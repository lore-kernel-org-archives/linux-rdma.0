Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F914E3222
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730190; cv=none; b=ZekmKZ6tpjH4SsYx6ZKg9S7h85WEqWWltwbRGV8qlrjzH5sebfBVXjd0U6GH0z/Y0niPd7KeM9UvHFSNWPgBO/X19LCBV6cHeXDbwOm9MpxQ78iLC1MgBKDuNf6Nava2jDb9f+bAf07z35TfE27Eg2PIv+Pg3XAV6xX1r445qU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730190; c=relaxed/simple;
	bh=o4kToKEbJC9C5em8n2nljNKGMrOzsxzJKl9F2bm8Oak=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D9K2IMc+LMpnNnVxk4y+C5QtSEaxYl2qRXVm2s6/jgqGBqgeCT1HlAsGc/6kpGF3akMLp3oRjI36D2L3DY7jUn+Qc9v9SII6QXPSGrBZc2414lkjlUJ/bwv/0vBb6z5MML70ljjNi65WEUg/ZY4sdkNTB8/5Ipe3Rpp3KfHanTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4fdV/B2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4fdV/B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC1F1F00898;
	Fri, 18 Sep 2026 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730188;
	bh=o4kToKEbJC9C5em8n2nljNKGMrOzsxzJKl9F2bm8Oak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U4fdV/B2/UKSTzLQCfZpVRvb//AbUKPOxSsI764Dzar8aDUbxMtS+QLjVUr09kV1Z
	 CRyfzo8mkkGeEcbaK3SvJQFUAxyhhaAGblSQ6RK2sVp4ZIso9tzsNkgkY46OYK9t1r
	 74wLl9EMnHRvK8Zp6uKCfye5X3wHBlh+SAQBXTch87rcqHmjr9X61GeTzsAPGFLlCB
	 YalCUQ7TxFBWnMXvAxeT/2aRNdMAFpaTRlV2wDWHXkTYT3/HiGlnrfr4frqFo162hu
	 lVsWOe04I9JYsX6kmV3M5S40Wxa94j9Vho1HIldOSNKiy38jhsuJRHpfcshXXe1HN/
	 YkR0lSk4/6MvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 01/10] RDMA/mlx5: Notify data direct users via
 a notifier chain on unbind
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-2-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:27 +0000
Message-Id: <20260918111628.4AC1F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Currently during unbind, data direct code calls
> mlx5_ib_data_direct_unbind() directly. To make the unbind notification
> generic and support multiple users, deliver an MLX5_DATA_DIRECT_UNBIND
> event through a blocking_notifier chain kept per registration.
>=20
> Users register a notifier_block via mlx5_data_direct_ib_reg(); mlx5_ib
> embeds one in struct mlx5_ib_dev and, from its notifier callback, runs
> the existing mlx5_ib_data_direct_unbind() teardown.
>=20
> This patch doesn't introduce any functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D1

