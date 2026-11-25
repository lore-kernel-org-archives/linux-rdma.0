Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795631513;
	b=l0Y8WnecGqZH8NXhEyqU/NbbdjuxX8mnhNrd3Qr1tIc7QFH0mqk0Cm11mglodAqR82D3
	 YoCOy+omlSVGU8oxFidgxPx7dRpnM8Df87Ph9GMH2wMcarbm+riy3HWcegWhKQF1kCg8c
	 abGAR2LTie4XR8xLjCD12zzTX6dex/Wc69HUsflPsS1RiZJfwg447cMbs9u7u2yXP5iLY
	 WB7JiquQX69majU3RBYQkKoZB39iak1g+r7V+73bfoEYxTeTpU8gJHrtC3Yx8a3KQZO5G
	 Y4dWSQCVZAd2SFOpbvsoFloV8S9GT7H1pqq3/gW0FaNm+ir6bkoFGTn6nDGKChqq8jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795631513;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E6yYRsJzldZ7MCtYcTnqXr5agzzJBski94EZ5xYE6Lo=;
	b=BHD2ofrIN4eyXkVYWk9Ir+OYZkEqjUgYBpCUY7LRuFZ1QDi2xsAAbrnwThIH0vpUrNEA
	 XTC38DT1JWWt74uh4s7B/fM7Nq/jZNpH4dHrnbyVcJbVD558GDG/1a/gWaJPphOBGU/GF
	 Vn1GWGdVTqZRGd9f8/w6ES7/ObGXhhFkjXTu4g3FEJ+xnq/LxgglD4/aHezvtU5sk3FQ4
	 HDjRvMtFCVXRQkM7J8g/W/eP/4kpifykFJvLiNIrp+/+KDvYHsgPP/JVKeLsyUX/MPNhR
	 QbzjKz6e02zfHpFnbBgOqe/mDP7JfujfCIjxXFIpzvjVDqFVNnmiioDY9ufr6dpvnPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MUKoY7/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557CA606A321
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MUKoY7/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9F11F000C6;
	Wed, 25 Nov 2026 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795631513;
	bh=E6yYRsJzldZ7MCtYcTnqXr5agzzJBski94EZ5xYE6Lo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MUKoY7/CR+u9M4VFEPxONFwSHbCpHsnJDYpJk3BSKZuF8p+PGc2l+tfVp9VW3k8M2
	 jFjQfFHAFrcAgrajSAwEaBgEKGD9ntY+0mIoIvy1cZp+YTc2VFQ4ImwPyiRlbKTQoH
	 xmlr8ktqn2bCt1uPQW5QuOL57C/daDNf4mSeBQ70cHKh7GENWLlmpaKGQ7LKRWSPR7
	 HJvRLrXYrQ99q1Myw25BlBMdgtks2lwyBABbkvn9LSQj/C+0iJZF3ENjI51Pnn8Got
	 zhbzGEoeSYR96HfJKmZCPMI11LBz9IGrx3F25or3/Mk5I1HIhnblWHbEq8J3oi0e3q
	 fUAVUjXcHxscw==
Message-ID: <sashiko-outbox-233999@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in
 rx path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Etienne AUJAMES" <eaujames@ddn.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <awcn1-LpcFgzRKgq@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 18:31:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5i_complete_rx_cqe() uses the parent's rq->ix to index the child
> PKEY priv's channel_stats[]. The child only populates entries for its
> own channels, so on a parent channel with a higher index the entry is
> NULL and the stat accounting crashes.
>=20
> The race occurs between mlx5i_complete_rx_cqe() and mlx5i_pkey_open()
> (bringing the PKEY interface up). Once the QPN is registered in
> hardware by mlx5_fs_add_rx_underlay_qpn(), packets for the PKEY can
> be received before all the channel_stats entries are allocated.
>=20
> Look the entry up through a new mlx5e_channel_stats_get() helper that
> checks ix against mlx5e_stats_nch_read(). This is safe because
> mlx5e_channel_stats_alloc() allocates entries in order and
> stats_nch is published with smp_store_release() after the entry is
> stored, so every ix < stats_nch is non-NULL (paired with the acquire
> in mlx5e_stats_nch_read()).
>=20
> Fall back to the parent's rq->stats when the child has no entry for that
> index. The fallback runs in the same parent NAPI context, so it adds no
> new data race.
>=20
> Fixes: b5e23931c45a ("net/mlx5e: IPoIB, Fix child PKEY interface stats on=
 rx path")
> Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/awcn1-LpcFgzRKgq@ea=
ujamesFR0130?part=3D1
