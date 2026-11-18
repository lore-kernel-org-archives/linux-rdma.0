Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001864;
	b=N0+sI4vN25An8FcTZRGKWSMLIwvlo1YETWueuBP27RjH+8pVf7UFC5Ujgu8n7hg2zZPQ
	 Nhc9WyTBTw/0HUJZhO88KFawMjY2sIX6O/52pzXMhf+2+xyj7OV85ETnnwrgw/XHgHcqO
	 wDWFubpwkVekQC74XCWaOm2xZ3bfpA3UjxfMlljeF5a+Fw6lurZZKDyVe/fGEdUZH46+C
	 arXLvnGi/NyBC2D4dcnD5sMtVsG97axsHxaNuObIBkax+4aQSwv6YyTzwx06Vb5Yi4l8s
	 98H2swMJ1IYYAtcutpZIUBH4GcfKvhLtExGm1onJHvaaILxQfQ6sdOTIV/F+yd70mew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001864;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9vnK9wXNJiCNycBSX4UDh5j0MpH+AIXCFIb+myXP0iE=;
	b=HeJ25UD7XqGLhPLaO9YLhf2Lhd9Ouc1ZTU1Cx/lSXz3FJmMweRtTUYftUd7VQ+HUE5l9
	 RFMwamqxxGQNUYtVp0pKe8tL2sW2yQUY2zHJNIVcBD+4IjZxT5+5Hxzcux4fo4Z6HdoTp
	 xMi2VjBUeg72JpuZNBopuXViGkkTgmyeFI/vkK3dv8XthZvUol0O9IkOTEeTo5QSqgLRj
	 ldttvTcIBdfshtensjnGonzpgPBbfil+hsEuOcmtQj+A8M83o8BsNWnsevc5PDXaMqVoz
	 b3Sm2ArYnQRBPEZIrivONNUs6uht1Nzitts88cGmh3XNmktdtWo2COMCjofgo4eISVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnY7FU9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78834606A333
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnY7FU9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70561F000C4;
	Wed, 18 Nov 2026 11:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795001864;
	bh=9vnK9wXNJiCNycBSX4UDh5j0MpH+AIXCFIb+myXP0iE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OnY7FU9njWnCFBe8M8w3b8eBPIJ8fa3w0XXOI68ljpZLxmMiQHVEi8kkbcMg8fWHn
	 aKGmpzHDaY1djC7hTCIEOU9diayqLtz0S4wkjqBRgNNrRMN06JN7HsEp+vnOmRlC+1
	 pVp7kGmpv1X+UfsNpYVgevkW5Td8xnI2LiyWvxzODqhEo4p5FOx9Fi4Kz6DaISZVLR
	 Fk6wfe3VYXxBuWJRYz9E/7OzOrl+ipDj40prex2+w3UxcOK22h21WTkHEdpqbcBJGA
	 3tihukDzhMVfXV2X/kNQnbzDTkf4wZ/L9Xgb9dSSiRShvw2KfYHjnbM+RrvWuW+O39
	 lS4gG1hjwwkxA==
Message-ID: <sashiko-outbox-220832@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC 2/4] nvme: let transports provide the dma-buf attachment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anuj Gupta" <anuj20.g@samsung.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118103327.1788667-3-anuj20.g@samsung.com>
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
 <CGME20261118103453epcas5p38649877d029a06c4b519578f5cfccc4d@epcas5p3.samsung.com>
 <20261118103327.1788667-3-anuj20.g@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:37:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Nitesh Shetty <nj.shetty@samsung.com>
>=20
> dma-bufs are currently attached to ctrl->dev by nvme-core. This works
> for nvme-pci, but fabrics transports can use a different device for
> data DMA.
>=20
> Let transports create the attachment and pass it to nvme-core, which
> takes ownership of it. nvme-pci continues to attach to its PCI device.
>=20
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118103327.1788=
667-1-anuj20.g@samsung.com?part=3D2

