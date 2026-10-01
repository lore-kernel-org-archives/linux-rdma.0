Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2396B316905;
	Thu,  1 Oct 2026 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790836673; cv=none; b=uSkV+1QeI4ea9fIZyxjIN5jLL7DAp/CjOLKH7s2s6CuyM4vOxsf5ukmeiUf9cBw6d/SjdAK7jbYpTuy8ILMx42kawa/7S3eac91K/F8i0SHUOnLbH8wOAzQbTyhNc6966tITykPJFuXWoIWZ+PzQdMeUfgd9AsN4Qx+j5U2ZYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790836673; c=relaxed/simple;
	bh=VCT1N6hI2ooF+CmtCByw4GpH0V8pynMdUmROqI71U1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fj0srJHERSbxGz7lA3OyAQGj4cOw19vFnzC7/gAgZvknGOWivYZcGRdAAu01UEA9wWLcGjZQuBG0lhNxD2RKQ7qUxzkH6rDqxZ8pF/V8alll0DQhkIbxyf2tijisvGEyypmH190dJ/oB66v9VYuvANAdwbptzRMEK7D82HPKNio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMj51tOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMj51tOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFA41F000FF;
	Thu,  1 Oct 2026 06:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790836671;
	bh=X2yG9C10oNzGkh3Q87HvKsn9L3yVCds4Sm/K2JQM8aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EMj51tODtUfKbgPh4IO5i7MmvgaToTcylrTMg0RILrRDsivA3MJdxfofL4/hF3JhN
	 LPRGbF6J0rhnXmajfYlkAaf3IfaFyCM9JLycu6mbYtTqlbDkCOjCH9BMAGdxzgKFic
	 3JAbeh529NFx5rbISpZvuPqTO5mrujoixRvIB2jzSFz4bmzHQaWXq/oga+T8bqIIMa
	 fls5ZFM8A59T+zDE1f73qjU5FENioHEd12uHY+ggnOU03mm9N4kaqWYlbdev7BFFua
	 mK9PZMO45uCurwd1tqcPjFAnfEnFtsGa/dIcLcZJYwJqdye860qW3ldcHI/khTHRn7
	 Lq6iv0ZeBTTKA==
Date: Thu, 1 Oct 2026 09:37:47 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Message-ID: <20261001063747.GK3401365@unreal>
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
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>

On Wed, Sep 30, 2026 at 04:57:04PM +0200, Thomas Hellström wrote:
> On Wed, 2026-09-30 at 17:32 +0300, Leon Romanovsky wrote:
> > On Wed, Sep 30, 2026 at 01:52:39PM +0200, Christian König wrote:
> > > On 9/30/26 13:43, Leon Romanovsky wrote:
> > > > On Wed, Sep 30, 2026 at 10:34:56AM +0200, Christian König wrote:
> > > > > On 9/30/26 10:18, Leon Romanovsky wrote:
> > > ...
> > > > > > 
> > > > > > At a minimum, exporters need to pass `p2pdma_provider`.
> > > > > 
> > > > > No, exactly that is a no-go. The neither the framework nor the
> > > > > importer should see the p2pdma_provider.
> > > > > 
> > > > > Only fully translated addresses where the DMA access should
> > > > > happen.
> > > > > 
> > > > > > 
> > > > > > If I keep the “dma-buf: Let exporters hand out the P2PDMA
> > > > > > provider behind a
> > > > > > buffer” patch, I can move the P2P TLP types back into
> > > > > > `p2pdma.c` and export
> > > > > > only the function that indicates whether ATS is required.
> > > > > > 
> > > > > > Is it ok?
> > > > > 
> > > > > What you can do is to forward declare enum pci_p2pdma_map_type
> > > > > and than pass that 1 to 1 from the exporter to the importer.
> > > > 
> > > > Unfortunately, neither suggestion applies to RDMA NICs. They need
> > > > to know,
> > > > before mapping addresses, whether to create the memory region
> > > > with ATS
> > > > enabled.
> > > 
> > > The design principle here is that the final location and access
> > > path of the data isn't determined when the buffer is created.
> > > 
> > > The importer first need to attach before it can query such
> > > information from the exporter.
> > 
> > In attach yes, this is why importer digs in dma_buf ops to get
> > p2pdma_provide, however it is before addresses are known.
> > 
> > > > The importer needs a way to obtain device information from the
> > > > exporter so
> > > > that it can configure itself correctly.
> > > 
> > > That won't work with DMA-buf then, the exporter is completely
> > > opaque to the importer and that is for really good reasons.
> > > 
> > > Why in the world does the importer needs to know the information
> > > from the exporter before the mapping is created?
> > > 
> > > It is the exporter who decides how data is accessed by the importer
> > > and not the other way around.
> > 
> > There are several reasons:
> > 
> > 1. This is how DMA-BUF MRs are built in RDMA. In mlx5, they rely on
> > the ODP
> >    mechanism, which requires an MKEY to be created first. See commit
> >    90da7dc8206a (“RDMA/mlx5: Support dma-buf based userspace memory
> > region”).
> > 2. P2P routing is a property of devices, not memory. It is known and
> > remains
> >    stable.
> > 3. See the VFIO TPH ST discussion, where the requirement to obtain
> > the
> >    exporter’s P2P information in the importer was raised again.
> > 
> > Thanks
> 
> 
> Returning again to Jason's series. Let's say we'd add just the mapping
> type infrastructure, converted users of pcie_p2pdma only to use that
> and then we'd have access to per-mapping-type data. This could actually
> be done as a prereq for this series and merged separately. It's a
> couple of patches only.

I afraid that you over optimistic about the amount of work.

> 
> Jason's match() and finish() callbacks could compute the interesting
> routes at attach time,  perhaps even condesed to whether IOVA is used
> and whether ATS translated packages have a direct route (which is what
> mlx5 care about AFAICT). This information is kept outside core dma-buf
> and would be specific to the pcie_p2p mapping type (interconnect) only
> rather than having functions and callbacks bloating the core dma-buf
> structures.
> 
> Then exactly where the cross-subsystem match() and finish()
> implementations should live I figure remain up for discussion and
> guidance by Christoph?

Maybe I'm wrong, and everything will work out. However, given Christian's
feedback to determine the mapping type when the mapping is established, this
approach won't work for an RDMA exporter.

As I mentioned, mlx5 uses on-demand paging (ODP), creating mappings in
response to page faults. To handle these faults with reasonable performance,
mlx5 must create a memory region (MR), with or without ATS, and it is
needed to be created before first page fault.

I'm afraid we're going in circles, so I'll drop the dma-buf patches for now
and focus on fixing only the PCI ATS flow.

Thanks

> 
> Thanks,
> Thomas
> 
> 
> 
