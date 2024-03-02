#include <signal.h>
#include <stdio.h>

void signal_handler(int sig) {
	if (sig == SIGINT) {
		printf("SIGINT received\n");
	}
	if (sig == SIGKILL) {
		printf("SIGKILL received\n");
	}
}

int main() {
	signal(SIGINT, signal_handler);
	signal(SIGKILL, signal_handler);
	while (1) {}
}
