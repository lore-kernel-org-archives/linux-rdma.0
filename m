Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011048.outbound.protection.outlook.com [52.101.52.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3A3E3DB8;
	Wed, 30 Sep 2026 09:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760252; cv=fail; b=HjCzIYV1rLZqXe7w+T/d59bdE1DRBSz1vdRDSGL0tCJKmpcVcWBzQkHOFQg5xIMHdiatYKPgk132I88vwNF0GgTwGWUiibh0OlnUfJWWErcRgT/pDfqjKvq+rCzGnGKKwqlTwoDZ1eJHsDvNdeq1p6JYmxFWVW+iPg9fSJdD7JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760252; c=relaxed/simple;
	bh=Ax4cWwD8fXsVKYSUD9zpjsc2pNGES0dAW4DROMlsgSU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Md8S2d7HdAvz/f1qs4Ig5Ke1nsCkDfBP91KEjWWdw2PXKCzABh5fTMFxo9R9Z/dDxVsdJXKbqmSUHgeYiXI727FY/IXWkRIec/+iNrYVx7Yb/KrM0y4ZRtZsQIZVVgvn+CQ4HMp2UTfNIsH5G0YtBb5Q6uJpOyF9CSphd6+rROs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fWtQA098; arc=fail smtp.client-ip=52.101.52.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fWtQA098"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b8wy30h7v7G6i+qBixsxbMpIoXqxUSeeMPPVPSTQi6j2xu6tVIgh9HnGsARH2bR11tmR5acgEQS8sflQBgcNZEzOu4nExLFa5QXc0UL0CEbTSea91UKguJAvFcJmFwtMOBJjcoeEDE0X2yeokLNAFnRKuxl8axuvVGeun3fClfzi/iZSQE+Dj7eb5s+/ypuFXCtb6qC/HO8zmvyQR5X4/22Zh2uUWFrbZN60AZPd65MSKdZM2+I1FAZvjffOtdxYxp1gnE4bD64wLnjwizLalesppgR5NTcCqe063XMglY7FNW6u+tEwkPpD87GWcdq+yfHX4bZlomnV/GmihFDkuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQOl11d3kvdeSAELIMiTDvh5hBH0f4SAk9IjriaTRts=;
 b=oBJF9MSqvdz7j1Ahn2gJ36AsgUCRkAsjYZla1uB3vna1igfwhMqfLaCgcXYwTK8MGMzAA4suOwPIEAJHgDFx1oDxFN+YvAwRBehGRjnq0FEBdFeIm9sxJMFMXqAQ+g/8Z/Iqvyw6DuALYg8TcIZ1r/Vy0AAZ54iF0FZCc0zI/ynOs1X5EZA2d3eZOCJelHA69P4VIZFZtLAp0e5Qc9Wp7ALLieKbEKqVj+rRhPmkr4wZ/4X90VjL8v11h5duR26ikjavGPk3kJAKE/2SF0rzMXkVGKcPvMPys4+bOWD2DaXenrzNph4mcjmsF9Kv8DALDTj4nqMwc0Aqrn/qrVK0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQOl11d3kvdeSAELIMiTDvh5hBH0f4SAk9IjriaTRts=;
 b=fWtQA098ZTKWf3SPxmjI1qGYU22nGAezkiOyFB7tP2Qg3wdAUN/+j9hByGmJIUMV91drNMNa9wfY5W7iP3VWhmm/pswKLPzSqnVLNa4CQzuSgqNkyeWcg0Ncnot8wNoLemrNDgYvaWDDZ5e1gie61Vr6f1wvaPMQ5FCqY7Ao6u0=
Received: from CY5P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:ed::12)
 by CH1PR12MB9671.namprd12.prod.outlook.com (2603:10b6:610:2b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Wed, 30 Sep
 2026 09:22:00 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:930:ed:cafe::7e) by CY5P220CA0001.outlook.office365.com
 (2603:10b6:930:ed::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 09:21:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 09:21:59 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:35 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:34 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 04:21:31 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 1/5] net: ionic: Fetch qid allocation and SRQ capability from firmware
Date: Wed, 30 Sep 2026 14:51:07 +0530
Message-ID: <20260930092111.3176738-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|CH1PR12MB9671:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bb8dd26-2e4e-438c-9e74-08df1ed447da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|36860700016|82310400026|22082099003|18002099003|3023799007|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	uiBNi1LZDpyiRZ+lVVz9P/nTcIewOePODmhsInQEHlMv3j8f3+pnRxvGOOekOOE70MRC293wh8zwr4m5nc6WVYDuzZNK1A99+y5blT8xIpFxBEpj0gFf3zTb9hm+ahLgZHW4dgt/WM9sFJS2qiqlNyKxM9Iga4hIzkMaS/U2rknsr1nprXYjw0EnrPFXNnpIKXCQsUEAT/ohyfmUJtL9K5T4GDvJvOHBIt6wG8SIK82KdAaaxSxDSNVqvaQchIZyfm9lL84rfnedG4tWyqsqX4jF/4Oujtr0Rfx+UuSDfSypaLcHHoZCrSimKF94KZTAhwQfPbfzbpM0n8Oi1FWvD7BhiiY4U8ryLCCOUwjbYZ052q3RssQMC6AkdqY/Dz+A9oE+UDb297Amg8859ZRQgZmaQMsQ9046tWAwi5Di4lhyWb/GmGc+9CZhte1VvIYmHYmsrjyt2leOZMB5t5ybB2MZrM4CdhxM5WZE5aSo8r94JFmO096ESBNN7U9trcgGrXSNv0AD2w54AEluAdgRR+kCJdTEzOY1lYTcyboyrfl35JuEaNcUFzQx2ByE2v90UVJH8Iq0YHcdm13zpsR9JArA6rxOCAm9Nkz/fl4Ek1dHLvnX/n1F4nJhLSLlmgN6CQ4AMhp8EjoLIWCYvg1isnURzMP082cy6jFyUT5Ti9skUQnL1CbBBD1r6Cq/EA7W+bvL7ROewI6/fg3nqunsgw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(36860700016)(82310400026)(22082099003)(18002099003)(3023799007)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BZ71k4MudwcFR36Iab/59HUtcVlug3MP3/z+2nb+xSq7lb0ms8Mt6W+ygPGKv91gWe/tR91+lF7Z6+5gNEnY7TgXFUml0IVzkfy/e/lt9TD4EpKvKRtRpqpXiKf94xOJegsARUBAUhaOFlfZ8KPS/PVLZProIOvxiTTU1ReMH3w6tcc+PPfIy9Lrs3gTvDYV4XlUr9ZI38dhvc2KISVf9m0tcQ8FioJRLQXIRb4NbPX7oF1n7CMTmAa1RSi8log9P0M75/9Nog0Bw3WcNPglOf1MjtRUXu9dgBIzmnXUhTKNeut0+OUjnBDNUGON7LwmhcIGd89TANTucIP3iQh2IMXVhD5VGWJngOjgtrHqzyePMzZlB9XcYyj19W2xi0CrUPw+DMV8UexHP0iKYADXdapxRP4gJZbT3fnjSce9FJCwRwtE22dt+rlPbZdnz9W1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:21:59.6943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb8dd26-2e4e-438c-9e74-08df1ed447da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9671

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

