Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693494;
	b=hXxes1tVNed+fqfW2Xo15PqiY94SiKABjQHEDiVNKHYEpo5BMW2M1sMqFA1jIvA7c+7h
	 dLA0fM8Uj7td8O+ffjR7sr1o3NAky7FEE7m1TsKilnaJb4MUIqvg49WV1UlPQPA+QqOXD
	 n4VRFiVae0jx7DY+cGWvW2uOOOgjk/cPL+WDebP+FP7W+g7NExIw1SCBv8/nnSR13WsC5
	 4V1x8TIERow/GDA9dKl88d3XFTtAitnimLj5QvsY+XaFDlzdgPgdFBVlXGL+LCQO4NAC0
	 DBtO39LKpa1N4veY3d+1nUqNKhHsuxl/bWkQHZW/TvQb3RaXG/X6O6XRZ+uAH62yoLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693494;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=SjU+fBjE/Bx1UV6uUeXe3VlknCtkPf0nIYkQ7/EN+vs=;
	b=ZWFwDu8yHLAkir+L+dO8uH1lHhXZUnjJndE1KAvhcxneHosGrnJGtjjWgU2uVgvIl20b
	 NWi1/j5UaEvoT19PZxPkyK5u7nTB6XfQFoce35lu1Y7fUk26pxI3XbgkzmgCDKMkchZJe
	 U5iSta5U6rnOQ05sUhxHthXQZXDjRdKECRvZX6clsZ7g3+E+re2We/l+eZUrgy+iFMdev
	 71RHvcK5/Vw0famUFMoiG6BDyDF3EJI4b0yQ4g+BPETsrgQ5Yl/uyYkCcO4euw0qcwcyp
	 T0qQ52sAcyMXcNriWphd537CnwFfSpPJimh7W3KUWGirMuXWrfo+ZXOph50b+P7rYHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieEQeeW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBBE606A334;
	Tue,  3 Nov 2026 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieEQeeW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C62A1F00919;
	Tue,  3 Nov 2026 08:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693494;
	bh=SjU+fBjE/Bx1UV6uUeXe3VlknCtkPf0nIYkQ7/EN+vs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ieEQeeW9X+QhR28OPfuu2z9CmJZGtqS2ZLUlnlftMIbFiNURnlYuNZSQvvz9sJFNP
	 nMwLssRZIvgjdz8pGyrDIh9lP08/SpZ4UH2qG8yOfPONHR5HD8km+UcyI2aOK6zQsL
	 JJvbzSQdncTh56ZbSt9xdeOKHTHCk4cekG1ucfecln5LZ7npUDGQYE70Tt575vbWJe
	 Ucwo0E7fuBmsUHJFklPPX26rsHqV5fZkC4rvANtkRI98mzZJnLcixanuQm5HP7kxQK
	 UVzALLUHxWoPQ90/zQFYDOf412lKg7A1XRHKnl9/99HQDgJEGnFDwHrOHyha9bMslE
	 NtrNMtR+8h1/g==
Subject: Re: [PATCH v1] net/mlx5e: IPoIB: Fix race in QPN to netdev mapping
From: netdev-bot+sashiko@kernel.org
To: 18983559317@163.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 08:11:33 +0000
Message-ID: <179369349314.488856.4430473764213926216@kernel.org>
In-Reply-To: <20261102074107.32859-1-18983559317@163.com>
References: <20261102074107.32859-1-18983559317@163.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The use-after-free fix in mlx5i_pkey_get_netdev()
  (drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c) is…
- [High] The patch adds a spinlock leak and deadlock to
  mlx5i_pkey_get_netdev()…
- [Medium] The patch takes one spinlock, shared by the whole parent, for
  every RX completion in the NAPI fast path.

--

net/mlx5e: IPoIB: Fix race in QPN to netdev mapping

This commit takes ht_lock around the QPN-to-netdev hash lookups in
mlx5i_pkey_get_netdev() and mlx5i_pkey_del_qpn(). It also puts the
deletion lookup and the unlink in a single critical section. The aim is
to stop the NAPI RX path from reading a qpn_to_netdev node that a child
PKEY interface teardown has already freed.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> index 4120afd097c36..8aea23e0183b7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c

[ ... ]

> @@ -128,9 +129,11 @@ struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn)
>  	struct mlx5i_priv *ipriv = netdev_priv(netdev);
>  	struct qpn_to_netdev *node;
>  
> +	spin_lock_bh(&ipriv->qpn_htbl->ht_lock);

[Severity: Medium]
mlx5i_complete_rx_cqe() calls mlx5i_pkey_get_netdev() once per CQE on
every RX channel. Child interfaces share the parent's table:

mlx5i_pkey_dev_init() {
    ...
	ipriv->qpn_htbl = parent_ipriv->qpn_htbl;
    ...
}

With this change, every received packet on every RX queue of the
parent and its PKEY children takes the same ht_lock. Is a shared
per-packet spinlock what was intended here?

The table is only written when a child is created or destroyed. Would
RCU fit better? That would mean hlist_for_each_entry_rcu() in
mlx5i_find_qpn_to_netdev_node(), hlist_add_head_rcu() and
hlist_del_rcu() under ht_lock in the writers, and kfree_rcu() in place
of kfree(node) in mlx5i_pkey_del_qpn().

NAPI already runs with BH disabled, which counts as an RCU read-side
section. So the spin_lock_bh() in the softirq reader would not be needed
either.

The commit message does not mention this tradeoff.

>  	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
>  	if (!node)
>  		return NULL;

[Severity: High]
Does this early return leave ht_lock held and BH disabled?

The only caller, mlx5i_complete_rx_cqe(), expects lookup misses:

	netdev = mlx5i_pkey_get_netdev(rq->netdev, qpn);

	/* No mapping present, cannot process SKB. This might happen if a child
	 * interface is going down while having unprocessed CQEs on parent RQ
	 */
	if (unlikely(!netdev)) {

That is the same teardown case this patch is meant to fix. After one
miss, the next CQE on that CPU calls spin_lock_bh() on the same lock and
spins forever.

Other RX channels, mlx5i_pkey_add_qpn() and mlx5i_pkey_del_qpn() would
also block on the shared ht_lock. Before this patch, the same situation
only dropped the skb.

> +	spin_unlock_bh(&ipriv->qpn_htbl->ht_lock);
>  
>  	return node->netdev;
>  }

[Severity: High]
Can node be freed after spin_unlock_bh() but before node->netdev is
read?

The commit message says:

    The NAPI path copies the netdev pointer while
    the lock prevents the mapping node from being freed.

However, the pointer is read after the lock has been dropped. A child
teardown on another CPU can run in that window:

CPU0                                    CPU1
mlx5i_pkey_get_netdev()
  spin_lock_bh(ht_lock)
  node = mlx5i_find_qpn_to_netdev_node()
  spin_unlock_bh(ht_lock)
                                        mlx5i_dev_cleanup()
                                          mlx5i_pkey_del_qpn()
                                            spin_lock_bh(&ht->ht_lock)
                                            hlist_del_init(&node->hlist)
                                            spin_unlock_bh(&ht->ht_lock)
                                            kfree(node)
  return node->netdev;

The free is not deferred, so the race from the commit message is still
there with a smaller window. mlx5i_complete_rx_cqe() would then use the
stale netdev through mlx5i_epriv(netdev) and
priv->channel_stats[rq->ix].

Would it work to copy the pointer before unlocking? For example:

	ndev = node ? node->netdev : NULL;
	spin_unlock_bh(&ipriv->qpn_htbl->ht_lock);
	return ndev;

That would also fix the early return above. Another option is to convert
the table to RCU and use kfree_rcu().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261102074107.32859-1-18983559317%40163.com
