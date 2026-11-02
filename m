Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601894;
	b=ZcRAMnq7Qzjnki9lM7U42GqkBknbHQPp0Kjit5Dw3Auh3psjJNuHVyhCVhopxz1xQEs0
	 0P+f+8E8v7xWVxdBBf4Q7CPFs0xPc2OeC+fUeiBlPhVqFDE3hNquNyuSzKGpHK/G/eNlr
	 lN9ojZNSrEuiMQrgp3vDN1u4/xyZ3yHMoFb3vC9sXSmsP7/xOMOFdeI8+BcQJu+h0yHt7
	 qGZ9mF95pfKNNl8nFLjMrnW6hetWgnIhcaqgFQ/HiazH5cHuHCRBAmvmQKVXRSBPDf7nn
	 DhSP/GMJnjAyhlfUP4RwbIxWAdis/1py+Wt7wJah3tzlB9g99d8BVHr+QmmP7fOJZ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601894;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CLT8W9DzftwgB4qFwnDteNsBQWMtTaGwHbGPfNFBweI=;
	b=GUbL2ep68VfSdY8ljnQA7UNriTAsSHEu9YDpCBr3i+8mKwWyGQZYQbJub1yvKkrcTL5V
	 LjyrukrVWw0ZV7oUxt7S4KDGdy868E8r4YQU0JMtvLyrQqgy4PKT1HWKWlmsuSJzOCoiI
	 WUEEtlrplk6vf51lMbHbRohJsCksbhWQkpFjqpTaIitdkY+Va7UO3ckpUDYNGWVYt1Fz0
	 r+OGBbH6TSPE8i790V4R7XbjseZ8vVhlr+9xBsUshaUPppW4rAL1EOu9NcvQ+6q4A5l8r
	 HeDb3NX7o2hCwgdGkkLRIhz4DZbDebLYpBLK2X9k4aHfe0ExF3IxONdYG3watmL9/5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBmCxm36;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A71C606A324;
	Mon,  2 Nov 2026 06:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBmCxm36
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5031F000C1;
	Mon,  2 Nov 2026 06:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793601894;
	bh=CLT8W9DzftwgB4qFwnDteNsBQWMtTaGwHbGPfNFBweI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CBmCxm36npVmthff4SGtzV873cCpvdpDIa+Iic7oubsI8Fo3JCfU/tCItryZvBonD
	 SXc2RcnwAMIZOM1HRBXCbr/LysmRuvzAQV/g8lk1ExeH28DnX2eRFJdw5qBiCT1uRY
	 NKQOWRDch5JTBJG6iZ2dnc5+Oemx2fpn2FiZrfSfMqJi6/ZI/HnGcs6kMnEg5rhi4L
	 zZR9ka9MbrFa0r8Hth26ZGYwbynTZi79ZvltxszHa/4P4RCBBL5CTTP5iW0ndghEn8
	 V0gSCVxTinwNM+jQAXSKQl2oKm+31xztPxDNMGNjCZ+IrcEU+GCfTns/etBk8SRMii
	 +iTuS6P+GmdQA==
Message-ID: <sashiko-outbox-192964@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261102061608.617186-3-yhlee@isslab.korea.ac.kr>
References: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
 <20261102061608.617186-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:44:53 +0000
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
- [Critical] IB/isert: UAF and invalid reject on removing check in isert_co=
nnect_request()
- [High] IB/isert: hang and connection leak in isert_teardown_conn() on ISE=
R_CONN_INIT
- [High] IB/isert: new isert_device and conn created after isert_remove_one=
() runs
- [High] IB/isert: ABBA deadlock calling ib_drain_qp() under isert_conn->mu=
tex
--

commit 0865225bbb6b53b508af1b272b6ebb49c8aac4d5
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: tear connections down from an ib_client on device removal

This commit replaces the RDMA_CM_EVENT_DEVICE_REMOVAL wait and kfree with an
ib_client removal callback (isert_remove_one) that tears down active
connections and waits for the last isert_device reference to be released.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 5371bba71ba3c..223a727c1d0de 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
[ ... ]
> @@ -464,9 +470,19 @@ isert_connect_request(struct rdma_cm_id *cma_id, str=
uct rdma_cm_event *event)
>  	if (ret)
>  		goto out_destroy_qp;
> =20
> +	mutex_lock(&isert_conn_mutex);
> +	if (device->removing) {
> +		mutex_unlock(&isert_conn_mutex);
> +		isert_info("device %p is being removed, rejecting conn %p\n",
> +			   device, isert_conn);
> +		ret =3D -ENODEV;
> +		goto out_destroy_qp;
> +	}

[Severity: Critical]
By the time isert_connect_request() acquires isert_conn_mutex and checks
device->removing, it has already called isert_login_post_recv() and
isert_rdma_accept():

drivers/infiniband/ulp/isert/ib_isert.c:isert_connect_request() {
	...
	ret =3D isert_login_post_recv(isert_conn);
	if (ret)
		goto out_destroy_qp;

	ret =3D isert_rdma_accept(isert_conn);
	if (ret)
		goto out_destroy_qp;

	mutex_lock(&isert_conn_mutex);
	if (device->removing) {
		...
		ret =3D -ENODEV;
		goto out_destroy_qp;
	}
	...
out_destroy_qp:
	isert_destroy_qp(isert_conn);
out_rsp_dma_map:
	isert_free_login_buf(isert_conn);
out_conn_dev:
	isert_device_put(device);
out:
	kfree(isert_conn);
	rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
	return ret;
}

Because rdma_accept() has already transitioned isert_conn->qp to RTR/RTS,
jumping to out_destroy_qp destroys the QP and returns the shared
IB_POLL_WORKQUEUE CQ to the CQ pool via ib_cq_pool_put() without calling
ib_drain_qp(), then immediately frees login_desc, device, and isert_conn. I=
f a
receive or flush CQE for the posted login_desc->rx_cqe was already queued on
the shared CQ, won't ib_cq_poll_work() invoke isert_login_recv_done() on the
freed login_desc, isert_conn, and device?

In addition, jumping to out after rdma_accept() succeeded calls rdma_reject=
()
and returns -ENODEV to the CMA REQ handler on an already-accepted cm_id. On
iWARP, iw_cm_accept() has already set IWCM_F_CONNECT_WAIT and taken a
reference on isert_conn->qp, which causes iw_destroy_cm_id() to hang waiting
for IWCM_F_CONNECT_WAIT to clear. Should the device->removing check happen
before isert_login_post_recv() and isert_rdma_accept() while holding a lock
that serializes against isert_remove_one()?

[ ... ]
> @@ -521,13 +537,25 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
>  	isert_info("conn %p\n", isert_conn);
> =20
>  	mutex_lock(&isert_conn->mutex);
> +	if (isert_conn->state >=3D ISER_CONN_TERMINATING) {
> +		/* The login receive is still posted, drain before releasing. */
> +		isert_info("conn %p is terminating, state %d\n",
> +			   isert_conn, isert_conn->state);
> +		if (rdma_disconnect(isert_conn->cm_id))
> +			isert_warn("Failed rdma_disconnect isert_conn %p\n",
> +				   isert_conn);
> +		ib_drain_qp(isert_conn->qp);
> +		isert_handle_unbound_conn(isert_conn, false);
> +		mutex_unlock(&isert_conn->mutex);
> +		return;
> +	}

[Severity: High]
Can calling ib_drain_qp(isert_conn->qp) while holding isert_conn->mutex here
(and in isert_teardown_conn() under the ISER_CONN_UP case) cause an ABBA
deadlock with the CQ completion workqueue?

In isert_create_qp(), isert_conn->cq is allocated from the shared pool with
IB_POLL_WORKQUEUE. If the initiator's login request PDU arrives before
rdma_disconnect() moves the QP to error, login_desc->rx_cqe completes with
IB_WC_SUCCESS ahead of the drain CQE on isert_conn->cq, and ib_cq_poll_work=
()
runs isert_login_recv_done():

drivers/infiniband/ulp/isert/ib_isert.c:isert_login_recv_done() {
	...
	mutex_lock(&isert_conn->mutex);
	complete(&isert_conn->login_req_comp);
	mutex_unlock(&isert_conn->mutex);
	...
}

Because isert_login_recv_done() blocks on isert_conn->mutex, ib_cq_poll_wor=
k()
cannot advance to the drain CQE that ib_drain_qp() is waiting on while hold=
ing
isert_conn->mutex (and isert_conn_mutex when called from isert_remove_one()=
).

[ ... ]
> @@ -625,20 +654,23 @@ isert_np_cma_handler(struct isert_np *isert_np,
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
> +	lockdep_assert_held(&isert_conn->mutex);
> =20
> -	mutex_lock(&isert_conn->mutex);
>  	switch (isert_conn->state) {
>  	case ISER_CONN_TERMINATING:
> +	case ISER_CONN_DOWN:
> +		break;
> +	case ISER_CONN_INIT:
> +		/* Mark only; isert_connected_handler() releases it. */
> +		isert_conn->state =3D ISER_CONN_TERMINATING;
>  		break;

[Severity: High]
As reported by Sashiko on v2 [1], when a connection in ISER_CONN_INIT is to=
rn
down in isert_teardown_conn(), it is only marked ISER_CONN_TERMINATING and
relies on isert_connected_handler() (RDMA_CM_EVENT_ESTABLISHED) to disconne=
ct,
drain the QP, and schedule release_work. What happens if
RDMA_CM_EVENT_ESTABLISHED never arrives?

For example, if the peer disconnects after CM REQ/REP without sending RTU (=
or
closes the connection before establishment on iWARP), cma_ib_handler() /
cma_iw_handler() delivers RDMA_CM_EVENT_DISCONNECTED, which calls
isert_disconnected_handler() -> isert_teardown_conn(). That transitions
isert_conn->state to ISER_CONN_TERMINATING without scheduling cleanup, and
since the CM state is now disconnecting, neither RDMA_CM_EVENT_ESTABLISHED =
nor
RDMA_CM_EVENT_UNREACHABLE will ever fire. Similarly, if isert_remove_one()
runs while a connection is in ISER_CONN_INIT and the peer never sends RTU,
isert_remove_one() runs before cma_remove_one() and cm_remove_one() in the
ib_client removal order. Won't that leak isert_conn and its isert_device
reference and cause isert_remove_one() to hang indefinitely in
wait_for_completion(&removal_comp)?

[ ... ]
> @@ -2697,8 +2727,54 @@ static struct iscsit_transport iser_target_transpo=
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
> +	found->removing =3D true;
> +	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
> +		if (isert_conn->device !=3D found)
> +			continue;
> +
> +		isert_info("removing conn %p state %d\n",
> +			   isert_conn, isert_conn->state);
> +		mutex_lock(&isert_conn->mutex);
> +		isert_teardown_conn(isert_conn);
> +		mutex_unlock(&isert_conn->mutex);
> +	}
> +	mutex_unlock(&isert_conn_mutex);
> +
> +	isert_device_put(found);
> +	wait_for_completion(&removal_comp);
> +}

[Severity: High]
As reported by Sashiko on v2 [2], during IB device unregistration,
disable_device() invokes ib_client remove callbacks in reverse registration
order, so isert_remove_one() runs and returns before cma_remove_one() destr=
oys
listening rdma_cm_ids.

Because struct isert_device entries only exist on device_list while
device->refcount > 0, if no connections exist when isert_remove_one() runs
(found =3D=3D NULL), or after wait_for_completion(&removal_comp) returns an=
d found
has been removed from device_list and freed by isert_device_put(), there is=
 no
record that ib_device is being removed.

If an RDMA_CM_EVENT_CONNECT_REQUEST arrives on a still-active listener befo=
re
cma_remove_one() runs, isert_connect_request() -> isert_device_get() will
allocate a fresh struct isert_device with removing =3D=3D false and accept =
the new
connection in ISER_CONN_INIT after isert_remove_one() has already finished.
When cma_remove_one() -> cma_process_remove() subsequently delivers
RDMA_CM_EVENT_DEVICE_REMOVAL to that connection, isert_cma_handler() return=
s 0
and isert_teardown_conn() only sets state =3D ISER_CONN_TERMINATING while
id_priv->state is set to RDMA_CM_DEVICE_REMOVAL (suppressing any further CM
events). Won't cma_process_remove() then block forever waiting for that cm_=
id
to be destroyed?

[1] https://lore.kernel.org/r/20261026060505.409476-1-yhlee@isslab.korea.ac=
.kr
[2] https://lore.kernel.org/r/20261026060505.409476-1-yhlee@isslab.korea.ac=
.kr

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102061608.6171=
86-1-yhlee@isslab.korea.ac.kr?part=3D2
