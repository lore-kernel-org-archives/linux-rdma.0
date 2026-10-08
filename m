Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517F4AD4B9
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470329; cv=none; b=dT9R9Gr/AdkZX2p+0ODe0HJKRLTZ2+UUzlOk85Vc3Rn9a57zvWzq8KCSjHsofAX0uByue3DWkwhQEWpLUCnn9E9R/mn9mMLbwThwVyUO1f7I/Vhm6lJHlEVAp7OWGMhqFLL7WWkj74pZgRGmBpifdZrngcjtDAHxuxSF2CA09U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470329; c=relaxed/simple;
	bh=81Cb3evR3+/QPK1eKmghxuS/7vY9YTT3Oxi3ig51R7c=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=u8uNgPL9W6zBZRpI9R4jCo/nnKXPo6Xoi09OdKKf9PCvf0GrL9HbIQ3cgWHXHDbMVCsH64nH7L/t2E6tigvSpzR/+nuHFt/iIsqsdjE6gf5mtC9Z0FLVW1OEXFQWKWG4ixox2gXFqRQQAK2KhvHuCAQkVTPLjlTECxi/fNdlZAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDtTqCo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDtTqCo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55E11F000FF;
	Thu,  8 Oct 2026 14:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791470326;
	bh=lcMscOh2PCR2cbqaJjZIpYJxK9W0g+KlDbFMt0+BS1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dDtTqCo7axHyjObpw3hkLWMF3802+ipcUJvrWS6PKEC2ylw5zPZq7Eig9E7S+8v2D
	 U1bhW1Lqsl0kIf15I5WMq/ACmL5o/SBmjfkPS3evNz6EUn4sw+979+lyPMLI5mNrKM
	 hgBxxMcm+IoUlAyHs08jvJpGl2v/OqbBdfr1BNfkEoZENW6g65qLKSesup90bd5nbo
	 nl729+29A0r4bRPCmlSN4OQRwCPsj1ROPGCWJS0pguEyBdRjGBOMlTl/mYSmU8/loh
	 h3Ur2X8WWJyhANbybozo1aM1/7hT13HubD8atzAMHKHQhZhA7aP7CcBTNAaF7jfx+1
	 lEn2FOm7/fpbg==
Message-ID: <sashiko-outbox-164310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/2] net/mlx5: HWS, release L2 to L3 tunnel
 reformats to their own pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007143830.1733583-2-acassen@corp.free.fr>
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <20261007143830.1733583-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 14:38:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] net/mlx5: memory leak of pr_data->data in packet reformat dealloc
- [Medium] net/mlx5: TOCTOU race in packet reformat pool allocation
--

commit b8aadd3f3a4943df684cd9bcfb91cb735038141f
Author: Alexandre Cassen <acassen@corp.free.fr>

net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool

L2 to L3 tunnel reformats are now released to the el2tol3tnl pools.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.=
c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 5a172c572a68f..44b311b4532d1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -1398,8 +1398,8 @@ static void mlx5_cmd_hws_packet_reformat_dealloc(st=
ruct mlx5_flow_root_namespace
>  						    pr_data->data_size);
>  		break;
>  	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
> -		pr_pool =3D mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol2tnl_pools,
> -						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
> +		pr_pool =3D mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol3tnl_pools,
> +						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3,
>  						    pr_data->data_size);

[Severity: Medium]
Could this call to mlx5_fs_get_pr_encap_pool() result in a time-of-check to
time-of-use race?

If multiple threads concurrently attempt to offload TC rules requiring a new
packet reformat pool of the same size, they might race locklessly. Both
threads could evaluate xa_load() to NULL and race on xa_insert():

drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c:mlx5_fs_get_p=
r_encap_pool() {
    ...
	pr_pool =3D xa_load(pr_pools, index);
	if (pr_pool)
		return pr_pool;
    ...
	err =3D xa_insert(pr_pools, index, pr_pool, GFP_KERNEL);
	if (err)
		goto cleanup_pr_pool;
    ...
}

Would the losing thread unconditionally propagate an -EBUSY error up instead
of retrying or recovering?

[Severity: Medium]
If mlx5_fs_get_pr_encap_pool() returns an error, does this code leak
pr_data->data?

Later in mlx5_cmd_hws_packet_reformat_dealloc(), the error path returns
immediately without freeing the data:

	if (!pkt_reformat->fs_hws_action.pr_data || IS_ERR(pr_pool)) {
		mlx5_core_err(ns->dev, "Failed release packet-reformat\n");
		return;
	}

Is a kfree(pr_data->data) missing in this error path prior to the return?

>  		break;
>  	case MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007143830.1733=
583-1-acassen@corp.free.fr?part=3D1
