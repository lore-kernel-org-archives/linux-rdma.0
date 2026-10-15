Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA5D52E06C
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069310; cv=none; b=M/No8y866+EK68+KwFMVq3IApgoVftWiUbAWMSF4NkS0C8Wz+hx9u93Igq3hNj7t+TqCbThYZz7I+F1pfG4ISQ4at72kY6H2+Xe2x4vucgykiYWiA15KejlfVehJyLk7Yf0u9N18Qf8E+6tQI3Z3HZbVDL6CSVe1HpTA+zHJI7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069310; c=relaxed/simple;
	bh=iK2KBmQRN30ly5jalb0oMmKM74Qkt5xIHAtgW74qjCI=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=LGS6dHfEpIoHyo70sYi0Mwa16ETlsps5j3MhmkUo3m91QQ2htF9Sa4GFZtD9yddYNe9K23dwELG0qYwiYv7XaTmLPUJUyca5h/fF7dtko1n/uTRvijmTURI1V5i58wX2IzE8bGlX0HkIB7TLmbzv1MUdGoQEkJxkZxfTlQFqMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjT+R0xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjT+R0xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C291F000C4;
	Thu, 15 Oct 2026 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792069309;
	bh=HnqOe7mSMnTTcVRDDbgS+Rx8fFhJSB8QHSH5HeKDsss=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RjT+R0xpCS0GDfmHVakZ++vee7o3WxEx3WHsJ7bm1/DJsrxbxdAcuPmXjvUuybcNv
	 wOhtiTLDd3hynqc3I9m29V5nZuPUqf0FUDeExQ3kzU+L+jgvZNVD1uMgEOg3nTNAcz
	 AyQoG7b9UQ3xat7bgCtG5++KauaxLOXP4ecXnvCSTAyEfq1a+ErFbcm8uvu4bIfGvl
	 h8bg6sVqBbzq5A1J6eraS2HN4l57vA9CVSP8FloNcM9NfQNKQicQX+KdD184f1cQnL
	 r7AD14TTBtjOw0gGYzmFye0qifHvlJPN/Kl52yGVspUufxxbk4y38y53P9PuTO4qVO
	 XGzuoP07qY4lw==
Message-ID: <sashiko-outbox-172888@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 1/3] IB/iser: Post header-only PDUs inline
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrei-Alexandru Bleortu" <me@andrei-z.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261015125118.2966247-2-me@andrei-z.com>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-2-me@andrei-z.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 13:01:48 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] iser: DMA mapping leak on iser_send_data_out() error path
--

commit 9c1d70cc4e6b5a103b601d5536559ca76fc30e86
Author: Andrei-Alexandru Bleortu <me@andrei-z.com>

IB/iser: Post header-only PDUs inline

iser_post_send() posts every PDU by reference, and the QP asks for no
inline data. Before the HCA can send a SCSI command it therefore has
to DMA-read the 76 bytes of iSER and iSCSI headers from host memory,
and that read is on the latency path of every command.

> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniban=
d/ulp/iser/iser_verbs.c
> index ab2a27d23478a..6319d7fd17cf1 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
[ ... ]
> @@ -870,6 +882,19 @@ int iser_post_send(struct ib_conn *ib_conn, struct i=
ser_tx_desc *tx_desc)
>  	wr->opcode =3D IB_WR_SEND;
>  	wr->send_flags =3D IB_SEND_SIGNALED;
> =20
> +	/*
> +	 * Post a header-only PDU inline if it fits in the granted inline
> +	 * size, so the HCA does not have to DMA-read it from host memory.
> +	 * The CPU copies inline data from a kernel virtual address, so point
> +	 * the SGE at the headers.
> +	 */
> +	tx_desc->tx_sg[0].addr =3D tx_desc->dma_addr;
> +	if (tx_desc->num_sge =3D=3D 1 &&
> +	    tx_desc->tx_sg[0].length <=3D ib_conn->max_inline_data) {
> +		tx_desc->tx_sg[0].addr =3D (uintptr_t)&tx_desc->iser_header;
> +		wr->send_flags |=3D IB_SEND_INLINE;
> +	}
> +
>  	if (tx_desc->inv_wr.next)
>  		first_wr =3D &tx_desc->inv_wr;
>  	else if (tx_desc->reg_wr.wr.next)

[Severity: Medium]
If iser_post_send() returns an error here (such as when ib_post_send() fail=
s),
iser_send_data_out() handles the error by jumping to send_data_out_error:

drivers/infiniband/ulp/iser/iser_initiator.c:iser_send_data_out() {
...
	err =3D iser_post_send(&iser_conn->ib_conn, tx_desc);
	if (!err)
		return 0;

send_data_out_error:
	kmem_cache_free(ig.desc_cache, tx_desc);
	iser_err("conn %p failed err %d\n", conn, err);
	return err;
}

When tx_desc was initialized earlier in iser_initialize_task_headers(), a D=
MA
mapping was created.

Does freeing tx_desc without calling ib_dma_unmap_single() cause a permanent
leak of the IOMMU DMA mapping?

This could potentially exhaust IOMMU space or cause memory corruption if the
address is reused.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015125118.2966=
247-1-me@andrei-z.com?part=3D1
