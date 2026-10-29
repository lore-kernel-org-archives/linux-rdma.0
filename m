Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299384;
	b=3pglNvzX6KmE4+AyCNeKSotghjVmtGEc/U7KRp62CLXdShhanP8vwG+n7aY4RAjqQnlW
	 c8+e9rHkVGmSZvqm+Ck1lHxzNRdr3yxhRhBCJk9z2i/GttKF9rKF2C+A44G82GCB09RRK
	 OpmTUgsD+QE9gW1NpfUBCqiPlLJOMJ4aPRZoyrCpbStRXPsstmSyCBmpeQuUTRKZlBOe5
	 LSsCG8ZUEjFMcReDoHzTmn9UrqxLfkzyiFrCcFQjLA8KliGykF8gDDXXCWn/opRCo8SaE
	 5DtbnPFrmDOpVhPSoNAD/xT3mt2XCiCsi0lbe2h/kpo+BQcS/hMxSh8pvfhtWr/Xz3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299384;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9SZRpBJnx0NfLgwlPQOrXbrxGTXyIyuec6PCXc20J9c=;
	b=QhDNpM3HRVyXDULgT0o83ltJAXaOZos10M1btsRSxyTiSS5ofhYl9cfs1Gc4yYgQj6Cq
	 buIiStwjPEa1Ff8wHHbwLvMLkdK18gxDE61cx0KloO8J7NWRlorgA9ZqnXTSNO0gez5Wk
	 fgIq+Ir7jWlWMv+IY4emJB0jkp/J81gPZfAC6sLNfa4PA8QvO8nQkrF0fIOfZhf93y5wo
	 uJ3wBe07LJA8ksHW5tUgaElhdqcDeUex/4u2dht/5CtmoMmNM/C5yKFjvUhXd/AgZDdAN
	 t42kE5UUDHwFhP28SqVXjGkqSAj9duH9v1dbHyK9Y7f2pjjuV382fdHpJz5f5uucyEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dM6tp2St;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA308606A332;
	Thu, 29 Oct 2026 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dM6tp2St
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154EA1F031E6;
	Thu, 29 Oct 2026 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299383;
	bh=9SZRpBJnx0NfLgwlPQOrXbrxGTXyIyuec6PCXc20J9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dM6tp2StWrsxBXQEnX9zLE0DhGQioCijaOY+DldVA1jwxuR+KBsaPXDyJLlrO5Asd
	 ID0KAV0GFZFOtoA7gPW1vaoWOjjublPdSETIB/tdUyiN4gK4gzqXhQRGxawzaQlTn9
	 MJFXIwhlZdCGJN+pzKLYHw2OvljwwNsjWA3QNEo/Kw7bjKC+Ms9lxT86gXnorOWcmO
	 EJCmomBeCZhYzxGYWS4AtKeao+uoFpWnhQTsOeiYZEauBrMfNiX7LumYyg/Q3Nf5Hg
	 74c2LNUaEx+ttxwZ2QIY/PoDiFNQQ3snpTWBwrjlw+gHF37e9EeLjGqODk5VTikhiH
	 jgICeUZSd0cQA==
Message-ID: <sashiko-outbox-189825@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v8 4/4] net/smc: bound the link failover cursor
 advance to the send buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
 <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 18:43:02 +0000
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
> On SMC-R link failover, smc_switch_cursor() rewinds the send and
> producer cursors to their values at the last completed CDC send, then
> advances them by the distance the peer's consumer cursor is ahead. That
> cursor comes from the wire, so a forged one adds an arbitrary amount to
> sndbuf_space and to the cursors. smc_curs_add() wraps them only once, so
> the next RDMA write takes its source past the send buffer.
>=20
> A conforming peer keeps its cursor count inside its RMB and cannot
> consume past the data in the send buffer. Advance only for such a count,
> and no further than tx_curs_prep. The pre-failover tx_curs_sent cannot
> be the bound: an earlier failover may have rewound it below the peer's
> cursor. The destination side is not bounded here: smc_write_space()
> still sizes the window from the peer's cursor, so a forged one can take
> the next write past the peer's own RMB, where its HCA refuses it and
> the link goes down.
>=20
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-b4-disp-33=
001ace-v8-0-f9bb96e17827@proton.me?part=3D4

