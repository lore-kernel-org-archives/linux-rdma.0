Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70894CE69E;
	Fri,  9 Oct 2026 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791567787; cv=none; b=L/f3YYSRDFjNdXMITwPtSQJ5VtKbvudNduxd3qj08Gq3FyVGxrt2hQpO/EDHwCc9JG2WBvGpS3EDfo72kybUtgvPgzF95FmtaLN7V7nxQ3mzf9g3Ra1H9GkGcTVHSut2HQOAr5llK7kVu78rRpafYVFtz9mvAh56o3t8Rd4aaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791567787; c=relaxed/simple;
	bh=mLiQqzGLzW31eYbHCnl2GntdGqvBueCmcEVKVxHtV3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj4QlkqSQobDbIAFOvqthedtZfy5TzVlg97S1DCdyMpTso7TzZl9Y8A064OoV8OjxEOJoJIC9cLbSPHAsACdCVIWspA5WnaKVYGd5+uB2YuQT1yX1slEXdxDTrsji1eS/ss86ZoN8mxscN8sHyR9tycCK/xpqjyTLryQyqhRk8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCpHTy2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCpHTy2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB21D1F000FF;
	Fri,  9 Oct 2026 17:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791567786;
	bh=U0s03iNrq790So+pbxwkgjCu207XK/E0NIw4uR3r3S4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dCpHTy2kRayrBM7jKK+ewjW+/1nlHlYFvCNzUWHvIu4BhDEB40Ckb1z6CuG6HTcHP
	 k0R5edj57wikOJaKKbUpz/U6Uj2TkOq3otUC/mhhMHhIX1qtO+Abkqvj1HGZ1Suwsb
	 9gv70Q5NfRUrjEy02QyerM0P1NLHA9bxKt0wf6Gwfz+6DPhCjog6Gzf+m6XKDFMWVz
	 4V63bvdWNQqHPqcGFyl3Cja06HwpnTIU2Ppi+uVZvAm12V1aM7HOlI1P/OJDDrZFuK
	 vza8KWGlZrphMiubCqZL0OEZzyaXsLrJGdfDm4YSvNuV+YQn7ap18HyVVtuVFDiDku
	 ptjFns74hSqpw==
Date: Fri, 9 Oct 2026 20:43:01 +0300
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
Subject: Re: [PATCH v9 02/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
Message-ID: <20261009174301.GC11438@unreal>
References: <20261007063227.GC7822@unreal>
 <20261007204045.GA783967@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007204045.GA783967@bhelgaas>

On Wed, Oct 07, 2026 at 03:40:45PM -0500, Bjorn Helgaas wrote:
> On Wed, Oct 07, 2026 at 09:32:27AM +0300, Leon Romanovsky wrote:
> > On Tue, Oct 06, 2026 at 03:49:47PM -0500, Bjorn Helgaas wrote:
> > > On Thu, Oct 01, 2026 at 02:55:10PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> > > > interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> > > > direction can unnecessarily force P2PDMA through the host bridge.
> > > 
> > > Does "the reverse TLP direction" refer to Completions?
> > 
> > In general, the P2P code treats TLPs flowing from device A to device B the
> > same as TLPs flowing from device B to device A.
> > 
> > However, in the context of this commit message, yes: completions flow in the
> > opposite direction from the device's perspective.
> 
> And I guess asymmetric fabrics must mean fabrics where Request
> Redirect and Completion Redirect are not set the same way?

Yes, in some of our systems, deviceA to deviceB is going through
different route than deviceB to deviceA.

> 
> > > > Evaluate Request Redirect for client Requests and Completion Redirect for
> > > > provider read Completions. Continue treating enabled Egress Control
> > > > conservatively as a Request redirect.
> > > 
> > > Completion Redirect is intended to avoid ordering rule violations
> > > between Completions and Requests when Requests are redirected (PCIe
> > > r7.0, sec 6.12.1.1).  I assume this patch preserves the ordering rule,
> > > but does the commit log need to say something about that?  I don't
> > > know enough about P2P DMA for it to be obvious to me.
> > 
> > I don't think so, i didn't change anything related to ordering.
> 
> I don't think there's anything in this whole series that changes any
> ACS settings, so I shouldn't have wondered about *preserving* the
> ordering rule.
> 
> But I asked about ordering because it sounds like this patch expects
> to encounter asymmetric fabrics where Request Redirect and Completion
> Redirect may not be set the same way, and the spec implies that
> asymmetry may result in ordering violations.

My guess is that the hardware and system architects have ensured this
doesn't happen. At least, I haven't received any complaints about this
series during internal testing.

> 
> > > Not really a question for this series, but p2pdma.c and p2pdma.rst
> > > refer to "clients" and "providers", neither of which are mentioned in
> > > the PCIe spec.  In this case it sounds like a client is a Requester
> > > and a provider is a Completer in spec terms.  Is that always the case?
> > > If so, "client" and "provider" in this paragraph are not adding any
> > > information.
> > > 
> > > If "client" is not the same concept as "Requester" and "provider" not
> > > the same as "Completer", maybe p2pdma.rst could explain the
> > > difference?
> > 
> > Client vs. provider are actual target vs. initiator. They express the
> > device role in the flow.
> 
> I'd rather use "Requester" and "Completer" when possible because they
> have specific meanings in the PCI spec and they correspond to the ACS
> control bits.  Client, provider, target, initiator are all from the
> outer world that makes use of PCIe constructs, but they don't mean
> anything inside the PCIe world.

These names come from p2p users such as dma-buf and NVMe. I didn't want
to rename them as they already exists and is in use inside p2p code.

Thanks

> 
> Bjorn
