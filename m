From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/37] IB/rdmavt: Alloc and dealloc ucontexts
Date: Mon, 07 Dec 2015 15:43:41 -0500
Message-ID: <20151207204340.8144.42516.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
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
 drivers/infiniband/sw/rdmavt/vt.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index c4d7f76..eab1ede 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -184,6 +184,26 @@ static int rvt_query_gid(struct ib_device *ibdev, u8 port,
 	return -EINVAL;
 }
 
+/**
+ * rvt_alloc_ucontext - Allocate a user context
+ * @ibdev: Vers IB dev
+ * @data: User data allocated
+ */
+static struct ib_ucontext *rvt_alloc_ucontext(struct ib_device *ibdev,
+					      struct ib_udata *udata)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ *rvt_dealloc_ucontext - Free a user context
+ *@context - Free this
+ */
+static int rvt_dealloc_ucontext(struct ib_ucontext *context)
+{
+	return -EINVAL;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -203,6 +223,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, modify_port);
 	CDR(rdi, query_pkey);
 	CDR(rdi, query_gid);
+	CDR(rdi, alloc_ucontext);
+	CDR(rdi, dealloc_ucontext);
 
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
