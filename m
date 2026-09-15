Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5571443C0F;
	Tue, 15 Sep 2026 06:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453706; cv=none; b=feY9R9MvvWaxxAOrR64CFbZtw3jrct8CVuPqXelO4pDFcL8PR3qr4Mdwy9PGGcvS6LOxsgLtH9TTg2P9C0EBBbe2MQQFHFdWMQl5j3jN3lpsWp6Vivm55yTF1Zgnahmym7SdiTsE8VmB4bXlnuz5PZPj7qZ8JDJ3ePLTn1OVZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453706; c=relaxed/simple;
	bh=hXL9wdr+HMJNOL6kBGMxXZ+0cF6DyLEHDi863+p1fh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etpDuJihOWwBINv4LGtcNKH3t+/gTuFa5ZKhHBbGcnr+4PYrb057Ejud1R+cPVjorwBbQWoiVZRjEGD62VDSKAvz+gtF1ioEZpD6OlABn6TGuoVEbR/CUHsVVrJVYF3/gLR1sHdbFlkwvl/SsHnCTu/yS62gTlmWLSGXnV28jSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMQzTK+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMQzTK+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC751F000FF;
	Tue, 15 Sep 2026 06:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789453690;
	bh=s1ZgCvgYBowuT21DiXBMsMTfkSs1dITBF/fvY9UsxyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eMQzTK+nrw6R3dF1TZi2yUMu6WLgyQCI83kBx7n12YE5mzGy6ZaTD051ee1SLTE84
	 kEwFIEICR+EESJNkBRNf1crLzx9LQD+VbOELejQnXcPVEtZyrl2uVbdJRbbT7Dtdoa
	 kwhnqSgQN3xaxQ54zApLkmuedqWF+fHgXRyELYCTBjspknWvtwVvwX3xoYRG9M18pZ
	 kca+l0S4rXYEBdiZgNmPBU1VKW/PXMddUg+hOeOqj5GajJLn9WXHPFBCDHFi/+vYJZ
	 MHbMEo72LoqYOnB5ADhVvDFvGwPgEi2XUQeuJT1YxVL0l2mS4FjESrcUbBEBCLX5bF
	 pMOQNpwY0TLNg==
Date: Tue, 15 Sep 2026 09:28:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <20260915062806.GC13683@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-17-5ef07ec9ef06@nvidia.com>
 <d3fb7ea0-019f-4311-bf0f-00d25bdebda0@amd.com>
 <20260914221025.GA3196566@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260914221025.GA3196566@ziepe.ca>

On Mon, Sep 14, 2026 at 07:10:25PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 14, 2026 at 04:27:00PM +0200, Christian König wrote:
> 
> > > +enum pci_p2pdma_map_type
> > > +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> > > +			unsigned int tlp_flags)
> > > +{
> > > +	struct dma_buf *dmabuf = attach->dmabuf;
> > > +	struct p2pdma_provider *provider;
> > > +
> > > +	if (!dmabuf->ops->p2pdma_provider)
> > > +		return PCI_P2PDMA_MAP_NONE;
> > > +
> > > +	provider = dmabuf->ops->p2pdma_provider(dmabuf);
> > > +	if (!provider)
> > > +		return PCI_P2PDMA_MAP_NONE;
> > > +
> > > +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
> > 
> > Calling PCI subsystem functions from dma-buf is a hard NO-GO.
> 
> This is why I had the mapping type arrangement able to know if a PCI
> path was involved so it could activate PCI support for that path. In
> an extendable way so other interconnects could also provide their
> unique knowledge too.
> 
> > I shouldn't have allowed the mapping functions to be added to
> > DMA-buf in the first place, all of this belongs either into the DMA
> > layer or the exporter.
> 
> DMA layer is not the place to form dmabuf's corrupted
> scatterlist. This must only be done in dmabuf.
> 
> We don't want to open code this common logic in every exporter, it
> needs a helper. If you have a better place where to put the thing that
> makes the dmabuf unique broken scatterlist, then I'm open :) HCH isn't
> going to accept anything like that outside stuff hard wired to dmabuf.
> 
> > We should probably have a single callback the exporter provides to
> > fill in a structure with PCI specific information for a mapping.
> 
> Yeah, that is where I was going.
> 
> I'm really sorry I haven't been able to come back to that mapping type
> series. Were you feeling positive about that? Maybe Leon or someone
> can pick it up from me. I was optimistic about scaling back to just
> the maping type negotiation as a first step

I can do it, but we should wait until the "Fix ACS ..." work is complete.

There is no reason to hold up everyone with incorrect PCI ACS behavior just
because we are arguing about where to put the code.

Thanks

> 
> Jason
