Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5297A3BE162
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141108; cv=none; b=rWYopp5rVK8jr9+487duUmuJ60S1Jf3EC7gX8rNmXZ814d3giSMldUX69FuSD4RMkbu84R0xA0ODThlu1WqjyNUZ7hbIieXKMwxi19PkrqTmSd8Aguub/o0sh+liU8jDYkENer4vU0sNvt/2aTBGBCKC4cvHZUN+aJ3kQ5tP0Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141108; c=relaxed/simple;
	bh=MkYaFsmwEtQ6kM+6pD4PRt7QwWw5zCpaMJam0J3OTJU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gZjhTANgGAONThFnL4MhXrUQsI0Zu1h4BDD9LxqG+Fr8yOkZK6isYzmxr0wHOzn/cRlW/q80A5B6+VdXrwx+kZtwMK7VgOQtyxEvia+bGU3+VhfiO1diOsgfed52UrAqbys5jf0dCA4BebfDComjZpY997sjp3xsRe9Qg1UvAmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dp8pFBK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dp8pFBK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C760D1F000C4;
	Fri, 16 Oct 2026 08:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792141106;
	bh=i4RoaZoD1iUweN+rguKXraRD/SrLh6PzNct50jrlo6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dp8pFBK9vA7pY4m57Yb0wcbvu+2dZDI5p/9zi3Efvp/kxZ2h8i4Fi1MXVUGlhKmiF
	 uuvCeNKTeXzkUQ/4N+Kme1558EpWHdOgCoLNlTlAZVsICB+lmzo5oCRsP3JEhPGQ9Y
	 CxE3d7Xn8P1tj49u3QH89GUx85GSgYFbek+V+M/VBJPwH7h2nVuPuA0MuScf/eQejz
	 uR6k+D1a9/4wDq2aG5sycaxqpwNTwULVakTGZimHRLA9UVIVaoAcbMLa4CZ/9DwK/E
	 evYEia762I4C5nz0X2f//ZE/eye6VdMQnGtpa5JP8y6euQoq/1DgDYH1ALw6MuDONb
	 GLheIQxMaBftw==
Message-ID: <sashiko-outbox-174038@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: rep, Fix races between devcom PAIR event
 and uplink close
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015085744.1109107-1-tariqt@nvidia.com>
References: <20261015085744.1109107-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 08:58:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5e: bypassed devcom lock in stop path leaves UAF race unmit=
igated
--

commit a1ed4eff90a08173eecbfbc7850c1594a36291d8
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: rep, Fix races between devcom PAIR event and uplink close

This commit attempts to fix a use-after-free race between the devcom PAIR
event and uplink close by protecting the teardown path with the devcom read
semaphore.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_rep.c
> index 88a170e40bd93..7211faaffd8d3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -629,8 +629,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
>  	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
>  	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
>  	struct mlx5_eswitch_rep *rep =3D rpriv->rep;
> +	bool devcom_locked;
> =20
> +	devcom_locked =3D mlx5_devcom_for_each_peer_begin(esw->devcom);
>  	mlx5e_sqs2vport_stop(esw, rep);

[Severity: High]
If mlx5_devcom_for_each_peer_begin() returns false because the devcom is not
yet marked ready, it drops the read semaphore before returning:

drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c:
mlx5_devcom_for_each_peer_begin() {
	...
	if (!READ_ONCE(comp->ready)) {
		up_read(&comp->sem);
		return false;
	}
	...
}

In that case, devcom_locked will be false, but mlx5e_sqs2vport_stop() is
still executed without holding the devcom read semaphore.

Does this leave the list modifications in mlx5e_sqs2vport_stop() unprotected
against a concurrent devcom PAIR event, potentially leading to the same
use-after-free regression on rep_sq objects that this patch was intended to
resolve?

> +	if (devcom_locked)
> +		mlx5_devcom_for_each_peer_end(esw->devcom);
>  }
> =20
>  static int

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015085744.1109=
107-1-tariqt@nvidia.com?part=3D1
