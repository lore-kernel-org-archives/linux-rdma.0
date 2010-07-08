From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibverbs: Introduce a new QP type IBV_QPT_RAW_PACKET
Date: Thu, 08 Jul 2010 16:49:23 +0300
Message-ID: <4C35D763.4050205@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This type of QP is used in Ethernet environment and intended for
creation of a whole packet, including L2 headers, from userspace.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..3941982 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -390,7 +390,8 @@ struct ibv_srq_init_attr {
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
-	IBV_QPT_UD
+	IBV_QPT_UD,
+	IBV_QPT_RAW_PACKET = 8
 };
 
 struct ibv_qp_cap {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
