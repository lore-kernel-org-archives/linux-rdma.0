Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793757487;
	b=pb6p4LT6WpxEvIpRa7fRpaxxClNeEATQbpAcZqgu3mBK9dwlCcttwfLLXGiXiXV7jNki
	 TdM78CeEqlKEVb+0A8HGXgCDrA3ZUWtKLxaVF/MRXC7ILiOM3O1HdvSymj6zGFKH2xlz9
	 3ww/Wg8Rj/4zYSjPhku5runFSmXe3hDvOjGFeZYS/9Qsq2Oke+plGh8b24WMlf6MVm51b
	 +45R9E24PCYLIS3HiNt4mcSFbTmxVLIFBE2AE7PGFbm09DpknMPVU86dZIJClhqF0QTT7
	 HoWCT9AeTNKEWuGDFAAODczBbpjQW8I1RMyaAxP6vodelhIvepS6a89PDmCWscKDxuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793757487;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0u/iOpavIwnAL9U/KKE7NEQCYQWzU5PEpxb9/R3zqss=;
	b=FgBbBpOGxwevnS7w6OtwT/XFLm/guwP33QpBHwCVAawmM2M0gRW2dusbWPBx05/eg4ON
	 hM4u7xSZ9g7+Qr0mOFd1Uw0mAFSQl5J+I8aQKrffdQi1rc5RHBCpx2qZ7DCaRw9wQlJ7e
	 VtHj9kxx9x9embZer+6t/eyjfNG9ww/ZSe5buskrmhXqQ4MuRzF8rCBsk9CqY0ezXf49c
	 W448/k3UPCeablHm3BJdf7Vcnf1Iudc4zifYyPAOi6nPQWw9uz49iZMYzvv79HciO7eBi
	 HW0lETPAxwoNtMUmJbMf20mHkg4NHwIxtmikSqwu+TgfDrMsXKoak0s1WF0ws44alQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h/05oGSW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCDC606A328;
	Wed,  4 Nov 2026 01:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/05oGSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964441F000C1;
	Wed,  4 Nov 2026 01:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793757486;
	bh=0u/iOpavIwnAL9U/KKE7NEQCYQWzU5PEpxb9/R3zqss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h/05oGSWx+Rcrv8j3bTrliUBkZTE7bS9VdPpJZnM+UaEn9x2h7Usf9U9RQHQXFw1A
	 2PexVImRffUKiwryQ5kepQC8WzGCXu7f4JQHc9XlcBjl6+xpOBfOTTzDeO+1rUM6Jn
	 qbB7lvqUYmLKxZCQusZednJxWY7AAvMjm+QiXz/WGNIF+HmnUhx5BNJQoFVheYA6dZ
	 n8QpRk1Ex1IHvLQFH8mW2SLebWY8mdGXc+HtZZbl3Lrl4+F4PDwQSBkACB5EHsM0Hu
	 Q7b6JhpmHwk2ltH4XxvHGKjUq7FnrBsmP0F7AT3Z3QipupcIKu9QCyg0Db/55Vsoyp
	 SbjfFvs0JYbKQ==
Message-ID: <sashiko-outbox-196418@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 3/6] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261104012219.1759523-4-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
 <20261104012219.1759523-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:58:06 +0000
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
- [High] IB/isert: NULL cm_id dereference in isert_qp_event_callback()
--

commit 701b903737b3f3f8c4ac6d7d5a75f88a91eb010c
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: tear connections down from an ib_client on device removal

This patch registers an ib_client for isert to tear down device connections
from its remove callback instead of waiting and freeing connections inside =
the
RDMA_CM_EVENT_DEVICE_REMOVAL handler. It also adds reference counting for
isert_np and tracks connections on isert_conn_list under isert_conn_mutex.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 61b214012a70b..4812dabd93945 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c

[ ... ]

> @@ -661,20 +721,33 @@ isert_connect_error(struct rdma_cm_id *cma_id)
>  {
>  	struct isert_conn *isert_conn =3D cma_id->qp->qp_context;
>  	struct isert_np *isert_np =3D cma_id->context;
> -	bool owned;
> +	bool owned =3D false, bound =3D false;
> =20
> +	mutex_lock(&isert_conn->mutex);
>  	mutex_lock(&isert_np->mutex);
> -	owned =3D !list_empty(&isert_conn->node);
> -	list_del_init(&isert_conn->node);
> +	if (list_empty(&isert_conn->node)) {
> +		bound =3D isert_conn->state =3D=3D ISER_CONN_BOUND ||
> +			isert_conn->state =3D=3D ISER_CONN_FULL_FEATURE;
> +	} else {
> +		owned =3D true;
> +		list_del_init(&isert_conn->node);
> +	}
>  	mutex_unlock(&isert_np->mutex);
> =20
> +	if (owned) {
> +		isert_conn->cm_id =3D NULL;
> +	} else if (bound) {
> +		isert_conn_terminate(isert_conn);
> +		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
> +	}
> +	mutex_unlock(&isert_conn->mutex);
> +
>  	if (!owned) {
>  		isert_info("conn %p is being released already\n", isert_conn);
>  		return 0;
>  	}
> =20
>  	ib_drain_qp(isert_conn->qp);
> -	isert_conn->cm_id =3D NULL;
>  	isert_put_conn(isert_conn);
> =20
>  	return -1;

[Severity: High]
Can clearing isert_conn->cm_id before draining and destroying the QP cause a
NULL pointer dereference in isert_qp_event_callback()?

During passive connection setup, isert_connect_request() creates
isert_conn->qp with isert_qp_event_callback() as its event handler and calls
isert_rdma_accept() -> rdma_accept(), which transitions the QP to RTR/RTS.

When RDMA_CM_EVENT_UNREACHABLE, RDMA_CM_EVENT_REJECTED, or
RDMA_CM_EVENT_CONNECT_ERROR invokes isert_connect_error() while the connect=
ion
is still on isert_np->accepted or isert_np->pending (owned is true),
isert_conn->cm_id is now set to NULL before ib_drain_qp(isert_conn->qp) runs
and before the QP is destroyed. In addition, if isert_remove_one() holds a
reference on isert_conn via kref_get_unless_zero(), isert_put_conn() in
isert_connect_error() will not drop kref to zero, leaving isert_conn->qp al=
ive
with isert_conn->cm_id =3D=3D NULL until isert_remove_one() drops its refer=
ence.

On RDMA_CM_EVENT_UNREACHABLE, cma does not transition the QP to IB_QPS_ERR
before invoking the handler, and drivers such as mlx4 and mlx5 dispatch
IB_EVENT_COMM_EST asynchronously on a workqueue that is not synchronized by
ib_drain_qp(). If IB_EVENT_COMM_EST runs in isert_qp_event_callback() during
this window:

drivers/infiniband/ulp/isert/ib_isert.c:isert_qp_event_callback() {
	...
	switch (e->event) {
	case IB_EVENT_COMM_EST:
		rdma_notify(isert_conn->cm_id, IB_EVENT_COMM_EST);
		break;
	...
}

rdma_notify() will be called with a NULL cm_id and dereference
id_priv->cm_id.ib at a NULL base pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104012219.1759=
523-1-yhlee@isslab.korea.ac.kr?part=3D3
