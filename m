From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/15] IB/hfi1: Name function prototype parameters
Date: Tue, 02 May 2017 17:41:47 -0700
Message-ID: <20170503004146.6965.72957.stgit@scvm10.sc.intel.com>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503003734.6965.67405.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To improve the readability of function prototypes, give the parameters
names.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c         |    8 ++-
 drivers/infiniband/hw/hfi1/chip.h         |    6 ++
 drivers/infiniband/hw/hfi1/driver.c       |    4 +-
 drivers/infiniband/hw/hfi1/file_ops.c     |   54 ++++++++++++----------
 drivers/infiniband/hw/hfi1/hfi.h          |   72 +++++++++++++++--------------
 drivers/infiniband/hw/hfi1/init.c         |    2 -
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   30 +++++++-----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |   12 ++---
 drivers/infiniband/hw/hfi1/user_sdma.c    |   62 +++++++++++++------------
 drivers/infiniband/hw/hfi1/user_sdma.h    |   13 +++--
 10 files changed, 143 insertions(+), 120 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index c96bb3a..5aa95da 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1055,7 +1055,7 @@ static void handle_lcb_err(struct hfi1_devdata *dd,
 static void handle_sdma_err(struct hfi1_devdata *dd, u32 unused, u64 reg);
 static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg);
 static void handle_txe_err(struct hfi1_devdata *dd, u32 unused, u64 reg);
-static void set_partition_keys(struct hfi1_pportdata *);
+static void set_partition_keys(struct hfi1_pportdata *ppd);
 static const char *link_state_name(u32 state);
 static const char *link_state_reason_name(struct hfi1_pportdata *ppd,
 					  u32 state);
@@ -1068,9 +1068,9 @@ static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 				  int msecs);
 static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc);
 static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
-static void handle_temp_err(struct hfi1_devdata *);
-static void dc_shutdown(struct hfi1_devdata *);
-static void dc_start(struct hfi1_devdata *);
+static void handle_temp_err(struct hfi1_devdata *dd);
+static void dc_shutdown(struct hfi1_devdata *dd);
+static void dc_start(struct hfi1_devdata *dd);
 static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
 			   unsigned int *np);
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index b9dbf16..4c3c88d 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -636,7 +636,8 @@ static inline void write_uctxt_csr(struct hfi1_devdata *dd, int ctxt,
 	write_csr(dd, offset0 + (0x1000 * ctxt), value);
 }
 
-u64 create_pbc(struct hfi1_pportdata *ppd, u64, int, u32, u32);
+u64 create_pbc(struct hfi1_pportdata *ppd, u64 flags, int srate_mbs, u32 vl,
+	       u32 dw_len);
 
 /* firmware.c */
 #define SBUS_MASTER_BROADCAST 0xfd
@@ -728,7 +729,8 @@ void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
 void set_intr_state(struct hfi1_devdata *dd, u32 enable);
 void apply_link_downgrade_policy(struct hfi1_pportdata *ppd,
 				 int refresh_widths);
-void update_usrhead(struct hfi1_ctxtdata *, u32, u32, u32, u32, u32);
+void update_usrhead(struct hfi1_ctxtdata *rcd, u32 hd, u32 updegr, u32 egrhd,
+		    u32 intr_adjust, u32 npkts);
 int stop_drain_data_vls(struct hfi1_devdata *dd);
 int open_fill_data_vls(struct hfi1_devdata *dd);
 u32 ns_to_cclock(struct hfi1_devdata *dd, u32 ns);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 5278954..fb319d2 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -85,8 +85,8 @@
 MODULE_PARM_DESC(cu, "Credit return units");
 
 unsigned long hfi1_cap_mask = HFI1_CAP_MASK_DEFAULT;
-static int hfi1_caps_set(const char *, const struct kernel_param *);
-static int hfi1_caps_get(char *, const struct kernel_param *);
+static int hfi1_caps_set(const char *val, const struct kernel_param *kp);
+static int hfi1_caps_get(char *buffer, const struct kernel_param *kp);
 static const struct kernel_param_ops cap_ops = {
 	.set = hfi1_caps_set,
 	.get = hfi1_caps_get
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index afdf3ef..0b77283 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -70,30 +70,36 @@
 /*
  * File operation functions
  */
-static int hfi1_file_open(struct inode *, struct file *);
-static int hfi1_file_close(struct inode *, struct file *);
-static ssize_t hfi1_write_iter(struct kiocb *, struct iov_iter *);
-static unsigned int hfi1_poll(struct file *, struct poll_table_struct *);
-static int hfi1_file_mmap(struct file *, struct vm_area_struct *);
-
-static u64 kvirt_to_phys(void *);
-static int assign_ctxt(struct file *, struct hfi1_user_info *);
-static int init_subctxts(struct hfi1_ctxtdata *, const struct hfi1_user_info *);
-static int user_init(struct file *);
-static int get_ctxt_info(struct file *, void __user *, __u32);
-static int get_base_info(struct file *, void __user *, __u32);
-static int setup_ctxt(struct file *);
-static int setup_subctxt(struct hfi1_ctxtdata *);
-static int get_user_context(struct file *, struct hfi1_user_info *, int);
-static int find_shared_ctxt(struct file *, const struct hfi1_user_info *);
-static int allocate_ctxt(struct file *, struct hfi1_devdata *,
-			 struct hfi1_user_info *);
-static unsigned int poll_urgent(struct file *, struct poll_table_struct *);
-static unsigned int poll_next(struct file *, struct poll_table_struct *);
-static int user_event_ack(struct hfi1_ctxtdata *, int, unsigned long);
-static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned, u16);
-static int manage_rcvq(struct hfi1_ctxtdata *, unsigned, int);
-static int vma_fault(struct vm_fault *);
+static int hfi1_file_open(struct inode *inode, struct file *fp);
+static int hfi1_file_close(struct inode *inode, struct file *fp);
+static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from);
+static unsigned int hfi1_poll(struct file *fp, struct poll_table_struct *pt);
+static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma);
+
+static u64 kvirt_to_phys(void *addr);
+static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo);
+static int init_subctxts(struct hfi1_ctxtdata *uctxt,
+			 const struct hfi1_user_info *uinfo);
+static int user_init(struct file *fp);
+static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len);
+static int get_base_info(struct file *fp, void __user *ubase, __u32 len);
+static int setup_ctxt(struct file *fp);
+static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
+static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
+			    int devno);
+static int find_shared_ctxt(struct file *fp,
+			    const struct hfi1_user_info *uinfo);
+static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
+			 struct hfi1_user_info *uinfo);
+static unsigned int poll_urgent(struct file *fp, struct poll_table_struct *pt);
+static unsigned int poll_next(struct file *fp, struct poll_table_struct *pt);
+static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
+			  unsigned long events);
+static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
+			 u16 pkey);
+static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
+		       int start_stop);
+static int vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index f066743..a1e9b8b 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1263,27 +1263,28 @@ struct hfi1_filedata {
 extern u32 hfi1_cpulist_count;
 extern unsigned long *hfi1_cpulist;
 
-int hfi1_init(struct hfi1_devdata *, int);
+int hfi1_init(struct hfi1_devdata *dd, int reinit);
 int hfi1_count_units(int *npresentp, int *nupp);
 int hfi1_count_active_units(void);
 
-int hfi1_diag_add(struct hfi1_devdata *);
-void hfi1_diag_remove(struct hfi1_devdata *);
+int hfi1_diag_add(struct hfi1_devdata *dd);
+void hfi1_diag_remove(struct hfi1_devdata *dd);
 void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup);
 
 void handle_user_interrupt(struct hfi1_ctxtdata *rcd);
 
-int hfi1_create_rcvhdrq(struct hfi1_devdata *, struct hfi1_ctxtdata *);
-int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *);
+int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd);
+int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd);
 int hfi1_create_ctxts(struct hfi1_devdata *dd);
-struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *, u32, int);
-void hfi1_init_pportdata(struct pci_dev *, struct hfi1_pportdata *,
-			 struct hfi1_devdata *, u8, u8);
-void hfi1_free_ctxtdata(struct hfi1_devdata *, struct hfi1_ctxtdata *);
-
-int handle_receive_interrupt(struct hfi1_ctxtdata *, int);
-int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *, int);
-int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *, int);
+struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
+					   int numa);
+void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
+			 struct hfi1_devdata *dd, u8 hw_pidx, u8 port);
+void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd);
+
+int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread);
+int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread);
+int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread);
 void set_all_slowpath(struct hfi1_devdata *dd);
 void hfi1_vnic_synchronize_irq(struct hfi1_devdata *dd);
 void hfi1_set_vnic_msix_info(struct hfi1_ctxtdata *rcd);
@@ -1580,7 +1581,7 @@ static inline int rcv_pkey_check(struct hfi1_pportdata *ppd, u16 pkey,
 
 u32 lrh_max_header_bytes(struct hfi1_devdata *dd);
 int mtu_to_enum(u32 mtu, int default_if_bad);
-u16 enum_to_mtu(int);
+u16 enum_to_mtu(int mtu);
 static inline int valid_ib_mtu(unsigned int mtu)
 {
 	return mtu == 256 || mtu == 512 ||
@@ -1594,15 +1595,15 @@ static inline int valid_opa_max_mtu(unsigned int mtu)
 		(valid_ib_mtu(mtu) || mtu == 8192 || mtu == 10240);
 }
 
-int set_mtu(struct hfi1_pportdata *);
+int set_mtu(struct hfi1_pportdata *ppd);
 
-int hfi1_set_lid(struct hfi1_pportdata *, u32, u8);
-void hfi1_disable_after_error(struct hfi1_devdata *);
-int hfi1_set_uevent_bits(struct hfi1_pportdata *, const int);
-int hfi1_rcvbuf_validate(u32, u8, u16 *);
+int hfi1_set_lid(struct hfi1_pportdata *ppd, u32 lid, u8 lmc);
+void hfi1_disable_after_error(struct hfi1_devdata *dd);
+int hfi1_set_uevent_bits(struct hfi1_pportdata *ppd, const int evtbit);
+int hfi1_rcvbuf_validate(u32 size, u8 type, u16 *encode);
 
-int fm_get_table(struct hfi1_pportdata *, int, void *);
-int fm_set_table(struct hfi1_pportdata *, int, void *);
+int fm_get_table(struct hfi1_pportdata *ppd, int which, void *t);
+int fm_set_table(struct hfi1_pportdata *ppd, int which, void *t);
 
 void set_up_vl15(struct hfi1_devdata *dd, u8 vau, u16 vl15buf);
 void reset_link_credits(struct hfi1_devdata *dd);
@@ -1734,9 +1735,9 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
 #define HFI1_CTXT_WAITING_URG 5
 
 /* free up any allocated data at closes */
-struct hfi1_devdata *hfi1_init_dd(struct pci_dev *,
-				  const struct pci_device_id *);
-void hfi1_free_devdata(struct hfi1_devdata *);
+struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
+				  const struct pci_device_id *ent);
+void hfi1_free_devdata(struct hfi1_devdata *dd);
 struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra);
 
 /* LED beaconing functions */
@@ -1811,24 +1812,25 @@ static inline u32 get_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 
 extern const char ib_hfi1_version[];
 
-int hfi1_device_create(struct hfi1_devdata *);
-void hfi1_device_remove(struct hfi1_devdata *);
+int hfi1_device_create(struct hfi1_devdata *dd);
+void hfi1_device_remove(struct hfi1_devdata *dd);
 
 int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 			   struct kobject *kobj);
-int hfi1_verbs_register_sysfs(struct hfi1_devdata *);
-void hfi1_verbs_unregister_sysfs(struct hfi1_devdata *);
+int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd);
+void hfi1_verbs_unregister_sysfs(struct hfi1_devdata *dd);
 /* Hook for sysfs read of QSFP */
 int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len);
 
-int hfi1_pcie_init(struct pci_dev *, const struct pci_device_id *);
-void hfi1_pcie_cleanup(struct pci_dev *);
-int hfi1_pcie_ddinit(struct hfi1_devdata *, struct pci_dev *);
+int hfi1_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent);
+void hfi1_pcie_cleanup(struct pci_dev *pdev);
+int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev);
 void hfi1_pcie_ddcleanup(struct hfi1_devdata *);
-void hfi1_pcie_flr(struct hfi1_devdata *);
-int pcie_speeds(struct hfi1_devdata *);
-void request_msix(struct hfi1_devdata *, u32 *, struct hfi1_msix_entry *);
-void hfi1_enable_intx(struct pci_dev *);
+void hfi1_pcie_flr(struct hfi1_devdata *dd);
+int pcie_speeds(struct hfi1_devdata *dd);
+void request_msix(struct hfi1_devdata *dd, u32 *nent,
+		  struct hfi1_msix_entry *entry);
+void hfi1_enable_intx(struct pci_dev *pdev);
 void restore_pci_variables(struct hfi1_devdata *dd);
 int do_pcie_gen3_transition(struct hfi1_devdata *dd);
 int parse_platform_config(struct hfi1_devdata *dd);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index b2db776..e872644 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -118,7 +118,7 @@
 module_param(user_credit_return_threshold, uint, S_IRUGO);
 MODULE_PARM_DESC(user_credit_return_threshold, "Credit return threshold for user send contexts, return when unreturned credits passes this many blocks (in percent of allocated blocks, 0 is off)");
 
-static inline u64 encode_rcv_header_entry_size(u16);
+static inline u64 encode_rcv_header_entry_size(u16 size);
 
 static struct idr hfi1_unit_table;
 u32 hfi1_cpulist_count;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index c7f13df..6090933 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -82,20 +82,26 @@ struct tid_pageset {
 		 (unsigned long)(len) - 1) & PAGE_MASK) -	       \
 	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
 
-static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
-			    struct hfi1_filedata *);
-static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
-static int set_rcvarray_entry(struct file *, unsigned long, u32,
-			      struct tid_group *, struct page **, unsigned);
-static int tid_rb_insert(void *, struct mmu_rb_node *);
+static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
+			    struct exp_tid_set *set,
+			    struct hfi1_filedata *fd);
+static u32 find_phys_blocks(struct page **pages, unsigned npages,
+			    struct tid_pageset *list);
+static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
+			      u32 rcventry, struct tid_group *grp,
+			      struct page **pages, unsigned npages);
+static int tid_rb_insert(void *arg, struct mmu_rb_node *node);
 static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
 				    struct tid_rb_node *tnode);
-static void tid_rb_remove(void *, struct mmu_rb_node *);
-static int tid_rb_invalidate(void *, struct mmu_rb_node *);
-static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
-			    struct tid_pageset *, unsigned, u16, struct page **,
-			    u32 *, unsigned *, unsigned *);
-static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
+static void tid_rb_remove(void *arg, struct mmu_rb_node *node);
+static int tid_rb_invalidate(void *arg, struct mmu_rb_node *mnode);
+static int program_rcvarray(struct file *fp, unsigned long vaddr,
+			    struct tid_group *grp,
+			    struct tid_pageset *sets,
+			    unsigned start, u16 count, struct page **pages,
+			    u32 *tidlist, unsigned *tididx, unsigned *pmapped);
+static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
+			      struct tid_group **grp);
 static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node);
 
 static struct mmu_rb_ops tid_rb_ops = {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index d1d7d3d..8a33a09 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -1,7 +1,7 @@
 #ifndef _HFI1_USER_EXP_RCV_H
 #define _HFI1_USER_EXP_RCV_H
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -71,10 +71,10 @@
 	} while (0)
 
 void hfi1_user_exp_rcv_grp_free(struct hfi1_ctxtdata *uctxt);
-int hfi1_user_exp_rcv_init(struct file *);
-int hfi1_user_exp_rcv_free(struct hfi1_filedata *);
-int hfi1_user_exp_rcv_setup(struct file *, struct hfi1_tid_info *);
-int hfi1_user_exp_rcv_clear(struct file *, struct hfi1_tid_info *);
-int hfi1_user_exp_rcv_invalid(struct file *, struct hfi1_tid_info *);
+int hfi1_user_exp_rcv_init(struct file *fp);
+int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd);
+int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo);
+int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo);
+int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo);
 
 #endif /* _HFI1_USER_EXP_RCV_H */
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 8adb6df..17142c5 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -280,39 +280,43 @@ struct user_sdma_txreq {
 	hfi1_cdbg(SDMA, "[%u:%u:%u] " fmt, (pq)->dd->unit, (pq)->ctxt, \
 		 (pq)->subctxt, ##__VA_ARGS__)
 
-static int user_sdma_send_pkts(struct user_sdma_request *, unsigned);
-static int num_user_pages(const struct iovec *);
-static void user_sdma_txreq_cb(struct sdma_txreq *, int);
-static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
-static void user_sdma_free_request(struct user_sdma_request *, bool);
-static int pin_vector_pages(struct user_sdma_request *,
-			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct mm_struct *, struct page **, unsigned,
-			       unsigned);
-static int check_header_template(struct user_sdma_request *,
-				 struct hfi1_pkt_header *, u32, u32);
-static int set_txreq_header(struct user_sdma_request *,
-			    struct user_sdma_txreq *, u32);
-static int set_txreq_header_ahg(struct user_sdma_request *,
-				struct user_sdma_txreq *, u32);
-static inline void set_comp_state(struct hfi1_user_sdma_pkt_q *,
-				  struct hfi1_user_sdma_comp_q *,
-				  u16, enum hfi1_sdma_comp_state, int);
-static inline u32 set_pkt_bth_psn(__be32, u8, u32);
+static int user_sdma_send_pkts(struct user_sdma_request *req,
+			       unsigned maxpkts);
+static int num_user_pages(const struct iovec *iov);
+static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status);
+static inline void pq_update(struct hfi1_user_sdma_pkt_q *pq);
+static void user_sdma_free_request(struct user_sdma_request *req, bool unpin);
+static int pin_vector_pages(struct user_sdma_request *req,
+			    struct user_sdma_iovec *iovec);
+static void unpin_vector_pages(struct mm_struct *mm, struct page **pages,
+			       unsigned start, unsigned npages);
+static int check_header_template(struct user_sdma_request *req,
+				 struct hfi1_pkt_header *hdr, u32 lrhlen,
+				 u32 datalen);
+static int set_txreq_header(struct user_sdma_request *req,
+			    struct user_sdma_txreq *tx, u32 datalen);
+static int set_txreq_header_ahg(struct user_sdma_request *req,
+				struct user_sdma_txreq *tx, u32 len);
+static inline void set_comp_state(struct hfi1_user_sdma_pkt_q *pq,
+				  struct hfi1_user_sdma_comp_q *cq,
+				  u16 idx, enum hfi1_sdma_comp_state state,
+				  int ret);
+static inline u32 set_pkt_bth_psn(__be32 bthpsn, u8 expct, u32 frags);
 static inline u32 get_lrh_len(struct hfi1_pkt_header, u32 len);
 
 static int defer_packet_queue(
-	struct sdma_engine *,
-	struct iowait *,
-	struct sdma_txreq *,
-	unsigned seq);
-static void activate_packet_queue(struct iowait *, int);
-static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
-static int sdma_rb_insert(void *, struct mmu_rb_node *);
+	struct sdma_engine *sde,
+	struct iowait *wait,
+	struct sdma_txreq *txreq,
+	unsigned int seq);
+static void activate_packet_queue(struct iowait *wait, int reason);
+static bool sdma_rb_filter(struct mmu_rb_node *node, unsigned long addr,
+			   unsigned long len);
+static int sdma_rb_insert(void *arg, struct mmu_rb_node *mnode);
 static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
 			 void *arg2, bool *stop);
-static void sdma_rb_remove(void *, struct mmu_rb_node *);
-static int sdma_rb_invalidate(void *, struct mmu_rb_node *);
+static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode);
+static int sdma_rb_invalidate(void *arg, struct mmu_rb_node *mnode);
 
 static struct mmu_rb_ops sdma_rb_ops = {
 	.filter = sdma_rb_filter,
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 3900171..95ec783 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -1,5 +1,7 @@
+#ifndef _HFI1_USER_SDMA_H
+#define _HFI1_USER_SDMA_H
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -78,7 +80,8 @@ struct hfi1_user_sdma_comp_q {
 	struct hfi1_sdma_comp_entry *comps;
 };
 
-int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *, struct file *);
-int hfi1_user_sdma_free_queues(struct hfi1_filedata *);
-int hfi1_user_sdma_process_request(struct file *, struct iovec *, unsigned long,
-				   unsigned long *);
+int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp);
+int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd);
+int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
+				   unsigned long dim, unsigned long *count);
+#endif /* _HFI1_USER_SDMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
