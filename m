Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724140;
	b=A25nm0fAj7yC54aBbjklY6WLwHYm7M4z6ZnN3lea16EDLfuMbH87GxqiCq8TK/oza1Ts
	 Ve94bvInefyVk1Rj+cgitvBLkzY3dNAKkjxmoC9rn0NUDCtzXJIcnYZbDUM37T1gaQwsQ
	 p+fr91X4mhayvtV4jEFkWACSWgWmQwcLe2mbjW6Ss3+0Ts7XQ2iy0hTiwYRqlNj2IZpGD
	 jh7L9yVYFBBQIMTSwJ01LMon5zIo+6YB9sd54D9YJCIE4jIAszeXgwsEG0l26ARuZjn1U
	 OA5mS07wHbVSoK57NpGbqctcPkWMAs7noKLke9TuUre2nAcKwDLK+XzL+zs3c4RAdEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724140;
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
	b=kKuKHo+IAOOeJKZF7PfYZdwPEeSekCcJ1ENej5ATij9iytTKx/l9G5dBH5B2enBXo9pJ
	 BpKpUivPNPGh+FH9jEGHgHWoA/69pH3ycAUwAui4ihY9TqGC9jgGoAfzmA/p8dkoIzx/p
	 o/g61oOgXIfXtdcK/qexTd+22pN7ZVHHA9etgxNq4yeTTDoerxqN8D0f5eGJIPuacCkX9
	 xAVOZhEZ89gIRcYLu+dVNVK0Y0wB7Y5CJ+36SnYFp/lSatHV/YayrrQQjBZQwVPeWNrm8
	 fMnStnftvuTs4LfrjYfHV0E2/POoJdR1Uc/UfCIyMxYb8+HgjE4li70z/cVxPVMGsXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SV0KO6DQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.25
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011025.outbound.protection.outlook.com [52.101.52.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03753606D809;
	Tue,  3 Nov 2026 16:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03753606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SV0KO6DQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpaqOLhKOHRUXocpakobna3/Qhzvih6nrPc2fluFAIkvSkGSecZv/JkCT2oR+dJy3hnwI7AObbDCGgfzyX1zrmZ2K6WNVbsPC6KKDFb08MPX5+nIxORU5nfpQ2VkW6E9wjk2fUCaXIwUWwLK1ziEnteG28lbM0WdQYeTc6l3FEYDgkEGnY06GYbY794yVUc8uk9AuY954BB/vS46MOf3taeh9c0+Kf9joO3v0O+9egC5xYVt7YQuIOVTVzFz3BjzXBV4IwQRokZVFp/H/xtjnqT4uNUTCzBe5xKt8rPEAuflGOWumLQSQN8LbQ0NcvFIt0Cbi9j9HYzYOMmkmEgqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
 b=qJKZf9AhfpwcehaBp3LJJBIHCuWb/WDsX3zx9aayhxJR4lfa4iDDm4scm7dl2dmMMHI8Nx+Em9nRHUOkw7VTVpip9fKzqE8GE78k6GZT37G4OCDE+HvpjXUAy4oPzFNbYLlvCwlCCQSK32gGoyBm2QHqd3jsspw4Ahl2O5QmP5m48NbfXFfCOvlJDEHQ3IzUDfn3VSVx0Y+1BfdToz5VyGbH7guwwTdWr9hQIpTl/oc2etJpFLExPVvxcH3d0xYYi7GL7TE8SWTp9JqIPPebVy2/6JpgINq9rjBAPhr8TfKiP5t6zvaMyzRmkjO46R8LJh4gwgHMsXxS8hnYjxdlYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
 b=SV0KO6DQqtYDl+lZoOQUcwSlGCTSGBjGoodSPgquJU1hZBNe+IGTRb/80qHIvIy38VSsfNjXv7tQTX71/gMJxZRVjHzkxI0Yo36/GqfSHJm0NLeleDG2TTizonjWjAazcDHwK5NJVVYMZbLPe6u0RYVYKP9w1vYHtgxJHIgafNPI96fYeLXovN0yC/T2MzEwCO2zX7/QUrkfx7R99qVNIZLQf7o3o7Wmp62zk2bVt0bTV65YsFOTVQR1MaA9jtird4YPMUiGhhw4LhIq6jSyPRyHy4D6v4JXC+c+nWrTnmOtdIU0HiZM37r8qKuCHRpinyhx/1TDlLd1jlYLKr7S2g==
Received: from CH2PR20CA0004.namprd20.prod.outlook.com (2603:10b6:610:58::14)
 by PHXPR12MB999255.namprd12.prod.outlook.com (2603:10b6:510:3ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:15 +0000
Received: from BL2PEPF000352CF.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::44) by CH2PR20CA0004.outlook.office365.com
 (2603:10b6:610:58::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CF.mail.protection.outlook.com (10.167.249.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:43 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:43 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:39 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 18/23] RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
Date: Tue, 3 Nov 2026 18:39:44 +0200
Message-ID: <20261103163949.1554-19-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CF:EE_|PHXPR12MB999255:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e315e0-feac-4a72-a45c-08df39c96aeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|261021135927099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|261026140227099003|261028144727099003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	DATB7fnFDGZNNTHTabbpgFCQdtargDA19HnSEMv1rRGznkrIm0DUfLhb2MDtmTsd9Osz+MVoyRsyqulz1283650Mx1HY/9BfA1gS0YtXz+8TzD63uORT6L2PsAsF8aaZDUa4gvm55vOkEemM/JTf8l75DP9h29pg2gguovwYIpZOXq8B7LokEvhqZoKc6oTmedEvXarPtFe4312jU8DUzF8arU5VkH3wd3KoITZ0OQATvCVde47BvdVkVP2Lj7D8OCdIDTT+8ckK70Z/oAPNkXRhac68ME8Hd66OdyWE6IhgUc0krPD24J3BjsXXVxsJK9crfkZWXKzz3rT0sUUP2ULUMEnKDIhllx5gbWc4xoSqWp0RRZsxoyX5bD1pWeDy69L7pgk+uQcuAeHvaesD1sosFHOZ1F1SmXtknq2lY2DERm7hfF1vo0wSaB2YSZKGyJhTJvGj3e0PYGitMrouqJ91ew7qG5kH8rh2LAoVDXiL6DuD30d6oTku6sqLGWPDrHiZz1x57YOnLp3Xx+ycZL0yNuyyv/kDBjByNzYKpeTnkZwExjlwDGcbcczst/U0x1nR4daA7iyducrgYhScpVPivd8tOp9XZOYRqifbs1G7dzAALfcjDg5wLdqLp/5F2tvGUrVN8coTN9Mau282uqiQ6z9F3PgjfHU4bxdFrgIsD7dBcTOZDD1cBoJUaDLe1l6kKGa4DO7/5kqdtqR0kQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261021135927099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(261026140227099003)(261028144727099003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	45nFnq8NdcMOE44oxeCTgxLIJQ8sKl3mYrRuKIuoQZVMujidrKAHUzUNfeKa0TSV9BmKaFsiLzu/+QnTCp+8+ZtF9W3fTuZRVVqwgKSIkoGNLEdxEY5zVMxORh28nYlb7Bjq5mEebQwVhmxjjkiFeXEqpsLXhTINsRCyz0rhEuObNS+1OSiJs1oALJrjeowyuGvvqVxmhr9NzotEqtirN84Qvhg8SYLtIldiIFatiGcX1WuVOXRkRlhThiTJ4ZIFpF5sH62m/TMuT+v26MqNjsRCkW/md79CIVROi/RgGMbFrME0PeAQ+/I1IDBb0C5NsLEWqff4HOKzpYCTXaIHwOUp5Qwuxl9eCeHp7oRe819akxsk4Yh5mqB8iNDSObT2ytprTbxjayMO9kOVvaTqXLx3CT9qhLUT5LuaovmKjLNXXCXK3Cu27kXTDfp82zs1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:15.3210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e315e0-feac-4a72-a45c-08df39c96aeb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR12MB999255

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

