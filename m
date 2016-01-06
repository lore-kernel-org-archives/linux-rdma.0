From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] IB/rdmavt: Add IB user context allocation and
 de-alloction functions
Date: Wed, 06 Jan 2016 10:15:00 -0800
Message-ID: <20160106181500.3238.75268.stgit@scvm10.sc.intel.com>
References: <20160106181226.3238.98769.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106181226.3238.98769.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Adding IB user context alloc and dealloc functions to rdmavt so that the
drivers that use rdmavt can use these functions instead of defining their
own functions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 18b5f43..df2df36 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -189,6 +189,16 @@ static int rvt_query_gid(struct ib_device *ibdev, u8 port,
 	return -EOPNOTSUPP;
 }
 
+struct rvt_ucontext {
+	struct ib_ucontext ibucontext;
+};
+
+static inline struct rvt_ucontext *to_iucontext(struct ib_ucontext
+						*ibucontext)
+{
+	return container_of(ibucontext, struct rvt_ucontext, ibucontext);
+}
+
 /**
  * rvt_alloc_ucontext - Allocate a user context
  * @ibdev: Vers IB dev
@@ -197,7 +207,12 @@ static int rvt_query_gid(struct ib_device *ibdev, u8 port,
 static struct ib_ucontext *rvt_alloc_ucontext(struct ib_device *ibdev,
 					      struct ib_udata *udata)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_ucontext *context;
+
+	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
+	return &context->ibucontext;
 }
 
 /**
@@ -206,7 +221,8 @@ static struct ib_ucontext *rvt_alloc_ucontext(struct ib_device *ibdev,
  */
 static int rvt_dealloc_ucontext(struct ib_ucontext *context)
 {
-	return -EOPNOTSUPP;
+	kfree(to_iucontext(context));
+	return 0;
 }
 
 static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
