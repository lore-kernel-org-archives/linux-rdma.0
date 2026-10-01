Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755953BFE4C;
	Thu,  1 Oct 2026 08:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843237; cv=none; b=qMqm351hgmSw8vqGyt6x8VSffm99IIKgwSrBN85p8qWy2AFk9a8q7UTVL3pP9AQ2mJfcdORQ2Dz2J7YxTN+UOi8qPT4QEJltyUXDcbwthKQe7lJLqL7gSMExiLgRs9H9U+OKupKQ2vzq9hMJGZ/Me7Dzwg+gNQ9DfxVE6JkGUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843237; c=relaxed/simple;
	bh=xWrH1Cjj6dY7/bQjODpc5DwgLCudd5ID9+bEGI7C7es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajDZHRNWAybKSW/PdB8WS1p+w1JoD7xL1fiGwnKciVNmgElzZtcSLAzA/6MTZlBUtWHu0YJqgSTNX40pxUorYyT7J8ohGDypNTkMA7XLTD8pHvgAhFFzag10aqAZ8Ly8CIPTPt7rb20o0XPuzpzkR2hnBxzcX1yByz6k6JFyXFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+sXCEEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+sXCEEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED751F000FF;
	Thu,  1 Oct 2026 08:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843236;
	bh=pYcL+VKdq7uxpH1GmJPMynmPVBR+edXOn5WdQI9nPt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O+sXCEEpjy8KVvZwc5d554sxhR3Ka0HiUCyaDILSzRUPNW5YfZkLHApdEhzGvyMZF
	 yRF5FT8tkfedcOcVxx0CM7GpE/BwFlqWYy5k59PjJz2/WtvOUxZBznMjNT/hBcslRV
	 rRHNGEibZMIsl3OEFff5poiB1m63mW9npK4yK8Z16887SV71LvkgE6bv9zPPGs6CqC
	 cRDIUMezxTaDy3Tz5xEYIdG3Acf5BAbgIdfOe3jvwfKqbnozWBjSyCXPh7Y75NR3T/
	 v0/XHfSXGMKLjSC3cGvoe1BsWkbFVM8vXBtlalVMRSoRSTah0ZMccpv6Sl3Uvz30S7
	 wjHi0lRn02RsA==
Date: Thu, 1 Oct 2026 11:27:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
Message-ID: <20261001082710.GL3401365@unreal>
References: <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
 <20260930143237.GI3401365@unreal>
 <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>
 <20261001063747.GK3401365@unreal>
 <918ff7c0-76fe-4f22-b001-830eb5acf836@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <918ff7c0-76fe-4f22-b001-830eb5acf836@amd.com>

On Thu, Oct 01, 2026 at 09:49:31AM +0200, Christian König wrote:
> On 10/1/26 08:37, Leon Romanovsky wrote:
> > On Wed, Sep 30, 2026 at 04:57:04PM +0200, Thomas Hellström wrote:
> >> On Wed, 2026-09-30 at 17:32 +0300, Leon Romanovsky wrote:
> ...
> >>
> >> Returning again to Jason's series. Let's say we'd add just the mapping
> >> type infrastructure, converted users of pcie_p2pdma only to use that
> >> and then we'd have access to per-mapping-type data. This could actually
> >> be done as a prereq for this series and merged separately. It's a
> >> couple of patches only.
> > 
> > I afraid that you over optimistic about the amount of work.
> 
> Yeah, agree. The proposal looked good but there will probably be quite a bunch of work.
> 
> >>
> >> Jason's match() and finish() callbacks could compute the interesting
> >> routes at attach time,  perhaps even condesed to whether IOVA is used
> >> and whether ATS translated packages have a direct route (which is what
> >> mlx5 care about AFAICT). This information is kept outside core dma-buf
> >> and would be specific to the pcie_p2p mapping type (interconnect) only
> >> rather than having functions and callbacks bloating the core dma-buf
> >> structures.
> >>
> >> Then exactly where the cross-subsystem match() and finish()
> >> implementations should live I figure remain up for discussion and
> >> guidance by Christoph?
> > 
> > Maybe I'm wrong, and everything will work out. However, given Christian's
> > feedback to determine the mapping type when the mapping is established, this
> > approach won't work for an RDMA exporter.
> > 
> > As I mentioned, mlx5 uses on-demand paging (ODP), creating mappings in
> > response to page faults. To handle these faults with reasonable performance,
> > mlx5 must create a memory region (MR), with or without ATS, and it is
> > needed to be created before first page fault.
> 
> Yeah, I feared that you have something like that. At least for the current DMA-buf semantics that is not something which fits into that model.
> 
> Background is that system memory is usually seen as fallback which should always work and you can have really strange combination of use cases.
> 
> So what can happen is that you create a mapping and P2P is possible without ATS but then some other device attaches and we suddenly have to use ATS because the buffer is now in system memory.

The importer reports ATS support on a per-mapping basis. If the exporter
receives this hint from deviceA but not deviceB, it prepares different
addresses for the two mappings.

The `ats_per_mapping` flag is stored in the importer structure:
https://lore.kernel.org/linux-rdma/20260928-fix-p2p-acs-v4-0-v8-20-404453b9c435@nvidia.com/

In our example, if the mlx5 and XE importers both attach to the same
exporter, they receive different mappings.

Thanks
