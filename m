Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795248151;
	b=sryMSlfTkhQVMOjO718CXJ+h4KuxycPQnkt+s3Avqp9mIfhJBCaKMYiIPR2r7OkqlltM
	 zgg2sOpU5BcI5BOQ851PsHJF49gRrniJkbpJHSxVtiB9iVrRbEkPC6lcoeRGcPSSlS5AD
	 ++FmB+YFm044V18EMwH+fmj5e6iOpaq6PFb7iPNDvnHSNxEXbhJH2F6mnRRifoI4AR1SS
	 uxizTAGfbZQzFC4YzMkdJWYOCbX6VoUWOhdaxjGCXMNWklbKrJQw9etKazzuJRexTHHmF
	 YIgPilDWEziq3tvw3Mzvhbp1u2470lSraNyzM2/anXh0FfAvTUnArgtpFKs+ZpsvdbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795248151;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XQMqykHZkYPJLdkTUFZM1MKABRT2cdQ1Lf3rJPa2XpI=;
	b=qd7PkP/xH1jqC62L5xgq+K3KO/ptS3Rub8qSqcyxG0b9oIznve+sr/2LX5OrzsoIBFwC
	 14d5HygnFLDAcwf8oTCu0Sx9p3dJOAVJLQh+0FPi+zAkLx6zVMg49wHLU51uTzhUD9l8K
	 QtdCt9R0cZHnyYh9Gdsh4a1L3fBfVFzyXH02zSJPWZfAStiv+r0Chyc6F4gZeF8vDQTZn
	 4SDDxHECEFUEvOKj+dqgBBaYnV1Te9mkyJcNcxons9D7+duRwgFwOkLudvRDap0DpBhUU
	 Aa7EtrJFzwjiGgcQq0QN5gyJC1xGBdYaB5KKwkZ9rfL3Q44xKh09HiUFt9N+IvAOWqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cReAyr4o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808FF606A32C
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cReAyr4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6701F000C4;
	Sat, 21 Nov 2026 08:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795248151;
	bh=XQMqykHZkYPJLdkTUFZM1MKABRT2cdQ1Lf3rJPa2XpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cReAyr4ouZ5XGlkmKxJcWhYTVyzTpGCIdhye3xanK1fwCLYTUw+NEVBP1C20Xvg0h
	 F9fodOJzN0h5zVWMwy08R5sYtfwU4oLCRKvKvQQsPvMdZRZb9Ulma6xjEV+5i9Qjft
	 U0s+kG8w03EZhzkqArGdEEK3Z7LDhVtcjvid0heidxYKeVJa724Cc2ghIlq5iCbwxg
	 oEa9rw4iKyRrwfPVQa3sIiMMV86DSC3NpfHQTtBmw9K7lxSD8s3j93TWDFiJRq95n7
	 EmR568YfSXei9V+2rSPoTGPT4UttJv2VgJxFWivEi9BxyKKtxJ8STfWVBhdmDx5dHg
	 QxJjkQE42ZenQ==
Message-ID: <sashiko-outbox-226815@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 4/5] net/mlx5e: Register eswitch-manager
 VF/SF self-port with switch-id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120075959.2533702-5-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
 <20261120075959.2533702-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:02:30 +0000
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
- [Low] net/mlx5e: duplicated switch_id setup in
  mlx5e_devlink_port_register()
--

commit a4fbc34804738e4b1300b56b57462bb3c5135774
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id

This commit populates attrs.switch_id from the system image GUID when
registering the self-port of a non-PF eswitch manager function.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/devlink.c
> index 8818f65d1fbc4..79adb1ecc4506 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> @@ -63,6 +63,11 @@ int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5=
e_dev,
>  		dl_port_index =3D mlx5_esw_vport_to_devlink_port_index(mdev,
>  								     MLX5_VPORT_UPLINK);
>  	} else {
> +		if (MLX5_ESWITCH_MANAGER(mdev)) {
> +			mlx5e_devlink_get_port_parent_id(mdev, &ppid);
> +			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
> +			attrs.switch_id.id_len =3D ppid.id_len;
> +		}
>  		attrs.flavour =3D DEVLINK_PORT_FLAVOUR_VIRTUAL;
>  		dl_port_index =3D mlx5_esw_vport_to_devlink_port_index(mdev, 0);
>  	}

[Severity: Low]
This isn't a bug, but the mlx5_core_is_pf(mdev) branch right above already
contains this exact if (MLX5_ESWITCH_MANAGER(mdev)) block to populate
attrs.switch_id.  Could it be moved outside the if/else to avoid duplicating
it in both branches?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120075959.2533=
702-1-tariqt@nvidia.com?part=3D4
