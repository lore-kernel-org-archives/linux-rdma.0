Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C046648C8DC
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246504; cv=none; b=qOlJGMBdyVO7s57LXDlj4cwjtVkafU2M5xtQYP9+4qumn6MMARq8SmMwxdvnby0j7rhGQPDxc1GOWPJ944mJSgcllhSrsL6a2nQfdRPmA+mLA9FY3y7htrvgMpubuwfJCtJ3CWbrCRBagNSuqRhwSe+LZi6Gxxl9+M6SBtfpJtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246504; c=relaxed/simple;
	bh=fE3jEK7j/ZjKv8++XH2mXzAJi0MSOz2DiagXY8QKbv0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hk2LvV9lDfWZjN0GEnjKe9wLRP8be3YeJvr5KttIEPrIqh9CvyiTkQCWobBwCR8pg3qgsokVbBNZBCRUK+kZg/2D1bIi9sQTbTo0zjoUNIFVXz1PjMoP7eYOJLREGGfOzBqy/wQDQlYRmJSNXqu0KfRGARt5mhkNE1/AgCpPaEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMKmiPR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMKmiPR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88FD1F008A0;
	Thu, 24 Sep 2026 10:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246502;
	bh=fE3jEK7j/ZjKv8++XH2mXzAJi0MSOz2DiagXY8QKbv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aMKmiPR73OClqUo85FriKsLN9DX2InsLcVo7D1fzOZY76t/DumJQ1NliiuMFFL1BI
	 Rzh2x/6MHRDea7vfTWKr3UWjSorZanbbkKN7gzIbDeYtv20ZN8zE+C5n22J49qAbIJ
	 0fCXJoP7cLMhVncHd7P0VjFihLLeU4LnxUYGG/r089Dtbz6/lWosJrDracSkR6T2bb
	 lVkv8nlAfVocB1kkgKD/WKt1AazcJxCzu298sgmjXRyB1xTdtU+saG8Q9icF8HRH0Y
	 TTQzHnNj5Hz7b2DVmnm0CzR1bTat1V5B3yg53XeiwwOz2tDdQGwFTWVSFf/tl9Kd8p
	 w5TebER1eJyAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 03/13] net/mlx5: LAG, allocate v2p_map
 dynamically
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-4-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:41 +0000
Message-Id: <20260924104141.D88FD1F008A0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> v2p_map was a fixed array sized MLX5_MAX_PORTS *
> MLX5_LAG_MAX_HASH_BUCKETS embedded in struct mlx5_lag. Turn it into a
> pointer allocated in mlx5_lag_dev_alloc() once ldev->ports is known,
> sized by the actual port count, and free it in mlx5_ldev_free(). The
> ldev->ports / ldev->buckets initialization is moved up so the allocation
> can use it.
>=20
> The matching scratch buffer in mlx5_modify_lag() is converted from a
> MLX5_MAX_PORTS-sized stack array to a kcalloc() of the same extent, with
> the trailing teardown reworked through a goto so the buffer is freed on
> every path. The memcpy() that previously relied on sizeof() of the stack
> array now uses the explicit ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS
> span.
>=20
> No functional change; this removes v2p_map's dependency on
> MLX5_MAX_PORTS.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D3

