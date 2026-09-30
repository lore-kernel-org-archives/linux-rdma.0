Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC92C4483BE;
	Wed, 30 Sep 2026 08:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790756320; cv=none; b=iN7Azfzya4U6GeYkqnrGrZl2UmPjQfdzDRP+F4mjpCSusoq1lnmJX9VkJ1N6s2LBpS3VkL2mfAqx+Ou8FQ1qowk1eXcTxJQrK1l2JedF8lxZ8UaPnilqUurN7I1sTSkvFmS2DvWjpLN+s0SIamSkJWibxIsnmhwW9qvK1CjyIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790756320; c=relaxed/simple;
	bh=R6s8OiKBK+PREbUobOUgjnqt4WFhGHvFtnaErDsUlvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBvgQNZ7C6lfDKpEsh33Jb6XS4adH87T2TYVGvf8TFgy8acjWFTJP9NBQ3zjQ0i0chMNVMnnBxViEl6b3R7IjPYLmGE6DGDOtpR18EWsBDX5YEKD5CMNmXhT9Cp0/utMb2/f7fHjW5b4k3HOo3xXnaMwagJbMub9/a2u2wNEJ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHnWXJca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHnWXJca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9851F000FF;
	Wed, 30 Sep 2026 08:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790756318;
	bh=Z5uqg8OGV8G3amtZGI+AAjssegRbH2Q3sF6MukzHR4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KHnWXJca1OG7ubExZjIAsnSkTiQN7MaCsc/vSPXZmsAHD3sKNtk/npmzfYD81IYrg
	 h8Lj9rd/RPGayQMkU52JzXFhfUWksJ7TlRl7xUB45oYxoOPh21Ar01EXU4zfXbSsDn
	 Qx8hep+EjuWDQ7wLN1CF7mjbzVWtpSnXHMaK/a3HE/Dy/wL5ni8au2Tr96oPwO0QDT
	 7B4erMxz79o2iObpm6+t9Njmp8GREh9GgdzEJAOTzh6WnT8jS413WaA+T2HtK6yklN
	 vciTXZuE1KJL3zD+ZEd4yVEG0DW9bj3eJpVgh6ta2ZvZ8Du4SNIsl3V3mE1ESo/Lkk
	 juuuE/eX51S/Q==
Date: Wed, 30 Sep 2026 11:18:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
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
Message-ID: <20260930081832.GA3401365@unreal>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
 <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
 <607e8903-a979-4d78-bf08-447321c03119@amd.com>
 <20260929132305.GJ563127@unreal>
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eeef5951-825e-459f-b474-bf8c59588446@amd.com>

On Wed, Sep 30, 2026 at 09:00:57AM +0200, Christian König wrote:
> On 9/29/26 19:57, Leon Romanovsky wrote:
> > On Tue, Sep 29, 2026 at 03:39:42PM +0200, Christian König wrote:
> >> On 9/29/26 15:23, Leon Romanovsky wrote:
> >>> On Tue, Sep 29, 2026 at 11:34:05AM +0200, Christian König wrote:
> >>>> On 9/28/26 13:19, Leon Romanovsky wrote:
> >> ...>>
> >>>>> +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
> >>>>
> >>>> This function call here *must* be in the exporter and not the DMA-buf framework.
> >>>>
> >>>> So clear NAK to putting that here.
> >>>
> >>> "Look, it is easy to complain you don't like how it looks, but this
> >>> stuff is hard there are lots of competing concerns, if you have a
> >>> better idea now is a good time to present it."
> >>> https://lore.kernel.org/all/20260921130858.GO11599@ziepe.ca/#t
> >>>
> >>> Do you have a viable solution?
> >>
> >> Ok, that sounds like you haven't understood why I'm rejecting this.
> >>
> >> By moving the calls to pci_p2pdma functions into DMA-buf you bypass the NAK to expose those functions to drivers from the DMA maintainers.
> > 
> > No, you have misunderstood Hellwig's position. His request was to ensure that only
> > subsystems deal with P2P internals. He was perfectly fine with bringing P2P
> > complexity into dma-buf, since it is the agreed-upon mechanism for sharing DMA
> > regions between devices.
> 
> Thanks for clearing that up, I indeed didn't realized that.
> 
> But that is pretty much against my standpoint that I don't want any P2P complexity in DMA-buf.
> 
> > 
> > So this is not a NAK bypass; it is a correct implementation of his request.
> > He handled P2P-related complexity in the block layer.
> > 
> > Let's add Christoph to the thread so he can correct me if I'm wrong.
> > 
> >>
> >> I unfortunately didn't understood that when the dma-buf-mapping.c code was added and just assumed that you just needed a place to put some common code.
> > 
> > That is not correct. Devices A and B share a DMA region via the dma-buf
> > mechanism. Where do you expect the code common to dma-buf to be placed?
> 
> In the DMA layer!
> 
> >>
> >> So as long as that NAK from the DMA maintainers to expose the pci_p2p functions to drivers stand I will push hard to get that stuff removed again from DMA-buf as well.
> > 
> > Are you seriously suggesting that every dma-buf driver in the world should
> > have to reimplement this mess?
> 
> Well I completely agree that this should probably not be replicated into each exporter, but that is the job of the DMA layer and not DMA-buf.
> 
> The purpose of DMA-buf is to exchange DMA addresses between an exporter and one or more importers and handle things like lifetime and synchronization of accesses. 
> 
> What the framework should do is to transport the capabilities of the importer to the exporter, e.g. what physical connections we have etc..
> 
> What the framework can also do is to have additional information from the exporter to the importer regarding addresses and mappings, for example if they are bus, IOVA or some special internal DMA addresses or how to stitch together your PCIe TLP or whatever.

At a minimum, exporters need to pass `p2pdma_provider`.

If I keep the “dma-buf: Let exporters hand out the P2PDMA provider behind a
buffer” patch, I can move the P2P TLP types back into `p2pdma.c` and export
only the function that indicates whether ATS is required.

Is it ok?

Thanks


> 
> As long as both the exporter and importer agree on what those values mean I have no problem at all with that.
> 
> But how those DMA addresses come to be should *absolutely not* be part of DMA-buf! The complexity of that is seriously not something we should have here.
> 
> Regards,
> Christian.
> 
> > 
> > Thanks
> > 
> >>
> >> What you try to do here is seriously not ok and I will push back hard on that in the future.
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> Thanks
> >>>
> >>>>
> >>>> Regards,
> >>>> Christian.
> >>
> >>
> 
