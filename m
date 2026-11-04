Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810627;
	b=IMENMbaf6cimnPloHvVuqmTg4aXbrvpjvVCtkwndUNu8ek5c16haE+b5E7GTtnlR1s1D
	 sxsFDXSpUjpmuOlvhL+vp3k35sHbzzakVEDDX1iPxTYGFh0Q/1sW2Amg1Mz6gOsJteds9
	 tb10kbkyg2WdQhA3B7FTNKCf/Df/13O6YSHVh6IxCwzyGC+OExJBcsiG7FLKgGmNaOYh5
	 6EdD/wsI8u1LIfPIuyT6kWMRN2P96DPsAxxilFtj0F7fMXJmfpsneXy3nQPzEZ5HlFvxs
	 NC9VKY/PHmI3Zce/NmJhG5xY3Bk/Nh1EgG7EsCR7KgTqBH0wrXLI+tnzNGeFmwLAZEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810627;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NcTIECCFXuqsIE5K17jCA19YckUqk6t3C62r5BdCxPg=;
	b=fsPbFD5c1o0Up0fL9Lf+jSLFJwRsoGtKQAbu38oiXEyPhyZu4PPD72u7gbcF+hzo2nm9
	 ++IbOvQ4f29e0FfGvf0jDB1n66gnwzzfaiKtJW24lM6RrXFQwyCRKIZwk2TnYJWCEvFC+
	 yQB6wd5L1znXeuYmxDqVXlJZx+igZHSwFQ64/LefaLLYKn8aK/W1ypnI0fbRGtsmVRo/M
	 V7rs1BmYlTrY7Kyd5edsqzxZM6gOewZcWYTCffeq52cEWnuefxn8Urn9z1avkQum3NtxJ
	 b2Qc7faQ383S4ujgv1xZmeqpjVjGYZNBOk1MpLKxmbjdsg+KPhYMxoxyTNVMsSgXeKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HpdsfmyP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040AE606A334
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HpdsfmyP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C716F1F00919;
	Wed,  4 Nov 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810626;
	bh=NcTIECCFXuqsIE5K17jCA19YckUqk6t3C62r5BdCxPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HpdsfmyPvz9QN2Bibi5f2Cy4sX4J7BnhIT3PHbMzCqDg/tMYHAoarqu2KakKwKpT0
	 cT3r0NSUi2ABlfLclvXvUacMeIEuwdxcBkjniXd04svGWMO/jOiXokwWYKWFnBOzyl
	 8NLAUJ6efCijpC0D5Llm2uj0PsN++VjMIAZTR84sysfWLtaiaUIszSpTElUCxfTvvD
	 CgbZewY1GFh2nz+ZUd3PXuHmHCHZ8LQ1WbUDIXRXX6R+w2v/DhwXYyjxvaguOY4UFc
	 TOT55OP57+8GodB1UxvK+7nphOkvhCyM6i0vQeNDW/qU6uNHxR0Zqz+ojAEtvwBrVY
	 bQfRkMyMWU7NQ==
Message-ID: <sashiko-outbox-197663@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 10/23] RDMA/mlx5: Introduce per-CQ poll_one
 hook in mlx5_ib_cq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-11-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-11-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:46 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D10

