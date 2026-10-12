Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CD74921BC;
	Mon, 12 Oct 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816139; cv=none; b=CCmv1oWhwWy3ViMW4UqyRsTgnNwXzBG2uv3RSPbkFH9WDrmuGP5k99X20LcOT9YxmYVCeb82B/NfSOj/H67S+oLLVWtNrj9GcIRT/CMs/MRjvftmd+KyS0SflYdwSWESrA+wkOGgY6PPQG/Z7LIz8h5+kRCEe6lXsjPvh76AoIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816139; c=relaxed/simple;
	bh=qtB2P4CTUG9D2ubnhimvTLq5EfQI0lVA/HeRccbCeFM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=twNvHenPA6mmamE8Gi1EPqN0cb+QwYq6YxcnjEPvu4CDomdSvKXUaAXLAx8IaWHyfQiRtwrnlv63qQSxDaPx222vD4Ijb1FyzVyNf+ji8qLFznrAc5W9DFmiMqbFIKZgbGPXvteZjsUKGgE8eSzDdvJFHEuSxd/rfGKcMzkYY+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvJsLp1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvJsLp1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC281F0089C;
	Mon, 12 Oct 2026 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816137;
	bh=E92LEZT1H9Kk6sub/fWsU8maqVhmo5Yb/H5VfOQb1qY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XvJsLp1PU1VSO9e3RhdBndWIRjLEGNmnHa81OcWTk5TL/yRp00V2Gesujomm/XMVQ
	 GxvZFj+KErqD1+j5P2qpwYA9x5emeCLD+8pxbrrb+S8u+2EEb1vtmkNhkvkugnSss5
	 symT7oMQj1a3vudOQQEqdGM+n3jvRrJ0vBnyr/JvHNXBYeRulLsKP9gIs8aCXLoglp
	 Rkit/VmzewtHLbj77Fs9TndAtqdf32BCgFQg4EMJd0pCn5bt2fkvQoh0nF+L2v0n5d
	 oDwxsE/xWBxwevtvHJuvd6yuDpEMtLrt8qGvdjyF6xEdSOmKcNCFNBxfvdWeyiKKs7
	 10ezeRjq3DFnw==
Subject: Re: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on
 data direct device unbind
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
Date: Mon, 12 Oct 2026 14:42:15 +0000
Message-ID: <179181613561.434549.16789148895604034806@kernel.org>
In-Reply-To: <20261008132815.654147-9-tariqt@nvidia.com>
References: <20261008132815.654147-9-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] On DD unbind, mlx5e_data_direct_event() clears
  MLX5E_PFLAG_DATA_DIRECT and rebuilds the channels, but it never…
- [Medium] mlx5e_data_direct_event()
  (drivers/net/ethernet/mellanox/mlx5/core/en_main.c) ignores the return…

--

net/mlx5e: Recreate netdev channels on data direct device unbind

On a data direct unbind event, this commit makes the mlx5e notifier clear
MLX5E_PFLAG_DATA_DIRECT and recreate the channels with
mlx5e_safe_switch_params(). It runs under rtnl, the netdev lock and
state_lock. The commit message notes that dmabuf bindings attached to the
data direct device are not torn down.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 6476baf71bdee..fb3e0bd00f04e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6144,9 +6144,28 @@ static int mlx5e_data_direct_event(struct notifier_block *nb,
>  {
>  	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv,
>  					       data_direct_nb);
> +	struct mlx5e_params new_params;
> +
> +	if (action != MLX5_DATA_DIRECT_UNBIND)
> +		return NOTIFY_DONE;
> +
> +	rtnl_lock();
> +	netdev_lock(priv->netdev);
> +	mutex_lock(&priv->state_lock);
>  
> -	if (action == MLX5_DATA_DIRECT_UNBIND)
> -		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
> +	if (!MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_DATA_DIRECT))
> +		goto out;
> +
> +	new_params = priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
> +	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);

[Severity: High]
What happens to devmem bindings that were mapped against the data direct
device when this switch runs?

While the pflag is set, mlx5e_queue_get_dma_dev() returns the data direct
PCI device. net_devmem_bind_dmabuf() therefore maps the dmabuf in the data
direct function's IOMMU domain, for the RX queues and for TX queue 0.

After the switch, mlx5e_open_channel() computes data_direct as false for
the recreated channels:

    data_direct = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT) &&
                  netif_rxq_has_unreadable_mp(netdev, ix);

and mlx5e_alloc_rq() then uses the ordinary PF UMR mkey:

    wqe->data[0].lkey = data_direct ?
                        cpu_to_be32(rq->mpwqe.crossing_mkey) :
                        rq->mpwqe.umr_mkey_be;

page_pool_init() picks up the same binding again from rxq->mp_params.
mp_dmabuf_devmem_init() does not check or remap the DMA device.

Won't the NIC then write received payload to data direct domain IOVAs as
the PF requester?

On TX, the new SQs no longer have MLX5E_SQ_STATE_DATA_DIRECT, so
mlx5e_txwqe_build_dsegs() uses sq->mkey_be for net_iov frags:

    dseg->lkey = dd && skb_frag_is_net_iov(frag) ?
                 sq->crossing_mkey_be : sq->mkey_be;

So the NIC would read PF domain memory at data direct domain IOVAs.

The commit message mentions IOMMU faults on RX. If an IOVA is also mapped
in the PF domain, could the result be silent memory corruption on RX,
with network-controlled payload, or an information leak on TX?

The later commit "net/mlx5e: Enable the data direct netdev feature" makes
the pflag settable. It also adds a netdev_has_dmabuf_binding() -EBUSY
check, but only in set_pflag_data_direct(). This unbind path still
switches unconditionally, and the series never adds a revoke hook.

At the end of the series, don't the queues still use data direct resources
after unbind, which is what this commit says it prevents?

Do the bindings need to be revoked or quiesced before this switch, or
should the switch be skipped while bindings exist?

> +	netdev_info(priv->netdev,
> +		    "data_direct device unbound, disabled data_direct\n");

[Severity: Medium]
Should the return value of mlx5e_safe_switch_params() be checked here?

When the interface is open, mlx5e_safe_switch_params() can fail if
kzalloc_obj() fails. It can also fail if mlx5e_open_channels() hits an
allocation or firmware command error:

    err = mlx5e_open_channels(priv, new_chs);
    if (err)
        goto err_cancel_selq;

Those error paths free only the new allocations and leave priv->channels
as it was. The old channels stay active:

- The SQs keep MLX5E_SQ_STATE_DATA_DIRECT and the crossing_mkey_be set in
  mlx5e_alloc_txqsq().
- The RQs keep the data direct mkeys.
- priv->channels.params still has MLX5E_PFLAG_DATA_DIRECT set.

Even so, the netdev_info() above reports that data_direct was disabled,
and NOTIFY_OK is returned.

mlx5_data_direct_do_unbind() sends this notification once, after it
clears reg->dd.dev, and never retries. mlx5_data_direct_remove() then
disables and frees the device without checking the result:

    mlx5_data_direct_dev_unreg(dev);
    pci_disable_device(pdev);
    kfree(dev->vuid);
    kfree(dev);

Could devmem-backed queues then keep sending DMA through a PCI function
that has been disabled, or rebound to another driver?

There is also a side effect: with the pflag still set and dd.dev NULL,
mlx5e_queue_get_dma_dev() still takes the data direct branch. But
mlx5_data_direct_get_dev() now returns NULL there, so later devmem or zcrx
binds would fail with no clear reason. Ethtool would also still show the
flag as enabled.

The later commit "net/mlx5e: Enable the data direct netdev feature" makes
this path reachable, and it does not change this callback.

> +
> +out:

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008132815.654147-1-tariqt%40nvidia.com
