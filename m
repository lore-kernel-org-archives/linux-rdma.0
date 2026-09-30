Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F54749C9
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 12:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771152; cv=none; b=anfFm241TA8KgnJYm+yhmGGcfQwBNqmdIHJX+HxLEq2W+jNadOSlubSs+MnBpBtKXExXKAbVkuBlEtEYBzP8pjpdnDEhAT9Z9O4sj1PAywhw6+GZ0Q/bWD4xzBRDC542ejkzBB1wpdqRQimNI14iEqHjCEFm1Kb+yC6nwnnQH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771152; c=relaxed/simple;
	bh=iOLR8/I2YGjnFUY2tvknBbiehfqpPJ29cnycTcH7WDs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gxW3onRHQPwTijiZLHiiCdE3mVGiA74ipVJXWwkzy2gn2HfwttH/PP0HFdCxgS7TBFESqHd2JLMbqPpXFCbEoNOko37jfzqPHlf0hVgfJ08uM5TfZztyz4bJLX1ntvYm7bacjnS//Hvezgs4yhVlvpOCxHPSZfcu8j12OTEh/Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InONWIuP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InONWIuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA3D1F00893;
	Wed, 30 Sep 2026 12:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771151;
	bh=iOLR8/I2YGjnFUY2tvknBbiehfqpPJ29cnycTcH7WDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=InONWIuP/ZPFdcEqiiN5QCK/NY/OhZw24dylTe9Vp8RvfrKAU2bFX6DGVcTBisbGA
	 wVnAzAniaUap7DjV24MdjCfFFOzbEEKzTV7gE4+b9zDDw24zHYu8GWgv35RTYpgLUe
	 ATUXMa621HUNDF9xUoi4tRT0KUoK+H5mBE4SnyIp9XAoSmhUQkngzTeXvGNzqWOhOz
	 tZ7jV7qmTWYC86L7uEOKqRryyIip1D2sdP4Q3LvEy0D42jIT7G6ENXjE2/kD/Hr47F
	 xEiZ56VCvYF+nSLQr4sNW/KN5LCwh/fXl9VoTFjPfJfMQwE4Mpj12u2o7dQXZ1/6+j
	 POjyxairXTf7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 3/4] net/mlx5e: Serialize TC and IPsec offload
 exclusion counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930121119.141953-4-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
 <20260930121119.141953-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 12:25:50 +0000
Message-Id: <20260930122551.1EA3D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> The counters enforcing TC and IPsec packet offload mutual exclusion are
> not consistently serialized. The IPsec add path conditionally takes the
> eswitch write lock, but neither release path takes it. The TC add path
> only holds the eswitch read lock, and devices without an eswitch cannot
> rely on that lock at all.
>=20
> Concurrent read-modify-write operations on the same counter can lose an
> update. A stale nonzero count can keep rejecting offload requests after
> the last user has gone, while an undercount can allow conflicting
> offloads to coexist.
>=20
> Move the counters into mdev->offload_block and protect all checks,
> increments and decrements with a dedicated mutex. Keep the
> opposing-counter check and reservation in the same critical section,
> independent of eswitch availability. Initialize the lock for the core
> device lifetime and add warnings for unbalanced releases.
>=20
> Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually excl=
usive on a netdev")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930121119.1419=
53-1-tariqt@nvidia.com?part=3D3

