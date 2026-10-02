Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1104657F5
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932387; cv=none; b=qOLy3a0QUiMs+nJfTWKM/q8ev6nqLHt8SgnwdpMRLXp1yrvomXyc+EHLYhUgrGX1n5mj3ktv9X14JmE2i5Lxwbn8/SQZPuGpEzAG/mzIWRYIGzjUbuq6QSCYT777zDL/1tyc3dgIeFsDY3ZR7/TrTp5kGHh4dTXcjePMw6RuHio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932387; c=relaxed/simple;
	bh=qryZPw7JFrqp10+VpCnAFTjpTfwZCVyq38EckpGXwBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KR3QT5nnMGJ/d9/BfmLgaOCTkHXtC5nAwarrxwcXA0ML8U0XGD4gw1PajPQPePp24Fo6kWJAuBZZfyZH2IzjU8I3x5DdD+UrnQb63ayl365TnvfOaPxVwgvioK1TWx0aQluiVBNqERmu1wU1XZA89Dbo92pawqSAwX5aKzNBYBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5Txx3Ig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5Txx3Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D76B1F00899;
	Fri,  2 Oct 2026 09:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932385;
	bh=xSnvQN/UuEjUXq++RK40T75NN7tIQbiyr+AF0XRl/lo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e5Txx3IgoN28hGxBu+PRnyZVHYELqqmDQ4OW9FIUUjWkpO6ixlQXJxRGrCB8iMqOe
	 Bu5DzaSDb2db1piQ0aA2UimKJr5/njvbq16EFCfETsHFrxYARRfamN7s8Z0wWxZWXU
	 I+al6OCyYf1zozZOiVldmxn+A0OLqbiXAAVNCH42tW+3IGM2Xjw/Yw4azslGnMcTBh
	 VHrW18hXqGVC9DDA/rLidL86qv0hiB28zCvMf9ag0EFCFc0Y88n9X1L8OoYgxNuAr1
	 dRWiOi2G7z5Vz9URhW3svpwUHuZkBc8kcss7fg5HzDIKsBoG7jgBKHY6XPPMW0ae+h
	 kb92NNG3U+q4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 03/10] net/mana: Extend GDMA encoding for new
 RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-4-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:04 +0000
Message-Id: <20261002091305.2D76B1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana: Missing fixed WQE size validation causes ring buffer ov=
erflow
--

commit 8f045a852a650adae362c74de90d65ccaf6541d9
Author: Konstantin Taranov <kotaranov@microsoft.com>

net/mana: Extend GDMA encoding for new RDMA WQEs

This commit extends mana_gd_post_work_request() to support extra-large OOB
data and fixed-size WQEs. It encodes WQE header fields based on WR flags
and uses num_pad_sge to specify padding size for fixed-size WQEs.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index 05ba7055405da..444101dcbb647 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1699,8 +1699,27 @@ static u32 mana_gd_write_client_oob(const struct g=
dma_wqe_request *wqe_req,
>  	header->num_sge =3D wqe_req->num_sge;
>  	header->inline_oob_size_div4 =3D client_oob_size / sizeof(u32);
> =20
> +	if (client_oob_size =3D=3D INLINE_OOB_EXTRA_LARGE_SIZE) {
> +		/* Extra large oob is encoded as 7 */
> +		header->inline_oob_size_div4 =3D 7;
> +		/* Extra large oob has 8 byte padding  */
> +		client_oob_size +=3D 8;
> +	}
> +
> +	if (wqe_req->wqe_size_in_bu) {
> +		header->num_sge =3D (wqe_req->wqe_size_in_bu * GDMA_WQE_BU_SIZE
> +			- sizeof(struct gdma_wqe) - client_oob_size) / sizeof(struct gdma_sge=
);
> +		header->num_pad_sge =3D header->num_sge - wqe_req->num_sge;

[Severity: High]
Does this calculation risk silently underflowing if the fixed WQE size is t=
oo
small?

If a caller provides an undersized fixed WQE size, this subtraction could
underflow, which might corrupt the hardware descriptor bitfields and lead t=
o an
out-of-bounds write of SGEs.

> +	}
> +
> +	header->check_rsn =3D !!(wqe_req->flags & GDMA_WR_CHECK_RSN);

[ ... ]

> @@ -1792,15 +1814,26 @@ int mana_gd_post_work_request(struct gdma_queue *=
wq,
>  		max_wqe_size =3D GDMA_MAX_RQE_SIZE;
>  	} else {
>  		if (client_oob_size !=3D INLINE_OOB_SMALL_SIZE &&
> -		    client_oob_size !=3D INLINE_OOB_LARGE_SIZE)
> +		    client_oob_size !=3D INLINE_OOB_LARGE_SIZE &&
> +		    client_oob_size !=3D INLINE_OOB_EXTRA_LARGE_SIZE)
>  			return -EINVAL;
> =20
>  		max_wqe_size =3D GDMA_MAX_SQE_SIZE;
>  	}
> =20
>  	sgl_data_size =3D sizeof(struct gdma_sge) * wqe_req->num_sge;
> -	wqe_size =3D ALIGN(sizeof(struct gdma_wqe) + client_oob_size +
> -			 sgl_data_size, GDMA_WQE_BU_SIZE);
> +	if (wqe_req->wqe_size_in_bu)
> +		wqe_size =3D wqe_req->wqe_size_in_bu * GDMA_WQE_BU_SIZE;

[Severity: High]
Is it possible for the user-provided fixed WQE size to be accepted here
without verifying that it is actually large enough to contain the requested
SGEs and OOB payload?

If a caller creates a queue pair with a small max_send_sge (fixing the WQE
size) but posts a send work request with num_sge larger than max_send_sge,
could this bypass validation?

If this validation is missing, it appears it would cause the integer underf=
low
mentioned above in mana_gd_write_client_oob() and lead to an out-of-bounds
memory write during mana_gd_write_sgl().

> +	else
> +		wqe_size =3D ALIGN(sizeof(struct gdma_wqe) + client_oob_size +
> +				 sgl_data_size, GDMA_WQE_BU_SIZE);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D3
