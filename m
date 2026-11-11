Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422437;
	b=FDVsXlNm40mJ7xL1IIfPBx5jTJ1C2VkvLeSzHauj+D6Y6mSuj4ppKmkg5/YuqxVYcCPf
	 NagJwr40Xh+foN8Pm85/dmwWLUXqnnDZrEGTWbBaiz8CfIGGnWouglkpTuygMd6Zr28jZ
	 SpLCivqaNy1zbIyZVuyOL8DbXsauCi9kCUuMbAwKMm8lo6cCLtx3E/Gtlnqm67wASYja0
	 Q9ZmYGpnx+kbbQNwCvxy3VoCw72vqwS6VQynh4FJGkYZ7RPBQ+48sA0iljFvHnDDroPS4
	 yNr1dfoX8TVBjy2zeQaqyMJnFUxd/WjEzVGpcB61nSEg/U8y1IbrmUkdU0UfaqRCGCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422437;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BNLrVdcBMNE5menTTeToxAHQjAY7/wYrhx7xl/3KwoM=;
	b=NaPsiKiYNCwd9eHec0ZOOu9QCQVjZB0IGxM0zPquA54aq1Dr4S/uNqmRXVSjRuLyz1EV
	 N4cMcyd0BDurtih5TH9NGnGr5tldC3uIaWSWqEinL9aXfwJ4EhzhIeiAL2r5rf2Sr6IAs
	 FkHYDcBvXEYkvFTCVE5TNB9hgt+Yw0yIcFNCq0rywmS4nzHxzI1dkpBJMz8ypfVc4jYRX
	 anVCxY5Fm574uJ3V+ssYLmeKiU2zvTNLdpQ89RidlAvLpZA37qTWGVzNTTJ85R/zAcT9I
	 iIn4OYiSnfGydfltfT0YpKz/ICkJa0TSZ8Ghce6to00n9J3FlS0n/AxesdtroXO7K6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WvbtvR/w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED8606A335
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WvbtvR/w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1501F00A05;
	Wed, 11 Nov 2026 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422436;
	bh=BNLrVdcBMNE5menTTeToxAHQjAY7/wYrhx7xl/3KwoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WvbtvR/wLGAXwtWQkAMDZKiFgXnPBuaCPQSAeb1BPq5KJqBxcC+alMREnBRfnsW3S
	 A785ynIFrcTXRP6mL/0sruMeP9/luOQvOwMpMWpau2lEx609/BjEZCYH60x8UWbI4+
	 EyTPJ+IZoYSlaFVGLsgFQOC3G3Gjt/FLE+/hu7xDimZWaZVz02z9VSOvE/v6mf7CFH
	 cMTO1DSILuVFy9WjJlN+7FpDNGgFXIJKQ60Z7VmxAaT47Rjfxjxt3jDTPelTvaIu08
	 DWVyC76aD0xvvOBa4OnyY2MNeUgJZqVgsGFdkIBj7sZCVRsAbNjB7HqDHWSxRni7XG
	 tFG3lVk8LiDzA==
Message-ID: <sashiko-outbox-209477@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 09/13] net/mlx5e: Use the correct DMA dev
 when data_direct is enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-10-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-10-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> When the data_direct private flag is enabled, return the data direct
> device instead of the NIC PF PCI device in .ndo_queue_get_dma_dev.
>=20
> The memory provider maps the payload buffers against that device, so
> the page_pool of a data direct RQ has to use it as well. Add
> mlx5e_get_dma_dev() which returns the DMA device of an mlx5_core_dev for
> either mode and use it in both places.
>=20
> Running .ndo_queue_get_dma_dev while the data direct device is going
> away returns NULL because the device pointer is already cleared.
> Opening a data direct RQ fails with -ENODEV for the same reason.
>=20
> Leased queues are not supported in data-direct mode because there is
> currently no mechanism to revoke leased queues from the leaser.
>=20
> Rename the dev argument to netdev because there are too many confusing
> "dev"-based names in this function.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D9

