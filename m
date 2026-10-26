Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793000385;
	b=WuIF8mL/qKrhBKOyuFkXIIwWg5BIwm9yLFDciYsl0nWVovHBc1PYsDrk9VZjt3jxdPus
	 aC531wieMY2Cp9ONgFz/QvZRLmc+3aLuqVvD1KLjTLelQOTjiyEH2O+uXnOVQtAeqUWnI
	 PWaXBlO4+enRjP+xGyi5D2c0YiFLkeVqLdAv3O8hh9T0yh7DoKeyhoeKDxHX2p53wwnLu
	 ev1j5p3eN7JO7yUucOdzEg9g2TIh2s4v829QGUlgBcIRu9RqCUgWabxJ8sUFt+NY0xTHF
	 wGQAPmEUsG+aAKf9w75X1kyzwwFVMYmW6rEKyo7y+/Vclr10141mXyL1sQLJfdL2WIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793000385;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5RVBbrUO/utme8eFXIXPzSpA0Nz6zTQIANbgxZjHxsI=;
	b=wMreNS5jCJTU1ZuQoK4hceujofdobLG3WLkf0s+xx4k0jhX8POxNarFqi5EeXDT5bnug
	 +IOi93r3/mfGKhosM2Vs/+ax98BWOpovcKJYkInrVP+g7RuDKkY6sIFGp8BQMIVhSUnKB
	 WV6r+29j/LCMLYx4L+yVUf5niKbq+C99HxkXTedT+AbRl1qW2tZhECAygUdfyj1CDOPso
	 EIhGD0K582k6UpRSZ0DUEGXJr0FBOO7L8/yuzJgOQyIaD4xzvMiCYrCKYjz0aVD4Hrbns
	 CJdLIEAp35+EIkOuZFR26KcVUHGbg8guF5xDeo8Jdo4BK65TXSNzLSRgVrO3fXNZ4Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bMnebJM5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10840606A323
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bMnebJM5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591451F01825;
	Mon, 26 Oct 2026 07:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793000384;
	bh=5RVBbrUO/utme8eFXIXPzSpA0Nz6zTQIANbgxZjHxsI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bMnebJM5Cyqrc15+7DLiddBcaAOut22ltldid3SyR6MZZcMeXP9vg/NY2OFsgD40O
	 x6djMe2Mxd//y5gTCbGgbog4AnJttAe2ZPrb1u8JfRNjOBdsIwrlwRF8c2Le1SUgTY
	 mxOxks5c9kn+H4HGYUiqA8nWBTqkePYoyocDTSzT+jy1SRPMrziy9NHFXyl45vpDc7
	 09XNJYWEHHz5A/0xKmwUEOr+NUYwESueYYgk1krA1nFVfGoVsirYTCZcQ//Yf1TDZ2
	 q0mnY/OZwDGw/geInMYkkAepD2A/Ml8oLqYgotj5LwGj1b5B0iQPhSbDk3xx6EveB+
	 y8xScHtZ/7eDQ==
Message-ID: <sashiko-outbox-184662@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/26] dma-buf: Let the exporter select mapping type at
 pin/map
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261026053623.202642-6-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-6-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:39:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] dma-buf: dma_buf_map_attachment() clears preexisting attach->selec=
ted on error
- [Medium] dma-buf: dma_buf_pin() leaves attach->selected true when ops->pi=
n() fails
--

commit e1080028468cc11821bdd6c9ecd4fc7204151523
Author: Alistair Popple <apopple@nvidia.com>

dma-buf: Let the exporter select mapping type at pin/map

This commit adds dma_buf_ops.select_mapping() so the exporter can select a
mapping type from attach->matches when an attachment is first pinned or
mapped, recording the choice in attach->selected until mappings are
invalidated via dma_buf_invalidate_mappings().

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 348b47f266b48..03f06c4b957ca 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1201,6 +1201,10 @@ int dma_buf_pin(struct dma_buf_attachment *attach)
> =20
>  	dma_resv_assert_held(dmabuf->resv);
> =20
> +	ret =3D dma_buf_mapping_select(attach);
> +	if (ret)
> +		return ret;
> +
>  	if (dmabuf->ops->pin)
>  		ret =3D dmabuf->ops->pin(attach);
> =20

[Severity: Medium]
Should dma_buf_pin() reset attach->selected to false if dmabuf->ops->pin()
fails when attach->selected was false upon entry?

When dma_buf_pin() is called on an unselected attachment,
dma_buf_mapping_select() sets attach->map_type and attach->selected =3D tru=
e:

drivers/dma-buf/dma-buf-mapping.c:dma_buf_mapping_select() {
	...
	attach->map_type =3D *match;
	attach->selected =3D true;
	return 0;
}

If dmabuf->ops->pin(attach) subsequently returns an error, dma_buf_pin()
returns that error while leaving attach->selected set to true even though t=
he
pin was not established. Because the attachment is not pinned, the exporter
may migrate the buffer elsewhere without invalidating it (and for attachmen=
ts
without importer_ops->invalidate_mappings, dma_buf_invalidate_mappings()
skips clearing attach->selected). A later retry of dma_buf_pin() or call to
dma_buf_map_attachment() will see attach->selected =3D=3D true in
dma_buf_mapping_select() and skip dmabuf->ops->select_mapping(), leaving a
stale attach->map_type in place.

[ ... ]

> @@ -1324,6 +1305,52 @@ struct sg_table *dma_buf_map_attachment(struct dma=
_buf_attachment *attach,
> =20
>  	return sg_table;
>  }
> +

[ ... ]

> +struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attac=
h,
> +					enum dma_data_direction direction)
> +{
> +	struct sg_table *sg_table;
> +	int ret;
> +
> +	might_sleep();
> +
> +	if (WARN_ON(!attach || !attach->dmabuf))
> +		return ERR_PTR(-EINVAL);
> +
> +	dma_resv_assert_held(attach->dmabuf->resv);
> +
> +	ret =3D dma_buf_mapping_select(attach);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	sg_table =3D __dma_buf_sgt_map_attachment(attach, direction);
> +	if (IS_ERR(sg_table))
> +		/* Nothing was established, so the choice may be made afresh */
> +		attach->selected =3D false;

[Severity: High]
What happens in dma_buf_map_attachment() if attach->selected was already tr=
ue
prior to calling dma_buf_mapping_select() and __dma_buf_sgt_map_attachment()
fails?

An importer can enter dma_buf_map_attachment() with attach->selected =3D=3D=
 true
because the attachment was previously pinned via dma_buf_pin(), because it =
is
remapping after a prior map/unmap cycle without an intervening
dma_buf_invalidate_mappings(), or because another mapping on the same
attachment is already active. In that case, dma_buf_mapping_select() return=
s 0
immediately without making a new selection:

drivers/dma-buf/dma-buf-mapping.c:dma_buf_mapping_select() {
	...
	if (attach->selected)
		return 0;
	...
}

If __dma_buf_sgt_map_attachment() then fails (for example, sgt_exp_ops is
NULL, map_dma_buf() or dma_buf_wrap_sg_table() returns -ENOMEM, or
dma_resv_wait_timeout() is interrupted), dma_buf_map_attachment()
unconditionally clears attach->selected =3D false.

A subsequent dma_buf_map_attachment() or dma_buf_pin() call will then invoke
dmabuf->ops->select_mapping(attach) again without
dma_buf_invalidate_mappings() having been delivered, which can overwrite
attach->map_type while the attachment is still pinned or while an earlier
mapping is still active. When that earlier mapping is later unmapped in
dma_buf_unmap_attachment():

drivers/dma-buf/dma-buf.c:dma_buf_unmap_attachment() {
	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =3D
		dma_buf_get_sgt_ops(attach);
	...
	if (WARN_ON(!attach || !attach->dmabuf || !sg_table || !sgt_exp_ops))
		return;
	...
	dma_buf_unwrap_sg_table(&sg_table);
	sgt_exp_ops->unmap_dma_buf(attach, sg_table, direction);
}

 wouldn't dma_buf_get_sgt_ops(attach) read the overwritten attach->map_type
and either call the wrong unmap_dma_buf() callback or hit
WARN_ON(!sgt_exp_ops) and leak the mapping?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D5
