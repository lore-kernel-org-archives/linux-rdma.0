Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712757;
	b=d++q4S4j/CObqWCktQ9+o9kOgzJIDSvjOAjL6ntv9IjynlEpQDBWby0x54TUa+mkyhqI
	 +9r/BkhS4ZJZbWwX1xj+FySnpFxgPiKoBmt42qD7q8wEDDWvJgaDesMWKAwe2SsWf6SjB
	 Z8TCMbxZGjGkZG8eWMYu5qGDlU0lPSN79wrpg6Csks8MRKg5+V+qlL32jcdx6sqbSToZV
	 9jOkozBsbw9SjdGlH9AAF7p2Wk3LZdffhUh9zQ7TIxThbORCzZKrDGbHZ0EGU77DogXIl
	 kryMwzZMOVJIGJuW/sgmvT8wjHb+PGaBEUWf0IMwjDHefDYIIDm41Dy9ZPYL54Xw67A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712757;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OvcOFf3MmrlGCp5T/+TtsY9dUnafa0lLhir0uL91yPg=;
	b=EArcA4ME2Ls4gjWyrb4Cb9MP6eUO8BGFZU5xdyoi4ySeUiEhEGppGWjD+NZHBx09jUxZ
	 924QGGSoX0fcTSXjP/2ftQRa8rrnSM/09a4gDq7iGj+eExEoEHZowm+8tqPFbXWdrSEd0
	 614TyOy5mBYt4vxg7pIrYJuNNVqZgoR0aRx1BHuHRlqirewi85w2icydfAMiBytJvfycw
	 6dglg1gxqXPwz/Zg6PnzWedDq2lBrLtA1jch1LWKofhkzACpE0IVHtzwytC3lqFvptNpC
	 x48i6jQXMl81pKxkR+pGbIUamO6kNEiDeAJXZAGRdeJ4LIjm2bfLRKDriwR0NURqh+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlZEHPSm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AE606D82E;
	Tue,  3 Nov 2026 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlZEHPSm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7040A1F00A21;
	Tue,  3 Nov 2026 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712756;
	bh=OvcOFf3MmrlGCp5T/+TtsY9dUnafa0lLhir0uL91yPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hlZEHPSmLrwlA8jxP14c1VQwL0UqpYwz3HeD+dyZdCFPmZn2gmFEBY3dm+d8DtPNL
	 3t4EgyUNPW4CsxTXlHQ9QsfVEuO6EiztXwNTVwu9GEt1Hq00kk2AW8u0JejATny40u
	 haZZF6PvmEd6LVSmT/ntmAT0tPryG+olZb0D9ul8VaciUOsYCGloxnd2djJs3Ukcja
	 GKfOIMXEslNwpyXsas2BwauC2xK3SFJDutJM5MSdLkc5GcE03ZfBBfQa0kbi+xED/W
	 Ub2iefB8JgDYAAwt2N5fYtt3+w9e5pZrSj/agJuaJsC6x81t6EJ1YJ1HLEk3lCtLR4
	 ZSp7VnPJFYfBw==
Message-ID: <sashiko-outbox-195360@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/5] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261103125955.1530355-4-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
 <20261103125955.1530355-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:32:36 +0000
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
- [High] IB/isert: premature reinstatement in isert_teardown_conn() hangs l=
ogin
--

commit fa784d352b38db9ec9f326e2a339d1ae4eb8f372
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: tear connections down from an ib_client on device removal

This commit registers an ib_client to tear down iSER target connections
during RDMA device removal instead of waiting for connection release inside
the RDMA_CM_EVENT_DEVICE_REMOVAL callback. It also adds reference counting
for isert_np and tracks active connections on isert_conn_list.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 61b214012a70b..4812dabd93945 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
[ ... ]
> @@ -610,48 +668,50 @@ isert_np_cma_handler(struct isert_np *isert_np,
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
> -	struct isert_np *isert_np =3D cma_id->context;
> -	bool owned =3D false, bound =3D false, terminated =3D false;
> +	struct isert_np *isert_np =3D isert_conn->np;
> +	bool owned =3D false, bound =3D false;
> +	bool promoted =3D false, terminated =3D false;
> =20
>  	mutex_lock(&isert_conn->mutex);
> -	switch (isert_conn->state) {
> -	case ISER_CONN_UP:
> -		mutex_lock(&isert_np->mutex);
> -		if (list_empty(&isert_conn->node)) {
> -			bound =3D isert_conn->state =3D=3D ISER_CONN_BOUND ||
> -				isert_conn->state =3D=3D ISER_CONN_FULL_FEATURE;
> -		} else {
> -			owned =3D true;
> -			list_del_init(&isert_conn->node);
> -		}
> -		mutex_unlock(&isert_np->mutex);
> -		break;
> -	case ISER_CONN_BOUND:
> -	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
> -		bound =3D true;
> -		break;
> -	default:
> -		break;
> +	mutex_lock(&isert_np->mutex);
> +	if (list_empty(&isert_conn->node)) {
> +		bound =3D isert_conn->state =3D=3D ISER_CONN_BOUND ||
> +			isert_conn->state =3D=3D ISER_CONN_FULL_FEATURE;
> +	} else {
> +		owned =3D true;
> +		promoted =3D isert_conn->promoted;
> +		list_del_init(&isert_conn->node);
>  	}
> +	mutex_unlock(&isert_np->mutex);
> =20
> -	if (owned)
> +	if (owned) {
>  		terminated =3D isert_conn_terminate(isert_conn);
> -	else if (bound)
> +	} else if (bound) {
> +		isert_conn_terminate(isert_conn);
>  		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
> +	}
>  	mutex_unlock(&isert_conn->mutex);

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

[ ... ]

> @@ -2679,6 +2741,10 @@ static void isert_get_rx_pdu(struct iscsit_conn *c=
onn)
> =20
>  	/* Now we are in FULL_FEATURE phase */
>  	mutex_lock(&isert_conn->mutex);
> +	if (isert_conn->state >=3D ISER_CONN_TERMINATING) {
> +		mutex_unlock(&isert_conn->mutex);
> +		return;
> +	}
>  	isert_conn->state =3D ISER_CONN_FULL_FEATURE;
>  	mutex_unlock(&isert_conn->mutex);

[Severity: High]
Can calling iscsit_cause_connection_reinstatement() in isert_teardown_conn()
and isert_connect_error() while isert_conn->state is ISER_CONN_BOUND leak
isert_conn and hang device removal in isert_remove_one()?

In isert_accept_np(), isert_conn->state is set to ISER_CONN_BOUND and stays
there throughout login negotiation until isert_get_rx_pdu() sets
ISER_CONN_FULL_FEATURE. At the end of login negotiation,
iscsi_target_do_tx_login_io() starts the RX and TX kthreads while
conn->conn_state is still TARG_CONN_STATE_IN_LOGIN and before
iscsi_post_login_handler() completes conn->rx_login_comp:

  iscsi_target_do_login_io()
    iscsi_target_do_tx_login_io()
      iscsit_start_kthreads(conn)
        conn->tx_thread_active =3D true;
        conn->rx_thread_active =3D true;
      iscsit_put_login_tx() -> isert_put_login_tx()
        isert_conn->login_rsp_pending =3D true;

If isert_teardown_conn() or isert_connect_error() runs in this window,
bound is true because isert_conn->state =3D=3D ISER_CONN_BOUND, so it calls
iscsit_cause_connection_reinstatement(isert_conn->conn, 0), sending SIGINT
to both conn->rx_thread and conn->tx_thread.

In drivers/target/iscsi/iscsi_target.c:iscsi_target_rx_thread(), SIGINT
interrupts wait_for_completion_interruptible(&conn->rx_login_comp) before
iscsit_get_rx_pdu() -> isert_get_rx_pdu() is reached:

	rc =3D wait_for_completion_interruptible(&conn->rx_login_comp);
	if (rc < 0 || iscsi_target_check_conn_state(conn))
		goto out;

And in drivers/target/iscsi/iscsi_target.c:iscsi_target_tx_thread(), waking
on SIGINT jumps to transport_err, where conn->conn_state is still
TARG_CONN_STATE_IN_LOGIN:

transport_err:
	if (conn->conn_state !=3D TARG_CONN_STATE_IN_LOGIN)
		iscsit_take_action_for_connection_exit(conn, &conn_freed);

Neither thread calls iscsit_take_action_for_connection_exit() to close the
connection and invoke isert_free_conn(), leaving both threads sleeping in
while (!kthread_should_stop()) and causing isert_remove_one() to wait
indefinitely on removal_comp.

Furthermore, if iscsi_target_tx_thread() reaches transport_err just after
iscsi_post_login_handler() sets conn->conn_state =3D TARG_CONN_STATE_LOGGED=
_IN
but before it adds conn->conn_list to sess->sess_conn_list,
iscsit_close_connection() will run list_del(&conn->conn_list) on an
uninitialized list head while iscsi_post_login_handler() is still running.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125955.1530=
355-1-yhlee@isslab.korea.ac.kr?part=3D3
