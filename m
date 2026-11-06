Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947438;
	b=gp55CpQwH3xoyHX1dMyDWXQxhcnRTe0e9UWNs7crujXRX9FWK49vwrfE9Q8Hy8c2Iksl
	 mavIdixKs9BTF90ENzrVEfCyDfi8Y8iO5WVKy0yNCLkZnHzz1WfSkFvr/BSfL0Tiioc03
	 eWiGTHhGdfGDbejeTqTSVJ/+gshZiIbgV0BRfvTmMQ/BpKkuKIB2JuyCFosI44S/vfxzJ
	 4wx/QyxfIk5X55qwzrDDjf/fZwulgC9jPk0FZQBaIfK5qSPYx8nOYa4Ufk/eyQ+rvSReS
	 xml3Jm8upIJz/cf0mt082cBM0MjbfgbkXuHnGD2ohwc4qHUhBoeOpJVuaxto8db/mpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947438;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a5vxMfp45ZKx8vu9IoJ/aE2rVPDdeaklq/UuOQVIkew=;
	b=QFCgS7ZCX051VMTDjU6WgVNuclFu3f5/VUHMQbbwm5Vo/iK+pFVa/5kqTrZ0QSB/G2s5
	 prVGPgFebHD56zjmm7+osYxwNHqOEEjQLQ+lfk40s+GrU6AkJpGoNi3ZDeyknZdSYj0Dr
	 qizaVrXHmgCAbXHux+Jqo3m2cjsPtzX2kM8U5m1ZuLnb71qcxc/YYgtBawoAhZZQeFhzF
	 TLLeAdcWGlf4RaHu97Necw2qNQIgj/GBZOJ+eFpblkUzuP2otZOnmVLqVpcXn5kGxRvsM
	 rxpkZBdJ+aHL7JPo3uMjpmf4eWZVDJwDzrRG7Poh+PqO4FF0c9Uut4zDse29xs0G26Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RUHrX3sp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9835C606A32C
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RUHrX3sp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5069B1F008A2;
	Fri,  6 Nov 2026 06:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947438;
	bh=a5vxMfp45ZKx8vu9IoJ/aE2rVPDdeaklq/UuOQVIkew=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RUHrX3spVPPixYweR9FP0lGBGoieWOa6UTBk8hAFu6dth1qva/ut9CoCDM5A776Tr
	 Np7rgWUtdHel2dckbpO+ge0L8ZexFY7RST6Dxd1tvm/9N8CX1+JOGT2TzdPYE0HNBg
	 AaumF/6A6+mjXM30lBpdNZzji8O5rQgg7v0qdv7KIbuJUJHcAf3B9UauUhyL4sZP+i
	 rhzR32APB2dTyhDj6x/2gMaRdacLn+tbkqJW2NlIa4MnWEmUC8jL7SGlrTJtZLl/qI
	 LEF4o6OoxeKMR/USpIgruRe98uNab31+iv9/AYwi66c4CxyMwYP+EibjeOCwhfW0gd
	 VvCsZZUMKFgyg==
Message-ID: <sashiko-outbox-200934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/23] dma-buf: Update dma_buf_phys_vec_to_sgt() to
 use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-18-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-18-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:57 +0000
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
> These helpers only work when matched to a SGT mapping type, call
> dma_buf_sgt_dma_device() to get the DMA device.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D18

