Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005914;
	b=zlkLmKCdys+Pm3eqF7HSRyKCdiYvW7uVSGnY8stWG7036UkffkeJ+PCDd7eUtyYWhCyv
	 BfbpWZ/fpCmwdQafzDXAizfihqGL759PU+AjlMz25nh0JS39PajQyiVTS9FiQF14ToVPO
	 y3V5qLfFnkwpt5Iym5NzSZvegG7m310OeChMGK0mO7tz6aZpmytljMPA2QwnMQNxASVEs
	 eJqyCbYNhzK6sDMQoyeb++bv52TYvYGQtI5kviy5oBDNUHNQwk8gcnF82Qj5jiYQxTgnl
	 PGqIrzYoy8jPPHH9eVH/ZsTtplDngeP0jUKsQ222KFcjQzQRSAaAoBng2gFfn/1LPwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005914;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6gqSwF+mx2cO1Cdnbv6gIakH6+eKz9t4/ixe7Ef/3DI=;
	b=zqBdrs+SqCgUxRhR2l+UddVvO44jbTmIw+sbiHr9S8Y+WU0Y2gpzK/2M39NfwnE2zRYc
	 2krHRBFERCO5pb+dmLzfybDTBxtYrhnPOhZLPB6xgkzc8Nb8lJcDEKYVOwlj8oJKd7Y+g
	 xCWBmv9lplw8P7QT6ZEmTeeUhYHf009lzmgRGjJTcuVMTI4Xksn1XnmgCRed3cUwjMJh0
	 6AKwVVd4vQunE7ird3cLhO8IEHwe+Hh8GFnZZEBfFOxO3x+q0kIhjYrU656rie2LD4L+a
	 aEn805pdqDciJa1AMdZ7frSizIWIgm0ZYGW5Q6CvT2unUIt+KVEzf9tBHaUXVI0HtLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dESB876m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4504C606A31A;
	Mon, 26 Oct 2026 09:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dESB876m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B0A1F01825;
	Mon, 26 Oct 2026 09:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005913;
	bh=6gqSwF+mx2cO1Cdnbv6gIakH6+eKz9t4/ixe7Ef/3DI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dESB876mNRY5qx2vPi2e63IMMwIMhQ2oKTUQ9fm4fLyrNjSsq8o9b4f5HX4zqpzaL
	 mOkMzPAPposDpFF3btDpSyGbGETgDFOPMDovnP6Z/ApjEUfVP5eKfny2MKqam4bf5K
	 d6xVjaxs4+lZf1X3W36T884aGWcMiJ8zREUXEwDd4Abpw6rAoZIGI5LexumGJkkbuh
	 Nk/fJ7Q9BXZvJwOjNb7lJYPAsuulwlUg6Qce+aqNfjGT5Lb0smIDFE2/FjxCejO6RZ
	 SAVCv95SwpMGKaE/pNbms8xfRhltVkX5cuLGmuZMhs/bXqLyNFtrDv3/3AntFO3gg3
	 yM1oc8/HNEyMg==
Message-ID: <sashiko-outbox-184744@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 RESEND] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026060505.409476-1-yhlee@isslab.korea.ac.kr>
References: <20261026060505.409476-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:11:53 +0000
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
- [Critical] IB/isert: race between isert_remove_one() and isert_free_np() =
on unbound conns
- [Critical] IB/isert: race between isert_connected_handler() and isert_rem=
ove_one() causes UAF
- [High] IB/isert: deadlock in isert_remove_one() on ISER_CONN_INIT connect=
ions
- [High] IB/isert: deadlock in device removal on racing or init-state conne=
ctions
--

commit 45ee38abdcac16c81f48c4efea555fb873360442
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: tear connections down from an ib_client on device removal

This commit registers an ib_client for ib_isert to tear down connections and
wait for the last isert_device reference during device removal instead of
waiting in the RDMA_CM_EVENT_DEVICE_REMOVAL callback. It also removes
isert_conn->dev_removed and isert_conn->rem_wait so that
isert_connect_release() is the sole place that destroys the cm_id and frees
isert_conn.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index efa8d7b7844c9..35e4b9c917bd6 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c

[ ... ]

> @@ -625,13 +637,10 @@ isert_np_cma_handler(struct isert_np *isert_np,
>  	return -1;
>  }
> =20
> -static int
> -isert_disconnected_handler(struct rdma_cm_id *cma_id,
> -			   enum rdma_cm_event_type event)
> +/* Must be called with isert_conn->mutex held. */
> +static void
> +isert_teardown_conn(struct isert_conn *isert_conn)
>  {
> -	struct isert_conn *isert_conn =3D cma_id->qp->qp_context;
> -
> -	mutex_lock(&isert_conn->mutex);
>  	switch (isert_conn->state) {
>  	case ISER_CONN_TERMINATING:
>  		break;
> @@ -648,6 +657,16 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
>  		isert_warn("conn %p terminating in state %d\n",
>  			   isert_conn, isert_conn->state);
>  	}
> +}

[Severity: High]
What happens in isert_teardown_conn() when a connection is still in
ISER_CONN_INIT during device removal?

During IB device unregistration, disable_device() invokes ib_client->remove
callbacks in reverse registration order:

drivers/infiniband/core/device.c:disable_device() {
	...
	while (cid) {
		cid--;
		remove_client_context(device, cid);
	}
}

Because isert_ib_client is registered after cma_client and cm_client,
isert_remove_one() runs and blocks on wait_for_completion(&removal_comp)
before cma_remove_one() and cm_remove_one() are called.

If a connection has processed RDMA_CM_EVENT_CONNECT_REQUEST in
isert_connect_request(), it holds a reference on isert_device and is on
isert_conn_list in state ISER_CONN_INIT. When isert_remove_one() calls
isert_teardown_conn(), ISER_CONN_INIT hits the default branch and only logs=
 a
warning without terminating the connection.

Because cma_remove_one() and cm_remove_one() have not run yet, the CM remai=
ns
active while isert_remove_one() waits on removal_comp. If the peer's RTU
arrives, RDMA_CM_EVENT_ESTABLISHED invokes isert_connected_handler():

drivers/infiniband/ulp/isert/ib_isert.c:isert_connected_handler() {
	...
	mutex_lock(&isert_conn->mutex);
	isert_conn->state =3D ISER_CONN_UP;
	kref_get(&isert_conn->kref);
	mutex_unlock(&isert_conn->mutex);
}

Since isert_remove_one() already finished its single pass over
isert_conn_list and cma_remove_one() is blocked behind isert_remove_one(),
won't this connection remain in ISER_CONN_UP (or advance to ISER_CONN_BOUND=
 /
ISER_CONN_FULL_FEATURE via isert_accept_np()) without anything ever tearing
it down, causing wait_for_completion(&removal_comp) in isert_remove_one() to
hang forever?

Similarly, on iWARP (where a failed passive connection in ISER_CONN_INIT
delivers IW_CM_EVENT_CLOSE -> RDMA_CM_EVENT_DISCONNECTED rather than
RDMA_CM_EVENT_UNREACHABLE) or if RDMA_CM_EVENT_DEVICE_REMOVAL reaches an
ISER_CONN_INIT connection (where cma_send_device_removal_put() sets
id_priv->state =3D RDMA_CM_DEVICE_REMOVAL so cma_ib_handler() drops subsequ=
ent
IB_CM_REP_ERROR / RDMA_CM_EVENT_UNREACHABLE events), won't
isert_disconnected_handler() -> isert_teardown_conn() ignore ISER_CONN_INIT
and leak the connection reference?

[ ... ]

> @@ -2689,8 +2701,60 @@ static struct iscsit_transport iser_target_transpo=
rt =3D {
>  	.iscsit_get_sup_prot_ops =3D isert_get_sup_prot_ops,
>  };
> =20
> +static void
> +isert_remove_one(struct ib_device *ib_device, void *client_data)
> +{
> +	DECLARE_COMPLETION_ONSTACK(removal_comp);
> +	struct isert_device *device, *found =3D NULL;
> +	struct isert_conn *isert_conn;
> +
> +	/*
> +	 * Not from the RDMA_CM_EVENT_DEVICE_REMOVAL callback: that one runs
> +	 * with the cm_id's handler mutex held, which a teardown already
> +	 * destroying that cm_id needs.  Same reason as
> +	 * commit f1d4ef7d8883 ("nvmet-rdma: register ib_client to not
> +	 * deadlock in device removal").
> +	 */
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

[Severity: High]
Because isert_remove_one() runs before cma_remove_one(), listening RDMA CM
IDs (isert_np->cm_id and per-device child listeners) are still in
RDMA_CM_LISTEN and continue delivering RDMA_CM_EVENT_CONNECT_REQUEST until
cma_remove_one() destroys them.

In isert_connect_request(), isert_device_get() increments device->refcount
under device_list_mutex without checking whether removal is in progress, and
isert_conn is only added to isert_conn_list after allocating login buffers,
creating the QP/CQ, posting a recv WR, and calling isert_rdma_accept():

drivers/infiniband/ulp/isert/ib_isert.c:isert_connect_request() {
	...
	device =3D isert_device_get(cma_id);
	if (IS_ERR(device)) {
		ret =3D PTR_ERR(device);
		goto out;
	}
	isert_conn->device =3D device;
	...
	mutex_lock(&isert_conn_mutex);
	list_add_tail(&isert_conn->conn_list, &isert_conn_list);
	mutex_unlock(&isert_conn_mutex);
}

If isert_remove_one() scans isert_conn_list while isert_connect_request() is
between isert_device_get() and list_add_tail(&isert_conn->conn_list,
&isert_conn_list), or if a new RDMA_CM_EVENT_CONNECT_REQUEST arrives while
isert_remove_one() is blocked in wait_for_completion(&removal_comp), can the
new connection acquire a reference on found and be added to isert_conn_list
after isert_remove_one() has already finished iterating the list, causing
wait_for_completion(&removal_comp) to hang?

Also, if isert_remove_one() returns (either immediately when found is NULL =
or
after removal_comp completes) and a new RDMA_CM_EVENT_CONNECT_REQUEST arriv=
es
before cma_remove_one() destroys the listener, won't isert_device_get()
allocate a new struct isert_device on the removing ib_device after
isert_remove_one() has already finished? When cma_remove_one() ->
cma_process_remove() then runs cma_send_device_removal_put() on that new
connection's cm_id, id_priv->state is set to RDMA_CM_DEVICE_REMOVAL and
isert_cma_handler() returns 0; if the connection is still in ISER_CONN_INIT,
cma_ib_handler() drops all subsequent non-timewait IB CM events:

drivers/infiniband/core/cma.c:cma_ib_handler() {
	...
	mutex_lock(&id_priv->handler_mutex);
	state =3D READ_ONCE(id_priv->state);
	if ((ib_event->event !=3D IB_CM_TIMEWAIT_EXIT &&
	     state !=3D RDMA_CM_CONNECT) ||
	    (ib_event->event =3D=3D IB_CM_TIMEWAIT_EXIT &&
	     state !=3D RDMA_CM_DISCONNECT))
		goto out;
}

Wouldn't that prevent rdma_destroy_id() from ever being called and deadlock
cma_process_remove() at wait_for_completion(&cma_dev->comp)?

> +
> +	mutex_lock(&isert_conn_mutex);
> +	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
> +		if (isert_conn->device !=3D found)
> +			continue;
> +
> +		isert_info("removing conn %p state %d\n",
> +			   isert_conn, isert_conn->state);
> +		mutex_lock(&isert_conn->mutex);
> +		isert_teardown_conn(isert_conn);
> +		mutex_unlock(&isert_conn->mutex);

[Severity: Critical]
Can isert_remove_one() race with isert_free_np() on unbound connections in
ISER_CONN_UP and corrupt drop_conn_list or double-free isert_conn?

When an iSCSI network portal is deleted, isert_free_np() moves connections
from isert_np->pending and isert_np->accepted onto a stack-local
drop_conn_list under isert_np->mutex, and then releases isert_np->mutex
before calling isert_connect_release() on each entry:

drivers/infiniband/ulp/isert/ib_isert.c:isert_free_np() {
	...
	mutex_lock(&isert_np->mutex);
	if (!list_empty(&isert_np->pending)) {
		...
		list_for_each_entry_safe(isert_conn, n,
					 &isert_np->pending,
					 node) {
			...
			list_move_tail(&isert_conn->node, &drop_conn_list);
		}
	}
	...
	mutex_unlock(&isert_np->mutex);

	list_for_each_entry_safe(isert_conn, n, &drop_conn_list, node) {
		list_del_init(&isert_conn->node);
		isert_connect_release(isert_conn);
	}
}

Because those connections remain on isert_conn_list until
isert_connect_release() acquires isert_conn_mutex and removes them, a
concurrent isert_remove_one() walking isert_conn_list can find a connection=
 in
ISER_CONN_UP that isert_free_np() has already moved onto drop_conn_list.

When isert_remove_one() calls isert_teardown_conn() ->
isert_handle_unbound_conn(), it checks !list_empty(&isert_conn->node) under
isert_np->mutex:

drivers/infiniband/ulp/isert/ib_isert.c:isert_handle_unbound_conn() {
	...
	mutex_lock(&isert_np->mutex);
	if (!list_empty(&isert_conn->node)) {
		list_del_init(&isert_conn->node);
		isert_put_conn(isert_conn);
		queue_work(isert_release_wq, &isert_conn->release_work);
	}
	mutex_unlock(&isert_np->mutex);
}

Since isert_conn->node is still linked into drop_conn_list,
!list_empty(&isert_conn->node) is true. Doesn't isert_handle_unbound_conn()
then mutate drop_conn_list via list_del_init(&isert_conn->node) while
isert_free_np() is traversing it without isert_np->mutex, and queue
isert_conn->release_work so that both isert_free_np() and
isert_release_work() call isert_connect_release(isert_conn)?

[Severity: Critical]
Could calling isert_teardown_conn() from isert_remove_one() without the
cm_id's handler_mutex also race with isert_connected_handler() and cause a
use-after-free?

Previously, both isert_connected_handler() and isert_disconnected_handler()
were called from isert_cma_handler() under the cm_id's handler_mutex. In
isert_connected_handler(), isert_conn->mutex is released after setting
ISER_CONN_UP and before acquiring isert_np->mutex to move isert_conn->node
from isert_np->accepted to isert_np->pending:

drivers/infiniband/ulp/isert/ib_isert.c:isert_connected_handler() {
	...
	mutex_lock(&isert_conn->mutex);
	isert_conn->state =3D ISER_CONN_UP;
	kref_get(&isert_conn->kref);
	mutex_unlock(&isert_conn->mutex);

	mutex_lock(&isert_np->mutex);
	list_move_tail(&isert_conn->node, &isert_np->pending);
	mutex_unlock(&isert_np->mutex);

	isert_info("np %p: Allow accept_np to continue\n", isert_np);
	up(&isert_np->sem);
}

If isert_remove_one() acquires isert_conn->mutex in that window between
mutex_unlock(&isert_conn->mutex) and mutex_lock(&isert_np->mutex),
isert_teardown_conn() sees state =3D=3D ISER_CONN_UP, sets state to
ISER_CONN_TERMINATING, and calls isert_handle_unbound_conn(isert_conn).
Because isert_conn->node is still on isert_np->accepted,
isert_handle_unbound_conn() removes isert_conn->node with list_del_init(),
drops a kref via isert_put_conn(), and queues isert_conn->release_work.

When isert_connected_handler() then acquires isert_np->mutex, won't
list_move_tail(&isert_conn->node, &isert_np->pending) re-insert the
terminating connection onto isert_np->pending and wake isert_np->sem while
isert_release_work() drops the last kref and frees isert_conn in
isert_connect_release()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026060505.4094=
76-1-yhlee@isslab.korea.ac.kr?part=3D1
