Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476415;
	b=T78FO/aZNhAclj0igm3mBt6o96mkB+Ih9ojcJgZcILh04Ph3XU6uyxuXhAO+eH+hqODG
	 vmLN/GXpN9rQcze7WdoT6y49OABxbpQXL1hdsXd3/gEUxKbihiDzVHiIIzlpchOUfD6I6
	 oQRkz6qee4u6pO9ZL7+i4vOWTw5HxGhLFT175MY7z00Cwxb8rujYKz8CfgBblZqqsWgzd
	 5ySFlBIRoRG80sfJBuvPIhepX5xA4fg40eJRTVSv/XHkQbxJpsyxcKpbDZ0q0ECow+vGf
	 K2jXDqUDaOql8nv5TxJ1J3UuA1GBbYQO7tHtZEM7m9OwfrnpoF5HR0QjXUTmMl+mnRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476415;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7lW23EWLEHnxDCRZobawWrlqPkzq3V4K9TcjMlbU7iQ=;
	b=ExVkbeYZAl/TUnTHffBRvcUbHx359+EA/Y549eWrLR3ES5tc09dTMe0n6sO8JxlhXjdR
	 jPrRwgwU05zCrSzfWfU1JwEgWkyBLUOxPdDSkwTD2siI3PDN3QyICP0RYScyTa0LmTuYr
	 bj9ZV/wgLm+s8kGr7TAvf0m/U/ciDGk0Ks7F/YeJ/Sr2R/qkekuxXKQwZc3LfE9gC0vi4
	 bUxLY54kdU98zwkEauwKVbCrhXEiBoOxV4koFAfByiTNsz53JHiDahpDhk080wdKUqaC/
	 muHz8lVuZ3Tbv7xAhE0qj47ov3heRAtcR02JdebRkhz1E7bYP1E5Yl/CGJbsESZ9rXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pul5c+Nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26384606A882;
	Thu, 12 Nov 2026 09:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pul5c+Nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1315E1F00A10;
	Thu, 12 Nov 2026 09:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476414;
	bh=7lW23EWLEHnxDCRZobawWrlqPkzq3V4K9TcjMlbU7iQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Pul5c+Nr3mdoAbDL9hp7J97xaGOKL3e4328xezUbw6gtZBt+7IEGJsrJBJruIr26w
	 aiaJwh6vs30KCwBQJueiEftaekq7zUJ41F726KpGsxHhpqeOy1A28tQrwf762q4NRw
	 NTJVOwBYZZkeTAd+MEpWQ0FBwgQCqWeftndLTf6Cf+pO5cvbFIG5n5Zkk0o2IPO2A2
	 9UVDhUqw4AHuuq2+sEke1Qo7qLdpRnF1CIryJcyOQeLMyKaQ0izeCI2UPLLLGraLVO
	 NYwYi1yX7L6j1T2GfueycMhQIUxBgMlG7PXCvk/49zNUKgxEWqir6zpEgKpMRka5QK
	 Cty9Y1rj/F+sg==
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
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
Date: Thu, 12 Nov 2026 09:40:12 +0000
Message-ID: <179447641258.2199510.921186677435570994@kernel.org>
In-Reply-To: <20261110183826.2927274-11-tariqt@nvidia.com>
References: <20261110183826.2927274-11-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The kernel-doc and commit message promise more than
  netdev_has_dmabuf_binding() actually checks.

--

net: devmem: add netdev_has_dmabuf_binding() helper

This adds an exported helper, netdev_has_dmabuf_binding(). It walks the
global devmem bindings xarray and reports whether a binding of a given
netdev is still mapped, with an optional filter on the DMA device. The
goal is to let drivers (data direct support in mlx5e) avoid swapping
the DMA device while in-flight skbs may still use dmabuf mappings.

> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index fb693bc1702a4..35bb6fa0f7194 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h

[ ... ]

> +/**
> + * netdev_has_dmabuf_binding - is there a dmabuf binding for a
> + * given @dev and @dma_dev
> + *
> + * @dev: netdev to check bindings
> + * @dma_dev: dma device to check, when NULL it will not be checked
> + *
> + * A binding is reported for as long as it is mapped, which can be long
> + * after the user unbound it: net_iovs of a TX binding can still be queued
> + * in flight, with DMA mappings that are only valid for the device the dmabuf
> + * was attached to.
> + *
> + * Return: true if a binding is found under @dev and possibly @dma_dev
> + */
> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);

[ ... ]

> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 5c7d9640e9d14..dd3987bbd9f6c 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c

[ ... ]

> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	unsigned long xa_idx;
> +	bool found = false;
> +
> +	netdev_assert_locked(dev);
> +
> +	/* A binding stays in the xarray until it is freed. binding->dev is
> +	 * only cleared under the instance lock of that netdev, and the free
> +	 * takes it before erasing the binding, so a binding found under @dev
> +	 * stays alive while the xarray lock is dropped.
> +	 */
> +	xa_lock(&net_devmem_dmabuf_bindings);
> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
> +		if (READ_ONCE(binding->dev) != dev)
> +			continue;

[Severity: Medium]
Does this check match what the kernel-doc promises, "A binding is
reported for as long as it is mapped"? The commit message also says the
helper will "report every binding of the netdev that is still mapped".

For leased RX queues, binding->dev may not be the device that holds the
mapping. netdev_nl_bind_rx_doit() passes the netdev the user named,
which can be a virtual leasee such as netkit:

net/core/netdev-genl.c:netdev_nl_bind_rx_doit() {
    ...
    binding = net_devmem_bind_dmabuf(netdev, NULL, dma_dev, DMA_FROM_DEVICE,
    ...
}

The dma_dev, though, comes from the physical queue the RX queue is
leased from:

net/core/netdev_queues.c:netdev_queue_get_dma_dev() {
    ...
	hw_rxq = __netif_get_rx_queue(dev, idx)->lease;

	netdev_lock(hw_rxq->dev);
	idx = get_netdev_rx_queue_index(hw_rxq);
	dma_dev = __netdev_queue_get_dma_dev(hw_rxq->dev, idx);
    ...
}

So binding->dev is the leasee, while binding->attachment->dev is the
DMA device of the physical NIC. That also seems to disagree with the
comment on struct net_devmem_dmabuf_binding::dev ("Physical NIC that
does the actual DMA for this binding"), which this helper relies on.

On top of that, both teardown paths skip the unmap in the lease case
but still clear binding->dev:

net/core/devmem.c:mp_dmabuf_devmem_uninstall() {
    ...
			if (!rxq->lease)
				net_devmem_dmabuf_binding_unmap(binding);
			ASSERT_EXCLUSIVE_WRITER(binding->dev);
			WRITE_ONCE(binding->dev, NULL);
    ...
}

net/core/devmem.c:net_devmem_dev_unregister() {
    ...
		if (!netif_is_queue_leasee(dev))
			net_devmem_dmabuf_binding_unmap(binding);
		xa_lock(&net_devmem_dmabuf_bindings);
		WRITE_ONCE(binding->dev, NULL);
    ...
}

After this, the binding stays in the xarray with attachment != NULL
until in-flight net_iovs release it. The check above can no longer
match it for any dev.

Could netdev_has_dmabuf_binding(phys_dev, phys_dma_dev) then return
false while a binding is still mapped against phys_dma_dev?

The only caller in this series, set_pflag_data_direct() in mlx5e,
already rejects installed RX memory providers and leased RX queues, so
it may not hit this today. Since the helper is exported, would it make
sense to either restrict the kernel-doc and commit message to TX
bindings (or bindings whose dev is still set), or to also match
bindings by attachment->dev against the DMA device(s) of @dev?

> +
> +		xa_unlock(&net_devmem_dmabuf_bindings);
> +		mutex_lock(&binding->lock);
> +		found = net_devmem_binding_mapped_to(binding, dma_dev);
> +		mutex_unlock(&binding->lock);
> +		xa_lock(&net_devmem_dmabuf_bindings);
> +		if (found)
> +			break;
> +	}
> +	xa_unlock(&net_devmem_dmabuf_bindings);
> +
> +	return found;
> +}
> +EXPORT_SYMBOL_GPL(netdev_has_dmabuf_binding);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
