Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793678210;
	b=q3vHZF2Do0axPe7gP1oQfMfhvJggtPEMdSef6d/lomUabnO1CPO15Vqwc6Ek+4QyrUOl
	 HGM+COATWfajecWMVNyW4KUk7zU1dUYdWLrkqwHOXpvrulm9WP321hCbMX3D2dE8VUlam
	 YKwoJ+42g08NhiISoCwc2Qk/L7gw606adxIE2swUN9AfIFO3ezUvDJo4qx3yunL7859TH
	 7rZMv2VR0IRlpmWkcR8mnob90mWQsUShedJH6WTod7NE6d7nANl6iNXA7XTQL26RpBKpE
	 gcEjtGPBDyWTa2rF1JY/9raPwQLOps9bR4R2LbslhoxYPscWLrybl1mHcc6/gMbT2FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793678210;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FtGi3s2UvkJR3RzSGKTla7Hz2Hp1Zqs/NhkGfiE84M4=;
	b=Isrms+rBcv/2RjfLuStZvRNvBeqKQb5Q/SYyuJlft29ApzDabfqxunxrAuFMgCQDo7xl
	 fF4T9KgDhlI6RNg5joxp1C5wWsWJjcWEMGV61NbuucWpRBNLv+WBsXW5rupHXaOdLGcx7
	 MT90/scNgEVEwFGIursj09/hD5uON8CJ0yZX0DbYloCadGuinbZyMFAO9GJj+B8fkxYmr
	 QOchfjlaey8091MI+wmgh2WJ1l8eFVLqrEmDAM+uUea1lxaUGEUw21uNFOlS85NNfBXSY
	 JdDWRNMLkTlMLk2DqxhuLFpRPKo8m67b0Egoehsmqncur0FFaQOupAMA+oXz6CtCh5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh9ZvgJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C8606A324;
	Tue,  3 Nov 2026 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh9ZvgJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440EC1F00A15;
	Tue,  3 Nov 2026 03:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793678209;
	bh=FtGi3s2UvkJR3RzSGKTla7Hz2Hp1Zqs/NhkGfiE84M4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jh9ZvgJwKxIQ2/yvcb6JEfZMsly8mSkq3bMj3IK6APVMcV2+9R8a/cwp1J6xQ+xnj
	 82Lxxqb0IWXDA29wx7nbQ3bQvEQ83yZw/hQ494clklVwCWSLcgpFeMOxDmPrD6Sx65
	 A9h5e/aHWJPQzd8t5yv326wO/60QpwVqUyv/lfRu53uwNKjJncYOj9mB3KHfJNvsBQ
	 MQz9EjltQTmH42OgbdggFcW3Gkyhg+MJEZpLv8kmeGItjpGnplFdenJ74GL+KfFS1P
	 9K/Z+S0337fUYz4JINjNLu8Jmw1Yg2vSGo9NKHgBa5OjVp0P05umr9YQbXDAzd7wsg
	 JXrJNvt4VQAPA==
Message-ID: <sashiko-outbox-194551@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/3] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261103032924.1073138-4-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
 <20261103032924.1073138-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:56:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] IB/isert: race between isert_teardown_conn() and isert_connect=
_error()
- [High] IB/isert: QP destroyed after accept in isert_connect_request() on =
removal
- [High] IB/isert: new isert_device created after isert_remove_one() comple=
tes
- [High] IB/isert: race between isert_teardown_conn() and isert_accept_np()
--

commit b4ccbe89413aac4cc5fc070bd4b49d33beb67439
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: tear connections down from an ib_client on device removal

This commit registers an ib_client removal callback to tear down iSER
connections without holding the rdma_cm_id handler_mutex, waiting for the
last isert_device reference to be dropped and reference counting isert_np.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index c6f417bb20690..5486fbdc6aa39 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c

[ ... ]

> @@ -456,20 +466,42 @@ isert_connect_request(struct rdma_cm_id *cma_id, st=
ruct rdma_cm_event *event)
>  		goto out_rsp_dma_map;
>  	}
> =20
> +	if (READ_ONCE(device->removing)) {
> +		isert_info("device %p is being removed, rejecting conn %p\n",
> +			   device, isert_conn);
> +		ret =3D -ENODEV;
> +		goto out_destroy_qp;
> +	}
> +
>  	ret =3D isert_login_post_recv(isert_conn);
>  	if (ret)
>  		goto out_destroy_qp;
> =20
>  	ret =3D isert_rdma_accept(isert_conn);
>  	if (ret)
> -		goto out_destroy_qp;
> -
> +		goto out_drain_qp;
> +	accepted =3D true;
> +
> +	mutex_lock(&isert_conn_mutex);
> +	if (device->removing) {
> +		mutex_unlock(&isert_conn_mutex);
> +		isert_info("device %p is being removed, dropping conn %p\n",
> +			   device, isert_conn);
> +		ret =3D -ENODEV;
> +		goto out_drain_qp;
> +	}
> +	isert_conn->np =3D isert_np;
> +	kref_get(&isert_np->kref);
> +	list_add_tail(&isert_conn->conn_list, &isert_conn_list);
>  	mutex_lock(&isert_np->mutex);
>  	list_add_tail(&isert_conn->node, &isert_np->accepted);
>  	mutex_unlock(&isert_np->mutex);
> +	mutex_unlock(&isert_conn_mutex);
> =20
>  	return 0;
> =20
> +out_drain_qp:
> +	ib_drain_qp(isert_conn->qp);
>  out_destroy_qp:
>  	isert_destroy_qp(isert_conn);
>  out_rsp_dma_map:
> @@ -478,7 +510,9 @@ isert_connect_request(struct rdma_cm_id *cma_id, stru=
ct rdma_cm_event *event)
>  	isert_device_put(device);
>  out:
>  	kfree(isert_conn);
> -	rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
> +	/* cma destroys an accepted cm id when this handler returns an error. */
> +	if (!accepted)
> +		rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
>  	return ret;
>  }

[Severity: High]
As reported by Sashiko on v3 [1], if device->removing becomes true between
the unlocked READ_ONCE(device->removing) check and mutex_lock(&isert_conn_m=
utex)
in isert_connect_request(), isert_rdma_accept() has already succeeded, yet
the error path jumps to out_drain_qp -> out_destroy_qp and calls
ib_destroy_qp(isert_conn->qp) before returning -ENODEV to the RDMA CM
CONNECT_REQUEST handler.

On iWARP transports, cma_accept_iw() -> iw_cm_accept() sets
IWCM_F_CONNECT_WAIT, stores cm_id_priv->qp =3D qp, and takes a provider QP
reference via iw_add_ref(qp) that is not released until iw_destroy_cm_id() =
or
cm_close_handler() runs on iwcm_wq after the CONNECT_REQUEST callback
returns. Won't calling ib_destroy_qp() here before returning from
isert_connect_request() deadlock in iWARP provider destroy_qp callbacks that
wait for the QP reference count to drop to zero (such as siw_destroy_qp() or
_irdma_destroy_qp()), or deadlock destroy_cm_id() on iwcm_wq waiting for
IWCM_F_CONNECT_WAIT to clear after iw_conn_req_handler() returns an error?

Also on IB/RoCE, doesn't destroying isert_conn->qp directly with
ib_destroy_qp() after cma_accept_ib() has already sent the CM REP leave
cma_id->qp pointing to a freed QP while the CM ID is still being torn down?

[ ... ]

> @@ -628,17 +695,17 @@ isert_np_cma_handler(struct isert_np *isert_np,
>  	return -1;
>  }
> =20
> -static int
> -isert_disconnected_handler(struct rdma_cm_id *cma_id,
> -			   enum rdma_cm_event_type event)
> +static void
> +isert_teardown_conn(struct isert_conn *isert_conn)
>  {
> -	struct isert_conn *isert_conn =3D cma_id->qp->qp_context;
>  	bool terminated =3D false;
> =20
>  	mutex_lock(&isert_conn->mutex);
>  	switch (isert_conn->state) {
>  	case ISER_CONN_TERMINATING:
> +	case ISER_CONN_DOWN:
>  		break;
> +	case ISER_CONN_INIT:
>  	case ISER_CONN_UP:
>  		terminated =3D isert_conn_terminate(isert_conn);
>  		break;
> @@ -652,10 +719,20 @@ isert_disconnected_handler(struct rdma_cm_id *cma_i=
d,
>  	}
>  	mutex_unlock(&isert_conn->mutex);
> =20
> -	if (terminated) {
> -		ib_drain_qp(isert_conn->qp);
> -		isert_handle_unbound_conn(isert_conn);
> -	}
> +	if (!terminated)
> +		return;
> +
> +	ib_drain_qp(isert_conn->qp);
> +	isert_handle_unbound_conn(isert_conn);
> +}

[Severity: Critical]
Can isert_teardown_conn() called from isert_remove_one() race with
isert_connect_error()?

Previously, connection teardown and connection error handling both ran under
the cm_id handler_mutex, and ISER_CONN_INIT was not handled in
isert_disconnected_handler(). With this change, isert_remove_one() takes a
reference on isert_conn via kref_get_unless_zero(&isert_conn->kref) and cal=
ls
isert_teardown_conn() outside the cm_id handler_mutex, while
isert_connect_error() does not take isert_conn->mutex or update
isert_conn->state:

drivers/infiniband/ulp/isert/ib_isert.c:isert_connect_error() {
	mutex_lock(&isert_np->mutex);
	owned =3D !list_empty(&isert_conn->node);
	list_del_init(&isert_conn->node);
	mutex_unlock(&isert_np->mutex);

	if (!owned) {
		isert_info("conn %p is being released already\n", isert_conn);
		return 0;
	}

	ib_drain_qp(isert_conn->qp);
	isert_conn->cm_id =3D NULL;
	isert_put_conn(isert_conn);

	return -1;
}

If isert_connect_error() runs after isert_remove_one() grabs a kref on a
connection in ISER_CONN_INIT and before isert_remove_one() calls
isert_teardown_conn(), isert_connect_error() sets isert_conn->cm_id =3D NUL=
L,
drops only the initial kref, and returns -1 (causing RDMA CM to destroy
cma_id), leaving isert_conn->state as ISER_CONN_INIT. When
isert_remove_one() then calls isert_teardown_conn() ->
isert_conn_terminate(), won't rdma_disconnect(isert_conn->cm_id) dereference
a NULL (or freed) cm_id?

Conversely, if isert_teardown_conn() runs isert_conn_terminate() first, it
sets isert_conn->state =3D ISER_CONN_TERMINATING and drops isert_conn->mute=
x to
call ib_drain_qp(isert_conn->qp) before isert_handle_unbound_conn() unlinks
isert_conn->node. While ib_drain_qp() is sleeping, can't a concurrent
isert_connect_error() see !list_empty(&isert_conn->node), unlink it, call
ib_drain_qp(isert_conn->qp) concurrently on the same QP, clear
isert_conn->cm_id =3D NULL, and free cma_id?

Also, if RDMA_CM_EVENT_UNREACHABLE triggers isert_connect_error() after
isert_connected_handler() has promoted the connection to ISER_CONN_UP (with
isert_conn->promoted =3D=3D true and an extra kref), isert_connect_error()
unlinks isert_conn->node without dropping the promoted reference. Won't that
leak isert_conn and hang wait_for_completion(&removal_comp) in
isert_remove_one()?

[ ... ]

> @@ -2480,6 +2546,7 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_=
conn *conn)
>  	isert_conn =3D list_first_entry(&isert_np->pending,
>  			struct isert_conn, node);
>  	list_del_init(&isert_conn->node);
> +	isert_conn->promoted =3D false;
>  	mutex_unlock(&isert_np->mutex);
> =20
>  	conn->context =3D isert_conn;

[Severity: High]
What happens if isert_teardown_conn() races with isert_accept_np() on a
connection in ISER_CONN_UP?

In isert_teardown_conn(), when isert_conn->state is ISER_CONN_UP, it sets
isert_conn->state =3D ISER_CONN_TERMINATING under isert_conn->mutex, unlocks
isert_conn->mutex, and calls ib_drain_qp(isert_conn->qp) before calling
isert_handle_unbound_conn() to unlink isert_conn->node from
isert_np->pending.

During that ib_drain_qp() window, isert_accept_np() only acquires
isert_np->mutex (without acquiring isert_conn->mutex or checking
isert_conn->state):

	mutex_lock(&isert_np->mutex);
	if (list_empty(&isert_np->pending)) {
		mutex_unlock(&isert_np->mutex);
		goto accept_wait;
	}
	isert_conn =3D list_first_entry(&isert_np->pending,
			struct isert_conn, node);
	list_del_init(&isert_conn->node);
	isert_conn->promoted =3D false;
	mutex_unlock(&isert_np->mutex);

	conn->context =3D isert_conn;
	isert_conn->conn =3D conn;
	isert_conn->state =3D ISER_CONN_BOUND;

If isert_accept_np() pops the connection from isert_np->pending while
ib_drain_qp() is in progress, it overwrites isert_conn->state from
ISER_CONN_TERMINATING to ISER_CONN_BOUND. Then isert_handle_unbound_conn()
sees list_empty(&isert_conn->node) and does nothing, while
isert_teardown_conn() never called iscsit_cause_connection_reinstatement()
because the state was ISER_CONN_UP when it checked. If the login request PDU
already arrived before the QP drained and finishes a single-stage login, the
login timer is stopped and iscsi_target_rx_thread() blocks in
isert_get_rx_pdu() -> wait_for_completion_interruptible(&comp) on the
already-drained QP. Doesn't this leave the connection stuck and hang
isert_remove_one() at wait_for_completion(&removal_comp)?

[ ... ]

> @@ -2717,8 +2783,61 @@ static struct iscsit_transport iser_target_transpo=
rt =3D {
>  	.iscsit_get_sup_prot_ops =3D isert_get_sup_prot_ops,
>  };
> =20
> +static void
> +isert_remove_one(struct ib_device *ib_device, void *client_data)
> +{
> +	DECLARE_COMPLETION_ONSTACK(removal_comp);
> +	struct isert_device *device, *found =3D NULL;
> +	struct isert_conn *isert_conn, *tmp;
> +	LIST_HEAD(removal_list);
> +
> +	mutex_lock(&device_list_mutex);
> +	list_for_each_entry(device, &device_list, dev_node) {
> +		if (device->ib_device !=3D ib_device)
> +			continue;
> +		device->refcount++;
> +		device->removal_comp =3D &removal_comp;
> +		found =3D device;
> +		break;
> +	}
> +	mutex_unlock(&device_list_mutex);
> +
> +	if (!found)
> +		return;
> +
> +	mutex_lock(&isert_conn_mutex);
> +	WRITE_ONCE(found->removing, true);
> +	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
> +		if (isert_conn->device !=3D found)
> +			continue;
> +		/* A connection with no reference left is already releasing. */
> +		if (!kref_get_unless_zero(&isert_conn->kref))
> +			continue;
> +		list_add_tail(&isert_conn->removal_node, &removal_list);
> +	}
> +	mutex_unlock(&isert_conn_mutex);
> +
> +	list_for_each_entry_safe(isert_conn, tmp, &removal_list, removal_node) {
> +		list_del_init(&isert_conn->removal_node);
> +		isert_info("removing conn %p state %d\n",
> +			   isert_conn, isert_conn->state);
> +		isert_teardown_conn(isert_conn);
> +		isert_put_conn(isert_conn);
> +	}
> +
> +	isert_device_put(found);
> +	wait_for_completion(&removal_comp);
> +}

[Severity: High]
As reported by Sashiko on v2 [2], because isert_ib_client is registered aft=
er
cma_client, disable_device() invokes isert_remove_one() before
cma_remove_one() destroys listening RDMA CM IDs.

In ib_isert.c, struct isert_device is only present on device_list while its
refcount is non-zero: if there are no active connections when
isert_remove_one() runs (or once existing connections drop the refcount to 0
in isert_device_put() and complete removal_comp), the isert_device is remov=
ed
from device_list and freed, and isert_remove_one() returns.

If an incoming RDMA_CM_EVENT_CONNECT_REQUEST arrives on a listener before
cma_remove_one() runs, won't isert_device_get() find no matching entry in
device_list, allocate a fresh struct isert_device with removing =3D=3D fals=
e, and
accept the new connection after isert_remove_one() has already completed?
When cma_remove_one() then delivers RDMA_CM_EVENT_DEVICE_REMOVAL to that
connection, isert_disconnected_handler() queues release_work asynchronously,
and isert_connect_release() calls rdma_destroy_id() (which unblocks
cma_remove_one()) before destroying the QP, returning the shared CQ to the
pool, unmapping DMA buffers, and deallocating the PD.

[1] https://lore.kernel.org/r/20261102061608.617186-3-yhlee@isslab.korea.ac=
.kr
[2] https://lore.kernel.org/r/sashiko-outbox-184744@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103032924.1073=
138-1-yhlee@isslab.korea.ac.kr?part=3D3
