Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729625;
	b=D0Syxh0+UPMWv+u61GJYgJRc2/EYSGsNeGxEFkA3Gm7Q5MBakxPyiuJ79Cj0dRw6b4hG
	 enT3zPToeTgJFyVi40uYuFrGe7VsbiXsngQYLd1upz0eC2rXC4+qMhQ+PlZyCGW6KHlxw
	 Qs0ik1dQh9Gqq0FMfBjaBendIrqKZtp3KVPvl8850tRw0XlLlBqGgD8umB5EzVkKy4zwV
	 8HMgq8HkcJ8kNwv4+zloJmFN8sOCd62hEzs1//zQ8bu/IGZk80/S3xGuazk6TOUhwELR4
	 SNdaD6w64+lAKmEjDDmnea+I8zfbT+/FK53m2bWTI6qZjBKNz2i+lRGpeCUZOh92yfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729625;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=xnA0YLCJu5Zoxr/YUts3GMxFlJn0WEzEZR0OZZ85DF8=;
	b=Y1DXFV2FP4iBzbv6P5ObP17NTJTcsg2A3YKk5Qr1hIjj8axDsFzfx2ImNKpwQrK7uWBQ
	 XO002KV2dDpROjIXgTw6jkBNQ0x7QVVNpEQBmc+N8BEXn7QtAvwMjjDDYdZZWKvMUN0Kp
	 WZEykBDJ5Fe7koIdXQUEAYvqvKiNRVFvtwQq/Fw5U0Qzkh4GrKnWRUPVAYnlv+S+d6Laj
	 l4F8uD1v97nXfqWWmefJWsJg8tIG5UWva7W/HYAINwq+aYp4hDVIUhmQpgX3QAlXWXloT
	 yDY8VybrfBxhYh1uird5lHTUyyjCGFgNov3pLVJDvaZ88BR55w1J3Vbhz/5BtMFJ5/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NK8dCG+L;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.71
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011071.outbound.protection.outlook.com [52.101.57.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789C5606A33F;
	Tue,  3 Nov 2026 18:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 789C5606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NK8dCG+L
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=toFIXYm2iC1pVsDuSNxsNqCkZEmBxMW+d/j5KXqUbKBhaU9IwVx5Yia0OPqi5wsZjS7X9reHnyXInZvZ31foePCwnG6hYl5aJA0urj5pE4Si6AfnJbxGMi6YPmp8USkCaQZWDPYdTjouTjtK3nquUfMTZ5DGiMLV1qE8cVMbnkepY8/fzUN2rFeD5Av/2k3Jw5fcQYGmpU16uxYow/iYbN2jAIqE0I0CUDx/4kF4hl6ytD1vhZILZ09/Q4RFyc9rHyYI1kQtG3D27aXbVi2cNBbRUJwSQnGoHrL33W+Ka4RECYvO+cCpmcISw0L7unpxst82v6fC9mpGp290SQ7YsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnA0YLCJu5Zoxr/YUts3GMxFlJn0WEzEZR0OZZ85DF8=;
 b=ivDaOFNv3jd9ukdv6sofd8NoD6oN7GuEhHlejgAVJUlON5IzLAFI9JRwyLzgPA43YJxk2wX8M01KIBXWg93v4NkZMtZCbG6phBkq5dunV/cAdJPZvpg4J8G0+27JRYVNWCXzPEkrBSoeuXpHNn4xSpAw6IgDrPXKVQNPqUzCNT1bnyokewmobOYK52U+0jE2IE49zMJ7bVe1VeCKKLA9hVKfNMTeLEFFYH4IpE5lgEsyZW4qlNMd1eFg5BjrqXmp2ascuualzg4s0iPNJDMnMb+Ng6IGiYGcfs4FQJCAIP2vhAJZA2GudpVQf8mg9xDzJMZUdNbnd+2d+KoTww/zsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnA0YLCJu5Zoxr/YUts3GMxFlJn0WEzEZR0OZZ85DF8=;
 b=NK8dCG+LNj/vjv/peQR3rY2OO0OjPur8TVpUxZMxD9Dof6DtH6as93qADhsHs/93ZshDEJDTjABGn0GTqAkcJeE+Goy2cLc5ZuKSrb7gNsuq5Rtc1Ww/9retXtc8M0H+yy6KtKp6gsm3vEOF6HbYv6qpMXq4Lj0vyM/8ubicrNNp6LGyrBhj1mO6ZrEUV6pY547bbPK1RQl3rneLBHb6PGMP5xh4JS14G3H2/SOQfZlyjhrIh8SyX+FD4gKHNj7xuRMmKGAD4zui0AgeYEL4py32wMm2IOf9ZDdAbnzOQRiC6nz1xVcRUFjMny/RaSNjElHcBbJJg6XOdO4UG8bHdQ==
Received: from MW4PR03CA0169.namprd03.prod.outlook.com (2603:10b6:303:8d::24)
 by CY1PR12MB9651.namprd12.prod.outlook.com (2603:10b6:930:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 18:13:30 +0000
Received: from SJ1PEPF000037B6.namprd05.prod.outlook.com
 (2603:10b6:303:8d:cafe::3b) by MW4PR03CA0169.outlook.office365.com
 (2603:10b6:303:8d::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 18:13:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000037B6.mail.protection.outlook.com (10.167.244.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 18:13:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 10:13:04 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:12:58 -0800
From: Edward Srouji <edwards@nvidia.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@mellanox.com>
CC: Edward Srouji <edwards@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Michael Gur <michaelgur@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Add NIC_RX_CLASS IFC bits
Date: Tue, 3 Nov 2026 20:12:49 +0200
Message-ID: <20261103-rdma-rx-classifier-v1-1-1ad6c8cfe936@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
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
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B6:EE_|CY1PR12MB9651:EE_
X-MS-Office365-Filtering-Correlation-Id: bf042c78-e5f5-41b0-af5b-08df39d6291f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|23010399003|1800799024|6133799003|10067099003|18002099003|22082099003|921020|56012099006|11063799006|261021135927099003|261021121427099003|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261021123027099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	y6JwcLEaPoOtUyP06b4fHdyI09Sr8yNhsDQdwragJg0OiyE3Ps3++mai7l+ahQZA16eQ3L15G1k/Q/nZrjo0Q2dIFWVMObbLo4u/oFqw9XSzrSAWxJBpyXa9wfpIe3M8F1CmZ/qUe5WedGAEnsHNms2LGg97EMw27ulkVozR+N2IUsB1p/CxGdquC7y8AfsEAZKMz4KwMk015KTeDgSn+vjmNXD02JkF+SOXbPs+m1EE+/lVaeqJoyq/YNJDU4R0jXhYqhpxXrAa8Y/JDjhN5sQ6JtztbBMqXzG0LFV7J7Esz3y25WY+ml1jrnIxFgOxaywgcR0s9tIn0wpzqQzxrHaOGoyY2D9XPwUtZuBN+DF70nK9ddXBZAWV1fZ4wKa2f4hv8luS7pSMZ7BJ3dVQ8jB+hlOpB8NdrUeZAUsfyvdR808KmSIHfcHbsaYA/ApCCjsbJwLIkNJt/Tz2uCl8aoX9FBCFW3X7ggRxyYnjk2AzbBEMU+gcD3EeHoD8904/wVMlsZx4AeXR1CaiiUqHS9PsEuMn/BIMC4Jixi6HkGD2qGhftddfv8I2idqOYjFtFuocy7ft0tVXwke5EimMY1x1nxdVZaer40gf3GMoqrQ3EOQbBB8ElAqYjsL+mLocA5vFRDmGnybY7nLuvdEAnWOt1CvNCTcbR6WEiTkJxcIBQ9bO1gasIkTeKmZK2NTim7hDU8bpG61IrvcuympG5CoygDSnbcFFk6fBT2vf58xfc/bJOw9hdAbfwEVLvcTR
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(921020)(56012099006)(11063799006)(261021135927099003)(261021121427099003)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021123027099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LGjDQoDaM9v7e8U7c9gf2O1kVHw+nSNduQWktDDj5HmHSsdHOUELYdS1PJ0uzmV0g+E7vVsjvh3Lqld6BkNtfPjPnhbF5H9hThWbQW9/CZoUODtpH5Sa3H3gPjAi5kO2ImT+oMqIOageMVArG6eiwjm1DU0zp88hNuhp3s+YAa8gtZ5SlO/SiCIAOjbc4SRB7pdUtTv8aO0xlhd1qNuWSRxlJniUzonG9GVQuU2FATuc2eyD+N30DpQGApJUb4i8SW78uJvd7Q8TCyGCEvhbm74/4Crn2X+jzo9BzsQw8PAR89rXKNOEbkwszb574/o9W7ULbLTZ9AdEv2Cgm1a2aMPGzgAOy3jKen0MSxClVF3k3K+EKEiroezPfa5HqTCSB+h2kF21lv++LEp1kwywabAba6ViknhTxT+zwmJu53oy8hyjk4y9izalW0ItaKnK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:28.5143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf042c78-e5f5-41b0-af5b-08df39d6291f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9651

From: Michael Gur <michaelgur@nvidia.com>

Expose NIC_RX_CLASS capabilities in ADV_RDMA struct to allow exposing
the new steering domain to users in the following patches.

Signed-off-by: Michael Gur <michaelgur@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 697fc9387b73ae1dd2305d475f7fdc767a1a2cdd..a7cf67264a1799ad179938907f5c871c9190f9e5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -13690,7 +13690,14 @@ struct mlx5_ifc_adv_rdma_cap_bits {
 
 	struct mlx5_ifc_flow_table_fields_supported_2_bits rdma_transport_tx_ft_field_bitmask_support_2;
 
-	u8         reserved_at_800[0x3800];
+	u8         reserved_at_800[0x400];
+	u8         reserved_at_c00[0x400];
+
+	struct mlx5_ifc_flow_table_prop_layout_bits nic_rx_class_flow_table_properties;
+
+	u8         reserved_at_1200[0x500];
+
+	u8         reserved_at_1700[0x2900];
 };
 
 struct mlx5_ifc_adv_virtualization_cap_bits {

-- 
2.49.0

