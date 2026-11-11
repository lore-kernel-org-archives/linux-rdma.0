Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418489;
	b=iD4VskO5NzYc+xwZaqS3masoD+AMH/FY317XGdppOU3wxokrDp/PA8QLX1WXJdhPao+m
	 epLO9GZZaNGbpowfg3Wbog0D4y/OfxE2Nf0zY+5hjYnES9Mx+P5GY52mtJWNSJWNRNswM
	 YjbkhQV4kxg6I1D+VRFfz++8nRBHbqq263035W3hBmnG/teaC5mWxMCvwDH5+4BNo09Oe
	 1m/6vL6tmFVrfNJxc2R8JKJC3Ulh3KOKXXnTt4IaP4CKz3UEYaW47653j3AMa/mi/2zFc
	 8lbXvnNb5d7Dewu/OMUwghdJiIHvJpaHAvpGtkJzMjXv1hdx4PR/qSWKWMjFi9Xhdmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418489;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FNluiPJ7F+Cn7/2xRPOJAlpKpFHd95L6uojgtai2vcc=;
	b=aMzmwlBgUa0/WKs/Bu7YF9WP0w191oSd0Ilafdxpe/ZcifDMHeg+RtbATF0+lD9iuR5z
	 EKkm/bLpf6XlWrroPy1/hq3Bqzgbvc71CKpbon6nhnNGfpRNMoQecj8UguvAbY4u+I6td
	 ofUSfwT5IP7Sv2Tn5BBzyymxP6Q5WITNvbIsFYUWkFwCf6HyR60Ouj6Ojw4rjev7SxP2j
	 CBztig1bpaioMZ10JYyhJTNevabDCUhJgOIl9OLbLPIv00QUCPlmQHiujVXWHrZunuKNv
	 c8ymADvPUo/vVJzr0zuLKbNuIenXFZrxpJ9XtsqABLoq04j2jS4rgYThntZN8iksOKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lXEwaKO3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88C606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lXEwaKO3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583A71F00A05;
	Wed, 11 Nov 2026 17:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794418489;
	bh=FNluiPJ7F+Cn7/2xRPOJAlpKpFHd95L6uojgtai2vcc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lXEwaKO3VX9eBueeM8CwZO7C0tdFEtgue3/8N7oxOEK7yTzZb/UxNPnpG4cXVuceo
	 HitNfAwA8dJCFi69kdh8LHDLAIPaikYS29PUJvcWUCfh7tfn2tFAh2dHxHr9Tfzg18
	 bCelTNX4w/F1GI4gPigj3SZyWfjx6qt62hheKxlGPHLb2muNYMXHdmysr1RYIdCTMa
	 Z31EallnPu31nwseTs8h333DIbcPTJ3JKOfTVqTqNleKQptx/4gdY0C4vvwcuopwI+
	 +r8YGLi+V1SFt07GC4PIi4bTv2ILV9HyzJZ/jvChutlSiyt6/xirEZibWR2Vf5345M
	 qkwHMfwhFUGyg==
Message-ID: <sashiko-outbox-209418@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: HWS, fix flow meter release on FTE update
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110173437.2471233-1-acassen@corp.free.fr>
References: <20261110173437.2471233-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 17:34:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] net/mlx5: null pointer dereference in
  mlx5_fs_destroy_fs_action() [1]
--

commit a0812bfa068bccb4957fe6b500d9c96fead53b69
Author: Alexandre Cassen <acassen@corp.free.fr>

net/mlx5: HWS, fix flow meter release on FTE update

This commit stores the ASO meter base_id directly in struct
mlx5_fs_hws_rule_action instead of keeping a pointer to the FTE's exe_aso,
preventing FTE updates from releasing the new rule's meter action.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.=
c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 812b2f3cddcff..cbcbc2b62809d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
[ ... ]
> @@ -704,7 +704,7 @@ static void mlx5_fs_destroy_fs_action(struct mlx5_flo=
w_root_namespace *ns,
>  		mlx5_fc_put_hws_action(fs_action->counter);
>  		break;
>  	case MLX5HWS_ACTION_TYP_ASO_METER:
> -		mlx5_fs_put_action_aso_meter(fs_ctx, fs_action->exe_aso);
> +		mlx5_fs_put_action_aso_meter(fs_ctx, fs_action->aso_base_id);
>  		break;
>  	case MLX5HWS_ACTION_TYP_SAMPLER:
>  		mlx5_fs_put_dest_action_sampler(fs_ctx, fs_action->sampler_id);
> @@ -937,7 +937,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_fl=
ow_root_namespace *ns,
>  			fte_action->exe_aso.flow_meter.init_color;
>  		(*ractions)[num_actions++].action =3D tmp_action;
>  		fs_actions[num_fs_actions].action =3D tmp_action;
> -		fs_actions[num_fs_actions++].exe_aso =3D &fte_action->exe_aso;
> +		fs_actions[num_fs_actions++].aso_base_id =3D fte_action->exe_aso.base_=
id;
>  	}
> =20
>  	if (fte_action->action & MLX5_FLOW_CONTEXT_ACTION_DROP) {

[Severity: High]
This problem wasn't introduced by this patch, but can
mlx5_fs_destroy_fs_action() dereference a NULL fs_action->action when
dest_action creation fails in mlx5_fs_fte_get_hws_actions() [1]?

Later in mlx5_fs_fte_get_hws_actions(), the MLX5_FLOW_DESTINATION_TYPE_RANGE
case (as well as MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM and
MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER) appends dest_action to fs_actions[]
and increments num_fs_actions before checking whether dest_action is NULL:

drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c:mlx5_fs_fte_g=
et_hws_actions() {
	...
			case MLX5_FLOW_DESTINATION_TYPE_RANGE:
				dest_action =3D mlx5_fs_create_dest_action_range(ctx, dst);
				fs_actions[num_fs_actions++].action =3D dest_action;
				break;
			...
			}
			if (!dest_action) {
				err =3D -ENOMEM;
				goto free_actions;
			}
	...
free_actions:
	mlx5_fs_destroy_fs_actions(ns, fs_actions, num_fs_actions);
}

When mlx5_fs_create_dest_action_range() returns NULL, the free_actions
cleanup path passes that NULL entry to mlx5_fs_destroy_fs_action(), which
immediately dereferences fs_action->action in mlx5hws_action_get_type().

[1] https://sashiko.dev/#/bug/linux-13dff211-595e-45fa-ac59-340929fc7d57

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110173437.2471=
233-1-acassen@corp.free.fr?part=3D1
