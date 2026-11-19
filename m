Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085856;
	b=1T1nx8/8ORgVS5Dx8rKio2u0FmTa1eXc2B04pzfdbYnar6dsSWyPS6HRtvyMC0+MHdGp
	 DlOGH2ycUWeK4vdXJ+MiDux3O42kCnbI7hLszvjFWADTwxbn2u+4e2zuExNeXlBLu/g0A
	 cpI0ShjUs6a+a8/oTDAvaCpi6aEhr4S/dAtcljAne6ig6f3WnyBcWe+vN0SdCKzUSYSEf
	 PjQE0DxH0I1ELEM1HfW5B6Gc8iuAGgHKCCdgDlYHw9N69dKvr9CrAIhP/9/yVEXW3M4Vl
	 SYaSMS4zLlpz0I+EKScpeVTOjwUliYfNekKhAeWjsyT2epJb+EbNz40LVG35+/ucJKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085856;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1VxTinBgi6+1nDcp5o1Il7egsG20CkF3pXrlH+TAq4o=;
	b=1IirK9rt6VE2SVdOOYW/+1q+0SDG+A8djM4BOV/v+qUr6sBaCv+AYntrBqdeykRFTgbm
	 lpiDwm/ghF9wTc6q5zuy8iswSWmjci2HJVbHMkm3hNKX0dfs9pQHLkd+4LRkvHZWETaF4
	 xo+QgwyTUZqIpU/OCp8ZxffCyX+JTUsJKVu21YZjCG8QUlDozbbaqCKbz4GE9fqUL7HwI
	 +m3NoJEaZZuzxiNtUMAXP8zLuYCQsiFsXzXfsPRaavclAme5Rrg4HWto+5GASKtzL2HAE
	 ElhU+92tUTvju9In1bx49YHOPQqRRdZnsLwZisBvM3DlEVgZGyNma08Jo1M2N510fDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vjr228QK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22423606A32A
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vjr228QK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C7C1F000C5;
	Thu, 19 Nov 2026 10:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795085856;
	bh=1VxTinBgi6+1nDcp5o1Il7egsG20CkF3pXrlH+TAq4o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vjr228QKflsNSRw8wuax+fKg/vcv4yNjJBVPT9rjE3V70WA5NP+EVYPyh/I7YNCti
	 FpPfCE3JNoXVR30CWR9feOZOIbXPNWe4agR71xvhwGivwD0PaoB7gwHySZ1ViSJ4ra
	 MI9CxYJ9Po4CdB2WbpYYq6F3K26D0CyQkFDqg9Lix1c0dQXxArCIiEUM+E3CHIJEPC
	 w3+1jicKcUq/3xvOglLdK4uf+inUi/jDDGvNtRMlsdD07yylOIiF6oDy1KiE50k8PN
	 b0JQBNPM+MBQJM0nw/Eb1dZn14oC0Y3zCN3FfMiYjS1qvSwSM9Rdvq7O6WdP8AWjS6
	 HhmGKwLw13S1w==
Message-ID: <sashiko-outbox-222995@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V3 2/2] net/mlx5e: Batch ICOSQ trigger RCU
 synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119103935.2190627-3-tariqt@nvidia.com>
References: <20261119103935.2190627-1-tariqt@nvidia.com>
 <20261119103935.2190627-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 10:57:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> During channel activation, mlx5e_activate_channels() triggers the ICOSQ
> once for every channel in order to kick NAPI. mlx5e_trigger_napi_icosq()
> sets MLX5E_SQ_STATE_LOCK_NEEDED and waits for an RCU grace period before
> serializing the trigger with ICOSQ users in NAPI context.
>=20
> Mark all channel ICOSQs as requiring locking first, wait for a single
> grace period, and then trigger all of them.
>=20
> Keep mlx5e_trigger_napi_icosq() with its existing synchronization
> semantics for standalone callers.
>=20
> 248 channels, rcu_normal=3D1, ip link set eth2 up:
> Before: 4.087s
> After:  1.080s (~3.8x faster)=20
>=20
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119103935.2190=
627-1-tariqt@nvidia.com?part=3D2

