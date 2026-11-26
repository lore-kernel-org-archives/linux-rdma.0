Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795721819;
	b=ibHrtpZBS/oCm/LMe0jkWh4rj58L/i83T/Axij4QV2YiJp418Bw1fY2STkhpXIc1gqtW
	 nRW5g4b7M55ykETKCsZEGvADNIgCWOvcKqLomTN+k1JauSvSMIOAag+apm/MEaOexCB7q
	 fHkHjPl68ifSs1iRQAuyh4N8C1nMTqlF/9Gr05PkCHOSuysPFJnyVq6UJ2xnuckTrAQr0
	 cjHYelPmRq5dufTU0wnfghei1hU4QfTlVZ6E8uTU2qvzjRlaRf+fhEnxoO++QTZW2caxg
	 7ioCdHvRgXUViIl7W8qaaNz83HIPCJJKzK2Nxsa3vqwDn5Z32ht8FeuWzp3so7jS1YQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721819;
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
	bh=XKaqQMcZF95wOI7u5hjuDsGWawcXR/2Mz/XJL0WzksE=;
	b=Q+24y5vOH7xBPP4v7zD4487sNymNBebCVuOrzJstCTN2s2k9/n6R2zUxQ6lPWp/pXjd1
	 o5BOlzKhLIX1GoMZtgiirhma+nY+5rU6StVt5JSnITerPY11bs018hJGK2jSD7JxuRHKd
	 svvE6mdgbTzBpDD0vf5ZJBrp0zMKOe7i8UyWSIDkvGQ1cc9/AtyjDpVeX2FmOpfBG8rhD
	 95IWUvNWgauUydZDH6xalOnlGo2sVrdF8pz5MRRRLriYU1l4Op7ebUXR73YOqOhSlFOJO
	 JC2YwN5Kb4guhFdnCOOElxv6o/mDAdHxGMbCruLr5M/2H2pwjlsw0N94mUix01E3xlw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r7a6XMVb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.56
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011056.outbound.protection.outlook.com [40.93.194.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33924606A32C;
	Thu, 26 Nov 2026 19:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33924606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r7a6XMVb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CkRPLz5Y8CTbflmbarS+fU/wiyfVdexbgWbPVEsEZH+agm8FWd7YnTdUplmBh1lj3cb0MkGWFvmRbir3sjzC+7LWGzCSnCkAgSKPC1ODGJvCHaZG4imJlEmBMjR8phgIDzP6itHEEEg2IwXSFCzkOer1VaUQ9590EEmfK2TftS9Qs/EP1+wFoYs5rgMaaYT2IOOQWGTA7Nz204LkUMMrzxA9xCgNembXV3pG7phVxn5jqpq8iUY8jjjpCsYvsskSkcpornDSs3MzmWAEvqIhawb6IWKi3ApMA3jvb4qndAEyUp5o3ZD4S7QM1xgmZKgHowPnqzhNo/JWDNytw9S+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKaqQMcZF95wOI7u5hjuDsGWawcXR/2Mz/XJL0WzksE=;
 b=JI71J37vbQszbbaazOjupICRHdA3z7VpWjAwKlhhUHghXmHcVUnUVt5KnXIh8R7rqwS4K1cEnItle8XobzIw2hwjf4PWSh4ThAMu9RcnuW6HYoIvIw8Uevkjv2TWTvuD/CcbUL2ZhEFgjPcoKVl4m0c4GNcoifnjW83i9mW9eaoxu3+SyQRGocCANtxjl9QuWcwegNs7Ad2Qvq+A+mwjhfdcMVTPJ1ogmLgDpCkFuswnCb/6u5Ly3n5B6Qw1iORACv72dcjVXTtdknCQvL+nVuO/JQU8GLykGx6jGG3CLszZUivpyXHODrvEM9uq4oarO7bIC1l9CfNmYxUxDE6TaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKaqQMcZF95wOI7u5hjuDsGWawcXR/2Mz/XJL0WzksE=;
 b=r7a6XMVbveCGKfaENnYZRB+xwjTZ/QwDXURsCqUslOSsxj1RISK7DCCSEe8nD5bwEwDUzWzorkBf0LD95ChLMNJ0bA9+WXawm3RW4MyiyeCl24OqiPqVX7gmExbc5I2QeT+5uYZa4zlBZ8gySKPgjAIoI7QBGZf53c2M7hWYLM2JABrtN10iS/ckqTkWCyy9pNoDq37YCDRSHuywGnOkfl/btGjGZaPN5KUHUIJsaSGfGbca9wWWm2lQYWg2EGYYwqudSJOY4E8d5CN4v9YI2vS0jDNh+ayPWUsWU4pgnp+bNi3vL+IUmM5gW0yL2Zmj7dliFTjrtgka5mTHITueeA==
Received: from CH2PR20CA0026.namprd20.prod.outlook.com (2603:10b6:610:58::36)
 by PH7PR12MB7454.namprd12.prod.outlook.com (2603:10b6:510:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 19:36:49 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:610:58:cafe::2f) by CH2PR20CA0026.outlook.office365.com
 (2603:10b6:610:58::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 19:36:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Thu, 26 Nov 2026 19:36:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 11:36:38 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 11:36:37 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Thu, 26
 Nov 2026 11:36:34 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/1] net/mlx5: Add PSP header extension length match field
Date: Thu, 26 Nov 2026 21:36:18 +0200
Message-ID: <20261126193618.725006-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261126193618.725006-1-tariqt@nvidia.com>
References: <20261126193618.725006-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|PH7PR12MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1831b5-19b8-4aaf-909e-08df4bf49d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|36860700016|376014|6133799003|22082099003|18002099003|56012099006|11063799006|261021121427099003|261102123227099003|261009223027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	xDdvqJl1oNn4B765IoaXImE2dWGg++4oewRYSpNs/jLU05c2wrE5GuZJ2tnuh5ic+sGVVKhhWykZK0SL/10wvotA/ZGt9qe60Tfh+JpZ8YWmsA2qO7ittXycXaufD90E5+eoSL24/OKTViNu23xOc2eJxv28b2XEPUahe/pyRD84W4VhHBH1mHKih6HT+lddhntZ0TrWBI4mYzPlDBkaJ1mZeqFz2tXJXNV4fIMsGmFE/uJnmZf44nVk5XP8v6jVRciOZ2m3vza/3hXdWCF2qeDoUkVPlxM+X7sDkyy1Bng7ov/C1WDTAc1gNR6HuK3Mv174YoduB3+VnsgV9UQoFeOJEdRBQsE4IcRQRjtYwUP+2LLVaQZ5CRfmfkssEN3VIU3gFGYQMOqf9DWVcXtob/y7oeKU2a/fvU0mv4n2DonTtBujY/imh8Ba7C9u8XgYSFafUneDRWO4jl2ZzatxdUvZb2d3vP4wQcXu8iwvf9/TtqNC8nTSmV9krK9pqXyXoDNwgo/5Dt4hCPPg69QXP3VjdRBtb51XaUbf3XekFuWLX6Nm3j0DFCHsjFFAf18XaUTDCh0f86zlMK6PRqTVGsSwjDCJHglogouNP+StP/LZfVSTHB5YHEZQS5LKcn8yuyUBDY3AaWmWEjU61i5dDE/s+xhoQMnkkoA8xWv/NcpIXB3WRZgMwCRGkhRGtgYw+3a+5W2H2sMFfP1WYN5gaQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(36860700016)(376014)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(261102123227099003)(261009223027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1qMgYS35JWUeifHumulSjYq1zLZ7zpjFMI2jQfqZZOz2x3+WsNGTvd4IHESaADBiDuwBupFRxycDyrD/Aw8s6M1rX0a53KUVsbYB3YYyyZ1yiV1tl/xvxn/jSxSMdH5DYLIQM0ldeAf/ShpQGl2k3gAliXTqFNdDPnKojpzU1WBIjm0lXcq9Uhyk5zUhSKzWCqpZL5UhBWTBXkMGQrmP920OMzOJ3HEGX4PAK1tGhPddvaLml1fxiwGW0F3fnLbBfDDWaPT77WDQgTV9B1ZPaUMMGOS2CtiEb99qJS2l/2EVkZiQMxKBQa9MK2kisEVf8RmnXvvdbFZ58jbINMzGqKELA6PHN+++rZS1KaEqbQIx29vh1uxb6Wfm21FW8qXYbJdqogrh8M6bHMP/PPfY1HclgbkGZEkaFqb6k/0lxniDQXe1AldGODiejL4ssGUe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 19:36:48.6691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1831b5-19b8-4aaf-909e-08df4bf49d04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7454

From: Cosmin Ratiu <cratiu@nvidia.com>

Expose the PSP header extension length (hdr_ext_len), so steering rules
can match PSP packets with extension headers (such as the virt cookie).

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261126061904.387686-1-tariqt@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index cb9b8a908523..6617edfe2a30 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -800,7 +800,9 @@ struct mlx5_ifc_fte_match_set_misc5_bits {
 };
 
 struct mlx5_ifc_fte_match_set_misc6_bits {
-	u8         reserved_at_0[0x1a];
+	u8         reserved_at_0[0x8];
+	u8         psp_hdr_ext_len[0x8];
+	u8         reserved_at_10[0xa];
 	u8         psp_version[0x4];
 	u8         reserved_at_1e[0x2];
 
-- 
2.44.0

