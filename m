Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404816;
	b=wIcMFCRbD8fKjd7AOXp0r0AMsXZy9rFNmpbe2NG01L3GfkIVDV3Ygn6B18O2K0kSrpvE
	 Y/EvfBHwWPoJ62FuTuKlEqnk8EL4c6Scv3OyyTb2vjF4L/D1aHDVGFzL0wLoH0qQL6LFA
	 SIb9xPy0isHjhMOGiqQZA1TbPOBmP0ygExV4I3c++Cm191dI3Jqt2Y5p1adskPfOCxHlD
	 zWFoCyA/w1WQUn7CUYSAT189wuaOOIBjFHcVUsqWwiD/Dc9CNEaTBb+xuQNsSIck4jnqM
	 Uh6ZXcP2dgiJEje0orS54OVYYvvNn/JWfACCxr8FfY12pqqDMbtxodT1atD5Si/v+Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DAsPpZ237m4bN94BfIoLWnTye3GIkrJfbAEa9MCqqEw=;
	b=gzN4aeEuYUy5w9J5/zb6xjZKPdtBAjJb02AAHFcQnGaWYBEn4FJy4BLqAyYgqgKXEJCy
	 3/8a/WSUlMWleHJCLFmqq0lbnaPX9JTG73zoMABeTwX7IMnMY8HaznKHlJGUT+i6cqum4
	 CW/hCR4naBitHV+lQqCZaIBVe3/uAa6m8HDUBdPqimI3wj9o+kT9dcn3NSJO/cvXuiDdo
	 Hgt94BtgQKhaDcUQxYtgX+x09T3KdhehQ029P5cZHMg8Zv03IZM/uun7hvVHvvpEMuQ2T
	 ZzwpEn0Rju6dGMVYfm1XAiNHkUe7tn//FcQpM0Hm7A6yj1y3R3ph0V/UlYT4+gUI0tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DTw8Ra5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222DC606A88D
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DTw8Ra5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0451F00A05;
	Wed, 11 Nov 2026 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404816;
	bh=DAsPpZ237m4bN94BfIoLWnTye3GIkrJfbAEa9MCqqEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DTw8Ra5w0p+XaNYDFj437KfqkfuWnXsNwjGoE73wYGefMrLmgw1KEJblVd6XVT9HK
	 LfYhqF+FewWuAIz9JQ+DZiOhiX5eiz7x7b9kDx6PtIcBZkSkiIL8kT8x2+xj4njAcf
	 N6Bn/I+j74Ibe01hU7rQQmBRUElVCotwbkV409ZLLex8lPaH6n63V6PCdQ+sQYMFDu
	 sUsH6DLdjcYMEiY21NhW3djm2y5r8xt2pX1P65S8oe9PX0N0zdF6vFZ/7ZA2H4zTqz
	 Y4LkLd0XUdzYAm7xqQwQG7WMMETRIFJrWblDRqY/g0xsv49Se9Cyuu5/iHOZxU/G3W
	 f/M6AEvfkft4A==
Message-ID: <sashiko-outbox-209103@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 18/24] RDMA/mlx5: Validate EQE port and GSI
 port before indexing devr.ports[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-19-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-19-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> devr.ports[] has 2 entries, but it is indexed by port numbers taken
> from the NIC, which adversarial mode does not trust.
>=20
> handle_port_change() uses the EQE port before any validation, so port 0
> wraps the index to UINT_MAX and a port above 2 overflows the array.
> mlx5_ib_create_gsi() gets a port already checked against phys_port_cnt,
> but that comes from the num_ports and num_vhca_ports FW caps, which may
> report more than 2 ports.
>=20
> Validate the port and bound it by ARRAY_SIZE() in both paths.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D18

