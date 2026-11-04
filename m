Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812428;
	b=KcHXYcEWjpqeiGuAeJ3uUJEulLbRsdPNAh/xl2fzUYscf8ZTLDuh8DNpQWWKJ3QUmuqC
	 GLGcDtVv5tsuowVgE/xIhU3ciZxgE7Gas+BO7VQB0cn1X87mDjNjzjd7XLvR/sQNh8ijv
	 u3cDD2kqtm5DCSHkdt04SL/5sBBe1Vc7Frg+Bz4Uzw450UNGfGZ3nEon66eX5XK9M75f8
	 C6TJxMvGs5wi9wCoiJqXzc9G0I7rxiJ8ZKZvZtHxNzfLE47BYYEe41Qi9VQHcrxpmVE15
	 X20NeEEQzTkhN5yrqa+es1XGmhlmPlYfOCt4A1pK8r5NRn+qGvadpsSBbsYlu3oXlUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812428;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Uoyouex4APwSdShWubmWhdt/pSb8nY9JyYlQXnG2Qpg=;
	b=Vs4DRys+Whe0RhudrJaD1x7TVW9if91ItzSpRCd/Yn0i9sdTKL6Dp3Ju1seqNtTkauXD
	 BLmC8NNdDv9dUyQ2Qq9cx/uDaNAfFff8x4NeYuYTfGiICj9/UR9awYuZWLAmWs5bFRULS
	 ccvPWnkc71vEFrZ/C7Lw4UsFaFce1MNhU3WYwMFNIYH3F5ua0cszx2pusVwBtq5kt4j3P
	 K5wj6DE3+HFlrVV7xgDz/IsMouVw5wobtTqnROLEyFO6rfU1J2pRWB4Hq0TMJio0yd8Tv
	 kRR4ERR8Iz3579u9PAqUPvxP5H2RMOxumR2tcLFRhcEh/hqXLTlx5l9yXO1gOy6Lt1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKwoDYbg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B272606A32C
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKwoDYbg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2AF1F000C1;
	Wed,  4 Nov 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812427;
	bh=Uoyouex4APwSdShWubmWhdt/pSb8nY9JyYlQXnG2Qpg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eKwoDYbgVMqqa/9ZQHil1UOPUiq3r8/IcAFOPOqBVXAd0V0BzPipBTseZXUNdTgAV
	 YI5Gb0M8+0giEowd4KKDO5q7HIbJZGyipw9j7jjfk2fmGn82ebasFzuYwuo7Y+b5BS
	 zTMg5OFFpx1XcszZKxtKrKOT7bpmQASpq00X/ysUl6HuilcZsVY5WWPluD0tGMrnZ9
	 3QjEPMGqTnxqIS2E/m7oPHgvpDqfQBrRtp1ViFzhBfVATczNN8zNrH7I241kk016DV
	 kGC0wVApBl9seGEU1Nug8Z3KvSkq5rGQh/m9l56K84Mhat+gCqhCarQ3VEhuHbIq6N
	 n1mW1tmLvoxcg==
Message-ID: <sashiko-outbox-197734@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 07/15] net/mlx5: LAG, resolve affinity indices
 only in queue-affinity mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-8-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:47 +0000
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
> mlx5_cmd_create_lag() resolved the first two members up front via
> mlx5_lag_get_dev_index_by_seq() and returned -EINVAL if either failed,
> but only the queue-affinity mode uses them.
>=20
> Move the lookup into that case.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D7

