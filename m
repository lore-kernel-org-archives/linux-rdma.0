Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812432;
	b=qupYV9dcTx6gh8T4KceQwGbmq+3XzkoviXkUMygAgfI7w/TnklgTkuvsnpB7IZuEAgnG
	 PvCpRAZniFGygHk52yfpQHF+3cQe6Hr4/WBYi9cgnhHYBQDHgrzLH5IgmsBMvQhXMqo69
	 lBI5K/RqqCZ1kOgi9wBCfgWZmr4KMdZRmVlY1nH1UcMbHCTH/GMcJA3X8raDzGPzuy8Es
	 y8b/r3twetVvbSoFNzdWk2k8yyErQj9D67g5bMTDWrtdF00E5EUyPZtO3YVf2yMITdd8b
	 irjeMES9maJuG/wE8fCS1b+TZwBoq13k3yaHZIb/izVEHJyLhabnS1mSdd5HhzNhG9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w41RWmta+nC17ij7ogpDOrMMKRLEDscz1xet2H3UYdI=;
	b=pH8xqmCzDK+DUY32A6093TCw90/xQqYzP6xbv0i9FnaMHS/TyLRNszOWQMxMQwL8YtRr
	 bl1s+8s5CrQ6iMDXDTjjN9zZ2REBqQeW4PRSbNbMuDyjkoPh89rr9OSybnkoYgY1EUzic
	 Tb19qC3Ea5tKkX27+eSsEkRyb77TDuwRlPgB2h1cvfn3Ez7ITo1owVdm7pc+JnlXP54ck
	 Sykxr8NWJ3q+0PjjToWRq6fDWuikAux5qjWotyHDWu9s5PA2IQrz+brcGcfhWltXoQfMk
	 /od31dxWXNUNUtuyJHV6Buqd+elOr+dk0/7TDGtHP7hWT+AUV88cQVLyLiyQzKgR4jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqReGfXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AF4606A33E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqReGfXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093BA1F00A1A;
	Wed,  4 Nov 2026 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812432;
	bh=w41RWmta+nC17ij7ogpDOrMMKRLEDscz1xet2H3UYdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VqReGfXCDkVUJz06D1O5r0dBUdscaQhVBFXagk2IW4tNczBaYWNW89cxVVwq2fyq5
	 eNFEPQk5N4ZSqJJJe6nMvBMpWEHDr0tGQ2j3Lhq2dd3kXxV+vZbbFTgIYcamPCjemQ
	 qXsaDJZV9qdzwBBCfgOfK2A5XOblmxxoFPGHVwN4uVi5J9EZriyFRtZnB4eE634jyj
	 Jj6mSJseV4BUSVckmGxGiz2fBqWrpX09UI2waNtSORrojjGI+L6jECc7MT0cHNXcrh
	 aW5l/SPbVbTAMUyflyHpfZ07c4NF6aFaumLUlBafeG3zWMgBBmuc5Vsi3gXAOuc4/R
	 soXtHHRY2tEqg==
Message-ID: <sashiko-outbox-197741@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 14/15] net/mlx5e: Register eswitch-manager
 VF/SF self-port with switch-id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-15-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-15-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:51 +0000
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
- [Low] net/mlx5e: duplicated switch_id setup in mlx5e_devlink_port_registe=
r()
--

commit 54a79d65d3221b87550e0050ec06b1b9389a1a13
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id

This commit populates attrs.switch_id from the system image GUID when
registering a non-PF eswitch manager's self-port so that its uplink netdev
exposes a phys_switch_id matching its managed representors.

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

[Severity: Low]
This isn't a bug, but in drivers/net/ethernet/mellanox/mlx5/core/en/devlink=
.c,
mlx5e_devlink_port_register() already has the exact same
MLX5_ESWITCH_MANAGER(mdev) block in the mlx5_core_is_pf(mdev) branch:

	if (mlx5_core_is_pf(mdev)) {
		attrs.flavour =3D DEVLINK_PORT_FLAVOUR_PHYSICAL;
		attrs.phys.port_number =3D mlx5_get_dev_index(mdev);
		if (MLX5_ESWITCH_MANAGER(mdev)) {
			mlx5e_devlink_get_port_parent_id(mdev, &ppid);
			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
			attrs.switch_id.id_len =3D ppid.id_len;
		}
		dl_port_index =3D mlx5_esw_vport_to_devlink_port_index(mdev,
								     MLX5_VPORT_UPLINK);
	}

Since attrs.switch_id is independent of the flavour-specific union in struct
devlink_port_attrs, could the MLX5_ESWITCH_MANAGER(mdev) check be moved
outside the if/else statement to avoid duplicating it in both branches?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D14
