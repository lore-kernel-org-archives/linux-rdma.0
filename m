Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311416;
	b=N8yJ4lrByTO4w7ndSioHTcWXc1ELeTSFLN799aRArYPuZRtUfW4XwyuBp1gCwcoRIknr
	 KzBh5Z5GskIB5dah9VG8wIzCQ6DhptvjKduYJHE1sd27JxZao7eovnA9lqpFPaHHsF5Ds
	 oYhDuq/tZqYIf2GUroTZxA2OG050ajUBEGY/G1Nzi08xrtM9/5JJupQXcnm9Do+45MzmL
	 tgKQSsZy7BZWc8Qblw+OkwVaVNxxbS47bNCKp4CuVBiGq6bfhPX8/kiQEn5F3sFFAMb07
	 3VjhqkV/04xdEVvHbR1qJU6Qi8+ndaS79dOSv/50U3taYcG8TsVKJHtaBby3wDD2sjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311416;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WQM5zLXbMDFqfV6oNv8XVBMZCaOuOCkJitvbGi7T1JU=;
	b=PVsWh5iJ9KvsGAwmumgwlg2YLBYiluRQNfh4ytSVo0Uyd7pdK5TfasbeUcC6Q2nJwHBJ
	 xxGtt1em0SmvqfwmYIX1WsbO/R1V4d0AG9QncxoEvjwJfDSBMe82RNJQhmRxhpQxnYxDJ
	 BUtLEUTSB+2p3ax2RauMd23m3s48ZAvbeTjH6n2Z1HZdiWkpaBD0Y2b9KQlieTEFT69t9
	 hbKeulRYodzP2NO/vfHbyWmiMvybDTaqHFgjHky66toO//li8rfBd2r+xnAJbyWz89Lwn
	 azfqeZg4mP593kQNgNCQyZeKHqHCcT53iXYs2XEiWLBdD2cNXjKmjIVlvBxDCq/wgFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yghszpju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CAD606B5B8
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yghszpju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EAF1F0089F;
	Tue, 10 Nov 2026 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311415;
	bh=WQM5zLXbMDFqfV6oNv8XVBMZCaOuOCkJitvbGi7T1JU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YghszpjulIizzEh2lEqR/rr1YMH+8K6A7WWMmkv5bsvSu9a2fnNsrUuTRN4MXsqd+
	 A5ndgnauB++jDeuQFYRUBBHRjHIZbuxapMpwG8sfJkkee4MEHWAFRS78Dq7aiXBZvc
	 yq/zJ7j+qiPgZMrJvmF72kW1nIr+Mgj7qBqnxaukSm6loy0bgzQvTvvFW3esfIbqjg
	 q3NfcI2j/V6N+gOvt3fYhbswiLlQC2Yqq7jG8lrsorRX4AJcqZV85raHMT99RjRV/A
	 JjsRa7rrgFaMi51SUV7OzrbL5QBa5ut+1bRWqhOBR9EDWT51DHS939NHOluxUdOnsQ
	 QGZWQJ32CHmUw==
Message-ID: <sashiko-outbox-206958@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 6/7] net/mlx5e: kTLS, Keep the TX queue of an
 offloaded socket stable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-7-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] net/mlx5e: missing sk_tx_queue_set() in mlx5e_select_queue()
  without dst
- [Medium] net/mlx5e: un-normalized queue cached in sk_tx_queue_mapping
  in selq
- [Medium] net/mlx5e: mlx5e_select_sticky_queue() reuses reassigned HTB
  txq_ix
- [Medium] net/mlx5e: mlx5e_sk_txq_may_move() fails on TSQ and pure ACK
  wmem charges
--

commit a5df807906b676e83f48b3d983daeac0ca981f49
Author: Tariq Toukan <tariqt@nvidia.com>

net/mlx5e: kTLS, Keep the TX queue of an offloaded socket stable

This commit opts in to TLSDEV_F_STICKY_TXQ and caches the final selected TX
queue in sk->sk_tx_queue_mapping for SOCK_STICKY_TXQ sockets so that priori=
ty
or HTB changes do not move an offloaded kTLS connection to another SQ while
packets are in flight.

Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@pur=
estorage.com/

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/selq.c
> index 8318a26bc263b..dfaee2c3624e0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c

[ ... ]

> @@ -266,3 +257,80 @@ u16 mlx5e_select_queue(struct net_device *dev, struc=
t sk_buff *skb,
> =20
>  	return txq_ix + up * selq->num_channels;
>  }
> +
> +static bool mlx5e_sk_sticky_txq(const struct sock *sk)
> +{
> +	return IS_ENABLED(CONFIG_MLX5_EN_TLS) && sk && sk_fullsock(sk) &&
> +	       sock_flag(sk, SOCK_STICKY_TXQ);
> +}
> +
> +/* TCP sets skb->ooo_okay when it transmits the skb, and it may be stale=
 by
> + * now, e.g. after an upper device's qdisc reordered the socket's skbs.
> + * Allow a move only if no other skb of the socket is in flight: a
> + * decrypted skb holds its own sk_wmem_alloc charge, any other skb may n=
ot.
> + */
> +static bool mlx5e_sk_txq_may_move(const struct sk_buff *skb)
> +{
> +	int own =3D skb_is_decrypted(skb) ? skb->truesize : 0;
> +
> +	return skb->ooo_okay && sk_wmem_alloc_get(skb->sk) <=3D own;
> +}

[Severity: Medium]
Should mlx5e_sk_txq_may_move() check sk_wmem_alloc_get(skb->sk) < own +
SKB_TRUESIZE(1) to match __tcp_transmit_skb() and sk_tx_queue_pinned()?

When TCP transmits from tcp_tsq_workfn(), tcp_wfree() retains a +1
reference in sk->sk_wmem_alloc until sk_free(sk) runs after
tcp_tsq_handler(sk), and in-flight pure ACKs charge truesize =3D=3D 2 via
skb_set_tcp_pure_ack() without carrying TLS data.  __tcp_transmit_skb()
therefore sets skb->ooo_okay =3D 1 when sk_wmem_alloc_get(sk) <
SKB_TRUESIZE(1), raising sk_wmem_alloc_get(sk) to at least own + 1 after
charging skb->truesize.  Because sk_wmem_alloc_get(skb->sk) <=3D own is then
false, a socket transmitting via TSQ or with a pure ACK in flight cannot
move to its updated UP/DSCP or HTB queue even when no data packet is in
flight (and in the follow-up commit "net/mlx5e: kTLS, Keep a TX connection
on one SQ at a time", mlx5e_ktls_tx_own_txq() drops the skb if queue
selection falls back to __mlx5e_select_queue() during tcp_tsq_workfn()).

> +
> +/* A SOCK_STICKY_TXQ socket must not move to another TX queue while it h=
as
> + * packets in flight, see TLSDEV_F_STICKY_TXQ. netdev_pick_tx() keeps the
> + * socket's queue, but the UP offset and the HTB queue are derived from =
each
> + * skb. Reuse the final queue of the socket's previous skb, unless TCP a=
llows
> + * a move.
> + */
> +static int mlx5e_select_sticky_queue(struct net_device *dev,
> +				     struct sk_buff *skb,
> +				     struct mlx5e_selq_params *selq)
> +{
> +	int txq_ix;
> +
> +	if (mlx5e_sk_txq_may_move(skb))
> +		return -1;
> +
> +	txq_ix =3D sk_tx_queue_get(skb->sk);
> +	if (txq_ix < 0 || txq_ix >=3D dev->real_num_tx_queues)
> +		return -1;
> +
> +	/* The PTP queues are selected for PTP event packets only. */
> +	if (selq->is_ptp && txq_ix >=3D selq->num_regular_queues &&
> +	    txq_ix < selq->num_regular_queues + selq->num_tcs)
> +		return -1;
> +
> +	return txq_ix;
> +}

[Severity: Medium]
Can mlx5e_select_sticky_queue() reuse an HTB queue index after that queue
was reassigned to another HTB class?

When an HTB leaf is deleted or converted into an inner class in
mlx5e_htb_leaf_to_inner(), mlx5e_htb_leaf_del(), or
mlx5e_htb_leaf_del_last(), its QoS qid is reused for another class while
txq_ix stays below dev->real_num_tx_queues and sk->sk_tx_queue_mapping is
not cleared.  If the first packet sent after the change is a non-decrypted
TCP packet such as a pure ACK, __tcp_transmit_skb() charges skb->truesize
to sk->sk_wmem_alloc while own is 0, so mlx5e_sk_txq_may_move() returns
false, mlx5e_select_sticky_queue() returns the reassigned txq_ix, and
subsequent TLS records sent while that ACK is in flight see ooo_okay =3D=3D=
 0
and stay pinned to the wrong HTB class.

In addition, htb_delete() and htb_change_class() invoke the driver offload
callback before qdisc_purge_queue() runs (while mlx5e_htb_leaf_to_inner()
does not call mlx5e_reset_qdisc(), and mlx5e_htb_leaf_del() passes the
0-based moved_qid instead of mlx5e_qid_from_qos() to mlx5e_reset_qdisc()),
and skbs that already passed __tcp_transmit_skb() with ooo_okay =3D=3D 0 and
are queued in an upper device's qdisc also keep sk->sk_wmem_alloc elevated
and reuse the reassigned txq_ix when they reach mlx5e_select_sticky_queue().

> +
> +u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
> +		       struct net_device *sb_dev)
> +{
> +	struct mlx5e_priv *priv =3D netdev_priv(dev);
> +	struct mlx5e_selq_params *selq;
> +	struct sock *sk =3D skb->sk;
> +	int txq_ix;
> +
> +	selq =3D rcu_dereference_bh(priv->selq.active);
> +
> +	/* This is a workaround needed only for the mlx5e_netdev_change_profile
> +	 * flow that zeroes out the whole priv without unregistering the netdev
> +	 * and without preventing ndo_select_queue from being called.
> +	 */
> +	if (unlikely(!selq))
> +		return 0;
> +
> +	if (likely(!mlx5e_sk_sticky_txq(sk)))
> +		return __mlx5e_select_queue(dev, skb, selq);

[Severity: Medium]
Does calling netdev_pick_tx() inside __mlx5e_select_queue() leave an
unadjusted queue index in sk->sk_tx_queue_mapping when SOCK_STICKY_TXQ is
later enabled?

Before setsockopt(SOL_TLS, TLS_TX) sets SOCK_STICKY_TXQ in
tls_set_device_offload(), mlx5e_sk_sticky_txq(sk) is false and
__mlx5e_select_queue() is called without updating sk->sk_tx_queue_mapping
afterwards.  Inside __mlx5e_select_queue(), netdev_pick_tx() caches its
raw queue index in sk->sk_tx_queue_mapping (for example, a TC 0 queue in
[0, num_channels) when DSCP trust or VLAN priority maps the packet to a
higher UP, or an un-normalized HTB queue index before
mlx5e_txq_to_ch_ix_htb()) while __mlx5e_select_queue() returns the UP- or
HTB-adjusted queue.  If a pre-offload packet such as the TLS handshake
Finished message is still in flight when the first offloaded record is
sent (so ooo_okay =3D=3D 0), mlx5e_select_sticky_queue() returns that raw
cached queue from sk->sk_tx_queue_mapping, moving the flow across TX
queues while packets are in flight and pinning it to the wrong TC or
queue.  Even after SOCK_STICKY_TXQ is set, netdev_pick_tx() transiently
writes the unadjusted queue into sk->sk_tx_queue_mapping before
mlx5e_select_queue() overwrites it with txq_ix.

> +
> +	txq_ix =3D mlx5e_select_sticky_queue(dev, skb, selq);
> +	if (txq_ix >=3D 0)
> +		return txq_ix;
> +
> +	txq_ix =3D __mlx5e_select_queue(dev, skb, selq);
> +	/* Cache the final queue, as netdev_pick_tx() does with its own pick. */
> +	if (rcu_access_pointer(sk->sk_dst_cache))
> +		sk_tx_queue_set(sk, txq_ix);

[Severity: Medium]
Can gating sk_tx_queue_set(sk, txq_ix) on sk->sk_dst_cache leave a stale
queue in sk->sk_tx_queue_mapping after a queue move?

If skb1 is transmitted with ooo_okay =3D=3D 1 and no other packets in fligh=
t,
__tcp_transmit_skb() charges skb1->truesize to sk->sk_wmem_alloc before
skb1 is routed and queued in an upper device's qdisc or neigh->arp_queue.
If sk_dst_reset() or __sk_dst_check() runs before skb1 reaches
mlx5e_select_queue(), sk_tx_queue_maybe_clear() sees
sk_tx_queue_pinned(sk) =3D=3D true and preserves the old queue in
sk->sk_tx_queue_mapping while clearing sk->sk_dst_cache.  When skb1 then
runs __mlx5e_select_queue() and selects a new queue txq_ix,
rcu_access_pointer(sk->sk_dst_cache) is NULL, so sk_tx_queue_set(sk,
txq_ix) is skipped.  Any subsequent packet sent while skb1 is still in
flight then reuses the old queue via mlx5e_select_sticky_queue(), putting
in-flight kTLS WQEs on two SQs at once (or causing
mlx5e_ktls_handle_tx_skb() to warn and drop the packet at the end of the
series).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D6
