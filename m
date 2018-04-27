From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH 3/3] net: Revoke export for __skb_tx_hash,
 update it to just be static skb_tx_hash
Date: Fri, 27 Apr 2018 14:06:53 -0400
Message-ID: <20180427180651.4883.20883.stgit@ahduyck-green-test.jf.intel.com>
References: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, niranjana.vishwanathapura@intel.com, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

I am dropping the export of __skb_tx_hash as after my patches nobody is
using it outside of the net/core/dev.c file. In addition I am renaming and
repurposing it to just be a static declaration of skb_tx_hash since that
was the only user for it at this point. By doing this the compiler can
inline it into __netdev_pick_tx as that will improve performance.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 include/linux/netdevice.h |   13 -------------
 net/core/dev.c            |   10 ++++------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cf44503..6da5371 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3213,19 +3213,6 @@ static inline int netif_set_xps_queue(struct net_device *dev,
 }
 #endif
 
-u16 __skb_tx_hash(const struct net_device *dev, struct sk_buff *skb,
-		  unsigned int num_tx_queues);
-
-/*
- * Returns a Tx hash for the given packet when dev->real_num_tx_queues is used
- * as a distribution range limit for the returned value.
- */
-static inline u16 skb_tx_hash(const struct net_device *dev,
-			      struct sk_buff *skb)
-{
-	return __skb_tx_hash(dev, skb, dev->real_num_tx_queues);
-}
-
 /**
  *	netif_is_multiqueue - test if device has multiple transmit queues
  *	@dev: network device
diff --git a/net/core/dev.c b/net/core/dev.c
index 9b04a9f..7584d9c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2614,17 +2614,16 @@ void netif_device_attach(struct net_device *dev)
  * Returns a Tx hash based on the given packet descriptor a Tx queues' number
  * to be used as a distribution range.
  */
-u16 __skb_tx_hash(const struct net_device *dev, struct sk_buff *skb,
-		  unsigned int num_tx_queues)
+static u16 skb_tx_hash(const struct net_device *dev, struct sk_buff *skb)
 {
 	u32 hash;
 	u16 qoffset = 0;
-	u16 qcount = num_tx_queues;
+	u16 qcount = dev->real_num_tx_queues;
 
 	if (skb_rx_queue_recorded(skb)) {
 		hash = skb_get_rx_queue(skb);
-		while (unlikely(hash >= num_tx_queues))
-			hash -= num_tx_queues;
+		while (unlikely(hash >= qcount))
+			hash -= qcount;
 		return hash;
 	}
 
@@ -2637,7 +2636,6 @@ u16 __skb_tx_hash(const struct net_device *dev, struct sk_buff *skb,
 
 	return (u16) reciprocal_scale(skb_get_hash(skb), qcount) + qoffset;
 }
-EXPORT_SYMBOL(__skb_tx_hash);
 
 static void skb_warn_bad_offload(const struct sk_buff *skb)
 {
