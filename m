Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ACD21ABAA;
	Tue, 30 Jun 2026 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782831625; cv=none; b=jqr0HvFzd28p0DodTfhHWlZWwwk5ZQy6EvZ5Xhig82fEZxeJ2q/mdymz6xQ54Ygh/t62bjCSx9g80NPZUUDueBpBkNvrtG/+FzyWnMb4MZkkkj27XaH7ax5bwjF7s4WSTr1wFZI3354dgYNpL+PkDfosfHB21flOtyqs9XdIylI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782831625; c=relaxed/simple;
	bh=MPzABO0zBN/6WA35CI45RYVH+YOk7AmePdrxclcf2ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unGT3FGQ5jbYnXYozZfB2V2o9zqzXfSc0kI6efljxPsUz/f5mw0qduyVnZncsk1XnzUvkR+McwXXCsmYcgLdEQb2prSOe4W1GAU55VIX7y8Pa0NGJbY9Uuk4OaRPu8oivIgMsVz7QzzoTgtK0gyzWeXNDJwaGtVjlf8/za2Z+fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5QS6KFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5QS6KFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB01F1F000E9;
	Tue, 30 Jun 2026 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782831624;
	bh=lEjljAT8oCBe6H0+DZxoSp7D0aXaqVksk3/Y1JCjZd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D5QS6KFhU/5DOxHs4TOWy0bffEu1vpyOjarro1YAFzBSMYJ0jmUqd8LXAXR5OSaYX
	 lT+ZeDgjVMLyeTBPni32H7bS6yD3N1YatU8vQZ3m4XXPIvFBZ3bClUETpdYbq6NLN0
	 D525b55NxYXe3NhT9lr1DvZDoZmx3XKZXU9PtqtAN+uGBEEWkUx4jDIMjFq5ywIOYB
	 0k2hic87Cigrr0lRB35EPiUya7c9cB7pohffQfgPmFBS9sx4Q0i+DDDGdU7K9/pwAh
	 gSQmlmDsiNreWpKLyF9SfSGdt/GUWU4i07X6MW5tXoGFu0D9jvOBINDUNGr6sQp+rf
	 9Ql8aWYKvA5/g==
Date: Tue, 30 Jun 2026 18:00:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <akPaAp-0Zul8uVga@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630123150.GB7525@ziepe.ca>

(adding Vlastimil)

On Tue, Jun 30, 2026 at 09:31:50AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> > ib_umem_get() allocates an array of pointers to struct page for
> > pin_user_pages_fast() calls during memory registration.
> 
> A whole bunch of these use cases in rdma are really "give me some
> temporary memory, I want it fast and as large as possible. In a
> syscall context I will free it before returning back to userspace"

Not sure I follow where "as large as possible" comes from. Here it's
explicitly a page.

And does "fast" mean that vmalloc() is not an option?
 
> eg we'd be really happy to get any kind of high order page here.
> 
> So, how would you feel about a new API?
> 
>  void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);
> 
> I know of a few other cases like this in the kernel at least.
> 
> The implementation could try to find an available high order page and
> immediately return it, otherwise do a small reclaim allocation?

How do you suggest to decide how much of reclaim should happen? With the
usual semantics of gfp?

> Jason

-- 
Sincerely yours,
Mike.
