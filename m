Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063846;
	b=EIWQ9owy67quHP4WQPCZKl52Iw9cFvtBV/iIWcmIP8ntAoP7gmX9WNacw8h1+HZXE5B3
	 Vfuzmz35Wsy52/Be6hDcrSJ7igySU0/dvrC5CczHxtk7AiKwoe/MIE7W9EDNUNxZZz+qa
	 5ay22hno62Yih1/JYcgr3+M9jML0xZJmy06sJNWu2gs/Dbgo7EHhnMiuzOmRpq24hRM3Y
	 h95osxdruwWAriZ33NLpHRM6NQ4CmVLAskOgbFLQPH0I8RCjtpoyeblnuaMvVe0IsnhXV
	 qNVUbuS1J2qRyDao6cSj8vWSY89IZe+ZSOfncC/giee/ne4ZPyayObszw5D4+g5Gf7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063846;
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
	bh=FBhmf78YyI3AlemGODmcmQURqcCfnDRSwXcYElD0rmY=;
	b=LIvp+JzJX18iiKz7JyCraFw6C1Wg+GsKdhk71Dzz8Lebi/8JKmtswG5ZnxdxaJk55SzJ
	 PJl2VhkSv/0ZQgF41zPBkRYNwUOAF70Nd0j8eS6LV/8LiXCTRp5vivNMpqRNVucs07bNx
	 VgixS+d1gNudZ+ioGM7sZ/TnVpa4t2X8i5T6h+TAPRw9VPGy8Xf5pPLu44rXMuk47+/zZ
	 cP0XmpymPrCd1TukrufYsNEvfE1vCVPRPWOcT0RIJMFp0Ljckrv2QT1vwM7Y3/hAmk1ID
	 rDUexp982NWVaoe1gqDM6Dxx+bSO70hE6gKjHmSSbTuYITbw4/oVWVJ4FUFyD1TpkNw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=SL6BtZ15;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.36
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010036.outbound.protection.outlook.com [52.101.56.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B4760A6F59;
	Sat,  7 Nov 2026 15:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20B4760A6F59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=SL6BtZ15
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l48X7x1aoafPWEGBKoGl3vyqAy2GQ7qb8qjCSJePwDxOSETZ3gbZVTO4TJFkq69M87bLPUFVuIWihTbFbqx4UPJcpsFPEp6bR5CTbbcTiJLXgRnUSB2j743huk0IWI+Y4u6TsTXD/oHSjC1psAnpk1pkDqRdQfGBxPr7GZpPnWujLfxxKZQOmvG3MZJfTG68K02lbqMG4B8PWhOG9vYYlGMzO5ZJwlLGoJw9B5yZVeG2hd2ytUG8jS6kvr0WlmVtpdVr+LxYQ7H/g8EZ6bHdIICTIIAIim2UlykAvHuFegwuXBDhfE61juctx2QEYrrrUMD0EUSwZaO0vs4GWroroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBhmf78YyI3AlemGODmcmQURqcCfnDRSwXcYElD0rmY=;
 b=mG6rUd21t7O3yYoir3K4Lgyr6Hf4z4nJXl1iJIpyZVRpujNKDfZQlXnS9b225P6wUdDFpjuYGtj+hZXyBUrfKrf/FGEVI8CekBhgIhk9jAWQNWd0Ynxez8a/DFHYFJJTbRPwWDiVSCYrbfsWqiYrCqCuPnGzyx8U1rbW2Eg5sVVonu18cYHouVlNRrHWFmoEHX8RVtisi1jrtAPoCtYnCCjjAyth2je+hPykleuBdBbXC0N6nMA0g2iBsqx01BWZyiL2iIUkhfUMbtX9gRglY4JWhS6wlli8JNE7VYPe1QEgmxMG8os+RNRmOpeZOI09p9Z2wZselxKFjZDt6a7S/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBhmf78YyI3AlemGODmcmQURqcCfnDRSwXcYElD0rmY=;
 b=SL6BtZ15IMvHKnzV8lppyrh7dDp0S/pEKe9zrwbEUbktrZTu7mIqvSD52klJQHDlTGApEJzGwMJKz8/lwhNPQoOtIyG94O7tlOZGElRgpf1F35JYKGLmeMqcAK949uhfZISpzGusyxfFrAw7klcSRUgmOkhePzAAwslxDcH9d4k=
Received: from CY8PR12CA0031.namprd12.prod.outlook.com (2603:10b6:930:49::9)
 by SA1PR12MB8724.namprd12.prod.outlook.com (2603:10b6:806:38b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Sat, 7 Nov
 2026 15:04:02 +0000
Received: from CY5PEPF00000E86.namprd05.prod.outlook.com
 (2603:10b6:930:49:cafe::50) by CY8PR12CA0031.outlook.office365.com
 (2603:10b6:930:49::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 15:04:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY5PEPF00000E86.mail.protection.outlook.com (10.167.247.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 15:04:01 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Sat, 7 Nov
 2026 09:03:57 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Sat, 7 Nov 2026 09:03:54 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <eric.joyner@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next 2/4] RDMA/ionic: preserve atomic operands in the send WQE
Date: Sat, 7 Nov 2026 20:32:47 +0530
Message-ID: <20261107150249.1576835-3-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E86:EE_|SA1PR12MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 559651da-ebb8-4842-14a0-08df3ce05bba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|36860700016|82310400026|11063799006|56012099006|261021121427099003|261009223027099003|261021123027099003|261102123227099003|261021135927099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/6AeuFM4PGv4MWpxMbdBKkV9JDxv+hF18CQVuFRWRGBvxlYkQrvAeAwdsP8JLwbLLu5If2ErWu//38ztoKdXoqEeY5KEZAcEkZN0d5FzxfCwtRlqWBiRowFe9HcsyECYh6ReeiURE0pWj6m4os1NeXwxHljh1p7husvpvjbgOqcJOe5rRoXHj7eDOm6KJLEgzyizuI1o7dUKuk+09+rD4Q8MrF3ksP3QEl1lAuwiebGf9u2/CA+0oJbrRHPcLN/l9O0TUD5tIgAfeDlDhFgefHt5sVIQ1WNERlZYnsDXb3F+Gf3n/m455qQvBbNQO3ZRNERGHyumdZhdXJrh+CjQSu4FEEzS99u1/pG3uYh6HuYPpHJSNYXmh4+FvO/W4vaxBVsaOUJqC0HaNjlx9OrUgsNmxQlbLDzyXfDRiNiZ6xvqWx10ZWOnKHJtRdBWJMOfirSAhPGbQh6+Lf+ngAZWN1hEwhSV2z8XGMBC2RnbuVR6343Oh+43x5WHBQJtr8NmtWvqdKZatocQLexM5Sf10ZP3EULueP8eijA+vGsEeKsbchhZDnHCQtizoaNmG7HsfFYBD+5g9XCFrsfNXHLgKUdY2Arac1x6I4DbeA9hZUQvnsIRGJNLganwKvzM/vS1CoVXdLx1gztJPrclzOSNdHwfXTY5UddZf6aW2q8Gx99pg0sXGpE/MKFEQ24j4ng3B1ttQkMlSfu0oISsspgWQw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(36860700016)(82310400026)(11063799006)(56012099006)(261021121427099003)(261009223027099003)(261021123027099003)(261102123227099003)(261021135927099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aLe66SS5W+hWl13FD6ZG3zqEhMKfcIOxoas65ZsziwlFzjsD92lPZ1woytTjxMQvyDNf2xNHaqlVw5asc41nY3WjIl7L2L+AaHyap9ggCK1ZKsy20ViBVt9w/GwaTZd6ME0P+FcgI2r+vHfWagzBnojU0A3CAzYo8oorOen8fJbb5e3ScnxBHhcTe4gRA/SR5v3im53OXcB0PLUWP4xNd8sMGyNnw3ewKYye34T9FE8ZE910CScAPvnh5fP8ZWQYNWjqBbh43J/r0GxWtK0wlXL95mAJkExLYlcTQTuNKBofHtIj3I3yEJpm10gE767hUDWYyGgdnihYKkizzZIbn31VMGHB57e+nUI2w7nMse46hZxfCjSgN3l07DPsI4nJAm3n5T6h5Pw7cvHD3yV8bpBjm77ewOOSoQK9Zb0CaRmC9SB9i54QNAOLMs+qksEx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 15:04:01.8541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 559651da-ebb8-4842-14a0-08df3ce05bba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E86.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8724

ionic_prep_common() writes the common length and scatter/gather element
into the same body bytes as the atomic operands. Finish the atomic WQE
with ionic_prep_base() instead.

Fixes: b83c62055b6f ("RDMA/ionic: Register device ops for datapath")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_datapath.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infiniband/hw/ionic/ionic_datapath.c
index f1354dae089c..5b6f10256b49 100644
--- a/drivers/infiniband/hw/ionic/ionic_datapath.c
+++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
@@ -1054,7 +1054,10 @@ static int ionic_prep_atomic(struct ionic_qp *qp,
 	wqe->atomic.sge.len = cpu_to_be32(8);
 	wqe->atomic.sge.lkey = cpu_to_be32(wr->wr.sg_list[0].lkey);
 
-	return ionic_prep_common(qp, &wr->wr, meta, wqe);
+	meta->len = 8;
+	ionic_prep_base(qp, &wr->wr, meta, wqe);
+
+	return 0;
 }
 
 static int ionic_prep_inv(struct ionic_qp *qp,
-- 
2.43.0

