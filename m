Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997919;
	b=1Rk/iNnw7wMz4fyURotTuGJN6d/VcJJJofXSzu0EA7ja9WYI3zKlZ42h8zhIZYOCPTjK
	 1Xpqm5jiQPDGm48ijV5wxOt+yteBEldyNApvkyg0F8jMQ9VPUOkSb/f1Iq2V6Yn5dGESt
	 2Ba0vDajWiW3Fpa9sESRBRSfYwRMQ+L1CQyYCrywewu+ZKzsEweyEZ/wvriHpUD0cTGKo
	 EyqN++F755KB7VKv8f7oxxmq23KQ9UGlbiCf99Jo1cMmRaIlZbQEddxOLQwSfFuY/uZni
	 V7xrwP7oMYuDwHCvuleAL+DZbHcviUGLY3f/chcK7Twgre8fnRZ1dXf82ibo/LnHTBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997919;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=P8vxApBGT0u4j4FUHi/CkDPkx6JQ5Wjd/VD7MyC9yUo=;
	b=yWp84ETRIuH7JdbjZfO2XkH32hZNomFl0XVRAMuCESLL2xdDpi7xc3xH475+EzJeAuSU
	 RcAURnhcNWYBsxGfd6oiL1+R7nXKgGxALbrDmL6T4gAVt1Lq/m20FVte/4PZnA9NPHd+X
	 7SI72jrxhf1KEf+u7fCAHPayEUwlgB1Wo/JILZcCavIcKMwEiEIA5cHMF6fuDdm8dhDlR
	 IKDY3/kpjCqvSCi9POvThplhSOTrkfTUW1C6EOsRiECII2/BnUPPmRt+YWTd++HqMpxuS
	 ptxAWcwXjevaAwkRO3po0pImweTvy/LpVkEJj5NEpzgi2uxGET55xf6lf2H6u+dHVRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N2Dj1eyk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37240606A338;
	Wed, 18 Nov 2026 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N2Dj1eyk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEDF1F000CD;
	Wed, 18 Nov 2026 10:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997919;
	bh=P8vxApBGT0u4j4FUHi/CkDPkx6JQ5Wjd/VD7MyC9yUo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=N2Dj1eyk8iSvmgrgm1BiK+ZscXl8ugro//qUSj0qaMDX0EflrHyjEY7RnYWdB9e6a
	 Emxi3xzt26SL8QcmSoCYCkEe0TBYR+1ptE1PSOYsXUk2+EMttZe3qDoJe7PSzG6o7r
	 se6ss0e7SNYuLFm7vqSwI6t0+3jJopyJ2R9agW5gA96DazNN+tU0rSGT7RS/meoEqs
	 j6QP84FQR2PczsX3LDgnEUf+6yMbAXJ7NPzcG/NbSTGYKKNXZVkonzoOoBJr/7ZnkL
	 Ntm4XrMYTuwRLjPDgmcDVt48vh7NvUnL+/Ab217Ms9wOA8qbKqHokGV+sxZ/gTYeAT
	 2mee9k4uwmtLw==
Subject: Re: [PATCH net-next V2 08/10] net/mlx5: LAG: replace fixed
 MLX5_MAX_PORTS arrays with dynamic allocation
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com
Date: Wed, 18 Nov 2026 10:31:57 +0000
Message-ID: <179499791769.3136.2377396411292995534@kernel.org>
In-Reply-To: <20261116103010.1129666-9-tariqt@nvidia.com>
References: <20261116103010.1129666-9-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Possible heap out-of-bounds read/write in
  mlx5_mpesw_metadata_cleanup()…
- [Low] The commit message ends with "Thus, removes the hard dependency
  on MLX5_MAX_PORTS", which overstates what the patch does.

--

net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation

This converts lag_mpesw.pf_metadata and the mdev array in
mlx5_lag_query_cong_counters() from fixed MLX5_MAX_PORTS sized arrays to
dynamically allocated buffers. pf_metadata is sized by ldev->max_fns when
MPESW is enabled. The cong counters array is sized by ldev->ports.

> Thus, removes the hard dependency on MLX5_MAX_PORTS.

[Severity: Low]
Is this statement accurate? This patch converts only two arrays.

This patch leaves the devs[MLX5_MAX_PORTS] scratch array in
mlx5_lag_rescan_devices_locked_filter() in place. The later series patch
"drop MLX5_MAX_PORTS scratch array from device rescan" removes it.

Some arrays tied to the LAG member index space are still there at the end
of the series. That index space is no longer capped at MLX5_MAX_PORTS,
because "decouple iteration end-of-walk from MLX5_MAX_PORTS" moved
xa_alloc() to XA_LIMIT(0, U8_MAX - 1):

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h:struct lag_tracker {
    ...
    struct netdev_lag_lower_state_info  netdev_state[MLX5_MAX_PORTS];
    ...
}

drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h:struct mlx5_lag_port_sel {
    ...
    struct mlx5_flow_handle *rules[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS];
    ...
}

Could the commit message say that these remain? Or should they be
converted or bounded as well?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> index 49602f8306155..8a867a04916a8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> @@ -15,6 +15,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
>  	u32 pf_metadata;
>  	int i;
>  
> +	if (!ldev->lag_mpesw.pf_metadata)
> +		return;
> +
>  	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
>  		dev = mlx5_lag_fn(ldev, i)->dev;
>  		esw = dev->priv.eswitch;
> @@ -27,6 +30,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
>  		mlx5_esw_match_metadata_free(esw, pf_metadata);
>  		ldev->lag_mpesw.pf_metadata[i] = 0;
>  	}
> +
> +	kfree(ldev->lag_mpesw.pf_metadata);
> +	ldev->lag_mpesw.pf_metadata = NULL;
>  }
>  
>  static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
> @@ -36,6 +42,12 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
>  	u32 pf_metadata;
>  	int i, err;
>  
> +	ldev->lag_mpesw.pf_metadata =
> +		kcalloc(ldev->max_fns, sizeof(*ldev->lag_mpesw.pf_metadata),
> +			GFP_KERNEL);
> +	if (!ldev->lag_mpesw.pf_metadata)
> +		return -ENOMEM;
> +

[Severity: High]
Can ldev->max_fns grow after this allocation while MPESW is still active?

The allocated length is not stored anywhere. Yet
mlx5_mpesw_metadata_cleanup() walks the members with mlx5_lag_for_each(),
which checks against the current max_fns:

#define mlx5_lag_for_each(i, start_index, ldev, filter) \
	for (int tmp = start_index; \
	     tmp = mlx5_get_next_lag_func(ldev, tmp, filter), \
	     i = tmp, tmp < (ldev)->max_fns; tmp++)

mlx5_ldev_add_mdev() grows max_fns without looking at the LAG mode:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_ldev_add_mdev() {
    ...
	/* max_fns is the iteration ceiling; grow it, never shrink. */
	if (idx >= ldev->max_fns)
		ldev->max_fns = idx + 1;
    ...
}

sd_lag_init() calls it for each SD secondary, also without checking
ldev->mode:

drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c:sd_lag_init() {
    ...
	mlx5_sd_for_each_secondary(i, primary, pos) {
		err = mlx5_ldev_add_mdev(ldev, pos, sd->group_id);
    ...
}

Here is one possible sequence on an SD card:

  devlink esw_multiport=true
    mlx5_lag_enable_mpesw()
      mlx5_mpesw_metadata_set()
        kcalloc(max_fns = 2)

  secondary PF probes later
    mlx5e_probe() -> mlx5_sd_init() -> sd_lag_init()
      mlx5_ldev_add_mdev()     /* idx 2, max_fns = 3 */

  devlink esw_multiport=false, or unload
    mlx5_lag_disable_mpesw()
      mlx5_mpesw_metadata_cleanup()
        reads and writes pf_metadata[2]

SD secondaries have fn->dev set, so the MLX5_LAG_FILTER_ALL walk visits
them. Three things then go wrong for any index past the allocated count:

- cleanup reads pf_metadata[i] past the end of the slab object.
- if that stale value is non-zero, it calls
  mlx5_esw_acl_ingress_vport_metadata_update() on that eswitch, and
  mlx5_esw_match_metadata_free() with an ida id that was never allocated.
- it writes 0 to pf_metadata[i] past the end of the buffer.

With the old embedded u32 pf_metadata[MLX5_MAX_PORTS], a member added
later at an index below MLX5_MAX_PORTS read a zero slot and was skipped.

The last patch in the series ("do not add a device to an already-active
virt LAG") says SD secondaries join before MPESW can be enabled. Is that
enforced anywhere?

- mlx5_devlink_esw_multiport_set()->mlx5_lag_mpesw_enable() does not
  check SD readiness.
- mlx5_phys_mpesw_validate()->mlx5_lag_check_prereq() only checks
  mlx5_lag_num_devs(ldev) == ldev->ports. That counts port members, not
  SD secondaries.

Would it be safer to record the allocated length and bound the cleanup
loop by it? Another option is to refuse max_fns growth and SD joins
while MPESW is active.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
