Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEBD3BCD21
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245062; cv=none; b=Q27TmF+iDp1pUcX7Ov9vj5W3+q53fLgscoVAMfWgrd4pHNaiWfU1xy3khV0V/Qe57poexwJ3skWHTl4f9SloZgeoHxLSON5iaDF6nq9yaZqp1TAJCugBlUcDJ40Er/2K39jwFbwLLfzr/mOq6xOHRJrA9iTNGMobfa3mo4ejiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245062; c=relaxed/simple;
	bh=B0KLX+NcqgzSvPL6xMQjrzle+Dgf5xboIuN1fDLKYx8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LqaXUqggAH1spfVqNCYZFjh6Fd5oI7xKUj6a5ydo6M0BvckgbylSmTQBlBLJ8qy2BCvnFK2hwun2N0LHhVo/z7Fz+ZYgLM5q1o1UrAJDYs53lziIx63cSDsZdWFeWCYgYuwvPPryxhBPxNgy3eTOpvjbhfsRJv/LeUa2Ej+TJdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7yzkec6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7yzkec6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA281F000FF;
	Thu, 24 Sep 2026 10:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790245056;
	bh=YG0WAyxRLXmJIi8XB0NgMuG19TcncxG8H3jhxSVa4K0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E7yzkec6noPmjcUL1EDbApsLf4KRydaj7Be8AcUX4FkLz4su7qROeBsZrkD0HpPsV
	 HdoqX9f2V4BBNPH0MrhfojZpFCpDWVNKGsr+hD1F9DgUtjOK15ARVHlZ9EQhd7J0sv
	 cPvhc9JpV+XG2voPwRdIPCBt8glFufnaFr/hDZkEjpCgnIwFLzdXzchmrxLwgebE+I
	 hrxHCx1MV6Cpr+ue8OaG2G/t6UU0XUeAZqkmWWxD9cFlRwkBPh6ZHwmVMFx9/3hQ9o
	 8rBnrlICFDvIc/hzynNbkHoj+bSnKrnaod82hWH5vqSVGWJzH1L1LM+Bt7/xKReB3n
	 1beQ7NrLLv7PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: Validate inline data range in user WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260924100515.502912-1-yaojiale02@163.com>
References: <20260924100515.502912-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:17:36 +0000
Message-Id: <20260924101736.9FA281F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] RDMA/rxe: TOCTOU bypass of inline WQE validation
--

commit e272f5be8d762ea2e78301c1339c440a19e1130b
Author: Jiale Yao <yaojiale02@163.com>

RDMA/rxe: Validate inline data range in user WQEs

This commit adds bounds validation for the inline data range in user WQEs to
prevent kernel memory disclosure or vmalloc out-of-bounds accesses. It chec=
ks
the offset and length against the per-WQE inline area to ensure they fit.

Link: https://lore.kernel.org/all/20260708224534.1206-1-security@auditcode.=
ai/

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 53f7c1e7fe55b..06b7669d7f737 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -716,6 +716,15 @@ int rxe_requester(struct rxe_qp *qp)
>  		goto err;
>  	}
> =20
> +	if (unlikely((wqe->wr.send_flags & IB_SEND_INLINE) &&
> +		     (wqe->dma.sge_offset > qp->sq.max_inline ||
> +		      wqe->dma.resid >
> +		      qp->sq.max_inline - wqe->dma.sge_offset))) {

[Severity: Critical]
Since wqe points directly to a memory-mapped ring buffer shared with
userspace, can this validation be bypassed via a TOCTOU race?

A malicious userspace program could provide a valid sge_offset here to
pass the bounds check, but then concurrently modify wqe->dma.sge_offset
in shared memory to an out-of-bounds value.

When finish_packet() executes later on:

finish_packet() {
    ...
    u8 *tmp =3D &wqe->dma.inline_data[wqe->dma.sge_offset];
    ...
}

Could it re-fetch the modified, now out-of-bounds sge_offset directly
from shared memory, resulting in the same kernel memory disclosure or
vmalloc out-of-bounds access this patch intends to fix?

> +		rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
> +		wqe->status =3D IB_WC_LOC_QP_OP_ERR;
> +		goto err;
> +	}
> +
>  	if (rxe_wqe_is_fenced(qp, wqe)) {
>  		qp->req.wait_fence =3D 1;
>  		goto exit;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924100515.5029=
12-1-yaojiale02@163.com?part=3D1
