#include <stddef.h>
int c_factorial(size_t n) {
	int s = 1;
	for (size_t i=1; i<=n; i++) {
		s *= i;
	}
	return s;
}
