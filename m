Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490211;
	b=tuqZJV/D9xJQmHk4dLtDHSYYTfUy4/+YfcuD2b3i4/OIFC5WvnXJqFqfEgc1UZ5l4YPK
	 HTa5cQuZ3dfO6uTeq258vE4/f+fX3b9UdnLGHR/2UagYLjgbXYe3wMa5XxCFmuaMJV/yR
	 nbfiINkTqDmgr0yifnEvGX+KyVZB1+Q8eJ+0P/qBFNFAFIakWLHaT/75vVoa0UiXlWhOc
	 3/VZLy9+bwCJXEQUelbi42UaVCMuSBOXZaXfQhNELj50mLYh8Eu8L/vl2dQLIGd0fmF/H
	 UFZFfmIUm+KYoPkGylrt6VBSMqKg0i85ABwf1lZ4VHuhvsTaYO2lU+HIBBsxSn1jmpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490211;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y01dVZN/6Fkpx4DDFzgh+YVKco8L/S+xFOKKb499nbE=;
	b=B+8Z96J8YixxdQz6X+0cbWuBfxfeYpJz+Wv7jJgzdNJus/AhCDXcyPx/vi8nNTuhaQSk
	 Dp+3sVRLOdzv7a8Eb7ei1Bw3wP9vmPHF+y+gtj+MzgHcgMvYyKrO6vpqkerz/UWzrJ/WW
	 loytgXEMny6LioC7UmRT9n52GpcBfDwIJuscDW6so+dw+bGefMgOu+kWSSEOXiUe6SlW8
	 cfLRnlAWwEtIZcgUlj3UHmSBw1e6tNjxPTNyXfaGkwOwrKmX2ZsOyhuEzGAiI4SQM3sST
	 /GlayrxJ4gZFC53y5Yg262VA711B/d+5oN38J5lkFemAr6XeW3U+PWNP6T23FP6yyOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=itT+TqQ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F4B606A337;
	Thu, 12 Nov 2026 13:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=itT+TqQ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD0E1F00A06;
	Thu, 12 Nov 2026 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490211;
	bh=y01dVZN/6Fkpx4DDFzgh+YVKco8L/S+xFOKKb499nbE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=itT+TqQ8qqmrNQnD1BgghH9zfNYTsbIs+BxxquxyeMi1AaMXoIXRdN5jWNyw/fJhb
	 vw0tGDWiaNLbfhdX3skBwB4Id9FH/b8DJ6TadMcXK87TlWoeQb265I5agGjfQXyRk8
	 VYtop/Oydhnbrfu/JODCTWM5fe4RSunGXtl+jza8vPxjCFDn5KZVkuNXezlYZwI9Tx
	 12licXn9pwILMIxyx0h+y/+hrHqeo7BRHt0OJKMC8Kz21B2FMGkBQNSRiC/QsLAPtz
	 XYw4inTCNsHcVRGy1dTAI5M4fS8DPDATZAEG/3muabhXCNI0N1p4wpW2MowYIDDSqr
	 T9hdoKgHYmhuQ==
Message-ID: <sashiko-outbox-211187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9 4/6] net/smc: keep the source of an RDMA write
 inside the send buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-4-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
 <20261112-b4-disp-0287c16e-v9-4-e5e8fa688177@proton.me>
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
> smcr_tx_rdma_writes() sizes the first source SGE of the second
> destination chunk from the send cursor as it was before the first
> chunk, so that SGE runs past the send buffer when the buffer ends
> inside the second chunk. A physically contiguous send buffer goes out
> under the local DMA lkey, which does not bound the SGE; on rxe the peer
> is sent the memory that follows the buffer. A conforming peer gets there
> when a completion handled inside smc_switch_cursor() leaves tx_curs_sent
> behind local_tx_ctrl.prod. Otherwise it takes a peer_rmbe_space forged
> larger than the RMBE and a send buffer larger than the RMBE.
>=20
> Size the SGE from the running offset, as smcd_tx_rdma_writes() does. A
> conforming write sends the same bytes.
>=20
> Fixes: e6727f39004b ("smc: send data (through RDMA)")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-d=
isp-f345196c-v7-0-ef3dddfbfa68%40proton.me?part=3D4
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-02=
87c16e-v9-0-e5e8fa688177@proton.me?part=3D4

