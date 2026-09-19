Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A3A2B9B7;
	Sat, 19 Sep 2026 04:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789792757; cv=none; b=GflFr1aRHJ+PuwZdCIQgu6y7Xtkgs1LeRnwHE1FT0k+oXlMSIYeLCb4B5QsxNGwk23C/yer95WM7B7oVE7kHs3oSMC72bi0nw/Bb9mU0quHgTi15MqGmoeRhDKT1L3jKqXSVPLYDO9CtXP8DPeTW5DoN89rYCuXWMMmGad5spUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789792757; c=relaxed/simple;
	bh=OvzvCShvMMIyGA68THVgyk5YaLtsd0zcLW9UY7FgFCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKdtaW9WXVPSoPwRhuXvM/MKrlTFC9OuctM/KLgitrayKadn2qIa2MlIXySxUnA1GI9n59TWKvOdtVdqwKxcmt1G6N472yDd9bx1ih6tb8U8kqc5hkWkI8/BcZ05f0xCb0Lsk1LWUK2noc5TKZ1L5/T610zCq3OF8eNv/+nnXIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdc0Xb46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdc0Xb46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551AD1F000FF;
	Sat, 19 Sep 2026 04:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789792756;
	bh=Igi4RHLJYWAKmVb+cd2dtDK1WqzkkFZ7X+ZVpe9M7cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gdc0Xb46lJVg8B0Ky3G0HTiETukThppICzF4vRLwyqtfTgn+OE2gznNkHPnuVAGJY
	 K9Uxjjwig9JL6g81dNk6F8CBwe2qfsHjEcyYUpyHnEF0QU0XZx3mCcejc9ulWoA73t
	 cUyf5iI7JwQ/Dne01j5S/F9qfVk6I9+TXhLkJI/IF5Ty9oDLe1rOCoL9oDKZFRr5Bz
	 xMXVH3hljWKb0sw+4kVmogm2dnUqqwtWc5EPHrti3+K9eNozLx7YvvhQWh9a14/87S
	 9whWSzdtS+08iIYTTQm7J1iG6vmO4t1WXjlcB5Tq/vlj8N3R1nj5PSQwgK5lPxgj89
	 d/EgkVMuN0ntw==
Date: Sat, 19 Sep 2026 07:39:11 +0300
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
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Matt Evans <matt@ozlabs.org>
Subject: Re: [PATCH v6 01/18] PCI/P2PDMA: Document pdev->p2pdma lifetime rules
Message-ID: <20260919043911.GA13683@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-1-5ef07ec9ef06@nvidia.com>
 <6e4f0c2f-eae8-4cd5-9c10-9b9a59941d2f@deltatee.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4f0c2f-eae8-4cd5-9c10-9b9a59941d2f@deltatee.com>

On Fri, Sep 18, 2026 at 12:25:01PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2026-09-14 05:22, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > pdev->p2pdma is normally accessed through provider-owned references, but
> > pci_p2pmem_find_many() and the p2pmem sysfs attributes may race with driver
> > unbind.
> > 
> > Document initialization, teardown, and how the release grace period
> > protects both the P2PDMA state and its optional allocation pool.
> > 
> > Cc: Alex Williamson <alex@shazbot.org>
> > Cc: Matt Evans <matt@ozlabs.org>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reads correct to me.
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks, Logan. Unfortunately, I'm inclined to drop this patch. AI review
makes it nearly impossible to write the description without complaints.

If I use my own words to describe the lifetime, the tools complain about
almost every word or sentence. If I let the tools write it instead, the
result is complete junk that merely describes basics already obvious from
the code itself.

Thanks
