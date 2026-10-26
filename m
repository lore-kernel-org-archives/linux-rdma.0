Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005786;
	b=DgHnKQa6/Ykybye8iN6aFfLIuicsFTqAHQ+nXb0KDRJCINVkw9LD0hMASVq5Jpzzbwiv
	 i9oKjSudasJvcsZ5c8bTp9vfyOn28XsQGhckCykY2qXv/7oKJUFxS1oqBTj3D53fXSlGV
	 DTXwsROBiJzHLZUuxEj4r1+yGr0xrZ1laAuZpXrWKLmAvHWM+wdwjaCOg1jzpNjHguuTR
	 FOM2VvE5Aj5b8v897ttprbkY7+1oHClgxwYPYeO3l1i2rgZzgk4QNtN/n1H+dvMDS3/EL
	 faVVn7yu9s/yQ4i+MSNgCo4SIAvsqyEZ0E6q++ZTOyxUk9Zv4jUoBybIy2WJaaTWDJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005786;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l4whMq9XVHLHGaJ4Ij7/L5MryUE7ioTaOFbg896wp+8=;
	b=HT+dya94QpMJ5oXs8USt7QdRBVzWk3+vPooL+uzFzNrPRVRJ/DGhAiR+MeaA9gSwPhaM
	 ScLuHhqcggYqj6Ol1LSbCmtTN8TOgUHIf0GvSiNZfYA8gRldU3nXWbPXwCZo6cJWm8VA8
	 B/TeRLOR/oSSQZjyjju8c+YwNAbj7eWSiiWEXzO6UuQYRxOBfNIt3qSTmmUIdAR1hX/0A
	 p90Dx4/d7YACW2F6x/akT/OiNzizQqJKpcozYo6g3hyjYujWZFFL3f2EqbUN5EzkM2V99
	 fMssc2VqoefPoYs55/NoEHrzTJMZqPqTDjDvRRHr1NrdPHsTuciNdmomL6Z6bGsg8Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKjdSLHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686F5606A31A;
	Mon, 26 Oct 2026 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKjdSLHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C481A1F01825;
	Mon, 26 Oct 2026 09:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005786;
	bh=l4whMq9XVHLHGaJ4Ij7/L5MryUE7ioTaOFbg896wp+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NKjdSLHZXdrTi5T+2WDBqKD1QeDIuznDg1mOVMT/MCmaCwwJ2hL9nlJ8q0FniV07Y
	 wTxhDcXmLyU99tkpJ9yfOooPnsWfVw5s0DrkiEV5CZnrUq5QK7sgGJHQ3ChIODSP0s
	 YQou5SsDeGCibvJawnxJ3wf92s57+L8I9wyoWe9xnN8a6eXXh518/Ae7eEHApNBw1M
	 ErmnsQYxtsa0RH3D/ZvB7gfikB7LO3wY2Hf26YRBNvZvydCuQyyhmlUazKByXiEMTD
	 Z6jmAkhYf3WrB4vTi3WKZXDNIwnx9XdOZjJ8phmsxkx/gXTNi1XbqLcVR90zHyxEdc
	 UsBSYaOT0yzjA==
Message-ID: <sashiko-outbox-184740@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] IB/isert: tear connections down from an ib_client on
 device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026041949.225619-1-yhlee@isslab.korea.ac.kr>
References: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr>
 <20261026041949.225619-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:09:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] IB/isert: race between isert_connected_handler() and isert_rem=
ove_one()
- [High] IB/isert: hang in isert_remove_one() on ISER_CONN_INIT and racing =
connects
--

commit 73bf46b98b888cdf4cb06784ff6926d47808ad06
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: tear connections down from an ib_client on device removal

This commit replaces the device removal wait in isert_cma_handler() with
an ib_client remove callback, isert_remove_one(), to tear down active
connections and wait for the final isert_device reference to be dropped
without holding the cm_id handler mutex.

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
[ ... ]
> @@ -695,21 +713,15 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct=
 rdma_cm_event *event)
>  		break;
>  	case RDMA_CM_EVENT_ADDR_CHANGE:
>  	case RDMA_CM_EVENT_DISCONNECTED:
> -	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
> -		ret =3D isert_disconnected_handler(cma_id, event->event);
> -		break;
> +	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
>  	case RDMA_CM_EVENT_DEVICE_REMOVAL:
> -		isert_conn =3D cma_id->qp->qp_context;
> -		isert_conn->dev_removed =3D true;
> -		isert_disconnected_handler(cma_id, event->event);
> -		wait_event_interruptible(isert_conn->rem_wait,
> -					 isert_conn->state =3D=3D ISER_CONN_DOWN);
> -		kfree(isert_conn);
>  		/*
> -		 * return non-zero from the callback to destroy
> -		 * the rdma cm id
> +		 * Device removal is driven by isert_remove_one().  Returning
> +		 * zero here keeps the cm_id; isert_connect_release() destroys
> +		 * it once the connection has been released.
>  		 */
> -		return 1;
> +		ret =3D isert_disconnected_handler(cma_id, event->event);
> +		break;
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
Can calling isert_teardown_conn() here without the cm_id handler_mutex
race with isert_connected_handler() and corrupt isert_np->pending or cause
a use-after-free of isert_conn?

Previously, both isert_connected_handler() and
isert_disconnected_handler() were only called from isert_cma_handler(),
which is serialized per cm_id by id_priv->handler_mutex.

Because disable_device() invokes ib_client remove callbacks before
cma_remove_one(), isert_remove_one() runs while RDMA_CM_EVENT_ESTABLISHED
can still be delivered to isert_connected_handler():

drivers/infiniband/ulp/isert/ib_isert.c:isert_connected_handler() {
	mutex_lock(&isert_conn->mutex);
	isert_conn->state =3D ISER_CONN_UP;
	kref_get(&isert_conn->kref);
	mutex_unlock(&isert_conn->mutex);

	mutex_lock(&isert_np->mutex);
	list_move_tail(&isert_conn->node, &isert_np->pending);
	mutex_unlock(&isert_np->mutex);
}

If isert_remove_one() acquires isert_conn->mutex in the window after
isert_connected_handler() drops isert_conn->mutex and before it acquires
isert_np->mutex, isert_teardown_conn() sees ISER_CONN_UP, transitions the
connection to ISER_CONN_TERMINATING, and calls
isert_handle_unbound_conn():

drivers/infiniband/ulp/isert/ib_isert.c:isert_handle_unbound_conn() {
	mutex_lock(&isert_np->mutex);
	if (!list_empty(&isert_conn->node)) {
		list_del_init(&isert_conn->node);
		isert_put_conn(isert_conn);
		queue_work(isert_release_wq, &isert_conn->release_work);
	}
	mutex_unlock(&isert_np->mutex);
}

Since isert_conn->node is still on isert_np->accepted at that moment,
isert_handle_unbound_conn() deletes it from isert_np->accepted, drops one
kref, and queues isert_conn->release_work.

When isert_connected_handler() then acquires isert_np->mutex, it executes
list_move_tail(&isert_conn->node, &isert_np->pending) and links the
terminating connection onto isert_np->pending while isert_release_work()
runs concurrently, drops the remaining kref, and frees isert_conn in
isert_connect_release().

> +	}
> +	mutex_unlock(&isert_conn_mutex);
> +
> +	isert_device_put(found);
> +	wait_for_completion(&removal_comp);

[Severity: High]
Could wait_for_completion(&removal_comp) hang indefinitely here when a
connection is still in ISER_CONN_INIT or when new connect requests arrive
during device removal?

In drivers/infiniband/core/device.c, disable_device() invokes client
remove callbacks in reverse registration order. Because ib_isert registers
isert_ib_client after rdma_cm and ib_cm register their clients,
isert_remove_one() runs to completion before cma_remove_one() starts (and
during module unload in isert_exit(), cma_remove_one() does not run at
all). This leaves a few paths where found->refcount is never dropped:

1. If a connection has been accepted by isert_connect_request() and is in
ISER_CONN_INIT when isert_remove_one() scans isert_conn_list,
isert_teardown_conn() hits the default case, logs a warning, and leaves
the connection in ISER_CONN_INIT. Because the CM is still active while
isert_remove_one() waits on removal_comp, an incoming RTU from the peer
will deliver RDMA_CM_EVENT_ESTABLISHED to isert_connected_handler(),
transitioning the connection to ISER_CONN_UP after isert_remove_one() has
already finished scanning isert_conn_list. At that point
RDMA_CM_EVENT_UNREACHABLE will never fire and cma_remove_one() is blocked
behind isert_remove_one(), so found->refcount never reaches zero.

2. Because the listening cm_id (isert_np->cm_id) is not destroyed until
cma_remove_one() runs after isert_remove_one(), a racing
RDMA_CM_EVENT_CONNECT_REQUEST in isert_connect_request() can call
isert_device_get() (which increments found->refcount even when
found->removal_comp is set) and append a new connection to isert_conn_list
after isert_remove_one() has already scanned the list.

3. If a new RDMA_CM_EVENT_CONNECT_REQUEST arrives after isert_remove_one()
returns (for instance when found was NULL or right after removal_comp
completes) and before cma_remove_one() destroys the listener,
isert_connect_request() creates a connection in ISER_CONN_INIT. When
cma_process_remove() -> cma_send_device_removal_put() then runs on that
cm_id, it sets id_priv->state =3D RDMA_CM_DEVICE_REMOVAL (suppressing any
later RDMA_CM_EVENT_UNREACHABLE in cma_ib_handler() / cma_iw_handler())
and calls isert_cma_handler(RDMA_CM_EVENT_DEVICE_REMOVAL). That calls
isert_teardown_conn(), which does nothing for ISER_CONN_INIT, and returns
0, leaving the cm_id undestroyed and blocking cma_process_remove() in
wait_for_completion(&cma_dev->comp).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026041949.2256=
19-1-yhlee@isslab.korea.ac.kr?part=3D1
