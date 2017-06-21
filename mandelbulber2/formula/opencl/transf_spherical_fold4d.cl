/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * spherical fold 4D
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
float4 TransfSphericalFold4dIteration(float4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// float r2 = dot(z, z);
	// float r2 = mad(z.x, z.x, z.y * z.y);
	// if (r2 < 1e-21f && r2 > -1e-21f) r2 = (r2 > 0) ? 1e-21f : -1e-21f;
	// r2 += z.z * z.z;
	float rr = dot(z, z);
	z += fractal->transformCommon.offset0000;
	if (rr < fractal->transformCommon.minR2p25)
	{
		z *= fractal->transformCommon.maxMinR2factor;
		aux->DE *= fractal->transformCommon.maxMinR2factor;
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (rr < fractal->transformCommon.maxR2d1)
	{
		z *= native_divide(fractal->transformCommon.maxR2d1, rr);
		aux->DE *= native_divide(fractal->transformCommon.maxR2d1, rr);
		aux->color += fractal->mandelbox.color.factorSp2;
	}
	z -= fractal->transformCommon.offset0000;
	return z;
}
#else
double4 TransfSphericalFold4dIteration(
	double4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// double r2 = dot(z, z);
	// double r2 = mad(z.x, z.x, z.y * z.y);
	// if (r2 < 1e-21 && r2 > -1e-21) r2 = (r2 > 0) ? 1e-21 : -1e-21;
	// r2 += z.z * z.z;
	double rr = dot(z, z);
	z += fractal->transformCommon.offset0000;
	if (rr < fractal->transformCommon.minR2p25)
	{
		z *= fractal->transformCommon.maxMinR2factor;
		aux->DE *= fractal->transformCommon.maxMinR2factor;
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (rr < fractal->transformCommon.maxR2d1)
	{
		z *= native_divide(fractal->transformCommon.maxR2d1, rr);
		aux->DE *= native_divide(fractal->transformCommon.maxR2d1, rr);
		aux->color += fractal->mandelbox.color.factorSp2;
	}
	z -= fractal->transformCommon.offset0000;
	return z;
}
#endif