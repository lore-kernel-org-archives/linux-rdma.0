Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023715;
	b=bvPTpL1rZ6rm3wn0I4ohrJA5FKkqch7vDNqHEhYyzdWMY9+NYuaySfDnTRd3TYBO6VY2
	 6abhieNEGAjl/Fd4IVhSkPgsmpe/Jn5Qkm+x9B7mUesfuK6rxZrKTIQhHchcH8PY2mGN/
	 cYSag4QH5WX0mBg671rlwULFdx/j8qqao+KvU6EZ4OkvnVK2rCrWLKDjuQW9wxcaF3NVe
	 yo6Ot4bvmqNDAffCH+LNRImv2DyyhRXmIM3NhkuSwZyVzVbfBhkkLf04F3mA7bz6nhVpR
	 4FZa0u6USsI43VJ3xfoYGLBFBH50egg69D8zZsInEeURfrmb3wwShXcbkAjoZPyEkog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023715;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yB4Xw912P0bBMGtStIgoIbAnx5ri0lW/Q84RTKGYIVo=;
	b=ZPumYBB8hvoiQpM8CjDnifLWzCsKUrVStEhv5TH0GFIG77mXEikUR75TBRt2yy2jPysY
	 DRn9E/iRVkpnqj9zkEDTOYsitCy6vWXVfYhVBAUtmoqFV3Y9yxi8QB+eKOzhQPhwXyxnh
	 O80VwYxDcBj3yibzdUzHAXhXJBQv5VwHaLsEsXQFe3gCGKo0ad+U2C1x329AhUQw8JYXB
	 doHNmfEqIqLcLeJE/yskIiOAPCOnD398n+auITqIaiuQ2bT+ruo7tKBMy3s8tSVUsvsSc
	 Tz5ewsu0M7W7XFi6vzIofAQaaZAPhKMwDQvL43Sc7SBO8/NT27cBWWJK4FOKjB850AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZJU6xnhy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6384606A332
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZJU6xnhy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847D11F000C5;
	Wed, 18 Nov 2026 17:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795023715;
	bh=yB4Xw912P0bBMGtStIgoIbAnx5ri0lW/Q84RTKGYIVo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZJU6xnhyaXUlfc1TdWqCxbx9TI8Y7IZpUL5sfWvxIUdVrmiFM7loeyQwt0Em4//+n
	 joyCEeuohkKlKAUYjLR/WEwqRx6/t8ItpFDgt2rW7UGqBfBvSYvy+5IaA8O0GSLNSr
	 jS1ZWojVBA8beYWxwCrIbv1U8LSEvIBCSpMghpyPHsm397UgHfRhkQVGoQbfyma8eO
	 Dshf7fLJtqsxjMSMk1xLxZYxb17ZfUVqk9ddNapCokml1BNCzSlXeseUvvKjeZmqWP
	 z9iVOE/RMEgHIu3hy0L+KISKzifsO4Eau2Tw5ofsH810WGqsOK8Zca9mgGVf/67R7b
	 hj6eNiB2ZCQJA==
Message-ID: <sashiko-outbox-221677@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 2/2] net/mlx5: DR, Fix out-of-bounds write when
 sync to HW fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118173227.1957670-3-tariqt@nvidia.com>
References: <20261118173227.1957670-1-tariqt@nvidia.com>
 <20261118173227.1957670-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:41:55 +0000
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
> mlx5dr_icm_free_chunk() moves a freed chunk to the "hot" chunks array by
> writing it to hot_chunks_arr and, once the accumulated hot memory
> crosses a threshold, triggers a sync to HW that flushes the array.  The
> array is large enough to hold the chunks of a single accumulation cycle,
> and relies on the sync path to flush it.
>=20
> However, if sync to HW fails, hot chunks array is not cleared, and every
> subsequent mlx5dr_icm_free_chunk will write past the end of
> hot_chunks_arr, resulting in an out-of-bounds write and kernel heap
> corruption.
>=20
> A failed sync to HW also means it is no longer safe to recycle ICM: a
> chunk's memory may only be returned to the buddy allocator (and thus be
> [ ... ]
>=20
> Fixes: 4519fc45beeb ("net/mlx5: DR, Keep track of hot ICM chunks in an ar=
ray instead of list")
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118173227.1957=
670-1-tariqt@nvidia.com?part=3D2

