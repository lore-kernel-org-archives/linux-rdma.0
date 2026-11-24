Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509169;
	b=Cy7rJulIPKlYxdQH8EtHw8ocMkqnLblCthGlSbJu+7TlLQXXzuNm/qPkIZgHbLSRohzg
	 zg/3BQJ04l2trIQuT0nozxccFe+93s1CiayPjn9Q4Ux7izLIIgm1ruwwnV0932z39k7tf
	 wYKSWr/IPTUm/ZEw2WhRWRDE7T0BhFr8eLEeZePMCrQwR4nThWc2EME8RuXnlcDSUCN9A
	 RrEEHOIyXHr1utLhw5oUWbR6vVdNtIzV256F3T2hZh7v0i1WuPG0LlAtOiEyBi6mkfjK9
	 rZ4wOZ8eq70Ny3euPD6NWfgNVHXubbfh8cH+cbjDiD33ghn+aRDiBYKvSR1rknZa2Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509169;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ECIETRSC6AfeLBZCYkHMk7HlVsPbIuG21c9KJDtowxU=;
	b=Y7iIqg37Uco3ecIVwrcPv2pxHcrUc5AqnKrI/QkwdfOItIEUZ/vhs1LOCMo0SdVKe4VD
	 89BEpBJ4JsdzmTC1GrbASXaYlqkXjaMETk/f60l0pcUZeMO9QWS6d7ZS3rF8xk83Dcda7
	 3ksQAmNK+5t/YwuPfofl472hJWEAWtfu7RSvcwpMkBTty/tmmKoxKddHkeWx664uKdzL3
	 L/TiQKLZ4t8q83G+TpwqwJ6Nu6dh2D8FV/WXLEPmgw7IyWE3PCJqwNQ7zDnKE26xbW2P0
	 8+zU8+Q69O1Q6vgxXYxO9uxxNsTP+IS7+HN2DOnBrhVnR6Nu04QZru90B6fwWaPHFeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbrvwFj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8723606A33E;
	Tue, 24 Nov 2026 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbrvwFj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492471F00A01;
	Tue, 24 Nov 2026 08:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795509169;
	bh=ECIETRSC6AfeLBZCYkHMk7HlVsPbIuG21c9KJDtowxU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NbrvwFj053913BQFODsWdbLKV2SHCt5l1HKw6gcNQFMhoqdb2r5ha4MsRi69SWhCp
	 MXpczA/oZpOdn+mPCTWpv+LHiRVL6SQTt4LiLRqZZXINOKVqelh9CN+NfEijUwQvIq
	 s14J4eUYy8e/B9KHZK0SlcVeFT/rrYjc4H/Fizcln04dr0Cznxmkb7KI2i9AI0d3W5
	 tW7tcTcQ4vZMp6JCkfnfNqBK+jsLm81dguQyD2Unek2UiaE4OCrcHVWUTs0YUVeMGR
	 vurn6n1jjrRxcXk9kgQv9qc9Acv+l1cU3QZ4/hVUXnWQ0gx7szsKpZZueDi9ZWu6/a
	 BUnVqJ+pNTORA==
Subject: Re: [PATCH net-next V2 1/5] net/mlx5: E-switch, add match-metadata
 allocator for nested VF/SF eswitches
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Tue, 24 Nov 2026 08:32:47 +0000
Message-ID: <179550916784.3135.15503627084704234984@kernel.org>
In-Reply-To: <20261120075959.2533702-2-tariqt@nvidia.com>
References: <20261120075959.2533702-2-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The layout selector added in
  mlx5_esw_match_metadata_alloc()/mlx5_esw_match_metadata_free() is…
- [Medium] The nested layout makes LAG admission and the encodable range
  disagree.
- [Low] The nested layout cuts the per-eswitch vport id space from 4094
  ids (2-4095) to 254 ids (2-255) (`vport_end_ida = (1 <<…

--

net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches

This patch adds a source-port match metadata allocator for nested (virt
LAG) VF/SF eswitches. Its layout is 8 bits for the function's slot in the
LAG xarray plus 8 bits for a per-eswitch vport id. The nested layout is
used for any non-PF eswitch, except one that is virt LAG capable but not
a LAG member.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 1323114ce7f93..3c1355f910906 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

[ ... ]

> +static u32 mlx5_nested_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
> +{
> +	u32 vport_end_ida = (1 << ESW_NESTED_VPORT_BITS) - 1;
> +	u32 max_idx = (1 << ESW_NESTED_IDX_BITS) -
> +		      (1 << (ESW_NESTED_IDX_BITS - ESW_PFNUM_BITS)) - 1;
> +	int idx;
> +	int id;
> +
> +	idx = mlx5_lag_get_member_idx(esw->dev);
> +	if (idx < 0 || idx > max_idx)
> +		return 0;

[Severity: Medium]
Can a LAG member be given a slot that this check then rejects?

mlx5_ldev_add_mdev() hands out slots 0-254:

    err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
                   GFP_KERNEL);

but max_idx here comes out to 239. A virt LAG VF/SF that lands in slot
240-254 is still a full member. mlx5_virt_lag_nonmember() returns false
for it, it passes the devcom pairing gate in
mlx5_esw_offloads_devcom_init(), and it gets the nested layout.

For such a member, every metadata allocation on its eswitch returns 0
here. esw_offloads_vport_metadata_setup() turns that 0 into -ENOSPC, so
switchdev can never be enabled on that function, and nothing is logged.

The comment above says only slots 0-239 are usable. Should virt LAG
admission stop at the encodable limit, or refuse such a joiner the same
way a late joiner is refused? Then LAG membership and match capability
would agree.

> +
> +	/* Use only non-zero id's (2-255). */
> +	id = ida_alloc_range(&esw->offloads.vport_metadata_ida,
> +			     MLX5_ESW_METADATA_RSVD_UPLINK + 1,
> +			     vport_end_ida, GFP_KERNEL);
> +	if (id < 0)
> +		return 0;

[Severity: Low]
This shrinks the per-eswitch id space from 2-4095 to 2-255. Does anything
make sure a nested eswitch has fewer vports than that needing metadata?

esw_offloads_metadata_init() allocates metadata up front for every vport,
and unwinds on the first failure:

    mlx5_esw_for_each_vport(esw, i, vport) {
        err = esw_offloads_vport_metadata_setup(esw, vport);
        if (err)
            goto metadata_err;

mlx5_esw_vports_init() creates SF vports from mlx5_sf_max_functions(dev),
and that is not limited to PFs:

    for (i = 0; i < mlx5_sf_max_functions(dev); i++) {
        err = mlx5_esw_vport_alloc(esw, idx, base_sf_num + i);

mlx5e_rep_bond_enslave() and the MPESW metadata take ids from the same
ida.

Suppose a nested VF/SF eswitch manager reports around 254 or more SFs.
The ida runs out, this function quietly returns 0, and switchdev enable
fails with -ENOSPC.

Commit a5bfbdfebd53 describes a non-PF eswitch as just the manager plus
uplink, so this may not be reachable today. Would it still be worth
clamping the vport count, or warning when it doesn't fit the 8-bit field?

> +	id = (idx << ESW_NESTED_VPORT_BITS) | id;
> +	return id;
> +}

[ ... ]

>  u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>  {
>  	u32 vport_end_ida = (1 << ESW_VPORT_BITS) - 1;
> @@ -3658,6 +3700,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>  	int pf_num;
>  	int id;
>  
> +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
> +		return mlx5_nested_esw_match_metadata_alloc(esw);
> +

[Severity: Medium]
Doesn't this condition also choose the nested layout for non-PF eswitches
that have no virt LAG capability at all?

mlx5_virt_lag_nonmember() is:

    return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);

Take a VF/SF eswitch manager without the virt LAG caps (no
multi_uplink_eswitch/lag_master, or num_lag_ports >= 2). For it,
mlx5_virt_lag_nonmember() returns false, so the condition above is true.

Such a device never gets an ldev, because mlx5_lag_add_mdev() returns
early:

    if (!mlx5_lag_is_supported(dev))
        return;

Later in the series this check becomes !mlx5_lag_is_supported(dev) &&
!mlx5_virt_lag_is_supported(dev), which still excludes the device.

So the call chain would be:

esw_offloads_metadata_init()
  esw_offloads_vport_metadata_setup()
    mlx5_esw_match_metadata_alloc()
      mlx5_nested_esw_match_metadata_alloc()
        mlx5_lag_get_member_idx() returns -ENOENT
      returns 0
    returns -ENOSPC

Match metadata is on by default where it is supported. Would switchdev
enable now fail on these devices?

Before this patch they used the PFNUM layout, where mlx5_sd_pf_num_get()
falls back to mlx5_get_dev_index(), and that worked. Non-PF eswitch
managers have been supported regardless of virt LAG caps since commit
a5bfbdfebd53 ("net/mlx5: E-switch, disable host functions for a non PF
e-switch manager").

The new comment in eswitch.h says this split is for a nested (virt LAG)
VF/SF eswitch. Would a condition that requires LAG membership, such as
!mlx5_core_is_pf(dev) && mlx5_lag_dev(dev), better match that intent?
mlx5_esw_match_metadata_free() uses the same condition.

Separately, at this commit even virt LAG capable VFs/SFs cannot get an
ldev. The later patch "net/mlx5: LAG, enable LAG over functions that do
not represent a physical port" fixes that part. The non virt LAG case is
still there at the end of the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com
