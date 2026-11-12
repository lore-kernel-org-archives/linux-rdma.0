Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476417;
	b=4GXK4iBK1U3MMbjA3/pBr/rEcVrJ1CdrV+YTDb3Mxwd+3vuTQdhty5PUagq9JjlRuKWH
	 WekChZwSwU+lz3DRwG3C8Jm9Y/DX62dqOrHVcXJsbUycWykn0dvXnkVrziZ2Y2sUrgFP5
	 3uvxmVoHPnLE9HLD6XnCPa+gUdAlwHVq9BfW2raRt+f+BkE3wzMRqBtt4CfZndCCtsmK/
	 eBzTg2ZBIogjSXdh+94uq264ki4P/GGfNEkSXWewUlnEA1p7hH1W0c4hxbuzXxjWtfGEj
	 ifMDIImV9cF6V4rdpHqenrBeu5Hb6it5P8LoZVKXR8XpJsB11u8rV2cBgxlrt6OzILA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476417;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=yVlS5CLKXtywGMbmucGGD+lm2y0RRJ5qeoKITFu0EHE=;
	b=s3vXQmoo2X74WlGbv3aOsaUlEW/zZD2rPEQliLRGHa1w2A8P1e4Xwvkz1+vn6Nxk9TXh
	 rzvN9NA1y6UZUnnS9Q67ICiU1R9e+XHKeI3hNBZlEF4SUDViFMST1iC2y75MeqAl9eIaT
	 ooyIunmPdI7PkjtleFoM+DW1lQTOnkuHC5fNa2qZzdoXpcdOBMGHgn+BjamZ+ftCEej/c
	 QqRAF2Dq+ECFnN1r5reRIKQ49ydBXSoPijwHUAj/emFF+UxhOHGetushhXoeis79HG4AR
	 6s8jxusHY9BC+moNOHXkOJbfUVgVfRAWl8m9wzSH7kDFkodkJ8PccJWvyUcebDeSn7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFs1mLoX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C089606A887;
	Thu, 12 Nov 2026 09:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFs1mLoX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D9F1F00A05;
	Thu, 12 Nov 2026 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476417;
	bh=yVlS5CLKXtywGMbmucGGD+lm2y0RRJ5qeoKITFu0EHE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TFs1mLoXh3aYAEDFz3lGVxEuy0JNtNHH/+HO7SfYr19qDERH+QlDr8fLi/5yVhEW0
	 dMo67WP0K+bRDdEwlUecl0fK0bZbk/v9/bIO21am1xt+4PTN18KscSTByFG/DHI4yi
	 L+Ux+13NOEUolRnFcc4Tub/mnrImBvxq/W29qYMe2JBMtEjlnp8vhoCAbw0/GXxMN3
	 gbLvTIXWOzON8lmQ+FDQrf1K1KpZSSHuk8Qu+1t3vF5TatInZKe+VX9Mm0bw1+RKa1
	 ROq/x+iHRaKNWJUFyfeOFncho4MpForoW0V3Itlzm/R0Rhqi4tOdnigm7ydewSJT/D
	 0LstL4ehHIngw==
Subject: Re: [PATCH net-next V2 11/13] net: add netdev_unbind_dma_dev() helper
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, dtatulea@nvidia.com, erfansh@meta.com,
 gal@nvidia.com, Jacob.e.keller@intel.com, kaifengw@google.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, mfleming@cloudflare.com, almasrymina@google.com,
 razor@blackwall.org, saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com
Date: Thu, 12 Nov 2026 09:40:14 +0000
Message-ID: <179447641496.2199510.9115038837644205059@kernel.org>
In-Reply-To: <20261110183826.2927274-12-tariqt@nvidia.com>
References: <20261110183826.2927274-12-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] netdev_unbind_dma_dev() (net/core/netdev_queues.c:84) refuses
  only when the netdev is both running and present (`netif_running(dev)…
- [Medium] The two halves of netdev_unbind_dma_dev() use different rules
  for which mappings belong to @dma_dev.
- [Medium] __netif_mp_close_rxq() (net/core/netdev_rx_queue.c:291)
  quietly accepts an already-uninstalled provider only when…
- [Low] The commit message says "A detached netdev also works because ...
  new bindings can't be added", but the core does not enforce this for…
- [Low] Several in-tree comments that list binding lifecycle rules were
  not updated for the new site that clears and unmaps bindings, and the…
- [Low] netdev_unbind_dma_dev() treats a NULL result from
  __netdev_queue_get_dma_dev() as "this queue maps against the departing…
- [Low] net_devmem_unbind_dma_dev() (devmem.c:575-596) clears
  NET_DEVMEM_BINDING_LIVE to "hide the binding from TX lookups while it…

--

net: add netdev_unbind_dma_dev() helper

This adds an exported helper for a closed or detached netdev. It
uninstalls the memory providers of RX queues mapped against a departing
DMA device and unmaps the devmem bindings that use that device. It is
meant for mlx5 data direct, where the DMA device is not the netdev's own
PCI device.

> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index dd3987bbd9f6c..bc8ae12b2318a 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -556,6 +556,48 @@ bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
>  }
>  EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);
>  
> +/* Unmap the bindings of a closed @dev that use @dma_dev, the way netdev
> + * unregister does. Senders that raced the detach drop their skbs at xmit.
> + */
> +void net_devmem_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	unsigned long xa_idx;
> +	bool match, live;
> +
> +	netdev_assert_locked(dev);
> +
> +	xa_lock(&net_devmem_dmabuf_bindings);
> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
> +		if (READ_ONCE(binding->dev) != dev)
> +			continue;
> +
> +		/* Hide the binding from TX lookups while it is checked. */
> +		live = xa_get_mark(&net_devmem_dmabuf_bindings, xa_idx,
> +				   NET_DEVMEM_BINDING_LIVE);
> +		if (live)
> +			__xa_clear_mark(&net_devmem_dmabuf_bindings, xa_idx,
> +					NET_DEVMEM_BINDING_LIVE);
> +		xa_unlock(&net_devmem_dmabuf_bindings);

[Severity: Low]
Does clearing the mark here actually hide the binding from TX lookups?
net_devmem_lookup_dmabuf() runs under rcu_read_lock() and does:

    binding = xa_find(&net_devmem_dmabuf_bindings, &xa_idx, id,
                      NET_DEVMEM_BINDING_LIVE);

net_devmem_unbind_dmabuf() needs a grace period after clearing the mark
for exactly this reason:

    /* Ensure no tx net_devmem_lookup_dmabuf() are in flight after the
     * mark is cleared.
     */
    synchronize_net();

There is no synchronize_net() here. A lookup already in flight can still
find a matching binding and take a reference. The safety of matching
bindings then rests only on clearing binding->dev and the check at xmit
time.

There is also a side effect for bindings that don't match. A binding on
@dev that doesn't use @dma_dev is invisible while xa_lock is dropped. A
concurrent SO_DEVMEM_TX sendmsg on it could get a spurious -EINVAL.

The mark is cleared on entry and restored on exit to guard this region,
rather than to express state. Is the clear and restore needed at all?

> +
> +		mutex_lock(&binding->lock);
> +		match = net_devmem_binding_mapped_to(binding, dma_dev);
> +		mutex_unlock(&binding->lock);
> +		if (match)
> +			net_devmem_dmabuf_binding_unmap(binding);

[Severity: Medium]
The commit message calls this half "devmem TX", and the comment says it
works "the way netdev unregister does". However, nothing here filters on
binding->direction or LIVE. net_devmem_dev_unregister() skips LIVE RX
bindings:

    if (binding->direction == DMA_FROM_DEVICE) {
        if (READ_ONCE(binding->dev) != dev ||
            xa_get_mark(..., NET_DEVMEM_BINDING_LIVE))
            continue;

The two halves of netdev_unbind_dma_dev() also pick mappings by
different rules. The RX loop uses the driver's current per-queue report
and skips leased queues. Here, net_devmem_binding_mapped_to() treats a
NULL @dma_dev as a wildcard:

    return binding->attachment &&
           (!dma_dev || binding->attachment->dev == dma_dev);

Take an RX binding whose queue the RX loop skipped but which matches
here. That can happen with a NULL @dma_dev, with a driver that already
reports a different device, or on the leased-queue path. Such a binding
is unmapped and gets binding->dev cleared while rxq->mp_params and
binding->bound_rxqs still point to it. mp_dmabuf_devmem_uninstall()
avoids this by clearing dev only once bound_rxqs is empty.

A later netlink socket close then reaches net_devmem_unbind_dmabuf()
with a NULL binding->dev:

    if (netif_mp_close_rxq(binding->dev, rxq_idx, &mp_params))

Wouldn't netif_mp_close_rxq() then dereference dev->real_num_rx_queues
through NULL? If the netdev is reopened first, the page pool would be
built from the provider that is still installed, over an sgt that has
already been unmapped.

This doesn't look reachable from the in-tree mlx5 caller. But the helper
is exported, and netdev_has_dmabuf_binding() documents a NULL dma_dev as
"any". Should this half filter on DMA_TO_DEVICE, or should a NULL
@dma_dev be rejected?

> +
> +		xa_lock(&net_devmem_dmabuf_bindings);
> +		if (match) {
> +			WRITE_ONCE(binding->vdev, NULL);
> +			WRITE_ONCE(binding->dev, NULL);

[Severity: Low]
This isn't a bug, but some comments about the binding lifecycle don't
cover this new site.

The net_devmem_lock_dev() kernel-doc lists where binding->dev is
cleared:

 * NULL while holding netdev_lock(dev) (in mp_dmabuf_devmem_uninstall(),
 * net_devmem_unbind_dmabuf(), or net_devmem_dev_unregister() during

In struct net_devmem_dmabuf_binding, the vdev comment says "cleared with
WRITE_ONCE() on unregistration". The ref comment says "TX bindings are
also unmapped earlier if their device is unregistered". Both of these now
also happen when the DMA device goes away.

The new netdev_unbind_dma_dev() kernel-doc says it uninstalls queues
"that map against @dma_dev". It also uninstalls queues for which the
driver reports no DMA device at all.

Should these comments be updated?

> +		} else if (live) {
> +			__xa_set_mark(&net_devmem_dmabuf_bindings, xa_idx,
> +				      NET_DEVMEM_BINDING_LIVE);
> +		}
> +	}
> +	xa_unlock(&net_devmem_dmabuf_bindings);
> +}

[ ... ]

> diff --git a/net/core/netdev_queues.c b/net/core/netdev_queues.c
> index 27cb6397bdd4e..71cc7bfc087dd 100644
> --- a/net/core/netdev_queues.c
> +++ b/net/core/netdev_queues.c

[ ... ]

> @@ -58,6 +60,55 @@ struct device *netdev_queue_get_dma_dev(struct net_device *dev,
>  	return dma_dev;
>  }
>  
> +/**
> + * netdev_unbind_dma_dev() - drop the memory providers of a departing DMA device
> + * @dev:	net_device, closed or detached by the caller
> + * @dma_dev:	DMA device the driver is about to lose

[Severity: Low]
The commit message says:

  A detached netdev also works because the driver has already torn down
  the queues and new bindings can't be added.

Is that enforced for io_uring zcrx? The devmem netlink bind paths check
netif_device_present(). zcrx_register_netdev() only needs
netdev_queue_get_dma_dev() to return non-NULL before it calls
netif_mp_open_rxq(). Neither netif_mp_open_rxq() nor
__netif_mp_open_rxq() checks whether the device is present.

So once this returns and the instance lock is dropped, the only thing
stopping a new zcrx area from being mapped against the departing device
is the driver's ndo_queue_get_dma_dev() no longer reporting it. mlx5
does stop reporting it: channels->num is 0 when closed, and dd.dev is
cleared before the notifier runs.

The kernel-doc only says "net_device, closed or detached by the caller".
Should it also state that the driver must stop reporting @dma_dev?

> + *
> + * Uninstalls the memory provider of every RX queue of @dev that maps
> + * against @dma_dev. Unmaps the devmem bindings of @dev that use @dma_dev.
> + * The bindings stay allocated until their users release them.

[ ... ]

> + * Return: 0 on success, -EBUSY if @dev is running and present.
> + */
> +int netdev_unbind_dma_dev(struct net_device *dev, struct device *dma_dev)
> +{
> +	unsigned int i;
> +
> +	netdev_assert_locked(dev);
> +
> +	if (netif_running(dev) && netif_device_present(dev))
> +		return -EBUSY;

[Severity: High]
Can a netdev that is running but detached get past this check while
validated devmem TX skbs are still sitting in a qdisc?

The commit message says:

  The netdev must be closed or detached so that the hardware no longer
  accesses the mappings and the qdiscs hold no validated skbs.

netif_device_detach() only clears __LINK_STATE_PRESENT and stops the TX
queues. Only dev_close()->dev_deactivate()->qdisc_reset() empties the
qdiscs.

The mlx5 caller later in this series seems to reach exactly this state
in mlx5e_nic_disable():

    if (netif_running(priv->netdev))
        mlx5e_close(priv->netdev);
    netif_device_detach(priv->netdev);
    ...
    mlx5e_data_direct_unbind_dev(priv);

mlx5e_close() is the ndo_stop, so __LINK_STATE_START stays set. The
check above then passes because the device is not present.

Consider this sequence:

sch_direct_xmit()
  validate_xmit_skb_list()
    validate_xmit_unreadable_skb()   <- binding->dev still set, passes
                                     mlx5e_close() stops the txq
  dev_requeue_skb(skb, q)            <- skb parked in q->gso_skb

netdev_unbind_dma_dev()
  net_devmem_unbind_dma_dev()
    net_devmem_dmabuf_binding_unmap()
      dma_buf_unmap_attachment()
      dma_buf_unpin()

On resume, mlx5e_open() and netif_device_attach() wake the queue.
dequeue_skb() then returns the gso_skb with:

    /* skb in gso_skb were already validated */
    *validate = false;

The binding->dev check in validate_xmit_unreadable_skb() never runs
again for that skb. Would the NIC then be given net_iov DMA addresses
that are no longer mapped for the DMA device?

The comment above net_devmem_unbind_dma_dev() says "Senders that raced
the detach drop their skbs at xmit". That doesn't seem to hold for these
requeued skbs.

For RX, the check relies on an unenforced convention that a detached
driver has already torn down its RX rings. mlx5 meets it because it
closes before detaching. A caller that only detaches would have its
dmabuf and zcrx mappings revoked while RX descriptors still point at
them. Should the exported helper enforce or document this?

> +
> +	for (i = 0; i < dev->real_num_rx_queues; i++) {
> +		struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, i);
> +		struct pp_memory_provider_params p = rxq->mp_params;
> +		struct device *queue_dev;
> +
> +		if (!p.mp_ops)
> +			continue;
> +
> +		queue_dev = __netdev_queue_get_dma_dev(dev, i);
> +		if (queue_dev && queue_dev != dma_dev)
> +			continue;

[Severity: Low]
Here a NULL from __netdev_queue_get_dma_dev() counts as a match. Is that
intended for a closed netdev?

mlx5e_queue_get_dma_dev() returns NULL whenever:

    /* Allow only opened channels. */
    if (queue_index < 0 || queue_index >= channels->num)
        goto out;

mlx5e_close_channels() sets chs->num = 0. So in the closed state this
helper requires, the @dma_dev filter appears to do nothing for the only
in-tree caller. Every RX queue with a provider is uninstalled, whichever
device it is actually mapped to.

If a driver's queues can map against more than one device, wouldn't
providers on a device that isn't going away be torn down as well? A
leased queue with a provider would also get past this filter and hit
the WARN_ON_ONCE(rxq->lease). The TX half filters on
binding->attachment->dev instead.

mlx5 doesn't allow data direct to be toggled while providers exist, so
there's no in-tree effect today. The semantics still look fragile.

> +
> +		if (WARN_ON_ONCE(rxq->lease))
> +			continue;
> +
> +		memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
> +		__netif_mp_uninstall_rxq(rxq, &p);

[Severity: Medium]
Can this race with io_close_queue() in io_uring/zcrx.c and trigger the
WARN_ON_ONCE() in __netif_mp_close_rxq()?

__netif_mp_close_rxq() only accepts an already-uninstalled provider on
the unregister path:

    if (dev->reg_state > NETREG_REGISTERED &&
        !rxq->mp_params.mp_ops)
        return 0;

    if (WARN_ON_ONCE(rxq->mp_params.mp_ops != old_p->mp_ops ||

Here mp_params is cleared on a device that is still registered. One
possible sequence:

io_close_queue()
  copies ifq->netdev, sets ifq->netdev = NULL under pp_lock
  netdev_lock(netdev)   <- blocks, held by the unbind caller
                                  netdev_unbind_dma_dev()
                                    memset(&rxq->mp_params, 0, ...)
                                    __netif_mp_uninstall_rxq()
                                      io_pp_uninstall()
                                        io_zcrx_unmap_areas()
                                        io_zcrx_drop_netdev()
                                        (ifq->if_rxq left unchanged)
  if (ifq->if_rxq != -1)
      netif_mp_close_rxq(netdev, ifq->if_rxq, &p);
        __netif_mp_close_rxq()
          reg_state == NETREG_REGISTERED, mp_ops == NULL
          WARN_ON_ONCE(...) -> -EINVAL

The areas are already unmapped, so cleanup still completes. Would a
zcrx teardown that races with a data direct unbind or a suspend produce
a WARN splat (fatal with panic_on_warn) plus a spurious -EINVAL?

> +	}
> +
> +	net_devmem_unbind_dma_dev(dev, dma_dev);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(netdev_unbind_dma_dev);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
