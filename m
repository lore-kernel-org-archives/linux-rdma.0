Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3BC45C6ED
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791296554; cv=none; b=ukTtNpO41Y7fqkCeNuqvFM6PVTd5xMFaKcIWG/6bM8CTH7yKPGUXi6eEXmg3W5n0ZmTOY+qjz4v4Dor7TOquiuwTyWvrMvzuzWAjq6SykZml5uidej/L1LL5cEHRQyPkHvdfvtQNFI4hUZisrHc1ZoHlFHO84sabJhSzUbEyAY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791296554; c=relaxed/simple;
	bh=aNFW1H5M/bR4BcJ+ichPu0xtAaMRPS8Lng0ocxzzX1w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cb6G6QK9MV/AnSW40OsWOWOx9IcftWMGh+7oY2xr0Aa96sGntlFjd+mMsw7msXtPpNQhLRI1h4L0OGKqg6J/HXdzN6qcnVHKiaO58Xt0mIK57G9vYbUvss93sT8PgtUpi/XQDdWJAZRdd3PMxz8us2IEUxmC0tLrI5N17Sl540A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjmYlEDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjmYlEDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B2E1F000FF;
	Tue,  6 Oct 2026 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791296552;
	bh=aNFW1H5M/bR4BcJ+ichPu0xtAaMRPS8Lng0ocxzzX1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jjmYlEDPwqeZKv6JWbKXOGcAfx0jGgCyLaaUJ5XqMJ0qgugOWN+pfRIoai2lBME5e
	 0wWnqYV5ZgjQT1ye5BI4j+xOEBbqlg89GAkUHYpp06SK+oHhQ/0ljoS72kbsMq9vs0
	 uxXgA2xlso3llrs9qhiGGN/Aisxkt075ONblAtdzvwaOZpsOX1rCZaIhATNYtiiFhM
	 IGKDQh7kY236mTAvI1dFIYAlsc40IVyijYOYf0VAovxcmZ3JdzIp9nmmT8XR6ZFWCK
	 BmNj6MXzCjGhtOKq23kaEskA5brHXvZohuCZXGX/3mShhIwIgFjJymkjtehXVunM7h
	 GCD70cnACvkIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net/mlx5: allocate DMA pool structs on the
 pool's NUMA node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Seongjun Hong" <hsj0512@snu.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
References: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 14:22:32 +0000
Message-Id: <20261006142232.A7B2E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> node hint, so they land on the node of whichever CPU happens to create
> or fill the pool, while the DMA pages they describe are allocated on
> the pool's node.
>=20
> The pool, page and bitmap are dereferenced on every block allocation
> and free. Allocate them on the pool's NUMA node as well, so that all
> of a pool's state lives on one node.
>=20
> These allocations happen on the control path, so the performance gain
> is expected to be small; the change is mainly for consistency.
>=20
> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006-net-mlx5-n=
uma-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr?part=3D1

