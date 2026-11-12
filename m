Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794475412;
	b=oNDa1IrUJ33ZOBgG43kwsyvET0LgliV1xKqMCH9ElhD/Y0Ic3Uvy/Ysf+WNseaRzWTgc
	 p872RlPz+F5lughFbMXJqHGf3EedU4L+3Pr10rhEYHIMvtXd5/1uLJQqDPzsh6hV4ItHE
	 /qz5PQqy+9xbrDJF88Q2Oq7CTZdawG6bnHQMI5ir24wfZXkshpYVDSGvtp1hVTnr38aux
	 xI5AQVB+fK4F8du8faMvVqBK1LxmlvgjykSEQMPiXRHhi/fTZ4GdxJKouA5f0Yyp3H0tm
	 faVnrpzOQCj0E4hZbjpYq6m/j8gUJcvhxr2RjIo5bR47m25+dCM4ozV8+r0VgTI9ZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475412;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=Yt4A8NZadS0W5LYvptZOhNRvoJ7zuxm37iF0wtrvYzQ=;
	b=RJvk3NdUNtQSobUQf2OIJy/h7+fYdne7s44IeHFxrDgTmcOCgzjz+i8joEtmk9IJrxnv
	 nzQwWkv4YpD3NWH8RLgDdjLOle9Z6wgt6gkBMkzSUSK9sZwTVETQoD8Y1P2XhOQiFtFiS
	 yqIk2GUCaaOkysrzXjQlzlqaZSU8RWFLsjIv/Vkhnl+0GEt+fSAMY01DZXV7+hlTgxCHi
	 zvuMKlZOvcHNcOhzdrBDpsl7d5R76/Qrva0V5JIqCEWTKU4kQ0b6uM4+zmbeJ0MkWCVUC
	 tYOCBFE8xsI7SFR6QBEfMx3UmVCRu+MxiMy+EmnT/NN5uQ1488n0vGcKhDkzunckoww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Al8XrrSs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E25606A32E;
	Thu, 12 Nov 2026 09:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Al8XrrSs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11CC1F00A05;
	Thu, 12 Nov 2026 09:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475411;
	bh=Yt4A8NZadS0W5LYvptZOhNRvoJ7zuxm37iF0wtrvYzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Al8XrrSs8SlF0Ee63VyaB5C5G3Uo5XX4ccMBtcpNj1/nlgPcep7aeKERTSWgnucOp
	 MfDI/asrfWa/3CEmg6pEOW0iwUBXTbrstHK+aT1k/N2rH9Ze++0BQyE3m5E+Bsvhla
	 Li75qTYXiN8XuLzDwXR8iTaIguGAuDTQE2CzXwvzHiWzxEQE/Ee8NN8ZEee7hLNl61
	 N4HHHSK9uoj65Dbf4ioWvuiLsqurNOmaBgvsD1iZXXvUzX8srVURqbXYCpIx3J/ZGz
	 +ThyHkvnZ3z8Ki/YNSmcFC2kOCj7mKH9R4pbLysLKP+MoYmyyEJ9f00YCJEhD/InKP
	 yDI53+WDSqvfg==
Date: Thu, 12 Nov 2026 11:23:26 +0200
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
Subject: Re: [PATCH v13 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261112092326.GU8635@unreal>
References: <20261111121602.GQ8635@unreal>
 <20261111224136.GA754433@bhelgaas>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261111224136.GA754433@bhelgaas>

On Wed, Nov 11, 2026 at 04:41:36PM -0600, Bjorn Helgaas wrote:
> On Wed, Nov 11, 2026 at 02:16:02PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 05, 2026 at 12:04:31PM +0200, Leon Romanovsky wrote:
> > > Punch line for Linus from Jason:
> > > "Enhance detecting if the PCI fabric can support a peer to peer path
> > > by evaluating the full bi-directional fabric path over each of the
> > > three traffic type ACS controls. Expand the number of fabric
> > > configurations where the P2P algorithm makes the correct determination
> > > of support to include non-uniform ACS and situations where translated
> > > takes different routes from untranslated."
> > 
> > Bjorn,
> > 
> > Just a friendly reminder.
> 
> Thanks for the reminder.  I put this on pci/p2pdma for build testing
> (no issues expected; I always try to get build testing before merging
> into linux-next).
> 
> I'm still struggling to describe this in a way that connects to the
> code changes and is accessible to non-experts, so please correct
> things I get wrong here.

When asked to explain what I’m working on during hallway conversations, I usually
start with a top-down view:

“In order to support P2P in VMs, the virtual PCI topology needs to know whether
P2P is possible. However, the guest OS cannot see the physical topology because
it is hidden by the hypervisor. Since the VM and hypervisor run the same OS, we
need a generic way to report whether P2P is supported, rather than relying on a
CPU-supported whitelist. This is why we need ACPI HMAT [1].

However, HMAT alone is not enough: it is static and comes from firmware, the
BIOS, or the platform. We also need to account for ACS registers and different
traffic types.

This series provides the ACS, traffic piece of the puzzle.”

[1] https://lore.kernel.org/linux-pci/20260812-hmat-p2p-v1-0-75ac41380585@nvidia.com/

> 
> I had the impression that this series helps VMs by making P2PDMA work
> with passthrough devices in cases where it currently doesn't, but
> maybe that's not the case; I don't see any mention of that in the
> series.

It is a fundamental building block (see my explanation above), but it is also
useful on its own. Even without VMs or HMAT, ACS and routing are important
(see the removed patch [2]): they allow us to dynamically enable or disable
ATS for each DMA mapping, support asymmetric PCI topologies, and more broadly
enable P2P by checking every PCI route.

This is why I didn't mention VM to the cover letter.

[2] https://lore.kernel.org/all/20260920-fix-p2p-acs-v4-0-v7-19-ca0828ab697c@nvidia.com/

> 
> IIUC the P2PDMA core doesn't actually *control* any TLP routing, i.e.,
> it doesn't change any ACS controls or change any TLP attributes that
> affect how TLPs are routed, so to me, these subject lines suggest more
> than is actually happening:
> 
>   Route Relaxed Ordering Completions directly
>   Reject Translated Requests blocked by Translation Blocking
>   Route Translated Requests under Direct Translated P2P
> 
> It seems like we're just *learning* whether RO Completions will be
> routed directly, whether Translated Requests will be rejected, etc?

Right, the path and these bits are static.

> 
> I think the core basically looks at the ACS controls on the path
> between two devices and decides whether:
> 
>   (a) the devices can do P2P DMA directly (PCI_P2PDMA_MAP_BUS_ADDR),
> 
>   (b) they can do P2P DMA but only through host bridges on the
>   allowlist (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE),
> 
>   (c) no P2P DMA is possible (PCI_P2PDMA_MAP_NOT_SUPPORTED),

This is equivalent to returning -EOPNOTSUPP when the functionality is
unavailable.

> 
>   (d) PCI_P2PDMA_MAP_NONE -- I don't understand this one; the comment
>   says "not a P2PDMA transfer", and pci_p2pdma_state() returns it when
>   the page is not a p2pdma_page, I guess because
>   pci_p2pdma_add_resource() has not set MEMORY_DEVICE_PCI_P2PDMA?
>   Not sure how this is used.

This means that this is regular DMA transfer which involves CPU.

> 
> I guess one benefit of this series is that a path where P2P Completion
> Redirect is set used to mean that pci_p2pdma_map_type() would return
> PCI_P2PDMA_MAP_NOT_SUPPORTED (unless the RC was allow-listed), and now
> it might return PCI_P2PDMA_MAP_BUS_ADDR because if P2P Request
> Redirect is clear, Requests can be routed directly?

I'm not sure the first part (return PCI_P2PDMA_MAP_NOT_SUPPORTED) is correct,
since callers have so far ensured that P2P is supported before calling this
function. The second part is correct.

> 
> That sounds great as long as the Request uses Relaxed Ordering, so the
> Completion won't be affected by P2P Completion Redirect.  But devices
> aren't *required* to use RO even if enabled, and I'm doubtful that a
> non-RO Completion redirected to the RC is going to work.  So I don't
> understand how p2pdma.c can guarantee safety.
> 
> Translated Requests seems similar -- are we assuming that if ACS
> Direct Translated P2P is set and ATS Enable is set, the device
> *always* generates Translated Requests?

PCI spec allows "A Function is permitted to intermix translated
and untranslated requests" and p2p doesn't decide anything except
if routing is possible or not.

Thanks

> 
> Bjorn
