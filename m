Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CFB49362B;
	Mon, 12 Oct 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816141; cv=none; b=m4Y7GWEjBigEcn9BOe7PPUtnI7kSOY4Bkmw+t52OmxtFJVzbaU8SzI6+vm257rArTeW8ZQA4UfvpfUB3GjHvbQlDBGBxgk6wM9Vgyagl/bWKZQiSjvnOWiiAzyKyiHfJOD/RW1TRXjdj7k4vdFxf2z7euKMrDFLormMuFv9rpSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816141; c=relaxed/simple;
	bh=KVM0UOsz3lnP/P8hPW5xi4RcWTRta/GqFVQB34QNQN4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KzvD6OvPo1PLCpqOGCrFlOwtxpj+pkndqz0PEs1z6cembyOKg8qme97jag4OAvuGlprcR14MPYz0SjACeDa/oZBJpA7u8rfANJSBLpuerzXOrHsOtxMNGDd9Kha/jUv/dgw9glJDMurKIsH13bZmOs9+WEnnysLw4m9g6dZIRA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDVuJgwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDVuJgwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DC91F0089B;
	Mon, 12 Oct 2026 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816139;
	bh=5dFzDnbDCnWU5n6vqYyXM/lXHbkM5jaAnlYNaSN2O9g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JDVuJgwuCFHeG51yfl6MOzg5xu2MUQ+w16zTtFhh9FwSznk1d/jGjxbE2Xmac6R3j
	 rq5cPx05vDprvqtlFqeoFRPFuWDSCT+4wqsx44x4TqhksIt32ltn6vnS3m/Jbl/580
	 4C537DgR3SjaEkUj6lJUjLp2nGZTg2Uq42+txCnCzi4y56/nIAL06F10NtL0r92FlV
	 nJIeH5xjNZB+42h5VhBX7ijQdQ9MZrzQQukZ8OYdfZitZS2br2g9cztyvcX6g4mb8y
	 dqqKhzTpU6o6nxiBe+JJEgq71BXNbZwBvNQDBlithFDOxYvd5mLnTIENgR+6pUkFm/
	 Tdb4JGkelE+7Q==
Subject: Re: [PATCH net-next 09/10] net: devmem: add
 netdev_has_dmabuf_binding() helper
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, byungchul@sk.com, cjubran@nvidia.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, shivajikant@google.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com, yuehaibing@huawei.com,
 bobbyeshleman@gmail.com
Date: Mon, 12 Oct 2026 14:42:17 +0000
Message-ID: <179181613781.434549.18105765033301114179@kernel.org>
In-Reply-To: <20261008132815.654147-10-tariqt@nvidia.com>
References: <20261008132815.654147-10-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] netdev_has_dmabuf_binding() matches only on `dev ==
  READ_ONCE(binding->dev)`.
- [Medium] netdev_has_dmabuf_binding() compares the caller's net_device
  pointer with binding->dev for every binding on…
- [Low] The kernel-doc for netdev_has_dmabuf_binding() in
  include/net/netmem.h says without qualification that 'A binding is…

--

net: devmem: add netdev_has_dmabuf_binding() helper

This adds netdev_has_dmabuf_binding(). It reports whether a devmem dmabuf
binding exists for a given netdev, and can also filter on the DMA device
the dmabuf was attached to. Bindings can outlive their xarray slot, so each
one now stays on a new global live list until it is freed.

> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index 0cc8572f62caf..8bcf44f43d175 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -387,16 +387,39 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)

[ ... ]

> +/**
> + * netdev_has_dmabuf_binding - is there a dmabuf binding for a
> + * given @dev and @dma_dev
> + *
> + * @dev: netdev to check bindings
> + * @dma_dev: dma device to check, when NULL it will not be checked
> + *
> + * A binding is reported until its last reference is dropped, which can be
> + * long after the user unbound it: net_iovs of a TX binding can still be
> + * queued in flight, with DMA mappings that are only valid for @dma_dev.

[Severity: Low]
Is this also true for RX bindings?

netdev_has_dmabuf_binding() matches on binding->dev. For RX bindings,
mp_dmabuf_devmem_uninstall() clears that field when the last bound queue
goes away:

net/core/devmem.c:mp_dmabuf_devmem_uninstall() {
    ...
			if (xa_empty(&binding->bound_rxqs)) {
				mutex_lock(&binding->lock);
				ASSERT_EXCLUSIVE_WRITER(binding->dev);
				WRITE_ONCE(binding->dev, NULL);
				mutex_unlock(&binding->lock);
			}
    ...
}

This can happen on netdev unregister through dev_memory_provider_uninstall().
It can also happen on lease teardown through netif_rxq_cleanup_unlease().

After that, the netlink socket, page pools or user-held devmem tokens can
still hold references to the binding. Its sgt is also still mapped against
attachment->dev. Even so, the helper no longer reports the binding for any
netdev.

The helper also walks RX bindings without checking binding->direction.

Should the kernel-doc, and the commit message's "track bindings for their
whole lifetime", say that this only applies to TX bindings?

> + *
> + * Return: true if a binding is found under @dev and possibly @dma_dev
> + */
> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);

[ ... ]

> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 07c62e2e3088c..173d66d1cb6e2 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c

[ ... ]

> @@ -357,6 +368,25 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
>  	return binding;
>  }
>  
> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	bool found = false;
> +
> +	spin_lock(&net_devmem_live_bindings_lock);
> +	list_for_each_entry(binding, &net_devmem_live_bindings, live_list) {
> +		if (dev == READ_ONCE(binding->dev) &&
> +		    (!dma_dev || binding->attachment->dev == dma_dev)) {

[Severity: High]
Can this miss RX bindings made on a leased queue?

netdev_nl_bind_rx_doit() stores the netdev the user named by ifindex as
binding->dev:

net/core/netdev-genl.c:netdev_nl_bind_rx_doit() {
    ...
	binding = net_devmem_bind_dmabuf(netdev, NULL, dma_dev, DMA_FROM_DEVICE,
					 dmabuf_fd, niov_shift, priv,
					 info->extack);
    ...
}

When that netdev is a virtual leasee such as netkit, the rest of the setup
still points at the physical NIC:

  - netdev_queue_get_dma_dev() follows the lease and returns the physical
    queue's DMA device. The dmabuf is attached and mapped against it.

  - netif_mp_open_rxq() installs the memory provider on the physical RX
    queue through __netif_get_rx_queue_lease(..., NETIF_VIRT_TO_PHYS).

The physical driver then fills its RX rings with net_iov DMA addresses
that are only valid for that dma_dev. But
netdev_has_dmabuf_binding(phys_netdev, ...) returns false, because
binding->dev is the netkit device.

TX doesn't have this problem, because netdev_nl_bind_tx_doit() stores the
physical bind_dev in binding->dev and the virtual device in vdev.

The only caller in the series is set_pflag_data_direct() in
drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:

    if (netdev_has_dmabuf_binding(netdev, NULL)) {

For a leased RX binding this check doesn't fire, so
mlx5e_safe_switch_params() goes ahead and reopens the channels. The queue
still has its mp installed, so this code in mlx5e_open_channel():

	data_direct = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT) &&
		      netif_rxq_has_unreadable_mp(netdev, ix);

would use the other DMA device with IOVAs that were mapped for the old one.

Could that cause IOMMU faults? Or could RX DMA land wherever those IOVAs
point in the other domain?

For RX bindings, should the lookup also match the physical device behind
a lease?

[Severity: Medium]
For TX bindings, could this pointer comparison match a stale binding->dev?

net_devmem_bind_dmabuf() sets binding->dev = dev without taking a netdev
reference, and netdev_nl_bind_tx_doit() doesn't take one either. The only
later write to the field is WRITE_ONCE(binding->dev, NULL) in
mp_dmabuf_devmem_uninstall(). That only runs for RX queues with an
installed memory provider.

With this patch, TX bindings stay on net_devmem_live_bindings until their
last percpu ref is dropped. That only happens once the owning netlink
socket is closed and all in-flight skbs are freed.

If the netdev is unregistered and freed before then, the list entry keeps
a dangling net_device pointer. An mlx5 driver rebind or a devlink reload
could do that.

If a new net_device is later allocated at the same address,
netdev_has_dmabuf_binding(new_netdev, NULL) would return true for a
binding that belongs to the old device. set_pflag_data_direct() would then
keep returning -EBUSY for as long as the old netlink socket stays open.

The stale TX binding->dev was already there before this patch. What this
patch adds is using it as a lookup key for the whole binding lifetime.

> +			found = true;
> +			break;
> +		}
> +	}
> +	spin_unlock(&net_devmem_live_bindings_lock);
> +
> +	return found;
> +}
> +EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008132815.654147-1-tariqt%40nvidia.com
