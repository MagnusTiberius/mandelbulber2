/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Formula based on Mandelbox (ABox). Extended to 4 dimensions and with variable scale parameter.
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
void MandelboxVaryScale4dIteration(float4 *z4D, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	float paraAddP0 = 0.0f;
	if (fractal->Cpara.enabledParabFalse)
	{ // parabolic = paraOffset + iter *slope + (iter *iter *scale)
		paraAddP0 = fractal->Cpara.parabOffset0 + (aux->i * fractal->Cpara.parabSlope)
								+ (aux->i * aux->i * 0.001f * fractal->Cpara.parabScale);
		z4D->w += paraAddP0;
	}

	aux->actualScale = mad(
		(fabs(aux->actualScale) - 1.0f), fractal->mandelboxVary4D.scaleVary, fractal->mandelbox.scale);
	float4 oldZ = *z4D;
	z4D->x = fabs(z4D->x + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->x - fractal->mandelboxVary4D.fold) - z4D->x;
	z4D->y = fabs(z4D->y + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->y - fractal->mandelboxVary4D.fold) - z4D->y;
	z4D->z = fabs(z4D->z + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->z - fractal->mandelboxVary4D.fold) - z4D->z;
	z4D->w = fabs(z4D->w + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->w - fractal->mandelboxVary4D.fold) - z4D->w;

	if (z4D->x != oldZ.x) aux->color += fractal->mandelbox.color.factor4D.x;
	if (z4D->y != oldZ.y) aux->color += fractal->mandelbox.color.factor4D.y;
	if (z4D->z != oldZ.z) aux->color += fractal->mandelbox.color.factor4D.z;
	if (z4D->w != oldZ.w) aux->color += fractal->mandelbox.color.factor4D.w;

	float rr =
		native_powr(mad(z4D->z, z4D->z, mad(z4D->x, z4D->x, z4D->y * z4D->y)) + z4D->w * z4D->w,
			fractal->mandelboxVary4D.rPower);
	float m = aux->actualScale;
	if (rr < fractal->mandelboxVary4D.minR * fractal->mandelboxVary4D.minR)
	{
		m = native_divide(
			aux->actualScale, (fractal->mandelboxVary4D.minR * fractal->mandelboxVary4D.minR));
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (rr < 1.0f)
	{
		m = native_divide(aux->actualScale, rr);
		aux->color += fractal->mandelbox.color.factorSp2;
	}
	*z4D *= m;
	aux->DE = mad(aux->DE, fabs(m), 1.0f);
	// 6 plane rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		float4 tp;
		if (fractal->transformCommon.rotation44a.x != 0)
		{
			tp = *z4D;
			float alpha = fractal->transformCommon.rotation44a.x * M_PI_180;
			z4D->x = mad(tp.x, native_cos(alpha), tp.y * native_sin(alpha));
			z4D->y = tp.x * -native_sin(alpha) + tp.y * native_cos(alpha);
		}
		if (fractal->transformCommon.rotation44a.y != 0)
		{
			tp = *z4D;
			float beta = fractal->transformCommon.rotation44a.y * M_PI_180;
			z4D->y = mad(tp.y, native_cos(beta), tp.z * native_sin(beta));
			z4D->z = tp.y * -native_sin(beta) + tp.z * native_cos(beta);
		}
		if (fractal->transformCommon.rotation44a.z != 0)
		{
			tp = *z4D;
			float gamma = fractal->transformCommon.rotation44a.z * M_PI_180;
			z4D->x = mad(tp.x, native_cos(gamma), tp.z * native_sin(gamma));
			z4D->z = tp.x * -native_sin(gamma) + tp.z * native_cos(gamma);
		}
		if (fractal->transformCommon.rotation44b.x != 0)
		{
			tp = *z4D;
			float delta = fractal->transformCommon.rotation44b.x * M_PI_180;
			z4D->x = mad(tp.x, native_cos(delta), tp.w * native_sin(delta));
			z4D->w = tp.x * -native_sin(delta) + tp.w * native_cos(delta);
		}
		if (fractal->transformCommon.rotation44b.y != 0)
		{
			tp = *z4D;
			float epsilon = fractal->transformCommon.rotation44b.y * M_PI_180;
			z4D->y = mad(tp.y, native_cos(epsilon), tp.w * native_sin(epsilon));
			z4D->w = tp.y * -native_sin(epsilon) + tp.w * native_cos(epsilon);
		}
		if (fractal->transformCommon.rotation44b.z != 0)
		{
			tp = *z4D;
			float zeta = fractal->transformCommon.rotation44b.z * M_PI_180;
			z4D->z = mad(tp.z, native_cos(zeta), tp.w * native_sin(zeta));
			z4D->w = tp.z * -native_sin(zeta) + tp.w * native_cos(zeta);
		}
	}
}
#else
void MandelboxVaryScale4dIteration(
	double4 *z4D, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	double paraAddP0 = 0.0;
	if (fractal->Cpara.enabledParabFalse)
	{ // parabolic = paraOffset + iter *slope + (iter *iter *scale)
		paraAddP0 = fractal->Cpara.parabOffset0 + (aux->i * fractal->Cpara.parabSlope)
								+ (aux->i * aux->i * 0.001 * fractal->Cpara.parabScale);
		z4D->w += paraAddP0;
	}

	aux->actualScale = mad(
		(fabs(aux->actualScale) - 1.0), fractal->mandelboxVary4D.scaleVary, fractal->mandelbox.scale);
	double4 oldZ = *z4D;
	z4D->x = fabs(z4D->x + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->x - fractal->mandelboxVary4D.fold) - z4D->x;
	z4D->y = fabs(z4D->y + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->y - fractal->mandelboxVary4D.fold) - z4D->y;
	z4D->z = fabs(z4D->z + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->z - fractal->mandelboxVary4D.fold) - z4D->z;
	z4D->w = fabs(z4D->w + fractal->mandelboxVary4D.fold)
					 - fabs(z4D->w - fractal->mandelboxVary4D.fold) - z4D->w;

	if (z4D->x != oldZ.x) aux->color += fractal->mandelbox.color.factor4D.x;
	if (z4D->y != oldZ.y) aux->color += fractal->mandelbox.color.factor4D.y;
	if (z4D->z != oldZ.z) aux->color += fractal->mandelbox.color.factor4D.z;
	if (z4D->w != oldZ.w) aux->color += fractal->mandelbox.color.factor4D.w;

	double rr =
		native_powr(mad(z4D->z, z4D->z, mad(z4D->x, z4D->x, z4D->y * z4D->y)) + z4D->w * z4D->w,
			fractal->mandelboxVary4D.rPower);
	double m = aux->actualScale;
	if (rr < fractal->mandelboxVary4D.minR * fractal->mandelboxVary4D.minR)
	{
		m = native_divide(
			aux->actualScale, (fractal->mandelboxVary4D.minR * fractal->mandelboxVary4D.minR));
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (rr < 1.0)
	{
		m = native_divide(aux->actualScale, rr);
		aux->color += fractal->mandelbox.color.factorSp2;
	}
	*z4D *= m;
	aux->DE = aux->DE * fabs(m) + 1.0;
	// 6 plane rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		double4 tp;
		if (fractal->transformCommon.rotation44a.x != 0)
		{
			tp = *z4D;
			double alpha = fractal->transformCommon.rotation44a.x * M_PI_180;
			z4D->x = mad(tp.x, native_cos(alpha), tp.y * native_sin(alpha));
			z4D->y = tp.x * -native_sin(alpha) + tp.y * native_cos(alpha);
		}
		if (fractal->transformCommon.rotation44a.y != 0)
		{
			tp = *z4D;
			double beta = fractal->transformCommon.rotation44a.y * M_PI_180;
			z4D->y = mad(tp.y, native_cos(beta), tp.z * native_sin(beta));
			z4D->z = tp.y * -native_sin(beta) + tp.z * native_cos(beta);
		}
		if (fractal->transformCommon.rotation44a.z != 0)
		{
			tp = *z4D;
			double gamma = fractal->transformCommon.rotation44a.z * M_PI_180;
			z4D->x = mad(tp.x, native_cos(gamma), tp.z * native_sin(gamma));
			z4D->z = tp.x * -native_sin(gamma) + tp.z * native_cos(gamma);
		}
		if (fractal->transformCommon.rotation44b.x != 0)
		{
			tp = *z4D;
			double delta = fractal->transformCommon.rotation44b.x * M_PI_180;
			z4D->x = mad(tp.x, native_cos(delta), tp.w * native_sin(delta));
			z4D->w = tp.x * -native_sin(delta) + tp.w * native_cos(delta);
		}
		if (fractal->transformCommon.rotation44b.y != 0)
		{
			tp = *z4D;
			double epsilon = fractal->transformCommon.rotation44b.y * M_PI_180;
			z4D->y = mad(tp.y, native_cos(epsilon), tp.w * native_sin(epsilon));
			z4D->w = tp.y * -native_sin(epsilon) + tp.w * native_cos(epsilon);
		}
		if (fractal->transformCommon.rotation44b.z != 0)
		{
			tp = *z4D;
			double zeta = fractal->transformCommon.rotation44b.z * M_PI_180;
			z4D->z = mad(tp.z, native_cos(zeta), tp.w * native_sin(zeta));
			z4D->w = tp.z * -native_sin(zeta) + tp.w * native_cos(zeta);
		}
	}
}
#endif
