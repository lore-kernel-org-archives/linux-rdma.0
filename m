Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513737FF56
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991238; cv=none; b=uv8ZH8Pa+HdTkVIezqYFSCj0tWGuMF4EU2LDJk70aLCIbmIC8e/MYjV/d1DIDgi9nBpg2nfDnYWnEL7B356Q2JHyg8BsqPlq+m17FNREH8Ghn5FqrL87zPFJyDZeya0Xq5RnFeI8bfMYrArj03r6JpW6PE/LiDKr/TBNyHgiqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991238; c=relaxed/simple;
	bh=+WV0sixwjy2PW8F+bRr47PIzccq1rtGokFWJzYKDYpE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sa08VbPVhu7WLSkBjTuzQdhi/9dXXFHdpEYHPQ0Gruvs0FktclmB/xU/ASN7bigaqvCbznmIQhqymvEgAHYIWDpOAHaDDAMUKgxc+py53SXiRNwozqqeqGcbBqGMjwHfKcSWDCiuab9Rj7RtWwGKyoHLQ0GUSELraLRX/yBQeac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onir3B5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onir3B5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0D01F00898;
	Sat,  3 Oct 2026 01:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991237;
	bh=UmdxlizMfDabzjPmwE1pre1jOfCX4bGm+tfr+fa016U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=onir3B5wQ/8FjoXD2XGnfmuzf2Mp/ML5+VJaZkvVb9+/L4jQcCfDTkyLsNfryRT/k
	 4NA1q8I673hb6WWYNvWMVbOFlRqUI9HDyxDUch3VrDI/PbNHUUYjH4rHJFEPN31DEC
	 NP1IJ++EjibuIMeCCTfZyJo0brpQ6XXsxlMU7TBjkgXv7oy3UJLLhnzA/9lgL9Zlvl
	 2aUwtn7BrEJNOKZqn2QbmbsSr15Pu46N+0CoLNvWBpu3qi0gQGUaYtHu0Gkf0rPsDv
	 yrup7JtKNZ+iCydu8S2/Ce5aBjjt4JiMx+qzWzxLcO8bDtVqJxKzeidAG/7E87BY4q
	 1Fdk6Ph1Hje0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y] net/mlx5e: Fix netif state handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261002204438.26168-1-artem@trailofbits.com>
References: <20261002204438.26168-1-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:33:56 +0000
Message-Id: <20261003013356.EA0D01F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> [ Upstream commit 3d5918477f94e4c2f064567875c475468e264644 ]
>=20
> mlx5e_suspend cleans resources only if netif_device_present() returns
> true. However, mlx5e_resume changes the state of netif, via
> mlx5e_nic_enable, only if reg_state =3D=3D NETREG_REGISTERED.
> In the below case, the above leads to NULL-ptr Oops[1] and memory
> leaks:
>=20
> mlx5e_probe
>  _mlx5e_resume
>   mlx5e_attach_netdev
>    mlx5e_nic_enable  <-- netdev not reg, not calling netif_device_attach()
>   register_netdev <-- failed for some reason.
> [ ... ]
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://lore.kernel.org/r/20240509112951.590184-2-tariqt@nvidia.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002204438.2616=
8-1-artem@trailofbits.com?part=3D1

