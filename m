Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234431;
	b=dnl+pjCySQnnPFJYsrPSuwtWujVW4suYIbte+TvEjYuCwiINZFPzTDpy7hWzW87e98sl
	 KbNM+hM2xFdQ/vr+nhN1fAiC9nw9sJPS1XP32TSAiPObI4GoanGvnCqSRTmpE99u/LZqB
	 qZpeP60KRIMwPUuPofO1W3oybRGkDiH7iG8ekgu84RrpBl62mwdbtyu44vN45SCvL3RZ4
	 9j2BoTxzlkII77qu8nDi+LnuaxpNsBAYXWvQnUGNzYkHCkJ8GhOF6Bj8QIk8uVT9n3vlj
	 FlQ0K1wJD40GGKEkZqdd+vGVpBCUnObOAhzPE4DytMq/DcLzk/o6E1chr7CHvzFse9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mXW4ZWEsFfZ6j/hjWhGBG5qi8fVFOp8p90IJ9q+u9Gw=;
	b=iPD7WIHvgcxUW9KVZt5gyWC4yctxuOmzhAOZOOgsqsmEY3+8KFRgN4vg7WOl09H1I2eP
	 FF804A0sdGse7jISL8EDGw1QGxVoSDlRi6sTYzJf0pv2ItzLKHh53446Ox0MCjoC3Xci6
	 5vm0S0oob2AIrZVlVoYiIXOGn4OEoMMxp9NIzLPTBQObtFpva/3Ecn80ulWH7Yaw07VnQ
	 p518bah4s7Rd2c8j2ZdPO2t3fgbCTAEjR+f4zKuGS5LO5oEmzMOjapze1kE0ZSeBclpoJ
	 LUWFZy/Lvx6APhREyWA847QKDB0h8D9FmIGMgCc5lfjxJftIc9VFgMYuTqRDUCpH6tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a1Vi1NcC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E9C606A323
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a1Vi1NcC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AEC1F008A2;
	Mon,  9 Nov 2026 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234431;
	bh=mXW4ZWEsFfZ6j/hjWhGBG5qi8fVFOp8p90IJ9q+u9Gw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a1Vi1NcCG1x/SF9gOd1RbSpbfvdf0w8DCht+NFwjsWYQfWdGPAoR/ll2fB+hDVj3z
	 RhvWdTlAkb2UyOhLw2MhdOP9k2e8c3PfGdWaj67z/JjOkfV2Sp1Qxpkc/S00i65Vs3
	 /ADT0oykKbJzYbTSlCQ4quvakQm3w4TmecvhDWOQIu41M2yTQwmIH+h1diIMV1EU8c
	 C3G4boLnkmsaVtzQQBj4whe9RMRsinQDJPoB8CU99f2OlhECYmHxCxOdI1QO7m7xEf
	 k16vHhgjgLX2OTjjVPk8TV2Z71U4gROEKkDROGmQvEV2quF3dw+dsZBD0kknWVwLtW
	 /aPyDYagqjN/A==
Message-ID: <sashiko-outbox-205095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 2/7] xfrm: esp4: use the current sequence
 number for the IV
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-3-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-3-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When a GSO packet is split in software for IPv4 ESP,
> validate_xmit_xfrm() calls esp_xmit() for each segment. These
> segments have XFRM_GSO_SEGMENT set, but after the split, skb_is_gso()
> returns false for each skb, so each call increments xo->seq.low by one
> after writing the ESP sequence number.
>=20
> The low bits are saved in seq before the increment, but esp.seqno is
> set afterwards, using the saved low bits and the high bits from
> xo->seq.hi.
>=20
> When encryption is done in software with ESN enabled, the segment at
> (H, 0xffffffff) uses (H+1, 0xffffffff) to generate the AES-GCM IV
> because xo->seq.hi has already been incremented when the low bits
> wrapped. One full 32-bit cycle later, if the packet at
> (H+1, 0xffffffff) on the same SA is non-GSO, it generates the same IV.
>=20
> Move the assignment to esp.seqno before xo->seq is advanced. This
> saves H before the wrap increments xo->seq.hi to H+1, so the segment
> at (H, 0xffffffff) generates its IV from (H, 0xffffffff).
>=20
> Fixes: 4b549ccce941 ("xfrm: replay: Fix ESN wrap around for GSO")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D2

