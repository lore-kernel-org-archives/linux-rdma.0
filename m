From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 43/44] Makefile
Date: Fri, 01 Jul 2011 08:19:04 -0500
Message-ID: <20110701132202.776163883@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=patch43
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makefile

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/hw/rxe/Makefile |   46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

Index: infiniband/drivers/infiniband/hw/rxe/Makefile
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/Makefile
@@ -0,0 +1,46 @@
+
+EXTRA_PRE_CFLAGS := -D__KERNEL__ $(BACKPORTS) $(DEBUG) \
+	-I/usr/src/ofa_kernel/include
+
+obj-m += ib_rxe.o ib_rxe_net.o ib_rxe_sample.o
+
+ib_rxe-y := \
+	rxe.o \
+	rxe_comp.o \
+	rxe_req.o \
+	rxe_resp.o \
+	rxe_recv.o \
+	rxe_pool.o \
+	rxe_queue.o \
+	rxe_verbs.o \
+	rxe_av.o \
+	rxe_srq.o \
+	rxe_qp.o \
+	rxe_cq.o \
+	rxe_mr.o \
+	rxe_dma.o \
+	rxe_opcode.o \
+	rxe_mmap.o \
+	rxe_arbiter.o \
+	rxe_sb8.o \
+	rxe_mcast.o \
+	rxe_task.o
+
+ib_rxe_net-y := \
+	rxe_net.o \
+	rxe_net_sysfs.o
+
+ib_rxe_sample-y := \
+	rxe_sample.o
+
+# Generation of SB8 tables for Ethernet CRC32
+hostprogs-y := gen_sb8tables
+clean-files := sb8_tables.h
+
+$(obj)/rxe_sb8.o: $(obj)/sb8_tables.h
+
+quiet_cmd_sb8 = GEN $@
+	cmd_sb8 = $< --flop --swip --flip --swap --poly=0xedb88320 > $@
+
+$(obj)/sb8_tables.h: $(obj)/gen_sb8tables
+	$(call cmd,sb8)

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
