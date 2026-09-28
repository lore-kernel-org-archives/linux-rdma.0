Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE8949DBBF
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612213; cv=none; b=lqxQ+VmKdQ4njHV8JCAlQLTQLUof5MhDMk7rvlUyKlGgTAhhTv4TZUKfTVObVAlpHNeDSPu5nyeP9zMhMZJH5WKhJ5cEhrDSREfhejOSf2nM/m7OmODpJ+8LIqd4hYxvASjUx6893M4ClRbSQPOloB3EFMe4WfW7+VQnawgfefY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612213; c=relaxed/simple;
	bh=ctl5IpQBuGdY5VGsYRDSQnBtS4mUSICzXKCRcaxD8l0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F8bbqa+RwyJGPCyiG4u4GO4RBs/bKhboYlYDZJXJOrfbhoB92AwzILWU/9/p+Yhwgym9NNvCQLGc0DT3sMUEehrf3XDd19FUkrKZJH7CTJHHABVgfF7Cx1jaM/qg0MEIc6IQVUtXadaqAymLnNk5jG5YP2huZGoNSXcbLhTCFZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2OqYWwM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2OqYWwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021E81F000FF;
	Mon, 28 Sep 2026 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790612196;
	bh=80j3HIbg7Qpxc9bvyhjlrXq53u9LQMKPe1oIilwUqHI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B2OqYWwMb0fdH0Y/xILhvl8wpu5MUWOchLDU4Q8agW0hOEJOtTeHEzsPNz3JSVtAa
	 rk2Fs3H9FoSaQK+F8kwnpe3bwdlr1y3DZwpe9MUgisHzWG8D2GtgGv2bV2XG5jyEdf
	 RmA9gaENrRJw0CyNu4jM9qPGwLBlrq6mKEvebqqP88RjUbm+WLezs1HXkMDem9X44C
	 yotGOaSsJL88hkP7etByHXAuLR2ie6YNNSTKfS01jD7PQceCkwrMAHPrh4R+80pq3m
	 mLGpXxQUXDTQkMDA8jyba6EDaBcfDbDy2jAsrHBFs0HlTiOZJkXkcjuLk+sJB5tOX1
	 V3IUUIvY4ONIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] RDMA/rxe: Invalidate MWs on QP destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928155351.3222978-4-cccccccccccc777777@gmail.com>
References: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
 <20260928155351.3222978-4-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 16:16:35 +0000
Message-Id: <20260928161636.021E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] rdma/rxe: type mismatch in xa_for_each causes memory corruption
- [High] rdma/rxe: Use-After-Free during MW pool iteration under RCU
- [High] rdma/rxe: concurrent MW bind during QP destruction causes hang and=
 UAF
- [Medium] rdma/rxe: soft lockup during MW pool traversal in rxe_invalidate=
_mws
--

commit 80671c88acbdcad0b751f787a4de4bc92545ab54
Author: Dongliang Qin <cccccccccccc777777@gmail.com>

RDMA/rxe: Invalidate MWs on QP destroy

A type-2 MW holds a reference to the QP that bound it. If the QP is
destroyed while an MW is still bound, the MW keeps the QP alive and the
responder can retain a stale QP association. This commit invalidates MWs
bound to the QP before removing the QP from its pool.

Cc: stable@vger.kernel.org

> diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/r=
xe/rxe_mw.c
> index 82e9fef89b6c3..02d20ede1a789 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mw.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mw.c

[ ... ]

> +void rxe_invalidate_mws(struct rxe_qp *qp)
> +{
> +	struct rxe_dev *rxe =3D to_rdev(qp->ibqp.device);
> +	struct rxe_mw *mw;
> +	unsigned long index;
> +
> +	rcu_read_lock();
> +	xa_for_each(&rxe->mw_pool.xa, index, mw) {

[Severity: High]
Does this loop incorrectly assume the XArray returns struct rxe_mw * direct=
ly?

The XArray mw_pool.xa stores struct rxe_pool_elem * elements, but
xa_for_each() assigns the returned pointer directly to mw (which is declared
as struct rxe_mw *).

Since elem is not at offset 0 in struct rxe_mw (it is preceded by struct
ib_mw), would any subsequent access like rxe_get(mw) evaluate to &mw->elem
with a non-zero offset, leading to out-of-bounds memory access?

[Severity: High]
Could this iteration race with concurrent MW deallocation?

The loop relies on rcu_read_lock() to protect object memory during lookup,
but the RDMA core synchronously frees the Memory Window without an RCU grace
period:

drivers/infiniband/core/uverbs_main.c:uverbs_dealloc_mw() {
    ...
    atomic_dec(&pd->usecnt);
    kfree(mw);
    return ret;
}

If a user destroys a QP while concurrently deallocating an MW, could
xa_for_each() return a pointer to an MW that is simultaneously kfreed,
causing rxe_get(mw) to access freed memory?

[Severity: Medium]
Could iterating this pool under RCU cause a soft lockup?

If a user creates a massive number of MWs (up to RXE_MAX_MW, which is
524,288) and then destroys a QP, this loop will iterate the entire
populated pool.

Since this executes strictly under rcu_read_lock() and takes spin_lock_bh()
for each present MW, preemption and bottom-halves are disabled for the
entire duration of this potentially massive loop without yielding. Will
this lead to watchdogs firing?

> +		if (!rxe_get(mw))
> +			continue;
> +
> +		spin_lock_bh(&mw->lock);
> +		if (mw->qp =3D=3D qp)
> +			rxe_do_invalidate_mw(mw);
> +		spin_unlock_bh(&mw->lock);
> +
> +		rxe_put(mw);
> +	}
> +	rcu_read_unlock();
> +}

[ ... ]

> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/s=
w/rxe/rxe_verbs.c
> index 8553c8402c619..c0d77cad4906b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c

[ ... ]

> @@ -658,6 +658,8 @@ static int rxe_destroy_qp(struct ib_qp *ibqp, struct =
ib_udata *udata)
>  		goto err_out;
>  	}
> =20
> +	rxe_invalidate_mws(qp);
> +
>  	err =3D rxe_cleanup(qp);

[Severity: High]
Is there a race condition between invalidating MWs and stopping the QP
tasklets?

The invalidation happens before the QP tasklets are stopped in rxe_cleanup(=
),
leaving a race window. The requester tasklet can concurrently process a bind
request:

drivers/infiniband/sw/rxe/rxe_req.c:rxe_requester() {
    ...
    case IB_WR_BIND_MW:
        ret =3D rxe_bind_mw(qp, wqe);
    ...
}

Could this concurrent bind request elevate the QP refcount after the
invalidation pass has already finished, causing the subsequent rxe_cleanup()
to hang indefinitely (or UAF if it times out) while waiting for the refcount
to drop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928155351.3222=
978-1-cccccccccccc777777@gmail.com?part=3D3
