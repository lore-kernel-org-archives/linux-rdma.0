Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12E209F43;
	Tue, 30 Jun 2026 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782831684; cv=none; b=W5HY1S0Zy7dGsnnDMnZXEjTAYLLpQIyfpwDPDvotN5VxsElTSPqDgSEPXoWSMuTHp2xfv4YMd+lkq2QzP7vf8CSotDxEP/Y0DSKEuZ1DjnzF6N9rSWE2AKipCPihbOlPU5Y2JQ8C8jgyWE/1YPPuhhbsBY9X8LRuvqYss1i3B9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782831684; c=relaxed/simple;
	bh=O0xQW406nJXTzb5HWbwGjFU/WpaZQPD6N+AgmOtX5Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJb/FPJ0RTCmmQ71kiBXLGSXkm/FlHBmlPdZ1Cwf0WU+o+H77O7N9vxpNVr01F/csvcACHI8jLltgAo1aiYyF9n+lWnFcD6/EnBHuN9b01rC/ydJ6tlUbWvClkPaDXzLWgJEuIV5VTm2QXHagCsc/Y7W8ltbw0AZ7FqWL9fDRO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6lqx7xe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6lqx7xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4CD1F000E9;
	Tue, 30 Jun 2026 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782831683;
	bh=v22ZwceD+Hle0zDa72UrwGJHemOkLfc0UBG3SW36enI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I6lqx7xe7ArEoBeN2UysBFuosgjtJd5J+5+JeOIu7nS7HkHEgOhZKD+NYpCgObeHQ
	 yx2gWe6NnthkQSUTweAI36dYEHA14aVvXYEOst62rLvNCjMo1jTB8pbeCqQzyQJzGh
	 dEuhY/mgrlzj09HUZxkcxAwvKcS/G95M7h8YF6EN5a3vmMQWrodWMlnCJnCcW+OlGf
	 ehGlUmxiDsExBPFzuMKvrjJdu1MxfULg8BOK1azZFEExpSBfKc+/rNWw7bQQAuNtXG
	 DrymVoUdkO1du/sPhAAjdKEL71Rpaih6H9vUFDqbg/ndhd54OWQjJCJJYfXrmFzny/
	 hmv0rm2Hnf/kw==
Date: Tue, 30 Jun 2026 18:01:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <akPaPaCJdYINBEEV@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
 <akPaAp-0Zul8uVga@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPaAp-0Zul8uVga@kernel.org>

(actually adding Vlastimil :) )

On Tue, Jun 30, 2026 at 06:00:24PM +0300, Mike Rapoport wrote:
> (adding Vlastimil)
> 
> On Tue, Jun 30, 2026 at 09:31:50AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> > > ib_umem_get() allocates an array of pointers to struct page for
> > > pin_user_pages_fast() calls during memory registration.
> > 
> > A whole bunch of these use cases in rdma are really "give me some
> > temporary memory, I want it fast and as large as possible. In a
> > syscall context I will free it before returning back to userspace"
> 
> Not sure I follow where "as large as possible" comes from. Here it's
> explicitly a page.
> 
> And does "fast" mean that vmalloc() is not an option?
>  
> > eg we'd be really happy to get any kind of high order page here.
> > 
> > So, how would you feel about a new API?
> > 
> >  void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);
> > 
> > I know of a few other cases like this in the kernel at least.
> > 
> > The implementation could try to find an available high order page and
> > immediately return it, otherwise do a small reclaim allocation?
> 
> How do you suggest to decide how much of reclaim should happen? With the
> usual semantics of gfp?
> 
> > Jason
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Sincerely yours,
Mike.
