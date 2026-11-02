Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605313;
	b=RYogGWcCyyzMuJyT84/1P4u5skMumWzGBqfT9cfKImyLCrEhiN+h1FS9ZG8JOH0keevL
	 cdKGS7AU5FJAUFHrcxfsBP4avsq4lWV+CSEHEqaBoKzoWAacVPhKQmDm0Q2olBbleAs9g
	 fHXNeJx5gmpvBXQ8WV9ZuvnHEOtzcuD+HMPDNCJFyAr5uT666m0VrtQS5a0JT6Jq7xCIb
	 KEY/4a9fsZjA2b+s7tbkHvaM5bBFAIwmXiA/cIMWJL6tt5Tv1kdzwrfx5Wgx+3XdpbSBN
	 ftjA4dPTfzlWKq0Gxo0wNkBvs/iT3k9bwm8O4qMVxNAgc7BOP8dE3zvorrhadUFSYlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605313;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=7CjleU6AvzaNyn+knfBHfOhhmo2TtUTc2OgSk/49SFk=;
	b=EDHKLzYUDU7TBeWaZTI6xqvX4tBmRwXnqkG78XI05JGywX3h2KsD3Z63YwmCEQ/8zi5y
	 TtpLV++4KPsgWcsSD92a2OPZ0CrVtm60+OTSi0o2NrL5JGmvGOFBfz0YKft3GqIGhkm/Q
	 DSmhFtsUZKZeESHFAL0pHreKodDA75VI+dhKJJmFIk7Pd1IOBWNfOqMta8SmOh0SyyCt0
	 ElinyONd1jfFJjVb9OobxUKNZ55ExC8rbJ7fVLo4eVLutW0xdvwkNyE4ntTyddW60vJKN
	 Sc2eF7mqZB/iiVOB4FMUjsXvh3G2NPxmT9zWuzvq5E4O9iZCN8ZJtfRH3szn10LMzsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=khZ9Jogz;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408DC606A33F;
	Mon,  2 Nov 2026 07:41:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 408DC606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=khZ9Jogz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7C
	jleU6AvzaNyn+knfBHfOhhmo2TtUTc2OgSk/49SFk=; b=khZ9JogzL2nw+bVsPI
	KgVkMRclJjBdKyyRwNRO1JZN5HZAhkP+eIF59+QeEkD4/4v2FDOnKAdtl8Elz5oY
	pF4ITw1nENjDkNIiOcrAI8ut9KkK+cDLvkVWkqpjFYUbFB6hbZMUBILfYnJzVQuD
	Xc4QB5wo3WyRlzzQkj4io2y6Q=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDnr0OVPuhqKTZdEw--.2020S2;
	Mon, 02 Nov 2026 15:41:10 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v1] net/mlx5e: IPoIB: Fix race in QPN to netdev mapping
Date: Mon,  2 Nov 2026 15:41:07 +0800
Message-ID: <20261102074107.32859-1-18983559317@163.com>
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
X-CM-TRANSID:_____wDnr0OVPuhqKTZdEw--.2020S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCry3WFWrXF15ur4UCr15Arb_yoW5AF47pr
	W7Ga95ArWkZry29w1vqFs5Wr1avw4DKF47G34fCw1fZwn8Zr95Wr1FkFW2kF9YkFWfArn3
	Jr45ZayUAFn5Ar7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRJ3kJUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4BaJbWroPpZszgAA3a

The QPN-to-netdev hash table is protected by ht_lock, but the NAPI lookup
path traverses and dereferences nodes without taking that lock.  A child
interface teardown can therefore remove and free the node while the parent
RQ is still processing completions for that child:

CPU0                                    CPU1
mlx5i_pkey_get_netdev()
node = mlx5i_find_qpn_to_netdev_node()
                                        mlx5i_pkey_del_qpn()
                                        node = mlx5i_find_qpn_to_netdev_node()
                                        spin_lock_bh(&ht->ht_lock)
                                        hlist_del_init(&node->hlist)
                                        spin_unlock_bh(&ht->ht_lock)
                                        kfree(node)
read node->netdev or node->hlist.next

At that point CPU0 is reading freed memory.  The race is reachable when a
PKEY child interface goes down while its completions are still queued on
the shared parent RQ; this is the same lifetime case already described by
the RX path comment.  It can lead to a KASAN use-after-free, corruption of
the RX path, or a panic.

Take ht_lock around hash lookups, and keep the deletion lookup and unlink
in one critical section.  The NAPI path copies the netdev pointer while
the lock prevents the mapping node from being freed.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by deep code inspection. Due to a lack of hardware
infrastructure, the issue was not observed at runtime.

Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev")
Assisted-by: Coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 4120afd097c3..91b203c6d603 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -109,13 +109,14 @@ int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn)
 	struct mlx5i_pkey_qpn_ht *ht = ipriv->qpn_htbl;
 	struct qpn_to_netdev *node;
 
+	spin_lock_bh(&ht->ht_lock);
 	node = mlx5i_find_qpn_to_netdev_node(ht->buckets, qpn);
 	if (!node) {
 		mlx5_core_warn(epriv->mdev, "QPN to netdev delete from HT failed\n");
+		spin_unlock_bh(&ht->ht_lock);
 		return -EINVAL;
 	}
 
-	spin_lock_bh(&ht->ht_lock);
 	hlist_del_init(&node->hlist);
 	spin_unlock_bh(&ht->ht_lock);
 	kfree(node);
@@ -128,10 +129,12 @@ struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn)
 	struct mlx5i_priv *ipriv = netdev_priv(netdev);
 	struct qpn_to_netdev *node;
 
+	spin_lock_bh(&ipriv->qpn_htbl->ht_lock);
 	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
 	if (!node)
 		return NULL;
-
+	spin_unlock_bh(&ipriv->qpn_htbl->ht_lock);
+
 	return node->netdev;
 }
 
-- 
2.43.0

