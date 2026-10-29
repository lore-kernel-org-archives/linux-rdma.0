Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299383;
	b=Oq0Yx13DWTDLPRB89l6MjtbDfbIE8EoDonfmAl8FT8Ndi7MNHPcNhEztoDudb/MFV/yT
	 lhwBKQ3wByNSh4JN6CaGWAnwDg5r7TW4sHwr7Fg7dLOE1dXGHnJ/K0y3b+QAncQnjJYOX
	 G1iW/t5KQ+r5PyHzyyLaabjWfkExz9S6NmqcSvKZf9QaNG/g5T39Sgzzrkp9h/nK31ojT
	 BqLrNBCN/K0eqOKDm1Tc64nGNiL8kc4DG0O9cUyiN+Kefk7RkpEpvZMuS4woxqXUUfxL2
	 xURCq7ZlCkoyWAZsquHuIDtegloG9tZtloLIvj3aOQUGtQ3wprI2b2U2m2TrIGx4oYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299383;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nf8Gw/gfWxqBs8gZEJnkugh5ea5MYZZ+hkarqQVTC8M=;
	b=vfMvMfzUkJ7PqoNoO3jDS4u13alRz/LNEs94O07ngcr292orCs9bv+MEVxxINpXMHvSZ
	 vhU/UQR59zrgankSsOYDJcMypGHbvLyLLeWGGgoaz1bmWBqN8Q19kiFexHChBYvNKEqkL
	 dfkXTkakTXme1mday0KbgSjqf/WFUi4ZsMe1m0wesDCUe0R8vH4PA/+XKcWUvz0YwZfBj
	 D4DmIG6U2Vt4b2OkwhxuIyqI546sfF0e3rY12Zptl3xgcz2Ah3YLDDx+Q1QdKStz99wMD
	 wKD1yh7m8DK9FDcVnnNTlrUSxGLlLV3HeFHHTCbgyu5EQci9O7r/vR9x4qTMuWnKHpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cufrmSp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C302F606A338;
	Thu, 29 Oct 2026 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cufrmSp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0B81F01825;
	Thu, 29 Oct 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299382;
	bh=Nf8Gw/gfWxqBs8gZEJnkugh5ea5MYZZ+hkarqQVTC8M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cufrmSp8v1UXpIF8n202uq2BsyYCbProsUE/N0c0ISuGV887EJWH8S+aEj7m+Gz1y
	 5ssDcHmeAv/Q5kSVAMViPkmvBw1SGHo1MdVgE3ZiTClfnie8Hwxy7nkTdFaiqdLPln
	 pw6rsHIT6XFS2ja44plFCQmuY/OMUfkAq58FJVuKBFTO3u9wRKrXjhG5+0QHTGtdt3
	 CL4VWfg4+huNf9adkEvFcdg5gZsbGr27bF4s47G1Hhm7ulHmlOt71XUqnZJNzR8SRd
	 7FBwuVzPB0QHYstd/BIuccou8fdGaHLQRNyj74oBxdQcefXK9fuM5bO+LXw01UOBKs
	 CRz1jG8oRFNfA==
Message-ID: <sashiko-outbox-189824@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v8 3/4] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261029-b4-disp-33001ace-v8-3-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
 <20261029-b4-disp-33001ace-v8-3-f9bb96e17827@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 18:43:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> conn->sndbuf_space can run past the send buffer. After an SMC-R link
> failover, a late completion from the old link can move tx_curs_fin back,
> and the next completion credits the same bytes again; across the ring
> end, smc_curs_diff() credits the step back itself as more than a whole
> ring, so even with a conforming peer sndbuf_space can reach three times
> the buffer. The failover catch-up and SMC-D DMB merge (only the loopback
> device today) also credit it from the peer's consumer cursor without a
> bound. smc_tx_sendmsg() takes it as the write space, and the second
> chunk of its copy writes past the send buffer.
>=20
> Clamp writespace, which sizes the copy, to sndbuf_desc->len, negative
> values included, so the copy stays in the send buffer.
>=20
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer D=
MB are merged")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-b4-disp-33=
001ace-v8-0-f9bb96e17827@proton.me?part=3D3

