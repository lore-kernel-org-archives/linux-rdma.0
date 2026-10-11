Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AC337DE85
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791742004; cv=none; b=mKDQhRTifnspzGo9MIYHoujagSBuvxIefle8Ed5qJtyLuThTtlKh2JNAxEaNJhdqe0WZ5fAvILVfIy1wSajjsLbOMcb+SvAVy6zGiXFKhg8uRUQSuowcANkj6AOf3KjkmMBoum9JQd1wEb/yT12EE8uZiVFF17HkHTyIZOA8FiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791742004; c=relaxed/simple;
	bh=Y4gI8DpG5r+QbK8s/nwqoqep41s9NTFHRLs8LOVwhJw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=uW+3XORjMmWPv81ufgHh7A5LqstVHh2Mmr3d724TUb+9rup4pWgvc6i2G2Wje0mC6brjHV1sIWySCB1yPQ40BJ9Hc6tRdR7Q1e7kWHZZ6Y5EvRzfALXkHs1CPizkjk9dXuUcvrOv8nCN13cLRkyMz6kIcjLrlUKloBfK5c9Zqt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiSl9Gyk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiSl9Gyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BBC1F0089C;
	Sun, 11 Oct 2026 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791742002;
	bh=9JWln6zrdrX/a943ZZsViMoRe7hkRWr8eSLvVus5OeI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LiSl9Gyk2bKONVBCF/6OFyvMu2npPPJA+uLcxRZ9tghDS75n8o7DnVGQjGmFTnK0t
	 kT0hsrwhnFEUN/sp6yRu0ksyscnuK3OUqv0PFh9vq/fYkJQz6xBTXku7Y8qXPlP+Nc
	 VhKFr4HjC6FrELgvImwTnUZbESq4CN3SgOtw3lRv1mPi3w/6YCNg8UFB/6Vsk81XS+
	 JwewolGsfVWsTbXJlolhhfLrpCrm057lH2tB6vtdfVbtLJ87R/AmUmld0W6jNJj3qc
	 5nggyQ86zg/k+5cGCawFiDxD9HVQOURqOiBfXiPr/DZRhrUzfVd/9HFP5pVTBNpEKP
	 jhRUqYlI8QVBg==
Message-ID: <sashiko-outbox-167370@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/cma: wait for addr_handler() to finish in
 rdma_destroy_id()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Palla Raghunath" <raghunathpalla.0209@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011174846.59186-1-raghunathpalla.0209@gmail.com>
References: <20261011174846.59186-1-raghunathpalla.0209@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 18:06:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] cma: UAF in addr_handler via device removal path
- [High] rdma: ABA UAF in rdma_addr_cancel due to matching req->addr pointer
- [Low] rdma: data race on id_priv->used_resolve_ip during concurrent teard=
own
--

commit 90d3632ce0f65b9c550b8fd703273d10f1bd0efb
Author: Palla Raghunath <raghunathpalla.0209@gmail.com>

RDMA/cma: wait for addr_handler() to finish in rdma_destroy_id()

This commit attempts to fix a use-after-free of id_priv in addr_handler()
when called via rdma_destroy_id(). It calls rdma_addr_cancel() before taking
handler_mutex to ensure the handler is fully finished, and clears
used_resolve_ip to prevent double cancellation.

Link: https://lore.kernel.org/all/20261004112613.18171-1-raghunathpalla.020=
9@gmail.com/

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf72..72138f40dd78e 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1968,12 +1968,14 @@ static void cma_cancel_operation(struct rdma_id_p=
rivate *id_priv,
>  		/*
>  		 * We can avoid doing the rdma_addr_cancel() based on state,
>  		 * only RDMA_CM_ADDR_QUERY has a work that could still execute.
> -		 * Notice that the addr_handler work could still be exiting
> -		 * outside this state, however due to the interaction with the
> -		 * handler_mutex the work is guaranteed not to touch id_priv
> -		 * during exit.
> +		 * The addr_handler work can still be finishing its
> +		 * mutex_unlock() after it has left this state.
> +		 * rdma_destroy_id() waits for that before it takes
> +		 * handler_mutex, and clears used_resolve_ip so the request
> +		 * isn't canceled twice.
>  		 */
> -		rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
> +		if (id_priv->used_resolve_ip)

[Severity: High]
Does this leave a use-after-free window open if destruction happens via the
device removal path?

If cma_process_remove() processes device removal concurrently with
addr_handler(), it queues cma_send_device_removal_put().

addr_handler() acquires handler_mutex, updates the state to
RDMA_CM_ADDR_RESOLVED, attaches to the device, and drops the mutex.

cma_send_device_removal_put() then acquires the mutex, reads the updated st=
ate,
triggers the DEVICE_REMOVAL event, and if the ULP (like SRP) returns non-ze=
ro,
it directly calls _destroy_id(id_priv, state), bypassing rdma_destroy_id():

drivers/infiniband/core/cma.c:cma_send_device_removal_put() {
    ...
    if (cma_cm_event_handler(id_priv, &event)) {
        trace_cm_id_destroy(id_priv);
        _destroy_id(id_priv, state);
        return;
    }
    ...
}

Because cma_cancel_operation() ties cancellation exclusively to the
RDMA_CM_ADDR_QUERY state, the _destroy_id() call will pass
state =3D RDMA_CM_ADDR_RESOLVED. This skips the rdma_addr_cancel() call,
failing to wait for addr_handler() to finish, and immediately freeing
id_priv while addr_handler() is still accessing it during mutex_unlock().

[Severity: Low]
Does this lockless read of used_resolve_ip cause a data race?

When the ULP handles RDMA_CM_EVENT_DEVICE_REMOVAL by queueing an asynchrono=
us
teardown task that calls rdma_destroy_id(), this read can execute concurren=
tly
with the ULP's teardown task. If cma_process_remove() calls
cma_cancel_operation() after releasing handler_mutex, neither path holds a
lock protecting this variable. Should this be annotated with READ_ONCE() to
prevent KCSAN warnings?

> +			rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
>  		break;
>  	case RDMA_CM_ROUTE_QUERY:
>  		cma_cancel_route(id_priv);

[ ... ]

> @@ -2121,6 +2123,20 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>  	struct rdma_id_private *id_priv =3D
>  		container_of(id, struct rdma_id_private, id);
> =20
> +	/*
> +	 * addr_handler() can still be in mutex_unlock(&handler_mutex) after
> +	 * it has moved the state on from RDMA_CM_ADDR_QUERY, and
> +	 * mutex_unlock() may touch the mutex even after we have taken it.
> +	 * Wait for the work to finish before we free id_priv. The req stays
> +	 * on req_list until the callback returns, so rdma_addr_cancel() will
> +	 * find it. Nothing can issue a new request now, so clear
> +	 * used_resolve_ip and let cma_cancel_operation() skip its cancel.
> +	 */
> +	if (id_priv->used_resolve_ip) {
> +		rdma_addr_cancel(&id->route.addr.dev_addr);

[Severity: High]
Does matching the request by pointer in rdma_addr_cancel() introduce an ABA
use-after-free issue?

In addr_handler(), if the user's event handler returns non-zero (for exampl=
e,
rds_rdma_cm_event_handler_cmn() can return a non-zero error code during
RDMA_CM_EVENT_ADDR_RESOLVED), destroy_id_handler_unlock() synchronously fre=
es
the id_priv memory:

drivers/infiniband/core/cma.c:addr_handler() {
    ...
    if (cma_cm_event_handler(id_priv, &event)) {
        destroy_id_handler_unlock(id_priv);
        return;
    }
    ...
}

At this point, the old req is still on req_list while process_one_req() is
executing and has not yet acquired the spin_lock_bh(&lock) to remove it:

drivers/infiniband/core/addr.c:process_one_req() {
    ...
    cancel_delayed_work(&req->work);
    if (!list_empty(&req->list)) {
        list_del_init(&req->list);
        kfree(req);
    }
    ...
}

A concurrent thread can allocate a new id_priv that reuses the exact same m=
emory
address (slab reuse). The new thread calls rdma_resolve_addr(), queueing a =
new
req to req_list with the exact same addr pointer.

When the new thread then calls rdma_destroy_id(), it invokes
rdma_addr_cancel(&new_id_priv->id.route.addr.dev_addr):

drivers/infiniband/core/addr.c:rdma_addr_cancel() {
    ...
    list_for_each_entry_safe(req, temp_req, &req_list, list) {
        if (req->addr =3D=3D addr) {
            list_del_init(&req->list);
            found =3D req;
            break;
        }
    }
    ...
}

Because rdma_addr_cancel() stops at the first match, it finds and cancels t=
he
OLD req instead of the NEW req. The NEW req remains active on req_list. Aft=
er
the new id_priv is destroyed and freed, the NEW req's delayed work will
eventually fire, passing the freed id_priv to its callback and causing a
use-after-free.

> +		id_priv->used_resolve_ip =3D 0;

[Severity: Low]
Does this lockless write to used_resolve_ip cause a data race?

As noted above, this can execute concurrently with lockless reads in
cma_cancel_operation() during device removal. Should this be annotated with
WRITE_ONCE()?

> +	}
> +
>  	mutex_lock(&id_priv->handler_mutex);
>  	destroy_id_handler_unlock(id_priv);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011174846.5918=
6-1-raghunathpalla.0209@gmail.com?part=3D1
