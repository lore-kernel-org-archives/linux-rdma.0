Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947434;
	b=q/RQGqLZGKZfTq5Azp1J74b1nIWsziFnRXF36WcgPYREF8j3Aq5jzd5Vgy0bKP7p3g07
	 EZfZPpP+/OL4PtZtmEMgcB8KYQo/b8mEd8BVbHsTWU1h/RZy+7RHgFWTZvtzl15hvR0OR
	 bQd7JzOw82sVO/3OBYOafmYgyu+0S8hrgs06JUmxLmVci663MfTgnD6XsISK+QrzwnfJY
	 Ctflm739duA5Ivst7KIZ5Nr4XBxb8mBQEMMB4MAjfYqJuV1oak6bHhRoHPPIRP7t6aHM1
	 meakCKPPYvYIp14mAkdXoSLtVGc77eSBMTDmXVn3iec+plxUAcYXSTVKHUXBejcI4dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947434;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+vAxIZ/lqmfUJRKrCBQ+aSMdj7gxOZr4SRhO2rjCPuU=;
	b=Fxe32e0nfPZYK2kxPo6uNZP3ZenExgwstZnQK5bRqF8fywb9ub0+shSUDsO47SMeYU2f
	 jp47KZIMWIlEAS7vR4/IRS8ViTH+NlaOd91/4ItNFAVSOeFz4ePwuvULjsdnQnP8zf7G6
	 V9cDW63NC+yuSnDigZmDk0qTL6Om/bgy1G5NqDhsnWfDtS8imCgDeQx4iObwZQsl74KyB
	 AVp7gqj4UrGeTQsSX2fGkmFSBLp4v2NS8soc9BhOanj9OckyPy6l9rzi+6fJ3irRD3CgD
	 ODO4hPwAeBewMdswfLd16RJfSkUZ80TxYe2cR2I0CxEGRZuXNqt+bHPmmsb/wI8Mq6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEeQpYY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B09606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEeQpYY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5331F008A1;
	Fri,  6 Nov 2026 06:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947434;
	bh=+vAxIZ/lqmfUJRKrCBQ+aSMdj7gxOZr4SRhO2rjCPuU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=QEeQpYY05hmyafIYkXaIF+k1SS3KywsLJMtce7/o7ochniltsNS2Du2vsoH+l8dIj
	 cSQ/NUvMmpxIbG37cgHJwe5ntrU5qF73GWzlR32sOngfGZ9e1kL26N6BQvznnCVgpY
	 mZMUFWQeCkvrBAIulj5nCIcDr2i4bwy33U9TSCtK2/lVcSHgNtKPBCKfJbTnI9bLgY
	 Urd17DRsh5gA8BVTqCXfpozgoClagc61k2BaLr7L4tBf+1QhBC1oLaOlyEtwiXAmzc
	 OTpzxWPNevvhVJEPtl9Ij7lOp6/yxR2xQbmAOnnyPK6ZhiG6VzW7BPZeZdUpWRz/j1
	 y5dDwcUOi5KIQ==
Message-ID: <sashiko-outbox-200927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/23] dma-buf: Convert all the simple exporters to
 use SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-11-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-11-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:53 +0000
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
> Update the exporters to use a SGT mapping type and the new style mapping
> type API. None of these exporters do anything with attach->peer2peer or
> importer_ops->allow_peer2peer and they all follow the same pattern.
>=20
> Change all the places that need to get the SGT's DMA device for DMA API
> use to use dma_buf_sgt_dma_device().
>=20
> This is all a mechanical change of moving the map_dma_buf/unmap_dma_buf
> into DMA_BUF_SIMPLE_SGT_EXP_MATCH() arguments and switching
> attach->dev to dma_buf_sgt_dma_device(attach).
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D11

