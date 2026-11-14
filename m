Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794669697;
	b=Y+n9aDM4ocQ65exMMwzlEu4Eni+dgZVmE5jWxFVDJFbwqUA6WDmpTJMwvCiPJvrbFk3H
	 cc79yq2315SREZ2Jpuxj+3phYQ0u/JE+BolBJotR1GMsVsGiNbw7QkRs+NsCDdgPQxW9t
	 X5UMYu7fyhv/dCgY1SuDRmb0VajVO8TTM5+J6ZqsGaevWx3ASc8Bn8J4rP37S2j3U2W+E
	 PB7mxrR0CwTXE4nomA3lyrE89t97vEy2oWzzS3o9cdz1/N0pERXf4vvezyyosNF6ODjAe
	 hFQP/I6Jakgy/uq7Rw1iyJABrWXmzfMoxl+qLBcDNvsrpK6XV2FQ4cCxUO3TwzLpLRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794669697;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G4DjAwGkLxUQakHv0AbLRFI6cASkGdH5y6xKN2hH/70=;
	b=h4r65FR/gisJzsra1aDlJvBhh3aCwl83ij2pIOKiYndMPL5STkTshq9qulwEtlwamD8U
	 21sJxjyuRw72vy0UZ27UVLwajUdsH62FRHAR/tQAYNd6qWU6Su+IWmXvoIWhWMLMCY4Me
	 NsQbWJtx+wXckGFPET6PKrwcBqOfiM5Sq2+ZYMp/X1SSlPAbVFspooFX5Ng1QBtlCUz3G
	 6gfAK0XP+agFtxzdwjcsMEjxvXRW1fSL9klxu6uu3QlcgCZmJRFEXGrqzb016HTPHbV0Z
	 bXMSBVihg9w9J4cxGUlfUPpxoUIxvwpyJgbUKpKquT3JGC1Zq2CDGOSJRDFRLtskuZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZo8vs3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923B3606A32D
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZo8vs3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8C11F000C5;
	Sat, 14 Nov 2026 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794669697;
	bh=G4DjAwGkLxUQakHv0AbLRFI6cASkGdH5y6xKN2hH/70=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BZo8vs3KQLdETR49iOS31pxZIIah01+whHiY5jE1ytrU8D9M1vRSyB/sqKEXbwPaX
	 Cdrxd6fwlWVOySpPJ6IDIUNt5SXIbprUJlwi2h0pW/vnsmqz8rNyjkG+Eis5VM/fYL
	 jpzcCpAS0tyF0zBBs7h4cSOoc758MN+Lmfr7boJrIwrKO8gr3UduU4yMT7nkC8H0hk
	 tHfWkOgcgFwFm3JOXfmtjqy0FM2TZZXBrw1ScdAQmWEyXfPCf4FPi9WM3WzfnpxxU8
	 D+ejfmGpLIkLlMaxvZ7VrGspK7npIzOV10xmJGME5IljVUejyJ2/kBCvNTqPHojWf0
	 fOfDNLxYx4n8w==
Message-ID: <sashiko-outbox-214696@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2] net/mlx5e: rep, Fix races between devcom PAIR
 event and uplink close
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112182403.3646298-1-tariqt@nvidia.com>
References: <20261112182403.3646298-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 15:21:36 +0000
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
- [Medium] net/mlx5e: esw->devcom UAF race with
  mlx5_esw_offloads_devcom_cleanup()
--

commit 7323974cbd0d255bb995fa9d0fba3a2187d60aad
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: rep, Fix races between devcom PAIR event and uplink close

This commit adds mlx5_devcom_comp_read_lock() and
mlx5_devcom_comp_read_unlock() and holds the devcom component read
semaphore across mlx5e_sqs2vport_start() and mlx5e_sqs2vport_stop() to
serialize against devcom PAIR and UNPAIR events.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_rep.c
> index a50a42581528a..962c70b9b5661 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -506,10 +506,11 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitc=
h *esw,
>  				 struct mlx5_eswitch_rep *rep,
>  				 u32 *sqns_array, int sqns_num)
>  {
> +	struct mlx5_devcom_comp_dev *devcom =3D esw->devcom;
>  	struct mlx5_flow_handle *flow_rule;
>  	struct mlx5e_rep_priv *rpriv;
>  	struct mlx5e_rep_sq *rep_sq;
> -	bool devcom_locked =3D false;
> +	bool peers_ready;
>  	int err;
>  	int i;
> =20
> @@ -518,9 +519,8 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch =
*esw,
> =20
>  	rpriv =3D mlx5e_rep_to_rep_priv(rep);
> =20
> -	if (mlx5_devcom_comp_is_ready(esw->devcom) &&
> -	    mlx5_devcom_for_each_peer_begin(esw->devcom))
> -		devcom_locked =3D true;
> +	mlx5_devcom_comp_read_lock(devcom);
> +	peers_ready =3D mlx5_devcom_comp_is_ready(devcom);

[ ... ]

> @@ -630,8 +627,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
>  	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
>  	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
>  	struct mlx5_eswitch_rep *rep =3D rpriv->rep;
> +	struct mlx5_devcom_comp_dev *devcom;
> =20
> +	devcom =3D esw->devcom;
> +	mlx5_devcom_comp_read_lock(devcom);
>  	mlx5e_sqs2vport_stop(esw, rep);
> +	mlx5_devcom_comp_read_unlock(devcom);
>  }

[Severity: Medium]
Can mlx5e_remove_sqs_fwd_rules() and mlx5e_sqs2vport_start() race with
mlx5_esw_offloads_devcom_cleanup() and dereference a freed esw->devcom?

esw_offloads_disable() tears down esw->devcom while esw->mode is still
MLX5_ESWITCH_OFFLOADS and before the VF and uplink representor netdevs
are unloaded:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:esw_offloads_dis=
able() {
    ...
	mlx5_esw_offloads_devcom_cleanup(esw);
	mlx5_eswitch_disable_pf_vf_vports(esw);
	mlx5_esw_offloads_rep_unload(esw, MLX5_VPORT_UPLINK);
    ...
}

In mlx5_esw_offloads_devcom_cleanup(), mlx5_devcom_unregister_component()
frees esw->devcom (and devcom->comp when the last peer unregisters)
before clearing esw->devcom =3D NULL.  esw_offloads_disable() holds
devl_lock and esw->offloads.reps_lock, while representor netdev callbacks
(such as mlx5e_close() or mlx5e_open()) hold only rtnl_lock/netdev_lock
and priv->state_lock:

CPU0                                    CPU1
esw_offloads_disable()                  mlx5e_close()
  mlx5_esw_offloads_devcom_cleanup()      ...
                                          mlx5e_remove_sqs_fwd_rules()
                                            devcom =3D esw->devcom;
    mlx5_devcom_unregister_component()
      devcom_free_comp_dev(devcom)
        kfree(devcom)
                                            mlx5_devcom_comp_read_lock(devc=
om)
                                              down_read(&devcom->comp->sem)
                                              <-- use-after-free
    esw->devcom =3D NULL;

mlx5e_sqs2vport_start() has the same race because it now calls
mlx5_devcom_comp_read_lock(devcom) unconditionally without checking
comp->ready first.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112182403.3646=
298-1-tariqt@nvidia.com?part=3D1
