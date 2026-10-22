Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680236;
	b=WpPVZ6SPfqSlUyAPBJwalWK5lSwW9o0gT6b53ycfd6xQkCSM+c+LU9pfAGREzocnUw3B
	 uIz8R2wsZnyLfKWYkypBazb7zaxOi5SVKbD+ZM32+x3EOqkBkQJlUTwuwX8DV+1ovnvk4
	 /gN6jbhHpvIHcylN8ftPHDKYWzfrrJY/bxiqkomm9NaRxjPTeIJ5jr/JR1yN0GXuCyOs3
	 9++E3KQOhFay0iomj8cXAyRlhjgAroM3w3RCzKVC/GoDC0gJNeDcZH8MuiHBRxLU1s4mw
	 ZQYuhOysBc1bb8YmFg3okMgbCPufG68KC4M1Pt1kWBJnhKkydhLeIFIsibYXvJU6skA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680236;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BQsy3r3WKo3jGro5VkyV3UwpETRe+1KXYudA4iozJMQ=;
	b=lRfuf7y5Wh8E8cVEjFmAHdVYyK/uHSm/EKiyOVr08xQKcckWDcSztDu4YfkC0aj//tc/
	 SQA867oc+xd5UtlCASfeg6Tlk8fApWe/28JMOjnwBRfGtKNCCvI2fxKIwyabE6YF3HAHK
	 eEHxQ32gegrzoKHGVeW4OtDvMji6O6R9Th+EsvJiOqH6N0TWXWrovXebulJechORiUrEA
	 asuoLSVmzoK/YbytRx9jE4i9lw036Md/2u069uAuBiYwm6whHx4PO3OLMLbbeAu47o8M9
	 so6VotTsrC+KRJz/Bop17SbCUv2JTtdp4X8v9z+pj7Opb6XK2dF4DL1J0xdr9nR1eBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HhuGGKIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600B9606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HhuGGKIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287F61F000C2;
	Thu, 22 Oct 2026 14:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792680236;
	bh=BQsy3r3WKo3jGro5VkyV3UwpETRe+1KXYudA4iozJMQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HhuGGKIrBzWQEzmszJ9Imz/UT8ipXP2lkkfBDo1BnexYD0vowA06zBEw9Jh8/cLdD
	 Ry904FxqEuxOVYHqSNIhjCOloKz5arQ5BdeQMWOpJnrlGS1YCykTsTUjz0HW3AGRJW
	 fZ3gHHx9xBnZG5Wbbm03FScZC/1QK2SWjXViuGZEZal57S30oKiFBoMgdl91LbtsPA
	 jPkorLOGAE/ZFinhWPCnVOIJEP0liFTVMKnU3x3SITKxoYjeTGaypxRBBkyymvKsjj
	 tWz3NPiMJkSK7th1mvJ1zv0ScvMMs6HUyrJBhCnkxqhKMQMolySiBL/yTSdIBHE9Rq
	 JeANwk/g8MWHw==
Message-ID: <sashiko-outbox-181649@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context
 counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
 <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 14:43:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srpt_send_ioctx::n_rdma and ::n_rw_ctx are u8, and neither of the values
> stored in them is bounded by 255.
>=20
> n_rw_ctx counts the INDIRECT descriptors a command carries, and the count
> guard in srpt_get_desc_tbl() admits data_out_desc_cnt plus
> data_in_desc_cnt, so up to 510. At 256 descriptors n_rw_ctx wraps to
> zero, and srpt_release_cmd() frees the contexts only when it is non-zero,
> so every scatterlist and RDMA context the command allocated leaks.
>=20
> n_rdma is not a descriptor count at all. It is the sum of the
> rdma_rw_ctx_init() return values, which is the number of work requests
> each context needs, accumulated by ioctx->n_rdma +=3D ret. A handful of
> descriptors for large transfers can pass 255 on their own, with no
> unusual descriptor count involved. A wrapped n_rdma is then handed to
> atomic_sub_return(ioctx->n_rdma, &ch->sq_wr_avail) and tested by
> WARN_ON(ioctx->n_rdma <=3D 0), so the send queue work request accounting
> drifts too.
>=20
> Make both counters int, the type the values they accumulate already have.
>=20
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022143901.2991=
062-1-yhlee@isslab.korea.ac.kr?part=3D2

