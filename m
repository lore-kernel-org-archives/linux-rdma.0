Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005228;
	b=z9ydv8ze3p+kbDjXbcAAhVU9p8X4YY9jfDAmoNtjOE1Pc54/SsHDe2rXAzcAQIha70oD
	 s2TY9K7xoVExRSwR6v+iCVAjt6RdVu521Wy5wufWKZeqshbw5ZItEru0nF3WiXua7yM/w
	 uqESGc9LTFhVEB+GLNeMzuzKzR3KrbiDwRIRldi9x1E4Cop3kbmf1wZKdGtbUbf+KVnwr
	 tKEAafmYRGj8WwAUT4PGLs8h+gNTvaTk4O0zDl10YldxPaqV2kTWOwn2zkWP6BVsA3GdI
	 YrC1kbP29BmkgQWOBYk4I3GZTICcky1yyict5B+inI2cimEvOdRsqYc8iJCM9kG4Yrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Xg9/KcGYBcGtgInejmZU4ytemTtqf/sGHcPNxqZ/CM4=;
	b=GnGGYiiXLaX//kFyEtY4BaqE6zcea0LfnGUCWC4Z32aniblH//cNSC5Q92JpdC+5vCw2
	 Od1GEVI0lsMCmlvYjk+Y0qZWKtwq2nqzDRd6H1r/bzDilNdapJ5/z00NScJZ1PJnBnNUS
	 z8F4dTc0snwzRyJuy3AMSQSpqExXTlBRiriR7EGT5tX+t3mipAzrho2gj7xEyZfyoH6Bm
	 i1MXnwLGPXmEtfJ2ypZmpCwjWceOQZIpnckR+gaIT5Z/FfsAWjbbCTXZsPt3Wg0ab2t1B
	 3hcm28nlw2Q8jJWZhhfq6EFuyAEbweEE+PtbhI1WqGz6SdsQAdAyw2G/I1b3QtJwaEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHhsGeKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F932606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHhsGeKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C231F01825;
	Mon, 26 Oct 2026 09:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005228;
	bh=Xg9/KcGYBcGtgInejmZU4ytemTtqf/sGHcPNxqZ/CM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QHhsGeKwI+LIDag9S9C4tASaUriI1p0Xq0fLQrD24zWBH4qnhe46fmYyJ92K3YM8r
	 wPTFx2C93EzPjuY3GH//43XAwFIW9R4dzTs09oNkEmZRyYiqaFGcuTvJQYp+IfHPet
	 WumxUMO0AbVnwO4OoFKlLZLDrRTena3W10/nME3ecJA2ArshQN43QVyu1+blVC3MTm
	 fdBR34jJJNQHPCXaFkt6LbOHIdRVaViBYZUfXtvDuLLz0yKHWywIEkxg+m6VSemWDe
	 h0kmgl6bAexkJzuNMAzKe5F0zUJsVdAmciRYBqXisJ2pAra/C4sTTaNbZlL8PlwgpH
	 JapKkeuxTvXnw==
Message-ID: <sashiko-outbox-184718@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/26] vfio/pci: Change the DMA-buf exporter to use
 mapping_type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261026053623.202642-16-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-16-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:00:27 +0000
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
- [High] vfio/pci: vfio_pci_dma_buf_match_mapping() breaks iopt_map_dmabuf(=
) attach
- [High] vfio/pci: UAF on pdev->p2pdma in vfio_pci_dma_buf_match_mapping()
--

commit 9770a3eb805c4984c35cbfef83d18657c914f9b0
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio/pci: Change the DMA-buf exporter to use mapping_type

This commit converts the VFIO PCI DMA-buf exporter to implement a
match_mapping() callback offering an SGT P2P mapping type and replaces the
attachment->peer2peer check in vfio_pci_dma_buf_attach(). It also holds a
pci_dev reference in struct vfio_pci_dma_buf for the lifetime of the
dma-buf to pass to DMA_BUF_EMAPPING_SGT_P2P().

> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_p=
ci_dmabuf.c
> index c16f460c01d68..58e771309c5f6 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c

[ ... ]

> @@ -95,15 +93,31 @@ static void vfio_pci_dma_buf_release(struct dma_buf *=
dmabuf)
>  		up_write(&priv->vdev->memory_lock);
>  		vfio_device_put_registration(&priv->vdev->vdev);
>  	}
> +	pci_dev_put(priv->pdev);
>  	kfree(priv->phys_vec);
>  	kfree(priv);
>  }
> =20
> -static const struct dma_buf_ops vfio_pci_dmabuf_ops =3D {
> -	.attach =3D vfio_pci_dma_buf_attach,
> +static const struct dma_buf_mapping_sgt_exp_ops vfio_pci_dma_buf_sgt_ops=
 =3D {
>  	.map_dma_buf =3D vfio_pci_dma_buf_map,
>  	.unmap_dma_buf =3D vfio_pci_dma_buf_unmap,
> +};
> +
> +static int vfio_pci_dma_buf_match_mapping(struct dma_buf_match_args *arg=
s)
> +{
> +	struct vfio_pci_dma_buf *priv =3D args->dmabuf->priv;
> +	struct dma_buf_mapping_match sgt_match[1];
> +
> +	sgt_match[0] =3D DMA_BUF_EMAPPING_SGT_P2P(&vfio_pci_dma_buf_sgt_ops,
> +						priv->pdev);

[Severity: High]
Does offering only DMA_BUF_EMAPPING_SGT_P2P() here break iommufd mapping of
VFIO PCI dma-bufs via iopt_map_dmabuf()?

When userspace maps a VFIO PCI dma-buf through iommufd, iopt_map_dmabuf()
in drivers/iommu/iommufd/pages.c attaches using iommufd_global_device()
before calling sym_vfio_pci_dma_buf_iommufd_map():

drivers/iommu/iommufd/pages.c:iopt_map_dmabuf()
	attach =3D dma_buf_dynamic_attach(dmabuf, iommufd_global_device(),
					&iopt_dmabuf_attach_revoke_ops, pages);
	if (IS_ERR(attach))
		return PTR_ERR(attach);
	...
	rc =3D sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);

where iommufd_global_device() in drivers/iommu/iommufd/main.c returns
iommu_misc_dev.this_device, a miscdevice with no parent pci_dev.

With DMA_BUF_EMAPPING_SGT_P2P(), dma_buf_dynamic_attach() runs:

  dma_buf_mapping_attach()
    -> vfio_pci_dma_buf_match_mapping()
      -> dma_buf_match_mapping()
        -> dma_buf_sgt_match()
          -> pci_p2pdma_distance(priv->pdev, iommufd_global_device(), true)
            -> pci_p2pdma_distance_many()

In drivers/pci/p2pdma.c:pci_p2pdma_distance_many(), find_parent_pci_dev()
returns NULL for iommufd_global_device():

	for (i =3D 0; i < num_clients; i++) {
		pci_client =3D find_parent_pci_dev(clients[i]);
		if (!pci_client) {
			if (verbose)
				dev_warn(clients[i],
					 "cannot be used for peer-to-peer DMA as it is not a PCI device\n");
			return -1;
		}

This emits a dev_warn() and returns -1, causing dma_buf_sgt_match() to
return -EOPNOTSUPP and dma_buf_match_mapping() to fail with -EINVAL before
sym_vfio_pci_dma_buf_iommufd_map() can be reached.

> +
> +	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
> +}

[Severity: High]
Can passing priv->pdev to DMA_BUF_EMAPPING_SGT_P2P() in
vfio_pci_dma_buf_match_mapping() race with driver unbind and trigger a
use-after-free on pdev->p2pdma?

When the VFIO device is closed while the exported dma-buf fd remains open,
vfio_pci_dma_buf_cleanup() revokes the dma-buf and drops the vfio_device
registration reference:

drivers/vfio/pci/vfio_pci_dmabuf.c:vfio_pci_dma_buf_cleanup()
	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
		if (!get_file_active(&priv->dmabuf->file))
			continue;

		list_del_init(&priv->dmabufs_elm);
		priv->vdev =3D NULL;
		vfio_device_put_registration(&vdev->vdev);
		fput(priv->dmabuf->file);
	}

Once vfio_device_put_registration() drops that reference, nothing pins the
driver binding on priv->pdev (pci_dev_get() only pins struct pci_dev, not
devres). Unbinding vfio-pci runs devres_release_all(), which invokes
pci_p2pdma_release() and frees the devm_kzalloc()-allocated struct
pci_p2pdma:

drivers/pci/p2pdma.c:pci_p2pdma_release()
	/* Flush and disable pci_alloc_p2p_mem() */
	pdev->p2pdma =3D NULL;
	if (p2pdma->pool)
		synchronize_rcu();
	xa_destroy(&p2pdma->map_types);

Because vfio_pci_core_init_dev() only calls pcim_p2pdma_init() and never
allocates p2pdma->pool via pci_p2pdma_add_resource(), p2pdma->pool is NULL.
As a result, pci_p2pdma_release() skips synchronize_rcu(), immediately
calls xa_destroy(&p2pdma->map_types), and devres frees p2pdma.

Concurrently, if an importer attaches to the open dma-buf fd,
dma_buf_mapping_attach() calls vfio_pci_dma_buf_match_mapping() before
vfio_pci_dma_buf_attach() checks priv->revoked:

  dma_buf_mapping_attach()
    -> vfio_pci_dma_buf_match_mapping()
      -> dma_buf_match_mapping()
        -> dma_buf_sgt_match()
          -> pci_p2pdma_distance()
            -> pci_p2pdma_distance_many()
              -> calc_map_type_and_dist()

In drivers/pci/p2pdma.c:calc_map_type_and_dist():

	rcu_read_lock();
	p2pdma =3D rcu_dereference(provider->p2pdma);
	if (p2pdma)
		xa_store(&p2pdma->map_types, map_types_idx(client),
			 xa_mk_value(map_type), GFP_ATOMIC);
	rcu_read_unlock();

Without synchronize_rcu() in pci_p2pdma_release(), calc_map_type_and_dist()
can load a non-NULL p2pdma pointer just before pdev->p2pdma is cleared and
call xa_store(&p2pdma->map_types, ...) concurrently with xa_destroy() and
after p2pdma has been freed by devres.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D15
