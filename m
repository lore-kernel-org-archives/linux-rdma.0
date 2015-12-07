From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/10] IB/qib: Add device specific info prints
Date: Mon, 07 Dec 2015 15:49:21 -0500
Message-ID: <20151207204920.11219.52265.stgit@phlsvslse11.ph.intel.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204735.11219.68688.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement get_card_name and get_pci_dev helper functions for rdmavt
for qib.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h        |    2 ++
 drivers/infiniband/hw/qib/qib_driver.c |   16 ++++++++++++++++
 drivers/infiniband/hw/qib/qib_verbs.c  |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 0e68e1f..e610eaf 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1455,6 +1455,8 @@ u64 qib_sps_ints(void);
 dma_addr_t qib_map_page(struct pci_dev *, struct page *, unsigned long,
 			  size_t, int);
 const char *qib_get_unit_name(int unit);
+const char *qib_get_card_name(struct rvt_dev_info *rdi);
+struct pci_dev *qib_get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
  * Flush write combining store buffers (if present) and perform a write
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 57b19ea..ae5a725 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -90,6 +90,22 @@ const char *qib_get_unit_name(int unit)
 	return iname;
 }
 
+const char *qib_get_card_name(struct rvt_dev_info *rdi)
+{
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = container_of(ibdev,
+					      struct qib_devdata, verbs_dev);
+	return qib_get_unit_name(dd->unit);
+}
+
+struct pci_dev *qib_get_pci_dev(struct rvt_dev_info *rdi)
+{
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = container_of(ibdev,
+					      struct qib_devdata, verbs_dev);
+	return dd->pcidev;
+}
+
 /*
  * Return count of units with at least one port ACTIVE.
  */
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 32c2811..b7e03ae 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2240,6 +2240,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	 * Fill in rvt info object.
 	 */
 	dd->verbs_dev.rdi.driver_f.port_callback = qib_create_port_files;
+	dd->verbs_dev.rdi.driver_f.get_card_name = qib_get_card_name;
+	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.dparms.props.max_pd = ib_qib_max_pds;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
 				   RVT_FLAG_QP_INIT_DRIVER |

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
