Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769404;
	b=mEniK4ceGatrS9m/X2dzHn897vmhmIrLD3PFPao3PfLnsE14z7lcEJB0C0CjspuBo+FN
	 a6YJswvjBHN8OyGXv/koYFg5wFaxmn/jo16VmOMOGwtCj6ykxeRWV9zz9s0F9KFsahyE/
	 6pelPu2gdN3EjhP8Qv9hAkT6nVXzE8FyfgTQUgWDdHX7mT3OPf9Xknzz+aVe660+tXiDJ
	 JhRrOKHaAY56EqN7dDVxw42/Olv7OMzxa5GxQTQH+igaFwH9v6c309bwMKyWqlrz1NY5e
	 DZabGGDxTDQSk+A23VtoXKJMXQ6mzJOOQvdlBQJq8+BBrp4rO012ucpUSXJfR4kI/ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769404;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VpsaYfALPxj3JTxUOmv1u6KeYeosvi0HWzXshqy6gK0=;
	b=25J54zpRUlB1akTE3rjR/L1aPNCJGNHzbswDThBCIDNW4Z08VFU3XTug79qstJD9yDqK
	 8y8TI1N80l+UkvYjwEViB9LOrIge5HY2PCT1HkaWiXW+sYaVTIWPZuuTfnevEaDJ36B5N
	 P5n8WpM/OAbj0IUUa50E6ze50lh0wCzQhRiXvVOHtwS3GNuiG2P5TvXSM18m6glldRFtF
	 eu7rzlbJwCHN0vx6hntctk+Y56JGZLls9sopPIvy2UBtfN1xNsCEvBoog6JHZNIyNA6Op
	 NIkDpE+OwuLWSKcfK7fyI5zWFo8zUVVTXpbvUrg+egqQ8bb8F3zQTJeX+SV9abSgipg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoLklo3U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27684606A31F;
	Sun, 15 Nov 2026 19:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoLklo3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362D01F000C4;
	Sun, 15 Nov 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769404;
	bh=VpsaYfALPxj3JTxUOmv1u6KeYeosvi0HWzXshqy6gK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aoLklo3Uur6KcFCrrNOsALrm6OryaVPwObMEdMqL4XhedzpTehgl03zLu66uzjfNh
	 x4np44MbqMsZ4VBru1LE94RfxUBlx35JXfkfbWSwR3FjNeLuNhgx2htAd8fWRWOdeC
	 DAEmT+5GKKgunM4f2v8ivYgKh0QmAjtzWcOTc/aZTCeLXxbIp1jyI3jKlxscYu5bBQ
	 qx37/W06MFIiEnIaH+Anykv+1rLEmN+m/woA+/cVsT/rEBlle3pk5WkjIlACTOV1XK
	 6FSKTa1VgQllE0sHkZutdJZ86GUJ2UJZwHdcupRU4aGDjKGRe+21/mOo4BJR1e7FCL
	 FZlAuuxBN6fxw==
Date: Sun, 15 Nov 2026 21:03:19 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: jgg@ziepe.ca, ynachum@amazon.com, yishaih@nvidia.com,
	edwards@nvidia.com, mrgolin@amazon.com, hemanth.selam@gmail.com,
	michael.j.ruhl@intel.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] RDMA/uverbs: Free all radix tree nodes in
 uverbs_destroy_api()
Message-ID: <20261115190319.GI42525@unreal>
References: <20261115142911.21321-1-kartikey406@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115142911.21321-1-kartikey406@gmail.com>

On Sun, Nov 15, 2026 at 07:59:11PM +0530, Deepanshu Kartikey wrote:
> syzbot reported a memory leak of radix_tree_node objects allocated
> while registering a siw device:
> 
>   radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
>   radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
>   uapi_add_elm+0x61/0x140 uverbs_uapi.c:41
>   uverbs_alloc_api+0x85/0xc50 uverbs_uapi.c:659
>   siw_newlink+0x36a/0x3f0 siw_main.c:433
> 
> radix_tree_insert() can fail with -ENOMEM after it has already linked
> intermediate nodes into the tree, leaving them with no entries.
> uverbs_destroy_api() only removes populated slots through
> uapi_remove_range(), and radix tree nodes are freed only as a side
> effect of deleting an entry, so these empty nodes are leaked when the
> uapi is destroyed.
> 
> Call xa_destroy() after removing the entries so that all remaining
> nodes are freed.
> 
> Reported-by: syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d60be66dd00b4490fa96
> Fixes: 9ed3e5f44772 ("IB/uverbs: Build the specs into a radix tree at runtime")
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> Changes in v2:
> - Drop the dummy insert/delete workaround in uapi_add_elm()
> - Call xa_destroy() in uverbs_destroy_api() to free all remaining
>   nodes, as suggested by Jason

AFAIK, Jason didn't suggest to call to xa_destroy().

Thanks

> 
> Compile tested only.
> ---
>  drivers/infiniband/core/uverbs_uapi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
> index b67db3790f03..77a4eb494936 100644
> --- a/drivers/infiniband/core/uverbs_uapi.c
> +++ b/drivers/infiniband/core/uverbs_uapi.c
> @@ -621,6 +621,7 @@ void uverbs_destroy_api(struct uverbs_api *uapi)
>  		return;
>  
>  	uapi_remove_range(uapi, 0, U32_MAX);
> +	xa_destroy(&uapi->radix);
>  	kfree(uapi->write_methods);
>  	kfree(uapi);
>  }
> -- 
> 2.43.0
> 
