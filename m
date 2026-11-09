Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794256530;
	b=wPJpg0BEe7SY7JHx3LqddZrLqWqagKmfXfpz7M0pQSFWWjt8tYXJa+RXodGYgzAJprhs
	 1anjv8x13CLbHdxR1Nqj6x5VMFKfJRYr6sVYvnqPGHoBARrM+H64p1GrL+mryr80Pbcz9
	 aajHhub0TTxneUpUzUJCw64lT0b2K5gZscoqi6BNKyskPjZM0+CKuFeyfBXfo8u236T0/
	 t7uXzD0n3SfFtCePvEOsOSzAPl9E4sSqxexGEkNyWxUYd5uUbemM/IJJfoyo3Bulj5vxh
	 nwIxd93di5DFQiFDKm3ZayaGCBkD7R39C5OlS0jOikAU0f5xpr/Wz15XFkrqpPv+eFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794256530;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/lQdIK1enOhQD//MUSPno7iZJRCJjElizE1uht9QFyQ=;
	b=KYCa057N/pw/MrHsqmIonADil3JzyGEu7YQ5Wkod1CiputPBZzD/Sv06sCg/Uv4yTB2/
	 fTLYoud3VlBKbAS5ahZ17soVAzLOap0vAZZEH5Rm6yhDlR17HJQoEH7/nQn7YiWCIE8B1
	 R2OUwy937aL23troGoWSIgVero6ncSjFCf95MSkjyjYvm5uzY4UzaB6PYU4+uQ30ceOmn
	 0N8pbQ+Z/6v2pg3FMKvprtVvZdvGBiihCUuYkoUV4QBdib/+XMb1pxckt43KpYWha4OkW
	 Jl1y0ijClvX89J+Q6BCwBXI3yHXV8l4BLv5UOWdPoX+ppmBQxBA2gVdNbFVO1BIMRsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fa17yK8K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0C606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fa17yK8K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C481F008A5;
	Mon,  9 Nov 2026 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794256530;
	bh=/lQdIK1enOhQD//MUSPno7iZJRCJjElizE1uht9QFyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fa17yK8K2Ij/Msmgj/+RtpOF5kreo6aqFR3eJ7eShiYpTmIotgtDcWEToZmIaTEB5
	 rD01SoJ3nQoBqTyBTemY+vVkZW6eRVoIFnAgqszKplaES4qoG5tmYAb66IuiA99ATd
	 F/XoTBVOQTyLSyBuL9VagcvbvuzSuUvnJrguVERmHpJ8KdhaFgI80/CpXAso1cAeTA
	 nNFhzTBEEChDrD3VxR8YZ6Z16qHNkzJtT8u34bSbfwnf+FubLH7EJnLwIRHj31HOKr
	 BX2ZMAnjxL5Az40d13uy2Vl2/Py7H37Jh1rDaWLMcFAcxPPcYB6S1EqPaYkRIyTGPf
	 nXrB022GUKYCQ==
Message-ID: <sashiko-outbox-205588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Fix potential UAF during SRQ
 limit AE handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109202525.2937295-1-jmoroni@google.com>
References: <20261109202525.2937295-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 20:35:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] RDMA/irdma: SRQ ID leak in irdma_create_srq() [1]
--

commit df1284da749f5b8315f44692f641894f41a2494c
Author: Jacob Moroni <jmoroni@google.com>

RDMA/irdma: Fix potential UAF during SRQ limit AE handling

This commit replaces the raw SRQ pointer in the AE cookie with the SRQ ID
and uses an XArray lookup with reference counting to prevent
use-after-free during SRQ limit AE processing.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index 72de5738ae470..e07b6b40dd992 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
[ ... ]
> @@ -2575,6 +2579,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
>  		return -EINVAL;
> =20
>  	refcount_set(&iwsrq->refcnt, 1);
> +	init_completion(&iwsrq->free_srq);
>  	spin_lock_init(&iwsrq->lock);
>  	err_code =3D irdma_alloc_rsrc(rf, rf->allocated_srqs, rf->max_srq,
>  				    &iwsrq->srq_num, &rf->next_srq);

[Severity: High]
This problem wasn't introduced by this patch, but does irdma_create_srq()
leak the SRQ ID in iwsrq->srq_num [1] if irdma_get_srqdepth() fails?

drivers/infiniband/hw/irdma/verbs.c:irdma_create_srq() {
	...
	err_code =3D irdma_alloc_rsrc(rf, rf->allocated_srqs, rf->max_srq,
				    &iwsrq->srq_num, &rf->next_srq);
	if (err_code)
		return err_code;
	...
	err_code =3D irdma_get_srqdepth(ukinfo->uk_attrs, attr->max_wr,
				      shift, &depth);
	if (err_code)
		return err_code;
	...
}

When irdma_get_srqdepth() rejects invalid attr->max_wr values, returning
directly skips the free_rsrc cleanup path and leaves the bit set in
rf->allocated_srqs, allowing an unprivileged user to exhaust the device's
SRQ ID pool via uverbs.

[1] https://sashiko.dev/#/bug/linux-ec859386-8123-4946-9c12-458c13e3f421

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109202525.2937=
295-1-jmoroni@google.com?part=3D1
