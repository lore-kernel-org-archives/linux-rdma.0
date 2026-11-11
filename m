Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422438;
	b=N07QN/QjYv24JK/jMpFVfV/y0xt4IAXj9Uacpo10sYAiWF9BjwTWi8sP9WzqLM0dytnt
	 xA1WL9vqA5OXqFq6JZPGPbYxfpWuz1i7a/r9lkmOpAPzm3S0TM1RhzWgNKV+sx5tjSk//
	 GA+misgVls6tHBkCcWeAo/X8QfYRCnnAG/jIo4CFR+0xWIgEnbiVK0Y6hlH1cW8pFqChr
	 hfyotEpigLAOZyh3l8njs5IXNQRwG9uO+dppJ8iC89P82sGsASF/lw+x0YPEqCNQ+8kIS
	 IJiqP0Gky8cl1zIEBpHL9u6GQnQnA4E38oTP8VCbwr02/Hja8cP7T2iitkgWwDOqKVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422438;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Y+abRssw5SinZcjZC4XYL+KaVKe1MuYPH6hCmeEotJU=;
	b=kePJwc01KZ0rBndTK8WNnLnJ75oiSkhllylGVLKHODHbnUEtE5YnJ8klL8D0a+7SgsBQ
	 lhW1yedntcbjHWYwv7FqLHf1fsbt5Xt+HbrbPONoOrMw8Vnlgn1cLDDnMRRYaoe71h/ig
	 vkgqvN21J7jRaXs9cev7OOScjpJb0CfpTCQA9i3CuFEzfA0iafo8ZPwp3EAPwHwrZfEYR
	 qQow08vNN23i141p3pgLrkmjSQM3S4cwOXvKuW8K3Y7IcgR3t1M/Y/evCP+hvYiMGXjTV
	 HXdR2ppKMY1ug6FtJFWHHTx0x4A01HCPrWan+Lx4XHX4H7URJeIE5op7q+U3q74m0dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFXf1wkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8E606A33E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFXf1wkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146661F00A06;
	Wed, 11 Nov 2026 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422438;
	bh=Y+abRssw5SinZcjZC4XYL+KaVKe1MuYPH6hCmeEotJU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VFXf1wkYdHkq45+9m3Z3QCgTpazZvlaZOAjFqLgDCWcltbWNRpe1TKmgMVRyDFanY
	 RNiT2dvEhEM/SczDfKQoFRhMV7k9om+p4C605yB1q5wMm1P1f+w1Z/C9XVii7rttV0
	 vN4olJa25L/c1fp/1cHycc+SDs6X5nR+IPsCU7OuNhMZNzldeoYkkUbQgMSo2DFt63
	 3e+j9PcXfgwWvx5UnAeozCyKf5iTR6tg+bHsys+8pxpDWqOiGMRK1ubjdqU6YWP29S
	 8X6OTsKNKx4VOPmscrAYE5PmrWmfYeCssgElkJ+P6aooWD8JC7rGUllDn8xfLmGaxc
	 /IwB9DkaAbBEA==
Message-ID: <sashiko-outbox-209479@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 11/13] net: add netdev_unbind_dma_dev()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-12-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-12-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] net: unmapping TX dmabufs on detached netdev in
  netdev_unbind_dma_dev()
- [Medium] net: race between netdev_unbind_dma_dev() and
  io_close_queue()
--

commit 3c773dc0f4402c3fc717479371e244f710ce138c
Author: Dragos Tatulea <dtatulea@nvidia.com>

net: add netdev_unbind_dma_dev() helper

This commit adds netdev_unbind_dma_dev() and net_devmem_unbind_dma_dev() to
uninstall RX memory providers and unmap TX devmem bindings associated with a
departing DMA device on a closed or detached netdev.

> diff --git a/net/core/netdev_queues.c b/net/core/netdev_queues.c
> index 27cb6397bdd4e..71cc7bfc087dd 100644
> --- a/net/core/netdev_queues.c
> +++ b/net/core/netdev_queues.c
[ ... ]
> +int netdev_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
> +{
> +	unsigned int i;
> +
> +	netdev_assert_locked(dev);
> +
> +	if (netif_running(dev) && netif_device_present(dev))
> +		return -EBUSY;

[Severity: High]
Can allowing netdev_unbind_dma_dev() on a running, detached netdev leave
validated devmem TX skbs queued in q->gso_skb after their dmabuf binding is
unmapped?

Unlike closing a netdev, netif_device_detach() only clears
__LINK_STATE_PRESENT and stops the TX queues without calling
dev_deactivate() or resetting q->gso_skb.  Any devmem TX skb that was
already validated by validate_xmit_unreadable_skb() and requeued onto
q->gso_skb when the queue stopped stays there while
net_devmem_unbind_dma_dev() unmaps the binding and clears binding->dev.

When netif_device_attach() later wakes the queues, dequeue_skb() pulls the
skb from q->gso_skb with *validate =3D false:

net/sched/sch_generic.c:dequeue_skb() {
    ...
		/* skb in gso_skb were already validated */
		*validate =3D false;
		if (xfrm_offload(skb))
			*validate =3D true;
		/* check the reason of requeuing without tx lock first */
		txq =3D skb_cap_tx_queue(q, skb);
		if (!netif_xmit_frozen_or_stopped(txq)) {
			skb =3D __skb_dequeue(&q->gso_skb);
    ...
}

sch_direct_xmit() then skips validate_xmit_skb_list() and passes the skb
with unmapped DMA addresses to ndo_start_xmit(), causing DMA to unmapped
memory or IOMMU faults.

> +
> +	for (i =3D 0; i < dev->real_num_rx_queues; i++) {
> +		struct netdev_rx_queue *rxq =3D __netif_get_rx_queue(dev, i);
> +		struct pp_memory_provider_params p =3D rxq->mp_params;
> +		struct device *queue_dev;
> +
> +		if (!p.mp_ops)
> +			continue;
> +
> +		queue_dev =3D __netdev_queue_get_dma_dev(dev, i);
> +		if (queue_dev && queue_dev !=3D dma_dev)
> +			continue;
> +
> +		if (WARN_ON_ONCE(rxq->lease))
> +			continue;
> +
> +		memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
> +		__netif_mp_uninstall_rxq(rxq, &p);

[Severity: Medium]
Can this trigger the WARN_ON_ONCE() in __netif_mp_close_rxq() when racing
with io_close_queue()?

CPU0                                  CPU1
io_close_queue()
  mutex_lock(&ifq->pp_lock)
  netdev =3D ifq->netdev
  ifq->netdev =3D NULL
  mutex_unlock(&ifq->pp_lock)
                                      netdev_lock(netdev)
                                      netdev_unbind_dma_dev()
                                        memset(&rxq->mp_params, 0, ...)
                                        __netif_mp_uninstall_rxq()
                                          io_pp_uninstall()
                                            io_zcrx_drop_netdev()
                                      netdev_unlock(netdev)
  netdev_lock(netdev)
  if (ifq->if_rxq !=3D -1)
    netif_mp_close_rxq()
      __netif_mp_close_rxq()
        WARN_ON_ONCE(...)  <-- hits warning

io_close_queue() clears ifq->netdev and drops ifq->pp_lock before taking
netdev_lock(netdev).  If netdev_unbind_dma_dev() runs in that window,
io_zcrx_drop_netdev() sees ifq->netdev =3D=3D NULL and leaves ifq->if_rxq
unchanged, so io_close_queue() proceeds to call netif_mp_close_rxq().

In __netif_mp_close_rxq(), a cleared rxq->mp_params is only ignored when
dev->reg_state > NETREG_REGISTERED:

net/core/netdev_rx_queue.c:__netif_mp_close_rxq() {
    ...
	if (dev->reg_state > NETREG_REGISTERED &&
	    !rxq->mp_params.mp_ops)
		return 0;

	if (WARN_ON_ONCE(rxq->mp_params.mp_ops !=3D old_p->mp_ops ||
			 rxq->mp_params.mp_priv !=3D old_p->mp_priv))
		return -EINVAL;
    ...
}

Because netdev_unbind_dma_dev() runs while dev->reg_state is still
NETREG_REGISTERED, __netif_mp_close_rxq() hits the WARN_ON_ONCE().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D11
