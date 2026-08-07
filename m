Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020074.outbound.protection.outlook.com [40.93.198.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550CF2F90E0
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786125415; cv=fail; b=KgoWFMsT/FFnlJQkKndaT3bm2X1I72+23lvjjeXWszewhHTTea8bU6AGlGwrltBHOK1BshknkcIactKzqVWdL5H9w6pE7uZEd/k5+wEmVHoxHoInB4QttHMXZRzeNTYmA1wPQkZS5c4QNLkdInV8Yo9jramO5i7p3Lsnb/fgeCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786125415; c=relaxed/simple;
	bh=kgRdXa9CnWdOQ0Eiyd5f+6xcHegJLtPGRVQZ6CAFme4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7rzn8Cix1yFi9ifWzyp4nSKaRd/EQI6CYhLOTAFNF+sSIsNeOShq2itJ59D6tx+qgbWQ8zbSYD2GaKIGpxyn8qOZ6c7wL80vtXzG0wLixbVeBX4XI9oMZFFOgBAIGIG7WRkkLn75MED+HD73o2AKLaX3u1NKfOaUVE97F27QEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=fiYK+236; arc=fail smtp.client-ip=40.93.198.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="fiYK+236"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYgHoU3xX09AMlDnL1eF2NQIIEp86vgUXBCng2cIBwiAnEfE3KHRk6Cr1XWT07P7JZEXO21oXsZrzno3+VcW9KmJGp4l2TJ1twFPF9n1tbNk4zh7u+gbgRu5zYHPA2d5647jxv1PTINCa6VcNjnln5dhXpJI2CTHTbWPKbaYXU6ch0JQHZjt6RCH3W+jsG/0uNSo818+eLCOqe8KlKpalNXpPPbLTj/PCAwNUbq5VjpIWoaJOSsaZOZE0QbWH/93VQcT6zywU3jCzh8a6qZ31O5IJYODIYWooifSNTKV/qbaK1S4A5wDkfU0je4ORO5Gwd6dG9+O66fSDa8iy/adzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uL/7kHda+U5lQm2WkNU2Bw1ihRy/Ykth7hX+cINz7zg=;
 b=HxbV2YzksKVZmtwSaDWM7fqpardL2xvDqmMOYGvY/FPlqaVHHCK+Sve4j6WbKcgKwwqYQ16uCsZ6NTw0F6bmBMPwuTjYZYTYmsb6sScgqcYLDUdTSALRrhPWx2yA3EKziMB+wZciS3ErCT8vOs1SvwN5a86/jR8xGHUFHHCwgzeiAA2lJk/kBzIUbbpcz7j5zLQ/J4xnUn5gDUOs1DvUEdC9ChIudpRcwFtxleY20RhkSlpwO/J9xuCp7TKKHO0TT7h05IiVDaz3ElGjMlgrWTQ95722o1Lg322ydgvQMb2lyR9ESJb8fkrPosn0biZbIgZlrs041CNF5HvKZLG9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=cornelisnetworks.com
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uL/7kHda+U5lQm2WkNU2Bw1ihRy/Ykth7hX+cINz7zg=;
 b=fiYK+236pxUNrzEk8eox9NS086Hrafve3yPNDhu61BkcIesJmvOpL4JLGNtXzVkTW+hbTAAL/eOZjVWYbxW3ezyH2Oa1YakLkxfRp4YAe3xjNQjzi6e6H8x7JYItNUs5WzsM2WP9iuV0DHtcFD8QRvR2XGSQcuM6HE64FiQdZCX8NBAP9rC/LVGPILgkDGIYl5rOajUg8H3kUF/6uRZEM8WDDP9xxTFPwYk7FaNPPTy3jz9csE4VllC6YEOmG4grHqEAgutkPHUrd3kuYMJlqaukzygO8sIVWxlkQ8wiQ56LoUsaq8RPOYW5XDJmauQmprcwsuleRFCwVKmHMBF/BQ==
Received: from SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7)
 by PH7PR01MB7728.prod.exchangelabs.com (2603:10b6:510:1d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.19; Fri, 7 Aug 2026 17:56:43 +0000
Received: from CO1PEPF000075EF.namprd03.prod.outlook.com
 (2603:10b6:a03:330:cafe::24) by SJ0PR05CA0182.outlook.office365.com
 (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.3 via Frontend Transport; Fri, 7
 Aug 2026 17:56:42 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 CO1PEPF000075EF.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 17:56:42 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id D7FCE1DAF27;
	Fri,  7 Aug 2026 13:56:41 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id D4D1C186A3082;
	Fri,  7 Aug 2026 13:56:41 -0400 (EDT)
Subject: [PATCH v4 for-next 11/24] RDMA/hfi2: Add cport management
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: Dean Luick <dean.luick@cornelisnetworks.com>,
 Douglas Miller <doug.miller@cornelisnetworks.com>, linux-rdma@vger.kernel.org
Date: Fri, 07 Aug 2026 13:56:41 -0400
Message-ID: <178612540183.3164235.12453438848600476714.stgit@awdrv-04>
In-Reply-To: <178612534584.3164235.5428549372904350681.stgit@awdrv-04>
References: <178612534584.3164235.5428549372904350681.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EF:EE_|PH7PR01MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d4f0e9-b937-4660-cf4a-08def4ad3d3f
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|18002099003|22082099003|55112099003|5023799004|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JQXFrrxYPyxp9mZp3DbH+k0d+VxG651gtSbpQyMnpdFp8tSq69u+KDp3QsSLVAoDbgI9zJi3Ext+o22Kk7PguYoQGMIJuYC2FXeQKxg6U4deER+Rk53xbnOtNTycoMqCZfrp2x51mvBwLTcYmcUBIVaR7TAOoBKjaXbLiHnnX52oy6i+inTI0uElXpTlOyWz6YDVLz+ajKjUFKtXaV7aLYMVQqOqzxwfJc416b5YjQ/6yc1ZURwmS/hJc8O5PwgP1hdZbiToDwm5njApH+ru0cuOQDwaxOGgtO02qiI6WSk5F4zyMTw+c4Chvdi3b09lJVlmu9hYLqeENsgVYw+NhIqsMpNC/NdgYMJOgcWO32UnBM0ozqBtl5KnyP3ExIWHrJ9FoKUA7ufsWu0K8mtOx110KnSgD5i/nWN0fl6aEHUDyh5u4tvfrfRV9F8TmAPingTO7eGJYz4zOu78fkRdme0CzcXWSJRGgF+cHKotbrhw7gqNr75bRElMQKDr6nrS8bcUlwuYohjhKqKGmLGMhcwT/oq9cL0rcKlTD9lr20nMI9QlMRGRePEcr9K74WmYGcp3tQIVW+krMqgwcZOOhqSMjec7hKM2smgsXURDK4OutOUKrirQfH5UPRkjDsJ3HQj992oc8x5Nbz2CNP5oroddeUtm+tYLj0RdHqvmz6FL1i03B6ar74NLwFuH4E/ncLxPkIv2oTiqvxq8kD8PGg==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(18002099003)(22082099003)(55112099003)(5023799004)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EMKzhCcB0oDHp9ELTkFU7LkD4/tt7+IKonhpXR5SrKwVqug9sQembk0VPaMTppoL9e3i4C0VHnW2iAw8yv2g6XJXH3ZUiu9A9a4jKZo+p8KKPtTKJrr0U4WDqtWXZ92FWa0xbUsK+3ZWyuwGsLt1HbqfnhH9CA2C7GitYX93KTX9odqmZVzm+MmNEEoBIB9NK34H2FP3v5Q68ytNVAiJiQ+UczWFGHeV4yglhQnjrTdchHU0xQZxk2+x20FMQi6BJsdLm/vFEx+8LErODUWZhTZeEjyLur/asW7PSQPvoOmSsstBuMqG+xqWnlf9CnwYDWR4cfEi25Ug8LRCTiI88xnw+mtDlyV2crJPGa8gwyGbd+77xLV3ZNzRlnoCCZ5uMAfKaZa/9JTJwUtwwsl0hIMcaCKnIcrhtOeZZEm26Xdcy86jRA2bZ5M7F0b83m04
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 17:56:42.5498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d4f0e9-b937-4660-cf4a-08def4ad3d3f
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB7728

Add the cport.c file which implements communication with the embedded
micro controller on the chip for port management operations.

Co-developed-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Co-developed-by: Douglas Miller <doug.miller@cornelisnetworks.com>
Signed-off-by: Douglas Miller <doug.miller@cornelisnetworks.com>
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
  Changes since v2:
  - Use spin_lock_irqsave for lost_mctxt_intr since irq_src_lock is also
    taken with irqsave in hardirq context.
  - Use timer_shutdown_sync for lost_int_timer.
  - Use cancel_work_sync for mctxt_work.
  - Change new_ctxts from u8 to u32 with U8_MAX overflow guard in
    cw_pad_size.
  - Add bounds check in hfi2_cport_resp_set before memcpy.
  - Remove dead tautological comparisons.
---
 drivers/infiniband/hw/hfi2/cport.c | 1029 ++++++++++++++++++++++++++++++++++++
 1 file changed, 1029 insertions(+)
 create mode 100644 drivers/infiniband/hw/hfi2/cport.c

diff --git a/drivers/infiniband/hw/hfi2/cport.c b/drivers/infiniband/hw/hfi2/cport.c
new file mode 100644
index 000000000000..1dc9f6c78b85
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/cport.c
@@ -0,0 +1,1029 @@
+// SPDX-License-Identifier: GPL-2.0 or BSD-3-Clause
+/*
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ */
+
+/*
+ * Implementation details of CPORT communications.
+ */
+
+#include <linux/semaphore.h>
+#include <linux/io.h>
+
+#include "hfi2.h"
+#include "chip_jkr.h"
+#include "cport.h"
+
+static uint cport_ping_to;
+
+uint hfi2_cport_adm_to = 1;
+
+static bool cport_mctxt_recovery = true;
+
+static void cport_send_req_fn(struct work_struct *work);
+static void cport_send_rsp_fn(struct work_struct *work);
+
+#undef CPORT_XA_DEBUG /* every tid assigned from xarray */
+#undef CPORT_RCV_DEBUG /* every message (header) received, and outbox empty */
+#undef CPORT_SND_DEBUG /* every message (header) sent */
+#undef CPORT_INT_DEBUG /* every interrupt processed, and status in timeouts */
+#define LOST_INT_DEBUG /* print if lost intr detected */
+
+static unsigned int cport_lost_int = 1 * HZ;
+
+/*
+ * This limit needs to balance memory consuption against
+ * the need to ensure tids don't repeat during periods of
+ * CPORT stall and message timeout.
+ *
+ * Also note that the limit parameter passed to xa_alloc*()
+ * gets modified, so we cannot use a static structure here.
+ */
+#define cport_tid_limit XA_LIMIT(0, 255)
+
+/*
+ * The "header" (first qword) of a message to/from CPORT.
+ */
+union cport_header {
+	struct {
+		u64 len : 15;
+		u64 _resv1 : 1;
+		u64 is_req : 1;
+		u64 no_rsp : 1;
+		u64 seq_no : 6;
+		u64 sts : 8;
+		u64 tid : 16;
+		u64 sideband : 8;
+		u64 op_code : 8;
+	};
+	u64 qw;
+};
+
+#define CPORT_SEQNO_MASK 0x3f
+
+#define CPORT_HDR_DEF 0x0000007ec0000000ul
+#define CPORT_HDR_LEN 48 /* bit position of length in CPORT_HDR_DEF */
+#define CPORT_HDR_SEQ 28 /* bit position of SEQ_NO */
+#define CPORT_HDR_EOM 30 /* bit position of EOM */
+#define CPORT_HDR_SOM 31 /* bit position of SOM */
+
+#define CPORT_IN_SCRATCH (JKR_ASIC_CFG_SCRATCH + 0)
+#define CPORT_OUT_SCRATCH (JKR_ASIC_CFG_SCRATCH + sizeof(u64))
+
+/*
+ * Assignment of bits in JKR_MCTXT_CPORT_INT_STATUS and
+ * JKR_MCTXT_PF0_INT_STATUS.
+ */
+#define JKR_MCTXT_INT_OUTBOX_EMPTY 0b00000001
+#define JKR_MCTXT_INT_INBOX_FULL 0b00000010
+
+/*
+ * The remainder is private to the host driver.
+ * CPORT firmware has no need of this interface.
+ */
+
+/*
+ * How the MCTXT CSRs are interpreted.
+ */
+union mctxt_mem {
+	union cport_header hdr;
+	u64 qw[JKR_C_MCTXT_MEM_SIZE_IN_QWORDS];
+};
+
+/*
+ * The common structure used to implement CPORT messages in hfi2.
+ */
+struct cport_work {
+	struct work_struct work;
+	struct kref kref;
+	int flags;
+	u8 n_mctxts; /* len of mctxt_mem req/rsp arrays */
+	u8 mctxts_done; /* number of mctxs sent/received */
+	long timeout;
+	struct semaphore *sem; /* only valid in send, if request w/response */
+	struct hfi2_devdata *dd; /* only valid in recv context */
+	union mctxt_mem *req;
+	union mctxt_mem *rsp; /* only used for request w/response */
+};
+
+#define CW_FLAG_SEND 0x01 /* struct originated in send */
+#define CW_FLAG_RECV 0x02 /* struct originated in receive */
+
+/*
+ * Suspected lost interrupt, try to recover if possible.
+ */
+static void lost_mctxt_intr(struct hfi2_devdata *dd)
+{
+	unsigned long flags;
+	u64 ints;
+
+	spin_lock_irqsave(&dd->irq_src_lock, flags);
+	ints = hfi2_read_csr(dd, JKR_MCTXT_PF0_INT_STATUS_ENABLED);
+	/* if bits set, assume lost interrupt and attempt recovery. */
+	if (ints) {
+#ifdef LOST_INT_DEBUG
+		dd_dev_info(dd, "%s forcing int for %llx\n", __func__, ints);
+#endif
+		hfi2_force_intr(dd, JKR_MCTXT_CPORT_TO_PCIE_INT);
+	}
+	spin_unlock_irqrestore(&dd->irq_src_lock, flags);
+}
+
+static void cport_lost_int_chk(struct timer_list *t)
+{
+	struct hfi2_cport *cport = timer_container_of(cport, t, lost_int_timer);
+
+	if (cport_lost_int) {
+		lost_mctxt_intr(cport->dd);
+		mod_timer(&cport->lost_int_timer, jiffies + cport_lost_int);
+	}
+}
+
+/*
+ * Acquire a reference to the message structure
+ */
+static inline void cwget(struct cport_work *cw)
+{
+	kref_get(&cw->kref);
+}
+
+/*
+ * Locate and remove the 'id' message in the xarray and atomically
+ * acquire a reference to the message structure.
+ */
+static inline struct cport_work *cwget_xa(struct hfi2_devdata *dd, u32 id)
+{
+	struct cport_work *cw;
+
+	xa_lock(&dd->cport->tid_xa);
+	cw = __xa_erase(&dd->cport->tid_xa, id);
+	if (cw)
+		cwget(cw);
+	xa_unlock(&dd->cport->tid_xa);
+	return cw;
+}
+
+static void cwrelease(struct kref *kref)
+{
+	struct cport_work *cw = container_of(kref, struct cport_work, kref);
+
+	kfree(cw->req);
+	kfree(cw->rsp);
+
+	kfree(cw);
+}
+
+static void cwput(struct cport_work *cw)
+{
+	kref_put(&cw->kref, cwrelease);
+}
+
+static struct cport_work *cwalloc(int flag)
+{
+	struct cport_work *cw = kzalloc(sizeof(*cw), GFP_KERNEL);
+
+	if (!cw)
+		return NULL;
+
+	cw->flags = flag;
+	cw->n_mctxts = 1;
+	cw->req = kzalloc_obj(cw->req, GFP_KERNEL);
+	if (!cw->req) {
+		kfree(cw);
+		return NULL;
+	}
+
+	cw->rsp = kzalloc(sizeof(*cw->rsp), GFP_KERNEL);
+	if (!cw->rsp) {
+		kfree(cw->req);
+		kfree(cw);
+		return NULL;
+	}
+
+	kref_init(&cw->kref);
+	return cw;
+}
+
+/* set "external" (non-alloc) response payload */
+static void pld_rsp_set(struct cport_work *cw, void *pld, int len)
+{
+	memcpy(&cw->rsp->qw[1], pld, len);
+	cw->rsp->hdr.len = len + sizeof(cw->rsp->hdr);
+}
+
+static int cw_pad_size(struct cport_work *msg, u32 size)
+{
+	union mctxt_mem *new_reqs, *new_rsps;
+	u32 new_ctxts;
+
+	/* already large enough */
+	if (size <= msg->n_mctxts * (sizeof(*new_reqs)))
+		return 0;
+
+	/* round up to next mctxt buffer len */
+	new_ctxts = (size + (sizeof(*new_reqs) - 1)) / sizeof(*new_reqs);
+	if (new_ctxts > U8_MAX)
+		return -EINVAL;
+	new_reqs =
+		krealloc(msg->req, new_ctxts * sizeof(*new_reqs), GFP_KERNEL);
+	if (!new_reqs)
+		return -ENOMEM;
+	msg->req = new_reqs;
+
+	new_rsps =
+		krealloc(msg->rsp, new_ctxts * sizeof(*new_reqs), GFP_KERNEL);
+	if (!new_rsps)
+		return -ENOMEM;
+
+	msg->rsp = new_rsps;
+	msg->n_mctxts = new_ctxts;
+
+	return 0;
+}
+
+static int cwcopy(struct cport_work *msg, void *from, u32 offset, u32 len,
+		  bool req)
+{
+	union mctxt_mem *mc;
+	int ret;
+
+	ret = cw_pad_size(msg, offset + len);
+	if (ret)
+		return ret;
+
+	mc = req ? msg->req : msg->rsp;
+	memcpy(((u8 *)mc) + offset, from, len);
+
+	return 0;
+}
+
+/*
+ * Send request, non-blocking, with timeout for OUTBOX_EMPTY wait.
+ * Caller must watch 'wait' semaphore for completion, and
+ * then call hfi2_cport_send_comp() or hfi2_cport_send_cancel() to finalize everything.
+ * Returns handle for hfi2_cport_send_comp()/_cancel(), or ERR_PTR().
+ *
+ * See hfi2_cport_send_req() for example usage.
+ */
+void *hfi2_cport_send_req_nb(struct hfi2_devdata *dd, u8 op, u8 sideband,
+			     void *payload, int len, struct semaphore *wait,
+			     long timeout)
+{
+	int ret;
+	struct cport_work *msg;
+	u32 idx;
+
+	if (!dd->cport)
+		return ERR_PTR(-EINVAL);
+
+	msg = cwalloc(CW_FLAG_SEND);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+	msg->dd = dd;
+	msg->timeout = timeout;
+	ret = cwcopy(msg, payload, sizeof(union cport_header), len, true);
+	if (ret) {
+		cwput(msg);
+		return ERR_PTR(ret);
+	}
+	ret = xa_alloc_cyclic(&dd->cport->tid_xa, &idx, msg, cport_tid_limit,
+			      &dd->cport->tid_next, GFP_KERNEL);
+	if (ret < 0) {
+		cwput(msg);
+		return ERR_PTR(ret);
+	}
+#ifdef CPORT_XA_DEBUG
+	dd_dev_info(dd, "CPORT tid is %04x\n", idx);
+#endif
+	msg->req->hdr.op_code = op;
+	msg->req->hdr.sideband = sideband;
+	msg->req->hdr.is_req = 1;
+	msg->req->hdr.no_rsp = 0;
+	msg->req->hdr.tid = idx;
+	msg->req->hdr.len = len + sizeof(msg->req->hdr);
+	msg->sem = wait;
+	cwget(msg); /* extra ref so not freed after send */
+	INIT_WORK(&msg->work, cport_send_req_fn);
+	queue_work(dd->hfi2_wq, &msg->work);
+	return msg;
+}
+
+/*
+ * Extract results from response and drop (last) reference to structure.
+ * Returns status from response header.
+ * Must never be called twice for the same message (message has been freed).
+ * Must never be called on a message that has not received response (up'ed wait).
+ */
+int hfi2_cport_send_comp(struct hfi2_devdata *dd, void *handle, void **rsp_pld,
+			 int *rsp_len)
+{
+	struct cport_work *msg = handle;
+	void *ptr;
+	int ret;
+	int len;
+
+	*rsp_len = len = msg->rsp->hdr.len - sizeof(msg->rsp->hdr);
+	if (rsp_pld) {
+		ptr = kzalloc(len, GFP_KERNEL);
+		if (!ptr)
+			return -ENOMEM;
+		memcpy(ptr, &msg->rsp[0].qw[1], len);
+		*rsp_pld = ptr;
+	}
+	ret = msg->rsp->hdr.sts;
+	cwput(msg);
+	return ret;
+}
+
+/*
+ * Cleanup aborted wait for response.
+ * Only called for requests w/responses.
+ * Must never be called twice for the same message (message has been freed).
+ */
+void hfi2_cport_send_cancel(struct hfi2_devdata *dd, void *handle)
+{
+	struct cport_work *msg = handle;
+
+	cancel_work(&msg->work); /* cport_send() drops ref on all paths */
+	xa_erase(&dd->cport->tid_xa, msg->req->hdr.tid);
+	cwput(msg);
+}
+
+/*
+ * Send request and wait for response, with timeout.
+ * Caller must be able to sleep.
+ * Returns status from response header, and response payload data, on success.
+ * Response payload was from k[z]alloc() and caller must kfree().
+ * On error, returns -errno (response status is always 0-15).
+ */
+int hfi2_cport_send_req(struct hfi2_devdata *dd, u8 op, u8 sideband,
+			void *payload, int len, void **rsp_pld, int *rsp_len,
+			long timeout)
+{
+	int ret;
+	struct cport_work *msg;
+	struct semaphore comp;
+
+	sema_init(&comp, 0);
+
+	might_sleep();
+
+	msg = hfi2_cport_send_req_nb(dd, op, sideband, payload, len, &comp,
+				     timeout);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+	if (timeout > 0 && timeout != MAX_SCHEDULE_TIMEOUT)
+		ret = down_timeout(&comp, timeout);
+	else
+		ret = down_killable(&comp);
+	if (ret) {
+#ifdef CPORT_INT_DEBUG
+		u64 ints;
+
+		ints = hfi2_read_csr(dd, JKR_MCTXT_PF0_INT_STATUS);
+		dd_dev_err(
+			dd,
+			"CPORT request wait interrupted %016llx (%d) [%02llx]\n",
+			msg->req->hdr.qw, ret, ints);
+#else
+		dd_dev_err(dd, "CPORT request wait interrupted %016llx (%d)\n",
+			   msg->req->hdr.qw, ret);
+#endif
+		hfi2_cport_send_cancel(dd, msg);
+		lost_mctxt_intr(dd); /* attempt recovery */
+		return ret;
+	}
+	return hfi2_cport_send_comp(dd, msg, rsp_pld, rsp_len);
+}
+
+int hfi2_cport_send_notif(struct hfi2_devdata *dd, u8 op, u8 sideband,
+			  void *payload, int len, long timeout)
+{
+	struct cport_work *msg;
+	int ret;
+
+	if (!dd->cport)
+		return -EINVAL;
+
+	msg = cwalloc(CW_FLAG_SEND);
+	if (!msg)
+		return -ENOMEM;
+	msg->dd = dd;
+	msg->timeout = timeout;
+	ret = cwcopy(msg, payload, sizeof(union cport_header), len, true);
+	if (ret) {
+		cwput(msg);
+		return ret;
+	}
+	msg->req->hdr.len = len + sizeof(msg->req->hdr);
+	msg->req->hdr.op_code = op;
+	msg->req->hdr.sideband = sideband;
+	msg->req->hdr.is_req = 1;
+	msg->req->hdr.no_rsp = 1;
+	INIT_WORK(&msg->work, cport_send_req_fn);
+	queue_work(dd->hfi2_wq, &msg->work);
+	return 0;
+}
+
+/*
+ ********************************************************************
+ * Internal routines.
+ */
+
+/*
+ * Send a response to CPORT's request.
+ *
+ * Re-uses message structure from request. Queues to send workqueue.
+ */
+static int cport_send_rsp(struct cport_work *msg, int sts)
+{
+	struct hfi2_devdata *dd = msg->dd;
+
+	/* rsp.hdr.len and rsp.qw[1..] already setup, also rsp.op_code/rsp.tid */
+	msg->rsp->hdr.is_req = 0;
+	msg->rsp->hdr.sts = sts;
+	INIT_WORK(&msg->work, cport_send_rsp_fn);
+	queue_work(dd->hfi2_wq, &msg->work);
+	return 0;
+}
+
+static void cport_send(struct cport_work *msg, bool req)
+{
+	union mctxt_mem *mc = req ? msg->req : msg->rsp;
+	struct hfi2_devdata *dd = msg->dd;
+	u32 csr_i, tot_len, len_sent;
+	u64 cport_hdr;
+	u8 seq_no;
+	u64 *ptr;
+	int ret, mcxt_len;
+
+	/* sleep until OutboxEmpty... */
+	if (msg->timeout > 0 && msg->timeout != MAX_SCHEDULE_TIMEOUT)
+		ret = down_timeout(&dd->cport->outbox, msg->timeout);
+	else
+		ret = down_killable(&dd->cport->outbox);
+	if (ret) {
+		dd_dev_err(dd, "CPORT Send OUTBOX_EMPTY killed %016llx (%d)\n",
+			   msg->req->hdr.qw, ret);
+		cwput(msg);
+		lost_mctxt_intr(dd); /* attempt recovery */
+		return; /* no way to report error to caller */
+	}
+
+	/* sequential under lock, check if there are unfinished messages */
+	if (dd->cport->incomplete_mctxt_msg_tx &&
+	    dd->cport->incomplete_mctxt_msg_tx != msg) {
+		/* give up empty outbox, the incomplete msg must finish next */
+		up(&dd->cport->outbox);
+		/* reschedule this work until next time */
+		queue_work(dd->hfi2_wq, &msg->work);
+		return;
+	}
+
+#ifdef CPORT_SND_DEBUG
+	dd_dev_info(dd, "MCTXT sent %016llx\n", mc->hdr.qw);
+#endif
+	tot_len = mc->hdr.len;
+	len_sent = msg->mctxts_done * sizeof(union mctxt_mem);
+	ptr = &mc[msg->mctxts_done].qw[0];
+	seq_no = msg->mctxts_done;
+	mcxt_len =
+		min_t(int, (int)(tot_len - len_sent), sizeof(union mctxt_mem));
+	/* NOTE: "CPORT IN" is our output */
+	csr_i = JKR_MCTXT_CPORT_IN;
+	cport_hdr = CPORT_HDR_DEF;
+	cport_hdr |= ((u64)mcxt_len << CPORT_HDR_LEN);
+
+	cport_hdr |= (((u64)seq_no & 0x3) << CPORT_HDR_SEQ);
+
+	/* CPORT_HDR_DEF sets SOM/EOM, clear if not */
+	if (msg->mctxts_done)
+		cport_hdr &= ~((u64)1 << CPORT_HDR_SOM);
+	else
+		mc->hdr.seq_no = atomic_fetch_inc(&dd->cport->seqno);
+
+	if (msg->mctxts_done + 1 < msg->n_mctxts)
+		cport_hdr &= ~((u64)1 << CPORT_HDR_EOM);
+
+	hfi2_write_csr(dd, CPORT_IN_SCRATCH, cport_hdr);
+	while (mcxt_len > 0) {
+		hfi2_write_csr(dd, csr_i, *ptr++);
+		csr_i += sizeof(u64);
+		mcxt_len -= sizeof(u64);
+	}
+	hfi2_write_csr(dd, JKR_MCTXT_CPORT_INT_STATUS,
+		       JKR_MCTXT_INT_INBOX_FULL);
+
+	/* did we complete the message? */
+	if (++msg->mctxts_done < msg->n_mctxts) {
+		dd->cport->incomplete_mctxt_msg_tx = msg;
+		queue_work(dd->hfi2_wq,
+			   &msg->work); /* reschedule the remaining sends */
+
+		return;
+	}
+
+	dd->cport->incomplete_mctxt_msg_tx = NULL;
+	/* reset mctxts_done for response parsing */
+	if (req)
+		msg->mctxts_done = 0;
+	cwput(msg); /* may or may not free memory */
+}
+
+/*
+ * Low-level send to CPORT via MCTXT.
+ *
+ * Interfaces with MCTXT.
+ */
+static void cport_send_req_fn(struct work_struct *work)
+{
+	struct cport_work *msg = container_of(work, struct cport_work, work);
+
+	cport_send(msg, true);
+}
+
+static void cport_send_rsp_fn(struct work_struct *work)
+{
+	struct cport_work *msg = container_of(work, struct cport_work, work);
+
+	cport_send(msg, false);
+}
+
+static int echo_req(struct hfi2_devdata *dd, u8 op, u8 sideband, void *pld,
+		    int pll, void *handle)
+{
+	struct cport_work *msg = handle;
+
+	dd_dev_info(msg->dd, "cport ping %02x (%d)\n", sideband, pll);
+	/* Leave payload in-tact (echo). */
+	pld_rsp_set(msg, pld, pll);
+	return MSG_RSP_STATUS_OK;
+}
+
+static int inval_req(struct hfi2_devdata *dd, u8 op, u8 sideband, void *pld,
+		     int pll, void *handle)
+{
+	return MSG_RSP_STATUS_OPCODE_UNSUPPORTED;
+}
+
+/*
+ * Process a request from CPORT.
+ *
+ * May be dispatched to external function from handlers[].
+ */
+static void cport_req_fn(struct work_struct *work)
+{
+	struct cport_work *msg = container_of(work, struct cport_work, work);
+	cport_handler func;
+	int ret = MSG_RSP_STATUS_OK;
+	void *pld;
+	int pll;
+
+	pll = msg->req->hdr.len - sizeof(msg->req->hdr);
+	pld = &msg->req->qw[1];
+	msg->rsp->hdr.qw = msg->req->hdr.qw;
+	/* default to no payload in response (if any) */
+	msg->rsp->hdr.len = sizeof(msg->req->hdr);
+	func = msg->dd->cport->handlers[msg->req->hdr.op_code];
+	if (func)
+		ret = func(msg->dd, msg->req->hdr.op_code,
+			   msg->req->hdr.sideband, pld, pll, msg);
+	else
+		ret = inval_req(msg->dd, msg->req->hdr.op_code,
+				msg->req->hdr.sideband, pld, pll, msg);
+	if (msg->req->hdr.no_rsp) {
+		cwput(msg);
+		if (ret)
+			dd_dev_err(msg->dd, "Op %d %02x failed (%d)\n",
+				   msg->req->hdr.op_code,
+				   msg->req->hdr.sideband, ret);
+	} else {
+		/* msg->rsp->qw[*] and msg->rsp->hdr.len have been updated */
+		ret = cport_send_rsp(msg, ret);
+		if (ret)
+			dd_dev_err(msg->dd, "Response send failed (%d)\n", ret);
+	}
+}
+
+/*
+ * Handler for MCTXT Inbox Full interrupt.
+ *
+ * Only one can be queued/run until JKR_MCTXT_INT_OUTBOX_EMPTY is cleared.
+ * Run in a workqueue (not interrupt context).
+ */
+static void cport_mctxt_fn(struct work_struct *work)
+{
+	struct hfi2_cport *cport =
+		container_of(work, struct hfi2_cport, mctxt_work);
+	struct hfi2_devdata *dd = cport->dd;
+	int ret = 0;
+	u8 is_start, is_end;
+	int len;
+	u64 *ptr;
+	u64 mhdr;
+	u32 i;
+	struct cport_work *msg;
+	union cport_header hdr;
+
+	/*
+	 * CPORT output MCTXT is our input.
+	 */
+	i = JKR_MCTXT_CPORT_OUT;
+
+	mhdr = hfi2_read_csr(dd, CPORT_OUT_SCRATCH);
+	len = (mhdr >> CPORT_HDR_LEN) & 0xfff;
+	len = min_t(int, len, sizeof(union mctxt_mem));
+	is_start = (mhdr >> CPORT_HDR_SOM) & 1;
+	is_end = (mhdr >> CPORT_HDR_EOM) & 1;
+	if (is_start) {
+		hdr.qw = hfi2_read_csr(dd, i);
+	} else if (cport->incomplete_mctxt_msg_rx) {
+		msg = cport->incomplete_mctxt_msg_rx;
+		if (msg->flags & CW_FLAG_RECV) {
+			ptr = &msg->req[msg->mctxts_done++].qw[0];
+			hdr.qw = msg->req->hdr.qw;
+		} else {
+			ptr = &msg->rsp[msg->mctxts_done++].qw[0];
+			hdr.qw = msg->rsp->hdr.qw;
+		}
+		dd_dev_info(dd, "%s: got continuation of %u\n", __func__,
+			    hdr.seq_no);
+		/* skip all the start-message parsing/allocation */
+		goto copy;
+	} else {
+		/* this is bad, just skip the message */
+		dd_dev_warn(dd, "cport sent unexpected non-start packet\n");
+		goto fail;
+	}
+#ifdef CPORT_RCV_DEBUG
+	dd_dev_info(dd, "%s() %016llx\n", __func__, hdr.qw);
+#endif
+	if (hdr.len < sizeof(hdr)) {
+		/* assume message is invalid  - cannot be processed */
+		ret = -EDOM;
+		goto fail;
+	}
+	i += sizeof(u64);
+	/* No need for atomics here, we are single threaded */
+	if (hdr.seq_no != cport->rseqno) {
+		dd_dev_info(dd, "Recv out of sequence: %d -> %d\n",
+			    cport->rseqno, hdr.seq_no);
+		cport->rseqno = hdr.seq_no;
+	}
+	cport->rseqno = (cport->rseqno + 1) & CPORT_SEQNO_MASK;
+	if (hdr.is_req) {
+		/* Request from CPORT, has no existing message context */
+		msg = cwalloc(CW_FLAG_RECV);
+		if (!msg) {
+			ret = -ENOMEM;
+			goto fail; /* drop message, with error */
+		}
+		ret = cw_pad_size(msg, hdr.len);
+		if (ret)
+			goto fail;
+		ptr = &msg->req->qw[msg->mctxts_done++];
+	} else {
+		/*
+		 * Responses already have a 'msg', extra ref was already taken.
+		 * Take an additional ref against possible race with timeout
+		 * (hfi2_cport_send_cancel()) between here and the up().
+		 */
+		msg = cwget_xa(dd, hdr.tid);
+		if (!msg) {
+			ret = -ESRCH;
+			goto fail; /* drop message, with error */
+		}
+		ret = cw_pad_size(msg, hdr.len);
+		if (ret)
+			goto fail;
+		ptr = &msg->rsp->qw[msg->mctxts_done++];
+		/* assert msg->req->hdr ~= hdr */
+	}
+	*ptr++ = hdr.qw;
+	len -= sizeof(hdr);
+copy:
+	/* now copy payload into chosen buffer */
+	while (len > 0) {
+		*ptr++ = hfi2_read_csr(dd, i);
+		i += sizeof(u64);
+		len -= sizeof(u64);
+	}
+	/*
+	 * We are finished with the dd->cport->mctxt_work struct,
+	 * and the MCTXT, so it can all be re-used now.
+	 */
+	hfi2_write_csr(dd, JKR_MCTXT_CPORT_INT_STATUS,
+		       JKR_MCTXT_INT_OUTBOX_EMPTY);
+#ifdef CPORT_RCV_DEBUG
+	dd_dev_info(dd, "%s() set CPORT OUTBOX_EMPTY\n", __func__);
+#endif
+	/*
+	 * if we do not contain the end of the message then we need to wait
+	 * until next mailbox
+	 */
+	if (!is_end) {
+		cport->incomplete_mctxt_msg_rx = msg;
+		dd_dev_info(dd, "%s: expecting continuation of %u\n", __func__,
+			    hdr.seq_no);
+		return;
+	}
+	cport->incomplete_mctxt_msg_rx = NULL;
+
+	/* responses don't require any more work here - just wakeup requester */
+	if (!hdr.is_req) {
+		up(msg->sem);
+		cwput(msg);
+		return;
+	}
+	msg->dd = dd;
+
+	/* reset mctxts for response parsing */
+	msg->mctxts_done = 0;
+
+	/* dispatch 'msg' request */
+	INIT_WORK(&msg->work, cport_req_fn);
+	/* don't care about locality */
+	queue_work(dd->hfi2_wq, &msg->work);
+	return;
+fail:
+	hfi2_write_csr(dd, JKR_MCTXT_CPORT_INT_STATUS,
+		       JKR_MCTXT_INT_OUTBOX_EMPTY);
+	dd_dev_err(dd, "Dropping incoming CPORT message %016llx (%d)\n", hdr.qw,
+		   ret);
+}
+
+/*
+ * Handler for PF0 MCTXT interrupts.
+ *
+ * Called when one of the enabled MCTXT_PF0 conditions occurs.
+ * 'source' is always 0. Called in interrupt context.
+ *
+ * Since this interrupt is exclusive to MCTXT, there is no doubt
+ * about which transport to use (always is MCTXT).
+ */
+void hfi2_is_cport_int(struct hfi2_devdata *dd, unsigned int source)
+{
+	u64 ints;
+	const int limit = 100; /* arbitrary */
+	int count;
+
+	if (!dd->cport)
+		return;
+
+	/*
+	 * MctxtCportToPcieInt is a "one shot" merged interrupt.  To ensure
+	 * nothing is missed, ensure that its source, MctxtPf0IntStatusEnabled,
+	 * is cleared and reads as zero.
+	 */
+	ints = 0;
+	for (count = 0; count < limit; count++) {
+		u64 temp;
+
+		temp = hfi2_read_csr(dd, JKR_MCTXT_PF0_INT_STATUS_ENABLED);
+		if (temp == 0)
+			break;
+		ints |= temp;
+		hfi2_write_csr(dd, JKR_MCTXT_PF0_INT_ACK, temp);
+	}
+	if (count == limit)
+		dd_dev_warn(dd, "MCTXT interrupt too many loops\n");
+	if (!ints) {
+		dd_dev_warn(dd, "MCTXT interrupt, but no status bits set\n");
+		return;
+	}
+
+#ifdef CPORT_INT_DEBUG
+	dd_dev_info(dd, "%s() %02llx\n", __func__, ints);
+#endif
+	if (ints & JKR_MCTXT_INT_INBOX_FULL)
+		queue_work(dd->hfi2_wq, &dd->cport->mctxt_work);
+	if (ints & JKR_MCTXT_INT_OUTBOX_EMPTY)
+		up(&dd->cport->outbox);
+}
+
+/***************************************************
+ * API for handling notifications from CPORT
+ */
+
+int hfi2_cport_resp_set(void *handle, void *payload, int len)
+{
+	struct cport_work *msg = handle;
+
+	if (!msg || !payload || len <= 0)
+		return -EINVAL;
+	if (len > (int)(sizeof(*msg->rsp) - sizeof(msg->rsp->hdr)))
+		return -EINVAL;
+	msg->rsp->hdr.len = len + sizeof(msg->rsp->hdr);
+	memcpy(&msg->rsp->qw[1], payload, len);
+	return 0;
+}
+
+int hfi2_cport_register_cb(struct hfi2_devdata *dd, u8 op_start, u8 op_end,
+			   cport_handler func)
+{
+	int x;
+
+	if (op_start > op_end)
+		return -ERANGE;
+	if (!dd->cport)
+		return -EINVAL;
+
+	/* 'func' may be NULL, to unregister */
+	for (x = op_start; x <= op_end; ++x) {
+		dd->cport->handlers[x] = func;
+	}
+	return 0;
+}
+
+static int cport_ping(void *data)
+{
+	struct hfi2_devdata *dd = data;
+	char buf[16];
+	int len;
+	unsigned int num;
+	void *rspbuf;
+	int rsplen;
+	int rc;
+
+	while (!kthread_should_stop() &&
+	       (num = atomic_read(&dd->cport->nping)) > 0) {
+		len = snprintf(buf, sizeof(buf), "ping %u", num);
+		rspbuf = NULL;
+		rc = hfi2_cport_send_req(dd, CH_OP_PING, 0, buf, len, &rspbuf,
+					 &rsplen,
+					 cport_ping_to ? cport_ping_to * HZ :
+							 MAX_SCHEDULE_TIMEOUT);
+		if (rc < 0) {
+			dd_dev_info(dd, "CPORT \"%s\" error %d\n", buf, rc);
+			if (!cport_ping_to)
+				break;
+		} else {
+			dd_dev_info(dd, "CPORT \"%s\" -> %d \"%.*s\"\n", buf,
+				    rc, rsplen, (char *)rspbuf);
+		}
+		kfree(rspbuf);
+		atomic_dec(&dd->cport->nping);
+	}
+	dd->cport->ping_th = NULL;
+	atomic_set(&dd->cport->nping, 0);
+	return 0;
+}
+
+int hfi2_cport_ping_start(struct hfi2_devdata *dd, unsigned int count)
+{
+	int rc;
+
+	if (!count) {
+		if (dd->cport->ping_th)
+			kthread_stop(dd->cport->ping_th);
+		/* kthread will zero count when exiting */
+		else
+			atomic_set(&dd->cport->nping, 0);
+		return 0;
+	}
+	atomic_set(&dd->cport->nping, count);
+	if (dd->cport->ping_th)
+		return 0;
+
+	dd->cport->ping_th =
+		kthread_create_on_node(cport_ping, dd, dd->node, "cport_ping");
+	if (IS_ERR(dd->cport->ping_th)) {
+		rc = PTR_ERR(dd->cport->ping_th);
+		dd->cport->ping_th = NULL;
+		dd_dev_err(dd, "Failed to create CPORT ping thread %d\n", rc);
+		return rc;
+	}
+	wake_up_process(dd->cport->ping_th);
+	return 0;
+}
+
+#ifdef CONFIG_HFI_CPORT_POLLING
+static int cport_poll(void *data)
+{
+	struct hfi2_devdata *dd = data;
+	u64 v;
+
+	while (!kthread_should_stop()) {
+		v = hfi2_read_csr(dd, JKR_MCTXT_PF0_INT_STATUS);
+		if (v & 0xff)
+			hfi2_is_cport_int(dd, 0);
+		fsleep(30);
+	}
+	return 0;
+}
+#endif
+
+/*
+ * Initialization/setup of MCTXT CPORT communications channel.
+ */
+int hfi2_cport_init(struct hfi2_devdata *dd)
+{
+	struct hfi2_cport *cport;
+
+	if (dd->params->chip_type == CHIP_WFR || dd->is_vf)
+		return 0;
+
+	cport = kzalloc_obj(cport, GFP_KERNEL);
+	if (!cport)
+		goto err1;
+
+	INIT_WORK(&cport->mctxt_work, cport_mctxt_fn);
+	xa_init_flags(&cport->tid_xa, XA_FLAGS_ALLOC);
+	xa_init_flags(&cport->trap_xa, XA_FLAGS_ALLOC);
+
+	/*
+	 * Setting initial state can be problematic.
+	 * We require that CPORT set JKR_MCTXT_INT_OUTBOX_EMPTY in
+	 * JKR_MCTXT_PF0_INT_STATUS or we will never start sending.
+	 * We also require that CPORT never set JKR_MCTXT_INT_OUTBOX_EMPTY
+	 * gratuitously, or we get a semaphore count > 1 and will
+	 * start overrunning MCTXT. Essentially, CPORT must set this
+	 * exactly once when entering the "ready to receive" state
+	 * (initially and after processing each message).
+	 */
+	sema_init(&cport->outbox, 0);
+
+	cport->dd = dd;
+	dd->cport = cport;
+
+	hfi2_cport_register_cb(dd, CH_OP_PING, CH_OP_PING, echo_req);
+
+	if (cport_mctxt_recovery) {
+		u64 is, ie;
+
+		is = hfi2_read_csr(dd, JKR_MCTXT_PF0_INT_STATUS);
+		ie = hfi2_read_csr(dd, JKR_MCTXT_PF0_INT_ENABLE);
+		if (!(is & JKR_MCTXT_INT_OUTBOX_EMPTY) && ie) {
+			dd_dev_warn(dd, "recovering CPORT MCTXT state\n");
+			hfi2_write_csr(dd, JKR_MCTXT_PF0_INT_ENABLE, 0);
+			hfi2_write_csr(dd, JKR_MCTXT_PF0_INT_STATUS,
+				       JKR_MCTXT_INT_OUTBOX_EMPTY);
+		}
+	}
+
+#ifdef CONFIG_HFI_CPORT_POLLING
+	cport->poll_th =
+		kthread_create_on_node(cport_poll, dd, dd->node, "cport_poll");
+	if (!cport->poll_th)
+		dd_dev_err(dd, "Failed to create CPORT polling thread\n");
+	else
+		wake_up_process(dd->cport->poll_th);
+#else
+	/* Enable intr source for MCTXT from CPORT (to PF0) */
+	hfi2_write_csr(dd, JKR_MCTXT_PF0_INT_ENABLE,
+		       JKR_MCTXT_INT_INBOX_FULL | JKR_MCTXT_INT_OUTBOX_EMPTY);
+	hfi2_set_intr_bits(dd, JKR_MCTXT_CPORT_TO_PCIE_INT,
+			   JKR_MCTXT_CPORT_TO_PCIE_INT, true);
+	timer_setup(&cport->lost_int_timer, cport_lost_int_chk, 0);
+	if (cport_lost_int)
+		mod_timer(&cport->lost_int_timer, jiffies + cport_lost_int);
+#endif
+
+	/*
+	 * Must reset/resync sequence numbers as CPORT is strictly enforcing
+	 * sequence number order. Use a timeout to allow easier cleanup should
+	 * init fail.
+	 */
+	hfi2_cport_send_notif(dd, CH_OP_PING, 0, NULL, 0,
+			      hfi2_cport_adm_to * HZ);
+	return 0;
+
+err1:
+	return -ENOMEM;
+}
+
+/*
+ * Deinitialization of MCTXT CPORT communications channel.
+ */
+int hfi2_cport_exit(struct hfi2_devdata *dd)
+{
+	if (!dd->cport)
+		return 0;
+
+	timer_shutdown_sync(&dd->cport->lost_int_timer);
+	/* flush all cport queued tasks (plus anything else on this queue) */
+	flush_workqueue(dd->hfi2_wq);
+
+	/* Disable intr source for MCTXT from CPORT (to PF0) */
+	hfi2_set_intr_bits(dd, JKR_MCTXT_CPORT_TO_PCIE_INT,
+			   JKR_MCTXT_CPORT_TO_PCIE_INT, false);
+	hfi2_write_csr(dd, JKR_MCTXT_PF0_INT_ENABLE, 0);
+	/* leave JKR_MCTXT_INT_OUTBOX_EMPTY set so that future users are ready-to-go */
+	hfi2_write_csr(dd, JKR_MCTXT_PF0_INT_STATUS,
+		       JKR_MCTXT_INT_OUTBOX_EMPTY);
+#ifdef CONFIG_HFI_CPORT_POLLING
+	if (dd->cport->poll_th)
+		kthread_stop(dd->cport->poll_th);
+#endif
+	if (dd->cport->ping_th)
+		kthread_stop(dd->cport->ping_th);
+
+	cancel_work_sync(&dd->cport->mctxt_work);
+
+	xa_destroy(&dd->cport->tid_xa);
+	xa_destroy(&dd->cport->trap_xa);
+	kfree(dd->cport);
+	dd->cport = NULL;
+
+	return 0;
+}


