Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947440;
	b=iwAXMH2Q0RfQ4rNTKUiyx64wUinoTx02Qwxd/w4Ut/AuBKxlNF7V5wZfR2RU4qJ7SIvD
	 Bp1gg89j0ux5fiPZDHZGHVyvHQBus4qoXRiPdzeJNBAt/YKlN8ho7nYYZZzDGdCxrX9Vb
	 OQmHA9KHjcW+WKSiTX1aBH14cbA/Oyak1n9mUtlWZUvUAW7+qTza5+mXusAMsRgb1Mdh6
	 BzmEC0rFoi7+DenCl4bb0X3v29ijdHokZn8MMGHm5yGNZdhQO4dnm1tnOWUWlhH/uSvsV
	 BeAceNo5OirnaNLrKOFq2gVn4ahDLgI1ybwORGKPRFzdsH3A1ZIcpuyvbJ/n7ThjWBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947440;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IsjU68yua5gmwWqAiq2vL6mxPc1ZBJJ7DPQljNMra/4=;
	b=4YFsgfVF9IZDIfhDVLYKs7P57X3w6RbDqujjXnXpqkcTwGD1LXqUorpR1MRzgESXBuXv
	 yzXVDPwXDOUfl4s696r8gAiEsHQFG/ogyalAr1QKz9gTq6SVOBY1hs7GCEcIvRow+w55G
	 BiSXhY/RuEN4PWIJapwYn3bpWFHDHSluG9bM61TmdGbx/zLuBV0MWo8gnOwC++4Q1OJyL
	 Vgj8GxDQbtMZ6W66QkwWs1KwHuM/pcODZGEh7JDca1HWHoZtBKELQciObYvKBPmI1bMCQ
	 KheZm0qjVZR3vcfZdnnMMReWwBAkFOogzRF9y5fRYYcu6oQH5TeXK8SdusuIyxcoDhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f2Jur710;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94520606A32C
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f2Jur710
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545951F0089F;
	Fri,  6 Nov 2026 06:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947440;
	bh=IsjU68yua5gmwWqAiq2vL6mxPc1ZBJJ7DPQljNMra/4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=f2Jur710HWbkf1qlhuD8zy8M7akUnmwvwfPPdTfmcv9PradYOWcDp8298cetsCPh8
	 4GVHyHbRC6W1+G9TzQOuscNamRETKk7mPL8gPZFgztmic+25V01gA0AY4u0AcsDFMb
	 cQhs/3tBp6BxGJkIBqo0Wp61IWNeS4i4YExl2NNRLKbWXXjdgcZjoo/meg01AtBCPV
	 EIZli9RtmiM8aK5kV7SUS0pjDyf81HYwWylW0TVK2/VDTU2bMVGxfLzdg5LJRLGESe
	 JG0hx8EZKS9sHjScq1BxyHnYV160AIovTB6T+YMaTdO8r/XbYURjfx9Qwmni2nd68A
	 LI0hOoqa0XGaw==
Message-ID: <sashiko-outbox-200937@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/23] dma-buf: Remove unused SGT stuff from the
 common structures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-21-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-21-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:59 +0000
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
> Now that all exporters are converted these compatibility things can be
> removed:
>=20
> dma_buf_ops: map_dma_buf/unmap_dma_buf
>              Moved to dma_buf_mapping_sgt_exp_ops
>=20
> dma_buf_attachment: dev
> 		    Moved to the match set entry's sgt_data.importing_dma_device,
> 		    accessed via dma_buf_sgt_dma_device()
>=20
> dma_buf_attachment: peer2peer
> 		    Moved to the match set entry's sgt_data.exporter_requires_p2p,
>                     accessed via dma_buf_sgt_p2p_allowed()
>=20
> dma_buf_sgt_exp_compat_match: No compatibility exporters anymore
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D21

