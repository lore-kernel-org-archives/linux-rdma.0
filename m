Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558414;
	b=5XHEAxgPX1oTbjQuQNTfclsAZl1IECKdgCAJ2NPishZYdzm+HT6WpdwT6UTqrDzMcseH
	 jMzJbXP0T8xna6lETXYfw+kPb6sLoZkCGnGichdeA0yl+tXSEu+1N5y++FMVyeZZO5iq1
	 L98J3dMqS2GCDHzme1TXXKbtigizRjCkoWbGC2AE1qgVpVqFUliayJdWtLJ57zaTih+md
	 2U4lUsVW2XtSURuUpCxeGi5v18IbNgBwvTvkQP06o2KeLieXlkUY2YeVX5F80EzSeTKMX
	 chZcDa7wY/9r+evlMW9w1xG2tKDbwuAqIT3K76yIj/hYHwqFfLCF7CL31Mm3s0BEyIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558414;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N2T3xrtOwYNy9ttW/L15mt+hDIXRdxOJNL38mkKBBZY=;
	b=zb6taVrprpqAjl/upPtpRl6022QvhYmxS1uOdl0ORFH8j+5sN6N5CIPa2h538nMZNvzn
	 lNmeJHit5BCRrnjVIqjTxPviSokWueWqwimtkly2XD1aoIYPfWTnOtCEm+7AvaXXJO9Rj
	 iQQsufbTjUQedbQenUYaAMk+FSIPZ+FPkRCVf8vIdv/PQusX7Lr0OSXviU1jStJZLTTq3
	 AoJiqv9S8678+Bkx1Gbi54bLtnPm4SSFfbqWfOm1WCDZNTwnd4YqrqWlgT4JtWA07BxWs
	 GQX/2+ZcvzE4W4P6FnO5dQ0hAvoSVjppvzkV9bqNi8qvwAkpdL5Jb5mj6BJY0gqNsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUL7BDet;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806E6606A33B
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 22:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUL7BDet
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0891F00AD3;
	Tue, 24 Nov 2026 22:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795558414;
	bh=N2T3xrtOwYNy9ttW/L15mt+hDIXRdxOJNL38mkKBBZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BUL7BDetFe9nGL9ViVbFL8YdIZQ4dxSlYlRwXE/nfwHfuSPWCYWNiic/EzZZ3qN1a
	 a08V5oxYgYkakUmQrcdDt9zNjDZkPINhu3H09eGylTObxXJNn/nDPsy/cTU44+uSds
	 jeDFxzPuvzd4OeXFIqX03lOf4A/lX7t1MWhOj5ld/1azDGyqFvuL1x2VPSy4EDEYWr
	 95yc+ZY1YcXjeh0fl1hYu/txhR8tGbppuMPbF07ZYbXG/LBBB4iWry2vtZv/F8mqJp
	 0/xQ8/7yFerEfho4aIg8+HdOZakxRdoL457cz49OGmtZOZz4WolYcMM5ZpdmfO7edQ
	 VzvTXURutgvrA==
Message-ID: <sashiko-outbox-232095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: HWS, fix action STE double free on rule
 update
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123221310.4045513-1-acassen@corp.free.fr>
References: <20261123221310.4045513-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 22:13:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] net/mlx5: HWS, missing rollback on update alloc error in
  hws_rule_create_hws()
- [Medium] net/mlx5: HWS, leak of old_action_ste on rule deletion after
  failed update
--

commit 0a380355d2aec6e9f92b8c556ecd839808dbe0cd
Author: Alexandre Cassen <acassen@corp.free.fr>

net/mlx5: HWS, fix action STE double free on rule update

This commit clears rule->action_ste.action_tbl after saving rule->action_ste
to rule->old_action_ste during a rule update so that rules updated to need
no action STEs do not free the old chunk twice.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> index 0d4cb2b2393b9..cc94d3149d76a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> @@ -243,6 +243,8 @@ static void hws_rule_create_init(struct mlx5hws_rule =
*rule,
>  		 * new action STEs and a corresponding match STE.
>  		 */
>  		rule->old_action_ste =3D rule->action_ste;
> +		/* The rule may need no action STEs once updated */
> +		rule->action_ste.action_tbl =3D NULL;
>  	}
> =20
>  	rule->pending_wqes =3D 0;

[Severity: Medium]
Does hws_rule_create_hws() leave the rule stuck in
MLX5HWS_RULE_STATUS_UPDATING and leak rule->old_action_ste if
mlx5hws_rule_alloc_action_ste() fails during an update?

hws_rule_create_init() sets rule->status to MLX5HWS_RULE_STATUS_UPDATING,
moves rule->action_ste to rule->old_action_ste, and clears
rule->action_ste.action_tbl before hws_rule_create_hws() calls
mlx5hws_rule_alloc_action_ste():

drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c:hws_rule_create=
_hws() {
    ...
	if (action_stes) {
		ret =3D mlx5hws_rule_alloc_action_ste(rule, attr->queue_id,
						    !!ste_attr.rtc_0,
						    !!ste_attr.rtc_1);
		if (ret) {
			mlx5hws_err(ctx, "Failed to allocate action memory %d", ret);
			mlx5hws_send_abort_new_dep_wqe(queue);
			return ret;
		}
	}
    ...
}

Because no WQE is posted on that error return, no completion transitions
rule->status out of MLX5HWS_RULE_STATUS_UPDATING.  Later update and
destroy calls fail with -EBUSY, and mlx5hws_bwc_rule_destroy() frees the
rule object while leaking rule->old_action_ste, rule->resize_info, and the
hardware match STE.

[Severity: Medium]
Can clearing rule->action_ste.action_tbl here also leak
rule->old_action_ste when a rule is deleted after an asynchronous update
failure?

If an update WQE fails while either rule->rtc_0 or rule->rtc_1 remains
non-zero, hws_send_engine_update_rule() leaves rule->status at
MLX5HWS_RULE_STATUS_FAILING rather than MLX5HWS_RULE_STATUS_FAILED.  When
the rule is later deleted, both the MLX5HWS_RULE_STATUS_DELETED completion
in hws_send_engine_update_rule() and the skip_delete path in
hws_rule_destroy_hws() only call
mlx5hws_rule_free_action_ste(&rule->action_ste), leaving
rule->old_action_ste leaked in the action STE pool even when the failed
update needed no new action STEs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123221310.4045=
513-1-acassen@corp.free.fr?part=3D1
