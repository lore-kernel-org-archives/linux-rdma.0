From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1 (resend)] mthca: Modify to support embedded PowerPC platforms
Date: Mon, 10 Jan 2011 20:12:20 -0800
Message-ID: <adafwt06puj.fsf@cisco.com>
References: <ig5vl1$j0$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ig5vl1$j0$1@dough.gmane.org> (J. L. Burr's message of "Thu, 6
	Jan 2011 21:59:06 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So I redid your patch by hand (and also fixed it up to apply to the
current driver -- there were some changes to mthca_eq.c that I think I
took into account).  See below... can I get a "Signed-off-by:" line from
you for this?

8<--------------------------------------------------

IB/mthca: Fix driver when sizeof (phys_addr_t) > sizeof (long)

Some systems have PCI addresses that don't fit in unsigned long (eg some
32-bit PowerPC 440 systems have 36-bit bus addresses).  Fix up the driver
by using phys_addr_t where appropriate, so we don't truncate any PCI
resource addresses before ioremapping them.

[ Update to apply to current driver source.  - Roland ]

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_catas.c |    5 +++--
 drivers/infiniband/hw/mthca/mthca_cmd.c   |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c    |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c  |    2 +-
 drivers/infiniband/hw/mthca/mthca_mr.c    |    2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_catas.c b/drivers/infiniband/hw/mthca/mthca_catas.c
index 0aa0110..e4a08c2 100644
--- a/drivers/infiniband/hw/mthca/mthca_catas.c
+++ b/drivers/infiniband/hw/mthca/mthca_catas.c
@@ -146,7 +146,7 @@ static void poll_catas(unsigned long dev_ptr)
 
 void mthca_start_catas_poll(struct mthca_dev *dev)
 {
-	unsigned long addr;
+	phys_addr_t addr;
 
 	init_timer(&dev->catas_err.timer);
 	dev->catas_err.map  = NULL;
@@ -158,7 +158,8 @@ void mthca_start_catas_poll(struct mthca_dev *dev)
 	dev->catas_err.map = ioremap(addr, dev->catas_err.size * 4);
 	if (!dev->catas_err.map) {
 		mthca_warn(dev, "couldn't map catastrophic error region "
-			   "at 0x%lx/0x%x\n", addr, dev->catas_err.size * 4);
+			   "at 0x%llx/0x%x\n", (unsigned long long) addr,
+			   dev->catas_err.size * 4);
 		return;
 	}
 
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index f4ceecd..7bfa2a1 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -713,7 +713,7 @@ int mthca_RUN_FW(struct mthca_dev *dev, u8 *status)
 
 static void mthca_setup_cmd_doorbells(struct mthca_dev *dev, u64 base)
 {
-	unsigned long addr;
+	phys_addr_t addr;
 	u16 max_off = 0;
 	int i;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 8e8c728..76785c6 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -653,7 +653,7 @@ static int mthca_map_reg(struct mthca_dev *dev,
 			 unsigned long offset, unsigned long size,
 			 void __iomem **map)
 {
-	unsigned long base = pci_resource_start(dev->pdev, 0);
+	phys_addr_t base = pci_resource_start(dev->pdev, 0);
 
 	*map = ioremap(base + offset, size);
 	if (!*map)
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 5eee666..8a40cd5 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -790,7 +790,7 @@ static int mthca_setup_hca(struct mthca_dev *dev)
 		goto err_uar_table_free;
 	}
 
-	dev->kar = ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	dev->kar = ioremap((phys_addr_t) dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!dev->kar) {
 		mthca_err(dev, "Couldn't map kernel access region, "
 			  "aborting.\n");
diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 065b208..44045c8 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -853,7 +853,7 @@ void mthca_arbel_fmr_unmap(struct mthca_dev *dev, struct mthca_fmr *fmr)
 
 int mthca_init_mr_table(struct mthca_dev *dev)
 {
-	unsigned long addr;
+	phys_addr_t addr;
 	int mpts, mtts, err, i;
 
 	err = mthca_alloc_init(&dev->mr_table.mpt_alloc,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
