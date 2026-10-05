Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5D23093C1
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791183810; cv=none; b=j0lkc1qsnc3XjScoSl3qc5TEE8j42pILj6jIBJsmuGKPO1W1PEDnkzA6DKawPI9wtcMgVgxPUBLTdcNXQHrKLpQVXrWeS6fCvSiEETpxbN6BzXjRKdkhvao+dn2LzdBVPvVMxbEYOlsjYqtxZ+/5ejHMH0atkwX3KrdJWYOI0vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791183810; c=relaxed/simple;
	bh=iphM4eHTnRtj757MCG1uChcEweQfZP51yuV8avBcTgY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Deuzch2odBl8g+oz7/D2ZNbcYWdTdaUIp+NbX7q6bUIJffI3GWo3JLLXlpz1w6Oh7s7EoVIlZAi+JQdu5vhHFmp+w2TxjAYCnVLGVfXTzB06EYKbYsWMtZWNLjVfqsVKfQjzZd/6iykd0mi2gHtpl/OdS0K80JSeguGbf4ugznw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NYzHNJSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NYzHNJSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAFD1F000FF;
	Mon,  5 Oct 2026 07:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791183808;
	bh=DixUGBZbtYVID3PzhJovycd2wPOEdpEFscHx1B7GqMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NYzHNJSBVnQnJWtPUIOtGsfkJzob+dX/EifkLiQ/2846eGWKEzrOO/y26zGuD//Pc
	 QNkJRfJbuDx5yctTtGbMuFUCX8R0bb+n+EEr0Mg1+OOjkuCx+AR/3u+Gbwep5miXCY
	 v9WIo4D2KtOhD2kIajNk/J0MSjxpX+XdlCXzBNjJ1Oet7VvY71C7ASR0TnBrz2rwKm
	 IzEbIsDyXDhgAsSAr1LC/PmwWJJ2UmK5twha6a9qX/wnhIoiwrY00gNtRKp3hm3wNk
	 emhgwYwvgu9+l+tz+zj8W0lbrSrz9+Yyb9CiZV2k8vgLHRJkifGvuhc4oZZNOgVwqV
	 J3/hIxCLqVIqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004070246.215239-1-tariqt@nvidia.com>
References: <20261004070246.215239-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 07:03:28 +0000
Message-Id: <20261005070328.AAAFD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5: rate limit dropped due to zeroed max TX speed fallback c=
ache
--

commit e0ff80bc97aeb275a4ecdbc780d58984bb55ac36
Author: Or Har-Toov <ohartoov@nvidia.com>

net/mlx5: Lag, only cache max_tx_speed that FW has not accepted

vport->agg_max_tx_speed caches a max_tx_speed that could not be pushed
to FW, to be applied by mlx5_esw_vport_enable() once the vport comes up.

Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/=
net/ethernet/mellanox/mlx5/core/eswitch.c
> index fc197d1dc9dfe..f8c220bf7b5ca 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -951,6 +951,8 @@ static void mlx5_esw_vport_set_max_tx_speed(struct ml=
x5_eswitch *esw,
>  		mlx5_core_dbg(esw->dev,
>  			      "Failed to set vport %d speed %d, err=3D%d\n",
>  			      vport->vport, vport->agg_max_tx_speed, ret);
> +	else
> +		vport->agg_max_tx_speed =3D 0;
>  }

[Severity: High]
This patch sets agg_max_tx_speed to 0 on a successful push, but multiple
fallback paths in the driver rely on this variable containing the actual
configured speed if a query fails.

For example, in mlx5_modify_vport_admin_state() in
drivers/net/ethernet/mellanox/mlx5/core/vport.c, if the query for the max
TX speed fails, the code falls back to the cache:

        err =3D mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
                                            other_vport, &speed, NULL);
        if (err) {
#ifdef CONFIG_MLX5_ESWITCH
            struct mlx5_vport *esw_vport;

            esw_vport =3D mlx5_eswitch_get_vport(mdev->priv.eswitch,
                                               vport);
            speed =3D IS_ERR(esw_vport) ? 0 :
                esw_vport->agg_max_tx_speed;
        ...
        MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);

If a max TX speed was successfully configured, this patch clears
agg_max_tx_speed to 0. If a later admin state modification triggers
mlx5_modify_vport_admin_state() and the query fails, won't this fallback
logic read 0 and inadvertently un-limit the vport by pushing 0 to the firmw=
are?

A similar fallback path that relies on this cache exists in
mlx5_esw_adj_vport_modify() in
drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 3b34bec559e08..7cee78cb47df9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1502,17 +1502,21 @@ static void mlx5_lag_modify_device_vports_speed(s=
truct mlx5_core_dev *mdev,
>  		if (vport->vport =3D=3D MLX5_VPORT_UPLINK)
>  			continue;
> =20
> -		vport->agg_max_tx_speed =3D speed;
> -
> -		if (!vport->enabled)
> +		if (!vport->enabled) {
> +			vport->agg_max_tx_speed =3D speed;
>  			continue;
> +		}
> =20
>  		ret =3D mlx5_modify_vport_max_tx_speed(mdev, op_mod,
>  						     vport->vport, true, speed);
> -		if (ret)
> +		if (ret) {
>  			mlx5_core_dbg(mdev,
>  				      "Failed to set vport %d speed %d, err=3D%d\n",
>  				      vport->vport, speed, ret);
> +			vport->agg_max_tx_speed =3D speed;
> +		} else {
> +			vport->agg_max_tx_speed =3D 0;
> +		}
>  	}

[Severity: High]
Since this successfully clears the cache to 0, wouldn't it break the fallba=
ck
mechanisms mentioned above?

Additionally, this logic appears to overload 0 to mean "no cached value".
As seen in mlx5_esw_vport_enable() in
drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:

    if (vport->agg_max_tx_speed)
        mlx5_esw_vport_set_max_tx_speed(esw, vport);

If a user explicitly configures a speed of 0 (unlimited) while the vport is
disabled, wouldn't the cache value be 0, preventing the unlimited setting
from being applied when the vport is later enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004070246.2152=
39-1-tariqt@nvidia.com?part=3D1
