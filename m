From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 7/8] ibacm: Push COPYING file into individual files
Date: Thu, 10 Nov 2016 11:47:39 -0700
Message-ID: <1478803660-27959-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478803660-27959-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing copyright headers and delete the COPYING file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/COPYING             | 378 ----------------------------------------------
 ibacm/ibacm.init.in       |   1 +
 ibacm/man/ib_acme.1       |   1 +
 ibacm/man/ibacm.1         |   1 +
 ibacm/man/ibacm.7         |   1 +
 ibacm/man/ibacm_prov.7.in |   1 +
 6 files changed, 5 insertions(+), 378 deletions(-)
 delete mode 100644 ibacm/COPYING

diff --git a/ibacm/COPYING b/ibacm/COPYING
deleted file mode 100644
index 13f30ae27d95..000000000000
diff --git a/ibacm/ibacm.init.in b/ibacm/ibacm.init.in
index 0fb0011f3953..821742366054 100644
--- a/ibacm/ibacm.init.in
+++ b/ibacm/ibacm.init.in
@@ -1,4 +1,5 @@
 #!/bin/bash
+# Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 #
 # Bring up/down the ibacm daemon
 #
diff --git a/ibacm/man/ib_acme.1 b/ibacm/man/ib_acme.1
index 530cd16c4c41..e94ff6c615cf 100644
--- a/ibacm/man/ib_acme.1
+++ b/ibacm/man/ib_acme.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "ib_acme" 1 "2014-06-16" "ib_acme" "ib_acme" ib_acme
 .SH NAME
 ib_acme \- test and configuration utility for the IB ACM
diff --git a/ibacm/man/ibacm.1 b/ibacm/man/ibacm.1
index 29ecd86b428e..5042e1ed88ac 100644
--- a/ibacm/man/ibacm.1
+++ b/ibacm/man/ibacm.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "ibacm" 1 "2014-06-16" "ibacm" "ibacm" ibacm
 .SH NAME
 ibacm \- address and route resolution services for InfiniBand.
diff --git a/ibacm/man/ibacm.7 b/ibacm/man/ibacm.7
index ad502cd0c25f..14b5d08d85f1 100644
--- a/ibacm/man/ibacm.7
+++ b/ibacm/man/ibacm.7
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "IBACM" 7 "2014-06-16" "IBACM" "IB ACM User Guide" IBACM
 .SH NAME
 ibacm \- InfiniBand communication management assistant
diff --git a/ibacm/man/ibacm_prov.7.in b/ibacm/man/ibacm_prov.7.in
index 9e79d58f639e..494fdc3b096e 100644
--- a/ibacm/man/ibacm_prov.7.in
+++ b/ibacm/man/ibacm_prov.7.in
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH "IBACM_PROV" 7 "2014-06-16" "IBACM_PROV" "IB ACM Provider Guide" IBACM_PROV
 .SH NAME
 ibacm_prov \- InfiniBand communication management assistant provider interface
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
