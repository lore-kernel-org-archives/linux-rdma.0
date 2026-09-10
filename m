Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A9D3EDAB5
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 09:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030963; cv=none; b=J3gITsGaqU5/GMrFWRuglKdUaj7McemvtuwlxGW50oXiEL4AdmYzpKkmg4maPFx2cnpTTkd/gxqXTMr4Od/NQvd0bKh+rsjua8kRA0593HUeISbX87ejT4AoeD9Dz2HWLeHXlqpk1LQpdHzhcikQyMzWQGyB88aP1vUxlFOSTJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030963; c=relaxed/simple;
	bh=37kL4JtkfvzWoUoKi8hyF4gayXoUcWQ9UhOuPCwW2nE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tKq0y+nghPePQ/YXVHXoMAPZ/ZHSdDAFi2D0vA+G9rw3BNE5qksK0Mi59lcUe6qZoF4P9BB/+d2mF3lg+oPBw+g5Y1Mp3PU0y44q9Fn0YzmmSJZ4aaQqaIjqSZjQfaB7tKGbZih+wcnicBG4d6aA5ekJUDmH4hhBUKqtjQSlsTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBeEHA/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBeEHA/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053F51F000FF;
	Thu, 10 Sep 2026 09:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030962;
	bh=TrpGCCzsmK1y3krwBTwfnOiXAxhoV0MnkeBHVWLHNf4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WBeEHA/Dzlr/uiGjhfpT4xwuLz6UKQtyg1vnrss2VxGoq5cbBkfQC7J9ejS80hPxy
	 v3L9gQfj9uaOe1CXkf2bKNFKHTjv9QbRAN/lUICfsq7PFVPzVKRr9hLm23N7FlqfHj
	 2TRPBvAkfaQR02vri5Yzac/sOpXTmMaefNfPzD00IhbC7JmXJPfU54nClZ83cONLuA
	 GNWGbInzFDveZF17GfuUfvUOxCLpLYhADXwXiz4knWkRomYIiNW15rNrjCS5bdMAM/
	 PdF/IkPCktEiUVXArgF76t+E5XrOnTiO2oLr5GkLX6Ym4MUe3XUe97EZi8g8HGEzC/
	 oD7SV8WOfgawA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: Sanitize receive WQE in local buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nicolas Morey" <nmorey@suse.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910083712.1595862-1-nmorey@suse.com>
References: <20260910083712.1595862-1-nmorey@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 09:02:41 +0000
Message-Id: <20260910090242.053F51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Copying into the inner `wqe` field triggers a FORTIFY_SOURCE field=
-spanning write WARN_ONCE or panic.

Pre-existing issues:
- [Critical] Double-fetch TOCTOU vulnerability in the send path (`rxe_req.c=
`) leading to out-of-bounds memory access.
--

commit 5c427e8b4bbe51e8f334533fce0d0db77db27960
Author: Nicolas Morey <nmorey@suse.com>

RDMA/rxe: Sanitize receive WQE in local buffer

This patch sanitizes receive work queue elements by copying them to a local
buffer and validating their fields. This addresses TOCTOU races and
out-of-bounds accesses during the receive path.

> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
[ ... ]
> @@ -257,6 +257,47 @@ static enum resp_states check_op_valid(struct rxe_qp=
 *qp,
>  	return RESPST_CHK_RESOURCE;
>  }
> =20
> +static enum resp_states recv_wqe_sanitize(struct rxe_qp *qp,
> +					struct rxe_recv_wqe *kernel_wqe,
> +					struct rxe_recv_wqe *user_wqe,
> +					int max_sge)
> +{
[ ... ]
> +	size =3D struct_size(user_wqe, dma.sge, num_sge);
> +	memcpy(kernel_wqe, user_wqe, size);

[Severity: High]
Will this memcpy trigger a FORTIFY_SOURCE warning or kernel panic due to a
field-spanning write?

When recv_wqe_sanitize is called from get_srq_wqe, it is passed a pointer to
the inner wqe sub-object:

> +	err =3D recv_wqe_sanitize(qp, &qp->resp.srq_wqe.wqe, wqe, srq->rq.max_s=
ge);

Because the destination pointer points specifically to the nested wqe struct
within the larger srq_wqe struct, the compiler evaluates the size of this
object to exactly 40 bytes. When memcpy attempts to write up to
40 + 16 * max_sge bytes, it violates this strict bounds check, resulting in=
 a
denial of service on the receive path.

[ ... ]

[Severity: Critical]
This is a pre-existing issue, but I noticed the symmetric send path appears
to suffer from a very similar TOCTOU vulnerability that might lead to an
out-of-bounds memory access.

In rxe_req.c, rxe_requester performs a bounds check on cur_sge while the
data is still in shared memory:

        if (unlikely(wqe->dma.num_sge > qp->sq.max_sge ||
                     (wqe->dma.resid &&
                      wqe->dma.cur_sge >=3D qp->sq.max_sge))) {

However, a malicious user could potentially overwrite cur_sge immediately
after this check. Later, copy_data in rxe_mr.c re-fetches cur_sge directly
from the shared memory and uses it as an array index:

        struct rxe_sge          *sge    =3D &dma->sge[dma->cur_sge];

Could this bypass the validation and read memory outside the wqe if the
value is mutated between the check and the use?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910083712.1595=
862-1-nmorey@suse.com?part=3D1
