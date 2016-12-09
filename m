From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] IB/vmw_pvrdma: Update file paths
Date: Fri, 9 Dec 2016 09:10:04 -0800
Message-ID: <551b2a65ebd74efbbd165f7d7ce4f17b2c2236db.1481303342.git.aditr@vmware.com>
References: <cover.1481303342.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1481303342.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move the files to the right path to reflect the module name.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig                         |    2 +-
 drivers/infiniband/hw/Makefile                     |    2 +-
 drivers/infiniband/hw/pvrdma/Kconfig               |    7 -
 drivers/infiniband/hw/pvrdma/Makefile              |    3 -
 drivers/infiniband/hw/pvrdma/pvrdma.h              |  474 --------
 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c          |  119 --
 drivers/infiniband/hw/pvrdma/pvrdma_cq.c           |  425 -------
 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h      |  586 ----------
 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c     |  127 --
 drivers/infiniband/hw/pvrdma/pvrdma_main.c         | 1211 --------------------
 drivers/infiniband/hw/pvrdma/pvrdma_misc.c         |  304 -----
 drivers/infiniband/hw/pvrdma/pvrdma_mr.c           |  334 ------
 drivers/infiniband/hw/pvrdma/pvrdma_qp.c           |  972 ----------------
 drivers/infiniband/hw/pvrdma/pvrdma_ring.h         |  131 ---
 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c        |  577 ----------
 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h        |  435 -------
 drivers/infiniband/hw/vmw_pvrdma/Kconfig           |    7 +
 drivers/infiniband/hw/vmw_pvrdma/Makefile          |    3 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |  474 ++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c      |  119 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c       |  425 +++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h  |  586 ++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c |  127 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     | 1211 ++++++++++++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c     |  304 +++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c       |  334 ++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |  972 ++++++++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h     |  131 +++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |  577 ++++++++++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h    |  435 +++++++
 30 files changed, 5707 insertions(+), 5707 deletions(-)
 delete mode 100644 drivers/infiniband/hw/pvrdma/Kconfig
 delete mode 100644 drivers/infiniband/hw/pvrdma/Makefile
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cq.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_main.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_misc.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_mr.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_qp.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ring.h
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
 delete mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_verbs.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/Makefile
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index fd20eba..6709173 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -73,7 +73,7 @@ source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
-source "drivers/infiniband/hw/pvrdma/Kconfig"
+source "drivers/infiniband/hw/vmw_pvrdma/Kconfig"
 source "drivers/infiniband/hw/usnic/Kconfig"
 source "drivers/infiniband/hw/hns/Kconfig"
 
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index a40a57c..a89a24c 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
-obj-$(CONFIG_INFINIBAND_PVRDMA)		+= pvrdma/
+obj-$(CONFIG_INFINIBAND_PVRDMA)		+= vmw_pvrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
diff --git a/drivers/infiniband/hw/pvrdma/Kconfig b/drivers/infiniband/hw/pvrdma/Kconfig
deleted file mode 100644
index b345679..0000000
--- a/drivers/infiniband/hw/pvrdma/Kconfig
+++ /dev/null
@@ -1,7 +0,0 @@
-config INFINIBAND_PVRDMA
-	tristate "VMware Paravirtualized RDMA Driver"
-	depends on NETDEVICES && ETHERNET && PCI && INET && VMXNET3
-	---help---
-	  This driver provides low-level support for VMware Paravirtual
-	  RDMA adapter. It interacts with the VMXNet3 driver to provide
-	  Ethernet capabilities.
diff --git a/drivers/infiniband/hw/pvrdma/Makefile b/drivers/infiniband/hw/pvrdma/Makefile
deleted file mode 100644
index 6ef4b98..0000000
--- a/drivers/infiniband/hw/pvrdma/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_INFINIBAND_PVRDMA) += vmw_pvrdma.o
-
-vmw_pvrdma-y := pvrdma_cmd.o pvrdma_cq.o pvrdma_doorbell.o pvrdma_main.o pvrdma_misc.o pvrdma_mr.o pvrdma_qp.o pvrdma_verbs.o
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma.h b/drivers/infiniband/hw/pvrdma/pvrdma.h
deleted file mode 100644
index deb6792..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma.h
+++ /dev/null
@@ -1,474 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef __PVRDMA_H__
-#define __PVRDMA_H__
-
-#include <linux/compiler.h>
-#include <linux/interrupt.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/pci.h>
-#include <linux/semaphore.h>
-#include <linux/workqueue.h>
-#include <rdma/ib_umem.h>
-#include <rdma/ib_verbs.h>
-#include <rdma/pvrdma-abi.h>
-
-#include "pvrdma_ring.h"
-#include "pvrdma_dev_api.h"
-#include "pvrdma_verbs.h"
-
-/* NOT the same as BIT_MASK(). */
-#define PVRDMA_MASK(n) ((n << 1) - 1)
-
-/*
- * VMware PVRDMA PCI device id.
- */
-#define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
-
-struct pvrdma_dev;
-
-struct pvrdma_page_dir {
-	dma_addr_t dir_dma;
-	u64 *dir;
-	int ntables;
-	u64 **tables;
-	u64 npages;
-	void **pages;
-};
-
-struct pvrdma_cq {
-	struct ib_cq ibcq;
-	int offset;
-	spinlock_t cq_lock; /* Poll lock. */
-	struct pvrdma_uar_map *uar;
-	struct ib_umem *umem;
-	struct pvrdma_ring_state *ring_state;
-	struct pvrdma_page_dir pdir;
-	u32 cq_handle;
-	bool is_kernel;
-	atomic_t refcnt;
-	wait_queue_head_t wait;
-};
-
-struct pvrdma_id_table {
-	u32 last;
-	u32 top;
-	u32 max;
-	u32 mask;
-	spinlock_t lock; /* Table lock. */
-	unsigned long *table;
-};
-
-struct pvrdma_uar_map {
-	unsigned long pfn;
-	void __iomem *map;
-	int index;
-};
-
-struct pvrdma_uar_table {
-	struct pvrdma_id_table tbl;
-	int size;
-};
-
-struct pvrdma_ucontext {
-	struct ib_ucontext ibucontext;
-	struct pvrdma_dev *dev;
-	struct pvrdma_uar_map uar;
-	u64 ctx_handle;
-};
-
-struct pvrdma_pd {
-	struct ib_pd ibpd;
-	u32 pdn;
-	u32 pd_handle;
-	int privileged;
-};
-
-struct pvrdma_mr {
-	u32 mr_handle;
-	u64 iova;
-	u64 size;
-};
-
-struct pvrdma_user_mr {
-	struct ib_mr ibmr;
-	struct ib_umem *umem;
-	struct pvrdma_mr mmr;
-	struct pvrdma_page_dir pdir;
-	u64 *pages;
-	u32 npages;
-	u32 max_pages;
-	u32 page_shift;
-};
-
-struct pvrdma_wq {
-	struct pvrdma_ring *ring;
-	spinlock_t lock; /* Work queue lock. */
-	int wqe_cnt;
-	int wqe_size;
-	int max_sg;
-	int offset;
-};
-
-struct pvrdma_ah {
-	struct ib_ah ibah;
-	struct pvrdma_av av;
-};
-
-struct pvrdma_qp {
-	struct ib_qp ibqp;
-	u32 qp_handle;
-	u32 qkey;
-	struct pvrdma_wq sq;
-	struct pvrdma_wq rq;
-	struct ib_umem *rumem;
-	struct ib_umem *sumem;
-	struct pvrdma_page_dir pdir;
-	int npages;
-	int npages_send;
-	int npages_recv;
-	u32 flags;
-	u8 port;
-	u8 state;
-	bool is_kernel;
-	struct mutex mutex; /* QP state mutex. */
-	atomic_t refcnt;
-	wait_queue_head_t wait;
-};
-
-struct pvrdma_dev {
-	/* PCI device-related information. */
-	struct ib_device ib_dev;
-	struct pci_dev *pdev;
-	void __iomem *regs;
-	struct pvrdma_device_shared_region *dsr; /* Shared region pointer */
-	dma_addr_t dsrbase; /* Shared region base address */
-	void *cmd_slot;
-	void *resp_slot;
-	unsigned long flags;
-	struct list_head device_link;
-
-	/* Locking and interrupt information. */
-	spinlock_t cmd_lock; /* Command lock. */
-	struct semaphore cmd_sema;
-	struct completion cmd_done;
-	struct {
-		enum pvrdma_intr_type type; /* Intr type */
-		struct msix_entry msix_entry[PVRDMA_MAX_INTERRUPTS];
-		irq_handler_t handler[PVRDMA_MAX_INTERRUPTS];
-		u8 enabled[PVRDMA_MAX_INTERRUPTS];
-		u8 size;
-	} intr;
-
-	/* RDMA-related device information. */
-	union ib_gid *sgid_tbl;
-	struct pvrdma_ring_state *async_ring_state;
-	struct pvrdma_page_dir async_pdir;
-	struct pvrdma_ring_state *cq_ring_state;
-	struct pvrdma_page_dir cq_pdir;
-	struct pvrdma_cq **cq_tbl;
-	spinlock_t cq_tbl_lock;
-	struct pvrdma_qp **qp_tbl;
-	spinlock_t qp_tbl_lock;
-	struct pvrdma_uar_table uar_table;
-	struct pvrdma_uar_map driver_uar;
-	__be64 sys_image_guid;
-	spinlock_t desc_lock; /* Device modification lock. */
-	u32 port_cap_mask;
-	struct mutex port_mutex; /* Port modification mutex. */
-	bool ib_active;
-	atomic_t num_qps;
-	atomic_t num_cqs;
-	atomic_t num_pds;
-	atomic_t num_ahs;
-
-	/* Network device information. */
-	struct net_device *netdev;
-	struct notifier_block nb_netdev;
-};
-
-struct pvrdma_netdevice_work {
-	struct work_struct work;
-	struct net_device *event_netdev;
-	unsigned long event;
-};
-
-static inline struct pvrdma_dev *to_vdev(struct ib_device *ibdev)
-{
-	return container_of(ibdev, struct pvrdma_dev, ib_dev);
-}
-
-static inline struct
-pvrdma_ucontext *to_vucontext(struct ib_ucontext *ibucontext)
-{
-	return container_of(ibucontext, struct pvrdma_ucontext, ibucontext);
-}
-
-static inline struct pvrdma_pd *to_vpd(struct ib_pd *ibpd)
-{
-	return container_of(ibpd, struct pvrdma_pd, ibpd);
-}
-
-static inline struct pvrdma_cq *to_vcq(struct ib_cq *ibcq)
-{
-	return container_of(ibcq, struct pvrdma_cq, ibcq);
-}
-
-static inline struct pvrdma_user_mr *to_vmr(struct ib_mr *ibmr)
-{
-	return container_of(ibmr, struct pvrdma_user_mr, ibmr);
-}
-
-static inline struct pvrdma_qp *to_vqp(struct ib_qp *ibqp)
-{
-	return container_of(ibqp, struct pvrdma_qp, ibqp);
-}
-
-static inline struct pvrdma_ah *to_vah(struct ib_ah *ibah)
-{
-	return container_of(ibah, struct pvrdma_ah, ibah);
-}
-
-static inline void pvrdma_write_reg(struct pvrdma_dev *dev, u32 reg, u32 val)
-{
-	writel(cpu_to_le32(val), dev->regs + reg);
-}
-
-static inline u32 pvrdma_read_reg(struct pvrdma_dev *dev, u32 reg)
-{
-	return le32_to_cpu(readl(dev->regs + reg));
-}
-
-static inline void pvrdma_write_uar_cq(struct pvrdma_dev *dev, u32 val)
-{
-	writel(cpu_to_le32(val), dev->driver_uar.map + PVRDMA_UAR_CQ_OFFSET);
-}
-
-static inline void pvrdma_write_uar_qp(struct pvrdma_dev *dev, u32 val)
-{
-	writel(cpu_to_le32(val), dev->driver_uar.map + PVRDMA_UAR_QP_OFFSET);
-}
-
-static inline void *pvrdma_page_dir_get_ptr(struct pvrdma_page_dir *pdir,
-					    u64 offset)
-{
-	return pdir->pages[offset / PAGE_SIZE] + (offset % PAGE_SIZE);
-}
-
-static inline enum pvrdma_mtu ib_mtu_to_pvrdma(enum ib_mtu mtu)
-{
-	return (enum pvrdma_mtu)mtu;
-}
-
-static inline enum ib_mtu pvrdma_mtu_to_ib(enum pvrdma_mtu mtu)
-{
-	return (enum ib_mtu)mtu;
-}
-
-static inline enum pvrdma_port_state ib_port_state_to_pvrdma(
-					enum ib_port_state state)
-{
-	return (enum pvrdma_port_state)state;
-}
-
-static inline enum ib_port_state pvrdma_port_state_to_ib(
-					enum pvrdma_port_state state)
-{
-	return (enum ib_port_state)state;
-}
-
-static inline int ib_port_cap_flags_to_pvrdma(int flags)
-{
-	return flags & PVRDMA_MASK(PVRDMA_PORT_CAP_FLAGS_MAX);
-}
-
-static inline int pvrdma_port_cap_flags_to_ib(int flags)
-{
-	return flags;
-}
-
-static inline enum pvrdma_port_width ib_port_width_to_pvrdma(
-					enum ib_port_width width)
-{
-	return (enum pvrdma_port_width)width;
-}
-
-static inline enum ib_port_width pvrdma_port_width_to_ib(
-					enum pvrdma_port_width width)
-{
-	return (enum ib_port_width)width;
-}
-
-static inline enum pvrdma_port_speed ib_port_speed_to_pvrdma(
-					enum ib_port_speed speed)
-{
-	return (enum pvrdma_port_speed)speed;
-}
-
-static inline enum ib_port_speed pvrdma_port_speed_to_ib(
-					enum pvrdma_port_speed speed)
-{
-	return (enum ib_port_speed)speed;
-}
-
-static inline int pvrdma_qp_attr_mask_to_ib(int attr_mask)
-{
-	return attr_mask;
-}
-
-static inline int ib_qp_attr_mask_to_pvrdma(int attr_mask)
-{
-	return attr_mask & PVRDMA_MASK(PVRDMA_QP_ATTR_MASK_MAX);
-}
-
-static inline enum pvrdma_mig_state ib_mig_state_to_pvrdma(
-					enum ib_mig_state state)
-{
-	return (enum pvrdma_mig_state)state;
-}
-
-static inline enum ib_mig_state pvrdma_mig_state_to_ib(
-					enum pvrdma_mig_state state)
-{
-	return (enum ib_mig_state)state;
-}
-
-static inline int ib_access_flags_to_pvrdma(int flags)
-{
-	return flags;
-}
-
-static inline int pvrdma_access_flags_to_ib(int flags)
-{
-	return flags & PVRDMA_MASK(PVRDMA_ACCESS_FLAGS_MAX);
-}
-
-static inline enum pvrdma_qp_type ib_qp_type_to_pvrdma(enum ib_qp_type type)
-{
-	return (enum pvrdma_qp_type)type;
-}
-
-static inline enum ib_qp_type pvrdma_qp_type_to_ib(enum pvrdma_qp_type type)
-{
-	return (enum ib_qp_type)type;
-}
-
-static inline enum pvrdma_qp_state ib_qp_state_to_pvrdma(enum ib_qp_state state)
-{
-	return (enum pvrdma_qp_state)state;
-}
-
-static inline enum ib_qp_state pvrdma_qp_state_to_ib(enum pvrdma_qp_state state)
-{
-	return (enum ib_qp_state)state;
-}
-
-static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_opcode op)
-{
-	return (enum pvrdma_wr_opcode)op;
-}
-
-static inline enum ib_wc_status pvrdma_wc_status_to_ib(
-					enum pvrdma_wc_status status)
-{
-	return (enum ib_wc_status)status;
-}
-
-static inline int pvrdma_wc_opcode_to_ib(int opcode)
-{
-	return opcode;
-}
-
-static inline int pvrdma_wc_flags_to_ib(int flags)
-{
-	return flags;
-}
-
-static inline int ib_send_flags_to_pvrdma(int flags)
-{
-	return flags & PVRDMA_MASK(PVRDMA_SEND_FLAGS_MAX);
-}
-
-void pvrdma_qp_cap_to_ib(struct ib_qp_cap *dst,
-			 const struct pvrdma_qp_cap *src);
-void ib_qp_cap_to_pvrdma(struct pvrdma_qp_cap *dst,
-			 const struct ib_qp_cap *src);
-void pvrdma_gid_to_ib(union ib_gid *dst, const union pvrdma_gid *src);
-void ib_gid_to_pvrdma(union pvrdma_gid *dst, const union ib_gid *src);
-void pvrdma_global_route_to_ib(struct ib_global_route *dst,
-			       const struct pvrdma_global_route *src);
-void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
-			       const struct ib_global_route *src);
-void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
-			  const struct pvrdma_ah_attr *src);
-void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
-			  const struct ib_ah_attr *src);
-
-int pvrdma_uar_table_init(struct pvrdma_dev *dev);
-void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev);
-
-int pvrdma_uar_alloc(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar);
-void pvrdma_uar_free(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar);
-
-void _pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq);
-
-int pvrdma_page_dir_init(struct pvrdma_dev *dev, struct pvrdma_page_dir *pdir,
-			 u64 npages, bool alloc_pages);
-void pvrdma_page_dir_cleanup(struct pvrdma_dev *dev,
-			     struct pvrdma_page_dir *pdir);
-int pvrdma_page_dir_insert_dma(struct pvrdma_page_dir *pdir, u64 idx,
-			       dma_addr_t daddr);
-int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
-				struct ib_umem *umem, u64 offset);
-dma_addr_t pvrdma_page_dir_get_dma(struct pvrdma_page_dir *pdir, u64 idx);
-int pvrdma_page_dir_insert_page_list(struct pvrdma_page_dir *pdir,
-				     u64 *page_list, int num_pages);
-
-int pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
-		    union pvrdma_cmd_resp *rsp, unsigned resp_code);
-
-#endif /* __PVRDMA_H__ */
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c b/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
deleted file mode 100644
index 4a78c53..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <linux/list.h>
-
-#include "pvrdma.h"
-
-#define PVRDMA_CMD_TIMEOUT	10000 /* ms */
-
-static inline int pvrdma_cmd_recv(struct pvrdma_dev *dev,
-				  union pvrdma_cmd_resp *resp,
-				  unsigned resp_code)
-{
-	int err;
-
-	dev_dbg(&dev->pdev->dev, "receive response from device\n");
-
-	err = wait_for_completion_interruptible_timeout(&dev->cmd_done,
-			msecs_to_jiffies(PVRDMA_CMD_TIMEOUT));
-	if (err == 0 || err == -ERESTARTSYS) {
-		dev_warn(&dev->pdev->dev,
-			 "completion timeout or interrupted\n");
-		return -ETIMEDOUT;
-	}
-
-	spin_lock(&dev->cmd_lock);
-	memcpy(resp, dev->resp_slot, sizeof(*resp));
-	spin_unlock(&dev->cmd_lock);
-
-	if (resp->hdr.ack != resp_code) {
-		dev_warn(&dev->pdev->dev,
-			 "unknown response %#x expected %#x\n",
-			 resp->hdr.ack, resp_code);
-		return -EFAULT;
-	}
-
-	return 0;
-}
-
-int
-pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
-		union pvrdma_cmd_resp *resp, unsigned resp_code)
-{
-	int err;
-
-	dev_dbg(&dev->pdev->dev, "post request to device\n");
-
-	/* Serializiation */
-	down(&dev->cmd_sema);
-
-	BUILD_BUG_ON(sizeof(union pvrdma_cmd_req) !=
-		     sizeof(struct pvrdma_cmd_modify_qp));
-
-	spin_lock(&dev->cmd_lock);
-	memcpy(dev->cmd_slot, req, sizeof(*req));
-	spin_unlock(&dev->cmd_lock);
-
-	init_completion(&dev->cmd_done);
-	pvrdma_write_reg(dev, PVRDMA_REG_REQUEST, 0);
-
-	/* Make sure the request is written before reading status. */
-	mb();
-
-	err = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
-	if (err == 0) {
-		if (resp != NULL)
-			err = pvrdma_cmd_recv(dev, resp, resp_code);
-	} else {
-		dev_warn(&dev->pdev->dev,
-			 "failed to write request error reg: %d\n", err);
-		err = -EFAULT;
-	}
-
-	up(&dev->cmd_sema);
-
-	return err;
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/pvrdma/pvrdma_cq.c
deleted file mode 100644
index e429ca5..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_cq.c
+++ /dev/null
@@ -1,425 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <asm/page.h>
-#include <linux/io.h>
-#include <linux/wait.h>
-#include <rdma/ib_addr.h>
-#include <rdma/ib_smi.h>
-#include <rdma/ib_user_verbs.h>
-
-#include "pvrdma.h"
-
-/**
- * pvrdma_req_notify_cq - request notification for a completion queue
- * @ibcq: the completion queue
- * @notify_flags: notification flags
- *
- * @return: 0 for success.
- */
-int pvrdma_req_notify_cq(struct ib_cq *ibcq,
-			 enum ib_cq_notify_flags notify_flags)
-{
-	struct pvrdma_dev *dev = to_vdev(ibcq->device);
-	struct pvrdma_cq *cq = to_vcq(ibcq);
-	u32 val = cq->cq_handle;
-
-	val |= (notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
-		PVRDMA_UAR_CQ_ARM_SOL : PVRDMA_UAR_CQ_ARM;
-
-	pvrdma_write_uar_cq(dev, val);
-
-	return 0;
-}
-
-/**
- * pvrdma_create_cq - create completion queue
- * @ibdev: the device
- * @attr: completion queue attributes
- * @context: user context
- * @udata: user data
- *
- * @return: ib_cq completion queue pointer on success,
- *          otherwise returns negative errno.
- */
-struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
-			       const struct ib_cq_init_attr *attr,
-			       struct ib_ucontext *context,
-			       struct ib_udata *udata)
-{
-	int entries = attr->cqe;
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-	struct pvrdma_cq *cq;
-	int ret;
-	int npages;
-	unsigned long flags;
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_cq *cmd = &req.create_cq;
-	struct pvrdma_cmd_create_cq_resp *resp = &rsp.create_cq_resp;
-	struct pvrdma_create_cq ucmd;
-
-	BUILD_BUG_ON(sizeof(struct pvrdma_cqe) != 64);
-
-	entries = roundup_pow_of_two(entries);
-	if (entries < 1 || entries > dev->dsr->caps.max_cqe)
-		return ERR_PTR(-EINVAL);
-
-	if (!atomic_add_unless(&dev->num_cqs, 1, dev->dsr->caps.max_cq))
-		return ERR_PTR(-ENOMEM);
-
-	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
-	if (!cq) {
-		atomic_dec(&dev->num_cqs);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	cq->ibcq.cqe = entries;
-
-	if (context) {
-		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
-			ret = -EFAULT;
-			goto err_cq;
-		}
-
-		cq->umem = ib_umem_get(context, ucmd.buf_addr, ucmd.buf_size,
-				       IB_ACCESS_LOCAL_WRITE, 1);
-		if (IS_ERR(cq->umem)) {
-			ret = PTR_ERR(cq->umem);
-			goto err_cq;
-		}
-
-		npages = ib_umem_page_count(cq->umem);
-	} else {
-		cq->is_kernel = true;
-
-		/* One extra page for shared ring state */
-		npages = 1 + (entries * sizeof(struct pvrdma_cqe) +
-			      PAGE_SIZE - 1) / PAGE_SIZE;
-
-		/* Skip header page. */
-		cq->offset = PAGE_SIZE;
-	}
-
-	if (npages < 0 || npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
-		dev_warn(&dev->pdev->dev,
-			 "overflow pages in completion queue\n");
-		ret = -EINVAL;
-		goto err_umem;
-	}
-
-	ret = pvrdma_page_dir_init(dev, &cq->pdir, npages, cq->is_kernel);
-	if (ret) {
-		dev_warn(&dev->pdev->dev,
-			 "could not allocate page directory\n");
-		goto err_umem;
-	}
-
-	/* Ring state is always the first page. Set in library for user cq. */
-	if (cq->is_kernel)
-		cq->ring_state = cq->pdir.pages[0];
-	else
-		pvrdma_page_dir_insert_umem(&cq->pdir, cq->umem, 0);
-
-	atomic_set(&cq->refcnt, 1);
-	init_waitqueue_head(&cq->wait);
-	spin_lock_init(&cq->cq_lock);
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_CQ;
-	cmd->nchunks = npages;
-	cmd->ctx_handle = (context) ?
-		(u64)to_vucontext(context)->ctx_handle : 0;
-	cmd->cqe = entries;
-	cmd->pdir_dma = cq->pdir.dir_dma;
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_CQ_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not create completion queue, error: %d\n", ret);
-		goto err_page_dir;
-	}
-
-	cq->ibcq.cqe = resp->cqe;
-	cq->cq_handle = resp->cq_handle;
-	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
-	dev->cq_tbl[cq->cq_handle % dev->dsr->caps.max_cq] = cq;
-	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
-
-	if (context) {
-		cq->uar = &(to_vucontext(context)->uar);
-
-		/* Copy udata back. */
-		if (ib_copy_to_udata(udata, &cq->cq_handle, sizeof(__u32))) {
-			dev_warn(&dev->pdev->dev,
-				 "failed to copy back udata\n");
-			pvrdma_destroy_cq(&cq->ibcq);
-			return ERR_PTR(-EINVAL);
-		}
-	}
-
-	return &cq->ibcq;
-
-err_page_dir:
-	pvrdma_page_dir_cleanup(dev, &cq->pdir);
-err_umem:
-	if (context)
-		ib_umem_release(cq->umem);
-err_cq:
-	atomic_dec(&dev->num_cqs);
-	kfree(cq);
-
-	return ERR_PTR(ret);
-}
-
-static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
-{
-	atomic_dec(&cq->refcnt);
-	wait_event(cq->wait, !atomic_read(&cq->refcnt));
-
-	if (!cq->is_kernel)
-		ib_umem_release(cq->umem);
-
-	pvrdma_page_dir_cleanup(dev, &cq->pdir);
-	kfree(cq);
-}
-
-/**
- * pvrdma_destroy_cq - destroy completion queue
- * @cq: the completion queue to destroy.
- *
- * @return: 0 for success.
- */
-int pvrdma_destroy_cq(struct ib_cq *cq)
-{
-	struct pvrdma_cq *vcq = to_vcq(cq);
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_destroy_cq *cmd = &req.destroy_cq;
-	struct pvrdma_dev *dev = to_vdev(cq->device);
-	unsigned long flags;
-	int ret;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_CQ;
-	cmd->cq_handle = vcq->cq_handle;
-
-	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
-	if (ret < 0)
-		dev_warn(&dev->pdev->dev,
-			 "could not destroy completion queue, error: %d\n",
-			 ret);
-
-	/* free cq's resources */
-	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
-	dev->cq_tbl[vcq->cq_handle] = NULL;
-	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
-
-	pvrdma_free_cq(dev, vcq);
-	atomic_dec(&dev->num_cqs);
-
-	return ret;
-}
-
-/**
- * pvrdma_modify_cq - modify the CQ moderation parameters
- * @ibcq: the CQ to modify
- * @cq_count: number of CQEs that will trigger an event
- * @cq_period: max period of time in usec before triggering an event
- *
- * @return: -EOPNOTSUPP as CQ resize is not supported.
- */
-int pvrdma_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline struct pvrdma_cqe *get_cqe(struct pvrdma_cq *cq, int i)
-{
-	return (struct pvrdma_cqe *)pvrdma_page_dir_get_ptr(
-					&cq->pdir,
-					cq->offset +
-					sizeof(struct pvrdma_cqe) * i);
-}
-
-void _pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq)
-{
-	int head;
-	int has_data;
-
-	if (!cq->is_kernel)
-		return;
-
-	/* Lock held */
-	has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
-					    cq->ibcq.cqe, &head);
-	if (unlikely(has_data > 0)) {
-		int items;
-		int curr;
-		int tail = pvrdma_idx(&cq->ring_state->rx.prod_tail,
-				      cq->ibcq.cqe);
-		struct pvrdma_cqe *cqe;
-		struct pvrdma_cqe *curr_cqe;
-
-		items = (tail > head) ? (tail - head) :
-			(cq->ibcq.cqe - head + tail);
-		curr = --tail;
-		while (items-- > 0) {
-			if (curr < 0)
-				curr = cq->ibcq.cqe - 1;
-			if (tail < 0)
-				tail = cq->ibcq.cqe - 1;
-			curr_cqe = get_cqe(cq, curr);
-			if ((curr_cqe->qp & 0xFFFF) != qp->qp_handle) {
-				if (curr != tail) {
-					cqe = get_cqe(cq, tail);
-					*cqe = *curr_cqe;
-				}
-				tail--;
-			} else {
-				pvrdma_idx_ring_inc(
-					&cq->ring_state->rx.cons_head,
-					cq->ibcq.cqe);
-			}
-			curr--;
-		}
-	}
-}
-
-static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
-			   struct ib_wc *wc)
-{
-	struct pvrdma_dev *dev = to_vdev(cq->ibcq.device);
-	int has_data;
-	unsigned int head;
-	bool tried = false;
-	struct pvrdma_cqe *cqe;
-
-retry:
-	has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
-					    cq->ibcq.cqe, &head);
-	if (has_data == 0) {
-		if (tried)
-			return -EAGAIN;
-
-		pvrdma_write_uar_cq(dev, cq->cq_handle | PVRDMA_UAR_CQ_POLL);
-
-		tried = true;
-		goto retry;
-	} else if (has_data == PVRDMA_INVALID_IDX) {
-		dev_err(&dev->pdev->dev, "CQ ring state invalid\n");
-		return -EAGAIN;
-	}
-
-	cqe = get_cqe(cq, head);
-
-	/* Ensure cqe is valid. */
-	rmb();
-	if (dev->qp_tbl[cqe->qp & 0xffff])
-		*cur_qp = (struct pvrdma_qp *)dev->qp_tbl[cqe->qp & 0xffff];
-	else
-		return -EAGAIN;
-
-	wc->opcode = pvrdma_wc_opcode_to_ib(cqe->opcode);
-	wc->status = pvrdma_wc_status_to_ib(cqe->status);
-	wc->wr_id = cqe->wr_id;
-	wc->qp = &(*cur_qp)->ibqp;
-	wc->byte_len = cqe->byte_len;
-	wc->ex.imm_data = cqe->imm_data;
-	wc->src_qp = cqe->src_qp;
-	wc->wc_flags = pvrdma_wc_flags_to_ib(cqe->wc_flags);
-	wc->pkey_index = cqe->pkey_index;
-	wc->slid = cqe->slid;
-	wc->sl = cqe->sl;
-	wc->dlid_path_bits = cqe->dlid_path_bits;
-	wc->port_num = cqe->port_num;
-	wc->vendor_err = 0;
-
-	/* Update shared ring state */
-	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq->ibcq.cqe);
-
-	return 0;
-}
-
-/**
- * pvrdma_poll_cq - poll for work completion queue entries
- * @ibcq: completion queue
- * @num_entries: the maximum number of entries
- * @entry: pointer to work completion array
- *
- * @return: number of polled completion entries
- */
-int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
-{
-	struct pvrdma_cq *cq = to_vcq(ibcq);
-	struct pvrdma_qp *cur_qp = NULL;
-	unsigned long flags;
-	int npolled;
-
-	if (num_entries < 1 || wc == NULL)
-		return 0;
-
-	spin_lock_irqsave(&cq->cq_lock, flags);
-	for (npolled = 0; npolled < num_entries; ++npolled) {
-		if (pvrdma_poll_one(cq, &cur_qp, wc + npolled))
-			break;
-	}
-
-	spin_unlock_irqrestore(&cq->cq_lock, flags);
-
-	/* Ensure we do not return errors from poll_cq */
-	return npolled;
-}
-
-/**
- * pvrdma_resize_cq - resize CQ
- * @ibcq: the completion queue
- * @entries: CQ entries
- * @udata: user data
- *
- * @return: -EOPNOTSUPP as CQ resize is not supported.
- */
-int pvrdma_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
-{
-	return -EOPNOTSUPP;
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
deleted file mode 100644
index c067686..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
+++ /dev/null
@@ -1,586 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef __PVRDMA_DEV_API_H__
-#define __PVRDMA_DEV_API_H__
-
-#include <linux/types.h>
-
-#include "pvrdma_verbs.h"
-
-#define PVRDMA_VERSION			17
-#define PVRDMA_BOARD_ID			1
-#define PVRDMA_REV_ID			1
-
-/*
- * Masks and accessors for page directory, which is a two-level lookup:
- * page directory -> page table -> page. Only one directory for now, but we
- * could expand that easily. 9 bits for tables, 9 bits for pages, gives one
- * gigabyte for memory regions and so forth.
- */
-
-#define PVRDMA_PDIR_SHIFT		18
-#define PVRDMA_PTABLE_SHIFT		9
-#define PVRDMA_PAGE_DIR_DIR(x)		(((x) >> PVRDMA_PDIR_SHIFT) & 0x1)
-#define PVRDMA_PAGE_DIR_TABLE(x)	(((x) >> PVRDMA_PTABLE_SHIFT) & 0x1ff)
-#define PVRDMA_PAGE_DIR_PAGE(x)		((x) & 0x1ff)
-#define PVRDMA_PAGE_DIR_MAX_PAGES	(1 * 512 * 512)
-#define PVRDMA_MAX_FAST_REG_PAGES	128
-
-/*
- * Max MSI-X vectors.
- */
-
-#define PVRDMA_MAX_INTERRUPTS	3
-
-/* Register offsets within PCI resource on BAR1. */
-#define PVRDMA_REG_VERSION	0x00	/* R: Version of device. */
-#define PVRDMA_REG_DSRLOW	0x04	/* W: Device shared region low PA. */
-#define PVRDMA_REG_DSRHIGH	0x08	/* W: Device shared region high PA. */
-#define PVRDMA_REG_CTL		0x0c	/* W: PVRDMA_DEVICE_CTL */
-#define PVRDMA_REG_REQUEST	0x10	/* W: Indicate device request. */
-#define PVRDMA_REG_ERR		0x14	/* R: Device error. */
-#define PVRDMA_REG_ICR		0x18	/* R: Interrupt cause. */
-#define PVRDMA_REG_IMR		0x1c	/* R/W: Interrupt mask. */
-#define PVRDMA_REG_MACL		0x20	/* R/W: MAC address low. */
-#define PVRDMA_REG_MACH		0x24	/* R/W: MAC address high. */
-
-/* Object flags. */
-#define PVRDMA_CQ_FLAG_ARMED_SOL	BIT(0)	/* Armed for solicited-only. */
-#define PVRDMA_CQ_FLAG_ARMED		BIT(1)	/* Armed. */
-#define PVRDMA_MR_FLAG_DMA		BIT(0)	/* DMA region. */
-#define PVRDMA_MR_FLAG_FRMR		BIT(1)	/* Fast reg memory region. */
-
-/*
- * Atomic operation capability (masked versions are extended atomic
- * operations.
- */
-
-#define PVRDMA_ATOMIC_OP_COMP_SWAP	BIT(0)	/* Compare and swap. */
-#define PVRDMA_ATOMIC_OP_FETCH_ADD	BIT(1)	/* Fetch and add. */
-#define PVRDMA_ATOMIC_OP_MASK_COMP_SWAP	BIT(2)	/* Masked compare and swap. */
-#define PVRDMA_ATOMIC_OP_MASK_FETCH_ADD	BIT(3)	/* Masked fetch and add. */
-
-/*
- * Base Memory Management Extension flags to support Fast Reg Memory Regions
- * and Fast Reg Work Requests. Each flag represents a verb operation and we
- * must support all of them to qualify for the BMME device cap.
- */
-
-#define PVRDMA_BMME_FLAG_LOCAL_INV	BIT(0)	/* Local Invalidate. */
-#define PVRDMA_BMME_FLAG_REMOTE_INV	BIT(1)	/* Remote Invalidate. */
-#define PVRDMA_BMME_FLAG_FAST_REG_WR	BIT(2)	/* Fast Reg Work Request. */
-
-/*
- * GID types. The interpretation of the gid_types bit field in the device
- * capabilities will depend on the device mode. For now, the device only
- * supports RoCE as mode, so only the different GID types for RoCE are
- * defined.
- */
-
-#define PVRDMA_GID_TYPE_FLAG_ROCE_V1	BIT(0)
-#define PVRDMA_GID_TYPE_FLAG_ROCE_V2	BIT(1)
-
-enum pvrdma_pci_resource {
-	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
-	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
-	PVRDMA_PCI_RESOURCE_UAR,	/* BAR2: UAR pages, MMIO, 64-bit. */
-	PVRDMA_PCI_RESOURCE_LAST,	/* Last. */
-};
-
-enum pvrdma_device_ctl {
-	PVRDMA_DEVICE_CTL_ACTIVATE,	/* Activate device. */
-	PVRDMA_DEVICE_CTL_QUIESCE,	/* Quiesce device. */
-	PVRDMA_DEVICE_CTL_RESET,	/* Reset device. */
-};
-
-enum pvrdma_intr_vector {
-	PVRDMA_INTR_VECTOR_RESPONSE,	/* Command response. */
-	PVRDMA_INTR_VECTOR_ASYNC,	/* Async events. */
-	PVRDMA_INTR_VECTOR_CQ,		/* CQ notification. */
-	/* Additional CQ notification vectors. */
-};
-
-enum pvrdma_intr_cause {
-	PVRDMA_INTR_CAUSE_RESPONSE	= (1 << PVRDMA_INTR_VECTOR_RESPONSE),
-	PVRDMA_INTR_CAUSE_ASYNC		= (1 << PVRDMA_INTR_VECTOR_ASYNC),
-	PVRDMA_INTR_CAUSE_CQ		= (1 << PVRDMA_INTR_VECTOR_CQ),
-};
-
-enum pvrdma_intr_type {
-	PVRDMA_INTR_TYPE_INTX,		/* Legacy. */
-	PVRDMA_INTR_TYPE_MSI,		/* MSI. */
-	PVRDMA_INTR_TYPE_MSIX,		/* MSI-X. */
-};
-
-enum pvrdma_gos_bits {
-	PVRDMA_GOS_BITS_UNK,		/* Unknown. */
-	PVRDMA_GOS_BITS_32,		/* 32-bit. */
-	PVRDMA_GOS_BITS_64,		/* 64-bit. */
-};
-
-enum pvrdma_gos_type {
-	PVRDMA_GOS_TYPE_UNK,		/* Unknown. */
-	PVRDMA_GOS_TYPE_LINUX,		/* Linux. */
-};
-
-enum pvrdma_device_mode {
-	PVRDMA_DEVICE_MODE_ROCE,	/* RoCE. */
-	PVRDMA_DEVICE_MODE_IWARP,	/* iWarp. */
-	PVRDMA_DEVICE_MODE_IB,		/* InfiniBand. */
-};
-
-struct pvrdma_gos_info {
-	u32 gos_bits:2;			/* W: PVRDMA_GOS_BITS_ */
-	u32 gos_type:4;			/* W: PVRDMA_GOS_TYPE_ */
-	u32 gos_ver:16;			/* W: Guest OS version. */
-	u32 gos_misc:10;		/* W: Other. */
-	u32 pad;			/* Pad to 8-byte alignment. */
-};
-
-struct pvrdma_device_caps {
-	u64 fw_ver;				/* R: Query device. */
-	__be64 node_guid;
-	__be64 sys_image_guid;
-	u64 max_mr_size;
-	u64 page_size_cap;
-	u64 atomic_arg_sizes;			/* EX verbs. */
-	u32 ex_comp_mask;			/* EX verbs. */
-	u32 device_cap_flags2;			/* EX verbs. */
-	u32 max_fa_bit_boundary;		/* EX verbs. */
-	u32 log_max_atomic_inline_arg;		/* EX verbs. */
-	u32 vendor_id;
-	u32 vendor_part_id;
-	u32 hw_ver;
-	u32 max_qp;
-	u32 max_qp_wr;
-	u32 device_cap_flags;
-	u32 max_sge;
-	u32 max_sge_rd;
-	u32 max_cq;
-	u32 max_cqe;
-	u32 max_mr;
-	u32 max_pd;
-	u32 max_qp_rd_atom;
-	u32 max_ee_rd_atom;
-	u32 max_res_rd_atom;
-	u32 max_qp_init_rd_atom;
-	u32 max_ee_init_rd_atom;
-	u32 max_ee;
-	u32 max_rdd;
-	u32 max_mw;
-	u32 max_raw_ipv6_qp;
-	u32 max_raw_ethy_qp;
-	u32 max_mcast_grp;
-	u32 max_mcast_qp_attach;
-	u32 max_total_mcast_qp_attach;
-	u32 max_ah;
-	u32 max_fmr;
-	u32 max_map_per_fmr;
-	u32 max_srq;
-	u32 max_srq_wr;
-	u32 max_srq_sge;
-	u32 max_uar;
-	u32 gid_tbl_len;
-	u16 max_pkeys;
-	u8  local_ca_ack_delay;
-	u8  phys_port_cnt;
-	u8  mode;				/* PVRDMA_DEVICE_MODE_ */
-	u8  atomic_ops;				/* PVRDMA_ATOMIC_OP_* bits */
-	u8  bmme_flags;				/* FRWR Mem Mgmt Extensions */
-	u8  gid_types;				/* PVRDMA_GID_TYPE_FLAG_ */
-	u8  reserved[4];
-};
-
-struct pvrdma_ring_page_info {
-	u32 num_pages;				/* Num pages incl. header. */
-	u32 reserved;				/* Reserved. */
-	u64 pdir_dma;				/* Page directory PA. */
-};
-
-#pragma pack(push, 1)
-
-struct pvrdma_device_shared_region {
-	u32 driver_version;			/* W: Driver version. */
-	u32 pad;				/* Pad to 8-byte align. */
-	struct pvrdma_gos_info gos_info;	/* W: Guest OS information. */
-	u64 cmd_slot_dma;			/* W: Command slot address. */
-	u64 resp_slot_dma;			/* W: Response slot address. */
-	struct pvrdma_ring_page_info async_ring_pages;
-						/* W: Async ring page info. */
-	struct pvrdma_ring_page_info cq_ring_pages;
-						/* W: CQ ring page info. */
-	u32 uar_pfn;				/* W: UAR pageframe. */
-	u32 pad2;				/* Pad to 8-byte align. */
-	struct pvrdma_device_caps caps;		/* R: Device capabilities. */
-};
-
-#pragma pack(pop)
-
-/* Event types. Currently a 1:1 mapping with enum ib_event. */
-enum pvrdma_eqe_type {
-	PVRDMA_EVENT_CQ_ERR,
-	PVRDMA_EVENT_QP_FATAL,
-	PVRDMA_EVENT_QP_REQ_ERR,
-	PVRDMA_EVENT_QP_ACCESS_ERR,
-	PVRDMA_EVENT_COMM_EST,
-	PVRDMA_EVENT_SQ_DRAINED,
-	PVRDMA_EVENT_PATH_MIG,
-	PVRDMA_EVENT_PATH_MIG_ERR,
-	PVRDMA_EVENT_DEVICE_FATAL,
-	PVRDMA_EVENT_PORT_ACTIVE,
-	PVRDMA_EVENT_PORT_ERR,
-	PVRDMA_EVENT_LID_CHANGE,
-	PVRDMA_EVENT_PKEY_CHANGE,
-	PVRDMA_EVENT_SM_CHANGE,
-	PVRDMA_EVENT_SRQ_ERR,
-	PVRDMA_EVENT_SRQ_LIMIT_REACHED,
-	PVRDMA_EVENT_QP_LAST_WQE_REACHED,
-	PVRDMA_EVENT_CLIENT_REREGISTER,
-	PVRDMA_EVENT_GID_CHANGE,
-};
-
-/* Event queue element. */
-struct pvrdma_eqe {
-	u32 type;	/* Event type. */
-	u32 info;	/* Handle, other. */
-};
-
-/* CQ notification queue element. */
-struct pvrdma_cqne {
-	u32 info;	/* Handle */
-};
-
-enum {
-	PVRDMA_CMD_FIRST,
-	PVRDMA_CMD_QUERY_PORT = PVRDMA_CMD_FIRST,
-	PVRDMA_CMD_QUERY_PKEY,
-	PVRDMA_CMD_CREATE_PD,
-	PVRDMA_CMD_DESTROY_PD,
-	PVRDMA_CMD_CREATE_MR,
-	PVRDMA_CMD_DESTROY_MR,
-	PVRDMA_CMD_CREATE_CQ,
-	PVRDMA_CMD_RESIZE_CQ,
-	PVRDMA_CMD_DESTROY_CQ,
-	PVRDMA_CMD_CREATE_QP,
-	PVRDMA_CMD_MODIFY_QP,
-	PVRDMA_CMD_QUERY_QP,
-	PVRDMA_CMD_DESTROY_QP,
-	PVRDMA_CMD_CREATE_UC,
-	PVRDMA_CMD_DESTROY_UC,
-	PVRDMA_CMD_CREATE_BIND,
-	PVRDMA_CMD_DESTROY_BIND,
-	PVRDMA_CMD_MAX,
-};
-
-enum {
-	PVRDMA_CMD_FIRST_RESP = (1 << 31),
-	PVRDMA_CMD_QUERY_PORT_RESP = PVRDMA_CMD_FIRST_RESP,
-	PVRDMA_CMD_QUERY_PKEY_RESP,
-	PVRDMA_CMD_CREATE_PD_RESP,
-	PVRDMA_CMD_DESTROY_PD_RESP_NOOP,
-	PVRDMA_CMD_CREATE_MR_RESP,
-	PVRDMA_CMD_DESTROY_MR_RESP_NOOP,
-	PVRDMA_CMD_CREATE_CQ_RESP,
-	PVRDMA_CMD_RESIZE_CQ_RESP,
-	PVRDMA_CMD_DESTROY_CQ_RESP_NOOP,
-	PVRDMA_CMD_CREATE_QP_RESP,
-	PVRDMA_CMD_MODIFY_QP_RESP,
-	PVRDMA_CMD_QUERY_QP_RESP,
-	PVRDMA_CMD_DESTROY_QP_RESP,
-	PVRDMA_CMD_CREATE_UC_RESP,
-	PVRDMA_CMD_DESTROY_UC_RESP_NOOP,
-	PVRDMA_CMD_CREATE_BIND_RESP_NOOP,
-	PVRDMA_CMD_DESTROY_BIND_RESP_NOOP,
-	PVRDMA_CMD_MAX_RESP,
-};
-
-struct pvrdma_cmd_hdr {
-	u64 response;		/* Key for response lookup. */
-	u32 cmd;		/* PVRDMA_CMD_ */
-	u32 reserved;		/* Reserved. */
-};
-
-struct pvrdma_cmd_resp_hdr {
-	u64 response;		/* From cmd hdr. */
-	u32 ack;		/* PVRDMA_CMD_XXX_RESP */
-	u8 err;			/* Error. */
-	u8 reserved[3];		/* Reserved. */
-};
-
-struct pvrdma_cmd_query_port {
-	struct pvrdma_cmd_hdr hdr;
-	u8 port_num;
-	u8 reserved[7];
-};
-
-struct pvrdma_cmd_query_port_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	struct pvrdma_port_attr attrs;
-};
-
-struct pvrdma_cmd_query_pkey {
-	struct pvrdma_cmd_hdr hdr;
-	u8 port_num;
-	u8 index;
-	u8 reserved[6];
-};
-
-struct pvrdma_cmd_query_pkey_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u16 pkey;
-	u8 reserved[6];
-};
-
-struct pvrdma_cmd_create_uc {
-	struct pvrdma_cmd_hdr hdr;
-	u32 pfn; /* UAR page frame number */
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_uc_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 ctx_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_destroy_uc {
-	struct pvrdma_cmd_hdr hdr;
-	u32 ctx_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_pd {
-	struct pvrdma_cmd_hdr hdr;
-	u32 ctx_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_pd_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 pd_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_destroy_pd {
-	struct pvrdma_cmd_hdr hdr;
-	u32 pd_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_mr {
-	struct pvrdma_cmd_hdr hdr;
-	u64 start;
-	u64 length;
-	u64 pdir_dma;
-	u32 pd_handle;
-	u32 access_flags;
-	u32 flags;
-	u32 nchunks;
-};
-
-struct pvrdma_cmd_create_mr_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 mr_handle;
-	u32 lkey;
-	u32 rkey;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_destroy_mr {
-	struct pvrdma_cmd_hdr hdr;
-	u32 mr_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_cq {
-	struct pvrdma_cmd_hdr hdr;
-	u64 pdir_dma;
-	u32 ctx_handle;
-	u32 cqe;
-	u32 nchunks;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_cq_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 cq_handle;
-	u32 cqe;
-};
-
-struct pvrdma_cmd_resize_cq {
-	struct pvrdma_cmd_hdr hdr;
-	u32 cq_handle;
-	u32 cqe;
-};
-
-struct pvrdma_cmd_resize_cq_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 cqe;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_destroy_cq {
-	struct pvrdma_cmd_hdr hdr;
-	u32 cq_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_qp {
-	struct pvrdma_cmd_hdr hdr;
-	u64 pdir_dma;
-	u32 pd_handle;
-	u32 send_cq_handle;
-	u32 recv_cq_handle;
-	u32 srq_handle;
-	u32 max_send_wr;
-	u32 max_recv_wr;
-	u32 max_send_sge;
-	u32 max_recv_sge;
-	u32 max_inline_data;
-	u32 lkey;
-	u32 access_flags;
-	u16 total_chunks;
-	u16 send_chunks;
-	u16 max_atomic_arg;
-	u8 sq_sig_all;
-	u8 qp_type;
-	u8 is_srq;
-	u8 reserved[3];
-};
-
-struct pvrdma_cmd_create_qp_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 qpn;
-	u32 max_send_wr;
-	u32 max_recv_wr;
-	u32 max_send_sge;
-	u32 max_recv_sge;
-	u32 max_inline_data;
-};
-
-struct pvrdma_cmd_modify_qp {
-	struct pvrdma_cmd_hdr hdr;
-	u32 qp_handle;
-	u32 attr_mask;
-	struct pvrdma_qp_attr attrs;
-};
-
-struct pvrdma_cmd_query_qp {
-	struct pvrdma_cmd_hdr hdr;
-	u32 qp_handle;
-	u32 attr_mask;
-};
-
-struct pvrdma_cmd_query_qp_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	struct pvrdma_qp_attr attrs;
-};
-
-struct pvrdma_cmd_destroy_qp {
-	struct pvrdma_cmd_hdr hdr;
-	u32 qp_handle;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_destroy_qp_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	u32 events_reported;
-	u8 reserved[4];
-};
-
-struct pvrdma_cmd_create_bind {
-	struct pvrdma_cmd_hdr hdr;
-	u32 mtu;
-	u32 vlan;
-	u32 index;
-	u8 new_gid[16];
-	u8 gid_type;
-	u8 reserved[3];
-};
-
-struct pvrdma_cmd_destroy_bind {
-	struct pvrdma_cmd_hdr hdr;
-	u32 index;
-	u8 dest_gid[16];
-	u8 reserved[4];
-};
-
-union pvrdma_cmd_req {
-	struct pvrdma_cmd_hdr hdr;
-	struct pvrdma_cmd_query_port query_port;
-	struct pvrdma_cmd_query_pkey query_pkey;
-	struct pvrdma_cmd_create_uc create_uc;
-	struct pvrdma_cmd_destroy_uc destroy_uc;
-	struct pvrdma_cmd_create_pd create_pd;
-	struct pvrdma_cmd_destroy_pd destroy_pd;
-	struct pvrdma_cmd_create_mr create_mr;
-	struct pvrdma_cmd_destroy_mr destroy_mr;
-	struct pvrdma_cmd_create_cq create_cq;
-	struct pvrdma_cmd_resize_cq resize_cq;
-	struct pvrdma_cmd_destroy_cq destroy_cq;
-	struct pvrdma_cmd_create_qp create_qp;
-	struct pvrdma_cmd_modify_qp modify_qp;
-	struct pvrdma_cmd_query_qp query_qp;
-	struct pvrdma_cmd_destroy_qp destroy_qp;
-	struct pvrdma_cmd_create_bind create_bind;
-	struct pvrdma_cmd_destroy_bind destroy_bind;
-};
-
-union pvrdma_cmd_resp {
-	struct pvrdma_cmd_resp_hdr hdr;
-	struct pvrdma_cmd_query_port_resp query_port_resp;
-	struct pvrdma_cmd_query_pkey_resp query_pkey_resp;
-	struct pvrdma_cmd_create_uc_resp create_uc_resp;
-	struct pvrdma_cmd_create_pd_resp create_pd_resp;
-	struct pvrdma_cmd_create_mr_resp create_mr_resp;
-	struct pvrdma_cmd_create_cq_resp create_cq_resp;
-	struct pvrdma_cmd_resize_cq_resp resize_cq_resp;
-	struct pvrdma_cmd_create_qp_resp create_qp_resp;
-	struct pvrdma_cmd_query_qp_resp query_qp_resp;
-	struct pvrdma_cmd_destroy_qp_resp destroy_qp_resp;
-};
-
-#endif /* __PVRDMA_DEV_API_H__ */
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c b/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
deleted file mode 100644
index bf51357..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
+++ /dev/null
@@ -1,127 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <linux/bitmap.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-
-#include "pvrdma.h"
-
-int pvrdma_uar_table_init(struct pvrdma_dev *dev)
-{
-	u32 num = dev->dsr->caps.max_uar;
-	u32 mask = num - 1;
-	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
-
-	if (!is_power_of_2(num))
-		return -EINVAL;
-
-	tbl->last = 0;
-	tbl->top = 0;
-	tbl->max = num;
-	tbl->mask = mask;
-	spin_lock_init(&tbl->lock);
-	tbl->table = kcalloc(BITS_TO_LONGS(num), sizeof(long), GFP_KERNEL);
-	if (!tbl->table)
-		return -ENOMEM;
-
-	/* 0th UAR is taken by the device. */
-	set_bit(0, tbl->table);
-
-	return 0;
-}
-
-void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev)
-{
-	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
-
-	kfree(tbl->table);
-}
-
-int pvrdma_uar_alloc(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar)
-{
-	struct pvrdma_id_table *tbl;
-	unsigned long flags;
-	u32 obj;
-
-	tbl = &dev->uar_table.tbl;
-
-	spin_lock_irqsave(&tbl->lock, flags);
-	obj = find_next_zero_bit(tbl->table, tbl->max, tbl->last);
-	if (obj >= tbl->max) {
-		tbl->top = (tbl->top + tbl->max) & tbl->mask;
-		obj = find_first_zero_bit(tbl->table, tbl->max);
-	}
-
-	if (obj >= tbl->max) {
-		spin_unlock_irqrestore(&tbl->lock, flags);
-		return -ENOMEM;
-	}
-
-	set_bit(obj, tbl->table);
-	obj |= tbl->top;
-
-	spin_unlock_irqrestore(&tbl->lock, flags);
-
-	uar->index = obj;
-	uar->pfn = (pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
-		    PAGE_SHIFT) + uar->index;
-
-	return 0;
-}
-
-void pvrdma_uar_free(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar)
-{
-	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
-	unsigned long flags;
-	u32 obj;
-
-	obj = uar->index & (tbl->max - 1);
-	spin_lock_irqsave(&tbl->lock, flags);
-	clear_bit(obj, tbl->table);
-	tbl->last = min(tbl->last, obj);
-	tbl->top = (tbl->top + tbl->max) & tbl->mask;
-	spin_unlock_irqrestore(&tbl->lock, flags);
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_main.c b/drivers/infiniband/hw/pvrdma/pvrdma_main.c
deleted file mode 100644
index 5510c86..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_main.c
+++ /dev/null
@@ -1,1211 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <linux/errno.h>
-#include <linux/inetdevice.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <rdma/ib_addr.h>
-#include <rdma/ib_smi.h>
-#include <rdma/ib_user_verbs.h>
-#include <net/addrconf.h>
-
-#include "pvrdma.h"
-
-#define DRV_NAME	"pvrdma"
-#define DRV_VERSION	"1.0.0.0-k"
-
-static DEFINE_MUTEX(pvrdma_device_list_lock);
-static LIST_HEAD(pvrdma_device_list);
-static struct workqueue_struct *event_wq;
-
-static int pvrdma_add_gid(struct ib_device *ibdev,
-			  u8 port_num,
-			  unsigned int index,
-			  const union ib_gid *gid,
-			  const struct ib_gid_attr *attr,
-			  void **context);
-static int pvrdma_del_gid(struct ib_device *ibdev,
-			  u8 port_num,
-			  unsigned int index,
-			  void **context);
-
-
-static ssize_t show_hca(struct device *device, struct device_attribute *attr,
-			char *buf)
-{
-	return sprintf(buf, "PVRDMA-%s\n", DRV_VERSION);
-}
-
-static ssize_t show_rev(struct device *device, struct device_attribute *attr,
-			char *buf)
-{
-	return sprintf(buf, "%d\n", PVRDMA_REV_ID);
-}
-
-static ssize_t show_board(struct device *device, struct device_attribute *attr,
-			  char *buf)
-{
-	return sprintf(buf, "%d\n", PVRDMA_BOARD_ID);
-}
-
-static DEVICE_ATTR(hw_rev,   S_IRUGO, show_rev,	   NULL);
-static DEVICE_ATTR(hca_type, S_IRUGO, show_hca,	   NULL);
-static DEVICE_ATTR(board_id, S_IRUGO, show_board,  NULL);
-
-static struct device_attribute *pvrdma_class_attributes[] = {
-	&dev_attr_hw_rev,
-	&dev_attr_hca_type,
-	&dev_attr_board_id
-};
-
-static void pvrdma_get_fw_ver_str(struct ib_device *device, char *str,
-				  size_t str_len)
-{
-	struct pvrdma_dev *dev =
-		container_of(device, struct pvrdma_dev, ib_dev);
-	snprintf(str, str_len, "%d.%d.%d\n",
-		 (int) (dev->dsr->caps.fw_ver >> 32),
-		 (int) (dev->dsr->caps.fw_ver >> 16) & 0xffff,
-		 (int) dev->dsr->caps.fw_ver & 0xffff);
-}
-
-static int pvrdma_init_device(struct pvrdma_dev *dev)
-{
-	/*  Initialize some device related stuff */
-	spin_lock_init(&dev->cmd_lock);
-	sema_init(&dev->cmd_sema, 1);
-	atomic_set(&dev->num_qps, 0);
-	atomic_set(&dev->num_cqs, 0);
-	atomic_set(&dev->num_pds, 0);
-	atomic_set(&dev->num_ahs, 0);
-
-	return 0;
-}
-
-static int pvrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
-				 struct ib_port_immutable *immutable)
-{
-	struct ib_port_attr attr;
-	int err;
-
-	err = pvrdma_query_port(ibdev, port_num, &attr);
-	if (err)
-		return err;
-
-	immutable->pkey_tbl_len = attr.pkey_tbl_len;
-	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
-	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
-	return 0;
-}
-
-static struct net_device *pvrdma_get_netdev(struct ib_device *ibdev,
-					    u8 port_num)
-{
-	struct net_device *netdev;
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-
-	if (port_num != 1)
-		return NULL;
-
-	rcu_read_lock();
-	netdev = dev->netdev;
-	if (netdev)
-		dev_hold(netdev);
-	rcu_read_unlock();
-
-	return netdev;
-}
-
-static int pvrdma_register_device(struct pvrdma_dev *dev)
-{
-	int ret = -1;
-	int i = 0;
-
-	strlcpy(dev->ib_dev.name, "pvrdma%d", IB_DEVICE_NAME_MAX);
-	dev->ib_dev.node_guid = dev->dsr->caps.node_guid;
-	dev->sys_image_guid = dev->dsr->caps.sys_image_guid;
-	dev->flags = 0;
-	dev->ib_dev.owner = THIS_MODULE;
-	dev->ib_dev.num_comp_vectors = 1;
-	dev->ib_dev.dma_device = &dev->pdev->dev;
-	dev->ib_dev.uverbs_abi_ver = PVRDMA_UVERBS_ABI_VERSION;
-	dev->ib_dev.uverbs_cmd_mask =
-		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
-		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
-		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
-		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
-		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
-		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
-		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
-		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
-		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
-		(1ull << IB_USER_VERBS_CMD_POLL_CQ)		|
-		(1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ)	|
-		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
-		(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
-		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
-		(1ull << IB_USER_VERBS_CMD_QUERY_QP)		|
-		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
-		(1ull << IB_USER_VERBS_CMD_POST_SEND)		|
-		(1ull << IB_USER_VERBS_CMD_POST_RECV)		|
-		(1ull << IB_USER_VERBS_CMD_CREATE_AH)		|
-		(1ull << IB_USER_VERBS_CMD_DESTROY_AH);
-
-	dev->ib_dev.node_type = RDMA_NODE_IB_CA;
-	dev->ib_dev.phys_port_cnt = dev->dsr->caps.phys_port_cnt;
-
-	dev->ib_dev.query_device = pvrdma_query_device;
-	dev->ib_dev.query_port = pvrdma_query_port;
-	dev->ib_dev.query_gid = pvrdma_query_gid;
-	dev->ib_dev.query_pkey = pvrdma_query_pkey;
-	dev->ib_dev.modify_port	= pvrdma_modify_port;
-	dev->ib_dev.alloc_ucontext = pvrdma_alloc_ucontext;
-	dev->ib_dev.dealloc_ucontext = pvrdma_dealloc_ucontext;
-	dev->ib_dev.mmap = pvrdma_mmap;
-	dev->ib_dev.alloc_pd = pvrdma_alloc_pd;
-	dev->ib_dev.dealloc_pd = pvrdma_dealloc_pd;
-	dev->ib_dev.create_ah = pvrdma_create_ah;
-	dev->ib_dev.destroy_ah = pvrdma_destroy_ah;
-	dev->ib_dev.create_qp = pvrdma_create_qp;
-	dev->ib_dev.modify_qp = pvrdma_modify_qp;
-	dev->ib_dev.query_qp = pvrdma_query_qp;
-	dev->ib_dev.destroy_qp = pvrdma_destroy_qp;
-	dev->ib_dev.post_send = pvrdma_post_send;
-	dev->ib_dev.post_recv = pvrdma_post_recv;
-	dev->ib_dev.create_cq = pvrdma_create_cq;
-	dev->ib_dev.modify_cq = pvrdma_modify_cq;
-	dev->ib_dev.resize_cq = pvrdma_resize_cq;
-	dev->ib_dev.destroy_cq = pvrdma_destroy_cq;
-	dev->ib_dev.poll_cq = pvrdma_poll_cq;
-	dev->ib_dev.req_notify_cq = pvrdma_req_notify_cq;
-	dev->ib_dev.get_dma_mr = pvrdma_get_dma_mr;
-	dev->ib_dev.reg_user_mr	= pvrdma_reg_user_mr;
-	dev->ib_dev.dereg_mr = pvrdma_dereg_mr;
-	dev->ib_dev.alloc_mr = pvrdma_alloc_mr;
-	dev->ib_dev.map_mr_sg = pvrdma_map_mr_sg;
-	dev->ib_dev.add_gid = pvrdma_add_gid;
-	dev->ib_dev.del_gid = pvrdma_del_gid;
-	dev->ib_dev.get_netdev = pvrdma_get_netdev;
-	dev->ib_dev.get_port_immutable = pvrdma_port_immutable;
-	dev->ib_dev.get_link_layer = pvrdma_port_link_layer;
-	dev->ib_dev.get_dev_fw_str = pvrdma_get_fw_ver_str;
-
-	mutex_init(&dev->port_mutex);
-	spin_lock_init(&dev->desc_lock);
-
-	dev->cq_tbl = kcalloc(dev->dsr->caps.max_cq, sizeof(void *),
-			      GFP_KERNEL);
-	if (!dev->cq_tbl)
-		return ret;
-	spin_lock_init(&dev->cq_tbl_lock);
-
-	dev->qp_tbl = kcalloc(dev->dsr->caps.max_qp, sizeof(void *),
-			      GFP_KERNEL);
-	if (!dev->qp_tbl)
-		goto err_cq_free;
-	spin_lock_init(&dev->qp_tbl_lock);
-
-	ret = ib_register_device(&dev->ib_dev, NULL);
-	if (ret)
-		goto err_qp_free;
-
-	for (i = 0; i < ARRAY_SIZE(pvrdma_class_attributes); ++i) {
-		ret = device_create_file(&dev->ib_dev.dev,
-					 pvrdma_class_attributes[i]);
-		if (ret)
-			goto err_class;
-	}
-
-	dev->ib_active = true;
-
-	return 0;
-
-err_class:
-	ib_unregister_device(&dev->ib_dev);
-err_qp_free:
-	kfree(dev->qp_tbl);
-err_cq_free:
-	kfree(dev->cq_tbl);
-
-	return ret;
-}
-
-static irqreturn_t pvrdma_intr0_handler(int irq, void *dev_id)
-{
-	u32 icr = PVRDMA_INTR_CAUSE_RESPONSE;
-	struct pvrdma_dev *dev = dev_id;
-
-	dev_dbg(&dev->pdev->dev, "interrupt 0 (response) handler\n");
-
-	if (dev->intr.type != PVRDMA_INTR_TYPE_MSIX) {
-		/* Legacy intr */
-		icr = pvrdma_read_reg(dev, PVRDMA_REG_ICR);
-		if (icr == 0)
-			return IRQ_NONE;
-	}
-
-	if (icr == PVRDMA_INTR_CAUSE_RESPONSE)
-		complete(&dev->cmd_done);
-
-	return IRQ_HANDLED;
-}
-
-static void pvrdma_qp_event(struct pvrdma_dev *dev, u32 qpn, int type)
-{
-	struct pvrdma_qp *qp;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
-	qp = dev->qp_tbl[qpn % dev->dsr->caps.max_qp];
-	if (qp)
-		atomic_inc(&qp->refcnt);
-	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
-
-	if (qp && qp->ibqp.event_handler) {
-		struct ib_qp *ibqp = &qp->ibqp;
-		struct ib_event e;
-
-		e.device = ibqp->device;
-		e.element.qp = ibqp;
-		e.event = type; /* 1:1 mapping for now. */
-		ibqp->event_handler(&e, ibqp->qp_context);
-	}
-	if (qp) {
-		atomic_dec(&qp->refcnt);
-		if (atomic_read(&qp->refcnt) == 0)
-			wake_up(&qp->wait);
-	}
-}
-
-static void pvrdma_cq_event(struct pvrdma_dev *dev, u32 cqn, int type)
-{
-	struct pvrdma_cq *cq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
-	cq = dev->cq_tbl[cqn % dev->dsr->caps.max_cq];
-	if (cq)
-		atomic_inc(&cq->refcnt);
-	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
-
-	if (cq && cq->ibcq.event_handler) {
-		struct ib_cq *ibcq = &cq->ibcq;
-		struct ib_event e;
-
-		e.device = ibcq->device;
-		e.element.cq = ibcq;
-		e.event = type; /* 1:1 mapping for now. */
-		ibcq->event_handler(&e, ibcq->cq_context);
-	}
-	if (cq) {
-		atomic_dec(&cq->refcnt);
-		if (atomic_read(&cq->refcnt) == 0)
-			wake_up(&cq->wait);
-	}
-}
-
-static void pvrdma_dispatch_event(struct pvrdma_dev *dev, int port,
-				  enum ib_event_type event)
-{
-	struct ib_event ib_event;
-
-	memset(&ib_event, 0, sizeof(ib_event));
-	ib_event.device = &dev->ib_dev;
-	ib_event.element.port_num = port;
-	ib_event.event = event;
-	ib_dispatch_event(&ib_event);
-}
-
-static void pvrdma_dev_event(struct pvrdma_dev *dev, u8 port, int type)
-{
-	if (port < 1 || port > dev->dsr->caps.phys_port_cnt) {
-		dev_warn(&dev->pdev->dev, "event on port %d\n", port);
-		return;
-	}
-
-	pvrdma_dispatch_event(dev, port, type);
-}
-
-static inline struct pvrdma_eqe *get_eqe(struct pvrdma_dev *dev, unsigned int i)
-{
-	return (struct pvrdma_eqe *)pvrdma_page_dir_get_ptr(
-					&dev->async_pdir,
-					PAGE_SIZE +
-					sizeof(struct pvrdma_eqe) * i);
-}
-
-static irqreturn_t pvrdma_intr1_handler(int irq, void *dev_id)
-{
-	struct pvrdma_dev *dev = dev_id;
-	struct pvrdma_ring *ring = &dev->async_ring_state->rx;
-	int ring_slots = (dev->dsr->async_ring_pages.num_pages - 1) *
-			 PAGE_SIZE / sizeof(struct pvrdma_eqe);
-	unsigned int head;
-
-	dev_dbg(&dev->pdev->dev, "interrupt 1 (async event) handler\n");
-
-	/*
-	 * Don't process events until the IB device is registered. Otherwise
-	 * we'll try to ib_dispatch_event() on an invalid device.
-	 */
-	if (!dev->ib_active)
-		return IRQ_HANDLED;
-
-	while (pvrdma_idx_ring_has_data(ring, ring_slots, &head) > 0) {
-		struct pvrdma_eqe *eqe;
-
-		eqe = get_eqe(dev, head);
-
-		switch (eqe->type) {
-		case PVRDMA_EVENT_QP_FATAL:
-		case PVRDMA_EVENT_QP_REQ_ERR:
-		case PVRDMA_EVENT_QP_ACCESS_ERR:
-		case PVRDMA_EVENT_COMM_EST:
-		case PVRDMA_EVENT_SQ_DRAINED:
-		case PVRDMA_EVENT_PATH_MIG:
-		case PVRDMA_EVENT_PATH_MIG_ERR:
-		case PVRDMA_EVENT_QP_LAST_WQE_REACHED:
-			pvrdma_qp_event(dev, eqe->info, eqe->type);
-			break;
-
-		case PVRDMA_EVENT_CQ_ERR:
-			pvrdma_cq_event(dev, eqe->info, eqe->type);
-			break;
-
-		case PVRDMA_EVENT_SRQ_ERR:
-		case PVRDMA_EVENT_SRQ_LIMIT_REACHED:
-			break;
-
-		case PVRDMA_EVENT_PORT_ACTIVE:
-		case PVRDMA_EVENT_PORT_ERR:
-		case PVRDMA_EVENT_LID_CHANGE:
-		case PVRDMA_EVENT_PKEY_CHANGE:
-		case PVRDMA_EVENT_SM_CHANGE:
-		case PVRDMA_EVENT_CLIENT_REREGISTER:
-		case PVRDMA_EVENT_GID_CHANGE:
-			pvrdma_dev_event(dev, eqe->info, eqe->type);
-			break;
-
-		case PVRDMA_EVENT_DEVICE_FATAL:
-			pvrdma_dev_event(dev, 1, eqe->type);
-			break;
-
-		default:
-			break;
-		}
-
-		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static inline struct pvrdma_cqne *get_cqne(struct pvrdma_dev *dev,
-					   unsigned int i)
-{
-	return (struct pvrdma_cqne *)pvrdma_page_dir_get_ptr(
-					&dev->cq_pdir,
-					PAGE_SIZE +
-					sizeof(struct pvrdma_cqne) * i);
-}
-
-static irqreturn_t pvrdma_intrx_handler(int irq, void *dev_id)
-{
-	struct pvrdma_dev *dev = dev_id;
-	struct pvrdma_ring *ring = &dev->cq_ring_state->rx;
-	int ring_slots = (dev->dsr->cq_ring_pages.num_pages - 1) * PAGE_SIZE /
-			 sizeof(struct pvrdma_cqne);
-	unsigned int head;
-	unsigned long flags;
-
-	dev_dbg(&dev->pdev->dev, "interrupt x (completion) handler\n");
-
-	while (pvrdma_idx_ring_has_data(ring, ring_slots, &head) > 0) {
-		struct pvrdma_cqne *cqne;
-		struct pvrdma_cq *cq;
-
-		cqne = get_cqne(dev, head);
-		spin_lock_irqsave(&dev->cq_tbl_lock, flags);
-		cq = dev->cq_tbl[cqne->info % dev->dsr->caps.max_cq];
-		if (cq)
-			atomic_inc(&cq->refcnt);
-		spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
-
-		if (cq && cq->ibcq.comp_handler)
-			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
-		if (cq) {
-			atomic_dec(&cq->refcnt);
-			if (atomic_read(&cq->refcnt))
-				wake_up(&cq->wait);
-		}
-		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static void pvrdma_disable_msi_all(struct pvrdma_dev *dev)
-{
-	if (dev->intr.type == PVRDMA_INTR_TYPE_MSIX)
-		pci_disable_msix(dev->pdev);
-	else if (dev->intr.type == PVRDMA_INTR_TYPE_MSI)
-		pci_disable_msi(dev->pdev);
-}
-
-static void pvrdma_free_irq(struct pvrdma_dev *dev)
-{
-	int i;
-
-	dev_dbg(&dev->pdev->dev, "freeing interrupts\n");
-
-	if (dev->intr.type == PVRDMA_INTR_TYPE_MSIX) {
-		for (i = 0; i < dev->intr.size; i++) {
-			if (dev->intr.enabled[i]) {
-				free_irq(dev->intr.msix_entry[i].vector, dev);
-				dev->intr.enabled[i] = 0;
-			}
-		}
-	} else if (dev->intr.type == PVRDMA_INTR_TYPE_INTX ||
-		   dev->intr.type == PVRDMA_INTR_TYPE_MSI) {
-		free_irq(dev->pdev->irq, dev);
-	}
-}
-
-static void pvrdma_enable_intrs(struct pvrdma_dev *dev)
-{
-	dev_dbg(&dev->pdev->dev, "enable interrupts\n");
-	pvrdma_write_reg(dev, PVRDMA_REG_IMR, 0);
-}
-
-static void pvrdma_disable_intrs(struct pvrdma_dev *dev)
-{
-	dev_dbg(&dev->pdev->dev, "disable interrupts\n");
-	pvrdma_write_reg(dev, PVRDMA_REG_IMR, ~0);
-}
-
-static int pvrdma_enable_msix(struct pci_dev *pdev, struct pvrdma_dev *dev)
-{
-	int i;
-	int ret;
-
-	for (i = 0; i < PVRDMA_MAX_INTERRUPTS; i++) {
-		dev->intr.msix_entry[i].entry = i;
-		dev->intr.msix_entry[i].vector = i;
-
-		switch (i) {
-		case 0:
-			/* CMD ring handler */
-			dev->intr.handler[i] = pvrdma_intr0_handler;
-			break;
-		case 1:
-			/* Async event ring handler */
-			dev->intr.handler[i] = pvrdma_intr1_handler;
-			break;
-		default:
-			/* Completion queue handler */
-			dev->intr.handler[i] = pvrdma_intrx_handler;
-			break;
-		}
-	}
-
-	ret = pci_enable_msix(pdev, dev->intr.msix_entry,
-			      PVRDMA_MAX_INTERRUPTS);
-	if (!ret) {
-		dev->intr.type = PVRDMA_INTR_TYPE_MSIX;
-		dev->intr.size = PVRDMA_MAX_INTERRUPTS;
-	} else if (ret > 0) {
-		ret = pci_enable_msix(pdev, dev->intr.msix_entry, ret);
-		if (!ret) {
-			dev->intr.type = PVRDMA_INTR_TYPE_MSIX;
-			dev->intr.size = ret;
-		} else {
-			dev->intr.size = 0;
-		}
-	}
-
-	dev_dbg(&pdev->dev, "using interrupt type %d, size %d\n",
-		dev->intr.type, dev->intr.size);
-
-	return ret;
-}
-
-static int pvrdma_alloc_intrs(struct pvrdma_dev *dev)
-{
-	int ret = 0;
-	int i;
-
-	if (pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX) &&
-	    pvrdma_enable_msix(dev->pdev, dev)) {
-		/* Try MSI */
-		ret = pci_enable_msi(dev->pdev);
-		if (!ret) {
-			dev->intr.type = PVRDMA_INTR_TYPE_MSI;
-		} else {
-			/* Legacy INTR */
-			dev->intr.type = PVRDMA_INTR_TYPE_INTX;
-		}
-	}
-
-	/* Request First IRQ */
-	switch (dev->intr.type) {
-	case PVRDMA_INTR_TYPE_INTX:
-	case PVRDMA_INTR_TYPE_MSI:
-		ret = request_irq(dev->pdev->irq, pvrdma_intr0_handler,
-				  IRQF_SHARED, DRV_NAME, dev);
-		if (ret) {
-			dev_err(&dev->pdev->dev,
-				"failed to request interrupt\n");
-			goto disable_msi;
-		}
-		break;
-	case PVRDMA_INTR_TYPE_MSIX:
-		ret = request_irq(dev->intr.msix_entry[0].vector,
-				  pvrdma_intr0_handler, 0, DRV_NAME, dev);
-		if (ret) {
-			dev_err(&dev->pdev->dev,
-				"failed to request interrupt 0\n");
-			goto disable_msi;
-		}
-		dev->intr.enabled[0] = 1;
-		break;
-	default:
-		/* Not reached */
-		break;
-	}
-
-	/* For MSIX: request intr for each vector */
-	if (dev->intr.size > 1) {
-		ret = request_irq(dev->intr.msix_entry[1].vector,
-				  pvrdma_intr1_handler, 0, DRV_NAME, dev);
-		if (ret) {
-			dev_err(&dev->pdev->dev,
-				"failed to request interrupt 1\n");
-			goto free_irq;
-		}
-		dev->intr.enabled[1] = 1;
-
-		for (i = 2; i < dev->intr.size; i++) {
-			ret = request_irq(dev->intr.msix_entry[i].vector,
-					  pvrdma_intrx_handler, 0,
-					  DRV_NAME, dev);
-			if (ret) {
-				dev_err(&dev->pdev->dev,
-					"failed to request interrupt %d\n", i);
-				goto free_irq;
-			}
-			dev->intr.enabled[i] = 1;
-		}
-	}
-
-	return 0;
-
-free_irq:
-	pvrdma_free_irq(dev);
-disable_msi:
-	pvrdma_disable_msi_all(dev);
-	return ret;
-}
-
-static void pvrdma_free_slots(struct pvrdma_dev *dev)
-{
-	struct pci_dev *pdev = dev->pdev;
-
-	if (dev->resp_slot)
-		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->resp_slot,
-				  dev->dsr->resp_slot_dma);
-	if (dev->cmd_slot)
-		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->cmd_slot,
-				  dev->dsr->cmd_slot_dma);
-}
-
-static int pvrdma_add_gid_at_index(struct pvrdma_dev *dev,
-				   const union ib_gid *gid,
-				   int index)
-{
-	int ret;
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_create_bind *cmd_bind = &req.create_bind;
-
-	if (!dev->sgid_tbl) {
-		dev_warn(&dev->pdev->dev, "sgid table not initialized\n");
-		return -EINVAL;
-	}
-
-	memset(cmd_bind, 0, sizeof(*cmd_bind));
-	cmd_bind->hdr.cmd = PVRDMA_CMD_CREATE_BIND;
-	memcpy(cmd_bind->new_gid, gid->raw, 16);
-	cmd_bind->mtu = ib_mtu_enum_to_int(IB_MTU_1024);
-	cmd_bind->vlan = 0xfff;
-	cmd_bind->index = index;
-	cmd_bind->gid_type = PVRDMA_GID_TYPE_FLAG_ROCE_V1;
-
-	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not create binding, error: %d\n", ret);
-		return -EFAULT;
-	}
-	memcpy(&dev->sgid_tbl[index], gid, sizeof(*gid));
-	return 0;
-}
-
-static int pvrdma_add_gid(struct ib_device *ibdev,
-			  u8 port_num,
-			  unsigned int index,
-			  const union ib_gid *gid,
-			  const struct ib_gid_attr *attr,
-			  void **context)
-{
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-
-	return pvrdma_add_gid_at_index(dev, gid, index);
-}
-
-static int pvrdma_del_gid_at_index(struct pvrdma_dev *dev, int index)
-{
-	int ret;
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_destroy_bind *cmd_dest = &req.destroy_bind;
-
-	/* Update sgid table. */
-	if (!dev->sgid_tbl) {
-		dev_warn(&dev->pdev->dev, "sgid table not initialized\n");
-		return -EINVAL;
-	}
-
-	memset(cmd_dest, 0, sizeof(*cmd_dest));
-	cmd_dest->hdr.cmd = PVRDMA_CMD_DESTROY_BIND;
-	memcpy(cmd_dest->dest_gid, &dev->sgid_tbl[index], 16);
-	cmd_dest->index = index;
-
-	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not destroy binding, error: %d\n", ret);
-		return ret;
-	}
-	memset(&dev->sgid_tbl[index], 0, 16);
-	return 0;
-}
-
-static int pvrdma_del_gid(struct ib_device *ibdev,
-			  u8 port_num,
-			  unsigned int index,
-			  void **context)
-{
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-
-	dev_dbg(&dev->pdev->dev, "removing gid at index %u from %s",
-		index, dev->netdev->name);
-
-	return pvrdma_del_gid_at_index(dev, index);
-}
-
-static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
-					  unsigned long event)
-{
-	switch (event) {
-	case NETDEV_REBOOT:
-	case NETDEV_DOWN:
-		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
-		break;
-	case NETDEV_UP:
-		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
-		break;
-	default:
-		dev_dbg(&dev->pdev->dev, "ignore netdevice event %ld on %s\n",
-			event, dev->ib_dev.name);
-		break;
-	}
-}
-
-static void pvrdma_netdevice_event_work(struct work_struct *work)
-{
-	struct pvrdma_netdevice_work *netdev_work;
-	struct pvrdma_dev *dev;
-
-	netdev_work = container_of(work, struct pvrdma_netdevice_work, work);
-
-	mutex_lock(&pvrdma_device_list_lock);
-	list_for_each_entry(dev, &pvrdma_device_list, device_link) {
-		if (dev->netdev == netdev_work->event_netdev) {
-			pvrdma_netdevice_event_handle(dev, netdev_work->event);
-			break;
-		}
-	}
-	mutex_unlock(&pvrdma_device_list_lock);
-
-	kfree(netdev_work);
-}
-
-static int pvrdma_netdevice_event(struct notifier_block *this,
-				  unsigned long event, void *ptr)
-{
-	struct net_device *event_netdev = netdev_notifier_info_to_dev(ptr);
-	struct pvrdma_netdevice_work *netdev_work;
-
-	netdev_work = kmalloc(sizeof(*netdev_work), GFP_ATOMIC);
-	if (!netdev_work)
-		return NOTIFY_BAD;
-
-	INIT_WORK(&netdev_work->work, pvrdma_netdevice_event_work);
-	netdev_work->event_netdev = event_netdev;
-	netdev_work->event = event;
-	queue_work(event_wq, &netdev_work->work);
-
-	return NOTIFY_DONE;
-}
-
-static int pvrdma_pci_probe(struct pci_dev *pdev,
-			    const struct pci_device_id *id)
-{
-	struct pci_dev *pdev_net;
-	struct pvrdma_dev *dev;
-	int ret;
-	unsigned long start;
-	unsigned long len;
-	unsigned int version;
-	dma_addr_t slot_dma = 0;
-
-	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
-
-	/* Allocate zero-out device */
-	dev = (struct pvrdma_dev *)ib_alloc_device(sizeof(*dev));
-	if (!dev) {
-		dev_err(&pdev->dev, "failed to allocate IB device\n");
-		return -ENOMEM;
-	}
-
-	mutex_lock(&pvrdma_device_list_lock);
-	list_add(&dev->device_link, &pvrdma_device_list);
-	mutex_unlock(&pvrdma_device_list_lock);
-
-	ret = pvrdma_init_device(dev);
-	if (ret)
-		goto err_free_device;
-
-	dev->pdev = pdev;
-	pci_set_drvdata(pdev, dev);
-
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "cannot enable PCI device\n");
-		goto err_free_device;
-	}
-
-	dev_dbg(&pdev->dev, "PCI resource flags BAR0 %#lx\n",
-		pci_resource_flags(pdev, 0));
-	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
-		(unsigned long long)pci_resource_len(pdev, 0));
-	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
-		(unsigned long long)pci_resource_start(pdev, 0));
-	dev_dbg(&pdev->dev, "PCI resource flags BAR1 %#lx\n",
-		pci_resource_flags(pdev, 1));
-	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
-		(unsigned long long)pci_resource_len(pdev, 1));
-	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
-		(unsigned long long)pci_resource_start(pdev, 1));
-
-	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
-	    !(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
-		dev_err(&pdev->dev, "PCI BAR region not MMIO\n");
-		ret = -ENOMEM;
-		goto err_free_device;
-	}
-
-	ret = pci_request_regions(pdev, DRV_NAME);
-	if (ret) {
-		dev_err(&pdev->dev, "cannot request PCI resources\n");
-		goto err_disable_pdev;
-	}
-
-	/* Enable 64-Bit DMA */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
-		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (ret != 0) {
-			dev_err(&pdev->dev,
-				"pci_set_consistent_dma_mask failed\n");
-			goto err_free_resource;
-		}
-	} else {
-		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (ret != 0) {
-			dev_err(&pdev->dev,
-				"pci_set_dma_mask failed\n");
-			goto err_free_resource;
-		}
-	}
-
-	pci_set_master(pdev);
-
-	/* Map register space */
-	start = pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
-	len = pci_resource_len(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
-	dev->regs = ioremap(start, len);
-	if (!dev->regs) {
-		dev_err(&pdev->dev, "register mapping failed\n");
-		ret = -ENOMEM;
-		goto err_free_resource;
-	}
-
-	/* Setup per-device UAR. */
-	dev->driver_uar.index = 0;
-	dev->driver_uar.pfn =
-		pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
-		PAGE_SHIFT;
-	dev->driver_uar.map =
-		ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
-	if (!dev->driver_uar.map) {
-		dev_err(&pdev->dev, "failed to remap UAR pages\n");
-		ret = -ENOMEM;
-		goto err_unmap_regs;
-	}
-
-	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
-	dev_info(&pdev->dev, "device version %d, driver version %d\n",
-		 version, PVRDMA_VERSION);
-	if (version < PVRDMA_VERSION) {
-		dev_err(&pdev->dev, "incompatible device version\n");
-		goto err_uar_unmap;
-	}
-
-	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
-				      &dev->dsrbase, GFP_KERNEL);
-	if (!dev->dsr) {
-		dev_err(&pdev->dev, "failed to allocate shared region\n");
-		ret = -ENOMEM;
-		goto err_uar_unmap;
-	}
-
-	/* Setup the shared region */
-	memset(dev->dsr, 0, sizeof(*dev->dsr));
-	dev->dsr->driver_version = PVRDMA_VERSION;
-	dev->dsr->gos_info.gos_bits = sizeof(void *) == 4 ?
-		PVRDMA_GOS_BITS_32 :
-		PVRDMA_GOS_BITS_64;
-	dev->dsr->gos_info.gos_type = PVRDMA_GOS_TYPE_LINUX;
-	dev->dsr->gos_info.gos_ver = 1;
-	dev->dsr->uar_pfn = dev->driver_uar.pfn;
-
-	/* Command slot. */
-	dev->cmd_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-					   &slot_dma, GFP_KERNEL);
-	if (!dev->cmd_slot) {
-		ret = -ENOMEM;
-		goto err_free_dsr;
-	}
-
-	dev->dsr->cmd_slot_dma = (u64)slot_dma;
-
-	/* Response slot. */
-	dev->resp_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-					    &slot_dma, GFP_KERNEL);
-	if (!dev->resp_slot) {
-		ret = -ENOMEM;
-		goto err_free_slots;
-	}
-
-	dev->dsr->resp_slot_dma = (u64)slot_dma;
-
-	/* Async event ring */
-	dev->dsr->async_ring_pages.num_pages = 4;
-	ret = pvrdma_page_dir_init(dev, &dev->async_pdir,
-				   dev->dsr->async_ring_pages.num_pages, true);
-	if (ret)
-		goto err_free_slots;
-	dev->async_ring_state = dev->async_pdir.pages[0];
-	dev->dsr->async_ring_pages.pdir_dma = dev->async_pdir.dir_dma;
-
-	/* CQ notification ring */
-	dev->dsr->cq_ring_pages.num_pages = 4;
-	ret = pvrdma_page_dir_init(dev, &dev->cq_pdir,
-				   dev->dsr->cq_ring_pages.num_pages, true);
-	if (ret)
-		goto err_free_async_ring;
-	dev->cq_ring_state = dev->cq_pdir.pages[0];
-	dev->dsr->cq_ring_pages.pdir_dma = dev->cq_pdir.dir_dma;
-
-	/*
-	 * Write the PA of the shared region to the device. The writes must be
-	 * ordered such that the high bits are written last. When the writes
-	 * complete, the device will have filled out the capabilities.
-	 */
-
-	pvrdma_write_reg(dev, PVRDMA_REG_DSRLOW, (u32)dev->dsrbase);
-	pvrdma_write_reg(dev, PVRDMA_REG_DSRHIGH,
-			 (u32)((u64)(dev->dsrbase) >> 32));
-
-	/* Make sure the write is complete before reading status. */
-	mb();
-
-	/* Currently, the driver only supports RoCE mode. */
-	if (dev->dsr->caps.mode != PVRDMA_DEVICE_MODE_ROCE) {
-		dev_err(&pdev->dev, "unsupported transport %d\n",
-			dev->dsr->caps.mode);
-		ret = -EFAULT;
-		goto err_free_cq_ring;
-	}
-
-	/* Currently, the driver only supports RoCE V1. */
-	if (!(dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V1)) {
-		dev_err(&pdev->dev, "driver needs RoCE v1 support\n");
-		ret = -EFAULT;
-		goto err_free_cq_ring;
-	}
-
-	/* Paired vmxnet3 will have same bus, slot. But func will be 0 */
-	pdev_net = pci_get_slot(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
-	if (!pdev_net) {
-		dev_err(&pdev->dev, "failed to find paired net device\n");
-		ret = -ENODEV;
-		goto err_free_cq_ring;
-	}
-
-	if (pdev_net->vendor != PCI_VENDOR_ID_VMWARE ||
-	    pdev_net->device != PCI_DEVICE_ID_VMWARE_VMXNET3) {
-		dev_err(&pdev->dev, "failed to find paired vmxnet3 device\n");
-		pci_dev_put(pdev_net);
-		ret = -ENODEV;
-		goto err_free_cq_ring;
-	}
-
-	dev->netdev = pci_get_drvdata(pdev_net);
-	pci_dev_put(pdev_net);
-	if (!dev->netdev) {
-		dev_err(&pdev->dev, "failed to get vmxnet3 device\n");
-		ret = -ENODEV;
-		goto err_free_cq_ring;
-	}
-
-	dev_info(&pdev->dev, "paired device to %s\n", dev->netdev->name);
-
-	/* Interrupt setup */
-	ret = pvrdma_alloc_intrs(dev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to allocate interrupts\n");
-		ret = -ENOMEM;
-		goto err_netdevice;
-	}
-
-	/* Allocate UAR table. */
-	ret = pvrdma_uar_table_init(dev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to allocate UAR table\n");
-		ret = -ENOMEM;
-		goto err_free_intrs;
-	}
-
-	/* Allocate GID table */
-	dev->sgid_tbl = kcalloc(dev->dsr->caps.gid_tbl_len,
-				sizeof(union ib_gid), GFP_KERNEL);
-	if (!dev->sgid_tbl) {
-		ret = -ENOMEM;
-		goto err_free_uar_table;
-	}
-	dev_dbg(&pdev->dev, "gid table len %d\n", dev->dsr->caps.gid_tbl_len);
-
-	pvrdma_enable_intrs(dev);
-
-	/* Activate pvrdma device */
-	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
-
-	/* Make sure the write is complete before reading status. */
-	mb();
-
-	/* Check if device was successfully activated */
-	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "failed to activate device\n");
-		ret = -EFAULT;
-		goto err_disable_intr;
-	}
-
-	/* Register IB device */
-	ret = pvrdma_register_device(dev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register IB device\n");
-		goto err_disable_intr;
-	}
-
-	dev->nb_netdev.notifier_call = pvrdma_netdevice_event;
-	ret = register_netdevice_notifier(&dev->nb_netdev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register netdevice events\n");
-		goto err_unreg_ibdev;
-	}
-
-	dev_info(&pdev->dev, "attached to device\n");
-	return 0;
-
-err_unreg_ibdev:
-	ib_unregister_device(&dev->ib_dev);
-err_disable_intr:
-	pvrdma_disable_intrs(dev);
-	kfree(dev->sgid_tbl);
-err_free_uar_table:
-	pvrdma_uar_table_cleanup(dev);
-err_free_intrs:
-	pvrdma_free_irq(dev);
-	pvrdma_disable_msi_all(dev);
-err_netdevice:
-	unregister_netdevice_notifier(&dev->nb_netdev);
-err_free_cq_ring:
-	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
-err_free_async_ring:
-	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
-err_free_slots:
-	pvrdma_free_slots(dev);
-err_free_dsr:
-	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
-			  dev->dsrbase);
-err_uar_unmap:
-	iounmap(dev->driver_uar.map);
-err_unmap_regs:
-	iounmap(dev->regs);
-err_free_resource:
-	pci_release_regions(pdev);
-err_disable_pdev:
-	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
-err_free_device:
-	mutex_lock(&pvrdma_device_list_lock);
-	list_del(&dev->device_link);
-	mutex_unlock(&pvrdma_device_list_lock);
-	ib_dealloc_device(&dev->ib_dev);
-	return ret;
-}
-
-static void pvrdma_pci_remove(struct pci_dev *pdev)
-{
-	struct pvrdma_dev *dev = pci_get_drvdata(pdev);
-
-	if (!dev)
-		return;
-
-	dev_info(&pdev->dev, "detaching from device\n");
-
-	unregister_netdevice_notifier(&dev->nb_netdev);
-	dev->nb_netdev.notifier_call = NULL;
-
-	flush_workqueue(event_wq);
-
-	/* Unregister ib device */
-	ib_unregister_device(&dev->ib_dev);
-
-	mutex_lock(&pvrdma_device_list_lock);
-	list_del(&dev->device_link);
-	mutex_unlock(&pvrdma_device_list_lock);
-
-	pvrdma_disable_intrs(dev);
-	pvrdma_free_irq(dev);
-	pvrdma_disable_msi_all(dev);
-
-	/* Deactivate pvrdma device */
-	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_RESET);
-	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
-	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
-	pvrdma_free_slots(dev);
-
-	iounmap(dev->regs);
-	kfree(dev->sgid_tbl);
-	kfree(dev->cq_tbl);
-	kfree(dev->qp_tbl);
-	pvrdma_uar_table_cleanup(dev);
-	iounmap(dev->driver_uar.map);
-
-	ib_dealloc_device(&dev->ib_dev);
-
-	/* Free pci resources */
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
-}
-
-static struct pci_device_id pvrdma_pci_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_PVRDMA), },
-	{ 0 },
-};
-
-MODULE_DEVICE_TABLE(pci, pvrdma_pci_table);
-
-static struct pci_driver pvrdma_driver = {
-	.name		= DRV_NAME,
-	.id_table	= pvrdma_pci_table,
-	.probe		= pvrdma_pci_probe,
-	.remove		= pvrdma_pci_remove,
-};
-
-static int __init pvrdma_init(void)
-{
-	int err;
-
-	event_wq = alloc_ordered_workqueue("pvrdma_event_wq", WQ_MEM_RECLAIM);
-	if (!event_wq)
-		return -ENOMEM;
-
-	err = pci_register_driver(&pvrdma_driver);
-	if (err)
-		destroy_workqueue(event_wq);
-
-	return err;
-}
-
-static void __exit pvrdma_cleanup(void)
-{
-	pci_unregister_driver(&pvrdma_driver);
-
-	destroy_workqueue(event_wq);
-}
-
-module_init(pvrdma_init);
-module_exit(pvrdma_cleanup);
-
-MODULE_AUTHOR("VMware, Inc");
-MODULE_DESCRIPTION("VMware Paravirtual RDMA driver");
-MODULE_VERSION(DRV_VERSION);
-MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/pvrdma/pvrdma_misc.c
deleted file mode 100644
index 948b5cc..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_misc.c
+++ /dev/null
@@ -1,304 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <linux/bitmap.h>
-
-#include "pvrdma.h"
-
-int pvrdma_page_dir_init(struct pvrdma_dev *dev, struct pvrdma_page_dir *pdir,
-			 u64 npages, bool alloc_pages)
-{
-	u64 i;
-
-	if (npages > PVRDMA_PAGE_DIR_MAX_PAGES)
-		return -EINVAL;
-
-	memset(pdir, 0, sizeof(*pdir));
-
-	pdir->dir = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
-				       &pdir->dir_dma, GFP_KERNEL);
-	if (!pdir->dir)
-		goto err;
-
-	pdir->ntables = PVRDMA_PAGE_DIR_TABLE(npages - 1) + 1;
-	pdir->tables = kcalloc(pdir->ntables, sizeof(*pdir->tables),
-			       GFP_KERNEL);
-	if (!pdir->tables)
-		goto err;
-
-	for (i = 0; i < pdir->ntables; i++) {
-		pdir->tables[i] = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
-						(dma_addr_t *)&pdir->dir[i],
-						GFP_KERNEL);
-		if (!pdir->tables[i])
-			goto err;
-	}
-
-	pdir->npages = npages;
-
-	if (alloc_pages) {
-		pdir->pages = kcalloc(npages, sizeof(*pdir->pages),
-				      GFP_KERNEL);
-		if (!pdir->pages)
-			goto err;
-
-		for (i = 0; i < pdir->npages; i++) {
-			dma_addr_t page_dma;
-
-			pdir->pages[i] = dma_alloc_coherent(&dev->pdev->dev,
-							    PAGE_SIZE,
-							    &page_dma,
-							    GFP_KERNEL);
-			if (!pdir->pages[i])
-				goto err;
-
-			pvrdma_page_dir_insert_dma(pdir, i, page_dma);
-		}
-	}
-
-	return 0;
-
-err:
-	pvrdma_page_dir_cleanup(dev, pdir);
-
-	return -ENOMEM;
-}
-
-static u64 *pvrdma_page_dir_table(struct pvrdma_page_dir *pdir, u64 idx)
-{
-	return pdir->tables[PVRDMA_PAGE_DIR_TABLE(idx)];
-}
-
-dma_addr_t pvrdma_page_dir_get_dma(struct pvrdma_page_dir *pdir, u64 idx)
-{
-	return pvrdma_page_dir_table(pdir, idx)[PVRDMA_PAGE_DIR_PAGE(idx)];
-}
-
-static void pvrdma_page_dir_cleanup_pages(struct pvrdma_dev *dev,
-					  struct pvrdma_page_dir *pdir)
-{
-	if (pdir->pages) {
-		u64 i;
-
-		for (i = 0; i < pdir->npages && pdir->pages[i]; i++) {
-			dma_addr_t page_dma = pvrdma_page_dir_get_dma(pdir, i);
-
-			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
-					  pdir->pages[i], page_dma);
-		}
-
-		kfree(pdir->pages);
-	}
-}
-
-static void pvrdma_page_dir_cleanup_tables(struct pvrdma_dev *dev,
-					   struct pvrdma_page_dir *pdir)
-{
-	if (pdir->tables) {
-		int i;
-
-		pvrdma_page_dir_cleanup_pages(dev, pdir);
-
-		for (i = 0; i < pdir->ntables; i++) {
-			u64 *table = pdir->tables[i];
-
-			if (table)
-				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
-						  table, pdir->dir[i]);
-		}
-
-		kfree(pdir->tables);
-	}
-}
-
-void pvrdma_page_dir_cleanup(struct pvrdma_dev *dev,
-			     struct pvrdma_page_dir *pdir)
-{
-	if (pdir->dir) {
-		pvrdma_page_dir_cleanup_tables(dev, pdir);
-		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
-				  pdir->dir, pdir->dir_dma);
-	}
-}
-
-int pvrdma_page_dir_insert_dma(struct pvrdma_page_dir *pdir, u64 idx,
-			       dma_addr_t daddr)
-{
-	u64 *table;
-
-	if (idx >= pdir->npages)
-		return -EINVAL;
-
-	table = pvrdma_page_dir_table(pdir, idx);
-	table[PVRDMA_PAGE_DIR_PAGE(idx)] = daddr;
-
-	return 0;
-}
-
-int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
-				struct ib_umem *umem, u64 offset)
-{
-	u64 i = offset;
-	int j, entry;
-	int ret = 0, len = 0;
-	struct scatterlist *sg;
-
-	if (offset >= pdir->npages)
-		return -EINVAL;
-
-	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-		len = sg_dma_len(sg) >> PAGE_SHIFT;
-		for (j = 0; j < len; j++) {
-			dma_addr_t addr = sg_dma_address(sg) +
-					  umem->page_size * j;
-
-			ret = pvrdma_page_dir_insert_dma(pdir, i, addr);
-			if (ret)
-				goto exit;
-
-			i++;
-		}
-	}
-
-exit:
-	return ret;
-}
-
-int pvrdma_page_dir_insert_page_list(struct pvrdma_page_dir *pdir,
-				     u64 *page_list,
-				     int num_pages)
-{
-	int i;
-	int ret;
-
-	if (num_pages > pdir->npages)
-		return -EINVAL;
-
-	for (i = 0; i < num_pages; i++) {
-		ret = pvrdma_page_dir_insert_dma(pdir, i, page_list[i]);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-void pvrdma_qp_cap_to_ib(struct ib_qp_cap *dst, const struct pvrdma_qp_cap *src)
-{
-	dst->max_send_wr = src->max_send_wr;
-	dst->max_recv_wr = src->max_recv_wr;
-	dst->max_send_sge = src->max_send_sge;
-	dst->max_recv_sge = src->max_recv_sge;
-	dst->max_inline_data = src->max_inline_data;
-}
-
-void ib_qp_cap_to_pvrdma(struct pvrdma_qp_cap *dst, const struct ib_qp_cap *src)
-{
-	dst->max_send_wr = src->max_send_wr;
-	dst->max_recv_wr = src->max_recv_wr;
-	dst->max_send_sge = src->max_send_sge;
-	dst->max_recv_sge = src->max_recv_sge;
-	dst->max_inline_data = src->max_inline_data;
-}
-
-void pvrdma_gid_to_ib(union ib_gid *dst, const union pvrdma_gid *src)
-{
-	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
-	memcpy(dst, src, sizeof(*src));
-}
-
-void ib_gid_to_pvrdma(union pvrdma_gid *dst, const union ib_gid *src)
-{
-	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
-	memcpy(dst, src, sizeof(*src));
-}
-
-void pvrdma_global_route_to_ib(struct ib_global_route *dst,
-			       const struct pvrdma_global_route *src)
-{
-	pvrdma_gid_to_ib(&dst->dgid, &src->dgid);
-	dst->flow_label = src->flow_label;
-	dst->sgid_index = src->sgid_index;
-	dst->hop_limit = src->hop_limit;
-	dst->traffic_class = src->traffic_class;
-}
-
-void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
-			       const struct ib_global_route *src)
-{
-	ib_gid_to_pvrdma(&dst->dgid, &src->dgid);
-	dst->flow_label = src->flow_label;
-	dst->sgid_index = src->sgid_index;
-	dst->hop_limit = src->hop_limit;
-	dst->traffic_class = src->traffic_class;
-}
-
-void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
-			  const struct pvrdma_ah_attr *src)
-{
-	pvrdma_global_route_to_ib(&dst->grh, &src->grh);
-	dst->dlid = src->dlid;
-	dst->sl = src->sl;
-	dst->src_path_bits = src->src_path_bits;
-	dst->static_rate = src->static_rate;
-	dst->ah_flags = src->ah_flags;
-	dst->port_num = src->port_num;
-	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));
-}
-
-void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
-			  const struct ib_ah_attr *src)
-{
-	ib_global_route_to_pvrdma(&dst->grh, &src->grh);
-	dst->dlid = src->dlid;
-	dst->sl = src->sl;
-	dst->src_path_bits = src->src_path_bits;
-	dst->static_rate = src->static_rate;
-	dst->ah_flags = src->ah_flags;
-	dst->port_num = src->port_num;
-	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/pvrdma/pvrdma_mr.c
deleted file mode 100644
index 8519f32..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_mr.c
+++ /dev/null
@@ -1,334 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <linux/list.h>
-#include <linux/slab.h>
-
-#include "pvrdma.h"
-
-/**
- * pvrdma_get_dma_mr - get a DMA memory region
- * @pd: protection domain
- * @acc: access flags
- *
- * @return: ib_mr pointer on success, otherwise returns an errno.
- */
-struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc)
-{
-	struct pvrdma_dev *dev = to_vdev(pd->device);
-	struct pvrdma_user_mr *mr;
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
-	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
-	int ret;
-
-	/* Support only LOCAL_WRITE flag for DMA MRs */
-	if (acc & ~IB_ACCESS_LOCAL_WRITE) {
-		dev_warn(&dev->pdev->dev,
-			 "unsupported dma mr access flags %#x\n", acc);
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_MR;
-	cmd->pd_handle = to_vpd(pd)->pd_handle;
-	cmd->access_flags = acc;
-	cmd->flags = PVRDMA_MR_FLAG_DMA;
-
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not get DMA mem region, error: %d\n", ret);
-		kfree(mr);
-		return ERR_PTR(ret);
-	}
-
-	mr->mmr.mr_handle = resp->mr_handle;
-	mr->ibmr.lkey = resp->lkey;
-	mr->ibmr.rkey = resp->rkey;
-
-	return &mr->ibmr;
-}
-
-/**
- * pvrdma_reg_user_mr - register a userspace memory region
- * @pd: protection domain
- * @start: starting address
- * @length: length of region
- * @virt_addr: I/O virtual address
- * @access_flags: access flags for memory region
- * @udata: user data
- *
- * @return: ib_mr pointer on success, otherwise returns an errno.
- */
-struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-				 u64 virt_addr, int access_flags,
-				 struct ib_udata *udata)
-{
-	struct pvrdma_dev *dev = to_vdev(pd->device);
-	struct pvrdma_user_mr *mr = NULL;
-	struct ib_umem *umem;
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
-	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
-	int nchunks;
-	int ret;
-	int entry;
-	struct scatterlist *sg;
-
-	if (length == 0 || length > dev->dsr->caps.max_mr_size) {
-		dev_warn(&dev->pdev->dev, "invalid mem region length\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	umem = ib_umem_get(pd->uobject->context, start,
-			   length, access_flags, 0);
-	if (IS_ERR(umem)) {
-		dev_warn(&dev->pdev->dev,
-			 "could not get umem for mem region\n");
-		return ERR_CAST(umem);
-	}
-
-	nchunks = 0;
-	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry)
-		nchunks += sg_dma_len(sg) >> PAGE_SHIFT;
-
-	if (nchunks < 0 || nchunks > PVRDMA_PAGE_DIR_MAX_PAGES) {
-		dev_warn(&dev->pdev->dev, "overflow %d pages in mem region\n",
-			 nchunks);
-		ret = -EINVAL;
-		goto err_umem;
-	}
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr) {
-		ret = -ENOMEM;
-		goto err_umem;
-	}
-
-	mr->mmr.iova = virt_addr;
-	mr->mmr.size = length;
-	mr->umem = umem;
-
-	ret = pvrdma_page_dir_init(dev, &mr->pdir, nchunks, false);
-	if (ret) {
-		dev_warn(&dev->pdev->dev,
-			 "could not allocate page directory\n");
-		goto err_umem;
-	}
-
-	ret = pvrdma_page_dir_insert_umem(&mr->pdir, mr->umem, 0);
-	if (ret)
-		goto err_pdir;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_MR;
-	cmd->start = start;
-	cmd->length = length;
-	cmd->pd_handle = to_vpd(pd)->pd_handle;
-	cmd->access_flags = access_flags;
-	cmd->nchunks = nchunks;
-	cmd->pdir_dma = mr->pdir.dir_dma;
-
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not register mem region, error: %d\n", ret);
-		goto err_pdir;
-	}
-
-	mr->mmr.mr_handle = resp->mr_handle;
-	mr->ibmr.lkey = resp->lkey;
-	mr->ibmr.rkey = resp->rkey;
-
-	return &mr->ibmr;
-
-err_pdir:
-	pvrdma_page_dir_cleanup(dev, &mr->pdir);
-err_umem:
-	ib_umem_release(umem);
-	kfree(mr);
-
-	return ERR_PTR(ret);
-}
-
-/**
- * pvrdma_alloc_mr - allocate a memory region
- * @pd: protection domain
- * @mr_type: type of memory region
- * @max_num_sg: maximum number of pages
- *
- * @return: ib_mr pointer on success, otherwise returns an errno.
- */
-struct ib_mr *pvrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			      u32 max_num_sg)
-{
-	struct pvrdma_dev *dev = to_vdev(pd->device);
-	struct pvrdma_user_mr *mr;
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
-	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
-	int size = max_num_sg * sizeof(u64);
-	int ret;
-
-	if (mr_type != IB_MR_TYPE_MEM_REG ||
-	    max_num_sg > PVRDMA_MAX_FAST_REG_PAGES)
-		return ERR_PTR(-EINVAL);
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
-
-	mr->pages = kzalloc(size, GFP_KERNEL);
-	if (!mr->pages) {
-		ret = -ENOMEM;
-		goto freemr;
-	}
-
-	ret = pvrdma_page_dir_init(dev, &mr->pdir, max_num_sg, false);
-	if (ret) {
-		dev_warn(&dev->pdev->dev,
-			 "failed to allocate page dir for mr\n");
-		ret = -ENOMEM;
-		goto freepages;
-	}
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_MR;
-	cmd->pd_handle = to_vpd(pd)->pd_handle;
-	cmd->access_flags = 0;
-	cmd->flags = PVRDMA_MR_FLAG_FRMR;
-	cmd->nchunks = max_num_sg;
-
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not create FR mem region, error: %d\n", ret);
-		goto freepdir;
-	}
-
-	mr->max_pages = max_num_sg;
-	mr->mmr.mr_handle = resp->mr_handle;
-	mr->ibmr.lkey = resp->lkey;
-	mr->ibmr.rkey = resp->rkey;
-	mr->page_shift = PAGE_SHIFT;
-	mr->umem = NULL;
-
-	return &mr->ibmr;
-
-freepdir:
-	pvrdma_page_dir_cleanup(dev, &mr->pdir);
-freepages:
-	kfree(mr->pages);
-freemr:
-	kfree(mr);
-	return ERR_PTR(ret);
-}
-
-/**
- * pvrdma_dereg_mr - deregister a memory region
- * @ibmr: memory region
- *
- * @return: 0 on success.
- */
-int pvrdma_dereg_mr(struct ib_mr *ibmr)
-{
-	struct pvrdma_user_mr *mr = to_vmr(ibmr);
-	struct pvrdma_dev *dev = to_vdev(ibmr->device);
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_destroy_mr *cmd = &req.destroy_mr;
-	int ret;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_MR;
-	cmd->mr_handle = mr->mmr.mr_handle;
-	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
-	if (ret < 0)
-		dev_warn(&dev->pdev->dev,
-			 "could not deregister mem region, error: %d\n", ret);
-
-	pvrdma_page_dir_cleanup(dev, &mr->pdir);
-	if (mr->umem)
-		ib_umem_release(mr->umem);
-
-	kfree(mr->pages);
-	kfree(mr);
-
-	return 0;
-}
-
-static int pvrdma_set_page(struct ib_mr *ibmr, u64 addr)
-{
-	struct pvrdma_user_mr *mr = to_vmr(ibmr);
-
-	if (mr->npages == mr->max_pages)
-		return -ENOMEM;
-
-	mr->pages[mr->npages++] = addr;
-	return 0;
-}
-
-int pvrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		     unsigned int *sg_offset)
-{
-	struct pvrdma_user_mr *mr = to_vmr(ibmr);
-	struct pvrdma_dev *dev = to_vdev(ibmr->device);
-	int ret;
-
-	mr->npages = 0;
-
-	ret = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, pvrdma_set_page);
-	if (ret < 0)
-		dev_warn(&dev->pdev->dev, "could not map sg to pages\n");
-
-	return ret;
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/pvrdma/pvrdma_qp.c
deleted file mode 100644
index c8c01e5..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_qp.c
+++ /dev/null
@@ -1,972 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <asm/page.h>
-#include <linux/io.h>
-#include <linux/wait.h>
-#include <rdma/ib_addr.h>
-#include <rdma/ib_smi.h>
-#include <rdma/ib_user_verbs.h>
-
-#include "pvrdma.h"
-
-static inline void get_cqs(struct pvrdma_qp *qp, struct pvrdma_cq **send_cq,
-			   struct pvrdma_cq **recv_cq)
-{
-	*send_cq = to_vcq(qp->ibqp.send_cq);
-	*recv_cq = to_vcq(qp->ibqp.recv_cq);
-}
-
-static void pvrdma_lock_cqs(struct pvrdma_cq *scq, struct pvrdma_cq *rcq,
-			    unsigned long *scq_flags,
-			    unsigned long *rcq_flags)
-	__acquires(scq->cq_lock) __acquires(rcq->cq_lock)
-{
-	if (scq == rcq) {
-		spin_lock_irqsave(&scq->cq_lock, *scq_flags);
-		__acquire(rcq->cq_lock);
-	} else if (scq->cq_handle < rcq->cq_handle) {
-		spin_lock_irqsave(&scq->cq_lock, *scq_flags);
-		spin_lock_irqsave_nested(&rcq->cq_lock, *rcq_flags,
-					 SINGLE_DEPTH_NESTING);
-	} else {
-		spin_lock_irqsave(&rcq->cq_lock, *rcq_flags);
-		spin_lock_irqsave_nested(&scq->cq_lock, *scq_flags,
-					 SINGLE_DEPTH_NESTING);
-	}
-}
-
-static void pvrdma_unlock_cqs(struct pvrdma_cq *scq, struct pvrdma_cq *rcq,
-			      unsigned long *scq_flags,
-			      unsigned long *rcq_flags)
-	__releases(scq->cq_lock) __releases(rcq->cq_lock)
-{
-	if (scq == rcq) {
-		__release(rcq->cq_lock);
-		spin_unlock_irqrestore(&scq->cq_lock, *scq_flags);
-	} else if (scq->cq_handle < rcq->cq_handle) {
-		spin_unlock_irqrestore(&rcq->cq_lock, *rcq_flags);
-		spin_unlock_irqrestore(&scq->cq_lock, *scq_flags);
-	} else {
-		spin_unlock_irqrestore(&scq->cq_lock, *scq_flags);
-		spin_unlock_irqrestore(&rcq->cq_lock, *rcq_flags);
-	}
-}
-
-static void pvrdma_reset_qp(struct pvrdma_qp *qp)
-{
-	struct pvrdma_cq *scq, *rcq;
-	unsigned long scq_flags, rcq_flags;
-
-	/* Clean up cqes */
-	get_cqs(qp, &scq, &rcq);
-	pvrdma_lock_cqs(scq, rcq, &scq_flags, &rcq_flags);
-
-	_pvrdma_flush_cqe(qp, scq);
-	if (scq != rcq)
-		_pvrdma_flush_cqe(qp, rcq);
-
-	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
-
-	/*
-	 * Reset queuepair. The checks are because usermode queuepairs won't
-	 * have kernel ringstates.
-	 */
-	if (qp->rq.ring) {
-		atomic_set(&qp->rq.ring->cons_head, 0);
-		atomic_set(&qp->rq.ring->prod_tail, 0);
-	}
-	if (qp->sq.ring) {
-		atomic_set(&qp->sq.ring->cons_head, 0);
-		atomic_set(&qp->sq.ring->prod_tail, 0);
-	}
-}
-
-static int pvrdma_set_rq_size(struct pvrdma_dev *dev,
-			      struct ib_qp_cap *req_cap,
-			      struct pvrdma_qp *qp)
-{
-	if (req_cap->max_recv_wr > dev->dsr->caps.max_qp_wr ||
-	    req_cap->max_recv_sge > dev->dsr->caps.max_sge) {
-		dev_warn(&dev->pdev->dev, "recv queue size invalid\n");
-		return -EINVAL;
-	}
-
-	qp->rq.wqe_cnt = roundup_pow_of_two(max(1U, req_cap->max_recv_wr));
-	qp->rq.max_sg = roundup_pow_of_two(max(1U, req_cap->max_recv_sge));
-
-	/* Write back */
-	req_cap->max_recv_wr = qp->rq.wqe_cnt;
-	req_cap->max_recv_sge = qp->rq.max_sg;
-
-	qp->rq.wqe_size = roundup_pow_of_two(sizeof(struct pvrdma_rq_wqe_hdr) +
-					     sizeof(struct pvrdma_sge) *
-					     qp->rq.max_sg);
-	qp->npages_recv = (qp->rq.wqe_cnt * qp->rq.wqe_size + PAGE_SIZE - 1) /
-			  PAGE_SIZE;
-
-	return 0;
-}
-
-static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap *req_cap,
-			      enum ib_qp_type type, struct pvrdma_qp *qp)
-{
-	if (req_cap->max_send_wr > dev->dsr->caps.max_qp_wr ||
-	    req_cap->max_send_sge > dev->dsr->caps.max_sge) {
-		dev_warn(&dev->pdev->dev, "send queue size invalid\n");
-		return -EINVAL;
-	}
-
-	qp->sq.wqe_cnt = roundup_pow_of_two(max(1U, req_cap->max_send_wr));
-	qp->sq.max_sg = roundup_pow_of_two(max(1U, req_cap->max_send_sge));
-
-	/* Write back */
-	req_cap->max_send_wr = qp->sq.wqe_cnt;
-	req_cap->max_send_sge = qp->sq.max_sg;
-
-	qp->sq.wqe_size = roundup_pow_of_two(sizeof(struct pvrdma_sq_wqe_hdr) +
-					     sizeof(struct pvrdma_sge) *
-					     qp->sq.max_sg);
-	/* Note: one extra page for the header. */
-	qp->npages_send = 1 + (qp->sq.wqe_cnt * qp->sq.wqe_size +
-			       PAGE_SIZE - 1) / PAGE_SIZE;
-
-	return 0;
-}
-
-/**
- * pvrdma_create_qp - create queue pair
- * @pd: protection domain
- * @init_attr: queue pair attributes
- * @udata: user data
- *
- * @return: the ib_qp pointer on success, otherwise returns an errno.
- */
-struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
-			       struct ib_qp_init_attr *init_attr,
-			       struct ib_udata *udata)
-{
-	struct pvrdma_qp *qp = NULL;
-	struct pvrdma_dev *dev = to_vdev(pd->device);
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_qp *cmd = &req.create_qp;
-	struct pvrdma_cmd_create_qp_resp *resp = &rsp.create_qp_resp;
-	struct pvrdma_create_qp ucmd;
-	unsigned long flags;
-	int ret;
-
-	if (init_attr->create_flags) {
-		dev_warn(&dev->pdev->dev,
-			 "invalid create queuepair flags %#x\n",
-			 init_attr->create_flags);
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (init_attr->qp_type != IB_QPT_RC &&
-	    init_attr->qp_type != IB_QPT_UD &&
-	    init_attr->qp_type != IB_QPT_GSI) {
-		dev_warn(&dev->pdev->dev, "queuepair type %d not supported\n",
-			 init_attr->qp_type);
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (!atomic_add_unless(&dev->num_qps, 1, dev->dsr->caps.max_qp))
-		return ERR_PTR(-ENOMEM);
-
-	switch (init_attr->qp_type) {
-	case IB_QPT_GSI:
-		if (init_attr->port_num == 0 ||
-		    init_attr->port_num > pd->device->phys_port_cnt ||
-		    udata) {
-			dev_warn(&dev->pdev->dev, "invalid queuepair attrs\n");
-			ret = -EINVAL;
-			goto err_qp;
-		}
-		/* fall through */
-	case IB_QPT_RC:
-	case IB_QPT_UD:
-		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
-		if (!qp) {
-			ret = -ENOMEM;
-			goto err_qp;
-		}
-
-		spin_lock_init(&qp->sq.lock);
-		spin_lock_init(&qp->rq.lock);
-		mutex_init(&qp->mutex);
-		atomic_set(&qp->refcnt, 1);
-		init_waitqueue_head(&qp->wait);
-
-		qp->state = IB_QPS_RESET;
-
-		if (pd->uobject && udata) {
-			dev_dbg(&dev->pdev->dev,
-				"create queuepair from user space\n");
-
-			if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
-				ret = -EFAULT;
-				goto err_qp;
-			}
-
-			/* set qp->sq.wqe_cnt, shift, buf_size.. */
-			qp->rumem = ib_umem_get(pd->uobject->context,
-						ucmd.rbuf_addr,
-						ucmd.rbuf_size, 0, 0);
-			if (IS_ERR(qp->rumem)) {
-				ret = PTR_ERR(qp->rumem);
-				goto err_qp;
-			}
-
-			qp->sumem = ib_umem_get(pd->uobject->context,
-						ucmd.sbuf_addr,
-						ucmd.sbuf_size, 0, 0);
-			if (IS_ERR(qp->sumem)) {
-				ib_umem_release(qp->rumem);
-				ret = PTR_ERR(qp->sumem);
-				goto err_qp;
-			}
-
-			qp->npages_send = ib_umem_page_count(qp->sumem);
-			qp->npages_recv = ib_umem_page_count(qp->rumem);
-			qp->npages = qp->npages_send + qp->npages_recv;
-		} else {
-			qp->is_kernel = true;
-
-			ret = pvrdma_set_sq_size(to_vdev(pd->device),
-						 &init_attr->cap,
-						 init_attr->qp_type, qp);
-			if (ret)
-				goto err_qp;
-
-			ret = pvrdma_set_rq_size(to_vdev(pd->device),
-						 &init_attr->cap, qp);
-			if (ret)
-				goto err_qp;
-
-			qp->npages = qp->npages_send + qp->npages_recv;
-
-			/* Skip header page. */
-			qp->sq.offset = PAGE_SIZE;
-
-			/* Recv queue pages are after send pages. */
-			qp->rq.offset = qp->npages_send * PAGE_SIZE;
-		}
-
-		if (qp->npages < 0 || qp->npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
-			dev_warn(&dev->pdev->dev,
-				 "overflow pages in queuepair\n");
-			ret = -EINVAL;
-			goto err_umem;
-		}
-
-		ret = pvrdma_page_dir_init(dev, &qp->pdir, qp->npages,
-					   qp->is_kernel);
-		if (ret) {
-			dev_warn(&dev->pdev->dev,
-				 "could not allocate page directory\n");
-			goto err_umem;
-		}
-
-		if (!qp->is_kernel) {
-			pvrdma_page_dir_insert_umem(&qp->pdir, qp->sumem, 0);
-			pvrdma_page_dir_insert_umem(&qp->pdir, qp->rumem,
-						    qp->npages_send);
-		} else {
-			/* Ring state is always the first page. */
-			qp->sq.ring = qp->pdir.pages[0];
-			qp->rq.ring = &qp->sq.ring[1];
-		}
-		break;
-	default:
-		ret = -EINVAL;
-		goto err_qp;
-	}
-
-	/* Not supported */
-	init_attr->cap.max_inline_data = 0;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_QP;
-	cmd->pd_handle = to_vpd(pd)->pd_handle;
-	cmd->send_cq_handle = to_vcq(init_attr->send_cq)->cq_handle;
-	cmd->recv_cq_handle = to_vcq(init_attr->recv_cq)->cq_handle;
-	cmd->max_send_wr = init_attr->cap.max_send_wr;
-	cmd->max_recv_wr = init_attr->cap.max_recv_wr;
-	cmd->max_send_sge = init_attr->cap.max_send_sge;
-	cmd->max_recv_sge = init_attr->cap.max_recv_sge;
-	cmd->max_inline_data = init_attr->cap.max_inline_data;
-	cmd->sq_sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) ? 1 : 0;
-	cmd->qp_type = ib_qp_type_to_pvrdma(init_attr->qp_type);
-	cmd->access_flags = IB_ACCESS_LOCAL_WRITE;
-	cmd->total_chunks = qp->npages;
-	cmd->send_chunks = qp->npages_send - 1;
-	cmd->pdir_dma = qp->pdir.dir_dma;
-
-	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
-		cmd->max_send_wr, cmd->max_recv_wr, cmd->max_send_sge,
-		cmd->max_recv_sge);
-
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_QP_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not create queuepair, error: %d\n", ret);
-		goto err_pdir;
-	}
-
-	/* max_send_wr/_recv_wr/_send_sge/_recv_sge/_inline_data */
-	qp->qp_handle = resp->qpn;
-	qp->port = init_attr->port_num;
-	qp->ibqp.qp_num = resp->qpn;
-	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
-	dev->qp_tbl[qp->qp_handle % dev->dsr->caps.max_qp] = qp;
-	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
-
-	return &qp->ibqp;
-
-err_pdir:
-	pvrdma_page_dir_cleanup(dev, &qp->pdir);
-err_umem:
-	if (pd->uobject && udata) {
-		if (qp->rumem)
-			ib_umem_release(qp->rumem);
-		if (qp->sumem)
-			ib_umem_release(qp->sumem);
-	}
-err_qp:
-	kfree(qp);
-	atomic_dec(&dev->num_qps);
-
-	return ERR_PTR(ret);
-}
-
-static void pvrdma_free_qp(struct pvrdma_qp *qp)
-{
-	struct pvrdma_dev *dev = to_vdev(qp->ibqp.device);
-	struct pvrdma_cq *scq;
-	struct pvrdma_cq *rcq;
-	unsigned long flags, scq_flags, rcq_flags;
-
-	/* In case cq is polling */
-	get_cqs(qp, &scq, &rcq);
-	pvrdma_lock_cqs(scq, rcq, &scq_flags, &rcq_flags);
-
-	_pvrdma_flush_cqe(qp, scq);
-	if (scq != rcq)
-		_pvrdma_flush_cqe(qp, rcq);
-
-	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
-	dev->qp_tbl[qp->qp_handle] = NULL;
-	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
-
-	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
-
-	atomic_dec(&qp->refcnt);
-	wait_event(qp->wait, !atomic_read(&qp->refcnt));
-
-	pvrdma_page_dir_cleanup(dev, &qp->pdir);
-
-	kfree(qp);
-
-	atomic_dec(&dev->num_qps);
-}
-
-/**
- * pvrdma_destroy_qp - destroy a queue pair
- * @qp: the queue pair to destroy
- *
- * @return: 0 on success.
- */
-int pvrdma_destroy_qp(struct ib_qp *qp)
-{
-	struct pvrdma_qp *vqp = to_vqp(qp);
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_destroy_qp *cmd = &req.destroy_qp;
-	int ret;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_QP;
-	cmd->qp_handle = vqp->qp_handle;
-
-	ret = pvrdma_cmd_post(to_vdev(qp->device), &req, NULL, 0);
-	if (ret < 0)
-		dev_warn(&to_vdev(qp->device)->pdev->dev,
-			 "destroy queuepair failed, error: %d\n", ret);
-
-	pvrdma_free_qp(vqp);
-
-	return 0;
-}
-
-/**
- * pvrdma_modify_qp - modify queue pair attributes
- * @ibqp: the queue pair
- * @attr: the new queue pair's attributes
- * @attr_mask: attributes mask
- * @udata: user data
- *
- * @returns 0 on success, otherwise returns an errno.
- */
-int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		     int attr_mask, struct ib_udata *udata)
-{
-	struct pvrdma_dev *dev = to_vdev(ibqp->device);
-	struct pvrdma_qp *qp = to_vqp(ibqp);
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_modify_qp *cmd = &req.modify_qp;
-	int cur_state, next_state;
-	int ret;
-
-	/* Sanity checking. Should need lock here */
-	mutex_lock(&qp->mutex);
-	cur_state = (attr_mask & IB_QP_CUR_STATE) ? attr->cur_qp_state :
-		qp->state;
-	next_state = (attr_mask & IB_QP_STATE) ? attr->qp_state : cur_state;
-
-	if (!ib_modify_qp_is_ok(cur_state, next_state, ibqp->qp_type,
-				attr_mask, IB_LINK_LAYER_ETHERNET)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (attr_mask & IB_QP_PORT) {
-		if (attr->port_num == 0 ||
-		    attr->port_num > ibqp->device->phys_port_cnt) {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	if (attr_mask & IB_QP_MIN_RNR_TIMER) {
-		if (attr->min_rnr_timer > 31) {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	if (attr_mask & IB_QP_PKEY_INDEX) {
-		if (attr->pkey_index >= dev->dsr->caps.max_pkeys) {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	if (attr_mask & IB_QP_QKEY)
-		qp->qkey = attr->qkey;
-
-	if (cur_state == next_state && cur_state == IB_QPS_RESET) {
-		ret = 0;
-		goto out;
-	}
-
-	qp->state = next_state;
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_MODIFY_QP;
-	cmd->qp_handle = qp->qp_handle;
-	cmd->attr_mask = ib_qp_attr_mask_to_pvrdma(attr_mask);
-	cmd->attrs.qp_state = ib_qp_state_to_pvrdma(attr->qp_state);
-	cmd->attrs.cur_qp_state =
-		ib_qp_state_to_pvrdma(attr->cur_qp_state);
-	cmd->attrs.path_mtu = ib_mtu_to_pvrdma(attr->path_mtu);
-	cmd->attrs.path_mig_state =
-		ib_mig_state_to_pvrdma(attr->path_mig_state);
-	cmd->attrs.qkey = attr->qkey;
-	cmd->attrs.rq_psn = attr->rq_psn;
-	cmd->attrs.sq_psn = attr->sq_psn;
-	cmd->attrs.dest_qp_num = attr->dest_qp_num;
-	cmd->attrs.qp_access_flags =
-		ib_access_flags_to_pvrdma(attr->qp_access_flags);
-	cmd->attrs.pkey_index = attr->pkey_index;
-	cmd->attrs.alt_pkey_index = attr->alt_pkey_index;
-	cmd->attrs.en_sqd_async_notify = attr->en_sqd_async_notify;
-	cmd->attrs.sq_draining = attr->sq_draining;
-	cmd->attrs.max_rd_atomic = attr->max_rd_atomic;
-	cmd->attrs.max_dest_rd_atomic = attr->max_dest_rd_atomic;
-	cmd->attrs.min_rnr_timer = attr->min_rnr_timer;
-	cmd->attrs.port_num = attr->port_num;
-	cmd->attrs.timeout = attr->timeout;
-	cmd->attrs.retry_cnt = attr->retry_cnt;
-	cmd->attrs.rnr_retry = attr->rnr_retry;
-	cmd->attrs.alt_port_num = attr->alt_port_num;
-	cmd->attrs.alt_timeout = attr->alt_timeout;
-	ib_qp_cap_to_pvrdma(&cmd->attrs.cap, &attr->cap);
-	ib_ah_attr_to_pvrdma(&cmd->attrs.ah_attr, &attr->ah_attr);
-	ib_ah_attr_to_pvrdma(&cmd->attrs.alt_ah_attr, &attr->alt_ah_attr);
-
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_MODIFY_QP_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not modify queuepair, error: %d\n", ret);
-	} else if (rsp.hdr.err > 0) {
-		dev_warn(&dev->pdev->dev,
-			 "cannot modify queuepair, error: %d\n", rsp.hdr.err);
-		ret = -EINVAL;
-	}
-
-	if (ret == 0 && next_state == IB_QPS_RESET)
-		pvrdma_reset_qp(qp);
-
-out:
-	mutex_unlock(&qp->mutex);
-
-	return ret;
-}
-
-static inline void *get_sq_wqe(struct pvrdma_qp *qp, int n)
-{
-	return pvrdma_page_dir_get_ptr(&qp->pdir,
-				       qp->sq.offset + n * qp->sq.wqe_size);
-}
-
-static inline void *get_rq_wqe(struct pvrdma_qp *qp, int n)
-{
-	return pvrdma_page_dir_get_ptr(&qp->pdir,
-				       qp->rq.offset + n * qp->rq.wqe_size);
-}
-
-static int set_reg_seg(struct pvrdma_sq_wqe_hdr *wqe_hdr, struct ib_reg_wr *wr)
-{
-	struct pvrdma_user_mr *mr = to_vmr(wr->mr);
-
-	wqe_hdr->wr.fast_reg.iova_start = mr->ibmr.iova;
-	wqe_hdr->wr.fast_reg.pl_pdir_dma = mr->pdir.dir_dma;
-	wqe_hdr->wr.fast_reg.page_shift = mr->page_shift;
-	wqe_hdr->wr.fast_reg.page_list_len = mr->npages;
-	wqe_hdr->wr.fast_reg.length = mr->ibmr.length;
-	wqe_hdr->wr.fast_reg.access_flags = wr->access;
-	wqe_hdr->wr.fast_reg.rkey = wr->key;
-
-	return pvrdma_page_dir_insert_page_list(&mr->pdir, mr->pages,
-						mr->npages);
-}
-
-/**
- * pvrdma_post_send - post send work request entries on a QP
- * @ibqp: the QP
- * @wr: work request list to post
- * @bad_wr: the first bad WR returned
- *
- * @return: 0 on success, otherwise errno returned.
- */
-int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
-		     struct ib_send_wr **bad_wr)
-{
-	struct pvrdma_qp *qp = to_vqp(ibqp);
-	struct pvrdma_dev *dev = to_vdev(ibqp->device);
-	unsigned long flags;
-	struct pvrdma_sq_wqe_hdr *wqe_hdr;
-	struct pvrdma_sge *sge;
-	int i, index;
-	int nreq;
-	int ret;
-
-	/*
-	 * In states lower than RTS, we can fail immediately. In other states,
-	 * just post and let the device figure it out.
-	 */
-	if (qp->state < IB_QPS_RTS) {
-		*bad_wr = wr;
-		return -EINVAL;
-	}
-
-	spin_lock_irqsave(&qp->sq.lock, flags);
-
-	index = pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
-	for (nreq = 0; wr; nreq++, wr = wr->next) {
-		unsigned int tail;
-
-		if (unlikely(!pvrdma_idx_ring_has_space(
-				qp->sq.ring, qp->sq.wqe_cnt, &tail))) {
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "send queue is full\n");
-			*bad_wr = wr;
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		if (unlikely(wr->num_sge > qp->sq.max_sg || wr->num_sge < 0)) {
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "send SGE overflow\n");
-			*bad_wr = wr;
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (unlikely(wr->opcode < 0)) {
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "invalid send opcode\n");
-			*bad_wr = wr;
-			ret = -EINVAL;
-			goto out;
-		}
-
-		/*
-		 * Only support UD, RC.
-		 * Need to check opcode table for thorough checking.
-		 * opcode		_UD	_UC	_RC
-		 * _SEND		x	x	x
-		 * _SEND_WITH_IMM	x	x	x
-		 * _RDMA_WRITE			x	x
-		 * _RDMA_WRITE_WITH_IMM		x	x
-		 * _LOCAL_INV			x	x
-		 * _SEND_WITH_INV		x	x
-		 * _RDMA_READ				x
-		 * _ATOMIC_CMP_AND_SWP			x
-		 * _ATOMIC_FETCH_AND_ADD		x
-		 * _MASK_ATOMIC_CMP_AND_SWP		x
-		 * _MASK_ATOMIC_FETCH_AND_ADD		x
-		 * _REG_MR				x
-		 *
-		 */
-		if (qp->ibqp.qp_type != IB_QPT_UD &&
-		    qp->ibqp.qp_type != IB_QPT_RC &&
-			wr->opcode != IB_WR_SEND) {
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "unsupported queuepair type\n");
-			*bad_wr = wr;
-			ret = -EINVAL;
-			goto out;
-		} else if (qp->ibqp.qp_type == IB_QPT_UD ||
-			   qp->ibqp.qp_type == IB_QPT_GSI) {
-			if (wr->opcode != IB_WR_SEND &&
-			    wr->opcode != IB_WR_SEND_WITH_IMM) {
-				dev_warn_ratelimited(&dev->pdev->dev,
-						     "invalid send opcode\n");
-				*bad_wr = wr;
-				ret = -EINVAL;
-				goto out;
-			}
-		}
-
-		wqe_hdr = (struct pvrdma_sq_wqe_hdr *)get_sq_wqe(qp, index);
-		memset(wqe_hdr, 0, sizeof(*wqe_hdr));
-		wqe_hdr->wr_id = wr->wr_id;
-		wqe_hdr->num_sge = wr->num_sge;
-		wqe_hdr->opcode = ib_wr_opcode_to_pvrdma(wr->opcode);
-		wqe_hdr->send_flags = ib_send_flags_to_pvrdma(wr->send_flags);
-		if (wr->opcode == IB_WR_SEND_WITH_IMM ||
-		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
-			wqe_hdr->ex.imm_data = wr->ex.imm_data;
-
-		switch (qp->ibqp.qp_type) {
-		case IB_QPT_GSI:
-		case IB_QPT_UD:
-			if (unlikely(!ud_wr(wr)->ah)) {
-				dev_warn_ratelimited(&dev->pdev->dev,
-						     "invalid address handle\n");
-				*bad_wr = wr;
-				ret = -EINVAL;
-				goto out;
-			}
-
-			/*
-			 * Use qkey from qp context if high order bit set,
-			 * otherwise from work request.
-			 */
-			wqe_hdr->wr.ud.remote_qpn = ud_wr(wr)->remote_qpn;
-			wqe_hdr->wr.ud.remote_qkey =
-				ud_wr(wr)->remote_qkey & 0x80000000 ?
-				qp->qkey : ud_wr(wr)->remote_qkey;
-			wqe_hdr->wr.ud.av = to_vah(ud_wr(wr)->ah)->av;
-
-			break;
-		case IB_QPT_RC:
-			switch (wr->opcode) {
-			case IB_WR_RDMA_READ:
-			case IB_WR_RDMA_WRITE:
-			case IB_WR_RDMA_WRITE_WITH_IMM:
-				wqe_hdr->wr.rdma.remote_addr =
-					rdma_wr(wr)->remote_addr;
-				wqe_hdr->wr.rdma.rkey = rdma_wr(wr)->rkey;
-				break;
-			case IB_WR_LOCAL_INV:
-			case IB_WR_SEND_WITH_INV:
-				wqe_hdr->ex.invalidate_rkey =
-					wr->ex.invalidate_rkey;
-				break;
-			case IB_WR_ATOMIC_CMP_AND_SWP:
-			case IB_WR_ATOMIC_FETCH_AND_ADD:
-				wqe_hdr->wr.atomic.remote_addr =
-					atomic_wr(wr)->remote_addr;
-				wqe_hdr->wr.atomic.rkey = atomic_wr(wr)->rkey;
-				wqe_hdr->wr.atomic.compare_add =
-					atomic_wr(wr)->compare_add;
-				if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP)
-					wqe_hdr->wr.atomic.swap =
-						atomic_wr(wr)->swap;
-				break;
-			case IB_WR_REG_MR:
-				ret = set_reg_seg(wqe_hdr, reg_wr(wr));
-				if (ret < 0) {
-					dev_warn_ratelimited(&dev->pdev->dev,
-							     "Failed to set fast register work request\n");
-					*bad_wr = wr;
-					goto out;
-				}
-				break;
-			default:
-				break;
-			}
-
-			break;
-		default:
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "invalid queuepair type\n");
-			ret = -EINVAL;
-			*bad_wr = wr;
-			goto out;
-		}
-
-		sge = (struct pvrdma_sge *)(wqe_hdr + 1);
-		for (i = 0; i < wr->num_sge; i++) {
-			/* Need to check wqe_size 0 or max size */
-			sge->addr = wr->sg_list[i].addr;
-			sge->length = wr->sg_list[i].length;
-			sge->lkey = wr->sg_list[i].lkey;
-			sge++;
-		}
-
-		/* Make sure wqe is written before index update */
-		smp_wmb();
-
-		index++;
-		if (unlikely(index >= qp->sq.wqe_cnt))
-			index = 0;
-		/* Update shared sq ring */
-		pvrdma_idx_ring_inc(&qp->sq.ring->prod_tail,
-				    qp->sq.wqe_cnt);
-	}
-
-	ret = 0;
-
-out:
-	spin_unlock_irqrestore(&qp->sq.lock, flags);
-
-	if (!ret)
-		pvrdma_write_uar_qp(dev, PVRDMA_UAR_QP_SEND | qp->qp_handle);
-
-	return ret;
-}
-
-/**
- * pvrdma_post_receive - post receive work request entries on a QP
- * @ibqp: the QP
- * @wr: the work request list to post
- * @bad_wr: the first bad WR returned
- *
- * @return: 0 on success, otherwise errno returned.
- */
-int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
-		     struct ib_recv_wr **bad_wr)
-{
-	struct pvrdma_dev *dev = to_vdev(ibqp->device);
-	unsigned long flags;
-	struct pvrdma_qp *qp = to_vqp(ibqp);
-	struct pvrdma_rq_wqe_hdr *wqe_hdr;
-	struct pvrdma_sge *sge;
-	int index, nreq;
-	int ret = 0;
-	int i;
-
-	/*
-	 * In the RESET state, we can fail immediately. For other states,
-	 * just post and let the device figure it out.
-	 */
-	if (qp->state == IB_QPS_RESET) {
-		*bad_wr = wr;
-		return -EINVAL;
-	}
-
-	spin_lock_irqsave(&qp->rq.lock, flags);
-
-	index = pvrdma_idx(&qp->rq.ring->prod_tail, qp->rq.wqe_cnt);
-	for (nreq = 0; wr; nreq++, wr = wr->next) {
-		unsigned int tail;
-
-		if (unlikely(wr->num_sge > qp->rq.max_sg ||
-			     wr->num_sge < 0)) {
-			ret = -EINVAL;
-			*bad_wr = wr;
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "recv SGE overflow\n");
-			goto out;
-		}
-
-		if (unlikely(!pvrdma_idx_ring_has_space(
-				qp->rq.ring, qp->rq.wqe_cnt, &tail))) {
-			ret = -ENOMEM;
-			*bad_wr = wr;
-			dev_warn_ratelimited(&dev->pdev->dev,
-					     "recv queue full\n");
-			goto out;
-		}
-
-		wqe_hdr = (struct pvrdma_rq_wqe_hdr *)get_rq_wqe(qp, index);
-		wqe_hdr->wr_id = wr->wr_id;
-		wqe_hdr->num_sge = wr->num_sge;
-		wqe_hdr->total_len = 0;
-
-		sge = (struct pvrdma_sge *)(wqe_hdr + 1);
-		for (i = 0; i < wr->num_sge; i++) {
-			sge->addr = wr->sg_list[i].addr;
-			sge->length = wr->sg_list[i].length;
-			sge->lkey = wr->sg_list[i].lkey;
-			sge++;
-		}
-
-		/* Make sure wqe is written before index update */
-		smp_wmb();
-
-		index++;
-		if (unlikely(index >= qp->rq.wqe_cnt))
-			index = 0;
-		/* Update shared rq ring */
-		pvrdma_idx_ring_inc(&qp->rq.ring->prod_tail,
-				    qp->rq.wqe_cnt);
-	}
-
-	spin_unlock_irqrestore(&qp->rq.lock, flags);
-
-	pvrdma_write_uar_qp(dev, PVRDMA_UAR_QP_RECV | qp->qp_handle);
-
-	return ret;
-
-out:
-	spin_unlock_irqrestore(&qp->rq.lock, flags);
-
-	return ret;
-}
-
-/**
- * pvrdma_query_qp - query a queue pair's attributes
- * @ibqp: the queue pair to query
- * @attr: the queue pair's attributes
- * @attr_mask: attributes mask
- * @init_attr: initial queue pair attributes
- *
- * @returns 0 on success, otherwise returns an errno.
- */
-int pvrdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		    int attr_mask, struct ib_qp_init_attr *init_attr)
-{
-	struct pvrdma_dev *dev = to_vdev(ibqp->device);
-	struct pvrdma_qp *qp = to_vqp(ibqp);
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_query_qp *cmd = &req.query_qp;
-	struct pvrdma_cmd_query_qp_resp *resp = &rsp.query_qp_resp;
-	int ret = 0;
-
-	mutex_lock(&qp->mutex);
-
-	if (qp->state == IB_QPS_RESET) {
-		attr->qp_state = IB_QPS_RESET;
-		goto out;
-	}
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_QUERY_QP;
-	cmd->qp_handle = qp->qp_handle;
-	cmd->attr_mask = ib_qp_attr_mask_to_pvrdma(attr_mask);
-
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_QUERY_QP_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not query queuepair, error: %d\n", ret);
-		goto out;
-	}
-
-	attr->qp_state = pvrdma_qp_state_to_ib(resp->attrs.qp_state);
-	attr->cur_qp_state =
-		pvrdma_qp_state_to_ib(resp->attrs.cur_qp_state);
-	attr->path_mtu = pvrdma_mtu_to_ib(resp->attrs.path_mtu);
-	attr->path_mig_state =
-		pvrdma_mig_state_to_ib(resp->attrs.path_mig_state);
-	attr->qkey = resp->attrs.qkey;
-	attr->rq_psn = resp->attrs.rq_psn;
-	attr->sq_psn = resp->attrs.sq_psn;
-	attr->dest_qp_num = resp->attrs.dest_qp_num;
-	attr->qp_access_flags =
-		pvrdma_access_flags_to_ib(resp->attrs.qp_access_flags);
-	attr->pkey_index = resp->attrs.pkey_index;
-	attr->alt_pkey_index = resp->attrs.alt_pkey_index;
-	attr->en_sqd_async_notify = resp->attrs.en_sqd_async_notify;
-	attr->sq_draining = resp->attrs.sq_draining;
-	attr->max_rd_atomic = resp->attrs.max_rd_atomic;
-	attr->max_dest_rd_atomic = resp->attrs.max_dest_rd_atomic;
-	attr->min_rnr_timer = resp->attrs.min_rnr_timer;
-	attr->port_num = resp->attrs.port_num;
-	attr->timeout = resp->attrs.timeout;
-	attr->retry_cnt = resp->attrs.retry_cnt;
-	attr->rnr_retry = resp->attrs.rnr_retry;
-	attr->alt_port_num = resp->attrs.alt_port_num;
-	attr->alt_timeout = resp->attrs.alt_timeout;
-	pvrdma_qp_cap_to_ib(&attr->cap, &resp->attrs.cap);
-	pvrdma_ah_attr_to_ib(&attr->ah_attr, &resp->attrs.ah_attr);
-	pvrdma_ah_attr_to_ib(&attr->alt_ah_attr, &resp->attrs.alt_ah_attr);
-
-	qp->state = attr->qp_state;
-
-	ret = 0;
-
-out:
-	attr->cur_qp_state = attr->qp_state;
-
-	init_attr->event_handler = qp->ibqp.event_handler;
-	init_attr->qp_context = qp->ibqp.qp_context;
-	init_attr->send_cq = qp->ibqp.send_cq;
-	init_attr->recv_cq = qp->ibqp.recv_cq;
-	init_attr->srq = qp->ibqp.srq;
-	init_attr->xrcd = NULL;
-	init_attr->cap = attr->cap;
-	init_attr->sq_sig_type = 0;
-	init_attr->qp_type = qp->ibqp.qp_type;
-	init_attr->create_flags = 0;
-	init_attr->port_num = qp->port;
-
-	mutex_unlock(&qp->mutex);
-	return ret;
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_ring.h b/drivers/infiniband/hw/pvrdma/pvrdma_ring.h
deleted file mode 100644
index ed9022a..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_ring.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef __PVRDMA_RING_H__
-#define __PVRDMA_RING_H__
-
-#include <linux/types.h>
-
-#define PVRDMA_INVALID_IDX	-1	/* Invalid index. */
-
-struct pvrdma_ring {
-	atomic_t prod_tail;	/* Producer tail. */
-	atomic_t cons_head;	/* Consumer head. */
-};
-
-struct pvrdma_ring_state {
-	struct pvrdma_ring tx;	/* Tx ring. */
-	struct pvrdma_ring rx;	/* Rx ring. */
-};
-
-static inline int pvrdma_idx_valid(__u32 idx, __u32 max_elems)
-{
-	/* Generates fewer instructions than a less-than. */
-	return (idx & ~((max_elems << 1) - 1)) == 0;
-}
-
-static inline __s32 pvrdma_idx(atomic_t *var, __u32 max_elems)
-{
-	const unsigned int idx = atomic_read(var);
-
-	if (pvrdma_idx_valid(idx, max_elems))
-		return idx & (max_elems - 1);
-	return PVRDMA_INVALID_IDX;
-}
-
-static inline void pvrdma_idx_ring_inc(atomic_t *var, __u32 max_elems)
-{
-	__u32 idx = atomic_read(var) + 1;	/* Increment. */
-
-	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
-	atomic_set(var, idx);
-}
-
-static inline __s32 pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
-					      __u32 max_elems, __u32 *out_tail)
-{
-	const __u32 tail = atomic_read(&r->prod_tail);
-	const __u32 head = atomic_read(&r->cons_head);
-
-	if (pvrdma_idx_valid(tail, max_elems) &&
-	    pvrdma_idx_valid(head, max_elems)) {
-		*out_tail = tail & (max_elems - 1);
-		return tail != (head ^ max_elems);
-	}
-	return PVRDMA_INVALID_IDX;
-}
-
-static inline __s32 pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
-					     __u32 max_elems, __u32 *out_head)
-{
-	const __u32 tail = atomic_read(&r->prod_tail);
-	const __u32 head = atomic_read(&r->cons_head);
-
-	if (pvrdma_idx_valid(tail, max_elems) &&
-	    pvrdma_idx_valid(head, max_elems)) {
-		*out_head = head & (max_elems - 1);
-		return tail != head;
-	}
-	return PVRDMA_INVALID_IDX;
-}
-
-static inline bool pvrdma_idx_ring_is_valid_idx(const struct pvrdma_ring *r,
-						__u32 max_elems, __u32 *idx)
-{
-	const __u32 tail = atomic_read(&r->prod_tail);
-	const __u32 head = atomic_read(&r->cons_head);
-
-	if (pvrdma_idx_valid(tail, max_elems) &&
-	    pvrdma_idx_valid(head, max_elems) &&
-	    pvrdma_idx_valid(*idx, max_elems)) {
-		if (tail > head && (*idx < tail && *idx >= head))
-			return true;
-		else if (head > tail && (*idx >= head || *idx < tail))
-			return true;
-	}
-	return false;
-}
-
-#endif /* __PVRDMA_RING_H__ */
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
deleted file mode 100644
index a7aef93d..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_verbs.c
+++ /dev/null
@@ -1,577 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <asm/page.h>
-#include <linux/inet.h>
-#include <linux/io.h>
-#include <rdma/ib_addr.h>
-#include <rdma/ib_smi.h>
-#include <rdma/ib_user_verbs.h>
-#include <rdma/pvrdma-abi.h>
-
-#include "pvrdma.h"
-
-/**
- * pvrdma_query_device - query device
- * @ibdev: the device to query
- * @props: the device properties
- * @uhw: user data
- *
- * @return: 0 on success, otherwise negative errno
- */
-int pvrdma_query_device(struct ib_device *ibdev,
-			struct ib_device_attr *props,
-			struct ib_udata *uhw)
-{
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-
-	if (uhw->inlen || uhw->outlen)
-		return -EINVAL;
-
-	memset(props, 0, sizeof(*props));
-
-	props->fw_ver = dev->dsr->caps.fw_ver;
-	props->sys_image_guid = dev->dsr->caps.sys_image_guid;
-	props->max_mr_size = dev->dsr->caps.max_mr_size;
-	props->page_size_cap = dev->dsr->caps.page_size_cap;
-	props->vendor_id = dev->dsr->caps.vendor_id;
-	props->vendor_part_id = dev->pdev->device;
-	props->hw_ver = dev->dsr->caps.hw_ver;
-	props->max_qp = dev->dsr->caps.max_qp;
-	props->max_qp_wr = dev->dsr->caps.max_qp_wr;
-	props->device_cap_flags = dev->dsr->caps.device_cap_flags;
-	props->max_sge = dev->dsr->caps.max_sge;
-	props->max_cq = dev->dsr->caps.max_cq;
-	props->max_cqe = dev->dsr->caps.max_cqe;
-	props->max_mr = dev->dsr->caps.max_mr;
-	props->max_pd = dev->dsr->caps.max_pd;
-	props->max_qp_rd_atom = dev->dsr->caps.max_qp_rd_atom;
-	props->max_qp_init_rd_atom = dev->dsr->caps.max_qp_init_rd_atom;
-	props->atomic_cap =
-		dev->dsr->caps.atomic_ops &
-		(PVRDMA_ATOMIC_OP_COMP_SWAP | PVRDMA_ATOMIC_OP_FETCH_ADD) ?
-		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
-	props->masked_atomic_cap = props->atomic_cap;
-	props->max_ah = dev->dsr->caps.max_ah;
-	props->max_pkeys = dev->dsr->caps.max_pkeys;
-	props->local_ca_ack_delay = dev->dsr->caps.local_ca_ack_delay;
-	if ((dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_LOCAL_INV) &&
-	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_REMOTE_INV) &&
-	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_FAST_REG_WR)) {
-		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
-	}
-
-	return 0;
-}
-
-/**
- * pvrdma_query_port - query device port attributes
- * @ibdev: the device to query
- * @port: the port number
- * @props: the device properties
- *
- * @return: 0 on success, otherwise negative errno
- */
-int pvrdma_query_port(struct ib_device *ibdev, u8 port,
-		      struct ib_port_attr *props)
-{
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_query_port *cmd = &req.query_port;
-	struct pvrdma_cmd_query_port_resp *resp = &rsp.query_port_resp;
-	int err;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_QUERY_PORT;
-	cmd->port_num = port;
-
-	err = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_QUERY_PORT_RESP);
-	if (err < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "could not query port, error: %d\n", err);
-		return err;
-	}
-
-	memset(props, 0, sizeof(*props));
-
-	props->state = pvrdma_port_state_to_ib(resp->attrs.state);
-	props->max_mtu = pvrdma_mtu_to_ib(resp->attrs.max_mtu);
-	props->active_mtu = pvrdma_mtu_to_ib(resp->attrs.active_mtu);
-	props->gid_tbl_len = resp->attrs.gid_tbl_len;
-	props->port_cap_flags =
-		pvrdma_port_cap_flags_to_ib(resp->attrs.port_cap_flags);
-	props->max_msg_sz = resp->attrs.max_msg_sz;
-	props->bad_pkey_cntr = resp->attrs.bad_pkey_cntr;
-	props->qkey_viol_cntr = resp->attrs.qkey_viol_cntr;
-	props->pkey_tbl_len = resp->attrs.pkey_tbl_len;
-	props->lid = resp->attrs.lid;
-	props->sm_lid = resp->attrs.sm_lid;
-	props->lmc = resp->attrs.lmc;
-	props->max_vl_num = resp->attrs.max_vl_num;
-	props->sm_sl = resp->attrs.sm_sl;
-	props->subnet_timeout = resp->attrs.subnet_timeout;
-	props->init_type_reply = resp->attrs.init_type_reply;
-	props->active_width = pvrdma_port_width_to_ib(resp->attrs.active_width);
-	props->active_speed = pvrdma_port_speed_to_ib(resp->attrs.active_speed);
-	props->phys_state = resp->attrs.phys_state;
-
-	return 0;
-}
-
-/**
- * pvrdma_query_gid - query device gid
- * @ibdev: the device to query
- * @port: the port number
- * @index: the index
- * @gid: the device gid value
- *
- * @return: 0 on success, otherwise negative errno
- */
-int pvrdma_query_gid(struct ib_device *ibdev, u8 port, int index,
-		     union ib_gid *gid)
-{
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-
-	if (index >= dev->dsr->caps.gid_tbl_len)
-		return -EINVAL;
-
-	memcpy(gid, &dev->sgid_tbl[index], sizeof(union ib_gid));
-
-	return 0;
-}
-
-/**
- * pvrdma_query_pkey - query device port's P_Key table
- * @ibdev: the device to query
- * @port: the port number
- * @index: the index
- * @pkey: the device P_Key value
- *
- * @return: 0 on success, otherwise negative errno
- */
-int pvrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
-		      u16 *pkey)
-{
-	int err = 0;
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_query_pkey *cmd = &req.query_pkey;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_QUERY_PKEY;
-	cmd->port_num = port;
-	cmd->index = index;
-
-	err = pvrdma_cmd_post(to_vdev(ibdev), &req, &rsp,
-			      PVRDMA_CMD_QUERY_PKEY_RESP);
-	if (err < 0) {
-		dev_warn(&to_vdev(ibdev)->pdev->dev,
-			 "could not query pkey, error: %d\n", err);
-		return err;
-	}
-
-	*pkey = rsp.query_pkey_resp.pkey;
-
-	return 0;
-}
-
-enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
-					    u8 port)
-{
-	return IB_LINK_LAYER_ETHERNET;
-}
-
-int pvrdma_modify_device(struct ib_device *ibdev, int mask,
-			 struct ib_device_modify *props)
-{
-	unsigned long flags;
-
-	if (mask & ~(IB_DEVICE_MODIFY_SYS_IMAGE_GUID |
-		     IB_DEVICE_MODIFY_NODE_DESC)) {
-		dev_warn(&to_vdev(ibdev)->pdev->dev,
-			 "unsupported device modify mask %#x\n", mask);
-		return -EOPNOTSUPP;
-	}
-
-	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
-		spin_lock_irqsave(&to_vdev(ibdev)->desc_lock, flags);
-		memcpy(ibdev->node_desc, props->node_desc, 64);
-		spin_unlock_irqrestore(&to_vdev(ibdev)->desc_lock, flags);
-	}
-
-	if (mask & IB_DEVICE_MODIFY_SYS_IMAGE_GUID) {
-		mutex_lock(&to_vdev(ibdev)->port_mutex);
-		to_vdev(ibdev)->sys_image_guid =
-			cpu_to_be64(props->sys_image_guid);
-		mutex_unlock(&to_vdev(ibdev)->port_mutex);
-	}
-
-	return 0;
-}
-
-/**
- * pvrdma_modify_port - modify device port attributes
- * @ibdev: the device to modify
- * @port: the port number
- * @mask: attributes to modify
- * @props: the device properties
- *
- * @return: 0 on success, otherwise negative errno
- */
-int pvrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
-		       struct ib_port_modify *props)
-{
-	struct ib_port_attr attr;
-	struct pvrdma_dev *vdev = to_vdev(ibdev);
-	int ret;
-
-	if (mask & ~IB_PORT_SHUTDOWN) {
-		dev_warn(&vdev->pdev->dev,
-			 "unsupported port modify mask %#x\n", mask);
-		return -EOPNOTSUPP;
-	}
-
-	mutex_lock(&vdev->port_mutex);
-	ret = pvrdma_query_port(ibdev, port, &attr);
-	if (ret)
-		goto out;
-
-	vdev->port_cap_mask |= props->set_port_cap_mask;
-	vdev->port_cap_mask &= ~props->clr_port_cap_mask;
-
-	if (mask & IB_PORT_SHUTDOWN)
-		vdev->ib_active = false;
-
-out:
-	mutex_unlock(&vdev->port_mutex);
-	return ret;
-}
-
-/**
- * pvrdma_alloc_ucontext - allocate ucontext
- * @ibdev: the IB device
- * @udata: user data
- *
- * @return: the ib_ucontext pointer on success, otherwise errno.
- */
-struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
-					  struct ib_udata *udata)
-{
-	struct pvrdma_dev *vdev = to_vdev(ibdev);
-	struct pvrdma_ucontext *context;
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_uc *cmd = &req.create_uc;
-	struct pvrdma_cmd_create_uc_resp *resp = &rsp.create_uc_resp;
-	struct pvrdma_alloc_ucontext_resp uresp;
-	int ret;
-	void *ptr;
-
-	if (!vdev->ib_active)
-		return ERR_PTR(-EAGAIN);
-
-	context = kmalloc(sizeof(*context), GFP_KERNEL);
-	if (!context)
-		return ERR_PTR(-ENOMEM);
-
-	context->dev = vdev;
-	ret = pvrdma_uar_alloc(vdev, &context->uar);
-	if (ret) {
-		kfree(context);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	/* get ctx_handle from host */
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->pfn = context->uar.pfn;
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_UC;
-	ret = pvrdma_cmd_post(vdev, &req, &rsp, PVRDMA_CMD_CREATE_UC_RESP);
-	if (ret < 0) {
-		dev_warn(&vdev->pdev->dev,
-			 "could not create ucontext, error: %d\n", ret);
-		ptr = ERR_PTR(ret);
-		goto err;
-	}
-
-	context->ctx_handle = resp->ctx_handle;
-
-	/* copy back to user */
-	uresp.qp_tab_size = vdev->dsr->caps.max_qp;
-	ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
-	if (ret) {
-		pvrdma_uar_free(vdev, &context->uar);
-		context->ibucontext.device = ibdev;
-		pvrdma_dealloc_ucontext(&context->ibucontext);
-		return ERR_PTR(-EFAULT);
-	}
-
-	return &context->ibucontext;
-
-err:
-	pvrdma_uar_free(vdev, &context->uar);
-	kfree(context);
-	return ptr;
-}
-
-/**
- * pvrdma_dealloc_ucontext - deallocate ucontext
- * @ibcontext: the ucontext
- *
- * @return: 0 on success, otherwise errno.
- */
-int pvrdma_dealloc_ucontext(struct ib_ucontext *ibcontext)
-{
-	struct pvrdma_ucontext *context = to_vucontext(ibcontext);
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_destroy_uc *cmd = &req.destroy_uc;
-	int ret;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_UC;
-	cmd->ctx_handle = context->ctx_handle;
-
-	ret = pvrdma_cmd_post(context->dev, &req, NULL, 0);
-	if (ret < 0)
-		dev_warn(&context->dev->pdev->dev,
-			 "destroy ucontext failed, error: %d\n", ret);
-
-	/* Free the UAR even if the device command failed */
-	pvrdma_uar_free(to_vdev(ibcontext->device), &context->uar);
-	kfree(context);
-
-	return ret;
-}
-
-/**
- * pvrdma_mmap - create mmap region
- * @ibcontext: the user context
- * @vma: the VMA
- *
- * @return: 0 on success, otherwise errno.
- */
-int pvrdma_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
-{
-	struct pvrdma_ucontext *context = to_vucontext(ibcontext);
-	unsigned long start = vma->vm_start;
-	unsigned long size = vma->vm_end - vma->vm_start;
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-
-	dev_dbg(&context->dev->pdev->dev, "create mmap region\n");
-
-	if ((size != PAGE_SIZE) || (offset & ~PAGE_MASK)) {
-		dev_warn(&context->dev->pdev->dev,
-			 "invalid params for mmap region\n");
-		return -EINVAL;
-	}
-
-	/* Map UAR to kernel space, VM_LOCKED? */
-	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	if (io_remap_pfn_range(vma, start, context->uar.pfn, size,
-			       vma->vm_page_prot))
-		return -EAGAIN;
-
-	return 0;
-}
-
-/**
- * pvrdma_alloc_pd - allocate protection domain
- * @ibdev: the IB device
- * @context: user context
- * @udata: user data
- *
- * @return: the ib_pd protection domain pointer on success, otherwise errno.
- */
-struct ib_pd *pvrdma_alloc_pd(struct ib_device *ibdev,
-			      struct ib_ucontext *context,
-			      struct ib_udata *udata)
-{
-	struct pvrdma_pd *pd;
-	struct pvrdma_dev *dev = to_vdev(ibdev);
-	union pvrdma_cmd_req req;
-	union pvrdma_cmd_resp rsp;
-	struct pvrdma_cmd_create_pd *cmd = &req.create_pd;
-	struct pvrdma_cmd_create_pd_resp *resp = &rsp.create_pd_resp;
-	int ret;
-	void *ptr;
-
-	/* Check allowed max pds */
-	if (!atomic_add_unless(&dev->num_pds, 1, dev->dsr->caps.max_pd))
-		return ERR_PTR(-ENOMEM);
-
-	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		ptr = ERR_PTR(-ENOMEM);
-		goto err;
-	}
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_CREATE_PD;
-	cmd->ctx_handle = (context) ? to_vucontext(context)->ctx_handle : 0;
-	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_PD_RESP);
-	if (ret < 0) {
-		dev_warn(&dev->pdev->dev,
-			 "failed to allocate protection domain, error: %d\n",
-			 ret);
-		ptr = ERR_PTR(ret);
-		goto freepd;
-	}
-
-	pd->privileged = !context;
-	pd->pd_handle = resp->pd_handle;
-	pd->pdn = resp->pd_handle;
-
-	if (context) {
-		if (ib_copy_to_udata(udata, &pd->pdn, sizeof(__u32))) {
-			dev_warn(&dev->pdev->dev,
-				 "failed to copy back protection domain\n");
-			pvrdma_dealloc_pd(&pd->ibpd);
-			return ERR_PTR(-EFAULT);
-		}
-	}
-
-	/* u32 pd handle */
-	return &pd->ibpd;
-
-freepd:
-	kfree(pd);
-err:
-	atomic_dec(&dev->num_pds);
-	return ptr;
-}
-
-/**
- * pvrdma_dealloc_pd - deallocate protection domain
- * @pd: the protection domain to be released
- *
- * @return: 0 on success, otherwise errno.
- */
-int pvrdma_dealloc_pd(struct ib_pd *pd)
-{
-	struct pvrdma_dev *dev = to_vdev(pd->device);
-	union pvrdma_cmd_req req;
-	struct pvrdma_cmd_destroy_pd *cmd = &req.destroy_pd;
-	int ret;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_PD;
-	cmd->pd_handle = to_vpd(pd)->pd_handle;
-
-	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
-	if (ret)
-		dev_warn(&dev->pdev->dev,
-			 "could not dealloc protection domain, error: %d\n",
-			 ret);
-
-	kfree(to_vpd(pd));
-	atomic_dec(&dev->num_pds);
-
-	return 0;
-}
-
-/**
- * pvrdma_create_ah - create an address handle
- * @pd: the protection domain
- * @ah_attr: the attributes of the AH
- *
- * @return: the ib_ah pointer on success, otherwise errno.
- */
-struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
-{
-	struct pvrdma_dev *dev = to_vdev(pd->device);
-	struct pvrdma_ah *ah;
-	enum rdma_link_layer ll;
-
-	if (!(ah_attr->ah_flags & IB_AH_GRH))
-		return ERR_PTR(-EINVAL);
-
-	ll = rdma_port_get_link_layer(pd->device, ah_attr->port_num);
-
-	if (ll != IB_LINK_LAYER_ETHERNET ||
-	    rdma_is_multicast_addr((struct in6_addr *)ah_attr->grh.dgid.raw))
-		return ERR_PTR(-EINVAL);
-
-	if (!atomic_add_unless(&dev->num_ahs, 1, dev->dsr->caps.max_ah))
-		return ERR_PTR(-ENOMEM);
-
-	ah = kzalloc(sizeof(*ah), GFP_KERNEL);
-	if (!ah) {
-		atomic_dec(&dev->num_ahs);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	ah->av.port_pd = to_vpd(pd)->pd_handle | (ah_attr->port_num << 24);
-	ah->av.src_path_bits = ah_attr->src_path_bits;
-	ah->av.src_path_bits |= 0x80;
-	ah->av.gid_index = ah_attr->grh.sgid_index;
-	ah->av.hop_limit = ah_attr->grh.hop_limit;
-	ah->av.sl_tclass_flowlabel = (ah_attr->grh.traffic_class << 20) |
-				      ah_attr->grh.flow_label;
-	memcpy(ah->av.dgid, ah_attr->grh.dgid.raw, 16);
-	memcpy(ah->av.dmac, ah_attr->dmac, 6);
-
-	ah->ibah.device = pd->device;
-	ah->ibah.pd = pd;
-	ah->ibah.uobject = NULL;
-
-	return &ah->ibah;
-}
-
-/**
- * pvrdma_destroy_ah - destroy an address handle
- * @ah: the address handle to destroyed
- *
- * @return: 0 on success.
- */
-int pvrdma_destroy_ah(struct ib_ah *ah)
-{
-	struct pvrdma_dev *dev = to_vdev(ah->device);
-
-	kfree(to_vah(ah));
-	atomic_dec(&dev->num_ahs);
-
-	return 0;
-}
diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/pvrdma/pvrdma_verbs.h
deleted file mode 100644
index 25ce9fd..0000000
--- a/drivers/infiniband/hw/pvrdma/pvrdma_verbs.h
+++ /dev/null
@@ -1,435 +0,0 @@
-/*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of EITHER the GNU General Public License
- * version 2 as published by the Free Software Foundation or the BSD
- * 2-Clause License. This program is distributed in the hope that it
- * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
- * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License version 2 for more details at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program available in the file COPYING in the main
- * directory of this source tree.
- *
- * The BSD 2-Clause License
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
- * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
- * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
- * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
- * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
- * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
- * OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef __PVRDMA_VERBS_H__
-#define __PVRDMA_VERBS_H__
-
-#include <linux/types.h>
-
-union pvrdma_gid {
-	u8	raw[16];
-	struct {
-		__be64	subnet_prefix;
-		__be64	interface_id;
-	} global;
-};
-
-enum pvrdma_link_layer {
-	PVRDMA_LINK_LAYER_UNSPECIFIED,
-	PVRDMA_LINK_LAYER_INFINIBAND,
-	PVRDMA_LINK_LAYER_ETHERNET,
-};
-
-enum pvrdma_mtu {
-	PVRDMA_MTU_256  = 1,
-	PVRDMA_MTU_512  = 2,
-	PVRDMA_MTU_1024 = 3,
-	PVRDMA_MTU_2048 = 4,
-	PVRDMA_MTU_4096 = 5,
-};
-
-static inline int pvrdma_mtu_enum_to_int(enum pvrdma_mtu mtu)
-{
-	switch (mtu) {
-	case PVRDMA_MTU_256:	return  256;
-	case PVRDMA_MTU_512:	return  512;
-	case PVRDMA_MTU_1024:	return 1024;
-	case PVRDMA_MTU_2048:	return 2048;
-	case PVRDMA_MTU_4096:	return 4096;
-	default:		return   -1;
-	}
-}
-
-static inline enum pvrdma_mtu pvrdma_mtu_int_to_enum(int mtu)
-{
-	switch (mtu) {
-	case 256:	return PVRDMA_MTU_256;
-	case 512:	return PVRDMA_MTU_512;
-	case 1024:	return PVRDMA_MTU_1024;
-	case 2048:	return PVRDMA_MTU_2048;
-	case 4096:
-	default:	return PVRDMA_MTU_4096;
-	}
-}
-
-enum pvrdma_port_state {
-	PVRDMA_PORT_NOP			= 0,
-	PVRDMA_PORT_DOWN		= 1,
-	PVRDMA_PORT_INIT		= 2,
-	PVRDMA_PORT_ARMED		= 3,
-	PVRDMA_PORT_ACTIVE		= 4,
-	PVRDMA_PORT_ACTIVE_DEFER	= 5,
-};
-
-enum pvrdma_port_cap_flags {
-	PVRDMA_PORT_SM				= 1 <<  1,
-	PVRDMA_PORT_NOTICE_SUP			= 1 <<  2,
-	PVRDMA_PORT_TRAP_SUP			= 1 <<  3,
-	PVRDMA_PORT_OPT_IPD_SUP			= 1 <<  4,
-	PVRDMA_PORT_AUTO_MIGR_SUP		= 1 <<  5,
-	PVRDMA_PORT_SL_MAP_SUP			= 1 <<  6,
-	PVRDMA_PORT_MKEY_NVRAM			= 1 <<  7,
-	PVRDMA_PORT_PKEY_NVRAM			= 1 <<  8,
-	PVRDMA_PORT_LED_INFO_SUP		= 1 <<  9,
-	PVRDMA_PORT_SM_DISABLED			= 1 << 10,
-	PVRDMA_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
-	PVRDMA_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
-	PVRDMA_PORT_EXTENDED_SPEEDS_SUP		= 1 << 14,
-	PVRDMA_PORT_CM_SUP			= 1 << 16,
-	PVRDMA_PORT_SNMP_TUNNEL_SUP		= 1 << 17,
-	PVRDMA_PORT_REINIT_SUP			= 1 << 18,
-	PVRDMA_PORT_DEVICE_MGMT_SUP		= 1 << 19,
-	PVRDMA_PORT_VENDOR_CLASS_SUP		= 1 << 20,
-	PVRDMA_PORT_DR_NOTICE_SUP		= 1 << 21,
-	PVRDMA_PORT_CAP_MASK_NOTICE_SUP		= 1 << 22,
-	PVRDMA_PORT_BOOT_MGMT_SUP		= 1 << 23,
-	PVRDMA_PORT_LINK_LATENCY_SUP		= 1 << 24,
-	PVRDMA_PORT_CLIENT_REG_SUP		= 1 << 25,
-	PVRDMA_PORT_IP_BASED_GIDS		= 1 << 26,
-	PVRDMA_PORT_CAP_FLAGS_MAX		= PVRDMA_PORT_IP_BASED_GIDS,
-};
-
-enum pvrdma_port_width {
-	PVRDMA_WIDTH_1X		= 1,
-	PVRDMA_WIDTH_4X		= 2,
-	PVRDMA_WIDTH_8X		= 4,
-	PVRDMA_WIDTH_12X	= 8,
-};
-
-static inline int pvrdma_width_enum_to_int(enum pvrdma_port_width width)
-{
-	switch (width) {
-	case PVRDMA_WIDTH_1X:	return  1;
-	case PVRDMA_WIDTH_4X:	return  4;
-	case PVRDMA_WIDTH_8X:	return  8;
-	case PVRDMA_WIDTH_12X:	return 12;
-	default:		return -1;
-	}
-}
-
-enum pvrdma_port_speed {
-	PVRDMA_SPEED_SDR	= 1,
-	PVRDMA_SPEED_DDR	= 2,
-	PVRDMA_SPEED_QDR	= 4,
-	PVRDMA_SPEED_FDR10	= 8,
-	PVRDMA_SPEED_FDR	= 16,
-	PVRDMA_SPEED_EDR	= 32,
-};
-
-struct pvrdma_port_attr {
-	enum pvrdma_port_state	state;
-	enum pvrdma_mtu		max_mtu;
-	enum pvrdma_mtu		active_mtu;
-	u32			gid_tbl_len;
-	u32			port_cap_flags;
-	u32			max_msg_sz;
-	u32			bad_pkey_cntr;
-	u32			qkey_viol_cntr;
-	u16			pkey_tbl_len;
-	u16			lid;
-	u16			sm_lid;
-	u8			lmc;
-	u8			max_vl_num;
-	u8			sm_sl;
-	u8			subnet_timeout;
-	u8			init_type_reply;
-	u8			active_width;
-	u8			active_speed;
-	u8			phys_state;
-	u8			reserved[2];
-};
-
-struct pvrdma_global_route {
-	union pvrdma_gid	dgid;
-	u32			flow_label;
-	u8			sgid_index;
-	u8			hop_limit;
-	u8			traffic_class;
-	u8			reserved;
-};
-
-struct pvrdma_grh {
-	__be32			version_tclass_flow;
-	__be16			paylen;
-	u8			next_hdr;
-	u8			hop_limit;
-	union pvrdma_gid	sgid;
-	union pvrdma_gid	dgid;
-};
-
-enum pvrdma_ah_flags {
-	PVRDMA_AH_GRH = 1,
-};
-
-enum pvrdma_rate {
-	PVRDMA_RATE_PORT_CURRENT	= 0,
-	PVRDMA_RATE_2_5_GBPS		= 2,
-	PVRDMA_RATE_5_GBPS		= 5,
-	PVRDMA_RATE_10_GBPS		= 3,
-	PVRDMA_RATE_20_GBPS		= 6,
-	PVRDMA_RATE_30_GBPS		= 4,
-	PVRDMA_RATE_40_GBPS		= 7,
-	PVRDMA_RATE_60_GBPS		= 8,
-	PVRDMA_RATE_80_GBPS		= 9,
-	PVRDMA_RATE_120_GBPS		= 10,
-	PVRDMA_RATE_14_GBPS		= 11,
-	PVRDMA_RATE_56_GBPS		= 12,
-	PVRDMA_RATE_112_GBPS		= 13,
-	PVRDMA_RATE_168_GBPS		= 14,
-	PVRDMA_RATE_25_GBPS		= 15,
-	PVRDMA_RATE_100_GBPS		= 16,
-	PVRDMA_RATE_200_GBPS		= 17,
-	PVRDMA_RATE_300_GBPS		= 18,
-};
-
-struct pvrdma_ah_attr {
-	struct pvrdma_global_route	grh;
-	u16				dlid;
-	u16				vlan_id;
-	u8				sl;
-	u8				src_path_bits;
-	u8				static_rate;
-	u8				ah_flags;
-	u8				port_num;
-	u8				dmac[6];
-	u8				reserved;
-};
-
-enum pvrdma_cq_notify_flags {
-	PVRDMA_CQ_SOLICITED		= 1 << 0,
-	PVRDMA_CQ_NEXT_COMP		= 1 << 1,
-	PVRDMA_CQ_SOLICITED_MASK	= PVRDMA_CQ_SOLICITED |
-					  PVRDMA_CQ_NEXT_COMP,
-	PVRDMA_CQ_REPORT_MISSED_EVENTS	= 1 << 2,
-};
-
-struct pvrdma_qp_cap {
-	u32	max_send_wr;
-	u32	max_recv_wr;
-	u32	max_send_sge;
-	u32	max_recv_sge;
-	u32	max_inline_data;
-	u32	reserved;
-};
-
-enum pvrdma_sig_type {
-	PVRDMA_SIGNAL_ALL_WR,
-	PVRDMA_SIGNAL_REQ_WR,
-};
-
-enum pvrdma_qp_type {
-	PVRDMA_QPT_SMI,
-	PVRDMA_QPT_GSI,
-	PVRDMA_QPT_RC,
-	PVRDMA_QPT_UC,
-	PVRDMA_QPT_UD,
-	PVRDMA_QPT_RAW_IPV6,
-	PVRDMA_QPT_RAW_ETHERTYPE,
-	PVRDMA_QPT_RAW_PACKET = 8,
-	PVRDMA_QPT_XRC_INI = 9,
-	PVRDMA_QPT_XRC_TGT,
-	PVRDMA_QPT_MAX,
-};
-
-enum pvrdma_qp_create_flags {
-	PVRDMA_QP_CREATE_IPOPVRDMA_UD_LSO		= 1 << 0,
-	PVRDMA_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
-};
-
-enum pvrdma_qp_attr_mask {
-	PVRDMA_QP_STATE			= 1 << 0,
-	PVRDMA_QP_CUR_STATE		= 1 << 1,
-	PVRDMA_QP_EN_SQD_ASYNC_NOTIFY	= 1 << 2,
-	PVRDMA_QP_ACCESS_FLAGS		= 1 << 3,
-	PVRDMA_QP_PKEY_INDEX		= 1 << 4,
-	PVRDMA_QP_PORT			= 1 << 5,
-	PVRDMA_QP_QKEY			= 1 << 6,
-	PVRDMA_QP_AV			= 1 << 7,
-	PVRDMA_QP_PATH_MTU		= 1 << 8,
-	PVRDMA_QP_TIMEOUT		= 1 << 9,
-	PVRDMA_QP_RETRY_CNT		= 1 << 10,
-	PVRDMA_QP_RNR_RETRY		= 1 << 11,
-	PVRDMA_QP_RQ_PSN		= 1 << 12,
-	PVRDMA_QP_MAX_QP_RD_ATOMIC	= 1 << 13,
-	PVRDMA_QP_ALT_PATH		= 1 << 14,
-	PVRDMA_QP_MIN_RNR_TIMER		= 1 << 15,
-	PVRDMA_QP_SQ_PSN		= 1 << 16,
-	PVRDMA_QP_MAX_DEST_RD_ATOMIC	= 1 << 17,
-	PVRDMA_QP_PATH_MIG_STATE	= 1 << 18,
-	PVRDMA_QP_CAP			= 1 << 19,
-	PVRDMA_QP_DEST_QPN		= 1 << 20,
-	PVRDMA_QP_ATTR_MASK_MAX		= PVRDMA_QP_DEST_QPN,
-};
-
-enum pvrdma_qp_state {
-	PVRDMA_QPS_RESET,
-	PVRDMA_QPS_INIT,
-	PVRDMA_QPS_RTR,
-	PVRDMA_QPS_RTS,
-	PVRDMA_QPS_SQD,
-	PVRDMA_QPS_SQE,
-	PVRDMA_QPS_ERR,
-};
-
-enum pvrdma_mig_state {
-	PVRDMA_MIG_MIGRATED,
-	PVRDMA_MIG_REARM,
-	PVRDMA_MIG_ARMED,
-};
-
-enum pvrdma_mw_type {
-	PVRDMA_MW_TYPE_1 = 1,
-	PVRDMA_MW_TYPE_2 = 2,
-};
-
-struct pvrdma_qp_attr {
-	enum pvrdma_qp_state	qp_state;
-	enum pvrdma_qp_state	cur_qp_state;
-	enum pvrdma_mtu		path_mtu;
-	enum pvrdma_mig_state	path_mig_state;
-	u32			qkey;
-	u32			rq_psn;
-	u32			sq_psn;
-	u32			dest_qp_num;
-	u32			qp_access_flags;
-	u16			pkey_index;
-	u16			alt_pkey_index;
-	u8			en_sqd_async_notify;
-	u8			sq_draining;
-	u8			max_rd_atomic;
-	u8			max_dest_rd_atomic;
-	u8			min_rnr_timer;
-	u8			port_num;
-	u8			timeout;
-	u8			retry_cnt;
-	u8			rnr_retry;
-	u8			alt_port_num;
-	u8			alt_timeout;
-	u8			reserved[5];
-	struct pvrdma_qp_cap	cap;
-	struct pvrdma_ah_attr	ah_attr;
-	struct pvrdma_ah_attr	alt_ah_attr;
-};
-
-enum pvrdma_send_flags {
-	PVRDMA_SEND_FENCE	= 1 << 0,
-	PVRDMA_SEND_SIGNALED	= 1 << 1,
-	PVRDMA_SEND_SOLICITED	= 1 << 2,
-	PVRDMA_SEND_INLINE	= 1 << 3,
-	PVRDMA_SEND_IP_CSUM	= 1 << 4,
-	PVRDMA_SEND_FLAGS_MAX	= PVRDMA_SEND_IP_CSUM,
-};
-
-enum pvrdma_access_flags {
-	PVRDMA_ACCESS_LOCAL_WRITE	= 1 << 0,
-	PVRDMA_ACCESS_REMOTE_WRITE	= 1 << 1,
-	PVRDMA_ACCESS_REMOTE_READ	= 1 << 2,
-	PVRDMA_ACCESS_REMOTE_ATOMIC	= 1 << 3,
-	PVRDMA_ACCESS_MW_BIND		= 1 << 4,
-	PVRDMA_ZERO_BASED		= 1 << 5,
-	PVRDMA_ACCESS_ON_DEMAND		= 1 << 6,
-	PVRDMA_ACCESS_FLAGS_MAX		= PVRDMA_ACCESS_ON_DEMAND,
-};
-
-int pvrdma_query_device(struct ib_device *ibdev,
-			struct ib_device_attr *props,
-			struct ib_udata *udata);
-int pvrdma_query_port(struct ib_device *ibdev, u8 port,
-		      struct ib_port_attr *props);
-int pvrdma_query_gid(struct ib_device *ibdev, u8 port,
-		     int index, union ib_gid *gid);
-int pvrdma_query_pkey(struct ib_device *ibdev, u8 port,
-		      u16 index, u16 *pkey);
-enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
-					    u8 port);
-int pvrdma_modify_device(struct ib_device *ibdev, int mask,
-			 struct ib_device_modify *props);
-int pvrdma_modify_port(struct ib_device *ibdev, u8 port,
-		       int mask, struct ib_port_modify *props);
-int pvrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
-struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
-					  struct ib_udata *udata);
-int pvrdma_dealloc_ucontext(struct ib_ucontext *context);
-struct ib_pd *pvrdma_alloc_pd(struct ib_device *ibdev,
-			      struct ib_ucontext *context,
-			      struct ib_udata *udata);
-int pvrdma_dealloc_pd(struct ib_pd *ibpd);
-struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc);
-struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-				 u64 virt_addr, int access_flags,
-				 struct ib_udata *udata);
-int pvrdma_dereg_mr(struct ib_mr *mr);
-struct ib_mr *pvrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			      u32 max_num_sg);
-int pvrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
-		     int sg_nents, unsigned int *sg_offset);
-int pvrdma_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
-int pvrdma_resize_cq(struct ib_cq *ibcq, int entries,
-		     struct ib_udata *udata);
-struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
-			       const struct ib_cq_init_attr *attr,
-			       struct ib_ucontext *context,
-			       struct ib_udata *udata);
-int pvrdma_resize_cq(struct ib_cq *ibcq, int entries,
-		     struct ib_udata *udata);
-int pvrdma_destroy_cq(struct ib_cq *cq);
-int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
-int pvrdma_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
-struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
-int pvrdma_destroy_ah(struct ib_ah *ah);
-struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
-			       struct ib_qp_init_attr *init_attr,
-			       struct ib_udata *udata);
-int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		     int attr_mask, struct ib_udata *udata);
-int pvrdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
-		    int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
-int pvrdma_destroy_qp(struct ib_qp *qp);
-int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
-		     struct ib_send_wr **bad_wr);
-int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
-		     struct ib_recv_wr **bad_wr);
-
-#endif /* __PVRDMA_VERBS_H__ */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/Kconfig b/drivers/infiniband/hw/vmw_pvrdma/Kconfig
new file mode 100644
index 0000000..b345679
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/Kconfig
@@ -0,0 +1,7 @@
+config INFINIBAND_PVRDMA
+	tristate "VMware Paravirtualized RDMA Driver"
+	depends on NETDEVICES && ETHERNET && PCI && INET && VMXNET3
+	---help---
+	  This driver provides low-level support for VMware Paravirtual
+	  RDMA adapter. It interacts with the VMXNet3 driver to provide
+	  Ethernet capabilities.
diff --git a/drivers/infiniband/hw/vmw_pvrdma/Makefile b/drivers/infiniband/hw/vmw_pvrdma/Makefile
new file mode 100644
index 0000000..6ef4b98
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_INFINIBAND_PVRDMA) += vmw_pvrdma.o
+
+vmw_pvrdma-y := pvrdma_cmd.o pvrdma_cq.o pvrdma_doorbell.o pvrdma_main.o pvrdma_misc.o pvrdma_mr.o pvrdma_qp.o pvrdma_verbs.o
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
new file mode 100644
index 0000000..deb6792
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -0,0 +1,474 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_H__
+#define __PVRDMA_H__
+
+#include <linux/compiler.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/semaphore.h>
+#include <linux/workqueue.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/pvrdma-abi.h>
+
+#include "pvrdma_ring.h"
+#include "pvrdma_dev_api.h"
+#include "pvrdma_verbs.h"
+
+/* NOT the same as BIT_MASK(). */
+#define PVRDMA_MASK(n) ((n << 1) - 1)
+
+/*
+ * VMware PVRDMA PCI device id.
+ */
+#define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
+
+struct pvrdma_dev;
+
+struct pvrdma_page_dir {
+	dma_addr_t dir_dma;
+	u64 *dir;
+	int ntables;
+	u64 **tables;
+	u64 npages;
+	void **pages;
+};
+
+struct pvrdma_cq {
+	struct ib_cq ibcq;
+	int offset;
+	spinlock_t cq_lock; /* Poll lock. */
+	struct pvrdma_uar_map *uar;
+	struct ib_umem *umem;
+	struct pvrdma_ring_state *ring_state;
+	struct pvrdma_page_dir pdir;
+	u32 cq_handle;
+	bool is_kernel;
+	atomic_t refcnt;
+	wait_queue_head_t wait;
+};
+
+struct pvrdma_id_table {
+	u32 last;
+	u32 top;
+	u32 max;
+	u32 mask;
+	spinlock_t lock; /* Table lock. */
+	unsigned long *table;
+};
+
+struct pvrdma_uar_map {
+	unsigned long pfn;
+	void __iomem *map;
+	int index;
+};
+
+struct pvrdma_uar_table {
+	struct pvrdma_id_table tbl;
+	int size;
+};
+
+struct pvrdma_ucontext {
+	struct ib_ucontext ibucontext;
+	struct pvrdma_dev *dev;
+	struct pvrdma_uar_map uar;
+	u64 ctx_handle;
+};
+
+struct pvrdma_pd {
+	struct ib_pd ibpd;
+	u32 pdn;
+	u32 pd_handle;
+	int privileged;
+};
+
+struct pvrdma_mr {
+	u32 mr_handle;
+	u64 iova;
+	u64 size;
+};
+
+struct pvrdma_user_mr {
+	struct ib_mr ibmr;
+	struct ib_umem *umem;
+	struct pvrdma_mr mmr;
+	struct pvrdma_page_dir pdir;
+	u64 *pages;
+	u32 npages;
+	u32 max_pages;
+	u32 page_shift;
+};
+
+struct pvrdma_wq {
+	struct pvrdma_ring *ring;
+	spinlock_t lock; /* Work queue lock. */
+	int wqe_cnt;
+	int wqe_size;
+	int max_sg;
+	int offset;
+};
+
+struct pvrdma_ah {
+	struct ib_ah ibah;
+	struct pvrdma_av av;
+};
+
+struct pvrdma_qp {
+	struct ib_qp ibqp;
+	u32 qp_handle;
+	u32 qkey;
+	struct pvrdma_wq sq;
+	struct pvrdma_wq rq;
+	struct ib_umem *rumem;
+	struct ib_umem *sumem;
+	struct pvrdma_page_dir pdir;
+	int npages;
+	int npages_send;
+	int npages_recv;
+	u32 flags;
+	u8 port;
+	u8 state;
+	bool is_kernel;
+	struct mutex mutex; /* QP state mutex. */
+	atomic_t refcnt;
+	wait_queue_head_t wait;
+};
+
+struct pvrdma_dev {
+	/* PCI device-related information. */
+	struct ib_device ib_dev;
+	struct pci_dev *pdev;
+	void __iomem *regs;
+	struct pvrdma_device_shared_region *dsr; /* Shared region pointer */
+	dma_addr_t dsrbase; /* Shared region base address */
+	void *cmd_slot;
+	void *resp_slot;
+	unsigned long flags;
+	struct list_head device_link;
+
+	/* Locking and interrupt information. */
+	spinlock_t cmd_lock; /* Command lock. */
+	struct semaphore cmd_sema;
+	struct completion cmd_done;
+	struct {
+		enum pvrdma_intr_type type; /* Intr type */
+		struct msix_entry msix_entry[PVRDMA_MAX_INTERRUPTS];
+		irq_handler_t handler[PVRDMA_MAX_INTERRUPTS];
+		u8 enabled[PVRDMA_MAX_INTERRUPTS];
+		u8 size;
+	} intr;
+
+	/* RDMA-related device information. */
+	union ib_gid *sgid_tbl;
+	struct pvrdma_ring_state *async_ring_state;
+	struct pvrdma_page_dir async_pdir;
+	struct pvrdma_ring_state *cq_ring_state;
+	struct pvrdma_page_dir cq_pdir;
+	struct pvrdma_cq **cq_tbl;
+	spinlock_t cq_tbl_lock;
+	struct pvrdma_qp **qp_tbl;
+	spinlock_t qp_tbl_lock;
+	struct pvrdma_uar_table uar_table;
+	struct pvrdma_uar_map driver_uar;
+	__be64 sys_image_guid;
+	spinlock_t desc_lock; /* Device modification lock. */
+	u32 port_cap_mask;
+	struct mutex port_mutex; /* Port modification mutex. */
+	bool ib_active;
+	atomic_t num_qps;
+	atomic_t num_cqs;
+	atomic_t num_pds;
+	atomic_t num_ahs;
+
+	/* Network device information. */
+	struct net_device *netdev;
+	struct notifier_block nb_netdev;
+};
+
+struct pvrdma_netdevice_work {
+	struct work_struct work;
+	struct net_device *event_netdev;
+	unsigned long event;
+};
+
+static inline struct pvrdma_dev *to_vdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct pvrdma_dev, ib_dev);
+}
+
+static inline struct
+pvrdma_ucontext *to_vucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct pvrdma_ucontext, ibucontext);
+}
+
+static inline struct pvrdma_pd *to_vpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct pvrdma_pd, ibpd);
+}
+
+static inline struct pvrdma_cq *to_vcq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct pvrdma_cq, ibcq);
+}
+
+static inline struct pvrdma_user_mr *to_vmr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct pvrdma_user_mr, ibmr);
+}
+
+static inline struct pvrdma_qp *to_vqp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct pvrdma_qp, ibqp);
+}
+
+static inline struct pvrdma_ah *to_vah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct pvrdma_ah, ibah);
+}
+
+static inline void pvrdma_write_reg(struct pvrdma_dev *dev, u32 reg, u32 val)
+{
+	writel(cpu_to_le32(val), dev->regs + reg);
+}
+
+static inline u32 pvrdma_read_reg(struct pvrdma_dev *dev, u32 reg)
+{
+	return le32_to_cpu(readl(dev->regs + reg));
+}
+
+static inline void pvrdma_write_uar_cq(struct pvrdma_dev *dev, u32 val)
+{
+	writel(cpu_to_le32(val), dev->driver_uar.map + PVRDMA_UAR_CQ_OFFSET);
+}
+
+static inline void pvrdma_write_uar_qp(struct pvrdma_dev *dev, u32 val)
+{
+	writel(cpu_to_le32(val), dev->driver_uar.map + PVRDMA_UAR_QP_OFFSET);
+}
+
+static inline void *pvrdma_page_dir_get_ptr(struct pvrdma_page_dir *pdir,
+					    u64 offset)
+{
+	return pdir->pages[offset / PAGE_SIZE] + (offset % PAGE_SIZE);
+}
+
+static inline enum pvrdma_mtu ib_mtu_to_pvrdma(enum ib_mtu mtu)
+{
+	return (enum pvrdma_mtu)mtu;
+}
+
+static inline enum ib_mtu pvrdma_mtu_to_ib(enum pvrdma_mtu mtu)
+{
+	return (enum ib_mtu)mtu;
+}
+
+static inline enum pvrdma_port_state ib_port_state_to_pvrdma(
+					enum ib_port_state state)
+{
+	return (enum pvrdma_port_state)state;
+}
+
+static inline enum ib_port_state pvrdma_port_state_to_ib(
+					enum pvrdma_port_state state)
+{
+	return (enum ib_port_state)state;
+}
+
+static inline int ib_port_cap_flags_to_pvrdma(int flags)
+{
+	return flags & PVRDMA_MASK(PVRDMA_PORT_CAP_FLAGS_MAX);
+}
+
+static inline int pvrdma_port_cap_flags_to_ib(int flags)
+{
+	return flags;
+}
+
+static inline enum pvrdma_port_width ib_port_width_to_pvrdma(
+					enum ib_port_width width)
+{
+	return (enum pvrdma_port_width)width;
+}
+
+static inline enum ib_port_width pvrdma_port_width_to_ib(
+					enum pvrdma_port_width width)
+{
+	return (enum ib_port_width)width;
+}
+
+static inline enum pvrdma_port_speed ib_port_speed_to_pvrdma(
+					enum ib_port_speed speed)
+{
+	return (enum pvrdma_port_speed)speed;
+}
+
+static inline enum ib_port_speed pvrdma_port_speed_to_ib(
+					enum pvrdma_port_speed speed)
+{
+	return (enum ib_port_speed)speed;
+}
+
+static inline int pvrdma_qp_attr_mask_to_ib(int attr_mask)
+{
+	return attr_mask;
+}
+
+static inline int ib_qp_attr_mask_to_pvrdma(int attr_mask)
+{
+	return attr_mask & PVRDMA_MASK(PVRDMA_QP_ATTR_MASK_MAX);
+}
+
+static inline enum pvrdma_mig_state ib_mig_state_to_pvrdma(
+					enum ib_mig_state state)
+{
+	return (enum pvrdma_mig_state)state;
+}
+
+static inline enum ib_mig_state pvrdma_mig_state_to_ib(
+					enum pvrdma_mig_state state)
+{
+	return (enum ib_mig_state)state;
+}
+
+static inline int ib_access_flags_to_pvrdma(int flags)
+{
+	return flags;
+}
+
+static inline int pvrdma_access_flags_to_ib(int flags)
+{
+	return flags & PVRDMA_MASK(PVRDMA_ACCESS_FLAGS_MAX);
+}
+
+static inline enum pvrdma_qp_type ib_qp_type_to_pvrdma(enum ib_qp_type type)
+{
+	return (enum pvrdma_qp_type)type;
+}
+
+static inline enum ib_qp_type pvrdma_qp_type_to_ib(enum pvrdma_qp_type type)
+{
+	return (enum ib_qp_type)type;
+}
+
+static inline enum pvrdma_qp_state ib_qp_state_to_pvrdma(enum ib_qp_state state)
+{
+	return (enum pvrdma_qp_state)state;
+}
+
+static inline enum ib_qp_state pvrdma_qp_state_to_ib(enum pvrdma_qp_state state)
+{
+	return (enum ib_qp_state)state;
+}
+
+static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_opcode op)
+{
+	return (enum pvrdma_wr_opcode)op;
+}
+
+static inline enum ib_wc_status pvrdma_wc_status_to_ib(
+					enum pvrdma_wc_status status)
+{
+	return (enum ib_wc_status)status;
+}
+
+static inline int pvrdma_wc_opcode_to_ib(int opcode)
+{
+	return opcode;
+}
+
+static inline int pvrdma_wc_flags_to_ib(int flags)
+{
+	return flags;
+}
+
+static inline int ib_send_flags_to_pvrdma(int flags)
+{
+	return flags & PVRDMA_MASK(PVRDMA_SEND_FLAGS_MAX);
+}
+
+void pvrdma_qp_cap_to_ib(struct ib_qp_cap *dst,
+			 const struct pvrdma_qp_cap *src);
+void ib_qp_cap_to_pvrdma(struct pvrdma_qp_cap *dst,
+			 const struct ib_qp_cap *src);
+void pvrdma_gid_to_ib(union ib_gid *dst, const union pvrdma_gid *src);
+void ib_gid_to_pvrdma(union pvrdma_gid *dst, const union ib_gid *src);
+void pvrdma_global_route_to_ib(struct ib_global_route *dst,
+			       const struct pvrdma_global_route *src);
+void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
+			       const struct ib_global_route *src);
+void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
+			  const struct pvrdma_ah_attr *src);
+void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
+			  const struct ib_ah_attr *src);
+
+int pvrdma_uar_table_init(struct pvrdma_dev *dev);
+void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev);
+
+int pvrdma_uar_alloc(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar);
+void pvrdma_uar_free(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar);
+
+void _pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq);
+
+int pvrdma_page_dir_init(struct pvrdma_dev *dev, struct pvrdma_page_dir *pdir,
+			 u64 npages, bool alloc_pages);
+void pvrdma_page_dir_cleanup(struct pvrdma_dev *dev,
+			     struct pvrdma_page_dir *pdir);
+int pvrdma_page_dir_insert_dma(struct pvrdma_page_dir *pdir, u64 idx,
+			       dma_addr_t daddr);
+int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
+				struct ib_umem *umem, u64 offset);
+dma_addr_t pvrdma_page_dir_get_dma(struct pvrdma_page_dir *pdir, u64 idx);
+int pvrdma_page_dir_insert_page_list(struct pvrdma_page_dir *pdir,
+				     u64 *page_list, int num_pages);
+
+int pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
+		    union pvrdma_cmd_resp *rsp, unsigned resp_code);
+
+#endif /* __PVRDMA_H__ */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c
new file mode 100644
index 0000000..4a78c53
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cmd.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/list.h>
+
+#include "pvrdma.h"
+
+#define PVRDMA_CMD_TIMEOUT	10000 /* ms */
+
+static inline int pvrdma_cmd_recv(struct pvrdma_dev *dev,
+				  union pvrdma_cmd_resp *resp,
+				  unsigned resp_code)
+{
+	int err;
+
+	dev_dbg(&dev->pdev->dev, "receive response from device\n");
+
+	err = wait_for_completion_interruptible_timeout(&dev->cmd_done,
+			msecs_to_jiffies(PVRDMA_CMD_TIMEOUT));
+	if (err == 0 || err == -ERESTARTSYS) {
+		dev_warn(&dev->pdev->dev,
+			 "completion timeout or interrupted\n");
+		return -ETIMEDOUT;
+	}
+
+	spin_lock(&dev->cmd_lock);
+	memcpy(resp, dev->resp_slot, sizeof(*resp));
+	spin_unlock(&dev->cmd_lock);
+
+	if (resp->hdr.ack != resp_code) {
+		dev_warn(&dev->pdev->dev,
+			 "unknown response %#x expected %#x\n",
+			 resp->hdr.ack, resp_code);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+int
+pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
+		union pvrdma_cmd_resp *resp, unsigned resp_code)
+{
+	int err;
+
+	dev_dbg(&dev->pdev->dev, "post request to device\n");
+
+	/* Serializiation */
+	down(&dev->cmd_sema);
+
+	BUILD_BUG_ON(sizeof(union pvrdma_cmd_req) !=
+		     sizeof(struct pvrdma_cmd_modify_qp));
+
+	spin_lock(&dev->cmd_lock);
+	memcpy(dev->cmd_slot, req, sizeof(*req));
+	spin_unlock(&dev->cmd_lock);
+
+	init_completion(&dev->cmd_done);
+	pvrdma_write_reg(dev, PVRDMA_REG_REQUEST, 0);
+
+	/* Make sure the request is written before reading status. */
+	mb();
+
+	err = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
+	if (err == 0) {
+		if (resp != NULL)
+			err = pvrdma_cmd_recv(dev, resp, resp_code);
+	} else {
+		dev_warn(&dev->pdev->dev,
+			 "failed to write request error reg: %d\n", err);
+		err = -EFAULT;
+	}
+
+	up(&dev->cmd_sema);
+
+	return err;
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
new file mode 100644
index 0000000..e429ca5
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -0,0 +1,425 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <asm/page.h>
+#include <linux/io.h>
+#include <linux/wait.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "pvrdma.h"
+
+/**
+ * pvrdma_req_notify_cq - request notification for a completion queue
+ * @ibcq: the completion queue
+ * @notify_flags: notification flags
+ *
+ * @return: 0 for success.
+ */
+int pvrdma_req_notify_cq(struct ib_cq *ibcq,
+			 enum ib_cq_notify_flags notify_flags)
+{
+	struct pvrdma_dev *dev = to_vdev(ibcq->device);
+	struct pvrdma_cq *cq = to_vcq(ibcq);
+	u32 val = cq->cq_handle;
+
+	val |= (notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
+		PVRDMA_UAR_CQ_ARM_SOL : PVRDMA_UAR_CQ_ARM;
+
+	pvrdma_write_uar_cq(dev, val);
+
+	return 0;
+}
+
+/**
+ * pvrdma_create_cq - create completion queue
+ * @ibdev: the device
+ * @attr: completion queue attributes
+ * @context: user context
+ * @udata: user data
+ *
+ * @return: ib_cq completion queue pointer on success,
+ *          otherwise returns negative errno.
+ */
+struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
+			       const struct ib_cq_init_attr *attr,
+			       struct ib_ucontext *context,
+			       struct ib_udata *udata)
+{
+	int entries = attr->cqe;
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+	struct pvrdma_cq *cq;
+	int ret;
+	int npages;
+	unsigned long flags;
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_cq *cmd = &req.create_cq;
+	struct pvrdma_cmd_create_cq_resp *resp = &rsp.create_cq_resp;
+	struct pvrdma_create_cq ucmd;
+
+	BUILD_BUG_ON(sizeof(struct pvrdma_cqe) != 64);
+
+	entries = roundup_pow_of_two(entries);
+	if (entries < 1 || entries > dev->dsr->caps.max_cqe)
+		return ERR_PTR(-EINVAL);
+
+	if (!atomic_add_unless(&dev->num_cqs, 1, dev->dsr->caps.max_cq))
+		return ERR_PTR(-ENOMEM);
+
+	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
+	if (!cq) {
+		atomic_dec(&dev->num_cqs);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	cq->ibcq.cqe = entries;
+
+	if (context) {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
+			ret = -EFAULT;
+			goto err_cq;
+		}
+
+		cq->umem = ib_umem_get(context, ucmd.buf_addr, ucmd.buf_size,
+				       IB_ACCESS_LOCAL_WRITE, 1);
+		if (IS_ERR(cq->umem)) {
+			ret = PTR_ERR(cq->umem);
+			goto err_cq;
+		}
+
+		npages = ib_umem_page_count(cq->umem);
+	} else {
+		cq->is_kernel = true;
+
+		/* One extra page for shared ring state */
+		npages = 1 + (entries * sizeof(struct pvrdma_cqe) +
+			      PAGE_SIZE - 1) / PAGE_SIZE;
+
+		/* Skip header page. */
+		cq->offset = PAGE_SIZE;
+	}
+
+	if (npages < 0 || npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
+		dev_warn(&dev->pdev->dev,
+			 "overflow pages in completion queue\n");
+		ret = -EINVAL;
+		goto err_umem;
+	}
+
+	ret = pvrdma_page_dir_init(dev, &cq->pdir, npages, cq->is_kernel);
+	if (ret) {
+		dev_warn(&dev->pdev->dev,
+			 "could not allocate page directory\n");
+		goto err_umem;
+	}
+
+	/* Ring state is always the first page. Set in library for user cq. */
+	if (cq->is_kernel)
+		cq->ring_state = cq->pdir.pages[0];
+	else
+		pvrdma_page_dir_insert_umem(&cq->pdir, cq->umem, 0);
+
+	atomic_set(&cq->refcnt, 1);
+	init_waitqueue_head(&cq->wait);
+	spin_lock_init(&cq->cq_lock);
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_CQ;
+	cmd->nchunks = npages;
+	cmd->ctx_handle = (context) ?
+		(u64)to_vucontext(context)->ctx_handle : 0;
+	cmd->cqe = entries;
+	cmd->pdir_dma = cq->pdir.dir_dma;
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_CQ_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not create completion queue, error: %d\n", ret);
+		goto err_page_dir;
+	}
+
+	cq->ibcq.cqe = resp->cqe;
+	cq->cq_handle = resp->cq_handle;
+	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
+	dev->cq_tbl[cq->cq_handle % dev->dsr->caps.max_cq] = cq;
+	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
+
+	if (context) {
+		cq->uar = &(to_vucontext(context)->uar);
+
+		/* Copy udata back. */
+		if (ib_copy_to_udata(udata, &cq->cq_handle, sizeof(__u32))) {
+			dev_warn(&dev->pdev->dev,
+				 "failed to copy back udata\n");
+			pvrdma_destroy_cq(&cq->ibcq);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	return &cq->ibcq;
+
+err_page_dir:
+	pvrdma_page_dir_cleanup(dev, &cq->pdir);
+err_umem:
+	if (context)
+		ib_umem_release(cq->umem);
+err_cq:
+	atomic_dec(&dev->num_cqs);
+	kfree(cq);
+
+	return ERR_PTR(ret);
+}
+
+static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
+{
+	atomic_dec(&cq->refcnt);
+	wait_event(cq->wait, !atomic_read(&cq->refcnt));
+
+	if (!cq->is_kernel)
+		ib_umem_release(cq->umem);
+
+	pvrdma_page_dir_cleanup(dev, &cq->pdir);
+	kfree(cq);
+}
+
+/**
+ * pvrdma_destroy_cq - destroy completion queue
+ * @cq: the completion queue to destroy.
+ *
+ * @return: 0 for success.
+ */
+int pvrdma_destroy_cq(struct ib_cq *cq)
+{
+	struct pvrdma_cq *vcq = to_vcq(cq);
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_destroy_cq *cmd = &req.destroy_cq;
+	struct pvrdma_dev *dev = to_vdev(cq->device);
+	unsigned long flags;
+	int ret;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_CQ;
+	cmd->cq_handle = vcq->cq_handle;
+
+	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
+	if (ret < 0)
+		dev_warn(&dev->pdev->dev,
+			 "could not destroy completion queue, error: %d\n",
+			 ret);
+
+	/* free cq's resources */
+	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
+	dev->cq_tbl[vcq->cq_handle] = NULL;
+	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
+
+	pvrdma_free_cq(dev, vcq);
+	atomic_dec(&dev->num_cqs);
+
+	return ret;
+}
+
+/**
+ * pvrdma_modify_cq - modify the CQ moderation parameters
+ * @ibcq: the CQ to modify
+ * @cq_count: number of CQEs that will trigger an event
+ * @cq_period: max period of time in usec before triggering an event
+ *
+ * @return: -EOPNOTSUPP as CQ resize is not supported.
+ */
+int pvrdma_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline struct pvrdma_cqe *get_cqe(struct pvrdma_cq *cq, int i)
+{
+	return (struct pvrdma_cqe *)pvrdma_page_dir_get_ptr(
+					&cq->pdir,
+					cq->offset +
+					sizeof(struct pvrdma_cqe) * i);
+}
+
+void _pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq)
+{
+	int head;
+	int has_data;
+
+	if (!cq->is_kernel)
+		return;
+
+	/* Lock held */
+	has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
+					    cq->ibcq.cqe, &head);
+	if (unlikely(has_data > 0)) {
+		int items;
+		int curr;
+		int tail = pvrdma_idx(&cq->ring_state->rx.prod_tail,
+				      cq->ibcq.cqe);
+		struct pvrdma_cqe *cqe;
+		struct pvrdma_cqe *curr_cqe;
+
+		items = (tail > head) ? (tail - head) :
+			(cq->ibcq.cqe - head + tail);
+		curr = --tail;
+		while (items-- > 0) {
+			if (curr < 0)
+				curr = cq->ibcq.cqe - 1;
+			if (tail < 0)
+				tail = cq->ibcq.cqe - 1;
+			curr_cqe = get_cqe(cq, curr);
+			if ((curr_cqe->qp & 0xFFFF) != qp->qp_handle) {
+				if (curr != tail) {
+					cqe = get_cqe(cq, tail);
+					*cqe = *curr_cqe;
+				}
+				tail--;
+			} else {
+				pvrdma_idx_ring_inc(
+					&cq->ring_state->rx.cons_head,
+					cq->ibcq.cqe);
+			}
+			curr--;
+		}
+	}
+}
+
+static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
+			   struct ib_wc *wc)
+{
+	struct pvrdma_dev *dev = to_vdev(cq->ibcq.device);
+	int has_data;
+	unsigned int head;
+	bool tried = false;
+	struct pvrdma_cqe *cqe;
+
+retry:
+	has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
+					    cq->ibcq.cqe, &head);
+	if (has_data == 0) {
+		if (tried)
+			return -EAGAIN;
+
+		pvrdma_write_uar_cq(dev, cq->cq_handle | PVRDMA_UAR_CQ_POLL);
+
+		tried = true;
+		goto retry;
+	} else if (has_data == PVRDMA_INVALID_IDX) {
+		dev_err(&dev->pdev->dev, "CQ ring state invalid\n");
+		return -EAGAIN;
+	}
+
+	cqe = get_cqe(cq, head);
+
+	/* Ensure cqe is valid. */
+	rmb();
+	if (dev->qp_tbl[cqe->qp & 0xffff])
+		*cur_qp = (struct pvrdma_qp *)dev->qp_tbl[cqe->qp & 0xffff];
+	else
+		return -EAGAIN;
+
+	wc->opcode = pvrdma_wc_opcode_to_ib(cqe->opcode);
+	wc->status = pvrdma_wc_status_to_ib(cqe->status);
+	wc->wr_id = cqe->wr_id;
+	wc->qp = &(*cur_qp)->ibqp;
+	wc->byte_len = cqe->byte_len;
+	wc->ex.imm_data = cqe->imm_data;
+	wc->src_qp = cqe->src_qp;
+	wc->wc_flags = pvrdma_wc_flags_to_ib(cqe->wc_flags);
+	wc->pkey_index = cqe->pkey_index;
+	wc->slid = cqe->slid;
+	wc->sl = cqe->sl;
+	wc->dlid_path_bits = cqe->dlid_path_bits;
+	wc->port_num = cqe->port_num;
+	wc->vendor_err = 0;
+
+	/* Update shared ring state */
+	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq->ibcq.cqe);
+
+	return 0;
+}
+
+/**
+ * pvrdma_poll_cq - poll for work completion queue entries
+ * @ibcq: completion queue
+ * @num_entries: the maximum number of entries
+ * @entry: pointer to work completion array
+ *
+ * @return: number of polled completion entries
+ */
+int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
+{
+	struct pvrdma_cq *cq = to_vcq(ibcq);
+	struct pvrdma_qp *cur_qp = NULL;
+	unsigned long flags;
+	int npolled;
+
+	if (num_entries < 1 || wc == NULL)
+		return 0;
+
+	spin_lock_irqsave(&cq->cq_lock, flags);
+	for (npolled = 0; npolled < num_entries; ++npolled) {
+		if (pvrdma_poll_one(cq, &cur_qp, wc + npolled))
+			break;
+	}
+
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+
+	/* Ensure we do not return errors from poll_cq */
+	return npolled;
+}
+
+/**
+ * pvrdma_resize_cq - resize CQ
+ * @ibcq: the completion queue
+ * @entries: CQ entries
+ * @udata: user data
+ *
+ * @return: -EOPNOTSUPP as CQ resize is not supported.
+ */
+int pvrdma_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
+{
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
new file mode 100644
index 0000000..c067686
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
@@ -0,0 +1,586 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_DEV_API_H__
+#define __PVRDMA_DEV_API_H__
+
+#include <linux/types.h>
+
+#include "pvrdma_verbs.h"
+
+#define PVRDMA_VERSION			17
+#define PVRDMA_BOARD_ID			1
+#define PVRDMA_REV_ID			1
+
+/*
+ * Masks and accessors for page directory, which is a two-level lookup:
+ * page directory -> page table -> page. Only one directory for now, but we
+ * could expand that easily. 9 bits for tables, 9 bits for pages, gives one
+ * gigabyte for memory regions and so forth.
+ */
+
+#define PVRDMA_PDIR_SHIFT		18
+#define PVRDMA_PTABLE_SHIFT		9
+#define PVRDMA_PAGE_DIR_DIR(x)		(((x) >> PVRDMA_PDIR_SHIFT) & 0x1)
+#define PVRDMA_PAGE_DIR_TABLE(x)	(((x) >> PVRDMA_PTABLE_SHIFT) & 0x1ff)
+#define PVRDMA_PAGE_DIR_PAGE(x)		((x) & 0x1ff)
+#define PVRDMA_PAGE_DIR_MAX_PAGES	(1 * 512 * 512)
+#define PVRDMA_MAX_FAST_REG_PAGES	128
+
+/*
+ * Max MSI-X vectors.
+ */
+
+#define PVRDMA_MAX_INTERRUPTS	3
+
+/* Register offsets within PCI resource on BAR1. */
+#define PVRDMA_REG_VERSION	0x00	/* R: Version of device. */
+#define PVRDMA_REG_DSRLOW	0x04	/* W: Device shared region low PA. */
+#define PVRDMA_REG_DSRHIGH	0x08	/* W: Device shared region high PA. */
+#define PVRDMA_REG_CTL		0x0c	/* W: PVRDMA_DEVICE_CTL */
+#define PVRDMA_REG_REQUEST	0x10	/* W: Indicate device request. */
+#define PVRDMA_REG_ERR		0x14	/* R: Device error. */
+#define PVRDMA_REG_ICR		0x18	/* R: Interrupt cause. */
+#define PVRDMA_REG_IMR		0x1c	/* R/W: Interrupt mask. */
+#define PVRDMA_REG_MACL		0x20	/* R/W: MAC address low. */
+#define PVRDMA_REG_MACH		0x24	/* R/W: MAC address high. */
+
+/* Object flags. */
+#define PVRDMA_CQ_FLAG_ARMED_SOL	BIT(0)	/* Armed for solicited-only. */
+#define PVRDMA_CQ_FLAG_ARMED		BIT(1)	/* Armed. */
+#define PVRDMA_MR_FLAG_DMA		BIT(0)	/* DMA region. */
+#define PVRDMA_MR_FLAG_FRMR		BIT(1)	/* Fast reg memory region. */
+
+/*
+ * Atomic operation capability (masked versions are extended atomic
+ * operations.
+ */
+
+#define PVRDMA_ATOMIC_OP_COMP_SWAP	BIT(0)	/* Compare and swap. */
+#define PVRDMA_ATOMIC_OP_FETCH_ADD	BIT(1)	/* Fetch and add. */
+#define PVRDMA_ATOMIC_OP_MASK_COMP_SWAP	BIT(2)	/* Masked compare and swap. */
+#define PVRDMA_ATOMIC_OP_MASK_FETCH_ADD	BIT(3)	/* Masked fetch and add. */
+
+/*
+ * Base Memory Management Extension flags to support Fast Reg Memory Regions
+ * and Fast Reg Work Requests. Each flag represents a verb operation and we
+ * must support all of them to qualify for the BMME device cap.
+ */
+
+#define PVRDMA_BMME_FLAG_LOCAL_INV	BIT(0)	/* Local Invalidate. */
+#define PVRDMA_BMME_FLAG_REMOTE_INV	BIT(1)	/* Remote Invalidate. */
+#define PVRDMA_BMME_FLAG_FAST_REG_WR	BIT(2)	/* Fast Reg Work Request. */
+
+/*
+ * GID types. The interpretation of the gid_types bit field in the device
+ * capabilities will depend on the device mode. For now, the device only
+ * supports RoCE as mode, so only the different GID types for RoCE are
+ * defined.
+ */
+
+#define PVRDMA_GID_TYPE_FLAG_ROCE_V1	BIT(0)
+#define PVRDMA_GID_TYPE_FLAG_ROCE_V2	BIT(1)
+
+enum pvrdma_pci_resource {
+	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
+	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
+	PVRDMA_PCI_RESOURCE_UAR,	/* BAR2: UAR pages, MMIO, 64-bit. */
+	PVRDMA_PCI_RESOURCE_LAST,	/* Last. */
+};
+
+enum pvrdma_device_ctl {
+	PVRDMA_DEVICE_CTL_ACTIVATE,	/* Activate device. */
+	PVRDMA_DEVICE_CTL_QUIESCE,	/* Quiesce device. */
+	PVRDMA_DEVICE_CTL_RESET,	/* Reset device. */
+};
+
+enum pvrdma_intr_vector {
+	PVRDMA_INTR_VECTOR_RESPONSE,	/* Command response. */
+	PVRDMA_INTR_VECTOR_ASYNC,	/* Async events. */
+	PVRDMA_INTR_VECTOR_CQ,		/* CQ notification. */
+	/* Additional CQ notification vectors. */
+};
+
+enum pvrdma_intr_cause {
+	PVRDMA_INTR_CAUSE_RESPONSE	= (1 << PVRDMA_INTR_VECTOR_RESPONSE),
+	PVRDMA_INTR_CAUSE_ASYNC		= (1 << PVRDMA_INTR_VECTOR_ASYNC),
+	PVRDMA_INTR_CAUSE_CQ		= (1 << PVRDMA_INTR_VECTOR_CQ),
+};
+
+enum pvrdma_intr_type {
+	PVRDMA_INTR_TYPE_INTX,		/* Legacy. */
+	PVRDMA_INTR_TYPE_MSI,		/* MSI. */
+	PVRDMA_INTR_TYPE_MSIX,		/* MSI-X. */
+};
+
+enum pvrdma_gos_bits {
+	PVRDMA_GOS_BITS_UNK,		/* Unknown. */
+	PVRDMA_GOS_BITS_32,		/* 32-bit. */
+	PVRDMA_GOS_BITS_64,		/* 64-bit. */
+};
+
+enum pvrdma_gos_type {
+	PVRDMA_GOS_TYPE_UNK,		/* Unknown. */
+	PVRDMA_GOS_TYPE_LINUX,		/* Linux. */
+};
+
+enum pvrdma_device_mode {
+	PVRDMA_DEVICE_MODE_ROCE,	/* RoCE. */
+	PVRDMA_DEVICE_MODE_IWARP,	/* iWarp. */
+	PVRDMA_DEVICE_MODE_IB,		/* InfiniBand. */
+};
+
+struct pvrdma_gos_info {
+	u32 gos_bits:2;			/* W: PVRDMA_GOS_BITS_ */
+	u32 gos_type:4;			/* W: PVRDMA_GOS_TYPE_ */
+	u32 gos_ver:16;			/* W: Guest OS version. */
+	u32 gos_misc:10;		/* W: Other. */
+	u32 pad;			/* Pad to 8-byte alignment. */
+};
+
+struct pvrdma_device_caps {
+	u64 fw_ver;				/* R: Query device. */
+	__be64 node_guid;
+	__be64 sys_image_guid;
+	u64 max_mr_size;
+	u64 page_size_cap;
+	u64 atomic_arg_sizes;			/* EX verbs. */
+	u32 ex_comp_mask;			/* EX verbs. */
+	u32 device_cap_flags2;			/* EX verbs. */
+	u32 max_fa_bit_boundary;		/* EX verbs. */
+	u32 log_max_atomic_inline_arg;		/* EX verbs. */
+	u32 vendor_id;
+	u32 vendor_part_id;
+	u32 hw_ver;
+	u32 max_qp;
+	u32 max_qp_wr;
+	u32 device_cap_flags;
+	u32 max_sge;
+	u32 max_sge_rd;
+	u32 max_cq;
+	u32 max_cqe;
+	u32 max_mr;
+	u32 max_pd;
+	u32 max_qp_rd_atom;
+	u32 max_ee_rd_atom;
+	u32 max_res_rd_atom;
+	u32 max_qp_init_rd_atom;
+	u32 max_ee_init_rd_atom;
+	u32 max_ee;
+	u32 max_rdd;
+	u32 max_mw;
+	u32 max_raw_ipv6_qp;
+	u32 max_raw_ethy_qp;
+	u32 max_mcast_grp;
+	u32 max_mcast_qp_attach;
+	u32 max_total_mcast_qp_attach;
+	u32 max_ah;
+	u32 max_fmr;
+	u32 max_map_per_fmr;
+	u32 max_srq;
+	u32 max_srq_wr;
+	u32 max_srq_sge;
+	u32 max_uar;
+	u32 gid_tbl_len;
+	u16 max_pkeys;
+	u8  local_ca_ack_delay;
+	u8  phys_port_cnt;
+	u8  mode;				/* PVRDMA_DEVICE_MODE_ */
+	u8  atomic_ops;				/* PVRDMA_ATOMIC_OP_* bits */
+	u8  bmme_flags;				/* FRWR Mem Mgmt Extensions */
+	u8  gid_types;				/* PVRDMA_GID_TYPE_FLAG_ */
+	u8  reserved[4];
+};
+
+struct pvrdma_ring_page_info {
+	u32 num_pages;				/* Num pages incl. header. */
+	u32 reserved;				/* Reserved. */
+	u64 pdir_dma;				/* Page directory PA. */
+};
+
+#pragma pack(push, 1)
+
+struct pvrdma_device_shared_region {
+	u32 driver_version;			/* W: Driver version. */
+	u32 pad;				/* Pad to 8-byte align. */
+	struct pvrdma_gos_info gos_info;	/* W: Guest OS information. */
+	u64 cmd_slot_dma;			/* W: Command slot address. */
+	u64 resp_slot_dma;			/* W: Response slot address. */
+	struct pvrdma_ring_page_info async_ring_pages;
+						/* W: Async ring page info. */
+	struct pvrdma_ring_page_info cq_ring_pages;
+						/* W: CQ ring page info. */
+	u32 uar_pfn;				/* W: UAR pageframe. */
+	u32 pad2;				/* Pad to 8-byte align. */
+	struct pvrdma_device_caps caps;		/* R: Device capabilities. */
+};
+
+#pragma pack(pop)
+
+/* Event types. Currently a 1:1 mapping with enum ib_event. */
+enum pvrdma_eqe_type {
+	PVRDMA_EVENT_CQ_ERR,
+	PVRDMA_EVENT_QP_FATAL,
+	PVRDMA_EVENT_QP_REQ_ERR,
+	PVRDMA_EVENT_QP_ACCESS_ERR,
+	PVRDMA_EVENT_COMM_EST,
+	PVRDMA_EVENT_SQ_DRAINED,
+	PVRDMA_EVENT_PATH_MIG,
+	PVRDMA_EVENT_PATH_MIG_ERR,
+	PVRDMA_EVENT_DEVICE_FATAL,
+	PVRDMA_EVENT_PORT_ACTIVE,
+	PVRDMA_EVENT_PORT_ERR,
+	PVRDMA_EVENT_LID_CHANGE,
+	PVRDMA_EVENT_PKEY_CHANGE,
+	PVRDMA_EVENT_SM_CHANGE,
+	PVRDMA_EVENT_SRQ_ERR,
+	PVRDMA_EVENT_SRQ_LIMIT_REACHED,
+	PVRDMA_EVENT_QP_LAST_WQE_REACHED,
+	PVRDMA_EVENT_CLIENT_REREGISTER,
+	PVRDMA_EVENT_GID_CHANGE,
+};
+
+/* Event queue element. */
+struct pvrdma_eqe {
+	u32 type;	/* Event type. */
+	u32 info;	/* Handle, other. */
+};
+
+/* CQ notification queue element. */
+struct pvrdma_cqne {
+	u32 info;	/* Handle */
+};
+
+enum {
+	PVRDMA_CMD_FIRST,
+	PVRDMA_CMD_QUERY_PORT = PVRDMA_CMD_FIRST,
+	PVRDMA_CMD_QUERY_PKEY,
+	PVRDMA_CMD_CREATE_PD,
+	PVRDMA_CMD_DESTROY_PD,
+	PVRDMA_CMD_CREATE_MR,
+	PVRDMA_CMD_DESTROY_MR,
+	PVRDMA_CMD_CREATE_CQ,
+	PVRDMA_CMD_RESIZE_CQ,
+	PVRDMA_CMD_DESTROY_CQ,
+	PVRDMA_CMD_CREATE_QP,
+	PVRDMA_CMD_MODIFY_QP,
+	PVRDMA_CMD_QUERY_QP,
+	PVRDMA_CMD_DESTROY_QP,
+	PVRDMA_CMD_CREATE_UC,
+	PVRDMA_CMD_DESTROY_UC,
+	PVRDMA_CMD_CREATE_BIND,
+	PVRDMA_CMD_DESTROY_BIND,
+	PVRDMA_CMD_MAX,
+};
+
+enum {
+	PVRDMA_CMD_FIRST_RESP = (1 << 31),
+	PVRDMA_CMD_QUERY_PORT_RESP = PVRDMA_CMD_FIRST_RESP,
+	PVRDMA_CMD_QUERY_PKEY_RESP,
+	PVRDMA_CMD_CREATE_PD_RESP,
+	PVRDMA_CMD_DESTROY_PD_RESP_NOOP,
+	PVRDMA_CMD_CREATE_MR_RESP,
+	PVRDMA_CMD_DESTROY_MR_RESP_NOOP,
+	PVRDMA_CMD_CREATE_CQ_RESP,
+	PVRDMA_CMD_RESIZE_CQ_RESP,
+	PVRDMA_CMD_DESTROY_CQ_RESP_NOOP,
+	PVRDMA_CMD_CREATE_QP_RESP,
+	PVRDMA_CMD_MODIFY_QP_RESP,
+	PVRDMA_CMD_QUERY_QP_RESP,
+	PVRDMA_CMD_DESTROY_QP_RESP,
+	PVRDMA_CMD_CREATE_UC_RESP,
+	PVRDMA_CMD_DESTROY_UC_RESP_NOOP,
+	PVRDMA_CMD_CREATE_BIND_RESP_NOOP,
+	PVRDMA_CMD_DESTROY_BIND_RESP_NOOP,
+	PVRDMA_CMD_MAX_RESP,
+};
+
+struct pvrdma_cmd_hdr {
+	u64 response;		/* Key for response lookup. */
+	u32 cmd;		/* PVRDMA_CMD_ */
+	u32 reserved;		/* Reserved. */
+};
+
+struct pvrdma_cmd_resp_hdr {
+	u64 response;		/* From cmd hdr. */
+	u32 ack;		/* PVRDMA_CMD_XXX_RESP */
+	u8 err;			/* Error. */
+	u8 reserved[3];		/* Reserved. */
+};
+
+struct pvrdma_cmd_query_port {
+	struct pvrdma_cmd_hdr hdr;
+	u8 port_num;
+	u8 reserved[7];
+};
+
+struct pvrdma_cmd_query_port_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	struct pvrdma_port_attr attrs;
+};
+
+struct pvrdma_cmd_query_pkey {
+	struct pvrdma_cmd_hdr hdr;
+	u8 port_num;
+	u8 index;
+	u8 reserved[6];
+};
+
+struct pvrdma_cmd_query_pkey_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u16 pkey;
+	u8 reserved[6];
+};
+
+struct pvrdma_cmd_create_uc {
+	struct pvrdma_cmd_hdr hdr;
+	u32 pfn; /* UAR page frame number */
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_uc_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 ctx_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_destroy_uc {
+	struct pvrdma_cmd_hdr hdr;
+	u32 ctx_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_pd {
+	struct pvrdma_cmd_hdr hdr;
+	u32 ctx_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_pd_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 pd_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_destroy_pd {
+	struct pvrdma_cmd_hdr hdr;
+	u32 pd_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_mr {
+	struct pvrdma_cmd_hdr hdr;
+	u64 start;
+	u64 length;
+	u64 pdir_dma;
+	u32 pd_handle;
+	u32 access_flags;
+	u32 flags;
+	u32 nchunks;
+};
+
+struct pvrdma_cmd_create_mr_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 mr_handle;
+	u32 lkey;
+	u32 rkey;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_destroy_mr {
+	struct pvrdma_cmd_hdr hdr;
+	u32 mr_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_cq {
+	struct pvrdma_cmd_hdr hdr;
+	u64 pdir_dma;
+	u32 ctx_handle;
+	u32 cqe;
+	u32 nchunks;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_cq_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 cq_handle;
+	u32 cqe;
+};
+
+struct pvrdma_cmd_resize_cq {
+	struct pvrdma_cmd_hdr hdr;
+	u32 cq_handle;
+	u32 cqe;
+};
+
+struct pvrdma_cmd_resize_cq_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 cqe;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_destroy_cq {
+	struct pvrdma_cmd_hdr hdr;
+	u32 cq_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_qp {
+	struct pvrdma_cmd_hdr hdr;
+	u64 pdir_dma;
+	u32 pd_handle;
+	u32 send_cq_handle;
+	u32 recv_cq_handle;
+	u32 srq_handle;
+	u32 max_send_wr;
+	u32 max_recv_wr;
+	u32 max_send_sge;
+	u32 max_recv_sge;
+	u32 max_inline_data;
+	u32 lkey;
+	u32 access_flags;
+	u16 total_chunks;
+	u16 send_chunks;
+	u16 max_atomic_arg;
+	u8 sq_sig_all;
+	u8 qp_type;
+	u8 is_srq;
+	u8 reserved[3];
+};
+
+struct pvrdma_cmd_create_qp_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 qpn;
+	u32 max_send_wr;
+	u32 max_recv_wr;
+	u32 max_send_sge;
+	u32 max_recv_sge;
+	u32 max_inline_data;
+};
+
+struct pvrdma_cmd_modify_qp {
+	struct pvrdma_cmd_hdr hdr;
+	u32 qp_handle;
+	u32 attr_mask;
+	struct pvrdma_qp_attr attrs;
+};
+
+struct pvrdma_cmd_query_qp {
+	struct pvrdma_cmd_hdr hdr;
+	u32 qp_handle;
+	u32 attr_mask;
+};
+
+struct pvrdma_cmd_query_qp_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	struct pvrdma_qp_attr attrs;
+};
+
+struct pvrdma_cmd_destroy_qp {
+	struct pvrdma_cmd_hdr hdr;
+	u32 qp_handle;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_destroy_qp_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	u32 events_reported;
+	u8 reserved[4];
+};
+
+struct pvrdma_cmd_create_bind {
+	struct pvrdma_cmd_hdr hdr;
+	u32 mtu;
+	u32 vlan;
+	u32 index;
+	u8 new_gid[16];
+	u8 gid_type;
+	u8 reserved[3];
+};
+
+struct pvrdma_cmd_destroy_bind {
+	struct pvrdma_cmd_hdr hdr;
+	u32 index;
+	u8 dest_gid[16];
+	u8 reserved[4];
+};
+
+union pvrdma_cmd_req {
+	struct pvrdma_cmd_hdr hdr;
+	struct pvrdma_cmd_query_port query_port;
+	struct pvrdma_cmd_query_pkey query_pkey;
+	struct pvrdma_cmd_create_uc create_uc;
+	struct pvrdma_cmd_destroy_uc destroy_uc;
+	struct pvrdma_cmd_create_pd create_pd;
+	struct pvrdma_cmd_destroy_pd destroy_pd;
+	struct pvrdma_cmd_create_mr create_mr;
+	struct pvrdma_cmd_destroy_mr destroy_mr;
+	struct pvrdma_cmd_create_cq create_cq;
+	struct pvrdma_cmd_resize_cq resize_cq;
+	struct pvrdma_cmd_destroy_cq destroy_cq;
+	struct pvrdma_cmd_create_qp create_qp;
+	struct pvrdma_cmd_modify_qp modify_qp;
+	struct pvrdma_cmd_query_qp query_qp;
+	struct pvrdma_cmd_destroy_qp destroy_qp;
+	struct pvrdma_cmd_create_bind create_bind;
+	struct pvrdma_cmd_destroy_bind destroy_bind;
+};
+
+union pvrdma_cmd_resp {
+	struct pvrdma_cmd_resp_hdr hdr;
+	struct pvrdma_cmd_query_port_resp query_port_resp;
+	struct pvrdma_cmd_query_pkey_resp query_pkey_resp;
+	struct pvrdma_cmd_create_uc_resp create_uc_resp;
+	struct pvrdma_cmd_create_pd_resp create_pd_resp;
+	struct pvrdma_cmd_create_mr_resp create_mr_resp;
+	struct pvrdma_cmd_create_cq_resp create_cq_resp;
+	struct pvrdma_cmd_resize_cq_resp resize_cq_resp;
+	struct pvrdma_cmd_create_qp_resp create_qp_resp;
+	struct pvrdma_cmd_query_qp_resp query_qp_resp;
+	struct pvrdma_cmd_destroy_qp_resp destroy_qp_resp;
+};
+
+#endif /* __PVRDMA_DEV_API_H__ */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c
new file mode 100644
index 0000000..bf51357
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_doorbell.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+
+#include "pvrdma.h"
+
+int pvrdma_uar_table_init(struct pvrdma_dev *dev)
+{
+	u32 num = dev->dsr->caps.max_uar;
+	u32 mask = num - 1;
+	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
+
+	if (!is_power_of_2(num))
+		return -EINVAL;
+
+	tbl->last = 0;
+	tbl->top = 0;
+	tbl->max = num;
+	tbl->mask = mask;
+	spin_lock_init(&tbl->lock);
+	tbl->table = kcalloc(BITS_TO_LONGS(num), sizeof(long), GFP_KERNEL);
+	if (!tbl->table)
+		return -ENOMEM;
+
+	/* 0th UAR is taken by the device. */
+	set_bit(0, tbl->table);
+
+	return 0;
+}
+
+void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev)
+{
+	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
+
+	kfree(tbl->table);
+}
+
+int pvrdma_uar_alloc(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar)
+{
+	struct pvrdma_id_table *tbl;
+	unsigned long flags;
+	u32 obj;
+
+	tbl = &dev->uar_table.tbl;
+
+	spin_lock_irqsave(&tbl->lock, flags);
+	obj = find_next_zero_bit(tbl->table, tbl->max, tbl->last);
+	if (obj >= tbl->max) {
+		tbl->top = (tbl->top + tbl->max) & tbl->mask;
+		obj = find_first_zero_bit(tbl->table, tbl->max);
+	}
+
+	if (obj >= tbl->max) {
+		spin_unlock_irqrestore(&tbl->lock, flags);
+		return -ENOMEM;
+	}
+
+	set_bit(obj, tbl->table);
+	obj |= tbl->top;
+
+	spin_unlock_irqrestore(&tbl->lock, flags);
+
+	uar->index = obj;
+	uar->pfn = (pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
+		    PAGE_SHIFT) + uar->index;
+
+	return 0;
+}
+
+void pvrdma_uar_free(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar)
+{
+	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
+	unsigned long flags;
+	u32 obj;
+
+	obj = uar->index & (tbl->max - 1);
+	spin_lock_irqsave(&tbl->lock, flags);
+	clear_bit(obj, tbl->table);
+	tbl->last = min(tbl->last, obj);
+	tbl->top = (tbl->top + tbl->max) & tbl->mask;
+	spin_unlock_irqrestore(&tbl->lock, flags);
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
new file mode 100644
index 0000000..5510c86
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -0,0 +1,1211 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/errno.h>
+#include <linux/inetdevice.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+#include <net/addrconf.h>
+
+#include "pvrdma.h"
+
+#define DRV_NAME	"pvrdma"
+#define DRV_VERSION	"1.0.0.0-k"
+
+static DEFINE_MUTEX(pvrdma_device_list_lock);
+static LIST_HEAD(pvrdma_device_list);
+static struct workqueue_struct *event_wq;
+
+static int pvrdma_add_gid(struct ib_device *ibdev,
+			  u8 port_num,
+			  unsigned int index,
+			  const union ib_gid *gid,
+			  const struct ib_gid_attr *attr,
+			  void **context);
+static int pvrdma_del_gid(struct ib_device *ibdev,
+			  u8 port_num,
+			  unsigned int index,
+			  void **context);
+
+
+static ssize_t show_hca(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	return sprintf(buf, "PVRDMA-%s\n", DRV_VERSION);
+}
+
+static ssize_t show_rev(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	return sprintf(buf, "%d\n", PVRDMA_REV_ID);
+}
+
+static ssize_t show_board(struct device *device, struct device_attribute *attr,
+			  char *buf)
+{
+	return sprintf(buf, "%d\n", PVRDMA_BOARD_ID);
+}
+
+static DEVICE_ATTR(hw_rev,   S_IRUGO, show_rev,	   NULL);
+static DEVICE_ATTR(hca_type, S_IRUGO, show_hca,	   NULL);
+static DEVICE_ATTR(board_id, S_IRUGO, show_board,  NULL);
+
+static struct device_attribute *pvrdma_class_attributes[] = {
+	&dev_attr_hw_rev,
+	&dev_attr_hca_type,
+	&dev_attr_board_id
+};
+
+static void pvrdma_get_fw_ver_str(struct ib_device *device, char *str,
+				  size_t str_len)
+{
+	struct pvrdma_dev *dev =
+		container_of(device, struct pvrdma_dev, ib_dev);
+	snprintf(str, str_len, "%d.%d.%d\n",
+		 (int) (dev->dsr->caps.fw_ver >> 32),
+		 (int) (dev->dsr->caps.fw_ver >> 16) & 0xffff,
+		 (int) dev->dsr->caps.fw_ver & 0xffff);
+}
+
+static int pvrdma_init_device(struct pvrdma_dev *dev)
+{
+	/*  Initialize some device related stuff */
+	spin_lock_init(&dev->cmd_lock);
+	sema_init(&dev->cmd_sema, 1);
+	atomic_set(&dev->num_qps, 0);
+	atomic_set(&dev->num_cqs, 0);
+	atomic_set(&dev->num_pds, 0);
+	atomic_set(&dev->num_ahs, 0);
+
+	return 0;
+}
+
+static int pvrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
+				 struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	err = pvrdma_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+	return 0;
+}
+
+static struct net_device *pvrdma_get_netdev(struct ib_device *ibdev,
+					    u8 port_num)
+{
+	struct net_device *netdev;
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+
+	if (port_num != 1)
+		return NULL;
+
+	rcu_read_lock();
+	netdev = dev->netdev;
+	if (netdev)
+		dev_hold(netdev);
+	rcu_read_unlock();
+
+	return netdev;
+}
+
+static int pvrdma_register_device(struct pvrdma_dev *dev)
+{
+	int ret = -1;
+	int i = 0;
+
+	strlcpy(dev->ib_dev.name, "pvrdma%d", IB_DEVICE_NAME_MAX);
+	dev->ib_dev.node_guid = dev->dsr->caps.node_guid;
+	dev->sys_image_guid = dev->dsr->caps.sys_image_guid;
+	dev->flags = 0;
+	dev->ib_dev.owner = THIS_MODULE;
+	dev->ib_dev.num_comp_vectors = 1;
+	dev->ib_dev.dma_device = &dev->pdev->dev;
+	dev->ib_dev.uverbs_abi_ver = PVRDMA_UVERBS_ABI_VERSION;
+	dev->ib_dev.uverbs_cmd_mask =
+		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
+		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
+		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
+		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
+		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
+		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
+		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_POLL_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ)	|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
+		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_QUERY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_POST_SEND)		|
+		(1ull << IB_USER_VERBS_CMD_POST_RECV)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_AH)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_AH);
+
+	dev->ib_dev.node_type = RDMA_NODE_IB_CA;
+	dev->ib_dev.phys_port_cnt = dev->dsr->caps.phys_port_cnt;
+
+	dev->ib_dev.query_device = pvrdma_query_device;
+	dev->ib_dev.query_port = pvrdma_query_port;
+	dev->ib_dev.query_gid = pvrdma_query_gid;
+	dev->ib_dev.query_pkey = pvrdma_query_pkey;
+	dev->ib_dev.modify_port	= pvrdma_modify_port;
+	dev->ib_dev.alloc_ucontext = pvrdma_alloc_ucontext;
+	dev->ib_dev.dealloc_ucontext = pvrdma_dealloc_ucontext;
+	dev->ib_dev.mmap = pvrdma_mmap;
+	dev->ib_dev.alloc_pd = pvrdma_alloc_pd;
+	dev->ib_dev.dealloc_pd = pvrdma_dealloc_pd;
+	dev->ib_dev.create_ah = pvrdma_create_ah;
+	dev->ib_dev.destroy_ah = pvrdma_destroy_ah;
+	dev->ib_dev.create_qp = pvrdma_create_qp;
+	dev->ib_dev.modify_qp = pvrdma_modify_qp;
+	dev->ib_dev.query_qp = pvrdma_query_qp;
+	dev->ib_dev.destroy_qp = pvrdma_destroy_qp;
+	dev->ib_dev.post_send = pvrdma_post_send;
+	dev->ib_dev.post_recv = pvrdma_post_recv;
+	dev->ib_dev.create_cq = pvrdma_create_cq;
+	dev->ib_dev.modify_cq = pvrdma_modify_cq;
+	dev->ib_dev.resize_cq = pvrdma_resize_cq;
+	dev->ib_dev.destroy_cq = pvrdma_destroy_cq;
+	dev->ib_dev.poll_cq = pvrdma_poll_cq;
+	dev->ib_dev.req_notify_cq = pvrdma_req_notify_cq;
+	dev->ib_dev.get_dma_mr = pvrdma_get_dma_mr;
+	dev->ib_dev.reg_user_mr	= pvrdma_reg_user_mr;
+	dev->ib_dev.dereg_mr = pvrdma_dereg_mr;
+	dev->ib_dev.alloc_mr = pvrdma_alloc_mr;
+	dev->ib_dev.map_mr_sg = pvrdma_map_mr_sg;
+	dev->ib_dev.add_gid = pvrdma_add_gid;
+	dev->ib_dev.del_gid = pvrdma_del_gid;
+	dev->ib_dev.get_netdev = pvrdma_get_netdev;
+	dev->ib_dev.get_port_immutable = pvrdma_port_immutable;
+	dev->ib_dev.get_link_layer = pvrdma_port_link_layer;
+	dev->ib_dev.get_dev_fw_str = pvrdma_get_fw_ver_str;
+
+	mutex_init(&dev->port_mutex);
+	spin_lock_init(&dev->desc_lock);
+
+	dev->cq_tbl = kcalloc(dev->dsr->caps.max_cq, sizeof(void *),
+			      GFP_KERNEL);
+	if (!dev->cq_tbl)
+		return ret;
+	spin_lock_init(&dev->cq_tbl_lock);
+
+	dev->qp_tbl = kcalloc(dev->dsr->caps.max_qp, sizeof(void *),
+			      GFP_KERNEL);
+	if (!dev->qp_tbl)
+		goto err_cq_free;
+	spin_lock_init(&dev->qp_tbl_lock);
+
+	ret = ib_register_device(&dev->ib_dev, NULL);
+	if (ret)
+		goto err_qp_free;
+
+	for (i = 0; i < ARRAY_SIZE(pvrdma_class_attributes); ++i) {
+		ret = device_create_file(&dev->ib_dev.dev,
+					 pvrdma_class_attributes[i]);
+		if (ret)
+			goto err_class;
+	}
+
+	dev->ib_active = true;
+
+	return 0;
+
+err_class:
+	ib_unregister_device(&dev->ib_dev);
+err_qp_free:
+	kfree(dev->qp_tbl);
+err_cq_free:
+	kfree(dev->cq_tbl);
+
+	return ret;
+}
+
+static irqreturn_t pvrdma_intr0_handler(int irq, void *dev_id)
+{
+	u32 icr = PVRDMA_INTR_CAUSE_RESPONSE;
+	struct pvrdma_dev *dev = dev_id;
+
+	dev_dbg(&dev->pdev->dev, "interrupt 0 (response) handler\n");
+
+	if (dev->intr.type != PVRDMA_INTR_TYPE_MSIX) {
+		/* Legacy intr */
+		icr = pvrdma_read_reg(dev, PVRDMA_REG_ICR);
+		if (icr == 0)
+			return IRQ_NONE;
+	}
+
+	if (icr == PVRDMA_INTR_CAUSE_RESPONSE)
+		complete(&dev->cmd_done);
+
+	return IRQ_HANDLED;
+}
+
+static void pvrdma_qp_event(struct pvrdma_dev *dev, u32 qpn, int type)
+{
+	struct pvrdma_qp *qp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
+	qp = dev->qp_tbl[qpn % dev->dsr->caps.max_qp];
+	if (qp)
+		atomic_inc(&qp->refcnt);
+	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
+
+	if (qp && qp->ibqp.event_handler) {
+		struct ib_qp *ibqp = &qp->ibqp;
+		struct ib_event e;
+
+		e.device = ibqp->device;
+		e.element.qp = ibqp;
+		e.event = type; /* 1:1 mapping for now. */
+		ibqp->event_handler(&e, ibqp->qp_context);
+	}
+	if (qp) {
+		atomic_dec(&qp->refcnt);
+		if (atomic_read(&qp->refcnt) == 0)
+			wake_up(&qp->wait);
+	}
+}
+
+static void pvrdma_cq_event(struct pvrdma_dev *dev, u32 cqn, int type)
+{
+	struct pvrdma_cq *cq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
+	cq = dev->cq_tbl[cqn % dev->dsr->caps.max_cq];
+	if (cq)
+		atomic_inc(&cq->refcnt);
+	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
+
+	if (cq && cq->ibcq.event_handler) {
+		struct ib_cq *ibcq = &cq->ibcq;
+		struct ib_event e;
+
+		e.device = ibcq->device;
+		e.element.cq = ibcq;
+		e.event = type; /* 1:1 mapping for now. */
+		ibcq->event_handler(&e, ibcq->cq_context);
+	}
+	if (cq) {
+		atomic_dec(&cq->refcnt);
+		if (atomic_read(&cq->refcnt) == 0)
+			wake_up(&cq->wait);
+	}
+}
+
+static void pvrdma_dispatch_event(struct pvrdma_dev *dev, int port,
+				  enum ib_event_type event)
+{
+	struct ib_event ib_event;
+
+	memset(&ib_event, 0, sizeof(ib_event));
+	ib_event.device = &dev->ib_dev;
+	ib_event.element.port_num = port;
+	ib_event.event = event;
+	ib_dispatch_event(&ib_event);
+}
+
+static void pvrdma_dev_event(struct pvrdma_dev *dev, u8 port, int type)
+{
+	if (port < 1 || port > dev->dsr->caps.phys_port_cnt) {
+		dev_warn(&dev->pdev->dev, "event on port %d\n", port);
+		return;
+	}
+
+	pvrdma_dispatch_event(dev, port, type);
+}
+
+static inline struct pvrdma_eqe *get_eqe(struct pvrdma_dev *dev, unsigned int i)
+{
+	return (struct pvrdma_eqe *)pvrdma_page_dir_get_ptr(
+					&dev->async_pdir,
+					PAGE_SIZE +
+					sizeof(struct pvrdma_eqe) * i);
+}
+
+static irqreturn_t pvrdma_intr1_handler(int irq, void *dev_id)
+{
+	struct pvrdma_dev *dev = dev_id;
+	struct pvrdma_ring *ring = &dev->async_ring_state->rx;
+	int ring_slots = (dev->dsr->async_ring_pages.num_pages - 1) *
+			 PAGE_SIZE / sizeof(struct pvrdma_eqe);
+	unsigned int head;
+
+	dev_dbg(&dev->pdev->dev, "interrupt 1 (async event) handler\n");
+
+	/*
+	 * Don't process events until the IB device is registered. Otherwise
+	 * we'll try to ib_dispatch_event() on an invalid device.
+	 */
+	if (!dev->ib_active)
+		return IRQ_HANDLED;
+
+	while (pvrdma_idx_ring_has_data(ring, ring_slots, &head) > 0) {
+		struct pvrdma_eqe *eqe;
+
+		eqe = get_eqe(dev, head);
+
+		switch (eqe->type) {
+		case PVRDMA_EVENT_QP_FATAL:
+		case PVRDMA_EVENT_QP_REQ_ERR:
+		case PVRDMA_EVENT_QP_ACCESS_ERR:
+		case PVRDMA_EVENT_COMM_EST:
+		case PVRDMA_EVENT_SQ_DRAINED:
+		case PVRDMA_EVENT_PATH_MIG:
+		case PVRDMA_EVENT_PATH_MIG_ERR:
+		case PVRDMA_EVENT_QP_LAST_WQE_REACHED:
+			pvrdma_qp_event(dev, eqe->info, eqe->type);
+			break;
+
+		case PVRDMA_EVENT_CQ_ERR:
+			pvrdma_cq_event(dev, eqe->info, eqe->type);
+			break;
+
+		case PVRDMA_EVENT_SRQ_ERR:
+		case PVRDMA_EVENT_SRQ_LIMIT_REACHED:
+			break;
+
+		case PVRDMA_EVENT_PORT_ACTIVE:
+		case PVRDMA_EVENT_PORT_ERR:
+		case PVRDMA_EVENT_LID_CHANGE:
+		case PVRDMA_EVENT_PKEY_CHANGE:
+		case PVRDMA_EVENT_SM_CHANGE:
+		case PVRDMA_EVENT_CLIENT_REREGISTER:
+		case PVRDMA_EVENT_GID_CHANGE:
+			pvrdma_dev_event(dev, eqe->info, eqe->type);
+			break;
+
+		case PVRDMA_EVENT_DEVICE_FATAL:
+			pvrdma_dev_event(dev, 1, eqe->type);
+			break;
+
+		default:
+			break;
+		}
+
+		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static inline struct pvrdma_cqne *get_cqne(struct pvrdma_dev *dev,
+					   unsigned int i)
+{
+	return (struct pvrdma_cqne *)pvrdma_page_dir_get_ptr(
+					&dev->cq_pdir,
+					PAGE_SIZE +
+					sizeof(struct pvrdma_cqne) * i);
+}
+
+static irqreturn_t pvrdma_intrx_handler(int irq, void *dev_id)
+{
+	struct pvrdma_dev *dev = dev_id;
+	struct pvrdma_ring *ring = &dev->cq_ring_state->rx;
+	int ring_slots = (dev->dsr->cq_ring_pages.num_pages - 1) * PAGE_SIZE /
+			 sizeof(struct pvrdma_cqne);
+	unsigned int head;
+	unsigned long flags;
+
+	dev_dbg(&dev->pdev->dev, "interrupt x (completion) handler\n");
+
+	while (pvrdma_idx_ring_has_data(ring, ring_slots, &head) > 0) {
+		struct pvrdma_cqne *cqne;
+		struct pvrdma_cq *cq;
+
+		cqne = get_cqne(dev, head);
+		spin_lock_irqsave(&dev->cq_tbl_lock, flags);
+		cq = dev->cq_tbl[cqne->info % dev->dsr->caps.max_cq];
+		if (cq)
+			atomic_inc(&cq->refcnt);
+		spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
+
+		if (cq && cq->ibcq.comp_handler)
+			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+		if (cq) {
+			atomic_dec(&cq->refcnt);
+			if (atomic_read(&cq->refcnt))
+				wake_up(&cq->wait);
+		}
+		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void pvrdma_disable_msi_all(struct pvrdma_dev *dev)
+{
+	if (dev->intr.type == PVRDMA_INTR_TYPE_MSIX)
+		pci_disable_msix(dev->pdev);
+	else if (dev->intr.type == PVRDMA_INTR_TYPE_MSI)
+		pci_disable_msi(dev->pdev);
+}
+
+static void pvrdma_free_irq(struct pvrdma_dev *dev)
+{
+	int i;
+
+	dev_dbg(&dev->pdev->dev, "freeing interrupts\n");
+
+	if (dev->intr.type == PVRDMA_INTR_TYPE_MSIX) {
+		for (i = 0; i < dev->intr.size; i++) {
+			if (dev->intr.enabled[i]) {
+				free_irq(dev->intr.msix_entry[i].vector, dev);
+				dev->intr.enabled[i] = 0;
+			}
+		}
+	} else if (dev->intr.type == PVRDMA_INTR_TYPE_INTX ||
+		   dev->intr.type == PVRDMA_INTR_TYPE_MSI) {
+		free_irq(dev->pdev->irq, dev);
+	}
+}
+
+static void pvrdma_enable_intrs(struct pvrdma_dev *dev)
+{
+	dev_dbg(&dev->pdev->dev, "enable interrupts\n");
+	pvrdma_write_reg(dev, PVRDMA_REG_IMR, 0);
+}
+
+static void pvrdma_disable_intrs(struct pvrdma_dev *dev)
+{
+	dev_dbg(&dev->pdev->dev, "disable interrupts\n");
+	pvrdma_write_reg(dev, PVRDMA_REG_IMR, ~0);
+}
+
+static int pvrdma_enable_msix(struct pci_dev *pdev, struct pvrdma_dev *dev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < PVRDMA_MAX_INTERRUPTS; i++) {
+		dev->intr.msix_entry[i].entry = i;
+		dev->intr.msix_entry[i].vector = i;
+
+		switch (i) {
+		case 0:
+			/* CMD ring handler */
+			dev->intr.handler[i] = pvrdma_intr0_handler;
+			break;
+		case 1:
+			/* Async event ring handler */
+			dev->intr.handler[i] = pvrdma_intr1_handler;
+			break;
+		default:
+			/* Completion queue handler */
+			dev->intr.handler[i] = pvrdma_intrx_handler;
+			break;
+		}
+	}
+
+	ret = pci_enable_msix(pdev, dev->intr.msix_entry,
+			      PVRDMA_MAX_INTERRUPTS);
+	if (!ret) {
+		dev->intr.type = PVRDMA_INTR_TYPE_MSIX;
+		dev->intr.size = PVRDMA_MAX_INTERRUPTS;
+	} else if (ret > 0) {
+		ret = pci_enable_msix(pdev, dev->intr.msix_entry, ret);
+		if (!ret) {
+			dev->intr.type = PVRDMA_INTR_TYPE_MSIX;
+			dev->intr.size = ret;
+		} else {
+			dev->intr.size = 0;
+		}
+	}
+
+	dev_dbg(&pdev->dev, "using interrupt type %d, size %d\n",
+		dev->intr.type, dev->intr.size);
+
+	return ret;
+}
+
+static int pvrdma_alloc_intrs(struct pvrdma_dev *dev)
+{
+	int ret = 0;
+	int i;
+
+	if (pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX) &&
+	    pvrdma_enable_msix(dev->pdev, dev)) {
+		/* Try MSI */
+		ret = pci_enable_msi(dev->pdev);
+		if (!ret) {
+			dev->intr.type = PVRDMA_INTR_TYPE_MSI;
+		} else {
+			/* Legacy INTR */
+			dev->intr.type = PVRDMA_INTR_TYPE_INTX;
+		}
+	}
+
+	/* Request First IRQ */
+	switch (dev->intr.type) {
+	case PVRDMA_INTR_TYPE_INTX:
+	case PVRDMA_INTR_TYPE_MSI:
+		ret = request_irq(dev->pdev->irq, pvrdma_intr0_handler,
+				  IRQF_SHARED, DRV_NAME, dev);
+		if (ret) {
+			dev_err(&dev->pdev->dev,
+				"failed to request interrupt\n");
+			goto disable_msi;
+		}
+		break;
+	case PVRDMA_INTR_TYPE_MSIX:
+		ret = request_irq(dev->intr.msix_entry[0].vector,
+				  pvrdma_intr0_handler, 0, DRV_NAME, dev);
+		if (ret) {
+			dev_err(&dev->pdev->dev,
+				"failed to request interrupt 0\n");
+			goto disable_msi;
+		}
+		dev->intr.enabled[0] = 1;
+		break;
+	default:
+		/* Not reached */
+		break;
+	}
+
+	/* For MSIX: request intr for each vector */
+	if (dev->intr.size > 1) {
+		ret = request_irq(dev->intr.msix_entry[1].vector,
+				  pvrdma_intr1_handler, 0, DRV_NAME, dev);
+		if (ret) {
+			dev_err(&dev->pdev->dev,
+				"failed to request interrupt 1\n");
+			goto free_irq;
+		}
+		dev->intr.enabled[1] = 1;
+
+		for (i = 2; i < dev->intr.size; i++) {
+			ret = request_irq(dev->intr.msix_entry[i].vector,
+					  pvrdma_intrx_handler, 0,
+					  DRV_NAME, dev);
+			if (ret) {
+				dev_err(&dev->pdev->dev,
+					"failed to request interrupt %d\n", i);
+				goto free_irq;
+			}
+			dev->intr.enabled[i] = 1;
+		}
+	}
+
+	return 0;
+
+free_irq:
+	pvrdma_free_irq(dev);
+disable_msi:
+	pvrdma_disable_msi_all(dev);
+	return ret;
+}
+
+static void pvrdma_free_slots(struct pvrdma_dev *dev)
+{
+	struct pci_dev *pdev = dev->pdev;
+
+	if (dev->resp_slot)
+		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->resp_slot,
+				  dev->dsr->resp_slot_dma);
+	if (dev->cmd_slot)
+		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->cmd_slot,
+				  dev->dsr->cmd_slot_dma);
+}
+
+static int pvrdma_add_gid_at_index(struct pvrdma_dev *dev,
+				   const union ib_gid *gid,
+				   int index)
+{
+	int ret;
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_create_bind *cmd_bind = &req.create_bind;
+
+	if (!dev->sgid_tbl) {
+		dev_warn(&dev->pdev->dev, "sgid table not initialized\n");
+		return -EINVAL;
+	}
+
+	memset(cmd_bind, 0, sizeof(*cmd_bind));
+	cmd_bind->hdr.cmd = PVRDMA_CMD_CREATE_BIND;
+	memcpy(cmd_bind->new_gid, gid->raw, 16);
+	cmd_bind->mtu = ib_mtu_enum_to_int(IB_MTU_1024);
+	cmd_bind->vlan = 0xfff;
+	cmd_bind->index = index;
+	cmd_bind->gid_type = PVRDMA_GID_TYPE_FLAG_ROCE_V1;
+
+	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not create binding, error: %d\n", ret);
+		return -EFAULT;
+	}
+	memcpy(&dev->sgid_tbl[index], gid, sizeof(*gid));
+	return 0;
+}
+
+static int pvrdma_add_gid(struct ib_device *ibdev,
+			  u8 port_num,
+			  unsigned int index,
+			  const union ib_gid *gid,
+			  const struct ib_gid_attr *attr,
+			  void **context)
+{
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+
+	return pvrdma_add_gid_at_index(dev, gid, index);
+}
+
+static int pvrdma_del_gid_at_index(struct pvrdma_dev *dev, int index)
+{
+	int ret;
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_destroy_bind *cmd_dest = &req.destroy_bind;
+
+	/* Update sgid table. */
+	if (!dev->sgid_tbl) {
+		dev_warn(&dev->pdev->dev, "sgid table not initialized\n");
+		return -EINVAL;
+	}
+
+	memset(cmd_dest, 0, sizeof(*cmd_dest));
+	cmd_dest->hdr.cmd = PVRDMA_CMD_DESTROY_BIND;
+	memcpy(cmd_dest->dest_gid, &dev->sgid_tbl[index], 16);
+	cmd_dest->index = index;
+
+	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not destroy binding, error: %d\n", ret);
+		return ret;
+	}
+	memset(&dev->sgid_tbl[index], 0, 16);
+	return 0;
+}
+
+static int pvrdma_del_gid(struct ib_device *ibdev,
+			  u8 port_num,
+			  unsigned int index,
+			  void **context)
+{
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+
+	dev_dbg(&dev->pdev->dev, "removing gid at index %u from %s",
+		index, dev->netdev->name);
+
+	return pvrdma_del_gid_at_index(dev, index);
+}
+
+static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
+					  unsigned long event)
+{
+	switch (event) {
+	case NETDEV_REBOOT:
+	case NETDEV_DOWN:
+		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
+		break;
+	case NETDEV_UP:
+		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
+		break;
+	default:
+		dev_dbg(&dev->pdev->dev, "ignore netdevice event %ld on %s\n",
+			event, dev->ib_dev.name);
+		break;
+	}
+}
+
+static void pvrdma_netdevice_event_work(struct work_struct *work)
+{
+	struct pvrdma_netdevice_work *netdev_work;
+	struct pvrdma_dev *dev;
+
+	netdev_work = container_of(work, struct pvrdma_netdevice_work, work);
+
+	mutex_lock(&pvrdma_device_list_lock);
+	list_for_each_entry(dev, &pvrdma_device_list, device_link) {
+		if (dev->netdev == netdev_work->event_netdev) {
+			pvrdma_netdevice_event_handle(dev, netdev_work->event);
+			break;
+		}
+	}
+	mutex_unlock(&pvrdma_device_list_lock);
+
+	kfree(netdev_work);
+}
+
+static int pvrdma_netdevice_event(struct notifier_block *this,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *event_netdev = netdev_notifier_info_to_dev(ptr);
+	struct pvrdma_netdevice_work *netdev_work;
+
+	netdev_work = kmalloc(sizeof(*netdev_work), GFP_ATOMIC);
+	if (!netdev_work)
+		return NOTIFY_BAD;
+
+	INIT_WORK(&netdev_work->work, pvrdma_netdevice_event_work);
+	netdev_work->event_netdev = event_netdev;
+	netdev_work->event = event;
+	queue_work(event_wq, &netdev_work->work);
+
+	return NOTIFY_DONE;
+}
+
+static int pvrdma_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *id)
+{
+	struct pci_dev *pdev_net;
+	struct pvrdma_dev *dev;
+	int ret;
+	unsigned long start;
+	unsigned long len;
+	unsigned int version;
+	dma_addr_t slot_dma = 0;
+
+	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
+
+	/* Allocate zero-out device */
+	dev = (struct pvrdma_dev *)ib_alloc_device(sizeof(*dev));
+	if (!dev) {
+		dev_err(&pdev->dev, "failed to allocate IB device\n");
+		return -ENOMEM;
+	}
+
+	mutex_lock(&pvrdma_device_list_lock);
+	list_add(&dev->device_link, &pvrdma_device_list);
+	mutex_unlock(&pvrdma_device_list_lock);
+
+	ret = pvrdma_init_device(dev);
+	if (ret)
+		goto err_free_device;
+
+	dev->pdev = pdev;
+	pci_set_drvdata(pdev, dev);
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot enable PCI device\n");
+		goto err_free_device;
+	}
+
+	dev_dbg(&pdev->dev, "PCI resource flags BAR0 %#lx\n",
+		pci_resource_flags(pdev, 0));
+	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
+		(unsigned long long)pci_resource_len(pdev, 0));
+	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
+		(unsigned long long)pci_resource_start(pdev, 0));
+	dev_dbg(&pdev->dev, "PCI resource flags BAR1 %#lx\n",
+		pci_resource_flags(pdev, 1));
+	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
+		(unsigned long long)pci_resource_len(pdev, 1));
+	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
+		(unsigned long long)pci_resource_start(pdev, 1));
+
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
+	    !(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "PCI BAR region not MMIO\n");
+		ret = -ENOMEM;
+		goto err_free_device;
+	}
+
+	ret = pci_request_regions(pdev, DRV_NAME);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot request PCI resources\n");
+		goto err_disable_pdev;
+	}
+
+	/* Enable 64-Bit DMA */
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
+		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"pci_set_consistent_dma_mask failed\n");
+			goto err_free_resource;
+		}
+	} else {
+		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"pci_set_dma_mask failed\n");
+			goto err_free_resource;
+		}
+	}
+
+	pci_set_master(pdev);
+
+	/* Map register space */
+	start = pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
+	len = pci_resource_len(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
+	dev->regs = ioremap(start, len);
+	if (!dev->regs) {
+		dev_err(&pdev->dev, "register mapping failed\n");
+		ret = -ENOMEM;
+		goto err_free_resource;
+	}
+
+	/* Setup per-device UAR. */
+	dev->driver_uar.index = 0;
+	dev->driver_uar.pfn =
+		pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
+		PAGE_SHIFT;
+	dev->driver_uar.map =
+		ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!dev->driver_uar.map) {
+		dev_err(&pdev->dev, "failed to remap UAR pages\n");
+		ret = -ENOMEM;
+		goto err_unmap_regs;
+	}
+
+	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
+	dev_info(&pdev->dev, "device version %d, driver version %d\n",
+		 version, PVRDMA_VERSION);
+	if (version < PVRDMA_VERSION) {
+		dev_err(&pdev->dev, "incompatible device version\n");
+		goto err_uar_unmap;
+	}
+
+	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
+				      &dev->dsrbase, GFP_KERNEL);
+	if (!dev->dsr) {
+		dev_err(&pdev->dev, "failed to allocate shared region\n");
+		ret = -ENOMEM;
+		goto err_uar_unmap;
+	}
+
+	/* Setup the shared region */
+	memset(dev->dsr, 0, sizeof(*dev->dsr));
+	dev->dsr->driver_version = PVRDMA_VERSION;
+	dev->dsr->gos_info.gos_bits = sizeof(void *) == 4 ?
+		PVRDMA_GOS_BITS_32 :
+		PVRDMA_GOS_BITS_64;
+	dev->dsr->gos_info.gos_type = PVRDMA_GOS_TYPE_LINUX;
+	dev->dsr->gos_info.gos_ver = 1;
+	dev->dsr->uar_pfn = dev->driver_uar.pfn;
+
+	/* Command slot. */
+	dev->cmd_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
+					   &slot_dma, GFP_KERNEL);
+	if (!dev->cmd_slot) {
+		ret = -ENOMEM;
+		goto err_free_dsr;
+	}
+
+	dev->dsr->cmd_slot_dma = (u64)slot_dma;
+
+	/* Response slot. */
+	dev->resp_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
+					    &slot_dma, GFP_KERNEL);
+	if (!dev->resp_slot) {
+		ret = -ENOMEM;
+		goto err_free_slots;
+	}
+
+	dev->dsr->resp_slot_dma = (u64)slot_dma;
+
+	/* Async event ring */
+	dev->dsr->async_ring_pages.num_pages = 4;
+	ret = pvrdma_page_dir_init(dev, &dev->async_pdir,
+				   dev->dsr->async_ring_pages.num_pages, true);
+	if (ret)
+		goto err_free_slots;
+	dev->async_ring_state = dev->async_pdir.pages[0];
+	dev->dsr->async_ring_pages.pdir_dma = dev->async_pdir.dir_dma;
+
+	/* CQ notification ring */
+	dev->dsr->cq_ring_pages.num_pages = 4;
+	ret = pvrdma_page_dir_init(dev, &dev->cq_pdir,
+				   dev->dsr->cq_ring_pages.num_pages, true);
+	if (ret)
+		goto err_free_async_ring;
+	dev->cq_ring_state = dev->cq_pdir.pages[0];
+	dev->dsr->cq_ring_pages.pdir_dma = dev->cq_pdir.dir_dma;
+
+	/*
+	 * Write the PA of the shared region to the device. The writes must be
+	 * ordered such that the high bits are written last. When the writes
+	 * complete, the device will have filled out the capabilities.
+	 */
+
+	pvrdma_write_reg(dev, PVRDMA_REG_DSRLOW, (u32)dev->dsrbase);
+	pvrdma_write_reg(dev, PVRDMA_REG_DSRHIGH,
+			 (u32)((u64)(dev->dsrbase) >> 32));
+
+	/* Make sure the write is complete before reading status. */
+	mb();
+
+	/* Currently, the driver only supports RoCE mode. */
+	if (dev->dsr->caps.mode != PVRDMA_DEVICE_MODE_ROCE) {
+		dev_err(&pdev->dev, "unsupported transport %d\n",
+			dev->dsr->caps.mode);
+		ret = -EFAULT;
+		goto err_free_cq_ring;
+	}
+
+	/* Currently, the driver only supports RoCE V1. */
+	if (!(dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V1)) {
+		dev_err(&pdev->dev, "driver needs RoCE v1 support\n");
+		ret = -EFAULT;
+		goto err_free_cq_ring;
+	}
+
+	/* Paired vmxnet3 will have same bus, slot. But func will be 0 */
+	pdev_net = pci_get_slot(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+	if (!pdev_net) {
+		dev_err(&pdev->dev, "failed to find paired net device\n");
+		ret = -ENODEV;
+		goto err_free_cq_ring;
+	}
+
+	if (pdev_net->vendor != PCI_VENDOR_ID_VMWARE ||
+	    pdev_net->device != PCI_DEVICE_ID_VMWARE_VMXNET3) {
+		dev_err(&pdev->dev, "failed to find paired vmxnet3 device\n");
+		pci_dev_put(pdev_net);
+		ret = -ENODEV;
+		goto err_free_cq_ring;
+	}
+
+	dev->netdev = pci_get_drvdata(pdev_net);
+	pci_dev_put(pdev_net);
+	if (!dev->netdev) {
+		dev_err(&pdev->dev, "failed to get vmxnet3 device\n");
+		ret = -ENODEV;
+		goto err_free_cq_ring;
+	}
+
+	dev_info(&pdev->dev, "paired device to %s\n", dev->netdev->name);
+
+	/* Interrupt setup */
+	ret = pvrdma_alloc_intrs(dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to allocate interrupts\n");
+		ret = -ENOMEM;
+		goto err_netdevice;
+	}
+
+	/* Allocate UAR table. */
+	ret = pvrdma_uar_table_init(dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to allocate UAR table\n");
+		ret = -ENOMEM;
+		goto err_free_intrs;
+	}
+
+	/* Allocate GID table */
+	dev->sgid_tbl = kcalloc(dev->dsr->caps.gid_tbl_len,
+				sizeof(union ib_gid), GFP_KERNEL);
+	if (!dev->sgid_tbl) {
+		ret = -ENOMEM;
+		goto err_free_uar_table;
+	}
+	dev_dbg(&pdev->dev, "gid table len %d\n", dev->dsr->caps.gid_tbl_len);
+
+	pvrdma_enable_intrs(dev);
+
+	/* Activate pvrdma device */
+	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
+
+	/* Make sure the write is complete before reading status. */
+	mb();
+
+	/* Check if device was successfully activated */
+	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "failed to activate device\n");
+		ret = -EFAULT;
+		goto err_disable_intr;
+	}
+
+	/* Register IB device */
+	ret = pvrdma_register_device(dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register IB device\n");
+		goto err_disable_intr;
+	}
+
+	dev->nb_netdev.notifier_call = pvrdma_netdevice_event;
+	ret = register_netdevice_notifier(&dev->nb_netdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register netdevice events\n");
+		goto err_unreg_ibdev;
+	}
+
+	dev_info(&pdev->dev, "attached to device\n");
+	return 0;
+
+err_unreg_ibdev:
+	ib_unregister_device(&dev->ib_dev);
+err_disable_intr:
+	pvrdma_disable_intrs(dev);
+	kfree(dev->sgid_tbl);
+err_free_uar_table:
+	pvrdma_uar_table_cleanup(dev);
+err_free_intrs:
+	pvrdma_free_irq(dev);
+	pvrdma_disable_msi_all(dev);
+err_netdevice:
+	unregister_netdevice_notifier(&dev->nb_netdev);
+err_free_cq_ring:
+	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
+err_free_async_ring:
+	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
+err_free_slots:
+	pvrdma_free_slots(dev);
+err_free_dsr:
+	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
+			  dev->dsrbase);
+err_uar_unmap:
+	iounmap(dev->driver_uar.map);
+err_unmap_regs:
+	iounmap(dev->regs);
+err_free_resource:
+	pci_release_regions(pdev);
+err_disable_pdev:
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+err_free_device:
+	mutex_lock(&pvrdma_device_list_lock);
+	list_del(&dev->device_link);
+	mutex_unlock(&pvrdma_device_list_lock);
+	ib_dealloc_device(&dev->ib_dev);
+	return ret;
+}
+
+static void pvrdma_pci_remove(struct pci_dev *pdev)
+{
+	struct pvrdma_dev *dev = pci_get_drvdata(pdev);
+
+	if (!dev)
+		return;
+
+	dev_info(&pdev->dev, "detaching from device\n");
+
+	unregister_netdevice_notifier(&dev->nb_netdev);
+	dev->nb_netdev.notifier_call = NULL;
+
+	flush_workqueue(event_wq);
+
+	/* Unregister ib device */
+	ib_unregister_device(&dev->ib_dev);
+
+	mutex_lock(&pvrdma_device_list_lock);
+	list_del(&dev->device_link);
+	mutex_unlock(&pvrdma_device_list_lock);
+
+	pvrdma_disable_intrs(dev);
+	pvrdma_free_irq(dev);
+	pvrdma_disable_msi_all(dev);
+
+	/* Deactivate pvrdma device */
+	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_RESET);
+	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
+	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
+	pvrdma_free_slots(dev);
+
+	iounmap(dev->regs);
+	kfree(dev->sgid_tbl);
+	kfree(dev->cq_tbl);
+	kfree(dev->qp_tbl);
+	pvrdma_uar_table_cleanup(dev);
+	iounmap(dev->driver_uar.map);
+
+	ib_dealloc_device(&dev->ib_dev);
+
+	/* Free pci resources */
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static struct pci_device_id pvrdma_pci_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_PVRDMA), },
+	{ 0 },
+};
+
+MODULE_DEVICE_TABLE(pci, pvrdma_pci_table);
+
+static struct pci_driver pvrdma_driver = {
+	.name		= DRV_NAME,
+	.id_table	= pvrdma_pci_table,
+	.probe		= pvrdma_pci_probe,
+	.remove		= pvrdma_pci_remove,
+};
+
+static int __init pvrdma_init(void)
+{
+	int err;
+
+	event_wq = alloc_ordered_workqueue("pvrdma_event_wq", WQ_MEM_RECLAIM);
+	if (!event_wq)
+		return -ENOMEM;
+
+	err = pci_register_driver(&pvrdma_driver);
+	if (err)
+		destroy_workqueue(event_wq);
+
+	return err;
+}
+
+static void __exit pvrdma_cleanup(void)
+{
+	pci_unregister_driver(&pvrdma_driver);
+
+	destroy_workqueue(event_wq);
+}
+
+module_init(pvrdma_init);
+module_exit(pvrdma_cleanup);
+
+MODULE_AUTHOR("VMware, Inc");
+MODULE_DESCRIPTION("VMware Paravirtual RDMA driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
new file mode 100644
index 0000000..948b5cc
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
@@ -0,0 +1,304 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/bitmap.h>
+
+#include "pvrdma.h"
+
+int pvrdma_page_dir_init(struct pvrdma_dev *dev, struct pvrdma_page_dir *pdir,
+			 u64 npages, bool alloc_pages)
+{
+	u64 i;
+
+	if (npages > PVRDMA_PAGE_DIR_MAX_PAGES)
+		return -EINVAL;
+
+	memset(pdir, 0, sizeof(*pdir));
+
+	pdir->dir = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
+				       &pdir->dir_dma, GFP_KERNEL);
+	if (!pdir->dir)
+		goto err;
+
+	pdir->ntables = PVRDMA_PAGE_DIR_TABLE(npages - 1) + 1;
+	pdir->tables = kcalloc(pdir->ntables, sizeof(*pdir->tables),
+			       GFP_KERNEL);
+	if (!pdir->tables)
+		goto err;
+
+	for (i = 0; i < pdir->ntables; i++) {
+		pdir->tables[i] = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
+						(dma_addr_t *)&pdir->dir[i],
+						GFP_KERNEL);
+		if (!pdir->tables[i])
+			goto err;
+	}
+
+	pdir->npages = npages;
+
+	if (alloc_pages) {
+		pdir->pages = kcalloc(npages, sizeof(*pdir->pages),
+				      GFP_KERNEL);
+		if (!pdir->pages)
+			goto err;
+
+		for (i = 0; i < pdir->npages; i++) {
+			dma_addr_t page_dma;
+
+			pdir->pages[i] = dma_alloc_coherent(&dev->pdev->dev,
+							    PAGE_SIZE,
+							    &page_dma,
+							    GFP_KERNEL);
+			if (!pdir->pages[i])
+				goto err;
+
+			pvrdma_page_dir_insert_dma(pdir, i, page_dma);
+		}
+	}
+
+	return 0;
+
+err:
+	pvrdma_page_dir_cleanup(dev, pdir);
+
+	return -ENOMEM;
+}
+
+static u64 *pvrdma_page_dir_table(struct pvrdma_page_dir *pdir, u64 idx)
+{
+	return pdir->tables[PVRDMA_PAGE_DIR_TABLE(idx)];
+}
+
+dma_addr_t pvrdma_page_dir_get_dma(struct pvrdma_page_dir *pdir, u64 idx)
+{
+	return pvrdma_page_dir_table(pdir, idx)[PVRDMA_PAGE_DIR_PAGE(idx)];
+}
+
+static void pvrdma_page_dir_cleanup_pages(struct pvrdma_dev *dev,
+					  struct pvrdma_page_dir *pdir)
+{
+	if (pdir->pages) {
+		u64 i;
+
+		for (i = 0; i < pdir->npages && pdir->pages[i]; i++) {
+			dma_addr_t page_dma = pvrdma_page_dir_get_dma(pdir, i);
+
+			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+					  pdir->pages[i], page_dma);
+		}
+
+		kfree(pdir->pages);
+	}
+}
+
+static void pvrdma_page_dir_cleanup_tables(struct pvrdma_dev *dev,
+					   struct pvrdma_page_dir *pdir)
+{
+	if (pdir->tables) {
+		int i;
+
+		pvrdma_page_dir_cleanup_pages(dev, pdir);
+
+		for (i = 0; i < pdir->ntables; i++) {
+			u64 *table = pdir->tables[i];
+
+			if (table)
+				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+						  table, pdir->dir[i]);
+		}
+
+		kfree(pdir->tables);
+	}
+}
+
+void pvrdma_page_dir_cleanup(struct pvrdma_dev *dev,
+			     struct pvrdma_page_dir *pdir)
+{
+	if (pdir->dir) {
+		pvrdma_page_dir_cleanup_tables(dev, pdir);
+		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+				  pdir->dir, pdir->dir_dma);
+	}
+}
+
+int pvrdma_page_dir_insert_dma(struct pvrdma_page_dir *pdir, u64 idx,
+			       dma_addr_t daddr)
+{
+	u64 *table;
+
+	if (idx >= pdir->npages)
+		return -EINVAL;
+
+	table = pvrdma_page_dir_table(pdir, idx);
+	table[PVRDMA_PAGE_DIR_PAGE(idx)] = daddr;
+
+	return 0;
+}
+
+int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
+				struct ib_umem *umem, u64 offset)
+{
+	u64 i = offset;
+	int j, entry;
+	int ret = 0, len = 0;
+	struct scatterlist *sg;
+
+	if (offset >= pdir->npages)
+		return -EINVAL;
+
+	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
+		len = sg_dma_len(sg) >> PAGE_SHIFT;
+		for (j = 0; j < len; j++) {
+			dma_addr_t addr = sg_dma_address(sg) +
+					  umem->page_size * j;
+
+			ret = pvrdma_page_dir_insert_dma(pdir, i, addr);
+			if (ret)
+				goto exit;
+
+			i++;
+		}
+	}
+
+exit:
+	return ret;
+}
+
+int pvrdma_page_dir_insert_page_list(struct pvrdma_page_dir *pdir,
+				     u64 *page_list,
+				     int num_pages)
+{
+	int i;
+	int ret;
+
+	if (num_pages > pdir->npages)
+		return -EINVAL;
+
+	for (i = 0; i < num_pages; i++) {
+		ret = pvrdma_page_dir_insert_dma(pdir, i, page_list[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+void pvrdma_qp_cap_to_ib(struct ib_qp_cap *dst, const struct pvrdma_qp_cap *src)
+{
+	dst->max_send_wr = src->max_send_wr;
+	dst->max_recv_wr = src->max_recv_wr;
+	dst->max_send_sge = src->max_send_sge;
+	dst->max_recv_sge = src->max_recv_sge;
+	dst->max_inline_data = src->max_inline_data;
+}
+
+void ib_qp_cap_to_pvrdma(struct pvrdma_qp_cap *dst, const struct ib_qp_cap *src)
+{
+	dst->max_send_wr = src->max_send_wr;
+	dst->max_recv_wr = src->max_recv_wr;
+	dst->max_send_sge = src->max_send_sge;
+	dst->max_recv_sge = src->max_recv_sge;
+	dst->max_inline_data = src->max_inline_data;
+}
+
+void pvrdma_gid_to_ib(union ib_gid *dst, const union pvrdma_gid *src)
+{
+	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
+	memcpy(dst, src, sizeof(*src));
+}
+
+void ib_gid_to_pvrdma(union pvrdma_gid *dst, const union ib_gid *src)
+{
+	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
+	memcpy(dst, src, sizeof(*src));
+}
+
+void pvrdma_global_route_to_ib(struct ib_global_route *dst,
+			       const struct pvrdma_global_route *src)
+{
+	pvrdma_gid_to_ib(&dst->dgid, &src->dgid);
+	dst->flow_label = src->flow_label;
+	dst->sgid_index = src->sgid_index;
+	dst->hop_limit = src->hop_limit;
+	dst->traffic_class = src->traffic_class;
+}
+
+void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
+			       const struct ib_global_route *src)
+{
+	ib_gid_to_pvrdma(&dst->dgid, &src->dgid);
+	dst->flow_label = src->flow_label;
+	dst->sgid_index = src->sgid_index;
+	dst->hop_limit = src->hop_limit;
+	dst->traffic_class = src->traffic_class;
+}
+
+void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
+			  const struct pvrdma_ah_attr *src)
+{
+	pvrdma_global_route_to_ib(&dst->grh, &src->grh);
+	dst->dlid = src->dlid;
+	dst->sl = src->sl;
+	dst->src_path_bits = src->src_path_bits;
+	dst->static_rate = src->static_rate;
+	dst->ah_flags = src->ah_flags;
+	dst->port_num = src->port_num;
+	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));
+}
+
+void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
+			  const struct ib_ah_attr *src)
+{
+	ib_global_route_to_pvrdma(&dst->grh, &src->grh);
+	dst->dlid = src->dlid;
+	dst->sl = src->sl;
+	dst->src_path_bits = src->src_path_bits;
+	dst->static_rate = src->static_rate;
+	dst->ah_flags = src->ah_flags;
+	dst->port_num = src->port_num;
+	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
new file mode 100644
index 0000000..8519f32
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
@@ -0,0 +1,334 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+
+#include "pvrdma.h"
+
+/**
+ * pvrdma_get_dma_mr - get a DMA memory region
+ * @pd: protection domain
+ * @acc: access flags
+ *
+ * @return: ib_mr pointer on success, otherwise returns an errno.
+ */
+struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc)
+{
+	struct pvrdma_dev *dev = to_vdev(pd->device);
+	struct pvrdma_user_mr *mr;
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
+	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
+	int ret;
+
+	/* Support only LOCAL_WRITE flag for DMA MRs */
+	if (acc & ~IB_ACCESS_LOCAL_WRITE) {
+		dev_warn(&dev->pdev->dev,
+			 "unsupported dma mr access flags %#x\n", acc);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_MR;
+	cmd->pd_handle = to_vpd(pd)->pd_handle;
+	cmd->access_flags = acc;
+	cmd->flags = PVRDMA_MR_FLAG_DMA;
+
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not get DMA mem region, error: %d\n", ret);
+		kfree(mr);
+		return ERR_PTR(ret);
+	}
+
+	mr->mmr.mr_handle = resp->mr_handle;
+	mr->ibmr.lkey = resp->lkey;
+	mr->ibmr.rkey = resp->rkey;
+
+	return &mr->ibmr;
+}
+
+/**
+ * pvrdma_reg_user_mr - register a userspace memory region
+ * @pd: protection domain
+ * @start: starting address
+ * @length: length of region
+ * @virt_addr: I/O virtual address
+ * @access_flags: access flags for memory region
+ * @udata: user data
+ *
+ * @return: ib_mr pointer on success, otherwise returns an errno.
+ */
+struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				 u64 virt_addr, int access_flags,
+				 struct ib_udata *udata)
+{
+	struct pvrdma_dev *dev = to_vdev(pd->device);
+	struct pvrdma_user_mr *mr = NULL;
+	struct ib_umem *umem;
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
+	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
+	int nchunks;
+	int ret;
+	int entry;
+	struct scatterlist *sg;
+
+	if (length == 0 || length > dev->dsr->caps.max_mr_size) {
+		dev_warn(&dev->pdev->dev, "invalid mem region length\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	umem = ib_umem_get(pd->uobject->context, start,
+			   length, access_flags, 0);
+	if (IS_ERR(umem)) {
+		dev_warn(&dev->pdev->dev,
+			 "could not get umem for mem region\n");
+		return ERR_CAST(umem);
+	}
+
+	nchunks = 0;
+	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry)
+		nchunks += sg_dma_len(sg) >> PAGE_SHIFT;
+
+	if (nchunks < 0 || nchunks > PVRDMA_PAGE_DIR_MAX_PAGES) {
+		dev_warn(&dev->pdev->dev, "overflow %d pages in mem region\n",
+			 nchunks);
+		ret = -EINVAL;
+		goto err_umem;
+	}
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr) {
+		ret = -ENOMEM;
+		goto err_umem;
+	}
+
+	mr->mmr.iova = virt_addr;
+	mr->mmr.size = length;
+	mr->umem = umem;
+
+	ret = pvrdma_page_dir_init(dev, &mr->pdir, nchunks, false);
+	if (ret) {
+		dev_warn(&dev->pdev->dev,
+			 "could not allocate page directory\n");
+		goto err_umem;
+	}
+
+	ret = pvrdma_page_dir_insert_umem(&mr->pdir, mr->umem, 0);
+	if (ret)
+		goto err_pdir;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_MR;
+	cmd->start = start;
+	cmd->length = length;
+	cmd->pd_handle = to_vpd(pd)->pd_handle;
+	cmd->access_flags = access_flags;
+	cmd->nchunks = nchunks;
+	cmd->pdir_dma = mr->pdir.dir_dma;
+
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not register mem region, error: %d\n", ret);
+		goto err_pdir;
+	}
+
+	mr->mmr.mr_handle = resp->mr_handle;
+	mr->ibmr.lkey = resp->lkey;
+	mr->ibmr.rkey = resp->rkey;
+
+	return &mr->ibmr;
+
+err_pdir:
+	pvrdma_page_dir_cleanup(dev, &mr->pdir);
+err_umem:
+	ib_umem_release(umem);
+	kfree(mr);
+
+	return ERR_PTR(ret);
+}
+
+/**
+ * pvrdma_alloc_mr - allocate a memory region
+ * @pd: protection domain
+ * @mr_type: type of memory region
+ * @max_num_sg: maximum number of pages
+ *
+ * @return: ib_mr pointer on success, otherwise returns an errno.
+ */
+struct ib_mr *pvrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
+			      u32 max_num_sg)
+{
+	struct pvrdma_dev *dev = to_vdev(pd->device);
+	struct pvrdma_user_mr *mr;
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
+	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
+	int size = max_num_sg * sizeof(u64);
+	int ret;
+
+	if (mr_type != IB_MR_TYPE_MEM_REG ||
+	    max_num_sg > PVRDMA_MAX_FAST_REG_PAGES)
+		return ERR_PTR(-EINVAL);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->pages = kzalloc(size, GFP_KERNEL);
+	if (!mr->pages) {
+		ret = -ENOMEM;
+		goto freemr;
+	}
+
+	ret = pvrdma_page_dir_init(dev, &mr->pdir, max_num_sg, false);
+	if (ret) {
+		dev_warn(&dev->pdev->dev,
+			 "failed to allocate page dir for mr\n");
+		ret = -ENOMEM;
+		goto freepages;
+	}
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_MR;
+	cmd->pd_handle = to_vpd(pd)->pd_handle;
+	cmd->access_flags = 0;
+	cmd->flags = PVRDMA_MR_FLAG_FRMR;
+	cmd->nchunks = max_num_sg;
+
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not create FR mem region, error: %d\n", ret);
+		goto freepdir;
+	}
+
+	mr->max_pages = max_num_sg;
+	mr->mmr.mr_handle = resp->mr_handle;
+	mr->ibmr.lkey = resp->lkey;
+	mr->ibmr.rkey = resp->rkey;
+	mr->page_shift = PAGE_SHIFT;
+	mr->umem = NULL;
+
+	return &mr->ibmr;
+
+freepdir:
+	pvrdma_page_dir_cleanup(dev, &mr->pdir);
+freepages:
+	kfree(mr->pages);
+freemr:
+	kfree(mr);
+	return ERR_PTR(ret);
+}
+
+/**
+ * pvrdma_dereg_mr - deregister a memory region
+ * @ibmr: memory region
+ *
+ * @return: 0 on success.
+ */
+int pvrdma_dereg_mr(struct ib_mr *ibmr)
+{
+	struct pvrdma_user_mr *mr = to_vmr(ibmr);
+	struct pvrdma_dev *dev = to_vdev(ibmr->device);
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_destroy_mr *cmd = &req.destroy_mr;
+	int ret;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_MR;
+	cmd->mr_handle = mr->mmr.mr_handle;
+	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
+	if (ret < 0)
+		dev_warn(&dev->pdev->dev,
+			 "could not deregister mem region, error: %d\n", ret);
+
+	pvrdma_page_dir_cleanup(dev, &mr->pdir);
+	if (mr->umem)
+		ib_umem_release(mr->umem);
+
+	kfree(mr->pages);
+	kfree(mr);
+
+	return 0;
+}
+
+static int pvrdma_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct pvrdma_user_mr *mr = to_vmr(ibmr);
+
+	if (mr->npages == mr->max_pages)
+		return -ENOMEM;
+
+	mr->pages[mr->npages++] = addr;
+	return 0;
+}
+
+int pvrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		     unsigned int *sg_offset)
+{
+	struct pvrdma_user_mr *mr = to_vmr(ibmr);
+	struct pvrdma_dev *dev = to_vdev(ibmr->device);
+	int ret;
+
+	mr->npages = 0;
+
+	ret = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, pvrdma_set_page);
+	if (ret < 0)
+		dev_warn(&dev->pdev->dev, "could not map sg to pages\n");
+
+	return ret;
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
new file mode 100644
index 0000000..c8c01e5
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -0,0 +1,972 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <asm/page.h>
+#include <linux/io.h>
+#include <linux/wait.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "pvrdma.h"
+
+static inline void get_cqs(struct pvrdma_qp *qp, struct pvrdma_cq **send_cq,
+			   struct pvrdma_cq **recv_cq)
+{
+	*send_cq = to_vcq(qp->ibqp.send_cq);
+	*recv_cq = to_vcq(qp->ibqp.recv_cq);
+}
+
+static void pvrdma_lock_cqs(struct pvrdma_cq *scq, struct pvrdma_cq *rcq,
+			    unsigned long *scq_flags,
+			    unsigned long *rcq_flags)
+	__acquires(scq->cq_lock) __acquires(rcq->cq_lock)
+{
+	if (scq == rcq) {
+		spin_lock_irqsave(&scq->cq_lock, *scq_flags);
+		__acquire(rcq->cq_lock);
+	} else if (scq->cq_handle < rcq->cq_handle) {
+		spin_lock_irqsave(&scq->cq_lock, *scq_flags);
+		spin_lock_irqsave_nested(&rcq->cq_lock, *rcq_flags,
+					 SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock_irqsave(&rcq->cq_lock, *rcq_flags);
+		spin_lock_irqsave_nested(&scq->cq_lock, *scq_flags,
+					 SINGLE_DEPTH_NESTING);
+	}
+}
+
+static void pvrdma_unlock_cqs(struct pvrdma_cq *scq, struct pvrdma_cq *rcq,
+			      unsigned long *scq_flags,
+			      unsigned long *rcq_flags)
+	__releases(scq->cq_lock) __releases(rcq->cq_lock)
+{
+	if (scq == rcq) {
+		__release(rcq->cq_lock);
+		spin_unlock_irqrestore(&scq->cq_lock, *scq_flags);
+	} else if (scq->cq_handle < rcq->cq_handle) {
+		spin_unlock_irqrestore(&rcq->cq_lock, *rcq_flags);
+		spin_unlock_irqrestore(&scq->cq_lock, *scq_flags);
+	} else {
+		spin_unlock_irqrestore(&scq->cq_lock, *scq_flags);
+		spin_unlock_irqrestore(&rcq->cq_lock, *rcq_flags);
+	}
+}
+
+static void pvrdma_reset_qp(struct pvrdma_qp *qp)
+{
+	struct pvrdma_cq *scq, *rcq;
+	unsigned long scq_flags, rcq_flags;
+
+	/* Clean up cqes */
+	get_cqs(qp, &scq, &rcq);
+	pvrdma_lock_cqs(scq, rcq, &scq_flags, &rcq_flags);
+
+	_pvrdma_flush_cqe(qp, scq);
+	if (scq != rcq)
+		_pvrdma_flush_cqe(qp, rcq);
+
+	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
+
+	/*
+	 * Reset queuepair. The checks are because usermode queuepairs won't
+	 * have kernel ringstates.
+	 */
+	if (qp->rq.ring) {
+		atomic_set(&qp->rq.ring->cons_head, 0);
+		atomic_set(&qp->rq.ring->prod_tail, 0);
+	}
+	if (qp->sq.ring) {
+		atomic_set(&qp->sq.ring->cons_head, 0);
+		atomic_set(&qp->sq.ring->prod_tail, 0);
+	}
+}
+
+static int pvrdma_set_rq_size(struct pvrdma_dev *dev,
+			      struct ib_qp_cap *req_cap,
+			      struct pvrdma_qp *qp)
+{
+	if (req_cap->max_recv_wr > dev->dsr->caps.max_qp_wr ||
+	    req_cap->max_recv_sge > dev->dsr->caps.max_sge) {
+		dev_warn(&dev->pdev->dev, "recv queue size invalid\n");
+		return -EINVAL;
+	}
+
+	qp->rq.wqe_cnt = roundup_pow_of_two(max(1U, req_cap->max_recv_wr));
+	qp->rq.max_sg = roundup_pow_of_two(max(1U, req_cap->max_recv_sge));
+
+	/* Write back */
+	req_cap->max_recv_wr = qp->rq.wqe_cnt;
+	req_cap->max_recv_sge = qp->rq.max_sg;
+
+	qp->rq.wqe_size = roundup_pow_of_two(sizeof(struct pvrdma_rq_wqe_hdr) +
+					     sizeof(struct pvrdma_sge) *
+					     qp->rq.max_sg);
+	qp->npages_recv = (qp->rq.wqe_cnt * qp->rq.wqe_size + PAGE_SIZE - 1) /
+			  PAGE_SIZE;
+
+	return 0;
+}
+
+static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap *req_cap,
+			      enum ib_qp_type type, struct pvrdma_qp *qp)
+{
+	if (req_cap->max_send_wr > dev->dsr->caps.max_qp_wr ||
+	    req_cap->max_send_sge > dev->dsr->caps.max_sge) {
+		dev_warn(&dev->pdev->dev, "send queue size invalid\n");
+		return -EINVAL;
+	}
+
+	qp->sq.wqe_cnt = roundup_pow_of_two(max(1U, req_cap->max_send_wr));
+	qp->sq.max_sg = roundup_pow_of_two(max(1U, req_cap->max_send_sge));
+
+	/* Write back */
+	req_cap->max_send_wr = qp->sq.wqe_cnt;
+	req_cap->max_send_sge = qp->sq.max_sg;
+
+	qp->sq.wqe_size = roundup_pow_of_two(sizeof(struct pvrdma_sq_wqe_hdr) +
+					     sizeof(struct pvrdma_sge) *
+					     qp->sq.max_sg);
+	/* Note: one extra page for the header. */
+	qp->npages_send = 1 + (qp->sq.wqe_cnt * qp->sq.wqe_size +
+			       PAGE_SIZE - 1) / PAGE_SIZE;
+
+	return 0;
+}
+
+/**
+ * pvrdma_create_qp - create queue pair
+ * @pd: protection domain
+ * @init_attr: queue pair attributes
+ * @udata: user data
+ *
+ * @return: the ib_qp pointer on success, otherwise returns an errno.
+ */
+struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
+			       struct ib_qp_init_attr *init_attr,
+			       struct ib_udata *udata)
+{
+	struct pvrdma_qp *qp = NULL;
+	struct pvrdma_dev *dev = to_vdev(pd->device);
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_qp *cmd = &req.create_qp;
+	struct pvrdma_cmd_create_qp_resp *resp = &rsp.create_qp_resp;
+	struct pvrdma_create_qp ucmd;
+	unsigned long flags;
+	int ret;
+
+	if (init_attr->create_flags) {
+		dev_warn(&dev->pdev->dev,
+			 "invalid create queuepair flags %#x\n",
+			 init_attr->create_flags);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (init_attr->qp_type != IB_QPT_RC &&
+	    init_attr->qp_type != IB_QPT_UD &&
+	    init_attr->qp_type != IB_QPT_GSI) {
+		dev_warn(&dev->pdev->dev, "queuepair type %d not supported\n",
+			 init_attr->qp_type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!atomic_add_unless(&dev->num_qps, 1, dev->dsr->caps.max_qp))
+		return ERR_PTR(-ENOMEM);
+
+	switch (init_attr->qp_type) {
+	case IB_QPT_GSI:
+		if (init_attr->port_num == 0 ||
+		    init_attr->port_num > pd->device->phys_port_cnt ||
+		    udata) {
+			dev_warn(&dev->pdev->dev, "invalid queuepair attrs\n");
+			ret = -EINVAL;
+			goto err_qp;
+		}
+		/* fall through */
+	case IB_QPT_RC:
+	case IB_QPT_UD:
+		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+		if (!qp) {
+			ret = -ENOMEM;
+			goto err_qp;
+		}
+
+		spin_lock_init(&qp->sq.lock);
+		spin_lock_init(&qp->rq.lock);
+		mutex_init(&qp->mutex);
+		atomic_set(&qp->refcnt, 1);
+		init_waitqueue_head(&qp->wait);
+
+		qp->state = IB_QPS_RESET;
+
+		if (pd->uobject && udata) {
+			dev_dbg(&dev->pdev->dev,
+				"create queuepair from user space\n");
+
+			if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
+				ret = -EFAULT;
+				goto err_qp;
+			}
+
+			/* set qp->sq.wqe_cnt, shift, buf_size.. */
+			qp->rumem = ib_umem_get(pd->uobject->context,
+						ucmd.rbuf_addr,
+						ucmd.rbuf_size, 0, 0);
+			if (IS_ERR(qp->rumem)) {
+				ret = PTR_ERR(qp->rumem);
+				goto err_qp;
+			}
+
+			qp->sumem = ib_umem_get(pd->uobject->context,
+						ucmd.sbuf_addr,
+						ucmd.sbuf_size, 0, 0);
+			if (IS_ERR(qp->sumem)) {
+				ib_umem_release(qp->rumem);
+				ret = PTR_ERR(qp->sumem);
+				goto err_qp;
+			}
+
+			qp->npages_send = ib_umem_page_count(qp->sumem);
+			qp->npages_recv = ib_umem_page_count(qp->rumem);
+			qp->npages = qp->npages_send + qp->npages_recv;
+		} else {
+			qp->is_kernel = true;
+
+			ret = pvrdma_set_sq_size(to_vdev(pd->device),
+						 &init_attr->cap,
+						 init_attr->qp_type, qp);
+			if (ret)
+				goto err_qp;
+
+			ret = pvrdma_set_rq_size(to_vdev(pd->device),
+						 &init_attr->cap, qp);
+			if (ret)
+				goto err_qp;
+
+			qp->npages = qp->npages_send + qp->npages_recv;
+
+			/* Skip header page. */
+			qp->sq.offset = PAGE_SIZE;
+
+			/* Recv queue pages are after send pages. */
+			qp->rq.offset = qp->npages_send * PAGE_SIZE;
+		}
+
+		if (qp->npages < 0 || qp->npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
+			dev_warn(&dev->pdev->dev,
+				 "overflow pages in queuepair\n");
+			ret = -EINVAL;
+			goto err_umem;
+		}
+
+		ret = pvrdma_page_dir_init(dev, &qp->pdir, qp->npages,
+					   qp->is_kernel);
+		if (ret) {
+			dev_warn(&dev->pdev->dev,
+				 "could not allocate page directory\n");
+			goto err_umem;
+		}
+
+		if (!qp->is_kernel) {
+			pvrdma_page_dir_insert_umem(&qp->pdir, qp->sumem, 0);
+			pvrdma_page_dir_insert_umem(&qp->pdir, qp->rumem,
+						    qp->npages_send);
+		} else {
+			/* Ring state is always the first page. */
+			qp->sq.ring = qp->pdir.pages[0];
+			qp->rq.ring = &qp->sq.ring[1];
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_qp;
+	}
+
+	/* Not supported */
+	init_attr->cap.max_inline_data = 0;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_QP;
+	cmd->pd_handle = to_vpd(pd)->pd_handle;
+	cmd->send_cq_handle = to_vcq(init_attr->send_cq)->cq_handle;
+	cmd->recv_cq_handle = to_vcq(init_attr->recv_cq)->cq_handle;
+	cmd->max_send_wr = init_attr->cap.max_send_wr;
+	cmd->max_recv_wr = init_attr->cap.max_recv_wr;
+	cmd->max_send_sge = init_attr->cap.max_send_sge;
+	cmd->max_recv_sge = init_attr->cap.max_recv_sge;
+	cmd->max_inline_data = init_attr->cap.max_inline_data;
+	cmd->sq_sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) ? 1 : 0;
+	cmd->qp_type = ib_qp_type_to_pvrdma(init_attr->qp_type);
+	cmd->access_flags = IB_ACCESS_LOCAL_WRITE;
+	cmd->total_chunks = qp->npages;
+	cmd->send_chunks = qp->npages_send - 1;
+	cmd->pdir_dma = qp->pdir.dir_dma;
+
+	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
+		cmd->max_send_wr, cmd->max_recv_wr, cmd->max_send_sge,
+		cmd->max_recv_sge);
+
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_QP_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not create queuepair, error: %d\n", ret);
+		goto err_pdir;
+	}
+
+	/* max_send_wr/_recv_wr/_send_sge/_recv_sge/_inline_data */
+	qp->qp_handle = resp->qpn;
+	qp->port = init_attr->port_num;
+	qp->ibqp.qp_num = resp->qpn;
+	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
+	dev->qp_tbl[qp->qp_handle % dev->dsr->caps.max_qp] = qp;
+	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
+
+	return &qp->ibqp;
+
+err_pdir:
+	pvrdma_page_dir_cleanup(dev, &qp->pdir);
+err_umem:
+	if (pd->uobject && udata) {
+		if (qp->rumem)
+			ib_umem_release(qp->rumem);
+		if (qp->sumem)
+			ib_umem_release(qp->sumem);
+	}
+err_qp:
+	kfree(qp);
+	atomic_dec(&dev->num_qps);
+
+	return ERR_PTR(ret);
+}
+
+static void pvrdma_free_qp(struct pvrdma_qp *qp)
+{
+	struct pvrdma_dev *dev = to_vdev(qp->ibqp.device);
+	struct pvrdma_cq *scq;
+	struct pvrdma_cq *rcq;
+	unsigned long flags, scq_flags, rcq_flags;
+
+	/* In case cq is polling */
+	get_cqs(qp, &scq, &rcq);
+	pvrdma_lock_cqs(scq, rcq, &scq_flags, &rcq_flags);
+
+	_pvrdma_flush_cqe(qp, scq);
+	if (scq != rcq)
+		_pvrdma_flush_cqe(qp, rcq);
+
+	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
+	dev->qp_tbl[qp->qp_handle] = NULL;
+	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
+
+	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
+
+	atomic_dec(&qp->refcnt);
+	wait_event(qp->wait, !atomic_read(&qp->refcnt));
+
+	pvrdma_page_dir_cleanup(dev, &qp->pdir);
+
+	kfree(qp);
+
+	atomic_dec(&dev->num_qps);
+}
+
+/**
+ * pvrdma_destroy_qp - destroy a queue pair
+ * @qp: the queue pair to destroy
+ *
+ * @return: 0 on success.
+ */
+int pvrdma_destroy_qp(struct ib_qp *qp)
+{
+	struct pvrdma_qp *vqp = to_vqp(qp);
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_destroy_qp *cmd = &req.destroy_qp;
+	int ret;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_QP;
+	cmd->qp_handle = vqp->qp_handle;
+
+	ret = pvrdma_cmd_post(to_vdev(qp->device), &req, NULL, 0);
+	if (ret < 0)
+		dev_warn(&to_vdev(qp->device)->pdev->dev,
+			 "destroy queuepair failed, error: %d\n", ret);
+
+	pvrdma_free_qp(vqp);
+
+	return 0;
+}
+
+/**
+ * pvrdma_modify_qp - modify queue pair attributes
+ * @ibqp: the queue pair
+ * @attr: the new queue pair's attributes
+ * @attr_mask: attributes mask
+ * @udata: user data
+ *
+ * @returns 0 on success, otherwise returns an errno.
+ */
+int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		     int attr_mask, struct ib_udata *udata)
+{
+	struct pvrdma_dev *dev = to_vdev(ibqp->device);
+	struct pvrdma_qp *qp = to_vqp(ibqp);
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_modify_qp *cmd = &req.modify_qp;
+	int cur_state, next_state;
+	int ret;
+
+	/* Sanity checking. Should need lock here */
+	mutex_lock(&qp->mutex);
+	cur_state = (attr_mask & IB_QP_CUR_STATE) ? attr->cur_qp_state :
+		qp->state;
+	next_state = (attr_mask & IB_QP_STATE) ? attr->qp_state : cur_state;
+
+	if (!ib_modify_qp_is_ok(cur_state, next_state, ibqp->qp_type,
+				attr_mask, IB_LINK_LAYER_ETHERNET)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (attr_mask & IB_QP_PORT) {
+		if (attr->port_num == 0 ||
+		    attr->port_num > ibqp->device->phys_port_cnt) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (attr_mask & IB_QP_MIN_RNR_TIMER) {
+		if (attr->min_rnr_timer > 31) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (attr_mask & IB_QP_PKEY_INDEX) {
+		if (attr->pkey_index >= dev->dsr->caps.max_pkeys) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (attr_mask & IB_QP_QKEY)
+		qp->qkey = attr->qkey;
+
+	if (cur_state == next_state && cur_state == IB_QPS_RESET) {
+		ret = 0;
+		goto out;
+	}
+
+	qp->state = next_state;
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_MODIFY_QP;
+	cmd->qp_handle = qp->qp_handle;
+	cmd->attr_mask = ib_qp_attr_mask_to_pvrdma(attr_mask);
+	cmd->attrs.qp_state = ib_qp_state_to_pvrdma(attr->qp_state);
+	cmd->attrs.cur_qp_state =
+		ib_qp_state_to_pvrdma(attr->cur_qp_state);
+	cmd->attrs.path_mtu = ib_mtu_to_pvrdma(attr->path_mtu);
+	cmd->attrs.path_mig_state =
+		ib_mig_state_to_pvrdma(attr->path_mig_state);
+	cmd->attrs.qkey = attr->qkey;
+	cmd->attrs.rq_psn = attr->rq_psn;
+	cmd->attrs.sq_psn = attr->sq_psn;
+	cmd->attrs.dest_qp_num = attr->dest_qp_num;
+	cmd->attrs.qp_access_flags =
+		ib_access_flags_to_pvrdma(attr->qp_access_flags);
+	cmd->attrs.pkey_index = attr->pkey_index;
+	cmd->attrs.alt_pkey_index = attr->alt_pkey_index;
+	cmd->attrs.en_sqd_async_notify = attr->en_sqd_async_notify;
+	cmd->attrs.sq_draining = attr->sq_draining;
+	cmd->attrs.max_rd_atomic = attr->max_rd_atomic;
+	cmd->attrs.max_dest_rd_atomic = attr->max_dest_rd_atomic;
+	cmd->attrs.min_rnr_timer = attr->min_rnr_timer;
+	cmd->attrs.port_num = attr->port_num;
+	cmd->attrs.timeout = attr->timeout;
+	cmd->attrs.retry_cnt = attr->retry_cnt;
+	cmd->attrs.rnr_retry = attr->rnr_retry;
+	cmd->attrs.alt_port_num = attr->alt_port_num;
+	cmd->attrs.alt_timeout = attr->alt_timeout;
+	ib_qp_cap_to_pvrdma(&cmd->attrs.cap, &attr->cap);
+	ib_ah_attr_to_pvrdma(&cmd->attrs.ah_attr, &attr->ah_attr);
+	ib_ah_attr_to_pvrdma(&cmd->attrs.alt_ah_attr, &attr->alt_ah_attr);
+
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_MODIFY_QP_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not modify queuepair, error: %d\n", ret);
+	} else if (rsp.hdr.err > 0) {
+		dev_warn(&dev->pdev->dev,
+			 "cannot modify queuepair, error: %d\n", rsp.hdr.err);
+		ret = -EINVAL;
+	}
+
+	if (ret == 0 && next_state == IB_QPS_RESET)
+		pvrdma_reset_qp(qp);
+
+out:
+	mutex_unlock(&qp->mutex);
+
+	return ret;
+}
+
+static inline void *get_sq_wqe(struct pvrdma_qp *qp, int n)
+{
+	return pvrdma_page_dir_get_ptr(&qp->pdir,
+				       qp->sq.offset + n * qp->sq.wqe_size);
+}
+
+static inline void *get_rq_wqe(struct pvrdma_qp *qp, int n)
+{
+	return pvrdma_page_dir_get_ptr(&qp->pdir,
+				       qp->rq.offset + n * qp->rq.wqe_size);
+}
+
+static int set_reg_seg(struct pvrdma_sq_wqe_hdr *wqe_hdr, struct ib_reg_wr *wr)
+{
+	struct pvrdma_user_mr *mr = to_vmr(wr->mr);
+
+	wqe_hdr->wr.fast_reg.iova_start = mr->ibmr.iova;
+	wqe_hdr->wr.fast_reg.pl_pdir_dma = mr->pdir.dir_dma;
+	wqe_hdr->wr.fast_reg.page_shift = mr->page_shift;
+	wqe_hdr->wr.fast_reg.page_list_len = mr->npages;
+	wqe_hdr->wr.fast_reg.length = mr->ibmr.length;
+	wqe_hdr->wr.fast_reg.access_flags = wr->access;
+	wqe_hdr->wr.fast_reg.rkey = wr->key;
+
+	return pvrdma_page_dir_insert_page_list(&mr->pdir, mr->pages,
+						mr->npages);
+}
+
+/**
+ * pvrdma_post_send - post send work request entries on a QP
+ * @ibqp: the QP
+ * @wr: work request list to post
+ * @bad_wr: the first bad WR returned
+ *
+ * @return: 0 on success, otherwise errno returned.
+ */
+int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		     struct ib_send_wr **bad_wr)
+{
+	struct pvrdma_qp *qp = to_vqp(ibqp);
+	struct pvrdma_dev *dev = to_vdev(ibqp->device);
+	unsigned long flags;
+	struct pvrdma_sq_wqe_hdr *wqe_hdr;
+	struct pvrdma_sge *sge;
+	int i, index;
+	int nreq;
+	int ret;
+
+	/*
+	 * In states lower than RTS, we can fail immediately. In other states,
+	 * just post and let the device figure it out.
+	 */
+	if (qp->state < IB_QPS_RTS) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&qp->sq.lock, flags);
+
+	index = pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
+	for (nreq = 0; wr; nreq++, wr = wr->next) {
+		unsigned int tail;
+
+		if (unlikely(!pvrdma_idx_ring_has_space(
+				qp->sq.ring, qp->sq.wqe_cnt, &tail))) {
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "send queue is full\n");
+			*bad_wr = wr;
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (unlikely(wr->num_sge > qp->sq.max_sg || wr->num_sge < 0)) {
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "send SGE overflow\n");
+			*bad_wr = wr;
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (unlikely(wr->opcode < 0)) {
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "invalid send opcode\n");
+			*bad_wr = wr;
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * Only support UD, RC.
+		 * Need to check opcode table for thorough checking.
+		 * opcode		_UD	_UC	_RC
+		 * _SEND		x	x	x
+		 * _SEND_WITH_IMM	x	x	x
+		 * _RDMA_WRITE			x	x
+		 * _RDMA_WRITE_WITH_IMM		x	x
+		 * _LOCAL_INV			x	x
+		 * _SEND_WITH_INV		x	x
+		 * _RDMA_READ				x
+		 * _ATOMIC_CMP_AND_SWP			x
+		 * _ATOMIC_FETCH_AND_ADD		x
+		 * _MASK_ATOMIC_CMP_AND_SWP		x
+		 * _MASK_ATOMIC_FETCH_AND_ADD		x
+		 * _REG_MR				x
+		 *
+		 */
+		if (qp->ibqp.qp_type != IB_QPT_UD &&
+		    qp->ibqp.qp_type != IB_QPT_RC &&
+			wr->opcode != IB_WR_SEND) {
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "unsupported queuepair type\n");
+			*bad_wr = wr;
+			ret = -EINVAL;
+			goto out;
+		} else if (qp->ibqp.qp_type == IB_QPT_UD ||
+			   qp->ibqp.qp_type == IB_QPT_GSI) {
+			if (wr->opcode != IB_WR_SEND &&
+			    wr->opcode != IB_WR_SEND_WITH_IMM) {
+				dev_warn_ratelimited(&dev->pdev->dev,
+						     "invalid send opcode\n");
+				*bad_wr = wr;
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+
+		wqe_hdr = (struct pvrdma_sq_wqe_hdr *)get_sq_wqe(qp, index);
+		memset(wqe_hdr, 0, sizeof(*wqe_hdr));
+		wqe_hdr->wr_id = wr->wr_id;
+		wqe_hdr->num_sge = wr->num_sge;
+		wqe_hdr->opcode = ib_wr_opcode_to_pvrdma(wr->opcode);
+		wqe_hdr->send_flags = ib_send_flags_to_pvrdma(wr->send_flags);
+		if (wr->opcode == IB_WR_SEND_WITH_IMM ||
+		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
+			wqe_hdr->ex.imm_data = wr->ex.imm_data;
+
+		switch (qp->ibqp.qp_type) {
+		case IB_QPT_GSI:
+		case IB_QPT_UD:
+			if (unlikely(!ud_wr(wr)->ah)) {
+				dev_warn_ratelimited(&dev->pdev->dev,
+						     "invalid address handle\n");
+				*bad_wr = wr;
+				ret = -EINVAL;
+				goto out;
+			}
+
+			/*
+			 * Use qkey from qp context if high order bit set,
+			 * otherwise from work request.
+			 */
+			wqe_hdr->wr.ud.remote_qpn = ud_wr(wr)->remote_qpn;
+			wqe_hdr->wr.ud.remote_qkey =
+				ud_wr(wr)->remote_qkey & 0x80000000 ?
+				qp->qkey : ud_wr(wr)->remote_qkey;
+			wqe_hdr->wr.ud.av = to_vah(ud_wr(wr)->ah)->av;
+
+			break;
+		case IB_QPT_RC:
+			switch (wr->opcode) {
+			case IB_WR_RDMA_READ:
+			case IB_WR_RDMA_WRITE:
+			case IB_WR_RDMA_WRITE_WITH_IMM:
+				wqe_hdr->wr.rdma.remote_addr =
+					rdma_wr(wr)->remote_addr;
+				wqe_hdr->wr.rdma.rkey = rdma_wr(wr)->rkey;
+				break;
+			case IB_WR_LOCAL_INV:
+			case IB_WR_SEND_WITH_INV:
+				wqe_hdr->ex.invalidate_rkey =
+					wr->ex.invalidate_rkey;
+				break;
+			case IB_WR_ATOMIC_CMP_AND_SWP:
+			case IB_WR_ATOMIC_FETCH_AND_ADD:
+				wqe_hdr->wr.atomic.remote_addr =
+					atomic_wr(wr)->remote_addr;
+				wqe_hdr->wr.atomic.rkey = atomic_wr(wr)->rkey;
+				wqe_hdr->wr.atomic.compare_add =
+					atomic_wr(wr)->compare_add;
+				if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP)
+					wqe_hdr->wr.atomic.swap =
+						atomic_wr(wr)->swap;
+				break;
+			case IB_WR_REG_MR:
+				ret = set_reg_seg(wqe_hdr, reg_wr(wr));
+				if (ret < 0) {
+					dev_warn_ratelimited(&dev->pdev->dev,
+							     "Failed to set fast register work request\n");
+					*bad_wr = wr;
+					goto out;
+				}
+				break;
+			default:
+				break;
+			}
+
+			break;
+		default:
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "invalid queuepair type\n");
+			ret = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		sge = (struct pvrdma_sge *)(wqe_hdr + 1);
+		for (i = 0; i < wr->num_sge; i++) {
+			/* Need to check wqe_size 0 or max size */
+			sge->addr = wr->sg_list[i].addr;
+			sge->length = wr->sg_list[i].length;
+			sge->lkey = wr->sg_list[i].lkey;
+			sge++;
+		}
+
+		/* Make sure wqe is written before index update */
+		smp_wmb();
+
+		index++;
+		if (unlikely(index >= qp->sq.wqe_cnt))
+			index = 0;
+		/* Update shared sq ring */
+		pvrdma_idx_ring_inc(&qp->sq.ring->prod_tail,
+				    qp->sq.wqe_cnt);
+	}
+
+	ret = 0;
+
+out:
+	spin_unlock_irqrestore(&qp->sq.lock, flags);
+
+	if (!ret)
+		pvrdma_write_uar_qp(dev, PVRDMA_UAR_QP_SEND | qp->qp_handle);
+
+	return ret;
+}
+
+/**
+ * pvrdma_post_receive - post receive work request entries on a QP
+ * @ibqp: the QP
+ * @wr: the work request list to post
+ * @bad_wr: the first bad WR returned
+ *
+ * @return: 0 on success, otherwise errno returned.
+ */
+int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		     struct ib_recv_wr **bad_wr)
+{
+	struct pvrdma_dev *dev = to_vdev(ibqp->device);
+	unsigned long flags;
+	struct pvrdma_qp *qp = to_vqp(ibqp);
+	struct pvrdma_rq_wqe_hdr *wqe_hdr;
+	struct pvrdma_sge *sge;
+	int index, nreq;
+	int ret = 0;
+	int i;
+
+	/*
+	 * In the RESET state, we can fail immediately. For other states,
+	 * just post and let the device figure it out.
+	 */
+	if (qp->state == IB_QPS_RESET) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&qp->rq.lock, flags);
+
+	index = pvrdma_idx(&qp->rq.ring->prod_tail, qp->rq.wqe_cnt);
+	for (nreq = 0; wr; nreq++, wr = wr->next) {
+		unsigned int tail;
+
+		if (unlikely(wr->num_sge > qp->rq.max_sg ||
+			     wr->num_sge < 0)) {
+			ret = -EINVAL;
+			*bad_wr = wr;
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "recv SGE overflow\n");
+			goto out;
+		}
+
+		if (unlikely(!pvrdma_idx_ring_has_space(
+				qp->rq.ring, qp->rq.wqe_cnt, &tail))) {
+			ret = -ENOMEM;
+			*bad_wr = wr;
+			dev_warn_ratelimited(&dev->pdev->dev,
+					     "recv queue full\n");
+			goto out;
+		}
+
+		wqe_hdr = (struct pvrdma_rq_wqe_hdr *)get_rq_wqe(qp, index);
+		wqe_hdr->wr_id = wr->wr_id;
+		wqe_hdr->num_sge = wr->num_sge;
+		wqe_hdr->total_len = 0;
+
+		sge = (struct pvrdma_sge *)(wqe_hdr + 1);
+		for (i = 0; i < wr->num_sge; i++) {
+			sge->addr = wr->sg_list[i].addr;
+			sge->length = wr->sg_list[i].length;
+			sge->lkey = wr->sg_list[i].lkey;
+			sge++;
+		}
+
+		/* Make sure wqe is written before index update */
+		smp_wmb();
+
+		index++;
+		if (unlikely(index >= qp->rq.wqe_cnt))
+			index = 0;
+		/* Update shared rq ring */
+		pvrdma_idx_ring_inc(&qp->rq.ring->prod_tail,
+				    qp->rq.wqe_cnt);
+	}
+
+	spin_unlock_irqrestore(&qp->rq.lock, flags);
+
+	pvrdma_write_uar_qp(dev, PVRDMA_UAR_QP_RECV | qp->qp_handle);
+
+	return ret;
+
+out:
+	spin_unlock_irqrestore(&qp->rq.lock, flags);
+
+	return ret;
+}
+
+/**
+ * pvrdma_query_qp - query a queue pair's attributes
+ * @ibqp: the queue pair to query
+ * @attr: the queue pair's attributes
+ * @attr_mask: attributes mask
+ * @init_attr: initial queue pair attributes
+ *
+ * @returns 0 on success, otherwise returns an errno.
+ */
+int pvrdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		    int attr_mask, struct ib_qp_init_attr *init_attr)
+{
+	struct pvrdma_dev *dev = to_vdev(ibqp->device);
+	struct pvrdma_qp *qp = to_vqp(ibqp);
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_query_qp *cmd = &req.query_qp;
+	struct pvrdma_cmd_query_qp_resp *resp = &rsp.query_qp_resp;
+	int ret = 0;
+
+	mutex_lock(&qp->mutex);
+
+	if (qp->state == IB_QPS_RESET) {
+		attr->qp_state = IB_QPS_RESET;
+		goto out;
+	}
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_QUERY_QP;
+	cmd->qp_handle = qp->qp_handle;
+	cmd->attr_mask = ib_qp_attr_mask_to_pvrdma(attr_mask);
+
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_QUERY_QP_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not query queuepair, error: %d\n", ret);
+		goto out;
+	}
+
+	attr->qp_state = pvrdma_qp_state_to_ib(resp->attrs.qp_state);
+	attr->cur_qp_state =
+		pvrdma_qp_state_to_ib(resp->attrs.cur_qp_state);
+	attr->path_mtu = pvrdma_mtu_to_ib(resp->attrs.path_mtu);
+	attr->path_mig_state =
+		pvrdma_mig_state_to_ib(resp->attrs.path_mig_state);
+	attr->qkey = resp->attrs.qkey;
+	attr->rq_psn = resp->attrs.rq_psn;
+	attr->sq_psn = resp->attrs.sq_psn;
+	attr->dest_qp_num = resp->attrs.dest_qp_num;
+	attr->qp_access_flags =
+		pvrdma_access_flags_to_ib(resp->attrs.qp_access_flags);
+	attr->pkey_index = resp->attrs.pkey_index;
+	attr->alt_pkey_index = resp->attrs.alt_pkey_index;
+	attr->en_sqd_async_notify = resp->attrs.en_sqd_async_notify;
+	attr->sq_draining = resp->attrs.sq_draining;
+	attr->max_rd_atomic = resp->attrs.max_rd_atomic;
+	attr->max_dest_rd_atomic = resp->attrs.max_dest_rd_atomic;
+	attr->min_rnr_timer = resp->attrs.min_rnr_timer;
+	attr->port_num = resp->attrs.port_num;
+	attr->timeout = resp->attrs.timeout;
+	attr->retry_cnt = resp->attrs.retry_cnt;
+	attr->rnr_retry = resp->attrs.rnr_retry;
+	attr->alt_port_num = resp->attrs.alt_port_num;
+	attr->alt_timeout = resp->attrs.alt_timeout;
+	pvrdma_qp_cap_to_ib(&attr->cap, &resp->attrs.cap);
+	pvrdma_ah_attr_to_ib(&attr->ah_attr, &resp->attrs.ah_attr);
+	pvrdma_ah_attr_to_ib(&attr->alt_ah_attr, &resp->attrs.alt_ah_attr);
+
+	qp->state = attr->qp_state;
+
+	ret = 0;
+
+out:
+	attr->cur_qp_state = attr->qp_state;
+
+	init_attr->event_handler = qp->ibqp.event_handler;
+	init_attr->qp_context = qp->ibqp.qp_context;
+	init_attr->send_cq = qp->ibqp.send_cq;
+	init_attr->recv_cq = qp->ibqp.recv_cq;
+	init_attr->srq = qp->ibqp.srq;
+	init_attr->xrcd = NULL;
+	init_attr->cap = attr->cap;
+	init_attr->sq_sig_type = 0;
+	init_attr->qp_type = qp->ibqp.qp_type;
+	init_attr->create_flags = 0;
+	init_attr->port_num = qp->port;
+
+	mutex_unlock(&qp->mutex);
+	return ret;
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
new file mode 100644
index 0000000..ed9022a
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_RING_H__
+#define __PVRDMA_RING_H__
+
+#include <linux/types.h>
+
+#define PVRDMA_INVALID_IDX	-1	/* Invalid index. */
+
+struct pvrdma_ring {
+	atomic_t prod_tail;	/* Producer tail. */
+	atomic_t cons_head;	/* Consumer head. */
+};
+
+struct pvrdma_ring_state {
+	struct pvrdma_ring tx;	/* Tx ring. */
+	struct pvrdma_ring rx;	/* Rx ring. */
+};
+
+static inline int pvrdma_idx_valid(__u32 idx, __u32 max_elems)
+{
+	/* Generates fewer instructions than a less-than. */
+	return (idx & ~((max_elems << 1) - 1)) == 0;
+}
+
+static inline __s32 pvrdma_idx(atomic_t *var, __u32 max_elems)
+{
+	const unsigned int idx = atomic_read(var);
+
+	if (pvrdma_idx_valid(idx, max_elems))
+		return idx & (max_elems - 1);
+	return PVRDMA_INVALID_IDX;
+}
+
+static inline void pvrdma_idx_ring_inc(atomic_t *var, __u32 max_elems)
+{
+	__u32 idx = atomic_read(var) + 1;	/* Increment. */
+
+	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
+	atomic_set(var, idx);
+}
+
+static inline __s32 pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
+					      __u32 max_elems, __u32 *out_tail)
+{
+	const __u32 tail = atomic_read(&r->prod_tail);
+	const __u32 head = atomic_read(&r->cons_head);
+
+	if (pvrdma_idx_valid(tail, max_elems) &&
+	    pvrdma_idx_valid(head, max_elems)) {
+		*out_tail = tail & (max_elems - 1);
+		return tail != (head ^ max_elems);
+	}
+	return PVRDMA_INVALID_IDX;
+}
+
+static inline __s32 pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
+					     __u32 max_elems, __u32 *out_head)
+{
+	const __u32 tail = atomic_read(&r->prod_tail);
+	const __u32 head = atomic_read(&r->cons_head);
+
+	if (pvrdma_idx_valid(tail, max_elems) &&
+	    pvrdma_idx_valid(head, max_elems)) {
+		*out_head = head & (max_elems - 1);
+		return tail != head;
+	}
+	return PVRDMA_INVALID_IDX;
+}
+
+static inline bool pvrdma_idx_ring_is_valid_idx(const struct pvrdma_ring *r,
+						__u32 max_elems, __u32 *idx)
+{
+	const __u32 tail = atomic_read(&r->prod_tail);
+	const __u32 head = atomic_read(&r->cons_head);
+
+	if (pvrdma_idx_valid(tail, max_elems) &&
+	    pvrdma_idx_valid(head, max_elems) &&
+	    pvrdma_idx_valid(*idx, max_elems)) {
+		if (tail > head && (*idx < tail && *idx >= head))
+			return true;
+		else if (head > tail && (*idx >= head || *idx < tail))
+			return true;
+	}
+	return false;
+}
+
+#endif /* __PVRDMA_RING_H__ */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
new file mode 100644
index 0000000..a7aef93d
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -0,0 +1,577 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <asm/page.h>
+#include <linux/inet.h>
+#include <linux/io.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/pvrdma-abi.h>
+
+#include "pvrdma.h"
+
+/**
+ * pvrdma_query_device - query device
+ * @ibdev: the device to query
+ * @props: the device properties
+ * @uhw: user data
+ *
+ * @return: 0 on success, otherwise negative errno
+ */
+int pvrdma_query_device(struct ib_device *ibdev,
+			struct ib_device_attr *props,
+			struct ib_udata *uhw)
+{
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+
+	if (uhw->inlen || uhw->outlen)
+		return -EINVAL;
+
+	memset(props, 0, sizeof(*props));
+
+	props->fw_ver = dev->dsr->caps.fw_ver;
+	props->sys_image_guid = dev->dsr->caps.sys_image_guid;
+	props->max_mr_size = dev->dsr->caps.max_mr_size;
+	props->page_size_cap = dev->dsr->caps.page_size_cap;
+	props->vendor_id = dev->dsr->caps.vendor_id;
+	props->vendor_part_id = dev->pdev->device;
+	props->hw_ver = dev->dsr->caps.hw_ver;
+	props->max_qp = dev->dsr->caps.max_qp;
+	props->max_qp_wr = dev->dsr->caps.max_qp_wr;
+	props->device_cap_flags = dev->dsr->caps.device_cap_flags;
+	props->max_sge = dev->dsr->caps.max_sge;
+	props->max_cq = dev->dsr->caps.max_cq;
+	props->max_cqe = dev->dsr->caps.max_cqe;
+	props->max_mr = dev->dsr->caps.max_mr;
+	props->max_pd = dev->dsr->caps.max_pd;
+	props->max_qp_rd_atom = dev->dsr->caps.max_qp_rd_atom;
+	props->max_qp_init_rd_atom = dev->dsr->caps.max_qp_init_rd_atom;
+	props->atomic_cap =
+		dev->dsr->caps.atomic_ops &
+		(PVRDMA_ATOMIC_OP_COMP_SWAP | PVRDMA_ATOMIC_OP_FETCH_ADD) ?
+		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
+	props->masked_atomic_cap = props->atomic_cap;
+	props->max_ah = dev->dsr->caps.max_ah;
+	props->max_pkeys = dev->dsr->caps.max_pkeys;
+	props->local_ca_ack_delay = dev->dsr->caps.local_ca_ack_delay;
+	if ((dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_LOCAL_INV) &&
+	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_REMOTE_INV) &&
+	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_FAST_REG_WR)) {
+		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	}
+
+	return 0;
+}
+
+/**
+ * pvrdma_query_port - query device port attributes
+ * @ibdev: the device to query
+ * @port: the port number
+ * @props: the device properties
+ *
+ * @return: 0 on success, otherwise negative errno
+ */
+int pvrdma_query_port(struct ib_device *ibdev, u8 port,
+		      struct ib_port_attr *props)
+{
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_query_port *cmd = &req.query_port;
+	struct pvrdma_cmd_query_port_resp *resp = &rsp.query_port_resp;
+	int err;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_QUERY_PORT;
+	cmd->port_num = port;
+
+	err = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_QUERY_PORT_RESP);
+	if (err < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "could not query port, error: %d\n", err);
+		return err;
+	}
+
+	memset(props, 0, sizeof(*props));
+
+	props->state = pvrdma_port_state_to_ib(resp->attrs.state);
+	props->max_mtu = pvrdma_mtu_to_ib(resp->attrs.max_mtu);
+	props->active_mtu = pvrdma_mtu_to_ib(resp->attrs.active_mtu);
+	props->gid_tbl_len = resp->attrs.gid_tbl_len;
+	props->port_cap_flags =
+		pvrdma_port_cap_flags_to_ib(resp->attrs.port_cap_flags);
+	props->max_msg_sz = resp->attrs.max_msg_sz;
+	props->bad_pkey_cntr = resp->attrs.bad_pkey_cntr;
+	props->qkey_viol_cntr = resp->attrs.qkey_viol_cntr;
+	props->pkey_tbl_len = resp->attrs.pkey_tbl_len;
+	props->lid = resp->attrs.lid;
+	props->sm_lid = resp->attrs.sm_lid;
+	props->lmc = resp->attrs.lmc;
+	props->max_vl_num = resp->attrs.max_vl_num;
+	props->sm_sl = resp->attrs.sm_sl;
+	props->subnet_timeout = resp->attrs.subnet_timeout;
+	props->init_type_reply = resp->attrs.init_type_reply;
+	props->active_width = pvrdma_port_width_to_ib(resp->attrs.active_width);
+	props->active_speed = pvrdma_port_speed_to_ib(resp->attrs.active_speed);
+	props->phys_state = resp->attrs.phys_state;
+
+	return 0;
+}
+
+/**
+ * pvrdma_query_gid - query device gid
+ * @ibdev: the device to query
+ * @port: the port number
+ * @index: the index
+ * @gid: the device gid value
+ *
+ * @return: 0 on success, otherwise negative errno
+ */
+int pvrdma_query_gid(struct ib_device *ibdev, u8 port, int index,
+		     union ib_gid *gid)
+{
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+
+	if (index >= dev->dsr->caps.gid_tbl_len)
+		return -EINVAL;
+
+	memcpy(gid, &dev->sgid_tbl[index], sizeof(union ib_gid));
+
+	return 0;
+}
+
+/**
+ * pvrdma_query_pkey - query device port's P_Key table
+ * @ibdev: the device to query
+ * @port: the port number
+ * @index: the index
+ * @pkey: the device P_Key value
+ *
+ * @return: 0 on success, otherwise negative errno
+ */
+int pvrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+		      u16 *pkey)
+{
+	int err = 0;
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_query_pkey *cmd = &req.query_pkey;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_QUERY_PKEY;
+	cmd->port_num = port;
+	cmd->index = index;
+
+	err = pvrdma_cmd_post(to_vdev(ibdev), &req, &rsp,
+			      PVRDMA_CMD_QUERY_PKEY_RESP);
+	if (err < 0) {
+		dev_warn(&to_vdev(ibdev)->pdev->dev,
+			 "could not query pkey, error: %d\n", err);
+		return err;
+	}
+
+	*pkey = rsp.query_pkey_resp.pkey;
+
+	return 0;
+}
+
+enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
+					    u8 port)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+int pvrdma_modify_device(struct ib_device *ibdev, int mask,
+			 struct ib_device_modify *props)
+{
+	unsigned long flags;
+
+	if (mask & ~(IB_DEVICE_MODIFY_SYS_IMAGE_GUID |
+		     IB_DEVICE_MODIFY_NODE_DESC)) {
+		dev_warn(&to_vdev(ibdev)->pdev->dev,
+			 "unsupported device modify mask %#x\n", mask);
+		return -EOPNOTSUPP;
+	}
+
+	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
+		spin_lock_irqsave(&to_vdev(ibdev)->desc_lock, flags);
+		memcpy(ibdev->node_desc, props->node_desc, 64);
+		spin_unlock_irqrestore(&to_vdev(ibdev)->desc_lock, flags);
+	}
+
+	if (mask & IB_DEVICE_MODIFY_SYS_IMAGE_GUID) {
+		mutex_lock(&to_vdev(ibdev)->port_mutex);
+		to_vdev(ibdev)->sys_image_guid =
+			cpu_to_be64(props->sys_image_guid);
+		mutex_unlock(&to_vdev(ibdev)->port_mutex);
+	}
+
+	return 0;
+}
+
+/**
+ * pvrdma_modify_port - modify device port attributes
+ * @ibdev: the device to modify
+ * @port: the port number
+ * @mask: attributes to modify
+ * @props: the device properties
+ *
+ * @return: 0 on success, otherwise negative errno
+ */
+int pvrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
+		       struct ib_port_modify *props)
+{
+	struct ib_port_attr attr;
+	struct pvrdma_dev *vdev = to_vdev(ibdev);
+	int ret;
+
+	if (mask & ~IB_PORT_SHUTDOWN) {
+		dev_warn(&vdev->pdev->dev,
+			 "unsupported port modify mask %#x\n", mask);
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&vdev->port_mutex);
+	ret = pvrdma_query_port(ibdev, port, &attr);
+	if (ret)
+		goto out;
+
+	vdev->port_cap_mask |= props->set_port_cap_mask;
+	vdev->port_cap_mask &= ~props->clr_port_cap_mask;
+
+	if (mask & IB_PORT_SHUTDOWN)
+		vdev->ib_active = false;
+
+out:
+	mutex_unlock(&vdev->port_mutex);
+	return ret;
+}
+
+/**
+ * pvrdma_alloc_ucontext - allocate ucontext
+ * @ibdev: the IB device
+ * @udata: user data
+ *
+ * @return: the ib_ucontext pointer on success, otherwise errno.
+ */
+struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
+					  struct ib_udata *udata)
+{
+	struct pvrdma_dev *vdev = to_vdev(ibdev);
+	struct pvrdma_ucontext *context;
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_uc *cmd = &req.create_uc;
+	struct pvrdma_cmd_create_uc_resp *resp = &rsp.create_uc_resp;
+	struct pvrdma_alloc_ucontext_resp uresp;
+	int ret;
+	void *ptr;
+
+	if (!vdev->ib_active)
+		return ERR_PTR(-EAGAIN);
+
+	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
+
+	context->dev = vdev;
+	ret = pvrdma_uar_alloc(vdev, &context->uar);
+	if (ret) {
+		kfree(context);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* get ctx_handle from host */
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->pfn = context->uar.pfn;
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_UC;
+	ret = pvrdma_cmd_post(vdev, &req, &rsp, PVRDMA_CMD_CREATE_UC_RESP);
+	if (ret < 0) {
+		dev_warn(&vdev->pdev->dev,
+			 "could not create ucontext, error: %d\n", ret);
+		ptr = ERR_PTR(ret);
+		goto err;
+	}
+
+	context->ctx_handle = resp->ctx_handle;
+
+	/* copy back to user */
+	uresp.qp_tab_size = vdev->dsr->caps.max_qp;
+	ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	if (ret) {
+		pvrdma_uar_free(vdev, &context->uar);
+		context->ibucontext.device = ibdev;
+		pvrdma_dealloc_ucontext(&context->ibucontext);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return &context->ibucontext;
+
+err:
+	pvrdma_uar_free(vdev, &context->uar);
+	kfree(context);
+	return ptr;
+}
+
+/**
+ * pvrdma_dealloc_ucontext - deallocate ucontext
+ * @ibcontext: the ucontext
+ *
+ * @return: 0 on success, otherwise errno.
+ */
+int pvrdma_dealloc_ucontext(struct ib_ucontext *ibcontext)
+{
+	struct pvrdma_ucontext *context = to_vucontext(ibcontext);
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_destroy_uc *cmd = &req.destroy_uc;
+	int ret;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_UC;
+	cmd->ctx_handle = context->ctx_handle;
+
+	ret = pvrdma_cmd_post(context->dev, &req, NULL, 0);
+	if (ret < 0)
+		dev_warn(&context->dev->pdev->dev,
+			 "destroy ucontext failed, error: %d\n", ret);
+
+	/* Free the UAR even if the device command failed */
+	pvrdma_uar_free(to_vdev(ibcontext->device), &context->uar);
+	kfree(context);
+
+	return ret;
+}
+
+/**
+ * pvrdma_mmap - create mmap region
+ * @ibcontext: the user context
+ * @vma: the VMA
+ *
+ * @return: 0 on success, otherwise errno.
+ */
+int pvrdma_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
+{
+	struct pvrdma_ucontext *context = to_vucontext(ibcontext);
+	unsigned long start = vma->vm_start;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	dev_dbg(&context->dev->pdev->dev, "create mmap region\n");
+
+	if ((size != PAGE_SIZE) || (offset & ~PAGE_MASK)) {
+		dev_warn(&context->dev->pdev->dev,
+			 "invalid params for mmap region\n");
+		return -EINVAL;
+	}
+
+	/* Map UAR to kernel space, VM_LOCKED? */
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	if (io_remap_pfn_range(vma, start, context->uar.pfn, size,
+			       vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
+
+/**
+ * pvrdma_alloc_pd - allocate protection domain
+ * @ibdev: the IB device
+ * @context: user context
+ * @udata: user data
+ *
+ * @return: the ib_pd protection domain pointer on success, otherwise errno.
+ */
+struct ib_pd *pvrdma_alloc_pd(struct ib_device *ibdev,
+			      struct ib_ucontext *context,
+			      struct ib_udata *udata)
+{
+	struct pvrdma_pd *pd;
+	struct pvrdma_dev *dev = to_vdev(ibdev);
+	union pvrdma_cmd_req req;
+	union pvrdma_cmd_resp rsp;
+	struct pvrdma_cmd_create_pd *cmd = &req.create_pd;
+	struct pvrdma_cmd_create_pd_resp *resp = &rsp.create_pd_resp;
+	int ret;
+	void *ptr;
+
+	/* Check allowed max pds */
+	if (!atomic_add_unless(&dev->num_pds, 1, dev->dsr->caps.max_pd))
+		return ERR_PTR(-ENOMEM);
+
+	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		ptr = ERR_PTR(-ENOMEM);
+		goto err;
+	}
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_CREATE_PD;
+	cmd->ctx_handle = (context) ? to_vucontext(context)->ctx_handle : 0;
+	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_PD_RESP);
+	if (ret < 0) {
+		dev_warn(&dev->pdev->dev,
+			 "failed to allocate protection domain, error: %d\n",
+			 ret);
+		ptr = ERR_PTR(ret);
+		goto freepd;
+	}
+
+	pd->privileged = !context;
+	pd->pd_handle = resp->pd_handle;
+	pd->pdn = resp->pd_handle;
+
+	if (context) {
+		if (ib_copy_to_udata(udata, &pd->pdn, sizeof(__u32))) {
+			dev_warn(&dev->pdev->dev,
+				 "failed to copy back protection domain\n");
+			pvrdma_dealloc_pd(&pd->ibpd);
+			return ERR_PTR(-EFAULT);
+		}
+	}
+
+	/* u32 pd handle */
+	return &pd->ibpd;
+
+freepd:
+	kfree(pd);
+err:
+	atomic_dec(&dev->num_pds);
+	return ptr;
+}
+
+/**
+ * pvrdma_dealloc_pd - deallocate protection domain
+ * @pd: the protection domain to be released
+ *
+ * @return: 0 on success, otherwise errno.
+ */
+int pvrdma_dealloc_pd(struct ib_pd *pd)
+{
+	struct pvrdma_dev *dev = to_vdev(pd->device);
+	union pvrdma_cmd_req req;
+	struct pvrdma_cmd_destroy_pd *cmd = &req.destroy_pd;
+	int ret;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->hdr.cmd = PVRDMA_CMD_DESTROY_PD;
+	cmd->pd_handle = to_vpd(pd)->pd_handle;
+
+	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
+	if (ret)
+		dev_warn(&dev->pdev->dev,
+			 "could not dealloc protection domain, error: %d\n",
+			 ret);
+
+	kfree(to_vpd(pd));
+	atomic_dec(&dev->num_pds);
+
+	return 0;
+}
+
+/**
+ * pvrdma_create_ah - create an address handle
+ * @pd: the protection domain
+ * @ah_attr: the attributes of the AH
+ *
+ * @return: the ib_ah pointer on success, otherwise errno.
+ */
+struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+{
+	struct pvrdma_dev *dev = to_vdev(pd->device);
+	struct pvrdma_ah *ah;
+	enum rdma_link_layer ll;
+
+	if (!(ah_attr->ah_flags & IB_AH_GRH))
+		return ERR_PTR(-EINVAL);
+
+	ll = rdma_port_get_link_layer(pd->device, ah_attr->port_num);
+
+	if (ll != IB_LINK_LAYER_ETHERNET ||
+	    rdma_is_multicast_addr((struct in6_addr *)ah_attr->grh.dgid.raw))
+		return ERR_PTR(-EINVAL);
+
+	if (!atomic_add_unless(&dev->num_ahs, 1, dev->dsr->caps.max_ah))
+		return ERR_PTR(-ENOMEM);
+
+	ah = kzalloc(sizeof(*ah), GFP_KERNEL);
+	if (!ah) {
+		atomic_dec(&dev->num_ahs);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ah->av.port_pd = to_vpd(pd)->pd_handle | (ah_attr->port_num << 24);
+	ah->av.src_path_bits = ah_attr->src_path_bits;
+	ah->av.src_path_bits |= 0x80;
+	ah->av.gid_index = ah_attr->grh.sgid_index;
+	ah->av.hop_limit = ah_attr->grh.hop_limit;
+	ah->av.sl_tclass_flowlabel = (ah_attr->grh.traffic_class << 20) |
+				      ah_attr->grh.flow_label;
+	memcpy(ah->av.dgid, ah_attr->grh.dgid.raw, 16);
+	memcpy(ah->av.dmac, ah_attr->dmac, 6);
+
+	ah->ibah.device = pd->device;
+	ah->ibah.pd = pd;
+	ah->ibah.uobject = NULL;
+
+	return &ah->ibah;
+}
+
+/**
+ * pvrdma_destroy_ah - destroy an address handle
+ * @ah: the address handle to destroyed
+ *
+ * @return: 0 on success.
+ */
+int pvrdma_destroy_ah(struct ib_ah *ah)
+{
+	struct pvrdma_dev *dev = to_vdev(ah->device);
+
+	kfree(to_vah(ah));
+	atomic_dec(&dev->num_ahs);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
new file mode 100644
index 0000000..25ce9fd
--- /dev/null
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -0,0 +1,435 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_VERBS_H__
+#define __PVRDMA_VERBS_H__
+
+#include <linux/types.h>
+
+union pvrdma_gid {
+	u8	raw[16];
+	struct {
+		__be64	subnet_prefix;
+		__be64	interface_id;
+	} global;
+};
+
+enum pvrdma_link_layer {
+	PVRDMA_LINK_LAYER_UNSPECIFIED,
+	PVRDMA_LINK_LAYER_INFINIBAND,
+	PVRDMA_LINK_LAYER_ETHERNET,
+};
+
+enum pvrdma_mtu {
+	PVRDMA_MTU_256  = 1,
+	PVRDMA_MTU_512  = 2,
+	PVRDMA_MTU_1024 = 3,
+	PVRDMA_MTU_2048 = 4,
+	PVRDMA_MTU_4096 = 5,
+};
+
+static inline int pvrdma_mtu_enum_to_int(enum pvrdma_mtu mtu)
+{
+	switch (mtu) {
+	case PVRDMA_MTU_256:	return  256;
+	case PVRDMA_MTU_512:	return  512;
+	case PVRDMA_MTU_1024:	return 1024;
+	case PVRDMA_MTU_2048:	return 2048;
+	case PVRDMA_MTU_4096:	return 4096;
+	default:		return   -1;
+	}
+}
+
+static inline enum pvrdma_mtu pvrdma_mtu_int_to_enum(int mtu)
+{
+	switch (mtu) {
+	case 256:	return PVRDMA_MTU_256;
+	case 512:	return PVRDMA_MTU_512;
+	case 1024:	return PVRDMA_MTU_1024;
+	case 2048:	return PVRDMA_MTU_2048;
+	case 4096:
+	default:	return PVRDMA_MTU_4096;
+	}
+}
+
+enum pvrdma_port_state {
+	PVRDMA_PORT_NOP			= 0,
+	PVRDMA_PORT_DOWN		= 1,
+	PVRDMA_PORT_INIT		= 2,
+	PVRDMA_PORT_ARMED		= 3,
+	PVRDMA_PORT_ACTIVE		= 4,
+	PVRDMA_PORT_ACTIVE_DEFER	= 5,
+};
+
+enum pvrdma_port_cap_flags {
+	PVRDMA_PORT_SM				= 1 <<  1,
+	PVRDMA_PORT_NOTICE_SUP			= 1 <<  2,
+	PVRDMA_PORT_TRAP_SUP			= 1 <<  3,
+	PVRDMA_PORT_OPT_IPD_SUP			= 1 <<  4,
+	PVRDMA_PORT_AUTO_MIGR_SUP		= 1 <<  5,
+	PVRDMA_PORT_SL_MAP_SUP			= 1 <<  6,
+	PVRDMA_PORT_MKEY_NVRAM			= 1 <<  7,
+	PVRDMA_PORT_PKEY_NVRAM			= 1 <<  8,
+	PVRDMA_PORT_LED_INFO_SUP		= 1 <<  9,
+	PVRDMA_PORT_SM_DISABLED			= 1 << 10,
+	PVRDMA_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
+	PVRDMA_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
+	PVRDMA_PORT_EXTENDED_SPEEDS_SUP		= 1 << 14,
+	PVRDMA_PORT_CM_SUP			= 1 << 16,
+	PVRDMA_PORT_SNMP_TUNNEL_SUP		= 1 << 17,
+	PVRDMA_PORT_REINIT_SUP			= 1 << 18,
+	PVRDMA_PORT_DEVICE_MGMT_SUP		= 1 << 19,
+	PVRDMA_PORT_VENDOR_CLASS_SUP		= 1 << 20,
+	PVRDMA_PORT_DR_NOTICE_SUP		= 1 << 21,
+	PVRDMA_PORT_CAP_MASK_NOTICE_SUP		= 1 << 22,
+	PVRDMA_PORT_BOOT_MGMT_SUP		= 1 << 23,
+	PVRDMA_PORT_LINK_LATENCY_SUP		= 1 << 24,
+	PVRDMA_PORT_CLIENT_REG_SUP		= 1 << 25,
+	PVRDMA_PORT_IP_BASED_GIDS		= 1 << 26,
+	PVRDMA_PORT_CAP_FLAGS_MAX		= PVRDMA_PORT_IP_BASED_GIDS,
+};
+
+enum pvrdma_port_width {
+	PVRDMA_WIDTH_1X		= 1,
+	PVRDMA_WIDTH_4X		= 2,
+	PVRDMA_WIDTH_8X		= 4,
+	PVRDMA_WIDTH_12X	= 8,
+};
+
+static inline int pvrdma_width_enum_to_int(enum pvrdma_port_width width)
+{
+	switch (width) {
+	case PVRDMA_WIDTH_1X:	return  1;
+	case PVRDMA_WIDTH_4X:	return  4;
+	case PVRDMA_WIDTH_8X:	return  8;
+	case PVRDMA_WIDTH_12X:	return 12;
+	default:		return -1;
+	}
+}
+
+enum pvrdma_port_speed {
+	PVRDMA_SPEED_SDR	= 1,
+	PVRDMA_SPEED_DDR	= 2,
+	PVRDMA_SPEED_QDR	= 4,
+	PVRDMA_SPEED_FDR10	= 8,
+	PVRDMA_SPEED_FDR	= 16,
+	PVRDMA_SPEED_EDR	= 32,
+};
+
+struct pvrdma_port_attr {
+	enum pvrdma_port_state	state;
+	enum pvrdma_mtu		max_mtu;
+	enum pvrdma_mtu		active_mtu;
+	u32			gid_tbl_len;
+	u32			port_cap_flags;
+	u32			max_msg_sz;
+	u32			bad_pkey_cntr;
+	u32			qkey_viol_cntr;
+	u16			pkey_tbl_len;
+	u16			lid;
+	u16			sm_lid;
+	u8			lmc;
+	u8			max_vl_num;
+	u8			sm_sl;
+	u8			subnet_timeout;
+	u8			init_type_reply;
+	u8			active_width;
+	u8			active_speed;
+	u8			phys_state;
+	u8			reserved[2];
+};
+
+struct pvrdma_global_route {
+	union pvrdma_gid	dgid;
+	u32			flow_label;
+	u8			sgid_index;
+	u8			hop_limit;
+	u8			traffic_class;
+	u8			reserved;
+};
+
+struct pvrdma_grh {
+	__be32			version_tclass_flow;
+	__be16			paylen;
+	u8			next_hdr;
+	u8			hop_limit;
+	union pvrdma_gid	sgid;
+	union pvrdma_gid	dgid;
+};
+
+enum pvrdma_ah_flags {
+	PVRDMA_AH_GRH = 1,
+};
+
+enum pvrdma_rate {
+	PVRDMA_RATE_PORT_CURRENT	= 0,
+	PVRDMA_RATE_2_5_GBPS		= 2,
+	PVRDMA_RATE_5_GBPS		= 5,
+	PVRDMA_RATE_10_GBPS		= 3,
+	PVRDMA_RATE_20_GBPS		= 6,
+	PVRDMA_RATE_30_GBPS		= 4,
+	PVRDMA_RATE_40_GBPS		= 7,
+	PVRDMA_RATE_60_GBPS		= 8,
+	PVRDMA_RATE_80_GBPS		= 9,
+	PVRDMA_RATE_120_GBPS		= 10,
+	PVRDMA_RATE_14_GBPS		= 11,
+	PVRDMA_RATE_56_GBPS		= 12,
+	PVRDMA_RATE_112_GBPS		= 13,
+	PVRDMA_RATE_168_GBPS		= 14,
+	PVRDMA_RATE_25_GBPS		= 15,
+	PVRDMA_RATE_100_GBPS		= 16,
+	PVRDMA_RATE_200_GBPS		= 17,
+	PVRDMA_RATE_300_GBPS		= 18,
+};
+
+struct pvrdma_ah_attr {
+	struct pvrdma_global_route	grh;
+	u16				dlid;
+	u16				vlan_id;
+	u8				sl;
+	u8				src_path_bits;
+	u8				static_rate;
+	u8				ah_flags;
+	u8				port_num;
+	u8				dmac[6];
+	u8				reserved;
+};
+
+enum pvrdma_cq_notify_flags {
+	PVRDMA_CQ_SOLICITED		= 1 << 0,
+	PVRDMA_CQ_NEXT_COMP		= 1 << 1,
+	PVRDMA_CQ_SOLICITED_MASK	= PVRDMA_CQ_SOLICITED |
+					  PVRDMA_CQ_NEXT_COMP,
+	PVRDMA_CQ_REPORT_MISSED_EVENTS	= 1 << 2,
+};
+
+struct pvrdma_qp_cap {
+	u32	max_send_wr;
+	u32	max_recv_wr;
+	u32	max_send_sge;
+	u32	max_recv_sge;
+	u32	max_inline_data;
+	u32	reserved;
+};
+
+enum pvrdma_sig_type {
+	PVRDMA_SIGNAL_ALL_WR,
+	PVRDMA_SIGNAL_REQ_WR,
+};
+
+enum pvrdma_qp_type {
+	PVRDMA_QPT_SMI,
+	PVRDMA_QPT_GSI,
+	PVRDMA_QPT_RC,
+	PVRDMA_QPT_UC,
+	PVRDMA_QPT_UD,
+	PVRDMA_QPT_RAW_IPV6,
+	PVRDMA_QPT_RAW_ETHERTYPE,
+	PVRDMA_QPT_RAW_PACKET = 8,
+	PVRDMA_QPT_XRC_INI = 9,
+	PVRDMA_QPT_XRC_TGT,
+	PVRDMA_QPT_MAX,
+};
+
+enum pvrdma_qp_create_flags {
+	PVRDMA_QP_CREATE_IPOPVRDMA_UD_LSO		= 1 << 0,
+	PVRDMA_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+};
+
+enum pvrdma_qp_attr_mask {
+	PVRDMA_QP_STATE			= 1 << 0,
+	PVRDMA_QP_CUR_STATE		= 1 << 1,
+	PVRDMA_QP_EN_SQD_ASYNC_NOTIFY	= 1 << 2,
+	PVRDMA_QP_ACCESS_FLAGS		= 1 << 3,
+	PVRDMA_QP_PKEY_INDEX		= 1 << 4,
+	PVRDMA_QP_PORT			= 1 << 5,
+	PVRDMA_QP_QKEY			= 1 << 6,
+	PVRDMA_QP_AV			= 1 << 7,
+	PVRDMA_QP_PATH_MTU		= 1 << 8,
+	PVRDMA_QP_TIMEOUT		= 1 << 9,
+	PVRDMA_QP_RETRY_CNT		= 1 << 10,
+	PVRDMA_QP_RNR_RETRY		= 1 << 11,
+	PVRDMA_QP_RQ_PSN		= 1 << 12,
+	PVRDMA_QP_MAX_QP_RD_ATOMIC	= 1 << 13,
+	PVRDMA_QP_ALT_PATH		= 1 << 14,
+	PVRDMA_QP_MIN_RNR_TIMER		= 1 << 15,
+	PVRDMA_QP_SQ_PSN		= 1 << 16,
+	PVRDMA_QP_MAX_DEST_RD_ATOMIC	= 1 << 17,
+	PVRDMA_QP_PATH_MIG_STATE	= 1 << 18,
+	PVRDMA_QP_CAP			= 1 << 19,
+	PVRDMA_QP_DEST_QPN		= 1 << 20,
+	PVRDMA_QP_ATTR_MASK_MAX		= PVRDMA_QP_DEST_QPN,
+};
+
+enum pvrdma_qp_state {
+	PVRDMA_QPS_RESET,
+	PVRDMA_QPS_INIT,
+	PVRDMA_QPS_RTR,
+	PVRDMA_QPS_RTS,
+	PVRDMA_QPS_SQD,
+	PVRDMA_QPS_SQE,
+	PVRDMA_QPS_ERR,
+};
+
+enum pvrdma_mig_state {
+	PVRDMA_MIG_MIGRATED,
+	PVRDMA_MIG_REARM,
+	PVRDMA_MIG_ARMED,
+};
+
+enum pvrdma_mw_type {
+	PVRDMA_MW_TYPE_1 = 1,
+	PVRDMA_MW_TYPE_2 = 2,
+};
+
+struct pvrdma_qp_attr {
+	enum pvrdma_qp_state	qp_state;
+	enum pvrdma_qp_state	cur_qp_state;
+	enum pvrdma_mtu		path_mtu;
+	enum pvrdma_mig_state	path_mig_state;
+	u32			qkey;
+	u32			rq_psn;
+	u32			sq_psn;
+	u32			dest_qp_num;
+	u32			qp_access_flags;
+	u16			pkey_index;
+	u16			alt_pkey_index;
+	u8			en_sqd_async_notify;
+	u8			sq_draining;
+	u8			max_rd_atomic;
+	u8			max_dest_rd_atomic;
+	u8			min_rnr_timer;
+	u8			port_num;
+	u8			timeout;
+	u8			retry_cnt;
+	u8			rnr_retry;
+	u8			alt_port_num;
+	u8			alt_timeout;
+	u8			reserved[5];
+	struct pvrdma_qp_cap	cap;
+	struct pvrdma_ah_attr	ah_attr;
+	struct pvrdma_ah_attr	alt_ah_attr;
+};
+
+enum pvrdma_send_flags {
+	PVRDMA_SEND_FENCE	= 1 << 0,
+	PVRDMA_SEND_SIGNALED	= 1 << 1,
+	PVRDMA_SEND_SOLICITED	= 1 << 2,
+	PVRDMA_SEND_INLINE	= 1 << 3,
+	PVRDMA_SEND_IP_CSUM	= 1 << 4,
+	PVRDMA_SEND_FLAGS_MAX	= PVRDMA_SEND_IP_CSUM,
+};
+
+enum pvrdma_access_flags {
+	PVRDMA_ACCESS_LOCAL_WRITE	= 1 << 0,
+	PVRDMA_ACCESS_REMOTE_WRITE	= 1 << 1,
+	PVRDMA_ACCESS_REMOTE_READ	= 1 << 2,
+	PVRDMA_ACCESS_REMOTE_ATOMIC	= 1 << 3,
+	PVRDMA_ACCESS_MW_BIND		= 1 << 4,
+	PVRDMA_ZERO_BASED		= 1 << 5,
+	PVRDMA_ACCESS_ON_DEMAND		= 1 << 6,
+	PVRDMA_ACCESS_FLAGS_MAX		= PVRDMA_ACCESS_ON_DEMAND,
+};
+
+int pvrdma_query_device(struct ib_device *ibdev,
+			struct ib_device_attr *props,
+			struct ib_udata *udata);
+int pvrdma_query_port(struct ib_device *ibdev, u8 port,
+		      struct ib_port_attr *props);
+int pvrdma_query_gid(struct ib_device *ibdev, u8 port,
+		     int index, union ib_gid *gid);
+int pvrdma_query_pkey(struct ib_device *ibdev, u8 port,
+		      u16 index, u16 *pkey);
+enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
+					    u8 port);
+int pvrdma_modify_device(struct ib_device *ibdev, int mask,
+			 struct ib_device_modify *props);
+int pvrdma_modify_port(struct ib_device *ibdev, u8 port,
+		       int mask, struct ib_port_modify *props);
+int pvrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
+struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
+					  struct ib_udata *udata);
+int pvrdma_dealloc_ucontext(struct ib_ucontext *context);
+struct ib_pd *pvrdma_alloc_pd(struct ib_device *ibdev,
+			      struct ib_ucontext *context,
+			      struct ib_udata *udata);
+int pvrdma_dealloc_pd(struct ib_pd *ibpd);
+struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc);
+struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				 u64 virt_addr, int access_flags,
+				 struct ib_udata *udata);
+int pvrdma_dereg_mr(struct ib_mr *mr);
+struct ib_mr *pvrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
+			      u32 max_num_sg);
+int pvrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		     int sg_nents, unsigned int *sg_offset);
+int pvrdma_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
+int pvrdma_resize_cq(struct ib_cq *ibcq, int entries,
+		     struct ib_udata *udata);
+struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
+			       const struct ib_cq_init_attr *attr,
+			       struct ib_ucontext *context,
+			       struct ib_udata *udata);
+int pvrdma_resize_cq(struct ib_cq *ibcq, int entries,
+		     struct ib_udata *udata);
+int pvrdma_destroy_cq(struct ib_cq *cq);
+int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+int pvrdma_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
+struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+int pvrdma_destroy_ah(struct ib_ah *ah);
+struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
+			       struct ib_qp_init_attr *init_attr,
+			       struct ib_udata *udata);
+int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		     int attr_mask, struct ib_udata *udata);
+int pvrdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
+		    int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
+int pvrdma_destroy_qp(struct ib_qp *qp);
+int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		     struct ib_send_wr **bad_wr);
+int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		     struct ib_recv_wr **bad_wr);
+
+#endif /* __PVRDMA_VERBS_H__ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
