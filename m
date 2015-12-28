From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 10/36] IB/rdmavt: Alloc and dealloc ucontexts
Date: Mon, 28 Dec 2015 13:05:52 -0800
Message-ID: <20151228210500.29850.48417.stgit@scvm10.sc.intel.com>
References: <20151228205612.29850.7328.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228205612.29850.7328.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the stubs to allocate and deallocate user contexts. This will be
handled completely by rvt.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Change stubs to return EOPNOTSUPP

drivers/infiniband/sw/rdmavt/vt.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index e95f197..cd19429 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -178,6 +178,26 @@ static int rvt_query_gid(struct ib_device *ibdev, u8 port,
 	return -EOPNOTSUPP;
 }
 
+/**
+ * rvt_alloc_ucontext - Allocate a user context
+ * @ibdev: Vers IB dev
+ * @data: User data allocated
+ */
+static struct ib_ucontext *rvt_alloc_ucontext(struct ib_device *ibdev,
+					      struct ib_udata *udata)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+/**
+ *rvt_dealloc_ucontext - Free a user context
+ *@context - Free this
+ */
+static int rvt_dealloc_ucontext(struct ib_ucontext *context)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -197,6 +217,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, modify_port);
 	CHECK_DRIVER_OVERRIDE(rdi, query_pkey);
 	CHECK_DRIVER_OVERRIDE(rdi, query_gid);
+	CHECK_DRIVER_OVERRIDE(rdi, alloc_ucontext);
+	CHECK_DRIVER_OVERRIDE(rdi, dealloc_ucontext);
 
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
