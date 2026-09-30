Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDACB51DDE9
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793664; cv=none; b=G+4pNx4mt+4M3qXgOJkNhM4qCO25whrmcFaYOE+Dp7sVelBfl85fGQL3XOm1+4SlwYVaCxA+Pi8XRgzHlaUmrHf2T79s6lPffj5GA6WkDyWZESK1QYPuutXclXT6QPPTw2ewxkYfsXQ50sQJFcVq4rkb4sOVpvHGy4clfa4mRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793664; c=relaxed/simple;
	bh=Ggydn++9YQwXsZkJbMYSMN2jGa7nIzaImNc9mLpFniM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Hz5DCQnzSU+oqx7oVi/u2JhZw5bfC8mDOnSsDjWRGEF6EPKVnG4gy8UmBfQAlWHyQ3CxFhNOJGy3aksYaCw5kX+Dgjh8pn/AkIQ5imvk6ZlQnjNqok/oy7vT1RUd8ShZf4X1UI8lXD4A5IH5qwI5V8V2FhlfmYrEO5wobCovCjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hm+D9ZP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hm+D9ZP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623CF1F0089A;
	Wed, 30 Sep 2026 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793662;
	bh=kFPnB2ImPQLrY7opKaHCHjoxwEukMYNJo7Tn6glOFYM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hm+D9ZP29AUO6IxzTXsxJ02RrevoDAuj4AdMDGgxZJDGh/CIsSlUCDU6Fmyzz+5Kh
	 YEBIjDhX4VjiJsNd/kyLdcIYTqpuOTi9gTlwv1AGpWvrXkZeKUfjBUQontpx+pDku+
	 BjvgdrxzNSHSBt9AmxxTrxqTyzLEEOxU8sKlZIdWo1wNWE/hYmMTIt4u2MTk2u6SMw
	 ZhkF9jnMWZLbSlk3PdkcAaBXqE2qrSXUa45XMovc+ZbC8398nE5gx1GIj1FgxvvKtQ
	 68acPXDqQ1rKfsLu5INBnOdLbWN+4fIAnzZhz5f1232GwPqVJa+4mNc5y199+M/P+N
	 iHYAB7cO7/Qnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: refuse to destroy a QP with type 2 MWs still
 bound
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930182223.2511145-1-ays511.kr@gmail.com>
References: <20260930182223.2511145-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:41:01 +0000
Message-Id: <20260930184102.623CF1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] RDMA/rxe: TOCTOU race in rxe_qp_chk_destroy() allows UAF
--

commit 94e08f1cc2290d06c7fcd154d031cde9d5a0054c
Author: Youngsung Ahn <ays511.kr@gmail.com>

    RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound

This commit adds tracking for type 2 memory windows bound to a QP via an
atomic counter. It attempts to prevent the destruction of a QP if there are
outstanding type 2 MW bindings by returning -EBUSY.

> diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/r=
xe/rxe_mw.c
> index bddb7a2578313..a2e3a6ce09463 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mw.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mw.c
[ ... ]
> @@ -161,6 +161,7 @@ static void rxe_do_bind_mw(struct rxe_qp *qp, struct =
rxe_send_wqe *wqe,
> =20
>  	if (mw->ibmw.type =3D=3D IB_MW_TYPE_2) {
>  		rxe_get(qp);
> +		atomic_inc(&qp->mw_bind_num);
>  		mw->qp =3D qp;
>  	}
>  }

[Severity: Critical]
Is it possible for the worker task to execute this concurrently during QP
destruction?

Since qp->valid is not cleared until rxe_qp_do_cleanup() runs, the requester
can freely process pending BIND_MW work requests during the cleanup delay:

drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester() {
    ...
    if (unlikely(!qp->valid)) {
    ...
}

If this runs concurrently, couldn't the counter be incremented too late,
holding the reference that triggers the 50-second timeout during cleanup?

> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/r=
xe/rxe_qp.c
> index 311f285d78a6b..fea55bc3b0cb9 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
[ ... ]
> @@ -858,6 +858,16 @@ int rxe_qp_chk_destroy(struct rxe_qp *qp)
>  		return -EBUSY;
>  	}
> =20
> +	/* An attempt to destroy a QP while it still holds references for
> +	 * bound type 2 memory windows will fail immediately.  Otherwise the
> +	 * QP is freed with those references outstanding and the windows are
> +	 * left pointing at freed memory (use-after-free).
> +	 */
> +	if (atomic_read(&qp->mw_bind_num)) {
> +		rxe_dbg_qp(qp, "Attempt to destroy while type 2 MWs are bound\n");
> +		return -EBUSY;
> +	}
> +
>  	return 0;
>  }

[Severity: Critical]
Does this lockless check fully prevent the regression?

Because this check happens before the QP is drained or the worker task is
stopped, a racing userspace application could post an IB_WR_BIND_MW work
request that is processed immediately after this check passes.

When that happens, the delayed bind will cause rxe_cleanup() to hit its
50-second timeout waiting for the reference to drop. However, the timeout
error from rxe_cleanup() is ignored:

drivers/infiniband/sw/rxe/rxe_verbs.c:rxe_destroy_qp() {
    ...
    err =3D rxe_cleanup(qp);
    if (err)
        rxe_err_qp(qp, "cleanup failed, err =3D %d\n", err);

    return 0;
}

Since it unconditionally returns 0, won't the core still free the QP memory
while the memory window retains a dangling pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930182223.2511=
145-1-ays511.kr@gmail.com?part=3D1
