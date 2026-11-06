Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947432;
	b=BUIZKgMbdioa1jsyB0rxOsb9Rur366vN0RDZ0wF0M57T48lJynPhtqagT5ndbJpXC+8L
	 u1IXljbCA9RJtpf2s49cTuPsb4KLUWnytkitlNKs3fa2b0EP7MraozssJHNvTHYpgqH6C
	 QiNcehsn4KP5naCNYleKwIpVy0fWQGqzxXvqljnI//pRbQ8p+krLO0NRPa29UXUb7a+iv
	 WLry/XMsloGS5pbE4vXRPpSnQwYhVq/WCXXsJwkfgtS/stJAmWltEoCIqhGx7FJOUa80R
	 OoXOUTzK5ky4Y05R7kZKllBbvY8QdT2jmW0NPUe62ggyKagytGrJVFYdaHrss3pcuKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JFOzyqeUkLPctxhWBoLyA8TYJY+ws3GNhlsC1HQMQQw=;
	b=LsGiKBXX/u+Ns7bNRhSDlNI2THIGWSTS0I0OQpzhNgRSPfSWPro+vcJYctboePWeKwQo
	 anAZoXUpaNFJvZMywksi/hGDop+6JdRVXFGl/7q2qkbe1W62xqMM28naUdFgZHftU4dfN
	 R8ld3Am2Em7Eske8Jt2Fmtvj+MZyu6IhuvD7e3+Jod7RhClys6CUKuMBYWpwV8uMFiomU
	 ijPNK1f7gkmE9TmqVRYOZ9USrKO2Zhi8+r6E3ReVXbDyGtiJEeFF8U0zSs3KOfp75MClY
	 Ov0Sd7nRK3IW29yS317STpWaS2rAyl1nT5gzzQymkUGqVVK88AiOCV6GRifu6QDs2hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5LCnmD7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391D1606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5LCnmD7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF211F0089F;
	Fri,  6 Nov 2026 06:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947432;
	bh=JFOzyqeUkLPctxhWBoLyA8TYJY+ws3GNhlsC1HQMQQw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=f5LCnmD7/Xf2ORT6nr0eECUELdxg+2xxXJBlN8Dxk+yrUTFvxqYsPFJUd4t/LIG61
	 kYRcUvwJVUAM73B9pPfjg6T2cLmlpDUYWatTj6OCS4krLn6qk4DsLuLWIP2ZrAQ53S
	 +lZvlzIygKooem1rZR2Z66S78wuMgcFdvUXstutZ0sJ/pQwV5RzCQtdr7n/6c7dYlL
	 Ewfmhf6BBer9ruaISuRWYJCQYhf9MQapvAZ6Ep7ohOySXrn87KOyTch1PFD/aDEo4h
	 4N5HhTzClwfAl3/Arek2vjLfNaMlX+/NZlRDJg8MMwTmRTE+CCTmIDj9ykVXNojEBN
	 3vebirY+/nfSA==
Message-ID: <sashiko-outbox-200924@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/23] dma-buf: Add dma_buf_mapping_map() returning a
 type-tagged mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-8-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-8-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> An importer that lists more than one mapping type cannot know which
> type-specific map function to call, because the exporter selects the
> type at map time. Create a generic entry point to determine the correct
> type.
>=20
> dma_buf_mapping_map() selects via dma_buf_mapping_select() and dispatches
> to a map op on struct dma_buf_mapping_type. That returns a struct
> dma_buf_mapping carrying the type, embedded in the type's own
> result struct. dma_buf_mapping_unmap() hands it back through the type's
> unmap op.
>=20
> To support existing SGT importers the SGT type implements both. Its
> result is struct dma_buf_sgt_mapping with the sg_table reachable through
> dma_buf_sgt_mapping_table(). The sgt map body is shared with the SGT
> type's map function which remains the entry point for importers listing
> only SGT.
>=20
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D8

