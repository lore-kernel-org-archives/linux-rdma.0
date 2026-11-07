Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083102;
	b=X5X75YWxrJI7iN+bFsBwJzMgOAoY3wZbky7irpzzmHScyyC3OaozLYnCCm/oI700S2os
	 GrCi/nM/pZvuA9fQ1ZBWcyFf/Lljn28S+Al1NoMpamgxAmoxeVvTCJsvWcLwqr+34jZ7i
	 OEDIxPiLY353DqyhLTDfKAw3stsW4KhX/CRDZDBUI8p9hkHq9Z7tI2L3flgxh2cA/DrYb
	 +/l+2GHssg/yQllydCdnpmmZXFFO7UOoKhATa1NV+wiYYZFS2juiyLBjsgV8+F8yqZ0XS
	 Zm+euDVon/xPicxPEEayWn6UmvArWs4V63nFKBaYgy2RkzcX7By6BFa4ARPOqNlm++A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083102;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=hAxrrIcR8kFy2gsceeU205RpPHqOi1H7v/dWyGTpYxY=;
	b=ih3TDKoZcrB4y1Pipd9kec0OGpijzYrJsNvxEi0KcnHGbKJwkV2LTfbRVUqXQkt4OoYD
	 QreO00PlKzTudlsxf9nHj2iYoYhjJGu+DdJIW4NOqesMB2OS/OYQC92zbRiCB3gW9gjEV
	 w5BNN+RRZKk4Buk5U7j/P+vy05sZT35D8V/EwAYIsONBDdS8IkFBdbHBGxy3brrn1Whug
	 N8dj6objzj+Hg3132KthKDM48JcH5eZnNFTcg05fQ5lQguALWU5uUi/Xqu1MPxv9m+oem
	 Ki13RXwfupiAbIsrBp3pyY5jNjKo3oGGhB6Uh0DVfTHVd+719EJlPrRbJqjaLIbT34w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuVbsSZn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BB9606A32F;
	Sat,  7 Nov 2026 20:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuVbsSZn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7BC1F008A1;
	Sat,  7 Nov 2026 20:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083101;
	bh=hAxrrIcR8kFy2gsceeU205RpPHqOi1H7v/dWyGTpYxY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NuVbsSZneZIFgRql+d1Rn2GBYJawSe+9wASghXgzUEqq7jPAyAZaG4SbUlOU2AJ4z
	 9AccY7j4qTFLOzpALyYR8bOd18+TOvM1LDAI56tWEn4bdHauWnPPofnO1o+HNNm+2v
	 uZ/RJXf+qXaKHIEE1VsmB50LZhJD9shrYSo8kEVmZxlt6Dy7uKA2dooQMNK5onchst
	 sGgj5ZLX2o5rIVuAmq86RtNBM6DotzEkgAoIif6M47JOu3H54OoQNiRrv56CI1No68
	 HtCPDD9t/wPtfW77wXu1cGfOMvJ3QNvG7xYYa9S+KZSTWjGdbNp0Lgrte1Rqg9niaU
	 Dd4zf8SiS1biQ==
Subject: Re: [PATCH rdma-next 16/23] RDMA/mlx5: Ignore completion events for a
 CQ without a handler
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:00 +0000
Message-ID: <179408310019.994134.8139150984682840933@kernel.org>
In-Reply-To: <20261103163949.1554-17-yishaih@nvidia.com>
References: <20261103163949.1554-17-yishaih@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix leaves a memory-ordering race on comp_handler.

--

RDMA/mlx5: Ignore completion events for a CQ without a handler

This patch makes mlx5_ib_cq_comp() skip the comp_handler call when no
handler is set. The case it targets is devr->c0, which is never armed, but
a hostile NIC in adversarial mode can still raise a completion event for
it.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 5cc86c3f93f3e..f955eb762051d 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -46,7 +46,12 @@ static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
>  {
>  	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
>  
> -	ibcq->comp_handler(ibcq, ibcq->cq_context);
> +	/*
> +	 * A CQ created without a handler (devr->c0) is never armed, but a
> +	 * hostile NIC can still raise a completion event for it.
> +	 */
> +	if (ibcq->comp_handler)
> +		ibcq->comp_handler(ibcq, ibcq->cq_context);

[Severity: High]
For devr->c0 this check is enough, because comp_handler stays NULL for
that CQ. Is it also enough for the CQs set up by __ib_alloc_cq()?

The companion commit "RDMA/core: Set the CQ comp_handler after its poll
context is set up" relies on this NULL check as a "poll context ready"
gate. Neither side of that gate has any ordering, though.

On the writer side, the CQ can be reached from the EQ interrupt once
create_cq() puts it in eq->cq_table.tree. The handler is published later
with a plain store:

drivers/infiniband/core/cq.c:__ib_alloc_cq() {
    ...
	ret = dev->ops.create_cq(cq, &cq_attr, NULL);
    ...
	case IB_POLL_SOFTIRQ:
		comp_handler = ib_cq_completion_softirq;
		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
		break;
	case IB_POLL_WORKQUEUE:
	case IB_POLL_UNBOUND_WORKQUEUE:
		comp_handler = ib_cq_completion_workqueue;
		INIT_WORK(&cq->work, ib_cq_poll_work);
		cq->comp_wq = ...
    ...
	cq->comp_handler = comp_handler;
    ...
}

On the reader side, mlx5_eq_comp_int() gets the CQ with mlx5_eq_cq_get(),
which is an RCU radix_tree_lookup() plus a refcount increment. That orders
against the tree insertion, but not against the stores made after it.
mlx5_ib_cq_comp() then loads comp_handler twice with plain loads.

Adversarial mode is enabled when cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)
is true. That includes arm64 Realm and pKVM guests, and those CPUs are
weakly ordered. Take the UMR CQ, which mlx5r_umr_resource_init() allocates
with IB_POLL_SOFTIRQ.

Could another CPU see comp_handler == ib_cq_completion_softirq before the
memset(), INIT_LIST_HEAD(), weight and poll stores from irq_poll_init()
are visible? If so, irq_poll_sched() would link iop onto the per-CPU list.
The delayed irq_poll_init() stores could then overwrite iop->state and
iop->list while iop is still on that list.

Possible results are per-CPU list corruption, irq_poll_softirq() spinning
on a stale entry, or a NULL iop->poll call. For the workqueue cases, the
compiler is also free to move the plain comp_handler store ahead of the
INIT_WORK() and cq->comp_wq stores. That could lead to queue_work() with a
NULL workqueue or an uninitialized work item.

The wmb() in the later ib_req_notify_cq() only helps if the device waits
for the arm doorbell, and a hostile device does not wait.

Would it make sense to publish the handler with:

	smp_store_release(&cq->comp_handler, comp_handler);

in __ib_alloc_cq(), and read it once in mlx5_ib_cq_comp() with:

	ib_comp_handler h = smp_load_acquire(&ibcq->comp_handler);

	if (h)
		h(ibcq, ibcq->cq_context);

That also removes the double fetch. KCSAN would likely report the current
plain check against the plain store as a data race. Later patches in the
series do not change this code.

>  }
>  
>  static void mlx5_ib_cq_event(struct mlx5_core_cq *mcq, enum mlx5_event type)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
