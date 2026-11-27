Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818730;
	b=xN2Rq+R5hvxByXCWrret9TSw/YWm8wTrwFHtP7NdJfi9LQgcswGoKVphy6ygXh11JMx8
	 TLF9MKilTILbpzlicoEJ0GIEQSUSRTC7CqHMFSCKCtomqb/ikVQ04uDlpTHVPr8QSDybe
	 fCWrvBpG+2t/R18in3k5A7FdGsMXlcQk1XibFD9coErYOVJVruVVrLFm98fQu9WZexVio
	 2JHihiqw4WHlMgqSPLQ/pqG2gc+RJndBoSsnAp0ONVjqe/uwISYNcg+ZkwzlR56TBte/B
	 3owbsg9xon472bxFOcm9nFsImHBap7k1qAB3lH2Y73yE/OQUfmlkBnUZQUwd2mlf+bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818730;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vAMhC1D3GE29080muE+ONPPerMaiCVZ5OFDSqcVKNSM=;
	b=opQuGbrvjZbdsiBktTzbJH+BT+8aTA3ATCQpMqUrq8Bn4TB/7UVwCIFu9Qu1+oZr43MR
	 UrDW2zyi2z1e5w06jLAtDCK1YzHf0CZ0b6xz9CCUnGjV0YeFIBp44uNEkYjnr+UmoGy+t
	 ThHEir3+27n2f9aXWibcNbAXMz9NMooPmLEfOJuhn8D+FtQvFi0UvOQwSmBX8KntdU6m5
	 KCHQZ1TGwYxsMlY2Ou5EwfNrXHYXes76tqopCLl22sSHQKD2UqnWUiUxJsA50AlXA+Qx7
	 iW/sQtdfnKjtXfcJ/xPmV84MkJCj09h76JsBn58xMu3JKDmm2JcK3Mk5Dhrvg1QPO/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WebihxBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A60606A31E;
	Fri, 27 Nov 2026 22:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WebihxBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04931F00898;
	Fri, 27 Nov 2026 22:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818730;
	bh=vAMhC1D3GE29080muE+ONPPerMaiCVZ5OFDSqcVKNSM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WebihxBDbeXaxZ9c1KgoBjkbuuOn5sWs5SmbYPaEDR98MdO52YDQ2NfE42MEKRPBz
	 Rs0ogi2BDyzjlHndHfd3fFDBBdouBtQyDSqGMC3FWU50QT2YSqUuoZ+EdyzifdQJGI
	 +XMhs0k57adLVw60umMVxXltuJF2t477XDT5KNbhV7yeHtCMpZ4P/ei1lXjtNOuY7o
	 Ju2zCxB+8YH1EL1doS8MhztS3KvlLoySgCa4Bf0M2h7T4dBT5dGYqu/FZwbotUjWea
	 tkMMTlDp83DNiMw4KdQdQHVJ0KqqC9/J3DtSVzThyt8SHdm5zTAlGGIhggx4tm+vGY
	 +YUYfmbXox79g==
Subject:
 Re: [PATCH net 03/10] net/mlx5e: Fix IPsec SA modify/stats update race
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:08 +0000
Message-ID: <179581872820.3135.14479664745812927249@kernel.org>
In-Reply-To: <20261126215614.792598-4-tariqt@nvidia.com>
References: <20261126215614.792598-4-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (3) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] This patch moves rx_mapped_id into struct mlx5e_ipsec_rule, so
  the existing `memset(&sa_entry_shadow.ipsec_rule, 0, ...)` in…
- [Low] The commit message does not match the code.

Pre-existing issues:
- [Medium] Baseline decision is false: the last patch in the series fixes
  this.
- [Medium] Baseline decision is false: pre-existing, medium severity, and
  not claimed or relied on by this patch.
- [Medium] Baseline decision is false: the last patch in the series fixes
  this.

--

net/mlx5e: Fix IPsec SA modify/stats update race

This commit moves the eswitch RX mapped id from struct
mlx5e_ipsec_sa_entry into struct mlx5e_ipsec_rule. It also changes
mlx5e_accel_ipsec_fs_modify(): the new rule is now swapped into
sa_entry under x->lock and the old rule is deleted afterwards. Before,
the old rule was deleted first and the whole shadow entry was memcpy'd
back.

> Fix that by:
> - moving the eswitch RX mapped id into struct mlx5e_ipsec_rule so
>   everything related to rule creation is in the same struct.
> - swap the pointer to it under x->lock to avoid the race.

[Severity: Low]
Is "swap the pointer" accurate here? ipsec_rule is an embedded member,
not a pointer:

struct mlx5e_ipsec_sa_entry {
	...
	struct mlx5e_ipsec_rule ipsec_rule;
	...
};

So swap(sa_entry->ipsec_rule, sa_entry_shadow.ipsec_rule) copies the
whole struct by value. That covers the flow handles, modify_hdr,
pkt_reformat, the four mlx5_fc pointers and rx_mapped_id. It is a
multi-word copy, and only readers holding x->lock see it atomically.

The message also doesn't mention that the old write-back was removed:

	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));

Without it, attrs, esn_state, limits and ctx are no longer reset to the
snapshot taken at the start of mlx5e_accel_ipsec_fs_modify(). That
looks harmless, since the add_rule paths only write ipsec_rule fields.

Could the commit message describe both of these more precisely?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> index f4b2d7b950c00..9bbcd9e4c3197 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> @@ -215,6 +215,7 @@ struct mlx5e_ipsec_rule {
>  	struct mlx5e_ipsec_drop replay;
>  	struct mlx5e_ipsec_drop auth;
>  	struct mlx5e_ipsec_drop trailer;
> +	u32 rx_mapped_id;
>  };

[Severity: Medium]
Now that rx_mapped_id lives in struct mlx5e_ipsec_rule, does the
existing memset in mlx5e_accel_ipsec_fs_modify() also clear the
shadow's mapped id?

mlx5e_accel_ipsec_fs_modify() {
	...
	memcpy(&sa_entry_shadow, sa_entry, sizeof(*sa_entry));
	memset(&sa_entry_shadow.ipsec_rule, 0x00, sizeof(sa_entry->ipsec_rule));

	err = mlx5e_accel_ipsec_fs_add_rule(&sa_entry_shadow);
	if (err)
		return;
	...
}

rx_add_rule() only allocates a new mapped id when the SA is not in drop
mode:

	if (!attrs->drop) {
		if (rx != ipsec->rx_esw)
			...
		else
			err = mlx5_esw_ipsec_rx_setup_modify_header(sa_entry, &flow_act);

Consider mlx5e_ipsec_handle_sw_limits() setting attrs.drop = true and
calling mlx5e_accel_ipsec_fs_modify() for an RX SA on rx_esw.
mlx5_esw_ipsec_rx_rule_add_match_obj() then builds the auth, trailer
and replay status drop rules with metadata_reg_c_1 == 0. Before this
patch, the modify path reused the SA's existing unique id.

On rx_esw, reg_c_1 is the only per-SA field in those matches. Every
drop-mode SA therefore ends up with identical FTEs that use
FLOW_ACT_NO_APPEND. SAs added in drop mode because the neighbour was
unresolved already had id 0. This patch extends that to every SA that
hits hard expiry.

Under HW steering, mlx5_cmd_hws_get_capabilities() doesn't report
MLX5_FLOW_STEERING_CAP_DUPLICATE_MATCH for FDB. add_rule_dup_match_fte()
then allows only one duplicate:

	if (!list_empty(&fte->dup->children)) {
		mlx5_core_warn(get_dev(&fte->node),
			       "Can have only a single duplicate rule\n");
		return ERR_PTR(-EEXIST);

Suppose two or more drop-mode SAs are already installed on rx_esw. Can
rx_add_rule() then fail for the expiring SA? If it does,
mlx5e_accel_ipsec_fs_modify() returns silently. Software has
attrs.drop = true, but the hardware keeps the old decrypt and forward
rule until the state is freed.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 0facc54771558..d0f738fdeff3d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -2845,8 +2845,11 @@ void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
>  	if (err)
>  		return;
>  
> -	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
> -	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));
> +	spin_lock_bh(&sa_entry->x->lock);
> +	swap(sa_entry->ipsec_rule, sa_entry_shadow.ipsec_rule);
> +	spin_unlock_bh(&sa_entry->x->lock);
> +
> +	mlx5e_accel_ipsec_fs_del_rule(&sa_entry_shadow);

[Severity: Medium]
This is a pre-existing issue, but does taking x->lock here fully close
the race the commit message describes?

mlx5e_xfrm_update_stats() accepts other locks instead of x->lock:

	lockdep_assert(lockdep_is_held(&x->lock) ||
		       lockdep_is_held(&net->xfrm.xfrm_cfg_mutex) ||
		       lockdep_is_held(&net->xfrm.xfrm_state_lock));

Some callers hold only xfrm_state_lock or xfrm_cfg_mutex:

xfrm_state_update_stats()      /proc/net/xfrm_stat, xfrm_state_lock
  -> xfrm_dev_state_update_stats()
    -> mlx5e_xfrm_update_stats()

copy_to_user_state()           SA dump under xfrm_state_lock,
                               xfrm_get_sa under xfrm_cfg_mutex
  -> xfrm_dev_state_update_stats()
    -> mlx5e_xfrm_update_stats()

The following sequence looks possible:

1. Such a reader loads an old ipsec_rule->fc (or auth.fc, trailer.fc,
   replay.fc) pointer.
2. The worker runs mlx5e_accel_ipsec_fs_del_rule(&sa_entry_shadow),
   which calls mlx5_fc_destroy().
3. The reader's mlx5_fc_query_cached() then reads and writes
   lastbytes/lastpackets on the freed mlx5_fc.

The same race existed before this commit. The last patch in this
series, "net/mlx5e: Create IPsec flow counters once per SA", moves the
counters into sa_entry->fcs[] and stops destroying them in del_rule. It
is still reachable at this commit, though.

[Severity: Medium]
This is also a pre-existing issue, but are counter deltas lost here?

mlx5e_accel_ipsec_fs_del_rule(&sa_entry_shadow) destroys the old
ipsec_rule.fc, auth.fc, trailer.fc and replay.fc without a final
mlx5_fc_query_cached(). Any delta gathered since the last
mlx5e_xfrm_update_stats() never reaches x->curlft.packets/bytes or
x->stats.integrity_failed/replay. The replacement counters start at
zero, so each neighbour update or expiry rebuild under-counts the SA.

The same later series commit, "net/mlx5e: Create IPsec flow counters
once per SA", keeps the counters in sa_entry->fcs[] across rebuilds. Its
commit message says it fixes these lost counter values.

>  }

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
> index f8c97954b6eaf..2615bbc89a16d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
> @@ -85,7 +85,7 @@ int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
>  		goto err_header_alloc;
>  	}
>  
> -	sa_entry->rx_mapped_id = mapped_id;
> +	sa_entry->ipsec_rule.rx_mapped_id = mapped_id;

[Severity: Medium]
This isn't a bug introduced by this patch, but does rx_add_rule() leak
this mapped id on its later error paths?

Once mlx5_esw_ipsec_rx_setup_modify_header() succeeds, it has allocated
an id in ipsec->ipsec_obj_id_map with xa_alloc_bh(). Later steps can
still fail: setup_pkt_reformat, mlx5_fc_create, mlx5_add_flow_rules,
and the sa_sel, replay, auth and trailer rule creation. Those failures
unwind through err_add_flow, err_add_cnt, err_pkt_reformat and
err_mod_header. These labels free the modify header but never erase
the xarray entry.

mlx5_esw_ipsec_rx_id_mapping_remove() is only called from
mlx5e_accel_ipsec_fs_del_rule(). In the modify path the id is held only
in the on-stack shadow, so it is lost for good when this returns:

	err = mlx5e_accel_ipsec_fs_add_rule(&sa_entry_shadow);
	if (err)
		return;

The same leak existed with sa_entry->rx_mapped_id, and it is still
present at the end of the series.

>  	flow_act->modify_hdr = modify_hdr;
>  	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
>  

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
