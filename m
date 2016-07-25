From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/28] IB/hfi1: Fix trace message units
Date: Mon, 25 Jul 2016 13:39:33 -0700
Message-ID: <20160725203932.4800.21799.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Heldt <grzegorz.heldt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Grzegorz Heldt <grzegorz.heldt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Trace shows incorrect amount of allocated memory.
Fix trace to display memory in KB.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Grzegorz Heldt <grzegorz.heldt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 44ec3a8..a358d23 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1777,8 +1777,8 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 
 	hfi1_cdbg(PROC,
 		  "ctxt%u: Alloced %u rcv tid entries @ %uKB, total %zuKB\n",
-		  rcd->ctxt, rcd->egrbufs.alloced, rcd->egrbufs.rcvtid_size,
-		  rcd->egrbufs.size);
+		  rcd->ctxt, rcd->egrbufs.alloced,
+		  rcd->egrbufs.rcvtid_size / 1024, rcd->egrbufs.size / 1024);
 
 	/*
 	 * Set the contexts rcv array head update threshold to the closest

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
