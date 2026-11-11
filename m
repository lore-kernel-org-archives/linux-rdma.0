Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422435;
	b=xk5FS+I1w8Yn4IIZL2SDPbl1nqdwB7dREsrui2a/timk4OAZVxfLVriIsbYsTg7P1Ag7
	 0om4UcEVPH9FqoCHWI4MDbbY9KvXGtIIhVHt2jxNtvYgDr9COy9c8BLEL1G/RFTmMT/Dg
	 G5Qg5CnCeWKiHCt66rFo5dPo1ZS6y7t+Fa0YyjIkTrvvMGuc6eJ8YXkIvw7NG2Z0IhpDE
	 vnGFotQysxXxa08bUJUOJTLyYPx8SIwr6qdqn8wExGTp8cB+mI1ACaaKvq83f0DtBVb9N
	 +FjxxofastJ1f53HSc65lVKKcU9wfGxfIcPpAzFZdotczOqAG5NU3+7jHgWF+Nn/gGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422435;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CcEv4k6EYczNZFSIEQ5Yg+KH/TDQEhsuCJIQZHT/paw=;
	b=lyV2rXtMFyv/ILWFMwfiecYZyyDu8sxJBC+Lk+8hkOeTTTNTf/3tLYQvsrPeYOfFNWWq
	 Kb4U2UgAl89Kg69XaZkKq3vGGLDxpMcsywxoMgYQ5Gu9J22UqMPG0gFjT4kkKB6km2Fts
	 7LyHwcQXC1MfZOx29M5Gi87NKDoKwXjgKoHd8CBv43oKzs3pqn7N/oxUu64aGTgjG6ATT
	 Oka2Jsyhz9MxX8kM78vRusuBPN0G4QBjGY7HdRa0vliF+rc56zUTB3/YQ4zwpQIFu/KHe
	 eKUoXSa1p5Cgb2B+B0l2pjIzKCShBqc5v2767fpXqIXLBGR/kLdPgUUzq9KvYLm3odQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bmxo8W7U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA553606A335
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bmxo8W7U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F69B1F00A05;
	Wed, 11 Nov 2026 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422435;
	bh=CcEv4k6EYczNZFSIEQ5Yg+KH/TDQEhsuCJIQZHT/paw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bmxo8W7UxSSnrZC8tNSfjl434EKYknU8kh1+iTu3w/N4eu605pFce8GaaHNcAskxz
	 O7/wJf+26gMTBoW2l23nT2aedcYHOBwcTnCuCa6Ae6z25BUbeUuwInGPEaNb7IdNPj
	 JLOQbJ8x0R7NkalFiehzTUo5aAei07zCydtDJ1XnDTHCMSlfq7arQOpOAXKTe1F+XM
	 e8jumJLBh50XEeVTIqnNYNTmLZXIc9m7XQk6MZ/nN/sO6v5WpUvogepzr0t3qMGYD6
	 PdZJqFg9ovxGaD+oytdGtZX0i13ZOR4aNRmz/5lcIn+oC+5So+rCrA34EX8/9gdIDi
	 Urno0eHTuuTvA==
Message-ID: <sashiko-outbox-209475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 07/13] net/mlx5e: SHAMPO, Use page_pool DMA
 sync helper for SKB frags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-8-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Switch to the page_pool DMA API which takes care of not calling
> dma_sync_* for unreadable netmem. Do it only for the place where it
> makes sense: SHAMPO payloads, the only RX buffers that can be
> unreadable.
>=20
> Until now it was ok to call the dma_sync_* API directly. But with the
> introduction of data direct it will no longer be correct: the payload
> netmem of a data direct RQ is mapped against the data direct device,
> not rq->pdev.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D7

