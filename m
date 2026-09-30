Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437C83ED3CF
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769362; cv=none; b=p73dL6FFYC7Qi7g5OErcpsgE7hdXWcyVMSYoVPKeTlEyRX5a1QogUySz2b6pCi6oIdh/toJATb8ne1zoopn0zAq6BJ8E3iiYY3od0GvSwQGf6syPROVtlVBH5vm2TeaLAUeCL2Ar/d/tqWjc//Ct8OACOLKGwI+oH7Ssnq5wTcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769362; c=relaxed/simple;
	bh=J3TfXujOdyeet7rOys94hw3hMCWfv3r963FUYaM2IjE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tt9iRQIXtM76QUlbGCxPmuvLPN1D+WF+gpHk1IAmrA8Z9Ua+MaM0HBX8voAxRB8/OkIqOvE+GssM828AwFNrSB5wvCaVIl++/yQ1O4bhiYEug6Hj/fCb2CdWh3GFpdo7YVrYosbHijguQSd6R3on4CNPXZQibstmIHSlPnAkx7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4ysjufj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4ysjufj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C51F00898;
	Wed, 30 Sep 2026 11:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769361;
	bh=J3TfXujOdyeet7rOys94hw3hMCWfv3r963FUYaM2IjE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h4ysjufjVJ12JfuvPHJ6rhyxOWz911sqwWp3BbxLxEgOpPyn71QjUPZh/VS+QX0pL
	 r+yNlVg/3M5tHqa4XSydnFwWYkQIuRm1pD+ygRuDMnvxL9RS0qnqYCpHTQsMZoF7tj
	 uj3LX249fz+cy4OLc6UOE+ddffvda3704Tx9OzS6Ey0ntZBFbowx4DysfDKzVX40fO
	 2pgxO+nZV/FIARiRhZSjPgBYtXtdj5w2ZoLZHyElpQHt7dAsK+p98SOMWb2SwYaItO
	 vTTzrVmBZBkbFXXTVWQhi0l6U5iFKcEnFcKpD5Sd19teMsXCBFo7bXpIQMqw9zrPdL
	 fXZoOs04mqKaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 01/10] RDMA/mlx5: Notify data direct users
 via a notifier chain on unbind
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-2-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:00 +0000
Message-Id: <20260930115601.0A3C51F00898@smtp.kernel.org>
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
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D1

