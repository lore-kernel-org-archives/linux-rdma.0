Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234431;
	b=a3XrvdGaD5UI+9iP2uTI1YcvzqHL7InrCfRmSU7vEoDbjuCIGOiO1tL5mhvhxYzURm3T
	 /AawLXMYnnf2eOjFSgALuxtXzjZhPExGNp4NGrM9hlqu4gj/V1dW2d1J4uYK9pIxEi4QG
	 HxWtlXkndjfXqbumIOuyfJlEpRBdeXNLqB2mFQ68NBAwROKsbGc3WaG2o2aGuEDkRUsh5
	 t/cm61E2KVh9lCOHkT4FWKbTtNGvNpVlLpol8GDMSmIZarP4DEbT6akltB8SJYhAYx2Ek
	 o0De2TVmIwl8G0/oHqN79P3kS1dts2xtiRWGV8WeUqrNBoy4IvEqtHJFMldy3o5SQ2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vWy8ix0m9HCEYY8TBU/fvfMMVpxhkBzeGSFEWtuYUFE=;
	b=IlXTodiVRrYjv2sLxzpr4x0rZYaef8NzP1eftgDdHo2KnAodZYlErTAfeMyiOBDWjTtf
	 RLfEzn1lthpMj5hZUVo8Sz9PBq1RMbwS8htYtf/Gx7NkA9YXBIbsKagirauzVIbrYCelb
	 LW5OddBo7e9CWPUS/vib1k9r4E/pzvvuu7jVKDNPHr8WL+ANW2aUrvFYLtiDvAwndpYTc
	 d0G4HXQnfIYqvl+aVS79A8/vzDyaYUhVwU147A7lrtcNi+RjwIL5BcBf7Y1WtGYPd4ya+
	 s5T3fktHsxiofhkGN9tEVEuzOy1wmF2I3nihwH1sar9UOD42XwWC2y9bYkCdtriUoXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qe5ie6dn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8969606A321
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qe5ie6dn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601991F008A1;
	Mon,  9 Nov 2026 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234430;
	bh=vWy8ix0m9HCEYY8TBU/fvfMMVpxhkBzeGSFEWtuYUFE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qe5ie6dne92UXmPt4rIVX6hdNh4waFbUOppW2LK3dZ7/S148NJz5qfK5Fe6vbK/tt
	 FbeAT2h90DQmjVu2o1L367RvOb/IDsLiA6grIPwhQHoGzFjUDINDHvtLS38iEGkMib
	 jJLhCL8nBc84oxARSiB5uJCSUtF9ZrdFAAwbiosQrVZPfQ5MRWnUQ6l5dRjZQ8dmB6
	 rPa+pZ67b5VN64K1EC66QwLAMClTNFlf/NoOsL1dAkXY16XtaFj+Ce4iGDQ9IWsVPe
	 CNFJh5asvLiplVLMb5ZBeVGR2ByZiE9VqFVzQwAWwZQr6v1d5S6KSj+n8O0YcqRtYJ
	 1dZxTg4kz4F5g==
Message-ID: <sashiko-outbox-205094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 1/7] xfrm: esp6: use the current sequence
 number for the IV
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When a GSO packet is split in software for IPv6 ESP,
> validate_xmit_xfrm() calls esp6_xmit() for each segment. These
> segments have XFRM_GSO_SEGMENT set, but after the split, skb_is_gso()
> returns false for each skb, so each call increments xo->seq.low by one
> after writing the ESP sequence number.
>=20
> When encryption is done in software, the AES-GCM IV is generated from
> the incremented value: if the last segment has sequence number 100, it
> uses 101 to generate its IV. A bug arises when the next ordinary
> packet is processed: it also goes through esp6_xmit() with sequence
> number 101, but since it does not have XFRM_GSO_SEGMENT, no increment
> happens and the same IV is reused.
>=20
> Save the full sequence number before incrementing xo->seq, and use
> that value to generate the IV.
>=20
> Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for G=
RO packets.")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1

