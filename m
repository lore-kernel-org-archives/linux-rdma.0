Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794971640;
	b=aBt5LfX0ISyNflFB59aGhYrR1iITqHgmufOlYEfuqah4NrTGzDMkrour1pNP/+e7Bxy7
	 gJPmelO8ucSDhnsk7RNvq2Az+CcO985LcfR3PCgJoCHoEGwxmxMx0NKKx1E7ntDgK6jW0
	 +e16sbvDAAivObpKuhvwdJBkn6Vqo+ZEKTnKfi36aGaLQi5wfiBOWrjjd2eOy91sngI2v
	 R1uSqvilZzPvkbtKuaMd2653vbnzTmZ2Bp5tD+0aQLmLC7Fc5VAryKH9Uffru6REunVFp
	 kbXTeU4A4nZ2ePdlg2damI8A5wOmIcFNXBWe1TGOlE7FgkewANEITfHHSqTI4rCfcdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794971640;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RNU+u23gu7czF0MbHvSk7T2zdyyOH07naq3hsBiJQJU=;
	b=3Di+mxcfihq/iQCmNhyj+lou2Vjx1qKVt0MGo6r4AhxXhNAujBYw5wO8r3rHShggxoBB
	 wWqnESutv+DyGAfWiIVlrPpGKDFPYsBCVF1FaiNw53wzWohdH+1ZJjMuTpfPYudKjVrU6
	 XGcIDawpnoHwaBqt2AtU7q1g7x3Hguvmshdu8i9v+JvD3YY2y4DsrMcY0AQEGVJYbcQhu
	 sHBM28RLr6+KVqrH2iQVBWZjYClnqiJqNHIEKTcBcq5fTI2sj4LuwOkr9VUcCBnc1YSIj
	 1XUIj87Espl4og0GOTrX+OZbrMRoQXjM6nTut5HPD4It/886JXLFqfNmcZpSFh8TkTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INC5f06C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D65D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 03:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INC5f06C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3891F000C4;
	Wed, 18 Nov 2026 03:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794971639;
	bh=RNU+u23gu7czF0MbHvSk7T2zdyyOH07naq3hsBiJQJU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=INC5f06Cuf20l0Pbm/kyBjfkifq9pDV53BOWLttQUW3R7/7AcnMLZsgSdqIqCdIq6
	 RxC7qfswM4swRUxcoA2BcInydbjIfXS5jyVDUmihUOSrydLEhulzdizSmJQ3hgnTep
	 1ucn1YLh//d3F0qRS1WhunuFXQ4mvMLUN0tPl/Kz7aZJrSe+ySlXBR79F16XwxsgTF
	 CsU/p1uZUXP9SztQ0RLoZEiTmre9U5BWyRX+48Y/9X3O7SNms8QViEhZCtsU4Hr+i3
	 wa4COJbyuu6II50Bs3M2qv0TneVkEq6BjFMB2lIgMBMKQsi6D8BQVS0IFXkmmd93M9
	 rPqAhMoks2xyw==
Message-ID: <sashiko-outbox-220007@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net: mlx5: Allow police as the last action of
 a TC rule
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mohsin Bashir" <mohsin.bashr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
References: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 03:13:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net/mlx5e: broken post_act steering when last police action
  uses pipe or jump
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Medium] net/mlx5e: memory leak of parse_attr on error path in
  alloc_branch_attr() [1]
--

commit bbe05fcd328438a7e5968a8a2b44d3bf4fffd2eb
Author: Mohsin Bashir <hmohsin@meta.com>

net: mlx5: Allow police as the last action of a TC rule

This commit sets MLX5_FLOW_CONTEXT_ACTION_FWD_DEST while parsing rate
police actions and updates alloc_branch_attr() to set MLX5_ATTR_FLAG_ACCEPT
for FLOW_ACTION_ACCEPT so police can be offloaded as the last action in a
TC rule.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b=
/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> index 1bd1c94fb9776..52295f5d644c5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *=
parse_state,
>  		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>  			return -EOPNOTSUPP;
> =20
> -		attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  		attr->flags |=3D MLX5_ATTR_FLAG_MTU;
>  	} else {
>  		attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>  		attr->exe_aso_type =3D MLX5_EXE_ASO_FLOW_METER;
>  	}
> =20
> +	attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +
>  	return 0;
>  }
> =20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index 1d35c97aea0bc..8685e41487f39 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>  		attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_DROP;
>  		break;
>  	case FLOW_ACTION_ACCEPT:
> +		attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +		attr->flags |=3D MLX5_ATTR_FLAG_ACCEPT;
> +		break;
>  	case FLOW_ACTION_PIPE:
>  		err =3D set_branch_dest_ft(flow->priv, attr);
>  		if (err)

[Severity: High]
What happens when a rule ends with a police action whose branch control is
FLOW_ACTION_PIPE (the iproute2 default for notexceed when configuring
"action police rate ... drop") or FLOW_ACTION_JUMP?

Setting MLX5_FLOW_CONTEXT_ACTION_FWD_DEST in tc_act_parse_police() lets a
trailing rate police action pass verify_attr_actions(), while
alloc_branch_attr() still sets branch_attr->dest_ft to post_act->ft for
FLOW_ACTION_PIPE and FLOW_ACTION_JUMP.  However, parse_tc_actions() only
splits the flow to allocate a subsequent post_act attribute when
i < flow_action->num_entries - 1, so next_attr is NULL in
alloc_flow_post_acts() and mlx5e_tc_act_set_next_post_act() never writes a
new FTEID_TO_REG or installs a target post_act rule.

Packets taking the pipe branch will miss in post_act->ft to the slow path
instead of reaching the end of the TC chains, or if an earlier multi-table
action preceded the final police action, FTEID_TO_REG still holds the final
police attribute's own post_act_handle->id and steers packets back into the
same police rule in a loop.

[Severity: Medium]
This problem wasn't introduced by this patch, but does the out_err path in
alloc_branch_attr() leak (*cond_attr)->parse_attr [1]?

mlx5e_clone_flow_attr_for_post_act() allocates both *cond_attr and a
separate (*cond_attr)->parse_attr via kvzalloc_obj(), but out_err only
calls kfree(*cond_attr) instead of a helper like free_branch_attr() when
set_branch_dest_ft() or branch validation fails.

[1] https://sashiko.dev/#/bug/linux-ad0e9c08-1f2f-44c7-a3a1-f3f69e4acf76

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117031337.4126=
403-1-mohsin.bashr@gmail.com?part=3D1
