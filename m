Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876C51C04F
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755158; cv=none; b=WVyia62cE/E8Kn6Qorc2ra8lUcHnwBqe445ywyxl6eZ8ODHP/Kb4tVFKCeiNLlw0M0edzdBVS+KmRKO8xRk53pyPg1oqq+xWCE0A745paCV5Y01j7odXQamO2lBC0h+Ut4KUVKDIKYN32Q20ur/FIl9fphbcSFQ+lh6gEYcQFsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755158; c=relaxed/simple;
	bh=6QJNKs2BeaX5nkG5Dj4OiG282bPlme3ZmCZD11jcg18=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oXAI0nmJpsppBBwROMpgy9TKG3LgWa+TnXhuTnFRgpPMBWkVCgb4CYABqAdoDsOCxYbeRMWym/Bjly/dxvOfmajjPQRMbDx/21ELMx3j9YBcDEKJN7rJPk2p439a1oM6QLdvYULjNPgtG86/ib3F5pgrFXmyXpkjJ/6pOLnN2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4nGiarq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4nGiarq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090841F0089B;
	Fri, 18 Sep 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755157;
	bh=6QJNKs2BeaX5nkG5Dj4OiG282bPlme3ZmCZD11jcg18=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q4nGiarqJCf8Q01evnPhPfuX400Mi6Y2o8OalqCj+a4vpSNTPqfx3gsHBhARB4LiP
	 wDOJzEn+GJ3c3hZe6MyeCOjDLYsqUZP7Uwc36mn1sc1jKyE/J5Nqmjk7CS49h0Octf
	 4OHIGZI3o3n6pQBP36q7OZDjferksJH0y0DsGCG2glQW1GnaHD529lAVonXNfDfQjj
	 HNPUDw0IeVEdi/WS1FVYO5U+Tkocd1oR4yKb120ofRW996Lb3bnamX/A0CoD+BU6kS
	 kNSyAh8DRtd5EWeegW7frMVfW6Pn+bWflWug7t4quS2W/YqE5o6ibKdrnuUWa3XNZ9
	 WilclAfVnlurw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 6/7] net/mlx5e: Serialize TC and IPsec offload
 exclusion counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-7-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:36 +0000
Message-Id: <20260918181237.090841F0089B@smtp.kernel.org>
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
> device lifetime and add warnings for unbalanced releases. Remove the
> now-unused mlx5_esw_lock() helper.
>=20
> Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually excl=
usive on a netdev")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D6

