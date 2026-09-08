Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011016.outbound.protection.outlook.com [52.101.62.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310114B0499;
	Tue,  8 Sep 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858556; cv=fail; b=oUK6bPul/WAUEgiAvBd1bWZSgXw6rjdA4LkynQMGRGqWw2NfcpclZYXZkXEXO+386xhBIuZZPF43x4pbz6xBFKgJHRvbO7gVr1vPoRIz5GU/n33CZ+rXsQJ7sfcC7ia6a2Ka0T0FaVl/MZ99dVNoPGqJuyRSkXhdZsMZJkUOzBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858556; c=relaxed/simple;
	bh=Oq3QnZizp1Toyc8gug2EegdwVVURfhgqqJQ4LHXaAbY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aWL5jmEDum7ZM0a1gRP4XrpqI+w2dRY3Hg9ER9thCu2AA7jMN82xumDzB1cVJVlE+EpIIXUJT7lUUbwi9mRl2IhnrdMuSBF4VMBLe7RELqgZCTAPZSKs98DXDrvWxClCmTUeNMcdnnMlKhDoz2SBXiZ4BKAF7v2M9QJjDt5u2d8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2ruLFwmw; arc=fail smtp.client-ip=52.101.62.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2ruLFwmw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FfxnRI4TRLeIvXFJFg6Js3WTCt5R7OT7q9imVABgGtI9q2/4LKi3Z9YCJlmu8TiJ6ohyECStOlRS0oEEflQmWG3evFzsIDCl4aJ/d7O2VRcZq2lZpK7QzB+4EGVcDNipggFwlwrVOjQgrjo/NSYYqdfIcBiUpLwxyI/FuDtStsn2genpn/TEovAI+XQlfpJO8S9MErmzQ/ajjuVMON5Z4lp9aMqvMj4GW0Y3HyStuwlZOrgFZ26hdSGgO8DIBfpIbksWOcL4HXJHUkF2bz6EqlhxjTCxJHk4nSw8/agb1jdaPdUaJojbhjuLv0MwXfJSYcOgaI7IQgPmennTOmFEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G02q9w+WkgT8jDntE5RrUHlvlWJkfGFog4GaGfAgwoY=;
 b=FyCu4yTatbn4keQrbKgW3Sgz6xSeJ1cxdZIKlv2CWOdMDuM9cv5f3UvMiCZzCdx6DfteKs31LvXF1RynCZW/s9NJVVDaxRHJyCWrbl/Rm+4WNRpudDIoWkLATUOWuIRzDojSArVS2cAHV2CjJxnLK2A5CGSSoW/lKXdq9H9szN529sT/ZckxLyZhQ6zqVvHIpRuPcCXyt4YWRaEaH02Ho6NovRwVtcFPfaBWQheS8vgH85ivu6DQFu6pxWRXhqB1xGfozo7mol7Q6t6BjIdJ/z/mXh8i36u/1K0sfUwLXG1Lhd2fMxx0Doz5AKmpd6v/Y+halmEldCZSYU0ITuVVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G02q9w+WkgT8jDntE5RrUHlvlWJkfGFog4GaGfAgwoY=;
 b=2ruLFwmw7sxq9bE4cqfMdnXNCBbBfpKm4MhmA5dWkCKxI5ZneGHnfWiX18yuSS1etH53x9AxZwuQgfx/GdGkVWGxolLnHwhuIKuUJyso/6om/oYDEcNDoWSmRCnMwHPjEyFCPLp0cctuQuNKfo7REhQ1kSIY2VXccJOLlgIIfuU=
Received: from BN1PR13CA0001.namprd13.prod.outlook.com (2603:10b6:408:e2::6)
 by CC6PR12MB259526.namprd12.prod.outlook.com (2603:10b6:170:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 09:09:10 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:e2:cafe::17) by BN1PR13CA0001.outlook.office365.com
 (2603:10b6:408:e2::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 09:09:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 09:09:10 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 04:09:08 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 04:09:07 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 8 Sep 2026 04:09:03 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v1 1/5] net: ionic: Fetch qid allocation and SRQ capability from firmware
Date: Tue, 8 Sep 2026 14:37:57 +0530
Message-ID: <20260908090802.152142-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908090802.152142-1-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|CC6PR12MB259526:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e0a59e6-2c22-441e-2c05-08df0d88d81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|1800799024|82310400026|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Lj+AyouK2WF2yXNmTSgJJQZwVQA7wWc8R8PMGIATTpcKFlW/ltxprN0ig5IF6TqBr/chIYADxynyDB8zedrduCokSSDGBfIc6f11I/0ZnjXEeBN52Mx7FUP3awhEFIGbgKi4pI916NCaZ4O5LgJbYQNDERXw6s8pfdmW6Y+XoQ7je9NMxDGWCZIgy3lU8TUWBQUG6Edci7AoHvWdx7LrtFQgLa4KY8M42rd+96TSWj4VdL8Uv2r+qL4JnB6lj14qcHz2w4gi8LuYX/27mwA/p7hr6vqF9oC1P1gu5ka1KbYujgBFzWsqFT1q9P/rlr3cuTsjwGJDbg2o6+dm6wiKWKsVuBlyIe6ooZ4xLYtMvxShbXOdjAjXaqKMJiLv+L8GTPDt5JBqjE+sCI4vX+psaTqPg8ZumPz80O9z3TZyBgjZVx/sMSb4OQHkbiSu5XmKV7UMlLd8EIMexB9x5y8FM5ULb8xY32f1wNu19u/moklliDuDWV+kQWJ1Zo8R0K0Yx0KUe/C0qgiD5mNIQfq8nqntDzolIpYlcL6MAxHkXk+2Fl2lrh938BmjP/9yK8UGhgSGsPHOf03cI25Vz4hWmnmHXknpOca+Qv68Xtfr31tYgrQzy/fAfN/g/RcKZkYYz6zcuiheNEjKlC5KWAm9A3+ZaTvTgP78w9r87UFombcZeCaI5RsLOqxfeTAgNjBTXM163gC0HxPWJqnTzR+5/A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(1800799024)(82310400026)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8kUYyolPeCnLaQvfO909WIbQBjwF8htUyxRBqGvttJkLxLJlzDJ7IzILnZGxWvLQTYkqauhaI50fe8qLgY1MTHQlcr62ORjflLu8vXb2ImchiK0nhAiZqu4s8jfAEQKSS05UBxtCTBZbue/uPLz7M/LCmomrQNuKO7nlbJk0EGWNQKXNTNsrN7+UBUdUkYFneMogAuW8SNPNXn0B41q5TmUzxn5Hf4kskX99pz+lVL7V01vNyk9lekIHu9zDAeai/qVErY6abReg2yWM3QJ/xBRLRh2jHdpzKDAI4GS8HpbbT4IkTCPbDcGV6fXS9yaTRJ+inRa7TeckSbHWD0VdWKn4q3y4EcZcTOyE1ePG6MMxIHdZKZ2vC1FcNqst/wKClMe7o00L3URd49aNUJkJQVrnoW3OClnF21AxIfkagn5gfcsRvijM19aSow1D1CMY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 09:09:10.1936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0a59e6-2c22-441e-2c05-08df0d88d81d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CC6PR12MB259526

Read the qid allocation and SRQ capability from the RDMA LIF identity
reported by firmware.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 31 +++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 15f2bc3f4043..9bd5f7a29fc4 100644
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
+ * @udma_mask:     udma index
  * @rsvd2:         reserved byte(s)
  *
  * The same command struct is used to create an RDMA event queue, completion
@@ -2637,7 +2663,8 @@ struct ionic_rdma_queue_cmd {
 	u8     depth_log2;
 	u8     stride_log2;
 	__le64 dma_addr;
-	u8     rsvd2[40];
+	u8     udma_mask;
+	u8     rsvd2[39];
 };
 
 /******************************************************************
-- 
2.43.0

