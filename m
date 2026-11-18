Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022033;
	b=V4k2FbuMagZe+ucLanePSRNpRE7vfxbDKCbnzw5mwhof0QzsNve3+GM5mGPs8m6/oUCe
	 vPLykHttE2aHfXpJS02Yc0yUPgQ6cW8Y1D/VnEsHB4fR736YTBeXyRAQlDcpq97V6TM/G
	 FTQn7aduQOOAefy8D0WP1w7iW6tQvtC75jD1OiY7ikaHa5t3m4hIHMxfyifOap2aUnzCf
	 9Ej+WdBp2HMsTSPxypQD/CkQgFCm/DZTYBLF/2kWhU17+jP6OkvLMixp2TJOiKft+N7AA
	 CSmnvqfRsIp2lTVNcQqBgT40moB/0+1Ro0sxrYyMzTsTiyebqFve7jDghQeq8AbEwjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022033;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f1SWJU0tV50pdDr31hnASxNBeRI3prxb9LLzmLuUkXc=;
	b=mL3+XWcT0+pGsP9YKUdQXVLzJyXzh2OSNUgvuk5IShH6VyoIoudedhHUp4pWtVGyKA5U
	 CXn3MD29V3gA3O+J+KsYl9sQpwBZgMx8U3aZ2UwFsCJoIkYhY/FgyGuRilKM43uhz9Xgo
	 FCYWfuuHQ8CzRLf/RtG9oCiWiT4O4MKFjzJIFrltZPwYTTaD85K7OovYMi/y4zJ2XMaUF
	 96LKhYox9s1VCdayZCBBrSPAQVFu447cAhe4do9Twv4LuiIq6yIYTeeKTXfZIvVohUA/c
	 mJrL76gVth67AimJuNxYtX7KYgqJIt/xsO7U90qkjARuu+dLrxPQCTRpCU6hP6LLBbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AngIN9wg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508760A2615
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AngIN9wg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7941F000CA;
	Wed, 18 Nov 2026 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022033;
	bh=f1SWJU0tV50pdDr31hnASxNBeRI3prxb9LLzmLuUkXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AngIN9wgn2CDvPjBYH5iMgQ+wdqwpvdvPYtwpyzig2t8vuZUUBiLpvw7nqddDDBpl
	 CQ7CQCtnIMpdnZ4633Ac2ZXTLEBRtG1ABUPvSY09WOJmjs3hWQkudt+m3q43foyuca
	 0cnEMJ0el+x+xgzVvjeXqA3Fn6JEyaLftjpA0KnSWEJFnbDww3C8rU2evE1/LMsYrc
	 H99idMKNEWsBbCTg6c2kCZwox1r66saTEKR5CRWnYXv7hi/FQA3SROvZWbpzQhWst4
	 BLXoUsVguaQNJsXDAofHGgEc88IZkXvZRmkJI1WmdCYGza7AV8f2bvxVctLBEXDgPO
	 81wiWIc3tD2NQ==
Message-ID: <sashiko-outbox-221620@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 19/21] RDMA/mlx5: Clamp log_max_* shifts in
 QP and WQ limit checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-20-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-20-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Several QP and WQ size checks in qp.c compute their limit as
> 1 << cap, where cap is a log_max_* FW capability. An untrusted NIC can
> report 31 or more, which makes the shift undefined.
>=20
> Use MLX5_CAP_GEN_LOGSZ_U32() for these limits, as done for
> log_max_cq_sz.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D19

