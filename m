Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490212;
	b=Uhze9letmzo6YVkMm0bF5WtKOs+wJC/ciFUtn90azQqPzsoco8ksJtzEz27AV5tIpg5v
	 EEEB1dzJXfMFevHmld2KIdnEPKmG1h2V0y5QDANAxYBH9nyk7ldvFpwxnIn0XLo1YaQb9
	 o96sLMXGAeVfTY5CYFFUPMFj7jfc/JgwcC3G+5G/XtaeHuh9jv+UCsQHqa4sF2HX3Jq2s
	 3G5MvUndAjz4rdxhAiLgZlqMEYzNGfolZoGH78noyEl/bz3p+RK20YmPVPDoQ8gG/XNZ3
	 1dedBi0a74Vv2LbUj737gwnWSOmS2rgQwaGb0XKyW02QsbCcNSiFYPK4GjdtYa/ykGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490212;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=X3zQ0Zu/0tdn7Uf+SY/tzJ/lempaA4pYVjpmuybxyfM=;
	b=WQ9kVKT1RrqS1a2R6grqasDk+/mcaldxbdmXY310yp7LE3GmL9nFOUwj/fug9mXaE0ZI
	 hD9wkg36SHEOAvGJo/qFxxYMPbYqd3qUs3pSCDo6J9+IIlal4m12NDD93BNgS+FV97amY
	 orQq3cSQIp5qACx/dS9Z5C18DIgshWDkVGtKNuYFJVhCq5HQKJlOJo2BI9hfYLl1jPWFk
	 Yjt+5oGIj0VVlmP8kwCvuU4FEkDVQp5Mdc4OLqakggJjm3jqzjPuLjMD4jbGgXEPXRUvd
	 w3XlkjQ2H+tl+yCaf1du352RLetbOYAldsSMBCWOd/FX1111pXFwVuvxCWWPIfTtt4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNZTduDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF04606A33B;
	Thu, 12 Nov 2026 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNZTduDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8B21F00A07;
	Thu, 12 Nov 2026 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490212;
	bh=X3zQ0Zu/0tdn7Uf+SY/tzJ/lempaA4pYVjpmuybxyfM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QNZTduDkIGeMUJZ3je3tAbD8mobu5YYgCekEgpl4o+oPt9F7lYO/Z0Z0iOwe2d/pB
	 9iOVdBp1vK+k1ywGi8gqFHzWhDCVwCjV4ydaKvxn78WlMBvIX9VGNNLfholmTq5v0w
	 wNNApxzQHkzHmZH2KgpZctY8/f2S2Jxpl09ckRaWGGgAITvZIFrN3rpaPWHtnDz/FV
	 gpNY4X3WUW6dF6sjso0lmKi2OOe3koLdfhtxbenXMKE/AD65K2w4io3FBCY22Hq5u+
	 4ap/JjidL2cIkCmwB1OAnP8Aqm2SLglNc6ED+dcimUCgxKb1D0P2jpTyVXhWYbfNBb
	 Tq/zUBA+CbnMg==
Message-ID: <sashiko-outbox-211188@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9 5/6] net/smc: keep an RDMA write inside the
 peer's RMBE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-5-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
 <20261112-b4-disp-0287c16e-v9-5-e5e8fa688177@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:30:11 +0000
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
> smc_tx_rdma_writes() takes the length of a write from peer_rmbe_space
> and decides from the cursor wraps whether the destination is one chunk
> or two. Both follow the peer's consumer cursor, which nothing bounds: a
> forged one takes a one-chunk write past the peer's RMBE, and so does a
> conforming peer that keeps reading across the end of its RMBE before
> the resend after an SMC-R link failover. With one RMBE per RMB, as
> Linux allocates them, the peer's HCA refuses the write and the link
> goes down.
>=20
> Write at most one RMBE per call and end the first chunk no later than
> the RMBE, whatever the wraps say. A conforming peer outside failover
> gets the chunks it got before. A write that was one chunk can now be
> two, which needs "net/smc: keep the source of an RDMA write inside the
> send buffer"; the first chunk needs prod.count inside the RMBE, which
> "net/smc: bound the link failover cursor advance to the send buffer"
> keeps at failover.
>=20
> Fixes: e6727f39004b ("smc: send data (through RDMA)")
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-d=
isp-f345196c-v7-0-ef3dddfbfa68%40proton.me?part=3D4
> Cc: stable@vger.kernel.org # see patch description, needs two other patch=
es
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-02=
87c16e-v9-0-e5e8fa688177@proton.me?part=3D5

