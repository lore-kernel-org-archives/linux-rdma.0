Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791494;
	b=vQ/ZM/AmCgj9EVYa/V15vDdXWGm7RQZMzlOuNnsd0f6OgjcRk+ZH+FJDdnJ68EHJ82Ml
	 Ugq0u++gJDhBJowl43fpkPrCGxNSXTPXEyV5i2uCpwAudgDpOXlQ7dnb0RN5Xded9RsQt
	 JMtS6p7IvpYaetNueUfWVm8KGPjVN/jLx8GFsN+cd+4JENF6j8NPL5seVEiMG7ko/80qb
	 h59KM7peMYX/KeSxGzx9WvwWRUCZhu5i3/kr5mD3hdT36KHvRd5R/x4k10dqmrdXnAwjd
	 /YNL8wJjsoGwq++W7h7yE5OXRSQAXX1I1K9dTrFycU0ph1HXSU42kUJPZVN8NmEVaqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791494;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mtCTdXqxG2+Td6nJooriykLm9tIXcIaZr4JUOW5b8VA=;
	b=WFYZI6+v1+ENup8WIDH9lJh3aGKCD6ndzxnL1eooU6xp/VHJZtnbiQ237G8g/XsAigQ5
	 GKiWzAghUAm9q5GVbGTfSn9V+RjrR7qR3LdBLQ4LlaVo+a9jF7OaUkRH7g+WGub3lfv+t
	 rsZigqsbqmNalM8VNl7okCZjUrFVM+bK5+iT31kb3KecDelUGmVpJRVDbWQzWvrkB0d6K
	 RNm3oSFxRu8NpM6siByW6jUsu/SqFDJXb3m+9iqZ4e7XUqsPqq98IyBQiTerj2FX7v4ay
	 GXhZ61RI/igkHR4X7widDrM/bSVDh007yK0TXDyTsUM/EH4ozwhbIqiUFW3H7KsWwWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="foc5Z+R/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D569D606A326
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=foc5Z+R/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C011F00893;
	Fri, 27 Nov 2026 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791494;
	bh=mtCTdXqxG2+Td6nJooriykLm9tIXcIaZr4JUOW5b8VA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=foc5Z+R/oUA7sAmMute7NjiuFaHS3a9rHKwNfeQuy6mdogHBtOIj5JS0dsSVlPX7T
	 CLWB649/JZtiTemSZmuLMLElFTSXVJ+PyxHR//GR+OpC1rjsBQaig4KlRCzTJ2h07R
	 mqZwtr3ruiwOgEhIBZFJ4DL7aOdkXCY8AwhM45dAY/0ho+kP1hHgryxoIqMXjrItkj
	 KxqEWde8spbsEMBIB3jHXkKriAuXufImm8auAluKO2Ic99GJd89SG0wl+ZnOSUNhn2
	 NxJqkQJtiuQet/4gvmWkq6641x0i12S2Tl8dGGFQEwnHaaVMw0TKaUDcWtYnLsXMvi
	 zgZNYL7MXLb4g==
Message-ID: <sashiko-outbox-237643@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/11] net/xsc: add the transmit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145740.70868-11-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145740.70868-11-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] net/xsc: lockless TX queue stop/wake race in xsc_eth_xmit()
- [Medium] net/xsc: xsc_eth_xmit() returns NETDEV_TX_BUSY without
  stopping TX queue
- [Medium] net/xsc: xsc_poll_tx_cq() frees completed TX skbs with
  dev_kfree_skb_any()
- [Medium] net/xsc: unconditional CQ doorbell MMIO write in
  xsc_poll_tx_cq()
--

commit a6c0dbbfbb297d8daa2d0367ab92f524118727e6
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the transmit path

This commit adds the transmit path for the xsc Ethernet driver, including
posting linear skbs to the send queue, ringing the TX doorbell, and
polling the TX completion queue.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c b/drive=
rs/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
> new file mode 100644
> index 0000000000000..580af1f231056
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#include "xsc_eth.h"
> +#include "xsc_eth_txrx.h"
> +
> +#define XSC_OPCODE_RAW			7
> +
> +netdev_tx_t xsc_eth_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	struct xsc_adapter *adapter =3D netdev_priv(netdev);
> +	struct xsc_core_device *xdev =3D adapter->xdev;
> +	struct xsc_send_wqe_ctrl_seg *cseg;
> +	struct xsc_tx_wqe_info *wi;
> +	struct xsc_sq *sq =3D &adapter->channel.qp.sq;
> +	struct xsc_tx_wqe *wqe;
> +	u32 ds_num_log =3D ilog2(xdev->caps.send_ds_num);
> +	dma_addr_t dma_addr;
> +	u16 pi;
> +
> +	if (!adapter->opened)
> +		return NETDEV_TX_BUSY;

[Severity: Medium]
Does returning NETDEV_TX_BUSY here without stopping sq->txq cause a
busy-requeue loop in sch_direct_xmit()?

In xsc_eth_open(), xsc_eth_sw_init() starts sq->txq and
netif_carrier_on() runs before adapter->opened is set to true, and in
xsc_eth_close(), adapter->opened is cleared before xsc_eth_sw_deinit()
disables the TX queue:

drivers/net/ethernet/yunsilicon/xsc/net/main.c:xsc_eth_close() {
	adapter->opened =3D false;

	netif_carrier_off(adapter->netdev);

	xsc_eth_sw_deinit(adapter);
    ...
}

While sq->txq is running and adapter->opened is false, returning
NETDEV_TX_BUSY causes sch_direct_xmit() to requeue skb and immediately
reschedule the qdisc via __netif_schedule().  Also, if earlier packets in
a batch were posted with netdev_xmit_more() true and adapter->opened
becomes false before the last packet of the batch, returning early here
skips xsc_update_tx_db() for the already-posted WQEs.

> +
> +	if (unlikely(skb_is_nonlinear(skb) || skb->len =3D=3D 0 ||
> +		     skb->len > sq->hw_mtu))
> +		goto err_drop;
> +
> +	pi =3D xsc_wq_cyc_ctr2ix(&sq->wq, sq->pc);
> +	wqe =3D xsc_wq_cyc_get_wqe(&sq->wq, pi);
> +	memset(wqe, 0, xdev->caps.send_ds_num * XSC_SEND_WQE_DS);
> +
> +	dma_addr =3D dma_map_single(sq->channel->adapter->dev, skb->data,
> +				  skb->len, DMA_TO_DEVICE);
> +	if (unlikely(dma_mapping_error(sq->channel->adapter->dev, dma_addr)))
> +		goto err_drop;
> +
> +	wi =3D &sq->wqe_info[pi];
> +	wi->skb =3D skb;
> +	wi->dma_addr =3D dma_addr;
> +
> +	cseg =3D &wqe->ctrl;
> +	cseg->data0 =3D cpu_to_le32(FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCOD=
E_MASK,
> +					     XSC_OPCODE_RAW) |
> +				  FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_DS_DATA_NUM_MASK,
> +					     1) |
> +				  FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK,
> +					     sq->pc << ds_num_log));
> +	cseg->msg_len =3D cpu_to_le32(skb->len);
> +	cseg->data3 =3D cpu_to_le32(XSC_WQE_CTRL_SEG_DATA3_CE);
> +	wqe->data[0].data0 =3D
> +		cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK,
> +				       skb->len));
> +	wqe->data[0].va =3D cpu_to_le64(dma_addr);
> +
> +	sq->pc++;
> +	if (unlikely(!xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
> +					   sq->stop_room)))
> +		netif_tx_stop_queue(sq->txq);

[Severity: High]
Can the lockless stop/wake protocol between xsc_eth_xmit() and
xsc_poll_tx_cq() race to either wake a full ring or leave sq->txq
permanently stopped?

xsc_eth_xmit() does not barrier and re-check xsc_wqc_has_room_for() after
netif_tx_stop_queue(), and xsc_poll_tx_cq() updates sq->cc and checks
netif_tx_queue_stopped(sq->txq) and sq->pc without memory barriers (even
when 0 CQEs were reaped):

CPU0 (xsc_eth_xmit)               CPU1 (xsc_poll_tx_cq)
-------------------               ---------------------
/* 1 slot left:
 * pc - cc =3D=3D sz - 1
 */
                                  /* 0 CQEs reaped; loads old
                                   * sq->pc before CPU0's store
                                   * is visible
                                   */
sq->pc++;
/* pc - cc =3D=3D sz (full) */
netif_tx_stop_queue(sq->txq);
                                  if (netif_tx_queue_stopped(sq->txq) &&
                                      xsc_wqc_has_room_for(..., old_pc, ...=
))
                                    netif_tx_wake_queue(sq->txq);
                                      <-- wakes full SQ

Because xsc_eth_xmit() does not check xsc_wqc_has_room_for() at entry,
the next xsc_eth_xmit() call indexes pi at sq->cc, overwriting the
in-flight WQE and sq->wqe_info[pi] (leaking wi->skb and wi->dma_addr) and
wrapping sq->pc past sq->cc + sz so the queue stays awake.

Conversely, when CPU1 reaps completions and writes sq->cc =3D sqcc while
CPU0 reads the old sq->cc and stops the queue, the lack of a store-load
barrier after sq->cc =3D sqcc on CPU1 and after netif_tx_stop_queue() on
CPU0 allows CPU1 to observe netif_tx_queue_stopped(sq->txq) =3D=3D false and
skip waking the queue, leaving sq->txq stopped with free descriptors.
Using netif_txq_maybe_stop() in xsc_eth_xmit() and only checking for wake
when i > 0 after smp_mb() in xsc_poll_tx_cq() would close both races.

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/dri=
vers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> new file mode 100644
> index 0000000000000..ee6554ed80040
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> @@ -0,0 +1,70 @@

[ ... ]

> +int xsc_poll_tx_cq(struct xsc_cq *cq, int budget)
> +{
> +	struct xsc_cqe *cqe;
> +	struct device *dev;
> +	struct xsc_sq *sq;
> +	u16 sqcc;
> +	int i =3D 0;
> +
> +	sq =3D container_of(cq, struct xsc_sq, cq);
> +	if (!test_bit(XSC_ETH_SQ_STATE_ENABLED, &sq->state))
> +		return 0;
> +
> +	dev =3D sq->channel->adapter->dev;
> +	sqcc =3D sq->cc;
> +
> +	while (i < budget) {
> +		struct xsc_tx_wqe_info *wi;
> +		struct sk_buff *skb;
> +
> +		cqe =3D xsc_cqwq_get_cqe(&cq->wq);
> +		if (!cqe)
> +			break;
> +		/* ensure cqe content is read after cqe ownership bit */
> +		dma_rmb();
> +
> +		xsc_cqwq_pop(&cq->wq);
> +		wi =3D &sq->wqe_info[xsc_wq_cyc_ctr2ix(&sq->wq, sqcc)];
> +
> +		skb =3D wi->skb;
> +		wi->skb =3D NULL;
> +		if (skb) {
> +			dma_unmap_single(dev, wi->dma_addr, skb->len,
> +					 DMA_TO_DEVICE);
> +			dev_kfree_skb_any(skb);
> +		}

[Severity: Medium]
Should xsc_poll_tx_cq() free completed TX packets with
napi_consume_skb(skb, budget) instead of dev_kfree_skb_any(skb)?

dev_kfree_skb_any() records SKB_DROP_REASON_NOT_SPECIFIED instead of
SKB_CONSUMED, which reports every transmitted packet as a drop in
skb:kfree_skb tracepoints and drop_monitor, and bypasses NAPI bulk skb
freeing.

> +
> +		sqcc++;
> +		i++;
> +	}
> +
> +	xsc_update_cq_ci(cq->xdev, cq->xcq.cqn, cq->wq.cc);
> +
> +	sq->cc =3D sqcc;

[Severity: Medium]
When no TX completions are reaped (i =3D=3D 0), does xsc_poll_tx_cq() still
issue an unconditional doorbell MMIO write?

xsc_update_cq_ci() executes a wmb() and a writel() to the PCIe BAR, and
sq->cc =3D sqcc dirties the sq->cc cacheline on every NAPI poll even when
the TX completion queue was empty.  Guarding the doorbell update, sq->cc
write, and wake check on i > 0 avoids the barrier and MMIO write on
idle-TX polls.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D10
