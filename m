Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792999768;
	b=Wfrt1+xwIcMvIltGpjxdB3NMBMkQjPahIsbZgyjLuw37Hqre3qXaqWax+NlxByI2zagw
	 Wc5pVUazFT48om4hdMgAayZnhOXWq7Zbvp5slJW5qmSSFimqSO8ecYBM9UMj7ncNEOUf7
	 nDWITADnqnMjmWnaMDCI7yn6FqEd/w5Mb/F6Bh5Cca+bfdVxtrNkm63Lomz5ddAxztLN8
	 h7Jm0nXwi60UTmM2n7Vep1fesXK2jpaqsdabK1KdIjGevABY/rwxSkoEybWYP1iR2OREJ
	 CcrwmKyiUheKa8ZnjNROF1uyT+5Z93v5tWouMgSU0QCjzv/i5yGH+iL3pJcNhrY8Bng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792999768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ngHZ//LensErVgUP2h/uzFikKxMQwlzgpBXqi8Yu/yQ=;
	b=Myn9fBSKYOgI7F7FzoCOcPJ7egn6eia5vScg7y01uCFi2KTMX/+qPeNWsp/SXowIzGNH
	 KOzyfgrix3zYtY7w1rr5+l6qVauXtIC+t4fxSM3FDOKnHqGeocMiNVUCYUb93XI8ETUdz
	 igZOm4J71oI4YPp7iq4BH+4aX8lECHcMwzjR9i5y3/726N3otBF2J6cGB0DbO2m79iXk2
	 H9I6sVYhDUjvK7R4/E93HNb3QrkZXMEHU6aZCjh1+q00+JuLA4pmV0KcdBMzI8r6rfwWV
	 g864oD6lc6WFRLc8MTtz6vTw6dPTA+rZXvkouEJT4f1NNThdjxc1YFkysc/FltKk+lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b+i0YPO2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16284606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b+i0YPO2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4D41F01825;
	Mon, 26 Oct 2026 07:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792999767;
	bh=ngHZ//LensErVgUP2h/uzFikKxMQwlzgpBXqi8Yu/yQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b+i0YPO2tFv0VV+dtBHvsJwUb9SYfN4ge7VwvQYtWPXaaBYsbA8M0rtNpQV4w4+c9
	 OTxQOpI2Xc1fKLgio0pFeZ2Tze7F4HnBrYDqI50brJ/vc4+mEiFN0rG0urTKtY1RqB
	 KcI8YgPQkFu0kng/eganHfrm3yX/9bZw0aCzRE5voy85U61sIuWm3QHxZEy12QUGA1
	 cMvrkvgwG3Uh2C56NNqYeSE21gyXzH0zCs6xkQdHbriojuw70/CoVCELX5dhaRYnQ+
	 7mNQQ+NGOIYxnxCV7bjUoN+72dLodZSoJuJKIpBOQikBLCjc3w2vyjjQem9B0WXOsG
	 R+F2aUGWqdAkQ==
Message-ID: <sashiko-outbox-184660@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/26] dma-buf: Route SGT related actions through
 attach->map_type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261026053623.202642-5-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-5-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:29:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] dma-buf: dma_buf_get_sgt_ops() called before !attach NULL check
--

commit b7db1c5ac9aaaa1115dc4420ef21a9d03108a96b
Author: Jason Gunthorpe <jgg@ziepe.ca>

dma-buf: Route SGT related actions through attach->map_type

This commit routes sg_table map, unmap, and debugfs dump operations through
attach->map_type instead of calling attach->dmabuf->ops directly.

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 16a7fbb8aaabe..348b47f266b48 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1253,12 +1253,14 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
>  struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attac=
h,
>  					enum dma_data_direction direction)
>  {
> +	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =3D
> +		dma_buf_get_sgt_ops(attach);
>  	struct sg_table *sg_table;
>  	signed long ret;
> =20
>  	might_sleep();
> =20
> -	if (WARN_ON(!attach || !attach->dmabuf))
> +	if (WARN_ON(!attach || !attach->dmabuf || !sgt_exp_ops))
>  		return ERR_PTR(-EINVAL);

[ ... ]

> @@ -1366,15 +1368,18 @@ void dma_buf_unmap_attachment(struct dma_buf_atta=
chment *attach,
>  				struct sg_table *sg_table,
>  				enum dma_data_direction direction)
>  {
> +	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =3D
> +		dma_buf_get_sgt_ops(attach);
> +
>  	might_sleep();
> =20
> -	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
> +	if (WARN_ON(!attach || !attach->dmabuf || !sg_table || !sgt_exp_ops))
>  		return;

[Severity: Medium]
Can calling dma_buf_get_sgt_ops(attach) in the variable initializers of
dma_buf_map_attachment() and dma_buf_unmap_attachment() cause a null
pointer dereference when attach is null?

In include/linux/dma-buf-mapping.h, dma_buf_get_sgt_ops() unconditionally
dereferences attach:

static inline const struct dma_buf_mapping_sgt_exp_ops *
dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
{
	if (attach->map_type.type !=3D &dma_buf_mapping_sgt_type)
		return NULL;
	return container_of(attach->map_type.exp_ops,
			    struct dma_buf_mapping_sgt_exp_ops, ops);
}

Because dma_buf_get_sgt_ops(attach) runs before the WARN_ON(!attach || ...)
checks in both functions, passing a null attach will dereference a null
pointer instead of triggering the warning and returning early, and the
compiler may also optimize away the subsequent !attach checks.

Note that while the dma_buf_map_attachment() path is refactored in a later
commit in this series ("dma-buf: Let the exporter select mapping type at
pin/map") when __dma_buf_sgt_map_attachment() is split out after the
WARN_ON(!attach || !attach->dmabuf) check, dma_buf_unmap_attachment()
(later renamed to dma_buf_sgt_unmap_attachment() in "treewide: Rename
dma_buf_unmap_attachment(_unlocked) to dma_buf_sgt_*") keeps the
dma_buf_get_sgt_ops(attach) call before WARN_ON(!attach || ...).

Should sgt_exp_ops be initialized after the !attach check in both
functions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D4
