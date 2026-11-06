Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947430;
	b=3S6HsYfgxQrX3mVq1m9Vtrm31IfFCySqCRnDwGFb7i27uOVVeZCyMmXcnqL6Agsd3AKQ
	 eLCVqEMJu0b7IDFde1z+wzusOR6fsEobBeo0L/o0/WVQOUSwo1HiAkGFsrovPVz4cBBFN
	 yh2jHt7b7ZDFrpTjynyBtbugKQwsFppC3q7b9AlYGp3G+PJu/Q9tDxcTQ85Ailc5D8Gbg
	 kqkfwS64Miw79ToiHq9047O8fOn3VPjpgoNy6G8kL5hU5imcJteYRQRYZdSComx9+X0mf
	 aqyUfdW/pTliuHlVWpyoUQgCsxm7AIKRABqso4qNZ6ghBKhGZFJ95B+hoS30pJYTraw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947430;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Lgzy2HMC6wjmdYvXSnsRsoqRXRd2d7aei4BZIaIfCKg=;
	b=xdEmnbU7FE5KuODgiGGJ0qAEF20AiiTh+cZw9+Qdwvu+19M11ryWen7DcXSlV+L0iAQ+
	 2q2cHMG2KJuPnTOwm6A3ahIbtKKIhQ1wbkb+KEQkK1ImS9J7iklK3i2Rea8aRDkGVVofz
	 ioDoh5ZIIg2N1PluGLLj2noSVsvpH2Xuxa69gF+u1fCGU99Viy4HtxhHYOcmxRM0DPWli
	 W1VJ6dhnQTrbehFloNg5HAPxKN5uIZ3Nr27AXHq+LzAWz0bAQMPeUrhnCvMMKdLyRbQRV
	 ZYL/buwKh9BJXzxw2OCjee04dubSXsMyqwzhspT9rg7PfMHztt8GXccvVVU7n0DLOrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZbVcEvFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D859C606A331
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZbVcEvFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804301F008A2;
	Fri,  6 Nov 2026 06:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947429;
	bh=Lgzy2HMC6wjmdYvXSnsRsoqRXRd2d7aei4BZIaIfCKg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ZbVcEvFQ/v7RxJTETNSrzlyiZ4mVghaCfzIjmKyVvVkT3FUTNyQjYydGbTbXByNe8
	 X2f47B84azZ5sTwF+5cUrlANTYmXz3UqFF9b+fzV0Bin3IDtWjNsBYzlKaL6CtWS3f
	 HVonJ1NF0cwc6EQs7fQGsY6NWRMPNYgiEishDsQ0xEDxTKzMMfjlcfvyi1BO62oa1+
	 UHbeAF2nOtuCDOHqKZNAEDZI8HHNOyjrqO0PBk2E5K/tbzXAx2r0tVcy9bR0lgasDN
	 qmiWEGThL5lgsXzxyS/EBJrSejVczNN/+f33zejqfDiZ+TmsdLfnE+eq4uIjrv70y/
	 Bd2u09974tHig==
Message-ID: <sashiko-outbox-200920@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/23] dma-buf: Negotiate the mapping type in
 dma_buf_dynamic_attach()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-4-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-4-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Let the importer tell the exporter which mapping types it supports when
> it attaches. A new optional dma_buf_attach_ops->supported_mapping_types
> table lists the importer's DMA_BUF_IMAPPING_*() entries, most preferred
> first. The entries carry no device so the table is static and shared by
> all of the importer's attachments; the device passed to
> dma_buf_dynamic_attach() is handed to the mapping types through the match
> arguments. Importers that do not provide a table, which includes every
> dma_buf_attach() caller, support only the SGT type with P2P according to
> allow_peer2peer, exactly as today.
>=20
> dma_buf_dynamic_attach() checks if the exporter is mapping aware and calls
> its ops->match_mapping() function to pick up the exporter match list and
> call dma_buf_match_mapping().
>=20
> If unaware it will use dma_buf_sgt_exp_compat_match as a compatibility
> [ ... ]
> declare two
> SGT exporters with different map/unmap functions.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D4

