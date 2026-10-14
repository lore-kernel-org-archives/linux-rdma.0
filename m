Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824572FD696;
	Wed, 14 Oct 2026 06:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791960832; cv=none; b=tULKElxlCB5bzSghcqgFNQXs+q/z0Fwuyp5gAKMpVWG9cpaDiyN/sW24PwJCrjy3JWmkZczDZxWaj+hXm/FbLKNPSJD9B6FVgXtbSjmoGlwAXxJvyNkcdkeoIbAOIj6/cBGiJCfSxI0GHiytkaQ+cQUJpJ7Gay4Ye6Ac9vOc9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791960832; c=relaxed/simple;
	bh=ioauh8jEjcNN0oXjWVsLxXk+ksMjmNDCMR6ErAColhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6sBbwKgGRYVTs3ggXwI80U7zoWwikRkK5efYRtmzawH+8jB4a9z/7U36zbcbg628GTcwiuaStMXiHkqfeneIkaQYDFGVWESj9vc5MywpPSkW7s6ftMJt0pYj8ZSqfHDV66KdSAGKz45Ylxsu26Z79wtDbTYHEcgGOVuXyv+GMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQon1WRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQon1WRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8941F000FF;
	Wed, 14 Oct 2026 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791960831;
	bh=wJBG1yc6nHxcLlJB5Xe3WD+42x4ELJs97WwmBWzAW7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gQon1WRCQUKmhwaRgO1mq76qgm8/r+H1pT/Ft/j+xOYOjF5zDwdetwmlHqKvilzq/
	 KTh3TIak5Mj2bN7plOyk9GGgphftr9mGHc1SnZ8lcICnoRV49QdLjJB/EPSKR9Tf7u
	 1n6knDThQzYyNOaNuoXKYQnYa+57YmNU6ZjlXvc4qerq9/Rok53HUtyPkv3Zc6bpOv
	 UGdkuW+v1UQZ4j6q+2vdiNWmTG8zXfAmmm689xz8SK9tHO5tgPK3aHh3zeU+M4aDTk
	 VI5FQMibAD4k9v+W8953u0FR4ZPzq5V3YlgtAzmJo9S+H12oTh5foLjimVgBPJ+OV/
	 10Qj5KfCHB5AQ==
Date: Wed, 14 Oct 2026 09:53:47 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
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
Subject: Re: [PATCH v11 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261014065347.GW219304@unreal>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>

On Tue, Oct 13, 2026 at 05:25:08PM +0300, Leon Romanovsky wrote:
> PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> This misclassifies asymmetric and nested switches, and reports one answer
> for every kind of TLP.
> 
> Three ACS controls act on TLP attributes the Requester chooses rather
> than on the topology: Translation Blocking and Direct Translated P2P act on
> a Request's Address Type, and Completion Redirect skips Completions carrying
> Relaxed Ordering.
> 
> Evaluate each direction at the path divergence, decide every class from the
> one walk, and treat a client with ATS enabled as translating unless its
> driver declares per-mapping ATS.
> 
> This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Changes in v11:


Bjorn,

Could you please save me from the AI-bot attack? Every rebase seems to
uncover another bizarre pre-existing issue. It never ends.

Thanks

<...>

> ---
> Leon Romanovsky (19):
>       PCI/P2PDMA: Honor device-specific ACS redirection
>       PCI/P2PDMA: Document the TLP attribute assumptions
>       PCI/P2PDMA: Derive routing from directional ACS controls
>       PCI: Reject unreadable ACS controls in isolation checks
>       PCI/P2PDMA: Evaluate ACS controls at the path divergence
>       PCI/P2PDMA: Document directional ACS routing
>       PCI/P2PDMA: Collect the path's ACS controls before deciding
>       PCI/P2PDMA: Answer routing per TLP class
>       PCI/P2PDMA: Route Relaxed Ordering Completions directly
>       PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
>       PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
>       PCI/P2PDMA: Log detailed ACS routing diagnostics
>       PCI/P2PDMA: Add KUnit tests for the ACS routing decisions
>       PCI/P2PDMA: Test the ACS P2P routing walk
>       PCI: Add KUnit coverage for ACS isolation checks
>       PCI/P2PDMA: Document TLP-class routing
>       PCI/P2PDMA: Let a client declare that it selects ATS per mapping
>       PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
>       PCI/P2PDMA: Test the routing of clients with ATS enabled
> 
>  Documentation/admin-guide/kernel-parameters.txt |   11 +-
>  Documentation/driver-api/pci/p2pdma.rst         |  105 ++
>  drivers/pci/Kconfig                             |   15 +
>  drivers/pci/Makefile                            |    1 +
>  drivers/pci/p2pdma.c                            |  942 +++++++++++++++--
>  drivers/pci/pci.c                               |    8 +-
>  drivers/pci/pci.h                               |   57 ++
>  drivers/pci/pci_acs_test.c                      | 1225 +++++++++++++++++++++++
>  drivers/pci/quirks.c                            |    8 +-
>  include/linux/pci-p2pdma.h                      |   12 +-
>  10 files changed, 2292 insertions(+), 92 deletions(-)
> ---
> base-commit: 36038f0e8377ef316b723d0d85b1510bc64069ab
> change-id: 20260821-fix-p2p-acs-v4-0-e72455e3a261
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 
