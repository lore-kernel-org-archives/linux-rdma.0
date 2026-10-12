Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE94741167F;
	Mon, 12 Oct 2026 10:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802637; cv=none; b=WrZ4Ze4LGcKo3I4G2fsTWH2gfVSXKN3zKFfbW+XzXqpWhulry3UwFQ3zWgWZ1dXZeT8clNr4oZ3u0yIHS0/vW+RTaOGHA95aeMDHJY6qnpSilwtj1fBKK7kBPtT0rA4yqj2OtaiQR5uLNZeH5kg6OK1uVpFCivTSt+t7GVbpQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802637; c=relaxed/simple;
	bh=LKhSCJ5F6yxqjFh5cS8xS7fTK9cfNzXKPzVsS6EDDt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQiVKn5KWoDd9GfFf/zmRY15WimuURvqPSEedXXlAZLyF2/ZVGXtbGmBZAnCVe84ng84PeWp3eqIELXTqWy93guIKgZc0ZgEcmTUftimm6O5dyBq5YYyXcnEm2xOGyXy8cb0jO0ixZqEAeGRYGqp+wjkZQTr4rzUM+fyG1p1a8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ww/TM8pW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ww/TM8pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B41F0089B;
	Mon, 12 Oct 2026 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802635;
	bh=xbC+yf7W/9NgxGXA244OT/ptq9frA+41G9nWB1s/IoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ww/TM8pWebbCbnXF049H+rr5GcvdFwXDLefJVHvquehv7bwCLS/7dsU0TF1GAQprI
	 kmiiNk3wePjVKitVm/2wqe197cD5bjwFPdUYRAU0uF+4MjEE6xXnVdOtI+sJbSATqU
	 /C3h/1fbIAo+n9oQyWo7GBNM7AjgcRJ8cInlz/0OjhJ6H56qbu9/ypRlanmOgv8nXe
	 OWFb6JuIa8226F5DYNHSHKcSrbpm/PZSWWwOLPdsqyDnQtywvzGe+0KGu9YmjWuNSF
	 jSslVmt2y4vuW7csg5UndDYBd4bih4gOYdg/sIHzpcsx0nXuK46DBipQkgS2kTxkPr
	 CREpK16ec3WLQ==
Date: Mon, 12 Oct 2026 13:57:10 +0300
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
Subject: Re: [PATCH v9 08/18] PCI/P2PDMA: Route Relaxed Ordering Completions
 directly
Message-ID: <20261012105710.GC219304@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-8-1a8e0f50ddd9@nvidia.com>
 <20261006222109.GA719055@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006222109.GA719055@bhelgaas>

On Tue, Oct 06, 2026 at 05:21:09PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 01, 2026 at 02:55:16PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > ACS P2P Completion Redirect leaves Completions carrying the Relaxed
> > Ordering attribute alone. PCIe r7.0 sec 6.12.1.1 redirects only those "that
> > do not have the Relaxed Ordering Attribute bit set", and sec 7.7.12.5
> > describes the enable bit as "applicable only to Completions whose Relaxed
> > Ordering Attribute is clear". P2PDMA reports one answer for every kind of
> > TLP, so a client whose provider returns such Completions is sent through
> > the host bridge for a redirect that never happens to it.
> 
> I guess pci_acs_p2pdma_completion() returned PCI_ACS_P2PDMA_REDIRECT
> even for RO Completions?  But that didn't change the hardware
> behavior -- maybe the caller *thought* Completions were routed through
> the host bridge, but they actually weren't.
> 
> I kind of lost the plot here.  What does the caller do with this
> information?  I don't think a device is *required* to set RO even when
> it is enabled, and it may set RO on some transactions but not others.

The mlx5 patch, which is currently on hold, uses the
PCI_P2PDMA_TLP_RELAXED_CPL TLP flag to dynamically enable or
disable ATS.

https://lore.kernel.org/all/20260920-fix-p2p-acs-v4-0-v7-19-ca0828ab697c@nvidia.com/

Thanks

> 
> > Add enum pci_p2pdma_tlp_flags and let a caller state that property.
> > 
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Tested-by: Tushar Dave <tdave@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/pci/p2pdma.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 43e225cc5735..1fadef6d0609 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> > @@ -544,11 +544,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
> >  /*
> >   * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
> >   * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
> > - * affects a Completion.
> > + * affects a Completion, and that one leaves Completions carrying the Relaxed
> > + * Ordering attribute alone.
> >   */
> >  static enum pci_acs_p2pdma_state
> >  pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
> >  {
> > +	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
> > +		return PCI_ACS_P2PDMA_DIRECT;
> > +
> >  	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
> >  				   PCI_ACS_P2PDMA_DIRECT;
> >  }
> > 
> > -- 
> > 2.55.0
> > 
