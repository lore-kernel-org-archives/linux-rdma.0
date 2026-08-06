Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C03DDB0B
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003106; cv=none; b=G/0BoIvwExS7ffHCbBNPbtfKTTePYkVsvwaW2gIS1mcQFtR0fB5o3bijAdZCrH92As7IzS5jZYJq6xrG3KL9lJLdtadNx0RFebg//DYeRNPMDPoa1UzwezKHLdycMPRB3EFkWu4U4o5EP8SRqPpsoyoo1N5RFCDJ9oitvJ7bagA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003106; c=relaxed/simple;
	bh=9rfXeUT3yjIJkM323nOo5B8G5y5kINnSVnEgPq8VzrE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FSHtRDZvnxo0ojym7M0LnrjJYP2DJvyvRGxw7+eHqe9oBxMhtkF2acaJmatGgRXGz4xdSq10+PUjTcmyuhEdZbiGeyUUaT30KrNW4Il+VSvLwZ13EBpD9TnYXf2hBLJExfP8ETui2aSjXuxV/9CKiks8kQbO/SBk8Jt1gu75ba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=aaxeD9Et; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="aaxeD9Et"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786003104; x=1817539104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lMM67NITOcu2GRbXyjagqUVTLy1FtkA5UCL4SMTGXGo=;
  b=aaxeD9EtFWKcY4+o7vq5trmBZarIVFT2NULUjO+mTqoe+ZcOHMpwm3yS
   WxXOkA8ajVShSY16ULS6G2vrVe+eV6goXGLkeGcEzaKMygb/vtldoRWcQ
   vd0YVeETw9Cmyu+MmhgKBF+Igd2eNwcIfWOcnvry1DZnC0RzNLwzsTYsq
   ybWb7P30bnYHj5lJAa1zmKo3LSmhvJ5nNTut85fd5QkC8l8v5ob1AQCwj
   /6/oKjZXyNNyOMulxc54beRdHpXHqFK0XZtJL5y0Q5qRdsfCT+5qeoQ9i
   KUTYIhyhWWNEaNDZQ82/rO/VsRIP6CMlylacsrmLe8Xa3JgFgTG3prGuR
   Q==;
X-CSE-ConnectionGUID: 8KMSjcafSiS1PQXN8XKLdw==
X-CSE-MsgGUID: lT1jahhiQ/KmZu5rw6edmw==
X-IronPort-AV: E=Sophos;i="6.25,208,1779148800"; 
   d="scan'208";a="25274283"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 07:58:21 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:5356]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.11:2525] with esmtp (Farcaster)
 id a44f9a41-cb26-439d-af92-6580b1c4656f; Thu, 6 Aug 2026 07:58:21 +0000 (UTC)
X-Farcaster-Flow-ID: a44f9a41-cb26-439d-af92-6580b1c4656f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 6 Aug 2026 07:58:21 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Thu, 6 Aug 2026
 07:58:19 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>, Chen Brasch
	<cbrasch@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 2/2] RDMA/efa: Pass relaxed ordering flag to device
Date: Thu, 6 Aug 2026 07:57:58 +0000
Message-ID: <20260806075758.3476667-3-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260806075758.3476667-1-ynachum@amazon.com>
References: <20260806075758.3476667-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Dana Malachi <danamala@amazon.com>

Accept the relaxed ordering access flag during memory region
registration and forward it to the device firmware via the admin command
path.

Reviewed-by: Chen Brasch <cbrasch@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Dana Malachi <danamala@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 10 +++++++---
 drivers/infiniband/hw/efa/efa_com_cmd.c         |  2 ++
 drivers/infiniband/hw/efa/efa_com_cmd.h         |  1 +
 drivers/infiniband/hw/efa/efa_verbs.c           |  7 +++++++
 include/uapi/rdma/efa-abi.h                     |  1 +
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index ab830764e3b4..eec660a32061 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -358,7 +358,8 @@ struct efa_admin_reg_mr_cmd {
 	 * 5:0 : phys_page_size_shift - page size is (1 <<
 	 *    phys_page_size_shift). Page size is used for
 	 *    building the Virtual to Physical address mapping
-	 * 6 : reserved - MBZ
+	 * 6 : relaxed_ordering_enable - Enable PCIe relaxed
+	 *    ordering for this memory region
 	 * 7 : mem_addr_phy_mode_en - Enable bit for physical
 	 *    memory registration (no translation), can be used
 	 *    only by privileged clients. If set, PBL must
@@ -697,7 +698,9 @@ struct efa_admin_feature_device_attr_desc {
 	 *    write with imm. receive is supported
 	 * 5 : event_counters - If set, event counters are
 	 *    supported
-	 * 9:6 : reserved1 - MBZ
+	 * 8:6 : reserved1 - MBZ
+	 * 9 : mr_relaxed_ordering - If set, MR PCIe relaxed
+	 *    ordering is supported
 	 * 10 : sq_64_bit_req_id - If set, SQ can use 64-bit
 	 *    work request ids
 	 * 31:11 : reserved2 - MBZ
@@ -1203,6 +1206,7 @@ struct efa_admin_modify_event_counter_resp {
 
 /* reg_mr_cmd */
 #define EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT_MASK      GENMASK(5, 0)
+#define EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE_MASK   BIT(6)
 #define EFA_ADMIN_REG_MR_CMD_MEM_ADDR_PHY_MODE_EN_MASK      BIT(7)
 #define EFA_ADMIN_REG_MR_CMD_LOCAL_WRITE_ENABLE_MASK        BIT(0)
 #define EFA_ADMIN_REG_MR_CMD_REMOTE_WRITE_ENABLE_MASK       BIT(1)
@@ -1231,7 +1235,7 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
-#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_SHIFT 10
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_MR_RELAXED_ORDERING_MASK BIT(9)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_MASK BIT(10)
 
 /* feature_queue_attr_desc_2 */
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index aac0e936601a..07bfcb093df8 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -236,6 +236,8 @@ int efa_com_register_mr(struct efa_com_dev *edev,
 	mr_cmd.mr_length = params->mr_length_in_bytes;
 	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
 		params->page_shift);
+	if (params->relaxed_ordering)
+		EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE, 1);
 	mr_cmd.iova = params->iova;
 	if (params->permissions.local_write)
 		EFA_SET(&mr_cmd.permissions, EFA_ADMIN_REG_MR_CMD_LOCAL_WRITE_ENABLE, 1);
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.h b/drivers/infiniband/hw/efa/efa_com_cmd.h
index 7b0399811cfd..524407f36d43 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.h
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.h
@@ -209,6 +209,7 @@ struct efa_com_reg_mr_params {
 		u8 remote_write : 1;
 		u8 remote_read : 1;
 	} permissions;
+	u8 relaxed_ordering;
 	u8 inline_pbl;
 	u8 indirect;
 };
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 635687275350..a91d02158a6a 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -272,6 +272,9 @@ int efa_query_device(struct ib_device *ibdev,
 		if (EFA_DEV_CAP(dev, EVENT_COUNTERS))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_COMP_CNTR;
 
+		if (EFA_DEV_CAP(dev, MR_RELAXED_ORDERING))
+			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_MR_RELAXED_ORDERING;
+
 		if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID;
 
@@ -1647,6 +1650,9 @@ static struct efa_mr *efa_alloc_mr(struct ib_pd *ibpd, int access_flags,
 		(EFA_DEV_CAP(dev, RDMA_READ) ? IB_ACCESS_REMOTE_READ : 0) |
 		(EFA_DEV_CAP(dev, RDMA_WRITE) ? IB_ACCESS_REMOTE_WRITE : 0);
 
+	if (EFA_DEV_CAP(dev, MR_RELAXED_ORDERING))
+		supp_access_flags |= IB_ACCESS_RELAXED_ORDERING;
+
 	access_flags &= ~IB_ACCESS_OPTIONAL;
 	if (access_flags & ~supp_access_flags) {
 		ibdev_dbg(&dev->ibdev,
@@ -1679,6 +1685,7 @@ static int efa_register_mr(struct ib_pd *ibpd, struct efa_mr *mr, u64 start,
 	params.permissions.local_write = !!(access_flags & IB_ACCESS_LOCAL_WRITE);
 	params.permissions.remote_write = !!(access_flags & IB_ACCESS_REMOTE_WRITE);
 	params.permissions.remote_read = !!(access_flags & IB_ACCESS_REMOTE_READ);
+	params.relaxed_ordering = !!(access_flags & IB_ACCESS_RELAXED_ORDERING);
 
 	pg_sz = ib_umem_find_best_pgsz(mr->umem,
 				       dev->dev_attr.page_size_cap,
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index 2094b4bcc5cf..675aca45e697 100644
--- a/include/uapi/rdma/efa-abi.h
+++ b/include/uapi/rdma/efa-abi.h
@@ -137,6 +137,7 @@ enum {
 	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
 	EFA_QUERY_DEVICE_CAPS_COMP_CNTR = 1 << 8,
 	EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID = 1 << 9,
+	EFA_QUERY_DEVICE_CAPS_MR_RELAXED_ORDERING = 1 << 10,
 };
 
 struct efa_ibv_ex_query_device_resp {
-- 
2.50.1

