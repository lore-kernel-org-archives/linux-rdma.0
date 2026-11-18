Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025621;
	b=WyjCOcVFLnYiD2yA10nwwJ4bBVT44RVlr1qkvsL+0NsdCb9+fuYb7tdkh+8se0xiVW9B
	 zupIvFMoEyzTXu5dMiEu1BorlYvbfvW8wDa+8U8DxdftPzoUx82PYvR5AA8VYIw7+4Wrs
	 mSCpRSnO81j/GL9b4tIpw4/O4ioSQniemRcNOW+ps0erSZrWNbaYZgDbsSt9gZwgHx1LZ
	 21qycYYbNAIkVuV99lULGfS29XgN0o+xr421PT7OShAHDADgoXcyJcIvDoiXitt7G0HjB
	 TofZX0kYrxt8h99wTB22EY7W9RwsAERzk4GAhE50QIp3PAkUYIsX7kyE7Y9ZORAEQEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025621;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=RNHYn9Uwf55o6irSeRoRJDXCOCtcjhiRfm7mwVUfGnQ=;
	b=g0Cl86D8jJP+tGfAzKyUrqcq6e4q9MTdlp/n8mch1vu74PlOoUYghcbxcCxw4yuyRe4Y
	 dWuuD7wDP3+ggpQqpk016lBJIJXiYWtnNcT6aNrX9raMTfKSUKSQaBsR9ipgev1kYME72
	 xlHdLlFTq1+CpnHPCMEkZri1BMH2a5ns1kXh4KSqkEaGeV8D3Lsz5ZaJQQ3eYBXxioWaA
	 AG/rkT9Po8zwtld1/kX/rncXQHPjJhNDBwRW06nq7zpdVI0IRY5wDxQ2p1+MgbPb5qABr
	 0uwYnDYt8Zi/K+cutt03k7nlLxeDFCDI4EqKVXFkbDHmLPCivgyMEL2Vfx0maf7N00A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWehsiFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FB9606A325;
	Wed, 18 Nov 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWehsiFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D11F000C4;
	Wed, 18 Nov 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795025621;
	bh=RNHYn9Uwf55o6irSeRoRJDXCOCtcjhiRfm7mwVUfGnQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bWehsiFLMVL0rkfPobD94C5KM6JS/oObv9+Vx/5V6XdQrotyi6Iag/90eFPhO1c1m
	 hqJfAXOP+rSusgETD+FEEw0+6JZQUnShPwdL8vRwdbCy/LzxB/pMm7BiYrQdrgHULm
	 kGn5sjZT7nDzfA00fV/qKumkjHqqOIpumyoP/+p54s6W/oFoPnD024TiOzBnoCpzkl
	 wVEvoHyKKWOT0G3o9qJl9709ScwEB12rIhzid65Maxjtk5/OqWSlPXJGFIvD3WvzhM
	 SqZzblacmfn4JMP5Viqen8/pwZeuL2/7q29MwKd6X4c/s4SGlrcbVxWom0ODQtYIfi
	 KUqCNopVDur+g==
Subject:
 Re: [PATCH net-next] net: mlx5: Allow police as the last action of a TC rule
From: netdev-bot+sashiko@kernel.org
To: mohsin.bashr@gmail.com
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, cjubran@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2026 18:13:40 +0000
Message-ID: <179502562008.3136.323213503024507641@kernel.org>
In-Reply-To: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
References: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
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

- [High] This patch makes a rate police allowed as the last action.
- [Low] The `FLOW_ACTION_ACCEPT` change in `alloc_branch_attr()`
  (en_tc.c:3894-3897) changes how already-deployed police rules forward…

--

net: mlx5: Allow police as the last action of a TC rule

In switchdev mode, this commit lets mlx5 offload a TC rule whose only or
last action is police. tc_act_parse_police() now sets
MLX5_FLOW_CONTEXT_ACTION_FWD_DEST for rate police as well as mtu police,
so verify_attr_actions() no longer rejects the rule. The police ok result
now goes to the end of the TC chains instead of being treated as pipe.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> index 1bd1c94fb9776..52295f5d644c5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>  		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>  			return -EOPNOTSUPP;
>  
> -		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  		attr->flags |= MLX5_ATTR_FLAG_MTU;
>  	} else {
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>  		attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>  	}
>  
> +	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +

[Severity: High]
Every rate police now sets FWD_DEST, so verify_attr_actions() accepts a
police-last rule whatever its conform/exceed results are. What happens
when the result is pipe or jump? For example:

  action police rate 100mbit burst 1m conform-exceed drop/pipe

alloc_branch_attr() still sends PIPE and JUMP through set_branch_dest_ft().
That function only points the branch at the post_act table:

  attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
  attr->dest_ft = mlx5e_tc_post_act_get_ft(post_act);

It does not write FTEID_TO_REG. Only mlx5e_tc_post_act_set_handle() writes
that register, through mlx5e_tc_act_set_next_post_act().
alloc_flow_post_acts() calls that only when a following attr exists:

  if (next_attr && !(attr->flags & MLX5_ATTR_FLAG_TERMINATING)) {
          err = mlx5e_tc_act_set_next_post_act(flow, attr, next_attr);

The jumping_attr case set up in dec_jump_count() also needs a later attr.
When police is the last action, neither path runs.

The post_act rules match only on the register:

  mlx5e_tc_match_to_reg_match(spec, FTEID_TO_REG, handle->id, MLX5_POST_ACTION_MASK);

On chain 0 the register is 0 and ids start at 1. The lookup misses and the
packet falls through, which happens to behave like accept.

If the packet reached this rule through an earlier post_act hop, though,
nothing clears the register. Take a CT pipeline: chain 0 has "ct zone Z
pipe action goto chain 1", and a chain 1 rule has "ct_state +trk+est
action police ... conform-exceed drop/pipe".

In that setup, couldn't green packets go back to the post_act table, match
the chain 0 rule's entry again, repeat its actions (goto chain 1), hit the
same meter, and loop? Any mirror, redirect or counter in that earlier entry
would also run again.

mtu police already set FWD_DEST before this patch, so it had the same gap.
This patch now exposes it for rate police too.

Should pipe at the end of the action list, and jump past the end, also go
to the end of the TC chains as ACCEPT now does? Or should they be rejected?

>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 1d35c97aea0bc..8685e41487f39 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>  		break;
>  	case FLOW_ACTION_ACCEPT:
> +		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +		attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
> +		break;

[Severity: Low]
This isn't a bug, but the change also affects existing offloaded rules
where other actions follow police, not only police-last rules.

Before, ACCEPT fell through to PIPE (from commit f86488cb4685 "net/mlx5e:
TC, initialize branch flow attributes"). An ok branch went to the post_act
table and ran the following actions.

Now MLX5_ATTR_FLAG_ACCEPT makes esw_setup_dests() call
esw_setup_accept_dest(), which sends the branch to the chains end table.

tcfp_result defaults to TC_ACT_OK when TCA_POLICE_RESULT is absent, so the
common form is affected too:

  police ... conform-exceed drop action mirred egress redirect dev X

Conforming traffic that was redirected in hardware now goes to the end of
the chains.

This matches software TC semantics. Could it be split into its own fix
with a Fixes: f86488cb4685 tag? Could the commit message also say that
existing offloaded rules will forward traffic differently?

>  	case FLOW_ACTION_PIPE:
>  		err = set_branch_dest_ft(flow->priv, attr);
>  		if (err)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117031337.4126403-1-mohsin.bashr%40gmail.com
