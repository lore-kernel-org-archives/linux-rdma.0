Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC60338E8C6;
	Mon, 21 Sep 2026 06:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789973865; cv=none; b=lKpsVjhpaywN1mOGpIkkZZze+UUgmYaCXIBuhScrx2UM7Esy2fI73Pi1aBaYuxxonF7DwXM8EQwBT3KbpC0EYMixBx6yKBDTzoHxP6854DQTjpqc38kl8yU3Mk+M4odQ9SiY0zC89kPxZ85DUARX7Tac5gYdm2GwzQb1oQUdDvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789973865; c=relaxed/simple;
	bh=P59r4FNY1nRj1bsYjyaGQcIz1iJ9xQL0uv3I+7eHlhA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cuy1BZUbmZRfkDgLEwxG76GgdjKeDo3Cm3nc9/r6riCN61UVsB2yPjzbdQTB56ixj029N7PBLys4i1XY9oFpXwihx3Yk3wN84o20FQB2dX6vJ8aSEoQT9kYuxcaiqa8fWSBWZY9qzXT3PvXlNRz5KbDgtpPFKkU4TEpisxdepZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cl/xZgJP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cl/xZgJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789973864; x=1821509864;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=P59r4FNY1nRj1bsYjyaGQcIz1iJ9xQL0uv3I+7eHlhA=;
  b=Cl/xZgJPmkgfVs9Lg4G+JVjFy4DY2BWrV5npadkuglGLgX4tNc3NPf7M
   I+h6UQMGeJEzBt/KBnAnmoANuBixkFBnsFQ1NQZSa5CE0/GsL0dzQkIEA
   WZTNH9l7DV+ykh4IeFZv5v4NzDyinUr2qjtBvDou3zALaVffYZZzd+90L
   IFz9aTE7fLt0NgjGhzBFI74cpbnaNpv8+EkQXOJHgYZDc/eCVRDJyx125
   C3UVm3eXKd6ajqOmKg3N2fydwbLdru6gnQKpBMLJFVQWXzXlh4XRasbE8
   WUP1jlhmAj3KyElChButwSV42Nrb6P9AfSSPaygWiMTlybwIGtl5HoExB
   w==;
X-CSE-ConnectionGUID: x6K0Ya5+TfyCkc1cDG3ASw==
X-CSE-MsgGUID: ki85AVokRVOh9pSHNGNqCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11911"; a="90484962"
X-IronPort-AV: E=Sophos;i="6.27,114,1787036400"; 
   d="scan'208";a="90484962"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2026 23:57:42 -0700
X-CSE-ConnectionGUID: pgydRxgNSECLINbB4qVCSQ==
X-CSE-MsgGUID: smtR3yD1Rx+3kxBejKlTcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,114,1787036400"; 
   d="scan'208";a="3829648"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO [10.245.244.155]) ([10.245.244.155])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2026 23:57:37 -0700
Message-ID: <e80dc629b90d5284ace6f84643616f352f25cb57.camel@linux.intel.com>
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a
 direct peer-to-peer route
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
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
Date: Mon, 21 Sep 2026 08:57:31 +0200
In-Reply-To: <9656f2f9-2e39-4007-b065-3b763b53c6de@amd.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
	 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
	 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
	 <20260918121500.GV13683@unreal>
	 <b517070d0b9236b03962fcba649faffcacda23eb.camel@linux.intel.com>
	 <20260918170524.GH11599@ziepe.ca>
	 <9656f2f9-2e39-4007-b065-3b763b53c6de@amd.com>
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

On Mon, 2026-09-21 at 08:43 +0200, Christian K=C3=B6nig wrote:
> On 9/18/26 19:05, Jason Gunthorpe wrote:
> > On Fri, Sep 18, 2026 at 03:42:28PM +0200, Thomas Hellstr=C3=B6m wrote:
> > >=20
> > > 1) Xe attachment check if pci_p2pdma_distance() returns OK for
> > > the
> > > path. Then Xe always sets up dma-addresses using
> > > dma_map_resource().=20
> >=20
> > Open coding pci_p2pdma_distance() in drivers is a hack. Using
> > dma_map_resource() like this was never "allowed".
> >=20
> > We've fixed things so these hacks are not needed, the drivers need
> > to
> > move over to things like dma_buf_phys_vec_to_sgt() and the hmm
> > helpers
> > to use the DMA API correctly.
>=20
> That is a completely broken approach as well since it limits the
> exported resources to addresses the CPU can reach.

And this would be OK for pcie_p2p, but not for other fast
interconnects, right? Or is this problematic also for pcie_p2p?

Thanks,
Thomas
