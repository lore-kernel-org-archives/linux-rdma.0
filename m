Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795752531;
	b=CPTbjS4UU2I+UP1Q4c+uojBYZqL2Fk5iJdbHKWNXAxyMOHXRLfkMbUDzPALGn8XLCMcC
	 vROJ/GV6pHjUeEJw61vjsjiS1kyKS4PQoVi/YQiITM12lmWbQcegvilR7OnNx7uUMt+1L
	 Ym1poZGjdEQXbBbMTctdWv/0CCjI+7jDknEu1RqICeGTVfEf7fubbXOq+cMO5OU0Oz1pa
	 rHco8euD8EhBC8zjFBZkVOMUJW7maurLkJ+Ys3wId6nI1D5UwxZJ7XKBcD8ZxYjfb15dY
	 1mj747p1WhtEgxaaDDjUFI1gSa9x0ZB9RN93t0p1ylHPuGMGx18BXdnZOu20TRoQLXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752531;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=rdlfWvzfISzn8kQMrAn9T5LiEAF04o/rwCujocnADxw=;
	b=KfwOPsvCvecUeflW5Squ4BCyD5g2xjlPobPi9etVlULhIKNQqVm1XWBa/U7x1VuNlje4
	 2zyEvOGOt8oLAmePkA4EeWM8GQV8lyhosG/jFktFbLx3Feb6tjkAlXr5ELBdnB+Lnokpi
	 Pt7MHDCjTbxW8qnL/CD69Dgvav6wUk5t8qZyu+zCKw6pQFt4PJqq4iGa/Ox8qdt+dcCeQ
	 zmy5RQfaiit7I4jhfsV5ZoVM+H4cuoNSkK3QnVvQ2cz5ek6J5M62UJyw49k8PU5acH+DF
	 X2bhIHKIrWlwi+NH6lbil50ObvBU4nFyjyAfcHgZHSxmZRF+MLel/l3pXJqbNM12Jnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mXHMkNOQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.68
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783D8606A31E;
	Fri, 27 Nov 2026 04:08:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 783D8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mXHMkNOQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mo/RumGKs3LKuQ8TaoIWP5mPV0Auk/pwfupACBixeIpvc1VkXh7BggeAfX9GoY7/KZxmKTtzeuucvOtcB2GtvrbXxRcFCpR4AZneb1gOn/DBywhuus36bMUHL/8DYkiImzImk0K7BPDo9g4jirCd5DLqxOgfvuMs7r6eF1cudCdcYC2jYIdrWOoPBIfLdQMmBUXI9uVwd36CqRVtpypc4s3z1+k6nu1OCpOi1HhKWYt1tNO/K7OJdR1y7o0S8Hv5JMHZdofziLfFpL7etA+rNmA1gbwZ1zXR0qXYkdpT4NM5C7zMEZqadNLJRfOqav1+KUNnpZ8/zfxjjalvRF9mng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdlfWvzfISzn8kQMrAn9T5LiEAF04o/rwCujocnADxw=;
 b=SR2TY231+oIikFXAvnLfpwBEqUcCev00xPIp2HUspHpsQMUD0d0ZzlUVYoakqzQpJSWkRgJcAtCFkUX7iWSNyQqPgn2lIFOvtr+wiOykQo5YJuNMxXzQ8VwLxU7J4TXxUnvV4hoIlyMM3eVsedSsXBMdfue4coGvZWYZ8dFSheNB6RKo2VQF8vYJS5T5GPp4LUS0ZF44GH4zaJ0G3utq0vssKSV9HPL+GKH3ISvwzQNyAKyeHJq7IXxoPC7K1ebZ+A8g9OHlxN7YAQFdZT564kxvCmQcU6bjZ86cH9wQw5Eky4Mc1k9liNGv4DRt/GFRaY3B436tshj6Nrp7/Ivp1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdlfWvzfISzn8kQMrAn9T5LiEAF04o/rwCujocnADxw=;
 b=mXHMkNOQaCjT2OujPSZqTKWnpgqOqZk2D1P9TQl+7Tr9JFyuL87BJQQxRTpLu9gBdHu7fe3mAjg7mqZdt8wG4+kLiSeXc2LCHG87sE0dyEA8VJAqgjP7ZuLsvLIxpXhgNJ9wO9BuQT4aMmA6Agyo/8g+3Yayh6ARo4djk4uq3pI=
Received: from PH7P220CA0039.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::26)
 by LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Fri, 27 Nov
 2026 04:08:47 +0000
Received: from BY1PEPF0001AE18.namprd04.prod.outlook.com
 (2603:10b6:510:32b:cafe::5e) by PH7P220CA0039.outlook.office365.com
 (2603:10b6:510:32b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.9 via Frontend Transport; Fri, 27
 Nov 2026 04:08:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF0001AE18.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 04:08:46 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 22:08:46 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 22:08:44 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v3 1/3] RDMA/ionic: Bound user queue depth and stride before shifting
Date: Fri, 27 Nov 2026 09:38:30 +0530
Message-ID: <20261127040832.16908-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127040832.16908-1-abhijit.gangurde@amd.com>
References: <20261127040832.16908-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE18:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 64a08c2e-a6dc-4057-4fc3-08df4c3c2264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|36860700016|376014|18002099003|261009223027099003|22082099003|56012099006|11063799006|261021121427099003|261102123227099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	BH8hwiiFBE0/PAVTmDnhbk5paHRwsyfBsAHL0hnjtryfo2BHpqI3Y/+jtlcaMQfJdSnlGeozJP6WdEs+ecwiSqx4hBRIcj7NZBOeSOkbinrBRxtnKpaxwz6gThos6yIP0P8zlIRxoGblo/ukb5cMEiw2yKOv9PWNltps5+tQzfoVylHT8mWmjWcG1HIVcyxemDmSaICCAegb86xPlNMNUgjguy3Ca9fYYCQ/3HQ/Zpu9/sxUD40jJ/7A3+4zHuAfIqAoWDkVdU8M/yukMqyhZG2nwPvTxlRYLIR/bnr8lQseLDAQQ1sKoJHd4VLXV359mihzTomDkjU+Ex/ZbHbNjulKKEgkhaCSw+u+rJ3mNdqGs+bUAa24ZzDep4ynKWUdUOt5CawEGMQeF4tZ9wjDudujRnMvyHGkZA6NXI8BFrIEaQTkyPbOKHDK6scmGPxSdoJY3+gPhF5LjJUu73nb420qHx/7Uw8McqVCejfcDtiOQEH/t4NMhLzVTGabfJeXZZkuBh/9cp6fdPokBHmyU18OIMBjr/mxwVByxM+Caiz1v/zNX1One8gVb9mOuIWe71Epv2w2x3ns3+BapyUp4L6Ugu3VtIMmAmgqlFIuWPuWle2RlvyNsx1g4++6Jj5P1X0c5k/Hcp6VmmoIK7msKOk1ZhCsA4FyLaCFHkorFCd2yzfJObDShaNpuisqOeFCP8mTH+N4V94XfkDNvgiSVQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(36860700016)(376014)(18002099003)(261009223027099003)(22082099003)(56012099006)(11063799006)(261021121427099003)(261102123227099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7EZR/rRFYUl7CW4lyhAqNV0gs26gmU4qxbAstGaWsXXBYqTG4Tkp4eBL9LlzqppqHmzx++QUsuBAmMLQFfgyxb1onEXJbOxqzuyU/eEu4Cq6n5CghGI5otdZ1iPqdzrpvjGvHHfBhsMRhBxpfpBbGenFNk/jhz2wesIRkRsb+2OXefobhU339hsmD6jAPZ40RoxzXoiirtia/4WPZgPAgLBAZ5mbTM40UZxaGFOpz16yDXGjtZ3eLXrb9xD6W7IiXhjfsMCGdumRNvOGhrhnJTHAsxkdTKoCfy0tLadUcffziRnHnDHEuphcF0hB42jtHRzv8BNw4GwYHW8agipnEbSpTQ4br0hXdQkg83pviApewf9K4+yiCeRN8KhSfA4LReKSvYuKZyo59z7qlj+gqmoAdsTSoAh0Dcb2qSVve8Bo4YNHX2xNhIzy/5wN0vj5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 04:08:46.8017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a08c2e-a6dc-4057-4fc3-08df4c3c2264
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE18.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168

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
index bf012f886fbc..717ab78b603c 100644
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

