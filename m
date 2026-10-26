Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792998053;
	b=FVqqW+Tqy9pvbi3nwGut/kgVAR+QFG+yp89+8p1NRXseUu17FCv3xKlzL+DlCXs5pOsy
	 STPzM+dk/5zoJt5cRcqb3LVdOUe5NqSD2ezzSkcVYJR0f8aZ5X9QWXug1euP1Sk2lJnaj
	 RmUucYQuwKFQ6N163pEaGxZ0kqWiu7urPpr4nxkpAYm1Baf3NjQAqo1J6SLiXde+TmF/k
	 cVf3vk1gEq5bF8dS5HaTY2Iii5MmiZQkpavbnJB1xUasArbZnlOZO667aArn3jGp7M+3W
	 4F77LDv4lro9VIjmIHP3v6J8yYXxwEkzNfIUaOqiO7TFPogCLYqlDMUs3Ysj/bX4P6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792998053;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FsmZT+gCQl0KmxVyeZ7wpCtc98JDJcAt+HKP8P+hBS8=;
	b=t8LHVOVi3qjnsX6pCmhVWTYI62GqYTvcQ+CzWAB7uwWtfKo2D/JOQsg98044M5Xk+BKW
	 rdLe09lHcsLoOXBi+/NDbBGMLMn1VNgl5qyjOJRo7COcRXhE2vX01S0MRHBJ13CCRqv5j
	 K2yrpJ06vRj7qbms4lMSLCoxELJ4UGcyCEY/jiKx+aYgAAyK2D5opEVhiQaerFcBlp18a
	 JcES6rDBpUJ8i4LhDnjBc1xFmkKRIuSGTlWKP1aZ56KkZ4qgDHQy0fdI35SQGgZF3dEmC
	 VTf5fUP0mC+GXhETdAx7g8AsLNZ2ydC0vvZtAvIU5gDmXL3A9qggMSpA7iaV6NOsAyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PRfsaeMI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25586606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PRfsaeMI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883AD1F01825;
	Mon, 26 Oct 2026 07:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792998052;
	bh=FsmZT+gCQl0KmxVyeZ7wpCtc98JDJcAt+HKP8P+hBS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PRfsaeMIgORHbcTyctRFZ9felJkoRwEYqSmnibyedbSk0rb5H6ezhduHxSCQd5RRS
	 trLgciDbXdxotsXVwXpOnGjwrqN4AtTw5QsfYoi1XG4IYjInQ6c8gOLpzRDVCc7S5R
	 72BaSa9raBx2Zat7Ui/VncF3OacEkUEWJivne0J6HOuqseUV9+5nrNqc34J7nDRnox
	 a8Q8xN8k1WkStAgPfT5j2GehuhojTjX0zqiynH5JAvl3wCLTZaAPjXeUuvf8aanurA
	 oObAERJpsd3Zy46Zkz2MCqLQxiJnQl4WuJgYkK6XlZItsMH0frheevSUku2HDejShr
	 1AtqxO8d5aBlw==
Message-ID: <sashiko-outbox-184644@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/26] dma-buf: Introduce DMA-buf mapping types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-2-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-2-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:00:52 +0000
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
> 	struct dma_buf_mapping_match imp_match[] =3D {
> 		DMA_BUF_IMAPPING_MY_DRIVER(dev, ...),
> 		DMA_BUF_IMAPPING_SGT(dev, false),
> [ ... ]
>   attach->matches instead of stopping at the first match, so that the
>   exporter can choose among the mutually acceptable types later, at pin or
>   map time, rather than the core fixing one type at attach. - apopple ]
> Co-developed-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D1

