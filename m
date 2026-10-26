Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792974044;
	b=Dauf8Q0bpyQKA5ftpYimqQKsdcFabYP0kqWAx8I3ifXMRIC94XfuHXS/gQOGcYvzrxgz
	 n/wwplYFZEZHma6EXwil/k3f16hbN5mpTUdXmSoeGAkcxuPNlQPGXeyidOvz0J1LDSnOP
	 bxJKz4oOZSXs26btHVzK6QNn6Y0VyQZS7jIJX/e8AgRvGqwo8dX0wpAojk2NR3mJEqKWb
	 i02rZNjbPrxpDR21L/30xGqDQTMyJD2QHbfpW3KAini2rrm6GsVIpnuiddzlklf51jNsn
	 wN17ATTfUqZC5Pz6+UGruYONYbZ1P6n/WRI2JYETE/mO21fQyRYQ7YVQLhRIBgtMHNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792974044;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+w8YFvPw+4yowONFz+6HziHOwnTq7DShF+lxL0lOaKE=;
	b=TTNTQqqY+Zb3rq/+zCkxGEOxzgF4PzxhKFW0yb8VnfN3xUcNIDkRKsqCJdF/1yMQ3o9Z
	 2S3x/VDZh3Ou4nWae/HbUqr1yXxXGcURmIb4QfguBJknNLhMtgeEebpJ3M/M4wgAbjElU
	 s8KpzW6RW77ZzDPSs1hBELzxLB1GtOSMLMUlCO8Nnj96D9aE/DWylJXTEK1RqetYJwRbq
	 q/kUl7qziBz2snzZLHKc0gU51saLLev2aTZtgCCwpXu097N//TaU31cYs1Cj3H5yFQuvh
	 geIF4IAE39C+GaD1WI2nYLtRIBc/mjDmQjkz+KY9a2PNPz5C+bUL7wmbCpzgvH0GflA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=elNhjeYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF33606A31A;
	Mon, 26 Oct 2026 00:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=elNhjeYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68231F01825;
	Mon, 26 Oct 2026 00:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792974044;
	bh=+w8YFvPw+4yowONFz+6HziHOwnTq7DShF+lxL0lOaKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=elNhjeYP/KFtiFr6aWNmY7kqNUMqsWz10p9CI1XkurczkYQ4ho9SkqjrV5NWz9vKj
	 DDqPNL+7Qg0TN70rQZ/YKEnj+n8rJVu7X/JgKrRg9i6XXgxKJ9l0iqIijkvRJdOJiQ
	 z1Lh+SFz8XOdkuoNipzaOqGv/0COLng1AisSO+StrLOfgz0sFg3WPOxpR4GWaAvAsO
	 onlai+4MRfUVw7sN57i9CcaRZh/2tLZ0vi/e9cLIknC3ZEnHISKiOV/THdJMZfX90R
	 0VEozisHeef5PEcP5XCnY4jKlyTIsU9G0GJTr0v5yDmKZ6nbjyUH3meOKjeVej/ZgN
	 SjUWmlMUUiQLQ==
Message-ID: <sashiko-outbox-184560@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/isert: set ISER_CONN_DOWN only after the connection
 has been released
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr>
References: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 00:20:43 +0000
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
- [Critical] IB/isert: UAF on rem_wait in isert_connect_release() after ISE=
R_CONN_DOWN
- [High] IB/isert: deadlock on handler_mutex in isert_connect_release() on =
device removal
--

commit dc719d99e88528503ed27ec0d20e073beee4b8f9
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: set ISER_CONN_DOWN only after the connection has been released

This commit moves the store setting isert_conn->state to ISER_CONN_DOWN from
isert_release_work() into isert_connect_release() right before waking
isert_conn->rem_wait. This is intended to prevent the
RDMA_CM_EVENT_DEVICE_REMOVAL handler in isert_cma_handler() from freeing
isert_conn while isert_connect_release() is still tearing down connection
resources.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index efa8d7b7844c9..cd0ca3cf131cb 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -506,10 +506,18 @@ isert_connect_release(struct isert_conn *isert_conn)
> =20
>  	isert_device_put(device);
> =20
> -	if (isert_conn->dev_removed)
> +	if (isert_conn->dev_removed) {
> +		/*
> +		 * Publish ISER_CONN_DOWN only now.  The
> +		 * RDMA_CM_EVENT_DEVICE_REMOVAL handler waits for it and then
> +		 * frees isert_conn, so it must not become visible before the
> +		 * teardown above has finished using the connection.
> +		 */
> +		isert_conn->state =3D ISER_CONN_DOWN;
>  		wake_up_interruptible(&isert_conn->rem_wait);

[Severity: Critical]
Can publishing isert_conn->state =3D ISER_CONN_DOWN before calling
wake_up_interruptible(&isert_conn->rem_wait) cause a use-after-free on
isert_conn->rem_wait when racing with kfree(isert_conn) in
isert_cma_handler()?

In drivers/infiniband/ulp/isert/ib_isert.c, isert_cma_handler() handles
RDMA_CM_EVENT_DEVICE_REMOVAL with:

	case RDMA_CM_EVENT_DEVICE_REMOVAL:
		isert_conn =3D cma_id->qp->qp_context;
		isert_conn->dev_removed =3D true;
		isert_disconnected_handler(cma_id, event->event);
		wait_event_interruptible(isert_conn->rem_wait,
					 isert_conn->state =3D=3D ISER_CONN_DOWN);
		kfree(isert_conn);

Because rem_wait is embedded inside struct isert_conn and
wait_event_interruptible() checks isert_conn->state =3D=3D ISER_CONN_DOWN b=
efore
acquiring rem_wait.lock (and again after prepare_to_wait_event() before
schedule()), as soon as the store to isert_conn->state becomes visible on
another CPU, wait_event_interruptible() can return immediately and call
kfree(isert_conn) before wake_up_interruptible(&isert_conn->rem_wait) even
begins. In that fast-path case, no barrier in wake_up_interruptible() has
executed to order prior accesses in isert_connect_release() before
kfree(isert_conn), and wake_up_interruptible() -> __wake_up_common_lock() ->
spin_lock_irqsave(&wq_head->lock, flags) will then dereference and write to
the freed isert_conn->rem_wait.

Even when the waiter is asleep in schedule(), __wake_up_common_lock() invok=
es
autoremove_wake_function(), which wakes the task and removes wq_entry from
rem_wait.head via list_del_init_careful(&wq_entry->entry) before releasing
rem_wait.lock. The woken waiter can observe isert_conn->state =3D=3D
ISER_CONN_DOWN, see list_empty_careful(&wq_entry->entry) in finish_wait()
without taking rem_wait.lock, and call kfree(isert_conn) while
__wake_up_common_lock() in isert_connect_release() is still traversing
rem_wait.head and unlocking isert_conn->rem_wait.lock.

Would replacing rem_wait with a struct completion (using complete() and
wait_for_completion_interruptible(), which serialize completion state and
waiter exit under the completion's wait.lock) avoid this race?

> -	else
> +	} else {
>  		kfree(isert_conn);
> +	}
>  }
> =20
>  static void
> @@ -2537,10 +2545,6 @@ static void isert_release_work(struct work_struct =
*work)
> =20
>  	isert_info("Starting release conn %p\n", isert_conn);
> =20
> -	mutex_lock(&isert_conn->mutex);
> -	isert_conn->state =3D ISER_CONN_DOWN;
> -	mutex_unlock(&isert_conn->mutex);

[Severity: High]
Does moving the ISER_CONN_DOWN transition from isert_release_work() to the =
end
of isert_connect_release() introduce a deadlock on id_priv->handler_mutex w=
hen
a normal connection teardown races with RDMA device removal?

In drivers/infiniband/ulp/isert/ib_isert.c, isert_connect_release() runs af=
ter
isert_release_work() drops the last reference and checks dev_removed before
destroying the CM ID:

static void
isert_connect_release(struct isert_conn *isert_conn)
{
	...
	if (isert_conn->cm_id &&
	    !isert_conn->dev_removed)
		rdma_destroy_id(isert_conn->cm_id);

If a connection begins normal teardown prior to device removal (for example,
via RDMA_CM_EVENT_DISCONNECTED or iscsit_close_connection() ->
isert_wait_conn()), isert_conn->state is set to ISER_CONN_TERMINATING with
isert_conn->dev_removed =3D=3D false, and isert_release_work() invokes
isert_connect_release().

If isert_connect_release() observes !isert_conn->dev_removed and enters
rdma_destroy_id(isert_conn->cm_id) just as cma_remove_one() ->
cma_process_remove() -> cma_send_device_removal_put() acquires
id_priv->handler_mutex first:

CPU0 (isert_release_wq)                 CPU1 (device removal)
isert_release_work()
  isert_put_conn()
    isert_connect_release()
      sees !isert_conn->dev_removed
      rdma_destroy_id(cm_id)
                                        cma_send_device_removal_put()
                                          mutex_lock(&id_priv->handler_mute=
x)
                                          cma_ndev_work / cma_cm_event_hand=
ler
                                            isert_cma_handler()
                                              isert_conn->dev_removed =3D t=
rue
                                              isert_disconnected_handler()
                                                (sees ISER_CONN_TERMINATING)
                                              wait_event_interruptible(
                                                isert_conn->rem_wait,
                                                state =3D=3D ISER_CONN_DOWN)
        mutex_lock(&id_priv->handler_mutex)

Because ISER_CONN_DOWN is now set only after rdma_destroy_id() returns in
isert_connect_release(), CPU0 blocks waiting for id_priv->handler_mutex ins=
ide
rdma_destroy_id() while CPU1 holds id_priv->handler_mutex waiting for
isert_conn->state =3D=3D ISER_CONN_DOWN. Furthermore, if the interruptible =
wait on
CPU1 is interrupted by a signal, isert_cma_handler() frees isert_conn and
returns 1 to destroy cm_id while rdma_destroy_id() on CPU0 proceeds to dest=
roy
cm_id a second time and then accesses the freed isert_conn.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026000733.4178=
856-1-yhlee@isslab.korea.ac.kr?part=3D1
