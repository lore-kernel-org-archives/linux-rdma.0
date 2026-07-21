Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010043.outbound.protection.outlook.com [40.93.198.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9A4921BC;
	Tue, 21 Jul 2026 12:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784635868; cv=fail; b=T2uMjX7SBfisgDYnqEZPeJqQe/Rij563psUznJf9Waw1xXJr5xBDYZCfnCNvBvX/LYOhnfwMMRJxXk+jCePeSw2CC9aDdmYNkIM4VRHuuztnEZgUvRrllOoLwOyvp6eF+CbF6fqHbV6FEZ8/gdSOPJ0RAiRhqnh/G9nrORR3orE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784635868; c=relaxed/simple;
	bh=as4oW+uyDR+Lqfa2014fJuPaoejgN/AR/3FRddsT4t0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JglwRRoJfZwGo6AJvLk4DcCRmZW4Au6MYFH/Ig57zq7+bGpeaORlW0IbPdzlo5KPXXLmM+v/FjQ4G95z6mzEc47U1PcvK0mSwDVyB/lkFaVZuSUnGCu8IBJvcAkEUTu9ytguxeaCMaUmVN0JIAPuch95cD/twy0Q+ao5ZREcNAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pLuDEGMp; arc=fail smtp.client-ip=40.93.198.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pLuDEGMp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nt+wASbmrITp72xQBgL5BkRixu3KCsnqHw4jjF2X9rcArvwY4tKE40J1pcEshewIncWtTW+xtzuFEApJF9WuAIHh8FFAv9pClenzpPihwu/QXbNJwL0yHSESlsJ2MBJ294V87a7bCnnY9jUUnjkaVAYVn7Pqyf5APkW6qehj2dBzyWpUbveFv4PWN7/9AJe6q3v2fY4hbZJE0GvagmK9PO08Ug32iyiz5T3fkZ32M8/XAM213Z5u48++OdLNpoJnHscayB6gPz5ZwJX+5OFcU5pDyq8pC3Zlo5oKQYWF4fEEYcJK2YXZ3b11XL+Jxl4EHAAwV/mYdl6PFtiFYD4ZPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJ4m/XyJGhFs2T/e8fR4sdjYwH/28u+sWH091FmsZ+o=;
 b=C7mH5obXfbnfBB+mw3T5ZD8UNGyHnLB5jC3FQEpoY4GAESJEX/AnO5VA+iYbUPX4Ypaqbk+N08w5PMqR39K+uW5gB9bkDKjJoK8QHdAPhzOhwwjkmp1ns5p8X+SJYIJF7h8oKeqzJT5SEXr92WzBabtZtNcCZb6ICCbwlOXaJMEVP+6jm7HF/mo60ciYUUBwJ0UllR2PACQmA8osx1TxI/R64vuagqYY84MkqmV1itwqDAljrjfNJPMbmB69XICOSV+zdTnkgvOmuDguVQ7B3QoZCktJWP6U42tkY1hVDs2xEOZb8Bp/AaYhIi1DyGgj3ZakGz4G7tDmq8DfnlHXvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJ4m/XyJGhFs2T/e8fR4sdjYwH/28u+sWH091FmsZ+o=;
 b=pLuDEGMp+RXKUIgdNvr5mZdmLTY2NTDeSrJIlkZUv2g88bpJo/wG6VVNzbaZ7FqSXREITMyh//e6AMstzosKw0nseqzm0OxEshwaieWA2dLqY7TYmDlDrzHERsbecPzBCXmDwyf6rFYV8w5ssIVGRUucu42OlINxYV4MQaRU/Ms=
Received: from PH3PEPF000040A9.namprd05.prod.outlook.com (2603:10b6:518:1::4b)
 by DS0PR12MB8414.namprd12.prod.outlook.com (2603:10b6:8:fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Tue, 21 Jul 2026 12:10:59 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2a01:111:f403:f90f::3) by PH3PEPF000040A9.outlook.office365.com
 (2603:1036:903:49::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Tue,
 21 Jul 2026 12:10:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Tue, 21 Jul 2026 12:10:58 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 07:10:56 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 21 Jul 2026 07:10:53 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 1/2] net: ionic: Fetch RCQ sign bit from firmware
Date: Tue, 21 Jul 2026 17:40:33 +0530
Message-ID: <20260721121034.1616562-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|DS0PR12MB8414:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cc6cab4-a98a-4d49-9e6c-08dee7211fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700016|23010399003|1800799024|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	iiVpFMUpGkqnEippVf9Cm+F3rLhEXfQm+g6R/01Etz4EsJIexpqmwBicYFR5aNCWU1EZSJelpymay24z5WeaX1EgYhfMUr+HZLaVAqatxspKTqHHLIhmVFVbpocf0jo1wogyg/88+d9lqEO5u90ria5Ge7fTy+SLeplrwNvMdx76ceqfuv5mCUm+g00ASA1vYc3tTE6nWiOfXj46V20gIUWKG/GPsRTp8SLn9pvzspensRH/37Dor7Pml5JiXDW1WbHbvkg+yv8LleAUYgkPTDsEG1kmvSt86KYLTytje8n9nahWvMrPTDL0RhKX6qHNEPd1IcRHRlbsAhxsH4eDH2XKxf9aaRV8lJYlW4O38uhD2KyY36z50O9z4UpOGASr8terCdgSHVktwlDEtNx12q48AmEmSc3XlhXotF7pXnMBm+ZaQsUBRz+HFpMmMunG1L9h5t0bCuHuovEFbDUY05NmJpZRwtywxAqwyOz5n2ES+vi6Fb8dTgm5vJYbG5mJulnseCvXrBERWpsybLEsMO7mtdnIF0NZh3R9jiH2AOoyBCMdJuqEdPBPVXh22dsxUJIgApPP398UyPn0AyDS0//usUenTLUmeHkQoP+DQjr6gqIE2IhY0pKYUXJoBj8pA0fP4L1E75CjwdoooxnJ3Yl4IBOm5ygX/tNN9JY0AfSAsFQjd6hoLw5jQ6qaRWEaUwPsJxpEzp3W+zYN1trMqA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700016)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	28Zf+H73N9EVwtHkf0cM+x1Bo9sXoNHBI2TBmquEavIaKh/YxBzLQ5PRqcs/b37MsBBpK8io6L5E2F8EnC6ruQ/CBfEk2GJz9S+l6qkhtbU1wHVuWWcgc1hSqG1i6YPpnuCud7J3LOhm77yP1obRRg/iODyMbddUkUMhlf2vIcym2d+ZVb/4Ex+AeX5DiIoR76YLYq8SZWY9BF8ERpPSRSdSNmJ08NEkKfeY8CW/vLzCIglSeNgc5ywBvPpZ7XXiUMZ+81fHqYmTPqzIXaQ+4aPlX9AWlhNWoBJu18dC0SrfqJyDK1RruLGZXJ9gb7CRio8GmnV/CykIpMVzzXXOWaokk9wzbmu1jynJVbuY2K8UWgAqwwoIuWiXoHF0FEMm/bLsKQ24e0rFN9F9OH3U0XvPnU9Jjw/BBmM/kIU3h9UIzVh91J+EcO1m0gb3sQM0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 12:10:58.7809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc6cab4-a98a-4d49-9e6c-08dee7211fe3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8414

Read the rcq_sign_bit from the RDMA LIF identity reported by firmware.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 23d6e2b4791e..b97de96f78c4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -553,6 +553,8 @@ enum ionic_lif_rdma_cap_stats {
  *	@rdma.eq_qtype:        RDMA Event Qtype
  *	@rdma.stats_type:      Supported statistics type
  *	                       (enum ionic_lif_rdma_cap_stats)
+ *	@rdma.rsvd:            Reserved byte
+ *	@rdma.rcq_sign_bit:    RCQ sign bit
  *	@rdma.rsvd1:           Reserved byte(s)
  * @words:               word access to struct contents
  */
@@ -598,7 +600,9 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype cq_qtype;
 			struct ionic_lif_logical_qtype eq_qtype;
 			__le16 stats_type;
-			u8 rsvd1[162];
+			u8 rsvd;
+			u8 rcq_sign_bit;
+			u8 rsvd1[160];
 		} __packed rdma;
 	} __packed;
 	__le32 words[478];
-- 
2.43.0

