Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793003651;
	b=JYI0bUdHMo3XaG16OqPnJ0AVj9ozniKzbzfzNr773NDFMRkb3tS50gsxql2Gnxv7LSHm
	 TADsox34LwVZQU4ZfVzG/e3GcBUlv89Xb/f/C1oyPpVUB6mcmvwOnW9q5psE2TC70/6vH
	 26AU8sAv214QI/foJmu82TgB+AdKZBExNydp1ih5IIONVDj/+bjaFU9fYFQkXh4ltF7/2
	 3OESV1OSiV5xIoqyF+VD7UVtnM1xQFikSzJOZMQNiaO9dFvZLoBP3Nbi7fIvNEr7zwq/l
	 EqMhDQ7JQah0G9rBQpIfUWEvBzWY4IPpgbcvcG86OHeodIs6/CS68JfTYDIDA0E1ZXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003651;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kAbiiNjzGighimGOBoebuwLOO2yYrOrhwxWF9oqCztY=;
	b=0smKbCm0CJPmPWKpRT0AACfEvi7E4ETXR5OqrLUfAL1mFlzQ8Mlh8bIqkETbL5qwQF2G
	 Z3EV8Kl7k/DXWQdYy73ChD4Uf+oFsmFTYkTgYIppzN8KhldnmHR2U7NXBqtVHDYZrragn
	 EIXknExbfr3brN4suEU2T5y31N176C6ZBULBtQlkB38HgCqtZ2XVC4d/D3dUaLlcgRsI8
	 g/Yrom7DVOvEFV03jBjYhSVKylcSIa6XU3hTSJ5NY4g9005hIOIe7YV8f8b92+4WTyr3k
	 69S6MeiL3gC8xTMRLSxY3G25mEqxdZBPpUmfDcsh1b3GHs3KPn3ZTSo1nbAU584sHmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NpCOtOWP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB5E606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NpCOtOWP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3595C1F01825;
	Mon, 26 Oct 2026 08:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793003650;
	bh=kAbiiNjzGighimGOBoebuwLOO2yYrOrhwxWF9oqCztY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NpCOtOWPkyXyU0mjkvK6+ge5mRr1Fc2/b/3BbtzO7j2L5VYtFTB1HcUokZ8ZXlamx
	 ojU9EuzalrNkxvCBzgxgFVDOltmtmT8x83oBaNej8ZW47b1VFzTUNWgHCRHHfMt/My
	 6sNYOB7xwlwsqGAar/5VKMlAf2sVkEbx7MHwCDbP/5LBV480YHuQ9UBVbPrRgPLIDV
	 8UDKXNoFj0on1eCy5uDu5ubreo4j7JSBkbumqwoq0106CPwe5Mg7+i+qbCMjoIeTxW
	 B4InmJou7aF4YvXNffuQqb+Ufs2NzrUyWJ4VhLqtriJ0bsOUYETUHB6NVZtzuPkCqw
	 9qN51AvQQv96Q==
Message-ID: <sashiko-outbox-184673@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/26] drm/xe/dma-buf: Use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261026053623.202642-14-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-14-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:34:09 +0000
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
- [Medium] drm/xe/dma-buf: xe_dma_buf_match_mapping() changes attach error =
to -EINVAL
- [Medium] drm/xe: verbose pci_p2pdma_distance() check in xe_dma_buf_match_=
mapping()
--

commit d3c9a19b80db02efc0ef1143d9205eb0a3c2194e
Author: Jason Gunthorpe <jgg@ziepe.ca>

drm/xe/dma-buf: Use the SGT mapping type

This commit converts the Xe dma-buf exporter to use the new SGT mapping type
infrastructure by providing P2P and non-P2P SGT exporter matches in
xe_dma_buf_match_mapping() and querying attachment mapping helpers during p=
in,
map, and unmap.

> diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_=
buf.c
> index bf0728838ead5..3ca198da6ee87 100644
> --- a/drivers/gpu/drm/xe/xe_dma_buf.c
> +++ b/drivers/gpu/drm/xe/xe_dma_buf.c
> @@ -27,13 +27,6 @@ static int xe_dma_buf_attach(struct dma_buf *dmabuf,
>  {
>  	struct drm_gem_object *obj =3D attach->dmabuf->priv;
> =20
> -	if (attach->peer2peer &&
> -	    pci_p2pdma_distance(to_pci_dev(obj->dev->dev), attach->dev, false) =
< 0)
> -		attach->peer2peer =3D false;
> -
> -	if (!attach->peer2peer && !xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_T=
T))
> -		return -EOPNOTSUPP;
> -
>  	xe_pm_runtime_get(to_xe_device(obj->dev));
>  	return 0;
>  }

[ ... ]

> @@ -205,18 +205,38 @@ static void xe_dma_buf_release(struct dma_buf *dmab=
uf)
>  	drm_gem_dmabuf_release(dmabuf);
>  }
> =20
> +static const struct dma_buf_mapping_sgt_exp_ops xe_dma_buf_sgt_ops =3D {
> +	.map_dma_buf =3D xe_dma_buf_map,
> +	.unmap_dma_buf =3D xe_dma_buf_unmap,
> +};
> +
> +static int xe_dma_buf_match_mapping(struct dma_buf_match_args *args)
> +{
> +	struct drm_gem_object *obj =3D args->dmabuf->priv;
> +	struct dma_buf_mapping_match sgt_match[2];
> +	unsigned int num_match =3D 0;
> +
> +	sgt_match[num_match++] =3D DMA_BUF_EMAPPING_SGT_P2P(
> +		&xe_dma_buf_sgt_ops, to_pci_dev(obj->dev->dev));

[Severity: Medium]
Will offering DMA_BUF_EMAPPING_SGT_P2P() unconditionally first cause spurio=
us
pci_warn() and dev_warn() messages in dmesg when attaching migratable or
system-memory-only BOs on systems without PCIe P2P support?

Previously, xe_dma_buf_attach() called pci_p2pdma_distance() with verbose s=
et
to false because P2P is optional when a BO resides in or can migrate to
XE_PL_TT (similar to commit d0fa84f17477 ("drm/amdgpu: Disable verbose for =
p2p
dist calc")).

With this change, dma_buf_match_mapping() evaluates sgt_match[0] first via
dma_buf_sgt_match(), which calls pci_p2pdma_distance() with verbose set to
true:

drivers/dma-buf/dma-buf-mapping.c:dma_buf_sgt_match() {
	if (exp->sgt_data.exporter_requires_p2p =3D=3D
	    DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE) {
		if (!imp->sgt_data.importer_allows_p2p)
			return -EOPNOTSUPP;
		if (pci_p2pdma_distance(exp->sgt_data.exporting_p2p_device,
					imp->sgt_data.importing_dma_device,
					true) < 0)
			return -EOPNOTSUPP;
	}
}

Whenever a P2P-capable importer attaches to an exported Xe dma-buf on a
platform where P2P is unavailable (such as a non-PCI importer, non-whitelis=
ted
host bridge, or ACS redirect on PCIe switches), calc_map_type_and_dist() wi=
ll
log a warning even though sgt_match[1] (DMA_BUF_EMAPPING_SGT) immediately
succeeds using system memory, or even when the BO was created as
system-memory-only.

> +
> +	if (xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_TT))
> +		sgt_match[num_match++] =3D
> +			DMA_BUF_EMAPPING_SGT(&xe_dma_buf_sgt_ops);
> +
> +	return dma_buf_match_mapping(args, sgt_match, num_match);
> +}

[Severity: Medium]
Does replacing the check in xe_dma_buf_attach() with dma_buf_match_mapping()
change the attach error code from -EOPNOTSUPP to -EINVAL and break the Xe
dma-buf KUnit test suite?

When exporting a non-migratable VRAM-only BO (where xe_bo_can_migrate(bo,
XE_PL_TT) is false) and attaching or importing it from an importer that does
not support P2P (or where pci_p2pdma_distance() < 0), xe_dma_buf_attach()
previously returned -EOPNOTSUPP.

Now, xe_dma_buf_match_mapping() only populates sgt_match[0] with
DMA_BUF_EMAPPING_SGT_P2P() and calls dma_buf_match_mapping(). In
drivers/dma-buf/dma-buf-mapping.c:dma_buf_match_mapping(), -EOPNOTSUPP from
exp->type->match() is skipped, and -EINVAL is returned when no matches rema=
in:

drivers/dma-buf/dma-buf-mapping.c:dma_buf_match_mapping() {
			if (exp->type->match) {
				ret =3D exp->type->match(args->dmabuf, exp, imp);
				if (ret =3D=3D -EOPNOTSUPP)
					continue;
				if (ret !=3D 0)
					return ret;
			}
...
	if (!nr)
		return -EINVAL;
}

In drivers/gpu/drm/xe/tests/xe_dma_buf.c:xe_test_dmabuf_import_same_driver(=
),
the KUnit test explicitly checks for -EOPNOTSUPP on import failure of a
non-migratable VRAM BO without P2P:

	} else if (PTR_ERR(import) !=3D -EOPNOTSUPP) {
		/* Unexpected error code. */
		KUNIT_FAIL(test,
			   "xe_gem_prime_import failed with the wrong err=3D%ld\n",
			   PTR_ERR(import));

Should this path still return -EOPNOTSUPP when no mapping matches?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D13
