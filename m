Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947435;
	b=1/hIoJXMnplw7b9GLvqBjMsCD9JUjYUISatLbr9UTNp0pkT5V4mAVNrS+3UQZmXL0ctF
	 aYzZq1DAzTZ+A7lYw6qsq2v9LvkrzsgUms2EZ1NUctQ8DDg3i+aPd9H7FhMqIINkmMRMG
	 24zxHwzvsodAkPef9HuFp+4M1qK/V/7BHCl2kaLTe6Alg4PO6vYr0vqQ7yeX/OXPDWYza
	 Eee3Z7bK90RDxwv71CYeljRzDDukvZN8SfoF6zHPfcUQUSpZ5mgvc8E06VwAVAgAioERA
	 aXQ6XKD5D4JOOWMKT2RfGKXkdz79ID4WdvAufLyCwwh5i4x1CnFYzHU4X2l+D39qq6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947435;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3roW3t1g1Fu/X/bd1choeaUGmtqf3ekAVEKkgxwFyfI=;
	b=0oTrP9/Hnr0i/TuMqaBC7LzTl/dF8uHWmMqQZjDYFTYvJshCeU2kWXRkve4qrufJmlQm
	 6BMVL4vJY3i/euvCvWyutLmMzEx6AWkOW6+ayKHA/u/joofwR2mqb2HVck7OX8D3MJ/nT
	 9FnewE4EZpNtVzUZa3JqvgJQRmOuLeRuo0u7LjFRMjU1e2zLClX/trlB4Qsg8+5fXeXr/
	 Otlw98Gihie4N1Qkwjn8JafjsxhjJ/Rr1ByFuWHJuzRFm1AfQP3algIOI901LGpRXqqnU
	 9NkGukwsEoPP3kxiGo0aU4skjWaHlFQN2rN1PbFEIv4A8PkPKinHOiqcrFnv0sm6H8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibvGSxOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4C5606A32F
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibvGSxOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DC71F0089F;
	Fri,  6 Nov 2026 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947434;
	bh=3roW3t1g1Fu/X/bd1choeaUGmtqf3ekAVEKkgxwFyfI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ibvGSxOqxkowemRzjZamejFjKZsBaCuQb24uWVDYCOOJj0QLXkCMz1JUbsfpegKK4
	 MJX1LrHoLOpR3J73MYo4wx5JJDGhm1MEEtMnpcLi8exP/J2KZ+NHVDMKA83/xFbKmI
	 7nRWNXcQbxS1eheABXFzHK3SZ4osPe4LqRe/9dH1OUPmxXCt1TYgIB5UYlpIecx3cV
	 sRfISobvLJdaD/6Yunuv1ge9zShcaaMfXyT/EBcrzvPIFIc9t1K782OhZuZvLID8GI
	 xza6q+Y4xz8ys0h2gRZxvLH+JOSwrC4INyJDIo6YZNG3zR71z0cm4cST5rvpCz+n8V
	 0b0DG4HMJpIAg==
Message-ID: <sashiko-outbox-200928@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/23] drm/vmwgfx: Use match_mapping instead of dummy
 calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-12-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-12-78b8dc9ae80a@nvidia.com>
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
> vmwgfx is creating a DMA-buf that cannot be attached by providing
> always fail functions for dma_buf_ops.
>=20
> The attach/detach callbacks are already optional inside DMA-buf, but
> dma_buf_export() is checking for non-null map/unmap callbacks.
>=20
> Instead use the mapping type interface and provide an always fail
> match_mapping(). Remove the unused SGT and attach/detach functions, they
> can never be called if match_mapping() fails.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D12

