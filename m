Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894976;
	b=us9F/mXbK419xpT8pQIWSDTIsjyoZX+HCMqKiwzI//woccHwhmtiikR7Hy4jKVc+8z2C
	 OXY1Ic1Z571ygzb6XrJPMnyL2beV8N+xswPcqqUSeyBtJY1ZpFuQHdrhZqRMalE1I7mjr
	 ejFQG98Ic7anVh4KyarztJmpJzA+cmrM4km6LstjTW4ThBxcQ8x4wQdn73rI4mzegYXsZ
	 5XfRuxPqP0mhJ4FZGoPHzk7NNV0GfWUQyL3aZf7qxisWrhk4Q2fuXjGQFTGsNPLCWJoxF
	 t2Vq7bfcE28FV9ww9XNJEhxKQkWS8WGKvex9a66I3XzFRs42B7u68vCryuNWNSIpusA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894976;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jp9sRKMeWWBO1g4tWiuTWlgJ9ZByyGl8FMgspweS1c0=;
	b=Vc7rsTnuthKxEv45cxt2tA4AuMLqj2QOo4lGWPwNiyFJ2iIgJwMuxk2TUzlLRNwb5EVe
	 GYN7yZQ+pXvBVTeMlUarZ40d1TGkW8coysuuRS5+nAoDugqW5to46R0XRxVXGtAXxVxii
	 nh1hDbo0JB/PHFoX4vyaBUNaztrTcbLmIurFIiZnSIUZFKiWOSihnaXO/KfCnzFwDofzI
	 5F/1JpwB5T3SaOjyNaeDzzZEIyUZlafgLfJOkNaw/9XZUY1/+vBpxFdXdjlDBUVft48Nz
	 d/PRxOZZsBoOR8LutTBXdHNq6ILubsdSHytxtvNu4OJ6ahbuW3LHpSxG1LXz9ePpFCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EdcNWibJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E6D606BE98
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EdcNWibJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811751F000C1;
	Thu,  5 Nov 2026 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894975;
	bh=jp9sRKMeWWBO1g4tWiuTWlgJ9ZByyGl8FMgspweS1c0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EdcNWibJM9arKn+FYQkvf5mKuSMZeqE5xwrB47xaRlK0iMrURLSv0KfIJMeVhOlCU
	 vfmUjw9az+n9esbcbiO/QUMz9uVA7tjLxiJRN7BbTITDalkAtqNpTNITdl8nNSUYNE
	 7yZjEiB5KqeNBsR20LRtDBWVmKkGO7HtEwAKEIrrfcHRKiSBNJm/E+Xu3nM2DE89mj
	 obiKTTXfhG1TEWMTrTTy74QI04Ru+8ui1CJImq7+N0F4McH7tz14dn4aXM1vZo6VRr
	 L5GudEIqDLdQw9dYlTzRbbFORyyfg7bTfj3OykG5VbmKQ7VRuDkqU9V6/6FNTJeZFh
	 6cyVZ/yLoYNYQ==
Message-ID: <sashiko-outbox-199431@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 09/15] net/xsc: add ethernet RX path and statistics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155710.37053-10-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155710.37053-10-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] net/xsc: missing RQ state check in xsc_eth_post_rx_wqes() and NAPI=
 order bug
- [Medium] net/xsc: unchecked initial RQ refill and doorbell write on alloc=
 failure
- [Medium] net/xsc: xsc_skb_set_hash() classifies all IPv4/IPv6 packets as =
L4 hash
- [Medium] net/xsc: missing drop stats and dead clamp in xsc_eth_handle_rx_=
cqe()
- [Medium] net/xsc: host-endian u16 read in XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_=
TYPE()
- [Low] net/xsc: xsc_eth_open_channels() zeroes chls->num_chl before loggin=
g it
--

commit 1ef80bdcef5b1d9741776856d8624e7ce0755662
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add ethernet RX path and statistics

This commit implements the ethernet receive path using page pools, linear a=
nd
non-linear SKB construction, CQE checksum and RSS hash handling, and RSS RQ
creation. It also wires up ndo_get_stats64 and advertises RX checksum and RX
hash offloads.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/net/main.c
> index a02f95145d018..e56e0eec30515 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -686,6 +686,14 @@ static int xsc_eth_open_channel(struct xsc_adapter *=
adapter,
>  static int xsc_eth_modify_qps_channel(struct xsc_adapter *adapter,
>  				      struct xsc_channel *c)
>  {
> +	int ret;
> +
> +	c->qp.rq.post_wqes(&c->qp.rq);
> +	ret =3D xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.rq.rqn,
> +					    XSC_CMD_OP_RTR2RTS_QP);
> +	if (ret)
> +		return ret;
> +
>  	return xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.sq.sqn,
>  					     XSC_CMD_OP_RTR2RTS_QP);
>  }

[ ... ]

> @@ -745,6 +1075,14 @@ static int xsc_eth_open_channels(struct xsc_adapter=
 *adapter)
>  			goto err_close_channel;
>  	}
> =20
> +	ret =3D xsc_eth_open_rss_qp_rqs(adapter,
> +				      &chl_param->rq_param,
> +				      chls,
> +				      chls->num_chl);
> +	if (ret)
> +		goto err_close_channel;
> +	free_rq =3D true;
> +
>  	for (i =3D 0; i < chls->num_chl; i++)
>  		napi_enable(&chls->c[i].napi);
> =20
> @@ -763,7 +1101,7 @@ static int xsc_eth_open_channels(struct xsc_adapter =
*adapter)
> =20
>  err_close_channel:
>  	for (--i; i >=3D 0; i--)
> -		xsc_eth_close_channel(&chls->c[i], false);
> +		xsc_eth_close_channel(&chls->c[i], free_rq);
> =20
>  	kvfree(chl_param);
>  err_free_ch:

[Severity: Low]
When xsc_eth_open_channels() fails (for example if xsc_eth_open_rss_qp_rqs()
or xsc_eth_modify_qps() returns an error), it jumps through err_close_chann=
el
to err_out:

err_out:
	chls->num_chl =3D 0;
	netdev_err(adapter->netdev, "failed to open %d channels, err=3D%d\n",
		   chls->num_chl, ret);

Since chls->num_chl is cleared to 0 right before netdev_err(), won't this
always log "failed to open 0 channels" instead of the number of channels th=
at
failed to open?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c b/drive=
rs/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
> new file mode 100644
> index 0000000000000..00ac7eacc0e99
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
> @@ -0,0 +1,556 @@

[ ... ]

> +static void xsc_skb_set_hash(struct xsc_adapter *adapter,
> +			     struct xsc_cqe *cqe,
> +			     struct sk_buff *skb)
> +{
> +	struct xsc_rss_params *rss =3D &adapter->rss_param;
> +	bool l3_hash =3D false;
> +	bool l4_hash =3D false;
> +	u32 hash_field;
> +	int ht =3D 0;
> +
> +	if (adapter->netdev->features & NETIF_F_RXHASH) {
> +		if (skb->protocol =3D=3D htons(ETH_P_IP)) {
> +			hash_field =3D rss->rx_hash_fields[XSC_TT_IPV4_TCP];
> +			if (hash_field & XSC_HASH_FIELD_SEL_SRC_IP ||
> +			    hash_field & XSC_HASH_FIELD_SEL_DST_IP)
> +				l3_hash =3D true;
> +
> +			if (hash_field & XSC_HASH_FIELD_SEL_SPORT ||
> +			    hash_field & XSC_HASH_FIELD_SEL_DPORT)
> +				l4_hash =3D true;
> +		} else if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
> +			hash_field =3D rss->rx_hash_fields[XSC_TT_IPV6_TCP];
> +			if (hash_field & XSC_HASH_FIELD_SEL_SRC_IPV6 ||
> +			    hash_field & XSC_HASH_FIELD_SEL_DST_IPV6)
> +				l3_hash =3D true;
> +
> +			if (hash_field & XSC_HASH_FIELD_SEL_SPORT_V6 ||
> +			    hash_field & XSC_HASH_FIELD_SEL_DPORT_V6)
> +				l4_hash =3D true;
> +		}
> +
> +		if (l3_hash && l4_hash)
> +			ht =3D PKT_HASH_TYPE_L4;
> +		else if (l3_hash)
> +			ht =3D PKT_HASH_TYPE_L3;
> +		if (ht)
> +			skb_set_hash(skb, le32_to_cpu(cqe->vni), ht);
> +	}
> +}

[Severity: Medium]
In xsc_skb_set_hash(), any packet with skb->protocol equal to htons(ETH_P_I=
P)
looks up rss->rx_hash_fields[XSC_TT_IPV4_TCP], and any packet with
htons(ETH_P_IPV6) looks up rss->rx_hash_fields[XSC_TT_IPV6_TCP].

In xsc_build_rss_param(), those two entries are initialized to
XSC_HASH_IP_PORTS and XSC_HASH_IP6_PORTS, which always have both the L3 IP
address bits and L4 port bits set.

Because the actual L4 protocol and fragmentation status of the received pac=
ket
are not checked here, won't every IPv4 and IPv6 packet (including ICMP, oth=
er
non-TCP/UDP protocols, and fragmented IP packets) be unconditionally report=
ed
to the network stack with PKT_HASH_TYPE_L4?

> +
> +static void xsc_handle_csum(struct xsc_cqe *cqe, struct xsc_rq *rq,
> +			    struct sk_buff *skb, struct xsc_wqe_frag_info *wi)
> +{
> +	struct xsc_dma_info *dma_info;
> +	struct net_device *netdev;
> +	void *hw_pph;
> +	struct xsc_channel *c;
> +	int offset_from;
> +
> +	c =3D rq->cq.channel;
> +	netdev =3D c->adapter->netdev;
> +	dma_info =3D wi->di;
> +	offset_from =3D wi->offset;
> +	hw_pph =3D page_address(dma_info->page) + offset_from;
> +
> +	if (unlikely((netdev->features & NETIF_F_RXCSUM) =3D=3D 0))
> +		goto csum_none;
> +
> +	if (!(le32_to_cpu(cqe->data0) & XSC_CQE_DATA0_HAS_PPH))
> +		goto csum_none;
> +
> +	dma_sync_single_for_cpu(rq->cq.xdev->device,
> +				dma_info->addr + offset_from,
> +				XSC_PPH_HEAD_LEN, DMA_FROM_DEVICE);
> +
> +	if (unlikely(XSC_GET_EPP2SOC_PPH_ERROR_BITMAP(hw_pph) & PACKET_UNKNOWN))
> +		goto csum_none;
> +
> +	if (XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(hw_pph) &&
> +	    (!(FIELD_GET(XSC_CQE_DATA0_CSUM_ERR_MASK, le32_to_cpu(cqe->data0)) &
> +	       OUTER_AND_INNER))) {

[Severity: Medium]
In xsc_handle_csum(), XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(hw_pph) is used to
check tunnel encapsulation on the DMA-synced packet parse header. Looking at
drivers/net/ethernet/yunsilicon/xsc/net/xsc_pph.h:

#define XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(PPH_BASE_ADDR)	\
	((*(u16 *)((u8 *)(PPH_BASE_ADDR) +	\
	EPP2SOC_PPH_EXT_TUNNEL_TYPE_OFFSET) &	\
	EPP2SOC_PPH_EXT_TUNNEL_TYPE_BIT_MASK) >>	\
	EPP2SOC_PPH_EXT_TUNNEL_TYPE_BIT_OFFSET)

Since this dereferences a u16 from the DMA buffer in host byte order without
endianness conversion and masks with 0x0f00 >> 8, won't it read the wrong
byte of hw_pph on big-endian architectures and misclassify tunnel checksums?

[ ... ]

> +void xsc_eth_handle_rx_cqe(struct xsc_cqwq *cqwq,
> +			   struct xsc_rq *rq, struct xsc_cqe *cqe)
> +{
> +	struct xsc_wq_cyc *wq =3D &rq->wqe.wq;
> +	u8 cqe_opcode =3D get_cqe_opcode(cqe);
> +	struct xsc_wqe_frag_info *wi;
> +	struct sk_buff *skb;
> +	u32 cqe_bcnt;
> +	u16 ci;
> +
> +	ci =3D xsc_wq_cyc_ctr2ix(wq, cqwq->cc);
> +	wi =3D get_frag(rq, ci);
> +	if (unlikely(cqe_opcode & BIT(7))) {
> +		xsc_dump_error_rqcqe(rq, cqe);
> +		goto free_wqe;
> +	}
> +
> +	cqe_bcnt =3D le32_to_cpu(cqe->msg_len);
> +	if ((le32_to_cpu(cqe->data0) & XSC_CQE_DATA0_HAS_PPH) &&
> +	    cqe_bcnt <=3D XSC_PPH_HEAD_LEN)
> +		goto free_wqe;
> +
> +	if (unlikely(cqe_bcnt < ETH_HLEN + ((le32_to_cpu(cqe->data0) &
> +					    XSC_CQE_DATA0_HAS_PPH) ?
> +					    XSC_PPH_HEAD_LEN : 0))) {
> +		rq->stats->dropped++;
> +		goto free_wqe;
> +	}
> +
> +	if (unlikely(cqe_bcnt > rq->frags_sz))
> +		goto free_wqe;
> +
> +	cqe_bcnt =3D min_t(u32, cqe_bcnt, rq->frags_sz);

[Severity: Medium]
In xsc_eth_handle_rx_cqe(), when XSC_CQE_DATA0_HAS_PPH is set and cqe_bcnt =
is
less than or equal to XSC_PPH_HEAD_LEN, or when cqe_bcnt > rq->frags_sz, the
frame jumps to free_wqe without incrementing rq->stats->dropped (which
xsc_eth_fold_sw_stats64() folds into rx_length_errors).

In addition, the second check (cqe_bcnt < ETH_HLEN + XSC_PPH_HEAD_LEN) alre=
ady
covers cqe_bcnt <=3D XSC_PPH_HEAD_LEN when XSC_CQE_DATA0_HAS_PPH is set, an=
d the
min_t(u32, cqe_bcnt, rq->frags_sz) clamp right after the cqe_bcnt > rq->fra=
gs_sz
branch is unreachable.

Should the first check and the redundant min_t() be removed, and should the
cqe_bcnt > rq->frags_sz path also increment rq->stats->dropped?

[ ... ]

> +bool xsc_eth_post_rx_wqes(struct xsc_rq *rq)
> +{
> +	struct xsc_wq_cyc *wq =3D &rq->wqe.wq;
> +	u8 wqe_bulk, wqe_bulk_min;
> +	int err =3D 0;
> +	int alloc;
> +	u16 head;
> +
> +	wqe_bulk =3D rq->wqe.info.wqe_bulk;
> +	wqe_bulk_min =3D rq->wqe.info.wqe_bulk_min;
> +	if (xsc_wq_cyc_missing(wq) < wqe_bulk)
> +		return false;
> +
> +	do {
> +		head =3D xsc_wq_cyc_get_head(wq);
> +
> +		alloc =3D min_t(int, wqe_bulk, xsc_wq_cyc_missing(wq));
> +		if (alloc < wqe_bulk && alloc >=3D wqe_bulk_min)
> +			alloc =3D alloc & 0xfffffffe;
> +
> +		if (alloc > 0) {
> +			err =3D xsc_alloc_rx_wqes(rq, head, alloc);
> +			if (unlikely(err))
> +				break;
> +
> +			xsc_wq_cyc_push_n(wq, alloc);
> +		}
> +	} while (xsc_wq_cyc_missing(wq) >=3D wqe_bulk_min);
> +
> +	dma_wmb();
> +
> +	/* ensure wqes are visible to device before updating doorbell record */
> +	xsc_rq_notify_hw(rq);
> +
> +	return !!err;
> +}

[Severity: Medium]
If xsc_alloc_rx_wqes() fails on the first iteration of the loop in
xsc_eth_post_rx_wqes(), no WQEs are pushed to wq, but execution still falls
through to xsc_rq_notify_hw(rq) and writes the unchanged wq->wqe_ctr to the
hardware RX doorbell.

In addition, during ndo_open, xsc_eth_modify_qps_channel() calls
c->qp.rq.post_wqes(&c->qp.rq) without checking its return value or whether =
the
RQ ring is still empty before transitioning the RQ to RTS. If initial page
allocation fails, won't the RQ enter RTS with zero posted WQEs and never
receive completions to trigger a refill?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/dri=
vers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> index 262421740e974..42e6305478913 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
> @@ -118,7 +118,9 @@ int xsc_eth_napi_poll(struct napi_struct *napi, int b=
udget)
>  {
>  	struct xsc_channel *c =3D container_of(napi, struct xsc_channel, napi);
>  	struct xsc_eth_params *params =3D &c->adapter->nic_param;
> +	struct xsc_rq *rq =3D &c->qp.rq;
>  	bool busy =3D false;
> +	int work_done =3D 0;
>  	int tx_budget;
> =20
>  	rcu_read_lock();
> @@ -126,18 +128,29 @@ int xsc_eth_napi_poll(struct napi_struct *napi, int=
 budget)
>  	tx_budget =3D params->sq_size >> 2;
>  	busy |=3D xsc_poll_tx_cq(&c->qp.sq.cq, tx_budget);
> =20
> +	/* budget=3D0 means: don't poll rx rings */
> +	if (likely(budget)) {
> +		work_done =3D xsc_poll_rx_cq(&rq->cq, budget);
> +		busy |=3D work_done =3D=3D budget;
> +	}
> +
> +	busy |=3D rq->post_wqes(rq);

[Severity: High]
Can xsc_eth_post_rx_wqes() race with NAPI or run while the RQ is disabled?

Looking at the channel open sequence in xsc_eth_sw_init():

xsc_eth_open_channels()
    for (i =3D 0; i < chls->num_chl; i++)
        napi_enable(&chls->c[i].napi);
    smp_wmb();
    xsc_eth_modify_qps()
        xsc_eth_modify_qps_channel()
            c->qp.rq.post_wqes(&c->qp.rq);
            xsc_core_eth_modify_qp_status(..., XSC_CMD_OP_RTR2RTS_QP);
xsc_eth_activate_priv_channels()
    xsc_eth_activate_channel()
        xsc_activate_rq() -> set_bit(XSC_ETH_RQ_STATE_ENABLED, &c->qp.rq.st=
ate)

Unlike xsc_poll_rx_cq(), xsc_eth_post_rx_wqes() does not check
test_bit(XSC_ETH_RQ_STATE_ENABLED, &rq->state), and xsc_eth_napi_poll() cal=
ls
rq->post_wqes(rq) unconditionally (even when budget =3D=3D 0 or when
XSC_ETH_RQ_STATE_ENABLED is not set).

This appears to allow several issues:

1. Because napi_enable() is called before xsc_eth_modify_qps_channel() calls
   c->qp.rq.post_wqes(&c->qp.rq) in process context without BH disabled, a
   concurrent NAPI poll (via busy-poll, netpoll, or a CQ interrupt) can run
   rq->post_wqes(rq) at the same time on the same RQ, corrupting wq->wqe_ct=
r,
   wq->cur_sz, frag->di->page, and the non-thread-safe page_pool alloc cach=
e.

2. While xsc_eth_modify_qps() is iterating over channels across sleeping
   firmware commands, earlier channels have already transitioned to RTS whi=
le
   XSC_ETH_RQ_STATE_ENABLED is still 0, so incoming packets can trigger
   xsc_eth_completion_event() while xsc_poll_rx_cq() refuses to drain the C=
Q.

3. During teardown in xsc_eth_deactivate_channels(), xsc_deactivate_rq()
   clears XSC_ETH_RQ_STATE_ENABLED before napi_disable(), but in-flight NAPI
   polls will still call rq->post_wqes(rq), allocating pages and ringing the
   RX doorbell on the deactivated RQ (and if page allocation fails, returni=
ng
   busy =3D true so xsc_eth_napi_poll() never completes NAPI).

Should xsc_eth_post_rx_wqes() check test_bit(XSC_ETH_RQ_STATE_ENABLED,
&rq->state), and should XSC_ETH_RQ_STATE_ENABLED and initial WQE posting ha=
ppen
before napi_enable() and the RTR2RTS transition?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D9
