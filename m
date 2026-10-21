Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792569631;
	b=4KJdBp4idKmcq2HVB3L/DkuZ+Gu0kvk2OGfRpe6tLZHH2jLCh2V3hA9YqPCunLaQjJwn
	 28pK3bqcwLiNAzC/IQlip2I55l5jOIx9FI2hMK0tiNZYBqOm7DfGUUKYCJIi1AOh91R3P
	 PuiJVxW7JVwr6Rfzq4ge9Y0yNl6+StZeK8gxaAO3PkyO6THZFtEHR8NPIIpFsooItoOBs
	 b5kMTSAU2swNl8Hfv7JmKJaORg1/UlQSV5X7elz4n9qqFb1Os+cd/mfSWFQyeOrAQeU6z
	 VvccDMtT/OApWwUv7QIzMSdh/Rj1uHo4NdAebScjqScR1vL2i9ERk0Gj66oJTl1KJiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569631;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1fSMItJbTefUsUVIncg6iidmYagVcdtDG4M+mORsQ24=;
	b=sFmTcILX+6GflalLTGqvXnWBgZCAeLmnKla8injkD2EOZ/BTw5LH1maCklI0d7+LYmJe
	 eLeC345R8fPCl+NQF9BDttt5TBXQU0l/Us7aqMBuytSA0AssOLoGtHQENDFfDa1KUlnlh
	 3LWo/7RIVRsC+w73Nq5jt1GrerHWprTYceBtQm+3FKV7P+vvft/6Zdq6jtKlH1CSCJFca
	 gUYOwGXY0Wgn+gXd9tmNjLFqdsX6J39G2c2SpH9ebZd4WHfZWTMWjRZW3mM2z+C2K2nAm
	 wGN4mWBjJFOlpvc0Y9aVQ6H4vZQxfGX86BDrruxLyF/IjfQ+ZHReTlzyOEHIQNnddnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DWs564f5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAC8606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 08:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DWs564f5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005171F000C9;
	Wed, 21 Oct 2026 08:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792569631;
	bh=1fSMItJbTefUsUVIncg6iidmYagVcdtDG4M+mORsQ24=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DWs564f5FSkVR0oS85AEP+RLaXVCWvzAWnW/ZG4YEwMdSK2auu5bulLSXFqsR6h5l
	 m7mAym9agkg0FEdvnL4k6xyeNC6+QYPEuipozaiK7gsh5ahq8s+2vfwhkkUkqHCk8x
	 0P30qX++3AvC5wB2lgbsyRoRugB5SMhI08Mc9lrN8SmNgN+CgfZFWTUqVguTBm1uw4
	 PEtc81Pgh60/iTfLusvlAyONylAa+QTOdjjfdDr4AWkKKr8/GxhqoxOYWfe01kGa0U
	 bYvWLrZOTsBzMAFUd2bjMW0SxReXFbhduRLVtB1QspBNNsTB1UX28QfZhQkI76+yTo
	 rUKPhJYQuQ3dA==
Message-ID: <sashiko-outbox-179935@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 3/3] net/mlx5: DR, Fix out-of-bounds write when sync
 to HW fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021074949.3471704-4-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
 <20261021074949.3471704-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 08:00:30 +0000
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
> reused) after a sync has confirmed that HW no longer references it.
>=20
> Fix both problems by putting the pool into an error state when a sync to
> HW fails - mlx5dr_icm_free_chunk() stops queuing freed chunks, so it
> never writes past hot_chunks_arr. The chunk's ICM memory is not returned
> to the buddy allocator (HW may still reference it); the segment is left
> reserved and is reclaimed when the pool is destroyed.
>=20
> Fixes: 4519fc45beeb ("net/mlx5: DR, Keep track of hot ICM chunks in an ar=
ray instead of list")
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021074949.3471=
704-1-tariqt@nvidia.com?part=3D3

