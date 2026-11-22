Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369181;
	b=Cw8en+IZeFEmhCPi5cFNDx9auboK1H1Nz0xOObuEJj2DD+iBKULQWbBT+EgVZP0o4ZGi
	 7dJp6ORot0uo8k6RoeaC0JQabzwKaB4c4edfZaAepgQ1WMAPiw3cFJ+kCIrcMabE9SNvX
	 UAVl8cGSL9h6DJwRTh4TGtOhvxOxiaGsRZ0r5QrZNDp4muF5y8lTekK7426qFFCw0B0gR
	 h3umasH94IXE6FMWOE+VzK8yqT1F0n138rdQQldX73TPpffwAh1GyRhOqv3YKZbhXP0Uh
	 tF++X/8GEHcrp7YPV8ZfQ3vjiWkXoY6QDTs/kTCARdFDCHvEIVLiL4WoKVLecmzgVAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369181;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=QKpvURI6NccGJ8jAECmRxEuHsxkv7InCFQ0rYF9GR8g=;
	b=Qe5QUX95L+t3C0rqeq7mbyiNVWbS24+MpavgxmXie1V8g8n+0Nvug8TJSF2UCM9r8ql2
	 pdveilf4p4KuKINgpTLLnSVQP7Q05nnrt2u1aQXCjOSSPUfgLq50sM9vLf4ycT5ZXaY8o
	 PjXaan8TU5WBWcJY2dJs+Tf/7lkBpFUBg918lq52lvRKuw1bRkFIVlNbrhBVYXu4LLmRH
	 eg+W0v69uFzWakTIj2Wg/2i45jpWuuWf0FJp1gbPIzDRRs44zCinT8DYpIxzEM3mDjPuL
	 DGFwpor7GbaDEdFi9fsaM5ghDzdHsvR/5+Y/Hs3cJQtXjnE574EmIj29+Ec5060d8MA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RnXTyByW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.54
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011054.outbound.protection.outlook.com [52.101.52.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A8B606A330;
	Sun, 22 Nov 2026 17:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4A8B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RnXTyByW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pXL9kZCD+5htLn3YOq1C1ZVXtimKgzYGZTZHj6HWIb7OZy28fJ5tWnc5g/GVQ89ruRmmDm6uyEo60b/jRcNxNUi2BO3n5TRMG3xOsVqBTuF+ttnaSNAnlyUXUWaKrKRd0yJc8tDAyk+LrPa0GsDTu9VWGwHZTRaoxyuw5cwbmYhAoaMI22lQ/nJi4GxfR2VWWYlsaDP87gyOMcRLINEr9AT3/zqUKa75RcpekxPAS1L5xGQZReUdg+0/An9Bl5+i5ikIcmp+RhOHgKLxhoRh8PP+ZS7Tcd2HKXVvJ6d6jM38zmFkWU/JzOpqM2ISVYRNKQkdBgz65mo3EeT19SYICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKpvURI6NccGJ8jAECmRxEuHsxkv7InCFQ0rYF9GR8g=;
 b=fBhOQ1U/5rnaruzQqDso5a16Y0ltMZE2bzU5MhnpG2sxOnsbwjmMRvT9UH2v0NaLVtDM+UWlHJzXGmo/TGT5ayrJTcVYXCTafmbx1FLWI2kD3HnPKlmuoFeoJKNZJai/uYIHvlXT2Lrcs5TYmnAj+IFPF1j/vCS5s6SJZeUodiWUjcjrDE+TQ7ET/ff1S1I2wS6PqiougvRzh1uLQzK6HjrjPhSiLSDctfGOul8kPyWJlvgNBsegaVO68V717OrLR2ywH+KxHJwZJ8H7ZWTDm3u4CBAYV4BTONW4ZhUJTG3DHY1UcmNKyxwzLHIv/wJ967uSPdWKkAceJAYELVFlUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKpvURI6NccGJ8jAECmRxEuHsxkv7InCFQ0rYF9GR8g=;
 b=RnXTyByWXKAMSjvgIOE3oLOepFQ2Rl/h92ppdkD0hNJcZot8tXIHlA+xMDv4LZluHWcFuxDJnwF6z5RK+JWoARpkvpHwbQm2jQoJ5Bmvq6/bz6U8ZuaSZFPl6aSM3asWjQC9/KAnuDpeYXqu7vKDNLAAVDNemvkqjc4YKaIbllZk8EYmKbgPljvedM6L8xEfJau1A87nGh+WVPEAaFCYusjJNEpYbHx3wwY6ER7O5NeTFbZJLzAIMHEhhYwiw1XU3JRISeRfNSxjzQrjNoaUN8frXF0RgJe+LK9Oks1Ida2/KKkE7k4VEss4jVnHHTAtATOphuhMsPtaDfmLA3akYg==
Received: from PH8PR15CA0012.namprd15.prod.outlook.com (2603:10b6:510:2d2::18)
 by LV5PR12MB9801.namprd12.prod.outlook.com (2603:10b6:408:2fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 17:39:36 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::36) by PH8PR15CA0012.outlook.office365.com
 (2603:10b6:510:2d2::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:39:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 17:39:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:24 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:24 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:21 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:09 +0200
Subject: [PATCH rdma-next 1/9] RDMA/mlx5: Validate port number in
 handle_port_change()
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261122-mlx5-port-events-probe-v1-1-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=1600;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=0kkINDgjD0Z6ND2vswYcUQUTo3vhHB9ZhnGg7nkEEQ8=;
 b=0Pmix0igJQi+e/YJUnO/gNaTSbVKSk49q7RJbV7GFTvi2CvdQkwImkVnE85TenXy8XAwuGtoS
 tYdf3O6gteEBd9n3QPoWxxwjbygu6F57UUBrpZjqY6RdtMLvFLSC7Nm
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|LV5PR12MB9801:EE_
X-MS-Office365-Filtering-Correlation-Id: d86e58d6-850f-4cbc-27bf-08df48bf9370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|11063799006|260925021311599003|260925021911599003|56012099006|260925022911599003|261028144727099003|261026140227099003|261102123227099003|261022105027099003|261021123027099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	EXH/cm8JiDGy1n6NLQIKCJ/663bO+mIVmZiYiovWmK7kW1+NpbCpsSktDT+lW9AwlCmICb1c9w/7yOfW6CNZ7tM4fIDnF82Jp2HzHU0MCsJGjH9hiF6xev5yIAgD1bmVpqg/x3eldj/Dg9fu+pAMojHMP99Z0G07lZaowUFKfcVQPnbNKuD1XPLmpdLxostXY4dUoJvARCFbU0FwAfo+bHau3/KyUXCyJB+mhMXjLy0iX0vKKIHd5okIcpkAqNlS0UEHD5V761jY0FAvtOqoDrx49RoVSEIin61eTR3GWDAEmnPsJm/BKZcwZVxa0HLyA1k8dDhJV+tQ3zyX4wudtowVb9NnwoKRtLbINmbb/UCFNTabRGDHbax+jIR4VPQyWMp2L52rO1fNwNnGSR723Rqls2B0YyE3wKQ4Z25ER93vFAQFNnCeVOxT3kNirRcJ/6H0pdJJvkxO7/pVOBixSQvbyEQ8lyXx47PcmVHdk03teDYyHteGvUplSWNU61B8E97XbG53xaHN1pWja2me80QFYkwZbaPR2Nu9V92qQL47fqoJ58UHiCwalNDwkXKpGbIznMsgm4Gek04aMIXTq26thtwgsKOjjCYD/pPh/6yMXHIrStEue11g/m16lpI5pBWxDAwddBcdTXDEc/jiiYZeBD7O9+MG9qXbNKrcKysRmSc0roGGDB3MV3egyyfIwFxwufZ8JuI6btnxtW4fdA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(11063799006)(260925021311599003)(260925021911599003)(56012099006)(260925022911599003)(261028144727099003)(261026140227099003)(261102123227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sriBIZnZ3B2W0sTBHflD33/wyIFThE21cwrsvszHKQX/3Ev7JkzA2Bw1LCyP2cLpqBsVhPCZv6M0N/7v72TRrrV5kytAnTszK4QzYIw5WxHEeLbG7uOdduBhc66LXyr9RNvThGNR809us8a3msu5wDoVwdhwXR9h5IyxIVhEQFGn8l7NzmDtL5kwMw/2T8FIZu58J5iGUvRKvNOVNysze/UEqqJynSvJ4CN8Il3y28numnhq79WSrnfGRWLomj+jjuY/JO3GORbvoyKdiHLxb/oTa28TEq7QyYT3ru5tnbzYQVXXzKfoumK+SNQdq6EkQUJ7sxkzGVPE9HXi8OPzcH6mNaj9HrngJHC3VxkfzzzeOSi/8r4D/WfR+U3rg8YrJllo4KKZr3Od72QWCxFGwFXSe/sQg+v2RlwJ+bwXJbAu7kYzhmmerzpb+KTQTMkL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:35.9245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d86e58d6-850f-4cbc-27bf-08df48bf9370
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9801

handle_port_change() takes the port number from a 4-bit EQE field and,
on a P_Key change, uses it to index devr.ports[] before anything
validates it; mlx5_ib_handle_event() checks it only afterwards.

Validate the port first.

Found by inspection; firmware is not expected to report such a port.

Fixes: 7722f47e71e5 ("IB/mlx5: Create GSI transmission QPs when P_Key table is changed")
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 65455aedd559b6291831492e92a68b24a6bd361e..789e17bd317a48db502937a6816e95aa22f48e6f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3062,6 +3062,11 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 {
 	u32 port = (eqe->data.port.port >> 4) & 0xf;
 
+	if (!rdma_is_port_valid(&ibdev->ib_dev, port)) {
+		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
+		return -EINVAL;
+	}
+
 	ibev->element.port_num = port;
 
 	switch (eqe->sub_type) {
@@ -3139,11 +3144,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 
 	ibev.device = &ibdev->ib_dev;
 
-	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
-		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
-		goto out;
-	}
-
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
 

-- 
2.49.0

