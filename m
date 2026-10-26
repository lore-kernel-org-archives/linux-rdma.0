Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006787;
	b=aml210jp3b41WaXtl6wKe0pNRZFeaBiu7/TDTRkEL6zMwEjS68CM+0Y18USm0XhMS8j9
	 WSbp2lLLos8DScMQZ+WhjWCEzpKWXTsXOEg8qwkazbH2VAetpxoiyNXJNzHIpQ+InnlVg
	 syj/RTpRWLGVghZI0eWP8ZTML+tjIuykfAixZNODQRP0lB2i51iz/ODn5PXHRrV33VPAY
	 pTazTv3LQuRQCIRRHb8ERo83wIUDrxdy4HWYnx7MhmGNx2okNXULBtDr2J8YJ0H9Dd2CU
	 Ui/BZyg49gr4dus3LwOH+nhD2cgGum1M/8FMCa8RgIjQGzpG4midr9fsP9KhMCRF2VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006787;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rvg1pkvDlDsKYuhGivy3MtCMo/mKk4tbR7Wv7D9m1z8=;
	b=4tXxTYyxWvszz/LzEHTtY9be2Z/W+54z97Gp0tXZ/eU0/HIehIkfQFVUccrAoQu5XfWR
	 sovWw1ynGlrKvva4hxOoO87BgFWhoMVaLGZ8F7hJ3hEmQZAy01/8DcYJY29nXHZFHNIE6
	 ukgZ+CjuHZ4kC7j8x5QoQ1S8jirO9ATnHdmOZzunDwFLAAd3K+1CRaHeSeiCVG+0+qaDb
	 O38JNQG4tmyVk7SLbalAZ0zPIOedn5wiPZLtdolOI+x5qlyTf6ZkjZTai5PZ+SXsQYI2h
	 qSMX934G/0lMHDyr9CbgsbdDFJD4m4RhLWZKyZYZGrJW+llvGVcr/gv+5FhyqCqUPFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNLdHcV8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7B7606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNLdHcV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C471F031E1;
	Mon, 26 Oct 2026 09:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793006787;
	bh=rvg1pkvDlDsKYuhGivy3MtCMo/mKk4tbR7Wv7D9m1z8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hNLdHcV8Vgt3/PNSaynrmuKqkQF/wl/LlQibSxkwLB2zy0RXQ//ynqJPsSIrkV80m
	 K9FgqPQo/CBkg2iBSdSSwAzHTs3wjaET9Zn0QZIV6M79zidI1yRdAQYL7kKfvILa1W
	 bMK3wkX0P8ksedQeb/qSF9OphcuVMyFjxxmH+KIvxF91loOpWXVaqFpjhCH6NTu5h9
	 aS2SANwjCW8rczljjmxaaWEgEmY9619299wBn0pbaVaRz5m3Jvq0yDPbCy6KidHvRw
	 ojclozHKDnCxAOIt1JKgRgpRXtc2KRUx/LzHWs1xygWsWAsriCE6B/EwGEw0P17rwZ
	 w2TTsvn/11UEw==
Message-ID: <sashiko-outbox-184784@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/26] dma-buf: Update dma_buf_phys_vec_to_sgt() to use
 the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-18-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-18-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:26:26 +0000
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D17

