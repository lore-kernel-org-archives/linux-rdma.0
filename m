Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005240;
	b=Btoj90fA5unnvoTm8uysZ6N6yTfvQly2ZS7fsfHXJYIKLYyOFFo+8hnucgnMb9JeKNsx
	 DGN+YoLAa68F61AWlpP1pyo9FVxVCGhhG7UeVHDSW/w2EyhDlu31NeDLFY+DJPGlfa2DH
	 9GJ7SLSaNGPkOOts8JzBGPUhROXqviSykqBrdztocu+7oBjhPdIxhMUX05asYWzZqrhtQ
	 LxpY0gjPWc1SDiAjbZO0xEzAWohC280T0X2w/wWeqXQ3XJzmrQTa9yl/6rp99Ut9MXmI4
	 yuPmucA1ct4f1ebnQKPrCHpkuz54hphAJdU1NLisFiL6y5+SGs7JoITMDBjcAMz5YWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005240;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VZLzhZBfWdEmy0rPaFvStLluO/IOoFIzPBcHrCh7dRk=;
	b=m2fa6waN/G8zZQdN1E5Zonw8iQ2GtsaLAsO9FrBWESPPDb2sHNL00BQLTrJTFwV++xnc
	 7wvtuU6/0tqO2ELXc1soneYhVXlMDg+YGqQV0FOsUUVu5k4Vkr+yIV/HXwnD+EMiIznvV
	 3IgqnFUeIz5ljOF86eLNTCWhEBw4c7j1QXOfxcrC9jcGhHBqfIsJEExzR8tg6f/MbVL9K
	 fH8lcdrka7JT2iiAh0gJXlhfio7YEu0NblatppfQ4PuockUchYP9d917rWmP09wJjIHDc
	 it63kGmFCl4prA9YTaFHq60cTqsdpm3OQ8E3i9WIXYEhVUY0dA3QTx7CmMzdu7Ue7fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKPnGn7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDE1606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKPnGn7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C1E1F01825;
	Mon, 26 Oct 2026 09:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005240;
	bh=VZLzhZBfWdEmy0rPaFvStLluO/IOoFIzPBcHrCh7dRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OKPnGn7cE+VdeXYTd6Yggcub0CfLzNXFHeqHOylElOnojvugc/XYj9wyUwjGf9fp6
	 2aXDbiJqYk9DzuwlMqF+Gz7QjYpa1g5WRriBNczHtVTd4oamZOiTHRbI1wOsKQrINd
	 2rz+YbIc6YoYieLAM6B7DD4MyroPBDCEYrxqmprHCywch6Sz1TU22gRpBQFZisJMco
	 NPtUpvKuCE0pKoKLaAPZGyi/JgSyE/AaSzwEyDzDVkTQBzncxJ8+CSbKMVdF00Pc4a
	 D17t2xiAw8Zd3NJOTLDrTh/OVhqiFxcczecCrYMdm7bzenyERTKx2bmzjUmv5/Yocj
	 Xi6xRK+98oqFA==
Message-ID: <sashiko-outbox-184720@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 RESEND 1/2] RDMA/srp: refuse a target that cannot
 receive an SRP_RSP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026055430.406487-2-yhlee@isslab.korea.ac.kr>
References: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
 <20261026055430.406487-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:00:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_cm_rep_handler() takes max_ti_iu_len straight from the target's
> SRP_LOGIN_RSP and srp_alloc_iu_bufs() then sizes every receive IU with it,
> so the target alone decides how large the initiator's receive buffers are.
> Nothing enforces a lower bound.
>=20
> The initiator parses a 36 byte header out of those buffers. A target that
> reports a smaller max_ti_iu_len gets undersized buffers, and the header
> reads in srp_process_rsp() then run past the allocation. A report of zero
> is worse, because kzalloc() answers it with ZERO_SIZE_PTR, and on a
> transport that maps addresses virtually ib_dma_map_single() returns that
> pointer without looking at the length and ib_dma_mapping_error() reports
> success, so the buffer reaches srp_recv_done() and the read of the opcode
> is already out of bounds.
>=20
>   BUG: KASAN: slab-out-of-bounds in srp_process_rsp+0x757/0xbe0
> [ ... ]
> cannot speak the protocol, so nothing that works today is turned away.
>=20
> Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026055430.4064=
87-1-yhlee@isslab.korea.ac.kr?part=3D1

