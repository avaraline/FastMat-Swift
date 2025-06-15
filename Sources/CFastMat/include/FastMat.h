/*
    Copyright ©1992-1996, Juri Munkki
    All rights reserved.

    File: FastMat.h
    Created: Friday, October 16, 1992, 23:55
    Modified: Wednesday, August 14, 1996, 14:13
*/

#pragma once

#include <math.h>
#include <stdint.h>
#include <stdlib.h>

typedef int32_t Fixed;

#define PI 3.141592653589793238463

#define FHALFPI 102944
#define FONEPI 205887
#define FTWOPI 411775

#define MAXFIXED 0x7FFFffffL
#define MINFIXED 0x80000000L

static const Fixed FIX1 = 0x00010000;

static inline float ToFloat(Fixed a) { return (float)a / FIX1; }
static inline Fixed ToFixed(float a) {
    float temp = a * FIX1;
    return (Fixed)temp;
}
static inline float Deg2Rad(float deg) { return deg * PI / 180.0; }

typedef Fixed Vector[4];  // A vector consists of 4 fixed point numbers: x,y,z,w
typedef Vector Matrix[4]; // A matrix consists of 4 vectors.
typedef struct {
    Fixed w, x, y, z;
} Quaternion;

/* FIX3 results in the n/1000 as a fixed point number */
static inline Fixed FIX3(int n) { return (Fixed)(n * 8192L / 125L); }

/* FIX results in the integer number as a fixed point number */
static inline Fixed FIX(int n) { return (Fixed)(n * 65536L); }

static inline Fixed FRound(float n) { return (Fixed)lround(n); }
static inline Fixed ToFixedRound(float n) { return FRound(n * FIX1); }

static inline int64_t LMul(int64_t a, Fixed b) { return (int64_t)((a * b) / FIX1); };
static inline Fixed FMul(Fixed a, Fixed b) { return (Fixed)(((int64_t)a * (int64_t)b) / FIX1); }
static inline Fixed FDiv(Fixed a, Fixed b) { return (Fixed)(((int64_t)a * FIX1) / b); }
static inline Fixed FMulDiv(Fixed a, Fixed b, Fixed c) { return (Fixed)(((double)a) * b / c); }

// Full circle is 2 Pi (fixed point, of course)
static inline Fixed FRadSin(Fixed a) { return (Fixed)(65536L * sin(a / 65536.0)); }
static inline Fixed FRadCos(Fixed a) { return (Fixed)(65536L * cos(a / 65536.0)); }
static inline Fixed FRadTan(Fixed a) { return (Fixed)(65536L * tan(a / 65536.0)); }

// Full circle is 360.0 (fixed point)
static inline Fixed FDegSin(Fixed a) { return (Fixed)(65536.0 * sin(a / 3754936.206169363)); }
static inline Fixed FDegCos(Fixed a) { return (Fixed)(65536.0 * cos(a / 3754936.206169363)); }
static inline Fixed FDegTan(Fixed a) { return (Fixed)(65536.0 * tan(a / 3754936.206169363)); }

// Full circle is 1.0 (fixed point)
static inline Fixed FOneSin(Fixed a) { return (Fixed)(65536.0 * sin(a / 10430.3783505)); }
static inline Fixed FOneCos(Fixed a) { return (Fixed)(65536.0 * cos(a / 10430.3783505)); }
static inline Fixed FOneTan(Fixed a) { return (Fixed)(65536.0 * tan(a / 10430.3783505)); }

static inline Fixed FRadToDeg(Fixed angle) { return FMul(angle, 3754936); }
static inline Fixed FDegToRad(Fixed angle) { return FMul(angle, 1144); }
static inline Fixed FOneToDeg(Fixed angle) { return ((angle) * 360); }
static inline Fixed FDegToOne(Fixed angle) { return ((angle) / 360); }
static inline Fixed FOneToRad(Fixed angle) { return FMul(angle, 41175); }
static inline Fixed FRadToOne(Fixed angle) { return FMul(angle, 10430); }

void InitMatrix();

void QuaternionToMatrix(Quaternion *q, Matrix *m);
void MatrixToQuaternion(Matrix *m, Quaternion *q);

void VectorMatrixProduct(long n, Vector *vs, Vector *vd, Matrix *m);
void CombineTransforms(Matrix *vs, Matrix *vd, Matrix *m);

void TransformMinMax(Matrix *m, Fixed *min, Fixed *max, Vector *dest);
void TransformBoundingBox(Matrix *m, Fixed *min, Fixed *max, Vector *dest);

void OneMatrix(Matrix *OneMatrix);
void Transpose(Matrix *aMatrix);

void MRotateX(Fixed s, Fixed c, Matrix *theMatrix);
void MRotateY(Fixed s, Fixed c, Matrix *theMatrix);
void MRotateZ(Fixed s, Fixed c, Matrix *theMatrix);
void MTranslate(Fixed xt, Fixed yt, Fixed zt, Matrix *theMatrix);

Fixed FRadArcCos(Fixed n); // Instead of FRadArcSin and FRadArcCos use FRadArcTan2
Fixed FRadArcSin(Fixed n); // when you can! ArcSin and ArcCos are for small values only.
Fixed FRadArcTan2(Fixed x, Fixed y);
Fixed FOneArcTan2(Fixed x, Fixed y);

void FindSpaceAngle(Fixed *delta, Fixed *heading, Fixed *pitch);
void FindSpaceAngleAndNormalize(Fixed *delta, Fixed *heading, Fixed *pitch);

static inline int *MakeAccumulator() {
    int *acc = (int *)malloc(sizeof(int) * 2);
    acc[0] = 0;
    acc[1] = 0;
    return acc;
}
static inline int AccHigh(int *acc) { return acc[0]; }
static inline int AccLow(int *acc) { return acc[1]; }
static inline void FreeAccumulator(int *acc) { free(acc); }

Fixed FSqroot(int *ab);
Fixed FSqrt(Fixed n);

void FSquareAccumulate(Fixed n, int *acc);
void FSquareSubtract(Fixed n, int *acc);

Fixed VectorLength(long n, Fixed *v);
Fixed NormalizeVector(long n, Fixed *v); // Returns length

Fixed FRandom();
Fixed FDistanceEstimate(Fixed dx, Fixed dy, Fixed dz);
Fixed FDistanceOverEstimate(Fixed dx, Fixed dy, Fixed dz);
void InverseTransform(Matrix *trans, Matrix *inv);

Fixed DistanceEstimate(Fixed x1, Fixed y1, Fixed x2, Fixed y2);

void UpdateFRandSeed(uint32_t value);
