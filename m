Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795667030;
	b=is8QSk61DyI4THMSfd/0l50AKfnXRucCDW9RgEsxWGyQMyA3Z6JOWE0nzWS0aXgUpv+8
	 ESwkJLTHLYwuFxEZbi8U1qNDTOp7FQrwePY/Xcw8WE4/Wuty1MIzHRuCvB487U9KH7LpT
	 CmGz53hy4aroqw6/2kSC3+9D3W56a/fvDg7HiS3OV/tC+J4BgMrP0ASHxHMZb5/B/te53
	 cLWruSF0drq/OzjbFGNOVxsStHjCDHTWFa2mYB9BLo7U4u5LWiHt6UeEQxFTQp2vgaMMm
	 1PsGr5Z9IPmt1Px8EwWoyZlMsrhHPQOIBs3kTw7wpQviWS+CBTvZmCWjONyJRHwW56g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795667030;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w0lR5VgpvDJ6T2cHqvlo9xPbD/OBlV8OGcQdybspTMM=;
	b=FychM7+haw+oXwsrdYcVAzgkYijZK9hLLiB+7XS9FBkmK8ryI8itj/NZegCj8/B9eyFu
	 +/2Vqwlz4yIdahc+9LFMFeUjZF/088Mb5feh+9JosXOfIzAukTPYNj+/pJiaET5uJAdH+
	 4qYNtHXafzYwtjX4m3So06ifMA+532BenbbR53zrP75/FL2MQTMkYP3J7BdgbfPL2mjy9
	 WqjvGWb65Gp+9EBBoZoZF0oedMUp/ImcjuUDc4UknovKqa/1MdcGUjPR/4CHtVftl9G/+
	 6uhyePQbcljZqtjutCMKeAgiNqZ7lrMmNA+FYeprVLhTocj9UrFU6lk5Enk0pnZIomA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fjHX9ZzO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2BB606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 04:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fjHX9ZzO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED80D1F000CF;
	Thu, 26 Nov 2026 04:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795667030;
	bh=w0lR5VgpvDJ6T2cHqvlo9xPbD/OBlV8OGcQdybspTMM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fjHX9ZzOf9CvVDP1dy7VoTUPkaLV4UWioNSD1ZKtaVuf5iqVren4DOX/62cSs3src
	 NJra7NOK2ApjZ8eZhhIgKiIbdGb9Ya5cBEgoPPFEqk1NPMNrWVGdzsfQCFLUIlfc47
	 B0DQkjh1frFr7NJBkHG9LHvSxdYOwjaYohP0pouQq6TZlnqA+f0QHwHncyKfid7F3k
	 kE7KG0aj9E1rgvuCnlxo8+K0Q0Vr4IeLU2f9vEHx0n/KpBskXKBfLYDAG6SE/vpoKN
	 NSOn54phm6F9JUJtf4f4xJUU3pOmISHzsphZ1YWrxzmsPzaJ+vufzXYYtkhkzpqD9X
	 LDQTzvI76Dk0g==
Message-ID: <sashiko-outbox-234731@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix deadlock when parsing flow actions
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziyu Zhang" <ziyuzhang201@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125042323.88050-1-ziyuzhang201@gmail.com>
References: <20261125042323.88050-1-ziyuzhang201@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 04:23:49 +0000
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
- [Medium] net/mlx5e: skipped encap detach in __mlx5e_add_fdb_flow() on
  action parse error
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [High] net/mlx5e: list corruption and encap leak in
  mlx5e_tc_tun_encap_dests_set() [1]
- [Critical] net/mlx5e: unguarded TUN_RX state in
  mlx5e_tc_add_fdb_flow() on retry [2]
--

commit d3aaf145c0b29688154f5549282aa0654096d594
Author: Ziyu Zhang <ziyuzhang201@gmail.com>

net/mlx5e: Fix deadlock when parsing flow actions fails

This commit marks the flow as FAILED, deletes post action rules, and
completes flow->init_done before detaching encap entries when parsing flow
actions fails, avoiding a deadlock with neighbour and route updates waiting
on flow->init_done under encap_tbl_lock.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index 011741553f5b9..d97612a7190b9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -4580,8 +4615,11 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
>  		goto err_free;
> =20
>  	err =3D parse_tc_fdb_actions(priv, &rule->action, flow, extack);
> -	if (err)
> +	if (err) {
> +		del_flow_post_act_handles(flow);
> +		mlx5e_flow_init_failed(flow);
>  		goto err_free;
> +	}

[Severity: Medium]
Does jumping to err_free without calling free_flow_post_acts(flow) leave
the flow attached to e->flows when a waiter is woken on flow->init_done?

Before waiting on flow->init_done, mlx5e_take_tmp_flow() calls
mlx5e_flow_get(flow), raising flow->refcnt to 2.  When
parse_tc_fdb_actions() fails after alloc_flow_post_acts() has already
succeeded, waking the waiter in mlx5e_flow_init_failed(flow) and calling
mlx5e_flow_put() at err_free can drop flow->refcnt from 2 to 1 and return
without running mlx5e_tc_del_flow() -> free_flow_post_acts():

CPU0                                CPU1
__mlx5e_add_fdb_flow()
  parse_tc_fdb_actions()
    alloc_flow_post_acts()
      /* attaches flow to e1, e2 */
                                    mlx5e_update_route_encaps()
                                      lock(&esw->offloads.encap_tbl_lock)
                                      mlx5e_take_all_encap_flows(e1, ...)
                                        mlx5e_flow_get(flow) /* refcnt=3D2 =
*/
                                        list_add(&flow->tmp_list, ...)
                                        wait_for_completion(&flow->init_don=
e)
    /* later check fails */
  del_flow_post_act_handles(flow)
  mlx5e_flow_init_failed(flow)
    complete_all(&flow->init_done)
  mlx5e_flow_put(priv, flow)
    /* refcnt 2 -> 1, returns */
                                      mlx5e_take_all_encap_flows(e2, ...)
                                        list_add(&flow->tmp_list, ...)
                                        /* corrupts flow->tmp_list */

Because flow is still on e2->flows, the next iteration of
mlx5e_update_route_encaps() (or another thread acquiring encap_tbl_lock
before CPU1 runs mlx5e_put_flow_list()) takes the flow again and calls
list_add() on an already-linked flow->tmp_list, corrupting the list and
leaking a flow reference.

Calling free_flow_post_acts(flow) before goto err_free, just as
alloc_flow_post_acts() does at out_free, ensures mlx5e_detach_encap()
waits for encap_tbl_lock and removes the flow from e->flows before
__mlx5e_add_fdb_flow() returns.

> =20
>  	err =3D mlx5e_tc_add_fdb_flow(priv, flow, extack);
>  	complete_all(&flow->init_done);

[Severity: High]
This problem wasn't introduced by this patch, but can a partial failure in
mlx5e_tc_tun_encap_dests_set() [1] corrupt e->flows and leak encap
references when an unready multipath flow is retried?

When mlx5e_tc_add_fdb_flow() calls post_process_attr() ->
mlx5e_tc_tun_encap_dests_set() for a rule with multiple tunnel encap
destinations, each successful mlx5e_attach_encap() links
flow->encaps[out_index].list into e->flows:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:mlx5e_tc_tun_enca=
p_dests_set() {
	...
	for (out_index =3D 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
		...
		err =3D mlx5e_attach_encap(priv, flow, attr, out_dev, out_index,
					 extack, &encap_dev);
		dev_put(out_dev);
		if (err)
			goto out;
		...
	}
}

If a later destination fails with -ENETUNREACH on a multipath LAG setup,
mlx5e_tc_tun_encap_dests_set() returns without detaching the earlier
destinations, and __mlx5e_add_fdb_flow() queues the flow via
add_unready_flow(flow) instead of freeing it.  When
mlx5e_tc_reoffload_flows_work() retries mlx5e_tc_add_fdb_flow(),
mlx5e_attach_encap() runs again from out_index 0, overwriting
flow->encaps[out_index].e and calling list_add() on the already-linked
flow->encaps[out_index].list.

[Severity: Critical]
This problem wasn't introduced by this patch, but can retrying an unready
TUN_RX flow in mlx5e_tc_add_fdb_flow() [2] corrupt r->decap_flows,
leak references, and append duplicate modify-header actions?

In mlx5e_tc_add_fdb_flow(), the TUN_RX handling runs before
post_process_attr():

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_add_fdb_flow() {
	...
	if (flow_flag_test(flow, TUN_RX)) {
		err =3D mlx5e_attach_decap_route(priv, flow);
		if (err)
			goto err_out;

		if (!attr->chain && esw_attr->int_port &&
		    attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
			...
			err =3D mlx5e_tc_match_to_reg_set(priv->mdev, &parse_attr->mod_hdr_acts,
							MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
							metadata);
			...
		}
	}
	...
	err =3D post_process_attr(flow, attr, extack);
	if (err)
		goto err_out;
}

If mlx5e_attach_decap_route() succeeds and post_process_attr() then fails
with -ENETUNREACH on a multipath LAG setup, err_out does not unwind the
TUN_RX state before __mlx5e_add_fdb_flow() calls add_unready_flow(flow).
When mlx5e_tc_reoffload_flows_work() retries mlx5e_tc_add_fdb_flow(),
mlx5e_attach_decap_route() runs a second time on the same flow: for a VF
tunnel decap route it grabs another reference to the mlx5e_route_entry and
calls list_add(&flow->decap_routes, &r->decap_flows) on an already-linked
node, and for an OVS internal port route it overwrites esw_attr->int_port
without releasing the previous reference and appends a duplicate
VPORT_TO_REG action to parse_attr->mod_hdr_acts.

[1] https://sashiko.dev/#/bug/linux-5302f345-b229-43c7-a40a-117aaaf5a0ba
[2] https://sashiko.dev/#/bug/linux-5f514873-9967-4a3f-b7c5-4fc8e750cbf6

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125042323.8805=
0-1-ziyuzhang201@gmail.com?part=3D1
