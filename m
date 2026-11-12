Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490213;
	b=U8y9CqOyEpF5eO+G5WF92SW12uT2xL2kqNDNEFvyfPhlkVcgiVI52vf21qya8p6bt9cK
	 8spkRBFqctT4q+quDrX6cGKoWwkROsMvOL+MKU/b09pUcAmS8Wgm2vLfwpkmfu5iD9K0g
	 /lAyL0BBs3zvmZeUsKiFV9YVbgEggIJePx72MVqYQk63Swhyk2pMrvRlAupj2xzNwjrUr
	 lzhL/IUUrZBangzaT9Cmq7wGjjFKbicUWvz9ur7iiEuDXCBZ6Ipox13y249GJG5XEuv2+
	 vhU+leV77uyCdKWLoLBtBSFtkEgrGMYbP4nNWgLE/mORD/qDb/JDrLbbjYGIZKGrz8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490213;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kkwZpzO4QP645yofju7Wf7df0gGs7S0eH5kcorA7byo=;
	b=ebY7byW26jLywNRZ+XO5AWhgpe6LSB8d+SCdD+FHxG6pKg45c/BEQM1IZdlmIGRtOcHJ
	 eK8PwRxvlKtmltSEnucmlCBxHylWQXsF3K7q085CWCVAu+fc4Z1Q44e3+oBj/tLPv3ziY
	 iGzGsv3qCAxdhvNK2MUbhbqA3qn14LhO9ud43SBsFkLXrwYXfQOj3gZed/2cGwW4/2g7n
	 XdSUhL670BCU7RQU3PWF3YtY1x3A/ciZ9zX70983h1keL9fhMMKJCFPwyljaPpQMSEOFo
	 pubvkU+JeVJcJkMmbHmjtiagsFcdVXzxCrPK3lThIbEuFJKmpgSCalcjcCOOSt2PVpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ccAzNuZN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0F606A332;
	Thu, 12 Nov 2026 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ccAzNuZN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A9E1F00A05;
	Thu, 12 Nov 2026 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490212;
	bh=kkwZpzO4QP645yofju7Wf7df0gGs7S0eH5kcorA7byo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ccAzNuZNNIYO9bm3PJKhB7ILw1bJdNLsIyfeoYo6FxR4XX5kNmFWOEStaDgSErdJc
	 fJXG6jDcfcxCZZYVSQiQlZuGAoarO2I9GG28IZBdBm6/NaTYqP/zpKTzCgOP+s51ZZ
	 dZa+xBgdpzZ1cDcvNyrriIRwhnHZ4DFlLeG0hdoGU7yPWj71W4+KFvyXhhePsrY645
	 tvbPhgZUsm9Loctv6LDntU/hcCdTKyDGhs4QRsSNaYsLvM4ycgs/Vf+lzM+yz4IrFU
	 cXoqRrPWbO9awW990WSXlRCsRGQgFnLN2ewrTeVHi9weGmoVv9b4PDy4Nbg5PXt0SD
	 i9mp8KQV4QEdw==
Message-ID: <sashiko-outbox-211189@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9 6/6] net/smc: bound the link failover cursor
 advance to the send buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-6-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
 <20261112-b4-disp-0287c16e-v9-6-e5e8fa688177@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:30:12 +0000
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
> producer cursors to the last completed CDC send, then advances them by
> the distance the peer's consumer cursor is ahead. That cursor comes
> from the wire: a forged one adds an arbitrary amount to sndbuf_space
> and to the cursors, and the next RDMA write takes its source past the
> send buffer.
>=20
> Advance only for a count inside the peer's RMBE, and no further than
> tx_curs_prep; a conforming peer's cursor is inside both. For any other
> count the write that follows can end past the peer's RMBE and needs
> "net/smc: keep an RDMA write inside the peer's RMBE" to bound it. Set
> tx_curs_fin and local_tx_ctrl_fin from the advanced cursors instead of
> adding to them: smc_cdc_tx_handler() can rewrite both while the switch
> runs. The switch is still not serialized against the handler: a
> completion handled inside it is still credited more than once and can
> make the next write hand the peer bytes it has already read.
>=20
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Cc: stable@vger.kernel.org # see patch description, needs another patch
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-02=
87c16e-v9-0-e5e8fa688177@proton.me?part=3D6

