Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234433;
	b=aoBOQs8URE0Mg401jdARwUCJFbCeC6QojdcxQA4+ATKD3hRZUEgW9lWL3MbP1wqL8E0N
	 rJw7awZhAN9HU+BH8hifNJLW1r3EOoBDXTiXljtskz8VIqY8joxFIjfm4rajIrGbxphqC
	 YpQQ4TPePjP8HfAQU0GO/ScU33cR6mcnSn8xZNOneGlHE98xY2BVhOAFBgJkX8vLMyKm6
	 DaRAnubgG1uT5tUTa4T4YvmaVda6nl0GQgd4wOByOMH07FXTn9bIntPkwccog7W4r1cxU
	 cjPYiX8m/i/z4XlxN24UpERSlX3uM/akU4dz0C8uhuPZoTR1xWopeL1cC1P7svDN8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234433;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hi+pgY2aZ+0h3qk2OFIX8pFuth5olaRUyl9/Eya40Lg=;
	b=FscgCf3ph29wE7S0NtKY2ZWFJAwZdSr3AIv9TwhsFInvIxa5AQQOiyHTOMmvpKQJgV1+
	 FUpNzrRbljxwjZbbxMmvOQLPwz4u6fmwz5F3KR+ekF/iFWmLe0uVqQwU10iYzvoV54q7g
	 jYJIs2Yx029biTRTx/P0//yt2lA6lw237irG58OWaXqJr5GzcPOsjb8q1xO14zv3qYV6N
	 QhgXh2bC3KZ9w1UYT111Y0oTIF+ENqNPIlWQKotvJzzM4wDZdbWCWi6hj9kC+UznSnXaR
	 4AQ/KJYhEKW0gGqDRk1RNRmhVpqo65ZAzEVUax14//nNP+Cv+PAo15tWpbTNvDHRB6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUkT5q8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D7606A336
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUkT5q8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0871F008A2;
	Mon,  9 Nov 2026 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234432;
	bh=Hi+pgY2aZ+0h3qk2OFIX8pFuth5olaRUyl9/Eya40Lg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SUkT5q8kEh/ImYMzIpCVCeK92WnrVjgq9j/ODsXAnYnTHlwX1zdpEce6FwNkV5vJc
	 3raWBwhUMFIGdP0TRNZWBrLPC0IPYRlw4tETWxK2qEIdBKdJszGKRmyP9mmAkMDfiL
	 17Jw3RBUSvR937g6AO6FVDKmXEzW12D/lY6HHpeIErtbVQgIvHRd3rwV2L0fGy/kzS
	 BD/SKKfR2x1jhrzDK/EzzFN2TMTYdVzwzhb7LKlLqiKeWvhYngLdnJjlsYivhtVGWc
	 Sn+/ynTo3TQiUq9CRNBGm73eY3NVsfEPxEXlpuUUI3VoPOK6+fELb0xDIgzbFo7tte
	 mNMOKcmqjOpGg==
Message-ID: <sashiko-outbox-205097@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 4/7] xfrm: prevent AES-GCM nonce reuse after
 early GSO
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> With software ESP offload, xfrm_output() attaches a secpath before
> calling xfrm_output_gso() for an encapsulated GSO packet, but
> skb_gso_segment() leaves the splitted skbs sharing the same secpath,
> including xo->seq.
>=20
> For the i-th splitted segment, xfrm_output_gso() reaches
> xfrm_replay_overflow() through xfrm_output_one(), which allocates
> sequence number N+i to that segment, and then incorrectly overwrites
> the shared xo->seq with N+i. If encryption is delayed until all t
> segments have been processed, xo->seq ends up with value N+t-1 for all
> segments. When validate_xmit_xfrm() calls esp*_xmit() for each
> segment, the IV is constructed from the same value N+t-1, causing
> nonce reuse in AES-GCM. Yet, each ESP header correctly keeps using
> value N+i from its private XFRM_SKB_CB.
>=20
> Call secpath_set() for each offloaded segment before xfrm_output2(),
> so sequence allocation writes to private metadata that cannot be
> overwritten by later segments.
>=20
> Fixes: a204aef9fd77 ("xfrm: call xfrm_output_gso when inner_protocol is s=
et in xfrm_output")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D4

