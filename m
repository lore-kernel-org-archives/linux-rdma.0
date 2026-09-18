Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C484F4CF3;
	Fri, 18 Sep 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789738965; cv=none; b=dF5MSMsiuFGhcUP+TTlxYvcu797fCi6hZqblrV4ZyH/pjdesEkU53Hi7Sg4yzzF1NTgMBotqgnXDOWHMUTY4kR0gMIbpxGQ6x+5Q7eiiypGzCQRHTDkN5u5ZjNAeVfuHRRhTHre/XRod8EQSksw1VJgl/sA0Uek8jYQJec0OzYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789738965; c=relaxed/simple;
	bh=0oiHFMwARjeya69GcpvyV541pBNfoR0D+boudpmmdkc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U5oXXZHWXi3T6hhodEV3axqiP2SKAa/JafxXKXQZ8LiHumpqkwKRsc3qO39osZW/lcscLEkUeFLgguijZci6E2/3mQj33lqDT11yBAf6ITlaVHHFBkY9NCmjozjHXFqSH/TlgvujJOFtKcoy3cO5YLqaQunEs/cLikLAr3q8D4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FzGRAyGZ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FzGRAyGZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789738962; x=1821274962;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0oiHFMwARjeya69GcpvyV541pBNfoR0D+boudpmmdkc=;
  b=FzGRAyGZT4dNMl9318MqJOyC6PavR9ICN8UEZG4lJhBJxY3LYdtCl+n1
   DAYYLyOsvGP4EnOzELLsolRHGPcb4JElegPEMXIaqFIQBUryQl1LXoBfl
   tppfx998Wu6cpyexOKV+IzYIyAbUUrqReBQDGnz9x88Q83gAq9vMiAdG/
   o85LxoBticOuLgHMJBW9Wsha8ZHXogilca6C+r5ad1eQo8xEvkifDjjBe
   gHFy5Apmpc9DDioj3o+EuUYWHL2/DHDx9Z+PpagXKQFPuFMOsQxzpy0qc
   Q9hhlKr0RYkpEXZV4eo5Bw2XXyETEsyWxzmmX5vn0RhpG+I5wAZie+Lo1
   g==;
X-CSE-ConnectionGUID: w+VdLg4YSGOGeyTCPi0Y3g==
X-CSE-MsgGUID: uoULOr0HQjC5e120A5NKuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11908"; a="89176889"
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="89176889"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 06:42:37 -0700
X-CSE-ConnectionGUID: nlw35IBKQbaMx6YJ5XUK1g==
X-CSE-MsgGUID: T2brE3rVRA+7nGvBdijE2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="2601666"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO [10.245.245.247]) ([10.245.245.247])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 06:42:31 -0700
Message-ID: <b517070d0b9236b03962fcba649faffcacda23eb.camel@linux.intel.com>
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a
 direct peer-to-peer route
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>,  Chaitanya Kulkarni	 <kch@nvidia.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe	 <axboe@kernel.dk>,
 Alex Williamson <alex@shazbot.org>, Ankit Agrawal	 <ankita@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet	 <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, "Joerg Roedel (AMD)"	 <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy	 <robin.murphy@arm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Sumit Semwal	 <sumit.semwal@linaro.org>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>,
 linux-pci@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,  Tushar Dave
 <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, 	linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org
Date: Fri, 18 Sep 2026 15:42:28 +0200
In-Reply-To: <20260918121500.GV13683@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
	 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
	 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
	 <20260918121500.GV13683@unreal>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,=C2=A0Leon,

On Fri, 2026-09-18 at 15:15 +0300, Leon Romanovsky wrote:
> On Thu, Sep 17, 2026 at 03:56:12PM +0200, Thomas Hellstr=C3=B6m wrote:
> > Hi
> >=20
> > On Mon, 2026-09-14 at 14:22 +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >=20
> > > mlx5_umem_needs_ats() enables ATS for any dma-buf whose caller
> > > asked
> > > for
> > > Relaxed Ordering, on the assumption that a switch in the path has
> > > CR,
> > > RR
> > > and DT all set. It also enables it for a buffer already mapped
> > > with
> > > the
> > > peer's bus addresses, which are not translatable at all.
> > >=20
> > > P2PDMA has read the ACS controls, so ask it through
> > > dma_buf_p2pdma_map_type(): enable ATS only where the path is not
> > > routed
> > > directly as it stands, but would be for a Translated Request
> > > whose
> > > Completions carry Relaxed Ordering. Exporters that name no
> > > provider
> > > keep
> > > the old assumption, since their ACS settings remain hidden.
> > >=20
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > > =C2=A0drivers/infiniband/hw/mlx5/mlx5_ib.h | 36 ++-------------------=
-
> > > ----
> > > ------
> > > =C2=A0drivers/infiniband/hw/mlx5/mr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 40
> > > ++++++++++++++++++++++++++++++++++++
> > > =C2=A02 files changed, 42 insertions(+), 34 deletions(-)
> > >=20
> > > diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > > b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > > index e9ddf2e97a76..ab32742b2180 100644
> > > --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > > +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > > @@ -1646,40 +1646,8 @@ static inline bool rt_supported(int
> > > ts_cap)
> > > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ts_cap =3D=3D
> > > MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
> > > =C2=A0}
> > > =C2=A0
> > > -/*
> > > - * PCI Peer to Peer is a trainwreck. If no switch is present
> > > then
> > > things
> > > - * sometimes work, depending on the pci_distance_p2p logic for
> > > excluding broken
> > > - * root complexes. However if a switch is present in the path,
> > > then
> > > things get
> > > - * really ugly depending on how the switch is setup. This table
> > > assumes that the
> > > - * root complex is strict and is validating that all req/reps
> > > are
> > > matches
> > > - * perfectly - so any scenario where it sees only half the
> > > transaction is a
> > > - * failure.
> > > - *
> > > - * CR/RR/DT=C2=A0 ATS RO P2P
> > > - * 00X=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 X=C2=A0=C2=A0 X=C2=A0 OK
> > > - * 010=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 X=C2=A0=C2=A0 X=C2=A0 fai=
ls (request is routed to root but root
> > > never
> > > sees comp)
> > > - * 011=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 X=C2=A0 fai=
ls (request is routed to root but root
> > > never
> > > sees comp)
> > > - * 011=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0 X=C2=A0 OK
> > > - * 10X=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 X=C2=A0=C2=A0 1=C2=A0 OK
> > > - * 101=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 X=C2=A0=C2=A0 0=C2=A0 fai=
ls (completion is routed to root but root
> > > didn't see req)
> > > - * 110=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 X=C2=A0=C2=A0 0=C2=A0 SLO=
W
> > > - * 111=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 0=C2=A0 SLO=
W
> > > - * 111=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0 0=C2=A0 fai=
ls (completion is routed to root but root
> > > didn't see req)
> > > - * 111=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0 1=C2=A0 OK
> > > - *
> > > - * Unfortunately we cannot reliably know if a switch is present
> > > or
> > > what the
> > > - * CR/RR/DT ACS settings are, as in a VM that is all hidden.
> > > Assume
> > > that
> > > - * CR/RR/DT is 111 if the ATS cap is enabled and follow the last
> > > three rows.
> > > - *
> > > - * For now assume if the umem is a dma_buf then it is P2P.
> > > - */
> > > -static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
> > > -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ib_umem *umem, int
> > > access_flags)
> > > -{
> > > -	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
> > > -		return false;
> > > -	return access_flags & IB_ACCESS_RELAXED_ORDERING;
> > > -}
> > > +bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem
> > > *umem,
> > > +			 int access_flags);
> > > =C2=A0
> > > =C2=A0int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
> > > =C2=A0		=C2=A0 unsigned int index, const union ib_gid *gid,
> > > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > > b/drivers/infiniband/hw/mlx5/mr.c
> > > index 00e13028762a..286f372e5b0c 100644
> > > --- a/drivers/infiniband/hw/mlx5/mr.c
> > > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > > @@ -38,6 +38,7 @@
> > > =C2=A0#include <linux/export.h>
> > > =C2=A0#include <linux/delay.h>
> > > =C2=A0#include <linux/dma-buf.h>
> > > +#include <linux/dma-buf-mapping.h>
> > > =C2=A0#include <linux/dma-resv.h>
> > > =C2=A0#include <rdma/frmr_pools.h>
> > > =C2=A0#include <rdma/ib_umem_odp.h>
> > > @@ -47,6 +48,45 @@
> > > =C2=A0#include "data_direct.h"
> > > =C2=A0#include "dmah.h"
> > > =C2=A0
> > > +MODULE_IMPORT_NS("DMA_BUF");
> > > +
> > > +bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem
> > > *umem,
> > > +			 int access_flags)
> > > +{
> > > +	struct dma_buf_attachment *attach;
> > > +
> > > +	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * The Completer decides whether its Completions carry
> > > Relaxed
> > > +	 * Ordering, and only a Request that asked for it can
> > > expect
> > > them to.
> > > +	 */
> > > +	if (!(access_flags & IB_ACCESS_RELAXED_ORDERING))
> > > +		return false;
> > > +
> > > +	attach =3D to_ib_umem_dmabuf(umem)->attach;
> > > +	switch (dma_buf_p2pdma_map_type(attach, 0)) {
> > > +	case PCI_P2PDMA_MAP_NONE:
> > > +		/* Nothing is known about the route, so fall
> > > back to
> > > the bet. */
> > > +		return true;
> > > +	case PCI_P2PDMA_MAP_BUS_ADDR:
> > > +		/*
> > > +		 * The path is routed directly already and is
> > > programmed with
> > > +		 * the peer's bus addresses. Those are not
> > > translatable, so
> > > +		 * ATS would be wrong as well as pointless.
> > > +		 */
> > > +		return false;
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> > > +	return dma_buf_p2pdma_map_type(attach,
> > > +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PCI_P2PDMA_TLP_TRANSLATED
> > > |
> > > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > PCI_P2PDMA_TLP_RELAXED_CPL) =3D=3D
> > > +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PCI_P2PDMA_MAP_BUS_ADDR;
> > > +}
> > > +
> >=20
> > It looks like this works well when the device can choose whether to
> > enable ATS per transaction.=20
> >=20
> > However, at least for the Intel GPUs, ATS enablement is based on
> > the
> > PCIe-side enable bit.
> >=20
> > This means that if p2pdma tells the dma-mapping layer to give an Xe
> > device a bus address rather than an IOVA, things break, while
> > pci_p2pdma_distance says everything is OK.
> >=20
> > It looks like the infrastructure and solution added in this series
> > is
> > targeted at fixing this on the device side by conditionally
> > enabling
> > ATS. However I think we need to look also at having the computed
> > routing assume untranslated transactions using IOVA rather than bus
> > address.
> >=20
> > That is, a flag to tell the topology check that some transactions
> > *will* take the host-bridge path due to IOVA being used, and that
> > the
> > computations including pci_p2pdma_distance() need to check whether
> > that
> > is possible (checking whitelist etc.) and return the corresponding
> > THRU_HOST_BRIDGE mapping type. Translated transactions taking a
> > short-
> > cut using the bus-address would then be hidden from the driver.
>=20
> The word *will* puzzles me. As I understand it, if your device has
> ATS
> enabled all the time, it should always get THRU_HOST_BRIDGE.
>=20
> In the mlx5 case, we can enable or disable ATS on the fly, but what
> does a
> device with ATS enabled globally do for different mapping types? Do
> you
> simply not use dma_buf_p2pdma_map_type() at all and continue to
> operate
> as is?
>=20
> I asked some questions my AI tool about XE:
> ---------------------------------------------------------------------
> ---------------------------
> Xe needs THRU_HOST_BRIDGE even with ATS completely disabled.
> xe_ttm_vram_mgr_alloc_sgt()
> maps VRAM with dma_map_resource() unconditionally
> (xe_ttm_vram_mgr.c:450) =E2=80=94 an IOVA under
> an IOMMU, never a bus address, with no ATS involvement at all. ATS
> only adds the possibility
> that some of that traffic short-cuts invisibly. The actual
> requirement is =E2=80=9Cthis caller cannot
> program bus addresses=E2=80=9D, which is true of Xe regardless of the ATS
> Enable bit.
> ---------------------------------------------------------------------
> ----------------------------
>=20
> Could you please clarify what the expected behavior is here? My
> series
> does not change the existing behavior; it only reports the routing
> more
> clearly for each TLP class.
>=20
> Thanks

So the *current* concerns are these (assuming I haven't misunderstood
the code).

1) Xe attachment check if pci_p2pdma_distance() returns OK for the
path. Then Xe always sets up dma-addresses using dma_map_resource(). If
IOMMU is enabled, that's always the IOMMU VAs. But if the host bridge
is not whitelisted, and pci_p2pdma_distance() has found a shortcut that
works using BUS_ADDR, then p2pdma is incorrectly enabled, and will be
routed using a non-supporting host bridge.

2) If an ATS on/off device (outside of dma-buf) were to map ZONE_DEVICE
pci_p2pdma pages using dma_map_sgtable(), then again the dma addresses
returned may be BUS_ADDR addresses, if the topology check finds a
direct path. But if ATS is on, then this also breaks down.

Now after your patch series, I tried to set up a patch for xe and ran
into the following:

1a) Let's say the importer (Xe) has ATS enabled, and the exporter is
supposed to map dma_addresses.
In between there is a switch that allows direct traffic.
Now with your patch series, How would the exporter know that Xe has ATS
enabled and therefore should return IOVA mappings rather than the BUS
addresses representing the shortcut.

2a) Does your patch series resolve that potential issue?

It seems to me that a pci-device settable flag "ATS always enabled"
should be enough to fix both issues?

Thanks,
Thomas


>=20
> >=20
> > Whether that is best done as a parameter to these functions or
> > perhaps
> > as a flag in the PCI device, I'm not sure.
> >=20
> > Thanks,
> > Thomas
> >=20
> >=20
> >=20
> >=20
> > > =C2=A0static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
> > > =C2=A0{
> > > =C2=A0	if (MLX5_CAP_GEN(dev->mdev,
> > > umr_extended_translation_offset))
