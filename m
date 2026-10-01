Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FE2381EAF;
	Thu,  1 Oct 2026 06:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835478; cv=none; b=Z8oJsynp6sBr0jiPgcvnmmesbuTZW4uub+FMW4fVIcYsS7chRy1l3ZbRddcNuUJFLRbwhTdsVllZ/bKmxRCxh29oaTmIUvhfLnOCsW5FokiaX25Ol6HxxL3YnC00OWKJt+LJPKuUXtOaPzGWOuizgDJXrnXu6/TgYWVjjnjxPjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835478; c=relaxed/simple;
	bh=bdjZ2ksMrimHVAeNkXQXzTtwi9GLiSP/enN5YzvRaeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QblMKd+4FTgh+e/1Yqw3ng2z8B4vyu7MLqAaUbjcwea+k1N5NM0PqEwfyIybRb2Nf7tIZbC0WdqCwWxNJVTNJQNMwFJ8zkvxJE+cTyhaaT1DGEWpbiBZiKoqlkdq64zMFNzq9owsDo/5bioB6gAUWqwTGOrKz2iVW0vkj/eewuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uiy59Iu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uiy59Iu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AC01F000FF;
	Thu,  1 Oct 2026 06:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835477;
	bh=PzeZRK3gY0+Qmg3bEyZe//3N5u+pNkNVRn1dnWCLqAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uiy59Iu7dkAPfC5+dQN02uWT3FtS5tIi1Bu/Hml2SIogm+MBBYrhVrawxx4gjJW7i
	 kep9+QGlBZDlLynjNcLYdzvhCno0eW7ZZtDCje7IAXYWdWjtEHvtQ4ktJpcPXDcg9y
	 QKepGUrqcPvxI0/e3Os06WyFUjrHiwNs0ilGv8Y7Wvd9WbfAeeT5VVEsTux6YVZWls
	 gsorZV+cvm3ZjW+pc9iKFENVLt71++wgb7vz8Xhi8OECk7Yp23kGMQOlNryrkm0zfr
	 Z0/c50xGiUKCoTBHoWMJ8Z6srtBvC19W7YjlHqU5wnPwM35/reXMJ5LMsDSuIG6LwJ
	 RCiP09TZEDVsQ==
Date: Thu, 1 Oct 2026 09:17:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
Message-ID: <20261001061752.GJ3401365@unreal>
References: <20260929132305.GJ563127@unreal>
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
 <20260930143237.GI3401365@unreal>
 <ed393791-46d5-40ad-998b-4ac0e1e9c6fa@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed393791-46d5-40ad-998b-4ac0e1e9c6fa@amd.com>

On Wed, Sep 30, 2026 at 04:52:20PM +0200, Christian König wrote:
> On 9/30/26 16:32, Leon Romanovsky wrote:
> > On Wed, Sep 30, 2026 at 01:52:39PM +0200, Christian König wrote:
> ...
> >>> The importer needs a way to obtain device information from the exporter so
> >>> that it can configure itself correctly.
> >>
> >> That won't work with DMA-buf then, the exporter is completely opaque to the importer and that is for really good reasons.
> >>
> >> Why in the world does the importer needs to know the information from the exporter before the mapping is created?
> >>
> >> It is the exporter who decides how data is accessed by the importer and not the other way around.
> > 
> > There are several reasons:
> > 
> > 1. This is how DMA-BUF MRs are built in RDMA. In mlx5, they rely on the ODP
> >    mechanism, which requires an MKEY to be created first. See commit
> >    90da7dc8206a (“RDMA/mlx5: Support dma-buf based userspace memory region”).
> 
> I know that patch, but I absolutely don't understand where the problem is.
> 
> > 2. P2P routing is a property of devices, not memory. It is known and remains
> >    stable.
> 
> No, absolutely not. You are making completely incorrect assumptions how DMA-buf works.

Maybe, but I understand how the kernel, PCI, and P2P DMA work, and dma-buf
seems to operate in a parallel reality that is not aligned with any of them.

> 
> Again: What is exported and from which path is up to the exporter and only determined when you create a DMA-buf mapping!

Let's discuss the PCI P2P case, where `p2pdma_provider` is present. In this
flow, the exporter has a PCI device, and the importer also has one when it
attaches. The decision about how to construct the addresses is made at that
point. Note that both the exporter and importer are PCI P2P devices, so the
importer should make the request.

> 
> In most cases you don't even have a single device which is the DMA-buf exporter.

How is it possible for exporter with p2pdma_provider?

> 
> Only while creating the mapping the underlying access path is finally determined. It can be that P2P is used, it can be that internal connections are used, it can be that the data is moved to system memory....

But we are talking about in-tree exporters: RDMA, VFIO e.t.c

> 
> That's why we have the distinction between attaching and importer and the importer creating a mapping.
> 
> > 3. See the VFIO TPH ST discussion, where the requirement to obtain the
> >    exporter’s P2P information in the importer was raised again.
> 
> As far as I can see there isn't any. The TPH/ST information are just passed through from the exporter to the importer.
> 
> We could define a bit better what needs to come first the mapping or the TPH/ST query but for their use case that is actually irrelevant.

They need an access to p2pdma_provider too.
https://lore.kernel.org/linux-rdma/CAH3zFs2rhg6-b-pVDps1V8LsM4Dn48t4J4LFVyKOZtT4axdY=Q@mail.gmail.com/

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Thanks
> 
