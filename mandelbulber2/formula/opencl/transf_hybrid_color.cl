/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Hybrid Color Trial
 *
 * for folds, the aux.color is updated each iteration
 * depending on which slots have formulas that use it
 * bailout may need to be adjusted with some formulas
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 TransfHybridColorIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL R2 = 0.0f;
	REAL auxColor = 0.0f;
	REAL distEst = 0.0f;
	REAL XYZbias = 0.0f;
	REAL planeBias = 0.0f;
	REAL divideByIter = 0.0f;
	REAL radius = 0.0f;
	REAL componentMaster = 0.0f;
	REAL lastColorValue = aux->colorHybrid;

	// used to turn off or mix with old hybrid color and orbit traps
	aux->oldHybridFactor *= fractal->foldColor.oldScale1;
	aux->minRFactor = fractal->foldColor.scaleC0; // orbit trap weight

	// radius
	if (fractal->transformCommon.functionEnabledCyFalse)
	{
		radius = length(z);
		radius = fractal->foldColor.scaleG0 * radius;
	}
	// radius squared components
	if (fractal->transformCommon.functionEnabledRFalse)
	{
		REAL temp0 = 0.0f;
		REAL temp1 = 0.0f;
		REAL4 c = aux->c;
		temp0 = dot(c, c) * fractal->foldColor.scaleA0; // initial R2
		temp1 = dot(z, z) * fractal->foldColor.scaleB0;
		R2 = temp0 + temp1;
	}
	// DE component
	if (fractal->transformCommon.functionEnabledDFalse)
	{
		if (fractal->transformCommon.functionEnabledBxFalse)
			distEst = aux->r_dz;
		else
			distEst = aux->DE;
		REAL temp5 = 0.0f;
		temp5 = distEst * fractal->foldColor.scaleD0;
		distEst = temp5;
	}
	// aux->color fold component
	if (fractal->transformCommon.functionEnabledAxFalse)
	{
		auxColor = aux->color;
		REAL temp8 = 0.0f;
		temp8 = auxColor * fractal->foldColor.scaleF0;
		auxColor = temp8;
	}
	// XYZ bias
	if (fractal->transformCommon.functionEnabledCxFalse)
	{
		REAL4 temp10 = z;
		if (fractal->transformCommon.functionEnabledSFalse)
		{
			temp10.x *= temp10.x;
		}
		else
		{
			temp10.x = fabs(temp10.x);
		}
		if (fractal->transformCommon.functionEnabledSwFalse)
		{
			temp10.y *= temp10.y;
		}
		else
		{
			temp10.y = fabs(temp10.y);
		}

		if (fractal->transformCommon.functionEnabledXFalse)
		{
			temp10.z *= temp10.z;
		}
		else
		{
			temp10.z = fabs(temp10.z);
		}
		temp10 = temp10 * fractal->transformCommon.additionConstantA000;

		XYZbias = temp10.x + temp10.y + temp10.z;
	}
	// plane bias
	if (fractal->transformCommon.functionEnabledAzFalse)
	{
		REAL4 tempP = z;
		if (fractal->transformCommon.functionEnabledEFalse)
		{
			tempP.x = tempP.x * tempP.y;
			tempP.x *= tempP.x;
		}
		else
		{
			tempP.x = fabs(tempP.x * tempP.y);
		}
		if (fractal->transformCommon.functionEnabledFFalse)
		{
			tempP.y = tempP.y * tempP.z;
			tempP.y *= tempP.y;
		}
		else
		{
			tempP.y = fabs(tempP.y * tempP.z);
		}
		if (fractal->transformCommon.functionEnabledKFalse)
		{
			tempP.z = tempP.z * tempP.x;
			tempP.z *= tempP.z;
		}
		else
		{
			tempP.z = fabs(tempP.z * tempP.x);
		}
		tempP = tempP * fractal->transformCommon.scale3D000;
		planeBias = tempP.x + tempP.y + tempP.z;
	}

	// build and scale componentMaster
	componentMaster = (fractal->foldColor.colorMin + R2 + distEst + auxColor + XYZbias + planeBias
											+ divideByIter + radius)
										* fractal->foldColor.newScale0;

	// divide by i
	if (fractal->transformCommon.functionEnabledCzFalse)
	{
		divideByIter =
			componentMaster * (1.0f + native_divide(fractal->transformCommon.scale, (aux->i + 1.0f)));
	}
	componentMaster += divideByIter;

	// non-linear palette options
	if (fractal->foldColor.parabEnabledFalse)
	{ // parabolic
		componentMaster += (componentMaster * componentMaster * fractal->foldColor.parabScale0);
	}
	if (fractal->foldColor.cosEnabledFalse)
	{ // trig
		REAL trig =
			128 * -fractal->foldColor.trigAdd1
			* (native_cos(componentMaster * 2.0f * native_divide(M_PI_F, fractal->foldColor.period1))
					- 1.0f);
		componentMaster += trig;
	}
	if (fractal->transformCommon.functionEnabledAyFalse)
	{ // log
		REAL logCurve = log(componentMaster + 1.0f) * fractal->foldColor.scaleE0;
		componentMaster += logCurve;
	}

	// limit componentMaster
	if (componentMaster < fractal->foldColor.limitMin0)
		componentMaster = fractal->foldColor.limitMin0;
	if (componentMaster > fractal->foldColor.limitMax9999)
		componentMaster = fractal->foldColor.limitMax9999;

	// final component value + cumulative??
	aux->colorHybrid =
		(componentMaster * 256.0f) + (lastColorValue * fractal->transformCommon.scale0);
	return z;
}