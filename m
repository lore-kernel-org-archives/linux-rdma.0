Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795155237;
	b=tF8K2nBsDZ54ROwEu80Fs8ySOq1USzgKQlLsbHU2Opj+Rmj1b//n4jxc3pe16yMSQUU7
	 VfiG2uBAzKLZ1aVoequkCLjyyK5Bq34FFxTevlEBVU4OeboV1MTUGbAuusBKH2vlAyYUP
	 ZKk7SctEHJS5qiWsrfpT/sA0U6xepCy945g/NKWqEZb/Y8A5e1JdXCuk7UIKXJ/GoHnru
	 LSs83ITEvztxA7vzgoi6gSL414xgx1SFngIs7kc6fjc5vX6T0UHFpTXv4+2gNJbV3MP6p
	 42ZzFvQNENrI7TOK56a+D+j7bKE9yjXWl+KmouD4XkmdV0oFtnVMbKFnSoesN64uVSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795155237;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C8zNlTokDjRjO1UL/G/pkJXnujYaeDDCdccIGRXzvqU=;
	b=wROLdDhZrgTGsSMmjZ8C9DX5mQOVExO6eqOWvIkGl1kpf+LzkoM2vbDzJcLLeqNXDhZb
	 uTxt+t5OskSWq2NmwN96jjgywcG+9pbIo/4w3Gus0SN0iQ1BRXV8hLxmNpw0Uj5+vSwNG
	 ZZX6ydtdNztjbQ4m83BsFu/wr2BKIBzfZ/uB4binrB40GQUgSX5uwa6B9EBXW89Xye4Ip
	 SZ82iZkyAAVWLfgoK6wRb5JU3QnftnutXYne+jSmV+/s9Cnb8agdEE8GJW/ec9VaUtzIb
	 tDHpHozLSRYjy3sZv0BNNYBDXXSD6E2QPfKeJW7tOZJ2d7HOQRmKNK0vRLEGh9dQgmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I90ROJN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD440606A528
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I90ROJN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FFF1F000C4;
	Fri, 20 Nov 2026 06:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795155237;
	bh=C8zNlTokDjRjO1UL/G/pkJXnujYaeDDCdccIGRXzvqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I90ROJN9BwJyD/zxpwNidBEqHy0Tj0gRKOUvgX5ekalTwiObGatZ91QZkKU1J79YG
	 fpSxsYgSriYPm4oMqPZ4zzR3Qy9nLm+HS13oIemF2Kx5RUb5ojKchR//jIgnq8Hs9M
	 3dtVJqrhTR/sBvlOjGrnatskNVyBWLSzgfbY5c5/dxSwcnH+N5naEtGEeEHaPjViHM
	 AsVL8PGs16rCdWV0BSGsf8r7BgpWhjfymd4kcsktvrjNnkHPJWIODUoGmKTvZNc4Jq
	 c6OUMp6iUySmjvgrTvUZQxAeg8Ie8iZvJdodrbw5A2TGBpFL1vxWdm6GvPa4vsc95i
	 N3eypJUt/yDxQ==
Message-ID: <sashiko-outbox-224545@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: match a duplicate request to a resource of
 its own type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yiran Qiu" <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
References: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 06:13:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> find_resource() matches a retransmitted request to a responder resource
> by PSN alone, and rxe_prepare_res() never sets the PSN range of a FLUSH
> resource, so it keeps the PSNs of the request that last used the slot.
> duplicate_request() then gives a retransmitted READ the FLUSH resource
> and reads res->read through the union, so read.rkey and read.length come
> from the FLUSH's RETH va, chosen by the requester. read_reply() replays
> the READ through rxe_recheck_mr(), which only checks that the rkey names
> a valid MR.
>=20
> A FLUSH with no persistence type needs no QP access bit. A connected RC
> peer holding one rkey of the QP's PD can thus read any valid MR on the
> device, including MRs of other PDs without remote access and the DMA MR
> that each kernel PD gets on rxe, which reads kernel memory at the
> address the peer gives.
>=20
> [ ... ]
> rdma-core v65.0 tests pass on rxe with and without this patch.
>=20
> Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder si=
de")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120055951.3022=
39-1-eritque-arcus@ikuyo.dev?part=3D1

