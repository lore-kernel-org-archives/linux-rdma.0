Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947434;
	b=YLafjPpIxF6YoEru9QZJ52zMRXolE2D8jzC7Nj0khREArqMTut2z9NlTF7h398pKsysm
	 bn3kjGniq8Lg4vzelLQ0bTAuVQzkIY3YbBttsUMh3+Gvk/acxxzAIE1eUoUSazNkoG8ix
	 SB2LqerD5ljdEfUSrFCJUBln3K9MIBmh0ozXio8dvpPG4payXH0gc5uSDUjGB0NRltv77
	 Xsdp2vJe4adkNjrHzcH5kG+p38sI+LmWpV7S3QlWgOHKF5FK3qdXYJZ1dYGPWPoS4tOko
	 uFFz/BGT0AYc9rLXDeD2b/6jxxQDq5hHOt4bA71hN4pnFNss569wPWLg45jkdvvqbHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947434;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dko70IlJGwm7/4LTdktNRgq+cW52TjKL+Dj2/wN25Ek=;
	b=LesfI411JGk/x7myawzCIMVAX27qsDVhbOhTHvkClfMfiDJ0vg+nW3zt2/y7fAXnK7J1
	 mUfQYUEGk6gfLsPVQ8ciHDmJ6Vg6UtKV90GDtb2qR3W0WWpqCpN8nEYmwmFNnoNY2SURT
	 mG4zhf4Mm1ygShWXa3fCXkUfpGGOhuUAz99AgP3Ph97Wa4q8p5oqdBKxYdMPwRRzuAFRe
	 bhIH5oJUtDM1dHLFM2YJga4VgapApjX2Fa8GwLfa7zU8r8qM2q2jUs4uy8EKL3ehDfMyV
	 JtYO4aCrQ+Y4pqiviA9MFp6QnrEyI1GKU+PNnpjmp4BHkTTAkKQDt7WXq0MZwZ4Ognw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V8vT9aKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF74606A32D
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V8vT9aKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446211F0089F;
	Fri,  6 Nov 2026 06:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947433;
	bh=dko70IlJGwm7/4LTdktNRgq+cW52TjKL+Dj2/wN25Ek=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=V8vT9aKKrQd2jtPxuSck5lN4UhAPIlf/O38KjQZyB2b5KGrwPxzue98A3Xcc8c0++
	 qEMLLtV68LITZNJapHIx3i97hz0Cer5U2FnsgMz5oCxlUKSjK3207f9m5dm1Pjqn/9
	 ZEaPiRTuXH9Mv7YcFVpV7Dk8XTEmvEHZPIocAZy/x2yucaQezyyVlgZdtTjtxOaBoK
	 kqsJ/Q3cuhhAodYjsQHVY5LGeFsckOx5iS48R11bdsH691/s37LBfWCJo2cB1EtedJ
	 uAgTiuPPGVMqmHFZaCKFD1nJb8y2Gz7pSzLpsFiP9MxV/XElBM8zoatH/LWhOhpbeE
	 7bhkf6VvIaaqQ==
Message-ID: <sashiko-outbox-200926@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/23] drm: Check the SGT ops for
 drm_gem_map_dma_buf()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-10-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-10-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:52 +0000
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
> When the next patch converts exporters to use SGT natively, the
> dma_buf->ops->map_dma_buf will become NULL. Additionally check
> sgt_exp_ops to see the new location.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D10

