Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2348F856;
	Mon, 12 Oct 2026 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816143; cv=none; b=rSKeSYXJ15NPCrgR+PuF/ILgpJ3MtwoO7YVlxBOIabv6/5QKsDhf5dsP8X/rbDGaV2nE2XLhFPngb8C2SkKyQsUh+wuSHAPh/6WLl6xq5YyVOBBLwz2MrZO1m4DvOmuZU4NmzaSbF1uUlDjtT73Wp+dGIJ849ThXtFQBFRCGlCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816143; c=relaxed/simple;
	bh=1lQvQwvjWy67EpJChMqUQ8ieh9OoI2R7zYjYkx4oYpA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iOHTORBZdHRPiQBYJAY/OZ03uNw37yk7eeiWGQ+tIhX/PWHNhd1EgjZnbwu/LGpLCDAtbv99wt+hGSeTYoYSYo/6gUJY9BIsulKXG7bjr7kV67PqlAoTZzOrAmMbDUVqXUHWMpcW2tf5mPEymBZiPJ+1DS0c6gWIOG7oiZNqWTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YG05CT7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YG05CT7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D0D1F0089C;
	Mon, 12 Oct 2026 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816141;
	bh=9kkg6vVzXjctboclnlhLJzLnBK/wncsMNmzmF3tNzJ0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YG05CT7iL2YX+wrgdCg1eZO6LYDiLbUSmtURE6Ohc8zpBoUW2ZlltePUA8ohqtOm7
	 oBrSy92Eny4V0Ek1C8qTvWX1vfjqLDPIktbADAsCvtOhbA9vf1UEV/CB6brCuVX7KR
	 Pa+y4JxKUZqjMPSUHeboYdJcAnPJyN1hcIt0n57bTgA6c+ZqpHFxu75lqgStdV3rnN
	 wXc5gIPNdIM3SvJXdqQO/M3WpFpY7ViGr5lMzH/nHvK2VIuWtv4+aNVlzheh8V5DZl
	 VvZtj9eJuf+NHF9ctQgeCQTEEgmZJktJietnmyEM49snP1GA5wn4jxnwO5H8TPs7RF
	 L/wdxxGUQIDqQ==
Subject:
 Re: [PATCH net-next 10/10] net/mlx5e: Enable the data direct netdev feature
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
Date: Mon, 12 Oct 2026 14:42:19 +0000
Message-ID: <179181613986.434549.15185486433326152669@kernel.org>
In-Reply-To: <20261008132815.654147-11-tariqt@nvidia.com>
References: <20261008132815.654147-11-tariqt@nvidia.com>
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

Critical: 0 · High: 2 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] set_pflag_data_direct()
  (drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:2431) is meant…
- [High] Before this commit, set_pflag_data_direct() always returned
  -EOPNOTSUPP, so the body of mlx5e_data_direct_event() never ran.
- [Medium] This commit makes mlx5e_data_direct_event() reachable, and
  that handler throws away the return value of…

--

net/mlx5e: Enable the data direct netdev feature

This commit adds the setter for the mlx5e data_direct private flag, which
turns the data direct feature on. It also refuses to change the flag while
dmabufs are bound to the netdev.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index b3eced1dd43fd..8ab1150ce3f20 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c

[ ... ]

> @@ -2402,7 +2403,40 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
>  
>  static int set_pflag_data_direct(struct net_device *netdev, bool enable)
>  {
> -	return -EOPNOTSUPP;
> +	struct mlx5e_priv *priv = netdev_priv(netdev);
> +	struct mlx5_core_dev *mdev = priv->mdev;
> +	struct mlx5e_params new_params;
> +

[ ... ]

> +	/* Changing the flag reopens the channels with a different DMA device,
> +	 * which would break any dmabuf currently bound to this netdev.
> +	 */
> +	if (netdev_has_dmabuf_binding(netdev, NULL)) {
> +		netdev_err(netdev, "Can't change data_direct while dmabufs are bound\n");
> +		return -EBUSY;
> +	}

[Severity: High]
Does this check catch every memory provider that can be installed on an
mlx5 RX queue?

netdev_has_dmabuf_binding() only walks net_devmem_live_bindings and
matches on binding->dev:

net/core/devmem.c:netdev_has_dmabuf_binding() {
    ...
	list_for_each_entry(binding, &net_devmem_live_bindings, live_list) {
		if (dev == READ_ONCE(binding->dev) &&
		    (!dma_dev || binding->attachment->dev == dma_dev)) {
    ...
}

This seems to miss two cases.

The first is a devmem RX binding made through a leased queue. In
netdev_nl_bind_rx_doit(), net_devmem_bind_dmabuf() is called with the
leasee netdev, so binding->dev is the virtual device. The dma_dev still
comes from mlx5e_queue_get_dma_dev() through the lease, and
netif_mp_open_rxq() installs the provider on the physical mlx5 rxq.

The second is io_uring zcrx. zcrx_register_netdev() does:

	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, if_rxq, NETDEV_QUEUE_TYPE_RX);

It then maps its area for that device and installs io_uring_pp_zc_ops
with netif_mp_open_rxq(). It never adds anything to
net_devmem_live_bindings.

In both cases the flag change is accepted and mlx5e_safe_switch_params()
reopens the channels. mlx5e_open_channel() then does:

	data_direct = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT) &&
		      netif_rxq_has_unreadable_mp(netdev, ix);

That is true for any unreadable provider, so the RQ switches between the
PF MTT UMR mkey and the data direct KSM crossing mkey. The page pool
netmems still hold IOVAs mapped for the old DMA device, and
mlx5e_alloc_rx_mpwqe() writes them into the KSM/MTT entries:

	if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
		umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
			.key = rq->mpwqe.ksm_child_mkey_be,
			.va  = cpu_to_be64(addr),

Could the NIC then DMA to IOVAs resolved through the other function's
IOMMU domain? That would mean IOMMU faults, or writes into unrelated pages
if the same IOVA happens to be mapped there.

The commit message says "Do not allow state changes while dmabufs are
still bound to the netdev". Should the setter also refuse the change when
any RX queue has a memory provider installed? One way would be to check
netif_rxq_has_unreadable_mp() for each queue below real_num_rx_queues.

> +
> +	new_params = priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, enable);
> +
> +	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);

[Severity: High]
Before this patch, set_pflag_data_direct() always returned -EOPNOTSUPP,
so the body of mlx5e_data_direct_event() never ran. Now that the flag can
be set, what keeps the dmabuf invariant when the data direct PCI function
unbinds?

While the flag is set, mlx5e_queue_get_dma_dev() returns the data direct
device:

	dd_dev = mlx5_data_direct_get_dev(mdev->data_direct);
	if (dd_dev)
		pdev = &dd_dev->pdev->dev;

So devmem bindings and zcrx areas created during that time are attached
to, and mapped for, the data direct function.

On sysfs unbind or hot-unplug the call chain is:

mlx5_data_direct_remove()
  mlx5_data_direct_dev_unreg()
    mlx5_data_direct_do_unbind()
      mlx5e_data_direct_event()
        mlx5e_safe_switch_params()

mlx5e_data_direct_event() clears the flag and reopens the channels. It
does not call netdev_has_dmabuf_binding() or
netif_rxq_has_unreadable_mp(), and it does not revoke anything:

	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);

rxq->mp_params is left in place. Would the recreated PF RQs keep posting
net_iovs whose DMA addresses come from the data direct function's IOMMU
domain?

After the notifier returns, mlx5_data_direct_remove() continues with:

	mlx5_data_direct_dev_unreg(dev);
	pci_disable_device(pdev);
	kfree(dev->vuid);
	kfree(dev);

It does not wait for the outstanding attachments. Later, the deferred
__net_devmem_dmabuf_binding_free() calls
dma_buf_unmap_attachment_unlocked() on an attachment whose device is the
removed function.

An earlier commit in this series, "net/mlx5e: Recreate netdev channels on
data direct device unbind", acknowledges the IOMMU faults and says a
devmem revoke hook is needed. No later commit in the series adds one.
Should the flag stay disabled until that revoke path exists?

[Severity: Medium]
This patch also makes the error handling in mlx5e_data_direct_event()
reachable. The handler ignores the return value of
mlx5e_safe_switch_params() and returns NOTIFY_OK:

	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
	netdev_info(priv->netdev,
		    "data_direct device unbound, disabled data_direct\n");

Suppose the interface is open and mlx5e_safe_switch_params() fails in
kzalloc_obj() or mlx5e_open_channels(). priv->channels is then left
unchanged. MLX5E_PFLAG_DATA_DIRECT stays set, and the old RQs/SQs keep
their data direct state, their KSM crossing mkeys and their page pools
mapped for the data direct device.

mlx5_data_direct_remove() then goes on to pci_disable_device() and
kfree(dev). Would the live queues still be routing DMA through a disabled
PCI function at that point?

mlx5_data_direct_do_unbind() has also already done:

	WRITE_ONCE(reg->dd.dev, NULL);

Because the flag is stale, mlx5e_queue_get_dma_dev() still takes the data
direct branch. It returns NULL instead of falling back to ch->pdev, so new
zero-copy bindings would fail until someone clears the flag by hand.

On this forced path, should a failure take the affected channels down, or
otherwise make sure the data direct path is gone, before PCI teardown
continues?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008132815.654147-1-tariqt%40nvidia.com
