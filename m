From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 18/36] IB/rdmavt: Add get port immutable stub
Date: Mon, 28 Dec 2015 13:11:38 -0800
Message-ID: <20151228211117.29850.30471.stgit@scvm10.sc.intel.com>
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

This adds the get port immutable verbs call.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Change stubs to return EOPNOTSUPP

 drivers/infiniband/sw/rdmavt/vt.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index a889ec4..99fbe37 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -198,6 +198,12 @@ static int rvt_dealloc_ucontext(struct ib_ucontext *context)
 	return -EOPNOTSUPP;
 }
 
+static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
+				  struct ib_port_immutable *immutable)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -219,6 +225,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, query_gid);
 	CHECK_DRIVER_OVERRIDE(rdi, alloc_ucontext);
 	CHECK_DRIVER_OVERRIDE(rdi, dealloc_ucontext);
+	CHECK_DRIVER_OVERRIDE(rdi, get_port_immutable);
 
 	/* Queue Pairs */
 	CHECK_DRIVER_OVERRIDE(rdi, create_qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
