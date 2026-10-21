Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792565394;
	b=VXbsS2v9GaunCE9G1vmYcCE6LntMdCDyW5m/gMttQTw4rNZynr+Er7tXmonaVVdK0gvJ
	 AgbSLziYvhdZAzEFRv8fscpv1G6FVvK8+UhRLWt6qCec311uh+CmUeQwVd56cNB/+vAEU
	 AGrG/dnT/x2velnfSqj7u5LAG7ux+P5ysj+rdEhjGDVYuQ0rrefHhHwQJCSwVRpR0y5uh
	 u93qGSIsUQ4VMSi1LCbqDx+c3vXO/rl2NZdhiH8FRNgtFS6mgmmtVI2IEiPCgEHm/ScIr
	 1fvyF4fICAiWrx8gvsLArk7CNsurR2lRJ8xV8QY/JpT3gBCxv8exx/D8HbzjB7B4PzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565394;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u1WDXbx8ROP1FfabNqtu7eFXj6xaWKzsn5Ip6aTQ34E=;
	b=b/0G1r6mXwCl5TyBPoyNVAnUz4oBnRx5ImByEp1oeZ9uz4l1XkGAOva2vDLznWxuhVMr
	 4ByMbYEDWW40Sw9UOJ9OKMyOIF5BA/xkUGIGK2Ug0lmmjcB+ARXV2RDYRhUlSLTsTphp3
	 ofdsiiH0Pac0DXTWjHZXrYOF7HGj+sVgwNhYDmwfg+g/PEJv5q4vxhb8cDpeC68C3+BLn
	 kZg4LNdEh4+/Xu93p7V2nO5Ec9eGCKFSCuHDR94p9giqmbGkpnI+3YYhWL8hKMSLZ/+45
	 Q1e/Pe32nJS3tu+9xspk1uzaFiGjZGFdibobf4n98H0BWePXMgFjvBYn3tgYJvRBcQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dXRirMWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A9606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 06:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dXRirMWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9119D1F000CD;
	Wed, 21 Oct 2026 06:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792565393;
	bh=u1WDXbx8ROP1FfabNqtu7eFXj6xaWKzsn5Ip6aTQ34E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dXRirMWZJzHbeugXz0ki6RKqmn4c7nyF+9xIBZWEA3M99C2GgkmvEwQRsUwSOkRR5
	 Ccl7pr4aMYJlKZqa8W3BZppUpZT4vzUEWb4l6DFKGEgUd2EwDwPFgLUt03I1XKHif0
	 y4EJWvAGzx3bs1coO5iPJTaf+kHu3uQa775O9SmS0R8MPfxGQM2McIgydIP2Ank5du
	 T7DL5xS5BcKEpSKpNVwReoP1mcElS+Dca2cJomJydc1nMYQDURr5jk1oMtvjfXzSnp
	 m2KIpjOLGWJHyGzSbI0rX3BzMeWxKGrBXafFQDzNuCQ5z0J9q1mmFDlxJQpX03hX40
	 fPMVWoukbRJXA==
Message-ID: <sashiko-outbox-179845@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: IPsec, Fix out-of-bounds comparison of
 neighbour keys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021064231.3466989-1-tariqt@nvidia.com>
References: <20261021064231.3466989-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 06:49:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Gal Pressman <gal@nvidia.com>
>=20
> mlx5e_ipsec_netevent_event() keeps the L2 headers of offloaded tunnel
> mode SAs up to date: on every neighbour change it looks for SAs whose
> endpoint matches the neighbour's address. The compare width, 4 bytes for
> IPv4 or 16 for IPv6, is chosen from the SA's address family, with no
> check that the neighbour is of the same family.
>=20
> An ARP entry only stores a 4-byte key, so with an IPv6 tunnel mode SA
> offloaded, any IPv4 neighbour update in the system is compared as if it
> were a 16-byte IPv6 address, reading past the end of the object:
>=20
>   BUG: KASAN: slab-out-of-bounds in mlx5e_ipsec_netevent_event+0x736/0x8d=
0 [mlx5_core]
>   Read of size 4 at addr ff110001260a4ad8 by task swapper/8/0
>   Call Trace:
> [ ... ]
> Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 =
headers in tunnel mode")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Yael Chemla <ychemla@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021064231.3466=
989-1-tariqt@nvidia.com?part=3D1

