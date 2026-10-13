Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891C851357C;
	Tue, 13 Oct 2026 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902856; cv=none; b=biMGoiE6HMduw1WTeyngFaCHRNpvhGfxxz/rP3nIPR6xjwePwem0Y/m8Y2FL2R4Opz39F+zlZC5VC2Vo6yuWWacfb26DGrudEPmeTwS671xwWPPCiYjfxPiNw5fsJcZuGPapG9KJGmMYZAcOequwMgjSEZLFxt2QPVfi+ilbEF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902856; c=relaxed/simple;
	bh=8ph/ZkO/PENyEYhLmNmqH7BtX1XUHzcpqcSky2TDuXg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XE0Trr0goHsQdW8qGyTgKEdvempJsQ8ztYGfw5bGXaComQeEY3iLuj8iRKw3WMmrWHj1uxjvAQRCkUChq9INdu3ZXRelspkWDeywnT/J+7Iwg9B24NuLPxoeTy2abO5AT8PVXqjbp36Y6OQINBjsXmdXHg9G+7ORsdXFkW0HgCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqNYf7ht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqNYf7ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B331F000FF;
	Tue, 13 Oct 2026 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902855;
	bh=8ph/ZkO/PENyEYhLmNmqH7BtX1XUHzcpqcSky2TDuXg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RqNYf7hteDmsSKlZhSWhYwR4qp7rRdtoZ8n2rDO5xR7CRpbQ3TJHeFsx9lbpA04yR
	 jNeAxDzdGjF8yrmlmRirXyuxVDhTDPNwzvaRlhAw9AP5CpIfdY3FNwuDTcmvzxfU5B
	 6DTZn+a/4t6x4QT9JIJLZdcxi/ItNTzBQZn5RXKR9LR4++DUhHy9pKMEKXKN3QT8zj
	 wavkMJgh4RvYVZi/86Xg73QqPbf47ZQMPZbbjO1JrL0J45bDeWDt24L6E3TQ/sgIIW
	 wqVCUPl8HJo2tFQyVgadWNZLhh43eLODB2YeIjs6b8j/a59crUz/EOMyyOQbxemIiP
	 4UYi+ipyB48FQ==
Message-ID: <sashiko-outbox-169936@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 19/19] PCI/P2PDMA: Test the routing of clients with
 ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-19-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-19-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:47:34 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A client that enables ATS for the whole device must never be handed a
> bus address, and Translation Blocking must reject its peer-to-peer
> traffic even when the caller asks for the default class. That has to
> hold for answers taken from the cache as well.
>=20
> Cover those on the fabricated fabric, together with a client that
> declared per-mapping ATS keeping the per-class answers and a client
> without ATS answering for the Untranslated Requests it will issue.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D19

