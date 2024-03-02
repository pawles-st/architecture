#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>

int x = 0;

void signal_handler(int sig) {
	if (sig == SIGUSR1) {
		printf("%d\n", ++x);
	}
}

int main() {
	signal(SIGUSR1, signal_handler);
	pid_t pid;
	pid = fork();
	if (pid < 0) {
		perror("fork error");
		return -1;
	} else if (pid == 0) {
		while (1) {}
	} else {
		for (; x < 100; ++x) {
			kill(pid, SIGUSR1);
		}
		sleep(1);
		return 0;
	}
}
