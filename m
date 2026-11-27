Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795087;
	b=YW5KzVhr0kPKxf618GAqIFg3rd2mH8Z44M0GcSe0qgvzL6x+NRGSf5J3Rpk+GCg7kwzC
	 l4npqVfxc4EHRkQIQopuY0vGK01YuxoIVTWlweyMH1ZBQ93Y8f44O1+eGSo5jjn36Pi0B
	 N15wBubbK/AoFdZb8KPsTqfr9vHU55bO5rRe/J3E9vEaZW73EvA3gW4g6mM+um9+Op4ID
	 8jBAmTQehLfRT+i5nTqcLzJTqs+YpE7yi0Mj92Cb5NS0Jmadm6FQgBx0+NMN7v0DM6moi
	 L8146IImBMogOwXVXbJWnOnztgfvdL6IPKLQvVBL61dLzBSz+JQnleldfDlC656xmQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795087;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vEG8QweyGdJ9ToIkRpw9h7GvA1Mq3Om+7t07k7pLt/w=;
	b=ww8hdjQ6KknBlvhF1LidbOhRdHI+Kjv64SB7MSdV+UeyspTDOVe3nOZchLzyH0a1tX5Q
	 zHGKqjJNWxm6BdC/5VfqNSq5HFSW6cWne1NXv2dGlbY1aICwWWLnCTOnrzRWSPH8caMKn
	 AhikwUYMm11+omw35A9XqxJV283mqZ75vQy0vJe5BIOO4iuA28xR/r3SBli8CmzU5cRuc
	 zWn5FBEj+dm8bC4kSj4n6hj8LBYSVA+lbSOdl+Nkg+03JNs+f26ux29IOATds46YWJd5r
	 mYuUmA3RjcGUXOzcdYVpZsV7Z3epTV40ko0vBwoOemWOp0VGyscz8etpEq2EHxM3DXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c2CRpYNu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCD0606A33F;
	Fri, 27 Nov 2026 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c2CRpYNu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655F41F00A02;
	Fri, 27 Nov 2026 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795087;
	bh=vEG8QweyGdJ9ToIkRpw9h7GvA1Mq3Om+7t07k7pLt/w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c2CRpYNuMat8BzcNgz//dZKoBLt3iMCemKIox+1FpwYwNZkUX9UhAMafPMb7ErE6U
	 QxPYSkMkza+/hFwIGry3Ir8I1ZZj5WvJ7K3+ShogL8RNoPwsRGnfMnw/P5slpnO7nq
	 iFSRhAzk2MWBwaWh1rjmvKqRt6zWkqgyhOd7UwGlM14hw1P6sSe4P8ynYNyIGmjQpv
	 43BDV38xvMVuL5Rw+TyzzvimODoGRAV25EGlgEUwqhK495X5ykTSCsbxi+cfElLDAD
	 F3SkEc+aE3EFrRGv4ChRCPQQisi3Vb/mUJ9Iod+eEGvRl8FFkWh1z68eUr6kHD+nfE
	 Jh+rU5AJIjVkA==
Subject: Re: [PATCH v2 11/11] net/xsc: add the receive path
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:58:05 +0000
Message-ID: <179579508593.3135.4625762216890263591@kernel.org>
In-Reply-To: <20261126145742.70868-12-tianx@yunsilicon.com>
References: <20261126145742.70868-12-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 12 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 6 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] xsc_skb_from_cqe() builds each RX skb with napi_build_skb(va,
  XSC_SKB_FRAG_SZ(cqe_bcnt)), where cqe_bcnt is the packet length…
- [High] In xsc_eth_alloc_rq(), if kvzalloc_node() for prq->wqe.di fails,
  the code does goto err_destroy_wq while ret still holds 0 from the…
- [Medium] xsc_eth_napi_poll() calls xsc_eth_post_rx_wqes(rq) on every
  poll, including polls with budget == 0.
- [Medium] When xsc_alloc_rx_wqes() fails, xsc_eth_post_rx_wqes() returns
  true from inside its do/while loop.
- [Medium] xsc_eth_build_queue_param() clamps the SQ depth to its CQ:
  sq_size = min(BIT(log_max_qp_depth), XSC_SQCQ_ELE_NUM).
- [Medium] In xsc_eth_open_cq(), the CQ becomes reachable from the EQ IRQ
  path before its NAPI context exists.
- [Medium] xsc_eth_open_channels() calls
  napi_enable(&adapter->channel.napi) before…
- [Medium] net/xsc: unconditional TX CQ doorbell MMIO write in
  xsc_poll_tx_cq()
- [Low] The commit message only mentions the RX path and a shared NAPI
  poll.
- [Low] In xsc_skb_from_cqe(), net_prefetch(va +
  SKB_DATA_ALIGN(sizeof(struct skb_shared_info))) does not match this…
- [Low] xsc_dump_error_rqcqe() prints u32 values (rq->cq.xcq.cqn,
  xsc_cqwq_get_ci(), rq->rqn) with %d and the QP id with %lu.
- [Low] In xsc_eth_deactivate_channel(), XSC_ETH_RQ_STATE_ENABLED is
  cleared, then synchronize_net() runs, then napi_disable().

--

net/xsc: add the receive path

This patch adds the RX path for the xsc driver. It builds linear skbs
from page pool pages on RQ completions. A single NAPI context per
channel polls both the TX and RX completion queues, and the CQ completion
callback is wired to schedule it.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> index 8eda3c8b12f25..e7b0871c1ccb7 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -106,6 +106,13 @@ static void xsc_eth_cq_error_event(struct xsc_core_cq *xcq,
>  		   "Eth catch CQ ERROR: %x, cqn: %d\n", event, xcq->cqn);
>  }
>  
> +static void xsc_eth_comp(struct xsc_core_cq *xcq)
> +{
> +	struct xsc_cq *cq = container_of(xcq, struct xsc_cq, xcq);
> +
> +	napi_schedule(cq->napi);
> +}
> +

[ ... ]

> @@ -204,6 +212,7 @@ static int xsc_eth_open_cq(struct xsc_channel *c,
>  
>  	xsc_arm_cq(pcq->xdev, pcq->xcq.cqn, pcq->wq.cc, 0);
>  
> +	pcq->napi = &c->napi;
>  	pcq->channel = c;
>  
>  	return 0;

[Severity: Medium]
Can xsc_eth_comp() run before cq->napi is valid? This is the order of
operations:

  xsc_eth_alloc_cq()
    core_cq->comp = xsc_eth_comp;
  xsc_eth_set_cq()
    CQ inserted into cq_table
  xsc_arm_cq()
    CQ armed
  pcq->napi = &c->napi;   (no barrier)
  ...
  xsc_eth_open_channel()
    netif_napi_add(adapter->netdev, &c->napi, xsc_eth_napi_poll);

A COMP or INTERNAL_ERROR EQE for this CQN can arrive before pcq->napi is
assigned. In that case xsc_eth_comp() calls napi_schedule(NULL) from
hardirq context.

A second window exists after the pointer is set but before
netif_napi_add() runs. Then napi_schedule_prep() succeeds on the zeroed
state and queues a napi with a NULL ->poll. The later netif_napi_add()
then reinitializes a poll_list that is still linked.

The normal open sequence does not post work to these CQs this early, so
a stale or spurious EQE would be needed. Would it be safer to set
cq->napi and call netif_napi_add() before the CQs are created and armed?

[ ... ]

> @@ -465,6 +476,8 @@ static int xsc_eth_modify_qps_channel(struct xsc_adapter *adapter,
>  {
>  	int ret;
>  
> +	xsc_eth_post_rx_wqes(&c->qp.rq);
> +

[Severity: High]
What happens here if xsc_eth_alloc_rq() failed to allocate the di array?
That error path was added earlier in the series by "net/xsc: add the
single TX/RX channel":

xsc_eth_alloc_rq() {
    ...
	prq->wqe.di = kvzalloc_node(array_size(wq_sz, sizeof(*prq->wqe.di)),
				    GFP_KERNEL, cpu_to_node(c->cpu));
	if (!prq->wqe.di)
		goto err_destroy_wq;
    ...
}

On that path ret is still 0 from xsc_eth_wq_cyc_create(). The cleanup
calls xsc_eth_wq_destroy()->xsc_core_frag_buf_free(), which frees the WQ
pages and kfree()s buf->frags, and the function then returns success.
After that, xsc_eth_open_qp_rq()->xsc_core_fill_page_frag_array() reads
the freed buf->frags[] and passes the freed DMA addresses to firmware in
CREATE_QP.

With this patch, the RQ then reaches xsc_eth_post_rx_wqes() with
rq->wqe.wqe_bulk still 0:

	do {
		head = xsc_wq_cyc_get_head(wq);
		alloc = min_t(int, rq->wqe.wqe_bulk, xsc_wq_cyc_missing(wq));
		...
		xsc_wq_cyc_push_n(wq, alloc);
	} while (xsc_wq_cyc_missing(wq) >= rq->wqe.wqe_bulk);

alloc is 0, nothing gets pushed, and the condition is always true. Does
this loop forever in ndo_open with rtnl held? If it were ever escaped,
xsc_eth_close_qp_rq()->xsc_eth_dealloc_rx_wqe() would dereference the
NULL di.

Should ret be set to -ENOMEM before the goto in xsc_eth_alloc_rq()?

>  	ret = xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.rq.rqn,
>  					    XSC_CMD_OP_RTR2RTS_QP);

[ ... ]

> @@ -662,6 +684,9 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
>  		goto err_close_channel;
>  	free_rq = true;
>  
> +	napi_enable(&adapter->channel.napi);
> +	napi_enabled = true;
> +
>  	ret = xsc_eth_modify_qps_channel(adapter, &adapter->channel);
>  	if (ret)
>  		goto err_close_channel;

[Severity: Medium]
NAPI is enabled here before xsc_eth_modify_qps_channel() fills the RX
ring from process context:

  xsc_eth_modify_qps_channel()
    xsc_eth_post_rx_wqes()
      xsc_alloc_rx_wqes()
        page_pool_dev_alloc_pages()
      xsc_wq_cyc_push_n()
      xsc_rq_notify_hw()

Once NAPI is enabled, any completion scheduled through xsc_eth_comp()
runs xsc_eth_napi_poll(). That poll calls xsc_eth_post_rx_wqes(rq)
unconditionally, because only xsc_poll_rx_cq() checks
XSC_ETH_RQ_STATE_ENABLED.

Nothing serializes the two callers. They could race on wq->wqe_ctr,
wq->cur_sz, the di[] slots, the RX doorbell value, and the page pool's
lockless alloc cache. That cache expects to be used only from the owning
NAPI.

In the normal open sequence this would need a spurious or stale EQE.
Could the ring be filled before napi_enable(), or filled only from NAPI
by calling napi_schedule() after enabling it?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
> new file mode 100644
> index 0000000000000..2c07f80928ea2
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
> @@ -0,0 +1,210 @@

[ ... ]

> +static struct sk_buff *xsc_skb_from_cqe(struct xsc_rq *rq,
> +					struct xsc_dma_info *di,
> +					u32 cqe_bcnt)
> +{
> +	struct sk_buff *skb;
> +	void *va;
> +	u32 frag_size;
> +
> +	va = page_address(di->page);
> +	frag_size = XSC_SKB_FRAG_SZ(cqe_bcnt);
> +
> +	dma_sync_single_range_for_cpu(rq->cq.xdev->device, di->addr,
> +				      0, frag_size, DMA_FROM_DEVICE);
> +	net_prefetch(va + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));

[Severity: Low]
Is this prefetch offset intended? The WQE is posted with the raw page DMA
address (wqe->data[0].va = cpu_to_le64(di->addr)), and napi_build_skb()
is called without skb_reserve(). So the Ethernet header is at va + 0 and
shinfo is at va + SKB_DATA_ALIGN(cqe_bcnt).

This prefetch lands about 320 bytes into the payload, or past the end of
small frames.

The skb also ends up with zero headroom, even though xsc_eth_common.h
defines XSC_ETH_RX_MAX_HEAD_ROOM and XSC_SW2HW_RX_PKT_LEN accounts for
it. Was headroom meant to be reserved here?

> +
> +	skb = napi_build_skb(va, frag_size);

[Severity: High]
Does this undercount skb->truesize? frag_size is derived from the packet
length reported by the device, but each WQE owns a whole order-0 page:

xsc_eth_alloc_rq() {
    ...
	prq->wqe.wqe_bulk = PAGE_SIZE /
		roundup_pow_of_two(xsc_rx_get_linear_frag_sz(c->adapter->nic_param.mtu));

	pagepool_params.order = XSC_RX_FRAG_SZ_ORDER;
    ...
}

xsc_alloc_rx_wqes() allocates one page_pool page per WQE and never
shares a page between WQEs. The frags-per-page formula above is only
used as a batch count.

__finalize_skb_around() sets truesize to
SKB_TRUESIZE(SKB_DATA_ALIGN(cqe_bcnt)). A 60-byte frame is charged
roughly 640 bytes while it pins 4 KiB. On 64 KiB page systems the gap is
close to 100x.

Socket rcvbuf, TCP rmem and OOO pruning, ipfrag_high_thresh and GRO
merged truesize all rely on this value. A remote sender of small frames
or fragments could therefore pin much more memory than the limits allow.

Should the skb be built with the real buffer size, so truesize reflects
the page being pinned?

> +	if (unlikely(!skb))
> +		return NULL;

[ ... ]

> +static void xsc_dump_error_rqcqe(struct xsc_rq *rq, struct xsc_cqe *cqe)
> +{
> +	struct xsc_channel *c = rq->cq.channel;
> +	u32 data0 = le32_to_cpu(cqe->data0);
> +
> +	net_err_ratelimited("Error cqe on dev=%s, cqn=%d, ci=%d, rqn=%d, qpn=%lu, error_code=0x%lx\n",
> +			    c->netdev->name, rq->cq.xcq.cqn,
> +			    xsc_cqwq_get_ci(&rq->cq.wq), rq->rqn,
> +			    FIELD_GET(XSC_CQE_DATA0_QP_ID_MASK, data0),
> +			    FIELD_GET(XSC_CQE_DATA0_ERR_CODE_MASK, data0));
> +}

[Severity: Low]
This isn't a bug, but cqn, ci and rqn are u32 values printed with %d, and
the QP id is printed with %lu.

The TX counterpart added in this patch, xsc_dump_error_sqcqe(), prints
the same CQE fields in hex. It also uses a different order (err_code
before qpid). Could the two dumps use the same format?

[ ... ]

> +bool xsc_eth_post_rx_wqes(struct xsc_rq *rq)
> +{
> +	struct xsc_wq_cyc *wq = &rq->wqe.wq;
> +	int alloc;
> +	u16 head;
> +
> +	if (xsc_wq_cyc_missing(wq) < rq->wqe.wqe_bulk)
> +		return false;
> +
> +	do {
> +		head = xsc_wq_cyc_get_head(wq);
> +		alloc = min_t(int, rq->wqe.wqe_bulk, xsc_wq_cyc_missing(wq));
> +
> +		if (xsc_alloc_rx_wqes(rq, head, alloc))
> +			return true;

[Severity: Medium]
Are the WQEs from earlier iterations lost to the device here? Those bulks
have already advanced wq->wqe_ctr and wq->cur_sz through
xsc_wq_cyc_push_n(). This early return skips dma_wmb() and
xsc_rq_notify_hw(), so the hardware is never told about them.

At open time this matters more. xsc_eth_modify_qps_channel() ignores the
return value and moves the RQ to RTS anyway. xsc_eth_activate_channel()
only sets XSC_ETH_RQ_STATE_ENABLED and never schedules NAPI.

If the initial fill fails (page_pool_dev_alloc_pages() is GFP_ATOMIC for
up to wq_sz pages), the hardware RQ has no buffers. No RX CQE or RX
interrupt can then occur. The refill would only be retried if a TX
completion happens to schedule the shared NAPI.

Should the doorbell be rung for what was already pushed? Should open
either fail or schedule NAPI when the initial fill comes up short?

> +
> +		xsc_wq_cyc_push_n(wq, alloc);
> +	} while (xsc_wq_cyc_missing(wq) >= rq->wqe.wqe_bulk);

[Severity: Medium]
This loop keeps the RQ nearly full. Is the RQ depth guaranteed to fit in
the RQ CQ? The SQ depth is clamped to XSC_SQCQ_ELE_NUM in
xsc_eth_build_queue_param(), but the RQ depth is not:

xsc_eth_build_queue_param() {
    ...
	if (adapter->nic_param.rq_size == 0)
		adapter->nic_param.rq_size = BIT(xdev->caps.log_max_qp_depth);
    ...
}

The RQ CQ is min(XSC_RQCQ_ELE_NUM, caps.max_cqes). Firmware could report
log_max_qp_depth > 11, or max_cqes < rq_size. Then the device can have
more outstanding receives than the CQ has entries.

xsc_eth_handle_rx_cqe() derives the WQE index from rq->cq.wq.cc. A CQ
overrun would therefore pair CQEs with the wrong buffers.

Separately, the RX doorbell PID field is only 13 bits:

#define XSC_RX_DB_DATA0_NEXT_PID_MASK	GENMASK(12, 0)

xsc_eth_open_qp_rq() creates the QP with
log_rq_sz = ilog2(recv_ds_num) + q_log_size, and nothing checks the two
against each other.

Should rq_size be clamped the same way the SQ is, and checked against
the doorbell width?

> +
> +	dma_wmb();
> +
> +	/* ensure wqes are visible to device before updating doorbell record */
> +	xsc_rq_notify_hw(rq);
> +
> +	return false;
> +}
> +
> +int xsc_eth_napi_poll(struct napi_struct *napi, int budget)
> +{
> +	struct xsc_channel *c = container_of(napi, struct xsc_channel, napi);
> +	struct xsc_rq *rq = &c->qp.rq;
> +	bool busy;
> +	int work_done;
> +
> +	busy = xsc_poll_tx_cq(&c->qp.sq.cq, xsc_cqwq_get_size(&c->qp.sq.cq.wq));
> +
> +	work_done = xsc_poll_rx_cq(&rq->cq, budget);
> +	busy |= work_done == budget;
> +
> +	if (xsc_eth_post_rx_wqes(rq))
> +		busy = true;

[Severity: Medium]
This patch makes xsc_eth_napi_poll() the only caller of
xsc_poll_tx_cq(), so the TX CQ is now reaped on every NAPI poll,
including polls driven purely by RX. xsc_poll_tx_cq() still ends with
an unconditional doorbell write:

  xsc_update_cq_ci(cq->xdev, cq->xcq.cqn, cq->wq.cc);

That write happens even when i == 0 and cq->wq.cc did not move. It
costs a wmb() and a writel() to DB_CQ_CID_DIRECT_MEM_ADDR and achieves
nothing.

When the poll then completes, xsc_cq_notify_hw_rearm() writes the SQ
CQ doorbell again through xsc_arm_cq(). An idle TX side therefore adds
two full barriers and two MMIO writes to every RX interrupt.

xsc_poll_rx_cq() already guards xsc_cq_notify_hw() with
if (work_done). Could xsc_poll_tx_cq() do the same, for example by
calling xsc_cq_notify_hw() only when i is non-zero?

There are two related points in the same path.

The TX budget passed in is xsc_cqwq_get_size(), the whole SQ CQ. One
poll can spend up to a full ring of unmaps and frees before RX is
looked at.

Completed skbs are released with dev_kfree_skb_any(). That skips the
NAPI bulk free cache, and it also reports successfully transmitted
skbs as drops.

Now that this only runs from NAPI, would napi_consume_skb(skb, budget)
be a better fit? It would need the real NAPI budget passed down
instead of the ring size. That way the netpoll case with budget == 0
still falls back to dev_consume_skb_any().

[Severity: Medium]
Is the refill safe when budget is 0? netpoll calls the poll function
with a zero budget, usually with IRQs disabled:

  netpoll_send_skb()
    netpoll_poll_dev()
      poll_napi()
        poll_one_napi()
          napi->poll(napi, 0)

xsc_poll_rx_cq() does nothing in that case, but xsc_eth_post_rx_wqes()
still runs. It calls page_pool_dev_alloc_pages(), and on failure its
unwind calls page_pool_recycle_direct().

Documentation/networking/napi.rst says "Rx specific APIs like page pool
or XDP cannot be used at all when budget is 0" and "if the argument is 0
driver cannot call any XDP (or page pool) APIs".

With hardirqs disabled, the lockdep_assert_no_hardirq() in
__page_pool_put_page() would fire. The pool's lockless alloc cache could
also be touched while this CPU's NAPI was interrupted mid-recycle.

Should the RX refill be skipped when budget is 0?

> +
> +	if (busy)
> +		return budget;
> +
> +	if (unlikely(!napi_complete_done(napi, work_done)))
> +		return work_done;
> +
> +	xsc_cq_notify_hw_rearm(&c->qp.sq.cq);
> +	xsc_cq_notify_hw_rearm(&rq->cq);

[Severity: Low]
Can this re-arm loop without progress during ifdown?
xsc_eth_deactivate_channel() does this:

	clear_bit(XSC_ETH_RQ_STATE_ENABLED, &c->qp.rq.state);
	clear_bit(XSC_ETH_SQ_STATE_ENABLED, &c->qp.sq.state);

	synchronize_net();

	/* last doorbell out */
	napi_disable(&c->napi);

The RQ stays in RTS with RSS active for that whole window, because
xsc_eth_disable_nic_hca() only runs after xsc_eth_sw_deinit() in
xsc_eth_close().

Packets arriving in this window generate RX CQEs. xsc_poll_rx_cq()
returns 0 because the bit is cleared, NAPI completes, and the RQ CQ is
re-armed with a consumer index behind the hardware producer.

If the hardware raises an event whenever a CQ with pending CQEs is
armed, this would cycle interrupt -> NAPI -> re-arm until napi_disable().
Should the RQ CQ re-arm be skipped once the RQ is disabled?

> +
> +	return work_done;
> +}

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> index ee6554ed80040..b3c926506a5e8 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c

[ ... ]

> @@ -43,6 +65,9 @@ int xsc_poll_tx_cq(struct xsc_cq *cq, int budget)
>  		/* ensure cqe content is read after cqe ownership bit */
>  		dma_rmb();
>  
> +		if (unlikely(le32_to_cpu(cqe->data0) & XSC_CQE_DATA0_IS_ERR))
> +			xsc_dump_error_sqcqe(sq, cqe);
> +
>  		xsc_cqwq_pop(&cq->wq);

[Severity: Low]
This isn't a bug, but the commit message only talks about the receive
path:

  Receive linear skbs from the completion queue with a page pool and
  handle both queue completions from a single NAPI poll.

The patch also changes TX behaviour. It adds xsc_dump_error_sqcqe() and
this error check. It is also the first patch to set
core_cq->comp = xsc_eth_comp, which is what makes xsc_poll_tx_cq()
actually run.

In the previous commit, "net/xsc: add the transmit path", xsc_poll_tx_cq()
had no caller, even though that commit's message says it reaps
completions. Could the TX changes be mentioned here, or moved into the TX
patch?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
