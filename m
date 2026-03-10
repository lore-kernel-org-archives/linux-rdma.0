Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBEF2E62B5
	for <linux-rdma@vger.kernel.org>; Tue, 10 Mar 2026 14:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153405; cv=none; b=DBTaXqZrJZDeE+/06L0meeSkLcERAZfwgFjdf0hpewY6Tt3Gf9arL9sVOZzOdnfaJoO+EHDKrt89FHaFn0Cbs7zTMUxBBYQrl/kxL17JE5gO8M0re9BMfLvRncwIg3r2vEqByHHdQtTvHUUTFZJLnPFuH1jlFbhYJzDMXZDrnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153405; c=relaxed/simple;
	bh=7bzujJPORarq//eo5hZCpxyca9hEqBvqn37NL23N9us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGCPS5krqGhFUo3xiXpj1zS6orPQzeTp3wM2Ukk9tqHSAMs48xGUoGkti19PP9jar24mBaT2vj0AlXLDqvyEZhXhnUc6NpmvyLo+O8KyYu2UsCZo+iNWj16altRWt4Yq/82Gkhoj4Gfsh7/aR3IwjGHvxLydkE0JGhjXI4HO4Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dop9zoIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dop9zoIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7ADC19423;
	Tue, 10 Mar 2026 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773153404;
	bh=7bzujJPORarq//eo5hZCpxyca9hEqBvqn37NL23N9us=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dop9zoIahIwAC9AmzkJMQFzW6IoW5nEYMLBrRTtu6/od35OUvfZStLNujn+jQIhuC
	 PHl3j2qIFeYGVqb8MqPi9802EZC7DQn9vtBP2p/e5ZWC+eYDjeH35+NL0UfUz7oBB7
	 WUbqH8CVoMtgN1sYmgTV9qFNpl5HWcOF7vaX95TJXF7X2IsbPBfq2PzhO7iy4lnnkE
	 jyKIltfKYIs97FvpKI4kgBfPKpC5xHJe5A7P8YeMjv/d+HJfjoI6b0Fu23QIRWCNuv
	 xszo/wK2VBH1Vsix/AIUNMmGZ2An5H4FjRuxjtbqu3LzDEGg/6FPckdsBmSXSpq7iL
	 Zx5ZGmuiDQt4Q==
Message-ID: <d0fefc47-b60f-47ba-8f2f-7eb05b1bb86d@kernel.org>
Date: Tue, 10 Mar 2026 10:36:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rw: Fix MR pool exhaustion in bvec RDMA READ path
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org,
 Chuck Lever <chuck.lever@oracle.com>
References: <20260310034621.5799-1-cel@kernel.org>
 <abAftjplHdwdwrkd@infradead.org>
Content-Language: en-US
From: Chuck Lever <cel@kernel.org>
Organization: kernel.org
In-Reply-To: <abAftjplHdwdwrkd@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/26 9:42 AM, Christoph Hellwig wrote:
> On Mon, Mar 09, 2026 at 11:46:21PM -0400, Chuck Lever wrote:
>> Under NFS WRITE workloads the server performs RDMA READs to
>> pull data from the client. With the inflated MR demand, the
>> pool is rapidly exhausted, ib_mr_pool_get() returns NULL, and
>> rdma_rw_init_one_mr() returns -EAGAIN. svcrdma treats this as
>> a DMA mapping failure, closes the connection, and the client
>> reconnects -- producing a cycle of 71% RPC retransmissions and
>> ~100 reconnections per test run. RDMA WRITEs (NFS READ
>> direction) are unaffected because DMA_TO_DEVICE never triggers
>> the max_sgl_rd check.
> 
> So this changelog extensively describes the problem, but it doesn't
> actually say how you fix it.

I didn't want to waste everyone's time, but I can add that.


>> +	 *
>> +	 * TODO: A bulk DMA mapping API for bvecs analogous to
>> +	 * dma_map_sgtable() would provide a proper post-DMA-
>> +	 * coalescing segment count here, enabling the map_wrs
>> +	 * path in more cases.
> 
> This isn't really something the DMA layer can easily do without getting
> as inefficient as the sgtable based path.  What the block layer does
> here is to simply keep a higher level count of merged segments.  The
> other option would be to not create multiple bvecs for continguous
> regions, which is what modern file system do in general, and why the
> above block layer nr_phys_segments based optimization isn't actually
> used all that much these days.

Technically, NFSD isn't a file system, it's a protocol adapter.


> Why can't NFS send a single bvec for contiguous ranges?

Have a look at svc_rdma_build_read_segment(). The RDMA READ path builds
bvecs from rqstp->rq_pages[], which is an array of individual struct
page pointers. Each bvec entry covers at most one page.

This is because I/O payloads arrive in an xdr_buf, which represents its
page data as a struct page ** array (xdr->pages), and svc_rqst::rq_pages
is likewise a flat array of single-page pointers. These pages are
allocated individually (typically from the page allocator via
alloc_pages()), so there's no guarantee of physical contiguity. Even if
adjacent pages happen to be contiguous, the code has no way to know that
without inspecting PFNs (which is exactly what the DMA mapping layer
does).

So currently svcrdma can't send a single bvec for contiguous ranges
because the contiguity information doesn't exist at the NFSD or RPC
layer. Contiguity is (re)discovered only at DMA map time.

The alternative is to build an SGL for mapping the bvec so that rw.c can
get the real contiguity of the pages before proceeding. But that seems
icky.

Long term, I expect that NFSD will need to preserve the folios it gets
from file systems and pass those to the RPC transports without
translating them to an array of page pointers.


-- 
Chuck Lever
