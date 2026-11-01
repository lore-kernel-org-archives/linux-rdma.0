Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542779;
	b=3YZE9BKQwnxudq7RxvZvIM/P1HvasjA83elZkNFRRFThJlTSwGIRkEFOfOc9czU3AYug
	 lyNUpFk8DaxOE/SMeKcNGu72hwvxdfMfi4LWvM1XeWTtpJx1yfyTKBro7uS7NsIuSfZCu
	 ctSeexyiWkl1x8OxsERqc/1QfSY5g4T3HRMpjTHAEpClUwr1PdYvA/OF99ZA0Hy4Lo2Sa
	 DAMeKK4Nmq/fpK2BLfQ0/HJE7KPfI2+ERqcOINJfKmOP1Dozw8qtYDJe8Gq6gpLEn+nMc
	 td/Bx6gLMWZHMAzSFo7bQ4V3nvzqe70wK7I8cGI7xHt+ffv73gHUYGDSAxxTaUWJ0/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542779;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FX5CK9V0a4+Bhhjzur+0fOakXupDEWoQvaQp5YQklSc=;
	b=UfoF8UcUBqWnW8npnpzcSL4tLpwLIr7T5xaRio2jFYyUzf000aVbqZwvIdhgO/qsj6RP
	 ZK0vTWDETSfWtYR0Fn6QhR+RwfRPErSLgUMlTBgKfztCX/HAmEb/BIKIsd3ZXmw7mjXSW
	 LhXHUec9l7kX/xfeJhctqs49P/+EU/gbQ+nLEqfr+nqjnGRU/GP/WAOd3dzZNZoiw+vH7
	 +rqnyVyV92ydpxQlxnksw/srp/qKmjHIAFLCi2C4b6UhOj5nK+G/LSSkUqUSkZFpN51Uo
	 0tVZFQwgBGBxGroI3yEENlR5J4v1ScFDdZX4naehcOueJWt5M3qKe8vbAY40lEx+1Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kOB0bYEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E2606A325
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kOB0bYEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6381F000C1;
	Sun,  1 Nov 2026 14:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793542778;
	bh=FX5CK9V0a4+Bhhjzur+0fOakXupDEWoQvaQp5YQklSc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kOB0bYEZPWuLDa78OnqZQWaZstFoQvBUQPu4L6q11JL5fPfjEhZSxvLMJpM3bLcmo
	 /tb/HavBUR6U5ISGZR3hWVJe4Q8RMwBuVO0MLClt27wPYkx3Ss+yAOIrW9XLf+I/pt
	 HbFBYt+WfNL+wg39oEV8TSDo+m7TPN9xHJccqMcsG6slDA0obV3y+4ZRKhPBemMAS0
	 fIoi9BY1xB8csSIt0rjbwKSLjAEVAMRBSh93WHI7UBiuAexeUoF35VYZEPftTYRiSs
	 5zHMpqjU6Usw9D3yuIf5e436TvejmpAspZnz+4peJy2egOKUD/zYSWk+AlxF+q0qWv
	 OxdFcNAB7PhVg==
Message-ID: <sashiko-outbox-192443@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] RDMA/nldev: Reply to RDMA_NLDEV_CMD_PORT_GET with
 its own command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikolaos Gkarlis" <nickgarlis@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261101141521.2426198-2-nickgarlis@gmail.com>
References: <20261101141521.2426198-1-nickgarlis@gmail.com>
 <20261101141521.2426198-2-nickgarlis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 14:19:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> nldev_port_get_doit() replies with RDMA_NLDEV_CMD_GET, while the dump
> replies with RDMA_NLDEV_CMD_PORT_GET. Use RDMA_NLDEV_CMD_PORT_GET for
> both.
>=20
> Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
> Assisted-by: LLM
> Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101141521.2426=
198-1-nickgarlis@gmail.com?part=3D1

