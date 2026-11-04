Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793788140;
	b=pB/dlboocT5V4nND2x1ZcUnpNqs1R7LJ+uvuwuTCwdAuzlIiVXD9AS5sTvAXZOhcxaeC
	 7kzo7aDtblfBPq1nRQUVgIQZU3eElB6E8jMaRm+z11lJ//MG9sDSQ/aQ28KZxfUcASSrU
	 qkXxwLo4gXT4h1Di+7OHhTfHkxJi9OxIDzk/iMTrFnKYpLAN9lI+fg/Kxiun9NFeyJJKO
	 93Pui6V3Bpr+UDTxpquttzpluFkS0GpNJl3tddZ0xZTIZigc1RCSBD4jaLzLLw5UQ55LO
	 sdJKdTiVUGu9BuQujKexWceo8IoCDmHMn9qzQoxPwMol+4ODH4vybO2LYXbtcqPzdgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793788140;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a9McVEItNmDllAZglmkJRciER2TWiN7f6afJbgcEVjA=;
	b=LO+1dRUp7oOui0MYeA5llT/5HfYIndKeDQhcqUe7pKMvl6ylxj6Oz6zbEWXBbtyXdTxD
	 YSpcfiX6ZLY8/9V7AayjkGaAqZB0DRkIwZxoxkmls1zm+qwC6rvbjOYVtLydlYbjF3EoY
	 6LbotBsSmwUFGD1CMdvsClxUhTA1xT2KVTzWd+zAQNRBZr58YkmSPyfZ67OWG117+CtWr
	 dp/TlJzorUEXHZ7C3MJ8cFefR5JUk3kmMn1uwIqiRYR60i8ug80gXLVBMfRA6iHEsky7t
	 GeSQ/83EXlYhUWdcrCcODSuytD10J8e2Mrv/bbQWudNdnxGBHkAquIkRytEgp5R9ceA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CiIHVwOi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81872606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 10:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CiIHVwOi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4BA1F000C1;
	Wed,  4 Nov 2026 10:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793788140;
	bh=a9McVEItNmDllAZglmkJRciER2TWiN7f6afJbgcEVjA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CiIHVwOiOnbbSMEYaejFwK9JgjYzLmawr3PeNN25j7jL/Pc/Fmzm8m5HiUqpg2vi+
	 jVXI+yuAHpyaOKil38D809uE69GxehlHpEpcIPCaa3vi0wgEKnZk4d89o+xdKmCDAV
	 R5mp1WBaHrB9OpDezHSQZf3xEgy1sQcp3FHn8PWT0IlF2lkmcIoSRyvQEFXoNDOJiy
	 eHQ3fgmT7bVFF04rU9hRQfAE1zg3WQmtiB6VOV6S0+BMh4gJf68wLUsd7fOvHmwbdJ
	 sMZDPoMkcKdtujq86bpOQZrUgZcxGX8d/7HaI2UjHMw7sazvQhnDFM7Nj8qhTeOs1F
	 QGMrWoezxBPXA==
Message-ID: <sashiko-outbox-197094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/mlx5e: TC, release meter if rule offload fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103102856.1340672-1-vulab@iscas.ac.cn>
References: <20261103102856.1340672-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:28:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5e: TC, dangling meter pointers after mlx5e_tc_del_flow_met=
er()
--

commit b953a898af94c9215dfc36d4dbe7f5054db010fd
Author: Wentao Liang <vulab@iscas.ac.cn>

net/mlx5e: TC, release meter if rule offload fails

This commit cleans up the flow meter and post-meter state in
mlx5e_tc_rule_offload() if mlx5_eswitch_add_offloaded_rule() fails after
mlx5e_tc_add_flow_meter() has succeeded.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index 708b7987ea4cd..17bd92529a44a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -491,6 +491,8 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
>  		      struct mlx5_flow_attr *attr)
>  {
>  	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
> +	struct mlx5_flow_handle *rule;
> +	bool meter_added =3D false;
>  	int err;
> =20
>  	if (!is_mdev_switchdev_mode(priv->mdev))
> @@ -503,9 +505,14 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
>  		err =3D mlx5e_tc_add_flow_meter(priv, attr);
>  		if (err)
>  			return ERR_PTR(err);
> +		meter_added =3D true;
>  	}
> =20
> -	return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
> +	rule =3D mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
> +	if (IS_ERR(rule) && meter_added)
> +		mlx5e_tc_del_flow_meter(esw, attr);

[Severity: High]
Does calling mlx5e_tc_del_flow_meter() here leave dangling pointers in
attr->meter_attr.meter, attr->meter_attr.post_meter, and attr->dest_ft that
can lead to a use-after-free or double-free when the flow is not immediately
freed?

In drivers/net/ethernet/mellanox/mlx5/core/en_tc.c,
mlx5e_tc_add_flow_meter() populates attr and mlx5e_tc_del_flow_meter()
releases the resources without clearing those fields:

mlx5e_tc_add_flow_meter() {
	...
	attr->meter_attr.meter =3D meter;
	attr->meter_attr.post_meter =3D post_meter;
	attr->dest_ft =3D mlx5e_post_meter_get_ft(post_meter);
	attr->action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
	return 0;
}

mlx5e_tc_del_flow_meter() {
	mlx5e_post_meter_cleanup(esw, attr->meter_attr.post_meter);
	mlx5e_tc_meter_put(attr->meter_attr.meter);
}

While mlx5e_tc_add_fdb_flow() frees the flow on error, other callers keep
flow->attr alive when mlx5e_tc_offload_fdb_rules() ->
mlx5e_tc_rule_offload() fails.

For example, in drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c,
mlx5e_reoffload_encap() keeps the flow and still sets the OFFLOADED flag:

mlx5e_reoffload_encap() {
	...
			rule =3D mlx5e_tc_offload_fdb_rules(esw, flow, spec, flow->attr);
			if (IS_ERR(rule)) {
				mlx5e_tc_unoffload_flow_post_acts(flow);
				err =3D PTR_ERR(rule);
				mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow,=
 %d\n",
					       err);
			} else {
				flow->rule[0] =3D rule;
			}
		} else {
			...
		}
		flow_flag_set(flow, OFFLOADED);
}

When that flow is later deleted or invalidated via
mlx5e_tc_unoffload_fdb_rules() -> mlx5e_tc_rule_unoffload():

mlx5e_tc_rule_unoffload() {
	...
	if (attr->meter_attr.meter)
		mlx5e_tc_del_flow_meter(esw, attr);
}

attr->meter_attr.meter is still non-NULL, so mlx5e_tc_del_flow_meter() is
called a second time on the already-cleaned-up post_meter and meter.

Similarly, if mlx5e_tc_offload_fdb_rules() fails in
mlx5e_tc_encap_flows_add(), the flow remains on the slow path with a
dangling non-NULL flow->attr->dest_ft. When
mlx5e_tc_unoffload_from_slow_path() later copies flow->attr into slow_attr
and calls mlx5e_tc_unoffload_fdb_rules() -> mlx5e_tc_rule_unoffload() ->
mlx5_eswitch_del_offloaded_rule() -> esw_cleanup_dests(), the non-NULL
attr->dest_ft causes esw_cleanup_dests() to take the attr->dest_ft branch on
a slow-path rule.

Should mlx5e_tc_del_flow_meter() (or the error path in
mlx5e_tc_rule_offload()) also clear attr->meter_attr.meter,
attr->meter_attr.post_meter, and attr->dest_ft?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103102856.1340=
672-1-vulab@iscas.ac.cn?part=3D1
