Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336020;
	b=GQcsOrD8oakhtmtOBJPpy/c4fCkPrVJ20uopkUylUiZYJ5dqItAa1knACOnvV3YWU569
	 ggXPgc5zBDU4L4DYY9n9LwxKpUKjXTCHWibWMwc4iRXrR93BnkR4KCnURo/yd0zAMd0Q4
	 emjBduo9uFJ717LP9p4pzYHqyqehjt55nOHysDObn9ifUWkgEnXiTgCjtWTiGbe4kmmVw
	 R4iDSw5byU/MUOZYol0D4twCQJauMcaETnauLxKivKBY+4uQMrg9m8RhIWGj4C8dXzaai
	 3dkUVq/MG0+cW7JApqx+/B3CAtiuVf18tz027d+aCkMA4U76aXYpDq7s+fuaXbdTy2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Jjd7HmwZPo4IBgSAxDit6vdVJm0Gg9PLUtmCu9J15KQ=;
	b=VMzVgBQ+Uc0OJV0rJCPfzDLMmvTVcJU5YMiFJzk0JMO84z+5gQV00f5Wl45k7yGyegT1
	 nrfiDLjkcJZSnyYlc8Q+ebTjCWdhTsTPJr38icWkMDvaqNHNRTEmeQqHQbXfC0hDineh9
	 qdaUL6x1SlAICxg+zBNF+hHMDcrrVAMNy6QZiSuLny5Dk5ZCH72nbQpxDa56o7G1CHo/J
	 rmK39n1boREzIRW/gtZTkjnBxqiXzwEMHydST7VKSb0vgM1Elu6IxyFLxE3GQWns3+Z4l
	 DOCXB418jkPO5unRExiYoCSUAWRZAVsvDuNYuThzH6SO3lK2kQJZ8FMFmylwv0xK/dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZZ5K3Hg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6291E606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZZ5K3Hg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF52E1F00A02;
	Fri, 30 Oct 2026 04:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336020;
	bh=Jjd7HmwZPo4IBgSAxDit6vdVJm0Gg9PLUtmCu9J15KQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BZZ5K3Hg0E4FLJ3JX1h3YOmM7lQ2U+5W91/a1MfcGv4sJNLZZW7wQqfofEhD2B0LK
	 Vc8nqQXOXeh41T1uP6WbY7Rl5dMKUth86MA6MiTsRYlnudsYNJuMOVPm9s9bJ489ZG
	 kLgyCjryVuUart4Zqh+tdZXJhK10mDPWoS3/72vV+3r/qhRx21QkoosXBdotwO2VJu
	 uJJ2zJgAmo6r6wpcwB4oD3Swy5wfepgSByLhtRsk26Q4BRtEr2+mb8TOHL9CMkuJcP
	 EUoJeOHzFAZuLq7j5ageAxIm/CnTRh5aAr1LaztJr6PsGbO+8jEWpsQC9iPBjgo6ac
	 /QSu76uKTkisA==
Message-ID: <sashiko-outbox-190334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/3] net/mlx5: wire frag buf pools lifecycle
 hooks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428052920.219201-2-tariqt@nvidia.com>
References: <20260428052920.219201-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Nimrod Oren <noren@nvidia.com>
>=20
> Wire mlx5_frag_buf pools init/cleanup hooks into
> mlx5_mdev_init()/uninit() and the init unwind path.
>=20
> Keep temporary no-op stubs in alloc.c so lifecycle ordering is in place
> before the coherent DMA sub-page allocator implementation is added in
> follow-up patches.
>=20
> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428052920.2192=
01-1-tariqt@nvidia.com?part=3D1

