Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514932;
	b=DRahWcVHuSpH1XH5DlBEVv61Nh4SjupPc/ENICT03LWPDovPWYPqhOIxR1VRBD808XC/
	 NouMdbu10qoPijy3qDNBRTGrqCLOW7FRq1A4OqDnDoKqYFrAJ7E6S3ojPI1FehEghLq5H
	 W2YfZek3BIexoRxqiCqPvPdxCx/OJHK2XssBYThreeMsgRrrdbJdwcmqwSDdN4qsYjn95
	 IzZxQzqUSpe9RUgIrIwT2Tpzl9FYzEo4AWNAeJCqWszRpl2I83c8wUP24gYUef09nyVkU
	 H+KCbgRhPd/ox05U9uZqleCOm8HwzgXQem+HjNcrzecvAzoeHbGv8OnGIqqmzeBU4Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514932;
	h=Received:Message-ID:From:Subject:Reply-To:To:Cc:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vi80vlxEw2kM2Cbp1sHg5Yc6c83kCLFWxyhTouS3h1w=;
	b=0mTdponJpxG9LPSYWeCodLXv3nfz6pzBF1dUrtBtqN3hLizhnQwUaGZqyPDHF7Q+rZ0Z
	 cp3QoEKp2cQ9Thsd9/CiNig7ekqKMUQJhRg+qImVOEYpwAL5nZGFeRteGpWyzHAgVFugU
	 x4MQn7XwdipOU7RDg4UO1DNBwNzrXmPNylbHbwaoaYk0FHF5PayinvixKQzJoHf8dx+ix
	 u/eUFMzygaGWqYSX+3f+E/6mVrZazOD5GNlp0da6c87KJMM0rGs0ZeU/Cua3bTBVRJrw1
	 t8EsyDvsMIBY983TNUZvTRazGCm4psfikuv15XvX+Gus6qR1EV1sd8iLMgXOw2SKKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7102606A324
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 16:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737961F01805;
	Tue, 20 Oct 2026 16:48:51 +0000 (UTC)
Message-ID: <sashiko-outbox-179377@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peter Morrow" <pdmorrow@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261020164239.3808903-1-pdmorrow@gmail.com>
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 16:48:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
> an IB port or a device that advertises IBoE. Before it, each mlx4
> interface was offered every device and decided in its own add callback.
> mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
> for raw packet QPs only.
>=20
> ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
> v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
> packet QPs, then cannot open them:
>=20
>   net_mlx4: cannot access device, is mlx4_ib loaded?
>=20
> Restore the old behaviour by creating both auxiliary devices for every
> device and letting mlx4_en and mlx4_ib decide in probe, as their add
> callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
> ports, and mlx4_en_probe() binds a device without Ethernet ports but
> creates no netdevs, as mlx4_en_add() did.
>=20
> Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
> eth and an ib auxiliary device, and DPDK attaches both VFs and passes
> traffic through them.
>=20
> Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary =
bus")
> Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail=
.com
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020164239.3808=
903-1-pdmorrow@gmail.com?part=3D1

