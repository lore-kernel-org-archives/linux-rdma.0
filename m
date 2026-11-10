Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318338;
	b=JGfyBzrtoEYmzXyqaR0yGyxWLCi4og9wmEqccOgsu+VAs8jkGLEzo4f54hG6479notd8
	 SQHVOuX88qa5VhtOIQF3gBMz+JjERoo1sOYMHpNJjYnuxo6SSiLALkSH+gtXj2WlnPk5q
	 jrJvSEpYGk2FGKe2l1lGo9O77kjfaOi9KMnAv87Qf/WlfhEtzux+k+1RaxzyNXbFahk/T
	 iqPT/5StfZxc4P8CkLIpoX3ni71hGBIy2d4txR5FChWDiNieDdtH1X8yys2riccaNxjLX
	 R6GfmxmvkrOxYJrGc5EPgM/dsSasUS37W15qWtIEzAaiMIVqyGUzrVkM7/cYDM8vs1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318338;
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
	bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
	b=Lwg4bXElnC9ENIGcgPmFfTdOsD89D7Hrg7PlsqpJ9E/IyXQFBh0HQ2BaY4o/UpoKNB2u
	 WEvI7n6PN12x6ogjCBb0SXmGXM3gtmIaC0XeQZRjEEx7alUL4xHH4UdW0yHtOHQnH9T0l
	 edKAPfDzZfXvLpctLHUupekX9np5mBeBsPKbwz8NxtNQyIVZj/lxdk6tGgEPlh+l4rZ9P
	 ZepSMDWe172IE6pDlLmiEX8nWzzX/z1PBrOQBIXftUP+H4AOoXvrneuh4lQ5p8k4skWKQ
	 3MovOJIyijm+PisqCkUZZieugCcpNZ2XOlUv1uKyfOV7V2KWaU/2EQLAEOr2e0oooGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TG7pMkTb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.16
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012016.outbound.protection.outlook.com [52.101.53.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C91560A2610;
	Tue, 10 Nov 2026 13:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C91560A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TG7pMkTb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZXFOnm6Rkiz9G51ITLUimn9jE4aPVg2GqcviZCIcomym9UzjiRNfpbghiqcn+8DQ3tkBaMZlmwqLTNrES+FC1uc9P7oJsZHfgaQivWjznIvRuyrXoUgQdASoUWlRgz/kLc1t2W4Vdsot39kimr9AQ8YimaJfDRT9dkUqRC2HbwpjN9wwvbf6dHcmay3fu/VIYFmLSAup/aG2WErOQ8lHbLmNMapoOZEJm1HLLtNN2P2tHKFVLnnixOyti5C0R8bzhJvrJ+plOd9+V7x741cT53Dwmo9b3Ur/8v2O6TlfxqifCAYhG1EE/QBIodKtSGha3SHEGE2Bgt5vdLJYXk0Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
 b=QZ4F1cRxuXcJ6Rz1i4K0XkRgGS+bkl0H3C1wNLfoqnnUnmxvai3RDCAOaAZ4DZ2RT2+8XDhONf3XiPP64+p0izcaFhk9l6AdD7cS7llWM7DZQhNUmQ01WF4Z/FfAZ7cC4xxmZ0ncEQyTuuMGCf2iHRLYqF1XV++Hb+Os3EvVdGEFTX8vZ36GxyaCQ4wjBVJGopeTmpr1ggD5TfvaF+BHsXGGSmHvdnAy3jSRhWv9oDSN4UKyA554O9AzlrzywmKMDFJssSTSSKKrlSNBMdMnZb4Fs32xwXSIvWl4nhVzTYZ11wSWoUfSq0wtxsjulCKI2UjU/5uNwUGbIzc1/1/C4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
 b=TG7pMkTbYemkVlQAA9wCV+oW0kSj+oGGIbAjszFSGmwEsZSpRoSSgbvfmEhvcHYT7UJzW3j/ylIju243NLkVlSTfemWaMe/XZJHFGy5KFzUOvJt4rvFbhb9nmHqpImMvs+OHXno4xjsYI3ldVV5/rmhVfUpLakF7MUgGzs9IjMDHTVogTWGpfQ/iYqO7kehqNgwPcje1Tl/uF+rGclnhn//lvkE+FiihDvxqP60uNRM146AlVs06wrnuZMb1t5N3ryHz4glpEoGGWzx5UZhQzl0066f5PlcOaI08CLKoOXJrfXGA3RzbMB72FhSugd0glTc8n7iguTRvHrNd6DFS9Q==
Received: from MW4PR03CA0012.namprd03.prod.outlook.com (2603:10b6:303:8f::17)
 by MW4PR12MB7466.namprd12.prod.outlook.com (2603:10b6:303:212::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:33 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::9a) by MW4PR03CA0012.outlook.office365.com
 (2603:10b6:303:8f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:15 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:15 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:11 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 19/24] RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
Date: Tue, 10 Nov 2026 15:43:15 +0200
Message-ID: <20261110134320.34408-20-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|MW4PR12MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dee6220-24e1-4f66-47d1-08df3f30e445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|11063799006|56012099006|261022105027099003|261021121427099003|261021135927099003|261028144727099003|261102123227099003|261009223027099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	stBiMR2XUHe1k0THPMRqM7ckamSKwcdEVaNggr3raBW97CwmYKpa0UfcURieRB6I/02W6qOBeljmxQEUPz41g77NiSRD2owwzh4af4v52wMVoJcBfeEPgi/Mm4DQlSWfWyLB5YnWwPWLk8Ueni24Exc+udmFcUYmMCR6EDaCWMfkD8gksE/xCnK/lEa5l4+KZ6TZXFOiuAm2P/EtuOSoBCasLOWA+qyGymsznfJwQ64DJX9NHrAqd1LVP1K4UHMJn608mxkFrmpLuddF9CKjZVvtPe9fgZojcwPOfbJx1w6w7t7JdfmCA2ZsBzmGY4cE0jumQ6h8KgXyJZA4iQBvkZQBGg+GaNP0evs36fe7mWCEDBEYDWyRGIdd2H97eTMludDOUnNdi8I6fda/VbKH5aRAb8jhTcbNojhJ1Zgm3wESSkISB8964HY1h1IA/pQT/scmukQFoy7KRODjP5OpH7SHIAFB8633hqR8Vi8wKrAv67jvRkt4StHTV6Xbsm/hQyVZSeD56ZWIlpZmjY54lwyMFwRuNYfEDy+SD4J0JiSADY9eII2aVZLKdA6voXj+GR3A/qce1z55z08vhGJ1tH31HIvIJ+XMSwT2zIWlE3EHtK/OWYCkRvMx0fMHXpk5dx4X0WJ+Jme6YLgKJVDmrr5WoTGQ+/SX81u/7ra6YsMTUbX6qWvoRxJjX6RFvjQqyCHyrvthheOtvqBbV9aSyA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(11063799006)(56012099006)(261022105027099003)(261021121427099003)(261021135927099003)(261028144727099003)(261102123227099003)(261009223027099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wyrfyDm7RZpWm9FtQhmiogoOT/pFNxY64GNR2FVfzGhTVOJtq8VDbh8wTSsbNgqr6TjLsGOiNi0suVV+13QhtrDUEEe9DbGqDFku643vh46/VRMimcAKuXA126egvq5DmHESbEWSQFNdVXXpway6oIv3Zh+cRXBdlY8Q4vzwzg0v4IJiBl1snk0kqmRbzWmnjRz8f4rNpRac0GavM340/AKcUdVs0x/4XntZEr0B97iFIBdc4snsf/4/3Cg1tGDjOQi7AiTzkLGREo5KSF2jyk282ZDMDdQrO5in90a5pNQoNcV7HYP70Ya+k+w1RkDFU1VLoePtG9ffvHoYrhzTbifmre0E93gTyZwn0XfcrRza4WG3KfQqV5fNHbRBREtkKwc1vhk5YvfKRuRl3bDfT4b8mcsC0dtB9ojKL1/2b4t10bWJVTHzpSo0NQMKlLRB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:33.0220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dee6220-24e1-4f66-47d1-08df3f30e445
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7466

sqrq_state_to_qp_state() indexes the 5x5 sqrq_trans[] table with the RQ
and SQ states returned by QUERY_RQ and QUERY_SQ. The state fields are 4
bits wide, so an untrusted NIC can return a state above 4 and the lookup
reads past the table.

Reject out of range states with -EIO before the lookup.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 19cbf6b2b979..05e8e75d734f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5081,6 +5081,9 @@ static int sqrq_state_to_qp_state(u8 sq_state, u8 rq_state,
 		},
 	};
 
+	if (sq_state >= MLX5_SQ_NUM_STATE || rq_state >= MLX5_RQ_NUM_STATE)
+		return -EIO;
+
 	*qp_state = sqrq_trans[rq_state][sq_state];
 
 	if (*qp_state == MLX5_QP_STATE_BAD) {
-- 
2.18.1

