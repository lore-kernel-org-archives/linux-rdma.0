From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] [IPOIB] Do IB path MTU
Date: Thu, 2 Sep 2010 17:20:37 -0600
Message-ID: <20100902232037.GX24971@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPOIB has a mechanism to support varying path MTUs, this is used for
the CM mode where the interface MTU is 64k while the path might be only
2k.

Store the MTU value from SA path record replies and SA multicast record
replies. Check outgoing packets against this value rather than the
broadcast group, and if it is too small then invoke the existing MTU
handling functionality.

For a couple of reasons:
- When 4k IB MTU rolls around it would make sense to use a 2k MTU for
  the broadcast and a 4k MTU for the interface. This mechanism will
  make 4k to 2k host communication work fine.
- Work around bugs in opensm which will happily create a 2k MTU
  broadcast group that traverses a 1k MTU link. With this patch PMTU
  will make sure that unicast communication that crosses a 1k link
  works. Otherwise things just quietly break.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |    9 ++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c        |    2 ++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 ++++--
 6 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..57930a5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -362,6 +362,7 @@ struct ipoib_ah {
 	struct list_head   list;
 	struct kref	   ref;
 	unsigned	   last_send;
+	unsigned int       mtu;
 };
 
 struct ipoib_path {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index bb10041..f9c0348 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1366,15 +1366,22 @@ static void ipoib_cm_skb_reap(struct work_struct *work)
 	struct net_device *dev = priv->dev;
 	struct sk_buff *skb;
 	unsigned long flags;
-	unsigned mtu = priv->mcast_mtu;
+	struct ipoib_neigh *neigh;
 
 	netif_tx_lock_bh(dev);
 	spin_lock_irqsave(&priv->lock, flags);
 
 	while ((skb = skb_dequeue(&priv->cm.skb_queue))) {
+		unsigned mtu;
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 
+		neigh = *to_ipoib_neigh(skb_dst(skb)->neighbour);
+		if (neigh && neigh->ah)
+			mtu = neigh->ah->mtu;
+		else
+			mtu = priv->mcast_mtu;
+
 		if (skb->protocol == htons(ETH_P_IP))
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, htonl(mtu));
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 86eae22..2232f79 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -217,9 +217,11 @@ static int ipoib_path_seq_show(struct seq_file *file, void *iter_ptr)
 		seq_printf(file,
 			   "  DLID:     0x%04x\n"
 			   "  SL: %12d\n"
+			   "  MTU: %11d\n"
 			   "  rate: %*d%s Gb/sec\n",
 			   be16_to_cpu(path.pathrec.dlid),
 			   path.pathrec.sl,
+			   path.ah ? path.ah->mtu : 0,
 			   10 - ((rate % 10) ? 2 : 0),
 			   rate / 10, rate % 10 ? ".5" : "");
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index aa9f9cf..ca48dd9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -552,12 +552,12 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		required_mtu = skb->len;
 	}
 
-	if (unlikely(required_mtu > priv->mcast_mtu + IPOIB_ENCAP_LEN)) {
+	if (unlikely(required_mtu > address->mtu + IPOIB_ENCAP_LEN)) {
 		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
-			   required_mtu, priv->mcast_mtu + IPOIB_ENCAP_LEN);
+			   required_mtu, address->mtu + IPOIB_ENCAP_LEN);
 		++dev->stats.tx_dropped;
 		++dev->stats.tx_errors;
-		ipoib_cm_skb_too_long(dev, skb, priv->mcast_mtu);
+		ipoib_cm_skb_too_long(dev, skb, address->mtu);
 		return;
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b2257..cf182eb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -433,6 +433,7 @@ static void path_rec_completion(int status,
 
 	if (ah) {
 		path->pathrec = *pathrec;
+		ah->mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(pathrec->mtu));
 
 		old_ah   = path->ah;
 		path->ah = ah;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3871ac6..c77017d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -242,15 +242,17 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 		if (!ah) {
 			ipoib_warn(priv, "ib_address_create failed\n");
 		} else {
+			ah->mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(mcmember->mtu));
 			spin_lock_irq(&priv->lock);
 			mcast->ah = ah;
 			spin_unlock_irq(&priv->lock);
 
-			ipoib_dbg_mcast(priv, "MGID %pI6 AV %p, LID 0x%04x, SL %d\n",
+			ipoib_dbg_mcast(priv, "MGID %pI6 AV %p, LID 0x%04x, SL %d, MTU %d\n",
 					mcast->mcmember.mgid.raw,
 					mcast->ah->ah,
 					be16_to_cpu(mcast->mcmember.mlid),
-					mcast->mcmember.sl);
+					mcast->mcmember.sl,
+					ah->mtu);
 		}
 	}
 
-- 
1.5.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
