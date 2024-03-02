#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <signal.h>

// constants

#define WORD_LEN 100 // max word length
#define BUF_SIZE 32 // max buffer size

// handle wait for when & is used

void signal_handler(int sig) {
	wait(NULL);
}

// separate *buf into an array of strings (arguments) and returns their number (argc)

int parse(char *buf, char ***argv) {

	// create new array and token value

	char **list = malloc(BUF_SIZE * sizeof(char*));
	char *token = strtok(buf, " \t\n");
	int argc = 0;

	// separate until empty

	while (token != NULL) {
		list[argc] = token;
		++argc;
		token = strtok(NULL, " \t\n");
	}

	// delimit array with NULL

	list[argc] = NULL;

	*argv = list;
	return argc;
}

// execvp and built-ins handling

void execute(int argc, char **argv, bool bg, char *in, char *out, char *err) {

	// built-in functions

	if (strcmp(argv[0], "exit") == 0 && argc == 1) { // exit
		exit(0);
	} else if (strcmp(argv[0], "cd") == 0 && argc == 2) { // cd (only relative path)
		char buf[WORD_LEN];
		getcwd(buf, sizeof(buf));
		chdir(strcat(strcat(buf, "/"), argv[1]));
		return;
	}

	// create child

	pid_t pid = fork();
	int status;

	// signal handling for when & is used

	if (bg) {
		signal(SIGCHLD, signal_handler);
	} else {
		signal(SIGCHLD, SIG_DFL);
	}

	// child vs parent

	if (pid < 0) {
		perror("fork error");
	} else if (pid == 0) { // child. replace with execvp
		if (in != NULL) {
			freopen(in, "r", stdin);
		}
		if (out != NULL) {
			freopen(out, "w", stdout);
		}
		if (err != NULL) {
			freopen(err, "w", stderr);
		}
		if (bg) {
			signal(SIGINT, SIG_IGN);
		}
		execvp(argv[0], argv);
		exit(1);
	} else { // parent, wait (or not) for child to die and loop
		waitpid(-1, &status, WNOHANG);
		if(!bg) {
			signal(SIGINT, SIG_IGN);
			wait(NULL);
			signal(SIGCHLD, signal_handler);
			signal(SIGINT, SIG_DFL);
		} else {
			sleep(.5);
		}
	}
}

// read input

void read_command() {

	// set up buf and read line

	char *buf = NULL;
	size_t bufsize = 0;
	if (getline(&buf, &bufsize, stdin) == -1) {
		if (feof(stdin)) {
			printf("\n");
			exit(0);
		} else {
			perror("reading error");
		}
	}

	// if the current program has been piped to

	bool piped = false;

	// parse input (split into argv)

	char **argv;
	int argc = parse(buf, &argv);

	// if no input given, loop

	if (argc == 0) {
		return;
	}

	// check if & used

	bool bg = false;
	if (strcmp(argv[argc - 1], "&") == 0) {
		argv[argc - 1] = NULL;
		--argc;
		bg = true;
	}

	// check for fd changes

	char *in = NULL;
	char *out = NULL;
	char *err = NULL;
	while (*argv[argc - 1] == '<' || *argv[argc - 1] == '>' || (*argv[argc - 1] == '2' && *(argv[argc - 1] + 1) == '>')) {
		if (*argv[argc - 1] == '<') {
			in = argv[argc - 1] + 1;
		} else if (*argv[argc - 1] == '>') {
			out = argv[argc - 1] + 1;
		} else if (*argv[argc - 1] == '2' && *(argv[argc - 1] + 1) == '>') {
			err = argv[argc - 1] + 2;
		}
		--argc;
		argv[argc] = NULL;
	}

	// execute

	execute(argc, argv, bg, in, out, err);

	free(buf);
}

int main() {
	char cwd[WORD_LEN];
	while (1) {
		getcwd(cwd, sizeof(cwd));
		printf("(%s) >>> ", cwd);
		read_command();
	}
}
