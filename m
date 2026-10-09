Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F5F37DE84;
	Fri,  9 Oct 2026 06:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526369; cv=none; b=bwLfQyQ2a41r/RSgPihW3aHat5sKR7pkqwsMAnlororBhHkE40xOFGPrZlFz04zgQg6LlBMN2p6cfoUef3sxrOebruTNI8B+dOkrjfNitUGtke/pIQaj2eAEIM3ifOOxkKkT9221vr4nipY+bM9hhkMtZgk7XT4l/p0aqOdn5Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526369; c=relaxed/simple;
	bh=19huoqS9nxwTgjB7iW20+dLSzhSxw/9+RFJKMRLLYUg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=s8v3LwTsLihcXYxWPU1BpQHh3y+FKLGQ/ax5Ce84krJLl5GFr9Il+nZnpvFdSN6bIjMYE0XqQKzbJ43FCHQ0YJyPVMWObZ/tETsdVOQi58W99cuSziLw9K8LG/Bu+SOvRTe/O3b0FlijlMoK/DY3jcUQyRJFVZ/C+jB5WCDCk8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DelxGXZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DelxGXZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E77E1F000FF;
	Fri,  9 Oct 2026 06:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526367;
	bh=19huoqS9nxwTgjB7iW20+dLSzhSxw/9+RFJKMRLLYUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DelxGXZJ6cVNU8cVjTPZDO4Qb9rrDxHDhfMcur0iEsdZ97zypksexcd73mrir7/fb
	 lGzbv2cVqv4Mc/jDDwuHZYFEAiopF/OcJxA55XsTn1fQJCZnBPHuOg3n7eTFhKv3sf
	 b2FYClQJrUTdMzTUCZBcjDbvrK6+K8icyRDPqEQE7bHKFOx+PvMX9E7fFVmFEVADw1
	 33cZEYW42/J77GAeoGMwcp8OIrNPPoGFO9GVgEPWkSvlnVtLJQsabUgtXF6eRWVAjW
	 x0TTaARBmci0UD81PgaYFg/nHBDo/RU98BJtEBYFnXRdmfpv2jS+wSQQbx3YvirDxy
	 jyBJ+U6461O9g==
Message-ID: <sashiko-outbox-164919@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-3-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
 <20261008-b4-disp-f7cd3d96-v6-3-fba616c0920c@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 06:12:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> On the SMC-D DMB-merge (nocopy) path, smc_cdc_msg_recv_action()
> advances conn->sndbuf_space from the peer's wire-controlled consumer
> cursor via smc_curs_diff(), which can return more than sndbuf_desc->len;
> a forged cursor drives sndbuf_space past the send buffer, and over many
> CDC messages overflows the signed counter negative. smc_tx_sendmsg()
> reads it as the write space and does a wrap-around copy whose second
> chunk is not re-bounded to sndbuf_desc->len, spilling the local
> sender's outbound data past the send buffer at a peer-controlled
> length: a heap out-of-bounds write. The nearby len > sndbuf_desc->len
> test only feeds SMC_STAT_RMB_TX_SIZE_SMALL on the user length; it does
> not bound the copy.
>=20
> Bound the write space to sndbuf_desc->len at the consumer, treating a
> negative (sign-overflowed) value as out of range too, so the copy can
> never exceed the ring. This enforces the documented
> 0 <=3D sndbuf_space <=3D sndbuf_desc->len invariant where it is race-free
> against the CDC tasklet; conforming peers are unaffected.
>=20
> Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer D=
MB are merged")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-disp-f7=
cd3d96-v6-0-fba616c0920c@proton.me?part=3D3

