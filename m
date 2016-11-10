From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/8] srp_daemon: Push COPYING file into individual files
Date: Thu, 10 Nov 2016 11:47:35 -0700
Message-ID: <1478803660-27959-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478803660-27959-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing copyright headers and delete the COPYING file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/COPYING         | 376 ---------------------------------------------
 srp_daemon/ibsrpdm.1       |   1 +
 srp_daemon/srp_daemon.1.in |   1 +
 srp_daemon/srpd.in         |   1 +
 4 files changed, 3 insertions(+), 376 deletions(-)
 delete mode 100644 srp_daemon/COPYING

diff --git a/srp_daemon/COPYING b/srp_daemon/COPYING
deleted file mode 100644
index 34994d31ea0b..000000000000
diff --git a/srp_daemon/ibsrpdm.1 b/srp_daemon/ibsrpdm.1
index f1c1d2a78ee3..6e7fc0d6e036 100644
--- a/srp_daemon/ibsrpdm.1
+++ b/srp_daemon/ibsrpdm.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBSRPDM 1 "August 30, 2005" "OpenFabrics" "USER COMMANDS"
 
 .SH NAME
diff --git a/srp_daemon/srp_daemon.1.in b/srp_daemon/srp_daemon.1.in
index 6ee114284780..008d53a2a55a 100644
--- a/srp_daemon/srp_daemon.1.in
+++ b/srp_daemon/srp_daemon.1.in
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH SRP_DAEMON 1 "September 5, 2006" "OpenFabrics" "USER COMMANDS"
 
 .SH NAME
diff --git a/srp_daemon/srpd.in b/srp_daemon/srpd.in
index d77579170a3b..7e2316f6fbc4 100755
--- a/srp_daemon/srpd.in
+++ b/srp_daemon/srpd.in
@@ -1,4 +1,5 @@
 #!/bin/bash
+# Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 #
 # Manage the SRP client daemon (srp_daemon)
 #
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
