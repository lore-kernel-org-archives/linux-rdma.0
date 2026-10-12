Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD14E361961;
	Mon, 12 Oct 2026 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806252; cv=none; b=pVSpt9HR3CJwOUWX62z54Ah6nIutD23qR+P3XgEaKFq4yytvZxpkFxqMGRr9A515Da7KQfj2p9ljG5abbhRhuERB+TySQ8LQzzN6xm60B9g3+ykV4zIln5wXLuqhLBFldkVlahWeIbDeecQEXI9MjPrh6jy8wJcDCilLHRVY5wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806252; c=relaxed/simple;
	bh=zHKVY/NJvHBNZ9hB3vMb1iEOuHc9AyYoNpqdlMl+GP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5vlnsC3kq/HEQMppNDlJjmRwHZ+PCH0iV8qlQBH/hHfx2vLfHb7UmKX61EQOKWBHdPyLqc7yRYOVchcC0LYUmf8bxlBmO3HSy147uWRkg57b9icJxKm4ZBHRGkzWI4xtL/MNPKCQNBbF/wWG8EEATX9ME04PBhtBhWOBUbfxgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXwZp/P7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXwZp/P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE761F0089B;
	Mon, 12 Oct 2026 11:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806250;
	bh=dIdf0EGX3pGuBo+uaCGYdHblHIOFatYE3He9grPS0X0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RXwZp/P7uRNArmaAhe0CHt6e5o5jX04SLyCRKlf2SJazfM0blAKjm8KtZvox63ONT
	 Reb4NOOE4ucQMY0rI7BcHL662fhJg6LRTFOcgaa9ZFldfLNDM1uP2lyc5/dIbBRde6
	 FLipsxi0fmaesgVy06bTQkR9gCv3h51b8JbMGMyFpVueZ7YvGwFqQkPpjbaMWHfQLI
	 bcAUtReyeQ0A5sQRVhlrk2EIf9dNtDmB5eCSdauNtFppTsAn+uwz9V6rXOyvUsxl/y
	 CGJ+3BFX2IneJRacFb4dMFWzKpbojw0mDD8EmP6rHM22Rme7630rx+LR3QHJgSYJLK
	 B2G/agcYNEbFQ==
Date: Mon, 12 Oct 2026 14:57:27 +0300
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
Subject: Re: [PATCH v9 07/18] PCI/P2PDMA: Answer routing per TLP class
Message-ID: <20261012115727.GF219304@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-7-1a8e0f50ddd9@nvidia.com>
 <20261009212529.GA1086940@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261009212529.GA1086940@bhelgaas>

On Fri, Oct 09, 2026 at 04:25:29PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 01, 2026 at 02:55:15PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > calc_map_type_and_dist() returns one mapping type per provider and client,
> > valid only for strictly ordered Requests carrying an Untranslated address.
> > Clients that use Relaxed Ordering or ATS cannot ask what the fabric would
> > do with their traffic.
> > 
> > Add enum pci_p2pdma_tlp_flags to name a class and pci_p2pdma_map_type_tlp()
> > to ask about one. The topology walk and the ACS Control reads do not depend
> > on the class, so decide all of them from the one walk and cache them
> > together, four bits each. Every class still answers alike; the controls
> > that tell them apart come next.
> > 
> > Tested-by: Tushar Dave <tdave@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/pci/p2pdma.c | 159 +++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 128 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 841c86be31bb..43e225cc5735 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> > @@ -492,6 +492,33 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
> >  	return NULL;
> >  }
> >  
> > +/**
> > + * enum pci_p2pdma_tlp_flags - Properties of the TLPs a client will issue
> > + *
> > + * These describe the traffic rather than the topology, and select which ACS
> > + * controls apply along the peer-to-peer path. A value of 0 means strictly
> > + * ordered Requests carrying an Untranslated address.
> > + *
> > + * @PCI_P2PDMA_TLP_TRANSLATED: Requests carry an ATS Translated address. PCIe
> > + *	r7.0 sec 6.12.3 routes those to the peer regardless of ACS P2P Request
> > + *	Redirect and ACS P2P Egress Control wherever ACS Direct Translated P2P
> > + *	is enabled.
> > + * @PCI_P2PDMA_TLP_RELAXED_CPL: The provider returns Completions with the
> > + *	Relaxed Ordering attribute set. PCIe r7.0 sec 6.12.1.1 never redirects
> > + *	those, so ACS P2P Completion Redirect does not gate the path. The
> > + *	Completer chooses this attribute and the specification does not require
> > + *	it to copy Relaxed Ordering from the Request into the Completion, so a
> > + *	caller passing this flag asserts that its provider does.
> 
> It doesn't sound right to me that Completers choose the attribute.  I
> thought *Requesters* chose the RO attribute based on their design
> (knowledge about which transactions require strong ordering) and their
> Enable Relaxed Ordering bit.  Sec 2.2.9.1 says:
> 
>   - Completion headers must supply the same values for the Attribute
>     as were supplied in the header of the corresponding Request,
>     except as explicitly allowed:
> 
>     - when IDO is used (see § Section 2.2.6.4)
> 
>     - when RO is used in a Translation Completion (see § Section
>       10.2.3)

You are right, while the code is correct and we indeed expects from
"Requester" to chose, the comment is not correct and needs to be
changed.

Thanks
