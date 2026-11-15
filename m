Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739677;
	b=j0pIhH6djRUPjfn/ze3m4OwfM05bMcoQRXruKJByhOxYhXEMM4OVxARZznQrtVpgc8KH
	 PtUq49N2j29BNupXpmY/e5r5FAZEQDdQhy6ix5SdayqEeSaoYnpBOExbXOtFwPxZFSRhG
	 9vFiSnW2ecJVtVNXq11I5Hj7MiDTkwIySmFE5sObUCV5jlDZkpzf50YV1Lh7VPsEct74b
	 RwH6ksnjooRk4u2FEloS4JnIsXFakntFy4wGUO7S5f/CoNHbw03gYD6CZ0O22qEMJazWJ
	 GD5SuCvyY0aC1QD8hguBjQWoLbpqjhXW7QDKL5aWZlf5NNMM3luJL2sMX1J0+dx1vTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739677;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZW4qJvGr/FjYlH534YDZcPG9JjKlCYHx5/kl/a+fcbU=;
	b=BSqJk4xsLh4MVDt7OYDEZU8WfSKKjPc0ZqOAAoaOPFHYnFdFwu47Jb7uPK0IuQoLai+S
	 gt5S0NGQ/Y64J3xKHW5n707IauMRBnRs9YEmEtW1RTv1GsgdfewrpeUMgNYyig1JYWDGi
	 g9GmnnRRlMarGHsxEQ17JZr9cgqLVXRLhoTNW4Sv8CoLcCiX561UygAWq8Hi6ZyOdvSWc
	 j/bR0cPJ0hPrtisb0I+qnZStYSn9oh3BrjUojIdgzeS4ByYWR/wa+Ggd0WofH7HbRKmyU
	 A+ddfOa2xXz4U3v7m2CyIa0s/KMd0zS9sBVChQuAaNE3zw2LbXccVrxIfGryf9125Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YpD39aPZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201C606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YpD39aPZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43B81F000C4;
	Sun, 15 Nov 2026 10:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794739677;
	bh=ZW4qJvGr/FjYlH534YDZcPG9JjKlCYHx5/kl/a+fcbU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YpD39aPZ4b7Cxv3FvkBCo7Ba1L3iocFgSczOO/f025bEE7wUsjHS71DV5Xb2TJeeg
	 g5iPIrI6OahVVpZQDIhz2O8OyYfu3GTGpVJj0KCfHwTDTIUQ7iNVKWoWHOXeLmLXTm
	 BW9rfCiH2mEsgpPiO7OUkG4jVRW+Xy1XEN3YSA6GWsH4Hx1q9DZpG/A+iOlAdeejCy
	 /JrYN1k/f1wRnc+5nUcMoKNvQWQBalT6Y1hzxd55liJRy5CFHfw5VDrGSOjHdisVZw
	 igIfEc12Ny0RAMr71wq7D6DTse6reZAfdjnZx0Ie8NcGe9kDtB9kZTxuE3F5pr4nKm
	 RWu0JJ8uTnkgw==
Message-ID: <sashiko-outbox-215409@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Check the DM type before mapping a MEMIC
 operation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115104342.56112-1-dennylin0707@gmail.com>
References: <20261115104342.56112-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 10:47:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> MLX5_IB_METHOD_DM_MAP_OP_ADDR accepts a handle to any DM object and
> converts it with to_memic() without checking the DM type. The handle can
> refer to a SW ICM object, which is a struct mlx5_ib_dm_icm and is
> smaller than struct mlx5_ib_dm_memic.
>=20
> The handler then uses the ops_xa_lock, ops and ref members, which are
> all located past the end of the mlx5_ib_dm_icm allocation, so it locks
> and modifies memory that belongs to other slab objects.
>=20
> Return -EOPNOTSUPP for DM objects that are not MEMIC, as
> MLX5_IB_METHOD_DM_QUERY already does.
>=20
> Fixes: cea85fa5dbc2 ("RDMA/mlx5: Add support in MEMIC operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115104342.5611=
2-1-dennylin0707@gmail.com?part=3D1

