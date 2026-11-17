Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935439;
	b=q+HDxYXAq2ucjlffbppbE02MSJNUWbw7p82OBXcGJIMWQ7/tLqeaE1s+yhIWy9dISUXe
	 +22VjeNWBgQnJLZUNjzW0d/Jjpj1elAqMnlRi9jvde6w6V0sOFpt6LH7avuQqnIrwS3hh
	 WJGn3wIMGFDGt730vshm6wlai6pClRDnTCMQLDzzvu1ZSseEjOYWMU4jaMsnO5l4KxGyd
	 iubElCd2IaY4LmJlinC1QrNYqyttYsGu6Rfrs8F8W+5Ih8cGuCUJibpUJALpl1yVXazdp
	 gEM4PxEsL56rox3l9dDN8DWGlEUnKRqA9thAlu0fT6h3yYSLE/S46FulwNbT7Ha6syQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935439;
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
	b=WyqSPQr2bJvpVoiLp4dSyovZsOG9b04MCNdxULSii/siS9KPWjtDJJOXho7mWotjtuq5
	 h/KZOmOvR4MMt3NhEXduEYwlKJjSonT607HZ4URD4/eeO2hKHkSe74Lh+omdM6MaNIfzD
	 uQIHX6exQxcsGfGf4GTrwWgYwY4CMYNpuUGfozb9Ab6K8W5neF1SUXCCS2V3lPYLGhdTB
	 ju2PJnt51GlzZI3BM+0u/81DFJUHcogrVs8PbDO5KLHT1cbKMaaiIofNREygPyAif9qHp
	 i+v5oWXPVjFF1DEPIDpQPBggnbk0DCEb/3LgkXZpNxMNyvbx+ehP66E9te0UlCVbEjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SdXMRct6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024F7606A8A2;
	Tue, 17 Nov 2026 17:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 024F7606A8A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SdXMRct6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uT4B2cr5QYG4I79j8nJRyBXUkkAs2WZ5ISvOzS+3F0yw+//7KZgcLrNKnGMEfZXhoBu+vQqkX7zv+mRmGVLtk5vfxvVBcxHCSdC6EosiexAnMlEM8lh9MBEfGIwOuM6NK9pSfyZE/a88bKuR+UES9s7aeI61BgxB6BQTJd3TQsxMnxoawGJhfjKXk/2tCTBLO8+u9dZi8rjNHSHq3e1LVLRvNfJ92nih3Y1C4ZvPeFZ+R4j7lkhuM+YQ4Qe2OKDTFN9MUrTLxCOf3P5NKEUg7w0uGUVOPa+M4vPr4Vh+LA6RUM/GNbCIQgMgsg4QOogF5F2nQ4HkbSKYdmEPHN+kSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
 b=HH3JPeOhourq7fZ6z81PaN9JPIpN/6gNTFU4pXQ7qdsh5D9ECJuYpI/29kBzftrYbaDSYtxXcSUL8Wdhe5piaI7abUgKmbqf4ncj8fTlVQr7EGBmXqVsLnBcGB3xsy0q+59iauD6Qr+XrzN8z7r2wOYUfDT/gEnYM7C87ApXlVh4Op95faMUhI1VpeWKR4YRG69wNIZeGKA2ROKpdBN7L9zuZ2P2lptTEnmqhT8Rigs3uxX0DMOUnhTh6f6obzC6KZfq4ZQZRK2gVuAOR4tfKaYxyiBdNxHxN20ZmjvR9Q+Sh99iXmLjz5otAgAuZPGNLrI468OGN0IdohRQ82GaCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ry4DLIPHNjgqSftzaTKrX04QUVxI7RydMWZpt8r4rQw=;
 b=SdXMRct6PueakKvezAUBf4fVtr6ELVAiHRAfEGgDosb6//twrl9wXEpnb1BY6nl1Y2UTtKevRRgQ1qKW0toFy704WCBxPv0noVjjOdqdy0jM7WF3q+cGNCi55y5994LQ0RLVkfJPwjpJfelr3OG2bnJt96st8GK7LSXyMs6Ax0sbvZlsg6Pu+gVXaiPmxoAqs/Pxxf+0E7zXexRpaKSzo+Te1UdgkQDl6gy0rjxrGtbPMAwCX2ao7274aD+rRSgB8vossrSIeq4uCxEZbBoBm4N+BhkrRxcyelIWq/nc6m+XRMQ2Bn+8Fhw3nhCcehWO8ldlgeANXVpbFuJYNSXx/Q==
Received: from SJ0PR05CA0132.namprd05.prod.outlook.com (2603:10b6:a03:33d::17)
 by CY8PR12MB8299.namprd12.prod.outlook.com (2603:10b6:930:6c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 17 Nov
 2026 17:10:29 +0000
Received: from SJ1PEPF00002324.namprd03.prod.outlook.com
 (2603:10b6:a03:33d:cafe::16) by SJ0PR05CA0132.outlook.office365.com
 (2603:10b6:a03:33d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.7 via Frontend Transport; Tue, 17
 Nov 2026 17:10:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002324.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:28 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:11 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:11 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:06 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 06/21] RDMA/mlx5: Reject QP transport types not enabled by FW capability
Date: Tue, 17 Nov 2026 19:08:59 +0200
Message-ID: <20261117170914.27410-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002324:EE_|CY8PR12MB8299:EE_
X-MS-Office365-Filtering-Correlation-Id: 30546fb8-7bd8-46cf-2f4d-08df44cdae13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|261022105027099003|261021121427099003|261009223027099003|261021123027099003|261028144727099003|11063799006|261026140227099003|56012099006|261102123227099003|18002099003|22082099003|6133799003|261026121527099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	H2EWpHwesL1O2NCm+7kqDYMGdooeWpR1DhhTprws69woR3KbAss1m696e/iDPe6vu96omhzGB5KehmFFru40njDeyDOkizmGywxEWOjVhxEjrZhd+zpVBQmLo6Zy/tv88waHbtVIqdhAP4strZHVvG8IIc6dKUt4lsMHcmmGBDbu0ja0yY1XI9ZdbLo+zTjVH/i5DN7eLlPinTP/skbkU+mZAQHuCpE4PUpthBv72lJaC+b5DfE3Ch9EDpvdb763Zy8OS+j+So9Y3gWsueRStY8RQ7+Nd3uRYDjjhlO+NY/pBzU8b+XEmZycA1to80LNM9BTq6kvzs8XM8C5zI5Ms/j/tz6tAGtBcPsYgc7g0f8ZScn3wExP0VMi7y835abtfXXoVn5ZYwbvMoP1xO/J/B3fmszsbiytqE0Ab7zNCEqIu0TxbiV+LbzbWGV5SsCJXfFcBqlHE3JzcfALNdSbs7wGKmcpT8X4s/KGRej2e1tyOGlbHQCql+WYj6Hk8tB/vz8gxiv5HuNpeIDv5bovK7CKunF7LJduC0R+KOqoIuWy9DAhM2TA4e9QgLYWdPr0WDcc4JZbs5R5WzUxFvYLWF2NxkTqU/dnTbgRAdIynew+kqIPiqgz1MeO5JTYrLi9ImICK9zK7cBTLPONBDycMz6UvG4GkTT/A7OsOdlpaXMqpsrATm9u3q0o3eoKLtXXd5i7P4eOPoTUEd9+Ep7MIg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(261022105027099003)(261021121427099003)(261009223027099003)(261021123027099003)(261028144727099003)(11063799006)(261026140227099003)(56012099006)(261102123227099003)(18002099003)(22082099003)(6133799003)(261026121527099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+lx6eG+kYDBcYKPY0N0NlZwNPuUyrQbiH8BIALLaR9j1tV1EHNBl7hBXgguLZI5prnnciUabS8kYKGdufdwt1Ds43BfIRUMay2RIJPWAP61/3kSFA5wfO3dhLouptrOnC+QnUwN86phQVKCFIXV+vN2WI+n9Z22Io2Lw6tuTAgYd5XIPnLkpJwbxb7Q3HhRDgqBcX4e1f/Dme2NtvobCYBuFWS4PbXE1A24Lhz4pBm+W3V1mjCe+Qgpn/V9UH0s5kgIvvKeg1mR8i76VH5TU6WOWq8mxGznFerwU78LVZ49paSF90udBr71QwKlIq6qGCwDN3d0oizTOv0fTVAJDhrFaTWnefvOH/gcdcmwkU1JpWr7T5o9bKUEYnP2hSJvnkiciWhx1CotEdFAofbpXvx2B2vdPWWOaDJx200LjSDFcEA0+7yanXzrEOXNEopue
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:28.9112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30546fb8-7bd8-46cf-2f4d-08df44cdae13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002324.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8299

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

