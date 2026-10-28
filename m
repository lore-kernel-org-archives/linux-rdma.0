Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200183;
	b=KYKjrLsM7e91ANZ1f5jxnZlpqPWo+MRFiXUBuc7xN+tVOJOpTVtjkxiXrnbB4Nmy+Jbr
	 jF5iY0AV//BRA4JN/o54lF07DzC1NSakrYWHbFZWuFx/u5s7u9gQMnLuHw6UlvQw7vej2
	 T/JNocIPvrGhaytRgYKJoJzOcB8MesvOOviD+tTfIKCmAwkAwT2H1jd+StaqG9hPtSeEC
	 RvPON68sq29fIAf+b0pXP5DH+XeN4mMoAdEJWP7HrBryGoTRSRohD8AIPDbabatgg9f8f
	 YKlJVaDvwk4lwWwK3N/pCXKoM0965/fHA++Nfyy+15cdGt8qEq9JKB4dRIk8aaKEyYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200183;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gvr6wt3x4HhVtV/J3MbHJwnMCMtatnCr92Qk3+lMtDQ=;
	b=oC/dlTz1GeLGNT7XuT0CBB6uRnWgBYFUno823TnEy0NNwFkHXnYq+rDfPLVjh/U8sauS
	 YXvNLEKGkQUcCE2jEtxF6bbKn731NcxTXedqlMzMmLHCW+z98CkNsedjRjDPGkw6W9GoV
	 5SZ9S2mkQ7Xal3zSaKWoPnSEmGYZnhAOOKKdE9q1ystTGxYL4LYZ6wwHalf3jxy2aTgiF
	 YmOVkM6ZG91p7mCopvswXgHzLOQFqRVbaJJLFz/qv7jjWsr6rchnM3QgCIB4Lz1taMKJq
	 x03bU2Z8nZ/0JjCiiGzZeU8smWQQRbVpvvSGlNLa4/59XNp3svlpqA2IUaYkEXxug8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N64s34C7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0D606A31E
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N64s34C7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B8A1F01825;
	Wed, 28 Oct 2026 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793200182;
	bh=gvr6wt3x4HhVtV/J3MbHJwnMCMtatnCr92Qk3+lMtDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N64s34C7iVqAPWLS+SNNdlLxqNPs0QVJWx/ECH4/4aqiKpcVJOFd3uzYMcoU4H9Nc
	 /k4cr7NntS0BHMFrTY5tNFUKLDHk9KePl6dmo3YVZji5R2wwRvU3m1kSQZLLspMjqP
	 Wtp7/D0K8LN/aqYYOd2Gk/ThPwfFpKf7aoa9qkfBFVjvXQ+SVF3HsOlZxquLa3UAYn
	 nd1JkV9+qfQ3vuIHuY3kkDZ8bTa1jJNhGoBM630LM8oDJFW/8kw+Z29XKEAGre8ODW
	 RHvXsznWXr9tajyvjVup6TW/gtGBLbwqittwJvuvoD7k03qpf38Gem1XsMTrvX+Bw7
	 7HT0rQA49a+vQ==
Message-ID: <sashiko-outbox-188038@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: TC, Fix double free of branch in failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Thomas Fourier" <fourier.thomas@gmail.com>
Cc: =?utf-8?b?b3BlbiBsaXN0Ok1FTExBTk9YIE1MWDUgY29yZSBWUEkgZHJpdmVy?= <linux-rdma@vger.kernel.org>
In-Reply-To: <20261028145805.54595-3-fourier.thomas@gmail.com>
References: <20261028145805.54595-3-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:09:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When allocating the false branch fails in parse_branch_ctrl(), the
> already allocated true branch is freed but attr->branch_true is left
> pointing to it. The caller parse_tc_actions() fails the flow, and
> free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
> free_branch_attr() on attr->branch_true.
>=20
> Clear the pointer after freeing it.
>=20
> This bug is theoretical and was compile tested only.
>=20
> Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028145805.5459=
5-3-fourier.thomas@gmail.com?part=3D1

