Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336024;
	b=e25i5LQhtg3Tn8+XFuNZhsZl7XgRDh0/hj08qdDu+xswxEw/85gAmeIV3Q+ZxWhvwrN9
	 8snUIpFbG/uBd0x0Obhx41EeuknuKScMCYaJr1nozOp7e92e0qpjfqoFjtfPWT4OaIvYX
	 f5+aK94vcVQzEXfe7jIZhk11tdBs3MvYiRlqJzph6ocHPXlejZT/6s+Kc/SoQ0PDs3fkV
	 QpYb3BiKvN1FBS5Ms5XZh+sMg/vpqty4uzcNwNkye8T4cnaobiWdSLfpg+Qv+USPjJZPZ
	 w3aJBzH2yf6fTM8uHnstgzGdbRSh90nS/fkUYli+P7yj/7px/q9qJOPmoEPl+nPSebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WUjtgkcqMMQs2FaL4gYKOmBrisQd2gyb8zNlygd0NHc=;
	b=yt/2KjYn/BKGhS2Sbw6E9Vl1L2IEifvCwnKx31kX6jis8yXp8hEyb/pLhMzbdu3Qz1oT
	 W0Fm23i5nG+PTIMGCg0uxxd9879g5S0yGZMPk6IlYp+C9iKIJVZ+2V+c/ucp4oQ8kWtMj
	 aa9u1r6w9Eb/+6Ovr+rFux8X9oHuNCCDxxb+tNkwJFSaMzwHpTOY9zvoQ/c5YvECKqotl
	 Hl8TtokXUAJyb6NY9ofkk5dR362aX2+x7mzfwRUYlrkAAtRweZcLpQzzzgDsyAQvL/m+z
	 Fb5trqUzEVA+uziiYU6LlKY9SdJscnp3xUWcswWhtNCDMLcNBHULp0YPFq3kyuMm6cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZpGvBthb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F42E606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZpGvBthb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478B71F0093A;
	Fri, 30 Oct 2026 04:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336024;
	bh=WUjtgkcqMMQs2FaL4gYKOmBrisQd2gyb8zNlygd0NHc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZpGvBthbnyVfqJbTV3E0SyGUUFr0gUeD1gkAC1PGF59o5f5pkD0pY/zTNZNzrTtzE
	 u1GcxGpdnacngk5ZBEkliAGPNeCw3grNOBpx5DWjQZX5morhNqco6NxJkmn6rYrB4c
	 Y6yqMLB8B+aWAMtavlR1bjpcL/lNur6IZq0VJgjJuSGjuUytSnNgQt4cvP+eJCkdU1
	 qMadgvaj9qOF5cdo2p/8U9sLLgmwRt+W7dFTe2Ak2GK6jQD/wrbzDA2Y+3beEiiUnf
	 eu7LM8FBTndGyLBeV1Mf0avhdiiUUqCIPdLBQ7f6njwg21pWqahtXbRfeY2GeZd23n
	 B5HlGib0Tovtg==
Message-ID: <sashiko-outbox-190342@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V4 3/4] net/mlx5e: SD, Fix missing cleanup on probe
 error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428060111.221086-4-tariqt@nvidia.com>
References: <20260428060111.221086-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:43 +0000
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
- [High] NULL Pointer Dereference in _mlx5e_remove() during suspend/resume =
error or hot-unplug of a secondary SD device.
--

commit 6088c89e67042c08a966bd363281ba624421bac1
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: SD, Fix missing cleanup on probe error

This commit adds a missing mlx5_sd_cleanup() call to the probe error path.
The commit message notes a similar gap exists on the resume path leaving
sd =3D=3D NULL on failure, but defers the fix to a follow-up series.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index 5a46870c4b74..e21affd0ffc4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
[ ... ]
> @@ -6912,9 +6912,16 @@ static int mlx5e_probe(struct auxiliary_device *ad=
ev,
>  		return err;
> =20
>  	actual_adev =3D mlx5_sd_get_adev(mdev, adev, edev->idx);
> -	if (actual_adev)
> -		return _mlx5e_probe(actual_adev);
> +	if (actual_adev) {
> +		err =3D _mlx5e_probe(actual_adev);
> +		if (err)
> +			goto sd_cleanup;
> +	}
>  	return 0;
> +
> +sd_cleanup:
> +	mlx5_sd_cleanup(mdev);
> +	return err;
>  }
> =20
>  static void _mlx5e_remove(struct auxiliary_device *adev)

Will leaving the resume gap unfixed as mentioned in the commit message cause
a NULL pointer dereference when a secondary device is later removed?

If a secondary device fails resume, sd becomes NULL. Later during removal,
mlx5_sd_get_adev() will check !sd and return the secondary adev.

This causes _mlx5e_remove() to be executed on the secondary adev:

_mlx5e_remove()
{
        struct mlx5_adev *edev =3D container_of(adev, struct mlx5_adev, ade=
v);
        struct mlx5e_dev *mlx5e_dev =3D auxiliary_get_drvdata(adev);
        struct net_device *netdev =3D mlx5e_dev->netdev;
        ...
}

Since _mlx5e_probe() is never called on secondary devices,
auxiliary_get_drvdata(adev) returns NULL. Does this mean accessing
mlx5e_dev->netdev will crash?

Would it be safer to add a NULL check for mlx5e_dev in _mlx5e_remove()
until the proper PM lifecycle fixes are implemented?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428060111.2210=
86-1-tariqt@nvidia.com?part=3D3
