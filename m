Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490211;
	b=qS2GsnF1CJ4rpMH1ZI/NyiOIwdelw5agnPqLUH5J/v6+CLy6BQMxOjprSjbEYnQtcdt2
	 b2FBrsvYndKXy1D3wdclM9NzrcxCn8M4Q9doCaZDb/uDahLoyxWwkZ3BauGWYZ37JDIME
	 0kaDFQ1W5LT10DiWUEaSJOT54GVmFyPHLIBu9k1lCi/Ps3FL+ssN9tfsH3ZiklZJIYdUr
	 EPAxBTdkDlOrzSFNzV4M4QQ2/uurcKpJMgSuoMtalnBkR68lLkLR8YGg1fDYpm9fE8nw2
	 vfFk8V8vjtw67K4pC5qBzaPzowG7Aly7e24dSrqPfhaP6SdsRL5EvU+0/0Uro0d7dsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490211;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aoJ59THfGfyJiiCL/fmA7/VV8FrggtNfMkME8DHUUi4=;
	b=Wdfex9C/jVM4TRrK+fZiKJ4qvOZYTXdon8VjeJTgx8VuaIgacce+VpLi89PWGd565jYZ
	 IOQgt0jmh1EkcGxrSwtgf4Ha2uF083MB7Xmc9ylUisD58JA1F0zi2HBrzEfd2VPiZp3l2
	 inUAyKNB54cXKdVm61v3fHPckiYOFvQ4QRWJ0EN07cHCqkAtonpu/tl1fXaR9R1Nm5PNY
	 3+mu4/xzGENY/ch2VFDaIeT1wr3hjLEFci3PodLT4PQZi96/GH42KfHGeVPT1ZA3m9+E2
	 ueSvMpo1Ox+Jzyk/uK/ieh0DFNSs1DwDI2scJGh9Vf6oEx2/n9BvKiFt/ZwAhEl+4MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BofBr8Gc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF2606A32A;
	Thu, 12 Nov 2026 13:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BofBr8Gc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F21B1F00A06;
	Thu, 12 Nov 2026 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490210;
	bh=aoJ59THfGfyJiiCL/fmA7/VV8FrggtNfMkME8DHUUi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BofBr8Gc9YqvMTkjulgqz13S4zVg4U/TwZ2sc2nGFWoJbLslpWPiov6ATqk2paVfn
	 8ITwCxplfnCPiNpoh2SY+8CWfSA5poouPL+KFdXaC7R+38M08NAwVCNX0eiUpnEL3w
	 M00qvbAUXINDc8zgItuIhUZG24zPEWCRnmgjJvBp4QceVqFxsRevdIjvFVpSHkKTx9
	 GFfjpUVnmxfVtkY84HU+1GEMQ87y6NxkN5wGG473RCh6ZL9bkM+eDJKMG5FY+oBJqq
	 knzZFB8WOTdWYxg8grySZxmXh5rlnqRFrbFU5bgZMYdpioo3dbwfJUyDOPbPtcAznP
	 GbeydQvmuut3A==
Message-ID: <sashiko-outbox-211186@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9 3/6] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-3-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
 <20261112-b4-disp-0287c16e-v9-3-e5e8fa688177@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:30:10 +0000
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
> values included, so the copy stays in the send buffer. The over-credit
> itself is not undone: with sndbuf_space too large, send() can still
> overwrite data in the send buffer that the peer has not received.
>=20
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer D=
MB are merged")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-02=
87c16e-v9-0-e5e8fa688177@proton.me?part=3D3

