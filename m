From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/opensm_release_notes-3.3.txt: Update Unsupported IB
 Compliance Statements
Date: Wed, 30 May 2012 11:26:34 -0400
Message-ID: <4FC63C2A.2040307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


GUIDInfo is now supported (alias GUID support)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/doc/opensm_release_notes-3.3.txt b/doc/opensm_release_notes-3.3.txt
index 888485e..19e6bc6 100644
--- a/doc/opensm_release_notes-3.3.txt
+++ b/doc/opensm_release_notes-3.3.txt
@@ -295,9 +295,6 @@ information regarding each compliance statement.
   If no permission to forward, the subscription should be removed and
   no further forwarding should occur.
 
-* C14-24.1.1.5 and C14-62.1.1.22 (Initialization):
-  GUIDInfo - SM should enable assigning Port GUIDInfo.
-
 * C14-44 (Initialization):
   If the SM discovers that it is missing an M_Key to update CA/RT/SW,
   it should notify the higher level.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
