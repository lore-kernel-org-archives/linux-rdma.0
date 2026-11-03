Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793666617;
	b=K7KruGYPF3KiuNPBj7ujOaOMWJOdTIc9SLsFGF7P6UAgsfJwqhYCZZx2LiY/s2hBDEKd
	 DdqrgR2YlIWfjUOcp7gDdeG7jdr8JfsYuM1aGQVPeJty59W4tJc5z22tvB8AD3FE6qp7S
	 ZLJOK01IA1esMnZ5b+q3DKMFzCj4/uFAMvJjxhZAGOzdBeQ5llYTAPoNByCOutPKxJ7YU
	 WkEQKfg4jnKMSpnHu/3IUVxb1RZeN+9ePNGI/e95GnaoC0IFhuEifBhNuIocfIhKzQIg/
	 EWx58iIkZJ/dTgqj4J2D7+4So3eAtJA7ClMYou69eXYq0Rg4X4g6mzhhv5Rm3OcXxQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793666617;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=gNtTtJrXDkKo1GQXPVfwRLQdP0jNqQAaumhhVJ72Ess=;
	b=3geHHA8/xF9RYHH2+eU2Dko209Y5+wA8dqiBKaaFYaTAdNFFYNxPJcRjsoKuMH2G2hNF
	 5EUOXwH7U8cxQ6Ou9jV3XupiV+GbKVca+BoxV0TQ7ZuLkLKAygtzY3d0LSRjIIkIxfrCA
	 HAKQ+1/nKsg5MAT5Fd3ih9hTVjAY4QqzRl9Nkj+M8FcBuR5neOnoqhs+aCBsSID5GfH5X
	 OjmjTnWWepOyJLeal/naQUXrI8/fToWeDWlb5hu2Tsew6HmRDXPfD5CCKJi8iDpvAD0mV
	 odFRuea9llSlLUYhbe0mVwUem4IFiiYy2MosA/sML9XmhD3uUCzTdTOf6/xDBhjXPwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kwsd2nmo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A20606A324;
	Tue,  3 Nov 2026 00:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kwsd2nmo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D191F000C1;
	Tue,  3 Nov 2026 00:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793666616;
	bh=gNtTtJrXDkKo1GQXPVfwRLQdP0jNqQAaumhhVJ72Ess=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Kwsd2nmo2bhK0gftF+pHi8REOYzrKWq01fnIdnkx2SRO7xvStK6EmKAwTXI3X7Lx+
	 ZaIfl6PjDdImoZ2VqmA7J56KP3hc9xhK0GkCNrey6ogyXqFDfgNAb9ISrBAfRa6Tqv
	 8tQ7uMVDC+862V67QMyh5wf9TepysLDZXmaH8R9kfPYG/sESfdwPWAZyBAsV+Iqs/m
	 TEDHqL3KexHYgnYhFlOedZicauWYATLzITVOoXteTXIMBSyFOtSHx/949lxtT2BUui
	 cnEWJZrWq/y2/50efY0toTWfjeHkzgvatydKnJ1yQc5kvKvZhOCxj7g1RaaxZPuuf/
	 dSsiIEbUpU8lQ==
Subject: Re: [PATCH net] net/mlx5: IPOIB, Fix QPN lookup race
From: netdev-bot+sashiko@kernel.org
To: prathameshdeshpande7@gmail.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, cratiu@nvidia.com, cjubran@nvidia.com,
 valex@mellanox.com, erezsh@mellanox.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 00:43:35 +0000
Message-ID: <179366661505.488856.13530839414893749142@kernel.org>
In-Reply-To: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
References: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix closes the use-after-free by putting
  spin_lock_bh()/spin_unlock_bh() on one device-wide lock, ht_lock, in…

--

net/mlx5: IPOIB, Fix QPN lookup race

This commit adds ht_lock around the QPN hash table lookup in
mlx5i_pkey_get_netdev(). Without the lock, the RX path can walk a bucket
while mlx5i_pkey_del_qpn() removes and frees a node. With the lock held,
node->netdev is read before the unlock.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> index 4120afd097c36..6c24ae8e76621 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> @@ -126,13 +126,17 @@ int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn)
>  struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn)
>  {
>  	struct mlx5i_priv *ipriv = netdev_priv(netdev);
> +	struct mlx5i_pkey_qpn_ht *ht = ipriv->qpn_htbl;
> +	struct net_device *result = NULL;
>  	struct qpn_to_netdev *node;
>  
> -	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
> -	if (!node)
> -		return NULL;
> +	spin_lock_bh(&ht->ht_lock);
> +	node = mlx5i_find_qpn_to_netdev_node(ht->buckets, qpn);
> +	if (node)
> +		result = node->netdev;
> +	spin_unlock_bh(&ht->ht_lock);

[Severity: High]
Does this add a device-wide spinlock to the RX datapath for every received
IPoIB packet?

mlx5i_pkey_get_netdev() is called once per RX CQE from NAPI:

mlx5i_handle_rx_cqe()
  -> mlx5i_complete_rx_cqe()
       netdev = mlx5i_pkey_get_netdev(rq->netdev, qpn);

The hash table is allocated once per parent and shared with every PKEY
child in mlx5i_pkey_dev_init():

	ipriv->qpn_htbl = parent_ipriv->qpn_htbl;

The parent's own QPN is also added to the table through
mlx5i_dev_init()->mlx5i_pkey_add_qpn(). So even a plain parent interface
with no children now takes the same ht_lock on every packet, on every RX
channel and CPU. The lock's cacheline would bounce between all the NAPI
CPUs under load.

The only writers are mlx5i_pkey_add_qpn() (from ndo_init via
mlx5i_dev_init()) and mlx5i_pkey_del_qpn() (from ndo_uninit via
mlx5i_dev_cleanup()). Both already run under RTNL. The NAPI readers run in
BH context, which is already an RCU read-side section.

Would an RCU based lookup close the same use-after-free without putting a
lock on the datapath? That would use hlist_add_head_rcu() in
mlx5i_pkey_add_qpn(), hlist_del_rcu() plus kfree_rcu() in
mlx5i_pkey_del_qpn(), and hlist_for_each_entry_rcu() in
mlx5i_find_qpn_to_netdev_node(). It would replace the reader-side locking
added here rather than build on it.

The commit message also does not mention the per-packet locking cost.

>  
> -	return node->netdev;
> +	return result;
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261030002241.8508-1-prathameshdeshpande7%40gmail.com
