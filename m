Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D138548A2B1
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246509; cv=none; b=Wfk0ZUwSx+V7Jw+j/Eg2czWjQU0ZtftUZAwGj6UKfSE8NcVaEvEIt/oSgJ3E2Cyggmv9Il8SWWEcq0J3jxihiGIOfOqG1GUvRhyVTU+QHa4506N2N3C3p0LypgADK7dEa4foaYeoVqf0q9legD1CrA3KsiBqworSH1JafpUscuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246509; c=relaxed/simple;
	bh=Mi1vIbFMrVldara7LDjqi09LptqVlMnvX+oH8hrPgc4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dEhkddbmciToVz+ukbPtd4M88r/GjaHZFN7GgoSEKcckrFgwcz8xj+vgP04VorSFnBr2BRvldRq/vo+WdL68dzydGLMqyIpfLcP7uUJ7ogum6gwli28esVfYz2EYszcPvGSnnxEFRYORu340peirlNzYqi40E/GG2qMm/tCf0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hX1usf0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hX1usf0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5FE1F008A3;
	Thu, 24 Sep 2026 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246506;
	bh=YJDqB7rPTcS3+8dxTPj6rHYDASNA0rbdJTMU/Ynb3+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hX1usf0B+t2lJ5Uv9NvIhqFTnxY7VHRqqPvc7UM5QoXYHiVX4XHwR7F9j7givl9pZ
	 3cv4PXY9U40XIihFnieN/HDRRaFAtwRWURXkJ1XD+7CfWtqWYg3tF5sT+fIIZw66N2
	 6fsfAyCDZ3w1oTnXD+m/Vlg41TqZR2W3aFq3ZaJkYQkb7fcRqqBkaSnedWvU9AP4yj
	 5zRpMEkp2r80C80vqaJQ7vW7TdUZy8bysgtcvlvKMwQfevQr522asaHczVGVEaspjE
	 Szm0sKfA8zghDE9J53XrRUV6XE1jmu85RSkS5ED3x7ZOA55r58qXKrcqUDpFBZD5xw
	 5k3SWQeI+xQpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 08/13] net/mlx5e: TC, track peer flows in a
 vhca_id xarray
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-9-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:45 +0000
Message-Id: <20260924104146.1E5FE1F008A3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/mlx5e: NULL pointer dereference in TC flow error cleanup
- [High] net/mlx5e: UAF of dup_peer_flows due to race with unpair
--

commit 92fc8821722bceca321f4825f3199f7c0d234a70
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: TC, track peer flows in a vhca_id xarray

The commit replaces a fixed-size esw->offloads.peer_flows[] array with an
xarray keyed by vhca_id to lift the MLX5_MAX_PORTS cap. A dup_peer_flows
list_head is created when eswitches pair over devcom and freed when they
unpair.

> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -4634,8 +4635,11 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_=
cls_offload *f,
>  	peer_flow->peer_orig =3D flow;
>  	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
>  	flow_flag_set(flow, DUP);
> +	dup_peer_flows =3D xa_load(&esw->offloads.peer_flows, peer_vhca_id);
> +	if (!dup_peer_flows)
> +		return -ENODEV;

[Severity: High]
Can this early return lead to a NULL pointer dereference during error
unwinding?=20

If xa_load() returns NULL, we return -ENODEV, leaving peer_flow->peer
completely uninitialized.

When the caller unwinds and calls mlx5e_tc_del_fdb_peer_flow(peer_flow),
it executes list_del(&peer_flow->peer) which will access NULL->next and
NULL->prev, causing a kernel panic.

>  	mutex_lock(&esw->offloads.peer_mutex);
> -	list_add_tail(&peer_flow->peer, &esw->offloads.peer_flows[i]);
> +	list_add_tail(&peer_flow->peer, dup_peer_flows);
>  	mutex_unlock(&esw->offloads.peer_mutex);
> =20
>  out:

[ ... ]

> @@ -5530,20 +5534,14 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv,=
 unsigned long flags)
> =20
>  void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
>  {
[ ... ]
> +	xa_for_each(&esw->offloads.peer_flows, index, dup_peer_flows)
>  		list_for_each_entry_safe(peer_flow, tmp_peer_flow,
> -					 &esw->offloads.peer_flows[i], peer)
> +					 dup_peer_flows, peer)
>  			mlx5e_tc_del_fdb_peer_flow(peer_flow);

[Severity: Low]
This isn't a bug introduced by this patch, but does flushing the entire xar=
ray
here wipe flows for all active peers when only a single peer unpairs?

When a devcom unpair event happens for a single peer, iterating over the
entire esw->offloads.peer_flows xarray unconditionally drops TC flows
duplicated to all active peers, rather than just the one disconnecting.
This behavior existed prior to the patch, but the patch carries it forward
without resolving the multi-peer limitation it claimed to lift.

> -	}
>  }

[ ... ]

> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3383,10 +3383,15 @@ static void mlx5_esw_offloads_rep_event_unpair(st=
ruct mlx5_eswitch *esw,
>  static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw,
>  				     struct mlx5_eswitch *peer_esw)
>  {
> +	struct list_head *dup_peer_flows;
> +
>  #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
>  	mlx5e_tc_clean_fdb_peer_flows(esw);
>  #endif
>  	mlx5_esw_offloads_rep_event_unpair(esw, peer_esw);
> +	dup_peer_flows =3D xa_erase(&esw->offloads.peer_flows,
> +				  MLX5_CAP_GEN(peer_esw->dev, vhca_id));
> +	kfree(dup_peer_flows);

[Severity: High]
Does this kfree() race with concurrent TC flow additions, leading to a
use-after-free?

In mlx5e_tc_add_fdb_peer_flow(), dup_peer_flows is retrieved locklessly
via xa_load(), and then usage is delayed behind acquiring peer_mutex:

mlx5e_tc_add_fdb_peer_flow() {
    dup_peer_flows =3D xa_load(&esw->offloads.peer_flows, peer_vhca_id);
    ...
    mutex_lock(&esw->offloads.peer_mutex);
    list_add_tail(&peer_flow->peer, dup_peer_flows);
}

Meanwhile, this unpair path does not hold peer_mutex before removing the
entry via xa_erase() and freeing it. If unpair runs concurrently with a
filter addition, can the addition thread wake up and call list_add_tail()
on the already freed dup_peer_flows list head?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D8
