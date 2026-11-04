Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812429;
	b=Kr3Xchwkj+RK1AtMNboGIOCfMpoI/i68N5x76I5zUeVScNhKNX5R7H3KEimLWLnhxqHn
	 qE9UlwmWLn1JJz20B8V2DpkU/c4NfIS3warj7Zgqo4D9/aiYd/tseCDO6EMlFq/OWDgI4
	 a0gQp3IPr88CALpto4E0sJuKo1tkONjoTsdPLmjfBOSpBKZp5Lc7npp5py6CjT9h0SHCZ
	 c0DyCegXbxcY0PqeoofRgxb4Ue39enC8Voek3dXTYkCvTPsv6p1nGgdWbFdXn7tsDqntM
	 hJJwaEbZKOUb+185DmDOTth0idpEILg7Vnwz9cTxafJtEi5DT4RavXe8mcVpFaDpsXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812429;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mipuDzM4KUNIN4URsMnmpMCr1w0Tw5lmlyuXqPPFQXg=;
	b=eaO/YOhqcSxBeWgD2B+3iZFLCN1npBfUdic4ScWwuHyY4TzCO5SmwytGbazpdL0GBZ0T
	 WiLdbUQ1IPc7bn8oGF6Q4DVTRWpEAlnAU44RkOFBETJinmE/p2/O8XFDDPqn7qcRnmD95
	 0dojUbXpAr01EeMw4OZppEMYIJSlBk0wHUZolwW0xJokhQJ8AkRQNsESQki2uRQFlyy44
	 cZZV0Hkj2lGx25rnggmP6s54g8c/736AY4XIKst6EowSy/Bh16t0K4Emq7V1eWNDx+SaC
	 Qjmn/k7UKKoA+uk28ui4fekMkVJJzxWqb9wB+L24cfu8ku865YrOZY4Vtu7yMVg1oUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMd81eoh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1D7606A330
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMd81eoh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6718C1F0093A;
	Wed,  4 Nov 2026 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812428;
	bh=mipuDzM4KUNIN4URsMnmpMCr1w0Tw5lmlyuXqPPFQXg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aMd81eohlykulVE0+JYxRgbTOhJaBlYirssE5fyhybLzv0W15u9SAsvPBOSBb2U8e
	 eFAPx1lzqfH53wto4OQuu9noryMrTpIKoPej/i+sL3HI3KUC9aaPawa1xBMTsYKu45
	 Wr0e8FddCn3TdjMH04+IheAlLaKZTYWv00BzKNJygnFJvvKjvwalL78B7YHp6jNNPL
	 CBCyhoLKZl1fkRVa2YqQCY5xd9uXb3T26dMo0iEImEiXuKAw+lSF1X4cW1hMLp9Zir
	 4vvQemUd1Ayf7HOaxOtViR9q0bP0TSIYyCv5n0xeVBXbw4voFSQnVaClyRAo1Sb1wa
	 3z/HNNOuypX8w==
Message-ID: <sashiko-outbox-197735@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 08/15] net/mlx5: LAG: replace fixed
 MLX5_MAX_PORTS arrays with dynamic allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-9-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> Converts two fixed-size arrays sized to MLX5_MAX_PORTS into
> dynamically allocated pointers:
>=20
> - lag_mpesw.pf_metadata in mpesw.c/mpesw.h, sized by ldev->max_fns
> - mdev array in mlx5_lag_query_cong_counters(), sized by ldev->ports
>=20
> The cong-counters array is sized by ldev->ports, which is fixed at ldev
> allocation, rather than by the LAG mode, so a mode change between the
> allocation and filling the array cannot overflow it. The query loop is
> bounded by the number of entries actually filled. A virt LAG is not
> aggregated and queries only the given device, as its members are not
> LAG ports.
>=20
> Thus, removes the hard dependency on MLX5_MAX_PORTS.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D8

