Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E63AAF5C
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 10:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160708; cv=none; b=CsISYmglTFjojBbiMK1SJUOgsrlrOtn3Cu+DAyHOkHJEkQwwn0sAMDytypBlPd5iv0GDrhGYv13LtMZrGLafnpag8vGl11s8trZ6ILhz/145H7Qn5aiqnPgyEpJ4yaVdjvDwFw1MCeSi8a7qnzoidbTP4bvDHg9u/902XmlUAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160708; c=relaxed/simple;
	bh=twChRccsAyk9MVFFHVWfDC6dnz8PZ/j1wce5cDpmzPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0R2QWUzKgHV+ooJBxuyCrdDpTMJkQzOsAkkC0CWAKgA9XYn+FW31Dem5v30IkTrcVuWJ/7SEy6kz0kGq0akXlDT96jpf+qPl8md8nfdmlGvkfBVbn86fUeB+LWv7a3ERiJUOyJtPGfOUTu6kOpQ4vgCQ3A/W2AGYg1lpzou0D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gY2hSH+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gY2hSH+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC431F000FF;
	Wed, 23 Sep 2026 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160690;
	bh=Ern1NakivqotGbH+yQZcsxocQFhb+sQz1vTyari3+o0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gY2hSH+14gQesivmOMsdqs1YEXvnAkFKqb1L1z8aIcIye5mosMle0mk8rJKIXtwj3
	 e8kEaJAxibsQrgp8jXfWz5gOCrS+xeKW46xOHpFNSHJMCrcteITUdyjY939VMBHQNs
	 yLtKmB3Im1BbcGt3fJ0qM5n3hHLorv2xchIRfPqoQswdlT1OjeLAyh4JbmE0lJ3XEM
	 F+sxYXZNRzGgdawbZaPlU8rnpGuCKSEfN783zlnALter1lvJDj87kHGX/7/2fpAiiL
	 klsiwwvUZSi42I6rq/1+MkioQMdwBtIVPrlIcXwAAg0kwk0Sa6E19fkKBoJEzc+U/V
	 CopzNgV4E/wpQ==
Date: Wed, 23 Sep 2026 13:51:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, sleybo@amazon.com,
	matua@amazon.com, gal.pressman@linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring
 allocations
Message-ID: <20260923105127.GP563127@unreal>
References: <20260917105101.9365-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917105101.9365-1-mrgolin@amazon.com>

On Thu, Sep 17, 2026 at 10:51:01AM +0000, Michael Margolin wrote:
> RQ and CQ ring buffers require physically contiguous memory. On
> systems under memory pressure, high-order allocations can fail
> even when sufficient free memory exists because the allocator
> gives up after a single reclaim and compaction attempt for
> costly-order requests that lack __GFP_RETRY_MAYFAIL.

What sizes did you see fail, and in which flow?

Thanks

> 
> Add __GFP_RETRY_MAYFAIL to the GFP flags in efa_zalloc_mapped()
> to allow retries with escalating compaction priority and release
> of highatomic reserves before giving up.
> 
> Reviewed-by: Firas Jahjah <firasj@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Michael Margolin <mrgolin@amazon.com>
> ---
>  drivers/infiniband/hw/efa/efa_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 2d28d68efe77..0b0396e190f2 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -190,7 +190,7 @@ static void *efa_zalloc_mapped(struct efa_dev *dev, dma_addr_t *dma_addr,
>  {
>  	void *addr;
>  
> -	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
> +	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL);
>  	if (!addr)
>  		return NULL;
>  
> -- 
> 2.47.3
> 
