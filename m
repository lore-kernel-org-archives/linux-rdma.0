Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA2448D862
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246505; cv=none; b=dAbb1OPOOIyslRFGQqUoK7zdMFevtE8CYuDUry5kfuj2EDu1hKiievxhVoV2N+cQMVWqezaEdpA/KsrqXReViGcM9nVu7fVn7+UzyK2xQTtuWDAeVYT4eyeOjsHE+HqHEcCydkx37QVhe7lIQU6nXTtJpKYYanfZNxFTggcqJuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246505; c=relaxed/simple;
	bh=pczUGDCMfs/Q5KPSEF/8gc1DaqV1ZyX8+eOUUnlUhwU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bV5d/+lJN2wPyS7/LTmCiWYrgVW/urF76Ig+o50+4hqFINKNtBkAkE939e+IamwsOLdem1IJilQUQezBl8VkHFunvjYIxAqvIrDQUwpEUYQkUDxFW/smJgXbgMrEX/z2ZetF0ZdNW5VNnyUvn+sc2rLpVGhCa2oiYc8lhkNsCu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jo8LWI1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jo8LWI1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E051F000FF;
	Thu, 24 Sep 2026 10:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246503;
	bh=pczUGDCMfs/Q5KPSEF/8gc1DaqV1ZyX8+eOUUnlUhwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jo8LWI1E3cqGtU2D01/iurAS5017OWZklwVK3oEkeNBulgrUS+3Zdjf3DOeXmk90o
	 JKSB3I1qRVcHrnAuSjMo5zM/ey/4kvYXu58tPfobRMvm1BDq8Vz8YYNM5ZuTPlbYOz
	 c3mw2bAm7Ro8j5dRLAynhmlILa3y20t45iIhXzi7T1SwOI7992XHmzKnA4afl4KKR+
	 t0tRF0nLHPLTgIt3panaCgQ7pgvW50Fbdi2k+bYx+UH9/QAIvJ97BMj5RUxTkU9wQh
	 Vm1HEJ64TNnkZ/WYQQtOIQbLpep8L+rnIr+SSozYEMIS0f6t2ZmLYVm/AFGLARjwtK
	 JXmdQ8RuhqoWA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 05/13] net/mlx5: LAG, drop per-port scratch
 array in drop-rule setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-6-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:42 +0000
Message-Id: <20260924104143.38E051F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_lag_drop_rule_setup() walks the per-port tracker state, but does so
> through a per-port scratch array, mlx5_lag_drop_rule_setup() collects
> the disabled ports to create a per-port drop rule.
>=20
> Walk the tracker state inline removing its MLX5_MAX_PORTS dependency.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D5

