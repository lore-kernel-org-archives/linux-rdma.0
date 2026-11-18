Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022025;
	b=jc7FWn8pCrj50INZPPPipKJ7sshqBSw5a36vagA5XNT39GOEQEMAKH0zcQTpM4DvLSwA
	 UOJCok/IznLmFir1LQlhqfc9oHBAaRYOYBfKJdVdRKfj96vYGavkuZkue78/ipXjGTCo+
	 pFMa0LjJ8Ja/QSDHnVlwo7ZyunR3oZxmhp+Lpp181oTSzWUX6/nRafp/JzTlLJgFHZKww
	 Fk8xd1P05sGSBRrjSGJi26yDZhcLgUgBNOuLEDa/z2qXaGV/MsgvJ6Uw86PoqXyoBXqpD
	 kXV75pbaY/O7MwaF8Kb7TN3lppwukgTa5leDL3qIdOnyYxaw6FmYAjw4wlpUdc5hjfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9KhA+2KjCTx8Rk3b538TWk9+4Rf67zr7QgW5b+WY1A4=;
	b=ZAvoz1lwPMQfINjIx6S55T5ukq7F6sH5caD3xKR8tNz/aQBAiFQ2JxJX2/bRYB0YTSIw
	 jceQlUUK526n98J4CVCg7JH2nucTo24FtEFWkJR+wANcv3apalqI2jPEtmAJBUB4VMPww
	 UP2R7zSFP89mjAh5gqn2xhXbFSFUuMFR1CjeCW9GtsN5L/79EdXO6Nzil1cpwpOaXrDWd
	 t1w7PotPPuENTfHBizKuV+GjyXjYTC18ppEJe6qPVkmMdIGDkHWic96/o+LP1tLd+X6Sj
	 /Tokz/Z/MIG9+NXRL7uSnjJ/8kKCHMMq3IKX5EBva/CMJ+S08tzKRdumLk/cnjELLCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBxMedWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A540F606A33B
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBxMedWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655081F000C5;
	Wed, 18 Nov 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022025;
	bh=9KhA+2KjCTx8Rk3b538TWk9+4Rf67zr7QgW5b+WY1A4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oBxMedWt+/wpTK2bklJYA3jwdp9SXF4xgEgrK1TD5CWDvSySRswvbUU+9iSJlL87A
	 hPDpHBAhnSvh4mN6MRMlV5lxbqlFF2DUu5XUxPd4eKXhn+kVwqPF000P7PLuBMQEkG
	 BfJLTF+5TJz+UiKAmzb7xTNrsM4AMNmypQVoXl110WW5kCJKqLqXK2CMq8UdeEZeKp
	 NT1ZfDXICDZvLtvHu+8Pq30VId7nzi7ff/2rDyj9I8ZIVK1OQK33YT+NHoJRyb4BtG
	 blG7mV3zpT62eyP4nidR4RW4bQuOWUhjUfuLbbGRt/vzHOfbN9bv9mDM3htgKEwqAd
	 kkCfN9WaQ9caQ==
Message-ID: <sashiko-outbox-221609@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 08/21] RDMA/core: Suppress kverbs_provider
 for adversarial_mode devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-9-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-9-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
> IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
> reports, its completions and the data it writes, so they must not use
> such a device.
>=20
> Add an adversarial_mode field to struct ib_device and clear
> kverbs_provider when it is set. add_client_context() then skips every
> client but uverbs, the only one that sets no_kverbs_req, so the kernel
> ULPs never bind to the device.
>=20
> The driver still implements the kverbs ops, as the uverbs path shares
> them, so kverbs_provider can't be cleared by the existing check of the
> mandatory ops.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D8

