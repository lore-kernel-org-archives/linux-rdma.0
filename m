Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793487490;
	b=ztZ52kpK+XE24XDCUSL2zTIndMQyvvj/M11SyyHpGIF9sWwIkZA7F1lzdWm3MNsWEM5A
	 kdp7fNn/j2gSuFan3WWfDEXkwbuF7EBUrIrKJT795e/uBpTMlhb2of/SlUQOTWzaZKpnu
	 GC7XkB/mmy/4a5d/N5IVgAg3FauH448Viof0yKxWg1BS2sHyY49dIcBkizALcByx3KBxA
	 ehxupMMdxwZ5z3//bmpaF0heLdIj4XLtTvQ3cJWZA7U1mN5SM8SzkLVxzQ3W2eno04axQ
	 wGY41qzoVz0od5JF9a56Ft/y+WENHHnN8KHlAfX1nrr2h0eY3wOfsTpPdRl9k5D+tzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793487490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yua6VmYG+rPT0EJdFP1ydV4LtFe2Ecs40LvHqDhT5L4=;
	b=hVu3gWl/HjN9WXtd6S1F8CvMm5Ro0Jm7pjQV/JIAF2TLOHNSTMX/T4ueeeKVrC1IrIeW
	 7olqCr+MO+3GmfWlrOuDo/cxUFSUWjmkgKHUbvOoYzrJdUn63pCV44sbmxMuaTzXLj7fG
	 S1I/Robq1NWC4eHkvR0jSmSHPi82jS3begTonqV/lmWfUQbZwAxuPDicQ55sHvFPI8veM
	 JnPN42h47El42piITinVe3XLZGW9HQ4gzNfLRnoUgT8ODyt9yG5p1YTRBhvWMZz1griuX
	 6U6fjAMK6MlCQW7xPEu6vLzbK4TXLCzN4ZYNValpyymUJKfwnn7OjX1e2GKZ+TyhKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ah0RW83o;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD00606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 22:58:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAD00606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ah0RW83o
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso13946115e9.1
        for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 15:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793487488; x=1794092288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yua6VmYG+rPT0EJdFP1ydV4LtFe2Ecs40LvHqDhT5L4=;
        b=Ah0RW83o0vWcaYoOAYnX0fCqd2bAS3joFH5VcC0MFdkv1gNZTCOkcdPggdJr59OYhR
         /+jjLbJmh0D7nJQ8bpw59wnGHdMCn1cIYVkz3mSrrAJwhOQo2m/7deY6X+z9YE4GenRh
         KRadVFQsKdgUhl8lqm3DoxTjjnSDPJYesWPSkTpgWpqXE9hWa84/dNvitSjMsb+bKPzZ
         y7ZImqjXw+nxAIGCEdLZczfVCsoV6OJqLH0+FLNr2zJ7pnxeI5GlufdYtAryO+UuHGWf
         Rxf5T9NfR00DvzV+wcObSia3cWdWMksVe8+BeSqzLMDpKPub+kI6eq+sgnqR8y9+sZOl
         k1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793487488; x=1794092288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yua6VmYG+rPT0EJdFP1ydV4LtFe2Ecs40LvHqDhT5L4=;
        b=YiMnRBGQJBG91MZR4niCKyxzMZbVnyBlBdDs7FHadbMx65Pc4a2dv2e59wMUdgDsqp
         MKiBRFFYUk7aZaZnmKswMGcPbyKO7JTNRDNKrcUbRELZPUbRrDiThOhvIlHjnwkFlD7/
         QMskofE0i8Qdra0gpojklEC/HjDRV+dN//lnBsJOTkn8AxjgSwNrkaa7YoLRsVafbMJo
         QMl6XBVuRf0pqzhWK1SblmLYSk2TMUY4tNl8boYGS2kR+HLxIsDG7A9beZ7XbHuoubDO
         idtHc2ETtIavDAi4FaaD19/Lyjw6Geh2jShNgZAVBAnGqRGh1Qm38Ycr1qfZY9Zb+537
         wh+w==
X-Forwarded-Encrypted: i=1; AKwUvBxiSyn/Tjr3dLaqqFb0+IgzSmQYYv3sCIp00RzAcc6k/EAc+BbMpMZ/gDxCTH2BwS4M0S8+fzhZvW3x@vger.kernel.org
X-Gm-Message-State: AFq9FYIQNVihEwHYoKRR2yRfWbP65OV04QhHguG+ynPMDL6i5Ob5kWfP
	uqLLJvGKmJgwTvwBurNj1mHDRtnbcdY32XJxbyQmUVN7eThq5wjzvMQG
X-Gm-Gg: AYBFou1x1rr82yu6OuYjrFCcgzRk+kHPyNClYazaUlqwEy0hqUblLPWqTImgw9sPE4i
	7IQ01MIrvou3cLZOr3QG4X+oJ4v5vvAzxmZSDyVjyYgrjGUeoOb/6V/WLRswkPY8RdMQArIEp6c
	EPicVRupJyD2LWk1iDRaEvHv+2Il0YwQ3DtEGS8i5rOJD27XPLvSfG4FaF9u+AbHpBuXQHbm0WY
	kTds81UBKb4bSy3sAG2hB4PdcDR794BqbPEhza9K+mRQcAGGYp8K5YkkSjgzj/eBR3b7mjA554N
	hQ8kpvLbRFJn2qvybXVRlBOchlOLsRGn9A0xXuZ4GHd40E4F2iZSFX9huWl8HKVSMPQm855zSSU
	JuCtUkR0KL+l0/s5w/KsQdoyBfzRp05IHP0Jj6AYvXIst8QGL8nCOqpnMWRD1YvFvWrfRdnubub
	TeNxnAYQkSATPCTstJsrA77EorpsxpaGzUYkmD31yXwzpE7InelcSDzptvfTXbxWRgMPeg67ZX0
	viiuBzadeUwTqM118DXupJE2g15bPYqYZwksgjPSwq7LEu6ipmUkV9lnnm/HIjaJFj3W08PlVPj
	0OpO6xvQ6kTspi/RY1pc4orl8f6X1U+lL12pHTwEBKIq/k7HhBaFQT8UkJqCVPO4Wb1B+zDMc1G
	O6y+Mn10tdI4gQJMwLFeNeX6JtLGVdrwINPSqH2egZc5+i7gVbH5ft3+WDC9mOHGslCcTRRwxX5
	1gOKoa7JNq
X-Received: by 2002:a05:600c:6087:b0:49f:f099:6fb1 with SMTP id 5b1f17b1804b1-4ac17753befmr138514985e9.15.1793487488222;
        Sat, 31 Oct 2026 15:58:08 -0700 (PDT)
Received: from SD.cable.virginm.net (cpc117822-heme13-2-0-cust760.9-1.cable.virginm.net. [81.111.210.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ab69b54742sm329882745e9.15.2026.10.31.15.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 15:58:05 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: dtatulea@nvidia.com,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Erez Shitrit <erezsh@mellanox.com>,
	Alex Vesker <valex@mellanox.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net/mlx5e: IPOIB, Fix QPN lookup race
Date: Sat, 31 Oct 2026 22:57:13 +0000
Message-ID: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The parent RX completion path can load a QPN hash entry before
mlx5i_pkey_del_qpn() unlinks and frees it, then dereference freed memory.

Use RCU hlist operations and defer freeing with kfree_rcu(). The existing
RCU read-side section in mlx5e_napi_poll() covers the lookup. Keep ht_lock
for writers and acquire it before looking up the entry to delete.

Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
---

Changes in v2:
- Replace the RX spinlock with RCU traversal and deferred freeing.
- Narrow the description to the parent CQE lookup race.

v1: https://lore.kernel.org/all/20261030002241.8508-1-prathameshdeshpande7@gmail.com/
Review: https://lore.kernel.org/all/ade46454-e575-43e4-85aa-eeb5ad79408a@nvidia.com/

 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |  2 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     | 26 +++++++++++--------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index d67d5a72bb41..8c0039c5425e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -82,7 +82,7 @@ void mlx5i_pkey_qpn_ht_cleanup(struct net_device *netdev);
 int mlx5i_pkey_add_qpn(struct net_device *netdev, u32 qpn);
 int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn);
 
-/* Get the net-device corresponding to the given underlay QPN */
+/* Get the net-device for a QPN. Caller must hold rcu_read_lock(). */
 struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn);
 
 /* Shared ndo functions */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 4120afd097c3..5edc39247525 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/hash.h>
+#include <linux/rculist.h>
 #include "ipoib.h"
 
 #define MLX5I_MAX_LOG_PKEY_SUP 7
@@ -39,11 +40,12 @@ struct qpn_to_netdev {
 	struct net_device *netdev;
 	struct hlist_node hlist;
 	u32 underlay_qpn;
+	struct rcu_head rcu;
 };
 
 struct mlx5i_pkey_qpn_ht {
 	struct hlist_head buckets[1 << MLX5I_MAX_LOG_PKEY_SUP];
-	spinlock_t ht_lock; /* Synchronise with NAPI */
+	spinlock_t ht_lock; /* Serialize hash table updates */
 };
 
 int mlx5i_pkey_qpn_ht_init(struct net_device *netdev)
@@ -68,13 +70,14 @@ void mlx5i_pkey_qpn_ht_cleanup(struct net_device *netdev)
 	kfree(ipriv->qpn_htbl);
 }
 
-static struct qpn_to_netdev *mlx5i_find_qpn_to_netdev_node(struct hlist_head *buckets,
-							   u32 qpn)
+static struct qpn_to_netdev *
+mlx5i_find_qpn_to_netdev_node(struct mlx5i_pkey_qpn_ht *ht, u32 qpn)
 {
-	struct hlist_head *h = &buckets[hash_32(qpn, MLX5I_MAX_LOG_PKEY_SUP)];
+	struct hlist_head *h = &ht->buckets[hash_32(qpn, MLX5I_MAX_LOG_PKEY_SUP)];
 	struct qpn_to_netdev *node;
 
-	hlist_for_each_entry(node, h, hlist) {
+	hlist_for_each_entry_rcu(node, h, hlist,
+				 lockdep_is_held(&ht->ht_lock)) {
 		if (node->underlay_qpn == qpn)
 			return node;
 	}
@@ -96,7 +99,7 @@ int mlx5i_pkey_add_qpn(struct net_device *netdev, u32 qpn)
 	new_node->netdev = netdev;
 	new_node->underlay_qpn = qpn;
 	spin_lock_bh(&ht->ht_lock);
-	hlist_add_head(&new_node->hlist, &ht->buckets[key]);
+	hlist_add_head_rcu(&new_node->hlist, &ht->buckets[key]);
 	spin_unlock_bh(&ht->ht_lock);
 
 	return 0;
@@ -109,16 +112,17 @@ int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn)
 	struct mlx5i_pkey_qpn_ht *ht = ipriv->qpn_htbl;
 	struct qpn_to_netdev *node;
 
-	node = mlx5i_find_qpn_to_netdev_node(ht->buckets, qpn);
+	spin_lock_bh(&ht->ht_lock);
+	node = mlx5i_find_qpn_to_netdev_node(ht, qpn);
 	if (!node) {
+		spin_unlock_bh(&ht->ht_lock);
 		mlx5_core_warn(epriv->mdev, "QPN to netdev delete from HT failed\n");
 		return -EINVAL;
 	}
 
-	spin_lock_bh(&ht->ht_lock);
-	hlist_del_init(&node->hlist);
+	hlist_del_rcu(&node->hlist);
 	spin_unlock_bh(&ht->ht_lock);
-	kfree(node);
+	kfree_rcu(node, rcu);
 
 	return 0;
 }
@@ -128,7 +132,7 @@ struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn)
 	struct mlx5i_priv *ipriv = netdev_priv(netdev);
 	struct qpn_to_netdev *node;
 
-	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
+	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl, qpn);
 	if (!node)
 		return NULL;
 
-- 
2.43.0

