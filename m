Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727552;
	b=CeJs5zJRUWYP5UlWsh/WpCe7O4Sy7qBdbAoGVdKgn2qoz669BZQw/Ya38YymyNAp7AsX
	 32djFEdKMl5w7XQ+cTCBOhnIHqQIXAFNQRtCPmAobNCc17RWykH2qbUvDUBLgoxLZeaOS
	 X1EI4v7ZjuQ1GjQdmZteVhJ9xR0MZHnKxwQ6PIspsIOqbrO1Wcw5X+IZg6EhcEDA8TVOY
	 P1IkM69lVu92aIkWg1LtYjjPn5W1LtKA5fVb1yKTwR714/NqeDgAkfp9YpU+wkvpLBo4a
	 X8toi76JGNdxGwwNutlxV75VjTdpIuuurjUDnUst+pedfWgX1y8JDb8i8lbTrg+iyXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727552;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i1yj1H8S/7I0jvO7LyVE8Fo+23exrPc3EasmUxJJaSo=;
	b=zvt8VBXtLWAWBBzLrRiuesG6k4LwfJgY5myIhkIAVEebIX6d7XD/E1nnqrlL2o/rPxPT
	 UITqJY1+ME196H+CAsJoIwj2IlnPBSExrfDPSOqTAEwFztsnvAUkoUN/tTCGQ/Kj4QCy1
	 en0pQEAIBSvpNrNi2nZblGgzGOd1xAOaBGAz923OPD2bj8Rssx+w9g3s7DNg/nxdOlakM
	 8T6QVrj3Hasb44tzdBW3M5rEpi6Dt9N/wSn5khpTEin2l8IsKJLhI/uUYEqEWvsC/6Z46
	 /lu7F/EhLOAexh9yHNKwNtF9AWRWyTXj18J+JDD2fzHUnQplVdMhgZ+/iFTgLEGcBHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y0f88u1/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C232606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 21:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0f88u1/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944191F00893;
	Thu, 26 Nov 2026 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727551;
	bh=i1yj1H8S/7I0jvO7LyVE8Fo+23exrPc3EasmUxJJaSo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y0f88u1/M2aKdhuMFu60LHMmnbZIIQtDibzTs8aixFRljwCFq+LOtmPnI985PPigx
	 KS5LuUAxQ9/dCX/OPEk8q8DjIMm/UyEUtwHlNA9L+GzWRnmJMHYMdALaB2tk2iDxRP
	 hLRnH+W8MwHryREvfl46w7cg9OZ8ERG0BIimSWmLi/LPNXzZazgXGjRJrtmtz4NZsg
	 9Q7B0Mb7QE8ETdCTycv9bTh3g6LrSbR+OuE51TcNBiqGklzPMrlm9SCpH34zA01Mlx
	 HE+4pzt7IPhFsdHDnEZtzhsvG5dmBJNJNR2nkBqyugVjs/dKgL/tGSaZhhmAVkbwrg
	 ZEYIgaJC2VCJQ==
Message-ID: <sashiko-outbox-236213@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix left shift overflow calculating
 sf_bar_length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126210849.766754-1-tariqt@nvidia.com>
References: <20261126210849.766754-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:12:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Amir Tzin <amirtz@nvidia.com>
>=20
> If the log_min_sf_size firmware capability is >=3D 20, the calculation of
> sf_bar_length overflows [1]. Use BIT_ULL which cast the calculation to
> unsigned long long.
>=20
> [1]
> [] ------------[ cut here ]------------
> [] UBSAN: shift-out-of-bounds in
>    drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c:346:27
> [] shift exponent 34 is too large for 32-bit type 'int'
> [] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
> [] Hardware name: Nvidia BlueField-4/BlueField-4, BIOS 26.07.3 20260708
> [] Workqueue: events work_for_cpu_fn
> [] Call trace:
> [ ... ]
>=20
> Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
> Signed-off-by: Amir Tzin <amirtz@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126210849.7667=
54-1-tariqt@nvidia.com?part=3D1
