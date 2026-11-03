Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793677998;
	b=sZWsYn6IeF6dq7VAxubgLYipEB3iZKmBL4N0vT77f7DxxS/jBU4pCE+8UWLUgmS4rO1u
	 AphKQHUFgn+JIS16NPJED4z2DU8nth1IGGxM9Q/H35L9H7ss4SKeEhdm+EWUqD5BHumUD
	 7c+g0yFMexEEDVQmjQFZygU8HX7MCough1P8H01s72/ToX/l/TnMDRSgIiXFx3Hb62OTx
	 TXZpxqdHOaIIFGgdTggU58u+xkR8tEpjksYO+ttUo9GJwmF/6lzbkVjyXxnaAwvQVGcDt
	 vaVCW8w4Vl4dyzMfcg0+D9opPjP++hlU3hFGEGsMqpLEf1UmMFNF21T7Ss6atOQJRug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793677998;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9xY3CayYf/RBq01cUopaStSjs5t8Y3rv6jNAohup/X4=;
	b=N112zu3PlsKTHip67nJwVa70YN9ZBxJgCmdk1SDB9SEoHX3WBmw63+e3swNkQIRs05Sy
	 meMMMAwtI5eog10+5nQpVSkWv3SKKdiwgd1Jws86ZaDnNdjJuZUywWLNPaj8qBySYEU1O
	 O6Vwl3C82IeR7MNoNJfkyzx6C+drUjIIamxxIKlUWiCYkDuOkYFSSrgY7Q5Js3ybWPUBB
	 SZEXcSX7vulSwAfhnUCU3gD++Wsko9riO0haxalNKx2vYeGtcVWAyalBXhQEnSyptMIB5
	 /APOocflWxFm8DXHgCaRowGhy+FapqS8MiSMSJxGL1L36uCDAkd2z6UAD0RiXOlXjtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aSaqdVP/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D50A606A327;
	Tue,  3 Nov 2026 03:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aSaqdVP/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FFF1F000C1;
	Tue,  3 Nov 2026 03:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793677997;
	bh=9xY3CayYf/RBq01cUopaStSjs5t8Y3rv6jNAohup/X4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aSaqdVP/r06YXLH/+KjoTPTNvK0eFn214SffoAHQe3UvQ8iVUrT5vLUT/Yn4xOJAd
	 GmNDW8dK/fO4IC1FIRUqhJ+a0Ur5E8s+8Cj+q3ywqZQDGvmaKz8ghwaKHh1IIQc54D
	 rLm29L6vqZSY1stnOTlILZx3j5tB7maRQsV+H/vVSs39N7g8ED3AuYkNNvYYlmMMee
	 sdBnijfvpFKpmti8j/dlIIcZeI85eMEMfx+uAZdaJl4xeVNU0hdZKSAvnjhLLAaDCx
	 0LV2a/nvchlFNgLypvEdf+kdWPa8RbYcfWwiPmy+TyAttOKhTvkYYG+dalucH7VNsc
	 Y2uR8+ez0L4WA==
Message-ID: <sashiko-outbox-194545@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/3] IB/isert: do not publish connections being
 released on a second list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261103032924.1073138-2-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
 <20261103032924.1073138-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:53:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] IB/isert: missing ib_drain_qp() in isert_free_np() and isert_c=
onnect_error()
--

commit 56a817f50afa9a4dae171633af8e54e1c447db9f
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: do not publish connections being released on a second list

This commit changes isert_free_np() to unlink connections from
isert_np->pending and isert_np->accepted one at a time rather than moving
them onto a local list, and updates the CM handlers to check whether
isert_conn->node is already empty under isert_np->mutex before acting on
the connection.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index efa8d7b7844c9..8255208e30c7d 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c

[ ... ]

> @@ -658,12 +663,19 @@ isert_connect_error(struct rdma_cm_id *cma_id)
>  {
>  	struct isert_conn *isert_conn =3D cma_id->qp->qp_context;
>  	struct isert_np *isert_np =3D cma_id->context;
> -
> -	ib_drain_qp(isert_conn->qp);
> +	bool owned;
> =20
>  	mutex_lock(&isert_np->mutex);
> +	owned =3D !list_empty(&isert_conn->node);
>  	list_del_init(&isert_conn->node);
>  	mutex_unlock(&isert_np->mutex);
> +
> +	if (!owned) {
> +		isert_info("conn %p is being released already\n", isert_conn);
> +		return 0;
> +	}
> +
> +	ib_drain_qp(isert_conn->qp);
>  	isert_conn->cm_id =3D NULL;
>  	isert_put_conn(isert_conn);
> =20
> @@ -2479,12 +2491,33 @@ isert_accept_np(struct iscsi_np *np, struct iscsi=
t_conn *conn)

[ ... ]

> @@ -2497,32 +2530,25 @@ isert_free_np(struct iscsi_np *np)

[ ... ]

> +	for (;;) {
> +		mutex_lock(&isert_np->mutex);
> +		isert_conn =3D isert_np_take_conn(isert_np, &promoted);
> +		mutex_unlock(&isert_np->mutex);
> +
> +		if (!isert_conn)
> +			break;
> +
> +		isert_info("cleaning isert_conn %p state (%d)\n",
> +			   isert_conn, isert_conn->state);
> +		if (promoted)
> +			isert_put_conn(isert_conn);
> +		isert_put_conn(isert_conn);
>  	}

[Severity: Critical]
Can skipping ib_drain_qp(isert_conn->qp) when isert_free_np() takes ownersh=
ip
of the connection cause a use-after-free in isert_login_recv_done()?

During RDMA_CM_EVENT_CONNECT_REQUEST, isert_connect_request() allocates a QP
using a shared workqueue-polled CQ from ib_cq_pool_get(..., IB_POLL_WORKQUE=
UE),
posts the login receive WR with wr_cqe =3D &isert_conn->login_desc->rx_cqe
(callback isert_login_recv_done) via isert_login_post_recv(), and transitio=
ns
the QP to RTS in isert_rdma_accept() before adding isert_conn->node to
isert_np->accepted.

When an IB_CM_REJ_RECEIVED event (or a cma_rep_recv() failure) occurs,
cma_ib_handler() calls cma_modify_qp_err() before invoking
cma_cm_event_handler() -> isert_cma_handler() -> isert_connect_error(). That
QP state transition flushes the pre-posted login receive WR into the shared=
 CQ
and queues cq->work (ib_cq_poll_work). Likewise, for a connection on
isert_np->accepted or isert_np->pending, the remote initiator may already h=
ave
sent a login PDU that completed into the shared CQ.

Previously, isert_connect_error() unconditionally called
ib_drain_qp(isert_conn->qp) at the start of the function (added in commit
cd52cb26e7ea ("IB/isert: Fix use-after-free in isert_connect_error")) before
taking isert_np->mutex. With this change, if isert_free_np() unlinks
isert_conn->node via isert_np_take_conn() first, isert_connect_error() sees
!owned and returns 0 without draining the QP, and neither isert_free_np() n=
or
isert_connect_release() calls ib_drain_qp(isert_conn->qp):

drivers/infiniband/ulp/isert/ib_isert.c:isert_connect_release() {
	...
	if (isert_conn->cm_id &&
	    !isert_conn->dev_removed)
		rdma_destroy_id(isert_conn->cm_id);

	if (isert_conn->qp)
		isert_destroy_qp(isert_conn);

	isert_unmap_tx_desc(&isert_conn->login_tx_desc, device->ib_device);

	if (isert_conn->login_desc)
		isert_free_login_buf(isert_conn);
	...
	kfree(isert_conn);
}

Because isert_destroy_qp() releases the shared CQ via ib_cq_pool_put(), whi=
ch
only decrements cq->cqe_used without canceling or flushing cq->work, can
ib_cq_poll_work concurrently invoke isert_login_recv_done() and dereference
wc->qp->qp_context, isert_conn->device, isert_conn->login_desc, and
isert_conn->mutex after isert_connect_release() has already freed them?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103032924.1073=
138-1-yhlee@isslab.korea.ac.kr?part=3D1
