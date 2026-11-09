Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234434;
	b=lIorQzrr/T1Zrh52iSutJ2f0sK09CARGxntNVj5pVEipttaDX7RPeUkigbtgYzNfaHv8
	 bau/PzWB+yDoWtx7Ree9olGGgQVK7XyZAo7sp7bFwMLSGxTZhaVG7wqJVA7hg/CvXe6rE
	 N1u8qXZsgkeCwVNBbKVsvK++bKeG3sxX/QaxeeUufX/EmiAgCXFPC+l5hVA7o4+hfJecI
	 +wVQFNIdpArCWDJVYpzXb/X3JsGPCiUYwhgwnCRZmq4RG4A4rPDNNKJzKdU78w2Lk3a31
	 8FUSgXMcsJ5ik1MLnCGHVD2iI1m5dKAa/GBscpvc7ddTL0+ScB7v2zRMci+2FiN/u4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234434;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CTyYPgfmM3IlprFtBBzqHhyNThahcS9sp2fnShhRl0g=;
	b=sd9yNq/PP64gcpcKNkeRORlbEj0CZeB0YW80Vcme03+/lP1qqfRGjD+n8YW5JPZKwMrw
	 P0HH3KcIprgzs/7djdJwE4pLkv+M0Eue7Skbhmbs/1gmwzmTUv7pknrnb6iDStYvu4apT
	 2cQ7IV2S5vzmQM4WEeKoAf0JKOT2F5VlHJyn+vlghP07M+ahx24v0tgJXQE/sKwLBwnN7
	 zBt7YQLpy1Rm0f6acBpLW7qIbEkMwjqmTah4jOyEwd9q4rxuw7SgqmTGfvs+xwDbn4t+R
	 /MVW5+j2cwIl/mjEc63DRE4SqzqFM7e66Z909YzEqA97nzzxRsuBwx7YFlvZ1ytm/Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hdMXJpPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB51606A333
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hdMXJpPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191261F0089F;
	Mon,  9 Nov 2026 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234434;
	bh=CTyYPgfmM3IlprFtBBzqHhyNThahcS9sp2fnShhRl0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hdMXJpPiMd7lXBLH+LwwiRDlEoBIkaW0qnCS3bWpfjY5oLB94nRZYxfW/I3d1lGfF
	 y5LgZ3U0osgGBeJl54aBGWSERxhbJTgRIR14O0UKK+4QCYp6U+DyrUBrRuHH7prlMW
	 tng/rWPgZOrdPB5MDagO37cqYmD4XC6defGPA4YIttiT0OZfHtMZlJ5Gq6Z3M2J2rj
	 eFU7QpqkQ1GHRCTQ3eD+W1Kp7MPwu9Xsg1fDz6ojO/IXSrg1VcOo74lwPLpkzVOj6o
	 1q4rj71MM96BisQ4UGjbRavRCP8TF2sf4Jr3y4h8RUH/lYcaFlVpM26p9f8S2lzLcI
	 TwVivnUBLM2ZQ==
Message-ID: <sashiko-outbox-205100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 7/7] xfrm: leave the sequence counter unchanged
 on ESN overflow
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-8-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-8-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When the 64-bit ESN counter overflows, xfrm_replay_overflow_offload_esn()
> rejects the packet and rolls back the stored counter. It decrements
> replay_esn->oseq even though only the local oseq has advanced, which
> can later induce a reuse of the last sequence number and the
> corresponding AES-GCM nonce. Both IPv4 and IPv6 are affected, yet,
> processing about 2^64 packets under a single key is required to
> trigger this bug, which is highly unlikely in regular use cases.
>=20
> Leave replay_esn->oseq unchanged on overflow. Keep the decrement of
> replay_esn->oseq_hi to undo its earlier increment.
>=20
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloa=
ding")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D7

