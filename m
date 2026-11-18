Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972959;
	b=4UTbxa51GEghCFF8JLwTCYv2doRXKxq8lWQBsZuUnJaKcR1akRAOYRuf59Z4cq7h9R4K
	 Ov2D+gZ1eBJ3o3Mn+WId41hLIo+CPV9t2CGLojDKKjp8WM49J4GAuxfC8RllYYZD/6v7U
	 Z4Rs4mClDrHO5A9lT8lsWwtX7VwWI7gSABvC182wb1k7FdV2gWswO4/6fFQHy6IomTD4E
	 zTPxnLj/YLtrvqzk2tNvYQ/HcYp0T87BbKw1FfOgS1mk8RgmsJ25ktNh3kOBbrPBRaxdc
	 4s55u/lY29nqtPcwieGAxmQ2LXuwS2u2N08bizSfR2cEPWEIiZiEqBgsRnvqJgcFHgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972959;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UAxASRzOdwQTHYjF2XATYjq4KSVTD+0pSnO5gfy9mgA=;
	b=c1hVzRLaWJtQ0y4HIoODHE7FjAnbJ1PEvIGNJ8JRY3FpMRzDsL/3oSMbUdWZ4000a40l
	 5UF7PNQBA1bCXLl6m2xxMgeB/HcFO8RkL8a4SCu2q93HLnCXr+cselTBj7v97QWASumGy
	 iU/ALsu7WL9E9ub72LIkz8HtPvNeykqKZ2a2olmpZxg9I/xLSdgna/r3WnxnKEwhjMXGK
	 qmD2xYCreoRtDSRV1oaCMIw4qUmZpWYb5RpljTaJWdxQtXsVBkrd0XQzZkOcqRObeQH8Z
	 7gIxFgrKT3FWRPuRJDHctPKD2Sa6V1nZzeiUx/4bcomMU6u73K0Y3xFIhKhOftbKuNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="g56Kt/vI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DFF606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 03:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g56Kt/vI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D32B1F000C4;
	Wed, 18 Nov 2026 03:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794972959;
	bh=UAxASRzOdwQTHYjF2XATYjq4KSVTD+0pSnO5gfy9mgA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g56Kt/vILW02v7JaGWlseICiGVFf/hqChQAubAyGvjfK8odtxuWIjhG30MPZgig/E
	 Pk6eD9w93NGfPj5St5EB/g/ws/VG3vBfeoodK/iMaUqZCa25IBl/ZlEhk08IEoAVHz
	 J74XQOTZmbP+V+WiZJuJsHMa96fuGEOu9y3/fENu+y0J5WMYLMUe+3m3Y/k4KJdL1z
	 vChav7ZXrBORQLbfF5NdlnNVlKw3TXg+1ziUWi3yCvcND0TetNDZC3cCH2HQYaepxw
	 mAh3Rp3JElsfZUjRk5LOYEPpt1kXJYN+5XAjSFq4T3+2/JqTXbPa4FdlFXgnavET5N
	 nEYxnFLJSrbKA==
Message-ID: <sashiko-outbox-220023@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP
 and CQ tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118032858.92963-1-chengyou@linux.alibaba.com>
References: <20261118032858.92963-1-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 03:35:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> [ Upstream commit 00baeade709fb66da647e8327e8398bb532e30f7 ]
>=20
> Locked QP and CQ lookups from EQ interrupts can deadlock with
> create-path XArray updates. If an interrupt arrives while the create
> path holds the plain xa_lock, the lookup spins forever trying to
> acquire the same lock.
>=20
> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths. Initialize both arrays with
> XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.
>=20
> [ The GSI QP create path is not present in 6.1.y, so omit that hunk. ]
>=20
> Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ e=
vents")
> Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM proces=
sing")
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> Link: https://patch.msgid.link/20260828030344.88021-1-chengyou@linux.alib=
aba.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118032858.9296=
3-1-chengyou@linux.alibaba.com?part=3D1

