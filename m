Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795668631;
	b=c0tAb5ZrKmZh1mi27PXxdNpjmo12eSkogXQw3fYl5SRV7ZLaz5zkoF7XYP7lAx/WQGNS
	 sflarfhEXmJI83TKG3yv5YJUqBPpxIeJwWbOWsAPgVIokauJ8eMHCC+lToz6jNFO3BOqQ
	 8Lwula1M37ygjXlva5b3PSSvtljtoE/zWvKvxBEoXTcSVG0bjJqlX6P3eoOSWJxT0v//Q
	 8uQ9Fx7SjPsUasaFbKCLQbIHbxEQ2JbdxJDxZQyQmn5ibLxsIJyg744w/1g5yvmKmi02k
	 pMsZayBG6kXSxVeUzK2aKNAzP8jolYj/hMHutVWhPKcT6VSdaELvxq12ghgxC2skdnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795668631;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OCXyut/sw9gPN44uzf3ucuJ9M+mChYOUIOX/V3QlHRw=;
	b=hjLrIo+JAi1gBnCu5J7ZE2BJAhwXasR9ot2z28xZNd23EFzVMml4feQOprJHZKphgHV4
	 lnE9jmIybNbXrbP8ZwSTvYerkzE1HeXP95qM1QsagjiT4eRlTqNqIAZS3VSrDT+6s/lGb
	 +5HRuB7Ncivp/QpF3uLiGfz6ckU+DMDe1vuPPlyAA+3BdFeye0XTXEo0tAPxdd+QOJ2MY
	 SqHARomp8Wd3AAUtLHX7PyOHtid+e94uGm0CoOrVEOoosjROUdM75xElUUT8pshX8a6Tp
	 M/izc3MqKM4RHYTLgfqbXNY3ebiHbdURUZM+sNVFU28xaq/fLxNaJfbkfS3t3jyEOOg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=IAAb0Iz9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.44
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27343606A31C;
	Thu, 26 Nov 2026 04:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27343606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=IAAb0Iz9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHsI+HBgNujSFMm72EdamTfW5xysh8UN4HPvOwbxBkr8qMG8hFa/2nTP/zwQXo6gIkKhDWo31k81mCybcz7F1/Kz3EK+sSKiddqsPVXi2UUS/EWvptZVG+E4iS8oG2ZaLSUMz+QSTER62KHlv/KsjRmqzmGIQuL6Ib0xjeArECSzKscQL4wZgWBtNVmYYgd3aRw2uYFX50UoAdtD5w9gN0rDJq1fEXuV4G7tAQCQFOfWw36JJXKIFKz+5VN3+aNPRra1Aza8GGH844pxEv/bCWk0Mg7Of0WM8EKd8ljg3lAVjPxvEcp+ZLAu8jGQFHkOmTNDkYAgHVXIuJe8Drgb4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCXyut/sw9gPN44uzf3ucuJ9M+mChYOUIOX/V3QlHRw=;
 b=vnS+H88GrJHXaRONqmiryToak2YXGP2pxW77NU6sh4Xnvgwk1rJyf8u4uqWevLMNmLzQB4C7HHXlvmmMzjM1VyQiw22m8qdVgKy2w9l94BZFzbagWoJ9cvHwx0ATvwSf+l8WgZoHbrT0PhfiuLCmVkd6dWrdh9dMSTLzzNnCwHXCoogjuYHlxjIhaGFMrKs6Cr4HI6KvtTlqvO1ULSGtxEGyivElxzVfXqxLT4AXNTAK5xPJDq4m/lXzjxQd2246EwBnZvjY80dhZQR24q7eresNRdM+FXw6ICsM9A6YKgrQ94+s2tO/czT0XrLrowSy/xVbs21z/SCowmHoW2p2NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCXyut/sw9gPN44uzf3ucuJ9M+mChYOUIOX/V3QlHRw=;
 b=IAAb0Iz9HoLJD8TVCDncQDFmRMEbvpznyULQxkxAATxE/X6EH3X1OoLL1kFlHbnF555ojiPixp3LTE+HkzOshMomSVi07gJjZEJyxgp4sPEblVpSuTxLGbyDr7FTQl4YAH7cAKyOE3Mcd3nyS+r/0c/wmgGhJSq9wn5S0Gbjcxk=
Received: from BN1PR10CA0003.namprd10.prod.outlook.com (2603:10b6:408:e0::8)
 by IA0PR12MB8906.namprd12.prod.outlook.com (2603:10b6:208:481::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Thu, 26 Nov
 2026 04:48:27 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:408:e0:cafe::2f) by BN1PR10CA0003.outlook.office365.com
 (2603:10b6:408:e0::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 04:48:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 04:48:27 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:27 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:26 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 22:48:24 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v2 1/3] RDMA/ionic: Bound user queue depth and stride before shifting
Date: Thu, 26 Nov 2026 10:18:08 +0530
Message-ID: <20261126044811.3458258-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
References: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|IA0PR12MB8906:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f4579f-f08a-4726-2c3e-08df4b7882dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|23010399003|36860700016|18002099003|22082099003|11063799006|56012099006|261102123227099003|261021121427099003|261021135927099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	NG5Uyw2JNJ6PSrR0nQNs5j9S3xTA5+rXamnj/Qmd56noaamJPEM5tnXoNKD5/Wv+9VXuyTjw4IZy8SywacmIsBxv6Enzq8r6cN2LSehfLfCnMz3hHUStYHgq+KDFeNaLLRL3l2yBnt0Qozh9hpqTwmkYAlcMuLzXNlHwCcF4yMYmvUOgGfGkoZWFKJdr0YqNWZJjcPTHo9ywSoCP0nO7EqMnDBsN2da5TyFT8lLtkMbuHDf1XPXiIfyrV7o0c9XD+jQQnpnvKhrp7tIcI4VSSlmmY9ieIuQ9UIdidVVOhPnKP+ZVECEufQ/EAZvxJK3ZNHBzlMeHSCVd2u0isfueRDUvMS3SQsY2TT+OIwbDpTBYdrh/6EXcQgsWX6uOXTG3nvtfaqS0h7jyN3cZikvPRHHLjZdRXI8gM3kbRXISwoUefSV1El3iNceIi1t7Ocx0LdDUwrzEJC52Nid8r5WVH8qSOvSLkSL6Y9BJfZWQma+mvjQWjXVf6uJ3uoU1D8M/azDiQnAXUsgZSVEndBRbj/bC6y9noWj53t6QPl3mCVh558zOG8r/DdaMTTtvc08/YIP+xu/6MAwHZepXmeCMW8ydL8CTleeK6DEoJ60NivKnjUa4q71R/mPFnDQK5LxX6K5ISyY4Zx6bqjtvaWdTHnKe9REt7+LOSohO205Ri3sO0HWb9apvXHlcDaPl8KiEOvojN/mdyVKVy+L75ZG03A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(23010399003)(36860700016)(18002099003)(22082099003)(11063799006)(56012099006)(261102123227099003)(261021121427099003)(261021135927099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IvR1rYBoNy333tZft5rMPfPMzCjBxtav85FuHc20nBW7Qvu+ANFcRkxEGdxlA/3+0BjqhJoJUEtMbyErzEUN20wUNbfmNQaiYZhrBsoZ3+fiS3tkS6FmL3sVqgDVjceO4ExXkLlD+40C7EcFtlqrjhOgN8GSo6O55hhruMxGn9OSM+jTSF3aX37RbfPD7FtKciHoUPgsSnPsnAdWHSwH+ol0E/vqwTYkH8nMDn670rijD1VhmjZlK6PhBuxcXG6qUXKh9noYxkwfdX7QngLv/jT3Cs4EaChRYm382KvjKhj2Wrb+NZ6KA3bkbeIHLwnXOWqtS9pMVBuzSa52SH30iNGrsJFAb+MyUm1gMfvyx10HUengE6jwYOZRnJZJ3eMA6ogLn27xWWIeyL+6dLFx1eEgmQu0jQ7n8YLvhPZiGRPwpQXQoe4Epq3Pgoe+4w4r
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 04:48:27.2941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f4579f-f08a-4726-2c3e-08df4b7882dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8906

ionic_validate_qdesc() uses depth_log2 and stride_log2 from the user
request as shift counts without an upper bound. Both are u8, so
BIT(depth_log2) and BIT_ULL(depth_log2 + stride_log2) can shift by the
width of the type or more, which is undefined behaviour.

Where the shift count wraps, as on x86-64, the size check can be
bypassed. With depth_log2 = 4, mask = 15 and stride_log2 = 60, the
required size BIT_ULL(64) evaluates to 1, so a one page ring passes
validation with a depth and stride it cannot hold.

Reject a depth_log2 above order_base_2(IONIC_MAX_DEPTH), and a
depth_log2 + stride_log2 of BITS_PER_LONG_LONG or more, before either
shift.

Fixes: f3bdbd42702c ("RDMA/ionic: Create device queues to support admin operations")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 8a0a1575a339..8a304d576852 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -23,6 +23,13 @@ static int ionic_validate_qdesc(struct ionic_qdesc *q)
 	if (q->addr & (PAGE_SIZE - 1))
 		return -EINVAL;
 
+	/* Keep the shift counts below within the width of their types */
+	if (q->depth_log2 > order_base_2(IONIC_MAX_DEPTH))
+		return -EINVAL;
+
+	if (q->depth_log2 + q->stride_log2 >= BITS_PER_LONG_LONG)
+		return -EINVAL;
+
 	if (q->mask != BIT(q->depth_log2) - 1)
 		return -EINVAL;
 
-- 
2.43.0

