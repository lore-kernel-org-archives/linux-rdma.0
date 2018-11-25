From: Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] net: remove unsafe skb_insert()
Date: Sun, 25 Nov 2018 08:26:23 -0800
Message-ID: <20181125162623.127762-1-edumazet@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: "David S . Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Eric Dumazet <eric.dumazet@gmail.com>, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

I do not see how one can effectively use skb_insert() without holding
some kind of lock. Otherwise other cpus could have changed the list
right before we have a chance of acquiring list->lock.

Only existing user is in drivers/infiniband/hw/nes/nes_mgt.c and this
one probably meant to use __skb_insert() since it appears nesqp->pau_list
is protected by nesqp->pau_lock. This looks like nesqp->pau_lock
could be removed, since nesqp->pau_list.lock could be used instead.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma <linux-rdma@vger.kernel.org>
---
 drivers/infiniband/hw/nes/nes_mgt.c |  4 ++--
 include/linux/skbuff.h              |  2 --
 net/core/skbuff.c                   | 22 ----------------------
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index fc0c191014e908eea32d752f3499295ef143aa0a..abb54d30d35dd53fa983ee437506933eeba72746 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -551,14 +551,14 @@ static void queue_fpdus(struct sk_buff *skb, struct nes_vnic *nesvnic, struct ne
 
 	/* Queue skb by sequence number */
 	if (skb_queue_len(&nesqp->pau_list) == 0) {
-		skb_queue_head(&nesqp->pau_list, skb);
+		__skb_queue_head(&nesqp->pau_list, skb);
 	} else {
 		skb_queue_walk(&nesqp->pau_list, tmpskb) {
 			cb = (struct nes_rskb_cb *)&tmpskb->cb[0];
 			if (before(seqnum, cb->seqnum))
 				break;
 		}
-		skb_insert(tmpskb, skb, &nesqp->pau_list);
+		__skb_insert(tmpskb, skb, &nesqp->pau_list);
 	}
 	if (nesqp->pau_state == PAU_READY)
 		process_it = true;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f17a7452ac7bf47ef4bcf89840bba165cee6f50a..73902acf2b71c8800d81b744a936a7420f33b459 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1749,8 +1749,6 @@ static inline void skb_queue_head_init_class(struct sk_buff_head *list,
  *	The "__skb_xxxx()" functions are the non-atomic ones that
  *	can only be called with interrupts disabled.
  */
-void skb_insert(struct sk_buff *old, struct sk_buff *newsk,
-		struct sk_buff_head *list);
 static inline void __skb_insert(struct sk_buff *newsk,
 				struct sk_buff *prev, struct sk_buff *next,
 				struct sk_buff_head *list)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9a8a72cefe9b94d3821b9cc5ba5bba647ae51267..02cd7ae3d0fb26ef0a8b006390154fdefd0d292f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2990,28 +2990,6 @@ void skb_append(struct sk_buff *old, struct sk_buff *newsk, struct sk_buff_head
 }
 EXPORT_SYMBOL(skb_append);
 
-/**
- *	skb_insert	-	insert a buffer
- *	@old: buffer to insert before
- *	@newsk: buffer to insert
- *	@list: list to use
- *
- *	Place a packet before a given packet in a list. The list locks are
- * 	taken and this function is atomic with respect to other list locked
- *	calls.
- *
- *	A buffer cannot be placed on two lists at the same time.
- */
-void skb_insert(struct sk_buff *old, struct sk_buff *newsk, struct sk_buff_head *list)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&list->lock, flags);
-	__skb_insert(newsk, old->prev, old, list);
-	spin_unlock_irqrestore(&list->lock, flags);
-}
-EXPORT_SYMBOL(skb_insert);
-
 static inline void skb_split_inside_header(struct sk_buff *skb,
 					   struct sk_buff* skb1,
 					   const u32 len, const int pos)
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
