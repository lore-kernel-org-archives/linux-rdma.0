Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795636979;
	b=UiK1tHEUw50KTeVAG8pYv0oHCn2AgjME9SGY+t16ev8WKcMvZb9jh93H+mA5W7Fden1L
	 6zdjHaHjvKa+Eu55pwgkkGw9SoCx0lXOiDKbfqe5WIOdn3wttZBJHvAxGJdpYmA0YtL4J
	 8FqRuIVwMcPeL0h1bLjH7mMzwufATfsaIF2+kCIMlIN9TuYH5D9j/CMAMqyrbpgLFkSqy
	 c8h63QBvu/kj+TCZ6SBSl49vwQTlGIeN03xP+ZPkQkJYkYHHlq7E6E5rEIuMLzrFzvQ7e
	 AeWdH3nKqkU5gEb/6DjkT1HtQ+hnBLMKkkUvVNIye43yHvolB8WfgIpve1dT6Q96d4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795636979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NV3qax3E8dMyFntuLziYflS0O+a/VnhBgje6LaQOMxM=;
	b=LiYUhYiZ1lphylD7tO0dhAuc5SLr/jRXMmMCvvbLjr2XodrOPM3DjyRljxmSQmay/Dga
	 jvo+v9ObQ9reAb35ljCQCfUNQfM1Zpa1A/O7zloiqD2J9CUXqn0NoZZQAWItYp46FyE2O
	 3zMZ9jOed3eOvhDsvlH8YBMEagyNJiMNqN+AorWAyLVizA5Th4/96G1L2eNghwBOJT7Pe
	 pw+KRd5vvTUMqgbYJSHodL2NfUTdaRELeMbRg/D8fEmF0+LrNrI1nArXqAHyvHWzYN9XV
	 RkvpS+odSVwCerPBbbDRdnSXrpVrb6e4ve5FyjRGzwvebtoX2u+awcm21HsXZCMIlEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nySpZ5/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FE9606A32C;
	Wed, 25 Nov 2026 20:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nySpZ5/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313FD1F000C4;
	Wed, 25 Nov 2026 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795636978;
	bh=NV3qax3E8dMyFntuLziYflS0O+a/VnhBgje6LaQOMxM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=nySpZ5/MW6+gjcbBaeaWrhgIi8D48C1+VVcEGsZagwxO/eo2C0gGTOJnMz+N1CbDq
	 YPx4iCKqzaih8Sb847jrdY1J7c7xoYyRdY3irUMMAqnvHWsezNgcRtjXKeSuQrVdWP
	 LRCE4i5lj8HLFTpn8v5EbVl8NN3MJx4ZDjJud5Mr8j0r1JILUx63+84n4LvAw/pFih
	 o5GZXoRrUmfAs5KdlmhlgIinO67I2viMQSBSRtcCPykfqG9Z5qGZXrWB8p2mNvl0Nw
	 UT76ALR9rLcaSWyzJ5J+32No4XEAZC/sUX6+qpx2+A+f8VxAc83WpE2O9KDM8fIetf
	 rI/kh/72JPM6Q==
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
Subject: Re: [PATCH net-next 06/15] xsk: Lend UMEM chunks to the page pools
 of a queue
In-Reply-To: <179561569684.3135.6558736307763434214@kernel.org>
References: <20261124125654.183091-6-bjorn@kernel.org>
 <179561569684.3135.6558736307763434214@kernel.org>
Date: Wed, 25 Nov 2026 21:02:55 +0100
Message-ID: <87pkvsn0gg.fsf@all.your.base.are.belong.to.us>
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

> Thank you for your contribution! Sashiko AI review found 6 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 2 =C2=B7 Medium: 2 =C2=B7 Low: 2
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] When a DRV_LAYOUT UMEM is shared across two queues of one netdev
>   whose per-queue DMA devices differ, xsk_sink_bind() gives the second=E2=
=80=A6
> - [High] xsk: xsk_sink_take_fill() recycles old-pool chunks instead of
>   releasing them
> - [Medium] The 'chunk lent twice' check only works inside one sink, so a
>   UMEM shared across queues or devices with XDP_SHARED_UMEM gets around=
=E2=80=A6
> - [Medium] xsk: xp_assign_dev() blocks standard zero-copy when
>   MP_XDP_ONLY is active
> - [Low] A DRV_LAYOUT bind accepts XDP_ZEROCOPY but delivers neither zero-
>   copy TX nor a zero-copy report.
> - [Low] xsk_sink_nl_fill() returns 0 and emits no attribute, so a page
>   pool backed by an AF_XDP sink cannot be identified in page-pool-=E2=80=
=A6
>
> --
>
> xsk: Lend UMEM chunks to the page pools of a queue
>
> This adds a sink memory provider. With it, the chunks of a UMEM
> registered with XDP_UMEM_DRV_LAYOUT back the RX page pools of the bound
> queue, and the device lays out RX buffers in those chunks as it does in
> pages. FILL entries lend chunks to the kernel, the UMEM is DMA mapped
> once at bind, and binding requires a held native XDP program.
>
>> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
>> index 5ec092f7cb6f7..7ece7d9e39376 100644
>> --- a/net/xdp/xsk_buff_pool.c
>> +++ b/net/xdp/xsk_buff_pool.c
>
> [ ... ]
>
>> @@ -211,6 +215,13 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>>  	 */
>>  	hlist_add_head(&pool->dev_node, &netdev->xsk_pools);
>>=20=20
>> +	if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
>> +		err =3D xsk_sink_bind(pool, netdev, queue_id, flags);
>> +		if (err)
>> +			goto err_unbind;
>> +		return 0;
>> +	}
>
> [Severity: Medium]
> After xsk_sink_bind() installs the provider on one queue,
> dev_get_min_mp_channel_count() returns non-zero for the whole device.
> It checks mp_params.mp_priv on every RX queue and does not skip
> MP_XDP_ONLY providers. Further down, xp_assign_dev() still uses it to
> gate classic zero copy:
>
> 	if (dev_get_min_mp_channel_count(netdev)) {
> 		err =3D -EBUSY;
> 		goto err_unreg_pool;
> 	}
>
> So once a DRV_LAYOUT socket is bound to one queue, a regular AF_XDP
> socket on another queue of the same device fails with -EBUSY if it
> asked for XDP_ZEROCOPY. Without that flag it silently falls back to
> copy mode.
>
> Earlier in this series, dev_mp_blocks_xdp() replaced this helper in
> dev_xdp_install(), netif_xdp_propagate() and the ethtool rings path,
> because an MP_XDP_ONLY provider does not stop native XDP. Was this
> caller left out on purpose? If not, would dev_mp_blocks_xdp() be the
> right test here? A sink on the queue being bound is already caught by
> the earlier xsk_get_pool_from_qid() check, so the device-wide test
> only needs to catch providers that block XDP.

Not on purpose, will fix!

> [Severity: Low]
> This branch returns success without setting pool->umem->zc, so xsk_bind()
> ends up with xs->zc =3D false. Should a bind that passes XDP_ZEROCOPY be
> accepted here?
>
> xsk_sink_bind() rejects XDP_COPY but lets XDP_ZEROCOPY through:
>
> 	if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
>
> TX on such a socket still goes through xsk_generic_xmit(). Also,
> getsockopt(XDP_OPTIONS) sets XDP_OPTIONS_ZEROCOPY only when xs->zc is
> true, so it reports copy mode even though RX is zero copy through the
> page pool.
>
> So a bind that asks for forced zero copy succeeds, TX runs in copy mode,
> and XDP_OPTIONS says the socket is not zero copy. The documentation patch
> later in the series says these sockets transmit in copy mode. It does not
> say that XDP_ZEROCOPY is accepted or what XDP_OPTIONS reports. Both become
> uAPI once registration accepts the flag. Could this be made consistent,
> either by rejecting XDP_ZEROCOPY or by reporting the RX mode?

It should be rejected. Will fix.

> [ ... ]
>
>> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
>> new file mode 100644
>> index 0000000000000..b78116f25e712
>> --- /dev/null
>> +++ b/net/xdp/xsk_sink.c
>
> [ ... ]
>
>> +static u32 xsk_sink_take_fill(struct xsk_sink *sink, struct page_pool *=
pp)
>> +{
>
> [ ... ]
>
>> +	for (i =3D 0; i < entries; i++) {
>> +		addr =3D ring->desc[(cons + i) & mask];
>> +		niov =3D &niovs[array_index_nospec((u32)(addr >> PAGE_SHIFT),
>> +						 nr)];
>> +		/* A chunk lent twice would be in two places at once */
>> +		if (unlikely(addr >=3D (u64)nr << PAGE_SHIFT ||
>> +			     READ_ONCE(niov->mp_state) =3D=3D XSK_SINK_LENT)) {
>> +			fq->invalid_descs++;
>> +			continue;
>> +		}
>
> [Severity: High]
> Once the next patch hands chunks back to userspace while they stay
> attached to the page pool that received into them, can this branch
> starve a new page pool on a queue restart?
>
> netdev_rx_queue_reconfig() calls ndo_queue_mem_alloc() and, for most
> drivers, ndo_queue_start() before ndo_queue_mem_free() destroys the
> old page pool. When the new pool pp first refills, every chunk that
> userspace posts back on FILL still has the old pool as owner, and
> sink->released is still empty.
>
> For each such chunk, xsk_sink_take_fill() marks it XSK_SINK_LENT,
> consumes the FILL entry and calls page_pool_put_unrefed_netmem() on
> the old pool. For a net_iov, __page_pool_page_can_be_recycled() is
> always true, so the chunk lands in owner->alloc.cache or owner->ring.
> page_pool_return_netmem(), and with it xsk_sink_release_netmem(),
> runs only when that ring is full. The chunk never reaches
> sink->released.
>
> So xsk_sink_take_fill() can consume up to PP_ALLOC_CACHE_SIZE FILL
> entries and still return 0. xsk_sink_take_released() then finds
> nothing, and xsk_sink_alloc_netmems() returns 0 and bumps
> queue_empty_descs even though FILL was not empty. The driver's ring
> fill in ndo_queue_mem_alloc() or ndo_queue_start() can then fail, or
> the new queue comes up without buffers.
>
> After page_pool_destroy() runs on the old pool, the chunks still held
> by userspace keep it inflight. Its ring is then scrubbed only from
> page_pool_release_retry(), once every DEFER_TIME. Until that happens,
> each refill of the new pool keeps pushing FILL chunks into the ring
> of a pool that is going away.
>
> Should a chunk whose owner is not pp be released to the sink, or moved
> to pp directly, rather than recycled into the old pool? Once a new
> pool exists for the queue, does the old pool ever need these chunks
> back?

Hmm, I'll try to address this.

> [Severity: Medium]
> Does this check still hold when the UMEM is shared with XDP_SHARED_UMEM
> across queues or devices?
>
> xp_assign_dev_shared() now sends DRV_LAYOUT UMEMs into xp_assign_dev()
> with flags =3D 0. A socket that shares the UMEM on another queue or device
> gets its own xsk_buff_pool and its own FILL ring. Then
> xsk_sink_bind()->xsk_sink_create() allocates a separate niov array over
> the same umem->chunks:
>
> 	sink->area.niovs =3D kvcalloc(nr, sizeof(*niov), GFP_KERNEL_ACCOUNT);
>
> The mp_state checked here belongs only to this sink, and it is checked
> under this sink's lock. Suppose userspace posts the same chunk address on
> both FILL rings. Each sink sees XSK_SINK_USER and lends the chunk. Two RX
> queues then DMA into the same UMEM page, and both sockets later get that
> chunk back as free.
>
> The commit message says:
>
>   A chunk that is lent twice, or lies outside the UMEM, counts as an
>   invalid FILL entry, so userspace cannot make the device use a chunk
>   twice.
>
> Is this guarantee meant to cover the shared UMEM case? As far as I can
> tell, the end of the series refuses a second receiving socket only on the
> same pool. The cross-queue branch of xsk_bind() still creates a second,
> independent sink.

Partly. The check is per queue, but the kernel does not need more! Each
sink has its own net_iovs, so a chunk on two FILL rings leaves the
kernel state on both sinks consistent. Two devices then write the same
chunk, which only correupts the application's OWN data. The kernel keeps
nothing in the UMEM and takes no bounds from it.

Let's try to fix the commit message and af_xdp.rst to make it clearer.

> [ ... ]
>
>> +static int xsk_sink_nl_fill(void *mp_priv, struct sk_buff *rsp,
>> +			    struct netdev_rx_queue *rxq)
>> +{
>> +	return 0;
>> +}
>
> [Severity: Low]
> Should this emit an attribute that identifies the provider?
> page_pool_nl_fill() calls:
>
> 	if (pool->mp_ops && pool->mp_ops->nl_fill(pool->mp_priv, rsp, NULL))
>
> That call is the only way a page-pool dump says which memory provider
> backs a pool. In devmem, mp_dmabuf_devmem_nl_fill() emits
> NETDEV_A_PAGE_POOL_DMABUF and NETDEV_A_QUEUE_DMABUF, and io_uring zcrx
> emits its IO_URING nest.
>
> With this stub, a page pool backed by UMEM chunks looks like an ordinary
> pool in page-pool-get dumps. Queue dumps still show NETDEV_A_QUEUE_XSK
> through rxq->pool, but the page-pool side has nothing. The function is
> unchanged at the end of the series.

Maybe add an empty xsk nest?

> [ ... ]
>
>> +int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
>> +		  u16 queue_id, u16 flags)
>> +{
>
> [ ... ]
>
>> +	/* The device of the queue's page pools, which may differ per queue */
>> +	dma_dev =3D netdev_queue_get_dma_dev(dev, queue_id, NETDEV_QUEUE_TYPE_=
RX);
>> +	if (!dma_dev)
>> +		return -EOPNOTSUPP;
>> +
>> +	/* Without a program, drivers would build skbs from the buffers */
>> +	if (!dev_xdp_drv_prog_held(dev))
>> +		return -ENOENT;
>> +
>> +	err =3D xp_dma_map(pool, dma_dev, XSK_SINK_DMA_ATTR, pool->umem->pgs,
>> +			 pool->umem->npgs);
>
> [Severity: High]
> Can the second queue end up with IOVAs that were mapped for a different
> struct device here?
>
> Take a DRV_LAYOUT UMEM shared across two queues of one netdev.
> xp_dma_map() first calls xp_find_dma_map(), which matches only on the
> netdev:
>
> 	if (dma_map->netdev =3D=3D pool->netdev)
> 		return dma_map;
>
> xp_init_dma_info() then copies that map's dma_pages into the pool and
> sets pool->dev =3D dma_map->dev, which is the first queue's device. Nothi=
ng
> compares dma_dev with dma_map->dev.
>
> xsk_sink_create() builds every net_iov DMA address from
> pool->dma_pages[i], but stores sink->dev =3D dma_dev, the second queue's
> device. So this check in xsk_sink_init() passes:
>
> 	if (pp->p.dev !=3D sink->dev || pp->p.offset + pp->p.max_len > PAGE_SIZE)
>
> The second queue's page pool then posts IOVAs from the first device's
> mapping to the second device. xsk_sink_alloc_netmems() also calls
> dma_sync_single_range_for_device(pp->p.dev, ...) on addresses that
> pp->p.dev never mapped.
>
> mlx5e_queue_get_dma_dev() returns ch->pdev, which differs per channel on
> multi-PF and socket-direct NICs. The mlx5 patch later in this series lets
> mlx5 RQs use this provider.
>
> If the two functions sit in separate IOMMU domains, won't the second
> device DMA to IOVAs that are unmapped in its domain, or mapped to
> something else there?
>
> The devmem bind path already rejects queues whose DMA devices differ, for
> this reason. Should xsk_sink_bind() do the same?

Probably. I'll try to address it.

pw-bot: cr

