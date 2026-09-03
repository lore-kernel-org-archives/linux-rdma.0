Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD053F1659;
	Thu,  3 Sep 2026 09:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428952; cv=none; b=YbO0yQAMpacM4TYDUkmZPax68v/f7Fcw30O/dpWqVKTKzQ67SpSkRL9PJWMlYLFYYo914h0x3t8DwTK36YeXtLEUkv9dUBqQidYsuWj/uuHLOcrNBoFIaMfc6ER/9EiMlIPgBcSVUog2p7HwVShOhRzk0xpZcez5LjR4aHIT5qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428952; c=relaxed/simple;
	bh=4LypXbaEzcZ8NAtmQXIJrEROpUNpdcQr0YW9LJ5DGfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qg1B93qxqp44X7saiX4o2BXpdcI09cUV1ItR89G1HOXo4fLPQCLqcjqSuQcl5qarKrRJqjLxFZLBsenws+fhugnJ0a0ZXFWVCzJ/7oVLuHHkhJlQ46FArh1BZtbx+4XMmT1QnubN/z+alUzxZs1lPy4Au+v06ET17U6kk/4YFps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWVJTPf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWVJTPf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2171F00A3A;
	Thu,  3 Sep 2026 09:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788428950;
	bh=00q18c3KntaOUA+b/Diunhes4MPW5phqrovziaQZ6Yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gWVJTPf7cSO+E2gr+KQFaLOyvjoPxugrYOvJdnUidVYYlpCqE1wIl316NmxPxnmDJ
	 vPmqZmV2Dq3LKDD9Qz3ghUvvG5Eb/rlwzSK7qYqcBxo3L7dvfPjzxL2vp0uBiO8Jum
	 tsbtOXgjAZzvlpDDNPT7LtnmvlZTrUys++VsTV3KHt1cgOrjClajn8QyoVmXdvGdRu
	 7gqTByYR5xPKSkG2Pyq12z4rArMNAihvxW8LXDMMbG+ogJrODhcVaRYnlpQCCB4Y62
	 YG+KJL26sUr5R6XhsK9SQaHgP74TR4qd4HGO3XePmY0nOH/xcZsBKKlsqt+CKyGq0t
	 O4McKQ0HVxSAQ==
Date: Thu, 3 Sep 2026 12:49:07 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Reject CQE counts above max_cqe in
 ib_cq_pool_get()
Message-ID: <20260903094907.GA24140@unreal>
References: <20260831171354.72140-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831171354.72140-1-serhatkumral1@gmail.com>

On Mon, Aug 31, 2026 at 08:13:54PM +0300, Serhat Kumral wrote:
> ib_cq_pool_get() does not validate nr_cqe against the device limit,
> while ib_alloc_cqs() caps the size passed to ib_alloc_cq() at
> dev->attrs.max_cqe:
> 
> 	nr_cqes = min(dev->attrs.max_cqe, max(nr_cqes, IB_MAX_SHARED_CQ_SZ));
> 
> If nr_cqe is larger than max_cqe, ib_alloc_cqs() cannot ask the device
> for that many entries. A device that reports the size it was asked for
> therefore returns a CQ smaller than nr_cqe, and the fit test skips
> every CQ in the pool:
> 
> 	if (cq->cqe_used + nr_cqe > cq->cqe)
> 		continue;
> 
> 'found' remains NULL and each iteration calls ib_alloc_cqs() again,
> adding another batch of CQs to dev->cq_pools[]. The CQs stay in the
> pool, so each walk under cq_pools_lock gets longer. The loop ends only
> when an allocation fails, i.e. once the device or the system has run
> out of resources.
> 
> ib_srpt can reach this path when a privileged user configures
> srp_sq_size through configfs. ib_srpt accepts values up to 65535 and
> requests ch->rq_size + sq_size CQEs while establishing a connection. If
> that sum exceeds max_cqe, a valid connection request from a remote
> initiator can trigger the allocation loop.
> 
> Reproduced with ib_srpt over rxe, which reports max_cqe = 32767, after
> setting srp_sq_size to 65535. In a 1 GB guest, a login attempt
> requesting 65663 CQEs caused 115 allocation rounds in 185 ms, followed
> by:
> 
>   Out of memory and no killable processes...
>   Kernel panic - not syncing: System is deadlocked on memory
>   Workqueue: ib_cm cm_work_handler
>   Call Trace:
>    __vmalloc_node_range_noprof
>    vmalloc_user_noprof
>    rxe_queue_init
>    rxe_cq_from_init
>    rxe_create_cq
>    __ib_alloc_cq
>    ib_cq_pool_get
>    srpt_cm_req_recv.cold
>    srpt_rdma_cm_req_recv
>    cma_cm_event_handler
>    cma_ib_req_handler
>    cm_process_work
>    cm_work_handler
> 
> Reject oversized requests before entering the allocation loop. With the
> check in place, the same test allocates no CQs and ib_srpt rejects the
> login:
> 
>   ib_srpt failed to create CQ cqe= 65663 ret= -EINVAL
> 
> Requests for max_cqe entries or fewer behave as before.

Please fix ib_srpt to honor device capabilities.

Thanks

> 
> Fixes: c7ff819aefea ("RDMA/core: Introduce shared CQ pool API")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
>  drivers/infiniband/core/cq.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index 12304c9a9403..1205e9b28897 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -449,6 +449,13 @@ struct ib_cq *ib_cq_pool_get(struct ib_device *dev, unsigned int nr_cqe,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> +	/*
> +	 * ib_alloc_cqs() caps CQ size at max_cqe, so a larger request would
> +	 * keep allocating CQs that never fit until allocation fails.
> +	 */
> +	if (nr_cqe > dev->attrs.max_cqe)
> +		return ERR_PTR(-EINVAL);
> +
>  	num_comp_vectors =
>  		min_t(unsigned int, dev->num_comp_vectors, num_online_cpus());
>  	/* Project the affinty to the device completion vector range */
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.53.0
> 
