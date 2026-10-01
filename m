Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F54A206E;
	Thu,  1 Oct 2026 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790842328; cv=none; b=lw7bM0P/eSd/Pr119gHD5eVq+SYGBGxcC5ZugL0yx2Izm6Yr/SN16H9ERLhMxG07gsVghofEKi2eY65y88kuGOEGaS9Y8B+cZSgyBJf+7xh599fcIftop0BHmN//dWJnjxKH4etoBrpox8xuMcQfEG8M6+AcRRqUGlVQ/PQrV70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790842328; c=relaxed/simple;
	bh=51A+0uGzwTXigzlmR2tcEbHZm+8G4JffQQe6Pb6jmvI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jVSNibcZOKjk90e4/OwgB1prZRL1qMSV/HLO0FGD03/W1N5eeMM/vVh0Sd48eMJIvWz6O5GdpDxOxw1JjYryNjvC54KKOK2UG2V1Moy39rn7+n5YZhDQlVar6jzXIgf9noFWr2UIO1UsqiNYNWBzsI9abLc+iQeXJc5kz4g/X8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LIGfd8vW; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LIGfd8vW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790842325; x=1822378325;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=51A+0uGzwTXigzlmR2tcEbHZm+8G4JffQQe6Pb6jmvI=;
  b=LIGfd8vWjjz7fO/xiyelABuOPIwXAgQNXzEDGwoyoiJ97U0mPjG6/Gm9
   hpYyQxnBIaNgj+KwGHau8MxKJcRZg10u04uWr5AliumxfveRRmeyU53eK
   eayEB15P+FHM6oOIa/qEvw8McAho7i+qiVYo9nuwzLt02zR7kOy6MMPLj
   tEEppPi6Mc85Icwtsj2eD3Trrw254s1xCYyWJ+TNW1lqsaCB/rhgllylu
   tD+DPeZ9/tq1G7nvc9bRmv8R4+X4IROa9P3B6YR1OaFPkYy0eFHU7ih5d
   7IXBohm7iSK7xn0WbZEjfeN9F2InXQR6M3uVqAWMULQu1PtmZBA6ZQsNm
   g==;
X-CSE-ConnectionGUID: Psy12l9OScCVY1B03Oo2YQ==
X-CSE-MsgGUID: FoxiiEzyS8uoT76F0fB8Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90359163"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90359163"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 01:12:00 -0700
X-CSE-ConnectionGUID: HwuLrs5LTRKMghWlxeiDhw==
X-CSE-MsgGUID: jwpBUmWqQJ6IyoRCXZ55Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="303866842"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO [10.245.244.16]) ([10.245.244.16])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 01:11:54 -0700
Message-ID: <044e3316569c030a224625151bd80a7333fc2b79.camel@linux.intel.com>
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  "Joerg Roedel (AMD)"	 <joro@8bytes.org>, Will
 Deacon <will@kernel.org>, Robin Murphy	 <robin.murphy@arm.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, iommu@lists.linux.dev, Tushar Dave
 <tdave@nvidia.com>, 	linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, 	linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org,  Chaitanya Kulkarni	
 <kch@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens
 Axboe	 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>, Ankit Agrawal
	 <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan	
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Sumit
 Semwal	 <sumit.semwal@linaro.org>
Date: Thu, 01 Oct 2026 10:11:51 +0200
In-Reply-To: <20261001063747.GK3401365@unreal>
References: <20260929132305.GJ563127@unreal>
	 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
	 <20260929175737.GK563127@unreal>
	 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
	 <20260930081832.GA3401365@unreal>
	 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
	 <20260930114356.GC3401365@unreal>
	 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
	 <20260930143237.GI3401365@unreal>
	 <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>
	 <20261001063747.GK3401365@unreal>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-10-01 at 09:37 +0300, Leon Romanovsky wrote:
> On Wed, Sep 30, 2026 at 04:57:04PM +0200, Thomas Hellstr=C3=B6m wrote:
> > On Wed, 2026-09-30 at 17:32 +0300, Leon Romanovsky wrote:
> > > On Wed, Sep 30, 2026 at 01:52:39PM +0200, Christian K=C3=B6nig wrote:
> > > > On 9/30/26 13:43, Leon Romanovsky wrote:
> > > > > On Wed, Sep 30, 2026 at 10:34:56AM +0200, Christian K=C3=B6nig
> > > > > wrote:
> > > > > > On 9/30/26 10:18, Leon Romanovsky wrote:
> > > > ...
> > > > > > >=20
> > > > > > > At a minimum, exporters need to pass `p2pdma_provider`.
> > > > > >=20
> > > > > > No, exactly that is a no-go. The neither the framework nor
> > > > > > the
> > > > > > importer should see the p2pdma_provider.
> > > > > >=20
> > > > > > Only fully translated addresses where the DMA access should
> > > > > > happen.
> > > > > >=20
> > > > > > >=20
> > > > > > > If I keep the =E2=80=9Cdma-buf: Let exporters hand out the P2=
PDMA
> > > > > > > provider behind a
> > > > > > > buffer=E2=80=9D patch, I can move the P2P TLP types back into
> > > > > > > `p2pdma.c` and export
> > > > > > > only the function that indicates whether ATS is required.
> > > > > > >=20
> > > > > > > Is it ok?
> > > > > >=20
> > > > > > What you can do is to forward declare enum
> > > > > > pci_p2pdma_map_type
> > > > > > and than pass that 1 to 1 from the exporter to the
> > > > > > importer.
> > > > >=20
> > > > > Unfortunately, neither suggestion applies to RDMA NICs. They
> > > > > need
> > > > > to know,
> > > > > before mapping addresses, whether to create the memory region
> > > > > with ATS
> > > > > enabled.
> > > >=20
> > > > The design principle here is that the final location and access
> > > > path of the data isn't determined when the buffer is created.
> > > >=20
> > > > The importer first need to attach before it can query such
> > > > information from the exporter.
> > >=20
> > > In attach yes, this is why importer digs in dma_buf ops to get
> > > p2pdma_provide, however it is before addresses are known.
> > >=20
> > > > > The importer needs a way to obtain device information from
> > > > > the
> > > > > exporter so
> > > > > that it can configure itself correctly.
> > > >=20
> > > > That won't work with DMA-buf then, the exporter is completely
> > > > opaque to the importer and that is for really good reasons.
> > > >=20
> > > > Why in the world does the importer needs to know the
> > > > information
> > > > from the exporter before the mapping is created?
> > > >=20
> > > > It is the exporter who decides how data is accessed by the
> > > > importer
> > > > and not the other way around.
> > >=20
> > > There are several reasons:
> > >=20
> > > 1. This is how DMA-BUF MRs are built in RDMA. In mlx5, they rely
> > > on
> > > the ODP
> > > =C2=A0=C2=A0 mechanism, which requires an MKEY to be created first. S=
ee
> > > commit
> > > =C2=A0=C2=A0 90da7dc8206a (=E2=80=9CRDMA/mlx5: Support dma-buf based =
userspace
> > > memory
> > > region=E2=80=9D).
> > > 2. P2P routing is a property of devices, not memory. It is known
> > > and
> > > remains
> > > =C2=A0=C2=A0 stable.
> > > 3. See the VFIO TPH ST discussion, where the requirement to
> > > obtain
> > > the
> > > =C2=A0=C2=A0 exporter=E2=80=99s P2P information in the importer was r=
aised again.
> > >=20
> > > Thanks
> >=20
> >=20
> > Returning again to Jason's series. Let's say we'd add just the
> > mapping
> > type infrastructure, converted users of pcie_p2pdma only to use
> > that
> > and then we'd have access to per-mapping-type data.=C2=A0This could
> > actually
> > be done as a prereq for this series and merged separately. It's a
> > couple of patches only.
>=20
> I afraid that you over optimistic about the amount of work.

I was thinking something like this
https://gitlab.freedesktop.org/thomash/xe-vibe/-/commit/0ab1cefa5c1439701e2=
a09d2de2d03722b63b509

Although I have a couple of review comments on the infrastructure, and
it doesn't include re-negotiation at map-time.

>=20
> >=20
> > Jason's match() and finish() callbacks could compute the
> > interesting
> > routes at attach time,=C2=A0 perhaps even condesed to whether IOVA is
> > used
> > and whether ATS translated packages have a direct route (which is
> > what
> > mlx5 care about AFAICT). This information is kept outside core dma-
> > buf
> > and would be specific to the pcie_p2p mapping type (interconnect)
> > only
> > rather than having functions and callbacks bloating the core dma-
> > buf
> > structures.
> >=20
> > Then exactly where the cross-subsystem match() and finish()
> > implementations should live I figure remain up for discussion and
> > guidance by Christoph?
>=20
> Maybe I'm wrong, and everything will work out. However, given
> Christian's
> feedback to determine the mapping type when the mapping is
> established, this
> approach won't work for an RDMA exporter.

I'm not 100% clear as to whether Christian meant the mapping-type would
be re-negotiated if an agreed mapping type failed, or whether we would
just allow a transparent fallback to system memory dma-buffers?
Christian?

In any case, IMHO the infrastructure must allow for an importer to
rather fail a mapping if the original attach-agreed mapping type was
severed at mapping time, and then you'd get the same behaviour as you
are sketching now? Or you could chose to take an unlikely slowpath to
perform whatever's necessary to accomodate the new mapping type, even
if that includes having to re-fault already ODP-faulted memory. Pinning
would also be an option, I figure.

Thanks,
Thomas


>=20
> As I mentioned, mlx5 uses on-demand paging (ODP), creating mappings
> in
> response to page faults. To handle these faults with reasonable
> performance,
> mlx5 must create a memory region (MR), with or without ATS, and it is
> needed to be created before first page fault.
>=20
> I'm afraid we're going in circles, so I'll drop the dma-buf patches
> for now
> and focus on fixing only the PCI ATS flow.
>=20
> Thanks
>=20
> >=20
> > Thanks,
> > Thomas
> >=20
> >=20
> >=20
