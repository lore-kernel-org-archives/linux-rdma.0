Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083100;
	b=p6n8+mt1EBjgtSWrURk2yRrfK6t7Ivr+h3qEY8Zpw6B/lTk82wJygQiZxhPs2ZFoIIOe
	 RBNNHpQQE0rHIRuhk/5+xfjd1vpTcOyPeoeBlIiW+mrDT+yk2WwkLCY8uKJBi+JwEXkwG
	 i1miea97NuWov8ScYtgiOwGrhB6lDNnTiGSa3jPRJjeCei8jP2wWhXBTJN/lqq+1v8Nvg
	 bv7FQeVND0xYE7S/a24bOYshqQKPrEHLNqp3eMLsTAQyN/D3Ddg50H2zaCdRKzpzzujH7
	 0MoVmLeE/94JvqaWooZNGv4Ilnf9VrfJZWG9+RLgLTnNme+HP5rWifRNDDJTLIb0tNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083100;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+sYQxBcP7NU+0E9pOU+OKA6LcFbrC8mLyMrCGr9ieqk=;
	b=RvhyWyfjKqOkSiKupO/KQHVWUpSjhXJDGPfWrbx+M+TITyAQAyoB4hYt/J7wKyg8XJPn
	 i/2iGm5TM++Hpht4MvIY8F+BYllOI9ulrRD+DezrRiB/kXANMd41gw9Gis4qdb2DnjHNj
	 CiU3DcRboHxR1oxLInUW1HahRCQvq+toL34s/OByyQQavPHA6w/9MZw2TBbT955oHP40R
	 EpU7c3t5ItgoZdQTM3NVLXoRn1Hk6bDAnSYU9K3ZvZOFks18jgN7fSu9Q7Xr6h5mmJw0B
	 lmNF0ymeK62aWKY/5hfVrDqGMdWUhNSOU+TEp0aXmZu36tk/+/eaFX8GQFfzd1F3ggQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFX03h8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204A9606A33D;
	Sat,  7 Nov 2026 20:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFX03h8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD1D1F008A2;
	Sat,  7 Nov 2026 20:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083100;
	bh=+sYQxBcP7NU+0E9pOU+OKA6LcFbrC8mLyMrCGr9ieqk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VFX03h8o7bT+5Mveui5Muo6i4nlLdvi+b83+WVobPLnPR+kJYbbC4MXI9ZQUK9yhq
	 WZs3p/Dx/GzDAI2vpfd06EgENTfZ4SIDEzyMsgFMSrHI9S+6oRBjVO2Mkn2B2AX+wY
	 wukSNALw7qOyDqmCpIc/4I9/Fjg2qYopod8RTjzhStaZmk91QHW+Wu0+FzLwiOB8jZ
	 8RvmLsK5vSVbeFWXPuJ0DHUcjuT4N8RpYJUEQ94uoYiSViupcmvFuC7R/8/rCL/XcK
	 KXYaJOWKFhTrxf7ttm6xh4H4wwrlC9GBO0GH95QBFjnZZd57jNTo9XzMdyCBVwPUeu
	 fTcgOx/F9+ewA==
Subject: Re: [PATCH rdma-next 15/23] RDMA/core: Set the CQ comp_handler after
 its poll context is set up
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:58 +0000
Message-ID: <179408309884.994134.17628521837326789530@kernel.org>
In-Reply-To: <20261103163949.1554-16-yishaih@nvidia.com>
References: <20261103163949.1554-16-yishaih@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch relies on program order alone to publish the poll
  context before the handler, and that ordering does not hold for…
- [Medium] __ib_alloc_cq() (drivers/infiniband/core/cq.c) still stores
  cq->comp_handler after dev->ops.create_cq() has returned (create_cq at…

--

RDMA/core: Set the CQ comp_handler after its poll context is set up

This commit reorders __ib_alloc_cq(). The irq_poll or work context and
comp_wq are now initialized before cq->comp_handler is stored, and the CQ
is armed only after the handler is set. The goal is that a completion
event raised right after ops.create_cq() returns no longer finds an
uninitialized poll context.

> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index 12304c9a9403e..42e4d272f5ade 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c

[ ... ]

> @@ -269,6 +267,15 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
>  		goto out_destroy_cq;
>  	}
>  
> +	/*
> +	 * The CQ is reachable from the completion interrupt once created. Set
> +	 * the handler only after the poll context it schedules is set up, and
> +	 * arm the CQ only after that.
> +	 */
> +	cq->comp_handler = comp_handler;

[Severity: Medium]
This store still runs after dev->ops.create_cq() has returned. By then, can
the driver's EQ dispatch already reach the CQ while comp_handler is still
NULL from rdma_zalloc_drv_obj()?

The driver publishes the CQN during create_cq. For example,
mlx5_core_create_cq()->mlx5_eq_add_cq() inserts it into the radix tree,
efa stores it in dev->cqs_xa, and mthca adds it to cq_table.

Several drivers then call the handler without a NULL check. For example,
in drivers/infiniband/hw/mlx4/cq.c:

static void mlx4_ib_cq_comp(struct mlx4_cq *cq)
{
	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
	ibcq->comp_handler(ibcq, ibcq->cq_context);
}

efa_process_comp_eqe() and mthca_cq_completion() do the same, and so does
mlx5_ib_cq_comp() at this commit.

So an early event from a non-conforming device would now be a NULL
function pointer call in irq or tasklet context, instead of scheduling an
uninitialized irq_poll or work. The patch also moves the store later than
before, past rdma_dim_init() (which can do a GFP_KERNEL allocation) and the
whole poll context switch, so the window gets a bit longer.

The commit message says:

    A conforming device raises no event for a new,
    empty CQ, but nothing in the core relies on that.

Doesn't the core now rely on every driver NULL-checking comp_handler?

The later commit "RDMA/mlx5: Ignore completion events for a CQ without a
handler" adds that check to mlx5_ib_cq_comp(), which closes the window for
mlx5. mlx4, efa and mthca still call the handler unconditionally at the end
of the series.

__ib_create_cq() in verbs.c, and the uverbs paths, set the handler before
calling into the driver:

	cq->device = device;
	cq->comp_handler = comp_handler;
	...
	ret = device->ops.create_cq(cq, cq_attr, NULL);

Could __ib_alloc_cq() do the same? That would mean running irq_poll_init(),
INIT_WORK(), the comp_wq store and the comp_handler store before
ops.create_cq(), and keeping only ib_req_notify_cq() for afterwards. The
driver's own publication of the CQ would then provide the ordering.

[Severity: High]
Is program order enough to make the poll context visible before the
handler? The irq_poll_init() stores (memset, INIT_LIST_HEAD, weight, poll),
INIT_WORK() and the cq->comp_wq store are all plain stores. This
comp_handler store is plain too, with no smp_store_release() or smp_wmb().

The reader side has no acquire ordering either:

mlx5 EQ irq
  mlx5_cq_tasklet_cb()
    mlx5_ib_cq_comp()
      ibcq->comp_handler()          <- plain load, indirect call
        ib_cq_completion_softirq()
          irq_poll_sched(&cq->iop)
      or
        ib_cq_completion_workqueue()
          queue_work(cq->comp_wq, &cq->work)

An event that arrives before the CQ is armed gets no ordering from the
doorbell write in ib_req_notify_cq().

On weakly ordered CPUs such as arm64 and POWER, can another CPU see the new
comp_handler before the iop, work or comp_wq stores? In the workqueue
cases, the compiler is also free to reorder the adjacent plain stores to
comp_wq and comp_handler.

If that happens, three things could go wrong:

- The reader schedules an iop whose memset and INIT_LIST_HEAD land after
  its own test_and_set_bit() and list_add_tail(). That corrupts the per-cpu
  irq_poll list.
- irq_poll_softirq() calls a stale NULL iop->poll.
- queue_work() is called with a NULL workqueue.

These are the failures the commit message describes.

Adversarial mode is enabled through cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
That is true for arm64 realm/pKVM guests and pseries secure guests. The mlx5
UMR CQ allocated in mlx5r_umr_resource_init() with IB_POLL_SOFTIRQ goes
through this path. The plain NULL check that the later commit adds to
mlx5_ib_cq_comp() does not provide acquire ordering.

Would this need smp_store_release() on comp_handler, paired with an acquire
load in the drivers? The other option is to do all of this setup before
ops.create_cq(). Then the driver's publication, such as radix_tree_insert()
under table->lock in mlx5_eq_add_cq(), would order the stores for readers
that look up the CQ.

> +	if (cq->poll_ctx != IB_POLL_DIRECT)
> +		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
