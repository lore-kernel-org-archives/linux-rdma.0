Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795768961;
	b=2+B/QLbipQNRgAIrRcHTnK1XEHuv7RkEDJC+qv0Y5jesznrzt9za8QR4EYexrrbapGDM
	 nofRjNhXI8CdrEXn+gJO8yOrZwTQv9ege2Pc+rnFD9eJRw2hLpEeDEo2Wrp9deCCq1jRR
	 D2Id+sLNrAPfiXhte/cFj/qFpNwHPGMQZZMXyeaPGB/OWVd3gBIk8NYEOsW3e6J+25zGG
	 4xNmVUUcDS7y4+rGx2YtqZoqwQxgUoB3oQ/nGQVp0t/GWRNPeNGMNQ9xa7Tp5BQVZfWwm
	 azVRRhT8rDM1r87ZQdj7z9T3HI2AUgX7c7TpKEVOTJIuBB9s3qqwBKBSamU3jqwYI/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795768961;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EBgqf2o5HZzB1803xaxbO8yypvQOndIrlJKcoBBvnZY=;
	b=Z8DmOeEnMYgx4QZW8knR6zdorg4K8kkiniWmvL1a6bYdgOQiY6+F5LgM1GsIb3h1xnkM
	 5yVnG9FZnM2Cl6e2soMYfrvztUYlYw3J45RLCwijGqRK8Y6qgE4LJ5dzsYqCuionIst5N
	 uDHjGmu29qOQDUAm7Ls1jgd1s3gkdWw9WqFsa1eiuwmmjMkYPrr1yS0uY5ALg7jBxfffz
	 O3+Z1EVh9tnTJKWRVkkUiE9si5++7tHmTNKS7SF5ShRgcyWMpGiFqRd/kULn8ZwfVO7pb
	 MjlIxJdRUv0Co22Y0MTpct9kFK9yG8vi8qhzvBOhQ8xjqxgKzX9lR8Om7LGwfTIN1Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVooSYCF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BAE606A31E
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 08:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVooSYCF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CB71F0089F;
	Fri, 27 Nov 2026 08:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795768960;
	bh=EBgqf2o5HZzB1803xaxbO8yypvQOndIrlJKcoBBvnZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XVooSYCFvEqhCCOHY6y+F4Dlt6KN3iQXM38j9Kz0RQ1q/PvsCrLSTg/EQ+HWNcC3x
	 UI/uFVuXNLFXovNeBUfMQKCXCgWictKqGe8NH8PN3eJtiU6+UMV+yYIcV8IxGg34st
	 qZdOWsfCRb3e1jm2Ok3NfoEPm2IZgFE/T8CXxxbiCsfIQmi/cH0Cd3XUuXaHCxwErB
	 VA8042w8ZwXenjjpHGvGy8gxPDiOKl/uGX9fpSlFGGtDnR0K+YBuES+mD49rvDw4KQ
	 Jirz/m5RJDwXDp63lB2JZytDEvDh8xdKpAuvO6/uGAopVWIQWb6O7g1KzzPZHJH3Gs
	 gbApEpOlTnXVA==
Message-ID: <sashiko-outbox-236897@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5e: Fix deadlock when parsing flow
 actions fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziyu Zhang" <ziyuzhang201@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126084216.26436-1-ziyuzhang201@gmail.com>
References: <20261126084216.26436-1-ziyuzhang201@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 08:42:39 +0000
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
- [High] net/mlx5e: unorted post-actions on mlx5e_tc_add_fdb_flow()
  failure
--

commit 80bfe544864e1741e156f9fe2cf078e4de48e16b
Author: Ziyu Zhang <ziyuzhang201@gmail.com>

net/mlx5e: Fix deadlock when parsing flow actions fails

This commit avoids a deadlock between flow action parsing failure cleanup
and neighbour or route updates by deleting post-action rules, setting
MLX5E_TC_FLOW_FLAG_PARSE_FAILED, and completing flow->init_done before
detaching encap entries under encap_tbl_lock.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index 011741553f5b9..9175fd469fdcd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -4580,8 +4605,10 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
>  		goto err_free;
> =20
>  	err =3D parse_tc_fdb_actions(priv, &rule->action, flow, extack);
> -	if (err)
> +	if (err) {
> +		abort_flow_post_acts(flow);
>  		goto err_free;
> +	}
> =20
>  	err =3D mlx5e_tc_add_fdb_flow(priv, flow, extack);
>  	complete_all(&flow->init_done);

[Severity: High]
What happens when parse_tc_fdb_actions() succeeds (attaching post-action
encaps and offloading post-action rules in alloc_flow_post_acts()), and
then mlx5e_tc_add_fdb_flow() fails (other than the multipath -ENETUNREACH
unready case)?

On failure, mlx5e_tc_add_fdb_flow() sets MLX5E_TC_FLOW_FLAG_FAILED,
leaving PARSE_FAILED and OFFLOADED unset, and __mlx5e_add_fdb_flow()
calls complete_all(&flow->init_done) before mlx5e_flow_put().  Because
mlx5e_take_tmp_flow() now waits for init_done before mlx5e_flow_get() and
only skips flows with PARSE_FAILED set:

CPU0                                  CPU1
__mlx5e_add_fdb_flow()
  parse_tc_fdb_actions()
    alloc_flow_post_acts()
                                      mlx5e_tc_fib_event_work()
                                        mutex_lock(&esw->offloads.encap_tbl=
_lock)
                                        mlx5e_take_tmp_flow()
                                          wait_for_completion(&flow->init_d=
one)
  mlx5e_tc_add_fdb_flow() -> fails
    flow_flag_set(flow, FAILED)
  complete_all(&flow->init_done)
                                          flow_flag_test(flow, PARSE_FAILED=
) -> false
                                          mlx5e_flow_get(flow) -> succeeds
                                          list_add(&flow->tmp_list, ...)
  mlx5e_flow_put(priv, flow)

If the route update encounters the failed flow through two encap entries
before cleanup detaches them, mlx5e_take_tmp_flow() calls
list_add(&flow->tmp_list, flow_list) twice on the same node, corrupting
flow_list.  In addition, because OFFLOADED is not set,
mlx5e_tc_encap_flows_del() skips unoffloading the flow's post-action rules
and calls mlx5_packet_reformat_dealloc() on e->pkt_reformat while the
installed post-action hardware rules still reference it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126084216.2643=
6-1-ziyuzhang201@gmail.com?part=3D1
