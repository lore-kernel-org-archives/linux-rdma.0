Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92423793DF
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869359; cv=none; b=ueCdwzyiIgmrH9wucRn7nF2dM2AtYltrF1B4O8ky+oBIluMfg+9UrpXpZ+ccig3AenNka3q+7q2K2i0ETomPJRaJ0wMfsmIvHEm/DolPyQMgykeWXQ94DberhgNTThl8hjGBHZdqrlYuuMso9rV4YbgS99sQyV6cfroYn+WC26g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869359; c=relaxed/simple;
	bh=z1yMaWwb+oPbBbegVnbSgAW8T5oZEil9QFC8qaPIShQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pOf2c/z+GfmlCIU6CeEGS0Cej0sZ+ciW3eShK8lryw5DWuW1J6ImpHCp4+O9bF57QprlGjjjTtRR0RGdkZ4VaZ8O9yK+8a6oFLAQIqnyVYRaAZBPyaqYL4Mux33+rGdICLCcjNEBnFT8DhxT45WtmiCI7OFVzhdkkFO++r/1gDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz+z90m6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz+z90m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254481F00899;
	Thu,  1 Oct 2026 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869357;
	bh=zY7hiSWpNWQ1NZ7dT4kZVCOsmEBmz09FezGfik0F4EQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hz+z90m6T4AFvhTLjAWEJzkHzl1yvHRl0d+n+2tWoeNCGvPl5NZc1uF8x5nNlsKNK
	 vgTjpzNR7yicaNinm81MfiI3jf5JgNCOVfEUjsEpTNfhJ820WmbKCtAlmH3pIigq9H
	 IuqUJg7G+Dui8XX7OQL0tbtsRtnZZayMlRchqdhU46AneL5l/8knCJ5CF02HYlbK5V
	 p3nsFlwZjpKvWdpkkix0hJMJNrgDHH0qWcrlkkEGc+JV+5HTwPMuF0COcgsaB7P5OF
	 g9ScjqinMzIbxNtfEOQKlzaY8wwOQbzTXj7Auhf8H7NakNgwMnUMKLWq7ngihk+pos
	 utezY3OzmO4lQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: validate cur_sge on the receive path
 before indexing dma->sge[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001152345.3259024-1-ays511.kr@gmail.com>
References: <20260930180119.2497360-1-ays511.kr@gmail.com>
 <20261001152345.3259024-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:42:36 +0000
Message-Id: <20261001154237.254481F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/rxe: double-fetch TOCTOU vulnerability in copy_data() bounds =
check
--

commit 2fd3d60fe5490f46cfcd1b0614c53c62687fc767
Author: Youngsung Ahn <ays511.kr@gmail.com>

RDMA/rxe: validate cur_sge on the receive path before indexing dma->sge[]

This commit adds bounds validation for cur_sge in copy_data() on the receive
path before the scatter/gather array is accessed. It intends to reject an
out-of-range cur_sge to prevent denial of service or information leaks.

> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/r=
xe/rxe_mr.c
> index 2afda5154dfb9..0c510bb7ae2a7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -436,6 +436,11 @@ int copy_data(
>  		goto err2;
>  	}
> =20
> +	if (unlikely(dma->cur_sge >=3D dma->num_sge)) {

[Severity: High]
Since dma can point directly into an attacker-controlled mmap'd ring buffer,
could this introduce a double-fetch vulnerability?

For example, on the send path, a WQE is retrieved without a kernel copy and
passed along:

rxe_requester()
   finish_packet()
       copy_data(..., &wqe->dma, ...)

Earlier in copy_data(), sge is initialized by fetching dma->cur_sge:

	struct rxe_sge *sge =3D &dma->sge[dma->cur_sge];

Because the check added here lacks READ_ONCE(), the compiler could fetch
dma->cur_sge twice from shared memory.

A malicious thread might race to provide an out-of-bounds value for the fir=
st
fetch, followed by a valid value for this second fetch. This would bypass t=
he
check and result in an out-of-bounds dereference when sge->length is evalua=
ted
shortly after.

Would caching dma->cur_sge locally with READ_ONCE() prevent this?

> +		err =3D -EINVAL;
> +		goto err2;
> +	}
> +
>  	if (sge->length && (offset < sge->length)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001152345.3259=
024-1-ays511.kr@gmail.com?part=3D1
