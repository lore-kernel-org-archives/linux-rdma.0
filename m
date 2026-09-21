Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A049DBA8;
	Mon, 21 Sep 2026 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997266; cv=none; b=k5zIoPgefZfVs6AHEYKiiTfiBteGh1YHFQ2HcGWcKQfzsLHOLY2VBVLd/3SKSuYpFj8vfRjlENx6bQvsRmpqj/Fe1uWp3B4iCoxo5YWYhZke8Cv49HPGnfu8ReK0EkwGeZVnd7xPbeP9GWxxQxcHuVTPJ9FwOq2WRV2l6avA5/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997266; c=relaxed/simple;
	bh=4nmoxw2ZHQofaj8EJj1UInlqle9eASAx4yPihU0NGKE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mJbE2s2CZ6YrLPkhrc6jKP52T1TqewXzS96701XOONsgVshEBNlG2dCbtJA6vgPt8XxAEabyZuXce26x6cWVAKY+yK6ejOzYFc1zJX+j+qh0g0HQ9c4ZaFJ0GoNRbyFiIt9Ke76U0g7Pt/3u9DGzSV4csZXlqssrqb4qPOS11yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSVwtMYm; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSVwtMYm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789997265; x=1821533265;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4nmoxw2ZHQofaj8EJj1UInlqle9eASAx4yPihU0NGKE=;
  b=gSVwtMYm9u8/TvRU/wBpgudO9Ehtse7UBnIlKa8lG/1MTfjZbfpLPAYx
   +aTSirdYG17fXPQsa0/CjgrNyG/2X5D9OnBuZMgRyh7GC/W3sQjkpkIGU
   g6QLJyJmTibkQa/yAdOMti5XmDK2iK91IcxklHYPijov10qlzhNnRrN9r
   QPcsnXXeQddQ7n3JVC1wcMShUVIGW9iEjmqWcOPIvfjSrUOBmCJ1d0l6V
   iF77jyoMenpeXvXfcJsGVxrTw+9aPFgSVd49KTGQlDpaoeECgqVOF99kr
   DFdn1/SNN6GImu1J0DYU3ib1Zik14r9xJYBcVwhmYYcsI2nAoBo5iBpGG
   g==;
X-CSE-ConnectionGUID: UFScwykFTZGXSlN5VY0WkQ==
X-CSE-MsgGUID: 506UoGJZRaO0PnY5xV6hpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11911"; a="89434438"
X-IronPort-AV: E=Sophos;i="6.27,114,1787036400"; 
   d="scan'208";a="89434438"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 06:27:44 -0700
X-CSE-ConnectionGUID: 5cCwDP5/TEOO04pH4+JPkA==
X-CSE-MsgGUID: YiaHkgBaTpKNVdfgWlxTsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,114,1787036400"; 
   d="scan'208";a="269165565"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO [10.245.244.155]) ([10.245.244.155])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 06:27:38 -0700
Message-ID: <51ddde08ece4ca9dc277d799b3ea4f1f3cdf7e10.camel@linux.intel.com>
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a
 direct peer-to-peer route
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 Logan Gunthorpe <logang@deltatee.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman	 <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson	 <alex@shazbot.org>, Ankit Agrawal
 <ankita@nvidia.com>, Jonathan Corbet	 <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, "Joerg Roedel (AMD)"	 <joro@8bytes.org>, Will
 Deacon <will@kernel.org>, Robin Murphy	 <robin.murphy@arm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Sumit Semwal	 <sumit.semwal@linaro.org>,
 linux-pci@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,  Tushar Dave
 <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, 	linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 21 Sep 2026 15:27:36 +0200
In-Reply-To: <20260921131055.GP11599@ziepe.ca>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
	 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
	 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
	 <20260918121500.GV13683@unreal>
	 <b517070d0b9236b03962fcba649faffcacda23eb.camel@linux.intel.com>
	 <20260918170524.GH11599@ziepe.ca>
	 <f9ced8cab6eb929a5f65d789fe6922458c6f3396.camel@linux.intel.com>
	 <20260921131055.GP11599@ziepe.ca>
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

On Mon, 2026-09-21 at 10:10 -0300, Jason Gunthorpe wrote:
> On Mon, Sep 21, 2026 at 08:40:41AM +0200, Thomas Hellstr=C3=B6m wrote:
> > On Fri, 2026-09-18 at 14:05 -0300, Jason Gunthorpe wrote:
> > > On Fri, Sep 18, 2026 at 03:42:28PM +0200, Thomas Hellstr=C3=B6m wrote=
:
> > > >=20
> > > > 1) Xe attachment check if pci_p2pdma_distance() returns OK for
> > > > the
> > > > path. Then Xe always sets up dma-addresses using
> > > > dma_map_resource().=20
> > >=20
> > > Open coding pci_p2pdma_distance() in drivers is a hack. Using
> > > dma_map_resource() like this was never "allowed".
> > >=20
> > > We've fixed things so these hacks are not needed, the drivers
> > > need to
> > > move over to things like dma_buf_phys_vec_to_sgt() and the hmm
> > > helpers
> > > to use the DMA API correctly.
> > >=20
> > > > 1a) Let's say the importer (Xe) has ATS enabled, and the
> > > > exporter
> > > > is
> > > > supposed to map dma_addresses.
> > > > In between there is a switch that allows direct traffic.
> > > > Now with your patch series, How would the exporter know that Xe
> > > > has
> > > > ATS
> > > > enabled and therefore should return IOVA mappings rather than
> > > > the
> > > > BUS
> > > > addresses representing the shortcut.
> > >=20
> > > The thing that does the DMA map must be aware of what PCI TLPs
> > > the
> > > PCIe initiator will use to compute the proper P2P mapping mode.
> > >=20
> > > ATS always needs an IOVA but that still doesn't mean the P2P will
> > > work.
> > >=20
> > > > It seems to me that a pci-device settable flag "ATS always
> > > > enabled"
> > > > should be enough to fix both issues?
> > >=20
> > > It should be be per-mapping to support the NIC workflow that
> > > isn't a
> > > global operation.
> >=20
> > OK. It looked to me from the series like the NIC workflow was to
> > adapt
> > its ATS settings per mapping depending on the p2p mapping type
> > returned
> > rather than vice versa. If so it would just clear "ATS always
> > enabled".
> >=20
> > Admittedly a per-mapping flag would be more flexible, but also
> > would
> > require changed internal APIs?
>=20
> Ah you didn't send this to the list, was it intentional?

No, Just hit the wrong reply-button. +lists again.

>=20
> mlx5 has both cases, some DMA is flexable and can do either, some is
> non-ATS only.

OK.

>=20
> Jason

Thanks,
Thomas
