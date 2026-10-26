Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792999258;
	b=yhxeSLRbKgW7I3p1gJOIdr6ghcl/ggR675aSISCByovPOuBFolZG+kpj4bit50hSrre6
	 Y/9tJdz240OZ8D2OLHTp7o5sq15dHzj/VbO1bVX+yUGRJ79Cx5yiYO17cVA4hP83xCEg/
	 IaIfDs8/F5f+FgxJZeL3iaEY7X++/B6vYII7A/zH9WNc8xLj688vVE/KckpqTYtVJAABx
	 5h9CSS7Bfig9klXsuZlw9yd3QIamzDoJezJT+RfvdXwuAHVr6rQsmreGbniggWVwld6fU
	 5NtSKGE+glJuxbj+fhCzba5Myw8RGwRc7PAyHglp/BXORpy+5XkaQvIS4mYkvVT12Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792999258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7F8/Dw2IEZGp7meIs3INlSoTvSdn/zEE5T/r1TSFuKk=;
	b=VyxvFEdr2wXB9D1qJEIT78VIgTAw+AxJtPDhk/HO+mXct5bPXFWP8R/kelyVJZjP0WMh
	 6GO0zaMyVc+8s/F2+aQwtswgqbKa0dS19ofI51UW2gjDReqNqspfBqvei/zOpcx9SUrGL
	 CiX4jPzJm1iX4+uYeBX582p00or7QkAVdrCOhPpoDWXfPpC/mHvPsOSUHiFT0K+z0bBq0
	 x8Hjew5F64TOyTL391Ga0zOuqg//wtP+FG41NQ4ubKsz8cYaCIWLKzeochBf8FegCSym9
	 4fy9TAAyejN3XhIvc+Z7OFh6OTb7ZWspSOZO8bQjPL0QjYzyKvU/MEH57wk1VApuWIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFFPQDxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A77606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFFPQDxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE0C1F01825;
	Mon, 26 Oct 2026 07:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792999257;
	bh=7F8/Dw2IEZGp7meIs3INlSoTvSdn/zEE5T/r1TSFuKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nFFPQDxYfmgp6kQwjsXqGbcRzO+yrHuqedwXfacF/KBfjO7uhpOkGb0gSK/ee+BK6
	 oFJAC7NLIgWtdEnk5/pc0ZXWvIyHfh+05CR9EyL7p8Z0oiKkStBWFtqGHHsqyVxOxD
	 LZ4aD1rkR+r0fosVpepP5fJes7IoX0LAObfiFtCTfCnFPN2NoY7ccEcFHdQ436Xcq0
	 mNNxKd0ZhzUOTBtcLYFn8Gnawz5zBVGE3yT207ijR/8SV6utAHyYXevWAHNKd9TIVl
	 GggDHQ3YRMuFmLLybrUEA55mjatB6okfKn5cpVG6mwwGtAooE3zpcegoNnNbiLqys/
	 h7uYz8hb3I50w==
Message-ID: <sashiko-outbox-184656@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/26] dma-buf: Add dma_buf_mapping_attach()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261026053623.202642-4-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-4-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:20:56 +0000
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
- [High] dma-buf: NULL pointer dereference of importer_ops in dma_buf_dynam=
ic_attach()
--

commit 4415ca9de8f7d7c189e76efc4aa022c3564f88f1
Author: Jason Gunthorpe <jgg@ziepe.ca>

dma-buf: Add dma_buf_mapping_attach()

This commit introduces dma_buf_mapping_attach() to match importer-supported
mapping types against exporter-supported mapping types during attachment. It
also converts dma_buf_attach() and dma_buf_dynamic_attach() into wrappers
around dma_buf_mapping_attach().

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 4c9add51f9ef5..16a7fbb8aaabe 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c

[ ... ]

> @@ -1025,31 +1035,55 @@ dma_buf_pin_on_map(struct dma_buf_attachment *att=
ach)

[ ... ]

> -	attach->dev =3D dev;
>  	attach->dmabuf =3D dmabuf;
> -	if (importer_ops)
> -		attach->peer2peer =3D importer_ops->allow_peer2peer;
>  	attach->importer_ops =3D importer_ops;
>  	attach->importer_priv =3D importer_priv;

[ ... ]

> @@ -1068,23 +1103,53 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, st=
ruct device *dev,

[ ... ]

> +/**
> + * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
> + * @dmabuf:		[in]	buffer to attach device to.
> + * @dev:		[in]	device to be attached.
> + * @importer_ops:	[in]	importer operations for the attachment
> + * @importer_priv:	[in]	importer private pointer for the attachment
> + *
> + * Wrapper to call dma_buf_mapping_attach() for drivers which only suppo=
rt SGT.
> + */
> +struct dma_buf_attachment *
> +dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
> +		       const struct dma_buf_attach_ops *importer_ops,
> +		       void *importer_priv)
> +{
> +	struct dma_buf_mapping_match sgt_match[] =3D {
> +		DMA_BUF_IMAPPING_SGT(dev, importer_ops->allow_peer2peer ?
> +						  DMA_SGT_IMPORTER_ACCEPTS_P2P :
> +						  DMA_SGT_NO_P2P),
> +	};

[Severity: High]
Can importer_ops be NULL when passed to dma_buf_dynamic_attach(), causing a
NULL pointer dereference when evaluating importer_ops->allow_peer2peer?

Previously, dma_buf_dynamic_attach() guarded this dereference with
if (importer_ops). In-tree callers still rely on passing a NULL importer_ops
pointer here, such as xe_gem_prime_import() when running the non-dynamic KU=
nit
test cases in drivers/gpu/drm/xe/tests/xe_dma_buf.c:

drivers/gpu/drm/xe/xe_dma_buf.c:xe_gem_prime_import() {
	...
	attach_ops =3D &xe_dma_buf_attach_ops;
#if IS_ENABLED(CONFIG_DRM_XE_KUNIT_TEST)
	if (test)
		attach_ops =3D test->attach_ops;
#endif

	attach =3D dma_buf_dynamic_attach(dma_buf, dev->dev, attach_ops, obj);
	...
}

Note that a later commit in the series, 77ea3fee521c ("dma-buf: Rename
dma_buf_dynamic_attach() to dma_buf_sgt_dynamic_attach()"), renames this
function while keeping the unconditional importer_ops->allow_peer2peer
dereference.

Should dma_buf_dynamic_attach() check importer_ops &&
importer_ops->allow_peer2peer before dereferencing importer_ops?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D3
