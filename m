Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792613002;
	b=dgvuvV0HQeHKu4PD6jWweb1azHFEf7xD1SlsqpBKbRSCv29N1MhxoHEYr2wK2+o54/IY
	 PeTq4z1MlYCQ4OUSXqkB/cAQzCsB32Ny0Eg2+id022sxt13+O1lv+jwF6QjP0YJf7FH11
	 cMDRNMsst7JxKArPfBACK69At3Kxhtb+JTQZMofSew3spYuldcmz/oSg3kYd7qmRfYQtH
	 foM5WDwyq5YW87Q5NTkV74xttGwkkUK9UlfUPkyCXeI6NjRLAWR8w3vXbQ6ZVXDisBKZz
	 nFDBeRK8zEmQE9YTNkSkRmh5oy4z2mCrS72yxk4dILhr2SOFIXWAW4zrwGYlowf2gnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613002;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hb8zDgNoBy85QIX4XWIyaVhUIi/abmULS/0xM6K4EUk=;
	b=uejM8FSYHNNGOVFTbxCeMzFzVjXRwsCAAllQ5Oo4DIuswbr1wkUqVOMkSR8wAdOsLKsA
	 Y6cA2FRUm+TlfuDdejgk15Kh3ktQ/DyEf/4bU/z0ev2xS5ngX8un3YJLc30QFDPOqieCY
	 iIhv81nD+HJFK1f6uVze9zCcYjLLly3HKspHf/a1qTWheECIzhyVcxcMNJDGMkD7G0sCV
	 5yxc8CGK+yqVxVhYO+n4/lQuiCPuvi/7hAbaokoEfpg21+HDu3mZ7YiTw0SrLbvhlq9aP
	 bZcXO6cPkFjYFrj2UBnL2CMAb23NVdFy8C+IAEiTfrT1MGyBpBh/AOQy4Nk4jbUGPow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dbV4QOZf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0156C606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dbV4QOZf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971C91F000C1;
	Wed, 21 Oct 2026 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792613001;
	bh=Hb8zDgNoBy85QIX4XWIyaVhUIi/abmULS/0xM6K4EUk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dbV4QOZfHzlz+t2hfGqLIONkITR+9b81iTH9G6NN3i73m6IgCzJzILXHFo24hL5OH
	 nI+T/H6s7AvvW4PIS3CDagUTb1ihz+hoEHu+UGu/DUhx50UUwbcEMV6jbHG+s4GXOh
	 QtplX4YY+diYAJ8aPNNRuLgXWb57uLKLcGJI0Yb27Fy2W2RwG40DCnK4+97nwbQrCo
	 jXRcFUW5SvVwuTiWlARp2CpG0JpOECiD2O06jPYIN351Qjwtu1WdVrxrPpBl554o99
	 lwsuSZwpd0wvbAimhzQleEDOPld9sBUh4+zHdrbGfp+/vnx9sOJzUGZaFths+dJEEp
	 6h+9WDMmwL6MA==
Message-ID: <sashiko-outbox-180619@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/2] net/rds: do not fail init when CONFIG_SYSCTL=n
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261021195837.142802-2-achender@kernel.org>
References: <20261021195837.142802-1-achender@kernel.org>
 <20261021195837.142802-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 20:03:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> With CONFIG_SYSCTL=3Dn, register_net_sysctl() and register_net_sysctl_sz()
> are inline stubs that return NULL.  rds_sysctl_init(),
> rds_ib_sysctl_init() and rds_tcp_init_net() all treat that NULL as
> -ENOMEM, so RDS refuses to initialize at all even though every tunable
> has a sane compiled-in default.
>=20
> When RDS is built in, that is worse than a missing feature: the failed
> rds_init() destroys rds_wq, but the rds_rdma initcall still runs, and
> when rds_ib_sysctl_init() fails the same way, the error path in
> rds_ib_init() flushes the already freed workqueue:
>=20
>   BUG: KASAN: slab-use-after-free in touch_wq_lockdep_map
>   ...
>    __flush_workqueue
>    rds_ib_init
> [ ... ]
> Fixes: e6babe4cc4ce ("RDS/IB: Stats and sysctls")
> Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on =
rds-tcp socket")
> Suggested-by: Joel Granados <joel.granados@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021195837.1428=
02-1-achender@kernel.org?part=3D1

