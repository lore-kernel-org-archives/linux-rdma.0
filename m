Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C0C4C10FD;
	Tue, 22 Sep 2026 09:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071139; cv=fail; b=jbye6+L8+dFRxfpUu1pdaiyf837LKi0kTnTIap5T9Ji/LyVAWRan//G0Q1tnhbPBdcmuQc53gYAZH5bErkt/mcKmrFkHqaYxLd8aOcLj/K3CcNzSj9o/BFw3KarU9VOHFm+scRI1Y0IXOXd7qYmR+qS+IPI6lriTLn1kWDmXiKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071139; c=relaxed/simple;
	bh=Oq3QnZizp1Toyc8gug2EegdwVVURfhgqqJQ4LHXaAbY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pooKVrz7rhKPJJN3hKmSY+FBWGWu6CJRE5ONE4iQjM3U0UlS5aP6sp5GueAYx5pb2KfDSszDYMWQ3ZwM50nAERsdJILslJn2lC1VSaxrEDyzVftan5DyxHAgtUgg6VnC3hv2eO5Ttwjl5M0KwlK8fRXalDllM/S4BWLnSn/4hA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ka7GMgxn; arc=fail smtp.client-ip=52.101.61.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ka7GMgxn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfiobtFbHJdJVcuy89Ql5zBeWIIylUncNCca6Ly87EXTrwGaliYUewOHsZrj1AYKjYbtJ7qc7bBuRMD74kXJ6PkP/FoImYdH+BOVXIn8Er0TzdjRMcRlAa/5473ha8HPE5NCLmdsIPLpRm5J+b5VwO6i7dvkRr4gEPkYkpbxgRiJDPX/rsBViz9Ow1G4tGuNfFOYoKW+5O/kJ5aC5dXlfhttgYwaXeIZ0WRrCkh3N3+rjA0CLE7wFmXnDDV/vt9tMsZlL7a0iAU4exdcyV/hN/LytPkpYU2FUc3/Ma6V4e48yaPUK+g0MGTj4alPJ9mlOHj5qTNgF1BxLwgQG+ItoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G02q9w+WkgT8jDntE5RrUHlvlWJkfGFog4GaGfAgwoY=;
 b=gDwpdGnXisGKkOEAeCX0jY2AIEsJOBpgutgFK+ERrVjTuGWoF8hROYeGnAzZ773nxYdmzBQSv+e9evIuMCqW1850BAqoHlc5sehVM7mbjBiPLRudGBWt6yyrA0+FG8kxNuOK6dB3BZpdIlMjusPT/Wttrc6haAErfApSBhtTxAGsC36QXrKuByikxWU8RDJxViEHTnI4WWddEgU9m00355WNLK6xDpO+WSCT5fpsEsPcXMDW9f/fDkmc1Ziza04JjgjzP6KpEfaAK06ZyY+ZWOBLrcGSbrngqfdkRUSPv+DqX+9H0Drtx9eeQNqtq5brAGEi6JRhQ2b86mKMP06TXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G02q9w+WkgT8jDntE5RrUHlvlWJkfGFog4GaGfAgwoY=;
 b=Ka7GMgxnmCUZ44eN7rrDw9Ufq8Skxbl2GrOpg3sqgFdhDOVFgJmwnCi7+PSLnM+oZOSC+2MwDgH2NTcnC+FYwKAbOJ7o14+kup+RO/hGvbh2d4jpZEEqnIUIXC+DnlJtQlsSpllfbSecVLyG/GLgysSimcAbYJunSVuzuNaSVOE=
Received: from SJ0PR03CA0085.namprd03.prod.outlook.com (2603:10b6:a03:331::30)
 by SJ1PR12MB6196.namprd12.prod.outlook.com (2603:10b6:a03:456::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 22 Sep
 2026 09:58:39 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:331:cafe::ab) by SJ0PR03CA0085.outlook.office365.com
 (2603:10b6:a03:331::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 09:58:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 09:58:39 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:58:38 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 04:58:34 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v2 1/5] net: ionic: Fetch qid allocation and SRQ capability from firmware
Date: Tue, 22 Sep 2026 15:27:20 +0530
Message-ID: <20260922095724.3683011-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|SJ1PR12MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 840dce4d-753a-4a91-a488-08df189013bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|82310400026|1800799024|18002099003|22082099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	1I+bmkVpQnx1ecqE7m2N5Cm0kujsuvYDNo+3OZCKKy76N+TuhPuguiPslxC8OzS8jpPeSoec0CGgcA7sn+Q7XNHTtAn+k1bCOGRLUnrGU/IZO7G30N2TYBTITAARF3kT4tY/g98S3XByZPtjImzX57a6OIKK9s05s9XkTzAW1OesHAzFkZ9Tq1E4OaAeg8o4cRKfqXds9Oc9deIH6JA425q7g2x/mE8FAjTK1UU54b7umS3oaMsGA6nZaxfUF36xwykF7OdKuHbVH6jLLZj4Uyw+cz3uEm2XR7GPPSCcKhMl6Jl6NMT5x1i+CKFehcZFKtdTMps+jLHqJRo3G7+YzyYoLEr4Czxcaw5Nn4Mq9en9SSQLmYvPi0KIXirX2MD2b1ge5zy3+vF/89D8jSnR+NTNdXksg6xLT9QDJcwqbwLg6mi2g1hVDp1lZHwCsYuTpYv7kDvC3gCdePL851NL9V7nqZatkrz4jhWlwcgl1kEPtYkrCgz1W6W3H1w0mgJOjwJDRtB25ur1LwQYXMDFF4GTdpbbPSqF5FfML4nsZ+2ZlziYi9ftOlJruj8OPCI/Ll6U9wp02G/3Qh2XaAr4VcfO83o5bh0epu7Mw55T6zeQ4ZVQ4I8qZxmOc4XjBtO9J5H8nM9MmIzVad/2zgbU8N7AQ4bkJX/7+ghXynDXF1Oj46Rbk2a1hgcXi+SSP67/1lFurD4MQ90qpQeT+lOteQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(82310400026)(1800799024)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+sQW3hEhmWqdl8R70LACV89c15DeNByzpchq2bOJ/JwOU1ahkfJLphKjCkqUmZE3czDXTAh5HwxPUqW4LY+uQMEWq7C+4gVnMWN7rAi3nh5M+l+AG1thP0eSMIVGmfwg79SSPj1MpsA84/TxmAn30z7m7x/TMI4RoZsPX5NkKKaSTs5LN3+AnatcU1CLMs2xxvq010HGONCgwKjwapqTeJ5cHAoVGvNCqmNPCXKdP8mc2riTwJp7eUv639fn8128zuI+2tkhBza1on/qy0nL6zDDPHMyDQpLKLn+x7HIAPXZkTXzercndQYki1uLwFAOZgi2Bt+RVSz84478/WdXwHnkj6ptTaNYkAZq12Fk7/Hl2gNPGEDwowAUlqEsW7E3ad3wRh2O9CLWloTvMh+poXy6OAKkEVajPGHB+m4UZT6YZe9hTLdGRugFEx8rtjrR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:58:39.4194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 840dce4d-753a-4a91-a488-08df189013bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6196

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

