Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245FA26E71F
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784643426; cv=none; b=PL/P3syUoEvKS1gxgL3NiNRchRiImpU5O3SjUvXYpE2gG/jB3BEaMCgRMefW99xK4mDOvhU9ewH4ATDSZ+jbZouMFLzHfloaqX60TtUPuUNSl6dejY2IjvbenbLUiDOeA1RrS5FvjASW0WNeW002RcYR4kNWgxlwjR8uGTVBm8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784643426; c=relaxed/simple;
	bh=9CCTIId18/Y+9M6ryIkDL8v/OI9vK9qJF/Ji6EnXqJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=afJfY5edm/QvkjRNizactRff1EbNrCjwQoNtrxkRBtEJ5nCdLCICDomAjdl9DER2ZEiQTs7ks1GzL5Btl9uDulxbfbF0IUahCwGAe4oy+pB6HQJeqxlv5zbCQtWaIKxkrlbN5G9keYeU4tQLnsVy97REJyoKrqxmdQ7rLuhtZww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hj/SAhp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hj/SAhp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1D01F00A3A;
	Tue, 21 Jul 2026 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643425;
	bh=avdKE7OXJsg1la2jqoe96ti+p5OWzO2cRxQMwQO4eVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hj/SAhp9Zpbnh59rxND134shmB0nyAPuI413Ry3THjqaMB3I4oU6htCI/C/0Lnp8S
	 UZsXqj3/KUUwiXjxKx+Q2qL3eYRUvVg3RLDtU8STQ5Sx0n7Esqwgw9i6VQy7dHIG2T
	 r8Kr9v7yNMEXtkuqtm+5YawnzdwWyHiC/K7FITPtt/Ku0R47l3ZiYiEgmlu49YzU/D
	 pLzPZ/6tvyT0VyvYOIK008HIikv7h+8JLIqtfR/Q4ukcqYq8/EtdbaDzugBnJk0knU
	 LsNCNGaASUr2jTDln0WPb3SpnxAwTcIEhNF8kr0UBU4doFgx58PYc5rL9TKWYj2NLk
	 vl/ADRWd1eRGg==
Date: Tue, 21 Jul 2026 17:16:59 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, sleybo@amazon.com,
	matua@amazon.com, gal.pressman@linux.dev,
	Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next v10 4/6] RDMA/core: Add Completion Counters to
 resource tracking
Message-ID: <20260721141659.GM110966@unreal>
References: <20260720132221.2551-1-mrgolin@amazon.com>
 <20260720132221.2551-5-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720132221.2551-5-mrgolin@amazon.com>

On Mon, Jul 20, 2026 at 01:22:19PM +0000, Michael Margolin wrote:
> Track completion counter objects in the resource tracking database so
> they are visible through the rdma netlink interface. The rdma tool
> displays the comp_cntr count in the resource summary.
> 
> Add RDMA_RESTRACK_COMP_CNTR type, embed rdma_restrack_entry in
> ib_comp_cntr, and add the res_to_dev mapping. Register the resource
> on create and remove it on destroy.
> 
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Michael Margolin <mrgolin@amazon.com>
> ---
>  drivers/infiniband/core/nldev.c                      | 8 ++++++++
>  drivers/infiniband/core/restrack.c                   | 2 ++
>  drivers/infiniband/core/uverbs_std_types_comp_cntr.c | 6 ++++++
>  include/rdma/ib_verbs.h                              | 1 +
>  include/rdma/restrack.h                              | 4 ++++
>  5 files changed, 21 insertions(+)

<...>

> @@ -48,7 +50,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_CREATE)(struct uverbs_attr_bun
>  	if (ret)
>  		goto err_free;
>  
> +	rdma_restrack_new(&cc->res, RDMA_RESTRACK_COMP_CNTR);

This is an unexpected location. I would expect restrack
initialization to occur before ops.create_comp_cntr.

Thanks

> +	rdma_restrack_set_name(&cc->res, NULL);
> +
>  	uobj->object = cc;
> +	rdma_restrack_add(&cc->res);
>  	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE);
>  	return 0;
