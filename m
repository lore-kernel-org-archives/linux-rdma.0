Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994191;
	b=384sEm7TycKGhj1HBvk0UF+j0POvGOjh0JG5y99l3UvSCjOjFAbfqof/77WIc8cvKw17
	 WTlsBPpW0ZORtDuROwVLXXOUUQxzgJuBPoYQazFrq9ZG9BqNHRnXJ2s6/yRFmdO+lrMlG
	 nOLr7DgyxTqj9v8LkI8+pok4JtRWjzb/YaVAIMAwUhm6klO6tfDPuo2E4sU71343Cp5Ay
	 jag4TC6ukKozNDz7tTWeqSwgzSZR1z4EpSJKgPC/b8uM1wXu+0aH5mV9Wge+hjidW3SQ7
	 ZfzXdIitQQWRlM9oXDtztWQQdp8xVYsaN2uHteOqWpkCVsZTWv+0oQ1MmYGk7mpdW+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994191;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Dj2HkoaelftvtSlYUEFlgukOKm7k56g76+ewxCYvhEE=;
	b=Wnpka64BAcv9cXW2GmJpEiLeHT+FnFEL97ebSA/dIIfmtWMKgq7U7ea+V6+aWDLu9NCT
	 bL7dAcZgOSVzoXRhjG4PTY14PCaD1LidSzu2LJIXWLus+zmC734BVDz0RBNGPNn+oYbvP
	 FVX3R410/CLClHGKf9PgxOfrKOhvqkqLKSOJ1YXJpGiqCquOLPdGhwOD/piLrSd9NkQMy
	 d+9o/4on7c4UEeYemnw6ACUc6qcyUXFTSH8xTexh/bmdxScp0hKFPxDenV1HS9yvPl2OI
	 eWERWxDS7G+uyL1bbXwWyv0gMZ2Tz92BPAt9BOWAUQJ8i+yPjwnSMDEAJCNbDXDR98A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dcHnTIx/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CF5606A334
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dcHnTIx/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1255E1F000C8;
	Wed, 18 Nov 2026 09:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994191;
	bh=Dj2HkoaelftvtSlYUEFlgukOKm7k56g76+ewxCYvhEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dcHnTIx/iGQ0wP/cmH0GA5mHaz1Ed9cl9yoGKIAIlcviqy/Yr34LAeh0cBLgeZ9pN
	 IHU0JUwQaFvuLWC1NYLO/R07GbV6eNoPht5ypQexVj9Gf0tJDXKGTJUNc4pKIXh4yH
	 7alJ+1lXDtjEjqn8nYqmbhFg+uVakXcetr7mfZ3PnnR6vtRblMhe2XLThS1At5m4cZ
	 hpZGRwWDNhqZlrnBC68ouQK4H5efrhkNmirGMkIejhs7fTnTCuResSAWryW1c+so7y
	 bosIxFtwB2TB/u1Fz6NLjVJ8F3f2pymtMgDKr7dCvbUwzC9L2e9eDyYfTvx3E9oTdF
	 OlMp45sz4LdEg==
Message-ID: <sashiko-outbox-220564@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 03/10] nfp: flower: refuse a tunnel key
 wider than the VNI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-4-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-4-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> VXLAN and GENEVE rules shift the key and the mask of enc_key_id into a 24
> bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
> is about to accept partial masks. A mask that only covers bits above 23
> would then match any VNI. Refuse a key that no VNI can match. GRE keeps
> its 32 bit key.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Confirmed by code inspection. The wrong match was not triggered. Build
> tested only.
>=20
> Fixes: 611aec101ab7 ("nfp: compile flower vxlan tunnel metadata match fie=
lds")
> Fixes: bedeca15afd8 ("nfp: flower: compile Geneve match fields")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D3

