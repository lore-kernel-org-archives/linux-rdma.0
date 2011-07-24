From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch v2 36/37] add Makefile
Date: Sun, 24 Jul 2011 14:43:36 -0500
Message-ID: <20110724201229.915626495@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=add-Makefile.c
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Makefile

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/hw/rxe/Makefile |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: infiniband/drivers/infiniband/hw/rxe/Makefile
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/Makefile
@@ -0,0 +1,30 @@
+obj-$(CONFIG_INFINIBAND_RXE) += ib_rxe.o ib_rxe_net.o ib_rxe_sample.o
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
+	rxe_icrc.o \
+	rxe_mcast.o \
+	rxe_task.o
+
+ib_rxe_net-y := \
+	rxe_net.o \
+	rxe_net_sysfs.o
+
+ib_rxe_sample-y := \
+	rxe_sample.o


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
