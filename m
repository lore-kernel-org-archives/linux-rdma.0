From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [RFC PATCH 07/15] IB/hfi1: Add device specific info prints
Date: Mon, 14 Dec 2015 12:28:40 -0500
Message-ID: <20151214172838.11576.26047.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

Implement get_card_name and get_pci_dev helper functions for rdmavt
for hfi1.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandr@intel.com>
---
 drivers/staging/rdma/hfi1/driver.c |   16 ++++++++++++++++
 drivers/staging/rdma/hfi1/hfi.h    |    2 ++
 drivers/staging/rdma/hfi1/verbs.c  |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 4c52e78..4f0103b 100644
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
index c4991be..5925deb 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1604,6 +1604,8 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 dma_addr_t hfi1_map_page(struct pci_dev *, struct page *, unsigned long,
 			 size_t, int);
 const char *get_unit_name(int unit);
+const char *get_card_name(struct rvt_dev_info *rdi);
+struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
  * Flush write combining store buffers (if present) and perform a write
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index b810142..1477d00 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2031,6 +2031,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	 * Fill in rvt info object.
 	 */
 	dd->verbs_dev.rdi.driver_f.port_callback = hfi1_create_port_files;
+	dd->verbs_dev.rdi.driver_f.get_card_name = get_card_name;
+	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
 				   RVT_FLAG_QP_INIT_DRIVER |
