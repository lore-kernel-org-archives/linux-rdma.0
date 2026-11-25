Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615721;
	b=kF2k2q/zGQstw5/DlUvhz6q+xnCZBCMMl8zy2Gr2JxtgGI9WoAY8cbH8dRzsW6qJhfRm
	 TZKrjPMwWLVjvcfDGr+pV5gXG1WiwWx32+0ww6dqGmYYOYaPacuRgT9PjlNXowuUxCHOp
	 SPhl+oVdhQN/R4wIliFpBTL8NG+p1UeQLN9UipC9LmXhOlzmpclW6HYmXGWYi2YK+wyTf
	 1eNT3b2j1/EnSIy8pT12H/gbzx7vkn7KiyVze0PdQpFli4Qfw/Pf4EKfjoyLT0oUaCWcK
	 Rh7WotR0hlMmFD0K3ia9QWCs6qREPpKRoRqMF6LVZPoHAYB3WHBftg8BW7dLFJTvhjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615721;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=5RDXUf24OP+IGwqTymupqSLNWGk88EXXkm2+JJNuDt8=;
	b=XSfcQnBrk92VWTh/drvYdK8ctZ+pHdsL/qu7jdYARlER8exazmi9xBa/5+73J+uO3yQc
	 21PcXsL5TmhSRDF2sbbN/ejhGiLZozexVc0AGqvkr/LO48ZvCOugJ+TSVm7/FiM4HXEXI
	 vAWgobcj4CzFUVXk7FE9QT5f67F7QF9n0/q2W4dg19pWSpL3ZZNqTDcdNf0qJnP5gbuli
	 g4bOeexneONVEj9tpG5GWY/8/UXx9kC7qTHlVS5CnCsTOPmk31Lba1r4WwXUg4ufXdVK2
	 g06B97K4YEEfi3Oe6a8ATjVMhB6KnY3IyR57rLno2cYYntz4H5vfqUE6Nf2/nyDXhkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpJKKCrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DE7606A684;
	Wed, 25 Nov 2026 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpJKKCrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D76C1F000F0;
	Wed, 25 Nov 2026 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615720;
	bh=5RDXUf24OP+IGwqTymupqSLNWGk88EXXkm2+JJNuDt8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JpJKKCrkhZosCdM9rNokWxoj4qCRx9vQ1DivHA+hwr94W2FA3McPo7YnrhjBmLNz6
	 xuPH/Rwa3nnOywmavxZlcn3IdOSq54DvHgCZVjcaQ4JoLeye/SWyPKx0Vhdwd0xjXn
	 +8OVLAXzYtai7o9KwaPGH8v4ezvJNoLksWcyseO4DwAyIUmJui33pyzSiDizuyt2Pu
	 +z3U8D1RE0oh/8h03583yPFSW5X0Y9PK1a40LgmYYe57TjELqqPNyGkOqNbATnJdnw
	 WKbQq0omR2DhSpDTyr3vURBYD1QQp+ixen39kGUQ5Tj2+Ek2RDZVslNE7ka3Cj2u05
	 SKZ9ZGtX3Hk5w==
Subject: Re: [PATCH net-next 14/15] selftests: net: xsk: Test the device's RX
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
Date: Wed, 25 Nov 2026 14:08:37 +0000
Message-ID: <179561571702.3135.12462188305615084284@kernel.org>
In-Reply-To: <20261124125654.183091-14-bjorn@kernel.org>
References: <20261124125654.183091-14-bjorn@kernel.org>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 10 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 6 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] With -D, the test puts XDP_UMEM_DRV_LAYOUT on every UMEM.
- [Medium] The commit says drv layout skips tests that need one RX
  descriptor per packet, but testapp_hw_sw_min_ring_size() is not…
- [Medium] With -D, main() probes zero-copy support through
  ifobj_zc_avail(ifobj_tx).
- [Medium] Drv-layout runs keep the fixed UMEM size: DEFAULT_UMEM_BUFFERS
  (1024) page chunks, doubled to 2048 in the single-netdev shared-UMEM…
- [Medium] selftests: net: xsk: testapp_stats_fill_empty() fails in drv
  layout mode
- [Medium] selftests: net: xsk: __receive_pkts() infinite spin reserving
  rcvd FILL slots
- [Low] The kernel accepts XDP_UMEM_DRV_LAYOUT only when chunk_size ==
  PAGE_SIZE (xdp_umem_reg()).
- [Low] __receive_pkts() calls count_drv_shared() for each data
  descriptor as soon as it is validated, before it knows whether the…
- [Low] The comment on is_frag_valid_drv() says the last payload word
  needs only the right sequence number because XDP_ADJUST_TAIL_GROW…
- [Low] In drv layout, xsk_configure_socket() always adds XDP_USE_SG, and
  xsk_sink_bind() then requires NETDEV_XDP_ACT_RX_SG in…

--

selftests: net: xsk: Test the device's RX buffer layout

This commit adds a -D option to xskxceiver. In drv mode it registers the
UMEM with XDP_UMEM_DRV_LAYOUT and binds multi-buffer sockets without
XDP_COPY. The receive path checks buffers by packet offset, returns chunks
to FILL only on XDP_RX_CHUNK_FREE, and populates FILL before bind. Tests
that cannot run in this layout are skipped.

> diff --git a/tools/testing/selftests/net/lib/xsk/test_xsk.c b/tools/testing/selftests/net/lib/xsk/test_xsk.c
> index ca161511f1e5f..bae503432eeb3 100644
> --- a/tools/testing/selftests/net/lib/xsk/test_xsk.c
> +++ b/tools/testing/selftests/net/lib/xsk/test_xsk.c

[ ... ]

> @@ -94,6 +99,8 @@ int xsk_configure_umem(struct ifobject *ifobj, struct xsk_umem_info *umem, void
>  
>  	if (umem->unaligned_mode)
>  		cfg.flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> +	if (opt_drv_layout)
> +		cfg.flags |= XDP_UMEM_DRV_LAYOUT;
>  
>  	ret = xsk_umem__create(&umem->umem, buffer, size,
>  			       &umem->fq, &umem->cq, &cfg);

[Severity: Medium]
Does this also put XDP_UMEM_DRV_LAYOUT on the TX-only UMEM?

xsk_configure_umem() sets the flag without looking at ifobj->rx_on. In
test_init(), the TX ifobject also loses XDP_COPY:

		else if (!opt_drv_layout || mode != TEST_MODE_DRV)
			ifobj->bind_flags |= XDP_COPY;

In the two-netdev setup, ifobj_tx registers its own UMEM. In the kernel,
every pool with this flag goes through the sink:

net/xdp/xsk_buff_pool.c:xp_assign_dev() {
    ...
	if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
		err = xsk_sink_bind(pool, netdev, queue_id, flags);
    ...
}

xsk_sink_bind() then calls netif_mp_open_rxq(), which restarts RX queue 0
of the TX device on the TX UMEM. That FILL ring is never populated:

- thread_common_ops() returns before xsk_populate_fill_ring() when rx_on
  is false.
- fill_first is also gated on rx_on.

xsk_sink_add_sock() only adopts sockets that have xs->rx, so nothing ever
receives on that queue.

Wouldn't the TX NIC's RX queue 0 then have no buffers for the whole run,
so any host traffic steered to it is dropped?

There is also the case of a TX device that lacks queue_mgmt_ops, REDIRECT
or RX_SG. Wouldn't the TX bind fail with -EOPNOTSUPP there, so every test
reports FAIL? The help text, "Receive in the device's buffer layout",
reads like an RX-only feature.

[Severity: Medium]
Can this abort the whole -D run on kernels where PAGE_SIZE is not 4096?

main() probes zero-copy support through ifobj_zc_avail(), which also
reaches this code:

tools/testing/selftests/net/lib/xsk/xskxceiver.c:ifobj_zc_avail() {
    ...
	umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
	ret = xsk_configure_umem(ifobject, umem, bufs, umem_sz);
	if (ret)
		exit_with_error(-ret);
    ...
}

With the flag set, xdp_umem_reg() rejects a 4096-byte chunk on such
kernels:

	if (mr->flags & XDP_UMEM_DRV_LAYOUT &&
	    (unaligned_chunks || chunk_size != PAGE_SIZE || headroom))
		return -EINVAL;

-D forces drv mode, and drv mode requires is_xdp_supported(), so this
probe always runs. The program would then exit with a failure before any
test starts. The drv_layout_umem_ok() skip in __testapp_validate_traffic()
would never be reached.

> @@ -161,7 +168,8 @@ int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem
>  	cfg.bind_flags = ifobject->bind_flags;
>  	if (shared)
>  		cfg.bind_flags |= XDP_SHARED_UMEM;
> -	if (ifobject->mtu > MAX_ETH_PKT_SIZE)
> +	/* The device may split any frame, see XDP_UMEM_DRV_LAYOUT */
> +	if (ifobject->mtu > MAX_ETH_PKT_SIZE || opt_drv_layout)
>  		cfg.bind_flags |= XDP_USE_SG;

[Severity: Low]
With XDP_USE_SG forced here, xsk_sink_bind() also requires RX_SG:

	if (flags & XDP_USE_SG)
		needed |= NETDEV_XDP_ACT_RX_SG;
	if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
	    (dev->xdp_features & needed) != needed ||
	    queue_id >= dev->real_num_rx_queues)
		return -EOPNOTSUPP;

The test already records ifobj->multi_buff_supp. However,
__testapp_validate_traffic() only checks it when
test->mtu > MAX_ETH_PKT_SIZE.

On a device that does not currently advertise RX_SG, would every
default-MTU drv layout test fail at bind and report FAIL? Today such
devices get the "Multi buffer not supported" SKIP.

[ ... ]

> @@ -878,6 +887,77 @@ static bool is_frag_valid(struct xsk_umem_info *umem, u64 addr, u32 len, u32 exp
>  	return false;
>  }
>  
> +/* Driver layout: a buffer may start and end anywhere in the packet, and
> + * anywhere in its chunk. Check its bytes against the generated pattern by
> + * packet offset. XDP_ADJUST_TAIL_GROW zeroes the last @grow bytes and
> + * writes the sequence number of the last word, so that word only needs the
> + * right sequence number, and the bytes before it may be zero.
> + */
> +static bool is_frag_valid_drv(struct xsk_umem_info *umem, u64 addr, u32 len,
> +			      u32 expected_pkt_nb, u32 bytes_processed,
> +			      u32 pkt_len, u32 grow)
> +{

[ ... ]

> +	for (i = 0; i < len; i++) {
> +		off = bytes_processed + i;
> +		if (off < PKT_HDR_SIZE || off >= payload_end)
> +			continue;
> +		if (off >= pkt_len - grow && !bytes[i])
> +			continue;
> +
> +		off -= PKT_HDR_SIZE;
> +		word = htonl(expected_pkt_nb << 16 | (off / 4));
> +		if (off / 4 == (payload_end - PKT_HDR_SIZE) / 4 - 1 &&
> +		    off % 4 < 2)
> +			continue;

[Severity: Low]
The comment above says the last word only needs the right sequence number
because XDP_ADJUST_TAIL_GROW rewrites it. Unlike the zero-byte check just
above it, though, this skip is not gated on grow.

xsk_xdp_adjust_tail() only rewrites the last word, leaving pkt_nb as zero,
when the packet grew.

Doesn't this leave the pkt_nb bytes of the last payload word unchecked for
every drv layout packet, even when test->adjust_grow is 0? Should this
skip depend on grow, as the comment suggests?

[ ... ]

> @@ -1050,46 +1151,74 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)

[ ... ]

> +			count_drv_shared(umem, batch_chunks, batch_n++, addr);

[ ... ]

>  	if (nb_frags) {
>  		/* In the middle of a packet. Start over from beginning of packet. */
>  		idx_rx -= nb_frags;
>  		xsk_ring_cons__cancel(&xsk->rx, nb_frags);
> -		if (ifobj->use_fill_ring) {
> +		if (ifobj->use_fill_ring && !opt_drv_layout) {
>  			idx_fq -= nb_frags;
>  			xsk_ring_prod__cancel(&umem->fq, nb_frags);
>  		}
>  		frags_processed -= nb_frags;
> +		fills -= pkt_fills;
>  		pkt_stream_cancel(pkt_stream);
>  		pkts_sent--;
>  	}

[Severity: Low]
fills is rolled back here. Should drv_rx_descs and drv_rx_shared be
rolled back too?

count_drv_shared() has already counted each data descriptor of the
partial packet. After xsk_ring_cons__cancel(), the next __receive_pkts()
call peeks the same descriptors and counts them again.

Every -D socket uses XDP_USE_SG, so packets that span RX batches seem
likely. Wouldn't that inflate the "rx descs" and "in a chunk shared within
an RX batch" totals printed by run_pkt_test()? The extra counts would come
from batching, not from how the device splits chunks.

[ ... ]

> @@ -1789,12 +1948,32 @@ static void clean_umem(struct test_spec *test, struct ifobject *ifobj1, struct i
>  		testapp_clean_xsk_umem(ifobj2);
>  }
>  
> +/* UMEM in the device's buffer layout: page chunks, no headroom */
> +static bool drv_layout(struct test_spec *test)
> +{
> +	return opt_drv_layout && test->mode == TEST_MODE_DRV;
> +}
> +
> +static bool drv_layout_umem_ok(struct ifobject *ifobj)
> +{
> +	struct xsk_umem_info *umem = ifobj->xsk->umem;
> +
> +	return umem->frame_size == getpagesize() && !umem->frame_headroom &&
> +	       !umem->unaligned_mode;
> +}

[Severity: Low]
__test_spec_init() always sets the frame size to 4096, and drv layout
runs do not change it:

		ifobj->xsk->umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;

On 16K or 64K page kernels, wouldn't drv_layout_umem_ok() then be false
for every test, so -D gives no coverage there?

The commit message says only the tests that need "other chunk sizes or
headroom" are skipped. Could drv layout runs set frame_size to
getpagesize(), or could the 4K page restriction be documented?

>  static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj1,
>  				      struct ifobject *ifobj2)
>  {
>  	pthread_t t0, t1;
>  	int err;
>  
> +	if (drv_layout(test) && (!drv_layout_umem_ok(ifobj1) ||
> +				 (ifobj2 && !drv_layout_umem_ok(ifobj2)))) {
> +		ksft_print_msg("drv layout needs page chunks without headroom\n");
> +		return TEST_SKIP;
> +	}

[Severity: Medium]
This pre-check covers chunk size and headroom. Should it also compare the
UMEM size with the device's page pool?

xsk_sink_init() rejects a page pool that is not well below the chunk
count:

	if (pp->p.pool_size + PP_ALLOC_CACHE_SIZE >= sink->area.num_niovs)
		return -ENOSPC;

Drv layout runs keep DEFAULT_UMEM_BUFFERS (1024) chunks, or 2048 with a
shared UMEM. Some configurations would hit this limit:

- mlx5 legacy RQs use pool_size = 1 << log_rq_mtu_frames, which is 1024
  at the default ring size.
- bnxt adds the agg ring fill level to the pool size.
- testapp_hw_sw_max_ring_size() raises rx_pending to rx_max_pending,
  while num_frames only grows to max_descs.

The page pool is created in netif_mp_open_rxq() during bind, so the
-ENOSPC comes back from xsk_socket__create(). thread_common_ops() then
fails and the test reports FAIL rather than SKIP.

Could this give false FAILs on such devices, with no hint that the UMEM is
too small for the device rings?

[ ... ]

> @@ -2013,6 +2205,12 @@ int testapp_stats_rx_full(struct test_spec *test)
>  {
>  	struct pkt_stream *tmp;
>  
> +	/* Empty descriptors that give chunks back take RX slots too */
> +	if (drv_layout(test)) {
> +		ksft_print_msg("RX slots are not all packets in drv layout\n");
> +		return TEST_SKIP;
> +	}
> +

[Severity: Medium]
The comment above says a test without the fill ring wants FILL to run
dry, so it fills after bind as before. Does testapp_stats_fill_empty()
actually work in drv layout?

testapp_stats_fill_empty() clears use_fill_ring and sends
DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2 packets. It then
expects exactly DEFAULT_UMEM_BUFFERS of them, in order. That assumes
one chunk per packet and no recycling.

With fill_first false here, xsk_configure() binds and xsk_sink_bind()
calls netif_mp_open_rxq() while FILL is still empty:

- On bnxt, bnxt_queue_mem_alloc() fills the RX ring during the queue
  restart. With nothing on FILL it posts no buffers, and the ring is
  only refilled from bnxt_rx_pkt() on a completion. Wouldn't
  receive_pkts() then wait until THREAD_TMOUT, even after
  xsk_populate_fill_ring() has run?
- On other drivers, the empty FILL at queue start can bump
  rx_fill_ring_empty_descs before any traffic. validate_fill_empty()
  could then pass for the wrong reason.

Populating FILL before bind would not seem to fix it either. In this
layout 1024 chunks are not 1024 packets, which is the same reason
testapp_stats_rx_full() is skipped:

- Chunks also sit in payload or agg rings and in the page pool cache,
  so fewer packets get through.
- A device such as fbnic packs several 64-byte frames into one 4K
  chunk, so all 1536 frames fit and FILL never runs dry.
  pkt_stream_get_next_rx_pkt() then returns NULL, and the test fails
  with "received too many packets".

Should testapp_stats_fill_empty() be skipped under drv_layout(), the
same way testapp_stats_rx_full() is?

[Severity: Medium]
The commit message says tests that need "an RX descriptor per packet" are
skipped. Should testapp_hw_sw_min_ring_size() be skipped as well? It
sets:

	test->ifobj_rx->xsk->batch_size = 1;

Under -D every socket binds with XDP_USE_SG. xsk_sink_rcv() writes one RX
descriptor per buffer, with XDP_PKT_CONTD on all but the last.

Suppose the device delivers a frame in two or more buffers:

- __receive_pkts() peeks one descriptor, sees XDP_PKT_CONTD, and leaves
  the loop with nb_frags == 1.
- The partial-packet block cancels it, so frags_processed is 0 and
  nothing is released.

Wouldn't each later call peek the same descriptor again, until
receive_pkts() hits THREAD_TMOUT and reports "Receive loop timed out"?

Whether 64-byte frames are split depends on the device. fbnic, for
example, splits all frames when hds_thresh is set below
FBNIC_HDR_BYTES_MIN.

[ ... ]

> @@ -1050,46 +1151,74 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)
>  		print_verbose("Rx: addr: %lx len: %u options: %u pkt_nb: %u valid: %u\n",
>  			      addr, desc->len, desc->options, pkt->pkt_nb, pkt->valid);
>  
> -		if (!is_frag_valid(umem, addr, desc->len, pkt->pkt_nb, pkt_len) ||
> -		    !is_offset_correct(umem, pkt, addr) || (ifobj->use_metadata &&
> -		    !is_metadata_correct(pkt, umem->buffer, addr)))
> +		if (opt_drv_layout) {
> +			/* The device picks offsets; metadata precedes the
> +			 * head
> +			 */
> +			if (!is_frag_valid_drv(umem, addr, desc->len,
> +					       pkt->pkt_nb, pkt_len,
> +					       pkt->len, test->adjust_grow) ||
> +			    (ifobj->use_metadata && !nb_frags &&
> +			     !is_metadata_correct(pkt, umem->buffer, addr)))
> +				return TEST_FAILURE;
> +			count_drv_shared(umem, batch_chunks, batch_n++, addr);
> +		} else if (!is_frag_valid(umem, addr, desc->len, pkt->pkt_nb,
> +					  pkt_len) ||
> +			   !is_offset_correct(umem, pkt, addr) ||
> +			   (ifobj->use_metadata &&
> +			    !is_metadata_correct(pkt, umem->buffer, addr))) {
>  			return TEST_FAILURE;
> +		}
>  
>  		if (!nb_frags++)
>  			first_addr = addr;
>  		frags_processed++;
>  		pkt_len += desc->len;
> -		if (ifobj->use_fill_ring)
> +		if (!ifobj->use_fill_ring) {
> +		} else if (!opt_drv_layout) {
>  			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
> +		} else if (desc->options & XDP_RX_CHUNK_FREE) {
> +			/* Driver layout: only a free chunk goes back to FILL */
> +			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) =
> +				orig - orig % umem->frame_size;
> +			fills++;
> +			pkt_fills++;
> +		}
>  
>  		if (pkt_continues(desc->options))
>  			continue;
>  
>  		/* The complete packet has been received */
>  		if (!is_pkt_valid(pkt, umem->buffer, first_addr, pkt_len) ||
> -		    !is_offset_correct(umem, pkt, addr))
> +		    (!opt_drv_layout && !is_offset_correct(umem, pkt, addr)))
>  			return TEST_FAILURE;
>  
>  		pkt_stream->nb_rx_pkts++;
>  		nb_frags = 0;
>  		pkt_len = 0;
> +		pkt_fills = 0;
>  	}
>  
>  	if (nb_frags) {
>  		/* In the middle of a packet. Start over from beginning of packet. */
>  		idx_rx -= nb_frags;
>  		xsk_ring_cons__cancel(&xsk->rx, nb_frags);
> -		if (ifobj->use_fill_ring) {
> +		if (ifobj->use_fill_ring && !opt_drv_layout) {
>  			idx_fq -= nb_frags;
>  			xsk_ring_prod__cancel(&umem->fq, nb_frags);
>  		}
>  		frags_processed -= nb_frags;
> +		fills -= pkt_fills;
>  		pkt_stream_cancel(pkt_stream);
>  		pkts_sent--;
>  	}
>  
> -	if (ifobj->use_fill_ring)
> +	if (ifobj->use_fill_ring && opt_drv_layout) {
> +		xsk_ring_prod__cancel(&umem->fq, rcvd - fills);
> +		xsk_ring_prod__submit(&umem->fq, fills);
> +	} else if (ifobj->use_fill_ring) {
>  		xsk_ring_prod__submit(&umem->fq, frags_processed);
> +	}
>  	if (ifobj->release_rx)
>  		xsk_ring_cons__release(&xsk->rx, frags_processed);
>  

[Severity: Medium]
__receive_pkts() still reserves rcvd FILL slots before it walks the RX
descriptors, and retries xsk_ring_prod__reserve() until it gets all of
them. In drv layout only descriptors carrying XDP_RX_CHUNK_FREE produce
a FILL entry, so fills can be well below rcvd. The surplus is only
cancelled here at the end.

Can that up-front reservation spin forever when several descriptors
share a chunk?

testapp_hw_sw_max_ring_size() sets num_frames and fill_size to
max_descs, and fill_first puts every chunk on FILL before bind. The
free FILL slots are then just the chunks the device has taken and not
yet had returned. If the device packs several frames into one chunk, a
single peeked batch can hold more descriptors than chunks consumed.
Reserving rcvd slots would then never succeed.

FILL is nearly full in that state, so xsk_ring_prod__needs_wakeup()
stays false and the loop never polls. The device will not take more
chunks while the descriptors wait to be released, and the loop has no
timeout. So receive_pkts() never gets to its THREAD_TMOUT check.

In drv layout, would it be better to count the XDP_RX_CHUNK_FREE
descriptors of the batch first and reserve only that many, or to
reserve after the scan?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
