Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E8541D114;
	Sun, 20 Sep 2026 11:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904076; cv=none; b=Fty3JRM31sjZ8+qW4EsV7J09iUUCOD6DW/DiSvZaIROzKp1xFWfvMuFlvFX2U4ZnjPaL05+HAcnBsictrrNjfCcQ9AgiYSO5JqvQOkoJqz/uq1MbvuYb2706x10ukCIutyu4eZv+SCUKvlQgiXUTYDAEz+TOctZWhl4BtRZV4/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904076; c=relaxed/simple;
	bh=AgKD8Uj0OpBdM8shwpSH1OHw7CNV/LdHw7aGJqG/6Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVEbiVRIdc4RDAmDviSNLOsiHNz8c7zKwUzmXIzZgYl2zt753TOR6CjhVAWd7kv3txgK2TareL0CHc/j4Fo+6pAqcP3K3yXKy6xsTJbQ+4FLrPvKm92I1ASIEbEK4TGM0lNor7RzuqHP/TnVq/4unAQy9jZX7duyVcAvDgDsa/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFMSaX2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFMSaX2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F8B1F000FF;
	Sun, 20 Sep 2026 11:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904065;
	bh=o19pe/ZOLyrZCZ3xyrwO1dORVM3jdvZ7EUMrrqzx/sc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VFMSaX2QgFUMmyoiYEHSjLc/YfwGFUF3rSLLzSb2RiXDkOR7tmvx4AY/6QchwV3wu
	 xeWUQxUhhztHSVXpmcqxd4iqduYww8bbeCtiHJfpMz1pfMiQUuaj2PbxBLbmtc2AVs
	 RW4amWSOxw0/mXmmK9XiN4M56nT+PJrStacNKmoGeJhzwjU/TClMc1A93FPpvV1qj0
	 4kvnM+JB1F/VN7YizD46bisQXK96UBmamDCtbu9NznIAdQIistrUXjdXzPIOeaoz44
	 Loan/RBqqvKvQOhKbpql7J+qkl05ra9OO2t3kzyrMr2XjYrj2CZWkqgAm0EWLqgRjI
	 3aMGDeyQ5tflA==
Date: Sun, 20 Sep 2026 14:34:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 03/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
Message-ID: <20260920113420.GA563127@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-3-5ef07ec9ef06@nvidia.com>
 <19bee27e-17d7-4b67-b796-ca5bb44e8de7@deltatee.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19bee27e-17d7-4b67-b796-ca5bb44e8de7@deltatee.com>

On Fri, Sep 18, 2026 at 01:39:55PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2026-09-14 05:22, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> > interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> > direction can unnecessarily force P2PDMA through the host bridge.
> > 
> > Evaluate Request Redirect for client Requests and Completion Redirect for
> > provider read Completions. Continue treating enabled Egress Control
> > conservatively as a Request redirect.
> > 
> > Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Core patch seems fine, minus one minor point below:
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> 
> > @@ -1132,10 +1173,10 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
> >  /**
> >   * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
> >   * @provider: P2PDMA provider structure
> > - * @dev: Target device for the transfer
> > + * @dev: Client device that initiates the transfer
> >   *
> >   * Determines how peer-to-peer DMA transfers should be mapped between
> > - * the provider and the target device. The mapping type indicates whether
> > + * the provider and the client device. The mapping type indicates whether
> >   * the transfer can be done directly through PCI switches or must go
> >   * through the host bridge.
> >   */
> > 
> 
> This hunk does not seem like it belongs in this patch.

This is the first patch that distinguishes between client and provider
and starts using that terminology instead of target/initiator. Therefore,
the change belongs here.

Thanks

