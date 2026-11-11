Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404811;
	b=CfvlCYknRvV76q9YjDk3ixFmnQHpxaeH+lDHdu7Wzg8hFRSlZ30+RekisA1LesbNO3um
	 TkXzxjA2lbzvXRZIwpWc1AVUNoC8eYu6P9JjCr49mjZTaJzYXTl4+eIysUASjx+p00s7R
	 ED3B4dbRGBHPKX0C6emVHK/4FSxEwyFfrG2k0/JmvxJLQUt0jWBDwCrHWpmHYv0FzdV8D
	 lCGLGagF+r2LFbbtgFv59M8iyhfaeoJXnIF3jdj7vSAnvfJRKQYo5I3EvtTJBc3g4HJYa
	 1Vo9YuJ8FMsOBiDHaMX2Erk2LvKGdeeBMyz//iaWHprNz1t3VRKfHjyII5cXFGSwzVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404811;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w7mmio8xc9ECJ+104liExouBSZr6tdPzi1vc/hFRXD4=;
	b=ocIssr7aFUMwQTqSpiD0ow/j4RZddAO20LChssN+KZNcUy0JoYf59dfHQEeObi54iUe+
	 H5wwOb+NXzjdbPvKc09Eg6gkLU6zDdyclD0DnyzV8fBzr5b9Y6DsTTVLFF/C34iUSCEE4
	 EV4RXsU1uvpYWGihnJdic2UhUXNwdZy59xhCT9rUnYjt+b7HR2dRM2Mb+pz1qMunKS+6A
	 Hipg9xPau9ioR0pIeNvgewG81YxlioMjY7Av8M1L9+/83ZGQNmIf3P1mmSJJpYIv6ATHE
	 TP/i/XjnxDwxggq5jQvvrA6qI/u/UInmDY8jqoGvtodWPE33uL3W+TorSkqFV/7ArCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T32XpjCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909F8606A332
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T32XpjCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF021F00A06;
	Wed, 11 Nov 2026 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404811;
	bh=w7mmio8xc9ECJ+104liExouBSZr6tdPzi1vc/hFRXD4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T32XpjCyQJIymcikUae2XosBlB2P2yQRQeWmQX1g07HgSDDSfTzaDs7MUgaSEfwVq
	 6C/0c0Ys5diPrZ9+/YaeCGKpxmVUB8EoqqGcpbOfecU2ac0MCTayaM1xn9d31c+qtk
	 0Xo9vPqJhcHWR5o4BWKDil71+3cY7K+iJEb91mbyxiZB+ImOjt/xGiH7ue5KtD3Jb6
	 E9QjMkkpo7whxerGigzuqB2y32k24ZWrSMAhtA1n8WDHlBKFCsTmWVxtYs6CKUYpO1
	 gqTO1iPBJ0eHQ5yD5i1eKnMcfZUotijfqg7wC1yarnyf4mjK9ZQBrAY9OcpsLLnqYV
	 G1HzKqLRCgqeQ==
Message-ID: <sashiko-outbox-209096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 11/24] RDMA/mlx5: Introduce per-CQ poll_one
 hook in mlx5_ib_cq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-12-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-12-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a poll_one function pointer to struct mlx5_ib_cq and initialize it
> to mlx5_poll_one in both mlx5_ib_create_cq() (kernel-ULP CQs) and
> mlx5_ib_create_user_cq() (uverbs CQs, the path used by both the
> modern ioctl-based and legacy write-based CQ creation commands).
> mlx5_ib_poll_cq() is updated to dispatch through the pointer instead
> of calling mlx5_poll_one() directly.
>=20
> This is a pure refactor with no behaviour change. The indirection
> allows a specialised poll_one implementation to be installed on a
> specific CQ, which a follow-up patch uses to verify the UMR CQ against
> a hostile NIC.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D11

