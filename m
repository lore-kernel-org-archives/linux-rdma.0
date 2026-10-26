Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005534;
	b=IddZyp4OLxFpxPoZG+1KPOYRaH3LXhRP4Ad+50+naYtzp1WZDAkHS3Ighnc8BWCn/4Gn
	 HFO9Pkn2VPmpc4h0+yXDPGEq+ki3nze3q28rUrUhP19vT5eZNjWevhiTLexrViPBuJbOt
	 RwAXXi4vZTic4miIwYGICgrDCldnVVXAB4GJol/gCqpemfe+hgHznh1bUUq8klGme+h6S
	 huML2MViRsHSm3OyZo+bHFZV73EtZUgzOXHHd1Zn8CpiSkneqx3/smF/1tXBCrKhwQFug
	 oP+lRWVjE5VFiaTGiAKzFbaXPBDqKRREP6LAeYjpKI6wlldvpcEsQldtN7usaV2YesQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005534;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3yYbPE6D4JL/XroeSAEPcSo8C2bZR/FW1yLd5fOFH7o=;
	b=TxLAScSramzaJKrDwFgjG8A2xzfsVohaZxvlpm9elW6PaQ0Zst+8EvEEYti9likMDm8R
	 aO1Na0DBEYAeGJ2B3nNFb9uy3Pqm0zX4eROlCGpRl+6J2XN+TYuuWG2vs+cBmmzhTmNrB
	 bKL/Idzx9Lp9r/ogjMhaD8bLX+ZMmKtvP5lxwsOZ04qu0gwYI8g3A6qf/fFpOd8WC4+sk
	 AGPgZj9bfK4d1PpYLDTwPJsWXtUCF+R+EqHIlHgOHQt2bIKK3VTEr/Iti4C2PoZ1Jjzyq
	 VgPCRk5mveoSL4BZGUeLfi/KqWjIAf7ZSkRuaUbycbLUt7OnishqmsjdzVUKkSTiTVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oA32Y+BQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47667606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oA32Y+BQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95561F01825;
	Mon, 26 Oct 2026 09:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005533;
	bh=3yYbPE6D4JL/XroeSAEPcSo8C2bZR/FW1yLd5fOFH7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oA32Y+BQ4xXRgzh+GwygbTZzLPW3Xk+MWyAY6GnCsaXDRlnV6AybvTEIlN9nMVZi0
	 DROzR/3eRFlxJw+ZwSQPiAsrvgr4dmlJPQXF/mg7R8fbTynVyOjRSDWY9ZQUWkYsAr
	 gEpx+gQHcfwNg20iD1+JczfBKbZu9+PQsOHfI5Zfk5wpJjZPbFm04P5xx6QRd2SphZ
	 3lJiNg0sD7X1CQvYWhyFGdY53deV0apAcUaFrGumNcLG2DGD1urkkwob8j5tK1VEot
	 nfiIIaTmd31NsScNVivG0ghvJLrcGfHY/JpTjUUd5t7v6iwg3SxU7Fta5TzfAhEwfU
	 N4nhoUoFje+Xg==
Message-ID: <sashiko-outbox-184728@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] RDMA/srp: refuse a target that cannot receive an
 SRP_RSP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026052030.296361-2-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
 <20261026052030.296361-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:05:33 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026052030.2963=
61-1-yhlee@isslab.korea.ac.kr?part=3D1

