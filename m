Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECB2312834
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 12:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789301009; cv=none; b=KUYMLQ0/ssAM9e9ouPCC4wJ2U+2+icxbj64wfs8bcYkdTEF7NW/jrwN8TZZIID/rnsdCmEThrcO84M5/3gnIPWB2Rz1iHJz9lg4T5lF7iqYMqUN+sJ2JrMp3sdPLW44+zxzIOJnDprPO/mRawtlppiAbl9wDll7XqPkqorXALbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789301009; c=relaxed/simple;
	bh=XT84BnAE4tMIO0N+I7akMPw8a0Ux2wmBsgfoltThgL0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PxkopzaqCE5DGGjGQq4oxJ/Vxf7bFIvKAC001dGCyZcHqcJODtrrldAgYSfGUIvozTdyE/9oGWXtE9/LuFBCgnEjGHD4yNpmbAPPeqVODScvfyDSqOF1d2kTaj9FqYM7Kmlg+LqayWP3HB0sqLs/ZajREWdTPSClGs0ggm/GM6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpSeCeEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpSeCeEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECA61F000FF;
	Sun, 13 Sep 2026 12:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789301007;
	bh=giLoeOyZY5XziG8rDcaF/4C3B4MixNNWQl92NWeDgGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bpSeCeExEnU26c9L7XfW7T7IGA1iUi2PBIZxP68QOl0LMKVihCLQDikcvkwuOR24j
	 lHJZdaEjirwKiqLjvSvaik4/lSKZuS2MSyHaiIv5T13xs1h1bxn98tZ77+YDq0T8Oa
	 ikkk0iIksq5pVz+noxaYUzWVQCxazO8nArVMvYTh5vOgxUrypNrmjViazpXDKSUZMN
	 2pa1bDk2R+qBSdiQBWoSDNidDcdjrxyCOOm/G2orkbhVIerPVtVNLQrvAQWagIsGr1
	 zrGYiDdiZoczldnV7JRdUWdCZljiMNB4/s2gmgZ43eLNu4Qe8mQufAzmtW0qlnKpkt
	 GMP5Ni8vWykBQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes
 after MR creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Norbert Szetei" <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260913-rxe-advise-mr-v2-v2-1-b806c789871c@doyensec.com>
References: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
 <20260913-rxe-advise-mr-v2-v2-1-b806c789871c@doyensec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 12:03:26 +0000
Message-Id: <20260913120327.5ECA61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Arbitrary Kernel Pointer Dereference / Local Privilege Escalat=
ion via IB_WR_REG_MR WQE
--

commit fa8758be337c701491b43023c09167d84e64fdc0
Author: Norbert Szetei <norbert@doyensec.com>

RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after MR creation

This commit prevents userspace from setting or clearing the
IB_ACCESS_ON_DEMAND flag on memory regions after they are created. This
ensures that the access flag correctly matches the underlying capabilities
of the memory region.

> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/r=
xe/rxe_mr.c
> index 71d9ea4772890..615da4bb9a38c 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -796,6 +796,12 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_se=
nd_wqe *wqe)
>  		return -EINVAL;
>  	}
> =20
> +	/* an MR with no umem is never an ODP MR */
> +	if (unlikely(access & IB_ACCESS_ON_DEMAND)) {
> +		rxe_dbg_mr(mr, "access =3D 0x%x requests ODP\n", access);
> +		return -EINVAL;
> +	}
> +

[Severity: Critical]
This is a pre-existing issue, but does writing to mr here allow an arbitrary
kernel memory overwrite?

If an unprivileged local user creates a Reliable Connection Queue Pair and
memory-maps its send queue ring buffer, they can write a crafted WQE with
IB_WR_REG_MR and set wqe->wr.wr.reg.mr to an arbitrary kernel pointer.

The kernel processes this WQE in rxe_requester(), which routes the WQE to
kernel-only local operations without verifying if the Queue Pair belongs to
a privileged context:

rxe_req.c:rxe_requester() {
    ...
    if (wqe->mask & WR_LOCAL_OP_MASK) {
        err =3D rxe_do_local_ops(qp, wqe);
    ...
}

Since rxe_wr_opcode_info allows WR_LOCAL_OP_MASK for IB_WR_REG_MR,
rxe_do_local_ops() dispatches it to rxe_reg_fast_mr().

In rxe_reg_fast_mr(), the arbitrary pointer from the user is directly cast:

rxe_mr.c:rxe_reg_fast_mr() {
    struct rxe_mr *mr =3D to_rmr(wqe->wr.wr.reg.mr);
    ...
}

Could this cause the subsequent assignments to mr->access, mr->lkey,
mr->rkey, and mr->state to overwrite arbitrary kernel memory?

>  	mr->access =3D access;
>  	mr->lkey =3D key;
>  	mr->rkey =3D key;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-rxe-advise=
-mr-v2-v2-0-b806c789871c@doyensec.com?part=3D1
