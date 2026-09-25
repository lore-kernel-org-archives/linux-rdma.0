Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02557476040;
	Fri, 25 Sep 2026 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324921; cv=fail; b=XQaENkJYr2vXOiqZuGNgO/un1tbshnIg4KAoDG/e1zFIBUpkQaIRr7vgXjX7B9Pi5mLM2h9+mQtNNjzZKOE07nWnXBgHZsTAV/rBLIND+jjXmX5y+UwuxwHGKcLKyIuHMzH6CxoWOUfprI7SH986WLhlYCuOX31ACM4NxSjqMgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324921; c=relaxed/simple;
	bh=Ax4cWwD8fXsVKYSUD9zpjsc2pNGES0dAW4DROMlsgSU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pedk7ZJwKUcWnyNFFo0WpImglN6VjUByiCxtJLH0VdJV2F4tGds87QxF3vu+u4EmFy9UNhiHCrDvNbos3f7y/jUcOmLBreK2SZxev0U0YmpfgWa6wlS0KxAlxfVcDs486ynv3Q2D8LCB4xXQdHF99hLraeQWhj7kWVKPnQsRnW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OhRb9n/v; arc=fail smtp.client-ip=52.101.52.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OhRb9n/v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qhwv0y0tUngc49VeChgE6f0vymOPmCJtZ1QFrpWHfNeHFLWNPDk0YnvWrKL7SkqX8TFWjRZ7p/+njYEcw/rtiiCqYdyGO+HJ7Fshy6wVEFPdqYuKJJn3ieeCCTFAXec+rrm6/32x4DulLE6M7zcp1wuyTROvDt1pYfA4AcoNdPL+LQC4WFpEySALCHwpwMBTsHbIFsa22iZSjpr556Jx70XtRoacCpR/XnfGLlI6dxJsyR7xayt/gEs+O2YRHrwyJzlrr4k47tQklPbcPqnij6VvQjTxWqHa5wWHvbQpuw7lClzVDnYGreZeCImBnBwzGME9ON5Gqu/rlHYpDseo1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQOl11d3kvdeSAELIMiTDvh5hBH0f4SAk9IjriaTRts=;
 b=bw4oaFCjSVjQ7wkomz9dQsDJ9ws3AjQ3V/mc9lAqIfENBVh0Wpx6pU2tT2KNnK2EZ1yLTgkk611eTvZ8GofcpyLI8Mkc0la6KwdmZBg6AecnCIgeO5fEZjgsUxxA+08fzBMO8ynnC+HHhyEnW6dOXfwCZwQJ0atTwCtsV3NSjjvvP1H4czsu32Krb37XeFM97wxJ/yNHhqNyRQM+BQqkb9hWGKJvF7bZYYEP6gOeIllP0ZZ8z26km5czmc9DSLcmJq97Vt8cEOzKJwpu46idMM+vcQwMA+OD8n4E6jqyeaC6kQt5feRrANtmE0nUyDRtBTpuctcHKLC6BsFJ2Ov8iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQOl11d3kvdeSAELIMiTDvh5hBH0f4SAk9IjriaTRts=;
 b=OhRb9n/vfR57fALg5mOYOFNo7UU1rLJwzp7zwOhPye5u56HJ4VWCIn4OrsNJwxCc6/4I5/IA5np/y9Fs3hEBXkXDrePK674/+Zz8jmw75Wjo9UPLqI8Z1b2lmUpkDNoQx8SQn5QtLms4jqFynXbHW0rTvEjfKMEDbMEYyZt6OMc=
Received: from BN9PR03CA0125.namprd03.prod.outlook.com (2603:10b6:408:fe::10)
 by CY8PR12MB7146.namprd12.prod.outlook.com (2603:10b6:930:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Fri, 25 Sep
 2026 08:28:32 +0000
Received: from BN3PEPF00022BCF.namprd03.prod.outlook.com
 (2603:10b6:408:fe:cafe::3d) by BN9PR03CA0125.outlook.office365.com
 (2603:10b6:408:fe::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Fri,
 25 Sep 2026 08:28:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BCF.mail.protection.outlook.com (10.167.248.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 25 Sep 2026 08:28:31 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 03:28:30 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Fri, 25 Sep 2026 03:28:26 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v3 1/5] net: ionic: Fetch qid allocation and SRQ capability from firmware
Date: Fri, 25 Sep 2026 13:57:58 +0530
Message-ID: <20260925082802.2675902-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCF:EE_|CY8PR12MB7146:EE_
X-MS-Office365-Filtering-Correlation-Id: 95accbff-bcb5-439b-da4b-08df1adefb80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|36860700016|82310400026|10067099003|56012099006|11063799006|22082099003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	JJf95emRTIHeyScMK9ft8Ai3oAuYoU4fX0bTKkwj/jXxamaFuSAbDG3EwnhZ9OO3YjGWFrJ4n/+XDiSIi+pdohNZTb7aV1vDQuh4TsdNGO9oJj0EjdraQeNfITubwRaI3bpmzSCVLgVBSqX8UZJV5zKrS+20AcvrOJ2UxgET6r4nVzx5FRZYtKiHtHmr8M1LiFOSn2e7CifCiVM/4H0XSgrF0ZkNs4teYXWpCq5JtA5kmMPX0o69pgbWdX3RL+Z5M2bspShdRqwASQE/85eIehF5RA4G/x8TQa7wUIV7zJo3+9afHc3WpVtbi3eQPHJeQPUn8dTVmNvnrx+65jJMvNj5cJSyxHB/OLMH/6sYCJQSpI8RjvrgQNDyDcg66KgniWAMXFPAulq8qqGlzIkZ3+G4NH6VcGlx4aBqc2NtcIDRXIUkU13BvFAoutQaGcY9GH7QBJDcqiYPv5M41jy+G/oEJNED9bEswqr/1sZwKdgxfuLybuPn69nALIUCEykJHl7DpjG73vCR9AH8eiJS5YVmgSsS+663VKB8HMUxDAcBd7lpMw+uyc3ElznfAYmdNmZ01/Wh2LSUbUcBpZ0pXyax3a0W6MLTG/d7jOB1uE2phn+xKAcuZlsZGBxHYDQLMUxjTijkAzE+mzvzBjn4s32lPoWKl00anIUm+mwlZD2kitk84WFF1pghIKWcrJXkY908ZVcZ9GqJ2j9rQ2SJrQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(36860700016)(82310400026)(10067099003)(56012099006)(11063799006)(22082099003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nGjoC2OQZFST1konw8mnPfy+FvakyCB92Al5w6GvS2QZtPDBM6Zqxm6Ow1rbJRhAaLfKPLOZWbJMbbwZqrzJJYhV5CjAYmCZxUAXPOHDuw4si2xnr/NCaoAVM/V9fDFDUi20pMvS/6jiTq0O4Qrkz/DZg4OxPrjdjIaIPONGW6IuHie9lalXddiYugorvQZnVeeJ4yhInY8OIIe6pSX6ospphf6iF0Ahmg4WJYSVVAojeopD3rnV1Pqes7wh3+ClXwB/Hc4e+g/wByfWXR5Abd1d46m/Nn3D3Bndo5z/7NNcRKoYhv/cz46LPNAg2v37w1kiKysNOO/lWTzhQDcK/TnQOV1N0uhody33oUokfUrcQVjaqRiAGuWapz/MU5iaVjy3asRAJQOq52DzkhGbivZIfzXMWeX1wVMh4la+SX721DJ9BWfweHyr4PGZdFO2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 08:28:31.4069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95accbff-bcb5-439b-da4b-08df1adefb80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7146

Read the qid allocation and SRQ capability from the RDMA LIF identity
reported by firmware.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 31 +++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 15f2bc3f4043..e911fad545d6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -7,6 +7,7 @@
 #define IONIC_DEV_INFO_SIGNATURE		0x44455649      /* 'DEVI' */
 #define IONIC_DEV_INFO_VERSION			1
 #define IONIC_IFNAMSIZ				16
+#define IONIC_CREATE_CQ_CMD_V2_MAGIC		-1
 
 /*
  * enum ionic_cmd_opcode - Device commands
@@ -513,6 +514,23 @@ enum ionic_lif_rdma_cap_stats {
 	IONIC_LIF_RDMA_STAT_QP = BIT(1),
 };
 
+/**
+ * enum ionic_lif_rdma_alloc_qid - RDMA QID allocation capability
+ *
+ * Bitmask of RDMA queue types for which firmware can automatically
+ * allocate queue IDs. When a bit is set, the driver can request the
+ * firmware to allocate QIDs for that queue type during creation.
+ *
+ * @IONIC_LIF_RDMA_ALLOC_QID_CQ:  Firmware can allocate QIDs for
+ *                                Completion Queues
+ * @IONIC_LIF_RDMA_ALLOC_QID_SRQ: Firmware can allocate QIDs for
+ *                                Shared Receive Queues
+ */
+enum ionic_lif_rdma_alloc_qid {
+	IONIC_LIF_RDMA_ALLOC_QID_CQ = BIT(0),
+	IONIC_LIF_RDMA_ALLOC_QID_SRQ = BIT(1),
+};
+
 /**
  * struct ionic_lif_identity - LIF identity information (type-specific)
  *
@@ -557,6 +575,10 @@ enum ionic_lif_rdma_cap_stats {
  *	                       (enum ionic_lif_rdma_cap_stats)
  *	@rdma.rsvd:            Reserved byte
  *	@rdma.rcq_sign_bit:    RCQ sign bit
+ *	@rdma.srq_qtype:       RDMA Shared Receive Qtype
+ *	@rdma.rsvd2:           Reserved byte(s)
+ *	@rdma.alloc_qid_cap:   RDMA queue type QID allocation capability
+ *	                       (bitmask of enum ionic_lif_rdma_alloc_qid)
  *	@rdma.rsvd1:           Reserved byte(s)
  * @words:               word access to struct contents
  */
@@ -604,7 +626,10 @@ union ionic_lif_identity {
 			__le16 stats_type;
 			u8 rsvd;
 			u8 rcq_sign_bit;
-			u8 rsvd1[160];
+			struct ionic_lif_logical_qtype srq_qtype;
+			u8 rsvd2[5];
+			u8 alloc_qid_cap;
+			u8 rsvd1[142];
 		} __packed rdma;
 	} __packed;
 	__le32 words[478];
@@ -2608,6 +2633,7 @@ struct ionic_rdma_reset_cmd {
  * @depth_log2:    log base two of queue depth
  * @stride_log2:   log base two of queue stride
  * @dma_addr:      address of the queue memory
+ * @udma_idx:      udma index
  * @rsvd2:         reserved byte(s)
  *
  * The same command struct is used to create an RDMA event queue, completion
@@ -2637,7 +2663,8 @@ struct ionic_rdma_queue_cmd {
 	u8     depth_log2;
 	u8     stride_log2;
 	__le64 dma_addr;
-	u8     rsvd2[40];
+	u8     udma_idx;
+	u8     rsvd2[39];
 };
 
 /******************************************************************
-- 
2.43.0

