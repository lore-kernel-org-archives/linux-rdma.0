Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFC7F9D9
	for <linux-rdma@vger.kernel.org>; Tue, 12 May 2026 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778613697; cv=none; b=DqifErbO+vmzmjBZ4QSmDkmX7r9f1Ur9INgeyCuq5qcDeY7mz6MYauJl+WwWyH3Ic43ELC52rN9THVpq7SHoVMZHaPXV2cdmwLTX9jNxthEgcPtP8FEdabPPO3h32qxCdOLgBtZ5aoqaa6m30+D084FVLtk5bf7Dmo0BpyMKqBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778613697; c=relaxed/simple;
	bh=5OlYdtIfvscrk3xjMArxz4XUGJmyyK+R5to9Jo2qcfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kejy3w+cuQI37xasqAiQP0IurcDiLP5rNGUqtn8+cRM4f/ipKoqjFhBRUYE1dTbgaeJmNiKyP+UU6FN9REGQZUwJFgBUbJ/fx9hQ9Cpieed/1gZyxflY0JUrUIoThgGoDw0T6ClJriEfL0f/HsncJl4Rn7RGOYztolCUD/Wouaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ko75XXYG; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ko75XXYG"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d6ab4476eso56045571cf.2
        for <linux-rdma@vger.kernel.org>; Tue, 12 May 2026 12:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778613695; x=1779218495; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDA2DZwVJmaT9gG+uIcxdJjva+NVF5ogWRXLCE3Bx7w=;
        b=Ko75XXYGDGqvV6yBOpo5hIqU5G4qDggmui4fHiy/mugJ2CS5MlBoIfNIOWjrGqmBSV
         U++J5MJMCnmO9bF7IohdeFmju6+a8jyMgzTxYjLS/v6E2UFeXuuPhnshe1SGoMPtD7oz
         n5qPj5cRN3saGlbt6wKqxhW9u8B2j8OVpqnKq8Sc4m2x7Pwsg3EpqTccg2BMptw1ef+Z
         HlIzxX0irSH4j/0FQjCVjM5kjxDOf8QvDptv62XOwrsMYVHfoq9XX1vbGvpKWWEaFrqj
         xR/2Hqjko+ZQ1fjuv+A6LRwM6TnIpPnf6PhMO8Lw4x1tdrI/DhlnHbuLrEqq1VtUSQwe
         fR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778613695; x=1779218495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDA2DZwVJmaT9gG+uIcxdJjva+NVF5ogWRXLCE3Bx7w=;
        b=O/DY9kFjL78/Tzd8mAr9dC3Vm21PQ8cKUweRqj3xDCxBk9ZasmBJwGBPsLdG6Zx0ld
         yEakPynQdI7x6uxYsDqjL+bGzVTLDP1M//o2o0FuDgEupEqlwzJwvFDSZu31aIiNuTdb
         r+J19JPFyMS6rZBaOYFgG1x3274d1niCkyB8xIcGfxd/8Uhqax+BHJJzQvStPjL5o+xw
         rtbbcbiCsZD/10WOMRtNfM0LmEfBw/DeiKpXGtENlzv54Ky17y+JzrV3lVCpqwS8b7c7
         /JzLmOAcd1f7MaLu+BbPb6ZKeJaMdI1Ff6ZSCKyC2e0+JgOb2zZAqRwT+DgIbv+l3YEM
         PYYA==
X-Gm-Message-State: AOJu0YzSsb8g+RVZL2kNRrdWUEVFGoBsa4xZ5opG+6HkCK13OE1RV3my
	E/nQCsopz3SVIqTi+hq9+ONdB3uWc0nLobiPFf1qM6zMyCC/Qbxx8qmnRcZO8qtGQ4s=
X-Gm-Gg: Acq92OHT7y4MnLSCQQ2BTa1q2fgg7aevfsbTw4rM2efQMfNaNJIy0lSvBMDGeU4J2l8
	g9bHFXmI5zq9iO8UDyz0SKpFLgIpJCe1LIrANiK48o21gIfEGCX9RMRQYp5UU6IBJWxYmBbIctv
	7NXretU208mw1L5EE498CuvC3U8hf4JDmL4zRYHAzOHnSeTEQTm9MbL8PvFIXg1MY3no3mkMl1y
	D1JcWgpnAAEY+G7GwVc6nuwtI51/dDcudKwXxvzMDx/WuWoqqudRn3xz7PmPAfl2BIDqrzbLAHf
	KJ+h2VxTbk04Cb7sxMWDeRvFNz9pRYjs/5Lt2PN9+PRD29uGG5nw6DAFE+cNyKy45zXhCokYMPc
	LI2yMv14xcNqINYL9ED7Ads4Jp+3q+1A4tDKehUJenBlHKe8cauLh9L6oBWOYEF1ra4Cjbe28MK
	sJqRqdXqOh62VQ8NDndJWKzSUX2BiwBpt+fmeVXukXhdD9n7ojYZjoQgGhpvhloMhVpKEjF8pF2
	x17IA==
X-Received: by 2002:ac8:5a50:0:b0:50f:bd79:2643 with SMTP id d75a77b69052e-51461e7e2d4mr446153591cf.34.1778613695136;
        Tue, 12 May 2026 12:21:35 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5162ee0d2f3sm918991cf.26.2026.05.12.12.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 12:21:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wMsfe-00000000wp7-08IY;
	Tue, 12 May 2026 16:21:34 -0300
Date: Tue, 12 May 2026 16:21:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, leon@kernel.org, mrgolin@amazon.com,
	gal.pressman@linux.dev, sleybo@amazon.com, parav@nvidia.com,
	mbloch@nvidia.com, yanjun.zhu@linux.dev, marco.crivellari@suse.com,
	roman.gushchin@linux.dev, phaddad@nvidia.com, lirongqing@baidu.com,
	ynachum@amazon.com, huangjunxian6@hisilicon.com,
	kalesh-anakkur.purayil@broadcom.com, ohartoov@nvidia.com,
	michaelgur@nvidia.com, shayd@nvidia.com, edwards@nvidia.com,
	sriharsha.basavapatna@broadcom.com, andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com
Subject: Re: [PATCH rdma-next v4 15/16] RDMA/mlx5: Use UMEM attribute for CQ
 doorbell record
Message-ID: <20260512192134.GK7702@ziepe.ca>
References: <20260507125231.2950751-1-jiri@resnulli.us>
 <20260507125231.2950751-16-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507125231.2950751-16-jiri@resnulli.us>

On Thu, May 07, 2026 at 02:52:30PM +0200, Jiri Pirko wrote:
> +int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context,
> +			struct ib_udata *udata, u16 attr_id,
> +			unsigned long virt, struct mlx5_db *db)
>  {
> -	struct mlx5_ib_user_db_page *page;
> +	struct mlx5_ib_user_db_page *page = NULL;
> +	unsigned long dma_offset;
>  	int err = 0;
>  
> +	if (udata) {
> +		struct ib_umem *umem;
> +
> +		umem = ib_umem_get_attr(context->ibucontext.device, udata,
> +					attr_id, sizeof(__be32) * 2, 0);
> +		if (IS_ERR(umem))
> +			return PTR_ERR(umem);
> +		if (umem) {

More IS_ERR_OR_NULL stuff..

> +			/*
> +			 * The 8-byte DBR is programmed to the device as one
> +			 * DMA address, so it must stay within a single page.
> +			 * An 8-byte range that crosses a page boundary may
> +			 * be split across two non-contiguous DMA mappings.
> +			 */
> +			if (ib_umem_offset(umem) >
> +			    PAGE_SIZE - sizeof(__be32) * 2) {
> +				ib_umem_release(umem);
> +				return -EINVAL;
> +			}

I think this can just be ib_umem_is_contiguous()

> +			page = kzalloc_obj(*page);
> +			if (!page) {
> +				ib_umem_release(umem);
> +				return -ENOMEM;
> +			}
> +			page->umem = umem;
> +			dma_offset = ib_umem_offset(umem);
> +		}
> +	}
> +
>  	mutex_lock(&context->db_page_mutex);
>  
> +	if (page)
> +		goto add_page;
> +
> +	dma_offset = virt & ~PAGE_MASK;
> +
>  	list_for_each_entry(page, &context->db_page_list, list)
>  		if ((current->mm == page->mm) &&
>  		    (page->user_virt == (virt & PAGE_MASK)))
>  			goto found;

Ah, this is why..

I think this function should take in a ib_uverbs_buffer_desc and that
should be stored inside the page instead of using virt. Then the
functions flow doesn't really change, it searchs the page_list for a
matching desc, otherwise it converts the desc to a umem and creates a
new page. Refuse to match FD based descs

That sort of suggests you want to split up the earlier patch so there
is a seperate re-usable get desc function instead of bundling into
ib_umem_get..


Jason
