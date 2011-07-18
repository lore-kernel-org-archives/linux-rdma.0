From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/doc/todo: Minor update
Date: Mon, 18 Jul 2011 09:17:52 -0400
Message-ID: <4E243280.1010006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/doc/todo b/doc/todo
index bbb9698..8a5ff14 100644
--- a/doc/todo
+++ b/doc/todo
@@ -8,20 +8,18 @@
 5	051207 - Client reregistration is indicated before SA is
 		 ready to accept subscriptions
 6	060109 - Use LID routing for light sweep to guarantee trap
-                 delivery path to the SM.
+                 delivery path to the SM
 7	061201 - Finer grained locking ?
-8	061201 - Mapping multiple MGIDs on single MLID when characteristics
-                 match (PKey, etc.)
-9	070329 - Add ssh support into remote socket/console support
-10	070329 - Add authentication for (at least remote) console
-11	070413 - Add dynamic rate adjustment for multicast groups
+8	070329 - Add ssh support into remote socket/console support
+9	070329 - Add authentication for (at least remote) console
+10	070413 - Add dynamic rate adjustment for multicast groups
 
 
 Futures
 
 LID partitioning ?
 Advanced failover
-Management
+Upper Layer Management
 Regression tests and automation
 Additional pathing algorithms
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
