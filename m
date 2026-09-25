Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52FC4AE116
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357714; cv=none; b=esF/CpRw/Jg/W4+3SkLnZYm1p8AWDQwAW9wwlA9yxjkqvC7QGxqJRoZgMjuDdGWUbDihSM340Reoe+rv/rI6mPNex6CXuja+rtNpni7YVLtU7sk9KezKfPUuQY5bvgaSUjSCBTMZdCmnL1t84Tg09LXBL4izeGP6/JrCzRfb46o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357714; c=relaxed/simple;
	bh=zyIf44cnv7UpbY3MHOaJ8XxYB3lSjxx/KdoPsEcd7sc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NJDqSD5ACS0yBgcZE0lxwPnW1ISGiNZ4E8osOfnCk9dBnHGevKD3ClBkTiFVT5GZd3aaR56C++UdPe6I49JRXv3upxi82ZuA37RKXOuzdK1/tOXVyNiiGqm/Tjwsk601Q4UpCgbAfmsZGd/XNuaQC3CPKb27M8spZWnj12YAwXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DM7/i7nj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DM7/i7nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273EF1F000FF;
	Fri, 25 Sep 2026 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790357713;
	bh=bjBTF0lvVqHdxyiE2BpF/7/U/ImgzEOVrVSvVMpthPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DM7/i7nj0K2aWAXLi0PJTzTWgNnDQ6EBM8lLxpqGa1HPF1mohdTRlF4Nenc9dSYmL
	 TndBehgBSmgT7Qc55LDUPYPeG89SqWXF4jqPCnhMaBh+w+72yKohhwWVtB0/ww9lZR
	 /JjM6bEt1aafDd7qAT80XnxjMA2ZXeLOLPoOVpO2jvoRjScYAPubZKklBz2MTrNFhS
	 GZS2IY2oaf4L9vtDxCMAHvS2II88+iqmSuFy7UorKEMa0jHe78qshvmvv3NxbWZxDe
	 M4SWSY8/+LWtlLkPMpXAyvdVvm6syBDRTcNZQMmPIcuHgBJrWagz5yRUDNujMdlGIq
	 zL0yRAUPUxZbQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y] net/mlx5e: TC, Fix internal port memory leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260924173505.87763-1-artem@trailofbits.com>
References: <20260924173505.87763-1-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 17:35:12 +0000
Message-Id: <20260925173513.273EF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mlx5e: double free of int_port in flow post actions backport
--

commit 31e3e836a049949a2f6ef2d83fb49017f4be37e3
Author: Jianbo Liu <jianbol@nvidia.com>

net/mlx5e: TC, Fix internal port memory leak

This commit attempts to fix a memory leak of the internal port object when
flow rules forward packets from an internal port over a tunnel. It moves the
cleanup into free_flow_post_acts() to release references on cloned
post-action attributes.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index 05888942ef276..d2f226a09a0c7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
[ ... ]
> @@ -3713,6 +3714,16 @@ free_flow_post_acts(struct mlx5e_tc_flow *flow)
>  				mlx5_modify_header_dealloc(flow->priv->mdev, attr->modify_hdr);
>  		}
> =20
> +		if (mlx5e_is_eswitch_flow(flow)) {
> +			esw_attr =3D attr->esw_attr;
> +			if (esw_attr->int_port)
> +				mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(flow->priv),
> +						      esw_attr->int_port);
> +			if (esw_attr->dest_int_port)
> +				mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(flow->priv),
> +						      esw_attr->dest_int_port);
                                                      ^^^^^^^^^^^^^^^^^^^^^=
^^
[Severity: High]
Can this cause a double free of the mlx5e_tc_int_port object?

When parsing a multi-table action, mlx5e_clone_flow_attr_for_post_act()
performs a shallow copy of the primary attribute:

mlx5e_clone_flow_attr_for_post_act() {
	...
	memcpy(attr2, attr, attr_sz);
	...
}

This duplicates the dest_int_port and int_port pointers into the cloned
attribute without acquiring new references for them.

During flow deletion, mlx5e_tc_del_fdb_flow() already correctly puts the
primary attribute's dest_int_port, dropping the refcount and freeing the
internal port object:

mlx5e_tc_del_fdb_flow() {
	...
	if (esw_attr->dest_int_port)
		mlx5e_tc_int_port_put(mlx5e_get_int_port_priv(priv),
				      esw_attr->dest_int_port);
	...
}

Since the cloned attributes never took their own references, won't putting
the pointers again here in free_flow_post_acts() result in a use-after-free
and double free of the already-freed mlx5e_tc_int_port object?

> +		}
> +
>  		list_del(&attr->list);
>  		kvfree(attr->parse_attr);
>  		kfree(attr);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924173505.8776=
3-1-artem@trailofbits.com?part=3D1
