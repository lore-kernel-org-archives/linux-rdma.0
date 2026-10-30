Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793348669;
	b=oXKWVqvJDMk/VjGKp/Z6qGUi0p/hSfGvbCtHu5UXoPjW6ot7tFidqJupg7+XS9sUBqFX
	 5BtfAta9DkKPsAeAFhLwzhUGXzV3VGaNBU962VDyfeF/3XD0mQ5MV5APkuf2xfeWI+g7x
	 s5nb6vbSlPEdaK/Y8YwqYT0juGaXYX/Ml7Lq16zGXlwTbTlRHJwLf+DYk/CmmOPy50rq1
	 KwE6/kUUo/dy8jL2C3yVNMErZT37FCEimFglnYeEZPFz1rt3QIij3udIAnmdQGzMP705Z
	 kVK8XXO/SLXfw9D7vcOEYP706sQchkM4dRTc1OBHBe40nXtzD+m3/McsvCat6ow5AVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348669;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=0TaKJOz3hHb+ads9VgIrK7dJH+c0YO+jzH2n3BpV6c8=;
	b=2KdZ/y+iF7xbWkqZ4q8AQ8YMKCdwfh11NGftN+FyHaBPk3rXKLceJ/Fj46/CbZQYcLtz
	 2uqDUxAMYNrOZrx+nTuqVVJ4aQOviy8gB85Q4yE2zex8E0MIOjtLCex56ophl3xUKid7I
	 0PyDv1AqpvEa2eQYh2g1VYoD3kCB6468rb1dgIOfkwC8fZkuzuLU5SLhDlHmICd+mXwN2
	 4CpXD7VsB2ne+dKka0X78tt/QmA44ArA+7pXMWukXIQHJRSlqmn7R8mN20DIxTFsNuiIu
	 61P+c03OI78L/rsyD218hIvyr15HpUz0uFmo9oNUpIu2meRURLQMeqhJmuv6tpJivzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=yOCL8dzp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.16
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722EC606A321;
	Fri, 30 Oct 2026 08:24:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 722EC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=yOCL8dzp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OcSRkDOjnlkB2zQNFj9ggTpXwKZTBLQ8samM6Aq4QygNncrN/O9y0vM/61Zffy3fgzV5ZhESycT+4qI3hs1taE4OCVuJ4luUMQgb8zmreo0nNAzPwPZ45LPhhzcg8r+RXIivLSGqKORyw2Tp5n7m5tNmRJVIfzrzq5DizPx/wmiPflWJEjM1AwCyAJeV+a2nL6P6dNfB2Vx5lW7ZAPbe6brm3XbhYWHrdW1IcjGSs5RvcmcElCnU70j2JSZSpa+TUdL6p4KZ6/R7HVIFrsS9OGdQKpm6gMvpTw4lV0GuJNzrXtx+o1iG6uf+Ud01CJq3Xviv+Ic0v77rT1329RROgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TaKJOz3hHb+ads9VgIrK7dJH+c0YO+jzH2n3BpV6c8=;
 b=gfIbGGxxC4Xal4e5czUqgZCvcyHf1TF/Dp5uS/8Qrx6IawhMWzbHBuK/IJ+gMpppaZZw5jmdC+/lw1JPV34QiprlJE4vzC42Ll628SvS+JyVxO5Q1beqpjuwDu5OLO9rD7CmUsJ3GzZVOoDINDMAy++aUdNbn+FSQeXrasCF2lbMRikmdXv1Mma1T56iiG0xa05orqCkCOsfCby7b571gxt5O3KDWisDBI8P78XSl/bHbey4zWrWbeuIDusNyKI0bUKs8I7iL6UJbTr285T8UjeneDaIp+FdbZ2r0VTYWgR/Y3G7t6zXOmJ3vsnqciGEd1QBTUY6S+lDYZVTEfTgwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TaKJOz3hHb+ads9VgIrK7dJH+c0YO+jzH2n3BpV6c8=;
 b=yOCL8dzpaaeKw1fhvxHlq+5bLMUSGw5aXe653+AHwyLwrSfWWJUoDqnVjZ+/vQ7/h00tFvTKtdoyPXSVbxvnPCbBpH+q3OSOXYYENeYurRIAPY3GjCAUHTt9+qj7GyQUjWrVytZN8JAZo35JHZF1X9dcCgRi6SSeYQs6IDcVLsU=
Received: from BY5PR04CA0009.namprd04.prod.outlook.com (2603:10b6:a03:1d0::19)
 by IA0PR12MB8228.namprd12.prod.outlook.com (2603:10b6:208:402::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 08:24:22 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::2b) by BY5PR04CA0009.outlook.office365.com
 (2603:10b6:a03:1d0::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.9 via Frontend Transport; Fri, 30
 Oct 2026 08:24:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Fri, 30 Oct 2026 08:24:22 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 30 Oct
 2026 03:24:21 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Fri, 30 Oct 2026 03:24:19 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>, Keith Lucas <keith.lucas@oracle.com>,
	<stable@vger.kernel.org>
Subject: [for-next 1/1] RDMA/ionic: Use a linear QID space when udma_shift is zero
Date: Fri, 30 Oct 2026 13:54:02 +0530
Message-ID: <20261030082402.841751-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|IA0PR12MB8228:EE_
X-MS-Office365-Filtering-Correlation-Id: b72b9629-c5f0-49e0-4c1b-08df365f3389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|18002099003|13003099007|56012099006|11063799006|261021135927099003|10067099003|261021123027099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	f9P/CYY5CiJJkCeANCrYPiM1G5AinANM9ix4ALxeiypvmFo4FJ173Qu5wWJgUibv6HcLwNHpiyiEMn9HPpWsw0YNv777ihSnDxxU0TjxtSdY4uTfyOP4JARnSTiXb+1USkuC4Me8ig0ES6/aGpWiWFFBxCsT1does+foSIZYBka0AuV9MMrMa7zZXDhD83gbDYpFMNATE9Rc7ok/2fh0xI8rZH65fctrekChA6XXR7sUcK5AW1M0uzmW8aqr9A1OCtAhplFcZcR9AzS4suZ901BewMMjt6kZDQlH57wDwEwUqPuhuX3jP0eJpfzricXmEADkVqzxW6AqjJIciUIGIJ4r/BV9nfqV02wvJJW6um8YZQXLOE7ox60f2PcSuwU7j0iOX/rnNKVDZqigLB8q79UcWb92rhXc34F9643dg0o/4SP3hiwWDdOwCzIN0zg5zEgl66qunA6xSK9dZjjJqEjynwjRaY3Yzho/8fxQrBs+OuAZf9kuDvLE12O8n7b7hySW7Cd3BK0sVQEA8wnL5upvgZysvrR+AYRNH0XVO+soQEiTFhCEMj4Z1m2PSnNcQ2BrNFGIHx1o2HEPm3uIyC61xSv7MHY9GrkrBQHiF8Cp8sqdQtX7LdczMLs7ppBvXSTI0/nHLXem1jDVCDEujVe7JGsi0RB1G+ye98e4nEQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(18002099003)(13003099007)(56012099006)(11063799006)(261021135927099003)(10067099003)(261021123027099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zg0R3bU7CFCbLqAh7t861gMf3qdkrrXwv8AdVSwi0z8lX93QCb0OkV80FwsXQH0BHLL4bW1N1yWFzA7t5S6F0RxuQYg2PsOTqq4AhZr9eFW0x4PFiLYU4H3UA1umkIRUoe0SYtJNifZ0rIX+ZSuwqcR655GzQ6CdPdCU2kx+CHOQ4vXSHpq9F0XcZRVx3ZrfFXoG+oxh8ZpLLzcD9qQY/2drq88LHrAxY0ItsfDmn3Ex3PLdsQxj3LEMFTPgE1wjz/Zr/yoxZViuD+CYCrRu66OwBM70NYWFauas0xYpeyBGUjDY4SrvDn44Pv/mgJnf03AORPR1Y6kn5V3UdBZn8ArO9VXoCzjbohlDO2C7FpT2UwagMcjWxIxWPgnVzUHgmOIAsi3yon6ktcIhqWe4GzAh2682lnPctlso1tt9mXcQuLP+BfgfUQmLSZ4Dr7qa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 08:24:22.3031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b72b9629-c5f0-49e0-4c1b-08df365f3389
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8228

Firmware reports udma_shift as the log2 of the number of queues in
a queue group. A value of zero means the queues are not striped
across two UDMAs, so the QID space is linear and the device has one UDMA.

The interleaved bitid/qid transform treats bit 0 as the UDMA selector
when the group shift is zero. QID 1 then becomes bitid
1 << half_qid_shift, and freeing that QID releases the wrong allocator
index. Skip the transform and select one UDMA so QP and CQ allocation
uses the QID directly.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Reported-by: Keith Lucas <keith.lucas@oracle.com>
Link: https://lore.kernel.org/r/20261021161651.4020222-1-haakon.bugge@oracle.com
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c |  2 +-
 drivers/infiniband/hw/ionic/ionic_res.h     | 23 ++++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
index 66cee57442e7..a3ee86b56037 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -84,7 +84,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	cfg->cq_qtype = ident->rdma.cq_qtype.qtype;
 	cfg->eq_qtype = ident->rdma.eq_qtype.qtype;
 	cfg->udma_qgrp_shift = ident->rdma.udma_shift;
-	cfg->udma_count = 2;
+	cfg->udma_count = cfg->udma_qgrp_shift ? 2 : 1;
 
 	cfg->max_stride = ident->rdma.max_stride;
 	cfg->rcq_sign_bit = ident->rdma.rcq_sign_bit;
diff --git a/drivers/infiniband/hw/ionic/ionic_res.h b/drivers/infiniband/hw/ionic/ionic_res.h
index 46c8c584bd9a..c480865dced5 100644
--- a/drivers/infiniband/hw/ionic/ionic_res.h
+++ b/drivers/infiniband/hw/ionic/ionic_res.h
@@ -125,10 +125,14 @@ static inline void ionic_resid_put(struct ionic_resid_bits *resid, int id)
 static inline u32 ionic_bitid_to_qid(u32 bitid, u8 qgrp_shift,
 				     u8 half_qid_shift)
 {
-	u32 udma_bit =
-		(bitid & BIT(half_qid_shift)) >> (half_qid_shift - qgrp_shift);
-	u32 grp_bits = (bitid & GENMASK(half_qid_shift - 1, qgrp_shift)) << 1;
-	u32 idx_bits = bitid & (BIT(qgrp_shift) - 1);
+	u32 udma_bit, grp_bits, idx_bits;
+
+	if (!qgrp_shift)
+		return bitid;
+
+	udma_bit = (bitid & BIT(half_qid_shift)) >> (half_qid_shift - qgrp_shift);
+	grp_bits = (bitid & GENMASK(half_qid_shift - 1, qgrp_shift)) << 1;
+	idx_bits = bitid & (BIT(qgrp_shift) - 1);
 
 	return grp_bits | udma_bit | idx_bits;
 }
@@ -145,9 +149,14 @@ static inline u32 ionic_bitid_to_qid(u32 bitid, u8 qgrp_shift,
  */
 static inline u32 ionic_qid_to_bitid(u32 qid, u8 qgrp_shift, u8 half_qid_shift)
 {
-	u32 udma_bit = (qid & BIT(qgrp_shift)) << (half_qid_shift - qgrp_shift);
-	u32 grp_bits = (qid & GENMASK(half_qid_shift, qgrp_shift + 1)) >> 1;
-	u32 idx_bits = qid & (BIT(qgrp_shift) - 1);
+	u32 udma_bit, grp_bits, idx_bits;
+
+	if (!qgrp_shift)
+		return qid;
+
+	udma_bit = (qid & BIT(qgrp_shift)) << (half_qid_shift - qgrp_shift);
+	grp_bits = (qid & GENMASK(half_qid_shift, qgrp_shift + 1)) >> 1;
+	idx_bits = qid & (BIT(qgrp_shift) - 1);
 
 	return udma_bit | grp_bits | idx_bits;
 }
-- 
2.43.0

