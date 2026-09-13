Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25E61F1534
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 11:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300711; cv=none; b=Yqh529B+zaSCNN5e9Z+XizFJ+JnLCALYHm7z14KkBRGAUMO6OksKcxC2Ce+qlD1fo9Hh1rqgMxKoLXrbnzbIvDs5tKhw52dOn+Fbm4gpmU6nUydiU2s0Bd8ViqrFj80Q+iljfyzf34Yfd3jqPp3aLyTy50DVMxfG7nHUr1mNHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300711; c=relaxed/simple;
	bh=y/TnpKLDdTVY4VPFwhewQeCi/JA9oT6Ozxfz1dH0f6o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mjpYwyecTrhj3bHYW31o36PINsdEotxqw3S3f6Cuir+yfWJsQJnXqNINqXaWzvCpeKZbFnPpNufsU+QuMwkdmbyPV9mDn2wpjPYez27Q075Iw0XlvIVXBmvCUP/ZUi3dMLX2D1yJeUbv3sl9izHIYMXRbBZlW0XfCEwwS5IexFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9bVBalU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9bVBalU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2056D1F000FF;
	Sun, 13 Sep 2026 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789300709;
	bh=2L01S3dmtthooGr2lHXYocvpr4EyfxTv02us10YTGRA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I9bVBalUdthoI8jD7gNkPe+LN8IHwVLD89HIJpx6fEWaz6L5Wh4uE+eHVzBYYWXnO
	 qXQtWjhs278vu1yHxQp0334/h4LhjJl484E4Dubu/Vu4tQV1WzOIK4hVPq0wYIfapQ
	 bH6QOczUiqWbvPx7S1vADZdUPc7OyEFCfFKCnu2BXfgORMj1K+NW09fpVCb9l2yNh9
	 aS8yScs4QL5wUgzsqxzcFE+mryNQTmIF2zPrXTVtI7aodVlwuINOSnBpfiVvws/e/G
	 V2U2iRNaybJQ2vjcuYtTbXv/L1Q3mz8uLD3vGD/wUZjKHXU390caYABlrl6sC6JCc5
	 hsuZtrZwWTsCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] RDMA/rxe: Reject prefetch of a non-ODP MR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Norbert Szetei" <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260913-rxe-advise-mr-v2-v2-2-b806c789871c@doyensec.com>
References: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
 <20260913-rxe-advise-mr-v2-v2-2-b806c789871c@doyensec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 11:58:28 +0000
Message-Id: <20260913115829.2056D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Prefetch incorrectly requires IB_ACCESS_LOCAL_WRITE unconditionall=
y, breaking read-prefetch on read-only ODP MRs and making the writable chec=
k redundant.
--

commit a9cc6b0ff5adbd3d36fe2189b597deea1078f23c
Author: Norbert Szetei <norbert@doyensec.com>

RDMA/rxe: Reject prefetch of a non-ODP MR

This commit modifies the prefetch paths in rxe_odp.c to require
IB_ACCESS_ON_DEMAND when calling lookup_mr. This prevents out-of-bounds
reads that occur when non-ODP MRs are erroneously processed by ODP
pagefault handlers.

Cc: stable@vger.kernel.org

> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/=
rxe/rxe_odp.c
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -469,7 +469,7 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
>  		struct rxe_mr *mr;
>  		struct ib_umem_odp *umem_odp;
> =20
> -		mr =3D lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
> +		mr =3D lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
>  			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);

[Severity: High]
This isn't a bug introduced by this patch, but does this require local write
access for all synchronous prefetches?

It appears this might improperly break read-prefetch for read-only ODP MRs.
Valid ibv_advise_mr calls for read-only ODP MRs requesting
IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH could fail with -EINVAL.

> =20
>  		if (!mr) {
>  			rxe_dbg_pd(pd, "mr with lkey %x not found\n",
>  				   sg_list[i].lkey);
>  			return -EINVAL;
>  		}
> =20
>  		if (advice =3D=3D IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH_WRITE &&
>  		    !mr->umem->writable) {

[Severity: High]
This is also a pre-existing issue, but does lookup_mr already strictly enfo=
rce
IB_ACCESS_LOCAL_WRITE?

If so, does that render this missing write permission check completely dead=
 code?

[ ... ]

> @@ -535,7 +535,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ib=
pd,
> =20
>  	for (i =3D 0; i < num_sge; ++i) {
>  		/* Takes a reference, which will be released in the queued work */
> -		mr =3D lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
> +		mr =3D lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
>  			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);

[Severity: High]
This is a pre-existing issue, but does the asynchronous path also suffer fr=
om
the same incorrect IB_ACCESS_LOCAL_WRITE enforcement?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-rxe-advise=
-mr-v2-v2-0-b806c789871c@doyensec.com?part=3D2
