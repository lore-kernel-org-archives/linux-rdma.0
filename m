Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795384983;
	b=Z9lHdDTTbJVuK6BmlLqDqvJtMGV/8mhvLms7OovAirs8lVJX+rU/60QNdC+DQPDww6WT
	 gbBbeTdcEkDH/mpSR13siNnFIu7p024cERemLVnsN671pAvi7rzeWleY71AxigdGM//MC
	 vBXxBtEZJhkdHQzUDIabaQE+tN7guObQa32TTGda+47jT/FImRUzrwKNhR55Ess8A6hyU
	 iIUrIf2vhhPe2a7lkckEm/vb9zOzeeNlIdDhJPy9PC3LXJ7v3RbwhYWhj1+lQ+c0P2Zpz
	 e4mphsjCEDSBwQWLhAdGQFgDGjpH0LBFotaPeQzPMJvK0AkCTw1l20VATvc/u9ZCdzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795384983;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Dd2jOoQYjx0SN+L+IeyhT47RMzYPHgA9OxlNT8tCwBI=;
	b=fTXj/161e5DOOPNzH0WXbu+UDlFFEjbcV6rZgkmcfgQdJiQcFAY00ph1hA69Hq9yP9zI
	 PB7YGYiEV9NDWwXxAUhNW/Q0ck95JkFPUmfDugRYB2xwIuTa0dARb8GcwLJxIKRi3rC7P
	 8XkYjrVqMF2i7oXyB31N0ZuNqwcw72UMTD1jPR3jdMrtSUVlb6F4X1gGN6vUP82eDi6cp
	 wLg6xUZ4RekPx4K/XCKMZebq1x9skEc1lqqwTwRDmPmGANy3vuIMCRj8fFwbjcOho5gRa
	 eYzGyC0DWbpp6EG5ON/olU8t4iWeij5wAr82F1IBYEe5eli727ssFHzux2t2hJR5D1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDJuNO4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DDF606A31A;
	Sun, 22 Nov 2026 22:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDJuNO4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA51F000C4;
	Sun, 22 Nov 2026 22:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795384982;
	bh=Dd2jOoQYjx0SN+L+IeyhT47RMzYPHgA9OxlNT8tCwBI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PDJuNO4CUPLHuiqMlmLyFurxPur31NPXnmTjgHIlZFWhq3zd8T9DSQZx6oRH+/0c9
	 3j2OBVZlXuzmKp4HyVvN2nsn2Ij9XaOCeMN3Jnqh/hcnx6FjEThs5yaWflzN1Kb1Ud
	 u16mu/r23Byz+MCFpQpJ/S2Dyw9pKIItSU6EseMzMpggwPXLMIp8aLmbEBMI2ymecT
	 lK3WDkn5KAs+Njpcu+tKc8QBtcHPlb5hI54r2j/og2LfsJ2vDfoDjDg/crXAgIQJ68
	 07JCnmVTuAnxGwngZbPhqoOZe58GvUeul9QuTNWXZ4Ok6p2rTsrR6BwJf9x+Cbfj8I
	 ShTxsQcMm9m4w==
Subject: Re: [PATCH net-next v2] net: mlx5: Allow police as the last action of
 a TC rule
From: netdev-bot+sashiko@kernel.org
To: mohsin.bashr@gmail.com
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, cjubran@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 22 Nov 2026 22:03:01 +0000
Message-ID: <179538498162.3135.15158973349412949279@kernel.org>
In-Reply-To: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
References: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
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

- [High] The patch rejects jump only when police is the last action, but
  leaves the same mismatch in place for every other police position.
- [Low] The patch fixes a user-visible bug but has no Fixes: tag, and the
  fix is folded into a feature change.

--

net: mlx5: Allow police as the last action of a TC rule

This commit lets a police action be the last (or only) action of an
offloaded mlx5 TC rule in switchdev mode. It sets the forward to the post
meter table while parsing police, and sends an ok result (and a pipe
result on the last police) to the end of the TC chains. It also rejects
jump when police is the last action.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> index 1bd1c94fb9776..faa0822b1136f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> @@ -49,6 +49,14 @@ tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
>  	if (err)
>  		return false;
>  
> +	if (flow_action_is_last_entry(parse_state->flow_action, act) &&
> +	    (act->police.exceed.act_id == FLOW_ACTION_JUMP ||
> +	     act->police.notexceed.act_id == FLOW_ACTION_JUMP)) {
> +		NL_SET_ERR_MSG_MOD(parse_state->extack,
> +				   "Jump on last police action is not supported");
> +		return false;
> +	}
> +

[Severity: High]
The commit message explains the rejection this way:

  "A jump counts from the start of the action list, so its target may be
  an earlier action or police itself."

That applies to a police at any action index k >= 1, not only to the
last one. Should this check use act_index and the remaining action count
rather than flow_action_is_last_entry()?

In software, tcf_action_exec() restarts from actions[0] and skips N
actions, so the target is the absolute index N:

net/sched/act_api.c:tcf_action_exec() {
    ...
		if (TC_ACT_EXT_CMP(ret, TC_ACT_JUMP)) {
			jmp_prgcnt = ret & TCA_ACT_MAX_PRIO_MASK;
			if (!jmp_prgcnt || (jmp_prgcnt > nr_actions)) {
				/* faulty opcode, stop pipeline */
				return TC_ACT_OK;
			} else {
				jmp_ttl -= 1;
				if (jmp_ttl > 0)
					goto restart_act_graph;
    ...
}

In mlx5, alloc_branch_attr() sets *jump_count = cond->extval, and
dec_jump_count() counts down once for each TC action after the police.
The hardware target ends up at k+N, measured from the police.

Some rules that still pass the new check:

  [pedit A, police drop/jump 1, B]
    TC jumps back to police and runs it again. mlx5 goes to B.

  [A, police drop/jump 2, B, C]
    TC runs B. mlx5 skips B and goes to C.

There is also the case of a jump that runs past the end of the list:

  [police1 drop/jump 3, police2 drop/pipe]

TC returns TC_ACT_OK here, because jmp_prgcnt > nr_actions. In mlx5,
jump_state.jump_count never reaches 0, so no attr gets jumping_attr.
police1->branch_true then keeps a plain post_act destination and reaches
police2. parse_tc_actions() never checks for a jump count left over
after the action loop.

Won't all of these rules be accepted for offload and then run a different
action sequence in hardware than TC runs in software?

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
This isn't a bug, but the change to FLOW_ACTION_ACCEPT handling in
alloc_branch_attr() fixes a user-visible mismatch with TC. Before, a
police ok result ran the actions after police. TC accepts the packet and
stops instead.

The old "case FLOW_ACTION_ACCEPT: case FLOW_ACTION_PIPE:" handling comes
from commit f86488cb4685 ("net/mlx5e: TC, initialize branch flow
attributes").

Could this fix be split from the police-only feature and given a Fixes:
tag? It would also help to state whether it is meant for net/stable, so
it can be routed on its own.

>  	case FLOW_ACTION_JUMP:
>  		if (*jump_count) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261119040010.1405900-1-mohsin.bashr%40gmail.com
