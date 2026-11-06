Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947436;
	b=dwulrx/T5INovIyPWG3YBHPpZgkxmW2KZJYYu84OjlKVWvQmh1vX7PObWNQCYVm5BFcx
	 C4rWO4JfShqYMHxJ8DS7kyBkq5q+uBwdlwn1IMZaFn7uehvYVD99/A6JxENGcoFcqcj3V
	 ooh+y+YyulKedGnkNJ8TJ7bGdQBopI5Qrmf8fHKaML5HQ77o+7/ZpV5Id/DrggDFGDKCu
	 Su90UNj46wcOg/RCszLdExJSk6tJ5tIAjxeoLws9usPI5Yr8laeRQJEaIQ8Sed3k0T4pK
	 rGOV5VGbKsatpN5y5Q4agYWYmmXnCSiCelU5jPcwEojyzuhISzL+UaU0Uwoavx0MqcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947436;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/6pnXc+aZz25S5tfIEsZ26QWYs39prOigCuf2bCNtCs=;
	b=Jg5RZjF4gt2KK5cBNg/db+PSt2jRwxmje1sYuDK0kbeLvXoZrvhOO4Ym4n+z4y/r5p0r
	 nYjfJUkotncBVmvLqT+Abitg0pPvI7Yh8qDmFvYleYo9lMssg5LxW3qjVBIvbPjsvg7B/
	 ZDF30KIAFt4lkQTL8JCGzsoeC44UDBFZHcbJoQsK4mjFKj77sklhOzrb/Qpu6prY5v++D
	 SUIioyyrFT7Mx14wigxzVeOBXcROjddRPF/PQaRQja2Ot5Mpn1UZyNll9k00FzeGewLhE
	 DWKrqhsWz3QuJk+SeaSwtqAYDAL+faLaDZ4NEuwxh7qYA+VUSlCWhdToZIHTpUswPTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDczlPp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39176606A33B
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDczlPp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D2B1F0089F;
	Fri,  6 Nov 2026 06:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947435;
	bh=/6pnXc+aZz25S5tfIEsZ26QWYs39prOigCuf2bCNtCs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ZDczlPp7PfhLOvqZIZ/kzWDWTqiEs8t/mZkOdsKm9M4sVJATd6BDUW2ToS2yvAYea
	 CzJugVGl2szrRyeFOlEVm1BagVMEmbPfAGknMaJQjVLNNO0s1LYGVuEHCG5Dopcpke
	 e6gtkY0D4Tau8UKtxfnJk2LfPSPFe1Fm/yGJjFUm3jg+PHzrwTfymaplhZ1e11iItB
	 wh5UaUHqjb3ddTAkIILVqz0IpwF7ruXJmdr62jNcui0OXK1rOe0jSlyFIvzCQBBpbT
	 3oE98tTfyu/Fa2iNeq3XRTWbHHLZSU1W7Y/Tl0nmWbxfHjTPTZLx8qRfcfeFtHrXVT
	 0JgFqjg2uxj6Q==
Message-ID: <sashiko-outbox-200930@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/23] drm/xe/dma-buf: Use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-14-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-14-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Like habana, xe wants to check pci_p2pdma_distance(), but unlike
> habana, it can migrate to system memory and support non-p2p DMAs as well.
>=20
> Add two exporter SGT mapping types, one that matches P2P and one that
> matches all of the non-p2p. The pin and map code will force migrate if
> the non-p2p one is matched.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D14

