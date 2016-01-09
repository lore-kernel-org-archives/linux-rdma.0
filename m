From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 07/27] IB/hfi1: Add device specific info prints
Date: Sat, 09 Jan 2016 07:17:17 -0800
Message-ID: <20160109151716.30800.67580.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement get_card_name and get_pci_dev helper functions for rdmavt
for hfi1.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |   16 ++++++++++++++++
 drivers/staging/rdma/hfi1/hfi.h    |    2 ++
 drivers/staging/rdma/hfi1/verbs.c  |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ce69141..16ac8b6 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -162,6 +162,22 @@ const char *get_unit_name(int unit)
 	return iname;
 }
 
+const char *get_card_name(struct rvt_dev_info *rdi)
+{
+	struct hfi1_ibdev *ibdev = container_of(rdi, struct hfi1_ibdev, rdi);
+	struct hfi1_devdata *dd = container_of(ibdev,
+					       struct hfi1_devdata, verbs_dev);
+	return get_unit_name(dd->unit);
+}
+
+struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi)
+{
+	struct hfi1_ibdev *ibdev = container_of(rdi, struct hfi1_ibdev, rdi);
+	struct hfi1_devdata *dd = container_of(ibdev,
+					       struct hfi1_devdata, verbs_dev);
+	return dd->pcidev;
+}
+
 /*
  * Return count of units with at least one port ACTIVE.
  */
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 1e3993f..c2f7bd0 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1624,6 +1624,8 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 dma_addr_t hfi1_map_page(struct pci_dev *, struct page *, unsigned long,
 			 size_t, int);
 const char *get_unit_name(int unit);
+const char *get_card_name(struct rvt_dev_info *rdi);
+struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
  * Flush write combining store buffers (if present) and perform a write
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 439c930..11540ed 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2042,6 +2042,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	 * Fill in rvt info object.
 	 */
 	dd->verbs_dev.rdi.driver_f.port_callback = hfi1_create_port_files;
+	dd->verbs_dev.rdi.driver_f.get_card_name = get_card_name;
+	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
 				   RVT_FLAG_QP_INIT_DRIVER |

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
