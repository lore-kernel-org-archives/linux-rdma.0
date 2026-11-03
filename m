Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705373;
	b=F+Vh18GHbg+Xb1ktV8bg/qlKgWY4peyEz9bRlqtvEBEDlJ7aIFGo7t5LfSBxnS0UsCSp
	 ntfRoZXAdY/rE0P2pmufdZwwZBDiIZzSMMvFP3ZqXlx8r+oo5qIgxUN65bgId6SYBxpAl
	 wRP/kWz3HmlKT9wnnj/5s7Kgxfpz18s+5JUUY+i8qG5KSsXmU4LrJPGLJJV1KjrmI6F08
	 XZu3jWAen6Z/cyxXVyE4cEcxRMuQaCQBv+vjKx0z9jN1rp3KjK23xpyH/C4fccGRcaeDA
	 WFjDkfJN7nzVp76bI1zVvwQMdcCwWBoIkddq/IxpbYZAKIzccSTmDWdvGtyMrNoYK2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705373;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=okobRNkzR1o1vxHIC/K3cQmdQ4GNATeekKJ4VN7PvCU=;
	b=WgpRBIzx1Jpqh/Q5nB4T7wjWiyjJMXhF93Vnmosn8+F1NkS+grBv8E61oRdp1TthZqaj
	 ieDJ3uuAr/ptBg4XeN7ZnHH718XlbwhqFqFrDMvq3vEDyPSPIZBE7pgSi6lQtKKlkPvwZ
	 QjYMMgH32EnhsbxwMopSD7UnX7u0/rx5AqJ2cTndW96rLoHVW3ZrYGhocuDS2gYoemCCj
	 T8dmrZUgM/H1O59jl/FNM+AU3madhKfZUTeeXQNrirddPlLBK2eRD1pgXD0+QDFzIpMVt
	 IW3s5cpLXQc5qk6eI9JKTrunaZ786WpM1jgEq2RX00hChDkjZCKz+gmHp9JdCUYbSzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4HYlyJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F101606BFBE
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4HYlyJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09101F000C1;
	Tue,  3 Nov 2026 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705372;
	bh=okobRNkzR1o1vxHIC/K3cQmdQ4GNATeekKJ4VN7PvCU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R4HYlyJBKDTOkLgocTSSJJGWWuBNzWltzKps56ExPsD4X4dxJFT9BRzuDF4VjYkw7
	 QWzye14NRIG7spBYlnuuvoF7wy/euZaI57DRCX0IkReUAUUn8+CioNrfywH/ZA7P9M
	 uRqJMQjzsUA2qfxCjGCh2Ffyxa5e+b/Bq1gd1Y90LrGkDVjvKadirRkOtVuncOYOTx
	 AfiPBH0Fm2Ea+seBQ0tX6Aaj0hUC0cCU+ZLBDA2RI/4ezHtqeXHPnfr3NK3b7hpmwX
	 NqwVLqPa5lizfIcoMgqAcDz8zr+DmEuYUCA79vqwCm5q/nkL5+nrlPraNrtCQtu61r
	 omJviL3x0JoBw==
Message-ID: <sashiko-outbox-195151@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 2/9] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-3-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:29:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D2

