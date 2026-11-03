Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724082;
	b=yuvUNDUBiqHPDlFcBPwLRAkU4D9SKsgvD6HaWwlJq0tZAVJl1e2jSCl629gKUmMO4L7p
	 V0IyLxhxQRvHQUjyzA8ppl12qCqcrapOyjCL1eMyUJPcDaV7QatiN38Yd6/iaYjw52JtL
	 n1Oc37l8dlqkI2kBVgV6SgoFfHN5GNSYdcdyAbrIffStUuVZkfELbVenXnMSOzzQchG0T
	 FeC+Rb+rf04F6YGjErW3X/Fe8FJOLonGNdtBmZdsnp0ARiuhI5RnP66u8PcfNmb6KBpZf
	 WhtfiQxyaHpN5Al0FngFuk1c3Bmr1A0gp7snSQjBkonzCU16io+JZ3yeFozJ5whCHrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724082;
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
	b=pQXFT9kz4IlyU1V+dKYDMvQCYDZw9JYZFWZtC/CQG+fJxfV2KSyA788A1qUyVPsY+rwu
	 vXSSFBmf5cZZIOCuPxqoZfg25yAF7NjZG7h4hDjg0QLBafLHmTqXFcszPBPCiP72A+wa3
	 TXKqg6d6mlHfPvgajE4FYoJ+x84Wm5Ut9Bf+qGXylqn2L+YgHDPgG5WsBN34rNst7Ah+q
	 Sv4ejOu8ZxNtxqhOhURVpXoPSlFRLqPNYdlcR1TXJTuL+ZViM5poZN4aWrDrHCfrN7+Dl
	 lRR/VsuOiVXn04YWTe3RjNhzA6M1tqDqRW5CRnrvTqiMmWosBnjlWAZa9lsiEsv5afA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=omZF0kTd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.65
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6466E6083607;
	Tue,  3 Nov 2026 16:41:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6466E6083607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=omZF0kTd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJ2OBJKBoANc3snO+Vwe6YwaV29K+/Q/YY6EvQVF5yYxgrIIsvRvMnqMkgkRzhsxvhL4dYo2k555iYwJ9G5oo/PrtDtcIINp7MWJU9xqk+7b/VquG+8SQE0Eh8aeLzTXiSDYwonM1wr89AY/Dfx2SnpOW26+YxyokPQQPW8tdNiNDDaGO27mDsFtt7anCQBD/Rv2T7/QEcR9AObVam1XeoOyTj8t4osglfybT/ms/Q/xldy6c1J9o18MQMhN71hBvxWChb8H0K4ef+oVWU+wzjDtSSSjjGaIeyZuaPDl7A3dDJvldzzFsqeTSyRvnE02d8OKmkFzK6xCc5ZXsLZU4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
 b=CASXlSRTrfB6w/vAe4ec3lbTV4tsWsvQFhez/YGBhhRLtZgN/7/esLH9WwjTcsn3v5JZ10kZzlccNFBQmW3/v9eNE6zQW3d2c9qOluSchdLXcjkd/yibJHF/OwnHsLd1A2LxaGS+AVFxjzVa7twvitsEr3+nnEQ3HjCGe2uFazMVMdJqavD60gEEY0PY3Y2lDOeQvkpf2PhU7nWa/9TRTBdFQDzFdxvLX9u4VH/H2jF6JwWNgQfs8/BOF1/H+WCyKAX2LTOlWZtNVj7Z9R/rwQibAF/Pu/4W1xQWlxvKxY17rgRAFy9B4K+lcPq/3RnSo5bxOXWKNg4Aeu/N7UhjqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
 b=omZF0kTdbCDC3QoQNvE+V8uLXNDrrFuNwXRPWEp/3CB6ecUi3ETBX1rgJ5phvXE5MADhfriFZbeCGCEeD/lZGWRM6B8CnGo3qROTPxSdSVWP0kErvo86GpoANF7KbqOeTUksRhDnNwnd0CF5ioQbrjQNV4ilKiNynUpbXI+dsV10EoGwsqcalrNUD6Jo9uxrVv4OgEUEX9leGoQTuBeC+DOqER4me5h0EVwdtAveTNMybpBM9ESbjLV4Z4SS5EQFDddMg11n+6LOBlQrJr3E+5qLvxbKBIC+5VLkxCBkB1fDSK3Yqo/FvDQF4pIMfJHHz/l/l8YE0lhSNDGFHNdF5Q==
Received: from SJ0PR03CA0344.namprd03.prod.outlook.com (2603:10b6:a03:39c::19)
 by CH0PR12MB8463.namprd12.prod.outlook.com (2603:10b6:610:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:14 +0000
Received: from SJ1PEPF000037AB.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::3d) by SJ0PR03CA0344.outlook.office365.com
 (2603:10b6:a03:39c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AB.mail.protection.outlook.com (10.167.244.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:45 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:45 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:41 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 05/23] RDMA/mlx5: Reject QP transport types not enabled by FW capability
Date: Tue, 3 Nov 2026 18:39:31 +0200
Message-ID: <20261103163949.1554-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AB:EE_|CH0PR12MB8463:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e0c05d7-cf30-4f42-ccbe-08df39c94697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|36860700016|82310400026|261102123227099003|56012099006|261021121427099003|261022105027099003|11063799006|261028144727099003|261009223027099003|261026121527099003|261021123027099003|261026140227099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	6cHx+0WoTzmUEjN9yS1ZiFBsPvdz6QHDPDk54SBfuZx0lw6XCBL8rmz32enQ5qL1Bc442Vh7fccg00ZojToNuT24BefjCAG46HCa+Vn6P6OuiOuhbn+ZbQeIqCxJQl67yANDFKhPpXEFVCCSCAkfNgATEWBMuEaNSuB5G23B8oYUt2syxu3oJxf9VxH1dEVdq1WKQxw+F3oITMy0QAlVinZclNn3+/ANCKHk0NV8xeZQU084NeTTGK1Rt8u+3b2jdGSuqWiTtllMFD7GXu/WT8XIJIAJoT7S9rQBfC0JnQrJgJwF2W4BnodLkBo/41wT2scUczFRNMmhBJB6Xv2NcyQOKiawsvvFf0hIc93u5pnFu3ChJWylc/eb6WBbrjU5z1GrYSSZQqRmPAeI7uwdfTTu9KzQuWTZqKoJFh9m6pG234LG4mt5FqccP/5eJc5UULjHA9oPEPX+MYTLMz4Hkar0KXc9Aacwcyif/c7kTl8Fsd3U6Q6uGHrCZ9gI0377FXYb/490Sv+O6AQ1hcMqexV98+ht9xXrIsx3jQRDo16Q74XLmjbmFwlo12lYYOK/q1FWSG5KPOPQABpccRuZg3giuGE8dx3eOOVXyRwqCGTMKnEY9szgOm3mAsfGn85oov/+wWWMNwHML1Vr36hfKtZcETOq0zO/0aDtjgPmCQwl0pQGvRXadvIU/RlKQnrowvsIy1FHfh4q/rcUk3lpdg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(261102123227099003)(56012099006)(261021121427099003)(261022105027099003)(11063799006)(261028144727099003)(261009223027099003)(261026121527099003)(261021123027099003)(261026140227099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QswEVChDzUaXzzz1YocC1AYMfSIRHk31x4IqOD05+tBvKsLSW4oQNCgvhDOBmiNpAZwNd/Xp68v21QlR2PFUg6LV35xb1Yw6kTZIv/oUAz/G/IkIgMH4PtZSuMnE/dnL2BLu+F+pxgYdoqYYJ1fKzE+C9fsGb0s9iCQ4NVpLTYKZ3EIs+yZZMbeRyA9YRIJNtWSdYjQo53A5dwJI9CI/XaueJ+nvTpbAhEY+R8tQiqyKiy+MXsV/Lmp5G6Zk/wlMoqJej3HxhvPgZKAXuAI0R47NbBmX6JeLbywkRTGekAP7TADLq+aO3ru6GxUbHmWmFjg2fmbPoGYDah+JE4p8gY8nJeuz0cTB6aSFfBbpiXl8M4Tl24rLYY2mHWPv76L4Gys09tEbD6AmTwXBBLCKM7NNciJCu7bo/WHgD7gF2O60yIkLQUZqTg0nVl2ou/U8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:14.4075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0c05d7-cf30-4f42-ccbe-08df39c94697
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8463

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

