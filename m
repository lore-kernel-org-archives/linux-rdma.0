Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022025;
	b=UFndwUJJ3u4SWyTcCxerNtaU1/vjeUu5RHEQgSWvoyZwJbwcXROJm6zOHD4P4ufGUIe7
	 Ftucx+6oNH4iTX0eC/Y8Al0VO+vC/0r2DK0jTbh2d6zuvD/C0txtf3pKPVnNue4Aejg7C
	 r/6qUi8WVdE4YIO2PBcbKvQ6pGdaj6m8YWLlrFf3HJo7kiyFtm5zNkPCljej4fEC1T01L
	 8cwoEhKWwqolQa7DaXHjrkW4/Ubnl8iHHf4Q68Ror+m5SZO9lGkhrmaqS3TcRYbstWAlV
	 emNW+WWMsPw2lAbTjIu9GQH94PEmVT++NxQhvLZBxhF5AEY9RkOBVBowaOtgOmxjH1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lIBfj69w0WUrDQ4QG7yc8TUK4C2kBn/VzMsecM3T6/c=;
	b=ES271YwZEPFBc2NUgJomQT4knjlE4/jTzSONJNooWmYUvkvzEvci0QrMA8n/WgKor0hF
	 dlmA02btAiI2nVy972dbdvrnxbxREcyEbHrMCnuBZMC18nGUMNQFfgvQSlEyrQMQzV/8o
	 SwWi98tzuPCZr/DxUxObmK2Fd4FEHpd5GnnocCgulugCGD+4WTrT2t+jDYUEiZdVcoLwf
	 6fo1sL0/uggzNis+eYGigaPIiir3GtI+kYzAb0EVPJEF3PK9FsXOINXfhtcQ4wHJHrjRr
	 xHF+dL5gnXmCOgH22k1k8RiyOuksxYmHSdMQOqbkjpy6s9s9L8nUVnMXxYBQ26SPnZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LX7+1Jzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EFD606A337
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LX7+1Jzk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF3F1F000C4;
	Wed, 18 Nov 2026 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022024;
	bh=lIBfj69w0WUrDQ4QG7yc8TUK4C2kBn/VzMsecM3T6/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LX7+1JzkHsF/BjzdRsWcm1y/KMISGnyVgU65F7sastD7IEZZ57QWQmPBynjcTrAj+
	 krrtlh3jHzif8D8dJzPnFJ3t8K7gAjdkKcq0/c//5dE5dv9hBSG0bMt4sjSM1aIO9t
	 fvdS2vbbtCvdMV/yxIgYv7TJm5aj9p6ZRbh/5EUhC/Yys9vnmS/glYci7ayNhDHOlT
	 wobpsC9Q48zm4Kdesu8yPlQEm8HovgyLTC9BD4dMSRwOJy9i1fdkiisxUem+ux2hnT
	 lhxpXHeo9+mq253V5DsBeMNiXeqk7eARmEdCHAbi+klp6KLFa7UPm1f3sAOrwsMdI/
	 V0rVU8Na7B5bg==
Message-ID: <sashiko-outbox-221608@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 07/21] RDMA/mlx5: Require IB_QPT_DRIVER for
 the DC vendor QP types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-8-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-8-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> check_qp_type() checks the dct capability only for IB_QPT_DRIVER, but
> process_vendor_flags() turns any QP that carries a DC type flag into a
> DCI or DCT QP. A QP created as, for example, IB_QPT_RC with a DC flag
> thus becomes a DC QP without the capability check.
>=20
> Accept the DC type flags only on IB_QPT_DRIVER, the type userspace
> uses to create DC QPs.
>=20
> Fixes: 37518fa49f76 ("RDMA/mlx5: Process all vendor flags in one place")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D7

