Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8DF5328C5;
	Thu, 24 Sep 2026 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271963; cv=none; b=aEQAJ/i6tiY0DcMEpyZ35D7sqnGRzzS+GrDUefbUpVokgGN8AVl4aV6Xl3l052whziYDkRGlktkz4bMJovAjtsIH8cGCWTfPUZso5RnW488IrvRzD0giWotT1KOjcs0+9Va1QID1ryu3clFJVCGKXhGt7M6wqoAGNqD0xISA3VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271963; c=relaxed/simple;
	bh=ylc+FVx4V2EsrDTSl/HnZlOSqUvwnV3EXUZZRhvXePo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IcyyaU+oZGlu9jA14qtiIiKryR7V2H36yeCM8w9hRHf/hSLRYjfopMl6MOuK+B3IhPhNIY9vg+QVpGSbiYnD8ROY+nHLWIqAhp8IFPC+VOmY+lA+EruY58qycORDXUKCHKjH/qsYzrEmVdKJJdVh7GForgE+NLnJHxJVkCVhubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0208AMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0208AMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD171F00893;
	Thu, 24 Sep 2026 17:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271961;
	bh=cqXb+cezkmL5LbSAnK9s+h9OzlihTLkVIWBDb2AwAS4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=J0208AMJt26uMxQyGPRGZaE3ShgZiGwOotRymvzM4s6xGp031RLGwsc49kBCJweE/
	 OGJOSnSuKd64BAWVRpjXXyrO80vl5w1sqhf8zV/LRF+b3JGyTJ/nAn70v4B0p6Nie8
	 Yvh0IS0Sb/fDzlCWjRgpe1SUiwmajTXgRJsIlMddoDoeiBhRr4IaNFM5j93i4ABVzd
	 gjuo60dNBFLF+feQkKxkSqJglJ3zdtk2aAl5z6BGeYNLBN8PjEkzSs7v/p/sH4jfma
	 hwqGw5VOHp26Bt3dL/LC5YtzoVmdKd0hfyCvsjHrB8vu+wN8iQ/R0tl3rn2jivH9M9
	 VQY5Res80Iwnw==
Subject: Re: [PATCH net-next 08/13] net/mlx5e: TC, track peer flows in a
 vhca_id xarray
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:46:00 +0000
Message-ID: <179027196054.2160803.7584454012670398994@kernel.org>
In-Reply-To: <20260923103830.1183-9-tariqt@nvidia.com>
References: <20260923103830.1183-9-tariqt@nvidia.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch adds an early return to mlx5e_tc_add_fdb_peer_flow()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c).
- [Low] The commit message says "No functional change", but the patch
  changes runtime behaviour in mlx5e_tc_add_fdb_peer_flow() in two ways.

--

net/mlx5e: TC, track peer flows in a vhca_id xarray

This commit replaces the fixed esw->offloads.peer_flows[MLX5_MAX_PORTS]
array of list heads with an xarray keyed by the peer vhca_id. Each entry
is a heap-allocated list head that is created at devcom pair time and
freed at unpair time. mlx5e_tc_add_fdb_peer_flow() now looks the entry up
with xa_load() and returns -ENODEV if it is missing.

> This lifts the MLX5_MAX_PORTS cap: the number
> of peers is bounded only by the number of distinct vhca_ids.

[ ... ]

> No functional change.

[Severity: Low]
This isn't a bug, but is "No functional change" accurate here?

The same message says the patch lifts the MLX5_MAX_PORTS cap. The patch
also adds a new -ENODEV failure path to mlx5e_tc_add_fdb_peer_flow() for a
peer that has no peer_flows xarray entry (see the comment below). Before
this patch, once __mlx5e_add_fdb_flow() succeeded, the duplicated flow was
always linked.

The old add path also used an unchecked index:

	int i = mlx5_lag_get_dev_seq(peer_esw->dev);
	...
	list_add_tail(&peer_flow->peer, &esw->offloads.peer_flows[i]);

mlx5_lag_get_dev_seq() can return -ENOENT, and only
mlx5e_tc_clean_fdb_peer_flows() checked for i < 0. Removing that latent
out-of-bounds access also changes behavior.

Could the commit message describe these changes instead?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index fae4f8625da4d..c99e824b4c6dc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -4634,8 +4635,11 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
>  	peer_flow->peer_orig = flow;
>  	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
>  	flow_flag_set(flow, DUP);
> +	dup_peer_flows = xa_load(&esw->offloads.peer_flows, peer_vhca_id);
> +	if (!dup_peer_flows)
> +		return -ENODEV;

[Severity: High]
What happens to peer_flow when xa_load() returns NULL here?

By this point __mlx5e_add_fdb_flow() has already offloaded the duplicate
rule to the peer FDB. peer_flow is on flow->peer_flows and DUP is set.

peer_flow->peer has not been linked, and it was never initialized either.
mlx5e_alloc_flow() allocates the flow with kzalloc_obj() and calls
INIT_LIST_HEAD() on peer_flows, hairpin, l3_to_l2_reformat, attrs and
encaps[], but not on peer. So peer.next and peer.prev are NULL.

The caller then unwinds like this:

mlx5e_add_fdb_flow()
  mlx5e_tc_add_fdb_peer_flow() returns -ENODEV
  goto peer_clean
  mlx5e_tc_del_fdb_peers_flow(flow)
    mlx5e_tc_del_fdb_peer_flow(peer_flow)
      mutex_lock(&esw->offloads.peer_mutex);
      list_del(&peer_flow->peer);

Can this list_del() dereference NULL? If it does, the oops happens while
peer_mutex and the devcom read semaphore are held. It also happens before
mlx5e_tc_del_fdb_flow() and clean_flow remove the peer and original FTEs
from hardware.

Can a NULL xa_load() actually happen? mlx5_devcom_for_each_peer_entry()
calls mlx5_devcom_get_next_peer_data(), which returns every registered
comp_dev with non-NULL data. It does not check esw->paired. A peer can be
registered without having a peer_flows entry in at least three ways:

- devcom_alloc_comp_dev() adds the new member to comp_dev_list_head before
  mlx5_esw_offloads_devcom_init() sends ESW_OFFLOADS_DEVCOM_PAIR in a
  separate locked section. An eswitch that is already paired can add a
  rule in between.

- mlx5_esw_offloads_unpair() erases and frees the entry, but the member
  stays on the list until mlx5_devcom_unregister_component(). comp->ready
  also stays true while other pairs remain.

- mlx5_esw_offloads_devcom_event() skips pairing when the metadata setting
  differs:

	case ESW_OFFLOADS_DEVCOM_PAIR:
		if (mlx5_eswitch_vport_match_metadata_enabled(esw) !=
		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
			break;

  An admin can change that setting through the esw_port_metadata devlink
  param. The peer then stays iterable with no xarray entry.

Before this patch the target was a statically initialized peer_flows[]
list head, so nothing could fail after the hardware write.

Would it make sense to do the xa_load() before __mlx5e_add_fdb_flow(), or
otherwise make sure peer_flow->peer is valid on this error path?

>  	mutex_lock(&esw->offloads.peer_mutex);
> -	list_add_tail(&peer_flow->peer, &esw->offloads.peer_flows[i]);
> +	list_add_tail(&peer_flow->peer, dup_peer_flows);
>  	mutex_unlock(&esw->offloads.peer_mutex);
>  
>  out:

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
