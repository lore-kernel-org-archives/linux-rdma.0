Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795082;
	b=VEh+jtqGwcBl+LzQUmczBGKpySK0yFpJoILdOhcGrzKhsftjYrhzl6Sx3PMsq8nsvURQ
	 FQ9dwbpSZcXEd6vKnVXwNVWRjxuJEpw+mn0Yl1A/+wo5INzk5dDlfa3m+BOjmfD5BgWJu
	 CgSFihYed9lCT4gKeumuMZNhLao6B9yuz4pmmaz0Tny0AuhvLS4btaCVaDipV+Nv5kyNr
	 j61mH+0lqziozSzAzOdw3jlbedl/If3KxxsNx7mWBbMzyO7tR5WLOAxzXz14cNBHhxrfj
	 7rswOVSOI1HSv/enAhdDDV1WQM9AfuyZX0nh3x39eijnru3k1PGD9TigOW0g/ulOKog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795082;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Sz0J1I1I6zeiPqKAIYnUCBCqReZQzAc4ATnlHHRTeAc=;
	b=vdjnq1Q1raGfhQhCnJche9W3btVJCgRdBsu+yEORUlfxzJQKT0SHQgUKs1eGOrkagALs
	 nmyH5OkKI6kXyp34Ierz1BgMOmwdS0gCn+C8kCoSoSs+lWZFoEQw7aeKtSNkcULWPzWxT
	 GPpnt5U1YPPUOLsAfuvK5g6o12LYrkcSc85Pox2CF+FoBxQSzTMcoU579r3FZxbFgIyvl
	 xhS0ZNMbpRdP0ea2fDsQOwu2ZMO3xIhexvRVNAhqMKY4w/TZ9si4IFMsx4r/QfoibwfYd
	 mc6o0qncn+RfwfPzGFHmaerJaHCdhJJuul+BsQ7BT/3y9n59ig3HDLZZFym4Hzd4yBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1XIG7xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E754606A6A4;
	Fri, 27 Nov 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1XIG7xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1241F008A0;
	Fri, 27 Nov 2026 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795082;
	bh=Sz0J1I1I6zeiPqKAIYnUCBCqReZQzAc4ATnlHHRTeAc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=F1XIG7xnM+o2iueKdev0ZzugKLJHnlpekEneX+GL/zEpAOv+/PDCrc4RLOI72tj46
	 idehW9enGIxLglJ0te91FPgPZ9NGNm/Z/MMXdWykx9NJ113tEhZuR5T/bmGcStDXZX
	 7qLo/tmLuos/QOfm7x8oeA4QTWtbZoGqBsiyNGAJNy4Ry3DVspOoi6z9KYxkx/x0hO
	 l9t7fRBX6O+8vwdaTgr7Rnx6JcT3kaNTBHcq6T6SkqAK7cJwVraRF0PWjlB8WEc3bS
	 quwyIHR/41d2aPDpGcqPNKidedunGApRKt0MMn5YTr8Va+FvZfH7vY6wCi5e6wuMgD
	 oUj9WANvl12HA==
Subject: Re: [PATCH v2 08/11] net/xsc: add the single TX/RX channel
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:58:00 +0000
Message-ID: <179579508072.3135.14994924132240509860@kernel.org>
In-Reply-To: <20261126145733.70868-9-tianx@yunsilicon.com>
References: <20261126145733.70868-9-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 11 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 4 · Low: 6

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] xsc_eth_alloc_rq()
  (drivers/net/ethernet/yunsilicon/xsc/net/main.c) reports success when…
- [Medium] The teardown order in xsc_eth_close() is not the reverse of
  xsc_eth_open().
- [Medium] xsc_eth_build_queue_param() sets the RQ depth to `rq_size =
  BIT(xdev->caps.log_max_qp_depth)` (line 38) with no clamp.
- [Medium] ENABLE_NIC_HCA in xsc_eth_enable_nic_hca() writes the absolute
  QPN returned by CREATE_QP into in.rss.rqn_base (line 745).
- [Medium] net/xsc: WQ DMA buffers freed on xsc_core_eth_destroy_qp()
  rollback failure
- [Low] Software and the CREATE_QP mailbox round the WQE stride
  differently.
- [Low] When DESTROY_QP fails, xsc_eth_close_qp_rq() and
  xsc_eth_close_qp_sq() return early on purpose and leak the WQ buffer,…
- [Low] The patch adds EXPORT_SYMBOL_GPL(xsc_fill_page_array) in
  drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c (line 124), and the…
- [Low] In xsc_eth_qp_event(), the branch for an unknown queue type
  prints `type` (the async event code) instead of qp->eth_queue_type,…
- [Low] xsc_dma_zalloc_coherent_node() (pci/alloc.c, lines 155-158) saves
  the numa_node of the shared, live PCI device, overwrites it with…
- [Low] xsc_eth_open_channel() reads the live IRQ descriptor's affinity
  mask without desc->lock: `aff = irq_get_affinity_mask(irqn); if (aff)…

--

net/xsc: add the single TX/RX channel

This patch brings up a single TX/RX channel on the xsc netdev. It builds
the queue parameters, creates the CQs, SQ and RQ through the core, and
enables the NIC HCA from ndo_open. It also adds the work queue ring helpers
and the fragmented DMA buffer allocation helpers in the pci core.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> index b9e75d7e14e78..1c7bbc27d8c4f 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -25,6 +25,774 @@ static void xsc_eth_netdev_init(struct xsc_adapter *adapter)
>  	netif_carrier_off(adapter->netdev);
>  }
>  
> +static void xsc_eth_build_queue_param(struct xsc_adapter *adapter,
> +				      struct xsc_queue_attr *attr, u8 type)
> +{
> +	struct xsc_core_device *xdev = adapter->xdev;
> +
> +	if (adapter->nic_param.sq_size == 0)
> +		adapter->nic_param.sq_size = min_t(u32,
> +						   BIT(xdev->caps.log_max_qp_depth),
> +						   XSC_SQCQ_ELE_NUM);
> +	if (adapter->nic_param.rq_size == 0)
> +		adapter->nic_param.rq_size = BIT(xdev->caps.log_max_qp_depth);

[Severity: Medium]
Should rq_size be clamped here the same way sq_size is?

Further down, the RQ's CQ gets min(XSC_RQCQ_ELE_NUM, caps.max_cqes)
entries. If firmware reports log_max_qp_depth above 11, the RQ ring ends up
deeper than its 2048-entry CQ. Once the receive path fills the ring, could
more completions be outstanding than the CQ can hold?

The sq_size clamp only uses XSC_SQCQ_ELE_NUM and ignores caps.max_cqes, so
the SQ can also end up deeper than its CQ.

Separately, struct xsc_wq_cyc in xsc_eth_wq.h stores the ring size in u16
fields:

struct xsc_wq_cyc {
	struct xsc_frag_buf_ctrl fbc;
	u16			sz;
	u16			wqe_ctr;
	u16			cur_sz;
};

xsc_wq_cyc_get_size() returns u32, though. With log_max_qp_depth >= 16,
xsc_eth_wq_cyc_create() would truncate wq->sz to 0. xsc_wq_cyc_missing()
would then never be positive, so the RX ring would never be posted. Can
firmware report a value in that range?

[ ... ]

> +	} else if (type == XSC_QUEUE_TYPE_RQ) {
> +		attr->ele_num = adapter->nic_param.rq_size;
> +		attr->ele_size = xdev->caps.recv_ds_num * XSC_RECV_WQE_DS;
> +		attr->ele_log_size = order_base_2(attr->ele_size);
> +		attr->q_log_size = order_base_2(attr->ele_num);
> +	} else if (type == XSC_QUEUE_TYPE_SQ) {
> +		attr->ele_num = adapter->nic_param.sq_size;
> +		attr->ele_size = xdev->caps.send_ds_num * XSC_SEND_WQE_DS;
> +		attr->ele_log_size = order_base_2(attr->ele_size);
> +		attr->q_log_size = order_base_2(attr->ele_num);
> +	}
> +}

[Severity: Low]
The software WQE stride here is order_base_2(ds_num * 16), which rounds
up. xsc_eth_open_qp_sq() and xsc_eth_open_qp_rq() pass the hardware a size
that rounds down:

	in->req.log_sq_sz = ilog2(xdev->caps.send_ds_num) + q_log_size;
	in->req.log_rq_sz = ilog2(xdev->caps.recv_ds_num) + q_log_size;

send_ds_num and recv_ds_num come from firmware, and nothing checks that
they are powers of two. If one is not, do the hardware and software then
disagree on WQE offsets and ring size?

Could one rounding be used consistently, or non-power-of-two values be
rejected?

[ ... ]

> +static void xsc_eth_qp_event(struct xsc_core_qp *qp, int type)
> +{
> +	struct xsc_core_device *xdev;
> +	struct xsc_rq *rq;
> +	struct xsc_sq *sq;
> +
> +	if (qp->eth_queue_type == XSC_RES_RQ) {
> +		rq = container_of(qp, struct xsc_rq, cqp);
> +		xdev = rq->cq.xdev;
> +	} else if (qp->eth_queue_type == XSC_RES_SQ) {
> +		sq = container_of(qp, struct xsc_sq, cqp);
> +		xdev = sq->cq.xdev;
> +	} else {
> +		pr_err("%s:Unknown eth qp type %d\n", __func__, type);

[Severity: Low]
This isn't a bug, but should this print qp->eth_queue_type instead of type?
type is the async event code, not the queue type that failed the check.

[ ... ]

> +static int xsc_eth_open_channel(struct xsc_adapter *adapter,
> +				struct xsc_channel *c,
> +				struct xsc_channel_param *chl_param)
> +{

[ ... ]

> +	ret = xsc_core_vector2eqn(xdev, 0, &eqn, &irqn);
> +	if (ret)
> +		goto err_out;
> +	aff = irq_get_affinity_mask(irqn);
> +	if (aff)
> +		c->cpu = cpumask_first(aff);

[Severity: Low]
Can c->cpu end up >= nr_cpu_ids here?

The affinity mask is read without desc->lock. On a system with more than
BITS_PER_LONG CPUs, a concurrent write to /proc/irq/N/smp_affinity could
briefly expose an empty mask. xsc_eth_alloc_cq(), xsc_eth_open_qp_sq() and
xsc_eth_alloc_rq() then use c->cpu in cpu_to_node(c->cpu) without a range
check.

Would cpumask_first_and() with cpu_online_mask, plus a fallback when the
result is >= nr_cpu_ids, be safer?

[ ... ]

> +static int xsc_eth_alloc_rq(struct xsc_channel *c,
> +			    struct xsc_rq *prq,
> +			    struct xsc_rq_param *prq_param)
> +{

[ ... ]

> +	ret = xsc_eth_wq_cyc_create(c->adapter->xdev, &prq_param->wq,
> +				    q_log_size, ele_log_size, &prq->wqe.wq,
> +				    &prq->wq_ctrl);
> +	if (ret)
> +		return ret;
> +
> +	wq_sz = xsc_wq_cyc_get_size(&prq->wqe.wq);
> +	prq->wqe.di = kvzalloc_node(array_size(wq_sz, sizeof(*prq->wqe.di)),
> +				    GFP_KERNEL, cpu_to_node(c->cpu));
> +	if (!prq->wqe.di)
> +		goto err_destroy_wq;

[Severity: High]
Is ret still 0 at this point? The last assignment was the successful
xsc_eth_wq_cyc_create(). If kvzalloc_node() fails, this path frees the WQ
buffer and returns 0.

xsc_eth_open_qp_rq() then treats the call as a success:

xsc_eth_open_qp_rq()
    hw_npages = DIV_ROUND_UP(prq->wq_ctrl.buf.size, XSC_PAGE_SIZE_4K);
    ...
    xsc_core_fill_page_frag_array(&prq->wq_ctrl.buf,
                                  &in->req.pas[0], hw_npages);
    ret = xsc_core_eth_create_qp(xdev, in, inlen, &prq->rqn);

xsc_core_frag_buf_free() kfree()s buf->frags but leaves frags, npages and
size unchanged. xsc_core_fill_page_frag_array() therefore reads the freed
frags array. CREATE_QP is then given the DMA addresses of pages that
dma_free_coherent() has already released. Could the device then DMA into
freed memory?

Later, xsc_eth_free_qp_rq() runs, from either the CREATE_QP failure path or
xsc_eth_close_qp_rq(). It calls xsc_eth_wq_destroy() again on the same
stale buf, so every coherent frag and buf->frags would be freed a second
time.

With the receive patch that follows, xsc_eth_modify_qps_channel() also ends
up posting RX WQEs while di == NULL, page_pool == NULL and wqe_bulk == 0.

Should ret be set to -ENOMEM before the goto, and should
xsc_core_frag_buf_free() clear buf->frags and buf->npages?

[ ... ]

> +static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
> +{
> +	if (free_rq)
> +		xsc_eth_close_qp_rq(c, &c->qp.rq);
> +	xsc_eth_close_cq(c, &c->qp.rq.cq);
> +	memset(&c->qp.rq, 0, sizeof(struct xsc_rq));
> +
> +	xsc_eth_close_qp_sq(c, &c->qp.sq);
> +	xsc_eth_close_cq(c, &c->qp.sq.cq);
> +	memset(&c->qp.sq, 0, sizeof(struct xsc_sq));
> +}

[Severity: Low]
When DESTROY_QP fails, xsc_eth_close_qp_rq() and xsc_eth_close_qp_sq()
return early on purpose and leak the WQ buffer, because the QP is still
live in firmware. They return void, though.

Does this function then destroy the CQ that the live QP is still bound to,
and memset() away its QPN and wq_ctrl?

If so, there is no way to retry the destroy or reclaim the leaked DMA
pages. The CQN could also be reused by another queue while the old QP
still points at it.

Could the close helpers report the failure, so that the CQ teardown and
the memset() are skipped in that case?

[ ... ]

> +static int xsc_eth_enable_nic_hca(struct xsc_adapter *adapter)
> +{

[ ... ]

> +	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_ENABLE_NIC_HCA);
> +
> +	in.rss.rss_en = 1;
> +	in.rss.rqn_base = cpu_to_be16(adapter->channel.qp.rq.rqn);

[Severity: Medium]
Does firmware expect an absolute QPN in rqn_base?

struct xsc_hca_cap in common/xsc_cmd.h has raweth_rss_qp_id_base and
raweth_qp_id_base fields. The caps query in pci/main.c never parses them,
and nothing subtracts a base from rqn.

If firmware treats rqn_base as relative to raweth_rss_qp_id_base, RSS could
steer traffic to the wrong RQ on any function where that base is non-zero.

Also, cpu_to_be16() here silently narrows the 24-bit qpn returned by
xsc_core_eth_create_qp() to 16 bits.

[ ... ]

> @@ -45,25 +813,46 @@ static void xsc_set_port_admin_status(struct xsc_adapter *adapter,

[ ... ]

>  static int xsc_eth_close(struct net_device *netdev)
>  {
>  	struct xsc_adapter *adapter = netdev_priv(netdev);
> +	int ret;
>  
>  	adapter->opened = false;
>  
>  	netif_carrier_off(adapter->netdev);
>  
> +	xsc_eth_sw_deinit(adapter);
> +
> +	ret = xsc_eth_disable_nic_hca(adapter);
> +	if (ret)
> +		netdev_err(adapter->netdev, "failed to disable nic hca, err=%d\n",
> +			   ret);
> +
>  	xsc_set_port_admin_status(adapter, XSC_PORT_DOWN);
>  
> -	return 0;
> +	return ret;
>  }

[Severity: Medium]
If xsc_core_eth_create_qp() has succeeded and a later step fails, this
rollback calls xsc_core_eth_destroy_qp() but ignores its return value,
then falls through to xsc_eth_wq_destroy() and frees the SQ WQ pages
anyway.

xsc_eth_close_qp_sq() and xsc_eth_close_qp_rq() in this same patch
check the DESTROY_QP result and deliberately leak the WQ buffer when it
fails, because the QP is still live in firmware with those pages
programmed. Shouldn't the open-time rollback follow the same rule?

As written, a failure in xsc_core_create_resource_common(),
xsc_eth_alloc_qp_sq_db() or xsc_core_eth_modify_raw_qp() followed by a
failed DESTROY_QP hands pages back to the allocator that the device can
still DMA into.

xsc_eth_open_qp_rq() has the same issue at err_destroy_qp. The result
of xsc_core_eth_destroy_qp() is dropped, and xsc_eth_free_qp_rq() then
frees the WQ buffer and destroys the page_pool anyway.

Could both paths check the destroy result and skip the buffer free (and
the page_pool destroy for the RQ) when it fails?

[Severity: Medium]
Should this teardown be the reverse of xsc_eth_open()?

Open creates the queues and then sends ENABLE_NIC_HCA with RSS pointed at
channel.qp.rq.rqn. Close does it the other way round.
xsc_eth_sw_deinit() destroys the RQ/SQ, the CQs, the buffers and the
page_pool first. Only after that is DISABLE_NIC_HCA sent, and the port is
still admin up at that point.

During that window, the HCA steering refers to a QPN that firmware has
already destroyed and may reuse. If DISABLE_NIC_HCA fails, close only logs
an error, and the HCA stays enabled with a stale RQN.

Would it be better to disable the HCA, or redirect RSS, before the queues
are destroyed?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> index 46eb0b031511d..0b0478c64be3b 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> @@ -121,3 +121,105 @@ void xsc_fill_page_array(struct xsc_buf *buf, __be64 *pas, unsigned int npages)
>  		pas[i] = cpu_to_be64(addr);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(xsc_fill_page_array);

[Severity: Low]
This isn't a bug, but is this export needed?

xsc_fill_page_array() is declared only in the private pci/alloc.h. Its only
caller is xsc_create_eq() in pci/eq.c, which is built into the same module.
xsc_eth uses only the new frag helpers.

The commit message doesn't mention this export either.

[ ... ]

> +static void *xsc_dma_zalloc_coherent_node(struct xsc_core_device *xdev,
> +					  size_t size, dma_addr_t *dma_handle,
> +					  int node)
> +{
> +	struct device *device = &xdev->pdev->dev;
> +	int original_node;
> +	void *cpu_handle;
> +
> +	/* WA for kernels that don't use numa_mem_id in alloc_pages_node */
> +	if (node == NUMA_NO_NODE)
> +		node = numa_mem_id();
> +
> +	original_node = dev_to_node(device);
> +	set_dev_node(device, node);
> +	cpu_handle = dma_alloc_coherent(device, size, dma_handle, GFP_KERNEL);
> +	set_dev_node(device, original_node);

[Severity: Low]
What serializes this save, modify and restore of the PCI device's
numa_node? mlx5_dma_zalloc_coherent_node(), which this looks derived from,
holds priv->alloc_mutex around the same sequence.

Other users of &xdev->pdev->dev can see the temporary node. One example is
the xsc_cmd dma_pool created in cmd.c, which is used from the event
workqueue without rtnl.

Two concurrent callers of the exported xsc_core_frag_buf_alloc_node() could
also interleave their save and restore steps. That would leave
dev->numa_node permanently wrong.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
