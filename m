From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 05/15] IB/hfi1: Adjust default eager_buffer_size to 8MB
Date: Thu, 04 May 2017 05:14:22 -0700
Message-ID: <20170504121421.32747.27378.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Performance analysis shows benefits for PSM2 in increasing eager buffer
size from 2MB to 8MB. The change has neutral impact on verbs.
Make change to the module parameter's default value. Allocation
ring down was verified to work with the larger buffer size.

Reviewed-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 71b0204..c573f06 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -102,9 +102,9 @@
 module_param_named(rcvarr_split, hfi1_rcvarr_split, uint, S_IRUGO);
 MODULE_PARM_DESC(rcvarr_split, "Percent of context's RcvArray entries used for Eager buffers");
 
-static uint eager_buffer_size = (2 << 20); /* 2MB */
+static uint eager_buffer_size = (8 << 20); /* 8MB */
 module_param(eager_buffer_size, uint, S_IRUGO);
-MODULE_PARM_DESC(eager_buffer_size, "Size of the eager buffers, default: 2MB");
+MODULE_PARM_DESC(eager_buffer_size, "Size of the eager buffers, default: 8MB");
 
 static uint rcvhdrcnt = 2048; /* 2x the max eager buffer count */
 module_param_named(rcvhdrcnt, rcvhdrcnt, uint, S_IRUGO);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
