From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/release notes: Fix typo
Date: Wed, 14 Oct 2009 07:28:19 -0400
Message-ID: <20091014112819.GA17634@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/doc/opensm_release_notes-3.2.txt b/opensm/doc/opensm_release_notes-3.2.txt
index 3356e95..5a83092 100644
--- a/opensm/doc/opensm_release_notes-3.2.txt
+++ b/opensm/doc/opensm_release_notes-3.2.txt
@@ -271,7 +271,7 @@ information regarding each compliance statement.
   PortInfo:M_Key - Set the M_Key to a node based random value.
 
 * C14-62.1.1.13 (Initialization):
-  PortInfo:P_KeyProtectBits - set according to an optional policy.
+  PortInfo:M_KeyProtectBits - set according to an optional policy.
 
 * C14-62.1.1.24 (Initialization):
   SwitchInfo:DefaultPort - should be configured for random FDB.
diff --git a/opensm/doc/opensm_release_notes-3.3.txt b/opensm/doc/opensm_release_notes-3.3.txt
index ad9f9eb..70e7110 100644
--- a/opensm/doc/opensm_release_notes-3.3.txt
+++ b/opensm/doc/opensm_release_notes-3.3.txt
@@ -157,7 +157,7 @@ information regarding each compliance statement.
   PortInfo:M_Key - Set the M_Key to a node based random value.
 
 * C14-62.1.1.13 (Initialization):
-  PortInfo:P_KeyProtectBits - set according to an optional policy.
+  PortInfo:M_KeyProtectBits - set according to an optional policy.
 
 * C14-62.1.1.24 (Initialization):
   SwitchInfo:DefaultPort - should be configured for random FDB.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
