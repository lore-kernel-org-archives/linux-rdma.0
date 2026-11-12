Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492659;
	b=RtQHuMvyaLhFaHa5xzt1tpaI+RK03oKFGE7HDn8zV1qg8OhQDha1o7NPBtA0YgXRrzL+
	 HkEwXeMOnVoJOftdSjqhTPrKr4fqmkmZtDit0TXVQVUzWB4EThC346kJwbvAofXXZKp1t
	 0R5CGIskDiCVDTkWokqgNNrNqzycJMlqaJl9q+7+E4AeKctl+gXn11Lj83hgcCECNvRVU
	 ag2RCmTW4CCJP3KOPNz3QvmgriP70/wOX/K75qSTXr1qhFKJ3E6Gbx22oEtFIgMpA6OqJ
	 tRK0A324+xuOoMp2bjoLIspcZ7C9ECP8A8hUuIY3GB0p2u5FGZ+k7zDnAuMb2GsKcag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492659;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=blTDX6sASAqM7TD1Shq2kiI+cxc7mHNdhRnyqFAca7w=;
	b=xE8WuP2c9b9iHGnrs5dcpuuRJA+Rk8uE+QbmR+4tedVXnnJhniV+mAmWBw/qHuWbuHG9
	 EBuUnpMKzM+HerwoYE7YLvrXJtsjjanXWnGlfSIWZdZYbcdmG1mnC46GfJFm0SqNe0Uk8
	 M2GK8VE4hwrbuuu1MHH52d+85z6sNdJvVy9LEFcpUXkxVPBTe/h+pzgJLzjugun3u+pfV
	 2FIfkDXbwAIo6czHS3zfDYh8Vg8czPjboAdPqZxj6qiXPJbjcj1EIub7PTBwNGI8f1L0Y
	 QSpX18/TaXXUdxSKhrZJdv5l8QFn66zNBBEyzt5txv9XdOAXubJw9Lsk791bRenWBog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="e17/rcSK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AC160A2609
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e17/rcSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BB91F00AC9;
	Thu, 12 Nov 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794492658;
	bh=blTDX6sASAqM7TD1Shq2kiI+cxc7mHNdhRnyqFAca7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e17/rcSKZqSK0lJbiAKF7SKoEC1oC7v9pd5SVjGnNOceeDPCxvZ93Iefqe3rTN9X0
	 8lH0lhfFEDYt+RLvDUqiEYmHlqBpmtR+h8SrH1TkhIldifVSfq0WdjTGKYt0cPuyKe
	 D4wkjczNKwXLnPl8ICctRhyHjaH21fNU6eEwIi+lEZxpUKK+BXBuPzkne7P5ks73dY
	 pnciF6HJam92O/8rqt0g+ZIoyVzhZCkNMXs8yQwqfXxwovqi8jF0M4OWeexB4SN/zj
	 UctDxnnd66nLULVGctm75yKiq5hVdBlHqsFDc/8WLokx2G03zX1kHOxMg9bPtKiYc0
	 t5fgLQrbaia9Q==
Message-ID: <sashiko-outbox-211275@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/ocrdma: Fix potential EQ table leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <liguangshuo@mail.sdu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>
References: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:10:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> EQ teardown destroys the individual queues but leaves their dynamically
> allocated table behind. Free the table after all EQs have been destroyed
> and reset its pointer and count.
>=20
> This issue was found by our static analysis tool under development.
>=20
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE =
RDMA adapter")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-88a3a7ff32=
-rdma-ocrdma@mail.sdu.edu.cn?part=3D1

