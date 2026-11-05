Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793846778;
	b=sNKJRm6U2srD0u9xjI+Uiewgcbt9VDQ4G0VFOLPAnuHFxxXLuhTavUtGNNmNzHtQ46Yj
	 MevgdBCJVT4LKtG+1MTDCt9n0o53aZVT34ADF4TbV44r/Lk97EyMt1jXd8LzSgurSuRHb
	 cmP4Xox4sFJ/GRPSiIgUYxbq5hoAdTAAziaRtVw2n7lHAd5QW7EIei4qhC/T6h8hQAYrU
	 elZEvzgdEDSaWCurOroFTqyHxWUwfJ60M69/wjoe/wwGlvQzfJ3VXJ15tUG/HZzbeAr/w
	 mp+QOZ3UX7jFgNukY5EIOt5XRVBaQKQ+0c85YpMrclkiNXL3WbnfmWpi+fz1kEt957Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793846778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pQuGx9CIA8sr0AeiKlq1u77VMmNA7SIF/2yGjh6OerI=;
	b=e8vzdzSFYu3NTss8DOhyNFStCsj/N4dsTfaEhq7xQSjSNObTGGSeVGviVZLe391Q+bVy
	 Mh1sV1OqQMuWbsb5VBvosOAgJSeNura1V1C90ajXTvw8iSkqpWKl005544xOclyl+th0O
	 PC6aj1zZL8WkdabyE/kQXA3s/guagaJQ8LXDpxKOH2YEGMwzeqEfwXX8DpxQCGTXHU+g4
	 wfw/lyt7gCTorvXT5KaGJT/9qmF/Hiuqn0lFoxh1RIGkTkQH58oTAuHsAxdkds/4vOSgz
	 axzxrNv3Xrzt6bMreyPVnPvWqZBqD829aMCbVTMhHzUXFfDEWp+kuj07At2LoZgsLmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoAitbtH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8975D606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 02:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoAitbtH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF771F000C1;
	Thu,  5 Nov 2026 02:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793846778;
	bh=pQuGx9CIA8sr0AeiKlq1u77VMmNA7SIF/2yGjh6OerI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OoAitbtHmYYVIfPQn1iiz/6HlkvrNKbbH/rh9Dj9VvgmXdi4QK+SJrTl5s8rXa26k
	 vt9wc7/Ilyr5HB3FzTDdarubjG+7faapmPitTQ6xJct22Bz64+kvaqRIhsZauIqZIO
	 qix9EXuCfUA/fMJpCiPOT9WHoFLEjW4BVfC5zxKBCFZ7W5vxf6yZ8Mdk8qSc5UYztp
	 aH4lodNLOwrcKG6yzZCJoO5AydxgIYNs2yvCWpblLI7DNPd/RzXuK6fEoFmV+1/wh5
	 VvY80VzkuOdYcN6E1UZgxePejitApCXqlL5Bk3VLu2nGd1gQTV+Q3PcGGl0eXCPxcJ
	 8RaOE1XgkcepA==
Message-ID: <sashiko-outbox-198482@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/siw: Fix early peer close handling on listeners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105022253.368316-1-lee@jaeyeong.cc>
References: <20261105022253.368316-1-lee@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 02:46:17 +0000
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
- [High] RDMA/siw: premature listener CEP release before sock_release() on =
error
--

commit 9e6e7c6fb2387746734048153461994802a461df
Author: Jaeyeong Lee <lee@jaeyeong.cc>

RDMA/siw: Fix early peer close handling on listeners

This commit fixes a use-after-free in siw_destroy_listen() and a race during
listener creation by ignoring early peer close events on listening sockets,
serializing accepted child socket handoff with socket state changes, and
holding the listener endpoint in use until setup is complete.

Link: https://lore.kernel.org/r/33abff2233b36a51e468d691cb4327d0294d2734.16=
20343860.git.metze@samba.org

> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index ed49818793dde..90adb9543d9d0 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c

[ ... ]

> @@ -1361,6 +1374,10 @@ static void siw_cm_llp_state_change(struct sock *s=
k)
> =20
>  	case TCP_CLOSE:
>  	case TCP_CLOSE_WAIT:
> +		if (cep->state =3D=3D SIW_EPSTATE_LISTENING ||
> +		    (cep->state =3D=3D SIW_EPSTATE_IDLE &&
> +		     !READ_ONCE(sk->sk_socket)))
> +			break;
>  		if (cep->qp)
>  			cep->qp->tx_ctx.tx_suspend =3D 1;
>  		siw_cm_queue_work(cep, SIW_CM_WORK_PEER_CLOSE);
> @@ -1880,6 +1897,7 @@ int siw_create_listen(struct iw_cm_id *id, int back=
log)
>  		rv =3D -ENOMEM;
>  		goto error;
>  	}
> +	siw_cep_set_inuse(cep);
>  	siw_cep_socket_assoc(cep, s);
> =20
>  	rv =3D siw_cm_alloc_work(cep, backlog);
> @@ -1932,14 +1950,13 @@ int siw_create_listen(struct iw_cm_id *id, int ba=
cklog)
> =20
>  	siw_dbg(id->device, "Listen at laddr %pISp\n", &id->local_addr);
> =20
> +	siw_cep_set_free(cep);
>  	return 0;
> =20
>  error:
>  	siw_dbg(id->device, "failed: %d\n", rv);
> =20
>  	if (cep) {
> -		siw_cep_set_inuse(cep);
> -
>  		siw_free_cm_id(cep);
>  		siw_socket_disassoc(s);
>  		cep->state =3D SIW_EPSTATE_CLOSED;

[Severity: High]
Can the error cleanup path in siw_create_listen() trigger a use-after-free =
on
cep if id->provider_data allocation fails after s->ops->listen() has starte=
d?

In siw_create_listen(), s->ops->listen(s, backlog) places s->sk into
TCP_LISTEN before id->provider_data is allocated:

	rv =3D s->ops->listen(s, backlog);
	if (rv) {
		siw_dbg(id->device, "listen error %d\n", rv);
		goto error;
	}
	cep->cm_id =3D id;
	id->add_ref(id);
	...
	if (!id->provider_data) {
		id->provider_data =3D
			kmalloc_obj(struct list_head);
		if (!id->provider_data) {
			rv =3D -ENOMEM;
			goto error;
		}

During this window, an incoming connection can complete the TCP handshake in
softirq context, creating a child socket in the accept queue that inherits
sk_user_data =3D cep and the siw_cm_llp_* callbacks, and queueing
SIW_CM_WORK_ACCEPT on cep.

If kmalloc_obj() then fails and jumps to error, siw_socket_disassoc(s) only
clears sk_user_data and restores callbacks on the parent listening socket
s->sk, leaving the unaccepted child socket with sk_user_data =3D cep:

error:
	if (cep) {
		siw_free_cm_id(cep);
		siw_socket_disassoc(s);
		cep->state =3D SIW_EPSTATE_CLOSED;

		siw_cep_set_free_and_put(cep);
	}
	sock_release(s);

Because cep->state =3D SIW_EPSTATE_CLOSED and siw_cep_set_free_and_put(cep)=
 run
before sock_release(s) (unlike in siw_drop_listeners(), where sock_release(=
s)
is called while cep->in_use is held and before cep->state is set to
SIW_EPSTATE_CLOSED), two problems can occur before sock_release(s) finishes
tearing down the unaccepted child socket:

1. Once siw_cep_set_free_and_put(cep) releases cep->in_use and drops the
listener reference, the pending SIW_CM_WORK_ACCEPT work item on siw_cm_wq
wakes up, sees cep->state !=3D SIW_EPSTATE_LISTENING in siw_accept_newconn(=
),
and drops the last reference on cep, freeing it. When sock_release(s) then
runs:

  sock_release(s)
    -> inet_release()
      -> tcp_close()
        -> inet_csk_listen_stop()
          -> inet_child_forget()
            -> tcp_disconnect()
              -> siw_cm_llp_error_report(child)

siw_cm_llp_error_report() dereferences the freed cep via sk_to_cep(child).

2. If the peer closes or resets the unaccepted child after cep->state is set
to SIW_EPSTATE_CLOSED, siw_cm_llp_state_change(child) only ignores
SIW_EPSTATE_LISTENING and SIW_EPSTATE_IDLE, so it will proceed to queue
SIW_CM_WORK_PEER_CLOSE on cep (or on already-freed memory).

Should siw_create_listen() call sock_release(s) before setting cep->state =
=3D
SIW_EPSTATE_CLOSED and calling siw_cep_set_free_and_put(cep) (matching
siw_drop_listeners()), or allocate id->provider_data before calling
s->ops->listen()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105022253.3683=
16-1-lee@jaeyeong.cc?part=3D1
