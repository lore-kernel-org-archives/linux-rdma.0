From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/27] IB/hfi1: Allocate context data on memory node
Date: Wed, 08 Feb 2017 05:26:37 -0800
Message-ID: <20170208132636.16442.92184.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There are some memory allocation calls in hfi1_create_ctxtdata()
that do not use the numa function parameter. This
can cause cache lines to be filled over QPI.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e3b5bc9..f40864e 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -297,14 +297,15 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 		 * The resulting value will be rounded down to the closest
 		 * multiple of dd->rcv_entries.group_size.
 		 */
-		rcd->egrbufs.buffers = kcalloc(rcd->egrbufs.count,
-					       sizeof(*rcd->egrbufs.buffers),
-					       GFP_KERNEL);
+		rcd->egrbufs.buffers = kzalloc_node(
+			rcd->egrbufs.count * sizeof(*rcd->egrbufs.buffers),
+			GFP_KERNEL, numa);
 		if (!rcd->egrbufs.buffers)
 			goto bail;
-		rcd->egrbufs.rcvtids = kcalloc(rcd->egrbufs.count,
-					       sizeof(*rcd->egrbufs.rcvtids),
-					       GFP_KERNEL);
+		rcd->egrbufs.rcvtids = kzalloc_node(
+				rcd->egrbufs.count *
+				sizeof(*rcd->egrbufs.rcvtids),
+				GFP_KERNEL, numa);
 		if (!rcd->egrbufs.rcvtids)
 			goto bail;
 		rcd->egrbufs.size = eager_buffer_size;
@@ -322,8 +323,8 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 		rcd->egrbufs.rcvtid_size = HFI1_MAX_EAGER_BUFFER_SIZE;
 
 		if (ctxt < dd->first_user_ctxt) { /* N/A for PSM contexts */
-			rcd->opstats = kzalloc(sizeof(*rcd->opstats),
-				GFP_KERNEL);
+			rcd->opstats = kzalloc_node(sizeof(*rcd->opstats),
+						    GFP_KERNEL, numa);
 			if (!rcd->opstats)
 				goto bail;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
