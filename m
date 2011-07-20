From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2] opensm/doc/todo: Minor update
Date: Wed, 20 Jul 2011 08:44:15 -0400
Message-ID: <4E26CD9F.9000606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clarify what is intended by "management"

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Restored MC group consolidation item as it's not fully implemented

diff --git a/doc/todo b/doc/todo
index bbb9698..4bf7117 100644
--- a/doc/todo
+++ b/doc/todo
@@ -8,7 +8,7 @@
 5	051207 - Client reregistration is indicated before SA is
 		 ready to accept subscriptions
 6	060109 - Use LID routing for light sweep to guarantee trap
-                 delivery path to the SM.
+                 delivery path to the SM
 7	061201 - Finer grained locking ?
 8	061201 - Mapping multiple MGIDs on single MLID when characteristics
                  match (PKey, etc.)
@@ -21,7 +21,7 @@ Futures
 
 LID partitioning ?
 Advanced failover
-Management
+Upper layer management
 Regression tests and automation
 Additional pathing algorithms
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
