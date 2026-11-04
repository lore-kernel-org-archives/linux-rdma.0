Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821950;
	b=b7KzeYl8Vq5xgPwDFCnUDHogrtnGHqIxNrv6nbSTr+48iBmwLeGCVghaJt9zgm5WhaIx
	 wQ3iX9Dpd0dsSAOYymSy+ER/v7ijrkxwkNvZsrRiJEKMAfEXFVV01bVa+Ny8j3NQH4z3W
	 2G/gfVOaSfgno/COe2GvkopP2/n9QcURmC2vaqIY+k5N8KwHdGyJvZ5LBmX2COHKnHxoD
	 B/WJlf2pBrBGS5CtTAzygsp1/LkXhuENpZhSgTfVms2tMkQkO/eZcKF3weom0l5NHRJdW
	 HYnFd3EGr5Kn02yo4FRzO9Rc20KZyZGf4Uk4G9oLyLTnFt3UY71+Dx0REFneBIyYFhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821950;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=L07m2wog8AXR293hC7wTAXwEB108EvydUujWlLJOS7k=;
	b=AOYykXl4hEGw3/0XKaYth/8bEvRc0ZWXfDlNvCb/CjUcPZxx5isFefbhoYTeBrSHh8hb
	 XjT6pJAKTnjLhUJshv/Q4KThswJle3zranTsaU1BZBlZoFc1o0PWo7K7lTGAh/GAcKGIV
	 74aSzJ0SCg8tUBYiMuCU4YoHMNugJvNIrJ3Ya5IORYjeXUdkybfpxDuqW/muadLPDHnb3
	 /Hwuz1oBUwaOV7ZJ7p9YqTuwfobOGdaq6nPL1xQvHzdAdC8/pmoFjadJcSA2/PnnFoTgH
	 /TFrV3fqpGVpEyT4thGRgeCXJJiNNQyBLapgDed482D8T1zzvWdVfBw2PEzJ2K9+wOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tngz3kAr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2E60D8785;
	Wed,  4 Nov 2026 19:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tngz3kAr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153AC1F000C1;
	Wed,  4 Nov 2026 19:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821949;
	bh=L07m2wog8AXR293hC7wTAXwEB108EvydUujWlLJOS7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tngz3kArIJr/FCTQecjk4Shv6JJTM59ST2VF34ZadkpeYJ07PybUi07DSlO5i+Lcc
	 BR3xuLP685IVZSVeTudkEydtaHvNT27bijsHdB/DfS5Op1gyYMOzm/YIwALKmnGEEd
	 pnaWfctGLzgd/kpEHK1zF1zzbJO/XvUGti+HfhqM7r3HJeHonwfpn2a+Z+2CKBMObQ
	 Pw82Y1W0REeHcm1tHA4k+WLMNBeS+eYtyl8WFgweX/UB5AfA6xoO2ECFibwrwsSAEY
	 UNVm8tllZewsPCCMrK9apq0WrX7YsjkklLlsnx8gLtWN3piM8BYXfNireITBbtAyGY
	 uClTjhZd5Mc7Q==
Date: Wed, 4 Nov 2026 21:52:25 +0200
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
Subject: Re: [PATCH v12 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261104195225.GI478286@unreal>
References: <20261104084328.GP264423@unreal>
 <20261104171412.GA1247928@bhelgaas>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104171412.GA1247928@bhelgaas>

On Wed, Nov 04, 2026 at 11:14:12AM -0600, Bjorn Helgaas wrote:
> On Wed, Nov 04, 2026 at 10:43:28AM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 03, 2026 at 05:37:42PM -0600, Bjorn Helgaas wrote:
> > > On Tue, Nov 03, 2026 at 10:29:39AM +0200, Leon Romanovsky wrote:
> > > > PCI P2PDMA applies Request and Completion Redirect throughout
> > > > both paths.  This misclassifies asymmetric and nested switches,
> > > > and reports one answer for every kind of TLP.
> > > > 
> > > > Three ACS controls act on TLP attributes the Requester chooses
> > > > rather than on the topology: Translation Blocking and Direct
> > > > Translated P2P act on a Request's Address Type, and Completion
> > > > Redirect skips Completions carrying Relaxed Ordering.
> > > > 
> > > > Evaluate each direction at the path divergence, decide every
> > > > class from the one walk, and treat a client with ATS enabled as
> > > > translating unless its driver declares per-mapping ATS.
> > > > 
> > > > This completes the P2PDMA side; dma-buf and mlx5 follow
> > > > separately.
> > > 
> > > Is there a one- or two-sentence explainer of why we want this?
> > > I'm thinking in terms of what Linus will want in the merge
> > > request: a fix for something that's broken or some new
> > > functionality.  It sounds like this is solving a problem, but I
> > > don't know enough to translate the nitty-gritty details to the
> > > higher-level user-visible problem or feature.
> > 
> > Not AI; these are my own words with grammar fixes from AI:
> > 
> > "The existing implementation of PCI peer-to-peer assumed that all
> > PCI TLPs were the same: ordered and carrying untranslated addresses.
> > It did not account for the variety of traffic types defined by the
> > PCI specification. As a result, only simple systems supported
> > peer-to-peer transfers in the upstream kernel; real-world systems
> > required out-of-tree patches and careful platform design.
> 
> Can we be any more specific?  E.g., what makes real-world systems
> different from simple ones?  What does careful platform design mean?
> Something about ordering beyond what PCIe requires?

I needed this series for GB300. I never asked to see for out-of-tree patches
to enable P2P on that system, but P2P did not work with the upstream kernel
without this series. In complex systems, the routing path between two
devices can include multiple PCI bridges with ACS settings. In simple
case, ACS will be 0 and not used.

Careful design ensures that P2P devices share common host bridge.

> 
> ACS P2P Completion Redirect affects Relaxed Ordering (RO) Completions.
> Translation Blocking and Direct Translated P2P affect Requests with
> Translated addresses.
> 
> So I assume the existing P2P implementation breaks somehow when RO or
> Translated addresses are used?  How does it break?

Jason tried to document it in the comment above mlx5_umem_needs_ats().

Thanks

> 
> > The new code will allow peer-to-peer transfers between any two
> > devices, for all types of PCI traffic, as long as the PCI path
> > between them supports peer-to-peer.
> > 
> > This paves the way for PCI peer-to-peer support in VMs, which the
> > upstream kernel does not currently support."
> > 
> > BTW:
> > 1. The patch "PCI/P2PDMA: Document the TLP attribute assumptions"
> >    attempts to explain the current situation.
> > 2. The change is too large to present as a fix.
