Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793691713;
	b=3naBllhPOavbEJT84IMFEA/tcKGWagIiKQmp0AZoY8U0F4YLTlWTHiJjI0UjM4nzRqQ3
	 Kf0iDJmkEHkVKN7R6DXzkA/E9Mqf4tOdiDJMxkmqEuwr15FJF50YdqsadWVly6lwkVxG+
	 nXyvJ9HT+Hgcrli1fz0k/Lhh2c/fXLEnO0stj985KbUmuE1qOaBMq0HDYS5/GW4jSRCOT
	 s+vGsC4wBiG5uzDxBL3rXqJJ5/V889Sv9CzAP2trQoebJe6YXwr/dGAtlV0FNSAZkmXAa
	 KS2ulcQO90cq+Et8B2RimCYOK/5E5f+bfHxiCSiEpGh9JzRrx2MtGOielEK8IRT6I/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lKAUc/iUJmPR/HMF9aaTsKUQAf3GWXkhJoXNRjtJvi4=;
	b=x19FCUUS2+8GHZNfO6zlSGQvpvB/ossIcrZpzUOCglOX05M9eWKKKc19yd0grUxzzT+7
	 zh5D901+RFPRJyNZx/2R9mQVC/lLc3MS2s8v+kisapz8M5EOob3L5Te2x//QeNSJuzx1B
	 WG75srIDj4DtH1p9apu+TUGdXzQYWlXNX2fj1cwuuxTL3BjH6lZetDNJLUJph6dhIaK2f
	 +FQDhQ8cD06xayzMQm1WripBnMBUTkgY7gId6TYVmPrx+VzoktgT4mmZqafZMfVWYtDiL
	 2SPqShNaiJEZtUjEgEJad98fpTmKtrabe5gnNsMm9BljYPJdF6i7D69ZVbi/8mIoRDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnN8Hoob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F52606A329
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 07:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnN8Hoob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA231F00919;
	Tue,  3 Nov 2026 07:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793691712;
	bh=lKAUc/iUJmPR/HMF9aaTsKUQAf3GWXkhJoXNRjtJvi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OnN8Hoobd+JYqEcLK5LQv20DnNG+ZLmc26akxR8nQDvKKGMHELaASBfpnSDXJBLOO
	 ROr0KUcATJMOwO9gpfogPiERi2eszWRY2Wf1FFhU2dSdlduhS00IfbyQD0AN9giOc4
	 F4RAmXoV8KNtSNyUdPhYASBM20jRVMOqAM6taOGqAecV4NCwAi6EQbQdwdrqCCcZdh
	 tMv+dnqN6Kxx/s4zDzH0Q7JRkdiF5QmtB9DmI/qppIHxYvOtsixJrl2Mk+f18VoLWw
	 9XW9qGSP9grJOOsDrCjemmKd5FR0eK8IRuv9hNX5NB00Pu0NVM4ITNOZ4iI0IRLY7x
	 //mETGmCJ6PKA==
Message-ID: <sashiko-outbox-194725@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] net/mlx5e: IPoIB: Fix race in QPN to netdev mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102074107.32859-1-18983559317@163.com>
References: <20261102074107.32859-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 07:41:52 +0000
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
- [Critical] net/mlx5e: use-after-free of node in mlx5i_pkey_get_netdev() a=
fter unlock
- [High] net/mlx5e: missing spin_unlock_bh() on error in mlx5i_pkey_get_net=
dev()
--

commit ce671ddaa82c0cc9dedd5f6d773ead36eb9647fc
Author: Binbin Deng <18983559317@163.com>

net/mlx5e: IPoIB: Fix race in QPN to netdev mapping

This commit adds spin_lock_bh(&ht->ht_lock) protection around QPN-to-netdev
hash table lookups in mlx5i_pkey_del_qpn() and mlx5i_pkey_get_netdev() to
prevent concurrent node removal and freeing during NAPI RX processing.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b=
/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> index 4120afd097c36..8aea23e0183b7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
> @@ -109,13 +109,14 @@ int mlx5i_pkey_del_qpn(struct net_device *netdev, u=
32 qpn)
>  	struct mlx5i_pkey_qpn_ht *ht =3D ipriv->qpn_htbl;
>  	struct qpn_to_netdev *node;
> =20
> +	spin_lock_bh(&ht->ht_lock);
>  	node =3D mlx5i_find_qpn_to_netdev_node(ht->buckets, qpn);
>  	if (!node) {
>  		mlx5_core_warn(epriv->mdev, "QPN to netdev delete from HT failed\n");
> +		spin_unlock_bh(&ht->ht_lock);
>  		return -EINVAL;
>  	}
> =20
> -	spin_lock_bh(&ht->ht_lock);
>  	hlist_del_init(&node->hlist);
>  	spin_unlock_bh(&ht->ht_lock);
>  	kfree(node);
> @@ -128,9 +129,11 @@ struct net_device *mlx5i_pkey_get_netdev(struct net_=
device *netdev, u32 qpn)
>  	struct mlx5i_priv *ipriv =3D netdev_priv(netdev);
>  	struct qpn_to_netdev *node;
> =20
> +	spin_lock_bh(&ipriv->qpn_htbl->ht_lock);
>  	node =3D mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
>  	if (!node)
>  		return NULL;

[Severity: High]
Does this early return in mlx5i_pkey_get_netdev() in
drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c leave
ipriv->qpn_htbl->ht_lock held and bottom halves disabled when
mlx5i_find_qpn_to_netdev_node() returns NULL?

During NAPI RX completion processing in
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:mlx5i_complete_rx_cqe(),
a child interface going down can still have unprocessed CQEs queued on the
shared parent RQ:

	netdev =3D mlx5i_pkey_get_netdev(rq->netdev, qpn);

	/* No mapping present, cannot process SKB. This might happen if a child
	 * interface is going down while having unprocessed CQEs on parent RQ
	 */
	if (unlikely(!netdev)) {

When that happens, mlx5i_find_qpn_to_netdev_node() returns NULL and
mlx5i_pkey_get_netdev() returns without calling
spin_unlock_bh(&ipriv->qpn_htbl->ht_lock), which will deadlock on the next
attempt to acquire ht_lock.

> +	spin_unlock_bh(&ipriv->qpn_htbl->ht_lock);
> =20
>  	return node->netdev;
>  }

[Severity: Critical]
Can dereferencing node->netdev after releasing ipriv->qpn_htbl->ht_lock in
mlx5i_pkey_get_netdev() in
drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c still trigger a
use-after-free of node?

Once spin_unlock_bh(&ipriv->qpn_htbl->ht_lock) is called, a concurrent
mlx5i_pkey_del_qpn() on another CPU can acquire ht->ht_lock, unlink node,
and free it before mlx5i_pkey_get_netdev() reads node->netdev:

CPU0                                    CPU1
mlx5i_pkey_get_netdev()
  spin_lock_bh(&ht->ht_lock)
  node =3D mlx5i_find_qpn_to_netdev_node()
  spin_unlock_bh(&ht->ht_lock)
                                        mlx5i_pkey_del_qpn()
                                          spin_lock_bh(&ht->ht_lock)
                                          hlist_del_init(&node->hlist)
                                          spin_unlock_bh(&ht->ht_lock)
                                          kfree(node)
  return node->netdev;

Should mlx5i_pkey_get_netdev() read node->netdev into a local variable
before calling spin_unlock_bh(&ipriv->qpn_htbl->ht_lock)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102074107.3285=
9-1-18983559317@163.com?part=3D1
