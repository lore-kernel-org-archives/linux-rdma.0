Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316264;
	b=xWCjRvUrm0lSB6Tx+QJ8RDoehLlmHFqyePabm4CDwi7lPlq7waDkM9JVLjT4XxxWvjd2
	 eBA+SnY1euYVN0vsZeM6InIGs3Lq0NzWfZBZ9RecowZwtjx4nFMLA/Wkw8KzHctHqI64z
	 WAeMJtAr2ij0ZcEu+VK3GO0v0Kk3rP59s0KhNoYYb02aPvMt2oHLt/E9M3Cb8EmUejquj
	 r+oKyfhL+C3MGvENpUFLvTbqM1pubrRWl0uMmWheUcuj7tmKwVNw0cZDsb0ggX27wO2J/
	 3MWhAGUqjcdhw1HzoIegGdoT7MXLKdKyw1hmlpABD3AGWPJPEmLQfHvz8YuvoXO/uog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316264;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LH8GraQpY/6MLRw2/QfUwT8j5Is+krJYkuTOl7nPk0c=;
	b=yZNETylB7MsxSENMMrQALek5GoDsqjcls2VRU9JI4NfKa738fsdJbgQ9JnPctYWGwQGa
	 Q2taIV88za85D+GF1tt7xf619dfEAtiidrZ6hfDxF2XRPDtPU8WOcpQXvMLSnu44jDBgi
	 0o6vPcb8VIxhf57WTmIcuy/mLUIs2+K4Vh2T5dj0J/i+3QfDkf7tmnTWiFIHw+HoJf4Cy
	 xdOHWZ0sbvuL5P342RzkG1QWna5TVETrTi1ld0PQ+fYtd1sRdFkuGO6ZkBDOA9Q5gmdXh
	 s4FTws2v/ToX6Wol70rPDcbMfwHOEgm3Ix2lu+xlc1LlEz+8mpI9TyLu9KmqZGSPo0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kk0bLxXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FC606A334
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kk0bLxXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E551F0089F;
	Tue, 10 Nov 2026 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316264;
	bh=LH8GraQpY/6MLRw2/QfUwT8j5Is+krJYkuTOl7nPk0c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kk0bLxXCdJ6TYf1tFzsJuGY8m/TuwshRmxMYaZnQResdA+TonbnhlZ6+tnO17bW1e
	 GBVwM4s8ATneFjSWvw7sAMV0DffCbTm1+6GBQ3ArtZvCWEz2mnqAo+GOq0wAxzUcIp
	 KInGB8rjCsh+/Hc1ZjZ5zkLObgDTcKJwsVY672S8LXe2mXwp5h7lk1KLtLywzzyYhu
	 c7MhW/8+xBMbJ1kN0Oyay/NlW+wp+/1kuhCYRi2A67xnb76aHj2kopAwK6MS2DmGXn
	 H3uMTQdukYXQfZHKi3msGt8x3HNdgwnbMTiwoUbBCRA4mqin8UeOhkRFE4Wv04CizH
	 3zRCL2MSpcWQQ==
Message-ID: <sashiko-outbox-207096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 07/10] selftests: forwarding: tc_flower: test
 the enc_key_id mask
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-8-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-8-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A filter on a block of tunnel keys must match a key inside the block and
> no key outside it. It must also dump its mask. A second filter proves that
> the frame outside the block reaches the device.
>=20
> When tc does not know the mask or a device refuses it under skip_sw, the
> test only logs this. Reporting a skip would turn the exit status of the
> whole script into a skip.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D7

