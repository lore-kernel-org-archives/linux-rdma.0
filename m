Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278C448F836
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246510; cv=none; b=sj9abgK/FZo0dF2QwZVpSDEi+aLkVVaumo3Qb1kQjtxEaqzuuqHm8zIvgGPn4O61aJeLJ03yg9KyosFVvi1L9Zbh+Z3WPtNCAdfVt5YirLd4fab1vnY6x2IjqwYGFde5rq/cZF2N0a4Ck5/y6wfV+V/NsKr+JVriKcSGg42e0XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246510; c=relaxed/simple;
	bh=6SkI6IbiGXeYA9eEEnFpt5z8fkLz+sJseY4etAp5Sjw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gdrmx+VQMg8p82R+jpU4WpEJg+oQmRJPZ0xWjyqVfD7rpqrZLah3d2Aa4kmZkmKkPqIw6h1gw7x4wJHAYWE+H3RR2HMsdOnxaCh38kwrsO1PTzjP0n7h8X1/DrzRc2FNeaIyGDO6XFEKYRVPWeIHV+DMpSHOw09/9AzUOScOfaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhUeORPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhUeORPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D971F008A1;
	Thu, 24 Sep 2026 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246507;
	bh=Aw7u7o98v/4AnKLFkyyINHLQDhyfq72X1qupapIkye0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dhUeORPnGzgti5pwV27TdTOqmDSluvKko2I+hDI1rTLe6nU6xcuJVwfgAvPUonkL7
	 Kj39X6mezkop6ejrLldluQksa6a3tusbW4gZ3Ayc7L0oYO9Reh46mx594fqCbnEuLj
	 e7g4YjgMb4MvHrh9eF1T+kZWS25+4qArbvp84WE1iVY3OIg0jmulRqWy0GIYKzLWoe
	 a6qqhM/1kN1jPn945nn33NP2NQoPi+ka9ZNqAb7KSnuGlUhQ5NQ1Z5wTjN8We6Zwgo
	 2pvaJZJtv7K8J7gxUvcMrb1moLDoT+0B2FEuOQ75uCES/gHy+OmDfxYFfGhhxeiWLK
	 m2R9wLqWevaOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 09/13] net/mlx5: E-switch, derive manager vport
 from device capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-10-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-10-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:46 +0000
Message-Id: <20260924104146.D1D971F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mlx5: VF manager vport left disabled during eswitch init
- [High] mlx5: steering subsystems misidentify VF manager due to hardcoded =
vport
--

commit b7db8f67187916a60362e41344e85b321363810d
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: E-switch, derive manager vport from device capability

mlx5_eswitch_manager_vport() hardcoded the e-switch manager vport as
either the ECPF or the host PF. Read esw_manager_vport_number from the
e-switch capability when esw_manager_vport_number_valid is set, so the
manager vport can be a VF - a prerequisite for VFs acting as e-switch
managers. Keep the previous mapping as fallback when the capability does
not report a number.

> diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
> index a0dd162baa787..03d3620141c83 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -222,6 +222,9 @@ static inline bool is_mdev_switchdev_mode(struct mlx5=
_core_dev *dev)
>  /* The returned number is valid only when the dev is eswitch manager. */
>  static inline u16 mlx5_eswitch_manager_vport(struct mlx5_core_dev *dev)
>  {
> +	if (MLX5_CAP_ESW(dev, esw_manager_vport_number_valid))
> +		return MLX5_CAP_ESW(dev, esw_manager_vport_number);
> +

[Severity: High]
With this change allowing a VF to be the e-switch manager, does it break
initialization in mlx5_eswitch_enable_pf_vf_vports()?

Looking at drivers/net/ethernet/mellanox/mlx5/core/eswitch.c, that function
hardcodes loading only MLX5_VPORT_HOST_PF and MLX5_VPORT_ECPF:

	/* Enable ECPF vport */
	if (mlx5_ecpf_vport_exists(esw->dev)) {
		ret =3D mlx5_eswitch_load_pf_vf_vport(esw, MLX5_VPORT_ECPF, enabled_event=
s);
		if (ret)
			goto ecpf_err;
	}

Since a VF doesn't have its own VFs (num_vfs =3D=3D 0), the iteration over =
VFs
skips it as well. Without a direct call to load esw->manager_vport, does th=
e VF
manager vport remain disabled?

Similarly, the teardown path in mlx5_eswitch_disable_pf_vf_vports()
hardcodes unloads for ECPF and HOST_PF, omitting the VF manager vport if it
had been loaded.

[Severity: High]
Does returning a VF manager vport here also break steering subsystems that
hardcode the manager vport ID?

In drivers/net/ethernet/mellanox/mlx5/core/steering/hws/vport.c:

static bool hws_vport_is_esw_mgr_vport(struct mlx5hws_context *ctx, u16 vpo=
rt)
{
	return ctx->caps->is_ecpf ? vport =3D=3D MLX5_VPORT_ECPF :
				    vport =3D=3D MLX5_VPORT_HOST_PF;
}

And similarly in drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_do=
main.c:

static bool dr_domain_is_esw_mgr_vport(struct mlx5dr_domain *dmn, u16 vport)
{
	struct mlx5dr_cmd_caps *caps =3D &dmn->info.caps;

	return (caps->is_ecpf && vport =3D=3D MLX5_VPORT_ECPF) ||
	       (!caps->is_ecpf && vport =3D=3D 0);
}

Both functions falsely assume the manager vport is MLX5_VPORT_HOST_PF (0) f=
or
non-ECPF devices, which would return false for a VF manager.=20

Will this cause the driver to query the manager's own capabilities and GVMI
using firmware commands designed for other vports, leading to GVMI resoluti=
on
failures and packet misrouting?

>  	return mlx5_core_is_ecpf_esw_manager(dev) ?
>  		MLX5_VPORT_ECPF : MLX5_VPORT_HOST_PF;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D9
