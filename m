Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600951;
	b=SRGYC+fLdf+TB1QET4vdNd2M6PMYUNhUpitDC8aB59qn0ZrtHjtgUOY+8k1pF3H601ej
	 8hnBha1uZOBWtQO2Kj9sB0u1S6jYObeVMGwF38op/8QSAcIsrj2gq4QvOQNqqZoniDcr4
	 neHxZzVapsXddLqOB1ciTTdqZRspTC0DGOC5iTqXvw0KZnKRJeZEFrqdXS+0RvkPSK4Eo
	 tJKrvG8bipAkG6+XOJbbZC62CWymLVsgMWWXZYaaLAq+dkeQasDZ9vaTDUi/cp79hNhf2
	 uYtZB+ZAlsmT5Hjt4AUNPvMQMH6cxtVoNpJFDZAs/1yS7S2zRXeCKy8/jy461hgiwng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600951;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yjkeeFtyYAg90Wn9LA1m8s0L76UVy7cZZLYrIK2hdNk=;
	b=uEEOOP+Fmc5W0W9nYQXjz4+qNgCq/KZ2h7iujRgGQT45nrQSgedC6+i3xpXgByfvcFsp
	 1hfFTnNx/yabOxSDOJmPSW2eZIQzh3LWUv01swjImEfJDKEF/eT7JU56iqBdCs6CBCvBW
	 vqBh8z3c9XitoKZGyk/mbEjvI8p/hP71NgMnGKayRysC1s1DoFJDzSzvcdjxjrOlhccRU
	 HQCX02vgbWNtcxelpCA4T/N/kwW+FuG2VKk3diwn8ztcSG5aVFQQ77cYAdpibSIJqjqbT
	 BT9ToEshTSridUdAn92mgJnSxelns9jioIa2MTyfpLUU/3bzHeY/gi4zP86V27BO3mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSTlL4r1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A0606A324;
	Mon,  2 Nov 2026 06:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSTlL4r1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F031F000C1;
	Mon,  2 Nov 2026 06:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793600950;
	bh=yjkeeFtyYAg90Wn9LA1m8s0L76UVy7cZZLYrIK2hdNk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GSTlL4r1Y3oTznxCbiA7n6cebpQcKtmjNo2dPF0kFWubWn6XCBI03CnFSqWRLXYld
	 Ci3Hemm8DYJpv5bZXcBmf1DRzEgWNiuNm5IdHfR+uIkyirMMkAeW7lyD9yYPbiLrJZ
	 Hxn8Uu0Zeqyr+39lBRPDg0Edhb/FKOpT1gsUG757VEjqOeKyRVtmxK1UGlFe3ogocK
	 RqMsCXlkHKP20j3ekMSskp3OGPWKDP9RtVBx+xRDCHtsw2sSG11anuG85Uw1gtrDDS
	 gknpyWvdHqPHhBq76KOXeqJY7V+SKWlB99aMv/0wMtdrDNTuHGi+wKkYHNq/IBH/CL
	 EQQGHCO18ATMQ==
Message-ID: <sashiko-outbox-192955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] IB/isert: do not publish connections being
 released on a second list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261102061608.617186-2-yhlee@isslab.korea.ac.kr>
References: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
 <20261102061608.617186-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:29:09 +0000
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
- [Critical] IB/isert: race between isert_free_np() and isert_connected_han=
dler()
- [Critical] IB/isert: race between isert_free_np() and isert_connect_error=
()
--

commit a36a7ac6c22cec858896a9509524018f8c67a5b1
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: do not publish connections being released on a second list

This commit changes isert_free_np() to take connections off
isert_np->pending and isert_np->accepted one at a time under
isert_np->mutex rather than moving them onto a local list, so that
isert_conn->node is empty when isert_np->mutex is dropped and
isert_handle_unbound_conn() does not unlink and release them a second time.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index efa8d7b7844c9..5371bba71ba3c 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2479,12 +2479,29 @@ isert_accept_np(struct iscsi_np *np, struct iscsi=
t_conn *conn)
>  	return 0;
>  }
> =20
> +static struct isert_conn *
> +isert_np_take_conn(struct isert_np *isert_np)
> +{
> +	struct isert_conn *isert_conn;
> +
> +	lockdep_assert_held(&isert_np->mutex);
> +
> +	isert_conn =3D list_first_entry_or_null(&isert_np->pending,
> +					      struct isert_conn, node);
> +	if (!isert_conn)
> +		isert_conn =3D list_first_entry_or_null(&isert_np->accepted,
> +						      struct isert_conn, node);
> +	if (isert_conn)
> +		list_del_init(&isert_conn->node);
> +
> +	return isert_conn;
> +}

[Severity: Critical]
Can isert_np_take_conn() race with isert_connect_error() when a connection =
on
isert_np->accepted fails concurrently with isert_free_np()?

In isert_free_np(), rdma_destroy_id(isert_np->cm_id) only destroys the
listening cm_id, leaving child connection cm_ids created by
isert_connect_request() active on isert_np->accepted with kref =3D=3D 1.

If RDMA_CM_EVENT_REJECTED, RDMA_CM_EVENT_UNREACHABLE, or
RDMA_CM_EVENT_CONNECT_ERROR fires on a child cm_id,
cma_ib_handler()->isert_cma_handler()->isert_connect_error() runs under
id_priv->handler_mutex and calls ib_drain_qp() before taking isert_np->mute=
x:

drivers/infiniband/ulp/isert/ib_isert.c:isert_connect_error() {
	struct isert_conn *isert_conn =3D cma_id->qp->qp_context;
	struct isert_np *isert_np =3D cma_id->context;

	ib_drain_qp(isert_conn->qp);

	mutex_lock(&isert_np->mutex);
	list_del_init(&isert_conn->node);
	mutex_unlock(&isert_np->mutex);
	isert_conn->cm_id =3D NULL;
	isert_put_conn(isert_conn);

	return -1;
}

If isert_free_np() takes that connection via isert_np_take_conn() while
isert_connect_error() is in ib_drain_qp(), isert_free_np() drops
isert_np->mutex and calls isert_connect_release(isert_conn), which blocks in
rdma_destroy_id(isert_conn->cm_id) waiting for id_priv->handler_mutex.

When ib_drain_qp() finishes, isert_connect_error() does not check
!list_empty(&isert_conn->node) under isert_np->mutex. Would it then call
isert_put_conn(isert_conn) (dropping kref from 1 to 0 and running
isert_connect_release(isert_conn) -> kfree(isert_conn)) and return -1 to
destroy the cm_id while isert_free_np() is concurrently releasing the same
isert_conn?

> +
>  static void
>  isert_free_np(struct iscsi_np *np)
>  {
>  	struct isert_np *isert_np =3D np->np_context;
> -	struct isert_conn *isert_conn, *n;
> -	LIST_HEAD(drop_conn_list);
> +	struct isert_conn *isert_conn;
> =20
>  	if (isert_np->cm_id)
>  		rdma_destroy_id(isert_np->cm_id);
> @@ -2497,31 +2514,22 @@ isert_free_np(struct iscsi_np *np)
>  	 * up in accepted and pending lists.
>  	 */
>  	mutex_lock(&isert_np->mutex);
> -	if (!list_empty(&isert_np->pending)) {
> +	if (!list_empty(&isert_np->pending))
>  		isert_info("Still have isert pending connections\n");
> -		list_for_each_entry_safe(isert_conn, n,
> -					 &isert_np->pending,
> -					 node) {
> -			isert_info("cleaning isert_conn %p state (%d)\n",
> -				   isert_conn, isert_conn->state);
> -			list_move_tail(&isert_conn->node, &drop_conn_list);
> -		}
> -	}
> -
> -	if (!list_empty(&isert_np->accepted)) {
> +	if (!list_empty(&isert_np->accepted))
>  		isert_info("Still have isert accepted connections\n");
> -		list_for_each_entry_safe(isert_conn, n,
> -					 &isert_np->accepted,
> -					 node) {
> -			isert_info("cleaning isert_conn %p state (%d)\n",
> -				   isert_conn, isert_conn->state);
> -			list_move_tail(&isert_conn->node, &drop_conn_list);
> -		}
> -	}
>  	mutex_unlock(&isert_np->mutex);
> =20
> -	list_for_each_entry_safe(isert_conn, n, &drop_conn_list, node) {
> -		list_del_init(&isert_conn->node);
> +	for (;;) {
> +		mutex_lock(&isert_np->mutex);
> +		isert_conn =3D isert_np_take_conn(isert_np);
> +		mutex_unlock(&isert_np->mutex);
> +
> +		if (!isert_conn)
> +			break;
> +
> +		isert_info("cleaning isert_conn %p state (%d)\n",
> +			   isert_conn, isert_conn->state);
>  		isert_connect_release(isert_conn);
>  	}

[Severity: Critical]
What happens if RDMA_CM_EVENT_ESTABLISHED fires on a connection just after
isert_np_take_conn() pops it from isert_np->accepted and drops
isert_np->mutex?

While isert_free_np()->isert_connect_release()->rdma_destroy_id() waits for
id_priv->handler_mutex, cma_ib_handler()->isert_cma_handler()->
isert_connected_handler() runs and moves isert_conn->node onto
isert_np->pending without checking !list_empty(&isert_conn->node):

drivers/infiniband/ulp/isert/ib_isert.c:isert_connected_handler() {
	...
	mutex_lock(&isert_np->mutex);
	list_move_tail(&isert_conn->node, &isert_np->pending);
	mutex_unlock(&isert_np->mutex);

	isert_info("np %p: Allow accept_np to continue\n", isert_np);
	up(&isert_np->sem);
}

Once isert_connected_handler() returns and drops id_priv->handler_mutex,
isert_connect_release() finishes and frees isert_conn via kfree(isert_conn)
while isert_conn->node is linked on isert_np->pending.

On the next iteration of the for (;;) loop in isert_free_np(), wouldn't
isert_np_take_conn() pop that already-freed isert_conn from isert_np->pendi=
ng
and call isert_connect_release(isert_conn) a second time?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102061608.6171=
86-1-yhlee@isslab.korea.ac.kr?part=3D1
