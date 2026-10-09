Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F45013C4
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791578594; cv=none; b=iyJ56i4VSNrU+a3C10UBzaOsVbAf+ttAuI4ghWqvLdnja8sCJdVqIVw6nQYzGf0e8fgagn+C993s6xHLnJeF0mHQ0Xxrvhhh6NwEC2cHbsZpIiMry+TWbMH8YTmhNFIkm8YcS/7s+UvzLjOGiwyBT2gq3pGCi5GVwg6XFf9y860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791578594; c=relaxed/simple;
	bh=eerf4R8R//l7Keh748efliZMnVmOOgPzU04Q9362MHY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dxU3LYHUe8pbPqque60AzeAE1BY/pjyqeoBELFBBAlSQu00gGyHVbqa0fjNjwqWnE2UUVCC3jJb2qUwXRooJRlak7RZ5uHRxjx45PT72cyA4xvLub4mBRmlMHiQSiiOVKl1v/mLHfoI8T3GESdUTn3tW0So9xfqPrUmshSe0ZJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCDjJPo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCDjJPo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8A51F000FF;
	Fri,  9 Oct 2026 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791578593;
	bh=dMF8ybEHFHUUdKEd6htQCnJXoGT0UMj/xdsWR5ndWZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cCDjJPo96lKjJobY4f/jGsThnEQqXTf5XzZojVwrakpWs3YQ8KeGuBTrSeWvW+snp
	 qzAFZ2k3cblsRHUBPdt+z7daa4FX6DBwBN4DjARPb/CYS5nspRjRWzF5UG5bGud2UM
	 8lWvuGu87cJUmOghNeV+9eC44XFg0FOWMcY47WI/98GKJKLzaOtqvCsJDRiiVEBxV1
	 NiCOGKyHRfXuNbt6a9NcBf3uiiauGjV8+5w3UbbH1dv0VXkOzujomkf9fx+ImRJ3jq
	 X09Z2bkEmCwCz9aWUmpbKjkyjadOHO2GdtLb6yz0lItJwPFE812y0xgRKxm98NC8zW
	 5pk4KX2vQCQ8A==
Message-ID: <sashiko-outbox-166055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix modify header pool creation
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008204230.3222198-3-acassen@corp.free.fr>
References: <20261008204230.3222198-1-acassen@corp.free.fr>
 <20261008204230.3222198-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 20:43:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5: 32-bit truncation of 64-bit modify actions in pool match
--

commit 214c1c5671cbf4fde727381eec5a1bbac14499d3
Author: Alexandre Cassen <acassen@corp.free.fr>

net/mlx5: HWS, fix modify header pool creation race

This commit adds a mutex to serialize modify header pool creation in
mlx5_cmd_hws_modify_header_alloc() to prevent concurrent callers from
failing with -EBUSY. It also removes the error path destruction of the newly
created pool so that other concurrent users can still access it.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.=
c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 66edb42268cbd..b387016bb5aad 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c

[ ... ]

> @@ -1474,6 +1476,7 @@ static int mlx5_cmd_hws_modify_header_alloc(struct =
mlx5_flow_root_namespace *ns,
>  	pattern.sz =3D MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_acti=
ons;
>  	pattern.data =3D modify_actions;
> =20
> +	mutex_lock(&hws_pool->mh_pools_lock);
>  	known_pattern =3D false;
>  	xa_for_each(&hws_pool->mh_pools, i, pool) {
>  		if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {

[Severity: High]
Does mlx5_fs_hws_mh_pool_match() incorrectly truncate 64-bit modify actions=
 to
32 bits during comparison?

Looking at drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pool=
s.c:

mlx5_fs_hws_mh_pool_match() {
	...
	for (i =3D 0; i < num_actions; i++) {
		if ((__force __be32)pattern->data[i] !=3D
		    (__force __be32)pool_pattern->data[i])
			return false;
	}
	...
}

The pattern->data array elements are 64-bit PRM elements (__be64). Casting
them to __be32 compares only the lower 32 bits, completely ignoring the act=
ion
type and target fields in the upper 32 bits.

Could this cause two distinct flow modify actions that share the same lower
32 bits to evaluate as equal, resulting in them incorrectly sharing the same
modify header pool and executing the wrong actions on packets?

>  			known_pattern =3D true;
>  			break;
>  		}
>  		cnt++;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008204230.3222=
198-1-acassen@corp.free.fr?part=3D2
