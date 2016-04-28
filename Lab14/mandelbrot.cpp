#include <xmmintrin.h>
#include "mandelbrot.h"

// cubic_mandelbrot() takes an array of SIZE (x,y) coordinates --- these are
// actually complex numbers x + yi, but we can view them as points on a plane.
// It then executes 200 iterations of f, using the <x,y> point, and checks
// the magnitude of the result; if the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the code below using SIMD intrinsics
int *cubic_mandelbrot_vector(float x[SIZE], float y[SIZE]) {
    static int ret[SIZE];
	float ebola[4];
    float x1, y1, x2, y2;
	__m128 fx1, fx2, fy1, fy2, xi, yi, xy, x22, y22, ay, yl, mao;

    for (int i = 0; i < SIZE; i ++) {
        // x1 = y1 = 0.0;
		fx1 = _mm_set1_ps(0.0);
		fy1 = _mm_set1_ps(0.0);

		xi = _mm_loadu_ps(&x[i]);
		yi = _mm_loadu_ps(&y[i]);

		xy = _mm_set1_ps(0.0);

        // Run M_ITER iterations
        for (int j = 0; j < M_ITER; j ++) {
            // Calculate x1^2 and y1^2
            // float x1_squared = x1 * x1;
			fx2 = _mm_mul_ps(fx1, fx1);
            // float y1_squared = y1 * y1;
			fy2 = _mm_mul_ps(fy1, fy1);

            // Calculate the real piece of (x1 + (y1*i))^3 + (x + (y*i))
            // x2 = x1 * (x1_squared - 3 * y1_squared) + x[i];
			x22 = _mm_add_ps(_mm_mul_ps(fx1, _mm_sub_ps(fx2, _mm_mul_ps(3, fy2))), xi);

            // Calculate the imaginary portion of (x1 + (y1*i))^3 + (x + (y*i))
            // y2 = y1 * (3 * x1_squared - y1_squared) + y[i];
			y22 = _mm_add_ps(_mm_mul_ps(fy1, _mm_sub_ps(_mm_mul_ps(3, fx2)), fy2), yi);

            // Use the resulting complex number as the input for the next
            // iteration
            fx1 = fx2;
            fy1 = fy2;
        }

        // calculate the magnitude of the result;
        // we could take the square root, but we instead just
        // compare squares
        // ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
		ay = _mm_mul_ps(x22, x22);
		yl = _mm_mul_ps(y22, y22);
		ay = _mm_add_ps(ay, yl);
		mao = _mm_set1_ps(M_MAG * M_MAG);
		ay = _mm_cmplt_ps(x2, mao);
		_mm_storeu_ps(ebola, x22);
		ret[i] = (int)ebola[0];
		ret[i + 1] = (int)ebola[1];
		ret[i + 2] = (int)ebola[2];
		ret[i + 3] = (int)ebola[3];

    }

    return ret;
}
