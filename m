Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759747;
	b=WZMGybCryF8sTN6evro5I0CqGpgMEk5qTBilPHmWTGLH5nc6wwaD4IqC1A/9n77ntgMx
	 SdK22pvEPidOVk1fhyb06TtuUAb5/nOx7cT3KUOzqUgZdHqhVDnjLltkxsbLq5lyZv+do
	 MexA68bNanL/9ZQ8xKEYL06l7lvnCPLIVkm5omNLR8bRrHNaQlj5GUui3to9bVKfiyLR6
	 V+FBDxx/eK5EQA/4Wvt9lxDNoDRa1rMaQciWzaxfN6pqEXjHErWQj8iL1MxiOChjDOmf/
	 1EBuxE2dTHgwv8Yttw2xxKUT3tK0XLApElC3RacN1hBFk96OKXm8vc2vXhqIYfnXo9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759747;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1aPzUzYiMTmXP9wHiOyh/D10jpEQp17b5KJNKoPtFFE=;
	b=KXoDcFwWW08lZ9Bx8AlACXyNxlc1j4rM1WjM6R4SO8W95SH/xAKZXehF4ZzWj42wLpGz
	 6rsjnyvS+C2+d5Ot7ldLHALVzhLY3DTOsnwhLYETIh3Z6/VtSWbr+H9jw5JiogpKcu9xL
	 cNL++CRFkFMbQO0ZZnxd1V77UxzCKTOVYF+2g5jKRkeJRtVYMJXCJMy+7UBrLlSXQMDU3
	 qvu23UTlorCN6lgSr+gkvzbDZQOtWgq64gSeaphOnu/uHkL+oVi0AvnLUpTgkxZE19Aon
	 dJlbDmVCJp7txqEpnKXhe2R/0NOdzDjl/Xg3fp4SaviRVMOdwST8RzkpPGAs/dq0w/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bBwa3vX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5314606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bBwa3vX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FBB1F01825;
	Fri, 23 Oct 2026 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759746;
	bh=1aPzUzYiMTmXP9wHiOyh/D10jpEQp17b5KJNKoPtFFE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bBwa3vX5OxXBh7VLt5A0uxBc/A70+uA3CtbWxdNro3Q3His1L7YMsf0ZYnEUTQQJP
	 TxMrQKCztD/tNwZ/WquNvLzfzpBrsqtExnmthX3KZg8pgaHRt7Ss/hSBnDwJEOZKlW
	 q8nb2TltmsM9Fkm+nvY08RG0lMJAxpf647U/O/JRjQInEELSF4ByV22/+1H0EZqC+N
	 F+R29yNJq1zdCf91o8kfhOZIuX3Ys5nh6vTudn7MS9UVbc4daRdJqAL86OElmrLjlF
	 5IUmTZk1cxIAkaK+EvrKJ6dX5hQA6tlZS6EDsBcaWgGHYuaP63BwQoMAObn671slzL
	 t/5pE+LsD/TOA==
Message-ID: <sashiko-outbox-182794@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] rpcrdma: Pin notifications during removal callbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261023125033.528835-3-lixiasong1@huawei.com>
References: <20261023125033.528835-1-lixiasong1@huawei.com>
 <20261023125033.528835-3-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 12:49:05 +0000
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
- [High] xprtrdma: use-after-free of ep->re_xprt in rpcrdma_ep_removal_done=
()
--

commit a86275f4d3e636fe6cee2fb36e6c7d9cb58af726
Author: Li Xiasong <lixiasong1@huawei.com>

rpcrdma: Pin notifications during removal callbacks

This commit adds reference-counting get and put callbacks to
rpcrdma_notification and serializes rpcrdma_rn_unregister() with
rpcrdma_device_mutex so device removal callbacks can safely run outside the
mutex.

[ ... ]

> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index be335eed329d1..9b00e71c80a7a 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -297,6 +297,22 @@ static void rpcrdma_ep_removal_done(struct rpcrdma_n=
otification *rn)
>  	xprt_force_disconnect(ep->re_xprt);
>  }
> =20
> +static bool rpcrdma_ep_removal_get(struct rpcrdma_notification *rn)
> +{
> +	struct rpcrdma_ep *ep =3D container_of(rn, struct rpcrdma_ep, re_rn);
> +
> +	return kref_get_unless_zero(&ep->re_kref);
> +}
> +
> +static void rpcrdma_ep_removal_put(struct rpcrdma_notification *rn)
> +{
> +	struct rpcrdma_ep *ep =3D container_of(rn, struct rpcrdma_ep, re_rn);
> +	struct rdma_cm_id *id =3D ep->re_id;
> +
> +	if (rpcrdma_ep_put(ep))
> +		rdma_destroy_id(id);
> +}

[Severity: High]
Can pinning only ep->re_kref in rpcrdma_ep_removal_get() lead to a
use-after-free of ep->re_xprt in rpcrdma_ep_removal_done()?

ep->re_xprt is an unreferenced pointer to &r_xprt->rx_xprt. When
rpcrdma_remove_one() acquires a reference on ep->re_kref via
rpcrdma_ep_removal_get() and drops rpcrdma_device_mutex before calling
rpcrdma_ep_removal_done(), a concurrent transport teardown in
xprt_destroy() -> xprt_destroy_cb() -> xprt_rdma_destroy() can run:

net/sunrpc/xprtrdma/verbs.c:rpcrdma_xprt_disconnect() {
    ...
	if (rpcrdma_ep_put(ep))
		rdma_destroy_id(id);

	r_xprt->rx_ep =3D NULL;
}

Because rpcrdma_remove_one() is holding the extra reference on ep->re_kref,
rpcrdma_ep_put(ep) does not reach zero and returns 0 without calling
rpcrdma_ep_destroy() or rpcrdma_rn_unregister(). rpcrdma_xprt_disconnect()
then returns immediately to xprt_rdma_destroy():

net/sunrpc/xprtrdma/transport.c:xprt_rdma_destroy() {
    ...
	rpcrdma_xprt_disconnect(r_xprt);
    ...
	xprt_rdma_free_addresses(xprt);
	xprt_free(xprt);
}

xprt_rdma_destroy() frees xprt->address_strings[] and schedules xprt for
destruction via kfree_rcu() while rpcrdma_remove_one() is executing in
sleepable process context outside any RCU read-side section. When
rpcrdma_ep_removal_done() then calls xprt_force_disconnect(ep->re_xprt), it
accesses the freed address_strings[] in trace_xprt_disconnect_force(), locks
xprt->transport_lock, and schedules xprt->task_cleanup on the freed
rpc_xprt.

The follow-up change ("xprtrdma: Wake connect worker on device removal")
still leaves this window open when rpcrdma_ep_removal_done() observes
xchg(&ep->re_connect_status, -ENODEV) =3D=3D 1 and transitions
ep->re_force_disconnect from 0 to 1 via rpcrdma_force_disconnect(ep) before
rpcrdma_xprt_drain() flushes the receive queue (or when no receive WRs are
posted), as rpcrdma_xprt_disconnect() will still return with ep->re_kref > 0
while rpcrdma_force_disconnect() proceeds to call
xprt_force_disconnect(ep->re_xprt).

Should rpcrdma_ep_removal_get() also acquire a reference on ep->re_xprt (for
example via xprt_get_unless_zero(), or by ensuring transport teardown waits
for in-flight removal callbacks) before rpcrdma_ep_removal_done()
dereferences ep->re_xprt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023125033.5288=
35-1-lixiasong1@huawei.com?part=3D2
