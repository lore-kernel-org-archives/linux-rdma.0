From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
Date: Mon, 20 Feb 2012 21:56:20 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202202153230.20998@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In drivers/infiniband/hw/nes/nes_cm.c::schedule_nes_timer(), if we do
not take the true branch of either the
  (type == NES_TIMER_TYPE_SEND)
or
  (type == NES_TIMER_TYPE_SEND)
'if' statements (which it looks like we potentially could since that
enum can have other values), then we'll leak the memory allocated to
'new_send'.

This (admittedly, rather clumsy) patch addresses that issue by turning
the two 'if's into 'if' 'else if' and then adding a 'else' branch
where we note that we need to free the mem and then later, when we are
done with it, does a conditional kfree() based on the bool we set in
the 'else' branch.

I also removed a redundant variable ('was_timer_set').

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

 Compile tested only.

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index a4972ab..434a25b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -663,8 +663,8 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	unsigned long flags;
 	struct nes_cm_core *cm_core = cm_node->cm_core;
 	struct nes_timer_entry *new_send;
+	bool free_new_send = false;
 	int ret = 0;
-	u32 was_timer_set;
 
 	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
 	if (!new_send)
@@ -688,9 +688,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 			return -EINVAL;
 		}
 		cm_node->recv_entry = new_send;
-	}
-
-	if (type == NES_TIMER_TYPE_SEND) {
+	} else if (type == NES_TIMER_TYPE_SEND) {
 		new_send->seq_num = ntohl(tcp_hdr(skb)->seq);
 		atomic_inc(&new_send->skb->users);
 		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
@@ -714,15 +712,18 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 				return ret;
 			}
 		}
+	} else {
+		free_new_send = true;
 	}
 
-	was_timer_set = timer_pending(&cm_core->tcp_timer);
-
-	if (!was_timer_set) {
+	if (!timer_pending(&cm_core->tcp_timer)) {
 		cm_core->tcp_timer.expires = new_send->timetosend;
 		add_timer(&cm_core->tcp_timer);
 	}
 
+	if (free_new_send)
+		kfree(new_send);
+
 	return ret;
 }
 
-- 
1.7.9.1


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
