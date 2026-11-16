Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794840417;
	b=w6p9Wa5eOSo5djB5Z2V8FyPyBj8a9MphoJvrlT4EIOWDVYQoQDa6Phetdy92KAinyiBn
	 AW8I6c11Bc2ab9fROcfK8DKJDtc31R/glWSZeq85dI1O44zzSUvUJgwOBE8F/3k/fJXqf
	 CqKLvY5mLWu70SihGBza5+pHFV79BkHcG6QhvZISL8kSayvSmII06qAuTKG5+NVaeHa/0
	 GrL77b0WmAObpfwAS2jEEJuBGX/XmSSpk9XLn+N6QrDh0fTjkYJKWEda93i6n7km62jIU
	 SD/rPiy3Oh3ltg8rMc3BguMdMh5fbnP6zwgxWKgDE+BFh8MCiCkP8h0AWay+z47wm6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840417;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=pxKf/uaIRSu95STzuuUv87OjKYmvZ04USwylLK7ZKxA=;
	b=VEITd1f0/QXLBMESxCcfqyrVKBCl0MGnAeTMygOFdtWBcq528cCfJoC4/9cCQjvKx4On
	 v5TzWZgb9KhQLxt+fne0Ps6B3pGpaPSCs5ZjgF8xvD1Do5BJk5K0UMpLw3DEFLMPXU3cl
	 bnHxdp6/w2xo7mGvV5nOh2g8RAvGUfibf4HWYn9rrCJv1GDLZ40podPKInEnyvQrEsVNq
	 6T4zIZs7LbRSv9o8B5K5YK/uhMOm2S2EmbdxfLS/EFRJGGJekRue9RKYbYf7QockgBnyL
	 06BOByALdFPb33nSVi9XM9IS5mxyOZAfFw8cPCipXId6axBXhdsAI/ISPz/1VFiU1qw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GFI6K8Hp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.30
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC4D606A31C;
	Mon, 16 Nov 2026 14:46:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABC4D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GFI6K8Hp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aK7Go+jqqPWXoIs8pgY4sR2TKJ7Kxb24Rzi27OyskPHd2fv3H30axkFOo0D0Q/sCRSQUWqRHiFz5OOJPd9jApFrZD8o/HyiHdnyemgcezBVyo1AJIxzj8FRr51+/LEPNQn1El6sp99dLHPTL1GKtWNWFGRkjoPdK1y1lDMVRDif0fynY7TWReS3Xu7n0zLMUxeDb4UkjnD/if1eXxkpgg9DuYDj5OiqC4pdgNvkpSOqnbwr5mhY23RI9HB8DhK/ATPhVIOv1xCg8qkod63gK7XOvTQcqYOl2iHPSGyCkwPEbXIIovSz9CoVQ6UUGz0bn5wjS5vcrBxzbWGbll4oD6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxKf/uaIRSu95STzuuUv87OjKYmvZ04USwylLK7ZKxA=;
 b=aL2OwnAz7F91LHv21F+xC2OiuYuZUOJHB+3cHJaPF6BBznAFMDz5mEj0vUKqcrFdKvLYWfdxQ3jxmEhOTdnxIY9DuPBF6CRuWJigxcHM42sFDuDUftzYHVh9woUPW8XSq77FqZmCugMvSibghUYxa72zW8Th48wH74AI39A5a4K+blCa9EH9N2u3xsD8jX4US2V5s3zBwQlhqOeXdXPFp17muKVqhc5RIBaYjWWkSGWtO5NYfJCn9m0H3C0FtHUAgQcjI8pqxtLCMWBWs4kQMbxvubinVYuqr5b744i1yMyfsC39iYnsI1fXP5ND9G+kIzsiKd2ETLZfos0u7Z0kag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxKf/uaIRSu95STzuuUv87OjKYmvZ04USwylLK7ZKxA=;
 b=GFI6K8HpCap5ZdOFg7eDtZtemQk7C4WpgPPoAZzdIz0VPW2fv+RbzYLn+AATr5HTSDmwgTShzZ8b9zmvlzhVwPNDX1e8QDexPsruWOnnKsfVYSVVGrXvQViPNYSpxaRHPih4aOkrvBzYOboXUHEjMQB8cDxdSGFAg6msCUq+f+GNBCOrqZHcugcg7cfvBcbJUr1bNjgGNQKkDE0ymAHymzj37NII0Blahx5bxn/iZ5NNrp3vb1beia+Q1TRjbKYxmjVQZu+EwPg8JdbTmaobD6ViLRE/p91NSzz77SeoZNpB+RtiE6K+eQrVPjYm2aYIxJWXSJluZcwFeXacS384wQ==
Received: from CH2PR14CA0019.namprd14.prod.outlook.com (2603:10b6:610:60::29)
 by DS0PR12MB8442.namprd12.prod.outlook.com (2603:10b6:8:125::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 14:46:51 +0000
Received: from CH3PEPF00024580.namprd04.prod.outlook.com
 (2603:10b6:610:60:cafe::29) by CH2PR14CA0019.outlook.office365.com
 (2603:10b6:610:60::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 14:46:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00024580.mail.protection.outlook.com (10.167.252.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 14:46:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:30 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 16
 Nov 2026 06:46:25 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Chris Mi <cmi@nvidia.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, "Gal
 Pressman" <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Parav Pandit <parav@nvidia.com>, Shay Drori
	<shayd@nvidia.com>
Subject: [PATCH mlx5-next 2/3] net/mlx5: Add IFC bits for SW RoCE monitor matched packets counter
Date: Mon, 16 Nov 2026 16:45:53 +0200
Message-ID: <20261116144554.1194389-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116144554.1194389-1-tariqt@nvidia.com>
References: <20261116144554.1194389-1-tariqt@nvidia.com>
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
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00024580:EE_|DS0PR12MB8442:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a6065a-82a7-40bf-b61f-08df43f072fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|10067099003|11063799006|56012099006|261021121427099003|261021135927099003|261021123027099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Fk+KlLtUUXM+UVLQLWTpt7I+/pBIWI9fY6qgBmmh499iemEDbVvauR1njElyymCRQMDK0fmxYfuoTmux0dIpjXfgGPg28F4Fs4e599bLY5L+X35T915DgsWHUA8AIHtD0J5daXv2gH1TUEhHiXPFHIpt/lhOW3iW+5EQWEwOWNQmWdUdxSq0U1EuCQbfDvu1/QufuT87LiGFACi/EwwtGpodj1z/G7yjDe3sakyEAfkuta5fwgFkPsMvuI4ReOET9uFjjcAyK7pTQhfsu8h1lrGjoQM1cW50A9V+fJYFx8e7PRsEhnRIlWzDKQnv1Cji7I4lCQ/1F1zEF229JNHyHP6BqBnXTudTuWNH8LYv+0tSv0EJ5X+X6KPh9XOeiQOCthr2jCYCAMc0idbbrTj/FvfmaRx1QZ4ZYv8G2OAeY1AWD4+OlTsDqpYtJ6pMy6GwttC1b9L4Pgzg+wkZrJht7Q645kRhPtzaxhlvsP+cvsjouxqwsOAC8gx0SFnTnlc26+WgvgtzA0Kp4pMD/Z2podSEP1Wet+oRpS+HCQxsdEWGYQWZarvTt/xtHcSGyL+26pwEUoo1mtQM8f53Rcj0qV7AfQ//i4Y99bP8sEkwa3IbNiM3c7EcioX6J9Ta6tzRD+o6YOyVFp+RXieRSN09VXceeAtINaqpA7bOwJqhZBeFahn6Ftq2IMRVTFlKpYibwrDwFwR6jaVm818iz6XDEg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021135927099003)(261021123027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VXmkPZvgMe7Dk010tqwPytcs/OPxyxa3bOigdBJTk+Fkl1oNGND4Kr0YIQ1BxfMh2V673H47CBjp6KexLPyAaui1H8NfIgpIenBNJftKhTZq3SVsQUmqNm0JHQO//mJbsfIjFrXdtK78WUxSxAcBAbtqNvMCZbJoWjG0dPogh8ite937sZ9Dv3Fe1inpamABJ7rwdY0K5eIt4mV655IlG8f8FubPn+yn/VfSzQ8jucclyhn6P3GgYoQoLSHiCmmdlgwKok1w3tpbyR7XlWrI/lJQ/twzzrLOsAOvV23SespOLU3GhO1CnOspsVPTjtuytRT8kt5Hky+sus4dVXlVm9+dMhhn2cUORr9W/EvO3R0AEOkbqltpwKXlMq/Zx2HpugI7GuLBt7YfCeNEk9RKtZx0EEKsrGb7AwhjCWaJN7ZzoQqz60GCgbj1HgdfG/2v
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:46:50.8897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a6065a-82a7-40bf-b61f-08df43f072fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00024580.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8442

From: Moshe Shemesh <moshe@nvidia.com>

Add the sw_roce_monitor_matched_packets counter to the query_vnic_env
command output. The counter reports the number of packets generated by
the Ethernet SQs of the vNIC that matched the configured SW RoCE
monitor classifier. Additionally, add the NIC_CAP_REG capability field
sw_roce_monitor_classifier. The field is a bitmask of the supported
classifiers, of which only bit 0, RoCEv2, is currently defined.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 04300c8765a0..06e17581fa51 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3448,7 +3448,13 @@ struct mlx5_ifc_nic_cap_reg_bits {
 	u8	   vhca_icm_ctrl[0x1];
 	u8	   reserved_at_1b[0x5];
 
-	u8	   reserved_at_20[0x3e0];
+	u8	   reserved_at_20[0x80];
+
+	u8	   reserved_at_a0[0x4];
+	u8	   sw_roce_monitor_classifier[0x4];
+	u8	   reserved_at_a8[0x18];
+
+	u8	   reserved_at_c0[0x340];
 };
 
 struct mlx5_ifc_default_timeout_bits {
@@ -4077,7 +4083,11 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         odp_remote_triggered_page_fault[0x20];
 
-	u8         reserved_at_3c0[0xc20];
+	u8         reserved_at_3e0[0x20];
+
+	u8         sw_roce_monitor_matched_packets[0x20];
+
+	u8         reserved_at_420[0xbe0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.44.0

