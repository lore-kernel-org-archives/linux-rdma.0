From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] IB/rdmavt,hfi1,qib: Fix memory leak
Date: Wed, 20 Apr 2016 06:05:24 -0700
Message-ID: <20160420130523.28231.90454.stgit@scvm10.sc.intel.com>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420125205.28231.86818.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rdi->ports has memory allocated in rvt_alloc_device(), but does not get
freed because the hfi1 and qib drivers drivers call ib_dealloc_device()
directly instead of going through rdmavt. Add a rvt_dealloc_device()
that frees rdi->ports and then calls ib_dealloc_device(). Switch hfi1
and qib drivers to calling rvt_dealloc_device() instead of
ib_dealloc_device() directly.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |    4 ++--
 drivers/infiniband/sw/rdmavt/vt.c    |   13 +++++++++++++
 drivers/staging/rdma/hfi1/init.c     |    4 ++--
 include/rdma/rdma_vt.h               |    1 +
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 3f062f0..f253111 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1090,7 +1090,7 @@ void qib_free_devdata(struct qib_devdata *dd)
 	qib_dbg_ibdev_exit(&dd->verbs_dev);
 #endif
 	free_percpu(dd->int_counter);
-	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
+	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
 
 u64 qib_int_counter(struct qib_devdata *dd)
@@ -1183,7 +1183,7 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 bail:
 	if (!list_empty(&dd->list))
 		list_del_init(&dd->list);
-	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
+	rvt_dealloc_device(&dd->verbs_dev.rdi);
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 6caf527..e1cc2cc 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -106,6 +106,19 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 }
 EXPORT_SYMBOL(rvt_alloc_device);
 
+/**
+ * rvt_dealloc_device - deallocate rdi
+ * @rdi: structure to free
+ *
+ * Free a structure allocated with rvt_alloc_device()
+ */
+void rvt_dealloc_device(struct rvt_dev_info *rdi)
+{
+	kfree(rdi->ports);
+	ib_dealloc_device(&rdi->ibdev);
+}
+EXPORT_SYMBOL(rvt_dealloc_device);
+
 static int rvt_query_device(struct ib_device *ibdev,
 			    struct ib_device_attr *props,
 			    struct ib_udata *uhw)
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index cfcdc16..00edd50 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1007,7 +1007,7 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	free_percpu(dd->rcv_limit);
 	hfi1_dev_affinity_free(dd);
 	free_percpu(dd->send_schedule);
-	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
+	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
 
 /*
@@ -1110,7 +1110,7 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 bail:
 	if (!list_empty(&dd->list))
 		list_del_init(&dd->list);
-	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
+	rvt_dealloc_device(&dd->verbs_dev.rdi);
 	return ERR_PTR(ret);
 }
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index a869655..d57ceee 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -467,6 +467,7 @@ static inline struct rvt_qp *rvt_lookup_qpn(struct rvt_dev_info *rdi,
 }
 
 struct rvt_dev_info *rvt_alloc_device(size_t size, int nports);
+void rvt_dealloc_device(struct rvt_dev_info *rdi);
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
