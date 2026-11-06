Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947428;
	b=JWrYHFPTnwM4Dz4RR8LmQFE+JX95VkPUN1vzkh+Un5wGaF2yfQ/G7kPS7I06B/zDHcTX
	 KMIVRnRFwZF+skSJQ/XGjP/GsIq4HYgWu6pecY93ornCaEphZCoFUsG7cwTBZXmrOQu+/
	 teP6dbR2bkOWmg1jwTnTc5OTAM7MaipPZ+UuTn35AgB9q6C3W1XA++miJBLQpIKHhSSOT
	 fqXeh1WnAMQW6PmOhb4pAOzR60kHF1kPeJmrul6X+jCFGbf9iznZFLwwNZAxZJYhsnJxp
	 BA9PD2SmJzccC8dQ1BQjHfnGRh1LANT2Kh49Ivz8RZVvj3ynnr6hgNK22n4YBj5Rfbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947428;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=x/Qur3pZ0LexHY8gUno44LB1nxf7fcxBV1yDgE0mfrs=;
	b=rV+9YqIS3t2QdmZxO/0vVMdPaBojHH50oSpgwmkx9h09+wmrZN3UR8M/weukKUYgaO5b
	 pv8nSrr0O7E0tWc3MZiyAGMoGQoz90xOt9L6BVOnZU81YgfKJRB8n94cnrhCs9vhkZeJm
	 T3rFh3YTCMnbfswzrjudl/wMhibY2q5ovRtdbP7qRHC89LnjxARO7hHS1zHaNtSLo3DJ4
	 goZy4y/2kwXFpyKmcwc6mZQ4u4kdrkOJKsRG3yu+O2QTUQNOXDeqKb8uWBEHNqCAtedzO
	 d/yiFnen5gOh++tTUMqVwAY1ofyrqdZlnUaW8bqIzz0djM4B8D7f/sJiDvdgN++zwyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5DKBS9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CA7606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5DKBS9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A511F008A1;
	Fri,  6 Nov 2026 06:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947428;
	bh=x/Qur3pZ0LexHY8gUno44LB1nxf7fcxBV1yDgE0mfrs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=S5DKBS9HNR3m4w0iz0kmACImCMIxfiryP67jgoJZJGleikoW+VgynnaCuc77VSy1U
	 GWiTk53yPRPqhnG3wosZJY2rcDuHw7BUMqaoiBPnwHoDa51OY19d5TJCJVgcZInllv
	 mShZ94rDgiB3tYc1bIxf8Q5P4iJXoemOmaDj3LrkwG1u21RRKFLPXViHHgUgp13Hma
	 w0MEXfZOlQbjFc1dd9nBytz0swhgu49PIF4pRREv/vIRTCJfqecRWeuynxVnNCSZLU
	 DDNfP40RAMCkKBg0RVhDgWamq6nkJTy3ROBlMa96joQlFkjnSwiGFOnYmPrjvP1jDv
	 dv8YQKe2/X1rA==
Message-ID: <sashiko-outbox-200918@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/23] dma-buf: Introduce DMA-buf mapping types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-2-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-2-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:48 +0000
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
> DMA-buf mapping types allow the importer and exporter to negotiate the
> format of the map/unmap to be used during the attachment.
>=20
> Currently DMA-buf only supports struct scatterlist as the attachment map
> operation.  This is not sufficient for all use cases as dma_addr_t is a
> very specific and limited type.
>=20
> With mapping types the importing driver can declare what it supports. For
> example:
>=20
> 	static const struct dma_buf_mapping_match imp_match[] =3D {
> 		DMA_BUF_IMAPPING_MY_DRIVER(...),
> 		DMA_BUF_IMAPPING_SGT(DMA_SGT_NO_P2P),
> [ ... ]
>    functions for map/unmap type operations with optimal type signatures.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Co-developed-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D2

