Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCA44028F5;
	Wed, 17 Jun 2026 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702784; cv=fail; b=Jma/dSarWd6zDwE59nxM8h8+CuQNQUOh80kyvB/u7Q0rF8PW88kGXvqr7oZl1N6iVz+6Ybr2w1TwKmMz/z+4/SWtcMqM1/7uqC5IT6FniynDNN4VIcLstFKW7BNHPmZgnXIUkRoXhNco9wYk3IdPd4L5SlqmoXWe+2JR6OYqi/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702784; c=relaxed/simple;
	bh=as4oW+uyDR+Lqfa2014fJuPaoejgN/AR/3FRddsT4t0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=No17UdIcl8k3E8lQ3+ICkbcmrg5y7ZVx34wMs92Czp90a8LSFBaW0SmUcWC6k377+IkxGQtEAAuwnxuOpADM+j8kqzo7aJ5f/Hs++1wXgmZBfszs1D5qkKuoIXuDdMBncWis9jwdR2IHcemBrEhXqWwl88KVSBjI+GTe7+B43EQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PaAPUKeK; arc=fail smtp.client-ip=52.101.52.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PaAPUKeK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAy2le04MYRbtyFQnSqDFtWEpeqfBlwuO6myLPohF6jeWfYTL2Fp9Ib45r+vWYdjWCrrFQ+TYoV0Ls8pDFUut4NscgDtaIf1OJsvhaFFW0+tBlROn1wMxH85odT0PlZNLR+q48JbqOh5Mm4q5pDlCXRtX70bZ5qinDyon+L1SyrkMwNZU8oTa1IlPE65yGWH0c1EMXq3aoXx9v8joqIdMbIw0qP44xOEOO3Wr/t+Ff/1VTwN7aPFirWDkj7ZnIYYhqTPVp+kb+O1NVg9r/ksTIMLf8M2rpjNkO2sfuhihvz9HTg+GPPrDZ6BZn79bsz/LoWyhAZ0dKJ23xgKvj5jLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJ4m/XyJGhFs2T/e8fR4sdjYwH/28u+sWH091FmsZ+o=;
 b=UE+LpKqsDogsyz7ARPK6VfsSixbpAuldb86rkS+raDIy5JEz0ccHZmF4VhP5b1AOQlRiPHbHxTgZCFGsyMEGw0Q1Qc6ANdZnaiQoZzQUN2WiQ1h758175aBgXQsvq2SzUBhB8JlFXhWxhFrsQLcitillRTeQ5m34n5PWblhwf9zxHcH/swMxcuyzsYJBkL8bxNZZ2bWlnyHTZH2+1N/Tbj83sYLC0PlAi0eR4cWQi7ynlTAL+ZeLIMbB8cg+TxldB+AJJljKzm03IrdpbxyFB2X2sxLUf2NZZcbvG8q4i+D09jC4+OjdMfHNT/aPFdnQmcevvQ/58P7MuTLpkjw/tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJ4m/XyJGhFs2T/e8fR4sdjYwH/28u+sWH091FmsZ+o=;
 b=PaAPUKeK84/WYTpJNRPezF++OrwOIvlDeV8wa6AZgQOH6PUwHanSKzJH99p6vPdutwVObGPSpvBQtIlP9EnlhUB/EMfJ7o9lOu33HHBrOkZTRwMoSFcT602zOY685745BsGWRE5rZzdI9NJfAAPLKO4ctdpHm73BaZY06+uD0Z8=
Received: from BL1PR13CA0330.namprd13.prod.outlook.com (2603:10b6:208:2c1::35)
 by PH0PR12MB8100.namprd12.prod.outlook.com (2603:10b6:510:29b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 13:26:18 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:2c1:cafe::79) by BL1PR13CA0330.outlook.office365.com
 (2603:10b6:208:2c1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Wed,
 17 Jun 2026 13:26:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Wed, 17 Jun 2026 13:26:17 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 17 Jun
 2026 08:26:16 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 17 Jun
 2026 08:26:16 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 17 Jun 2026 08:26:13 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v3 1/3] net: ionic: Fetch RCQ sign bit from firmware
Date: Wed, 17 Jun 2026 18:56:03 +0530
Message-ID: <20260617132605.1888205-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260617132605.1888205-1-abhijit.gangurde@amd.com>
References: <20260617132605.1888205-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|PH0PR12MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8a88f6-2c41-4040-b13f-08decc74030e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700016|82310400026|23010399003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	FBFLIja0kW2V1jBznMBG37Z/vNytAoMCRxxIJjy0HrGOdiILHwgB4VmZUmb51Y/3ym/LZR4g00rYVNggoQBRo+LZGj235qVoqqcM+Q+9rgYdKsFc91KOTd7JwzyHzFGbESHMOJxBoSBE7n2R5Pp0pzWj09cO/y0bnWHMVdoBmOziU4DcUFHKCuUGra0hBomBmQEIYy8f3fvJ43mFq91/6C2pB9HUAyEhNj5Yr9KbFW+7KYvBa64DQsEVTrHQ4GRgCalJdn9XPo5p89L7PaH/YwY593G0tWUtAiV1DZpgnWN1OBrrvzcgFsYH4jBelFVQS2qewbKPinAV9Jb5pcXSb8osI/GsaSdtmSqcnlpyWFDh/cOKdge1UPET047hLt5ReHKpyLZ6OjSqLES052iLUuS542yzbWV1rLggoUr8vJvUJrI/l4Izx9caiK+aHpSgKQQiXRHYLKoRr2zzDsIHcO64FwgATRlKQ4lko1RRiqIO8hI1pQ0+bM62HZ9HNI3RZc3ueGp8qvlCYf82GCcH388LtWrwcNFPW70q6fWULwitObUZvJ/oYbiyOEfZiwPSgilHS9hoxbmtvbFMKbV6+y4Vu9BSA3Sr4I//b1CPl4YuZjkr9QeQDhvQ63BICFSs/G0CfDE6OhrxB3cmU88MhJNnK2vu5XFRvDHbxyMHGJTUjC4GB7lS7YEuA1BbM3y+/u4DvU2+OndV3R7yHISyUjX9uBUq45hhyZPKQm9EUBo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700016)(82310400026)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Px16IBouc0pX5BNYyPDprRIMD+QLU+JCok1wfEH0XrL5KOm3y1eeKMCnNJa9GmlucA4J+MOpOXJx8+UI4M/gInItY/drqqXrgyqE0KnKwE7vA1BV3l58a2N6qY+ww7CpADyTcaJUOAlDaT7/s0ZKDHfxElxHvKeEJgKNeJ48mkOvhQRkVLgoxP8x9p6qc5+Liz4g92Q1L+4WGHshe2vwwjowbyFCbDSbV4pGXhiYwNW4ylpgKS56mUAeaYuvJMgx/87GAWW+/Ac2+XEB6JODJgUsnmhYd5tEX8wngvO98HEq4JDyfxK/6BxeDaZr4uStLGLyGBSFFcxPIcPykpzG3haj516lJ+yncTzxPI/hLwn9N/WjLHnP3U8inCsClRPkfyqdFUf8zSRBgXTb45csuTDhE3+6Hw1xI1HOC/63W86QkREhPUhndqlfSKMEpZNq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 13:26:17.2396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8a88f6-2c41-4040-b13f-08decc74030e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8100

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

