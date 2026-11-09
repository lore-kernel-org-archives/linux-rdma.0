Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234433;
	b=gwY8pGQqibK/WtlXlMhZkP6PY8cEw3gxv/3ojojFE4oqbA1IGicvj7hHP7s8xtCndoAp
	 bUWTgJMsalUyIoURJIt00DgSXVzJ8va46MdipEnnwo8VFTNPu3MYygkGsmnSXgj6Pex+P
	 gOdOmfsTUpNGG8pAWVPbB2vfAwQxM4aWdzVRSKKALTrqOS5hZsixNiOLgCy1f8iAHf6Fz
	 kCTQmC9vyVSgoReUkb82/6ObJhPZNnKR1N+3PKLKidTSn7GOP1TguTWZAZD5ssyVy0vV3
	 bbwLXRcQBufvK3TuXTU6gq2aTTAxYoo3NY7lsmdfveDLLVr07ziGpQpJBBMJDBeQGlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234433;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SDHk+u0TgN4wSHAcx8ufYFnYW/cGsOILUqU5+a3VEt0=;
	b=4cWfsuL1nGZEfPc/tX2VXSTVqaLF330nT5iybk5ujYjSRfiSZV5kPFjOpN/DAKNi0qn9
	 26kaCKgA85t/J71Ttz49fM7wq1kZBeLh23oA3D9BvqWvFO63mIjHjVgHbk9+XwbaMVubU
	 0m/3B2qlq2nRj+kT+80poh6SFwqoeqloBM735z5OqSQGc1t+Rtkg+26w0l/QBqL49gnAF
	 ba94atKB2J0xBZRI0DH02+tn5K3Jp5/dDaI11+atdPFCQtJZtgdVEabxDaSkcs6h5sdYv
	 awjEeZ5T6yE/Z++AJKApDBFD2yWPwpKoX4c70skFBv6x9sZaastQWj6emU8y9fy2GKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3YXT1BI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58099606A335
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3YXT1BI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D235D1F0089F;
	Mon,  9 Nov 2026 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234433;
	bh=SDHk+u0TgN4wSHAcx8ufYFnYW/cGsOILUqU5+a3VEt0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N3YXT1BIV+60aTxhGp6MEcaqge5xmL4wLWtAXcQlgFSiYn/4tzRE2nYYiNyJvCooR
	 obSjbmfhuZIRydvliy87RSgnNw7VOIPNGtMEBrKX/ipa5FS/MsZkbt51XORLEedIO8
	 LHczrje9ffDNGJbbXoJzgmqCG7D+9bSaemMurEWgSDJcGfdiXEePcTYoAQW6N8NwMp
	 yLvW2VbLih+jL2FG7pvmJwZq9+bJsxOLg/d8wZk6tOYcp9caMXbbYaDDCTVQojGsDg
	 kZWJh6jbJo/X3IrVVQThTw+i11kC3fQFMfCth6c+qpp47MKCmu/VuwDLNYaMjkvjCs
	 F+v9r+5AmpiOw==
Message-ID: <sashiko-outbox-205098@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 5/7] net/mlx5e: Use the packet sequence number
 for the IPsec IV
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-6-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-6-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5e_ipsec_set_iv_esn() may decrement xo->seq.hi for a GSO skb based
> on the SA's current output counter. The metadata already contains the
> high word for the first packet, so this can produce the wrong IV.
>=20
> For a three-segment GSO skb starting at (H, 0), oseq is 2 and
> oseq - gso_segs wraps to 0xffffffff. The helper then uses (H-1, 0)
> for the IV instead of (H, 0). This can create a situation where GCM
> reuses a nonce.
>=20
> Remove the high-word adjustment. mlx5e_ipsec_set_iv_esn() then becomes
> identical to mlx5e_ipsec_set_iv(), so delete it. Since there is no
> longer an alternate IV implementation to select, remove the per-SA
> callback and call the common helper directly for outbound crypto
> offload.
>=20
> Fixes: cb01008390bb ("net/mlx5: IPSec, Add support for ESN")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D5

