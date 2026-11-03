Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711827;
	b=BHoPfWh2wrJTcRA6Lcn5pQjCIpF8eDbXqo9uycmEk0pPcGRRl4MJ8fIVhzR1TapUl/DL
	 4ZP8CzdXnNefzY+xAurnKZoIcN+tYENQ74rWv/4yJwqkgMdxmhvNYfkrFCJxvTLiW4a3P
	 Je64asabPzoGUZVwGlD3mvkY/3A8v6DZaCzx3/2b3uBh+IxfCkgzkGScQPjXSOEKTIFNV
	 LPZWKf3dyhN868u95mGIVWNXEkuXkeeUnaQKTADwap+6joUAX64pZ1dOHN3+iGFX3mY4E
	 rsvM2jpgifNBMoQklRfRU5rjSMSJiHx/VwMDh1tVzA7xLyYU11XwQ31i+Z6moWT6P2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711827;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MkNXoCm/vxYNvCfUmA5T+AG7+TJWP3stUyJ3dI209kA=;
	b=omWFtYGoR0cmygFbc6BJvdmYpTeaU25Jr/Qv8DHcmTnjN2OovEJqviBv5ix/Q7MqDj8P
	 ayuxsfsh9vQobQAkzp2uTBJy2IQz4+7drswvXCEk+mygcPsy5Yb0tlha6VpFnW0OD4yFK
	 chF6llvrpLYTm+SYoVIh0GeZ0qCEc7fuCwhWOdD+NGaaQm1DbeoyPbref4j29P1RoXe1k
	 L1mFsXM4PXrv8z/78LEu2zFou7JVHzI2E+17t6uNagRVyc2reTyDuNZdxfBSnb7hA6e7A
	 laBu1MR7ZjAy8l5TY8p8yaeYhd5htFd+s53HkVHfTmH33gAVVZZAcYLj7sWJHQkb/OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0ZtTqXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ABC606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0ZtTqXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C571F000C1;
	Tue,  3 Nov 2026 13:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711827;
	bh=MkNXoCm/vxYNvCfUmA5T+AG7+TJWP3stUyJ3dI209kA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a0ZtTqXNsojY5S8A9g1s1oHHl8fNJDvwilddhVx0yHrmSAUsQQuTOBRp55DWFFWYQ
	 rvnI3jhHAa6kZ5ZpOqrm2nGA7mEWQ0IjeNwHTt1Yl9SI1OPEVdRHWBb2UmzlGPECIz
	 MGV4+O2aQll1GH42Ex4cDyH+1xIjxr8iCYRJVoXcR0jVUIF9EARFVVO+ioZhgWLN2p
	 rhDYi1M0MBNM6WrotKVl5QDInAi5y+n5WmqZM3zbsAbxoLDO8qLCM3NNAw7nB0lOuy
	 68EaXeTKsIY57smCj6otjRtFMid24c/n2bNXBGD0M8EmD9NvobTFwz6BmPHUhhn1TL
	 WPCTIGhCNK1aw==
Message-ID: <sashiko-outbox-195318@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 6/7] RDMA/zrdma: Add device probe and remove
 logic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-7-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-7-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:17:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Implement the auxiliary bus probe and remove functions, including device
> initialization, hardware resource setup, and IB device registration.
> This replaces the stub probe from the initial skeleton patch. The file
> is modified rather than deleted, so every commit of the series builds on
> its own.
>=20
> The device ops are installed right after ib_alloc_device(), so that the
> dealloc_driver hook is in place before any resource is taken. The hook
> releases the hardware resources and the address handle list lock, and it
> only destroys the lock when it was actually initialised. The pci device
> is owned by the PF driver, so the driver does not release it.
>=20
> The netdev is bound to the IB device and the DMA capable device is
> handed to the core before the device is registered, so that the port
> queries read the netdev the auxiliary device belongs to and the core
> does not have to fall back to the kernel virtual address of the
> scatterlists.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D6

