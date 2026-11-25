Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611612;
	b=OPRyStkQkr/gvneAghvcZBjhOmEVEzLNb0AkdNEgoHI4U6sF9R3ft8GE/VJbbiSQYdgd
	 N5H62Rg3UEvfe8qyzN3jTkZ1eOivb5EYMoA08bxNucXpzRCGH+IC9qmXfa/3GaLRjk4TW
	 e1cDaFPPCpbsfH9gRb+xJnjADbllpA5Ha7QhDqxLMK5EMuFnJ/82zwi42h5QrsG2Agtav
	 GEM6ljqDGTlenKF3egYES5/f8hIdNURxs/kkOEG3ZLTsBwmJtnel/3aOb+awXZJkNfUM6
	 r1bfQLw3bM9h4NFSe+Imm4odMMNe6qHD5H6iXCeQWm0rjbiRe82Vvy3c8sY01nmWbbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611612;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UCJQQAwUv7EjIGphmNS2tq+U0M54aJMj9FLtLPAoriM=;
	b=3NmcyEkkEHADqW4/Y66i5XKh6ZnGny9IKYI1CttL7vCz3cFPV3nITfI7YW64JfGHq/Aw
	 sat0Vh5ZgaLlef0a1qiq5UfdKkCh/tK+hwtEAipgEa2F0qIm8kBHVcDkkqhFG2dgqzZ+W
	 KzusjuFQrYrKlWPb4IACPZhjAIcclr2UpRwflLHSfWh8G2wNqvGVEJDXcNt+hkvOLN2Y4
	 Rv0Na55A2Hmje27wcJfSTNVRIxkngS6cOYmFt59Csn4MUcON7NF+2tLE9q6WNEnHvoG9F
	 AsENi7ruhGIJTJfxIa+9pLMJLJBk6qOncY8ydwR/9KCe5h5Wfu/nks85BTLri6m3F9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZAJbl4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDEF606A329;
	Wed, 25 Nov 2026 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZAJbl4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263BB1F000CF;
	Wed, 25 Nov 2026 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611612;
	bh=UCJQQAwUv7EjIGphmNS2tq+U0M54aJMj9FLtLPAoriM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aZAJbl4BjsMmzrSeyCmDtkmQrbcGvDazUPUm+NDsCb2bXP2Mnu48S2ye+vm3o4mpW
	 PdQ2D2L3BTE3qAvphs1mCtvjZ+eYX1K3Y8WV/G7tpuzRgubnOPtlo3TyYUCuo7/SI7
	 iCRRshvgD0M1eRQeIPko4Jnqc9laPX7FoOOIbkUqaqUBZ46OczdWEXPbLqYpK2dkqO
	 6Z3U/Z/jYdMirHqEmJnSCwYfb95GVpn2QG4S/bu5nxyjdnOwQtMGWfad6VNOoSgGEK
	 yFe0+Ao1wa3S3fcXr22/U1J6K19P5dIlfgybBpk6c3arDODeCB3UpTbExaNfOUTt+C
	 YMjcL4XC7sN0Q==
Message-ID: <sashiko-outbox-233416@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 06/15] xsk: Lend UMEM chunks to the page pools
 of a queue
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-6-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-6-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] xsk: per-queue DMA device mismatch in xsk_sink_bind() and
  xp_find_dma_map()
- [High] xsk: xsk_sink_take_fill() recycles old-pool chunks instead of
  releasing them
- [Medium] xsk: xp_assign_dev() blocks standard zero-copy when
  MP_XDP_ONLY is active
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [High] xsk: DMA mapping leak in __xp_dma_unmap() when IOVA is 0 [1]
- [Critical] xsk: false match in xp_find_dma_map() due to dangling
  netdev pointer [2]
--

commit 58bc067256d91ca8a9a5c3294236af1fb45e76be
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

xsk: Lend UMEM chunks to the page pools of a queue

This commit adds the XDP_UMEM_DRV_LAYOUT flag and a page pool memory
provider (xsk_sink) so an AF_XDP socket can lend page-sized UMEM chunks to
the page pools of a bound RX queue.

> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 5ec092f7cb6f7..7ece7d9e39376 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
[ ... ]
> @@ -211,6 +215,13 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>  	 */
>  	hlist_add_head(&pool->dev_node, &netdev->xsk_pools);
> =20
> +	if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
> +		err =3D xsk_sink_bind(pool, netdev, queue_id, flags);
> +		if (err)
> +			goto err_unbind;
> +		return 0;
> +	}
> +
>  	if (force_copy)
>  		/* For copy-mode, we are done. */
>  		return 0;

[Severity: Medium]
Once xsk_sink_bind() installs the MP_XDP_ONLY provider on a queue,
dev_get_min_mp_channel_count(netdev) returns non-zero for the whole
net_device.  Because xp_assign_dev() still checks
dev_get_min_mp_channel_count(netdev) rather than dev_mp_blocks_xdp(netdev)
further down, does binding an XDP_UMEM_DRV_LAYOUT socket on one queue
cause standard AF_XDP sockets on other queues of the same device to fail
with -EBUSY or silently fall back to copy mode?

[ ... ]

> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
> new file mode 100644
> index 0000000000000..b78116f25e712
> --- /dev/null
> +++ b/net/xdp/xsk_sink.c
> @@ -0,0 +1,416 @@
[ ... ]
> +static u32 xsk_sink_take_fill(struct xsk_sink *sink, struct page_pool *p=
p)
> +{
[ ... ]
> +	for (i =3D 0; i < entries; i++) {
> +		addr =3D ring->desc[(cons + i) & mask];
> +		niov =3D &niovs[array_index_nospec((u32)(addr >> PAGE_SHIFT),
> +						 nr)];
> +		/* A chunk lent twice would be in two places at once */
> +		if (unlikely(addr >=3D (u64)nr << PAGE_SHIFT ||
> +			     READ_ONCE(niov->mp_state) =3D=3D XSK_SINK_LENT)) {
> +			fq->invalid_descs++;
> +			continue;
> +		}
> +
> +		WRITE_ONCE(niov->mp_state, XSK_SINK_LENT);
> +		netmem =3D net_iov_to_netmem(niov);
> +		owner =3D netmem_get_pp(netmem);
> +		if (owner && owner !=3D pp) {
> +			page_pool_put_unrefed_netmem(owner, netmem, -1, false);
> +			continue;
> +		}
> +		if (!owner)
> +			net_mp_niov_set_page_pool(pp, niov);
> +		pp->alloc.cache[n++] =3D netmem;
> +	}

[Severity: High]
When a chunk in the FILL ring still belongs to an earlier page pool
(owner !=3D pp), does calling page_pool_put_unrefed_netmem(owner, ...)
recycle the chunk into owner->ring instead of releasing it onto
sink->released?

net/core/page_pool.c:page_pool_put_unrefed_netmem() {
	...
	netmem =3D __page_pool_put_page(pool, netmem, dma_sync_size,
				      allow_direct);
	if (netmem && !page_pool_recycle_in_ring(pool, netmem)) {
		/* Cache full, fallback to free pages */
		recycle_stat_inc(pool, ring_full);
		page_pool_return_netmem(pool, netmem);
	}
}

Because __page_pool_page_can_be_recycled() is always true for a net_iov,
page_pool_put_unrefed_netmem() puts the chunk into owner->ring and only
calls page_pool_return_netmem() -> xsk_sink_release_netmem() when that
ring is full.  During netdev_rx_queue_reconfig(), ndo_queue_mem_alloc()
and ndo_queue_start() refill the new page pool before ndo_queue_mem_free()
destroys the old one, and even after page_pool_destroy(owner) runs, any
in-flight chunks keep owner alive in deferred release.  Refills on the new
pool will consume FILL descriptors and strand those chunks in the old
pool's ptr_ring instead of supplying buffers to pp.

Calling page_pool_return_netmem(owner, netmem) (or transferring the chunk
directly to pp after releasing it from owner) would avoid recycling into
the old pool.

[ ... ]

> +/* No queue DMAs to the UMEM any longer */
> +static void xsk_sink_stop(struct xsk_sink *sink)
> +{
> +	bool unmap;
> +
> +	spin_lock_bh(&sink->lock);
> +	WRITE_ONCE(sink->rxq, NULL);
> +	unmap =3D sink->fq;
> +	sink->fq =3D NULL;
> +	spin_unlock_bh(&sink->lock);
> +
> +	/* Wait for wakeups that found the sink or the queue */
> +	synchronize_net();
> +	if (unmap)
> +		xp_dma_unmap(sink->pool, XSK_SINK_DMA_ATTR);
> +}

[Severity: High]
This problem wasn't introduced by this patch, but xp_dma_unmap() ->
__xp_dma_unmap() checks if (*dma) before unmapping each entry [1],
can that leak DMA mappings when a page is assigned a valid IOVA of 0?

net/xdp/xsk_buff_pool.c:__xp_dma_unmap() {
	...
	for (i =3D 0; i < dma_map->dma_pages_cnt; i++) {
		dma =3D &dma_map->dma_pages[i];
		if (*dma) {
			*dma &=3D ~XSK_NEXT_PG_CONTIG_MASK;
			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
					     DMA_BIDIRECTIONAL, attrs);
			*dma =3D 0;
		}
	}
	...
}

On IOMMU or architecture configurations where 0 is a valid DMA address,
__xp_dma_unmap() skips dma_unmap_page_attrs() for that page, leaking the
mapping across pool teardown.

[ ... ]

> +int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
> +		  u16 queue_id, u16 flags)
> +{
[ ... ]
> +	/* The device of the queue's page pools, which may differ per queue */
> +	dma_dev =3D netdev_queue_get_dma_dev(dev, queue_id, NETDEV_QUEUE_TYPE_R=
X);
> +	if (!dma_dev)
> +		return -EOPNOTSUPP;
> +
> +	/* Without a program, drivers would build skbs from the buffers */
> +	if (!dev_xdp_drv_prog_held(dev))
> +		return -ENOENT;
> +
> +	err =3D xp_dma_map(pool, dma_dev, XSK_SINK_DMA_ATTR, pool->umem->pgs,
> +			 pool->umem->npgs);

[Severity: Critical]
This problem wasn't introduced by this patch, but xp_dma_map() looks up
existing mappings in xp_find_dma_map() by comparing raw dma_map->netdev =3D=
=3D
pool->netdev pointers without holding a netdev reference on
dma_map->netdev [2].  If the original net_device is freed while
the UMEM stays alive and a new net_device is allocated at the same address,
xp_find_dma_map() can match the dangling pointer and reuse stale DMA
addresses on the new device.

> +	if (err)
> +		return err;
> +
> +	sink =3D xsk_sink_create(pool, dma_dev);

[Severity: High]
When a UMEM is shared with XDP_SHARED_UMEM across two queues of the same
net_device that have different per-queue DMA devices, can xp_dma_map() and
xsk_sink_create() pair sink->dev with DMA addresses mapped for another
device?

net/xdp/xsk_buff_pool.c:xp_find_dma_map() {
	...
	list_for_each_entry(dma_map, &pool->umem->xsk_dma_list, list) {
		if (dma_map->netdev =3D=3D pool->netdev)
			return dma_map;
	}
}

xp_find_dma_map() checks only dma_map->netdev =3D=3D pool->netdev and does =
not
check that dma_map->dev matches dma_dev.  On a multi-DMA-device netdev,
binding a second shared-UMEM socket reuses the first queue's dma_pages
while xsk_sink_create(pool, dma_dev) sets sink->dev =3D dma_dev, so
xsk_sink_init() sees pp->p.dev =3D=3D sink->dev and the second queue perfor=
ms
DMA syncs and transfers with IOVAs mapped for the first queue's DMA
device.

[1] https://sashiko.dev/#/bug/linux-5e2b8325-f1ba-4785-8981-9032096f3c3f
[2] https://sashiko.dev/#/bug/linux-fb37d535-f34d-40eb-b2c2-d903fa118a91

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D6
