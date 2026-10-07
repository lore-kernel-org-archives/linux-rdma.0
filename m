Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C48749DB98;
	Wed,  7 Oct 2026 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370297; cv=none; b=ucWu3TH6emHWLUlXYtwnWp3VkVxiz2jL/jmZuDwTOCuZMq7S5Yeze5k4oYjmvDZhq0ggvXIebE24E1QN+hsUDs4YU3f3WTB8F7RVbrprfWaSd8LagMs44xWhg4fx5xwwZt3pmgSPk6MZKa/JvvAfR7hNPGjRWPJ9v1UiAFbq6ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370297; c=relaxed/simple;
	bh=J+DFMDnlZ3G9MVUQd4T8u6HsYYM3KMhWI8aLB4phSgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzVNRhsRYQNCFQIdiVId3n9sffvqzy3o8S4F62py5bEHvA+WaNm3oB5Y62t/5ph3qs96S/QybuapxvNT/WMalF1JISmBLo6GMmg85UY+zYg+t/F+lePzXgUaadZZf32jeIx4TJ5mWlScHETkQYRsxg4axc8shRok1nbBSz1GAr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aB0CPojg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aB0CPojg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D201F0089B;
	Wed,  7 Oct 2026 10:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791370268;
	bh=weSi5GskMQcEeS2NiW1uUS0DljvEtWiOygax9Ns7zp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aB0CPojga/mp5PJnUHNynUO3VHoezNfPEjLWND7BpXC8J4A+Z4VctOV0EybFyiCXA
	 LlYp+FK1nbqf0as+ZbN6Tco7T6z4qAB/edMjNHhgXQLk3WDy3+/9RYGLamn/UHJ+Pp
	 ZvLlvcbTDFnXxNsYhj+fHc24kE1SenB9XFzDFjNDvZ5EQI6v5LFoC1yibaRNzuHplB
	 nBKlna6sthqpyLF2Tss+WOBkeYgO+5N12aegqpOwKWgyeVLO4QbzHaORjfSK8R82Rm
	 mx+WM6PP8z8AH0dvvVRwbAyph4bkrTOMGqFmFAVWepY6r/5+2/mVscuFGz5Re0tPOD
	 1k9ZJmr0mZRvw==
Date: Wed, 7 Oct 2026 13:51:04 +0300
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
Subject: Re: [PATCH v9 04/18] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
Message-ID: <20261007105104.GD7822@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-4-1a8e0f50ddd9@nvidia.com>
 <20261006210848.GA712422@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006210848.GA712422@bhelgaas>

On Tue, Oct 06, 2026 at 04:08:48PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 01, 2026 at 02:55:12PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > ACS redirect controls choose between peer and upstream routes only at the
> > path divergence. Applying them below that point rejects valid nested
> > topologies because traffic already has only an upstream route.
> 
> I guess the point here is that prior to this patch,
> calc_map_type_and_dist() returned PCI_P2PDMA_MAP_NOT_SUPPORTED in a
> case where it didn't need to?  Can you include an example to make this
> concrete?

One possible example I had in mind while preparing the presentation [1] was
ability to connect devices to different switches. Despite devices and switches
support P2P, but from the P2P subsystem's point of view, traffic between them
was not P2P (see slide 4).

This support will become even more important when we reach the point of
enabling P2P inside a VM. It will allow us to hide the underlying PCI
topology from the VM.

Thanks

[1] http://lpc.events/event/20/contributions/2508/
