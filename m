Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408932;
	b=2bedDAGIa6cuPbZDoUksC09ikj6N+nf+xv89Y0QUXhrQru/ToUiUxxglFOV/KDvCnKNo
	 EHwWRFTjTaki5vOIB2q7fjvTQPuMX+Sk+b8dxJozdVR553V8Q6+2btEUdGCEzJ/NAY/cA
	 8E1wcE3SigF13NEMIlQhBWSJOuyHf7YJLszLXkuWYaMO9/qQZDv7fZBxZjmGnW+w4+Bxw
	 aEDPrBy/sXheZLos0NvCjxuElZJd09mioTeIDmrPsrj+XOn5h1wSASPg2v+dIOyNnZ83E
	 nxydwjwTV79YooVzillKkFrQvHhIwmmCM6JDBMJ0o0SbM2ttn/aJAQ1NDT6C6wGv59A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408932;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SgeipNBdGstiaqqTw5tB7DA1qUv2Q32XZkBLKXwIbo0=;
	b=dEDIeApq78TjTxJs2QCGcZ1esCwFlbDcFAn2yy6i5OjpYW1HgIouTjpTB7pQk1HJvRyP
	 ZpTnYINu4vGDX7WbTwnqcpIXAIFcElyuHiAdfMIh2mGCpy73KJy4ZS+IvHP5eqyaUrWT8
	 WjKmS7CeMkUIsI14YfAkYk7aNAHdx0xrK/dVOKDDf6DV1750+u5c9j8JfvYYEf0PzqIqj
	 qk9PZ+NOXkL2q5vERi3hovcdl09S5YAKWU6ZFm9O19O52MaB50ERAWCLxOKaveAGICzNq
	 bsbzr/UP2B78JWB/fUYuHaK6Ufo0y8iRi6pkaJTbUTmKtP/pkUFGGGcGQu3DkYMq2Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l93z8jPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B75606A324
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 14:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l93z8jPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9AE1F00A06;
	Wed, 11 Nov 2026 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408931;
	bh=SgeipNBdGstiaqqTw5tB7DA1qUv2Q32XZkBLKXwIbo0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l93z8jPmkiC4RMPEmJcfuUDeqk4riCac7IoE4iYg4fEhmJLoLPeH0mu8PYNmvYSny
	 a+Ce9XS/h6HL3OmRctUWZc3Id3VAovScyXYS7f+I2YjFDOZR/Ba9+c8ctFJi0Y8Qxh
	 ELwvK+gQ1CvvqBZzUyYVsyeYZT6q0f8pnu3hOZsN3G/wczwd8WLcR2AHpgvSzB7DRW
	 IELZ2X+jEJ8sNbR32WvxPah/cIDunS+gcnpG+Oj0H9r+7NhWqCKK/kxd7Q+ZKJdSN7
	 woLo0sFZOCf4p2N9/Np25IVzVAE94LF8lfJ6GVJ5cpt/sWoKQGkJWWB4AsUSf2z9bM
	 CWv22k4Fabwiw==
Message-ID: <sashiko-outbox-209202@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/mlx5: Fix DEVX UMEM mailbox size
 truncation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-2-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
 <20261111-devx-umem-mailbox-overflow-v2-2-1e7ca8237b58@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:55:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Uri Dar <udar@nvidia.com>
>=20
> devx_umem_reg_cmd_alloc() stores the CREATE_UMEM mailbox size, a header
> plus 8 bytes per MTT, in the u32 cmd->inlen. The number of MTTs is
> derived from the user-supplied length and pgsz_bitmap, so a UMEM of about
> 2TB registered with 4KB pages wraps the size, the mailbox is
> under-allocated and mlx5_ib_populate_pas() writes past its end.
>=20
> Compute the size with the saturating size_mul() and size_add() helpers
> and reject a UMEM whose mailbox exceeds INT_MAX, the largest in_size
> mlx5_cmd_exec() accepts.
>=20
> Mailbox sizes within 512 bytes of INT_MAX still overflow the block count
> in mlx5_calc_cmd_blocks(), but the command then fails with -ENOMEM
> before reaching firmware. This predates the change.
>=20
> Fixes: aeae94579caf ("IB/mlx5: Add DEVX support for memory registration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-devx-umem-=
mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com?part=3D2

