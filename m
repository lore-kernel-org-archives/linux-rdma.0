Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709097;
	b=AvjIP3FrXxF/aAu+grGiMBdJ04JjFTR4XE70OVKgwKwKPF0M/StZUsRAghJiU/U/vQ9X
	 khXDgb+LmZhtcvy1lzBoROKweBOI2hTRVum/TEfwgKPGpKig/iGKhBoUglLl0Oi7wcXog
	 ocfQ0Pie2FimBUmq8U4faa/XwzUj2aJMomnKA2MsO5novJw4htqw6dF/6vx/zYQXenyfl
	 LzzRr8fX5oSfXpmpAy5q47LbVeUGpH1J7CVVQosbWH1OB8o44kMtIM7Mpxp8Lq0DMxOsZ
	 43I5utzJaDE90CgwL4sMmrPrmbqG1iFd/9HU/w93rJU0WooIfZ427vNpDDrWutzI0MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709097;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=d/2tJQDcchY0DPGsSZf2yoUNHp1knyhio4rAvJAFD3U=;
	b=pTpt8QZApPGXeZ7mAXqBB8oE0QhWgZHwd1aC49sXPW3yt7GOj3QLdZqiq54g/TCrqvFq
	 PuyX2ko8psBpvqgulIHAyUbEq+wpOaoisqAcSSheqqIv/To5QwL0AYxiJwCfcBeorAjtF
	 veowvkcglhK7aYU2fhq5TjotcG4sJgoQ4R9u+ziQ7lN92D6PQ6xnfH5dELAB7apBnS8Z1
	 qVPbrrlxZWp0hKAdhgLm5VyCZfE1/uidt6eFF3KUTnAg+NYXH3dbWJUVq6XdhYiqKZSc/
	 lhQ3zoYtuJj1yqQfHJYrle9EXi0T02YKTQ88hdVDOxHgK0VPdMit8g0q1mTbYu0MPrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="f/oQ548I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6146606A321;
	Thu, 26 Nov 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f/oQ548I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686501F000C0;
	Thu, 26 Nov 2026 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795709097;
	bh=d/2tJQDcchY0DPGsSZf2yoUNHp1knyhio4rAvJAFD3U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f/oQ548IJWqULmchlbJljEYQeE9S+Je69cP7gg+KktYcLlb43hznA8rqEm0SNKt/u
	 JzM3h10iezHW9f4euAZS5Olic4COfqp1GRFrIcjuudQs64XDpByedCTy2LDpeI2AOT
	 4rjPgr3FrMPXpH2j+dVnqlPVuhwDXwsi5gbPhojSIxWMnUawVaNKDDgf7b97dIt++3
	 7C/+nUPKVs4iAZktrUzxVs9QLo9qbgEYp1fIvDTAIPVbNYmyyBAWRQ0NhhEWy8LH6H
	 sZ1q2AdHhGGb3NScvs/7EdF/eUbBxmX6EJ6TNraamNVM71OsBrXKyEixpftN+aBCNH
	 T8KHbHrqc/1/w==
Subject: Re: [PATCH net-next v3] net: mlx5: Allow police as the last action of
 a TC rule
From: netdev-bot+sashiko@kernel.org
To: mohsin.bashr@gmail.com
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, cjubran@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 26 Nov 2026 16:04:55 +0000
Message-ID: <179570909592.3135.1382351175870070773@kernel.org>
In-Reply-To: <20261124220251.776944-1-mohsin.bashr@gmail.com>
References: <20261124220251.776944-1-mohsin.bashr@gmail.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In police_act_can_offload_jump()
  (drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c), every…
- [Low] Besides adding police-as-last-action support, the patch fixes two
  hardware/software mismatches in existing offloaded rules, both present…

--

net: mlx5: Allow police as the last action of a TC rule

This patch lets mlx5 offload TC rules in switchdev mode where police is
the last action. It also changes how police results are offloaded: ok is
now accept, pipe as the last action is accept, and a jump is only
offloaded when police is the first action and the skipped actions are all
drop or all ok. The forward to the post meter table is now set for rate
police as well as mtu police.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> index 1bd1c94fb9776..f03a992cbc270 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> @@ -37,6 +37,52 @@ static int police_act_validate(const struct flow_action_entry *act,
>  	return 0;
>  }
>  
> +static bool
> +police_act_can_offload_jump(struct mlx5e_tc_act_parse_state *parse_state,
> +			    const struct flow_action_entry *act,
> +			    int act_index, u32 target)
> +{

[ ... ]

> +	prev = act;
> +	for (i = 1; i <= target; i++) {
> +		entry = &flow_action->entries[i];
> +
> +		if (i < target &&
> +		    ((entry->id != FLOW_ACTION_DROP &&
> +		      entry->id != FLOW_ACTION_ACCEPT) ||
> +		     entry->id != flow_action->entries[1].id)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Jump can only skip actions that are all drop or all ok");
> +			return false;
> +		}

[Severity: Medium]

Does this check stop offloading police-first jump rules that were offloaded
correctly before this patch?

tc_act_can_offload_police() calls police_act_can_offload_jump() for each
jump result of both rate and mtu police. With police at index 0, any
skipped action other than drop or ok is now rejected. For example:

  action police mtu 1500 conform-exceed pipe/jump 2 \
  action mirred egress redirect dev A \
  action mirred egress redirect dev B

Before this patch, dec_jump_count() already handled this case when police
is at index 0. jump_count is set to extval and decremented once per
distinct TC action, so the jump lands on the same entry where
tcf_action_exec() restarts.

The last skipped action is either marked terminating or forwarded to the
post action table (as for mirror):

dec_jump_count() {
    ...
		if (tc_act->is_terminating_action) { /* the branch ends here */
			attr->flags |= MLX5_ATTR_FLAG_TERMINATING;
			...
		} else { /* the branch continues executing the rest of the actions */
			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
			...
}

With this patch these rules fail can_offload with "Jump can only skip
actions that are all drop or all ok". With skip_sw the filter add fails.
Without skip_sw (for example with OVS) the traffic goes to the software
datapath.

The only flaw the commit message names in the old jump handling is that
the jump is counted from police instead of from the start of the action
list. That cannot happen when police is at index 0, and the act_index
check above already rejects the other case.

Is the extra all drop or all ok restriction needed? If it is intentional,
could the commit message say that rules which offload today will stop
offloading, instead of only "Reject the rest"?

> +
> +		if (entry->id == prev->id && entry->hw_index == prev->hw_index) {

[ ... ]

> @@ -49,6 +95,16 @@ tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
>  	if (err)
>  		return false;
>  
> +	if (act->police.exceed.act_id == FLOW_ACTION_JUMP &&
> +	    !police_act_can_offload_jump(parse_state, act, act_index,
> +					 act->police.exceed.extval))
> +		return false;
> +
> +	if (act->police.notexceed.act_id == FLOW_ACTION_JUMP &&
> +	    !police_act_can_offload_jump(parse_state, act, act_index,
> +					 act->police.notexceed.extval))
> +		return false;
> +
>  	return !!mlx5e_get_flow_meters(parse_state->flow->priv->mdev);
>  }

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 1d35c97aea0bc..7e7111e6d058b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -3891,11 +3891,17 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>  	case FLOW_ACTION_DROP:
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>  		break;
> -	case FLOW_ACTION_ACCEPT:
>  	case FLOW_ACTION_PIPE:
> -		err = set_branch_dest_ft(flow->priv, attr);
> -		if (err)
> -			goto out_err;
> +		if (!last) {
> +			err = set_branch_dest_ft(flow->priv, attr);
> +			if (err)
> +				goto out_err;
> +			break;
> +		}
> +		fallthrough;
> +	case FLOW_ACTION_ACCEPT:
> +		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +		attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>  		break;

[Severity: Low]

This isn't a runtime bug in the patch. However, this hunk and the
act_index check in police_act_can_offload_jump() also fix two
hardware/software mismatches in rules that are already offloaded.

First, alloc_branch_attr() handled an ok police result like pipe. For
"police ... conform-exceed drop/ok action mirred ...", the hardware ran
the following actions for conforming packets, while tcf_action_exec()
stops at TC_ACT_OK.

Second, dec_jump_count() counts a police jump from the police action,
while TC counts from the start of the list. With police at a non-zero
index, the hardware ran different actions than software did.

Both seem to date back to the branching support in commit f86488cb4685
("net/mlx5e: TC, initialize branch flow attributes") and its follow-up
c84fa1ab94a77c ("net/mlx5e: TC, initialize branching action with target
attr").

The commit message describes the behavior change, but there is no Fixes:
tag, and the fixes are mixed with the new police-as-last-action support.
Could these fixes be split out and sent to net with Fixes: tags, so that
stable trees pick them up?

>  	case FLOW_ACTION_JUMP:
>  		if (*jump_count) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124220251.776944-1-mohsin.bashr%40gmail.com
