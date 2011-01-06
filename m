From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] mthca: Modify to support embedded PowerPC platforms
Date: Wed, 5 Jan 2011 23:13:09 -0500
Message-ID: <ig3fqc$3bt$2@dough.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here's the patch described in part 0.

Use phys_addr_t, rather than unsigned long, for physical addresses to 
accommodate embedded PowerPC processors which use a 36-bit physical address 
on a 32-bit CPU.  phys_addr_t will be 64-bits on these platforms.

This patch is for Linux kernel 2.6.26.

---
diff -rup a/drivers/infiniband/hw/mthca/mthca_catas.c 
b/drivers/infiniband/hw/mthca/mthca_catas.c
--- a/drivers/infiniband/hw/mthca/mthca_catas.c
+++ b/drivers/infiniband/hw/mthca/mthca_catas.c
@@ -148,7 +148,7 @@ static void poll_catas(unsigned long dev

 void mthca_start_catas_poll(struct mthca_dev *dev)
 {
- unsigned long addr;
+ phys_addr_t addr;

  init_timer(&dev->catas_err.timer);
  dev->catas_err.stop = 0;
@@ -161,14 +161,14 @@ void mthca_start_catas_poll(struct mthca
  if (!request_mem_region(addr, dev->catas_err.size * 4,
     DRV_NAME)) {
   mthca_warn(dev, "couldn't request catastrophic error region "
-      "at 0x%lx/0x%x\n", addr, dev->catas_err.size * 4);
+      "at 0x%llx/0x%x\n", (unsigned long long)addr, dev->catas_err.size * 
4);
   return;
  }

  dev->catas_err.map = ioremap(addr, dev->catas_err.size * 4);
  if (!dev->catas_err.map) {
   mthca_warn(dev, "couldn't map catastrophic error region "
-      "at 0x%lx/0x%x\n", addr, dev->catas_err.size * 4);
+      "at 0x%llx/0x%x\n", (unsigned long long)addr, dev->catas_err.size * 
4);
   release_mem_region(addr, dev->catas_err.size * 4);
   return;
  }
diff -rup a/drivers/infiniband/hw/mthca/mthca_cmd.c 
b/drivers/infiniband/hw/mthca/mthca_cmd.c
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -712,7 +712,7 @@ int mthca_RUN_FW(struct mthca_dev *dev,

 static void mthca_setup_cmd_doorbells(struct mthca_dev *dev, u64 base)
 {
- unsigned long addr;
+ phys_addr_t addr;
  u16 max_off = 0;
  int i;

diff -rup a/drivers/infiniband/hw/mthca/mthca_eq.c 
b/drivers/infiniband/hw/mthca/mthca_eq.c
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -652,7 +652,7 @@ static int mthca_map_reg(struct mthca_de
     unsigned long offset, unsigned long size,
     void __iomem **map)
 {
- unsigned long base = pci_resource_start(dev->pdev, 0);
+ phys_addr_t base = pci_resource_start(dev->pdev, 0);

  if (!request_mem_region(base + offset, size, DRV_NAME))
   return -EBUSY;
@@ -669,7 +669,7 @@ static int mthca_map_reg(struct mthca_de
 static void mthca_unmap_reg(struct mthca_dev *dev, unsigned long offset,
        unsigned long size, void __iomem *map)
 {
- unsigned long base = pci_resource_start(dev->pdev, 0);
+ phys_addr_t base = pci_resource_start(dev->pdev, 0);

  release_mem_region(base + offset, size);
  iounmap(map);
diff -rup a/drivers/infiniband/hw/mthca/mthca_main.c 
b/drivers/infiniband/hw/mthca/mthca_main.c
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -786,7 +786,7 @@ static int mthca_setup_hca(struct mthca_
   goto err_uar_table_free;
  }

- dev->kar = ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+ dev->kar = ioremap((phys_addr_t)(dev->driver_uar.pfn) << PAGE_SHIFT, 
PAGE_SIZE);
  if (!dev->kar) {
   mthca_err(dev, "Couldn't map kernel access region, "
      "aborting.\n");
diff -rup a/drivers/infiniband/hw/mthca/mthca_mr.c 
b/drivers/infiniband/hw/mthca/mthca_mr.c
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -838,7 +838,7 @@ void mthca_arbel_fmr_unmap(struct mthca_

 int mthca_init_mr_table(struct mthca_dev *dev)
 {
- unsigned long addr;
+ phys_addr_t addr;
  int mpts, mtts, err, i;

  err = mthca_alloc_init(&dev->mr_table.mpt_alloc,



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
