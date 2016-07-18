From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/rdmavt and IB/hfi1: Disable by default
Date: Mon, 18 Jul 2016 07:18:16 -0700
Message-ID: <ef7f1f80-68c4-b8d5-f40b-9bcef5b95e21@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a strict policy in the Linux kernel that new drivers must be
disabled by default. Hence change "default m" into "default n" for the
rdmavt and the hfi1 drivers.

Fixes: 0194621b2253 ("IB/rdmavt: Create module framework and handle driver registration")
Fixes: f48ad614c100 ("IB/hfi1: Move driver out of staging")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/Kconfig   | 2 +-
 drivers/infiniband/sw/rdmavt/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index a925fb0..6a2e83c 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -3,7 +3,7 @@ config INFINIBAND_HFI1
 	depends on X86_64 && INFINIBAND_RDMAVT
 	select MMU_NOTIFIER
 	select CRC32
-	default m
+	default n
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.
 config HFI1_DEBUG_SDMA_ORDER
diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
index 11aa6a3..3426b44 100644
--- a/drivers/infiniband/sw/rdmavt/Kconfig
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_RDMAVT
 	tristate "RDMA verbs transport library"
 	depends on 64BIT
-	default m
+	default n
 	---help---
 	This is a common software verbs provider for RDMA networks.
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
