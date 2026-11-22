Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795355823;
	b=Yw4WQVs3Td+dU2D4eDBu0O+QD7YeU5vdmyN6bBFI1j+uVei+eMq7lw13SpdpeAuoTalQ
	 Hmx+IGZMGLZjnoEjspjzCP4nu9zTDW/FHAvCKcfbHT4Fyz3DvX8MSXFXk/70JB4EGXp03
	 e8b0YTgPsepoUawIDI8mNmWs5CGjy5WBU4tGr/CJw4hmRdHrQ8NAjCRh7EN4aXdG75r7A
	 OLPXTZcYDocQIQ2MqlFZXlrsZ11YbkaP3LswMCIqSoJW1hHKUVli0d44LElujEX/7cvLP
	 kjwO76yZk9rAVjXZfda3YRl5hTAJhC7JvEasfvzF1Kso/Cdt5ghwrv/V93EfXJuvd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795355823;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R2HZ951OgGb5yoMEbHDJxn0EnOOAjypklwSgTmZINZc=;
	b=VREf7YpBTRQH0umCBnXORAvZB9MD+gXaE72rNq3RWMi8R/ikEzUoU0azRWx+tFZUI3wt
	 eZCXEiNggD6udpWm2vBpcpUdt/2GnF3qLP08A/WzXBacWbJO/G6FETO2Dq+sCRpM2z3Jz
	 CkDnEa8A8F+p4+n0VVc30aCD+gNYjP9ncPT/SK/XbgJgtPbl0hu2lNpSud6kJxMoIAV2L
	 VM0+OIwlyCQSuuolmYPzGq4p1uSIDYk+gcudelnhZC0hFkvre9yTYIibJFiA7aC/lD6tH
	 7HYIhw0pcYNrVZGk/hPV988Ih0BsXk2ADjfM49NLuuFQ5WvDoDutXWutt6o8iYKzfjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfmesnmX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01746606A32A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfmesnmX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8E1F000D2;
	Sun, 22 Nov 2026 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795355822;
	bh=R2HZ951OgGb5yoMEbHDJxn0EnOOAjypklwSgTmZINZc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lfmesnmXk18GbuIi/q4Gc3TaiaE/2mb96AAJ91HYuMY5dJYcmqd8UUrnsAGa1bVwK
	 iMKg3LQFYeAIl8KtXnxZgvlC1GqBA78f8CNxyHLpb+922Y8RCu13Uw/GQ+QEOvgoXd
	 n224tw3GFSz2mnNZ5PuemmTRrrlceii9irXz6GyU/jmHhpL9ugbYNDVn1G5FM4+w82
	 WgFoKZBDcKgRpF1/aDW5YEUDhIpq48wtPtoduwx/hiiv4jg09+g1PGT1MSunwLEqNM
	 36PdDwJMbSIAQGCv9uEe9t5HlYyvbKKA7O5/IfgeBffO6ycC0JWkLIfv1LR6lDPqUM
	 qBCJ7Lm98i7SQ==
Message-ID: <sashiko-outbox-227998@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Unmap BAR2 when c4iw_rdev_open() fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261122135413.93813-1-serhatkumral1@gmail.com>
References: <20261122135413.93813-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 13:57:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> c4iw_alloc() maps BAR2 on T5/T6 devices or its on-chip queue region
> on T4 devices. If c4iw_rdev_open() fails, c4iw_alloc() releases the
> IB device but leaves the mapping in place.
>=20
> Unmap the mapped region before releasing the IB device.
>=20
> Fixes: c6d7b26791a2 ("RDMA/cxgb4: Support on-chip SQs")
> Fixes: fa658a98a2d0 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and=
 T5 devices")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122135413.9381=
3-1-serhatkumral1@gmail.com?part=3D1
