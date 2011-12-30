From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/Makefile.am: Add doc/opensm-sriov.txt to docs
Date: Thu, 29 Dec 2011 21:45:10 -0500
Message-ID: <4EFD25B6.8090607@dev.mellanox.co.il>
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
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 57492a9..cb430b3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,7 @@ man_MANS = man/opensm.8 man/osmtest.8 man/torus-2QoS.8 man/torus-2QoS.conf.5
 
 various_scripts = $(wildcard scripts/*)
 docs = doc/performance-manager-HOWTO.txt doc/QoS_management_in_OpenSM.txt \
-	doc/opensm_release_notes-3.3.txt
+	doc/opensm-sriov.txt doc/opensm_release_notes-3.3.txt
 
 EXTRA_DIST = autogen.sh opensm.spec $(various_scripts) $(man_MANS) $(docs)
 
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
