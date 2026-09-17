Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CDF4F96BF;
	Thu, 17 Sep 2026 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667188; cv=none; b=BcxYCLkiRoB5Ewady+WGioEaXyDLH+TfSvAd9BeT7MA39YFQ26DZqdFqm7iF41ZNAG13Ie+Cnp3mhEYvPI9UPRGyL00VsJT85toHfU6VqQQnhal43gQFsX8JTuHIUobPWWz+ehbpVErh8woLWyqSFKbUiUXM9CqPTqcA3/OF2Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667188; c=relaxed/simple;
	bh=WsOGNskEmwAtLsd6PYQhCJGUAiQfLENkoGNoncrtNk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUfbLXZB34aPkHNuxoeUl/00GZmNKRLONRiDf1oo1rgzyIe/4DPKt3qCXS8io5rij6mNZjzm5ejyuPU3uJEuLw6QTea+p5AYwi1cFWZTnV82/+zNO26I+6C2orQPqUGi0r9uq1tIc0iTNDVcBuF/gxFfHUMdnOPXGlm8xZrQe0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ9Mwin5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ9Mwin5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F481F000FF;
	Thu, 17 Sep 2026 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667186;
	bh=dspblTNvub5rle9BmwfEbsUa9e/NklHbI3e8a3hXj8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ9Mwin5jhwkvMTYuzg1O35xZgKN0Iw23+rBj8uYjPEWKX+n+MVgTZqv0SvoFtMcx
	 y5lFaS/JRde/aJaHZ4itB15DHBKYcygU83F/mBNbi9aoz+CWs1lGSqGG0sceSUdryh
	 Nbp9tce9L9Rhkk5y/QSXTjWiZhonprT43u4oAHuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <gospo@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1234/1250] fwctl/bnxt_en: Move common definitions to include/linux/bnxt/
Date: Thu, 17 Sep 2026 16:17:09 +0100
Message-ID: <20260917151625.739227659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 7be18a1fa00eab5283b35c13e26c6b76fcaab9ce ]

We have common definitions that are now going to be used
by more than one component outside of bnxt (bnxt_re and
fwctl)

Move bnxt_ulp.h to include/linux/bnxt/ as ulp.h.

Link: https://patch.msgid.link/r/20260314151605.932749-2-pavan.chebbi@broadcom.com
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 961e2a17c5e3 ("bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/debugfs.c                         | 2 +-
 drivers/infiniband/hw/bnxt_re/main.c                            | 2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                        | 2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h                       | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                       | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c               | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c               | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                 | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c                   | 2 +-
 .../broadcom/bnxt/bnxt_ulp.h => include/linux/bnxt/ulp.h        | 0
 drivers/infiniband/hw/bnxt_re/debugfs.c           |    2 
 drivers/infiniband/hw/bnxt_re/main.c              |    2 
 drivers/infiniband/hw/bnxt_re/qplib_fp.c          |    2 
 drivers/infiniband/hw/bnxt_re/qplib_res.h         |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h     |  129 ----------------------
 include/linux/bnxt/ulp.h                          |  129 ++++++++++++++++++++++
 11 files changed, 138 insertions(+), 138 deletions(-)
 rename drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h => include/linux/bnxt/ulp.h (100%)

--- a/drivers/infiniband/hw/bnxt_re/debugfs.c
+++ b/drivers/infiniband/hw/bnxt_re/debugfs.c
@@ -10,8 +10,8 @@
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <rdma/ib_addr.h>
+#include <linux/bnxt/ulp.h>
 
-#include "bnxt_ulp.h"
 #include "roce_hsi.h"
 #include "qplib_res.h"
 #include "qplib_sp.h"
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -55,8 +55,8 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_addr.h>
 #include <linux/hashtable.h>
+#include <linux/bnxt/ulp.h>
 
-#include "bnxt_ulp.h"
 #include "roce_hsi.h"
 #include "qplib_res.h"
 #include "qplib_sp.h"
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -46,6 +46,7 @@
 #include <linux/delay.h>
 #include <linux/prefetch.h>
 #include <linux/if_ether.h>
+#include <linux/bnxt/ulp.h>
 #include <rdma/ib_mad.h>
 
 #include "roce_hsi.h"
@@ -55,7 +56,6 @@
 #include "qplib_sp.h"
 #include "qplib_fp.h"
 #include <rdma/ib_addr.h>
-#include "bnxt_ulp.h"
 #include "bnxt_re.h"
 #include "ib_verbs.h"
 
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -39,7 +39,7 @@
 #ifndef __BNXT_QPLIB_RES_H__
 #define __BNXT_QPLIB_RES_H__
 
-#include "bnxt_ulp.h"
+#include <linux/bnxt/ulp.h>
 
 extern const struct bnxt_qplib_gid bnxt_qplib_gid_zero;
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -59,10 +59,10 @@
 #include <net/netdev_rx_queue.h>
 #include <linux/pci-tph.h>
 #include <linux/bnxt/hsi.h>
+#include <linux/bnxt/ulp.h>
 
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
-#include "bnxt_ulp.h"
 #include "bnxt_sriov.h"
 #include "bnxt_ethtool.h"
 #include "bnxt_dcb.h"
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -13,12 +13,12 @@
 #include <net/devlink.h>
 #include <net/netdev_lock.h>
 #include <linux/bnxt/hsi.h>
+#include <linux/bnxt/ulp.h>
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
 #include "bnxt_vfr.h"
 #include "bnxt_devlink.h"
 #include "bnxt_ethtool.h"
-#include "bnxt_ulp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_coredump.h"
 #include "bnxt_nvm_defs.h"
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -27,9 +27,9 @@
 #include <net/netdev_queues.h>
 #include <net/netlink.h>
 #include <linux/bnxt/hsi.h>
+#include <linux/bnxt/ulp.h>
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
-#include "bnxt_ulp.h"
 #include "bnxt_xdp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_ethtool.h"
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -17,9 +17,9 @@
 #include <linux/etherdevice.h>
 #include <net/dcbnl.h>
 #include <linux/bnxt/hsi.h>
+#include <linux/bnxt/ulp.h>
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
-#include "bnxt_ulp.h"
 #include "bnxt_sriov.h"
 #include "bnxt_vfr.h"
 #include "bnxt_ethtool.h"
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -22,10 +22,10 @@
 #include <linux/auxiliary_bus.h>
 #include <net/netdev_lock.h>
 #include <linux/bnxt/hsi.h>
+#include <linux/bnxt/ulp.h>
 
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
-#include "bnxt_ulp.h"
 
 static DEFINE_IDA(bnxt_aux_dev_ids);
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ /dev/null
@@ -1,129 +0,0 @@
-/* Broadcom NetXtreme-C/E network driver.
- *
- * Copyright (c) 2016-2018 Broadcom Limited
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation.
- */
-
-#ifndef BNXT_ULP_H
-#define BNXT_ULP_H
-
-#define BNXT_MIN_ROCE_CP_RINGS	2
-#define BNXT_MIN_ROCE_STAT_CTXS	1
-
-#define BNXT_MAX_ROCE_MSIX_VF		2
-#define BNXT_MAX_ROCE_MSIX_NPAR_PF	5
-#define BNXT_MAX_ROCE_MSIX		64
-
-struct hwrm_async_event_cmpl;
-struct bnxt;
-
-struct bnxt_msix_entry {
-	u32	vector;
-	u32	ring_idx;
-	u32	db_offset;
-};
-
-struct bnxt_ulp_ops {
-	/* async_notifier() cannot sleep (in BH context) */
-	void (*ulp_async_notifier)(void *, struct hwrm_async_event_cmpl *);
-	void (*ulp_irq_stop)(void *, bool);
-	void (*ulp_irq_restart)(void *, struct bnxt_msix_entry *);
-};
-
-struct bnxt_fw_msg {
-	void	*msg;
-	int	msg_len;
-	void	*resp;
-	int	resp_max_len;
-	int	timeout;
-};
-
-struct bnxt_ulp {
-	void		*handle;
-	struct bnxt_ulp_ops __rcu *ulp_ops;
-	unsigned long	*async_events_bmap;
-	u16		max_async_event_id;
-	u16		msix_requested;
-};
-
-struct bnxt_en_dev {
-	struct net_device *net;
-	struct pci_dev *pdev;
-	struct bnxt_msix_entry			msix_entries[BNXT_MAX_ROCE_MSIX];
-	u32 flags;
-	#define BNXT_EN_FLAG_ROCEV1_CAP		0x1
-	#define BNXT_EN_FLAG_ROCEV2_CAP		0x2
-	#define BNXT_EN_FLAG_ROCE_CAP		(BNXT_EN_FLAG_ROCEV1_CAP | \
-						 BNXT_EN_FLAG_ROCEV2_CAP)
-	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
-	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
-	#define BNXT_EN_FLAG_VF			0x10
-#define BNXT_EN_VF(edev)	((edev)->flags & BNXT_EN_FLAG_VF)
-	#define BNXT_EN_FLAG_ROCE_VF_RES_MGMT	0x20
-	#define BNXT_EN_FLAG_SW_RES_LMT		0x40
-#define BNXT_EN_SW_RES_LMT(edev) ((edev)->flags & BNXT_EN_FLAG_SW_RES_LMT)
-
-	struct bnxt_ulp			*ulp_tbl;
-	int				l2_db_size;	/* Doorbell BAR size in
-							 * bytes mapped by L2
-							 * driver.
-							 */
-	int				l2_db_size_nc;	/* Doorbell BAR size in
-							 * bytes mapped as non-
-							 * cacheable.
-							 */
-	int				l2_db_offset;	/* Doorbell offset in
-							 * bytes within
-							 * l2_db_size_nc.
-							 */
-	u16				chip_num;
-	u16				hw_ring_stats_size;
-	u16				pf_port_id;
-	unsigned long			en_state;	/* Could be checked in
-							 * RoCE driver suspend
-							 * mode only. Will be
-							 * updated in resume.
-							 */
-	void __iomem                    *bar0;
-
-	u16				ulp_num_msix_vec;
-	u16				ulp_num_ctxs;
-
-					/* serialize ulp operations */
-	struct mutex			en_dev_lock;
-};
-
-static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
-{
-	if (edev && rcu_access_pointer(edev->ulp_tbl->ulp_ops))
-		return true;
-	return false;
-}
-
-int bnxt_get_ulp_msix_num(struct bnxt *bp);
-int bnxt_get_ulp_msix_num_in_use(struct bnxt *bp);
-void bnxt_set_ulp_msix_num(struct bnxt *bp, int num);
-int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
-void bnxt_set_ulp_stat_ctxs(struct bnxt *bp, int num_ctxs);
-int bnxt_get_ulp_stat_ctxs_in_use(struct bnxt *bp);
-void bnxt_set_dflt_ulp_stat_ctxs(struct bnxt *bp);
-void bnxt_ulp_stop(struct bnxt *bp);
-void bnxt_ulp_start(struct bnxt *bp, int err);
-void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
-void bnxt_ulp_irq_stop(struct bnxt *bp);
-void bnxt_ulp_irq_restart(struct bnxt *bp, int err);
-void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
-void bnxt_rdma_aux_device_uninit(struct bnxt *bp);
-void bnxt_rdma_aux_device_del(struct bnxt *bp);
-void bnxt_rdma_aux_device_add(struct bnxt *bp);
-void bnxt_rdma_aux_device_init(struct bnxt *bp);
-int bnxt_register_dev(struct bnxt_en_dev *edev, struct bnxt_ulp_ops *ulp_ops,
-		      void *handle);
-void bnxt_unregister_dev(struct bnxt_en_dev *edev);
-int bnxt_send_msg(struct bnxt_en_dev *edev, struct bnxt_fw_msg *fw_msg);
-void bnxt_register_async_events(struct bnxt_en_dev *edev,
-				unsigned long *events_bmap, u16 max_id);
-#endif
--- /dev/null
+++ b/include/linux/bnxt/ulp.h
@@ -0,0 +1,129 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2016-2018 Broadcom Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef BNXT_ULP_H
+#define BNXT_ULP_H
+
+#define BNXT_MIN_ROCE_CP_RINGS	2
+#define BNXT_MIN_ROCE_STAT_CTXS	1
+
+#define BNXT_MAX_ROCE_MSIX_VF		2
+#define BNXT_MAX_ROCE_MSIX_NPAR_PF	5
+#define BNXT_MAX_ROCE_MSIX		64
+
+struct hwrm_async_event_cmpl;
+struct bnxt;
+
+struct bnxt_msix_entry {
+	u32	vector;
+	u32	ring_idx;
+	u32	db_offset;
+};
+
+struct bnxt_ulp_ops {
+	/* async_notifier() cannot sleep (in BH context) */
+	void (*ulp_async_notifier)(void *, struct hwrm_async_event_cmpl *);
+	void (*ulp_irq_stop)(void *, bool);
+	void (*ulp_irq_restart)(void *, struct bnxt_msix_entry *);
+};
+
+struct bnxt_fw_msg {
+	void	*msg;
+	int	msg_len;
+	void	*resp;
+	int	resp_max_len;
+	int	timeout;
+};
+
+struct bnxt_ulp {
+	void		*handle;
+	struct bnxt_ulp_ops __rcu *ulp_ops;
+	unsigned long	*async_events_bmap;
+	u16		max_async_event_id;
+	u16		msix_requested;
+};
+
+struct bnxt_en_dev {
+	struct net_device *net;
+	struct pci_dev *pdev;
+	struct bnxt_msix_entry			msix_entries[BNXT_MAX_ROCE_MSIX];
+	u32 flags;
+	#define BNXT_EN_FLAG_ROCEV1_CAP		0x1
+	#define BNXT_EN_FLAG_ROCEV2_CAP		0x2
+	#define BNXT_EN_FLAG_ROCE_CAP		(BNXT_EN_FLAG_ROCEV1_CAP | \
+						 BNXT_EN_FLAG_ROCEV2_CAP)
+	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
+	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
+	#define BNXT_EN_FLAG_VF			0x10
+#define BNXT_EN_VF(edev)	((edev)->flags & BNXT_EN_FLAG_VF)
+	#define BNXT_EN_FLAG_ROCE_VF_RES_MGMT	0x20
+	#define BNXT_EN_FLAG_SW_RES_LMT		0x40
+#define BNXT_EN_SW_RES_LMT(edev) ((edev)->flags & BNXT_EN_FLAG_SW_RES_LMT)
+
+	struct bnxt_ulp			*ulp_tbl;
+	int				l2_db_size;	/* Doorbell BAR size in
+							 * bytes mapped by L2
+							 * driver.
+							 */
+	int				l2_db_size_nc;	/* Doorbell BAR size in
+							 * bytes mapped as non-
+							 * cacheable.
+							 */
+	int				l2_db_offset;	/* Doorbell offset in
+							 * bytes within
+							 * l2_db_size_nc.
+							 */
+	u16				chip_num;
+	u16				hw_ring_stats_size;
+	u16				pf_port_id;
+	unsigned long			en_state;	/* Could be checked in
+							 * RoCE driver suspend
+							 * mode only. Will be
+							 * updated in resume.
+							 */
+	void __iomem                    *bar0;
+
+	u16				ulp_num_msix_vec;
+	u16				ulp_num_ctxs;
+
+					/* serialize ulp operations */
+	struct mutex			en_dev_lock;
+};
+
+static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
+{
+	if (edev && rcu_access_pointer(edev->ulp_tbl->ulp_ops))
+		return true;
+	return false;
+}
+
+int bnxt_get_ulp_msix_num(struct bnxt *bp);
+int bnxt_get_ulp_msix_num_in_use(struct bnxt *bp);
+void bnxt_set_ulp_msix_num(struct bnxt *bp, int num);
+int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
+void bnxt_set_ulp_stat_ctxs(struct bnxt *bp, int num_ctxs);
+int bnxt_get_ulp_stat_ctxs_in_use(struct bnxt *bp);
+void bnxt_set_dflt_ulp_stat_ctxs(struct bnxt *bp);
+void bnxt_ulp_stop(struct bnxt *bp);
+void bnxt_ulp_start(struct bnxt *bp, int err);
+void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
+void bnxt_ulp_irq_stop(struct bnxt *bp);
+void bnxt_ulp_irq_restart(struct bnxt *bp, int err);
+void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
+void bnxt_rdma_aux_device_uninit(struct bnxt *bp);
+void bnxt_rdma_aux_device_del(struct bnxt *bp);
+void bnxt_rdma_aux_device_add(struct bnxt *bp);
+void bnxt_rdma_aux_device_init(struct bnxt *bp);
+int bnxt_register_dev(struct bnxt_en_dev *edev, struct bnxt_ulp_ops *ulp_ops,
+		      void *handle);
+void bnxt_unregister_dev(struct bnxt_en_dev *edev);
+int bnxt_send_msg(struct bnxt_en_dev *edev, struct bnxt_fw_msg *fw_msg);
+void bnxt_register_async_events(struct bnxt_en_dev *edev,
+				unsigned long *events_bmap, u16 max_id);
+#endif


