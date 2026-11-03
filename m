Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716672;
	b=FNdQ+tctytk7rymdttqLq2DJRIRvCsFPMk0IVU7kxgbH0w66SvXnIVxg9ih1Vd1Pt2uR
	 Ki3LPJdutdtvPYmpJBemGj+v10N1n4yJJDzCVFB7YqeWeiMj97GMCWkttnQiJ813hX0J5
	 5Nd+ot0mgdrQCxU64sjuMCckZCREYkpFcQrWVRTYBdiS0LJVd/l2I0vAbm2gy9RwW3u7r
	 BYIuGSBA4TJJt69GfzHJGf1CBcDrF8RgMF33QF0rB3b1mRWE1xQ3fQ+yEnrsbXVNxdUtv
	 88/y4dpPXjrQIhMZgUSbpbKHPZei3qdQqA/+SN3KabrA/1OcZr7961KVq5uPRDqLFLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716672;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0II1/XloAzTRVHk+66VdnRMv+5KhxgQ23WNutsL+clc=;
	b=4JEhs7BUu27FdVR3T06QN9iiGodG9aFf3VmsQb/XPyo/elkfz1XHJry2D0gj9VIc7SHD
	 0JQv+BwwUwD5yJclqBS6NPJGnC9kSaQn25aM0LkPtpkPJJunUcr1bLmQuuP+664P28wqc
	 kL5EmtFTcu+322kzEr54KO8pIEch03/gTj4SswO7xdYKVWBkBbyu2rHtlrg8og1fa9M3N
	 OeFyL22uMRvz+btZivr14k5qPwfP7Zy4YauYpOKd1ycU//Itz6ue9Uxrf/1+coQGm+ITL
	 6CTX1DP+b1vjeTMTA/BllqJNNlhFV9FURUkynoLk+dsU2rviN2qzkSdU2EWRBNfNK1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Bz5XvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1CE606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Bz5XvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25101F000C1;
	Tue,  3 Nov 2026 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716671;
	bh=0II1/XloAzTRVHk+66VdnRMv+5KhxgQ23WNutsL+clc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i6Bz5XvT3+jy3Oywmzx8YGv8qniQBhMuP+JYgECQEe1UWtUkJdV+sm5lxYCCDfCMp
	 nMfnM1nV0KjaL5RD+OkrgHljPi/CFwpax/YarykAnK4cOWCy5RmwDaEGQUSk682vTi
	 sFRic20cO7/tT3S5jeOrwdvQFGviWH9T+3LW5t7Tk2nwkcP9TfuPXMoA7BNqp9z7MD
	 JJoovQ/ieqj1Fv8VASBdkmQqdpJwesGT35fOUFxz8vpc5zlxVimTn69mJ27ck/OU39
	 8AXpGKOmnXyMxZMnriOB4L5myK0d92VGnsaRk2srqhdvzy7QM6sV6+5i4eEHqDxQlr
	 DGtbMI65KgiUw==
Message-ID: <sashiko-outbox-195463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation
 for pages >= 4G
Reply-To: sashiko-reviews@lists.linux.dev
To: 0z5a <dezhen.lu@student.uni-tuebingen.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
References: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:37:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
>=20
> devx_umem_find_best_pgsize() computes the page size in an unsigned long
> but returns it as unsigned int, and devx_umem_reg_cmd_alloc() stores it
> in an unsigned int. When the DMA mapping of the umem is contiguous and
> aligned to 4 GiB or more, and the umem length is a multiple of that
> size, ib_umem_find_best_pgoff() selects a page size >=3D 2^32. Since the
> value is a power of two, the truncation turns it into 0 and the
> registration fails with -EINVAL.
>=20
> The umem log_page_size field is 5 bits wide on top of
> MLX5_ADAPTER_PAGE_SHIFT, so the command can encode these page sizes.
>=20
> Seen on two GH200 nodes (ConnectX-7, firmware 32.38.3056 and
> 32.43.1014) with a dma-buf exported from cudaMalloc memory: registering
> [ ... ]
> GH200 nodes described above.
>=20
> Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103142804.6721=
0-1-dezhen.lu@student.uni-tuebingen.de?part=3D1

