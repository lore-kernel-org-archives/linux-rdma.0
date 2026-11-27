Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795085;
	b=wzapffFXsZQmj41QSFgNWpk2wPU2D+TyH9rs/8nRp6q8ufIC8U8oeiq22LyUh83XzJpz
	 LbQTAnE2XUGBP793A4reWpBQP6RZWv+gfL5trNgK8YYuQSPa99BKzZQ/eLEAuYJV/LTOX
	 +rXfiB4WBE5L4wpddSMhUdJIdl2Wj7bFnHPcwlQXlcR5jADjJZWrMunrnKw3ydhR7PAGq
	 oQeGahV8iugO/8vqO4VwC2Xm/LAWixdB428S+Xru2LgJmYxr3KYLD5xVtR3POqnc0vStI
	 OpCLDyp253AueNaBmj4WCHhgHcFgfSfBzgc8axrZg/NufOhqGSSCDd5h0zNR6TPkilA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795085;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7KGeFjs5PX/tkxJAUFM5Z/NmhcKaV2QlvKHXrIhvBs0=;
	b=O04/7dAg8ehY6pI+doJuVyH1u/cYu9bCAyJ/bk9v4iJ18CWCa/2vcmFxQG/5tCodL38V
	 6tEigWT9clLieFdnT/D58mnZd1/IIF5SJdjfW4lkE1d3fU9vvnM0VXuaBnNL1WywKN1w4
	 yhVwZZIE3VOH9Rta3DH1n+4q9fKwcXGtbxz/5v2PDsFcRP1pSp6NETAm4V9tUZBbjazoZ
	 rEhDLlBAzCcGPM/svWaIx6DD+Aib8JyLwJUSSeIoQPvzQVWE7VAuDeULMGeo5VQhPnU6n
	 MLFUVsBc99VcXeQNP9tWh7QxmyCfPr9LG06mELJ/sMwX47ZWXHHbmergjay4oimlZ8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=My2MzzJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCE3606A6B6;
	Fri, 27 Nov 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=My2MzzJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2051F00919;
	Fri, 27 Nov 2026 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795085;
	bh=7KGeFjs5PX/tkxJAUFM5Z/NmhcKaV2QlvKHXrIhvBs0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=My2MzzJ33v5yEC0fEtDE0zVv0XGghwkpGU/rRK4ZRlDT7inZZwMYWsfmO62NrCT7g
	 7bTuTowcyj8sboqPkd9pH1SjyNQjR7aGvsxFqBIqYKJgxBNhsBcf750TYUMHquPSTR
	 rqyui/iftzcgMJ2APe6oaoVKGx2tT3lrk42CMS0IrLuFDUrPal5tjg9LR7GiVFJxoi
	 fxKVCo1OPrjfmIiHKOHeTGpygx/GClaPxM5pL+GkbzHV80P6QwWnCBSK3lS3hMVkfM
	 ejEPcKf0+B+z7nO/CBTV6Bzh0MczPGwy/CvAgWCh8KDua5/2stFtnpr8mbFGM+Shdd
	 rd2uq548m5R4g==
Subject: Re: [PATCH v2 10/11] net/xsc: add the transmit path
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:58:04 +0000
Message-ID: <179579508443.3135.6949667103028918025@kernel.org>
In-Reply-To: <20261126145740.70868-11-tianx@yunsilicon.com>
References: <20261126145740.70868-11-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 5 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net/xsc: lockless TX queue stop/wake race in xsc_eth_xmit()
- [Medium] The new transmit path in xsc_eth_xmit()
  (drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c) drops frames…
- [Medium] The RX and TX paths fill the same hardware descriptor, struct
  xsc_wqe_data_seg, with a raw DMA address in ->va, but they set ->mkey…
- [Medium] The SQ and its completion queue are sized from unrelated
  capabilities, while the new TX path asks for one CQE per WQE and…
- [Medium] net/xsc: unconditional CQ doorbell MMIO write in
  xsc_poll_tx_cq()
- [Medium] net/xsc: xsc_poll_tx_cq() frees completed TX skbs with
  dev_kfree_skb_any()
- [Low] xsc_eth_xmit() starts with `if (!adapter->opened) return
  NETDEV_TX_BUSY;`.

--

net/xsc: add the transmit path

This adds an ndo_start_xmit implementation to the xsc ethernet driver. It
posts linear skbs to the send queue and rings the doorbell. A TX completion
handler unmaps and frees the skbs once they have been sent.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
> new file mode 100644
> index 0000000000000..580af1f231056
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
> @@ -0,0 +1,87 @@

[ ... ]

> +netdev_tx_t xsc_eth_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{

[ ... ]

> +	if (!adapter->opened)
> +		return NETDEV_TX_BUSY;

[Severity: Low]
Is this check needed? adapter->opened is a plain bool. xsc_eth_open() and
xsc_eth_close() write it without WRITE_ONCE(), and this code reads it
without a lock or READ_ONCE(). KCSAN would likely report the pair as a data
race.

On close, the core has already quiesced TX before ndo_stop runs.

On open, the queue is woken and the carrier is turned on before the flag is
set:

xsc_eth_activate_channel()
    netif_tx_start_queue(psq->txq);
...
xsc_eth_open()
    netif_carrier_on(adapter->netdev);
    ...
    adapter->opened = true;

In that window, could a PACKET_QDISC_BYPASS sender going through
__dev_direct_xmit() reach xsc_eth_xmit()? It would get NETDEV_TX_BUSY on an
awake queue, and its skb would be dropped.

The driver API also discourages returning NETDEV_TX_BUSY without stopping
the queue. Could this check be removed so that queue start/stop ordering
handles it, or could the accesses at least be annotated?

> +
> +	if (unlikely(skb_is_nonlinear(skb) || skb->len == 0 ||
> +		     skb->len > sq->hw_mtu))
> +		goto err_drop;
> +
> +	pi = xsc_wq_cyc_ctr2ix(&sq->wq, sq->pc);
> +	wqe = xsc_wq_cyc_get_wqe(&sq->wq, pi);
> +	memset(wqe, 0, xdev->caps.send_ds_num * XSC_SEND_WQE_DS);

[ ... ]

> +	cseg->data3 = cpu_to_le32(XSC_WQE_CTRL_SEG_DATA3_CE);
> +	wqe->data[0].data0 =
> +		cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK,
> +				       skb->len));
> +	wqe->data[0].va = cpu_to_le64(dma_addr);

[Severity: Medium]
Should data[0].mkey be set here too? The memset() leaves it at 0.

The RX path fills the same struct xsc_wqe_data_seg with a raw DMA address
and marks it with XSC_INVALID_LKEY:

drivers/net/ethernet/yunsilicon/xsc/net/main.c:xsc_eth_alloc_rq() {
    ...
		wqe->data[0].mkey = cpu_to_le32(XSC_INVALID_LKEY);
    ...
}

Suppose the device treats any mkey other than XSC_INVALID_LKEY (0x100) as a
real memory key. Would every TX descriptor then be checked against MR 0 and
complete with an error, or put the wrong data on the wire?

The tree doesn't show whether the hardware reads mkey on raw ethernet send
WQEs. Still, the two writers of this descriptor disagree. Could the TX path
set mkey to cpu_to_le32(XSC_INVALID_LKEY) the same way RX does?

> +
> +	sq->pc++;
> +	if (unlikely(!xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
> +					   sq->stop_room)))
> +		netif_tx_stop_queue(sq->txq);

[Severity: Medium]
Can the SQ completion queue overflow here? Every WQE sets
XSC_WQE_CTRL_SEG_DATA3_CE, so every posted WQE produces a CQE. The queue
is only stopped when the SQ ring itself is full.

xsc_eth_build_queue_param() sizes the SQ and its CQ from different
capabilities:

	adapter->nic_param.sq_size = min_t(u32,
					   BIT(xdev->caps.log_max_qp_depth),
					   XSC_SQCQ_ELE_NUM);
    ...
	} else if (type == XSC_QUEUE_TYPE_SQCQ) {
		attr->ele_num = min_t(int, XSC_SQCQ_ELE_NUM,
				      xdev->caps.max_cqes);

caps.max_cqes is 1 << log_max_cq_sz as reported by firmware. If
log_max_cq_sz is below 10 while log_max_qp_depth is 10 or more, up to 1024
WQEs, and so up to 1024 CQEs, can be outstanding against a smaller CQ
before NAPI reaps them.

If that happens, the CQ error event would only be logged by
xsc_eth_cq_error_event(), and TX completions would stall.

Neither xsc_eth_xmit() nor xsc_wqc_has_room_for() takes the CQ capacity
into account. Should sq_size be clamped to the SQ CQ size?

> +
> +	if (!netdev_xmit_more() || netif_xmit_stopped(sq->txq))
> +		xsc_update_tx_db(xdev, sq->sqn, sq->pc << ds_num_log);
> +
> +	return NETDEV_TX_OK;
> +
> +err_drop:
> +	dev_kfree_skb_any(skb);

[Severity: Medium]
Are these drops counted anywhere? Four cases end up here: non-linear skbs,
zero-length skbs, skbs longer than sq->hw_mtu, and dma_map_single()
failures. Nothing calls dev_core_stats_tx_dropped_inc() or updates a driver
counter.

Successful sends aren't counted either. No tx_packets or tx_bytes are kept,
and xsc_netdev_ops has only ndo_open, ndo_stop and ndo_start_xmit, with no
ndo_get_stats64. This seems to still be the case after the later commit
"net/xsc: add the receive path".

Won't ip -s link then show no TX activity and no TX drops for this device,
even when DMA mapping fails or frames are rejected?

> +	if (!netdev_xmit_more() || netif_xmit_stopped(sq->txq))
> +		xsc_update_tx_db(xdev, sq->sqn, sq->pc << ds_num_log);
> +	return NETDEV_TX_OK;
> +}

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#include "xsc_eth.h"
> +#include "xsc_eth_txrx.h"
> +
> +struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq)
> +{
> +	struct xsc_cqe *cqe = xsc_frag_buf_get_wqe(&wq->fbc,
> +						   xsc_cqwq_get_ci(wq));
> +
> +	if (!!(le32_to_cpu(cqe->data1) & XSC_CQE_DATA1_OWNER) !=
> +	    (xsc_cqwq_get_wrap_cnt(wq) & 1))
> +		return NULL;
> +
> +	return cqe;
> +}
> +
> +int xsc_poll_tx_cq(struct xsc_cq *cq, int budget)
> +{
> +	struct xsc_cqe *cqe;
> +	struct device *dev;
> +	struct xsc_sq *sq;
> +	u16 sqcc;
> +	int i = 0;
> +
> +	sq = container_of(cq, struct xsc_sq, cq);
> +	if (!test_bit(XSC_ETH_SQ_STATE_ENABLED, &sq->state))
> +		return 0;
> +
> +	dev = sq->channel->adapter->dev;
> +	sqcc = sq->cc;
> +
> +	while (i < budget) {
> +		struct xsc_tx_wqe_info *wi;
> +		struct sk_buff *skb;
> +
> +		cqe = xsc_cqwq_get_cqe(&cq->wq);
> +		if (!cqe)
> +			break;
> +		/* ensure cqe content is read after cqe ownership bit */
> +		dma_rmb();
> +
> +		xsc_cqwq_pop(&cq->wq);
> +		wi = &sq->wqe_info[xsc_wq_cyc_ctr2ix(&sq->wq, sqcc)];
> +
> +		skb = wi->skb;
> +		wi->skb = NULL;
> +		if (skb) {
> +			dma_unmap_single(dev, wi->dma_addr, skb->len,
> +					 DMA_TO_DEVICE);
> +			dev_kfree_skb_any(skb);
> +		}
> +
> +		sqcc++;
> +		i++;
> +	}
> +
> +	xsc_update_cq_ci(cq->xdev, cq->xcq.cqn, cq->wq.cc);
> +
> +	sq->cc = sqcc;
> +
> +	if (netif_tx_queue_stopped(sq->txq) &&
> +	    xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room))
> +		netif_tx_wake_queue(sq->txq);
> +
> +	return i == budget;
> +}

[Severity: Medium]
Is dev_kfree_skb_any() the right call for a completed TX skb? It goes
through dev_kfree_skb_any_reason() with SKB_DROP_REASON_NOT_SPECIFIED.
Every frame that was transmitted successfully would then be reported
as a drop by the skb:kfree_skb tracepoint and by drop_monitor.

This runs from the channel NAPI poll, so napi_consume_skb() would
account the skb as consumed. It would also let the skb use the NAPI
bulk free path. That needs the NAPI budget to reach
xsc_poll_tx_cq(), with a budget of 0 passed through when called from
netpoll. Would napi_consume_skb(skb, budget) work here, or at least
dev_consume_skb_any()?

[Severity: High]
What orders the queue stop in xsc_eth_xmit() against the wake here?
xsc_poll_tx_cq() runs from NAPI without the TX queue lock. Neither
side has the barriers that netif_txq_maybe_stop() and
netif_txq_completed_wake() provide.

In xsc_eth_xmit(), netif_tx_stop_queue() is called based on a plain
read of sq->cc. There is no smp_mb__after_atomic() and no re-check
of xsc_wqc_has_room_for() afterwards. Here, sq->cc = sqcc is followed
directly by netif_tx_queue_stopped() with no smp_mb() in between.
Couldn't this interleave as:

CPU0 (xsc_eth_xmit)            CPU1 (xsc_poll_tx_cq)
reads old sq->cc, ring full
                               sq->cc = sqcc
                               netif_tx_queue_stopped() == false
netif_tx_stop_queue()

That would leave the queue stopped with free descriptors and no
further completions to wake it.

The other direction looks worse. Suppose this function observes
__QUEUE_STATE_DRV_XOFF but loads a stale sq->pc from before the
final post. It can then call netif_tx_wake_queue() on a full ring,
even on a poll that reaped no CQEs. Nothing orders the state bit
test before the sq->pc load.

xsc_eth_xmit() never checks for room before deriving pi from sq->pc.
The next frame would then overwrite the WQE and sq->wqe_info[pi] of a
descriptor the device still owns, leaking that skb and its DMA
mapping. Once sq->pc is more than a ring size ahead of sq->cc,
xsc_wqc_has_room_for() wraps and reports room again. The queue would
stay awake and keep overwriting in-flight entries.

Would it make sense to use netif_txq_maybe_stop() and
netif_txq_completed_wake() from include/net/netdev_queues.h? That
would go with READ_ONCE()/WRITE_ONCE() on sq->cc and sq->pc. Could
xsc_eth_xmit() also stop the queue and return NETDEV_TX_BUSY if it is
ever entered without room?

[Severity: Medium]
Does this need to ring the CQ consumer doorbell when nothing was
reaped? If xsc_cqwq_get_cqe() returns NULL on the first iteration,
i is 0 and cq->wq.cc has not moved. xsc_update_cq_ci() still issues
a wmb() and an uncached writel() to DB_CQ_CID_DIRECT_MEM_ADDR.

The channel NAPI poll will call this on every pass, including passes
that only have RX work. With RX-heavy traffic or idle TX, most of
these MMIO writes would be redundant. The sq->cc = sqcc store is also
unconditional and dirties the cacheline that xsc_eth_xmit() reads on
the transmitting CPU.

Could the doorbell and the sq->cc update be skipped when i == 0?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
