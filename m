From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Add partition manager configuration doc to docs
Date: Wed, 06 Jun 2012 13:04:15 -0400
Message-ID: <4FCF8D8F.7080905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/Makefile.am b/Makefile.am
index cb430b3..e6fd74a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,8 @@ man_MANS = man/opensm.8 man/osmtest.8 man/torus-2QoS.8 man/torus-2QoS.conf.5
 
 various_scripts = $(wildcard scripts/*)
 docs = doc/performance-manager-HOWTO.txt doc/QoS_management_in_OpenSM.txt \
-	doc/opensm-sriov.txt doc/opensm_release_notes-3.3.txt
+	doc/partition-config.txt doc/opensm-sriov.txt \
+	doc/opensm_release_notes-3.3.txt
 
 EXTRA_DIST = autogen.sh opensm.spec $(various_scripts) $(man_MANS) $(docs)
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
