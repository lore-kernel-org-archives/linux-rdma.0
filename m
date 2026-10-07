Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EAE3A6EE5;
	Wed,  7 Oct 2026 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380833; cv=none; b=Lek7fDdMSo363owNjpltc2slirayEPprBGBziIM5LQYt64kfI355YNPH2YAEWhH15y62sKKxCGR+o4PxV3c5K4YM6OwLLX0lVPeHfXGb/JbDu7h3o92t5P/HaDpxG4X1Ip9M2cAAcGV/Nf2JwAySK2Apl3MS8X700goaWizGdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380833; c=relaxed/simple;
	bh=GiHgJGOD4vTaulCRzGazZo1n7LLOYXLA7Wbs5WRyYig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdGGeZHO5iuJb28p+BWExl1MgjSjda5L/90tDdd3/JL3z8G3SEGIjZF2VODhdH5tzIw2eECRGEdCc97btq/19Vn/lGwWth29JFTvJuzZWEDpmFtR4ZmgLtzzPsz0IJtlDeLjGHW/TiVmxYMT6fSKKyREsj7OMmR1T6gkkQIj1C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMlgI1hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMlgI1hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279BF1F0089B;
	Wed,  7 Oct 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791380822;
	bh=vpfwYGClDuRl26lqIMKOLS8bH5yxmBXmaYs6FO3Op4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LMlgI1hbp3tF4Daa3wnI+FsLCOaruBnf5FNDiteB8k/EzlltSYal+5EV3GfnCLz6g
	 nnujVsnHVjiKgpDlPvBhq/KRqOTrGRSs08hOPe5ulBL99+F0zYLLD+jXEFvmsdP2vk
	 QOIE8CxsWScNlEQ/QlmEBKUnJpXAt5TtZpuwJL98vh7aZPAPfLR0MrHTyDoU/AGJnL
	 QMCU60wW7/vgzjn8Z2jnwJ5Y6vQUNrq/IkEm/9O4nQMetgR86IApVzaRxfAaIWyPiZ
	 Kov7z6a+rnS0BAyuZLlK+WcpVLuT72sAvPTCbDfUZrzOVsB25+F3EotmpPSeJueSi9
	 mlRedJKsPEBjg==
Date: Wed, 7 Oct 2026 16:46:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Subject: Re: [PATCH v9 05/18] PCI/P2PDMA: Document directional ACS routing
Message-ID: <20261007134658.GF7822@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-5-1a8e0f50ddd9@nvidia.com>
 <20261006213205.GA713622@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006213205.GA713622@bhelgaas>

On Tue, Oct 06, 2026 at 04:32:05PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 01, 2026 at 02:55:13PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > P2PDMA documentation describes ACS controls as path-wide, although Request
> > and Completion controls apply to different transaction directions and only
> > affect peer-versus-upstream decisions at the path divergence.
> > 
> > Document the fixed client and provider roles, the divergence port checked
> > for each TLP direction, and the conservative handling of unreadable ACS
> > state. Clarify which controls disable_acs_redir changes.
> > 
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Tested-by: Tushar Dave <tdave@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/admin-guide/kernel-parameters.txt | 15 +++++++++------
> >  Documentation/driver-api/pci/p2pdma.rst         | 13 +++++++++++++
> >  2 files changed, 22 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 68647ff4bdd2..bc83e07dd5fc 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -5291,12 +5291,15 @@ Kernel parameters
> >  		disable_acs_redir=<pci_dev>[; ...]
> >  				Specify one or more PCI devices (in the format
> >  				specified above) separated by semicolons.
> > -				Each device specified will have the PCI ACS
> > -				redirect capabilities forced off which will
> > -				allow P2P traffic between devices through
> > -				bridges without forcing it upstream. Note:
> > -				this removes isolation between devices and
> > -				may put more devices in an IOMMU group.
> > +				Each device specified will have the PCI ACS P2P
> > +				Request Redirect, Completion Redirect, and Egress
> > +				Control features forced off. This may allow P2P
> > +				traffic through bridges that would otherwise be
> > +				redirected upstream. This may allow P2P traffic
> > +				through bridges that would otherwise be redirected
> > +				upstream and thus this removes isolation between
> > +				devices and may cause affected devices to share
> > +				an IOMMU group.
> >  		config_acs=
> >  				Format:
> >  				<ACS flags>@<pci_dev>[; ...]
> > diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> > index 80f8fec9b0e9..42b18610bf7d 100644
> > --- a/Documentation/driver-api/pci/p2pdma.rst
> > +++ b/Documentation/driver-api/pci/p2pdma.rst
> > @@ -15,6 +15,19 @@ then based on the ACS settings the transaction can route entirely within
> >  the PCIe hierarchy and never reach the root port. The kernel will evaluate
> >  the PCIe topology and always permit P2P in these well-defined cases.
> >  
> > +The client remains the PCIe requester when it reads or writes provider memory.
> > +Where the paths diverge, the kernel therefore evaluates P2P Request Redirect
> > +and Egress Control on the client-side port, and P2P Completion Redirect on the
> > +provider-side port for completions from a read. An enabled Egress Control is
> > +conservatively treated as a Request redirect.
> 
> I think "where the paths diverge" means the point where a port decides
> whether to route a TLP up through its Upstream Port (or to the RC) or
> back down via a sibling Downstream Port?

Yes.

> 
> I'm not sure p2pdma.rst includes the context to interpret "divergence"
> yet.  I think the code comments in [4/18] might also need a little
> more context about divergence.
> 
> IIUC, this divergence point is basically a static point where the ACS
> controls being applied makes a routing difference.

Right. Previously, we did not account for ACS bits, so any "junction"
automatically caused P2P to be considered unsupported.

Thanks

> 
> > +Below the divergence, the route toward the other branch is already upstream,
> > +so those P2P redirect controls do not affect it. Redirect controls for the
> > +reverse transaction directions do not affect the mapping. P2P DMA is routed
> > +through the host bridge when either applicable port redirects. If an ACS
> > +Control register cannot be read, P2P DMA is rejected because the kernel cannot
> > +establish a usable route.
> > +
> >  This evaluation assumes clients issue strictly ordered Requests carrying an
> >  Untranslated address. Its result is not defined when clients use Relaxed
> >  Ordering or issue ATS-translated Requests because those TLP attributes can
> > 
> > -- 
> > 2.55.0
> > 
