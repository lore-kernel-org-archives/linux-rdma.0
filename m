Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791496;
	b=ppLonITcMpbMMH18mk5cOGeLugDONenFgpq7K4yw5VTBtztaJnGt/1yY/fPRh3P1vixB
	 WiKmFpV2p0rE5uZFKk8v2Ps4VdRUEffu7Q1087deWVUPdidLTLHraxuJat9QfhHph3rNZ
	 zkZc/w89t2M9/QzPQB4EaCjj5kOjhDnRm5lCMI6BIPu8xErw57ZMgx6SaEzAHZ89ES7oy
	 JZFS+KKKuUG7Z/MB1lObQmdzDLm8o7oGsS9TnCXeAJzdijND/aOBB7XMY3tVLGqFTpWO9
	 dwNMZ91ZsySQmKKnIBnPEFHAQ2buP9ez8md/3OG4ceNhE2azvYBNcyF7NuoNlMZ7ByA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791496;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Qg1yzUQi17BOTC9YagrYryW12ztINsd2+7V8HQBlo+E=;
	b=vpYJgj6D2pdglTV2ydDouV68b0iMiiVM9yURE2nczn54T9vbhxnNtzOV4ErhcvyPwS0V
	 yQ14jCV7fDbxpyr1BI6mUE/+Bm/TT7rlxQNuRHpjEZlKhjCC+IqbjsrRbTWROzhW2pD1/
	 Rjlf0fUQVAo1ki1wg74WsveSgsJ37sKL2tfizbZ63KncJaGOaPBa0ZhDvZf0rnvMSk1QC
	 sMIS2CX9rCFxgRTeDsC21N+X7KdLaGmZX0H3u8HIdIOxqvBns3h/LFprgiF2X8MiyxgQ+
	 63WcqKwT9UBYkehdA53N4wSHPxoVCezmR/H2e1FkXuquWydvmT1Vc4jxXHLm8S/Epbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XN4d04Wv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578C3606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XN4d04Wv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355ED1F00893;
	Fri, 27 Nov 2026 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791495;
	bh=Qg1yzUQi17BOTC9YagrYryW12ztINsd2+7V8HQBlo+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XN4d04WvzsJkvzc/6xagHpt0xG4mA0iBKuXym4Lo1cNo/GmXNOAAMSfMn6sFr6oCW
	 52CzsPCNOVsGB74u098Ey+vaOmUh9h8oGNum8+yhiujhL7+/l9LSexcB1YWFP1E7U/
	 N1sDHKUwaK62WfEIup8dGmGEWJjbxw+t0SSIYfuf8hNEYekRX2uuxmnFOkbl6hyTus
	 I2S4SxziH3JrrAMDuYXpYnhFlpbksMaQr1fB0vEiNWd6TmYpxEmoEtu0pTONXl3vvN
	 n3En8tg93Wo8Ed4WWtepyYGTb0vyAqswe4VknAHqIvATAnhbEbqLYFV+MOyMuqFzmT
	 ZWvamUQ/aux7g==
Message-ID: <sashiko-outbox-237644@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/11] net/xsc: add the receive path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145742.70868-12-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145742.70868-12-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [High] net/xsc: missing RX doorbell on partial alloc in
  xsc_eth_post_rx_wqes()
- [High] net/xsc: missing RQ state check in xsc_eth_post_rx_wqes() and
  early NAPI enable
- [Medium] net/xsc: CQs armed before NAPI init in xsc_eth_open_cq() and
  open_channel()
- [Medium] net/xsc: netif_napi_del() called before closing CQs in
  xsc_eth_close_channel()
- [Medium] net/xsc: missing pagepool_params.napi assignment in
  xsc_eth_alloc_rq()
- [Medium] net/xsc: wrong prefetch offset and DMA sync length in
  xsc_skb_from_cqe()
- [Medium] net/xsc: unconditional TX CQ doorbell MMIO write in
  xsc_poll_tx_cq()
--

commit 5c867b6dd2012f64299cb03411c3483a056f2b36
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the receive path

This commit adds the receive path for the xsc ethernet driver, building
linear skbs from page_pool buffers and polling both TX and RX completion
queues from a single NAPI instance.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/net/main.c
> index 8eda3c8b12f25..e7b0871c1ccb7 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -106,6 +106,13 @@ static void xsc_eth_cq_error_event(struct xsc_core_c=
q *xcq,
>  		   "Eth catch CQ ERROR: %x, cqn: %d\n", event, xcq->cqn);
>  }
> =20
> +static void xsc_eth_comp(struct xsc_core_cq *xcq)
> +{
> +	struct xsc_cq *cq =3D container_of(xcq, struct xsc_cq, xcq);
> +
> +	napi_schedule(cq->napi);
> +}
> +
>  static int xsc_eth_alloc_cq(struct xsc_channel *c, struct xsc_cq *pcq,
>  			    struct xsc_cq_param *pcq_param)
>  {
> @@ -125,6 +132,7 @@ static int xsc_eth_alloc_cq(struct xsc_channel *c, st=
ruct xsc_cq *pcq,
>  	if (ret)
>  		return ret;
> =20
> +	core_cq->comp =3D xsc_eth_comp;
>  	core_cq->event =3D xsc_eth_cq_error_event;
>  	core_cq->vector =3D 0;
> =20
> @@ -204,6 +212,7 @@ static int xsc_eth_open_cq(struct xsc_channel *c,
> =20
>  	xsc_arm_cq(pcq->xdev, pcq->xcq.cqn, pcq->wq.cc, 0);
> =20
> +	pcq->napi =3D &c->napi;
>  	pcq->channel =3D c;
> =20
>  	return 0;
> @@ -448,6 +457,8 @@ static int xsc_eth_open_channel(struct xsc_adapter *a=
dapter,
>  	if (ret)
>  		goto err_close_sq_cq;
> =20
> +	netif_napi_add(adapter->netdev, &c->napi, xsc_eth_napi_poll);
> +
>  	netdev_dbg(adapter->netdev, "open channel ok\n");
>  	return 0;

[Severity: Medium]
Can an EQ completion interrupt reach xsc_eth_comp() before pcq->napi and
c->napi are initialized?

xsc_eth_open_cq() registers pcq->xcq in xdev->cq_table.tree via
xsc_eth_set_cq() and arms it with xsc_arm_cq() before assigning pcq->napi,
and xsc_eth_open_channel() opens both CQs before calling netif_napi_add():

CPU0                              <hardirq>
xsc_eth_open_channel()
  xsc_eth_open_cq(&c->qp.rq.cq)
    xsc_eth_set_cq()
    xsc_arm_cq()
                                  xsc_eq_int()
                                    xsc_cq_completion()
                                      xsc_eth_comp()
                                        napi_schedule(cq->napi)
                                          <-- NULL or uninitialized napi
    pcq->napi =3D &c->napi
  ...
  netif_napi_add(&c->napi)

If an EQ event arrives in that window, napi_schedule() either dereferences
NULL or schedules a zeroed napi_struct whose NAPI_STATE_SCHED bit is clear
and poll callback is NULL.  Calling netif_napi_add() before opening the
CQs and setting pcq->napi before xsc_eth_set_cq() would close this window.

[ ... ]

> @@ -625,11 +640,17 @@ static void xsc_eth_close_qp_rq(struct xsc_channel =
*c, struct xsc_rq *prq)
>  		return;
>  	}
> =20
> +	/* return the pages still posted to hardware before the pool dies */
> +	for (i =3D 0; i < wq_sz; i++)
> +		xsc_eth_dealloc_rx_wqe(prq, i);
> +
>  	xsc_eth_free_qp_rq(prq);
>  }
> =20
>  static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
>  {
> +	netif_napi_del(&c->napi);
> +
>  	if (free_rq)
>  		xsc_eth_close_qp_rq(c, &c->qp.rq);
>  	xsc_eth_close_cq(c, &c->qp.rq.cq);

[Severity: Medium]
Should netif_napi_del(&c->napi) run after both CQs are closed in
xsc_eth_close_channel()?

While xsc_eth_close_qp_rq(), xsc_eth_close_qp_sq() and xsc_eth_close_cq()
are still running, the CQs remain in xdev->cq_table.tree and an arriving
EQ interrupt can invoke xsc_eth_comp() -> napi_schedule(&c->napi) on the
already deleted napi_struct.

> @@ -644,6 +665,7 @@ static int xsc_eth_open_channels(struct xsc_adapter *=
adapter)
>  {
>  	struct xsc_channel_param *chl_param;
>  	bool free_rq =3D false;
> +	bool napi_enabled =3D false;
>  	int ret =3D 0;
> =20
>  	chl_param =3D kvzalloc_obj(*chl_param, GFP_KERNEL);
> @@ -662,6 +684,9 @@ static int xsc_eth_open_channels(struct xsc_adapter *=
adapter)
>  		goto err_close_channel;
>  	free_rq =3D true;
> =20
> +	napi_enable(&adapter->channel.napi);
> +	napi_enabled =3D true;
> +
>  	ret =3D xsc_eth_modify_qps_channel(adapter, &adapter->channel);
>  	if (ret)
>  		goto err_close_channel;
> @@ -670,6 +695,8 @@ static int xsc_eth_open_channels(struct xsc_adapter *=
adapter)
>  	return 0;
> =20
>  err_close_channel:
> +	if (napi_enabled)
> +		napi_disable(&adapter->channel.napi);
>  	xsc_eth_close_channel(&adapter->channel, free_rq);
>  err_free_param:
>  	kvfree(chl_param);
> @@ -702,6 +729,9 @@ static void xsc_eth_deactivate_channel(struct xsc_cha=
nnel *c)
>  	clear_bit(XSC_ETH_SQ_STATE_ENABLED, &c->qp.sq.state);
> =20
>  	synchronize_net();
> +
> +	/* last doorbell out */
> +	napi_disable(&c->napi);
>  }

[Severity: High]
Can xsc_eth_napi_poll() race with xsc_eth_modify_qps_channel() or run
while XSC_ETH_RQ_STATE_ENABLED is clear?

xsc_eth_open_channels() calls napi_enable() while both CQs are already
armed, before xsc_eth_modify_qps_channel() posts the initial RX WQEs and
before xsc_eth_activate_channel() sets XSC_ETH_RQ_STATE_ENABLED and
XSC_ETH_SQ_STATE_ENABLED.  Because xsc_eth_post_rx_wqes() does not check
XSC_ETH_RQ_STATE_ENABLED, an EQ interrupt during open can run
xsc_eth_post_rx_wqes() in NAPI concurrently with process context:

CPU0 (process)                    CPU1 (<softirq>)
xsc_eth_open_channels()
  napi_enable(&c->napi)
  xsc_eth_modify_qps_channel()
    xsc_eth_post_rx_wqes(rq)
      xsc_alloc_rx_wqes()
                                  xsc_eth_napi_poll()
                                    xsc_eth_post_rx_wqes(rq)
                                      xsc_alloc_rx_wqes()
                                        <-- concurrent page_pool alloc
                                            and rq->wqe.wq corruption

This violates the single-consumer BH invariant of page_pool_dev_alloc_pages=
()
and corrupts rq->wqe.wq and rq->wqe.di[].

In addition, when xsc_eth_napi_poll() runs while the ENABLED bits are
clear (either before xsc_eth_activate_channel(), or in
xsc_eth_deactivate_channel() between clear_bit() and napi_disable()):
- xsc_eth_post_rx_wqes() still allocates pages and rings the RX doorbell,
  and if xsc_alloc_rx_wqes() fails with -ENOMEM it returns true (busy),
  preventing napi_complete_done() so napi_disable() hangs forever.
- xsc_poll_tx_cq() and xsc_poll_rx_cq() return 0 without draining pending
  CQEs, yet xsc_eth_napi_poll() unconditionally rearms both CQs at the
  unconsumed cq->wq.cc index, causing an immediate re-interrupt loop.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c b/drive=
rs/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
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
> +	va =3D page_address(di->page);
> +	frag_size =3D XSC_SKB_FRAG_SZ(cqe_bcnt);
> +
> +	dma_sync_single_range_for_cpu(rq->cq.xdev->device, di->addr,
> +				      0, frag_size, DMA_FROM_DEVICE);
> +	net_prefetch(va + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));

[Severity: Medium]
Does net_prefetch() prefetch past the packet headers here?

xsc_alloc_rx_wqes() programs wqe->data[0].va with di->addr (offset 0 of
di->page), and napi_build_skb(va, frag_size) places struct skb_shared_info
at the end of the buffer, not at the start.  Prefetching
va + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) skips the first 320
bytes where the Ethernet, IP, and transport headers sit (and prefetches
past the end of frames <=3D 320 bytes), while dma_sync_single_range_for_cpu=
()
also syncs the trailing skb_shared_info region instead of cqe_bcnt bytes.

> +
> +	skb =3D napi_build_skb(va, frag_size);
> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	skb_put(skb, cqe_bcnt);
> +	skb_mark_for_recycle(skb);
> +
> +	return skb;
> +}

[Severity: Medium]
Does skb_mark_for_recycle() ever use the lockless NAPI page_pool cache
without pagepool_params.napi set?

In xsc_eth_alloc_rq(), pagepool_params.napi is left NULL:

drivers/net/ethernet/yunsilicon/xsc/net/main.c:xsc_eth_alloc_rq() {
    ...
	pagepool_params.dev =3D c->adapter->dev;
	pagepool_params.dma_dir =3D DMA_FROM_DEVICE;
	pagepool_params.max_len =3D PAGE_SIZE;
	prq->page_pool =3D page_pool_create(&pagepool_params);
    ...
}

Because pool->p.napi is NULL, napi_pp_put_page() -> page_pool_napi_local()
always returns false when freeing recycled skbs, bypassing
pool->alloc.cache and forcing every recycled page through the locked
ptr_ring slow path.

[ ... ]

> +bool xsc_eth_post_rx_wqes(struct xsc_rq *rq)
> +{
> +	struct xsc_wq_cyc *wq =3D &rq->wqe.wq;
> +	int alloc;
> +	u16 head;
> +
> +	if (xsc_wq_cyc_missing(wq) < rq->wqe.wqe_bulk)
> +		return false;
> +
> +	do {
> +		head =3D xsc_wq_cyc_get_head(wq);
> +		alloc =3D min_t(int, rq->wqe.wqe_bulk, xsc_wq_cyc_missing(wq));
> +
> +		if (xsc_alloc_rx_wqes(rq, head, alloc))
> +			return true;
> +
> +		xsc_wq_cyc_push_n(wq, alloc);
> +	} while (xsc_wq_cyc_missing(wq) >=3D rq->wqe.wqe_bulk);
> +
> +	dma_wmb();
> +
> +	/* ensure wqes are visible to device before updating doorbell record */
> +	xsc_rq_notify_hw(rq);
> +
> +	return false;
> +}

[Severity: High]
If xsc_alloc_rx_wqes() fails after earlier loop iterations already pushed
WQEs, doesn't returning true immediately skip dma_wmb() and
xsc_rq_notify_hw(rq)?

Those earlier batches are already accounted for in wq->wqe_ctr and
wq->cur_sz via xsc_wq_cyc_push_n(), so skipping the doorbell leaves
hardware unaware of the posted descriptors.  Furthermore,
xsc_eth_modify_qps_channel() ignores the return value of
xsc_eth_post_rx_wqes(&c->qp.rq) during initial fill; if any batch fails
during ndo_open, the RX doorbell is never rung at all and the RX queue
starts in RTS with 0 descriptors notified to hardware, stalling RX
permanently.

> +
> +int xsc_eth_napi_poll(struct napi_struct *napi, int budget)
> +{
> +	struct xsc_channel *c =3D container_of(napi, struct xsc_channel, napi);
> +	struct xsc_rq *rq =3D &c->qp.rq;
> +	bool busy;
> +	int work_done;
> +
> +	busy =3D xsc_poll_tx_cq(&c->qp.sq.cq, xsc_cqwq_get_size(&c->qp.sq.cq.wq=
));

[Severity: Medium]
Does xsc_poll_tx_cq() ring the TX CQ consumer-index doorbell on every NAPI
poll even when no TX completions were processed?

Unlike xsc_poll_rx_cq(), which guards xsc_cq_notify_hw() with
if (work_done), xsc_poll_tx_cq() calls xsc_update_cq_ci() unconditionally
when i =3D=3D 0, issuing an unnecessary wmb() and PCIe MMIO writel() on eve=
ry
RX-only NAPI poll:

drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c:xsc_poll_tx_cq() {
    ...
		if (skb) {
			dma_unmap_single(dev, wi->dma_addr, skb->len,
					 DMA_TO_DEVICE);
			dev_kfree_skb_any(skb);
		}

		sqcc++;
		i++;
	}

	xsc_update_cq_ci(cq->xdev, cq->xcq.cqn, cq->wq.cc);
    ...
}

Also, since xsc_poll_tx_cq() runs from NAPI poll context, using
napi_consume_skb(skb, budget) instead of dev_kfree_skb_any(skb) would
enable NAPI skb bulk freeing.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D11
