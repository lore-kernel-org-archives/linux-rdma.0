Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793677977;
	b=2LVBOQs5h+oUFngL+Eq8GDM8225kTYllEpzShUWUdbPmpw+KIfAcfXdS+AI2rMyE2i74
	 ZYk+g/kt5ywHtW5v6phjcqifKaPUzVPF2s/LLjeZDhtCurwEJlZGJ51lxuXih6AWLVF4F
	 smzDz6/iTZcNGknnHWabuDwnpvTyJ36NLBrogr1AJ8zpLBoZg4MP6aSxQnligZe5pSHq8
	 McfvtBJNon3bp867xuqhu097Hiv009hIuSEHVoofB7khHIxUEoVxNpVsM8CUlh1IoXfXV
	 XwNpODXvYI9HBfnRSWjeHu6t5APZmXNRx5ECa+CQcy+OeFREb+SZUx4INl/kWr5rXEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793677977;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Doe1ae61OFADcw0NRqIPyGhlZAVYN9HY06kBHQHHK8Y=;
	b=ZMpA7O2TgvYfMGfgPHOKz9CQh1pZvV/OOXUreM1+/e3RBTBcjnoPcaCThYbRAEKv6og9
	 PA4JrgMHz6dpmBgTRBLsL07ZqcM2JZZCA18pecMRh6IzWmJEJYY01lttgeHI74zKy5ZWP
	 S57ZA8/NwtKqpyGqtLnHiu22cwXcspL50YvrPn1AqEGw3GmoXt9ARPQNUauU8OR0FOFZd
	 LKJGwxRYZK7cOdlnfS7shs1HA/qmv13D6GG5HN0f0vpYL2nFnf6wAQsX+w0ia4Izccvd6
	 buSkbfurOqZC9kc3v5fi9UE7yPkHC2nOlJ7ED/WKpXCMkdkIphUG/RYkcXGNLlRacXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dNOwVn1h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F21A606A324;
	Tue,  3 Nov 2026 03:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dNOwVn1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB841F000C1;
	Tue,  3 Nov 2026 03:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793677977;
	bh=Doe1ae61OFADcw0NRqIPyGhlZAVYN9HY06kBHQHHK8Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dNOwVn1hxeyX7HRAF8Em75f1C+9vn5FSeLm/7T/wG5jgCGcuRJyoO7g5IFvBMGKir
	 j92CKWw0xFi988mwTPDV8eK7PWARyEKrxNhxtYUYJibGpCCHX8tHhIV5S6bVoe/sOQ
	 JSOUK9lBGGaOyN00+swuFJfmRq6gTCQ6sIThvPgNl8ySeElGoHXcYcG/WLCJ6P6nnS
	 CPcKP1wqqbCcTmO72kgXwoljyGeSdpMqAENAdJqbCS6Gv9LFxN29t0MqW5/VO/p/KE
	 ANf2HzGujtvLw2QmmWJpUELykE1KsNfZPxnYY5cVuiRxC5FDl2f6tSHuFcC1wG87tq
	 WYDtSEV305BOw==
Message-ID: <sashiko-outbox-194544@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/3] IB/isert: drain the QP without holding
 isert_conn->mutex
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261103032924.1073138-3-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
 <20261103032924.1073138-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:52:56 +0000
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
- [High] IB/isert: race with isert_accept_np() when draining QP unlocked
- [Low] IB/isert: missing colon in Return section of isert_conn_terminate()=
 kernel-doc
--

commit 563514f12bfc26c4edaed45f85db0c8c5f4ade31
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: drain the QP without holding isert_conn->mutex

This commit changes isert_conn_terminate() to return whether it moved the
connection to ISER_CONN_TERMINATING, and moves ib_drain_qp() and
isert_handle_unbound_conn() outside isert_conn->mutex in
isert_disconnected_handler() to avoid deadlocking with
isert_login_recv_done().

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 8255208e30c7d..c6f417bb20690 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -578,21 +578,17 @@ isert_handle_unbound_conn(struct isert_conn *isert_=
conn)
>   * isert_conn_terminate() - Initiate connection termination
>   * @isert_conn: isert connection struct
>   *
> - * Notes:
> - * In case the connection state is BOUND, move state
> - * to TEMINATING and start teardown sequence (rdma_disconnect).
> - * In case the connection state is UP, complete flush as well.
> - *
> - * This routine must be called with mutex held. Thus it is
> - * safe to call multiple times.
> + * Returns true if this caller moved the connection to ISER_CONN_TERMINA=
TING.
>   */

[Severity: Low]
This isn't a bug, but kernel-doc requires a colon after Returns (Returns:)
to recognize the return value section when building with W=3D2.

> -static void
> +static bool
>  isert_conn_terminate(struct isert_conn *isert_conn)
>  {
>  	int err;
> =20
> +	lockdep_assert_held(&isert_conn->mutex);
> +
>  	if (isert_conn->state >=3D ISER_CONN_TERMINATING)
> -		return;
> +		return false;
> =20
>  	isert_info("Terminating conn %p state %d\n",
>  		   isert_conn, isert_conn->state);
> @@ -601,6 +597,8 @@ isert_conn_terminate(struct isert_conn *isert_conn)
>  	if (err)
>  		isert_warn("Failed rdma_disconnect isert_conn %p\n",
>  			   isert_conn);
> +
> +	return true;
>  }
> =20
>  static int
> @@ -635,15 +633,14 @@ isert_disconnected_handler(struct rdma_cm_id *cma_i=
d,
>  			   enum rdma_cm_event_type event)
>  {
>  	struct isert_conn *isert_conn =3D cma_id->qp->qp_context;
> +	bool terminated =3D false;
> =20
>  	mutex_lock(&isert_conn->mutex);
>  	switch (isert_conn->state) {
>  	case ISER_CONN_TERMINATING:
>  		break;
>  	case ISER_CONN_UP:
> -		isert_conn_terminate(isert_conn);
> -		ib_drain_qp(isert_conn->qp);
> -		isert_handle_unbound_conn(isert_conn);
> +		terminated =3D isert_conn_terminate(isert_conn);
>  		break;
>  	case ISER_CONN_BOUND:
>  	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
> @@ -655,6 +652,11 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
>  	}
>  	mutex_unlock(&isert_conn->mutex);
> =20
> +	if (terminated) {
> +		ib_drain_qp(isert_conn->qp);
> +		isert_handle_unbound_conn(isert_conn);
> +	}

[Severity: High]
Can dropping isert_conn->mutex before ib_drain_qp() and
isert_handle_unbound_conn() race with isert_accept_np()?

When a connection reaches isert_connected_handler(), its state is set to
ISER_CONN_UP, isert_conn->node is placed on isert_np->pending, and
up(&isert_np->sem) wakes the login thread in isert_accept_np().

If a disconnect arrives while the connection is still in ISER_CONN_UP,
isert_disconnected_handler() sets isert_conn->state to
ISER_CONN_TERMINATING and now unlocks isert_conn->mutex before removing
isert_conn->node from isert_np->pending in isert_handle_unbound_conn().

While ib_drain_qp() is waiting in isert_disconnected_handler(),
isert_login_recv_done() can complete isert_conn->login_req_comp for a login
PDU received just before the disconnect, and isert_accept_np() can dequeue
isert_conn from isert_np->pending and overwrite isert_conn->state without
holding isert_conn->mutex:

drivers/infiniband/ulp/isert/ib_isert.c:isert_accept_np() {
	...
	isert_conn =3D list_first_entry(&isert_np->pending,
			struct isert_conn, node);
	list_del_init(&isert_conn->node);
	mutex_unlock(&isert_np->mutex);

	conn->context =3D isert_conn;
	isert_conn->conn =3D conn;
	isert_conn->state =3D ISER_CONN_BOUND;
	...
}

Once list_del_init(&isert_conn->node) has run in isert_accept_np(),
isert_handle_unbound_conn() sees list_empty(&isert_conn->node) and becomes
a no-op.

If login then fails or times out, iscsi_target_login_sess_out() calls
isert_wait_conn() and isert_free_conn():

drivers/infiniband/ulp/isert/ib_isert.c:isert_wait_conn() {
	...
	mutex_lock(&isert_conn->mutex);
	isert_conn_terminate(isert_conn);
	mutex_unlock(&isert_conn->mutex);

	ib_drain_qp(isert_conn->qp);
	isert_put_conn(isert_conn);
	queue_work(isert_release_wq, &isert_conn->release_work);
}

Because isert_conn->state was reset to ISER_CONN_BOUND and
isert_conn->mutex is no longer held across ib_drain_qp(), wouldn't
isert_wait_conn() call ib_drain_qp(isert_conn->qp) a second time
concurrently with isert_disconnected_handler(), and allow both kref
references on isert_conn to be dropped while isert_disconnected_handler()
is still running?

Alternatively, if single-stage login succeeds in memory without posting to
the QP (isert_put_login_tx() sets isert_conn->login_rsp_pending =3D true),
wouldn't isert_get_rx_pdu() set isert_conn->state to ISER_CONN_FULL_FEATURE,
post to the already-disconnected QP, and block indefinitely in
wait_for_completion_interruptible(&comp) because the disconnect event was
already handled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103032924.1073=
138-1-yhlee@isslab.korea.ac.kr?part=3D2
