Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794150255;
	b=uHlsjC8TN2va5Wq8gm7hmaixNx0cZNRUX2JrasASGgXqSYVZA6aOPp22aubr4d0WH6ny
	 ecV0/IVxlyGG75IBXjxEbEZlnHNuLNNmSKO61z2hme4V8yeIvvgGibZpEWmjg480WtHdT
	 Kdy/O/hPUoPXWXihSmx265/nIpDwEdgxjJYWYkmMIukOwknvmBpOrI2tOr281M22K2NoI
	 ihe/VSJPdwvFqROwVdEz9DkUIcEOUKDLg4Tpl/lgWxtwwi/X5bGaXRj7ZR368C3CWYGk5
	 6tL/Lryb3+K1KZTc3w7Z26L62O4e6GfdVJ8T9DIFeyrCcUIL8Z10eYuZz9OP6sGw8fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794150255;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FhntQK/QsBaLbSo13zWwbmjKVHMocUxZCLDGKFOCMVM=;
	b=4tZhUub2SrHDLdO4eYsTGwXEsJYUlMhilfKikjOP6SBpdx/DloKnD0B+ExDmR8kcz4k+
	 oeWVT6qR/c8DE2KxxbnRSVoJH7j7a8fFU5FEfOn8e0JyTgfA+vaR2kFWDXZp6h5/YbT/4
	 IRNjBncNYe60bncVwoKuiKgz/jna8Bz2sCQoHz1Kh28NJDCikTMfEqRSPuq7RTGdS1sjV
	 rvyEzninjS8wJeWQMgD8BigheK2JSZHwXJxPuw/tDGf5mKVZ4VpeEo0U7QqHjnHL+fx8w
	 1jZRAZfoIz74cmu768RJUXqEixRbLq/bkIfMVSksyEXmZpeSwYtz8EY0U+AJr8NGrPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AP0FOrIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57054606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AP0FOrIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7391F008A2;
	Sun,  8 Nov 2026 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794150254;
	bh=FhntQK/QsBaLbSo13zWwbmjKVHMocUxZCLDGKFOCMVM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AP0FOrILqyLGy2EZ9nhBqCUZGbyRYztdugdWf3LxReXMjl3zXzMpDlBXrMky6RXNt
	 kE77qc16zQ1mHba7sYdcq4qFk4P0s2DeH5nDcmq0fdThoTiprACXnK1wDsHXB6mwEL
	 Qkh4hLJf+lg25K9FKGniLzJr6etY4byZLYDsuSpsLGuFUVrzUvYxMtEUS/OZz/u8PI
	 rYyVglj8Nw9wWZwnyiVagG1IMZcYyzPXEhL6IGuCbxkefj4IQhl0beRl5uEJUc98G0
	 MK2m8vus+YHis5+ObJv8arm2u53N3GT85YHNsBDitu5TNkOiXTnmzn7GryAor8zJhN
	 eC0KftHd2GAZw==
Message-ID: <sashiko-outbox-203825@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next 3/4] RDMA/ionic: allocate a PD-scoped DMA MR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261107150249.1576835-4-abhijit.gangurde@amd.com>
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
 <20261107150249.1576835-4-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 15:04:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] RDMA/ionic: build failure in ionic_fill_lif_cfg() due to
  missing rdma.cap
--

commit 71ee46b9e5e60e185b9553d17b2722a569d100ad
Author: Gregor Dick <gregor.dick@amd.com>

RDMA/ionic: allocate a PD-scoped DMA MR

This commit allocates a PD-scoped DMA MR via CREATE_MR with
IONIC_MRF_DMA_MR when the firmware advertises IONIC_GEN_CAP_DMA_MR.

[ ... ]

> diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infini=
band/hw/ionic/ionic_lif_cfg.c
> index 66cee57442e7a..dcf54856603d4 100644
> --- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> +++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> @@ -95,6 +95,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct i=
onic_lif_cfg *cfg)
>  	cfg->rq_expdb =3D
>  	    !!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_EXPDB=
);
>  	cfg->alloc_qid_cap =3D ident->rdma.alloc_qid_cap;
> +	cfg->cap =3D le64_to_cpu(ident->rdma.cap);
>  }

[Severity: High]
Does this break the build when CONFIG_INFINIBAND_IONIC is enabled?
The rdma struct inside union ionic_lif_identity in
drivers/net/ethernet/pensando/ionic/ionic_if.h has no cap member.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107150249.1576=
835-4-abhijit.gangurde@amd.com?part=3D1
