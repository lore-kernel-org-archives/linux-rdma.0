From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/6] IB/rdmavt: Add device structure allocation
Date: Fri, 22 Jan 2016 13:04:45 -0800
Message-ID: <20160122210444.9932.31713.stgit@scvm10.sc.intel.com>
References: <20160122210251.9932.46251.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210251.9932.46251.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds rdmavt device structure allocation in rdamvt. The
ib_device alloc is now done in rdmavt instead of the driver. Drivers
need to tell rdmavt the number of ports when calling.

A side of effect of this patch is fixing a bug with port initialization
where the device structure port array was allocated over top of an
existing one.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   30 ++++++++++++++++++------------
 include/rdma/rdma_vt.h            |    1 +
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index cf7cac6..450caa7 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -67,6 +67,24 @@ static void rvt_cleanup(void)
 }
 module_exit(rvt_cleanup);
 
+struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
+{
+	struct rvt_dev_info *rdi = ERR_PTR(-ENOMEM);
+
+	rdi = (struct rvt_dev_info *)ib_alloc_device(size);
+	if (!rdi)
+		return rdi;
+
+	rdi->ports = kcalloc(nports,
+			     sizeof(struct rvt_ibport **),
+			     GFP_KERNEL);
+	if (!rdi->ports)
+		ib_dealloc_device(&rdi->ibdev);
+
+	return rdi;
+}
+EXPORT_SYMBOL(rvt_alloc_device);
+
 static int rvt_query_device(struct ib_device *ibdev,
 			    struct ib_device_attr *props,
 			    struct ib_udata *uhw)
@@ -434,18 +452,6 @@ EXPORT_SYMBOL(rvt_unregister_device);
 int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
 		  int portnum, u16 *pkey_table)
 {
-	if (!rdi->dparms.nports) {
-		rvt_pr_err(rdi, "Driver says it has no ports.\n");
-		return -EINVAL;
-	}
-
-	rdi->ports = kcalloc(rdi->dparms.nports,
-			     sizeof(struct rvt_ibport **),
-			     GFP_KERNEL);
-	if (!rdi->ports) {
-		rvt_pr_err(rdi, "Could not allocate port mem.\n");
-		return -ENOMEM;
-	}
 
 	rdi->ports[portnum] = port;
 	rdi->ports[portnum]->pkey_table = pkey_table;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index e382cca..7768e04 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -394,6 +394,7 @@ static inline struct rvt_qp *rvt_lookup_qpn(struct rvt_dev_info *rdi,
 	return qp;
 }
 
+struct rvt_dev_info *rvt_alloc_device(size_t size, int nports);
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
