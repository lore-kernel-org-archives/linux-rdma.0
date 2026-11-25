Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611613;
	b=J02S2VBzsDghpFgl5CcpZWJCfX5zUFyydOyEW+Mk2ZaFdRD2a6vdE00vKTM5dSoWck/1
	 tGa22TZb7WR6clEvSlPpzwpAaH5HMGn4gJPb1PXGUWQTzJUxKKOEL9etRXgXYB5fWuNgH
	 Dm19inFDeYL8R/ke3NkHFh+6x4yKHsEf568LRWXULIi4XShI4sSmGfBvaHfFLnw5BZ7zS
	 k53Tm0aw24WiURGt84ETC6E4ATI0UpQbuI1qW1va6DDem0lC5INmU4lASQo8mg8boZkCI
	 d+7/B+HTUVFInbYTwAYGM/UAVXWXKU7XJ8WDH/xo8OFwHZzeVYgWi9fTlkWYNRKJlAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611613;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=el9nU2HHLF/xjMhB0WwMFNSqllhxZ9uhWPOS87fqitA=;
	b=y7wOHBRbmyGS1eD+71vRzncV3IjupXFSSK8so5RP/QiKyN+VBY1Ta95hGj1SelAeqFSk
	 6d51Pgv0YL3j0TZ/HWJUWpn7hNpiMSOqo8rsKsYymmeAXDhmBUtVZ/IP/YQVm1eH7+Pd4
	 j6H/9ClTc/blKw23hX1mK7fc2VSU2ubvUoAFn0FIX1364msvUjmeU+9CITNnm63lgkzVF
	 C8VjqT3g9Je3yC0uKpgnWXXu9oEfxpsbCEow/RrVSHCHW8yJSq0DE3+WQMSEsh8LiKviS
	 q9ZETk3CzcoI5UkzhZsh1MsISBr8JustnMVU4UbUZ2rWjQb2BtheEYiZr6+c2pAMPBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AB/ty3fg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92537606A6B6;
	Wed, 25 Nov 2026 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AB/ty3fg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A941F000E6;
	Wed, 25 Nov 2026 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611613;
	bh=el9nU2HHLF/xjMhB0WwMFNSqllhxZ9uhWPOS87fqitA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AB/ty3fg4FY+1+81c2uY8ElrKKRRbGS4OlH4h4Jmu8lDGDMuNr0UZG8ym3y2CfgKI
	 FQ9xsTf94zXgyPPzuoIndTX14BDjZc5TmNVr4EkRnqYgXRe891qusT2gsazzQWUiSp
	 hNMolai1pnRS0wWNM4Mp3WL72UGV8WvGfdjUC0qiUd/YUvjxxiVWhdQNH3/UCabf4E
	 fjqYt68DXBYP5IkkOff09MUtfWfFqaR1hCl/jc68ZFIu7qvabrZWB23T5iT1tbtQDg
	 owf+rbBgHCsbXMi71XIiYeNzP4tvuxpLDqs70JsrHRXJ4LD4qWdF+Cqd9Qs8mGkhq/
	 xtZ4R0zOFa4sA==
Message-ID: <sashiko-outbox-233417@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 07/15] xsk: Deliver to the socket in the
 device's buffer layout
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-7-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-7-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] xsk: page_pool_put_unrefed_netmem() in take_fill/scrub recycles
  to old pool
- [High] xsk: handed chunks miss wakeup in xsk_sink_flush() and stall
  when cached
- [Medium] bpf: xdp_do_redirect() sink path leaks ri->flags/map and
  skips tracepoints
- [Medium] xsk: xsk_sink_alloc_netmems() wakes socket when
  xsk_sink_give_back() fails
- [Medium] xsk: missing release-acquire ordering on niov->mp_state in
  xsk_sink
--

commit b48b71ff0dc93c37b004fc1b4026f483bf6126d2
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

xsk: Deliver to the socket in the device's buffer layout

This commit delivers redirected sink buffers to the bound AF_XDP socket in
the device's buffer layout and returns UMEM chunks to userspace via
XDP_RX_CHUNK_FREE once both the socket and the device are done with them.

> diff --git a/net/core/filter.c b/net/core/filter.c
> index d5774b2577e72..30b35d00e6b2f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4775,6 +4775,15 @@ int xdp_do_redirect(struct net_device *dev, struct=
 xdp_buff *xdp,
>  	struct bpf_redirect_info *ri =3D bpf_net_ctx_get_ri();
>  	enum bpf_map_type map_type =3D ri->map_type;
> =20
> +	/* A sink buffer goes to an AF_XDP socket of its queue */
> +	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp)) {
> +		void *fwd =3D ri->tgt_value;
> +
> +		ri->map_id =3D 0;
> +		ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
> +		return xsk_sink_redirect(xdp, map_type, fwd);
> +	}

[Severity: Medium]
Does taking this early return leave ri->flags and ri->map set when an XDP
program on a sink queue calls bpf_redirect_map() on another map type, such
as a devmap with BPF_F_BROADCAST?

__xdp_do_redirect_frame() clears ri->flags and WRITE_ONCE(ri->map, NULL)
so dev_map_free() does not spin waiting on a stale ri->map pointer and
later redirects in the same softirq do not inherit stale flags.  This path
also skips _trace_xdp_redirect_map() and _trace_xdp_redirect_map_err().

> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
> index b78116f25e712..9f1f7cf822667 100644
> --- a/net/xdp/xsk_sink.c
> +++ b/net/xdp/xsk_sink.c

[ ... ]

> @@ -172,12 +192,78 @@ static u32 xsk_sink_take_released(struct xsk_sink *=
sink, struct page_pool *pp,
>  	return n;
>  }
> =20
> +/* Posts the chunks that page pools handed off as empty RX descriptors
> + * while the ring has room, and puts the rest back on the list. Their or=
der
> + * does not matter, as userspace tells chunks by their address. Only one
> + * NAPI runs a queue at a time, so this is the only consumer of the list
> + * while the queue runs, and xsk_sink_scrub() the only one after it stop=
ped.
> + *
> + * Context: the queue NAPI
> + */
> +static void xsk_sink_give_back(struct xsk_sink *sink, struct xdp_sock *x=
s)
> +{
> +	struct llist_node *node, *last;
> +	u32 idx;
> +
> +	if (llist_empty(&sink->handed) || !xskq_prod_nb_free(xs->rx, 1))
> +		return;
> +
> +	node =3D llist_del_all(&sink->handed);
> +	while (node && xskq_prod_nb_free(xs->rx, 1)) {
> +		idx =3D node - sink->nodes;
> +		node =3D node->next;
> +		WRITE_ONCE(sink->area.niovs[idx].mp_state, XSK_SINK_USER);
> +		__xskq_prod_reserve_desc(xs->rx, (u64)idx << PAGE_SHIFT, 0,
> +					 XDP_RX_CHUNK_FREE);
> +	}
> +	if (!node)
> +		return;
> +
> +	/* The ring is full, so userspace is behind */
> +	for (last =3D node; last->next; last =3D last->next)
> +		;
> +	llist_add_batch(node, last, &sink->handed);
> +}
> +
> +/* Drops the reference of the buffer of @niov that the socket took at the
> + * last RX descriptor. Only the queue NAPI changes the count of a chunk =
that
> + * delivers to the socket, so this needs no atomic.
> + */
> +static void xsk_sink_drop_buf(struct xsk_sink *sink, struct xdp_sock *xs,
> +			      struct net_iov *niov)
> +{
> +	struct xdp_rxtx_ring *ring;
> +	atomic_long_t *count;
> +	long left;
> +
> +	count =3D netmem_get_pp_ref_count_ref(net_iov_to_netmem(niov));
> +	left =3D atomic_long_read(count) - 1;
> +	if (left > 0) {
> +		/* The device still uses it: its last put hands it off */
> +		atomic_long_set(count, left);
> +		niov->mp_hand_off =3D true;
> +		return;
> +	}
> +
> +	/* Free: back to userspace with this descriptor, still charged to its
> +	 * page pool with the count of a free netmem
> +	 */
> +	WARN_ON_ONCE(left < 0);
> +	atomic_long_set(count, 1);
> +	niov->mp_hand_off =3D false;
> +	WRITE_ONCE(niov->mp_state, XSK_SINK_USER);
> +	ring =3D (struct xdp_rxtx_ring *)xs->rx->ring;
> +	ring->desc[(xs->rx->cached_prod - 1) & xs->rx->ring_mask].options |=3D
> +		XDP_RX_CHUNK_FREE;
> +}

[Severity: Medium]
Can xsk_sink_take_fill() observe niov->mp_state =3D=3D XSK_SINK_USER before
niov->mp_hand_off =3D false and atomic_long_set(count, 1) become visible on
weakly ordered architectures?

When a driver refills a new queue's page pool from process context while
the old queue NAPI is still running (such as bnxt during queue restart)
and userspace has already placed the chunk address on the FILL ring, the
RX-ring-to-FILL-ring ordering is bypassed:

CPU0 (old queue NAPI)             CPU1 (process-context refill)
xsk_sink_drop_buf()               xsk_sink_take_fill()
  atomic_long_set(count, 1)         READ_ONCE(niov->mp_state)
  niov->mp_hand_off =3D false           // sees XSK_SINK_USER
  WRITE_ONCE(niov->mp_state,        WRITE_ONCE(niov->mp_state,
             XSK_SINK_USER)                    XSK_SINK_LENT)
                                    page_pool_put_unrefed_netmem(owner, ...)
                                      page_pool_hand_off()
                                        if (niov->mp_hand_off)
                                          <-- sees stale true

If page_pool_hand_off() sees stale mp_hand_off =3D=3D true, it puts the chu=
nk
on sink->handed instead of releasing it from the old page pool, emitting a
duplicate XDP_RX_CHUNK_FREE descriptor for a chunk whose FILL entry was
already consumed.  Pairing smp_store_release(&niov->mp_state,
XSK_SINK_USER) with smp_load_acquire(&niov->mp_state) in
xsk_sink_take_fill() would order these accesses.

>  static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp)
>  {
>  	struct xsk_sink *sink =3D pp->mp_priv;
>  	/* The NAPI owns the need_wakeup flags */
>  	bool napi =3D in_softirq() && !in_hardirq();
>  	struct xsk_queue *fq;
> +	struct xdp_sock *xs;
>  	dma_addr_t dma;
>  	u32 i, n;
> =20
> @@ -185,17 +271,34 @@ static netmem_ref xsk_sink_alloc_netmems(struct pag=
e_pool *pp, gfp_t gfp)
>  	if (WARN_ON_ONCE(pp->alloc.count))
>  		return 0;
> =20
> +	/* Userspace may wait for chunks the device let go of after the last
> +	 * flush, and with no packets coming, no flush gives them back. A
> +	 * refill with BH disabled is the queue NAPI, as process context
> +	 * refills with BH enabled. Only one NAPI runs a queue at a time, as
> +	 * a queue restart stops the old queue before the new one runs, so
> +	 * the refill may produce to the RX ring.
> +	 */
> +	/* Pairs with xsk_sink_add_sock() */
> +	xs =3D smp_load_acquire(&sink->xs);
> +	if (xs && napi && !llist_empty(&sink->handed)) {
> +		xsk_sink_give_back(sink, xs);
> +		xskq_prod_submit(xs->rx);
> +		xs->sk.sk_data_ready(&xs->sk);
> +	}

[Severity: Medium]
When xs->rx is full, xsk_sink_give_back() returns immediately without
reserving any descriptors and leaves the chunks on sink->handed.  Should
xskq_prod_submit() and sk_data_ready() only run when xsk_sink_give_back()
actually posted descriptors, to avoid waking the socket on every NAPI
cache refill while the RX ring is full?

[ ... ]

> +/* Page pools hold the chunks that went back to userspace until it lends
> + * them again. Put them back, so that the page pools can finish their
> + * destruction, and handed-off chunks that never made it to userspace to=
o.
> + * The queue stopped, so no NAPI takes from the handed list any longer.
> + * Device unregister scrubs twice, when it uninstalls the provider and
> + * when the socket unbinds.
> + */
> +static void xsk_sink_scrub(struct xsk_sink *sink)
> +{
> +	struct llist_node *node;
> +	struct net_iov *niov;
> +	netmem_ref netmem;
> +	u32 idx;
> +
> +	for (node =3D llist_del_all(&sink->handed); node; node =3D node->next)
> +		sink->area.niovs[node - sink->nodes].mp_state =3D XSK_SINK_USER;
> +
> +	for (idx =3D 0; idx < sink->area.num_niovs; idx++) {
> +		niov =3D &sink->area.niovs[idx];
> +		netmem =3D net_iov_to_netmem(niov);
> +		if (niov->mp_state =3D=3D XSK_SINK_LENT || !netmem_get_pp(netmem))
> +			continue;
> +
> +		niov->mp_hand_off =3D false;
> +		/* A later scrub must skip it: its page pool may not have
> +		 * released it yet
> +		 */
> +		niov->mp_state =3D XSK_SINK_LENT;
> +		page_pool_put_unrefed_netmem(netmem_get_pp(netmem), netmem,
> +					     -1, false);
> +	}
> +}

[Severity: High]
Does calling page_pool_put_unrefed_netmem() here and in
xsk_sink_take_fill() recycle chunks into the old page pool's ptr_ring
instead of releasing them?

Once chunks return to userspace in XSK_SINK_USER, netmem_get_pp(netmem)
still points to the page pool that allocated them.  Because
__page_pool_page_can_be_recycled() always returns true for net_iovs:

net/core/page_pool.c:__page_pool_put_page() {
    ...
	if (likely(__page_pool_page_can_be_recycled(netmem))) {
		...
		return netmem;
	}
    ...
	page_pool_return_netmem(pool, netmem);
	return 0;
}

page_pool_put_unrefed_netmem(owner, netmem, -1, false) pushes the chunk
into owner->ring rather than calling page_pool_return_netmem() ->
xsk_sink_release_netmem().

During a queue restart in drivers that allocate the new queue's buffers
before destroying the old page pool (such as bnxt or fbnic),
xsk_sink_take_fill() consumes FILL entries for the new page pool and traps
them in the old pool's ptr_ring instead of moving them to sink->released,
so xsk_sink_alloc_netmems() returns 0 even with a full FILL ring.  And on
unbind, xsk_sink_scrub() runs after netif_mp_close_rxq() has already
called page_pool_destroy(), so pushing the chunks into the detached pool's
ptr_ring delays page pool and sink destruction until the 1-second
release_dw retry work drains the ring.

[ ... ]

> +/**
> + * xsk_sink_flush - give back chunks at the end of a NAPI poll
> + * @sink: provider of a socket that received in this poll
> + *
> + * Context: the queue NAPI, from xdp_do_flush(), before the RX ring is
> + * submitted.
> + */
> +void xsk_sink_flush(struct xsk_sink *sink)
> +{
> +	/* Pairs with xsk_sink_add_sock() */
> +	struct xdp_sock *xs =3D smp_load_acquire(&sink->xs);
> +
> +	if (!xs)
> +		return;
> +
> +	xsk_sink_give_back(sink, xs);
> +}

[Severity: High]
Can chunks left on sink->handed stall when the RX ring is full at the end
of a NAPI poll or when later refills are satisfied from pp->alloc.cache?

If xsk_sink_give_back() in xsk_sink_flush() stops because xs->rx is full,
nothing sets xsk_set_rx_need_wakeup(sink->pool) if xsk_sink_alloc_netmems()
already ran earlier in the poll (when sink->handed was empty) or did not
run because pp->alloc.cache had entries.  Userspace then drains xs->rx
without knowing it needs to wake the NAPI.

Even when XDP_RING_NEED_WAKEUP is set, a subsequent wakeup NAPI poll that
receives no packets does not call xsk_sink_flush(), and only reaches
xsk_sink_alloc_netmems() if the driver refills and both pp->alloc.cache
and pp->ring are empty; otherwise the handed-off chunks remain on
sink->handed across polls.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D7
