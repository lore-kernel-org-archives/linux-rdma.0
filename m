Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DDD443308;
	Fri, 11 Sep 2026 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122294; cv=none; b=U8KguMmm3ufLMWl7yG6mUd3v6M3LNONCkS4O7nbwaHsqqM1uIRFnR2ohjd6cesh3299Q11w9iDvmlyQYe8iuPSK8C03UBJ/DcStY/oZYjoAj3Mpgcq6xmuEM4lR95wHbpPixB8wWq9EIJ6i3pbloR71g9LbnybturFJiKINlnjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122294; c=relaxed/simple;
	bh=XCPLThBu3P2SukJrMurkLKsZkLi40Q5qkARJ8FMq1vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tv3do6EsamAbcHXr98OAng5FmPXg3ypwMRasGqY5sKIzL0nTHxK/Z24NdXq4N1Fvrrg1dukW0gS4dY2XBz4CIpVi4z3atcWwePUsxXrewzfitKoVJaqFBpzR01g+SFcvktPnwdwTUTlDtQmKRDsItLgldyUkJOU9FIASts35Feg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEvyQLuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEvyQLuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343251F000FF;
	Fri, 11 Sep 2026 10:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789122290;
	bh=FsDQkX5qVD1HL2Qoye/f9xNhSTkp7Bvx/JXzS/JYNzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PEvyQLuumFBeOUp0cGBCw8w+vJVhMcWC2mQyQ3rVvjjfjHKhZKhty6lG09J4CRP8B
	 P/tk4a/Vl3IGahLUYuudsQ7W77/9yESis9SErkTkb0/55ZoMwW/nGZaLcb0JiJ52fA
	 OKOBsV8thXmIeURnWnvn0cbDstmHIxH5cSVPxWwfmADZps0FOkkFGdbNz2bzLyv+mj
	 z2wu7BCCB0WVjH0yLjYjxJeFc4o29majX+vaJk3eE8FKwnS8EeAZp7p/VPezVpESNJ
	 sNpEBLddzx5nOrKNyp08kivpxwh7zkPhqc6gGFbAJNKIvAcFx7E+LpFkB2jLZF4STr
	 7E5u9/D+YAmdw==
Date: Fri, 11 Sep 2026 13:24:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	iommu@lists.linux.dev, Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v5 17/18] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
Message-ID: <20260911102446.GV13683@unreal>
References: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
 <20260910-fix-p2p-acs-v4-0-v5-17-856087f63c0d@nvidia.com>
 <7805bb89-2c46-46f6-9f15-8dce842d5ae5@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7805bb89-2c46-46f6-9f15-8dce842d5ae5@amd.com>

On Fri, Sep 11, 2026 at 09:51:48AM +0200, Christian König wrote:
> On 9/10/26 13:32, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Exporters keep the &struct p2pdma_provider in their own private data and
> > hand it to dma_buf_phys_vec_to_sgt() on every map. An importer cannot reach
> > it, so it has no way to learn how its own peer-to-peer traffic would be
> > routed before it programs its hardware.
> 
> Why should that be interesting to importers?
> 
> In general importers should just consome the data provided by a DMA-buf and don't participate in any way in the decision how that data is made available.

The importer does not control how traffic flows, but it needs to know how
to configure itself for optimal performance. In the mlx5 case, it needs to
enable or disable ATS depending on the location of the exporter's device.

Think of this as a hint propagated from the exporter to the importer.

Take a look at patch #18 and the old comment above mlx5_umem_needs_ats().
It explains when enabling ATS is beneficial and when it may hurt
performance.

>  
> > Publish the provider through &struct dma_buf_export_info instead,
> 
> That is a very bad idea and not even remotely acceptable.
> 
> This needs to be a callback instead if that should really fly.

The provider is a stable pointer that never changes during the dma-buf
lifetime, so it seemed natural to store it as-is. However, I can certainly
change this to use a callback instead.

Thanks

> 
> Regards,
> Christian.
> 
> > and add
> > dma_buf_p2pdma_map_type() for importers to query it by TLP class. It is
> > fixed at export time, so dma_buf_phys_vec_to_sgt() no longer needs it as an
> > argument and the two exporters no longer need a copy of it.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/dma-buf-mapping.c                 | 41 +++++++++++++++++++----
> >  drivers/dma-buf/dma-buf.c                         |  1 +
> >  drivers/infiniband/core/uverbs.h                  |  1 -
> >  drivers/infiniband/core/uverbs_std_types_dmabuf.c |  7 ++--
> >  drivers/vfio/pci/vfio_pci_dmabuf.c                |  8 ++---
> >  include/linux/dma-buf-mapping.h                   |  4 ++-
> >  include/linux/dma-buf.h                           |  5 +++
> >  7 files changed, 49 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> > index 794acff2546a..8b431000e906 100644
> > --- a/drivers/dma-buf/dma-buf-mapping.c
> > +++ b/drivers/dma-buf/dma-buf-mapping.c
> > @@ -6,6 +6,32 @@
> >  #include <linux/dma-buf-mapping.h>
> >  #include <linux/dma-resv.h>
> >  
> > +/**
> > + * dma_buf_p2pdma_map_type - How peer-to-peer traffic to a buffer is routed
> > + * @attach:	attachment of the importer that will issue the traffic
> > + * @tlp_flags:	&enum pci_p2pdma_tlp_flags describing the TLPs it will issue
> > + *
> > + * Reports how the PCIe fabric routes @tlp_flags traffic between the buffer
> > + * behind @attach and the importer attached to it, so that an importer can
> > + * choose the TLP attributes that earn it a direct route before it programs
> > + * its hardware.
> > + *
> > + * Return: the mapping type for @tlp_flags traffic, or PCI_P2PDMA_MAP_NONE
> > + * when the exporter named no &struct p2pdma_provider and nothing is known
> > + * about the route.
> > + */
> > +enum pci_p2pdma_map_type
> > +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> > +			unsigned int tlp_flags)
> > +{
> > +	if (!attach->dmabuf->provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> > +	return pci_p2pdma_map_type_tlp(attach->dmabuf->provider, attach->dev,
> > +				       tlp_flags);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(dma_buf_p2pdma_map_type, "DMA_BUF");
> > +
> >  static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> >  					 dma_addr_t addr)
> >  {
> > @@ -71,7 +97,6 @@ struct dma_buf_dma {
> >   * from arrays of physical vectors. This funciton is intended for MMIO memory
> >   * only.
> >   * @attach:	[in]	attachment whose scatterlist is to be returned
> > - * @provider:	[in]	p2pdma provider
> >   * @phys_vec:	[in]	array of physical vectors
> >   * @nr_ranges:	[in]	number of entries in phys_vec array
> >   * @size:	[in]	total size of phys_vec
> > @@ -85,16 +110,17 @@ struct dma_buf_dma {
> >   *
> >   * A mapping must be unmapped by using dma_buf_free_sgt().
> >   *
> > - * NOTE: This function is intended for exporters. If direct traffic routing is
> > - * mandatory exporter should call routing pci_p2pdma_map_type() before calling
> > - * this function.
> > + * NOTE: This function is intended for exporters, and works on MMIO memory
> > + * only, so &dma_buf.provider must have been set at export time. If direct
> > + * traffic routing is mandatory the exporter should call
> > + * pci_p2pdma_map_type() before calling this function.
> >   */
> >  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
> > -					 struct p2pdma_provider *provider,
> >  					 struct phys_vec *phys_vec,
> >  					 size_t nr_ranges, size_t size,
> >  					 enum dma_data_direction dir)
> >  {
> > +	struct p2pdma_provider *provider;
> >  	unsigned int nents, mapped_len = 0;
> >  	struct dma_buf_dma *dma;
> >  	struct scatterlist *sgl;
> > @@ -104,10 +130,11 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
> >  
> >  	dma_resv_assert_held(attach->dmabuf->resv);
> >  
> > -	if (WARN_ON(!attach || !attach->dmabuf || !provider))
> > -		/* This function is supposed to work on MMIO memory only */
> > +	if (WARN_ON(!attach || !attach->dmabuf || !attach->dmabuf->provider))
> >  		return ERR_PTR(-EINVAL);
> >  
> > +	provider = attach->dmabuf->provider;
> > +
> >  	dma = kzalloc_obj(*dma);
> >  	if (!dma)
> >  		return ERR_PTR(-ENOMEM);
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index d504c636dc29..c2b9944e9659 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -747,6 +747,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
> >  	dmabuf->size = exp_info->size;
> >  	dmabuf->exp_name = exp_info->exp_name;
> >  	dmabuf->owner = exp_info->owner;
> > +	dmabuf->provider = exp_info->provider;
> >  	spin_lock_init(&dmabuf->name_lock);
> >  	init_waitqueue_head(&dmabuf->poll);
> >  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
> > diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> > index c64dd6b94e10..fbdac18b69ca 100644
> > --- a/drivers/infiniband/core/uverbs.h
> > +++ b/drivers/infiniband/core/uverbs.h
> > @@ -139,7 +139,6 @@ struct ib_uverbs_dmabuf_file {
> >  	struct list_head dmabufs_elm;
> >  	struct rdma_user_mmap_entry *mmap_entry;
> >  	struct phys_vec phys_vec;
> > -	struct p2pdma_provider *provider;
> >  	struct kref kref;
> >  	struct completion comp;
> >  	u8 revoked :1;
> > diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> > index 2411ebee69e2..94d3719a34da 100644
> > --- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> > +++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> > @@ -33,9 +33,8 @@ uverbs_dmabuf_map(struct dma_buf_attachment *attachment,
> >  	if (priv->revoked)
> >  		return ERR_PTR(-ENODEV);
> >  
> > -	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
> > -				      &priv->phys_vec, 1, priv->phys_vec.len,
> > -				      dir);
> > +	ret = dma_buf_phys_vec_to_sgt(attachment, &priv->phys_vec, 1,
> > +				      priv->phys_vec.len, dir);
> >  	if (IS_ERR(ret))
> >  		return ret;
> >  
> > @@ -108,7 +107,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
> >  		return -EINVAL;
> >  
> >  	ret = ib_dev->ops.mmap_get_pfns(mmap_entry, &uverbs_dmabuf->phys_vec,
> > -					&uverbs_dmabuf->provider);
> > +					&exp_info.provider);
> >  	if (ret)
> >  		goto err;
> >  
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > index c16f460c01d6..10f47992e7f5 100644
> > --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > @@ -15,7 +15,6 @@ struct vfio_pci_dma_buf {
> >  	struct list_head dmabufs_elm;
> >  	size_t size;
> >  	struct phys_vec *phys_vec;
> > -	struct p2pdma_provider *provider;
> >  	u32 nr_ranges;
> >  	struct kref kref;
> >  	struct completion comp;
> > @@ -59,9 +58,8 @@ vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
> >  	if (priv->revoked)
> >  		return ERR_PTR(-ENODEV);
> >  
> > -	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
> > -				      priv->phys_vec, priv->nr_ranges,
> > -				      priv->size, dir);
> > +	ret = dma_buf_phys_vec_to_sgt(attachment, priv->phys_vec,
> > +				      priv->nr_ranges, priv->size, dir);
> >  	if (IS_ERR(ret))
> >  		return ret;
> >  
> > @@ -274,7 +272,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
> >  	priv->vdev = vdev;
> >  	priv->nr_ranges = get_dma_buf.nr_ranges;
> >  	priv->size = length;
> > -	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &priv->provider,
> > +	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &exp_info.provider,
> >  					     get_dma_buf.region_index,
> >  					     priv->phys_vec, dma_ranges,
> >  					     priv->nr_ranges);
> > diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
> > index 09bde3f748e4..d63ac4d52aa5 100644
> > --- a/include/linux/dma-buf-mapping.h
> > +++ b/include/linux/dma-buf-mapping.h
> > @@ -7,8 +7,10 @@
> >  #define __DMA_BUF_MAPPING_H__
> >  #include <linux/dma-buf.h>
> >  
> > +enum pci_p2pdma_map_type
> > +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> > +			unsigned int tlp_flags);
> >  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
> > -					 struct p2pdma_provider *provider,
> >  					 struct phys_vec *phys_vec,
> >  					 size_t nr_ranges, size_t size,
> >  					 enum dma_data_direction dir);
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index d1203da56fc5..81c136fcee6e 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -368,6 +368,9 @@ struct dma_buf {
> >  	/** @priv: exporter specific private data for this buffer object. */
> >  	void *priv;
> >  
> > +	/** @provider: The peer-to-peer provider backing this buffer. */
> > +	struct p2pdma_provider *provider;
> > +
> >  	/**
> >  	 * @resv:
> >  	 *
> > @@ -501,6 +504,7 @@ struct dma_buf_attachment {
> >   * @flags:	mode flags for the file
> >   * @resv:	reservation-object, NULL to allocate default one
> >   * @priv:	Attach private data of allocator to this buffer
> > + * @provider:	Peer-to-peer provider backing the buffer
> >   *
> >   * This structure holds the information required to export the buffer. Used
> >   * with dma_buf_export() only.
> > @@ -512,6 +516,7 @@ struct dma_buf_export_info {
> >  	size_t size;
> >  	int flags;
> >  	struct dma_resv *resv;
> > +	struct p2pdma_provider *provider;
> >  	void *priv;
> >  };
> >  
> > 
> 
