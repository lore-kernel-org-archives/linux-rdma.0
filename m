Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9A53909A6;
	Fri, 18 Sep 2026 12:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789733707; cv=none; b=dKoyRVtEk+Vk3ZkpV24WUKhP0rseuy4ERzdPBR2j8ovU1JOFyfqGjya1sTFMFJsf2ZExu5FU+zZIGM3SN8w3CF1n99uZQDIiCzW3d0uSe2XopNUthWFdBpA4+eH5vADsGioWgza7C9SVZE3mSnSG5dTXm0qHQiPZCoLCEmeb/74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789733707; c=relaxed/simple;
	bh=F1W0yb/pBICTbgkVH2INu9VOvJSl1gEVUZOoeEz7gY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZsw9DTa7gxIeTMAJQHkWREB63vOgh2VHKytunNShSfdgipi2L3Pwm0ijKjbFGPUkCkRnGWKmGC/eko0iOhdxLS4psyDZV+13bLETbfkJu4TqHTEqeKogk0zW6Krd2kIuvTAgUPpM+G8J/11Q+fVFXk5PXflZohK2KbQOkRh//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2Hvu22q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2Hvu22q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB791F000FF;
	Fri, 18 Sep 2026 12:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733705;
	bh=+8ouL8MHD3D1pD50ird+0r+dFeJQjvvbk3v4ZZQqqXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2Hvu22qiDsRKF2dKtyIxq/BuSR7nfYOOeG3+byXlyAoETgK9LqUOuJf3cPOxvCk9
	 ErhqPvZWMTU0HVQRHUlSoKCVv4TTd/UVGn9MIJc1m0h/cvb5JjTclY7E4W1i4QRSQ/
	 x9Owc28rL0PF6cQprfFCFa5XAjmbt/JpP7/o3PY2oA2uoLtlTjhBJX4HT1qwc7bwrp
	 GfkiEtJuhX0PazsalVk64Sr4JjlBI88Y/Upmbe8SPhLHlKOiZIbUJH+CqwwiJvZtAW
	 JO4jA67c801lRH5V6gEpMjNdTEf1tcR54d2kKhjbRRN2ELDKWA0IuNx68rVtOqC2mw
	 ooJwoi5T2fIhw==
Date: Fri, 18 Sep 2026 15:15:00 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
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
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a
 direct peer-to-peer route
Message-ID: <20260918121500.GV13683@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>

On Thu, Sep 17, 2026 at 03:56:12PM +0200, Thomas Hellström wrote:
> Hi
> 
> On Mon, 2026-09-14 at 14:22 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > mlx5_umem_needs_ats() enables ATS for any dma-buf whose caller asked
> > for
> > Relaxed Ordering, on the assumption that a switch in the path has CR,
> > RR
> > and DT all set. It also enables it for a buffer already mapped with
> > the
> > peer's bus addresses, which are not translatable at all.
> > 
> > P2PDMA has read the ACS controls, so ask it through
> > dma_buf_p2pdma_map_type(): enable ATS only where the path is not
> > routed
> > directly as it stands, but would be for a Translated Request whose
> > Completions carry Relaxed Ordering. Exporters that name no provider
> > keep
> > the old assumption, since their ACS settings remain hidden.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h | 36 ++------------------------
> > ------
> >  drivers/infiniband/hw/mlx5/mr.c      | 40
> > ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 42 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > index e9ddf2e97a76..ab32742b2180 100644
> > --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > @@ -1646,40 +1646,8 @@ static inline bool rt_supported(int ts_cap)
> >  	       ts_cap ==
> > MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
> >  }
> >  
> > -/*
> > - * PCI Peer to Peer is a trainwreck. If no switch is present then
> > things
> > - * sometimes work, depending on the pci_distance_p2p logic for
> > excluding broken
> > - * root complexes. However if a switch is present in the path, then
> > things get
> > - * really ugly depending on how the switch is setup. This table
> > assumes that the
> > - * root complex is strict and is validating that all req/reps are
> > matches
> > - * perfectly - so any scenario where it sees only half the
> > transaction is a
> > - * failure.
> > - *
> > - * CR/RR/DT  ATS RO P2P
> > - * 00X       X   X  OK
> > - * 010       X   X  fails (request is routed to root but root never
> > sees comp)
> > - * 011       0   X  fails (request is routed to root but root never
> > sees comp)
> > - * 011       1   X  OK
> > - * 10X       X   1  OK
> > - * 101       X   0  fails (completion is routed to root but root
> > didn't see req)
> > - * 110       X   0  SLOW
> > - * 111       0   0  SLOW
> > - * 111       1   0  fails (completion is routed to root but root
> > didn't see req)
> > - * 111       1   1  OK
> > - *
> > - * Unfortunately we cannot reliably know if a switch is present or
> > what the
> > - * CR/RR/DT ACS settings are, as in a VM that is all hidden. Assume
> > that
> > - * CR/RR/DT is 111 if the ATS cap is enabled and follow the last
> > three rows.
> > - *
> > - * For now assume if the umem is a dma_buf then it is P2P.
> > - */
> > -static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
> > -				       struct ib_umem *umem, int
> > access_flags)
> > -{
> > -	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
> > -		return false;
> > -	return access_flags & IB_ACCESS_RELAXED_ORDERING;
> > -}
> > +bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem
> > *umem,
> > +			 int access_flags);
> >  
> >  int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
> >  		  unsigned int index, const union ib_gid *gid,
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > b/drivers/infiniband/hw/mlx5/mr.c
> > index 00e13028762a..286f372e5b0c 100644
> > --- a/drivers/infiniband/hw/mlx5/mr.c
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -38,6 +38,7 @@
> >  #include <linux/export.h>
> >  #include <linux/delay.h>
> >  #include <linux/dma-buf.h>
> > +#include <linux/dma-buf-mapping.h>
> >  #include <linux/dma-resv.h>
> >  #include <rdma/frmr_pools.h>
> >  #include <rdma/ib_umem_odp.h>
> > @@ -47,6 +48,45 @@
> >  #include "data_direct.h"
> >  #include "dmah.h"
> >  
> > +MODULE_IMPORT_NS("DMA_BUF");
> > +
> > +bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem
> > *umem,
> > +			 int access_flags)
> > +{
> > +	struct dma_buf_attachment *attach;
> > +
> > +	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
> > +		return false;
> > +
> > +	/*
> > +	 * The Completer decides whether its Completions carry
> > Relaxed
> > +	 * Ordering, and only a Request that asked for it can expect
> > them to.
> > +	 */
> > +	if (!(access_flags & IB_ACCESS_RELAXED_ORDERING))
> > +		return false;
> > +
> > +	attach = to_ib_umem_dmabuf(umem)->attach;
> > +	switch (dma_buf_p2pdma_map_type(attach, 0)) {
> > +	case PCI_P2PDMA_MAP_NONE:
> > +		/* Nothing is known about the route, so fall back to
> > the bet. */
> > +		return true;
> > +	case PCI_P2PDMA_MAP_BUS_ADDR:
> > +		/*
> > +		 * The path is routed directly already and is
> > programmed with
> > +		 * the peer's bus addresses. Those are not
> > translatable, so
> > +		 * ATS would be wrong as well as pointless.
> > +		 */
> > +		return false;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return dma_buf_p2pdma_map_type(attach,
> > +				       PCI_P2PDMA_TLP_TRANSLATED |
> > +					      
> > PCI_P2PDMA_TLP_RELAXED_CPL) ==
> > +	       PCI_P2PDMA_MAP_BUS_ADDR;
> > +}
> > +
> 
> It looks like this works well when the device can choose whether to
> enable ATS per transaction. 
> 
> However, at least for the Intel GPUs, ATS enablement is based on the
> PCIe-side enable bit.
> 
> This means that if p2pdma tells the dma-mapping layer to give an Xe
> device a bus address rather than an IOVA, things break, while
> pci_p2pdma_distance says everything is OK.
> 
> It looks like the infrastructure and solution added in this series is
> targeted at fixing this on the device side by conditionally enabling
> ATS. However I think we need to look also at having the computed
> routing assume untranslated transactions using IOVA rather than bus
> address.
> 
> That is, a flag to tell the topology check that some transactions
> *will* take the host-bridge path due to IOVA being used, and that the
> computations including pci_p2pdma_distance() need to check whether that
> is possible (checking whitelist etc.) and return the corresponding
> THRU_HOST_BRIDGE mapping type. Translated transactions taking a short-
> cut using the bus-address would then be hidden from the driver.

The word *will* puzzles me. As I understand it, if your device has ATS
enabled all the time, it should always get THRU_HOST_BRIDGE.

In the mlx5 case, we can enable or disable ATS on the fly, but what does a
device with ATS enabled globally do for different mapping types? Do you
simply not use dma_buf_p2pdma_map_type() at all and continue to operate
as is?

I asked some questions my AI tool about XE:
------------------------------------------------------------------------------------------------
Xe needs THRU_HOST_BRIDGE even with ATS completely disabled. xe_ttm_vram_mgr_alloc_sgt()
maps VRAM with dma_map_resource() unconditionally (xe_ttm_vram_mgr.c:450) — an IOVA under
an IOMMU, never a bus address, with no ATS involvement at all. ATS only adds the possibility
that some of that traffic short-cuts invisibly. The actual requirement is “this caller cannot
program bus addresses”, which is true of Xe regardless of the ATS Enable bit.
-------------------------------------------------------------------------------------------------

Could you please clarify what the expected behavior is here? My series
does not change the existing behavior; it only reports the routing more
clearly for each TLP class.

Thanks

> 
> Whether that is best done as a parameter to these functions or perhaps
> as a flag in the PCI device, I'm not sure.
> 
> Thanks,
> Thomas
> 
> 
> 
> 
> >  static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
> >  {
> >  	if (MLX5_CAP_GEN(dev->mdev,
> > umr_extended_translation_offset))
