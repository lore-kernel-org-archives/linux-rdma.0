Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994196;
	b=wkURaQkNGp2RQQX0yescAC5P3+DnaRtbuPw99Oxe16VGvpPHZ4AaAbdY8lngIFFkSECV
	 chA5ARkdhEn8AhOJzrZYsusejTi8J7L01sWrSD+kzyKF/5QT7eL8YsNEJU2ZWUWgvU/IU
	 p39W0nXnpg2s9AcRwrFshXKSuHNHP3KuDjix62ERg5eWAo1l93QTfl5JwESziFRBmoETl
	 mMnCLoMv/GFSt2VVO5KVTVlrpDShWfW+WGbc7WudJWYUQj8BmlEoDAuoAeo8p/zYkXTv/
	 rr6YuNzTa21uXI6YpNbwg95OyBLyzwI2tKtBaRKy/BN8Q6kZQjl/bl3YT0Hd+lKhzVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994196;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zBoHApS78KWaSOJpURT7X1ycqXXPCTHHts1dQsEyOq8=;
	b=wcrGWyy5k3ddueUEIUBBphcN+cwm9YSFPSD7086VuWX/y3y8yPZm9WsKcledgL2DE002
	 3elMyhqgvhScL93g1gWe0/fdHJ6jH/5tPhC5MyB06JWgmQaHtGYPp/lhf6yYdBVv9Pvr/
	 OYex8UFMs9SOlVcCUwzO7gfFyasslpJLcfiIikMDoFT+Y2OqMGNBSIgkXAP4Q6bNomwMK
	 33tcVw2Q2YFAh024bRydAeP/rfkErtJPaqdtQe4styQgR2g695szOEY37Wfl/puQsg8kd
	 nlBwKcZSmK3/90fMIP/bN0D6X/X3Q1g/nJ03MgBBIYkLPtc7lEPfEQcpCBX3QLwrFyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jcpQp2kP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BD0606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jcpQp2kP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D341F000C6;
	Wed, 18 Nov 2026 09:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994195;
	bh=zBoHApS78KWaSOJpURT7X1ycqXXPCTHHts1dQsEyOq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jcpQp2kPTJlFFnO/EcibpofXw+z1DV1m6VxTGdQp+HpZcBYvv3JrH4bF6ESrz33hc
	 QP4qOxP7MNXds38adHEKr3vDESWFgjFpSU1TXeLU8+x5pingDgFAz9/unMe//BoPvo
	 VvIt2O7hyj7fYKyHs9iId+4GgKz1xC7UUGl7/5OSripb4vYFNIp6MUrcQZzYlvTSYJ
	 mZ8mxpxMFxRKVnhoy/bBWAoOjSuw3ztJNO5IYOqp2i5XUbj4wFghXSCDf1mIFppInI
	 qjvOVKAGMqkgVYbSqyitNobX0iIeHMXZXAG2UwRucv5L0X9hZFuOcbcXs8cqvTl9rH
	 OZZuVIIGSgEYw==
Message-ID: <sashiko-outbox-220570@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 09/10] net/mlx5e: TC, match the tunnel key
 without a tunnel device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-10-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-10-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:55 +0000
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
- [Medium] net/mlx5e: missing 24-bit VNI mask check in outer key
  VXLAN/GENEVE parsers
--

commit f2971dcf3d78103aa3910311cdd90b5bd51fcc77
Author: Alexandre Cassen <acassen@corp.free.fr>

net/mlx5e: TC, match the tunnel key without a tunnel device

This commit adds TC flower support for matching the outer tunnel key
(enc_key_id) on GRE, VXLAN, GENEVE, and GTP-U traffic when no tunnel
device is used.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b=
/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
> index ee04fcdca6ffe..9a2f7a409a821 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
[ ... ]
> @@ -350,6 +351,42 @@ static bool mlx5e_tc_tun_encap_info_equal_geneve(str=
uct mlx5e_encap_key *a,
>  						     IP_TUNNEL_GENEVE_OPT_BIT);
>  }
> =20
> +static int
> +mlx5e_tc_tun_parse_outer_key_geneve(struct mlx5e_priv *priv,
> +				    struct mlx5_flow_spec *spec,
> +				    struct netlink_ext_ack *extack,
> +				    u32 key, u32 mask,
> +				    enum fs_flow_table_type fs_type)
> +{
> +	void *misc_c, *misc_v;
> +
> +	if (key >=3D MLX5E_TC_TUN_N_VNI) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Tunnel key does not fit the 24 bit VNI");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!mlx5e_tc_tun_can_offload_geneve(priv) ||
> +	    !MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
> +				     ft_field_support.outer_geneve_vni,
> +				     fs_type)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Matching on GENEVE VNI is not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	misc_c =3D MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> +			      misc_parameters);
> +	misc_v =3D MLX5_ADDR_OF(fte_match_param, spec->match_value,
> +			      misc_parameters);
> +
> +	MLX5_SET(fte_match_set_misc, misc_c, geneve_vni, mask);
> +	MLX5_SET(fte_match_set_misc, misc_v, geneve_vni, key);
> +	spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS;
> +
> +	return 0;
> +}
[ ... ]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> index 33911e72d20d0..610e2bbc21f1f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
[ ... ]
> @@ -261,6 +262,41 @@ static int mlx5e_tc_tun_get_remote_ifindex(struct ne=
t_device *mirred_dev)
>  	return ifindex;
>  }
> =20
> +static int
> +mlx5e_tc_tun_parse_outer_key_vxlan(struct mlx5e_priv *priv,
> +				   struct mlx5_flow_spec *spec,
> +				   struct netlink_ext_ack *extack,
> +				   u32 key, u32 mask,
> +				   enum fs_flow_table_type fs_type)
> +{
> +	void *misc_c, *misc_v;
> +
> +	if (key >=3D MLX5E_TC_TUN_N_VNI) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Tunnel key does not fit the 24 bit VNI");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
> +				     ft_field_support.outer_vxlan_vni,
> +				     fs_type)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Matching on VXLAN VNI is not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	misc_c =3D MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> +			      misc_parameters);
> +	misc_v =3D MLX5_ADDR_OF(fte_match_param, spec->match_value,
> +			      misc_parameters);
> +
> +	MLX5_SET(fte_match_set_misc, misc_c, vxlan_vni, mask);
> +	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni, key);
> +	spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS;
> +
> +	return 0;
> +}

[Severity: Medium]
Can a 32-bit enc_key_id mask with bits set only in [31:24] (such as
0/0xff000000) bypass the 24-bit VNI check in
mlx5e_tc_tun_parse_outer_key_geneve() and
mlx5e_tc_tun_parse_outer_key_vxlan()?

When key is 0 and mask & (MLX5E_TC_TUN_N_VNI - 1) is 0, key >=3D
MLX5E_TC_TUN_N_VNI is false, and MLX5_SET() truncates the 24-bit
geneve_vni or vxlan_vni mask to 0 while still setting
MLX5_MATCH_MISC_PARAMETERS.  Under SMFS, HMFS, or FDB DMFS when
misc_parameters has other non-zero criteria, this installs a hardware rule
that ignores the VNI and matches all UDP traffic on the tunnel port;
otherwise, enabling MLX5_MATCH_MISC_PARAMETERS with an all-zero
misc_parameters criteria causes firmware flow group creation to fail.

Rejecting !(mask & (MLX5E_TC_TUN_N_VNI - 1)) alongside key >=3D
MLX5E_TC_TUN_N_VNI, as cxgb4_validate_flow_match() does, would prevent
this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D9
