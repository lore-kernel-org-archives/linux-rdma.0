Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9606945A2BD;
	Wed,  7 Oct 2026 10:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370480; cv=none; b=SR4F2H8rZzbuwR/iaQUnMRlJ8+d0friQqlzLdAgiyYEhqGbaZ7m2IXZmuYVUfV/X0L/zVz+Fr2lJ0XEDn7rgqrem25EqNLQ56kD8Iz1/b5G/1BFTHKf3MRfCo8fgKzio9JGgJnfal2GH13+IWoLVMt6C+ubZCx2dvv7JmKDVkSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370480; c=relaxed/simple;
	bh=V55R8SAuqlFQorvkL6orijSqh3O7uPPYrcF3c4x6/VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTadyd4UIy3cxEQjq1N5ZRBFOn0Gjrm7jDq3PoIzedS2Ega3E0N1BHwVjaKHWsXwbtS9T+XU+sTWW/gzMijDMq6TU9lvAxMfCJK3o+t+wfK+/0wwmo3KlfheGUP60wqKYs4PB82jUb0f9ORfIuU07FWlTjBDUbW+xdrdVPZ7Sk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lc494qjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lc494qjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776501F0089B;
	Wed,  7 Oct 2026 10:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791370451;
	bh=uA8p+MDOC9gzZwh78glwvS7UOOYTU0AmigEJLyE3mac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lc494qjL1xY90Qq8b3HA15YxTTdSqmiRIBIXHw+stWAENpxOc0o6ycgT+ojLUzmCp
	 If/oGtK8sqWqWP1p1FeWjJo89tjgEjwaOed0er48LEvgcCN2Bdpc+a3NbhdBm8BwUj
	 KsStxNosrZv9FCvaxqbkW10yhM+BU+xPw9pFRf/pcv7fR4zSYOCeQMx6IHPY7NguXs
	 HZzlMaK0JBQ3i+MHU0mCk9mG/fbOV1LbmUKLdQsKfpt6TKM2ZLv5YkP3GbA37oWbiG
	 wYDYA2ZLNshzWhSXgx3LnhVokOCoftFZnNSs4cNZ9JPhw50gbYcgND6lUnVo7240r7
	 7hkxyDkDrCnsA==
Date: Wed, 7 Oct 2026 13:54:09 +0300
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
Subject: Re: [PATCH v9 00/18] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261007105409.GE7822@unreal>
References: <20261006213650.GA716945@bhelgaas>
 <20261007065644.GA738981@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007065644.GA738981@bhelgaas>

On Wed, Oct 07, 2026 at 01:56:44AM -0500, Bjorn Helgaas wrote:
> On Tue, Oct 06, 2026 at 04:36:50PM -0500, Bjorn Helgaas wrote:
> > On Wed, Oct 07, 2026 at 12:22:27AM +0300, Leon Romanovsky wrote:
> > > On Tue, Oct 06, 2026 at 02:29:55PM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Oct 01, 2026 at 02:55:08PM +0300, Leon Romanovsky wrote:
> > > > > PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> > > > > This misclassifies asymmetric and nested switches, and reports one answer
> > > > > for every kind of TLP.
> > > > > 
> > > > > Three ACS controls act on TLP attributes the client chooses rather than
> > > > > on the topology: Translation Blocking and Direct Translated P2P act on
> > > > > a Request's Address Type, and Completion Redirect skips Completions carrying
> > > > > Relaxed Ordering.
> > > > > 
> > > > > Evaluate each direction at the path divergence, decide every class from the
> > > > > one walk, and treat a client with ATS enabled as translating unless its
> > > > > driver declares per-mapping ATS.
> > > > > 
> > > > > This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> > > > > ...
> > > > 
> > > > > Leon Romanovsky (18):
> > > > >       PCI/P2PDMA: Document the TLP attribute assumptions
> > > > >       PCI/P2PDMA: Derive routing from directional ACS controls
> > > > >       PCI: Reject unreadable ACS controls in isolation checks
> > > > >       PCI/P2PDMA: Evaluate ACS controls at the path divergence
> > > > >       PCI/P2PDMA: Document directional ACS routing
> > > > >       PCI/P2PDMA: Collect the path's ACS controls before deciding
> > > > >       PCI/P2PDMA: Answer routing per TLP class
> > > > >       PCI/P2PDMA: Route Relaxed Ordering Completions directly
> > > > >       PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
> > > > >       PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
> > > > >       PCI/P2PDMA: Log detailed ACS routing diagnostics
> > > > >       PCI/P2PDMA: Add KUnit tests for the ACS routing decisions
> > > > >       PCI/P2PDMA: Test the ACS P2P routing walk
> > > > >       PCI: Add KUnit coverage for ACS isolation checks
> > > > >       PCI/P2PDMA: Document TLP-class routing
> > > > >       PCI/P2PDMA: Let a client declare that it selects ATS per mapping
> > > > >       PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
> > > > >       PCI/P2PDMA: Test the routing of clients with ATS enabled
> > > > > 
> > > > >  Documentation/admin-guide/kernel-parameters.txt |  15 +-
> > > > >  Documentation/driver-api/pci/p2pdma.rst         |  80 +++
> > > > >  drivers/pci/Kconfig                             |  15 +
> > > > >  drivers/pci/Makefile                            |   1 +
> > > > >  drivers/pci/p2pdma.c                            | 719 ++++++++++++++++++--
> > > > >  drivers/pci/pci.c                               |   7 +-
> > > > >  drivers/pci/pci.h                               |  58 ++
> > > > >  drivers/pci/pci_acs_test.c                      | 860 ++++++++++++++++++++++++
> > > > >  drivers/pci/quirks.c                            |   6 +-
> > > > >  include/linux/pci-p2pdma.h                      |  12 +-
> > > > >  10 files changed, 1687 insertions(+), 86 deletions(-)
> > > > > ---
> > > > > base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
> > > > > change-id: 20260821-fix-p2p-acs-v4-0-e72455e3a261
> > > > > prerequisite-message-id: <20260830-batch-p2p-fixes-v1-0-5044e8dfbe2e@nvidia.com>
> > > > > prerequisite-patch-id: 6b25c7fcf164cdfc14e9fac5b908d97fcf6509d7
> > > > > prerequisite-patch-id: 0d083c281001365aae4b35544cf28891a6ab9a96
> > > > > prerequisite-patch-id: bfd9dabf271f3cc9a3a61f46387d20c20311363d
> > > > > prerequisite-patch-id: fad0275efc722830fc591509506c0a5e4f581073
> > > > > prerequisite-patch-id: 0c83bee688fec1f6d1564654df7c630fa6a4a978
> > > > 
> > > > This seems like material for the PCI tree, but I'm not sure how to
> > > > apply it.  It doesn't apply cleanly on the current pci/p2pdma
> > > > (https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/log/?h=p2pdma),
> > > > which does contain your series from
> > > > 20260830-batch-p2p-fixes-v1-0-5044e8dfbe2e@nvidia.com.
> > > > 
> > > > I could probably fix the conflicts but I don't know why there should
> > > > be conflicts, since the only commits on pci/p2pdma other than yours
> > > > are a few trivial allow-list updates.
> > > 
> > > So maybe this is related to these trivial updates, my series was based
> > > on the clean p2pdma branch:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=fix-p2p-acs-v9
> > 
> > Ah, yeah, it must be the allow-list additions that I have but you
> > don't.  I wouldn't have thought the offsets would have been a problem.
> 
> It applies fine if I move the Haswell and Alibaba allowlist patches t
> to the end so the base matches fix-p2p-acs-v9, thanks.

Bjorn,

It is unclear to me if I should to resend.

Thanks
