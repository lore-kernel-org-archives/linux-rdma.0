Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D018E35E937
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 02:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792378618; cv=none; b=X9T/J+V0jdvW2GcTlCvx0MIrQpTKtPv/2ksZG/4Q8XnWOb7zXYVDUuaeqENbAFQXuYA6uhp1AG2Nuc4KDUr236VPXm3ebDvrOPbro7OKdU9mwYmaYLiuDnX25iizsqkoWPng5uXrCiMiUr+1Y0qLDmPFDpPCCU8nlDWO5vMgFhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792378618; c=relaxed/simple;
	bh=NidlYxmhPBdABDNMw6Dm/RtUXJn1lLaPLtD2hnJDvhE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XyntQHtBYzulmMGVnG6VUkxJUCiBD3gvpQkZ1/ToSGFdfLwDa7Iut0RiUP9Mev4hDnZciJ58gSCTpoxRvm8/qLOkDjHQ00zWsGKINUjD79GvRN0DnZTdgMwnrLVUIsDv6o13UcGRrkiohtGYLvi43yvcphDPsXkY/KI37SQW//A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4NhgpRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4NhgpRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3619C1F000C4;
	Mon, 19 Oct 2026 02:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792378617;
	bh=k4RUaR6BR3ejFrqLILWQ7qXYxi8LKPIH4Hkzv3GCa5Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K4NhgpRAczT8feqH9AyQj2UdI6Bf9u8NMg3+sdlhjxm7+COMlNYSHbNeDADQUY33Z
	 GFtt7UirsqRPJO/Yfq1b2xLrqvMy+WE7G8roztGV43WmK2FGjf6yG9wAQ6qbRPU8CF
	 gBNQY45JI3/PCUlCROvpCBhXwGROPmgYSdPQGWUjQVx7bTD/Ih9fQvHW57NYNE/kS6
	 eUrznNnLPmljZLJoFoEw1IeF5ZGpIcEBdtgetpcGr1gy3C4iwkRhPGceTu9maQkMk/
	 +/jG5V2Ue17I5nRWr4mYzo5F4YX1NRY3XeZmV01rZhyeksQamHZ+cRbQ61Xm+jQ7NC
	 HvtHr/cZsQD+w==
Message-ID: <sashiko-outbox-176553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: unpublish the per-net tunnel socket before
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019023717.455067-1-18983559317@163.com>
References: <20261019023717.455067-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 02:56:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] RDMA/rxe: use-after-free in rxe_find_route6() due to unpinned =
socket
- [High] RDMA/rxe: unsynchronized sk_refcnt check and socket release in rxe=
_sock_put()
--

commit 860836b4fabbeecebc7b1940a3702993878d2022
Author: Binbin Deng <18983559317@163.com>

RDMA/rxe: unpublish the per-net tunnel socket before

This commit moves the call to set_sk(net, NULL) before
rxe_release_udp_tunnel(sk) in rxe_sock_put() to avoid a slab use-after-free=
 in
ip6_route_output_flags() when a user removes an RXE device while RoCE v2 ov=
er
IPv6 traffic is active.

> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/=
rxe/rxe_net.c
> index 53daaf4c1eb2e..fc597e02c85ca 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -638,9 +638,8 @@ static void rxe_sock_put(struct sock *sk,
>  	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
>  		__sock_put(sk);
>  	} else {
> +		set_sk(net, NULL);

[Severity: Critical]
Does calling set_sk(net, NULL) before rxe_release_udp_tunnel(sk) actually
prevent the slab use-after-free in ip6_route_output_flags() reached from
rxe_find_route6()?

In drivers/infiniband/sw/rxe/rxe_ns.c, rxe_ns_pernet_sk6() drops
rcu_read_unlock() before returning the raw sk pointer without acquiring a
reference on sk:

struct sock *rxe_ns_pernet_sk6(struct net *net)
{
	struct rxe_ns_sock *ns_sk =3D net_generic(net, rxe_pernet_id);
	struct sock *sk;

	rcu_read_lock();
	sk =3D rcu_dereference(ns_sk->rxe_sk6);
	rcu_read_unlock();

	return sk;
}

And in drivers/infiniband/sw/rxe/rxe_net.c, rxe_find_route6() runs in
preemptible workqueue context (rxe_sender() -> rxe_requester() ->
rxe_prepare() -> rxe_find_route() -> rxe_find_route6()) outside any RCU
read-side critical section:

	ndst =3D ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);

If CPU 0 calls rxe_ns_pernet_sk6(net), obtains the non-NULL sk pointer, and
calls rcu_read_unlock() just before CPU 1 calls set_sk(net, NULL) in
rxe_sock_put(), the synchronize_rcu() inside rxe_ns_pernet_set_sk6() will n=
ot
wait for CPU 0 because CPU 0 is no longer in an RCU read-side critical
section.

CPU 1 can then run rxe_release_udp_tunnel(sk) -> udp_tunnel_sock_release(sk=
) ->
sock_release() -> sock_put(sk) -> sk_free(sk) -> call_rcu(&sk->sk_rcu,
__sk_destruct). Because CPU 0 is outside rcu_read_lock() before
ip6_route_output_flags() enters its internal RCU section (and again after
ip6_route_output_flags() drops rcu_read_unlock() before xfrm_lookup_route()=
 ->
xfrm_lookup_with_ifid()), __sk_destruct() can still free sk while CPU 0 is
dereferencing sk->sk_bound_dev_if, inet6_sk(sk)->srcprefs, or
sk->sk_policy[XFRM_POLICY_OUT].

>  		rxe_release_udp_tunnel(sk);
> -		sk =3D NULL;
> -		set_sk(net, sk);
>  	}
>  }

[Severity: High]
Could moving set_sk(net, NULL) before rxe_release_udp_tunnel(sk), combined
with the unsynchronized sk->sk_refcnt check in rxe_sock_put(), also introdu=
ce
a race window with concurrent link operations or socket lookups?

1. In rxe_sock_put(), set_sk(net, NULL) clears ns_sk->rxe_sk4 or
ns_sk->rxe_sk6 and sleeps in synchronize_rcu() before rxe_release_udp_tunne=
l()
closes and unhashes the UDP tunnel socket bound to ROCE_V2_UDP_DPORT:

	} else {
		set_sk(net, NULL);
		rxe_release_udp_tunnel(sk);
	}

Because nldev_newlink() -> rxe_newlink() -> rxe_net_init() does not seriali=
ze
with nldev_dellink() or rxe_notify(NETDEV_UNREGISTER), if rxe_net_ipv4_init=
()
or rxe_net_ipv6_init() runs while set_sk(net, NULL) is sleeping in
synchronize_rcu():

	sk =3D rxe_ns_pernet_sk4(net);
	if (sk) {
		sock_hold(sk);
		return 0;
	}

	sock =3D rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), false);

it will see a NULL per-net socket pointer and try to create a new UDP tunnel
socket on ROCE_V2_UDP_DPORT while the old socket is still bound, failing wi=
th
-EADDRINUSE.

2. Furthermore, rxe_sock_put() checks refcount_read(&sk->sk_refcnt) >
SK_REF_FOR_TUNNEL without lock serialization across rxe_net_del() callers
(nldev_dellink() and rxe_notify(NETDEV_UNREGISTER)) or rxe_net_init(), and =
the
UDP tunnel socket is hashed in the global UDP tables where paths like
udp_diag_dump_one() or udp4/6_lib_lookup() transiently increment sk->sk_ref=
cnt
via refcount_inc_not_zero(). If a transient reference is held when the last
RXE device in the netns is removed, refcount_read(&sk->sk_refcnt) >
SK_REF_FOR_TUNNEL evaluates to true, causing rxe_sock_put() to call
__sock_put(sk) instead of releasing the tunnel and leaving a dangling socket
with an unbalanced refcount published in the netns.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019023717.4550=
67-1-18983559317@163.com?part=3D1
