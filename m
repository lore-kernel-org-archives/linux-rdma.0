Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445026;
	b=PcsNwlXxxsLTplm5XKI49woI+jiUFi8fiIPqE3Q7qRRnmyPFpq56E2Ibvf+ZQJ8P2aMl
	 6ARFYlFZevJFzJ6Wgy5d3EKRsCq0vdlbYehA4y327s42l05IvqC7sD7aMMENqXF4Vocu9
	 /LCPtjj4XjatOwfeQxxCWuIvvh3tNaZ2nAfNqQ7D7mgGyiYQC4mj13KA3wqztIy1IOTyu
	 StoHOsevPhVRFldSQDPKF1Z0uyI6HqajatmU6aPOXxEkxdOT47aqRDD8IGICzLcg1lGGH
	 pnKwxHdLJNqTfQNjydUjcYB2purNqqgf/KtNroZjb25paeCg7h7mq0e2PqARlSUxENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445026;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nG/1NaFJs6pGRi054WppdOmUHtg7iny8nH2SyW1x7h0=;
	b=TBEVSE8YEMiWO7MCwnagIsfC8Ms4WhF/qTFCtbnUktiPmHcvreKtHjxWY0MiT5tGdb19
	 H19tP9rilFDrg+4lYE93JkoYd59WT5iUSV4j8YWTc02a063iAhadw73Yh/k0etKD8sQKT
	 mrmD6/ONbeWg8lXDJJIyYEppJ7Oa1KYZeAVJ+ovoEltHEvyGTtzUDDiHKGRTxLQkYVE0K
	 SZPDibH8rOPElNp8P+XTvZ0lp6PdpP2eNAQNyQg1rGq2NYhA/l8qQrhKTE786mEz7sgHs
	 vUhVWsja2dGpgoeX1Sa+PNA7ItYeB3rowrW5g13ARsKgzuQNZNphFIiuigGphT1r8SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMSAUh7k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66A1606A330
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMSAUh7k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8641F00A07;
	Thu, 12 Nov 2026 00:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445026;
	bh=nG/1NaFJs6pGRi054WppdOmUHtg7iny8nH2SyW1x7h0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VMSAUh7kJpPFOrH/7bxh4nuRLaSnb9sivmji+GSEAiv6LJSS5NTbLoLwF+cIO5y0x
	 D0F4Rpmxb5WBrSRaH7TYtf4TCthu2Y2mIVNMRW+p6uAVaLKL+HKWjim0xUFKJeq/Mk
	 cW6vZWPhLXVGWlEVwhQPs8wmMpvP/IpXaJMgP3vfbCr+mNPyZPljoUW7uBwnoD1nYo
	 zNFcAof6LKtfglAqECmF6nb7s/LbXguUOHf86wLiXHNz+Fvf6XU3i+fYo5w3lIg+aA
	 TfR/QIp85hlPtY8PABeQqhaS0RDg8NuLPpLRe0CJ8aSHdAaeoZaAsQpNwFIyVqf0Bt
	 yp9D6pYFeZ8mA==
Message-ID: <sashiko-outbox-210013@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 10/15] net/sched: flower: add psp_spi,
 psp_ver, and psp_dev matches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-11-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-11-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a flow dissector key filled from the PSP Rx state (SKB_EXT_PSP) the
> device attached to a decrypted packet, and corresponding flower matches.
> SPI the packet was decrypted with (psp_spi, with a mask), PSP version
> (psp_ver), and the ID of the PSP device which decrypted it (psp_dev).
>=20
> For example, to take the packets of one Rx association, (created with
> rx-spi-alloc), and remove their PSP state so that they can be forwarded,
>=20
>   tc filter add dev eth0 ingress protocol ipv6 flower
>       psp_spi 0x80000001 psp_ver 0 psp_dev 1
>       action psp decap
>=20
> Together these matches tie a rule to one association, in a form which
> hw can match on (offload comes in a follow-up series). The SPI is only
> unique on its PSP device, and an association has one PSP version. This
> matches the per-packet check that psp sockets have against its
> association, with one exception - the generation of the device key is
> not checked.
>=20
> this means that a rule matching packets that correspond to an rx
> association which is stale (two rotations have passed), can still match.
>=20
> It is therefore important that a rule which matches a SPI should be
> replaced before the device key has had two rotations. follow up work
> will bring enforcement of this based on key rotation events.
>=20
> Note that this only ever matches packets which were decrypted, even if
> the mask is 0. So "psp_spi 0/0" matches any decrypted PSP packet.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D10

