Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794853498;
	b=hjEKs0n3hK4PINqnftO9U0E6QyOa/FLe1G9ZL86vPCcmr/Kvvl9pHRdcPdGdk4PBMoDb
	 39KlEN9UzxdlOPa5NTjKFJagUpv6o2n7Gp+tZQXLm1s9s+A6Wquk9cW7V6+MFAYmnyY2c
	 fhRZEqn6hGLRrK3NOt+JjPdPmrggsZKbqUt7YyjHlMskMIcfefDKv2cCS4BWtvpQhjdyb
	 3FqzUoiaU1ZIbz/CAvGAwABxH5kDxbWYqYPSWV74GurpGFS5NzD2QxZ8i7TXH7wXpzCt6
	 kP1asWh564g/UVKFIDm64eiA2DyzhNG9SNlipivSb3ZYZSuOgxiRnux98R5B0jViiTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794853498;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=XA+MlmsTnaQekZvsezoaPcmpVRDOL1KtXr3naLhDekg=;
	b=NCWFHE8gJ+VkA8m0Jnc5mDTKiGz0Ngoyzt3uTNW054qMsjkl5IrywN8LDiRaLebL+Bno
	 USCql+tDH2vnthyKwdnvaHU/kMFA5TbgTGeMwbmQJvRxWbbWtB7ArUO8/hj+KODIaf+x8
	 Om1alg1J7bWaQrKKZIfuAAk6r4TkVaAQrYBC0b+YsvFj1ugXOOd03UYRvayJ863BK+vZP
	 1fnpYkkEfcD8MIk1Gtq/guDgLJDUyTHhCAdN21lnNGmCcr1j9kTqwxGlKno4BAChUnIXB
	 Goi+/ftdiG5ye2v0XejoVKjzeEBX2DTO8hVtwh6vByvGyh/dviAOHhFbMDIZtSDLKYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SgIeVhBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2219A606A31C;
	Mon, 16 Nov 2026 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SgIeVhBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A971F000C4;
	Mon, 16 Nov 2026 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853497;
	bh=XA+MlmsTnaQekZvsezoaPcmpVRDOL1KtXr3naLhDekg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SgIeVhBihQyYgnwdbZecmKRhj9gHH01x4DcmhMxd+OPSgkJveEgkb0jOKvTnfWah0
	 sc++6AfcPGymw1ak10ITL01DC3xAKtjPHOx5ISg3f2ZyZBCcf5i0ovD//yE6ptE1+3
	 Dh6IqdARURhe1pg3IcN7AgEHICFjhhrEz0058nEcw42pY0p2fMezCEne6kDUlaPzIV
	 3w8cB7NTE1gcT5u9F9gs0eWCDJFJUzkDmIy4/jT6gzk0Mvj1QSD8YTxHflPZqRTkJx
	 r8TYFfpZ4OWcfYZ2w9soug5cjdHevEcd/6odQpLESwAd3pyhP4Ioi+32iNPLdpkriQ
	 sb5rwzZYSU4nQ==
Subject: Re: [PATCH net V2] net/mlx5e: rep, Fix races between devcom PAIR
 event and uplink close
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, markzhang@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com
Date: Mon, 16 Nov 2026 18:24:56 +0000
Message-ID: <179485349648.3136.17669005426251956349@kernel.org>
In-Reply-To: <20261112182403.3646298-1-tariqt@nvidia.com>
References: <20261112182403.3646298-1-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new locking only works if the unsynchronized read of
  `esw->devcom` returns a valid pointer.

--

net/mlx5e: rep, Fix races between devcom PAIR event and uplink close

This commit adds mlx5_devcom_comp_read_lock/unlock(), which take the
devcom component semaphore for read whether or not comp->ready is set.
It holds that lock across mlx5e_sqs2vport_start() and
mlx5e_sqs2vport_stop() so that both are serialized against the
ESW_OFFLOADS PAIR/UNPAIR handler.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index a50a42581528a..962c70b9b5661 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c

[ ... ]

> @@ -630,8 +627,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
>  	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>  	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>  	struct mlx5_eswitch_rep *rep = rpriv->rep;
> +	struct mlx5_devcom_comp_dev *devcom;
>  
> +	devcom = esw->devcom;
> +	mlx5_devcom_comp_read_lock(devcom);
> +	mlx5e_sqs2vport_stop(esw, rep);
> +	mlx5_devcom_comp_read_unlock(devcom);
>  }

[Severity: High]

Are the races still reachable if esw->devcom is NULL or stale when it is
read here and in mlx5e_sqs2vport_start()?

The load of esw->devcom is a plain unsynchronized read. The store side
has no WRITE_ONCE() and the load side has no READ_ONCE().
mlx5_devcom_comp_read_lock() also does nothing when passed NULL.

In esw_offloads_enable(), the uplink and VF reps are loaded and their
netdevs registered before mlx5_esw_offloads_devcom_init() runs. That
function publishes the pointer and sends the PAIR event right away:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:mlx5_esw_offloads_devcom_init() {
    ...
	esw->devcom = mlx5_devcom_register_component(esw->dev->priv.devc,
						     MLX5_DEVCOM_ESW_OFFLOADS,
						     attr,
						     mlx5_esw_offloads_devcom_event,
						     esw);
	if (!esw->devcom)
		return;

	err = mlx5_devcom_send_event(esw->devcom,
				     ESW_OFFLOADS_DEVCOM_PAIR,
    ...
}

The PAIR handler runs with comp->sem held for write. It goes through
mlx5_esw_offloads_devcom_event()->mlx5_esw_offloads_pair()->
mlx5e_vport_rep_event_pair(), which walks rpriv->vport_sqs_list for
every loaded rep and calls xa_insert() on rep_sq->sq_peer.

A rep ndo_open or ndo_stop holds rtnl and priv->state_lock. The
devlink-locked enable path holds neither across this window. If the rep
reads esw->devcom before the store above, two things can happen:

  - mlx5e_sqs2vport_start() snapshots devcom == NULL, so it takes no lock
    and sees peers_ready == false. It then does list_add() into
    rpriv->vport_sqs_list while the PAIR handler is walking that list.
    SQs added after the walk also never get their peer send-to-vport
    rules.

  - mlx5e_remove_sqs_fwd_rules() calls mlx5e_sqs2vport_stop() without
    the lock. That can list_del() and kfree() a rep_sq and its sq_peer
    entries while mlx5e_vport_rep_event_pair() is still using them.

These are the two races the commit message describes as fixed.

On teardown, esw_offloads_disable() calls the devcom cleanup while the
VF rep netdevs are still registered:

	mlx5_esw_offloads_devcom_cleanup(esw);
	mlx5_eswitch_disable_pf_vf_vports(esw);
	mlx5_esw_offloads_rep_unload(esw, MLX5_VPORT_UPLINK);

mlx5_esw_offloads_devcom_cleanup() frees the comp_dev before it clears
the pointer:

	mlx5_devcom_unregister_component(esw->devcom);
	xa_destroy(&esw->paired);
	xa_destroy(&esw->fdb_table.offloads.peer_miss_rules);
	esw->devcom = NULL;

Inside mlx5_devcom_unregister_component(), devcom_free_comp_dev() does:

	down_write(&comp->sem);
	list_del(&devcom->list);
	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
	up_write(&comp->sem);

	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
	kfree(devcom);
	kref_put(&comp->ref, mlx5_devcom_comp_release);

The write lock only excludes readers that already hold comp->sem.

Could a concurrent VF rep ndo_stop load the old esw->devcom in
mlx5e_remove_sqs_fwd_rules() and then call down_read(&devcom->comp->sem)
after the kfree()? The stop path did not touch esw->devcom before this
patch, so this use-after-free would be new on the close path.

Would it work better to serialize publishing and clearing esw->devcom
against rep start/stop, instead of locking whatever pointer happens to be
read at that moment?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112182403.3646298-1-tariqt%40nvidia.com
