From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 15/27] IB/hfi1: Use rdmavt pkey verbs function
Date: Sat, 09 Jan 2016 07:18:02 -0800
Message-ID: <20160109151801.30800.98440.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need to keep providing the query pkey function. This is now being
done in rdmavt. Remove support from hfi1. The allocation and
maintenance of the list still resides in the driver.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index ebf5e2d..25eeea4 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1690,24 +1690,6 @@ unsigned hfi1_get_npkeys(struct hfi1_devdata *dd)
 	return ARRAY_SIZE(dd->pport[0].pkeys);
 }
 
-static int query_pkey(struct ib_device *ibdev, u8 port, u16 index,
-		      u16 *pkey)
-{
-	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	int ret;
-
-	if (index >= hfi1_get_npkeys(dd)) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	*pkey = hfi1_get_pkey(to_iport(ibdev, port), index);
-	ret = 0;
-
-bail:
-	return ret;
-}
-
 /**
  * alloc_ucontext - allocate a ucontest
  * @ibdev: the infiniband device
@@ -1875,7 +1857,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_device = modify_device;
 	ibdev->query_port = query_port;
 	ibdev->modify_port = modify_port;
-	ibdev->query_pkey = query_pkey;
+	ibdev->query_pkey = NULL;
 	ibdev->query_gid = query_gid;
 	ibdev->alloc_ucontext = alloc_ucontext;
 	ibdev->dealloc_ucontext = dealloc_ucontext;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
