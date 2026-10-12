Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D14490C00;
	Mon, 12 Oct 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816137; cv=none; b=hipVDwAsKw5jtiGTHZOqpKsrpczsDiihd+peP4EKHOJmFhI/spZHT66kukrEmos79mlRRc9EcohJO3ei9OhSfcVfOjhwEEqaHqJucwq1XbczeTGUX+2DNdaq18a44Pvl19TFnrtkXrbO5r4pgI3UGqjrcn+mWJrlnt5x1lHJ/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816137; c=relaxed/simple;
	bh=JEqAw5rCjb4mTgsCwvH8sxDXt7MS2cPo1Om5XabkL38=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jkc9XvIT7QqflCft+tY2DBM80oMDM44epWH5Eiv4CnOIrTelcQBgTFUNLIlvRwLOKv1UiLKDfgle/rA4PUcLI+DqTLiEMijCQT0f8Gmwo/UKsAVshKRKReIKdhKO/T9/xFyoSWVeLUR6a66y0pZgS83rMzxkm+HkQ+IL5OEmBkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPyQZX9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPyQZX9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012BB1F0089B;
	Mon, 12 Oct 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816135;
	bh=QmYSvqzUSXfmdUBpjjHSs/oy6k6hNzQoUqDCmTNJFxQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IPyQZX9sE8W9+A0mujAToOBETOsfBdszN/vo2zAJpn1aWesR4v72TEyJ0+4g7+UZu
	 zh8RnRmgCYeS/0uY9qm5nIyFklec6/QP0MTdAvB//5byTx1+n9k/4FLpNapmXRLEbr
	 2WmYs5cISeO5PBMCwPP/caFI8CXaS3BRY/Awdt5oOcM6KuGQP9JxZgq+HwNP+zYxkS
	 bS+u/bhUqEfcrsjsR4cI1GhpVRypCmZuuUYKcXi5J41yHvsnpLnikvetnynImmaz6j
	 om7NG1ssiILCLY1d3YEn1kTa80El7Dexs/PusGqm2mGbveVaJOEE3O65Ev4UAfidLF
	 pPGbllnlvPeIQ==
Subject: Re: [PATCH net-next 07/10] net/mlx5e: Use the correct DMA dev when
 data_direct pdev enabled
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
Date: Mon, 12 Oct 2026 14:42:13 +0000
Message-ID: <179181613357.434549.16364110509873454132@kernel.org>
In-Reply-To: <20261008132815.654147-8-tariqt@nvidia.com>
References: <20261008132815.654147-8-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] This patch makes mlx5e_queue_get_dma_dev() return
  &dd_dev->pdev->dev, the device of a separate, independently removable…
- [Medium] With MLX5E_PFLAG_DATA_DIRECT set, mlx5e_queue_get_dma_dev()
  (drivers/net/ethernet/mellanox/mlx5/core/en_main.c:5916-5922) returns…
- [Medium] At this commit, mlx5e_queue_get_dma_dev() loads dd_dev =
  READ_ONCE(mdev->data_direct->dev) under priv->state_lock and…
- [Low] The commit message says 'Rename netdev argument to netdev', but
  the diff renames the parameter of mlx5e_queue_get_dma_dev() from 'dev'…

--

net/mlx5e: Use the correct DMA dev when data_direct pdev enabled

When MLX5E_PFLAG_DATA_DIRECT is set, this patch makes
mlx5e_queue_get_dma_dev() return the data direct PCI device instead of
the NIC PF DMA device. It also renames the net_device parameter of the
function.

> When the private flag is set, always return the data direct
> PCI device instead of the NIC PF PCI device in .ndo_queue_get_dma_dev.
>
> Rename netdev argument to netdev because there are too many confusing
> "dev"-based names in this function.

[Severity: Low]
This isn't a bug, but should this read "Rename dev argument to netdev"?
The diff renames the parameter from dev to netdev.

Is "always" accurate? If mlx5_data_direct_get_dev() returns NULL (no
bound dd device, or mdev->data_direct == NULL), the function returns NULL.
It does not fall back to the PF device.

At this commit, set_pflag_data_direct() in en_ethtool.c still returns
-EOPNOTSUPP, so the flag can't be set yet. Earlier patches in the series
say when a change has no runtime effect. Could this message say so too?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index d5282a3016218..6476baf71bdee 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[ ... ]

> @@ -5913,7 +5913,16 @@ static struct device *mlx5e_queue_get_dma_dev(struct net_device *dev,
>  		goto out;
>  
>  	ch = channels->c[queue_index];
> -	pdev = ch->pdev;
> +	if (MLX5E_GET_PFLAG(&channels->params, MLX5E_PFLAG_DATA_DIRECT)) {
> +		struct mlx5_core_dev *mdev = ch->mdev;
> +		struct mlx5_data_direct_dev *dd_dev;
> +
> +		dd_dev = mlx5_data_direct_get_dev(mdev->data_direct);

[Severity: Medium]
What keeps dd_dev alive between this load and the dd_dev->pdev
dereference below? The reader holds priv->state_lock. At this commit the
unbind path does not take that lock:

mlx5_data_direct_remove()
  mlx5_data_direct_dev_unreg()
    mlx5_data_direct_do_unbind()
      clears the dd pointer, calls the UNBIND notifier
        mlx5e_data_direct_event()   <- only logs
  kfree(dev)

The pflag can't be set at this commit, so this path isn't reachable yet.
The next patch in the series, "net/mlx5e: Recreate netdev channels on data
direct device unbind", makes mlx5e_data_direct_event() take rtnl_lock,
netdev_lock and priv->state_lock before kfree(dev) runs. That closes the
race for priv->mdev.

A gap still seems to remain. mlx5e_nic_enable() registers the notifier
only on priv->mdev:

	mlx5_data_direct_register(mdev, &priv->data_direct_nb);

This reader uses ch->mdev instead. On a Socket-Direct netdev, can an
unbind of a secondary PF's dd device race with this lookup? That case
only arises if SD and data direct are used together.

> +		if (dd_dev)
> +			pdev = &dd_dev->pdev->dev;

[Severity: Medium]
Does the returned device match the device the RQ page_pool is created
with? mlx5e_alloc_rq() still uses:

	pp_params.dev       = rq->pdev;

rq->pdev is set in mlx5e_open_channel():

	c->pdev     = mlx5_core_dma_dev(mdev);

That is the PF device, even when the RQ is opened with data_direct set.

io_uring zcrx stores the ndo result and maps the area against it. It then
checks that device against the page_pool device:

io_register_zcrx_ifq()
	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, if_rxq, NETDEV_QUEUE_TYPE_RX);

io_pp_zc_init()
	if (WARN_ON_ONCE(ifq->dev != pp->p.dev))
		return -EINVAL;

With the pflag set, would registering a zcrx ifq hit this WARN, so that
page_pool_create() and the queue restart both fail?

Even without that check, zcrx_sync_for_device() syncs through pp->p.dev
(the PF). The area, however, was mapped on the data direct device.

There is also a related case. The final patch in the series guards the
pflag change only with netdev_has_dmabuf_binding(). That covers devmem
but not zcrx.

Suppose a zcrx memory provider is installed before the flag is flipped.
mlx5e_open_channel() then computes data_direct=true, because
netif_rxq_has_unreadable_mp() only checks mp_ops. The area is still mapped
on the PF, so the device check passes, but the RQ uses the data direct
PD/KSM mkey. Is that combination expected to work?

[Severity: High]
Can this device go away while a devmem binding still uses it? It belongs
to a separate PCI function (mlx5_dd) that can be removed on its own, and
no reference is taken on it here.

devmem keeps the pointer for as long as the binding exists:

net_devmem_bind_dmabuf()
  dma_buf_attach(binding->dmabuf, dma_dev)
    dma_buf_dynamic_attach()
      attach->dev = dev;    <- no get_device()

The mapping is only torn down later:

__net_devmem_dmabuf_binding_free()
  dma_buf_unmap_attachment_unlocked(binding->attachment, ...)
  dma_buf_detach(binding->dmabuf, binding->attachment)

mlx5_data_direct_remove() does not revoke these bindings. At this commit
the UNBIND notifier only logs.

Later in the series, "net/mlx5e: Recreate netdev channels on data direct
device unbind" clears the pflag and recreates the channels. Its commit
message says the recreated channels "will still pick up the binding via
rxq->mp_params and post DMA addresses from the data direct IOMMU domain
to the PF, causing IOMMU faults".

After a dd unbind or hot-remove with a binding still active, could the
NIC post dd-domain IOVAs through the PF? That would mean IOMMU faults, or
DMA into the wrong memory if the domain is reassigned, for example to
vfio.

On hot removal, could the struct pci_dev be freed while attach->dev still
points to it? The deferred __net_devmem_dmabuf_binding_free() would then
unmap and detach against freed memory.

netdev_has_dmabuf_binding() in the final patch blocks pflag changes from
ethtool. It doesn't seem to cover the dd device being unbound.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008132815.654147-1-tariqt%40nvidia.com
