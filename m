Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795816690;
	b=wbNU9FmrrS/easmiIwKLeFwjJL4SzL4gxtb/jhnAiwSnh5GD0P5z8eUsVKkKGMvgIGtR
	 GQL+42aFeihiTwnR4awlUxaxmfXKJtsbUvxy+gwlYUYcLJ4PIX93ZCCaPnUpDrzE1e2L5
	 DINkI1hJEDHs0plwQpuFLj39zGCfx2RUqcU1DIT+SAN9E84hYorE577L8UuFx3zt9M243
	 fsatMb0PEV+d0ays79pm/BLUG6BLiXTfxXaJjK6M4Z78m7C71WqNLr/T+xSQE8NwexyTj
	 Pxg3zaulH05up9kzofrVJptXOq9u6pdm349JSEV7s1/LPrDhroaEabgVuSO7VqK6cjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795816690;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f+3w8nAYy0wfqGEeSlI8U43Ygr7DxwuMGDFST6VOkO4=;
	b=SqHxrb142TbTnDQ+aDEflwSBFs5J+wBL3cTy+hWIAiNoZopUG2cPlskEMiEOVTOa/ve0
	 kHUTY8Z8Fa+JDI3m3jAHKqQ8SIsujGEZv5YAw7HgQlMqHok8oGQ9Crs6SqpqvVof+AfN5
	 rDJEcYSbtlV3wc80CoXeWJ3zxzfMgeiM5ga+15ZQFPXvoHPSlGjJgnyvk4GeSAm/NphfZ
	 yfuS8+UrMud5nnaTNhFM8f8xKSLoi/9PmZ6eGDzO0CfIlsbAPbqi0rkJBQvwP7r1/TbG6
	 OB4u26IeLCBqR5plnQUGC6GXAf1nm0UNYbcST8TE0P0xinXAAaRmAIhP9ze9vMGd3TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8LQMPc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992CC606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 21:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8LQMPc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A4D1F000C1;
	Fri, 27 Nov 2026 21:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795816689;
	bh=f+3w8nAYy0wfqGEeSlI8U43Ygr7DxwuMGDFST6VOkO4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K8LQMPc7O4kQB7y1dFY0XEh8KyB+yHKLMzXThvcm4ncEsT95PRl0o5zU3uCqT3dkB
	 jaNlbisL+g9MkmOvzDEeV2Uq4Er3g5bElYM48EBwLJZ/yFEsfTIhpdYRTjxO5jiIga
	 gAlCMOLDZ8hKcSow+D15W8pplND1TXu6asuqSgO756qgyW3/FunHNhsISERZ4xxpSA
	 T1EyAtE+5PEad1mnNBL+k/oswGOhujZb0w96fQjKM6uBcAg3yN6TRSNhGLFnwR0F/k
	 6jJzNa1H+c6u1yiRcnncVq8fg9IL+LSvSMtFu3HeVrJGFT/3WTyh2tlKcul7lDbqmv
	 daSTEy/LW17Lw==
Message-ID: <sashiko-outbox-238308@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 05/10] net/mlx5e: Drop IPsec tunnel traffic if the
 neigh cannot be created
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126215614.792598-6-tariqt@nvidia.com>
References: <20261126215614.792598-1-tariqt@nvidia.com>
 <20261126215614.792598-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 21:58:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] net/mlx5e: use of IPv4 ARP table for IPv6 in
  mlx5e_ipsec_init_macs() [1]
--

commit 219ed936793954d216c649a4142781d59b610e93
Author: Jianbo Liu <jianbol@nvidia.com>

net/mlx5e: Drop IPsec tunnel traffic if the neigh cannot be created

This commit sets attrs->drop =3D true before checking whether
ipv4_neigh_create() failed in mlx5e_ipsec_init_macs(), so IPsec tunnel
packets are dropped instead of transmitted with a zero destination MAC when
neighbour creation fails.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index ea7a1ae2056fa..4daad648460fe 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -368,10 +368,10 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipse=
c_sa_entry *sa_entry,
>  	n =3D ipv4_neigh_lookup(netdev, pkey);
>  	if (!n) {
>  		n =3D ipv4_neigh_create(netdev, pkey);
> +		attrs->drop =3D true;
>  		if (IS_ERR(n))
>  			return;
>  		neigh_event_send(n, NULL);
> -		attrs->drop =3D true;
>  	} else {
>  		neigh_ha_snapshot(addr, n, netdev);
>  		ether_addr_copy(dst, addr);

[Severity: High]
This problem wasn't introduced by this patch, but does this fallback path
query and populate the IPv4 ARP table even for AF_INET6 SAs [1]?

When addrs->family is AF_INET6, pkey points to a 16-byte IPv6 address
(&addrs->saddr.a6 or &addrs->daddr.a6), and if ip6_dst_lookup() or
dst_neigh_lookup() fails, jumping to neigh: passes pkey to
ipv4_neigh_lookup() and ipv4_neigh_create().  That treats the first 4 bytes
of the IPv6 address as an IPv4 neighbour key in arp_tbl instead of resolving
the IPv6 neighbour.

[1] https://sashiko.dev/#/bug/linux-38e0271d-7232-4b1a-b4a7-ed3c33c14790

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126215614.7925=
98-1-tariqt@nvidia.com?part=3D5
