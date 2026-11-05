Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894975;
	b=5qZP/sTffch9vjZzyAYoU/AKoygyjujLsBeG32KearL5ZRoPZDNdc5nvhxnr+WiUO9oP
	 EgOVEqh1/8Fis7FbSQaIw235MuOKbKuh6QLlSXdTNuq9GgRHSSGCWGasigaDHmJBL81ht
	 SdaQay9oWIAXseFGlDMoQz1Ta5KUvC+qaoLTxiHMKDJ/sJJiLP3IVzss0V8Xa7P7ddMAk
	 ZhpXUCaeiON4Zh35JGjItVLKnruM9WPehSn8OwnzFijfiQjRaR6mFzjzwhsTBdXlYZS0j
	 0+HXQINhvQe4N4BZJqqhbrRkGHYT2JXRJSRobYEJhfTlPIo5+jFX5wayZohWSB/GRQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894975;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qSHBgUDsg6gXKgNyX1Nx6yW1rS1/nkl7g1JLJPekEFw=;
	b=Ww1a9erghNCA1SQm2Z//F2ccEVZYEqzwj4hoJN1KDS+ZPpSZpbin3gzTgV7awwGCsOo4
	 rrM4VQqbsiVxeSnKUsYmC3zQ43BtWK6A3N5kXSgxQpBqqictEgPSN1tffpoYkP19B9/rK
	 wFsMSu03Romwn17B7fjPHTvIP+q1bbEYDQUZqdYb0lheGtkTZ/UiMGx7yh8A1d9GzmwU7
	 N7c0ZeTJ7VF4mBf8TQE/YZ5m1Vh4ZRYio2gdBC7Ntsm+1dtI3oIfrnIJhJGMNh0JHfTwC
	 nciYFlqHlwo5uFsAZwaWu14NC2Ub89DR7Lrua9wzoRDBrerl5KzMDjFNOuGTsA8P66Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQ9ckz5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E115606BE93
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQ9ckz5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30E11F00919;
	Thu,  5 Nov 2026 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894975;
	bh=qSHBgUDsg6gXKgNyX1Nx6yW1rS1/nkl7g1JLJPekEFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EQ9ckz5pE6RslMcwBg9inxV1vCTionvW9MDQfNLJLX+3Ol31lrRAVGTuDRYNFpLea
	 YYQqH2d9u2gwcB8YqUH6WhuA6qR/IcTLijVGvxXoLYKKetnxeuNTAhr9hWMMTM/Vzs
	 91F37/hYC3wvbit/C/SNHgoSaK9ebWr8RhRR2ls0fGVAbTARrzXFZYQ4MkZGpFvLNl
	 0bTPoRpkxt25oHxd9DSsftTPt7gRM8Un/OcwYtGlWyGQmQlthsnVk0IFRtqnZHP2CX
	 ZGhBsw0Eg3kc0ZHo/yXh1gRxHqIsE10e//6WFewNy4rzyG2Hxd7r93phXttKGw3p5i
	 n27976dIhmoUQ==
Message-ID: <sashiko-outbox-199430@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 08/15] net/xsc: add ethernet TX path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155708.37053-9-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155708.37053-9-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] net/xsc: NETDEV_TX_BUSY on active queues in xsc_eth_xmit_start()
- [High] net/xsc: race waking stopped TX queues in xsc_eth_deactivate_priv_=
channels()
- [High] net/xsc: CQs armed before NAPI and queue state init in xsc_eth_ope=
n_channels()
- [Medium] net/xsc: missed error CQE checks in xsc_poll_tx_cq() poll loop
- [Medium] net/xsc: missing TX doorbell on err_drop path in xsc_eth_xmit_fr=
ame()
- [Medium] net/xsc: fix CQE error check, sqcc update, and budget in xsc_pol=
l_tx_cq()
- [Low] net/xsc: chls->num_chl zeroed before error log in xsc_eth_open_chan=
nels()
--

commit 251dc7b87bb643704bb618df57c60cfb11aec1a1
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add ethernet TX path

This commit implements the Ethernet transmit path for the xsc driver,
including per-channel CQ and raw-TSO SQ setup, NAPI completion polling,
WQE construction with DMA mapping and BQL tracking, and offload feature
advertisement.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/net/main.c
> index 21a50085fa879..a02f95145d018 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -95,22 +95,825 @@ static int xsc_eth_netdev_init(struct xsc_adapter *a=
dapter)

[ ... ]

> +static void xsc_eth_completion_event(struct xsc_core_cq *xcq)
> +{
> +	struct xsc_cq *cq =3D container_of(xcq, struct xsc_cq, xcq);
> +	struct xsc_core_device *xdev =3D cq->xdev;
> +	struct xsc_rq *rq =3D NULL;
> +
> +	if (unlikely(!cq->channel)) {
> +		netdev_err(xsc_dev_to_netdev(xdev), "cq%d->channel is null\n",
> +			   xcq->cqn);
> +		return;
> +	}
> +
> +	rq =3D &cq->channel->qp.rq;
> +
> +	if (!test_bit(XSC_ETH_RQ_STATE_ENABLED, &rq->state))
> +		netdev_err(xsc_dev_to_netdev(xdev),
> +			   "ch%d_cq%d, napi_flag=3D0x%lx\n",
> +			   cq->channel->chl_idx, xcq->cqn,
> +			   cq->napi->state);
> +
> +	napi_schedule(cq->napi);
> +	cq->event_ctr++;
> +}

[ ... ]

> +static int xsc_eth_open_cq(struct xsc_channel *c,
> +			   struct xsc_cq *pcq,
> +			   struct xsc_cq_param *pcq_param)
> +{
> +	int ret;
> +
> +	ret =3D xsc_eth_alloc_cq(c, pcq, pcq_param);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D xsc_eth_set_cq(c, pcq, pcq_param);
> +	if (ret)
> +		goto err_free_cq;
> +
> +	xsc_cq_notify_hw_rearm(pcq);
> +
> +	pcq->napi =3D &c->napi;
> +	pcq->channel =3D c;
> +
> +	return 0;
> +
> +err_free_cq:
> +	xsc_eth_free_cq(pcq);
> +	return ret;
> +}

[ ... ]

> +static int xsc_eth_open_channel(struct xsc_adapter *adapter,
> +				int idx,
> +				struct xsc_channel *c,
> +				struct xsc_channel_param *chl_param)
> +{
> +	struct xsc_core_device *xdev =3D adapter->xdev;
> +	struct net_device *netdev =3D adapter->netdev;
> +	const struct cpumask *aff;
> +	unsigned int irqn;
> +	u32 eqn;
> +	int ret;
> +
> +	c->adapter =3D adapter;
> +	c->netdev =3D adapter->netdev;
> +	c->chl_idx =3D idx;
> +
> +	ret =3D xsc_core_vector2eqn(xdev, c->chl_idx, &eqn, &irqn);
> +	if (ret)
> +		goto err_out;
> +	aff =3D irq_get_affinity_mask(irqn);
> +	c->aff_mask =3D aff;
> +	c->cpu =3D cpumask_first(aff);
> +
> +	ret =3D xsc_eth_open_cq(c, &c->qp.rq.cq, &chl_param->rqcq_param);
> +	if (ret)
> +		goto err_out;
> +
> +	ret =3D xsc_eth_open_cq(c, &c->qp.sq.cq, &chl_param->sqcq_param);
> +	if (ret)
> +		goto err_close_rq_cq;
> +
> +	ret =3D xsc_eth_open_qp_sq(c, &c->qp.sq, &chl_param->sq_param);
> +	if (ret)
> +		goto err_close_sq_cq;
> +
> +	netif_napi_add(netdev, &c->napi, xsc_eth_napi_poll);

[Severity: High]
Could this ordering between CQ creation, NAPI initialization, and queue
state enablement cause a NULL pointer dereference or unratelimited log
spam from hardirq context?

In xsc_eth_open_cq(), xsc_eth_set_cq() calls xsc_core_eth_create_cq(),
which inserts &pcq->xcq into xdev->dev_res->cq_table.tree while MSI-X EQs
are active, and then calls xsc_cq_notify_hw_rearm(pcq) before setting
pcq->napi and pcq->channel.

Furthermore, in xsc_eth_open_channel(), both CQs (rq.cq and sq.cq) are
opened and armed before netif_napi_add(netdev, &c->napi, xsc_eth_napi_poll)
initializes c->napi. Because c is zero-allocated with kcalloc_node(),
c->napi.state has NAPIF_STATE_SCHED cleared and c->napi.poll is NULL prior
to netif_napi_add(). If xsc_eq_int() dispatches XSC_EVENT_TYPE_COMP or
XSC_EVENT_TYPE_INTERNAL_ERROR for the CQ after pcq->channel is assigned
and before netif_napi_add() runs, xsc_eth_completion_event() will call
napi_schedule(cq->napi) on an uninitialized napi_struct.

In addition, xsc_eth_completion_event() checks
!test_bit(XSC_ETH_RQ_STATE_ENABLED, &rq->state) and logs an unratelimited
netdev_err() from hardirq context. In this commit XSC_ETH_RQ_STATE_ENABLED
is never set anywhere, so every TX completion interrupt triggers
netdev_err(). Even once RX sets XSC_ETH_RQ_STATE_ENABLED in
xsc_eth_activate_priv_channels(), xsc_eth_open_channels() transitions QPs
to RTS before xsc_eth_activate_priv_channels() sets the enabled state bits
(and xsc_eth_deactivate_channels() clears them before tearing down the QPs
and CQs), during which time xsc_poll_tx_cq() returns early when
XSC_ETH_SQ_STATE_ENABLED is clear while xsc_eth_napi_poll() re-arms the CQ
without draining it.

Should netif_napi_add() and pcq->napi / pcq->channel initialization happen
before registering and arming the CQs, and should the queue state bits be
set before arming CQs and transitioning QPs to RTS?

> +
> +	netdev_dbg(adapter->netdev, "open channel%d ok\n", idx);
> +	return 0;

[ ... ]

> +err_close_channel:
> +	for (--i; i >=3D 0; i--)
> +		xsc_eth_close_channel(&chls->c[i], false);
> +
> +	kvfree(chl_param);
> +err_free_ch:
> +	kfree(chls->c);
> +err_out:
> +	chls->num_chl =3D 0;
> +	netdev_err(adapter->netdev, "failed to open %d channels, err=3D%d\n",
> +		   chls->num_chl, ret);
> +	return ret;
> +}

[Severity: Low]
In xsc_eth_open_channels(), chls->num_chl is set to 0 right before the
netdev_err() call at err_out. Won't this always log "failed to open 0
channels" on failure instead of the number of channels that failed to
open?

[ ... ]

> +static void xsc_eth_deactivate_channels(struct xsc_eth_channels *chs)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < chs->num_chl; i++)
> +		xsc_eth_deactivate_channel(&chs->c[i]);
> +
> +	/* Sync with all NAPIs to wait until they stop using queues. */
> +	synchronize_net();
> +
> +	for (i =3D 0; i < chs->num_chl; i++)
> +		/* last doorbell out */
> +		napi_disable(&chs->c[i].napi);
> +}
> +
> +static void xsc_eth_activate_priv_channels(struct xsc_adapter *adapter)
> +{
> +	struct net_device *netdev =3D adapter->netdev;
> +
> +	netif_set_real_num_tx_queues(netdev, adapter->channels.num_chl);
> +	netif_set_real_num_rx_queues(netdev, adapter->channels.num_chl);
> +
> +	xsc_eth_build_tx2sq_maps(adapter);
> +	xsc_eth_activate_channels(&adapter->channels);
> +	netif_tx_start_all_queues(adapter->netdev);
> +}
> +
> +static void xsc_eth_deactivate_priv_channels(struct xsc_adapter *adapter)
> +{
> +	netif_tx_disable(adapter->netdev);
> +	xsc_eth_deactivate_channels(&adapter->channels);
> +}

[Severity: High]
Can a concurrent NAPI poll re-wake a TX queue during teardown in
xsc_eth_deactivate_priv_channels()?

xsc_eth_deactivate_priv_channels() calls netif_tx_disable(adapter->netdev)
before xsc_eth_deactivate_channels() clears XSC_ETH_SQ_STATE_ENABLED and
disables NAPI. If xsc_poll_tx_cq() is running concurrently on another CPU,
it can still see XSC_ETH_SQ_STATE_ENABLED set, observe
netif_tx_queue_stopped(sq->txq) is true (just set by netif_tx_disable()),
and call netif_tx_wake_queue(sq->txq):

drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c:xsc_poll_tx_cq() {
    ...
	if (netif_tx_queue_stopped(sq->txq) &&
	    xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room)) {
		netif_tx_wake_queue(sq->txq);
	}
}

Wouldn't that clear __QUEUE_STATE_DRV_XOFF and leave the TX queue awake
while xsc_eth_sw_deinit() proceeds to free TX WQEs and close the channels?
Should xsc_eth_deactivate_channels() run before netif_tx_disable()?

[ ... ]

> @@ -172,14 +1053,26 @@ static int xsc_set_port_admin_status(struct xsc_ad=
apter *adapter,
>  static int xsc_eth_open(struct net_device *netdev)
>  {
>  	struct xsc_adapter *adapter =3D netdev_priv(netdev);
> +	bool link_up;
>  	int ret;
> =20
>  	if (adapter->opened) {
>  		netdev_err(adapter->netdev, "ndo_open on an already opened device\n");
>  		return 0;
>  	}
> +	ret =3D xsc_eth_sw_init(adapter);
> +	if (ret)
> +		return ret;
> =20
> -	if (xsc_eth_get_link_status(adapter))	{
> +	ret =3D xsc_eth_enable_nic_hca(adapter);
> +	if (ret)
> +		goto err_sw_deinit;
> +
> +	ret =3D xsc_eth_get_link_status(adapter, &link_up);
> +	if (ret)
> +		netdev_warn(netdev, "failed to query link status, err=3D%d\n", ret);
> +
> +	if (!ret && link_up) {
>  		netdev_info(netdev, "Link up\n");
>  		netif_carrier_on(adapter->netdev);
>  	} else {
> @@ -196,6 +1089,10 @@ static int xsc_eth_open(struct net_device *netdev)
>  			   ret);
> =20
>  	return 0;
> +
> +err_sw_deinit:
> +	xsc_eth_sw_deinit(adapter);
> +	return ret;
>  }
> =20
>  static int xsc_eth_close(struct net_device *netdev)
> @@ -209,6 +1106,13 @@ static int xsc_eth_close(struct net_device *netdev)
> =20
>  	netif_carrier_off(adapter->netdev);
> =20
> +	xsc_eth_sw_deinit(adapter);

[Severity: High]
Can xsc_eth_xmit_start() return NETDEV_TX_BUSY on an active, unstopped TX
queue during xsc_eth_open() and xsc_eth_close()?

In xsc_eth_open(), xsc_eth_sw_init() calls xsc_eth_activate_priv_channels(),
which calls netif_set_real_num_tx_queues() and
netif_set_real_num_rx_queues() (without checking their return values) and
starts all TX queues via netif_tx_start_queue() and
netif_tx_start_all_queues() while adapter->opened is still false.
xsc_eth_open() then sleeps in xsc_eth_enable_nic_hca() and
xsc_eth_get_link_status() and calls netif_carrier_on() before setting
adapter->opened =3D true (and xsc_eth_link_event_handler() can also turn the
carrier on asynchronously).

Similarly, in xsc_eth_close(), adapter->opened =3D false is set before
netif_carrier_off() and before xsc_eth_sw_deinit() calls
netif_tx_disable().

During both windows, TX queues are active and unstopped while
adapter->opened is false. Any packet reaching xsc_eth_xmit_start() will
hit:

drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c:xsc_eth_xmit_start() {
	if (!adapter->opened)
		return NETDEV_TX_BUSY;
}

without stopping the TX queue, causing sch_direct_xmit() to requeue the skb
and reschedule NET_TX_SOFTIRQ in a tight retry loop (and leaving any
earlier skbs in a netdev_xmit_more() batch without a doorbell ring).

Should adapter->opened be set before starting the TX queues (or TX queues
started only after HCA enablement and adapter->opened =3D true), and in
xsc_eth_close() should the TX queues be disabled before clearing
adapter->opened?

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c b/drive=
rs/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
> new file mode 100644
> index 0000000000000..376b2cd0d8f29
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c

[ ... ]

> +static void xsc_txwqe_complete(struct xsc_sq *sq, struct sk_buff *skb,
> +			       u8 opcode, u16 ds_cnt,
> +			       u8 num_wqebbs, u32 num_bytes, u8 num_dma,
> +			       struct xsc_tx_wqe_info *wi)
> +{
> +	struct xsc_wq_cyc *wq =3D &sq->wq;
> +
> +	wi->num_bytes =3D num_bytes;
> +	wi->num_dma =3D num_dma;
> +	wi->num_wqebbs =3D num_wqebbs;
> +	wi->skb =3D skb;
> +
> +	netdev_tx_sent_queue(sq->txq, num_bytes);
> +
> +	sq->pc +=3D wi->num_wqebbs;
> +
> +	if (unlikely(!xsc_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room)))
> +		netif_tx_stop_queue(sq->txq);
> +
> +	if (!netdev_xmit_more() || netif_xmit_stopped(sq->txq))
> +		xsc_sq_notify_hw(wq, sq->pc, sq);
> +}
> +
> +static uint32_t xsc_eth_xmit_frame(struct sk_buff *skb,
> +				   struct xsc_sq *sq,
> +				   struct xsc_tx_wqe *wqe,
> +				   u16 pi)
> +{

[ ... ]

> +	xsc_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
> +			   num_dma, wi);
> +	stats->bytes     +=3D num_bytes;
> +	stats->packets   +=3D num_pkts;
> +
> +	return NETDEV_TX_OK;
> +
> +err_drop:
> +	stats->dropped++;
> +	dev_kfree_skb_any(skb);
> +
> +	return NETDEV_TX_OK;
> +}

[Severity: Medium]
What happens to previously queued WQEs in a netdev_xmit_more() batch if a
subsequent packet in that batch takes the err_drop path in
xsc_eth_xmit_frame()?

When earlier packets in a batch are queued with netdev_xmit_more() true and
the queue is not stopped, xsc_txwqe_complete() advances sq->pc and skips
xsc_sq_notify_hw(). If a later packet (such as the final packet in the
batch where netdev_xmit_more() is false) jumps to err_drop (for example on
skb->len > sq->hw_mtu, skb_linearize() failure, skb->len =3D=3D 0, or DMA
mapping failure in xsc_txwqe_build_dsegs()), err_drop frees the skb and
returns without ringing the doorbell for the earlier WQEs. Should err_drop
call xsc_sq_notify_hw() when !netdev_xmit_more() or when uncommitted WQEs
are pending?

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/dri=
vers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> new file mode 100644
> index 0000000000000..262421740e974
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c

[ ... ]

> +static bool xsc_poll_tx_cq(struct xsc_cq *cq, int napi_budget)
> +{
> +	struct xsc_adapter *adapter;
> +	struct xsc_cqe *cqe;
> +	struct device *dev;
> +	struct xsc_sq *sq;
> +	u32 dma_fifo_cc;
> +	u32 nbytes =3D 0;
> +	u16 npkts =3D 0;
> +	int i =3D 0;
> +	u16 sqcc;
> +
> +	sq =3D container_of(cq, struct xsc_sq, cq);
> +	if (!test_bit(XSC_ETH_SQ_STATE_ENABLED, &sq->state))
> +		return false;
> +
> +	adapter =3D sq->channel->adapter;
> +	dev =3D adapter->dev;
> +
> +	cqe =3D xsc_cqwq_get_cqe(&cq->wq);
> +	if (!cqe)
> +		goto out;
> +
> +	if (unlikely(get_cqe_opcode(cqe) & BIT(7)))
> +		xsc_dump_error_sqcqe(sq, cqe);
> +
> +	sqcc =3D sq->cc;
> +
> +	/* avoid dirtying sq cache line every cqe */
> +	dma_fifo_cc =3D sq->dma_fifo_cc;
> +	i =3D 0;
> +	do {
> +		struct xsc_tx_wqe_info *wi;
> +		struct sk_buff *skb;
> +		int j;
> +		u16 ci;
> +
> +		xsc_cqwq_pop(&cq->wq);
> +
> +		ci =3D xsc_wq_cyc_ctr2ix(&sq->wq, sqcc);
> +		wi =3D &sq->db.wqe_info[ci];
> +		skb =3D wi->skb;
> +
> +		if (unlikely(!skb))
> +			continue;
> +
> +		for (j =3D 0; j < wi->num_dma; j++) {
> +			struct xsc_sq_dma *dma =3D xsc_dma_get(sq, dma_fifo_cc++);
> +
> +			xsc_tx_dma_unmap(dev, dma);
> +		}
> +
> +		npkts++;
> +		nbytes +=3D wi->num_bytes;
> +		sqcc +=3D wi->num_wqebbs;
> +		napi_consume_skb(skb, 0);
> +
> +	} while ((++i < napi_budget) && (cqe =3D xsc_cqwq_get_cqe(&cq->wq)));

[Severity: Medium]
There are a few issues in the xsc_poll_tx_cq() loop:

1. get_cqe_opcode(cqe) & BIT(7) is only checked once before the do-while
loop rather than inside the loop before xsc_cqwq_pop(&cq->wq). Won't any
error CQEs fetched after the first CQE in a NAPI poll batch be silently
ignored instead of logged via xsc_dump_error_sqcqe()?

2. If unlikely(!skb) is taken after xsc_cqwq_pop(&cq->wq), the loop
executes continue without advancing sqcc (unlike xsc_free_tx_wqe(), which
increments sq->cc++), and wi->skb is never cleared when a WQE completes.
Could that desynchronize sqcc from the CQ if a nop WQE is encountered?

3. napi_consume_skb(skb, 0) is called with a hardcoded budget of 0, which
causes napi_consume_skb() to always take the !budget non-NAPI fallback
(dev_consume_skb_any()) instead of using the NAPI per-CPU skb cache. Should
the NAPI poll budget be passed through to napi_consume_skb() here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D8
