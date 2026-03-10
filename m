Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B67318ED7
	for <linux-rdma@vger.kernel.org>; Tue, 10 Mar 2026 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167881; cv=none; b=rFotPBQTZtjU4iyWTJwDonVJWmhXRTpL8/WjtoW3GJn9wZphjIJSfg/krk78KZwzETRg+hMWqlBdlZZBAagdLjC9vrfX9yH9x2sLBnTFSA2HnNdX8Mzn9l8YNKBzLgeQGjmhgq99sR5QkUN9IaAXvVIeRwTTRjW75D2O0lSt1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167881; c=relaxed/simple;
	bh=16btx5e1aaY4Ghrj6UyNp2Vi4b9na63bFfeNTvfEqeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOLLX5r6uRCDlLsvnRMLAsx5VgnK7niDRh5Uxk5EEIpffj0eWluarCKn4XEUztgqLx3ZUklZ6C64DBGmAx0hHb+0UBCO07kCHAcKLvWf8CNqiuDr0KeOuyFLIeiN6iQaKJRVkMTMsOPQA8zyFmu+l+6/lgF3/Hz5OaDTe36uLqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2LGuELt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2LGuELt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314F1C19423;
	Tue, 10 Mar 2026 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773167881;
	bh=16btx5e1aaY4Ghrj6UyNp2Vi4b9na63bFfeNTvfEqeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P2LGuELtF3QNko5WrRwWq7g9Jiv6f4/W/Gmx0jZk5HsTgf90GbAxG3Ys4yupkGfSI
	 yBxHosCmMdF0IAxfseM+XKMucVxWBXvDRTk5EjF9lV6IThC29FGnzKMXK6BEAra/mf
	 xApBAJ67SBL8K6TnwKzz/tvSPlI0aHL0a51raFf1Gyyzlds7Z1WthJOuSpEDh7IxmS
	 qGJDR44c5r+F1Vpl8OuEoG8QofWt7kB7Jrez0RUy5qgn7gq08lDksgqm5sha5EK8G3
	 I107fZhzo+7lF03CQ9TDaXWSqUDZKbtSBfwbMMg1TZ7Kn7nkLUS9dq7OcbGgwyY5Y6
	 197WOVkEtz7UQ==
Date: Tue, 10 Mar 2026 20:37:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgg@nvidia.com>,
	Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH] RDMA/rw: Fix MR pool exhaustion in bvec RDMA READ path
Message-ID: <20260310183756.GH12611@unreal>
References: <20260310034621.5799-1-cel@kernel.org>
 <abAftjplHdwdwrkd@infradead.org>
 <d0fefc47-b60f-47ba-8f2f-7eb05b1bb86d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0fefc47-b60f-47ba-8f2f-7eb05b1bb86d@kernel.org>

On Tue, Mar 10, 2026 at 10:36:43AM -0400, Chuck Lever wrote:
> On 3/10/26 9:42 AM, Christoph Hellwig wrote:
> > On Mon, Mar 09, 2026 at 11:46:21PM -0400, Chuck Lever wrote:
> >> Under NFS WRITE workloads the server performs RDMA READs to
> >> pull data from the client. With the inflated MR demand, the
> >> pool is rapidly exhausted, ib_mr_pool_get() returns NULL, and
> >> rdma_rw_init_one_mr() returns -EAGAIN. svcrdma treats this as
> >> a DMA mapping failure, closes the connection, and the client
> >> reconnects -- producing a cycle of 71% RPC retransmissions and
> >> ~100 reconnections per test run. RDMA WRITEs (NFS READ
> >> direction) are unaffected because DMA_TO_DEVICE never triggers
> >> the max_sgl_rd check.
> > 
> > So this changelog extensively describes the problem, but it doesn't
> > actually say how you fix it.
> 
> I didn't want to waste everyone's time, but I can add that.
> 
> 
> >> +	 *
> >> +	 * TODO: A bulk DMA mapping API for bvecs analogous to
> >> +	 * dma_map_sgtable() would provide a proper post-DMA-
> >> +	 * coalescing segment count here, enabling the map_wrs
> >> +	 * path in more cases.
> > 
> > This isn't really something the DMA layer can easily do without getting
> > as inefficient as the sgtable based path.  What the block layer does
> > here is to simply keep a higher level count of merged segments.  The
> > other option would be to not create multiple bvecs for continguous
> > regions, which is what modern file system do in general, and why the
> > above block layer nr_phys_segments based optimization isn't actually
> > used all that much these days.
> 
> Technically, NFSD isn't a file system, it's a protocol adapter.
> 
> 
> > Why can't NFS send a single bvec for contiguous ranges?
> 
> Have a look at svc_rdma_build_read_segment(). The RDMA READ path builds
> bvecs from rqstp->rq_pages[], which is an array of individual struct
> page pointers. Each bvec entry covers at most one page.
> 
> This is because I/O payloads arrive in an xdr_buf, which represents its
> page data as a struct page ** array (xdr->pages), and svc_rqst::rq_pages
> is likewise a flat array of single-page pointers. These pages are
> allocated individually (typically from the page allocator via
> alloc_pages()), so there's no guarantee of physical contiguity. Even if
> adjacent pages happen to be contiguous, the code has no way to know that
> without inspecting PFNs (which is exactly what the DMA mapping layer
> does).
> 
> So currently svcrdma can't send a single bvec for contiguous ranges
> because the contiguity information doesn't exist at the NFSD or RPC
> layer. Contiguity is (re)discovered only at DMA map time.
> 
> The alternative is to build an SGL for mapping the bvec so that rw.c can
> get the real contiguity of the pages before proceeding. But that seems
> icky.
> 
> Long term, I expect that NFSD will need to preserve the folios it gets
> from file systems and pass those to the RPC transports without
> translating them to an array of page pointers.

Folio sounds like a correct approach to me, why do you mark it as "long term"? 

Thanks

> 
> 
> -- 
> Chuck Lever
