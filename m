Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792893507;
	b=1m1UbrStljuQJAjgViBKuHebFYzcjlEsw1dpH/JDxIq+KcxZAnGw5hilAzNjICny8LLt
	 5YKJHL72CkxiA/bG4A9ci9s6V//KXOUL+pH6DptxTl1nlbCuzuIdHm11/evr4dLDU+TN7
	 gBf4NpYJfo+ToIEB+B9smsMkrusjW9Y8DIvl3MTptbxLSNn9BW6ArtvXZpCj+5uvz5hAU
	 rs4iPlxjd19JPvr4T0fBKlkmAUHblhpFc5ATOGbsQPOaFbDbW4Vj5nSRsHCV/+srUHsWI
	 FE8PuiFDrPMmxFZviLGyE/m0nUtiLKjwyfE61OmdOstwjcLVRlSYmim0Syh1GrhEhcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792893507;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5jz6WKd/i6bnrMQJ2hEQzzW6vx0AJHimdZs1HuvQ4B8=;
	b=Az5kxOSO63zBT8//uQAVgmdmulxAGGGDatHCJ5eVqCftnn4c3IRTBFpNbvMrHcy4lE/m
	 QyMg5xwLY1IFZtEgFNzNYTTw+CisZITA/9iKizZLDD3keK55Ca2Pe6T9T3FFf50BAlEAW
	 Ww1k3UZH22mP4a4nat/vsrpoW+lVhJD5Vmp+CtjAS2ciQ2asejk0qX1yTwLgxEYT0B+Oz
	 2piFr8a+xZiUtN4nB3CawLNAkYYi3DKvyIbn0ZogQSZ0WzCoy8uzV+raWnCdzEeJBTu+u
	 9mBy+iQGPz5Pfz7Jqj7a9lmw8S3oIN55/kzp1RIoO92oC2VhPid8N2pl77509c5JWGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OhFUaVIX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935D9606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OhFUaVIX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053D21F01825;
	Sun, 25 Oct 2026 01:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792893507;
	bh=5jz6WKd/i6bnrMQJ2hEQzzW6vx0AJHimdZs1HuvQ4B8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OhFUaVIXelJIprDPDBj0ODFTzznERoObXP0ypmoLF6c6o7TzQcZwAYTwy3SfN/3AO
	 iLd35Y/FTORwS9BuNCyY5NQ/8Tdfo3NyFBtuJDpa4DtgA3LfPjZdurLSzVgZI94tEY
	 zsUIeBUx5dNO4FO97twII7rYDylqsbOFmaVIKstIxZ+O3HuQ7clVDPFY3iOjRkNLLH
	 HQAGkqsUiMTcqYzOocLzUf0FlDtL/q0EluFpA6W7+xnuFWScrfsc7dVu1lY8cyn0t+
	 d7h38G1esrs76dOtrNRGpX8xa/nQ/hxomnyi7Y0q+Bo6ZdFrjHllWa7kM/d+a5lhfa
	 /QxxDZfuMN51g==
Message-ID: <sashiko-outbox-183972@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/3] RDMA/srpt: widen the indirect RDMA context
 counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261025013748.3755639-4-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
 <20261025013748.3755639-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 01:58:26 +0000
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
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025013748.3755=
639-1-yhlee@isslab.korea.ac.kr?part=3D3

