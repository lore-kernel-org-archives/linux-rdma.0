Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474905;
	b=N89bPh/P20y1XI4J+/28QbxO0UY5oOxHo8dYprml3/R303IuqyrTOPy/r6JhHAh6GKi8
	 KdUnLftYlqHIXl0l6if9fkKDPZ0GV05UwSoooYmPiHDHorlUKP1DRreTUa3eVo6YNzgpR
	 YIaLVEXsPBwIQ7ldAAaxP2hKLm1q/D9hoNjKwdttU1Bf05tk6S4agVlVOtDrvjUoT7okH
	 DhOzlP1I7gUszUBP3ncl/X1AueUeKvqwp+uevrqvJKkkVICWWXquO52N7o90zKYYkxXb1
	 zsQaY6JhsSb8eKRidRWAoSTiz9GNLBvXuF9P4FynBcMgp0vDy02YOrTgQm7OmLHlidQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474905;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0GX5aqL/63RKy6e0FnbAV5zLiXqHIb0sHYD69kFAXpQ=;
	b=g1o+PgLhKm2kXJ5ZEBDBXGzwNPbZG9SbfjMFnAvy7279oLBx9a9+Qnq6S73JcR5rTHnS
	 ROQzUAxjaZ9oRLrY9PoOPx7C78L38nyF0jIjTGQvB5UvP56/kd053ZReJVh2Sa6PBOUeU
	 6DYnxF6ZtmQ7L7BvBh/Ky3xA63pxFdsOkLhdN+bq/YhmWv9ZDCOuzjobOMo3J+69X0adq
	 ylvFHpNS9wWTEEWivVeV8JhE4/GaaRqGW4QGerCNJq81ImgVTo1cNQzvkA/O0jelvF67g
	 iHcLjYd5qItFVNCBX+ldfIjesWH8o3/JF8wmRZFKMybk4tod4gPH4LVUe3FT0KRHYkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiWGzxv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CCF606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiWGzxv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AB01F00A0B;
	Thu, 12 Nov 2026 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474904;
	bh=0GX5aqL/63RKy6e0FnbAV5zLiXqHIb0sHYD69kFAXpQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BiWGzxv7WiqQ8KuOz2UZpFvBqnY/rHUovqDCLyjrl7HFbvsGETRu1H0gQqSF2P0+M
	 1Ni80kOUG+4h83kF4xQZNhsdtHqEC6+F+6m2cZZ8v4TqunqCO2Y2JE6p5I+FAFLF/O
	 9X8DcFPvg/lQxsZq1Txp8Nv4wbwmo0u8av3/HAb/9Dx4+nkD5Zo2339iaE9XTBC7Dg
	 Oys2FFl8OyE+AoaUNnPVirq2HDM1qspYL9hpzydPCkwZgHN4PK77zHzkVD99zPAZRO
	 x/J34LiT06FnvgFq9DzPo77xKuFeuHUWxifEq9Y4ZgXgYrKDXA/mkGnWZOYEB6FDEI
	 /rKOX/nGeQ2Sg==
Message-ID: <sashiko-outbox-210842@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 8/9] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-9-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:15:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D8

