Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF8472540
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792384958; cv=none; b=KcJ4+ipZKwlzk7A47Xsv41lsZW39+ATV4pEs+JJWwjl5WXssVojev/3I2XBr75ZUUBe0IE2FDQreQf/mF0/6daGmHiCW4DJWfPdDvDOlyj+aZfCDCQSSKNsuPyWOgpfZ+27qsQ+NlRgaczP99Axe0JYf8r3GwPe8tDbRFpfnYe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792384958; c=relaxed/simple;
	bh=a6wAUq1VbxkfMmvCpVptKwn3Bvd+8nAunj+ikmHewb4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=t/6F3iaB/sFnGvcCbVtOzWIAvpq2xeulZGENbsUF3hGciQnS9kA1+Vb/bsUq8Fs/Zk4hYfvtAAM/LHFEItEi1fWr/frnxmIScrthaoEk0qdorQskCPysUTk3XYg4B/EH00wli9EGGVWfMNsOwJRMtmRLH6XBOWgTrIOTcUS37no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhzVtQvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhzVtQvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F881F000C4;
	Mon, 19 Oct 2026 04:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792384947;
	bh=e5oCCRVQbIUa5jtllThrHtTNeFlzuDBGnPGMVZl6r7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JhzVtQvfyULcv75/FkVD4eGFQnqSxvzoM8HFyl84ccoyCv+iVUZlnZefiv++hvOUa
	 ngFYg4tN0p04oatACwbpyeu2+jh0E5j4Sxo566uaAIW0tMAeSAqGpmgZfMeguw8bLq
	 dtNwpB5YQqi9gc51RHj8vdMaQsqxCp/OSCxf8Zgh58I3jF6SmLwS2+nmMANDOrKphC
	 A/JqDTLAF67BM1G0hWYb5GUwv9ICisZmTKKFFTzWvz5W2wZm661iG2NhSte47MrLlL
	 bm18ofIHcxz/2baBOUR1WZBxd4vHoZ2j8fjqzfuKOTOw0G1KDm9JaUg0dBZQjvWbgd
	 qBq4TurcEOCDA==
Message-ID: <sashiko-outbox-176647@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: Fix use-after-free of the per-net tunnel
 socket
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019043205.466134-1-18983559317@163.com>
References: <20261019043205.466134-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 04:42:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/rxe: broken sk_refcnt check and reference leak in rxe_sock_pu=
t()
--

commit 4fbcdc28fc0ebeebf87dd5a747900ac13874c9a3
Author: Binbin Deng <18983559317@163.com>

RDMA/rxe: Fix use-after-free of the per-net tunnel socket

This patch fixes a use-after-free of the per-net UDP tunnel socket by
clearing the per-net socket pointer before releasing the tunnel in
rxe_sock_put(), and by taking a reference on sk->sk_refcnt under
rcu_read_lock() in rxe_ns_pernet_sk4() and rxe_ns_pernet_sk6().

> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/=
rxe/rxe_net.c
> index 53daaf4c1eb2e..ec98133a60055 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -135,13 +135,20 @@ static struct dst_entry *rxe_find_route6(struct rxe=
_qp *qp,
>  {
>  	struct dst_entry *ndst;
>  	struct flowi6 fl6 =3D {};
> +	struct sock *sk;
> =20
>  	fl6.flowi6_oif =3D ndev->ifindex;
>  	memcpy(&fl6.saddr, saddr, sizeof(*saddr));
>  	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
>  	fl6.flowi6_proto =3D IPPROTO_UDP;
> =20
> -	ndst =3D ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);
> +	/* keep the socket pinned while it is passed to the IPv6 routing
> +	 * code which dereferences it outside of rcu_read_lock()
> +	 */
> +	sk =3D rxe_ns_pernet_sk6(net);
> +	ndst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);
> +	if (sk)
> +		sock_put(sk);
>  	if (IS_ERR(ndst)) {
>  		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
>  		return NULL;
> @@ -638,9 +645,15 @@ static void rxe_sock_put(struct sock *sk,
>  	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
>  		__sock_put(sk);
>  	} else {
> +		/*
> +		 * Clear the per-net pointer before the socket is released:
> +		 * rxe_ns_pernet_sk4/6() take a reference on the socket, but
> +		 * new lookups must not find it once it is being released.
> +		 */
> +		set_sk(net, NULL);
>  		rxe_release_udp_tunnel(sk);
> -		sk =3D NULL;
> -		set_sk(net, sk);
> +		/* drop the reference from rxe_ns_pernet_sk4/6() */
> +		sock_put(sk);
>  	}
>  }

[Severity: High]
Does this change make the else branch in rxe_sock_put() unreachable and
leak sk->sk_refcnt as well as the UDP tunnel sockets?

When the first RXE device in a network namespace creates a UDP tunnel
socket via rxe_setup_udp_tunnel() in rxe_net_ipv4_init() or
rxe_net_ipv6_init(), sk->sk_refcnt starts at 2 (SK_REF_FOR_TUNNEL). Each
additional device in the namespace increments sk->sk_refcnt by 1 via
rxe_ns_pernet_sk4() or rxe_ns_pernet_sk6().

Both callers of rxe_sock_put() fetch sk via rxe_ns_pernet_sk4() or
rxe_ns_pernet_sk6() right before calling rxe_sock_put():

drivers/infiniband/sw/rxe/rxe_net.c:rxe_net_del() {
	sk =3D rxe_ns_pernet_sk4(net);
	if (sk)
		rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);

	sk =3D rxe_ns_pernet_sk6(net);
	if (sk)
		rxe_sock_put(sk, rxe_ns_pernet_set_sk6, net);
}

drivers/infiniband/sw/rxe/rxe_net.c:rxe_net_init() {
    ...
err_out:
	/* If ipv6 error, release ipv4 resource */
	sk =3D rxe_ns_pernet_sk4(net);
	if (sk)
		rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);
    ...
}

Because rxe_ns_pernet_sk4() and rxe_ns_pernet_sk6() now increment
sk->sk_refcnt with refcount_inc_not_zero(), refcount_read(&sk->sk_refcnt)
upon entry to rxe_sock_put() is at least SK_REF_FOR_TUNNEL + 1 (3 when one
device exists, or N + 2 for N > 1 devices).

As a result, in rxe_sock_put():

1. refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL is always true, so the
   else branch (set_sk(net, NULL) and rxe_release_udp_tunnel(sk)) is never
   reached when the last RXE device is deleted or when rxe_net_ipv6_init()
   fails.

2. The if branch calls __sock_put(sk) only once, which only drops the
   temporary reference just acquired by the caller's rxe_ns_pernet_sk4() or
   rxe_ns_pernet_sk6() call without dropping the per-device reference taken
   in rxe_net_ipv4_init() or rxe_net_ipv6_init(). Each device addition and
   removal cycle therefore leaks a reference on struct sock.

3. In addition, because rxe_find_route6() also increments sk->sk_refcnt via
   rxe_ns_pernet_sk6(net) and drops it with sock_put(sk), any concurrent
   rxe_find_route6() in flight during rxe_net_del() of the last device will
   elevate sk->sk_refcnt. Even if the threshold in rxe_sock_put() were
   adjusted for the caller's getter reference, wouldn't a concurrent route
   lookup cause rxe_sock_put() to take the if branch and skip releasing the
   UDP tunnel, while rxe_find_route6()'s subsequent sock_put(sk) only
   decrements sk->sk_refcnt without releasing the tunnel?

[ ... ]

> diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/r=
xe/rxe_ns.c
> index 64621c89f8bf1..0a7d409c0f981 100644
> --- a/drivers/infiniband/sw/rxe/rxe_ns.c
> +++ b/drivers/infiniband/sw/rxe/rxe_ns.c
> @@ -71,6 +71,12 @@ static struct pernet_operations rxe_net_ops =3D {
>  	.size =3D sizeof(struct rxe_ns_sock),
>  };
> =20
> +/*
> + * Return the per-net tunnel socket with a reference taken, or NULL if
> + * the namespace has no tunnel socket.  The reference is taken under
> + * rcu_read_lock() so the socket cannot be freed while the pointer is
> + * still published; the caller must sock_put() it.
> + */
>  struct sock *rxe_ns_pernet_sk4(struct net *net)
>  {
>  	struct rxe_ns_sock *ns_sk =3D net_generic(net, rxe_pernet_id);
> @@ -78,6 +84,8 @@ struct sock *rxe_ns_pernet_sk4(struct net *net)
> =20
>  	rcu_read_lock();
>  	sk =3D rcu_dereference(ns_sk->rxe_sk4);
> +	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
> +		sk =3D NULL;
>  	rcu_read_unlock();
> =20
>  	return sk;
> @@ -99,6 +107,8 @@ struct sock *rxe_ns_pernet_sk6(struct net *net)
> =20
>  	rcu_read_lock();
>  	sk =3D rcu_dereference(ns_sk->rxe_sk6);
> +	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
> +		sk =3D NULL;
>  	rcu_read_unlock();
> =20
>  	return sk;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019043205.4661=
34-1-18983559317@163.com?part=3D1
