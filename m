Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7450C3BCD29;
	Tue, 15 Sep 2026 06:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453433; cv=none; b=aA+XyN8zs11FeeRPgmcVSLZQphjcBqvBwa5HsSvJ5EPtyfOa8rHMgEWwNzyS0JqPaaGfWTnmo5v5UmS3uWsVsfqg7fnf7HF3airw6LvUaKdqMe8mVppYWazFwmaYf96qpzpnpnfQFtlPlMYdefW31f8j7MOd5Kn/w/bWhat+vUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453433; c=relaxed/simple;
	bh=XeX+dvp7tsF7D8D0PVBjBSRr+LI+y8EIC2pK+2exL7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxdSft4p3ZRCEh6+uQOyCOWePSc++hAQqu6AFjTzT0WR0IEYHOI8+/3D9lEz02hHgPXzHetnMhvSJnxCBbnkYEe8cemHJQEBDqyqQQ2iy7RiLaP5P0qOyo8EaSxiGmPmFSWbyqE3tlW9RivzAFTUWhugFziV4J1znBVLcHqASlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfuZbgmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfuZbgmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A03D1F000FF;
	Tue, 15 Sep 2026 06:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789453431;
	bh=yFrOVJsHwITVaC+EbmE+b+kEEDebikU4bCK/widGiTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jfuZbgmGmL829y0T2VYwsjo2R5rUeGwtRAHpEXCcba95Xh4sZNi38OO0ai3fF9iCe
	 bA0nk+ujyWAKurkAr7Aq3pYcTD1SBL8IzcGQrhMudUPLK0X4AVl0M9YNyEObBuz8Lt
	 qv+lKfu/acLdq0xX58C/Vvo95T9cnHjnDFe3LYzqVMd//60+SAONDMh1AnRY4F8CVp
	 Smqa2Wx6OQ+XDRvGexhN4vMl8GWtXK/Lg4jkebMnqNjLso4nGZgmfjn6w3HKKgf263
	 SyOijns18PybdKDZ4pqqKNBiJyVzeYIBe7ebVvhNFZ4qYT071or95G7gwBhMOBztnM
	 gdMowTS8N94fg==
Date: Tue, 15 Sep 2026 09:23:47 +0300
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
Subject: Re: [PATCH v6 17/18] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
Message-ID: <20260915062347.GB13683@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-17-5ef07ec9ef06@nvidia.com>
 <d3fb7ea0-019f-4311-bf0f-00d25bdebda0@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3fb7ea0-019f-4311-bf0f-00d25bdebda0@amd.com>

On Mon, Sep 14, 2026 at 04:27:00PM +0200, Christian König wrote:
> On 9/14/26 13:22, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Exporters keep the &struct p2pdma_provider backing a buffer in their own
> > private data. An importer cannot reach it, so it has no way to learn how
> > its own peer-to-peer traffic would be routed before it programs its
> > hardware.
> > 
> > Add an optional @p2pdma_provider callback for an exporter to hand that
> > provider out, and dma_buf_p2pdma_map_type() for an importer to ask by TLP
> > class. Exporters keep the provider where it already lives, so this adds an
> > operation rather than changing any existing signature or structure.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/dma-buf-mapping.c                 | 32 +++++++++++++++++++++++
> >  drivers/infiniband/core/uverbs_std_types_dmabuf.c | 12 +++++++++
> >  drivers/vfio/pci/vfio_pci_dmabuf.c                | 12 +++++++++
> >  include/linux/dma-buf-mapping.h                   |  3 +++
> >  include/linux/dma-buf.h                           | 17 ++++++++++++
> >  5 files changed, 76 insertions(+)
> > 
> > diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> > index 794acff2546a..fb03a698b381 100644
> > --- a/drivers/dma-buf/dma-buf-mapping.c
> > +++ b/drivers/dma-buf/dma-buf-mapping.c
> > @@ -6,6 +6,38 @@
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
> > + * when the exporter names no &struct p2pdma_provider and nothing is known
> > + * about the route.
> > + */
> > +enum pci_p2pdma_map_type
> > +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> > +			unsigned int tlp_flags)
> > +{
> > +	struct dma_buf *dmabuf = attach->dmabuf;
> > +	struct p2pdma_provider *provider;
> > +
> > +	if (!dmabuf->ops->p2pdma_provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> > +	provider = dmabuf->ops->p2pdma_provider(dmabuf);
> > +	if (!provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> > +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
> 
> Calling PCI subsystem functions from dma-buf is a hard NO-GO.

There are two main reasons for this design:

1. DMA-buf's broken use of scatter-gather lists.
2. Hellwig's NAK on exporting low-level PCI P2P functions. These should be
   used by core code, while in-kernel exporters and importers may be built
   as modules and therefore need EXPORT_SYMBOL() to access PCI P2P
   functionality.

> 
> Then wrappers for DMA-buf backend functions should be in dma-buf.c and not here.
> 
> I shouldn't have allowed the mapping functions to be added to DMA-buf in the first place, all of this belongs either into the DMA layer or the exporter.

Due to item #2, they cannot be in the exporters. Ideally, the DMA layer
should not have PCI-specific paths.

> 
> We should probably have a single callback the exporter provides to fill in a structure with PCI specific information for a mapping.

If you have an idea how to do this without adding EXPORT_SYMBOL to p2p,
let me know and I will implement it.

DMA-buf is the de facto mechanism for setting up and using p2p between
devices. There is no other mechanism (except NVMe which is unique)
in the kernel to achieve this. IMHO, the dmabuf code should try to implement
as much of the common functionality as possible, so that dmabuf consumers
do not have to reinvent their own p2p implementations.

> 

<...>

> > +
> >  static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
> >  	.attach = vfio_pci_dma_buf_attach,
> >  	.map_dma_buf = vfio_pci_dma_buf_map,
> >  	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
> >  	.release = vfio_pci_dma_buf_release,
> > +	.p2pdma_provider = vfio_pci_dma_buf_provider,
> 
> Please split up the patch into the actual DMA-buf changes, exporter changes and importer changes.

Sure, will do.

Thanks
