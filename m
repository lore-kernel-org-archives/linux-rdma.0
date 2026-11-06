Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947436;
	b=Z9gmaiYtfZ/rARxNIM0PzVOI0BkJx6rM+hvQWG15qiDKYyM8aNTu2PQYldlNrKztCfHr
	 klSVoTEvievy/E7quX7IVXIafJSrJz45XZ/hD67Y0tmWXgcfeBstDZNl7AiXSLSyxtGGQ
	 JqqrNaDY8JM49ynivdQEJ8UImolaTKwlvsGoI+czhugQGf0PeijADwIfmnoQGMS3ZoX+r
	 p3h7rUcjDoJyK3s7yKmUqkIwi/sKEa5TAZFJfuytU655M7/pBo7z6En0mPCODUJM3Jfvd
	 OZWLhfLswIXS+fYy1jj2oJFHpRCHmjlAihiQTvoHidJM3tbX973Vj7cOOtmWL5oC3kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947436;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/eKRQv541JhaHN/nOwagDfXo74KG/VcEeaIZEwenKbs=;
	b=1QKjX4dmZXdVQTfghkRniDy+vYzOD5bKzLlJ5icx2e2bDucyadBIm/9yK4SXrXLtxW7z
	 mmr6E7Q8Tk6rqYQiemMwLAic2gB8scekdYYd09v/KGgc0Bndhd/AGt9C09avL62Bysu30
	 JhHxQZGY2Y1dHPD2lpMpHBX43+0cQGKUje4XuwkjYNYHS9cinemVdplROB9IKkshHyW5z
	 dLTSvUr4T7aK24APhFlYFTkDJkIp05ppSkScm3/LyEQgQ5DyvV/Ff3ynmxUt57g51Kh4W
	 uL8dqwMpD+RgnSheHgyeTZAj6gylMlou7ekP/iqAMxJpdlQJ5SjCc6piTsoaUHVx+Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1rpAUe3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D846606A32D
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1rpAUe3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB011F008A1;
	Fri,  6 Nov 2026 06:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947436;
	bh=/eKRQv541JhaHN/nOwagDfXo74KG/VcEeaIZEwenKbs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=h1rpAUe3DAuN5L34ab6wnxESAY6+F89xyaiIBvTh2L0hc7lj5YhatbRyd6dTGRqjA
	 LoYyI1+JvhN2hub5xvQerEj/deGfrdSBJnH0GTt9cpLxJDJRvXoJ71Obkkiq5SGq8h
	 pGMFUMtJBNJ2ufyS+O0GnnRTtnN6QPCQTaXkG/1D0Hdr/tJDjaPK6wit07DxewbLva
	 8Cy8tGwefuN1XPLnn9GeKjnk0ycOHcPEDcu5UbQCFJWlmN9uL9NRMMBa++hpfB5vv2
	 AikaWy7wjEU6ulsRekZz5EQdX/NzM51SQ45H4D02Cp37XWN/Mmmn6DmFVP4dZdbFek
	 HfNftjx/umRXQ==
Message-ID: <sashiko-outbox-200931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/23] drm/amdgpu: Use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-15-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-15-78b8dc9ae80a@nvidia.com>
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
> Similar to xe, amdgpu wants to check pci_p2pdma_distance(), and
> only needs that if peer2peer can be supported by the GPU. It can migrate =
to
> system memory and support non-p2p DMA as well.
>=20
> Further it supports a private non-PCI XGMI path. For now hack this on top
> of a SGT type, but eventually this is likely better off as its own mapping
> type.
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
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D15

