Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637519;
	b=zorVDEcl1dhdWHhwYAbmCxHc+Xzk84SfXKyBYDmrzlMInt94Wu2HgjxD305N8VaXf/7V
	 ylOc/MHedq3pPMPlJ6lKjDGp3xatMLjm8pAqyd1M3IuQF5MQ0TN7WoZRAmTIqMsrWY07v
	 TP77f7XwXLGdkOB5im4a+tMblAClWWMSmxHa9enveY1u/UaeIIvhq0TDSLQAV0QV6LpKl
	 x+Il6S5YR9kX+5yefx3qGiR6EguV/xisE23rRY6DB9NNg+IYIB/6lzRI+lsiHVC5KQ+LE
	 PLzjRwUsWvat9whRcnoiqarIUNU6fSrSVBR5aEt/pQJc23t5Dr9l1Izqe3FOxnEt0hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=COM9lytTrC++arFn1pMakoydzKnYeVlJgwdIyF6vsaQ=;
	b=HjHX7w2QJrqb/+pxbu6b8ndCa67nfw6NL2EmQFzaiXfU3kRqIMzqSLucJhik3JkP6mWq
	 D326XUGH34t5rKw5tdg15vKXWsFHhDRm9nPLEusCmVOjGkOpsYG+MVOXWicf5kq6lDJbu
	 4Qm4Ul7q0pi/5QYTVkn5fsGgs6ibGGKVyYlVnNqTuVqGx1buZXabNLb2ilFADSTN9xo0m
	 /udPSMzK3mX//hHApjfwBwr6wk/GnqvwjuhgIuTXQlKsN0tI1nKj2CKuNxZha22fZ1fja
	 brD+1efUN/kGabReUqpKo79nIXGCV2JiTq9unIwq0lfLu4Lrd2JtUuFaGyXyqenkLsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Kh0/HJ0d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FD3606A31E;
	Wed, 25 Nov 2026 20:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kh0/HJ0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF13E1F000C4;
	Wed, 25 Nov 2026 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795637519;
	bh=COM9lytTrC++arFn1pMakoydzKnYeVlJgwdIyF6vsaQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Kh0/HJ0d3RliEb0/WwaCv4tKnl2IGXPOttHI3NABKsnpiFvC7jEjd8TvNhsOUtTvV
	 RIo4UHhfm56+ubnTA6Y0lCaR8cBJS42M4VDvUp7YZKVfHVKqyewN6lIG1+bpsbcYzX
	 YpZT7O3pH32sgTHVVLHTS/Cu97DZpTRauAhhqKcCdPa+nTLCrTo8JOtlrtU9ajDZL3
	 2o/lf3WIopsbge7wVXgJVhz+Vk+4H2Djp8E9qx/7SkiM60AkQJdg4C7MeM6UUC61SP
	 qIVkh4I91DOuFtGkeVwOXf5XMwsbFF6IdYReUsP6BC5fYF+cFls7M0wK5RcyOL3sg5
	 79MT4vKp9c4Lg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ilias.apalodimas@linaro.org, alexanderduyck@fb.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com,
 dimitri.daskalakis1@gmail.com, bobbyeshleman@meta.com,
 mohsin.bashr@gmail.com, kees@kernel.org, leitao@debian.org,
 maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 07/15] xsk: Deliver to the socket in the
 device's buffer layout
In-Reply-To: <179561570080.3135.17027149687263984243@kernel.org>
References: <20261124125654.183091-7-bjorn@kernel.org>
 <179561570080.3135.17027149687263984243@kernel.org>
Date: Wed, 25 Nov 2026 21:11:55 +0100
Message-ID: <87jym0n01g.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

netdev-bot+sashiko@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] xsk: page_pool_put_unrefed_netmem() in take_fill/scrub recycles
>   to old pool
> - [Medium] Handed-off chunks can stay on sink->handed indefinitely, so
>   they never reach userspace.
> - [Low] The new sink branch in xdp_do_redirect() (net/core/filter.c)
>   clears ri->map_id/map_type and returns xsk_sink_redirect()'s result=E2=
=80=A6
>
> --
>
> xsk: Deliver to the socket in the device's buffer layout
>
> This patch delivers redirected sink buffers to the receiving AF_XDP
> socket of the queue. Each buffer becomes one RX descriptor, chained with
> XDP_PKT_CONTD. Chunks go back to userspace with a new XDP_RX_CHUNK_FREE
> flag, either on the descriptor of the buffer that freed the chunk or as an
> empty descriptor posted from a hand-off list at a later flush or refill
> of the queue NAPI.
>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index d5774b2577e72..30b35d00e6b2f 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -4775,6 +4775,15 @@ int xdp_do_redirect(struct net_device *dev, struc=
t xdp_buff *xdp,
>>  	struct bpf_redirect_info *ri =3D bpf_net_ctx_get_ri();
>>  	enum bpf_map_type map_type =3D ri->map_type;
>>=20=20
>> +	/* A sink buffer goes to an AF_XDP socket of its queue */
>> +	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp)) {
>> +		void *fwd =3D ri->tgt_value;
>> +
>> +		ri->map_id =3D 0;
>> +		ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
>> +		return xsk_sink_redirect(xdp, map_type, fwd);
>> +	}
>
> [Severity: Low]
> Is it intended that sink redirects skip the redirect tracepoints? This
> branch returns before __xdp_do_redirect_xsk() or
> __xdp_do_redirect_frame() run. Those are where the existing redirect
> paths emit their events:
>
> net/core/filter.c:__xdp_do_redirect_xsk() {
>     ...
> 	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_in=
dex);
> 	return 0;
> err:
> 	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tg=
t_index, err);
>     ...
> }
>
> As a result, neither xdp:xdp_redirect_map nor xdp:xdp_redirect_map_err
> fires for sink buffers. That covers successful deliveries and every
> error that xsk_sink_redirect() returns:
>
>   -EOPNOTSUPP for a non-XSKMAP target, such as a devmap or cpumap
>   redirect. Before this patch, that failed in __xdp_do_redirect_frame()
>   with a traced error.
>   -EINVAL for a target that is not the receiving socket.
>   -ENOBUFS when the RX ring is full.
>   -EINVAL for the drops in xsk_sink_rcv().
>
> Tools that count redirects and redirect errors through these tracepoints,
> such as xdp-monitor, would see nothing for sink queues. The commit
> message doesn't mention this, and filter.c isn't changed later in the
> series.
>
> Could the tracepoints be emitted on this path too?

Yes!

>> +
>>  	if (map_type =3D=3D BPF_MAP_TYPE_XSKMAP)
>>  		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
>>=20=20
>
> [ ... ]
>
>> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
>> index b78116f25e712..9f1f7cf822667 100644
>> --- a/net/xdp/xsk_sink.c
>> +++ b/net/xdp/xsk_sink.c
>
> [ ... ]
>
>> @@ -172,12 +192,78 @@ static u32 xsk_sink_take_released(struct xsk_sink =
*sink, struct page_pool *pp,
>>  	return n;
>>  }
>>=20=20
>> +/* Posts the chunks that page pools handed off as empty RX descriptors
>> + * while the ring has room, and puts the rest back on the list. Their o=
rder
>> + * does not matter, as userspace tells chunks by their address. Only one
>> + * NAPI runs a queue at a time, so this is the only consumer of the list
>> + * while the queue runs, and xsk_sink_scrub() the only one after it sto=
pped.
>> + *
>> + * Context: the queue NAPI
>> + */
>> +static void xsk_sink_give_back(struct xsk_sink *sink, struct xdp_sock *=
xs)
>> +{
>> +	struct llist_node *node, *last;
>> +	u32 idx;
>> +
>> +	if (llist_empty(&sink->handed) || !xskq_prod_nb_free(xs->rx, 1))
>> +		return;
>> +
>> +	node =3D llist_del_all(&sink->handed);
>> +	while (node && xskq_prod_nb_free(xs->rx, 1)) {
>
> [ ... ]
>
>> +	}
>> +	if (!node)
>> +		return;
>> +
>> +	/* The ring is full, so userspace is behind */
>> +	for (last =3D node; last->next; last =3D last->next)
>> +		;
>> +	llist_add_batch(node, last, &sink->handed);
>> +}
>
> [ ... ]
>
>> @@ -185,17 +271,34 @@ static netmem_ref xsk_sink_alloc_netmems(struct pa=
ge_pool *pp, gfp_t gfp)
>>  	if (WARN_ON_ONCE(pp->alloc.count))
>>  		return 0;
>>=20=20
>
> [ ... ]
>
>> +	/* Pairs with xsk_sink_add_sock() */
>> +	xs =3D smp_load_acquire(&sink->xs);
>> +	if (xs && napi && !llist_empty(&sink->handed)) {
>> +		xsk_sink_give_back(sink, xs);
>> +		xskq_prod_submit(xs->rx);
>> +		xs->sk.sk_data_ready(&xs->sk);
>> +	}
>> +
>>  	spin_lock_bh(&sink->lock);
>>  	n =3D xsk_sink_take_fill(sink, pp);
>>  	n =3D xsk_sink_take_released(sink, pp, n);
>>  	fq =3D sink->fq;
>
> [Severity: High]
> Does the put in xsk_sink_scrub(), and the one in xsk_sink_take_fill()
> for a chunk of another page pool, ever reach xsk_sink_release_netmem()?
>
> With this patch, a chunk that goes back to userspace through
> xsk_sink_drop_buf() or xsk_sink_give_back() is in XSK_SINK_USER, but
> netmem_get_pp() still points at the page pool that allocated it. When
> userspace lends it again and a different page pool refills,
> xsk_sink_take_fill() gives it to that owner:
>
> net/xdp/xsk_sink.c:xsk_sink_take_fill() {
>     ...
> 		owner =3D netmem_get_pp(netmem);
> 		if (owner && owner !=3D pp) {
> 			page_pool_put_unrefed_netmem(owner, netmem, -1, false);
> 			continue;
> 		}
>     ...
> }
>
> page_pool_put_unrefed_netmem() does not release a net_iov, though.
> __page_pool_page_can_be_recycled() is always true for net_iovs, so
> __page_pool_put_page() keeps the chunk and it lands in owner->ring, or
> in the owner's alloc cache when page_pool_napi_local() says so. Only
> page_pool_return_netmem() calls the provider's release_netmem, and on
> this path that only happens when the ring is full, or when
> page_pool_scrub() of a destroyed pool empties the ring.
>
> That seems to matter in three places:
>
>   On a queue restart where the driver fills the new queue before the
>   old page pool goes away, as bnxt does from bnxt_queue_mem_alloc()
>   and fbnic from fbnic_queue_start(), every chunk that userspace lends
>   again moves from FILL into the old pool's ring. sink->released is
>   empty at that point, so xsk_sink_alloc_netmems() can return 0 for
>   the new pool and count fq->queue_empty_descs, even with a full FILL
>   ring. Can that make bnxt fail the restart with -ENOMEM?
>
>   Where the old pool is destroyed first, as in mlx5e_queue_start(),
>   the chunks that userspace holds keep it in flight, so
>   page_pool_destroy() scrubs its ring once and leaves the rest to
>   release_dw. Chunks that the new pool takes from FILL after that
>   sit in the old ring until page_pool_release_retry() runs, up to
>   DEFER_TIME later.
>
>   On unbind, netif_mp_close_rxq() destroys the page pool while
>   XSK_SINK_USER chunks and the hand-off list are still charged to it.
>   xsk_sink_scrub() then runs from xsk_sink_stop() and puts them into
>   the ring of that destroyed pool. They only reach
>   xsk_sink_release_netmem() once the deferred release runs a second
>   later, and the page pool and the sink stay around until then.
>
> Should the provider release these chunks itself, the way
> page_pool_return_netmem() would, instead of putting them through the
> recycling path? Or is there another way for the owner to let go of a
> chunk that it lent to userspace?

Hmm, same root cause as patch 6. Let's try to fix it.

> [ ... ]
>
>>  	if (napi && fq && sink->pool->uses_need_wakeup) {
>> -		if (n)
>> +		if (n && llist_empty(&sink->handed))
>>  			xsk_clear_rx_need_wakeup(sink->pool);
>>  		else
>>  			xsk_set_rx_need_wakeup(sink->pool);
>
> [ ... ]
>
>> @@ -226,12 +329,61 @@ static bool xsk_sink_release_netmem(struct page_po=
ol *pp, netmem_ref netmem)
>>  	return false;
>>  }
>>=20=20
>> +/* The last put of a chunk with a buffer in userspace: it goes back to
>> + * userspace, still charged to @pp. The next flush or refill of the que=
ue
>> + * NAPI posts its empty descriptor.
>> + */
>> +static bool xsk_sink_hand_off(struct page_pool *pp, netmem_ref netmem)
>> +{
>> +	struct net_iov *niov =3D netmem_to_net_iov(netmem);
>> +	struct xsk_sink *sink =3D pp->mp_priv;
>> +	struct llist_node *node;
>> +
>> +	niov->mp_hand_off =3D false;
>> +	node =3D &sink->nodes[net_iov_idx(niov)];
>> +	llist_add(node, &sink->handed);
>> +	return true;
>> +}
>
> [Severity: Medium]
> Can chunks stay on sink->handed indefinitely?
>
> The commit message says that a handed-off chunk "gives it back at the
> next flush of the queue NAPI, or at a refill while no packets come". It
> also says that "the refill asks the socket for a kick while any chunk
> waits, so that a reader that fell behind gets them once it has drained
> its ring".
>
> While the queue runs, only two places take chunks from sink->handed.
>
> The first is xsk_sink_flush(). It is only reached from xsk_flush(), and
> only for a socket on the XSKMAP flush list:
>
> net/xdp/xsk.c:xsk_flush() {
> 	struct xsk_sink *sink =3D xs->pool->sink;
>
> 	if (sink)
> 		xsk_sink_flush(sink);
>     ...
> }
>
> A socket only joins that list after a successful xsk_sink_redirect() in
> the same poll.
>
> The second is xsk_sink_alloc_netmems(). The page pool only calls it on
> the slow path, when both the alloc cache and the ptr_ring are empty.
>
> In mlx5, xdp_do_flush() runs inside mlx5e_poll_rx_cq() through
> mlx5e_xdp_rx_poll_complete(). The WQE pages are released later in the
> same poll:
>
> mlx5e_post_rx_mpwqes()
>   mlx5e_free_rx_mpwqe()
>     mlx5e_page_release_fragmented()
>       page_pool_put_unrefed_netmem()
>         page_pool_hand_off()
>           xsk_sink_hand_off()
>             llist_add(node, &sink->handed)
>
> So the final put of a chunk whose mp_hand_off was set in
> xsk_sink_drop_buf() always comes after that poll's flush.
>
> The other pages freed there go straight into the pp cache with
> allow_direct. As a result, the refill in the same loop usually doesn't
> reach alloc_netmems either.
>
> When the RX ring is full, xsk_sink_give_back() puts the leftover chunks
> back on the list. While the ring stays full, xsk_sink_rcv() returns
> -ENOBUFS, so the socket never joins the flush list. Dropped buffers also
> keep the pp cache from running dry.
>
> In both cases, a later NAPI run with no successful delivery and a
> non-empty cache posts none of the waiting chunks. That includes an idle
> link, and the NAPI run that the next patch's xsk_sink_wakeup() starts
> through napi_schedule().
>
> The need_wakeup decision in xsk_sink_alloc_netmems() quoted above has a
> related gap, because it is only evaluated at refill time.
>
> If the refill ran before a late hand-off, the flag stays cleared and
> userspace is not asked to kick.
>
> If the refill saw a non-empty list, the flag stays set. Each poll() or
> recvmsg() then kicks a NAPI that can't post the chunks.
>
> The chunks seem to come back only when another packet is delivered, or
> when the device runs its page pool cache dry. Could an application that
> waits for XDP_RX_CHUNK_FREE stall for as long as the link is idle? For
> example, one that waits to refill the fill ring or to reuse chunks for
> TX.
>
> This also looks like it remains at the end of the series. The fbnic
> patch moves its flush after the refill, but mlx5 and bnxt do not.

Hmm... I think partly, for some chunks, but fewer that this says!

When the socket takes every packet, the chunks of its buffers never go
back to the pool cache, so the refill after mlx5 frees a WQE usually
takes the slow path and gives back the chunks handed off before it. What
waits is what the device lets go of after the last flush/refill of a
poll, and chunks that found the RX ring full.

A wakeup alone does not post them. With FILL empty, the refill reaches
the slow path, so the queue does not deadlock!

Maybe flush the mlx5 redirect after repost, and let a wakeup give back
the chunks that wait...
