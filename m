From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 11/45] RDMA/cxgb4: Fix indentation
Date: Wed, 11 Oct 2017 10:48:53 -0700
Message-ID: <20171011174927.25113-12-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that smatch reports the following:

drivers/infiniband/hw/cxgb4/device.c:1105: copy_gl_to_skb_pkt() warn: inconsistent indenting
drivers/infiniband/hw/cxgb4/cm.c:835: send_connect() warn: inconsistent indenting
drivers/infiniband/hw/cxgb4/cm.c:841: send_connect() warn: inconsistent indenting
drivers/infiniband/hw/cxgb4/cm.c:888: send_connect() warn: inconsistent indenting
drivers/infiniband/hw/cxgb4/cm.c:894: send_connect() warn: inconsistent indenting

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c     | 8 ++++----
 drivers/infiniband/hw/cxgb4/device.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e395afcd7d33..2331e7d57704 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -832,13 +832,13 @@ static int send_connect(struct c4iw_ep *ep)
 				t5req->params =
 					  cpu_to_be64(FILTER_TUPLE_V(params));
 				t5req->rsvd = cpu_to_be32(isn);
-			pr_debug("snd_isn %u\n", t5req->rsvd);
+				pr_debug("snd_isn %u\n", t5req->rsvd);
 				t5req->opt2 = cpu_to_be32(opt2);
 			} else {
 				t6req->params =
 					  cpu_to_be64(FILTER_TUPLE_V(params));
 				t6req->rsvd = cpu_to_be32(isn);
-			pr_debug("snd_isn %u\n", t6req->rsvd);
+				pr_debug("snd_isn %u\n", t6req->rsvd);
 				t6req->opt2 = cpu_to_be32(opt2);
 			}
 		}
@@ -885,13 +885,13 @@ static int send_connect(struct c4iw_ep *ep)
 				t5req6->params =
 					    cpu_to_be64(FILTER_TUPLE_V(params));
 				t5req6->rsvd = cpu_to_be32(isn);
-			pr_debug("snd_isn %u\n", t5req6->rsvd);
+				pr_debug("snd_isn %u\n", t5req6->rsvd);
 				t5req6->opt2 = cpu_to_be32(opt2);
 			} else {
 				t6req6->params =
 					    cpu_to_be64(FILTER_TUPLE_V(params));
 				t6req6->rsvd = cpu_to_be32(isn);
-			pr_debug("snd_isn %u\n", t6req6->rsvd);
+				pr_debug("snd_isn %u\n", t6req6->rsvd);
 				t6req6->opt2 = cpu_to_be32(opt2);
 			}
 
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index fa16a4a8c9a4..33bfddf3b064 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1102,8 +1102,8 @@ static inline struct sk_buff *copy_gl_to_skb_pkt(const struct pkt_gl *gl,
 	if (unlikely(!skb))
 		return NULL;
 
-	 __skb_put(skb, gl->tot_len + sizeof(struct cpl_pass_accept_req) +
-		   sizeof(struct rss_header) - pktshift);
+	__skb_put(skb, gl->tot_len + sizeof(struct cpl_pass_accept_req) +
+		  sizeof(struct rss_header) - pktshift);
 
 	/*
 	 * This skb will contain:
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
