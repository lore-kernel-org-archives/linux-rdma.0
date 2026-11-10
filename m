Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318319;
	b=gBeMG/HsgQCFews2e9tDJUjzmNYhVCo2MyDzVXmFohhLf322QtojV8sVxIz/JcuYmppB
	 +4cA6P+/CoFxhtYwQ0nlN6NnP2N+gFj3PwcCJgm9LUPlpQ1NuJSThmM1REIsnah7uMl2b
	 FAoSgqgS6xmqNCrf3bEUnrxx44rsqCJSzDF3QBRRBWfFc2n9S7/MTeFBujHJ4h22Y+dKJ
	 Z1CQJZsQsGmKXywKlgj9MUSIm2BJnYqL8RKCofpDPcl+CoXAudl40BMxIkxZwICaew5vv
	 XLdzyUp8li3tcjTW6XjTkU18wq4L/NhvgpzZ9XhXR2kynfwcYQxyu5YmVrH1vKsicZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318319;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
	b=EDRa+Dp0x6kcEhDBLnrC0Q1VNAUUcd5NEDqclyTFvKOfrNqc/1yGpOe/tQR5E2CoEcuV
	 4q+vySq9UDis4ZRJoyoUtE79zjBIqNy5aoNhYYISDKfPjFMpsnBrh0chlmpknp3z4m9JH
	 DEYSc0191yeH9Yp+hHE4lGQ6H39x6c7wD4W5pDjRW7khaRM/v+q9bSl1ccKYHViJZ/YiM
	 rioJSHhP87Fkyu9TVzRDVLOrGMTNYEAt+gUHJtrJVXkT7DeIjl7NcyHU2T70l91Y7VmKx
	 EJbF7f82Rocqj5Vj01XVE3Jdxq7v3RvOoqtegashHNhpe2B5ThEkL9lksBK3gN/LS6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lu395DuU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.45
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829C0606A332;
	Tue, 10 Nov 2026 13:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 829C0606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lu395DuU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHz6cvpduZd5wWtL/hZFz5LCGr36ZCv8Y0lbi+dH+Zx9R0d646AqpGICs67HEmHubtcz2qKEzuJBccMv62tTU3Yb7C4YEcm/5BMuwnY0ICDqpCMdw5LZibFjiqN0HlFocaqCZU8kn0t09S5XuM5586XB71WLWpZ18VDT4c3AMbCYF4ll747XHGWIDK8e2ctkUDCvcfCpXK1mCibMJXf0O1hbjmdzzbXGfnSjbDPB1hAik3VgLJrVnXXipRGgL1iZw/gCw5rILsgbBVMaaxob552h1j8GaDouOPFx9f75N+AiShs5rnkTOFVBwb46klJbOsAEUZtleAafKPZxCSrYEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
 b=ur83t2Z4hBISriLuqfGAdXnXpxdbyTW9dOngz6UaitfY+GIxMVullv0/dp0tN6wZVUrEAhEHsvJCREkafqDpXDcDJ9pIL8PIKerSOx2+eZPlR2lMaAVFbobK1Ga9oAlD8pfPX6weIdH/14TcaYxt7Ks073o/ARTVbySlBYRqqDOW4qVzKMfyn7X7uNs0E0SQlAawZkBXOlXvYOhI8JYVHy495RVyUG8fASvtBVj+hRkUf7YEVr0jQ1ww0T+kbZP1eGGRyPdhigdYWGH00uwXnWEpgAgFI0Q6781w8VGOf1GS+xRvrFxoVyiiDkfBlFUelnHnEBOaHKIJDrfkjTS+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
 b=lu395DuUlKOy8siXmC9vyVCqTkeeDYcCEfPdpQry4yQd7lJx3VHojeXTXNkzrlxOtlJqttn66vj27FKnIbokEgKsMf53B3QKidwtiiNeibfXD7W5qU/fXu9+f0kXXClyobAC4/b12+R2coQQEsEC8aOhyGN4+bjT+Ggoh9/xd++mb7kvgAQtqpSisJESMOpzIZWMC1dBEDk2oI6ghdg3e1lLovMDDAb31s/5ncvGKlcDNskw52WlBD3HYPVWwDODi8um0UyfkETWzcqK6f7WcgnUHemz7HoI85E08zkpY7Efm/z68WU5u8ugggpJWL+9BsBJfb3Ev5ulvwgL+btkFA==
Received: from MW4PR03CA0001.namprd03.prod.outlook.com (2603:10b6:303:8f::6)
 by FT1PR12MB475569.namprd12.prod.outlook.com (2603:10b6:170:33::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:44:31 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::aa) by MW4PR03CA0001.outlook.office365.com
 (2603:10b6:303:8f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:16 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:16 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:12 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 06/24] RDMA/mlx5: Reject QP transport types not enabled by FW capability
Date: Tue, 10 Nov 2026 15:43:02 +0200
Message-ID: <20261110134320.34408-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|FT1PR12MB475569:EE_
X-MS-Office365-Filtering-Correlation-Id: 20de1887-beeb-413c-89cb-08df3f30bf66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|11063799006|56012099006|18002099003|22082099003|6133799003|10067099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261022105027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	ybWqp8GLEFKH+Q7hIAqipxDV2/1CeDtwInSGLafZx/9v07oNka00ixIiezbClho9CVZnlItSiuAoHFd1JzmTzmvXW2YoOe+ZHnqSbdJsEm8GD5yBLdVIQy997Pd53po6k7EV3naX8n/3h5L11zi7/zcjD0Vl2grDBnDxw33R5DTyW+JfrixKDHg6NtNx7jzbu8BYcj8CrG7r16Cb1WdxHuw7Zb7N44GgeOym6ORWmP9VoFANF3EmNsk0AfA+DAABNF3MwTMEsgMEVC0hS7ht+MNMtPoHHML5jf9tZrvbllj0HlFkd8u4602Ra6R2Kert8te/syrcLLZjVtvL2eUPQQUP6Llcj8hQkleevPO2hBqowSoW2s+mWhFlyPOaxKkyJkZE1F3CbwufwfhgNV1zsJRr3Y0BcbPR3sN1d6A7vo4FRyf2S1gM/IXnvwU8OptRa17qFyW2v6MblIyu3LPvi0unEcj97Ymlc1qxS62kc3P33im9DAUgLrnPOdghsFNMQL+0GBvWo0U3045MwvLHOilVHU9M7sDkNAmCsFTjFx2uNsNqJNEmOGct/yjMJV6h81iFRd+W35jDk/f1VguN3u0Ke0m9yv7DiH4nGUJuM6Q5XVdJblsZG3KxeNo2iZxzj7TFxHfhQ+SMPh33tg0TNrCd+h3B2tD29eVtjjpN8O1IlMraaTN3fwLHLpMVUD67BQMyVkNzfRip4EnqlLYplA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003)(10067099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Bnj+Hv0C0XOeZnm9LyMeOkp3Jbzui0q15oWrycT7U6fyBjQBLWlrM7jlba2Miw+SKMglRxe6c6tmQKwNQIledaqby3SbGrO4KfOaL7lnSd3mi2+WtM4kf215Ofrhbe6Ddwg5AqJtUPGIAc1QZJ+kK+w68oIg2l7Si8yrex/lQNi8ORGhOsYx/SVyaz13uPjKMgxWB3AfqFntUOXSWUlCb9HgY//6ujBhjZ2FpXkJjxDBHSu32sDuaj/WHmyeMdtJnmtkWI7bqngcQKtLgOgLbmKzUaQciszmDLgYjmD2UxW6auo+2KlNLKtSvucPVb0Qkaswvf3ng4P6TFfWnXkkGAMMd53GyWZYcHGPVgy5VWuJmojaPz6Fr/mc2dq4wHBmPoaO697RsLyQpf/zkeZ3nkz7cxGlBWnggR5M+s2+Oi15liAMQjhXxvTndm9IFSJQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:31.1062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20de1887-beeb-413c-89cb-08df3f30bf66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB475569

check_qp_type() checks the FW capability only for XRC and DC. RC, UC
and UD QPs are created even if the FW does not report the matching
capability bit.

Check the rc, uc and ud capabilities as well, so that QP creation is
refused for a transport the FW does not support.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 627dd17804c9..943ee5c55538 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2824,15 +2824,24 @@ static int check_qp_type(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	case IB_QPT_XRC_INI:
 		if (!MLX5_CAP_GEN(dev->mdev, xrc))
 			goto out;
-		fallthrough;
+		break;
 	case IB_QPT_RC:
+		if (!MLX5_CAP_GEN(dev->mdev, rc))
+			goto out;
+		break;
 	case IB_QPT_UC:
+		if (!MLX5_CAP_GEN(dev->mdev, uc))
+			goto out;
+		break;
+	case IB_QPT_UD:
+		if (!MLX5_CAP_GEN(dev->mdev, ud))
+			goto out;
+		break;
 	case IB_QPT_SMI:
 	case MLX5_IB_QPT_HW_GSI:
 	case IB_QPT_DRIVER:
 	case IB_QPT_GSI:
 	case IB_QPT_RAW_PACKET:
-	case IB_QPT_UD:
 	case MLX5_IB_QPT_REG_UMR:
 		break;
 	default:
-- 
2.18.1

