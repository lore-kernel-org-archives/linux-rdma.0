Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C48647141E
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065332; cv=none; b=iZLnhcoDFOeRXGyPR6JxUY64J2veDFmEKaSVtIk0P6UIOGWv9CI8XrZ+xdLjJZiIoz8oA+JfSp2ept5EFytS0FmPXR4Omw2+iUSAAkWOiqVsLW4SR0vEJ0nwP+Su3XHWMDa1va7/QLdUjPkTR8cWwU558LvxIfD7G9LAitQ5DOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065332; c=relaxed/simple;
	bh=diwUbzma+4J6hZ538ib8HhImm4qz7Og0F3Tr9JVM4t0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QzQ1E07/EbSTx9Vfv5xz2KPNvjGHHYBw+54J/7KBHt9UkGZ+lyEufbA5zwRj1ng0I0x4FjSHzcvnNMysXWqDR16VGwdCeVPAK3fEuXqUkCX9AP7mebrtEoS2RSKOGkeFmPktF/PSfX7gLWc1baOpkgbC0kMrmhxN6uLkJNXXm9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJZ0fFz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJZ0fFz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8B61F000C4;
	Thu, 15 Oct 2026 11:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792065330;
	bh=aFR1XJA/c/XhnusL1xnZZztIp59COGtNX7189q1kGmg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fJZ0fFz3tNji1a7JEdm643VNI6QdD1RX+Ywb7iAuN5FvAmtIkVNcUZnqsr5f2faTI
	 btcahIp4ZoLgLS+uFlTbrzSWGO7nlQuWYYg6jTzXpGv/XlYbot0Ndnz0bpMH62LpPY
	 GRsiON4TqW3VwT0VT8bHTd/pMD07EVnDIbUnBmXo5zwBYAJQ9OKQ+AkP6qg7wXpunb
	 mPmYCrnCqRZk9lS2JE5dU0VeLsWLq8Knm4xCSvXQR167XbS8iAMaIfugERHc4JB49A
	 9y/dhzwi6gxUeT22/HtgCTZtwywqlv4dgUR5UlqfZCiR62TvQeBLQn3+j79UcowR2W
	 ww2i0RWBR5dEA==
Message-ID: <sashiko-outbox-172773@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Add missing error flow in
 mlx5_ib_set_vport_rep
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015-rep-netdev-leak-v1-1-5110013806ae@nvidia.com>
References: <20261015-rep-netdev-leak-v1-1-5110013806ae@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 11:55:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mlx5: TOCTOU race in port representor cleanup leading to NULL=
 deref
--

commit 8e906a48ae2be9e11d0c09a6021af6c819f14449
Author: Shay Drory <shayd@nvidia.com>

RDMA/mlx5: Add missing error flow in mlx5_ib_set_vport_rep

mlx5_ib_set_vport_rep() attaches the representor netdev to the IB
device, which takes a netdev reference, and then adds the LAG demux
rule. Undo the netdev attach and clear the rep pointers on failure.

> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/=
mlx5/ib_rep.c
> index 65d8767d1830c..9cbd27063ba8f 100644
> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> @@ -36,7 +36,18 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
>  	if (mlx5_eswitch_get_total_vports(dev) > vport_index)
>  		return 0;
> =20
> -	return mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
> +	ret =3D mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
> +	if (ret)
> +		goto err_demux;
> +
> +	return 0;
> +
> +err_demux:
> +	ib_device_set_netdev(&ibdev->ib_dev, NULL, vport_index + 1);
> +err_set_netdev:
> +	rep->rep_data[REP_IB].priv =3D NULL;
> +	ibdev->port[vport_index].rep =3D NULL;

[Severity: High]
Can this lockless clearing of the pointer cause a NULL pointer dereference
if it races with concurrent readers?

In drivers/infiniband/hw/mlx5/counters.c:mlx5_ib_query_q_counters_vport(),
the rep pointer is checked and then dereferenced:

	if (!dev->port[port_num].rep ||
	    dev->port[port_num].rep->vport =3D=3D MLX5_VPORT_UPLINK)
		return 0;

	mdev =3D mlx5_eswitch_get_core_dev(dev->port[port_num].rep->esw);

Since there is no READ_ONCE() or local caching of the pointer on the
read side, and no synchronization with this error path, can the compiler
reload the pointer from memory after the safety check?

If the pointer is cleared by the error path here between the check and
the dereference in mlx5_ib_query_q_counters_vport(), wouldn't this
result in a NULL pointer dereference?

> +	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-rep-netdev=
-leak-v1-1-5110013806ae@nvidia.com?part=3D1
