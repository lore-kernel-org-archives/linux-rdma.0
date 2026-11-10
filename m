Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311416;
	b=oIAmKp2rkJA96X+QTINPvO3nfNkmzv4nEiSYGDPK/6JbR7kLF628HI5IFLk3uzgaVzWW
	 HGVJGI6QjiNLJHMDvzw6lUhaR00/r0yNsITMHAaq2K5OBnsKrMmtMY2hjsj/u7ogFvSZ3
	 JFbwWvXFo8PSvM+y0jJfZ6DeG3eCwEkeu9DbYd7hC51EtjKblwC8SCZ9/hxNqMzWvBUxg
	 bwO3Lo/Uacq500l3FjgcGb7Kj5+uZcz/bWqIL6s1vZq6EQjfWbU6C0q6pc2aKwuHQgoak
	 /nEGdscCDu0OaFC+UJoA4MWXrUMYouk3JracCEeu3N49iW1l55HpSIlnDow4zSoH6uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311416;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qlzEk2JJk+7yb2ap3z40Qv3sIgrzPTZOnpm2PJDyPVM=;
	b=Z1bu8NkbVhBgDQKV47caL5Ivh/ry5BlTcuPKEMksUQIy46JoaoGHs0xdkF3WVibtrwpZ
	 2u/lwl80fHR5io1I1k7SJpUqGESGWTzTihNj8tbAmH/6t9wFc6NjFPV3X78nxW8DKAdK2
	 vnQL7srJ/iFqxXgNsYVhoM//YPsiWiwc8mIadRgc0dNo8XvO357TCRm2WkDCD4432HfBm
	 B/VFVLZA3zU9g8Y/wle1ONTDhp2OXvJH6tSYL6AD+h8VLbzJMih1Y/na46fnyoxkUA01o
	 ibCX9rnyB59hZiWk82unzk9URDnpxgVhu0vRo2tq129A6I8ftw3grCA+yGiF1+sI9Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knjOnds2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B3C606B5A6
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knjOnds2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0451F008A3;
	Tue, 10 Nov 2026 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311415;
	bh=qlzEk2JJk+7yb2ap3z40Qv3sIgrzPTZOnpm2PJDyPVM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=knjOnds2sk2fRk0kvsyG9iwwjWXH9ecTUzShu+HIItlutd6b1y6uSi412tYcSXei7
	 3YJu+8eevWI+iS7JnwEP5sCO8doLUZEKo/J3eXR/94MxK4x2J1xqgtdhVTaPtijZbx
	 H4Ve4U1OicPjfvYg+0lnaoQgkMEa4DDAWKLnF/ahjBeY2be05SfELah8bAB0QuEbqe
	 rwU/jEoJoKQcKQ5FGjDCW36I74c6s62hxuN6+XuaU0CElBKz1B+c0PReuswwVPllJC
	 4mC51bLlSCDdA4SC95Yk5jleJE3G0yLJ8voOolx//FIKTZ1aBqbV/ZsPV2eSIqmEhG
	 N+BSSEXFmSM7w==
Message-ID: <sashiko-outbox-206957@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 5/7] net: tls: keep the TX queue of a
 device-offloaded socket stable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-6-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net: netdev_pick_tx() skips sk_tx_queue_set() when
  sk_dst_cache is NULL
--

commit 32c68c0d3ebf3235b8df4cd0c9b9ac85b4fd2c5f
Author: Tariq Toukan <tariqt@nvidia.com>

net: tls: keep the TX queue of a device-offloaded socket stable

This commit adds TLSDEV_F_STICKY_TXQ and SOCK_STICKY_TXQ so that sockets
offloaded to stateful TLS TX devices keep their cached TX queue mapping and
avoid setting skb->ooo_okay while packets are in flight.

Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@pur=
estorage.com/

> diff --git a/include/net/sock.h b/include/net/sock.h
> index 9bba1e793f1ee..ab4b5a5a74f5d 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
[ ... ]
> @@ -2067,6 +2072,29 @@ static inline void sk_tx_queue_clear(struct sock *=
sk)
>  	WRITE_ONCE(sk->sk_tx_queue_mapping, NO_QUEUE_MAPPING);
>  }
> =20
> +#define SK_WMEM_ALLOC_BIAS 1
> +
> +/* A SOCK_STICKY_TXQ socket keeps its TX queue while it has packets in
> + * flight: a stateful TX offload must not see the flow on a new queue
> + * while its work may still be pending on the previous one.
> + */
> +static inline bool sk_tx_queue_pinned(const struct sock *sk)
> +{
> +	return sock_flag(sk, SOCK_STICKY_TXQ) &&
> +	       refcount_read(&sk->sk_wmem_alloc) - SK_WMEM_ALLOC_BIAS >=3D
> +	       SKB_TRUESIZE(1);
> +}
> +
> +/* Like sk_tx_queue_clear(), but keeps a pinned mapping, see
> + * sk_tx_queue_pinned(). Lifecycle resets (allocation, cloning) must use
> + * sk_tx_queue_clear() directly.
> + */
> +static inline void sk_tx_queue_maybe_clear(struct sock *sk)
> +{
> +	if (!sk_tx_queue_pinned(sk))
> +		sk_tx_queue_clear(sk);
> +}
> +
>  int sk_tx_queue_get(const struct sock *sk);
> =20
>  static inline void __sk_rx_queue_set(struct sock *sk,
> @@ -2237,7 +2265,7 @@ __sk_dst_set(struct sock *sk, struct dst_entry *dst)
>  {
>  	struct dst_entry *old_dst;
> =20
> -	sk_tx_queue_clear(sk);
> +	sk_tx_queue_maybe_clear(sk);
>  	WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
>  	old_dst =3D rcu_dereference_protected(sk->sk_dst_cache,
>  					    lockdep_sock_is_held(sk));
> @@ -2250,7 +2278,7 @@ sk_dst_set(struct sock *sk, struct dst_entry *dst)
>  {
>  	struct dst_entry *old_dst;
> =20
> -	sk_tx_queue_clear(sk);
> +	sk_tx_queue_maybe_clear(sk);
>  	WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
>  	old_dst =3D unrcu_pointer(xchg(&sk->sk_dst_cache, RCU_INITIALIZER(dst))=
);
>  	dst_release(old_dst);

[Severity: Medium]
Can netdev_pick_tx() transmit a packet on a newly selected TX queue without
updating sk->sk_tx_queue_mapping when sk->sk_dst_cache is NULL?

net/core/dev.c:netdev_pick_tx() {
	...
	if (queue_index < 0 || skb->ooo_okay ||
	    queue_index >=3D dev->real_num_tx_queues) {
		int new_index =3D get_xps_queue(dev, sb_dev, skb);

		if (new_index < 0)
			new_index =3D skb_tx_hash(dev, sb_dev, skb);

		if (sk && sk_fullsock(sk) &&
		    rcu_access_pointer(sk->sk_dst_cache))
			sk_tx_queue_set(sk, new_index);

		queue_index =3D new_index;
	}
	...
}

In __tcp_transmit_skb(), when a SOCK_STICKY_TXQ socket with no packets in
flight sends an skb, it sets skb->ooo_okay =3D 1 and charges skb->truesize =
to
sk->sk_wmem_alloc before calling queue_xmit, which makes
sk_tx_queue_pinned(sk) true.  If sk->sk_dst_cache is cleared before that skb
reaches netdev_pick_tx() (for example by a concurrent sk_dst_reset() on a
redirect/PMTU update, or by an egress cgroup BPF program updating SO_MARK),
sk_tx_queue_maybe_clear() leaves the previous sk->sk_tx_queue_mapping intact
while setting sk->sk_dst_cache to NULL.

When that skb enters netdev_pick_tx(), skb->ooo_okay picks a new queue
new_index, but sk_tx_queue_set() is skipped because sk->sk_dst_cache is NUL=
L.
A subsequent packet sent while the first is still in flight has
skb->ooo_okay =3D 0, repopulates sk->sk_dst_cache without clearing the old
sk->sk_tx_queue_mapping (since sk_tx_queue_pinned(sk) is true), and is sent
on the old queue while the first packet is still in flight on new_index,
corrupting per-connection device TLS state.

Allowing netdev_pick_tx() to also call sk_tx_queue_set() when
sock_flag(sk, SOCK_STICKY_TXQ) is set would keep sk->sk_tx_queue_mapping in
sync with the queue actually used.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D5
