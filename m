Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311417;
	b=mCz2M9Uqker2ayJjyuTKiYNMtTQ7EhaDmhP8IQpg1VULtanTXZrF74QdA7htUj+v11e9
	 KuV5Ml2t5yMQ60mtdhq2uACV+MkSqQHhAKEy4ZfJn0IDstLx2WOHIt1uRhbrQeQitBHlS
	 jSlMJt/TWdZfVI3sbvNDsIbp694GRA4qO2gONHnmw1gkTviXvJkrbDxV7YRui873qEHDM
	 1Fa/m+Cf+Ul65FTAaLm4i2XzQ9zilnj847A9jX/a6wAB+cYntqGOjjqHU86L8R2MwzjkA
	 m3suIuE/DM/L4xy2zgfZOQVs43LvXxU8fJCvNbRJ1hMQbNo0TDB24YvS0UwMQxMYBvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311417;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IfrSLotOt58tBC3+5aaI9CMFBSWUzTI8SJLwriC5mPs=;
	b=ca3raAzpCoPJ62gxXvHHJ0x+Z/Jvbd6aZOXgFX3mykK9hDfFNimNLMVR+Kqhm+WsF7an
	 WeHeqGwVC3jQj9ZqY7sQFdNVxGfQGe3zSdbUE6qv1n8CU944hUSVwJd2EQd6D+YmGxa1U
	 BFGq86RTaxieXCpcmluiyF+yU6kPvJ6ijdfF/3qOwtxATeykJtR/JKNRdVIriAhVtxLwY
	 fh2mbtgkaKP9bT9wckMrVOGYywulLKEi5pIkgEklW1nWwj0tVbAQorVuuJ/mceOxCdSul
	 4ZsK+bzNLccbyDCcsC68s0kKdhAe8+sQrS7/4dsvQvuAXrVteT3OPNlxjThGYZquFgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oDFBZdnB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D07C606B5B8
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oDFBZdnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F2D1F0089F;
	Tue, 10 Nov 2026 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311416;
	bh=IfrSLotOt58tBC3+5aaI9CMFBSWUzTI8SJLwriC5mPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oDFBZdnBYOJevKYjuQsXSV9EOVgDN6kdvvA0qYkuJPvGrS33K8QlY2x5eCSeXIYHn
	 5BA8/AkxP59tNCKqaXFKYRqrGj30UZqc/zrfZmRaZ3VFr0vlADNzyFw1QYQnZRVQpP
	 veJyXg+gUXGWiT+Kmmf5XUf16T/eVC9BL7QhKHRDImexe4G2B7Ngx6S/vKr1CydgKM
	 ge8as4xAvbWaSWSGEOctTv0meGu6ViXuU5+i2GvEPW8jloGe/qCmt8TU2OQXg8sBKJ
	 an0pUsDauO+fVjCJV4pxsni6fedsK64K0FpfPE86PX7G04zL+uP2vqME94YGO7c9tL
	 wRhfgVm+Z3ytg==
Message-ID: <sashiko-outbox-206959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 7/7] net/mlx5e: kTLS, Keep a TX connection on one
 SQ at a time
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-8-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] net/mlx5e: unlocked txq_ix update in mlx5e_ktls_tx_select_txq()
- [Medium] net/mlx5e: self-trylock failure in mlx5e_ktls_tx_own_txq() on
  txq_ix re-read
- [Medium] net/mlx5e: missed mlx5e_ktls_tx_select_txq() when sticky
  queue is invalid
- [Medium] net/mlx5e: mlx5e_ktls_tx_own_txq() drops software-segmented
  GSO packets
- [Medium] net/mlx5e: kTLS in-flight wmem checks ignore tcp_tsq_workfn()
  +1 reference
--

commit d7dc36218f27e50a58cf06b01d4aeb04325f18d6
Author: Tariq Toukan <tariqt@nvidia.com>

net/mlx5e: kTLS, Keep a TX connection on one SQ at a time

This commit tracks the TX queue index on each kTLS TX offload context and
restricts moving the connection to another TX queue while packets of the
socket are still in flight, dropping packets that would otherwise post WQEs
concurrently to multiple SQs.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/selq.c
> index dfaee2c3624e0..0bac217bbfec8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
[ ... ]
> @@ -323,14 +322,19 @@ u16 mlx5e_select_queue(struct net_device *dev, stru=
ct sk_buff *skb,
>  	if (likely(!mlx5e_sk_sticky_txq(sk)))
>  		return __mlx5e_select_queue(dev, skb, selq);
> =20
> -	txq_ix =3D mlx5e_select_sticky_queue(dev, skb, selq);
> -	if (txq_ix >=3D 0)
> -		return txq_ix;
> +	may_move =3D mlx5e_sk_txq_may_move(skb);
> +	if (!may_move) {
> +		txq_ix =3D mlx5e_select_sticky_queue(dev, skb, selq);
> +		if (txq_ix >=3D 0)
> +			return txq_ix;
> +	}
> =20
>  	txq_ix =3D __mlx5e_select_queue(dev, skb, selq);
>  	/* Cache the final queue, as netdev_pick_tx() does with its own pick. */
>  	if (rcu_access_pointer(sk->sk_dst_cache))
>  		sk_tx_queue_set(sk, txq_ix);
> +	if (may_move)
> +		mlx5e_ktls_tx_select_txq(dev, skb, txq_ix);
> =20
>  	return txq_ix;
>  }

[Severity: Medium]
Does skipping mlx5e_ktls_tx_select_txq() when !may_move cause multi-packet
bursts to be dropped after mlx5e_select_sticky_queue() rejects a stale queu=
e?

When skb->ooo_okay is 0 (for example, because an earlier skb was still
completing when __tcp_transmit_skb() built this skb), may_move is false.  If
mlx5e_select_sticky_queue() returns -1 because the cached queue index is out
of range after reducing the channel count with ethtool -L,
mlx5e_select_queue() picks a new txq_ix and caches it via sk_tx_queue_set(),
but leaves priv_tx->txq_ix pointing at the old queue even if all prior skbs
have now completed (sk_wmem_alloc_get(sk) <=3D own).

Subsequent skbs in the same burst then take the newly cached queue in
mlx5e_select_sticky_queue() and queue up behind the first skb, raising
sk_wmem_alloc above skb->truesize.  When the first skb reaches
mlx5e_ktls_handle_tx_skb(), mlx5e_ktls_tx_own_txq() sees
sk_wmem_alloc_get(skb->sk) > skb->truesize and drops every skb in the burst
except the last one, triggering TCP retransmissions and a hardware kTLS OOO
resync.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b=
/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> index 0bd4d961e7044..9603ef4b3eb3f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
[ ... ]
> @@ -846,6 +850,59 @@ void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *s=
q, struct sk_buff *skb)
>  	rcu_read_unlock();
>  }
> =20
> +/* A connection must not post WQEs to another SQ while WQEs that it post=
ed to
> + * its SQ may be pending, see TLSDEV_F_STICKY_TXQ. Let it move to the TX=
 queue
> + * of @sq only if no other skb of its socket is in flight: an skb is fre=
ed only
> + * once the WQEs posted for it are done. The move is made under the lock=
 of the
> + * old TX queue, under which the connection posts there.
> + */
> +static bool mlx5e_ktls_tx_own_txq(struct net_device *netdev,
> +				  struct mlx5e_ktls_offload_context_tx *priv_tx,
> +				  struct mlx5e_txqsq *sq, struct sk_buff *skb)
> +{
> +	int old =3D READ_ONCE(priv_tx->txq_ix);
> +	struct netdev_queue *old_txq;
> +	bool own;
> +
> +	if (old =3D=3D MLX5E_KTLS_TX_NO_TXQ)
> +		return cmpxchg(&priv_tx->txq_ix, old, sq->txq_ix) =3D=3D old;
> +
> +	old_txq =3D netdev_get_tx_queue(netdev, old);
> +	if (!__netif_tx_trylock(old_txq))
> +		return false;

[Severity: Medium]
Can re-reading priv_tx->txq_ix into old without checking old =3D=3D sq->txq=
_ix
cause mlx5e_ktls_tx_own_txq() to trylock the current TX queue and drop the
packet?

mlx5e_ktls_handle_tx_skb() runs under HARD_TX_LOCK for sq->txq and calls
mlx5e_ktls_tx_own_txq() after observing READ_ONCE(priv_tx->txq_ix) !=3D
sq->txq_ix.  If another CPU updates priv_tx->txq_ix to sq->txq_ix (for
example via mlx5e_ktls_tx_select_txq()) before the second READ_ONCE() here,
old equals sq->txq_ix.  __netif_tx_trylock(old_txq) then tries to acquire
sq->txq->_xmit_lock, which is already held by this CPU, so it fails and dro=
ps
the skb with a false warning.

> +
> +	own =3D READ_ONCE(priv_tx->txq_ix) =3D=3D old &&
> +	      sk_wmem_alloc_get(skb->sk) <=3D skb->truesize;

[Severity: Medium]
Does checking sk_wmem_alloc_get(skb->sk) <=3D skb->truesize drop the first =
N-1
segments when a GSO skb is software-segmented before mlx5e_xmit()?

When validate_xmit_skb() segments a GSO skb in software via
__skb_gso_segment() -> tcp_gso_segment(), all N resulting segments are
charged to sk->sk_wmem_alloc with destructor tcp_wfree before
dev_hard_start_xmit() loops over the segment list.  If the connection moves
to a new TX queue at xmit time (such as via tc skbedit queue_mapping),
sk_wmem_alloc_get(skb->sk) holds the sum of truesizes of all remaining
segments, so mlx5e_ktls_tx_own_txq() rejects and frees segments 1 through N=
-1
one by one until only segment N remains, transmitting segment N out of order
and forcing a kTLS resync.

> +	if (own)
> +		WRITE_ONCE(priv_tx->txq_ix, sq->txq_ix);
> +	__netif_tx_unlock(old_txq);
> +
> +	return own;
> +}

[Severity: Medium]
Do the sk_wmem_alloc_get(skb->sk) checks in mlx5e_ktls_tx_own_txq() and
mlx5e_sk_txq_may_move() fail for packets sent from the TCP Small Queues
tasklet?

When tcp_wfree() schedules the TSQ worker, it leaves a +1 reference in
sk->sk_wmem_alloc for sk_free() to release after tcp_tsq_handler() returns:

net/ipv4/tcp_output.c:tcp_tsq_workfn() {
    ...
			tcp_tsq_handler(sk);
		}
		bh_unlock_sock(sk);

		if (need_free)
			sk_free(sk);
    ...
}

Inside tcp_tsq_handler(), __tcp_transmit_skb() charges skb->truesize while
that +1 reference is still present, so sk_wmem_alloc_get(skb->sk) is
skb->truesize + 1 even when no other skb is in flight (which is why
__tcp_transmit_skb() and sk_tx_queue_pinned() test against SKB_TRUESIZE(1)
rather than 0).  As a result, both sk_wmem_alloc_get(skb->sk) <=3D own in
mlx5e_sk_txq_may_move() and sk_wmem_alloc_get(skb->sk) <=3D skb->truesize in
mlx5e_ktls_tx_own_txq() evaluate to false during TSQ transmissions, blocking
queue moves at selection time and dropping packets moved to another TX queu=
e.

> +
> +/* The TX queue selection lets the socket of @skb move to @txq_ix only w=
hile
> + * no other skb of the socket is in flight, see mlx5e_select_queue(), so=
 the
> + * connection has no WQE pending on any SQ: hand it the new TX queue now=
. Once
> + * @skb is queued there, the socket's next skbs queue up behind it and h=
old
> + * sk_wmem_alloc, and mlx5e_ktls_tx_own_txq() would refuse the move.
> + */
> +void mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff =
*skb,
> +			      u16 txq_ix)
> +{
> +	struct mlx5e_ktls_offload_context_tx *priv_tx;
> +	struct tls_context *tls_ctx;
> +
> +	if (!tls_is_skb_tx_device_offloaded(skb))
> +		return;
> +
> +	tls_ctx =3D tls_get_ctx(skb->sk);
> +	if (rcu_dereference_bh(tls_ctx->netdev) !=3D netdev)
> +		return;
> +
> +	priv_tx =3D mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
> +	WRITE_ONCE(priv_tx->txq_ix, txq_ix);
> +}

[Severity: High]
Can this unlocked WRITE_ONCE(priv_tx->txq_ix, txq_ix) race with a packet
transmitting on the old TX queue and allow both SQs to post WQEs for the sa=
me
kTLS connection concurrently?

In mlx5e_select_queue(), may_move =3D mlx5e_sk_txq_may_move(skb) is checked
before __mlx5e_select_queue() and sk_tx_queue_set() without holding any TX
queue lock, and mlx5e_ktls_tx_select_txq() then unconditionally overwrites
priv_tx->txq_ix without locking old_txq or re-checking sk_wmem_alloc_get():

CPU0                                    CPU1
mlx5e_select_queue(skb1)
  may_move =3D mlx5e_sk_txq_may_move(skb1)
    /* true: wmem <=3D truesize */
                                        mlx5e_select_queue(skb2)
                                          /* !may_move: picks sticky old_q =
*/
                                        mlx5e_xmit(skb2) [on old_sq]
                                          HARD_TX_LOCK(old_txq)
                                          mlx5e_ktls_handle_tx_skb(skb2)
                                            priv_tx->txq_ix =3D=3D old_sq->=
txq_ix
                                            /* starts posting WQEs on old_s=
q */
  txq_ix =3D __mlx5e_select_queue(...)
  sk_tx_queue_set(sk, new_q)
  mlx5e_ktls_tx_select_txq(skb1, new_q)
    WRITE_ONCE(priv_tx->txq_ix, new_q)
mlx5e_xmit(skb1) [on new_sq]
  HARD_TX_LOCK(new_txq)
  mlx5e_ktls_handle_tx_skb(skb1)
    priv_tx->txq_ix =3D=3D new_sq->txq_ix
    /* skips mlx5e_ktls_tx_own_txq(),
     * posts WQEs on new_sq concurrently! */

This can happen when skb1 is delayed in an upper device's qdisc (such as a
bonding or VLAN device where the socket lock is no longer held), or when sk=
b1
is a non-decrypted packet (e.g. a pure ACK or pre-offload packet) whose
sk_wmem_alloc was released by skb_orphan_partial() in an upper qdisc, making
mlx5e_sk_txq_may_move() see own =3D=3D 0 and sk_wmem_alloc =3D=3D 0 before =
CPU1 sends
encrypted data on old_sq.  Both SQs then update the connection's TIS state
and priv_tx fields (expected_seq, ctx_post_pending, rec_seq) without
serialization, corrupting TLS records on the wire.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D7
