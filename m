Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759784;
	b=eOirksrcu/leUPJJjuXx6vkylbUJAcgaHzCPnNWMEIg6AnUt5uilBxmJh+3APsKTWfFQ
	 ApVM0uxo/OcTZfLQV6FN2mrzjiVxI0bpHkQubA5V/k35FUr4r9JeHNx0kx6HaiWEk9nfZ
	 dblubqG1tPUsremshG++MsCocotnc39RNhv83+Srwc5mG7dlM4TF57aXnbfr8GpaBvqiA
	 rIvx20Eawg5GayAoFY5/+2G0LKOoU3Gto2OK6ET4trefqd5I4Bz1/dfy+IrlItKLHg2vR
	 sj80NBlOgarSyivUglge7v8ffKdKaY7zDe4G0vddpj/ed9sL1srddnS2rq4StBeKptg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759784;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5V3W832Qmx7cBwQoM6fHGJyvI4fkaKqdTNe+U/16MZo=;
	b=AJpbipJCEVr9QpgM4ZO/+N08KhhfL7+Kk3ApE+ekgl3QYzC14hG2z2nutraEzUnT8oOz
	 ticOXywirRF5QnM5lunq4yVbURg82bFyWSwVROz9yFDp7ngfJorhmlUf3KgQRYotEI/NE
	 R+csAIBkLZIqjZQOW0LdnZ4iyfRDInjcEf/nOy6y4rVCHlbIxID7OZHa0S47uLkbNme3z
	 LofXaJgTWGMkPp4agdTLADS+rEIHVFEbJ3QA/Ag0IWZeu0vqMz1rGGGNAotYXAuOFJLbZ
	 SC1ZnCSkDOaXg+EIfE+EWWnPu4eXB+tj5zSIg7c/BYawTIoeOhwiQwCEOWxdMFsDeyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fEeGP2Yc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0D9606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fEeGP2Yc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C9F1F01825;
	Fri, 23 Oct 2026 12:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759783;
	bh=5V3W832Qmx7cBwQoM6fHGJyvI4fkaKqdTNe+U/16MZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fEeGP2YcT+M74gpHg7/Fp9uHVJaf6oqRP7obvyRetTL4IsyL4sXM16SOVEq9ZhRwy
	 nmFLSn5ylG7PDUgigw+xCQ6OJQ2o2YFJHXr8J3n/0TSVbUjFZTpHte3rrbkgnUMhS7
	 xnYatlNXnfmC4V0/v4cmNg143/lHThlYMzAvkXyg6vpmNtuiCKTdo76LXUJ/PLhsPO
	 O7Yjg/nh1hwOrNglBJq2EeBJmY8V1GQPcyXBE+kvZHTefIK5O7mFvOpyaOZOQlwY1/
	 5vpWlsuAVpsG6qEcgwx8GciobbLTkaMiGupc3HnHAQe3evlAQepCBtVaJlWO2wY/pg
	 LuVZ2UWD20XJQ==
Message-ID: <sashiko-outbox-182795@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] xprtrdma: Wake connect worker on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261023125033.528835-4-lixiasong1@huawei.com>
References: <20261023125033.528835-1-lixiasong1@huawei.com>
 <20261023125033.528835-4-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 12:49:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] xprtrdma: use-after-free of ep in rpcrdma_cm_event_handler() o=
n teardown
- [High] xprtrdma: ep kref leak and removal hang on UNREACHABLE or REJECTED=
 event
- [High] xprtrdma: use-after-free or spurious disconnect of re_xprt on ESTA=
BLISHED
--

commit ab99aeccfc2a88d68d44010bf5a53935dda9cc76
Author: Li Xiasong <lixiasong1@huawei.com>

xprtrdma: Wake connect worker on device removal

This commit updates rpcrdma_cm_event_handler() and rpcrdma_ep_removal_done()
to use atomic state transitions on ep->re_connect_status so that device
removal wakes the connect worker when not yet established and the endpoint
reference taken on RDMA_CM_EVENT_ESTABLISHED is released once on state
change.

> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 9b00e71c80a7a..ff65bb9e28ff6 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -229,6 +229,7 @@ static int
>  rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *ev=
ent)
>  {
>  	struct rpcrdma_ep *ep =3D id->context;
> +	int status;
> =20
>  	might_sleep();
> =20
> @@ -251,16 +252,21 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, str=
uct rdma_cm_event *event)
>  		case 0:
>  			goto wake_connect_worker;
>  		case 1:
> -			/* The later DISCONNECTED event balances the
> -			 * ESTABLISHED get; do not put here.
> -			 */
>  			rpcrdma_force_disconnect(ep);
> -			return 0;
> +			return rpcrdma_ep_put(ep);
>  		}
>  		return 0;
>  	case RDMA_CM_EVENT_ESTABLISHED:
>  		rpcrdma_ep_get(ep);
> -		ep->re_connect_status =3D 1;
> +		switch (cmpxchg(&ep->re_connect_status, 0, 1)) {
> +		case 0:
> +			break;
> +		case -ENODEV:
> +			rpcrdma_force_disconnect(ep);
> +			return rpcrdma_ep_put(ep);

[Severity: High]
Can calling rpcrdma_force_disconnect(ep) here cause a use-after-free on
ep->re_xprt or a spurious disconnect on a subsequent connection attempt?

When ep->re_connect_status transitions from 0 to -ENODEV in
RDMA_CM_EVENT_ADDR_CHANGE or rpcrdma_ep_removal_done(), the endpoint was
not yet established and ep->re_connect_wait is woken so that
rpcrdma_xprt_connect() returns -ENODEV to xprt_rdma_connect_worker():

net/sunrpc/xprtrdma/transport.c:xprt_rdma_connect_worker() {
	...
	rc =3D rpcrdma_xprt_connect(r_xprt);
	xprt_clear_connecting(xprt);
	if (!rc) {
		...
	} else
		rpcrdma_xprt_disconnect(r_xprt);
	xprt_unlock_connect(xprt, r_xprt);
}

If RDMA_CM_EVENT_ESTABLISHED races with that teardown and takes a temporary
reference via rpcrdma_ep_get(ep) before rpcrdma_xprt_disconnect() calls
rpcrdma_ep_put(ep), rpcrdma_xprt_disconnect() sees a non-zero kref, clears
r_xprt->rx_ep =3D NULL, and returns:

net/sunrpc/xprtrdma/verbs.c:rpcrdma_xprt_disconnect() {
	...
	if (rpcrdma_ep_put(ep))
		rdma_destroy_id(id);

	r_xprt->rx_ep =3D NULL;
}

Once xprt_rdma_connect_worker() finishes, a concurrent xprt_rdma_destroy()
can complete cancel_delayed_work_sync(&r_xprt->rx_connect_worker), observe
r_xprt->rx_ep =3D=3D NULL, and free xprt via xprt_free(xprt) (or if not
destroyed, a new connection attempt can start on xprt) before
RDMA_CM_EVENT_ESTABLISHED executes rpcrdma_force_disconnect(ep) ->
xprt_force_disconnect(ep->re_xprt).

> +		default:
> +			return rpcrdma_ep_put(ep);
> +		}
>  		rpcrdma_update_cm_private(ep, &event->param.conn);
>  		trace_xprtrdma_inline_thresh(ep);
>  		wake_up_all(&ep->re_connect_wait);
> @@ -279,9 +285,11 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, stru=
ct rdma_cm_event *event)
>  		wake_up_all(&ep->re_connect_wait);
>  		return 0;
>  	case RDMA_CM_EVENT_DISCONNECTED:
> -		ep->re_connect_status =3D -ECONNABORTED;
> +		status =3D xchg(&ep->re_connect_status, -ECONNABORTED);
>  		rpcrdma_force_disconnect(ep);
> -		return rpcrdma_ep_put(ep);
> +		if (status =3D=3D 1)
> +			return rpcrdma_ep_put(ep);
> +		return 0;

[Severity: High]
What happens if RDMA_CM_EVENT_UNREACHABLE or RDMA_CM_EVENT_REJECTED arrives
after RDMA_CM_EVENT_ESTABLISHED has already set ep->re_connect_status to 1?

In rpcrdma_cm_event_handler(), RDMA_CM_EVENT_CONNECT_ERROR,
RDMA_CM_EVENT_UNREACHABLE, and RDMA_CM_EVENT_REJECTED still overwrite
ep->re_connect_status unconditionally without checking whether the previous
value was 1:

net/sunrpc/xprtrdma/verbs.c:rpcrdma_cm_event_handler() {
	...
	case RDMA_CM_EVENT_CONNECT_ERROR:
		ep->re_connect_status =3D -ENOTCONN;
		goto wake_connect_worker;
	case RDMA_CM_EVENT_UNREACHABLE:
		ep->re_connect_status =3D -ENETUNREACH;
		goto wake_connect_worker;
	case RDMA_CM_EVENT_REJECTED:
		ep->re_connect_status =3D -ECONNREFUSED;
		if (event->status =3D=3D IB_CM_REJ_STALE_CONN)
			ep->re_connect_status =3D -ENOTCONN;
wake_connect_worker:
		wake_up_all(&ep->re_connect_wait);
		return 0;
}

In RDMA CMA, both events can be delivered on a client CM ID after
RDMA_CM_EVENT_ESTABLISHED:

1. On RoCE, rdma_resolve_route() inserts id_priv into id_table via
   cma_add_id_to_tree(), where it remains in state RDMA_CM_CONNECT until
   _destroy_id(). On a NETEVENT_NEIGH_UPDATE event,
   cma_netevent_callback() queues id_priv->id.net_work and
   cma_netevent_work_handler() delivers RDMA_CM_EVENT_UNREACHABLE unless
   the state is RDMA_CM_DESTROYING or RDMA_CM_DEVICE_REMOVAL.

2. On IB/RoCE, after cma_ib_handler() processes IB_CM_REP_RECEIVED via
   cma_rep_recv() -> ib_send_cm_rtu() and delivers
   RDMA_CM_EVENT_ESTABLISHED, cm_rej_handler() still accepts a peer REJ MAD
   while in IB_CM_ESTABLISHED (with lap_state =3D=3D IB_CM_LAP_UNINIT) or
   IB_CM_DREQ_SENT, and cma_ib_handler() delivers RDMA_CM_EVENT_REJECTED.

If either event overwrites ep->re_connect_status from 1 to a negative
errno, neither that event nor a subsequent RDMA_CM_EVENT_DISCONNECTED,
RDMA_CM_EVENT_ADDR_CHANGE, or rpcrdma_ep_removal_done() will observe
status =3D=3D 1.

Wouldn't that skip rpcrdma_ep_put(ep) (and skip rpcrdma_force_disconnect(ep)
in RDMA_CM_EVENT_ADDR_CHANGE and rpcrdma_ep_removal_done()), leaking
ep->re_kref and causing rpcrdma_remove_one() to hang indefinitely at
wait_for_completion(&rd->rd_done)?

>  	default:
>  		break;
>  	}
> @@ -294,7 +302,18 @@ static void rpcrdma_ep_removal_done(struct rpcrdma_n=
otification *rn)
>  	struct rpcrdma_ep *ep =3D container_of(rn, struct rpcrdma_ep, re_rn);
> =20
>  	trace_xprtrdma_device_removal(ep->re_id);
> -	xprt_force_disconnect(ep->re_xprt);
> +	switch (xchg(&ep->re_connect_status, -ENODEV)) {
> +	case 0:
> +		wake_up_all(&ep->re_connect_wait);
> +		break;
> +	case 1:
> +		rpcrdma_force_disconnect(ep);
> +		/* DEVICE_REMOVAL prevents a later DISCONNECTED event. */
> +		rpcrdma_ep_put(ep);
> +		break;
> +	default:
> +		break;
> +	}
>  }

[Severity: Critical]
Does dropping the ESTABLISHED reference in RDMA_CM_EVENT_ADDR_CHANGE and
rpcrdma_ep_removal_done() (or waking the connect worker on case 0 while CM
events can still fire) allow ep to be freed while rpcrdma_cm_event_handler()
is still using id->context?

In rpcrdma_xprt_disconnect(), rpcrdma_ep_put(ep) is called before
rdma_destroy_id(id):

net/sunrpc/xprtrdma/verbs.c:rpcrdma_xprt_disconnect() {
	...
	id =3D ep->re_id;
	rc =3D rdma_disconnect(id);
	trace_xprtrdma_disconnect(r_xprt, rc);

	rpcrdma_xprt_drain(r_xprt);
	rpcrdma_reps_unmap(r_xprt);
	rpcrdma_sendctxs_destroy(r_xprt);
	rpcrdma_reqs_reset(r_xprt);
	rpcrdma_mrs_destroy(r_xprt);

	if (rpcrdma_ep_put(ep))
		rdma_destroy_id(id);
}

When rpcrdma_ep_put(ep) drops the last reference on ep->re_kref,
rpcrdma_ep_destroy() runs immediately and calls kfree(ep) before
rdma_destroy_id(id) acquires id_priv->handler_mutex to synchronize with
rpcrdma_cm_event_handler().

Prior to this change, commit af9b65b29af3 ("xprtrdma: Fix ep kref imbalance
on ADDR_CHANGE") kept the ESTABLISHED reference on RDMA_CM_EVENT_ADDR_CHANGE
until RDMA_CM_EVENT_DISCONNECTED arrived. Neither RDMA_CM_EVENT_ADDR_CHANGE
nor rpcrdma_ep_removal_done() stops further CM events from firing on id:

1. RDMA_CM_EVENT_ADDR_CHANGE leaves id_priv->state as RDMA_CM_CONNECT.

2. During device removal, disable_device() invokes ib_client->remove
   callbacks in reverse registration order. Because rpcrdma_ib_client is
   registered after cma_client, rpcrdma_remove_one() runs and waits in
   wait_for_completion(&rd->rd_done) before cma_remove_one() ->
   cma_process_remove() transitions id_priv->state to
   RDMA_CM_DEVICE_REMOVAL.

Once RDMA_CM_EVENT_ADDR_CHANGE or rpcrdma_ep_removal_done() drops the
ESTABLISHED reference (or wakes the connect worker from case 0 while a
connection attempt is still in flight), rpcrdma_xprt_disconnect() calls
rdma_disconnect(id) (which triggers RDMA_CM_EVENT_DISCONNECTED), drains the
QP, and drops the final ep->re_kref reference in rpcrdma_ep_put(ep),
freeing ep before rdma_destroy_id(id) is reached.

Won't a concurrent rpcrdma_cm_event_handler() invocation (such as
RDMA_CM_EVENT_DISCONNECTED triggered by rdma_disconnect(id), or a racing
RDMA_CM_EVENT_ESTABLISHED on the case 0 path) then dereference id->context
after ep has already been freed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023125033.5288=
35-1-lixiasong1@huawei.com?part=3D3
