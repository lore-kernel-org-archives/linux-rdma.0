Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D5B2D2381;
	Wed,  7 Oct 2026 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791403819; cv=none; b=RQ1N1GQCqb1CMgl5p+DVpphktz0MApPs3AfDoj4VIErNfL22C3S6HFz/mLmAkfmqyyfcDyYMc1wvLcJhuIxaoP0VXKS60QJOCPYHxljG7MphQInXWUaHFH9VAu3tlAhLjMtis9HEqkL5l/JxJky0P6iPEkIh7cxzYK0K0YrmzvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791403819; c=relaxed/simple;
	bh=54icOuuUwXmNmg4TfNkqpRGviaV/OPBnITiEsz2i+z8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=jd5Z0of5RDxLoOhroNT80xyOrOiF8zwQrkTitYmFimKnWnSuLhm9b5HXh9bVkz4rzCCxtnk8EUQTf9mfly3aMWOZdcGHYNY2nLs/PXMKYqrq1QvDXm2KjrzWuee3CnDWXW5X5454qm5LxL5RbQjjzEpNK7E8uKk08iDsXmAKw7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjaCEpxM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjaCEpxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A743B1F000FF;
	Wed,  7 Oct 2026 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791403817;
	bh=aa2oEqoLgcxfDk2tkT0+VE+vyr1xxJnXC2sMgkbjLJM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=HjaCEpxM4UO3eYRp0gNAbKalLyREiz/+BiDN19lJU7lnz4T7jwwgyG6M8Bo/1pVKv
	 YPVreUOMFDnpZrUJWvM9gqqamCBkJWsB93o0MH9lElCX2pMCR7/TjP4qPh8O0ul1sX
	 N0WydXeChLTf/CCXJmVygOw/WaTG1q/Q2wT4XpjPSkrli0+xE5prjVzKYbsV+SxmvW
	 IJyw8FWsBOmJ5H2dRgHw6IHv4Bbyhb1vGCJbgCn6fXRzB8cKdKnZC4A5M6M5ECq3qV
	 cOJ7IswyyvPvmyXfbsAsccoWFPr3nBJcDFYS2qyqg7vxxP/wkO3M5qQwipgRn8vA04
	 5ajNW2dn8309A==
Date: Wed, 7 Oct 2026 15:10:16 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
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
Message-ID: <20261007201016.GA778574@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007134658.GF7822@unreal>

On Wed, Oct 07, 2026 at 04:46:58PM +0300, Leon Romanovsky wrote:
> On Tue, Oct 06, 2026 at 04:32:05PM -0500, Bjorn Helgaas wrote:
> > On Thu, Oct 01, 2026 at 02:55:13PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > P2PDMA documentation describes ACS controls as path-wide, although Request
> > > and Completion controls apply to different transaction directions and only
> > > affect peer-versus-upstream decisions at the path divergence.
> > > 
> > > Document the fixed client and provider roles, the divergence port checked
> > > for each TLP direction, and the conservative handling of unreadable ACS
> > > state. Clarify which controls disable_acs_redir changes.
> > > 
> > > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > > Tested-by: Tushar Dave <tdave@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  Documentation/admin-guide/kernel-parameters.txt | 15 +++++++++------
> > >  Documentation/driver-api/pci/p2pdma.rst         | 13 +++++++++++++
> > >  2 files changed, 22 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > index 68647ff4bdd2..bc83e07dd5fc 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -5291,12 +5291,15 @@ Kernel parameters
> > >  		disable_acs_redir=<pci_dev>[; ...]
> > >  				Specify one or more PCI devices (in the format
> > >  				specified above) separated by semicolons.
> > > -				Each device specified will have the PCI ACS
> > > -				redirect capabilities forced off which will
> > > -				allow P2P traffic between devices through
> > > -				bridges without forcing it upstream. Note:
> > > -				this removes isolation between devices and
> > > -				may put more devices in an IOMMU group.
> > > +				Each device specified will have the PCI ACS P2P
> > > +				Request Redirect, Completion Redirect, and Egress
> > > +				Control features forced off. This may allow P2P
> > > +				traffic through bridges that would otherwise be
> > > +				redirected upstream. This may allow P2P traffic
> > > +				through bridges that would otherwise be redirected
> > > +				upstream and thus this removes isolation between
> > > +				devices and may cause affected devices to share
> > > +				an IOMMU group.
> > >  		config_acs=
> > >  				Format:
> > >  				<ACS flags>@<pci_dev>[; ...]
> > > diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> > > index 80f8fec9b0e9..42b18610bf7d 100644
> > > --- a/Documentation/driver-api/pci/p2pdma.rst
> > > +++ b/Documentation/driver-api/pci/p2pdma.rst
> > > @@ -15,6 +15,19 @@ then based on the ACS settings the transaction can route entirely within
> > >  the PCIe hierarchy and never reach the root port. The kernel will evaluate
> > >  the PCIe topology and always permit P2P in these well-defined cases.
> > >  
> > > +The client remains the PCIe requester when it reads or writes provider memory.
> > > +Where the paths diverge, the kernel therefore evaluates P2P Request Redirect
> > > +and Egress Control on the client-side port, and P2P Completion Redirect on the
> > > +provider-side port for completions from a read. An enabled Egress Control is
> > > +conservatively treated as a Request redirect.

Does "client remains" imply that the client can also be a Completer in
other circumstances?  I'd like to use PCIe terms when possible since
we're talking about PCIe ACS controls.

s/requester/Requester/ since it's defined by PCIe spec.
s/completions/Completions/ similarly.
s/Request redirect/Request Redirect/ to match spec.

s/and Egress Control/and P2P Egress Control/ to match spec and RR and
CR mentions here.  The second "Egress Control" matches the "Request
Redirect" so I think that's fine.

> > I think "where the paths diverge" means the point where a port decides
> > whether to route a TLP up through its Upstream Port (or to the RC) or
> > back down via a sibling Downstream Port?
> 
> Yes.

Am I right in thinking that there may be several such points e.g., a
Request is routed back downstream by any Downstream Port where P2P
Request Redirect is not enabled?

I think this "paths diverge" needs some background when it's
introduced, e.g. something like this (fix or reword as necessary):

  If the Requester and Completer are below the same Root Port, the
  path taken by Requests depends on ACS settings of the Downstream
  Ports above the Requester.  If ACS P2P Request Redirect is enabled
  in all of them, the Request is routed upstream; otherwise it will be
  routed back downstream via the Downstream Port leading to the
  Completer.  The path of Completions likewise depends on ACS P2P
  Completion Redirect in the Downstream Ports above the Completer.

> > I'm not sure p2pdma.rst includes the context to interpret "divergence"
> > yet.  I think the code comments in [4/18] might also need a little
> > more context about divergence.
> > 
> > IIUC, this divergence point is basically a static point where the ACS
> > controls being applied makes a routing difference.
> 
> Right. Previously, we did not account for ACS bits, so any "junction"
> automatically caused P2P to be considered unsupported.
>
> > > +Below the divergence, the route toward the other branch is already upstream,
> > > +so those P2P redirect controls do not affect it. Redirect controls for the
> > > +reverse transaction directions do not affect the mapping. P2P DMA is routed
> > > +through the host bridge when either applicable port redirects. If an ACS
> > > +Control register cannot be read, P2P DMA is rejected because the kernel cannot
> > > +establish a usable route.

Similarly, I don't think "the divergence" is defined yet here.  I
*think* it means the lowest Switch or Root Port shared between
Requester and Completer.  That's the first point where a TLP could be
either routed back downstream or upstream.

I think a TLP could also be routed back downstream if a higher Switch
Downstream Port or the Root Port had Request/Completion Redirect
cleared and lower Switch Downstream Ports had it set.

> > > +
> > >  This evaluation assumes clients issue strictly ordered Requests carrying an
> > >  Untranslated address. Its result is not defined when clients use Relaxed
> > >  Ordering or issue ATS-translated Requests because those TLP attributes can
> > > 
> > > -- 
> > > 2.55.0
> > > 
