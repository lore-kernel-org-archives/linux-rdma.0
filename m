Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0866A3BF695
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870021; cv=none; b=i2bD2ey/PRqSFvft7kjsYjScB10IYsCRbUc43D6peZAVtskYu3VlJ5HTWkQMHdf5HEub2bnqaztYpa2NGSjoajWTvGgXQOg/KAUGbMcqSBlI5aWEK8CfSsUhylwdIAVUqCUJ7dwddppK7jIwJleVPeNHe6Yal+avZzwp1A/R4u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870021; c=relaxed/simple;
	bh=1/jwMqXK8cKcdJddhXQS3/mA1Z+NGHMB5uhMVaxng9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A///SqSxEfpanrDALLueZPxgaNsPkUQq8xEk2468ebF9QeMZd0ke7tirTd4kaHchDgHzi/YE0dond5fgDUfVO1XQfmCts+heRJHXNKHBqXcGALOCEPfixKu2qIFQgG1Oysvjb+oLrPKl7flNQLXPpcAozSEobpJpG0b6z03DwXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHI6J8He; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHI6J8He"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C631F000FF;
	Thu,  1 Oct 2026 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790870018;
	bh=+EmLvUEKOEByTo+Prg6YLkZ4Ht1/Wt56IsYphdtVG48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FHI6J8HeWQnZNHBNcIqQTwT1QDRpMaXGC2gTMuiefed/A6nlot2b2ueclnrkxdNNs
	 lFo1YN3eh1H47WQo7NvVof9Nun8jv4R/rv9As0PK+kHKYOSVh+ZisWgbVRc5i2YJ/v
	 3bkKT2Dmi69m/etlBACkZCjRwHeWnEqqmjc4OlsgcfP3W50xh5RqKcioWC+EYfvG/X
	 jYMG2fr8KKXo8bn/glE9iLLkoj1FE5+b9OVoVxXmxDSEjQ7XURaI2OPJxbsS5Lo6He
	 Ogunxp87OstViCG/4fe06hYjXE5UwRXgFJ41mdsSwe2Q2CeHzi9zC5UR9FNxEhhkl3
	 yy1/vtNngn6jg==
Date: Thu, 1 Oct 2026 18:53:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yonatan Nachum <ynachum@amazon.com>,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, Yehuda Yitschak <yehuday@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via
 device query
Message-ID: <20261001155333.GP3401365@unreal>
References: <afhL9DLUVhnVyzZu@nvidia.com>
 <20260505081514.GA19297@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <afoPWiiEwk5igB/N@nvidia.com>
 <20260923163830.GA6954@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260923171741.GH2545495@nvidia.com>
 <20260924152913.GB24800@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260924182201.GB9354@nvidia.com>
 <20260924193026.GA13498@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260925125512.GM9354@nvidia.com>
 <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930132613.GA24387@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Wed, Sep 30, 2026 at 01:26:13PM +0000, Michael Margolin wrote:
> On Fri, Sep 25, 2026 at 09:55:12AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 24, 2026 at 07:30:26PM +0000, Michael Margolin wrote:
> > > On Thu, Sep 24, 2026 at 03:22:01PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Sep 24, 2026 at 03:29:13PM +0000, Michael Margolin wrote:
> > > > 
> > > > > > > 2. Expose EFA_DEV_CAP(dev, PCIE_PEER_ACCESS_ENABLED)
> > > > > > >    directly to userspace. As you already stated, this is a
> > > > > > >    bit awkward as a device isn't expected to be aware of
> > > > > > >    system topology, but since EFA lives in the cloud it is
> > > > > > >    partially aware of the platform configuration and in
> > > > > > >    particular the ability to access peer devices over PCIe.
> > > > > > 
> > > > > > If you already know your VMs are always safe what is even the issue?
> > > > > > What are you probing for?
> > > > > > 
> > > > > > Lets please not hack around bad userspace with even worse kernel uAPI.
> > > > > 
> > > > > The EFA device already knows this attribute. The problem is that this
> > > > > information is not exposed to userspace today.
> > > > > 
> > > > > So if I go back to our original proposal - exposing the
> > > > > EFA_DEV_CAP(dev, P2P_DMA) bit through query device - this is a firmware
> > > > > attribute that says "this device does not block PCIe peer access on its
> > > > > end." It's not a topology claim, it's a device property, similar to how
> > > > > we already expose RDMA read/write support.
> > > > 
> > > > And how does that help you if you actually need reachability? You
> > > > haven't said directly what you are even trying to achieve (though I
> > > > have a pretty good guess).
> > > 
> > > On some platforms P2P is blocked at the device level despite the fact
> > > that the peer GPU is reachable over PCIe.
> > 
> > This idea just doesn't exist in Linux.. It is completely inappropriate
> > for a PCI device to declare it knows something about the
> > topology. That's not how PCI works, it is the wrong place for your VM
> > to signal information about the PCI routing through the EFA driver.
> > 
> > That needs to come up to the P2P subsystem.
> > 
> > > This mainly happens in multi-instance setups where there is a need
> > > to manage PCIe bandwidth or prevent noisy neighbor effects. Today we
> > > check this attribute on the device during MR registration, so
> > > libfabric's EFA provider allocates GPU memory and attempts to
> > > register an MR to get this information.  This process is costly,
> > > thus we are trying to replace it with a simple capability check.
> > 
> > Which is the right thing to do, again if it is slow go talk to the
> > people who are making it slow..
> > 
> > > > Precompute it and use a topology file like everyone else?
> > > 
> > > This is an option but it seems like a big overkill for the simple
> > > check that we need.
> > 
> > Maybe there is some other place you can inject into the VM a 'this vm
> > does not support p2p' flag that userspace can see?
> > 
> > Leon has been working on some ACPI enhancements for this, perhaps that
> > new table could be distilled down to a single sysfs under an acpi
> > directory?
> 
> Looked at Leon's patches and it does seem like the right place to expose
> such peer relations. Although it wouldn't help with our immediate need,
> maybe we can add a sysfs interface on top of Leon's patches to expose
> the gathered accessiblity (and maybe also performance) information.
> 
> Leon, what is your opinion on this?

ACPI tables are available here /sys/firmware/acpi/tables/, this will
include our new p2p HMAT extension.

Thanks

> 
> Michael
> 
> > 
> > Jason
