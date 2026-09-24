Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9436148C3FB
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246507; cv=none; b=Ok+Q11qfOsaDudlcG+hQZv+dyHRa4WSmhIpiYGG6DrT8u83Hps0o2+6Fk7PwYErAhElq1zI4+yHXB5i3qT/mfD7MfXv6cMVUugpZDLx65orK99kEOURjOHZNnJb71g3fxk8ahKaZAFwK6SypfVuKDkK2hhp2ljuwn2H2gcz1PBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246507; c=relaxed/simple;
	bh=iFzoIyx+96FVpFs+0dB3W3TUIHvz7J+i5uIXq3YYyv4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nb6vwLuPBm39wqu2lOzYKBgflhxKT9ilXos40sQlyi/BWP6rtPvxbGTvihdZCtaoiCaifGRFZiGDsmz9JENZtlF+S6+XBrwbst0uKbcU1vgfOyYc7TWGOz5DcAKGZtANGSt783HZX/hkzxhbxVM+UYUgvVALd/74lgpE3T/gjh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1YRVjlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1YRVjlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72601F00899;
	Thu, 24 Sep 2026 10:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246504;
	bh=ZZ5Y29KCHMFfM337AE+vPJQT+ts8hslj+4bD2VrMaAw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z1YRVjlBZTvtS9XjIfb/XLhqxOsIs9exElDTGT9mnJldOkHA8A8mUJKFkIds6AQT6
	 xwlP+heyWdzCH8dC1nBKEK3SCMNJ1CjQokqV394fezK+qAk9qvgoA/f60veqy3AeGz
	 NIBZkU82SYCQZA8sjyMYRwo7Cg5HWCiMKh+9OBkpIe1UeWflk6z1m1O7RYRGahCO/k
	 jZTtndcr6epg+Bdh1pgTmqmBpPEB+H3M6FRhn8Yz03GnUs4Jflhtk7IgbBS0drsjv3
	 cHDtsqmjgtCNHgmjVIBoLIFgVLtctw2EXYRDkfCFKzKWAZB5u+IzPTeH4q9hY7YeK/
	 tMTwn3XLPv8WQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 06/13] net/mlx5: LAG, size debugfs buffers by
 port count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-7-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:44 +0000
Message-Id: <20260924104144.A72601F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/mlx5: heap buffer overflow in mapping_show() due to unbounde=
d port iteration
--

commit 246f550ad218121a01820b63c27f405fffbeac7b
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: LAG, size debugfs buffers by port count

This commit changes mapping_show() in the debugfs interface to dynamically
allocate the ports buffer based on the actual number of ports rather than
using a fixed maximum size.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> index e9b8d79d2d21e..44296789d6567 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> @@ -101,14 +101,18 @@ static int flags_show(struct seq_file *file, void *=
priv)
>  static int mapping_show(struct seq_file *file, void *priv)
>  {
>  	struct mlx5_core_dev *dev =3D file->private;
> -	u8 ports[MLX5_MAX_PORTS] =3D {};
>  	struct mlx5_lag *ldev;
>  	bool hash =3D false;
>  	bool lag_active;
>  	int i, idx =3D 0;
>  	int num_ports;
> +	u8 *ports;
> =20
>  	ldev =3D mlx5_lag_dev(dev);
> +	ports =3D kcalloc(ldev->ports, sizeof(*ports), GFP_KERNEL);
> +	if (!ports)
> +		return -ENOMEM;
> +

[Severity: Medium]
Can this allocation size lead to a heap buffer overflow?

The ports array is dynamically sized to ldev->ports. However, it is
populated below this allocation using mlx5_ldev_for_each(), which iterates
up to MLX5_MAX_PORTS:

    mlx5_ldev_for_each(i, 0, ldev)
        ports[idx++] =3D ldev->v2p_map[i];

If firmware anomalies or hotplugging cause mlx5_ldev_for_each() to find more
devices than ldev->ports, will this write past the end of the ports buffer?

Similarly, when hash mapping is used, mapping_show() calls
mlx5_infer_tx_enabled() to populate the buffer:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_infer_tx_enabled()
    mlx5_ldev_for_each(i, 0, ldev)
        if (tracker->netdev_state[i].tx_enabled &&
            tracker->netdev_state[i].link_up)
            ports[(*num_enabled)++] =3D i;

Could this path also overflow the buffer since it shares the same unbounded
iteration logic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D6
