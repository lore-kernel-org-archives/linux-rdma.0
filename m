Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A90C3F484D
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006443; cv=none; b=Zaz/HRr6fKcE6o6Rz7/w/HwYKQQDIDnXevmqatwqnCIrvVQ4cqjpJqwhQEka+7F7jsQ9z3yJg/hid7nZGProVuYmD5qFGf1n1EsBu37hKGG5NDmdAtFJbCrtV9cKD5kw40nPmNQUZYcNd5zkcrzyxt653uzYSe5D1wWHXdWuGZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006443; c=relaxed/simple;
	bh=nRJOGrjZACcIBLdalNHrr/LQzQ5uJ4aYE6CbZM1bIy8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YAo3V+1Llfa60m6SxEkDmgXHPEpfa/YUOkVOUlJ0l93CYGBL+JUaU2Sh9+hGjl5UmMTqt1m6lAwqfNwQSWb1STpjzCilQtLeWkHSE02+ImGLprZ5+pTd7yNa4kWFS4/bxN3g8Z5BzfANSZP0F+1RLLWkOrGpM4hIaqkiCPRt/pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoVhzTym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoVhzTym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA96F1F000C4;
	Wed, 14 Oct 2026 19:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792006441;
	bh=ADziVcuLJxNDaCG+SGo7QSfJzRphowmw1j4dcThJEDU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NoVhzTymGdCwMxbILzISrUTYrta7tzLGGwrz8odbzfhsRdXYyTC7pPaP5KcFlnnpw
	 5jpMQWb5dDK/ku5IlF274UHAdecjp3DFXVg63FNN9zGDIPeQphMMLjyAbxth+bJWLP
	 9lIh/FwMf+OkerlJ0h/jiuwYHDJ7Qe6wDBo+jXURR28q1p+tH5sgdK7vjpqjZgWMTl
	 cYDOmy8jkbjK1Syb4g5SDRmH4XuYBtcj2HI6td2Fjd9QXSeeF1NQuK3QqodMtJ2k/c
	 vUbS/B5iDilZnOz/nZ5RWjWC+g6eL5qj+fUaT8m8wAQ3c51vrohXmSgtNim/feoOjm
	 +ZBadusVb/Bag==
Message-ID: <sashiko-outbox-171793@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y 1/2] net/mlx5e: Don't store mlx5e_priv in
 mlx5e_dev devlink priv
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014191738.24034-2-artem@trailofbits.com>
References: <20261014191738.24034-1-artem@trailofbits.com>
 <20261014191738.24034-2-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 19:34:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Saeed Mahameed <saeedm@nvidia.com>
>=20
> [ Upstream commit 123eda2e5b1638e298e3a66bb1e64a8da92de5e1 ]
>=20
> mlx5e_priv is an unstable structure that can be memset(0) if profile
> attaching fails, mlx5e_priv in mlx5e_dev devlink private is used to
> reference the netdev and mdev associated with that struct. Instead,
> store netdev directly into mlx5e_dev and get mdev from the containing
> mlx5_adev aux device structure.
>=20
> This fixes a kernel oops in mlx5e_remove when switchdev mode fails due
> to change profile failure.
>=20
> $ devlink dev eswitch set pci/0000:00:03.0 mode switchdev
> Error: mlx5_core: Failed setting eswitch to offloads.
> [ ... ]
>   Fix netif state handling), which makes probe registration-failure
>   unwind release resources even before netif_device_attach(). Patch 2
>   of this series ("net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead
>   of priv") uses netdev-based destruction. ]
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014191738.2403=
4-1-artem@trailofbits.com?part=3D1

