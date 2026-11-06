Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947435;
	b=acAO26lbvGmvXXwod6odGE3n1k6z5PBB89u1hIwWA1KPzDUfuTegdi/trLBWghznmKJV
	 IZ764Qmgf8C+3QJXq3TlEqkEpfAA81j5lbkyUw9U+77SbuC3AkwUTcGshAKGdRtcmZBVD
	 J2yk2ByArcpJbuHwhY2vWhoYuZgpox9VFIOA7EfBg6nueVG+yXKPnhS2nlVSlwoNKu3px
	 vq06o9DfpF/QEY7oKeiEAPLYKi6N63EqHo+xp1/e1AoXkxPV5bSoXWkgvCanfL0JWqkP7
	 bTZDyYEnA4sKC5tMi2FP6jjrvx43RYJtsqn9jdONjpnxovxpiGOb3XEYaWi45EvMF0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947435;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iMfs5dHI0OWlKFX+e26Ch5iEc6OfZ6tcSO3QTKHBdzY=;
	b=cNRQ7p3YxgRgB4yD31PalgJ5OLBtg9ODqBDbUB6CjafOfNYinxrV7WH1PLTJXDgNLZ1L
	 xOKpFw8lKjGcXnnSPWWk7P6mmHRtiRHUPnZC4LnNj7MFSbglRhjxL8XQTr2dERvIs62Qi
	 J+Md90dG2sDd/7KKYPGZEYoV7Rmu1ZwPyPW+UfSbzrcPF2HMYMkLTQxe3UeElgTcAopss
	 4YJRVlIdRSKJ5r7NVAPncSgMiqzaTLgY4a+bxa1113dbaYUlxmCUBYIHUy9E6rsLGu6fk
	 habBfJLJuMz+Jj4answtj+fQtwFdZM4bVg3rMCV8vOYufZxaFHEF44Fk+mMMYzhTinw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXuzyw8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AB2606A335
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXuzyw8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AE41F008A2;
	Fri,  6 Nov 2026 06:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947435;
	bh=iMfs5dHI0OWlKFX+e26Ch5iEc6OfZ6tcSO3QTKHBdzY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=WXuzyw8org/yjEYu6pjxkYnWJ3nxVueQOBzVZHA2refuI3tuQ4wBgrIG9a72URTea
	 aljo0+rUXUy7n27YXOsPlv90eggiuqV5bv80S7xZgWp2xtOYIm/3F1J96MLnoIjVQn
	 BpC6h7jGeRdd69fYeZBDANjbvH3Jh39r4/1OEnaI/IV1PIPzT3GeByu9dLpKH90pIK
	 g9B5MNQg7vybSEpdq4BVX6JSForI4sVdTL4eWBvGUuWWhINBHhTJ8KLTxFVsUfniKX
	 FNuGCPB5acORxrK4cp8+QIqF85v+HqFJvZS8n8mDSjWhyiZ2AlxQDfTVEoNqJP+ra3
	 agpiZEEQVPqrw==
Message-ID: <sashiko-outbox-200929@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/23] accel/habanalabs: Use the SGT_P2P mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-13-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-13-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:54 +0000
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
> habana has special code to check pci_p2pdma_distance() and rejects any
> importer that cannot do P2P DMA to its MMIO.
>=20
> Convert this directly to a SGT_P2P match which does the same check
> inside the matching logic.
>=20
> Someday this should be converted to use dma_buf_phys_vec_to_sgt() which
> does the P2P checking correctly, for both direct and IOMMU based cases,
> instead of this hack.
>=20
> Remove the now empty attach function.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D13

