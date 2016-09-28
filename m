From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rxe: IB/core: IB/rdmavt: Fix kernel crash for reg MR
Date: Wed, 28 Sep 2016 20:25:47 +0000
Message-ID: <1475094347-18402-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes below kernel crash on memory registration for rxe
and other transport drivers which has dma_ops extension.

IB/core invokes ib_map_sg_attrs() in generic manner with dma attributes
which is used by mlx5 and mthca adapters.
However in doing so it ignored honoring dma_ops extension of software based
transports for sg map/unmap operation.
This results into calling dma_map_sg_attrs of hardware virtual device
resulting in crash for null reference.

Fix: It extends core to support sg_map/unmap_attrs and transport drivers
to implement those dma_ops callback functions.
Verified usign perftest applications.

Sep 27 06:54:44 kernel: [53869.549130] BUG: unable to handle kernel NULL pointer dereference at           (null)
Sep 27 06:54:44 kernel: [53869.553005] IP: [<ffffffff81032a75>] check_addr+0x35/0x60
Sep 27 06:54:44 kernel: [53869.553005] PGD 3cad8067 PUD 3ce05067 PMD 0
Sep 27 06:54:44 kernel: [53869.553005] Oops: 0000 [#1] SMP
Sep 27 06:54:44 kernel: [53869.553005] Modules linked in: rdma_rxe rdma_ucm ib_umad rdma_cm configfs iw_cm ib_cm ib_uverbs udp_tunnel ib_core binfmt_misc dm_mirror dm_region_hash dm_log dm_mod mousedev evdev psmouse acpi_cpufreq pcspkr button ext4(E) crc16(E) jbd2(E) mbcache(E) ata_piix(E) libata(E) scsi_mod(E) [last unloaded: rdma_rxe]
Sep 27 06:54:44 kernel: [53869.553005] CPU: 0 PID: 32639 Comm: ib_send_bw Tainted: G            E   4.8.0-rc6+ #12
Sep 27 06:54:44 kernel: [53869.553005] Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/12/2016
Sep 27 06:54:44 kernel: [53869.553005] task: ffff88003ca45880 task.stack: ffff88003ce88000
Sep 27 06:54:44 kernel: [53869.553005] RIP: 0010:[<ffffffff81032a75>]  [<ffffffff81032a75>] check_addr+0x35/0x60
Sep 27 06:54:44 kernel: [53869.553005] RSP: 0018:ffff88003ce8bb90  EFLAGS: 00010246
Sep 27 06:54:44 kernel: [53869.553005] RAX: 0000000000000000 RBX: ffff88003d4e1440 RCX: 0000000000001000
Sep 27 06:54:44 kernel: [53869.553005] RDX: 000000002cf3c000 RSI: ffff88003d012840 RDI: ffffffff81789d7e
Sep 27 06:54:44 kernel: [53869.553005] RBP: ffff88003ce8bbc0 R08: 0000000000000000 R09: ffff88003ce05048
Sep 27 06:54:44 kernel: [53869.553005] R10: 00000000013f4000 R11: 0000000000000002 R12: 0000000000000000
Sep 27 06:54:44 kernel: [53869.553005] R13: 0000000000000002 R14: ffff88003d012840 R15: 0000160000000000
Sep 27 06:54:44 kernel: [53869.553005] FS:  00007f19c7803740(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
Sep 27 06:54:44 kernel: [53869.553005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 27 06:54:44 kernel: [53869.553005] CR2: 0000000000000000 CR3: 0000000037cb1000 CR4: 00000000001406f0
Sep 27 06:54:44 kernel: [53869.553005] Stack:
Sep 27 06:54:44 kernel: [53869.553005]  ffffffff81032b39 ffff880037a98c40 0000000000000000 ffff88003becf280
Sep 27 06:54:44 kernel: [53869.553005]  ffff88003bf33000 0000000000000000 ffff88003ce8bc38 ffffffffa02b31c6
Sep 27 06:54:44 kernel: [53869.553005]  ffff880037a98c40 ffff88003d012840 0000000000000002 0000000000000000
Sep 27 06:54:44 kernel: [53869.553005] Call Trace:
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff81032b39>] ? nommu_map_sg+0x99/0xd0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffffa02b31c6>] ib_umem_get+0x3d6/0x470 [ib_core]
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffffa01cc329>] rxe_mem_init_user+0x49/0x270 [rdma_rxe]
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffffa01c793a>] ? rxe_add_index+0xca/0x100 [rdma_rxe]
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffffa01c995f>] rxe_reg_user_mr+0x9f/0x130 [rdma_rxe]
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffffa00419fe>] ib_uverbs_reg_mr+0x14e/0x2c0 [ib_uverbs]
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffffa003d3ab>] ib_uverbs_write+0x15b/0x3b0 [ib_uverbs]
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff811e92a6>] ? mem_cgroup_commit_charge+0x76/0xe0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff811af0a9>] ? page_add_new_anon_rmap+0x89/0xc0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff8117e6c9>] ? lru_cache_add_active_or_unevictable+0x39/0xc0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff811f0da8>] __vfs_write+0x28/0x120
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff811f1239>] ? rw_verify_area+0x49/0xb0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff811f1492>] vfs_write+0xb2/0x1b0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff811f27d6>] SyS_write+0x46/0xa0
Sep 27 06:54:44 kernel: [53869.553005]  [<ffffffff814f7d32>] entry_SYSCALL_64_fastpath+0x1a/0xa4

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/dma.c  | 17 +++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_dma.c | 17 +++++++++++++++++
 include/rdma/ib_verbs.h             | 23 ++++++++++++++++++++---
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/dma.c b/drivers/infiniband/sw/rdmavt/dma.c
index 33076a5..01f71ca 100644
--- a/drivers/infiniband/sw/rdmavt/dma.c
+++ b/drivers/infiniband/sw/rdmavt/dma.c
@@ -138,6 +138,21 @@ static void rvt_unmap_sg(struct ib_device *dev,
 	/* This is a stub, nothing to be done here */
 }
 
+static int rvt_map_sg_attrs(struct ib_device *dev, struct scatterlist *sgl,
+			    int nents, enum dma_data_direction direction,
+			    unsigned long attrs)
+{
+	return rvt_map_sg(dev, sgl, nents, direction);
+}
+
+static void rvt_unmap_sg_attrs(struct ib_device *dev,
+			       struct scatterlist *sg, int nents,
+			       enum dma_data_direction direction,
+			       unsigned long attrs)
+{
+	return rvt_unmap_sg(dev, sg, nents, direction);
+}
+
 static void rvt_sync_single_for_cpu(struct ib_device *dev, u64 addr,
 				    size_t size, enum dma_data_direction dir)
 {
@@ -177,6 +192,8 @@ struct ib_dma_mapping_ops rvt_default_dma_mapping_ops = {
 	.unmap_page = rvt_dma_unmap_page,
 	.map_sg = rvt_map_sg,
 	.unmap_sg = rvt_unmap_sg,
+	.map_sg_attrs = rvt_map_sg_attrs,
+	.unmap_sg_attrs = rvt_unmap_sg_attrs,
 	.sync_single_for_cpu = rvt_sync_single_for_cpu,
 	.sync_single_for_device = rvt_sync_single_for_device,
 	.alloc_coherent = rvt_dma_alloc_coherent,
diff --git a/drivers/infiniband/sw/rxe/rxe_dma.c b/drivers/infiniband/sw/rxe/rxe_dma.c
index 7634c1a..a0f8af5 100644
--- a/drivers/infiniband/sw/rxe/rxe_dma.c
+++ b/drivers/infiniband/sw/rxe/rxe_dma.c
@@ -117,6 +117,21 @@ static void rxe_unmap_sg(struct ib_device *dev,
 	WARN_ON(!valid_dma_direction(direction));
 }
 
+static int rxe_map_sg_attrs(struct ib_device *dev, struct scatterlist *sgl,
+			    int nents, enum dma_data_direction direction,
+			    unsigned long attrs)
+{
+	return rxe_map_sg(dev, sgl, nents, direction);
+}
+
+static void rxe_unmap_sg_attrs(struct ib_device *dev,
+			       struct scatterlist *sg, int nents,
+			       enum dma_data_direction direction,
+			       unsigned long attrs)
+{
+	rxe_unmap_sg(dev, sg, nents, direction);
+}
+
 static void rxe_sync_single_for_cpu(struct ib_device *dev,
 				    u64 addr,
 				    size_t size, enum dma_data_direction dir)
@@ -159,6 +174,8 @@ struct ib_dma_mapping_ops rxe_dma_mapping_ops = {
 	.unmap_page		= rxe_dma_unmap_page,
 	.map_sg			= rxe_map_sg,
 	.unmap_sg		= rxe_unmap_sg,
+	.map_sg_attrs		= rxe_map_sg_attrs,
+	.unmap_sg_attrs		= rxe_unmap_sg_attrs,
 	.sync_single_for_cpu	= rxe_sync_single_for_cpu,
 	.sync_single_for_device	= rxe_sync_single_for_device,
 	.alloc_coherent		= rxe_dma_alloc_coherent,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e1f9673..9e93565 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1739,6 +1739,14 @@ struct ib_dma_mapping_ops {
 	void		(*unmap_sg)(struct ib_device *dev,
 				    struct scatterlist *sg, int nents,
 				    enum dma_data_direction direction);
+	int		(*map_sg_attrs)(struct ib_device *dev,
+					struct scatterlist *sg, int nents,
+					enum dma_data_direction direction,
+					unsigned long attrs);
+	void		(*unmap_sg_attrs)(struct ib_device *dev,
+					  struct scatterlist *sg, int nents,
+					  enum dma_data_direction direction,
+					  unsigned long attrs);
 	void		(*sync_single_for_cpu)(struct ib_device *dev,
 					       u64 dma_handle,
 					       size_t size,
@@ -3000,8 +3008,12 @@ static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      enum dma_data_direction direction,
 				      unsigned long dma_attrs)
 {
-	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
-				dma_attrs);
+	if (dev->dma_ops)
+		return dev->dma_ops->map_sg_attrs(dev, sg, nents, direction,
+						  dma_attrs);
+	else
+		return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
+					dma_attrs);
 }
 
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
@@ -3009,7 +3021,12 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 					 enum dma_data_direction direction,
 					 unsigned long dma_attrs)
 {
-	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, dma_attrs);
+	if (dev->dma_ops)
+		return dev->dma_ops->unmap_sg_attrs(dev, sg, nents, direction,
+						  dma_attrs);
+	else
+		dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction,
+				   dma_attrs);
 }
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
