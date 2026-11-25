Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611619;
	b=Du3h/aAN7bwJUdW/2HOK0RAmvEzIc2U4S/3Mvt8XfCw6JLhZBjhRGNRHNOeypmKDBfLJ
	 rKSGlB0WtssabzJud9jPBR1Vo++h8y0QXZy7Ww7pK9I3mr0nQ7M48IPiqGAY7SU5dBIJh
	 v+yyZsBKAAlYFTlCqxJoIUnqwpcn0MDAqA0DUogLIOt6p9jrwn2hHFWSLKB3DJgVV+L1Z
	 MGEJzk1YB28EYWjux7sFI4CxkGKMCOmPZC47LipiXdQ6DDZ8zVLSP4dACaVEvXe2gBEzk
	 /qwt2iaO6lU+FpSnjfXoSCK6tO2miMAfX+9Qq978tZfCBWCoZKcLM6/PpGaJvPsCZhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611619;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DSUYvN1ahX4LsDGMaNKmleBLOOVV36gVBGqPw4ZEYE0=;
	b=m9uQSLe/Ii/xlD5Tozx/6yiBo0VKMC71Nd/oB9NQERX2r9+/n9IvctGOaGvykvpKaY/P
	 D/jLo2rKYI8fFECbAutsG9jDbCSN7eOy2jfnfT7vL9m4evzPjKtgpF4PSAqySz2r/gGl3
	 X9tgAZAuBarNhB+R6rXHuQ8BBF9xp5PnIWO9EJlDQVQKma9I4PXrp9zBs3Qg6mNovcdJT
	 RIwBXDls7EqLmbxyBheFGA5IlfzmBYgrt5zh/kgnIClk6OCOrFCr0YNYbo7xI7Q9cfeN7
	 VrMMKqWh0vE0GtM3g/vJJE2k+CY8iGLq2lbv0WmuqdGkrn3HVPTqPfMPMyLXX8SQ8VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyaKYdrQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0793160A2614;
	Wed, 25 Nov 2026 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyaKYdrQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5901F000EC;
	Wed, 25 Nov 2026 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611618;
	bh=DSUYvN1ahX4LsDGMaNKmleBLOOVV36gVBGqPw4ZEYE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iyaKYdrQCQoPC32+eMpyDfu102ENOLSaUZGhgNx9KsTLlv/clzwjq2cJIGkU7GMUf
	 p0lXmwuqq5OgCLCQT0k37zxawEaps7J9u36sX4IPpHITtgw9OPIuA3Q0hV5Dzm7kgA
	 dh/1ZaqdiZDcUUMDdwT0naClOan3jUZPH4CqUY+X6Wz4zCsKSlYZeJYfGkZZpz9nHK
	 AlJjM0+2yukqnMgmyaLj8dUEQC3A1jGzVSJFaaU8ugBjXEFV6K7w43WiRCWCZZM5LK
	 /3EHJ6yD2JpOOVRVZNcbBCsa60vg/Mj1cRZVRQxi7NGj9cZtckHyrZAK/k2MV7BJ4K
	 w3IhOwHJFxo4A==
Message-ID: <sashiko-outbox-233424@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 14/15] selftests: net: xsk: Test the device's
 RX buffer layout
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-14-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-14-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:18 +0000
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
- [Medium] selftests: net: xsk: XDP_UMEM_DRV_LAYOUT set on TX-only and
  ZC-probe UMEMs
- [Medium] selftests: net: xsk: is_frag_valid_drv() skips zeroed last
  word seqnum check
- [Medium] selftests: net: xsk: __receive_pkts() infinite spin reserving
  rcvd FILL slots
- [Medium] selftests: net: xsk: testapp_stats_fill_empty() fails in drv
  layout mode
- [Low] selftests: net: xsk: livelock in __receive_pkts() when
  batch_size is 1
--

commit 505282853476bb5b9e8a5968f2d816c8a8b08570
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

selftests: net: xsk: Test the device's RX buffer layout

This commit adds the -D (--drv-layout) option to xskxceiver to test
AF_XDP UMEMs registered with XDP_UMEM_DRV_LAYOUT in driver mode.

> diff --git a/tools/testing/selftests/net/lib/xsk/test_xsk.c b/tools/testi=
ng/selftests/net/lib/xsk/test_xsk.c
> index ca161511f1e5f..bae503432eeb3 100644
> --- a/tools/testing/selftests/net/lib/xsk/test_xsk.c
> +++ b/tools/testing/selftests/net/lib/xsk/test_xsk.c
[ ... ]
> @@ -94,6 +99,8 @@ int xsk_configure_umem(struct ifobject *ifobj, struct x=
sk_umem_info *umem, void
> =20
>  	if (umem->unaligned_mode)
>  		cfg.flags |=3D XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> +	if (opt_drv_layout)
> +		cfg.flags |=3D XDP_UMEM_DRV_LAYOUT;
> =20
>  	ret =3D xsk_umem__create(&umem->umem, buffer, size,
>  			       &umem->fq, &umem->cq, &cfg);

[Severity: Medium]
Should XDP_UMEM_DRV_LAYOUT (and the corresponding bind flags in
xsk_configure_socket() and test_init()) only be set when ifobj->rx_on is
true?

When xskxceiver is run with two distinct interfaces (-i tx_if -i rx_if
-D), ifobj_tx does not share a UMEM with ifobj_rx and has rx_on set to
false.  Setting XDP_UMEM_DRV_LAYOUT on ifobj_tx's TX-only UMEM causes
xp_assign_dev() to call xsk_sink_bind() on ifobj_tx RX queue 0 with an
unpopulated FILL ring, and when clean_sockets() closes that TX-only
socket, xsk_sink_release() defers unbinding to xp_release_deferred()
because sink->xs is NULL, which races with xsk_reattach_xdp() in later
tests and fails with -EBUSY.

In addition, at startup main() calls ifobj_zc_avail() ->
xsk_configure_umem() while rx_on is still false and frame_size is
hardcoded to 4096, so on kernels with PAGE_SIZE !=3D 4096 xdp_umem_reg()
returns -EINVAL and ifobj_zc_avail() aborts the binary via
exit_with_error() before drv_layout_umem_ok() can skip the tests.

> @@ -161,7 +168,8 @@ int xsk_configure_socket(struct xsk_socket_info *xsk,=
 struct xsk_umem_info *umem
>  	cfg.bind_flags =3D ifobject->bind_flags;
>  	if (shared)
>  		cfg.bind_flags |=3D XDP_SHARED_UMEM;
> -	if (ifobject->mtu > MAX_ETH_PKT_SIZE)
> +	/* The device may split any frame, see XDP_UMEM_DRV_LAYOUT */
> +	if (ifobject->mtu > MAX_ETH_PKT_SIZE || opt_drv_layout)
>  		cfg.bind_flags |=3D XDP_USE_SG;
>  	if (umem->comp_size)
>  		cfg.tx_size =3D umem->comp_size;

[Severity: Low]
Can testapp_hw_sw_min_ring_size() livelock in __receive_pkts() when a
device splits a frame across two or more RX descriptors in
opt_drv_layout mode?

testapp_hw_sw_min_ring_size() sets test->ifobj_rx->xsk->batch_size to 1.
When a received frame is split across multiple RX descriptors (for
example, header-data split), xsk_ring_cons__peek(&xsk->rx,
xsk->batch_size, &idx_rx) in __receive_pkts() peeks only the first
descriptor (with XDP_PKT_CONTD set), and the if (nb_frags) rollback
block cancels that descriptor on every call until receive_pkts() times
out.

[ ... ]

> @@ -878,6 +887,77 @@ static bool is_frag_valid(struct xsk_umem_info *umem=
, u64 addr, u32 len, u32 exp
>  	return false;
>  }
> =20
> +/* Driver layout: a buffer may start and end anywhere in the packet, and
> + * anywhere in its chunk. Check its bytes against the generated pattern =
by
> + * packet offset. XDP_ADJUST_TAIL_GROW zeroes the last @grow bytes and
> + * writes the sequence number of the last word, so that word only needs =
the
> + * right sequence number, and the bytes before it may be zero.
> + */
> +static bool is_frag_valid_drv(struct xsk_umem_info *umem, u64 addr, u32 =
len,
> +			      u32 expected_pkt_nb, u32 bytes_processed,
> +			      u32 pkt_len, u32 grow)
> +{
> +	u32 payload_end =3D PKT_HDR_SIZE + ((pkt_len - PKT_HDR_SIZE) & ~3U);
> +	u8 *bytes =3D xsk_umem__get_data(umem->buffer, addr);
> +	u64 umem_sz =3D umem_size(umem);
> +	u32 i, off, word;
> +
> +	addr -=3D umem->base_addr;
> +	if (addr >=3D umem_sz || addr + len > umem_sz ||
> +	    addr % umem->frame_size + len > umem->frame_size) {
> +		ksft_print_msg("Frag invalid addr: %llx len: %u\n",
> +			       (unsigned long long)addr, len);
> +		return false;
> +	}
> +
> +	for (i =3D 0; i < len; i++) {
> +		off =3D bytes_processed + i;
> +		if (off < PKT_HDR_SIZE || off >=3D payload_end)
> +			continue;
> +		if (off >=3D pkt_len - grow && !bytes[i])
> +			continue;
> +
> +		off -=3D PKT_HDR_SIZE;
> +		word =3D htonl(expected_pkt_nb << 16 | (off / 4));
> +		if (off / 4 =3D=3D (payload_end - PKT_HDR_SIZE) / 4 - 1 &&
> +		    off % 4 < 2)
> +			continue;

[Severity: Medium]
Does the zero-byte exemption in is_frag_valid_drv() also skip checking
the sequence number in the last 4-byte word when those bytes are zero?

Because the final word at [payload_end - 4, payload_end) also satisfies
off >=3D pkt_len - grow when grow >=3D 4, an all-zero final word where
xsk_xdp_adjust_tail() never wrote seq_num (or wrote zero bytes in the
wrong positions) satisfies !bytes[i] and passes validation.  Also, the
off % 4 < 2 check on the last word is not gated on grow > 0, so the
upper 16 bits (expected_pkt_nb) of the last payload word are never
checked when grow =3D=3D 0.

[ ... ]

> @@ -1050,46 +1151,74 @@ static int __receive_pkts(struct test_spec *test,=
 struct xsk_socket_info *xsk)
[ ... ]
>  	if (nb_frags) {
>  		/* In the middle of a packet. Start over from beginning of packet. */
>  		idx_rx -=3D nb_frags;
>  		xsk_ring_cons__cancel(&xsk->rx, nb_frags);
> -		if (ifobj->use_fill_ring) {
> +		if (ifobj->use_fill_ring && !opt_drv_layout) {
>  			idx_fq -=3D nb_frags;
>  			xsk_ring_prod__cancel(&umem->fq, nb_frags);
>  		}
>  		frags_processed -=3D nb_frags;
> +		fills -=3D pkt_fills;
>  		pkt_stream_cancel(pkt_stream);
>  		pkts_sent--;
>  	}
> =20
> -	if (ifobj->use_fill_ring)
> +	if (ifobj->use_fill_ring && opt_drv_layout) {
> +		xsk_ring_prod__cancel(&umem->fq, rcvd - fills);
> +		xsk_ring_prod__submit(&umem->fq, fills);
> +	} else if (ifobj->use_fill_ring) {
>  		xsk_ring_prod__submit(&umem->fq, frags_processed);
> +	}

[Severity: Medium]
Can __receive_pkts() spin forever reserving rcvd slots in umem->fq when
multiple RX descriptors share UMEM chunks?

Before this loop, __receive_pkts() reserves rcvd entries in umem->fq:

tools/testing/selftests/net/lib/xsk/test_xsk.c:__receive_pkts() {
	if (ifobj->use_fill_ring) {
		ret =3D xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
		while (ret !=3D rcvd) {
			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
				ret =3D poll(&fds, 1, POLL_TMOUT);
				if (ret < 0)
					return TEST_FAILURE;
			}
			ret =3D xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
		}
	}
}

In testapp_hw_sw_max_ring_size(), umem->num_frames and umem->fill_size
are both set to max_descs (8192), so xsk_populate_fill_ring() fills all
8192 slots of umem->fq before bind().  When the device packs multiple
buffers into each page-sized chunk, C chunks consumed from umem->fq can
produce rcvd > C RX descriptors while leaving only C free slots in
umem->fq, so xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq) returns 0
and the while (ret !=3D rcvd) loop spins forever.

[ ... ]

> @@ -1600,6 +1742,21 @@ static int thread_common_ops(struct test_spec *tes=
t, struct ifobject *ifobject)
>  	if (ret)
>  		return ret;
> =20
> +	/* In the device's buffer layout, the queue takes its first buffers
> +	 * from FILL when bind starts it: fill FILL first, or the first
> +	 * packets find no buffer. A test without the fill ring wants FILL
> +	 * to run dry, so it fills after bind as before.
> +	 */
> +	fill_first =3D opt_drv_layout && test->mode =3D=3D TEST_MODE_DRV &&
> +		     ifobject->rx_on && ifobject->use_fill_ring;
> +	if (fill_first) {
> +		ret =3D xsk_populate_fill_ring(umem,
> +					     ifobject->xsk_arr[0].pkt_stream,
> +					     ifobject->use_fill_ring);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	ret =3D xsk_configure(test, ifobject, umem, false);

[Severity: Medium]
Does testapp_stats_fill_empty() work in drv_layout(test) mode, or should
it be skipped like testapp_stats_rx_full()?

In testapp_stats_fill_empty(), use_fill_ring is false, so fill_first is
false and xsk_configure() starts the RX queue via netif_mp_open_rxq()
while the FILL ring is empty.  On drivers such as bnxt that allocate RX
ring buffers during netif_mp_open_rxq() and only allocate replacement
buffers on RX packet completions, starting the queue with an empty FILL
ring leaves 0 buffers posted to hardware and receive_pkts() hangs until
timeout.

Even if the 1024 initial chunks were populated before bind, 1024 page
chunks in XDP_UMEM_DRV_LAYOUT mode do not map 1:1 to 1024 received
packets without FILL recycling: chunks are held in secondary rings and
the RX ring itself, while devices that pack multiple 64-byte packets per
4 KiB chunk can receive more than the expected 1024 packets in a batch
and fail in __receive_pkts().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D14
