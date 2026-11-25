Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615704;
	b=RpzUKXmLZLi3PwrVrT2JIFPP7B6+WKG0IllH4Z/KlsOUl6yGMLsRtEcuUpDDTEXBQ/7G
	 26CuhAYUj7m6EQ63wiQ4tFCgGOc/BF84icXBe3LcDJbaDFJxgghEbjvhRM6u8NrNMh2kF
	 Xpjsiq/iit2j5TJv5MuZ5i+HlnBzdkyNUaL1LKVYGMV4FfmSwapCg6iXx6R5+2CbhCfXV
	 lQ70vN5MliWqeTB+gH/P91eNY5slWuZ8+CwAzBvJoArtnzmZPPSCsfl84T7CTyN/Fq+Dd
	 vK1noNo5bV0Yv4xhHvy7DH9SYv0z2URhxvP8JGuFS2BCLMpiOIIWwywFNYyagUhqC5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615704;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TU1LfWeolW34kG5kf/VIvYt2G9z/dahYQR674XJ7ngc=;
	b=2eJbgJDYyLeVEer3ri+rmKK3J8oiHqe74Aul9tp2kU/A7eZpyVhphyqZnfAroSq/4E6F
	 E/VvpZk6ornjKWWP8p/dVLYc3qlf00WQ9/M5BKuLChwkN3PrxH20aDMTgZlB3DT4Wb0CV
	 +AST7k9HDmrdAtNnvh/RYhEf5FStnCh2ZVibqmDazozpPmQ+RUXupJGowTG2aUYgq3gPY
	 TzlTt0moV3KbTmfpghB/YltbpkTHm2UzPujxPBKyhn6iRcW2g/4ZVAUu6xFZMtAMfcMPq
	 FHAp3ByQRSihHLLZdRIDT9Hu7Em+gs6aOFW9uWCLL9DHKMdIt64V97cNv4UcE4eGMUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDZOtrbA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C74606A33C;
	Wed, 25 Nov 2026 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDZOtrbA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF91F000C0;
	Wed, 25 Nov 2026 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615704;
	bh=TU1LfWeolW34kG5kf/VIvYt2G9z/dahYQR674XJ7ngc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jDZOtrbAJRxS5789GD2IEu5cFWg8H4bMOpYuk+T1NGLJq+Y9pZrVBG4wIcA9oakLG
	 6cb9WlWsnjS+Sxp1nMs0u+jEIhDt2eWL27Gcz4Q/xpD2wK7briTpJ75tCgTPvtz66z
	 4PiTvOGBy3dFQpHyLWTSoiHeIrX/KnrRTTwKEwF0IpFjU9e1p8pmOBH8J2pDzLhdsb
	 /fw/ujACMI2vyeo3kRwUtkSRXUwiNFmlT+nDSQag41l1iMp9cOF99kCIsmsb9bmVuX
	 zPSSLlmuAvHjEBF7SX0HNySz+tUqTrVPDXE2vsmEZqeGY4u9Sl8HaazALm0NmXenfI
	 sqiBuNSi/6fQQ==
Subject: Re: [PATCH net-next 07/15] xsk: Deliver to the socket in the device's
 buffer layout
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:08:20 +0000
Message-ID: <179561570080.3135.17027149687263984243@kernel.org>
In-Reply-To: <20261124125654.183091-7-bjorn@kernel.org>
References: <20261124125654.183091-7-bjorn@kernel.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] xsk: page_pool_put_unrefed_netmem() in take_fill/scrub recycles
  to old pool
- [Medium] Handed-off chunks can stay on sink->handed indefinitely, so
  they never reach userspace.
- [Low] The new sink branch in xdp_do_redirect() (net/core/filter.c)
  clears ri->map_id/map_type and returns xsk_sink_redirect()'s result…

--

xsk: Deliver to the socket in the device's buffer layout

This patch delivers redirected sink buffers to the receiving AF_XDP
socket of the queue. Each buffer becomes one RX descriptor, chained with
XDP_PKT_CONTD. Chunks go back to userspace with a new XDP_RX_CHUNK_FREE
flag, either on the descriptor of the buffer that freed the chunk or as an
empty descriptor posted from a hand-off list at a later flush or refill
of the queue NAPI.

> diff --git a/net/core/filter.c b/net/core/filter.c
> index d5774b2577e72..30b35d00e6b2f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4775,6 +4775,15 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  	struct bpf_redirect_info *ri = bpf_net_ctx_get_ri();
>  	enum bpf_map_type map_type = ri->map_type;
>  
> +	/* A sink buffer goes to an AF_XDP socket of its queue */
> +	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp)) {
> +		void *fwd = ri->tgt_value;
> +
> +		ri->map_id = 0;
> +		ri->map_type = BPF_MAP_TYPE_UNSPEC;
> +		return xsk_sink_redirect(xdp, map_type, fwd);
> +	}

[Severity: Low]
Is it intended that sink redirects skip the redirect tracepoints? This
branch returns before __xdp_do_redirect_xsk() or
__xdp_do_redirect_frame() run. Those are where the existing redirect
paths emit their events:

net/core/filter.c:__xdp_do_redirect_xsk() {
    ...
	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
	return 0;
err:
	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
    ...
}

As a result, neither xdp:xdp_redirect_map nor xdp:xdp_redirect_map_err
fires for sink buffers. That covers successful deliveries and every
error that xsk_sink_redirect() returns:

  -EOPNOTSUPP for a non-XSKMAP target, such as a devmap or cpumap
  redirect. Before this patch, that failed in __xdp_do_redirect_frame()
  with a traced error.
  -EINVAL for a target that is not the receiving socket.
  -ENOBUFS when the RX ring is full.
  -EINVAL for the drops in xsk_sink_rcv().

Tools that count redirects and redirect errors through these tracepoints,
such as xdp-monitor, would see nothing for sink queues. The commit
message doesn't mention this, and filter.c isn't changed later in the
series.

Could the tracepoints be emitted on this path too?

> +
>  	if (map_type == BPF_MAP_TYPE_XSKMAP)
>  		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
>  

[ ... ]

> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
> index b78116f25e712..9f1f7cf822667 100644
> --- a/net/xdp/xsk_sink.c
> +++ b/net/xdp/xsk_sink.c

[ ... ]

> @@ -172,12 +192,78 @@ static u32 xsk_sink_take_released(struct xsk_sink *sink, struct page_pool *pp,
>  	return n;
>  }
>  
> +/* Posts the chunks that page pools handed off as empty RX descriptors
> + * while the ring has room, and puts the rest back on the list. Their order
> + * does not matter, as userspace tells chunks by their address. Only one
> + * NAPI runs a queue at a time, so this is the only consumer of the list
> + * while the queue runs, and xsk_sink_scrub() the only one after it stopped.
> + *
> + * Context: the queue NAPI
> + */
> +static void xsk_sink_give_back(struct xsk_sink *sink, struct xdp_sock *xs)
> +{
> +	struct llist_node *node, *last;
> +	u32 idx;
> +
> +	if (llist_empty(&sink->handed) || !xskq_prod_nb_free(xs->rx, 1))
> +		return;
> +
> +	node = llist_del_all(&sink->handed);
> +	while (node && xskq_prod_nb_free(xs->rx, 1)) {

[ ... ]

> +	}
> +	if (!node)
> +		return;
> +
> +	/* The ring is full, so userspace is behind */
> +	for (last = node; last->next; last = last->next)
> +		;
> +	llist_add_batch(node, last, &sink->handed);
> +}

[ ... ]

> @@ -185,17 +271,34 @@ static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp)
>  	if (WARN_ON_ONCE(pp->alloc.count))
>  		return 0;
>  

[ ... ]

> +	/* Pairs with xsk_sink_add_sock() */
> +	xs = smp_load_acquire(&sink->xs);
> +	if (xs && napi && !llist_empty(&sink->handed)) {
> +		xsk_sink_give_back(sink, xs);
> +		xskq_prod_submit(xs->rx);
> +		xs->sk.sk_data_ready(&xs->sk);
> +	}
> +
>  	spin_lock_bh(&sink->lock);
>  	n = xsk_sink_take_fill(sink, pp);
>  	n = xsk_sink_take_released(sink, pp, n);
>  	fq = sink->fq;

[Severity: High]
Does the put in xsk_sink_scrub(), and the one in xsk_sink_take_fill()
for a chunk of another page pool, ever reach xsk_sink_release_netmem()?

With this patch, a chunk that goes back to userspace through
xsk_sink_drop_buf() or xsk_sink_give_back() is in XSK_SINK_USER, but
netmem_get_pp() still points at the page pool that allocated it. When
userspace lends it again and a different page pool refills,
xsk_sink_take_fill() gives it to that owner:

net/xdp/xsk_sink.c:xsk_sink_take_fill() {
    ...
		owner = netmem_get_pp(netmem);
		if (owner && owner != pp) {
			page_pool_put_unrefed_netmem(owner, netmem, -1, false);
			continue;
		}
    ...
}

page_pool_put_unrefed_netmem() does not release a net_iov, though.
__page_pool_page_can_be_recycled() is always true for net_iovs, so
__page_pool_put_page() keeps the chunk and it lands in owner->ring, or
in the owner's alloc cache when page_pool_napi_local() says so. Only
page_pool_return_netmem() calls the provider's release_netmem, and on
this path that only happens when the ring is full, or when
page_pool_scrub() of a destroyed pool empties the ring.

That seems to matter in three places:

  On a queue restart where the driver fills the new queue before the
  old page pool goes away, as bnxt does from bnxt_queue_mem_alloc()
  and fbnic from fbnic_queue_start(), every chunk that userspace lends
  again moves from FILL into the old pool's ring. sink->released is
  empty at that point, so xsk_sink_alloc_netmems() can return 0 for
  the new pool and count fq->queue_empty_descs, even with a full FILL
  ring. Can that make bnxt fail the restart with -ENOMEM?

  Where the old pool is destroyed first, as in mlx5e_queue_start(),
  the chunks that userspace holds keep it in flight, so
  page_pool_destroy() scrubs its ring once and leaves the rest to
  release_dw. Chunks that the new pool takes from FILL after that
  sit in the old ring until page_pool_release_retry() runs, up to
  DEFER_TIME later.

  On unbind, netif_mp_close_rxq() destroys the page pool while
  XSK_SINK_USER chunks and the hand-off list are still charged to it.
  xsk_sink_scrub() then runs from xsk_sink_stop() and puts them into
  the ring of that destroyed pool. They only reach
  xsk_sink_release_netmem() once the deferred release runs a second
  later, and the page pool and the sink stay around until then.

Should the provider release these chunks itself, the way
page_pool_return_netmem() would, instead of putting them through the
recycling path? Or is there another way for the owner to let go of a
chunk that it lent to userspace?

[ ... ]

>  	if (napi && fq && sink->pool->uses_need_wakeup) {
> -		if (n)
> +		if (n && llist_empty(&sink->handed))
>  			xsk_clear_rx_need_wakeup(sink->pool);
>  		else
>  			xsk_set_rx_need_wakeup(sink->pool);

[ ... ]

> @@ -226,12 +329,61 @@ static bool xsk_sink_release_netmem(struct page_pool *pp, netmem_ref netmem)
>  	return false;
>  }
>  
> +/* The last put of a chunk with a buffer in userspace: it goes back to
> + * userspace, still charged to @pp. The next flush or refill of the queue
> + * NAPI posts its empty descriptor.
> + */
> +static bool xsk_sink_hand_off(struct page_pool *pp, netmem_ref netmem)
> +{
> +	struct net_iov *niov = netmem_to_net_iov(netmem);
> +	struct xsk_sink *sink = pp->mp_priv;
> +	struct llist_node *node;
> +
> +	niov->mp_hand_off = false;
> +	node = &sink->nodes[net_iov_idx(niov)];
> +	llist_add(node, &sink->handed);
> +	return true;
> +}

[Severity: Medium]
Can chunks stay on sink->handed indefinitely?

The commit message says that a handed-off chunk "gives it back at the
next flush of the queue NAPI, or at a refill while no packets come". It
also says that "the refill asks the socket for a kick while any chunk
waits, so that a reader that fell behind gets them once it has drained
its ring".

While the queue runs, only two places take chunks from sink->handed.

The first is xsk_sink_flush(). It is only reached from xsk_flush(), and
only for a socket on the XSKMAP flush list:

net/xdp/xsk.c:xsk_flush() {
	struct xsk_sink *sink = xs->pool->sink;

	if (sink)
		xsk_sink_flush(sink);
    ...
}

A socket only joins that list after a successful xsk_sink_redirect() in
the same poll.

The second is xsk_sink_alloc_netmems(). The page pool only calls it on
the slow path, when both the alloc cache and the ptr_ring are empty.

In mlx5, xdp_do_flush() runs inside mlx5e_poll_rx_cq() through
mlx5e_xdp_rx_poll_complete(). The WQE pages are released later in the
same poll:

mlx5e_post_rx_mpwqes()
  mlx5e_free_rx_mpwqe()
    mlx5e_page_release_fragmented()
      page_pool_put_unrefed_netmem()
        page_pool_hand_off()
          xsk_sink_hand_off()
            llist_add(node, &sink->handed)

So the final put of a chunk whose mp_hand_off was set in
xsk_sink_drop_buf() always comes after that poll's flush.

The other pages freed there go straight into the pp cache with
allow_direct. As a result, the refill in the same loop usually doesn't
reach alloc_netmems either.

When the RX ring is full, xsk_sink_give_back() puts the leftover chunks
back on the list. While the ring stays full, xsk_sink_rcv() returns
-ENOBUFS, so the socket never joins the flush list. Dropped buffers also
keep the pp cache from running dry.

In both cases, a later NAPI run with no successful delivery and a
non-empty cache posts none of the waiting chunks. That includes an idle
link, and the NAPI run that the next patch's xsk_sink_wakeup() starts
through napi_schedule().

The need_wakeup decision in xsk_sink_alloc_netmems() quoted above has a
related gap, because it is only evaluated at refill time.

If the refill ran before a late hand-off, the flag stays cleared and
userspace is not asked to kick.

If the refill saw a non-empty list, the flag stays set. Each poll() or
recvmsg() then kicks a NAPI that can't post the chunks.

The chunks seem to come back only when another packet is delivered, or
when the device runs its page pool cache dry. Could an application that
waits for XDP_RX_CHUNK_FREE stall for as long as the link is idle? For
example, one that waits to refill the fill ring or to reuse chunks for
TX.

This also looks like it remains at the end of the series. The fbnic
patch moves its flush after the refill, but mlx5 and bnxt do not.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
