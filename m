Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D603218BA
	for <linux-rdma@vger.kernel.org>; Sun, 17 May 2026 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779029570; cv=none; b=Z0j5TVVzeKWCYTG0RmYO/9R2USO/sBLr+XAOzCxNzDtHA77ijvetV3mEDV9KrAN2SAGuvrvbU8kgSHuq3CHGqwcOkr6XPWNGgmthrDSXczty4kXS71QBWjVmlFRPcVdUdgDEafkX/BeEC1TIOuzSWXwEd9GuAeNwzzEj0LHebaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779029570; c=relaxed/simple;
	bh=PM4r1u48D4JFerpsjFbeUU2gNSzyNwzaf4lDXzrJEgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSMjHEqnLCS8gyGE4BK9OFmTBl6ywIXv+nsB4Wbxb8b5acbDaIKu3mEfNhh2D90hAGX5lS0ymm3MdwYgTkFimX2JtwThi9+PuW0dpDsaNZZHi01C9qCIfH6vBnfFFDbSk/n2KiQHOR9sNgY7/lUY+SmJeF1fjMwSM608astf01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNDiz38t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNDiz38t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243E2C2BCB0;
	Sun, 17 May 2026 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779029569;
	bh=PM4r1u48D4JFerpsjFbeUU2gNSzyNwzaf4lDXzrJEgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNDiz38tDsx9gSVPOHD1hyn/5uy8f2+7pmji3g6wSiLEUY2b60zenmc3BGoqQ1IYk
	 Mv92h2enShtlQhWK5oQQZd9v51ZxltXrIaRXLCcfTlVk8YWP7CTf1sa/zZFRVdYHud
	 +NskVZCKMg8z7rIuhu7yHjnqH/E8b5oB6PQ5T5vseCdaW8IKbn4Sl2O0yg2UieUcM2
	 ystuzJ8T3nou5sl5LxNaZmZt26tfQjuxdVw6OJhtwN/ICZlDYegHI2hknCcjgj3ZRT
	 kEhrJFck3BqeSsSa7asMjVo+hdNsmMd5saLQG5ND8vunb7+d7DePJmb0RO+5Tn0Z4E
	 aM7WeMQVFFdxw==
Date: Sun, 17 May 2026 17:52:45 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: rosenp@gmail.com, jgg@ziepe.ca, kees@kernel.org, gustavoars@kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH v3] RDMA/siw: use kzalloc_flex
Message-ID: <20260517145245.GI33515@unreal>
References: <20260511141149.52362-1-bernard.metzler@linux.dev>
 <177869432039.2333679.10257766726760194039.b4-ty@kernel.org>
 <7463ed4b-543c-49d4-9337-f41915354a3f@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7463ed4b-543c-49d4-9337-f41915354a3f@linux.dev>

On Thu, May 14, 2026 at 03:14:24PM +0200, Bernard Metzler wrote:
> On 13.05.2026 19:45, Leon Romanovsky wrote:
> > 
> > On Mon, 11 May 2026 16:11:49 +0200, bernard.metzler@linux.dev wrote:
> > > Simplify umem allocation by using flexible array member.
> > > Add __counted_by to get extra runtime analysis.
> > 
> > Applied, thanks!
> > 
> > [1/1] RDMA/siw: use kzalloc_flex
> >        https://git.kernel.org/rdma/rdma/c/79678bea399052
> > 
> > Best regards,
> Hi Leon,
> 
> per Jason's suggestion, please amend the patch by
> adding below line. We should NOT assume kzalloc_flex
> to initialize anything but 0. So we shall set
> umem->num_chunks explicitly.

done, thanks

> 
> Many thanks,
> Bernard.
> ----
> 
> diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
> index 88ec3cacfa00..40455616d9ec 100644
> --- a/drivers/infiniband/sw/siw/siw_mem.c
> +++ b/drivers/infiniband/sw/siw/siw_mem.c
> @@ -359,6 +359,7 @@ struct siw_umem *siw_umem_get(struct ib_device *base_dev, u64 start,
> 	umem->fp_addr = first_page_va;
> 	umem->base_mem = base_mem;
> 	umem->num_pages = num_pages;
> +	umem->num_chunks = num_chunks;
> 
> 	sgt = &base_mem->sgt_append.sgt;
> 	__sg_page_iter_start(&sg_iter, sgt->sgl, sgt->orig_nents, 0);
> 
> 
