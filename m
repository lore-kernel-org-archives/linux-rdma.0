From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 06/15] IB/rxe: Enable type checking on SKB_TO_PKT() and PKT_TO_SKB() arguments
Date: Tue, 10 Jan 2017 11:08:13 -0800
Message-ID: <20170110190822.16953-7-bart.vanassche@sandisk.com>
References: <20170110190822.16953-1-bart.vanassche@sandisk.com>
 <20170110190822.16953-2-bart.vanassche@sandisk.com>
 <20170110190822.16953-3-bart.vanassche@sandisk.com>
 <20170110190822.16953-4-bart.vanassche@sandisk.com>
 <20170110190822.16953-5-bart.vanassche@sandisk.com>
 <20170110190822.16953-6-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110190822.16953-6-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Let the compiler check the type of the arguments passed to SKB_TO_PKT()
and PKT_TO_SKB().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_hdr.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_hdr.h b/drivers/infiniband/sw/rxe/rxe_hdr.h
index d57b5e956ceb..6cb18406f5b8 100644
--- a/drivers/infiniband/sw/rxe/rxe_hdr.h
+++ b/drivers/infiniband/sw/rxe/rxe_hdr.h
@@ -53,8 +53,16 @@ struct rxe_pkt_info {
 };
 
 /* Macros should be used only for received skb */
-#define SKB_TO_PKT(skb) ((struct rxe_pkt_info *)(skb)->cb)
-#define PKT_TO_SKB(pkt) container_of((void *)(pkt), struct sk_buff, cb)
+static inline struct rxe_pkt_info *SKB_TO_PKT(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct rxe_pkt_info) > sizeof(skb->cb));
+	return (void *)skb->cb;
+}
+
+static inline struct sk_buff *PKT_TO_SKB(struct rxe_pkt_info *pkt)
+{
+	return container_of((void *)pkt, struct sk_buff, cb);
+}
 
 /*
  * IBA header types and methods
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
