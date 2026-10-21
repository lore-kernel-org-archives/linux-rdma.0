Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792569630;
	b=09UbTyLRU9/g5OhIMnKT2ClE97TiNysl9zxKnXs4IiRBlZYXRAHLLhh91Bm6MBEIvdDj
	 9rEgeX2l9GWEk3Bj264M2pYLRPb2nA75w+Q2XqsDb1ZCUXrmOjms+kzZk11UwZ86XEaL1
	 XutLx9QtFk99v2y3Qb4yCQT9TVO1VHH71zvStICI5hA44zNC4nczxiqGlK3ZZlxIq4XBv
	 kwd5FVnAjsJexy0F3HlTEEJLfIZ3uDXeJts8cF/GA/axhRf51Eh/eSuf+VLq440Xzb+OU
	 Z6uvCsaNHAcn89NnQibedoPSbVgp0Mwt050HM7SOHYeojNHFM8yh1WPFb6HY+4/WWIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569630;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/lhDirCRkNI9zoR1QCeZVc8cmTXSAGhJw5MGyaE0M/o=;
	b=kwu9EfoQGnMfwBVEAP2ZmErxLg0KHbxnwi/XlWR3cbwdl7Se1zZl4mjJYh/3WjmAXiJD
	 bnRYl3q0k8YpcandfbiqFOxeXpck4D4WDsv7gVCTnwaUehTTcWbXm3EirkX/RPJfzEET7
	 wa/gTapx6pcMR7Bj1rti4MFXTO1XR90VxxVjjmkFtD18+T7R10fH5yU5HEYdkMerTU44w
	 OSlTmB/Z627LKT38gayFKXgYdZx+gIdhn6atuiexId4OwphnvXGwsq2bwzk5DU3empPZ+
	 eqmnl0wQSvFcn+xfgOWVdlUdIKWFRpQvOzvr0zF9KZpOdbUEZfpiB0HL4yEeK6tjtRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZR2mdRWR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFA3606A31B
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 08:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZR2mdRWR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C821F000C9;
	Wed, 21 Oct 2026 08:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792569629;
	bh=/lhDirCRkNI9zoR1QCeZVc8cmTXSAGhJw5MGyaE0M/o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZR2mdRWR+c1FdhpZgWWwCucDYZRdneLw9+15Cw37PyE5c1XhxHoyplyAjkD6FE8N0
	 m96SyOkdH4iTpS/Er2f91X/yaoabG2ihrc3/5jEOimKOhEVH+dVFUDWGZ2IlwXIPw+
	 wDDfrlbuqOGii/o6qUo/71d4OaEomEJuWDP9XCSpn4gG7WJsNQ4XAnq4Wy39L6jBfp
	 yAK2oqy5cz4yg4evZBePTubdj+pGmIulB9RXEAKrgoPKPJT+5sFurOvpZWfD+QUCuM
	 nNN1ohLpvg08L7sArFCdfYdmSNpgHjNjkI/NCqNhiAwPbs8/JaQIla/5pk4kptt9dS
	 hGqbM9nRL1oYg==
Message-ID: <sashiko-outbox-179933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/3] net/mlx5: HWS, Handle NULL in vport destination
 action creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021074949.3471704-2-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
 <20261021074949.3471704-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 08:00:28 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> mlx5hws_action_create_dest_vport can return NULL - handle
> this case before trying to insert NULL into xarray.
>=20
> Fixes: 8e2e08a6d1e0 ("net/mlx5: fs, add support for dest vport HWS action=
")
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Alex Vesker <valex@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021074949.3471=
704-1-tariqt@nvidia.com?part=3D1

