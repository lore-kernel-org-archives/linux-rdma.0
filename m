Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E44D3955CB
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 07:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787556689; cv=none; b=rigEKLAOIOtwWLG6ileVJupq53tUXZGq5DlEF7w09mYUeXzt0nHVFi16HF1mB+MG/H1MtP8PWIJk0EShwM5vfWdMbktXTF3950rGeGhFz1OG8pwbzpSWeN6yPkPJ8DceDriUVUBCrKyg2q4Mtmw/Q7mrGn5MF0pqfiZWxjTt79M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787556689; c=relaxed/simple;
	bh=zA+032ElcD0KiWwUo4kuWf9DK2uUNn6ol5kkvBM7nxk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZtC4Fi9xCst1MeiTS8nqBILoij+kGPecuNFOcUdROXtTGar4ry0QNyEQdbuUuptw98RsnqU0Kton5KdB5X1kg3OUZAa92UuHLL4ZnKfJN/NVGm2CPKjzWbNQ8ci5SNkg/8XQlLFi6zK3fSSvUN2NInmdfZotF2a0nFtPHMzVbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=omO/rZ1J; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="omO/rZ1J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787556687; x=1819092687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D6E6rmLzTZIu4ZB194/G/hJVyI5FV+AYK/7wBuqSDVI=;
  b=omO/rZ1JdivoSCOnOn3brXXmSUPwR9uiQiGzv/9wB4pU7zh7jgYGIUmj
   xQ+yXrk78lPF3qCfeWAlt1KGqWMumXMBT/ENnUcFV5vczOg//fJyUAb1O
   LtvDt+jxBVS4RgifVsVBWll7PDmPcD/ltsX1LMAUduBILGI5O7cj5MrvI
   p45SuqlrFbwBqvBl7pS3G2NI/NUbgIGcINCKaOQRkaCYAqRjo+UCLgD0r
   D9kvnDhnEVt5POqszs2RBwA2iyJiNdRT6PqdBkJzl0e0chjdL48lmx0xy
   LvD6F7PzZnS5S4ixOaRI0ZOL6upY09jh5VnTcGLh/TAyE2UWq8lEZhDEr
   Q==;
X-CSE-ConnectionGUID: 9Bhbn+SdQ9yHFXYRaxmUaw==
X-CSE-MsgGUID: 5D2x00qeTV+SZRS+1zp68w==
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="26772625"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 07:31:23 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:1356]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.76:2525] with esmtp (Farcaster)
 id 667730ae-dd06-4341-9e9c-97855ca78e03; Mon, 24 Aug 2026 07:31:23 +0000 (UTC)
X-Farcaster-Flow-ID: 667730ae-dd06-4341-9e9c-97855ca78e03
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 24 Aug 2026 07:31:23 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Mon, 24 Aug 2026
 07:31:21 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>, Chen Brasch
	<cbrasch@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v2 2/2] RDMA/efa: Pass relaxed ordering flag to device
Date: Mon, 24 Aug 2026 07:30:57 +0000
Message-ID: <20260824073057.1046630-3-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260824073057.1046630-1-ynachum@amazon.com>
References: <20260824073057.1046630-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Dana Malachi <danamala@amazon.com>

Accept the relaxed ordering access flag during memory region
registration and forward it to the device firmware via the
admin command path.

Reviewed-by: Chen Brasch <cbrasch@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Dana Malachi <danamala@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
 drivers/infiniband/hw/efa/efa_com_cmd.c         | 2 ++
 drivers/infiniband/hw/efa/efa_com_cmd.h         | 1 +
 drivers/infiniband/hw/efa/efa_verbs.c           | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index ab830764e3b4..30a38e633bfd 100644
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
@@ -1203,6 +1204,7 @@ struct efa_admin_modify_event_counter_resp {
 
 /* reg_mr_cmd */
 #define EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT_MASK      GENMASK(5, 0)
+#define EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE_MASK   BIT(6)
 #define EFA_ADMIN_REG_MR_CMD_MEM_ADDR_PHY_MODE_EN_MASK      BIT(7)
 #define EFA_ADMIN_REG_MR_CMD_LOCAL_WRITE_ENABLE_MASK        BIT(0)
 #define EFA_ADMIN_REG_MR_CMD_REMOTE_WRITE_ENABLE_MASK       BIT(1)
@@ -1231,7 +1233,6 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
-#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_SHIFT 10
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
index 635687275350..9e4435401a4c 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1679,6 +1679,7 @@ static int efa_register_mr(struct ib_pd *ibpd, struct efa_mr *mr, u64 start,
 	params.permissions.local_write = !!(access_flags & IB_ACCESS_LOCAL_WRITE);
 	params.permissions.remote_write = !!(access_flags & IB_ACCESS_REMOTE_WRITE);
 	params.permissions.remote_read = !!(access_flags & IB_ACCESS_REMOTE_READ);
+	params.relaxed_ordering = !!(access_flags & IB_ACCESS_RELAXED_ORDERING);
 
 	pg_sz = ib_umem_find_best_pgsz(mr->umem,
 				       dev->dev_attr.page_size_cap,
-- 
2.50.1

