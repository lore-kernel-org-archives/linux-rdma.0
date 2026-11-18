Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997916;
	b=L5z910ccXIdciGtygbacuL4I+FuuhzcSUn4NXEmdV2dYOPsfmHxk0ZKZkKZUBse7cWgY
	 eEYT4ya/Ql3pEgXMUTAAhs2ktERBT2WeOj9cz6DPii2MLy2CgwU8Fs7zBFCR68FwBOizY
	 ncFvwaqFcoMNz25JueR9cTSNPmOM9x+yF6S5MKdxXKVYI7q1OJgvCwE69u9XCHtRt/jmU
	 bS2lLGjv5uIsFF80SyMw48S2rBbIqRGBIBAdDZ+KZbtuXUqN8DvDzd5t9lRiqy65tQzCx
	 ANeyZUyhI7LfV4GvxA4GZ4d/+LQiMyT/crZnHik+b/WOBvFzr6bpbTd00b5KTsDJ9/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997916;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=iVD2kgNK3ROB3N0Vzmf85YuBMNxQZozeSJD02qACaik=;
	b=ajR+qb0KtG74Sc5Da4x6agnwv6hwh1cNDFFfZgEhNv7U/HxYPaS/LqT9FYwSsutHDily
	 JCkE3kTZ/Q1qfkX8kCfMYkP89zq3MzBJFBsE01L4LCLncZNbp/mLwL1sLDumscoCgj0XT
	 bG/8wcUTK/cW+pEJ92QuOCoc/879ij/lVOsxHwNn/LfcaWVW/hRcc6OVza5rUVb8E1WHR
	 xNpF37+FMxT7UrpAb1jljqjhX855DEK9hYDZK0GxyzaXqn3ol5zTX/kjK2KHUb5D0jpN1
	 Av1vOGCUd+L2IPA2oIZO7ehGG/t4y73xdxsBwlH08gPDyv2FZ+fYdln8pzDl4Y7pZfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QcRyoms/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A72606A31C;
	Wed, 18 Nov 2026 10:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QcRyoms/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C592A1F000C4;
	Wed, 18 Nov 2026 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997916;
	bh=iVD2kgNK3ROB3N0Vzmf85YuBMNxQZozeSJD02qACaik=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QcRyoms/4A7RSxOfu5WQmUdVrIizJMnPAsOYB+7oqkgAQTTzg6v6+tRVasQ//+Yuq
	 JJqtcGnNb/8zX5ZhYSDFRN6B+PAnCD089VKg/9b16Kg3dmmaWnYdoW/DJ9R2iT4/Pc
	 RQEJyPFzjIqaRSvsPeKkZy+3RmB3KeiVlp7tYCBFTpzaAiPSKOvpvkMXE0+Kxmf8Ib
	 CoBwip15f8oZA+BJiCRIWAQlsIzDiXng/NdTDR3SlO43vmi4/CSdikzXkhTG2KDX2G
	 SEnStEHlgYV1sluUPMIOTuT0nmw5HczvDsulXjDyI8dRvDwjeEMKS9nS57kkcoIdpj
	 4/ax7f0IUSHVA==
Subject: Re: [PATCH net-next V2 05/10] net/mlx5: LAG, decouple iteration
 end-of-walk from MLX5_MAX_PORTS
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com
Date: Wed, 18 Nov 2026 10:31:54 +0000
Message-ID: <179499791433.3136.10916264856961246459@kernel.org>
In-Reply-To: <20261116103010.1129666-6-tariqt@nvidia.com>
References: <20261116103010.1129666-6-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] mlx5_ldev_add_mdev() raises the xa_alloc() range from
  XA_LIMIT(0, MLX5_MAX_PORTS - 1) to XA_LIMIT(0, U8_MAX - 1).
- [Medium] mlx5_handle_changeupper_event() now tests whether the port was
  found with `if (i < ldev->ports)`.
- [Medium] The end-of-walk sentinel used to be the compile-time constant
  MLX5_MAX_PORTS.
- [Low] In mlx5_lag_create_single_fdb_filter() (shared_fdb.c), the
  max_slaves argument to mlx5_eswitch_offloads_single_fdb_add_one()…
- [Low] mlx5_lag_dev_alloc() sets `ldev->max_funcs = ldev->ports` only at
  the very end.

--

net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS

This patch adds ldev->max_funcs and uses it as the end-of-walk sentinel
for the LAG xarray iterators in place of MLX5_MAX_PORTS. max_funcs grows
when a member is added at a higher xarray index. The patch also raises
the xa_alloc() limit in mlx5_ldev_add_mdev() from MLX5_MAX_PORTS - 1 to
U8_MAX - 1.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 669b2167a82d2..cbef6ab1e38a8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -395,6 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
>  		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
>  			      err);
>  
> +	ldev->max_funcs = ldev->ports;
>  	return ldev;

[Severity: Low]
Can a netdev event see max_funcs == 0 here?

By the time this assignment runs, register_netdevice_notifier_net() has
already made ldev->nb live. mlx5_lag_mp_init() has also registered the
FIB notifier, which dumps the FIB and can take a while. Until this line,
max_funcs is still 0 from kzalloc.

Suppose a NETDEV_CHANGEUPPER for a bond in the same netns arrives in that
window. mlx5_handle_changeupper_event() then runs mlx5_ldev_for_each()
with max_funcs == 0:

- mlx5_get_next_lag_func() returns 0.
- The loop exits with i = 0 and idx still -1.
- The new "i < ldev->ports" check passes.

The handler then executes:

    bond_status |= (1 << idx);

This is a shift by -1. Would it be better to set max_funcs right after
ldev->ports is assigned, before any notifier is registered?

[ ... ]

> @@ -2094,7 +2095,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>  				break;
>  			}
>  		}
> -		if (i < MLX5_MAX_PORTS) {
> +		if (i < ldev->ports) {

[Severity: Medium]
Should this compare against ldev->max_funcs, like the other converted call
sites? mlx5_ldev_for_each() now ends with i == ldev->max_funcs. This patch
also explicitly allows members at xarray indices >= ldev->ports, since
mlx5_ldev_add_mdev() grows max_funcs for that case.

xa_alloc() hands out the lowest free index to both port and SD members.
For example, after a PF is unbound and rebound, SD secondaries added by
sd_lag_init() can hold the low indices, so the matched port PF can end up
at an index >= ports.

In that case the loop breaks with i equal to that index, "i < ldev->ports"
is false, and the PF is treated as not found. Its bond_status bit is never
set and has_inactive is not computed for it, so this never becomes true:

    is_in_lag = num_slaves == ldev->ports &&
        bond_status == GENMASK(ldev->ports - 1, 0);

As a result, the bond is never offloaded. Before this patch, indices were
capped at 7, so any found entry passed the check.

The notifier is only registered when !mlx5_sd_is_supported(dev), so this
may need a mixed or unusual topology to trigger. The check is still the
same at the end of the series.

[ ... ]

> @@ -2359,13 +2360,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>  	if (!pf)
>  		return -ENOMEM;
>  
> -	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
> +	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
>  		       GFP_KERNEL);

[Severity: High]
Is it safe to drop the MLX5_MAX_PORTS limit before the arrays that depend
on it are resized?

This limit was the only thing that kept both the member count and every
xarray index below MLX5_MAX_PORTS (8). Neither __mlx5_lag_dev_add_mdev()
nor sd_lag_init() checks the member count.

At this commit, once an ldev has more than 8 members, these writes look
like they go out of bounds:

- mlx5_mpesw_metadata_set() writes ldev->lag_mpesw.pf_metadata[i]
  (u32[MLX5_MAX_PORTS]) under MLX5_LAG_FILTER_ALL. lag_mpesw is the last
  member of struct mlx5_lag, so this writes past the kzalloc'd ldev.

- mlx5_lag_rescan_devices_locked_filter() fills the on-stack
  devs[MLX5_MAX_PORTS] with devs[num_devs++] without any bound check.

- mlx5_lag_query_cong_counters() fills a buffer of MLX5_MAX_PORTS entries
  with mdev[idx++].

- struct lag_tracker::netdev_state[MLX5_MAX_PORTS] is written at the
  port's xarray index in mlx5_ldev_add_netdev() and in
  mlx5_handle_changelowerstate_event():

      tracker->netdev_state[idx] = *lag_lower_info;

- struct mlx5_lag_definer::rules[MLX5_MAX_PORTS *
  MLX5_LAG_MAX_HASH_BUCKETS] is indexed by i * ldev->buckets + j in
  port_sel.c, where i is the port's xarray index.

Before this patch, such a configuration failed cleanly: xa_alloc()
returned -EBUSY and sd_lag_init() rolled back the secondaries. An 8-port
SD configuration, for example, would now give 16 members.

Later patches in the series fix some of these:

- "net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic
  allocation" makes pf_metadata kcalloc(max_fns) and sizes the
  cong-counter buffer from ports.
- "net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan"
  removes devs[].

At the end of the series, though, lag_tracker::netdev_state[] and
mlx5_lag_definer::rules[] are still sized by MLX5_MAX_PORTS and indexed
by xarray indices that are no longer bounded.

The commit message also says:

    No functional change; this only removes the dependency on
    MLX5_MAX_PORTS.

Isn't dropping the xa_alloc() bound a functional change in itself?

>  	if (err) {
>  		kfree(pf);
>  		return err;
>  	}
>  
> +	/* max_funcs is the iteration ceiling; grow it, never shrink. */
> +	if (idx >= ldev->max_funcs)
> +		ldev->max_funcs = idx + 1;
>  	pf->idx = idx;
>  	pf->dev = dev;

[Severity: Medium]
Can walkers that don't hold ldev->lock see an inconsistent max_funcs?

The end-of-walk sentinel used to be a constant. It is now this field,
which is written with a plain store under ldev->lock only. Each iteration
of mlx5_lag_for_each() loads it twice: once as the return value of
mlx5_get_next_lag_func(), and again in the macro test:

    i = tmp, tmp < (ldev)->max_funcs; tmp++)

Several walkers don't hold ldev->lock:

- mlx5_mpesw_sd_devcoms_lock(), called from mlx5_mpesw_work() and
  mlx5_lag_disable_change(), runs under the HCA devcom lock but before
  mutex_lock(&ldev->lock).
- mlx5_ldev_add_netdev(), mlx5_lag_get_next_peer_mdev() and
  mlx5_lag_query_cong_counters() hold only lag_lock.
- mlx5_handle_changeupper_event() holds only RCU.

sd_lag_init() adds secondaries while holding only ldev->lock. The writer
order is:

1. xa_alloc() publishes a zeroed pf at idx == old max_funcs.
2. max_funcs = idx + 1.
3. pf->dev = dev.
4. The PORT mark is set.

Suppose a reader's walk ends while the new pf isn't valid yet. It gets
sentinel N back from mlx5_get_next_lag_func(), then re-reads max_funcs as
N + 1. The loop body then runs once with i = N, skipping the !pf->dev
check and the PORT-mark filter. In mlx5_mpesw_sd_devcoms_lock() that
means:

    sd_devcom = mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);

runs with a NULL dev, which mlx5_get_sd() dereferences. In
mlx5_lag_get_next_peer_mdev(), a NULL or non-port dev could be returned
as a peer.

Also, on weakly ordered architectures nothing orders this store against
the xarray slot, so xa_load(N) could return NULL as well.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> index 7c7e6c832a93d..29048b0c27977 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> @@ -71,7 +71,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
>  
>  		err = mlx5_eswitch_offloads_single_fdb_add_one(master_esw,
>  							       slave_esw,
> -							       ldev->ports);
> +							       ldev->max_funcs);

[Severity: Low]
Is this change intended? This argument isn't an end-of-walk sentinel. It
is max_slaves, which goes through esw_set_master_egress_rule() to
esw_master_egress_create_resources(). There it becomes ft_attr.max_fte
and the bounce group's end_flow_index for the master's egress ACL table
in firmware.

With SD, secondaries take extra xarray indices, so max_funcs can exceed
ports (for example, 4 on a 2-port SD card) and the ACL table is created
larger. max_funcs is also a high-water mark of xarray indices that never
shrinks, not a slave count.

Bounce rules are only added for SD primaries, so ldev->ports seems to
have been sufficient already.

This doesn't match "No functional change" in the commit message. Could
the change be explained in the commit message, or dropped?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
