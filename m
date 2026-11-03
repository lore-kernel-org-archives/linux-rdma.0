Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676615;
	b=DUSd6UYKQNJpiN2vC31UWGAfhUIA9ZmEmVRdk7QLqorXHapY7p0L/YRanpszqE0mpHFm
	 XFcJ2Kf+z5gASVFGHYrUVz10AdITKLor7Wlh14WJ/SyqiVYMkmIo3CirqSli8jU+jFxBj
	 dvwhx0K3mpudQ57uXGmHJ+/r/iiR1p863vRnTMK4+xJLgq5bOB5Q0QSVxjJkrY4Lf3Fnp
	 j/tWFn5fXMRd5OtQEn1LEVZSW0QvL3gM1um65UtMn+xAXQOnHihJae3uvSigCUMeVS+n6
	 leJ1oNMMmW2HCV7Isem4DRID4ywrTwxfBmbwBkof5lHYosujTvM0Tucggai5vcg0GOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4lG3JPIqDiso+6UXofdYqVLl0bQM2VdUGS2F9oMopDA=;
	b=HWzsKTg1nMbB+iRu0C2Gv1H91QXtzz/+Jep8VFAQfjTnFV3KUJhDMufCxaiWg9xDesn3
	 VQql79Bfmfk/yeEE6A6eDI+P8i9wRAgjaDH1TxBs69qXt/GaWZob50vURnZP0uu/+3WWW
	 VDxTgTAUK8UELU0atPF3SojY7Okjo+1FPzQs5tgJB1r8lIMwnOtNXM3d1xfd0TIsp8GVX
	 NytvTRVVMnKarg8JqP/Yy/BoxK9SxkU0B70VeU6iXfiLzx3OWMRwtDXdJKr7hdjnuu2Or
	 4xsyk8/NlHl2rfL76OQMRotnTnOL4eWXiILCkjBv2mxtlbLREXLJKxvlu2MxPHq8ZMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NXGbYqz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9687606A32D
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 03:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NXGbYqz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0E61F00919;
	Tue,  3 Nov 2026 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793676614;
	bh=4lG3JPIqDiso+6UXofdYqVLl0bQM2VdUGS2F9oMopDA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NXGbYqz6G25yfIWtcfXIwsQ1uZHO9qHzUsdhDt3L7fpAoXi0ekAxsoPwhSrcLEtCp
	 6s1NhSZZe/1ePktiUXeIQ74xivwpNyqv6EWEsbpDuorAZv0AC7dFRejVfSGmDEi7j5
	 E18O8Ss+G9PRMWJe8AtPRX4eCor9aMYOV90Kq6Xi4Dhu4r3XiXJYxHsGiOIq/swK2w
	 dBMaV42BsE1ShkWijqVfxlk11lTLp8IPT2U89g5uygA+pG20CHXGkaS2zN/h8VHY6h
	 Dh/AwdwsQZr2rLBrne4vEnZeqU/Mw8wfmijDq+IYNIG614RnekR9HvlA90p/qER3Tk
	 jvbur9SA7wwPA==
Message-ID: <sashiko-outbox-194517@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] xprtrdma: Wake connect worker on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261103032758.1302493-4-lixiasong1@huawei.com>
References: <20261103032758.1302493-1-lixiasong1@huawei.com>
 <20261103032758.1302493-4-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:30:13 +0000
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
- [Critical] xprtrdma: rpcrdma_cm_event_handler() forces disconnect on unpi=
nned xprt
- [High] xprtrdma: rpcrdma_ep_disconnect() fails to update established stat=
us
--

commit d1bbd79b2434442573f7ee7831bc287ea9096c3a
Author: Li Xiasong <lixiasong1@huawei.com>

xprtrdma: Wake connect worker on device removal

This commit updates endpoint connection status transitions and CM ID teardo=
wn
during RDMA device removal and CM events so that pending connect workers are
woken and endpoint destruction synchronizes with CM callbacks.

> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 69d1796bb4f3b..9eec462cffd92 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -75,7 +75,7 @@ static void rpcrdma_reps_unmap(struct rpcrdma_xprt *r_x=
prt);
>  static void rpcrdma_mrs_create(struct rpcrdma_xprt *r_xprt);
>  static void rpcrdma_mrs_destroy(struct rpcrdma_xprt *r_xprt);
>  static void rpcrdma_ep_get(struct rpcrdma_ep *ep);
> -static int rpcrdma_ep_put(struct rpcrdma_ep *ep);
> +static void rpcrdma_ep_put(struct rpcrdma_ep *ep);
>  static struct rpcrdma_regbuf *
>  rpcrdma_regbuf_alloc_node(size_t size, enum dma_data_direction direction,
>  			  int node);
> @@ -124,6 +124,20 @@ void rpcrdma_force_disconnect(struct rpcrdma_ep *ep)
>  		xprt_force_disconnect(ep->re_xprt);
>  }
> =20
> +static void rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, int status)
> +{
> +	switch (cmpxchg(&ep->re_connect_status, 0, status)) {
> +	case 0:
> +		wake_up_all(&ep->re_connect_wait);
> +		break;
> +	case 1:
> +		rpcrdma_force_disconnect(ep);
> +		break;
> +	default:
> +		break;
> +	}
> +}

[Severity: High]
When ep->re_connect_status is already 1 (established), cmpxchg(&ep->re_conn=
ect_status, 0, status) in rpcrdma_ep_disconnect() returns 1 without updatin=
g ep->re_connect_status to status.

Unlike the previous xchg(&ep->re_connect_status, -ENODEV) in RDMA_CM_EVENT_=
ADDR_CHANGE (and the xchg() calls used for RDMA_CM_EVENT_REJECTED and RDMA_=
CM_EVENT_DISCONNECTED), calling rpcrdma_ep_disconnect() from rpcrdma_ep_rem=
oval_done(), RDMA_CM_EVENT_ADDR_CHANGE, or RDMA_CM_EVENT_UNREACHABLE leaves=
 ep->re_connect_status set to 1.

If RDMA_CM_EVENT_ESTABLISHED transitions ep->re_connect_status to 1 and wak=
es ep->re_connect_wait, and then rpcrdma_ep_disconnect() (or rpcrdma_ep_rem=
oval_get() when xprt_get() fails) runs before rpcrdma_xprt_connect() checks=
 the status:

net/sunrpc/xprtrdma/verbs.c:rpcrdma_xprt_connect() {
	...
	wait_event_interruptible(ep->re_connect_wait,
				 ep->re_connect_status !=3D 0);
	if (ep->re_connect_status <=3D 0) {
		rc =3D ep->re_connect_status;
		goto out;
	}
	...
}

won't rpcrdma_xprt_connect() observe ep->re_connect_status =3D=3D 1 and pro=
ceed to allocate and post send contexts, receive buffers, and MRs on the di=
sconnecting or removing device while holding XPRT_LOCKED?

Leaving ep->re_connect_status =3D=3D 1 also allows rpcrdma_mrs_refresh() to=
 continue queueing buf->rb_refresh_worker until xprt_autoclose() runs:

net/sunrpc/xprtrdma/verbs.c:rpcrdma_mrs_refresh() {
	...
	if (ep->re_connect_status !=3D 1)
		return;
	queue_work(system_highpri_wq, &buf->rb_refresh_worker);
}

Should rpcrdma_ep_disconnect() update ep->re_connect_status when transition=
ing from 1 as well (for example, using xchg() or a second transition from 1=
 to status)?

[ ... ]

> @@ -247,20 +262,18 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, str=
uct rdma_cm_event *event)
>  		complete(&ep->re_done);
>  		return 0;
>  	case RDMA_CM_EVENT_ADDR_CHANGE:
> -		switch (xchg(&ep->re_connect_status, -ENODEV)) {
> +		rpcrdma_ep_disconnect(ep, -ENODEV);
> +		return 0;
> +	case RDMA_CM_EVENT_ESTABLISHED:
> +		switch (cmpxchg(&ep->re_connect_status, 0, 1)) {
>  		case 0:
> -			goto wake_connect_worker;
> -		case 1:
> -			/* The later DISCONNECTED event balances the
> -			 * ESTABLISHED get; do not put here.
> -			 */
> +			break;
> +		case -ENODEV:
>  			rpcrdma_force_disconnect(ep);
>  			return 0;
> +		default:
> +			return 0;
>  		}

[Severity: Critical]
As reported by Sashiko on v1 [1], when the final xprt_put() has already dro=
pped xprt->kref to 0 and xprt_destroy() is waiting on XPRT_LOCKED, rpcrdma_=
ep_removal_get() sees !xprt_get(xprt) and sets ep->re_connect_status to -EN=
ODEV via cmpxchg() to wake the connect worker without touching the unpinned=
 xprt:

net/sunrpc/xprtrdma/verbs.c:rpcrdma_ep_removal_get() {
	if (!xprt_get(xprt)) {
		if (cmpxchg(&ep->re_connect_status, 0, -ENODEV) =3D=3D 0)
			wake_up_all(&ep->re_connect_wait);
		return false;
	}
}

If RDMA_CM_EVENT_ESTABLISHED arrives in rpcrdma_cm_event_handler() before t=
he connect worker finishes rpcrdma_xprt_disconnect(), cmpxchg(&ep->re_conne=
ct_status, 0, 1) returns -ENODEV and executes:

	rpcrdma_force_disconnect(ep);
	  -> xprt_force_disconnect(ep->re_xprt);
	    -> xprt_schedule_autoclose_locked(xprt);

which sets XPRT_CLOSE_WAIT on the unpinned xprt whose kref is already 0.

When xprt_rdma_connect_worker() subsequently unlocks the transport via xprt=
_unlock_connect() -> xprt_release_xprt_cong() -> xprt_clear_locked(), seein=
g XPRT_CLOSE_WAIT causes xprt_clear_locked() to queue xprt->task_cleanup (x=
prt_autoclose) instead of clearing XPRT_LOCKED. Once xprt_autoclose() calls=
 xprt_release_write() and clears XPRT_LOCKED, xprt_destroy() wakes from wai=
t_on_bit_lock(), reinitializes xprt->task_cleanup with INIT_WORK(&xprt->tas=
k_cleanup, xprt_destroy_cb), and frees xprt while xprt_autoclose() is still=
 finishing.

Since ep->re_connect_status was never 1 when cmpxchg(&ep->re_connect_status=
, 0, 1) observes -ENODEV, rpcrdma_xprt_connect() is already guaranteed to s=
ee ep->re_connect_status <=3D 0 and trigger rpcrdma_xprt_disconnect() from =
xprt_rdma_connect_worker(). Can the -ENODEV case in RDMA_CM_EVENT_ESTABLISH=
ED simply return 0 without calling rpcrdma_force_disconnect(ep)?

[1] https://lore.kernel.org/r/20261023125033.528835-4-lixiasong1@huawei.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103032758.1302=
493-1-lixiasong1@huawei.com?part=3D3
