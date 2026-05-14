Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B433066E
	for <linux-rdma@vger.kernel.org>; Thu, 14 May 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778775144; cv=none; b=R1I/xHEo4eAaxeYqiYAAzKLNGgbTflp8KfRKQGD1CGatum/eJp/UT+ztKXy40eah4E/I+bRiOMoeRmLScftu3cVjCXvciZ8kXhOqJsZRR9CiepWoXeB1Ij4w2EK3QC2uny74BsuBeU3ny9u55S/4Ta/EjaAuWlXRlN1PPwOARZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778775144; c=relaxed/simple;
	bh=eTKJVOXg2o5aD5lx7jCAlENhEJLCOmE4ytkf3G2jOd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oi8PKD+2tyYeh2isFzCq+V28nyeA2zOGFgGNVRSa5XZfFaCkdQURz7VmdEwC+FN3XCb74Zq18ltIlZuBpcnBptLOp4LUB0w6o9swIiG0AnvUM8oqrvk8r/57PzN9DEAz5KaVrqVzmxhxzoWW9wd+UGLDFiScbFbi+GX8247lDR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWYr1JXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWYr1JXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DEFC2BCB3;
	Thu, 14 May 2026 16:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778775144;
	bh=eTKJVOXg2o5aD5lx7jCAlENhEJLCOmE4ytkf3G2jOd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gWYr1JXQlhsWX0pqfZB2utw0F30nCOAAtDBemciCwZsqWYbR10puGuj16o6kir5JN
	 2gDeXRU2jQqlBsstkicTxUsnQgBkcJme5cSI0D05cFHHdjF2NGVA5oQ8g3DtARnIUg
	 Siq49maABOQ5F9p6t3B70DwuokH8ddxTExYFCwoGv48eaHFeifhTOGBYH9H7FJgXZp
	 3TLYzlp5edTVXjXSZa7/ocLY2TYwFypo3yOlhREe4xM1dDWegRkV0z88R9X44UV0y3
	 3zuDS6/WnEW/m9uuS+rYInIKR+llJAUTKfM8EEgRMOS3adLnJlONrqBDYwmQSEltEz
	 6ehYjf77Ernjg==
Date: Thu, 14 May 2026 09:12:23 -0700
From: Kees Cook <kees@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Bernard Metzler <bernard.metzler@linux.dev>, rosenp@gmail.com,
	leon@kernel.org, gustavoars@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH v3] RDMA/siw: use kzalloc_flex
Message-ID: <202605140906.EC4B0F5A@keescook>
References: <20260511141149.52362-1-bernard.metzler@linux.dev>
 <8226377c-0691-4368-bb82-48b620f784d2@linux.dev>
 <20260513142846.GN7702@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513142846.GN7702@ziepe.ca>

On Wed, May 13, 2026 at 11:28:46AM -0300, Jason Gunthorpe wrote:
> Ignore this, kxalloc_flex should not be assumed to initialize anything
> but 0. IDK why they put in the auto-initialize when it cannot be
> relied on, security in depth I guess.

Correct, manual initialization is still always required. The auto-init
(when counted_by is supported) is to deal with adding counted_by to code
that doesn't initialize the counter before access. i.e. this code used
to work:

thing = kzalloc(sizeof(*thing) + n * sizeof(*thing->fam));
access(thing->fam);
thing->fam_count = n;

but if we add counted_by and use kzalloc_flex, suddenly it breaks (at
access() time) unless kzalloc_flex also performs the "fam_count = n"
at alloc time.

-- 
Kees Cook
