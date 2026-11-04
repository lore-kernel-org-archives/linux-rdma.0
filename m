Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810626;
	b=ttEqf1B09QmXPISfsj7NKM0HFr/BLleguV1oKULkFhEvzSi0ZwSeyURY2f4vfgbp+K7f
	 81V9t7HMCToexmMcjS14JP5IfCAV8FVguukGckqSeM/79Riof+hap+0UCNrCMSI+LIwCi
	 ZGNzUfSfSOibSScO6+FVy2mfRcQCozb8SP4ll6vGfoMh4I2DTiSu/zv0rw0VgpzRWjiWr
	 R79p4IPH9gjhwIY3G9PXvKN/0WeBFqM4UF6Vq6qGHh5gWri59PcpQ8w0hpErT6SPV3O1Q
	 kVk7mhcXHC+NQmE12Zv+LplTqW0i94e1MdReePuPdR9HHvenVCjpVS4gAvaV1S6sOQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810626;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cvYMqIAB57m9d0fOlVNVJ6tpmcwpzc5MO25bR6Gfjqw=;
	b=R7LSaZuUGYMvhxIxLCE/1h+LSijFE90h/tvgsztdY71l4haTGhEE03+tuA9aOadMIrmS
	 hrNFsjxWGXZ7Za83ffMWwgGGGZ/L2cER7ewHrtG0Fv6tR+21TIVGVB1uSMcmEk4wZyu4h
	 gKIHZP6+ErmNAux3zjmhkYdWbjQiIFmmvF3VqhgcOTzDt0BN67Qqq3vLS+rcNDSBpFdr4
	 WlPnsztN3lAzXHWeJrKvF4+B2my0g0ZLJhiwbYB412mmC9vnsS0ITmSEzqRNQwUdzdEFn
	 jUIxnNIch1mEjA04jMgg+T86lAUN7+F+dBGZxk02sWs+3aQn2ctBSVXe9JDyzEhQNGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KrosAr/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A3606A32F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KrosAr/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3202B1F0093A;
	Wed,  4 Nov 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810626;
	bh=cvYMqIAB57m9d0fOlVNVJ6tpmcwpzc5MO25bR6Gfjqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KrosAr/pZFArjs2jTzDEYvWtuGMwvaGpc6SqNHpmGdzxMQz4o0el1UQm84D4UEDH8
	 70cxaUt0Aw8Dy3utegdyslcJuXOiuBnXGNBZyOA9iYl2iL9rIHNf9m/TveRCWevaO5
	 FunWVzY5fw3+Lq2p6mBKuu5zx993EYpTTLT8OCAI0RTralxRrJL8DfwSofwx7KJWVH
	 4Cha7QoZOMh7I9IoK/n8l7c4DNqoe2FVT7Y9Initz7bV+9Vb9Anq6MA9GD/LVaASnF
	 Pokr1UdzdKpvU9a0+O6Jk92KRTahmv+0Ue/FFsWcOcSPFEhdchnPnsJG9fZ4gTZR9S
	 L7ePz1lebes1A==
Message-ID: <sashiko-outbox-197662@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 09/23] RDMA/mlx5: Remove duplicate
 mlx5_ib_umr_context struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-10-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-10-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5_ib_umr_context in mlx5_ib.h and mlx5r_umr_context in umr.h have
> identical layouts: an ib_cqe, a status, and a completion.  The done
> callback used mlx5_ib_umr_context via container_of, while every other
> site in umr.c used mlx5r_umr_context.
>=20
> Remove the duplicate and use mlx5r_umr_context consistently throughout.
> No behaviour change.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D9

