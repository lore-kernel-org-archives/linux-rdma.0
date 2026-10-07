Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA70C45A287;
	Wed,  7 Oct 2026 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381059; cv=none; b=UG+SPmfSkrvfXlCGZdLw/dOyWNIsJexUdOAaCydiQEL8Fc7XweP3cTWPx4rzjJ3vGKLM2bq920yqDSkwihsjUM9hzZZWAApjYZciMdR1WgW7cbCeyZNu3So8K/5fzyNUtx2Siml7Pl0IXXJAG0GB+vZ9LchoEyeux0uSAaIcKSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381059; c=relaxed/simple;
	bh=idwY4yyE4yrbcS+m0AUMe4/vP4sler0GEpgHkkuCuzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7AdZQpHNNdVW1ftvPDixOCATQS0sp+RDOdWQGmQTeljVb3Eo6D6JjmhR24p80E0qoKDicI8aGBhK09yrFavIrtX200LAio82CDwKe1NQOmMjxms4e/UEdoY2utGppYrXqL9qxsLfNtc+w3zTmXm8aLchGegMegCzblYVmF0nKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjQgmPnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjQgmPnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A4D1F0089B;
	Wed,  7 Oct 2026 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791381049;
	bh=1shPG4ZK7PMcDI/u1JoCLyyFAzztG3l8pUDkDi8PnMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HjQgmPntYWukekS4isKgEoaEI0YgYaa+J7dSy2VcyfslrCHoyEYXOCAlgLlz19NcR
	 ItQy6KmofW1ILo8FWaD7RFVo9zAI1pwHbZIUosTXgq4byEJDlJHVHzkkTn3TJjmMig
	 KqVJJOlrLwzl4Y7f1cx27EEnYhlhRt47oKViVGP7tDY6fYohcFbX6onxkx3PY2ZxNj
	 Z9FJXVDIW94u9C85e+KA3u75zw28NZ/T8uh8qXWvvQ4FW8exvmsz1+CdJp1ThtK53N
	 uInKu6uJmJfx/aJf0tsqrOwriH7LYFLxfrKSLqOloLlMATybqcP8bTMTaB4ef1yX9i
	 F+nbmWETw9JaA==
Date: Wed, 7 Oct 2026 16:50:44 +0300
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
Subject: Re: [PATCH v9 06/18] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Message-ID: <20261007135044.GG7822@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-6-1a8e0f50ddd9@nvidia.com>
 <20261006214858.GA717151@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006214858.GA717151@bhelgaas>

On Tue, Oct 06, 2026 at 04:48:58PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 01, 2026 at 02:55:14PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > calc_map_type_and_dist() reads each divergence port's ACS Control register
> > and folds the result into running counters as it goes. Any routing property
> > that depends on the kind of TLP being routed would have to be threaded
> > through that code, so there is nowhere to put one without reading the
> > registers again for each kind.
> 
> What is the "one" that there's nowhere to put?  I guess the routing
> property?  So this is an optimization to avoid some config reads?

Right, cache the ACS bits, since we need to query them for both devices
whenever we calculate routing.

Thanks
