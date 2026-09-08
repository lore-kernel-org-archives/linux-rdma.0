Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B51F54B1BA
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881504; cv=fail; b=OQgPYW4bZtc4EQSZhpXxZLeSnJJw1jWSsYfp2/ondowi5ZH7+XpcJZue36VYib+imgMTlK9KHAhoaq+97Au5t6rakPWUckfysx45BfYPBXw9uGL5Bew9SyDJgzd7nL0DU/0e+4VdxW/zBmQiEwrjzk/0EWzQyEZ5/qMQhb8GazQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881504; c=relaxed/simple;
	bh=n5W6Slhx9hGNCqotstvcEzevXgCmum9nb7Q2Kq85O/8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlXinWmlq87GPNxebMl5YtZuBpdKGgZkrsgoGnuZNUpqn5NV5d7ufUvm3bXOLyBSEOxguggQ/lHiwcFYvODyK3gb4lL3hhylk2lmBlYLG+iXR84EPENs4aKjdCipdS/M9gmpqLtBVp/QW6kmJ+DQ75Mk+UiS+CEHHGsg5YyBLBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GgjUXBHY; arc=fail smtp.client-ip=40.93.198.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GgjUXBHY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9WDmRsXZzMHZmET/BfnW979srZeoc/tmPINcaDU1o5tEM4zhzdkxysPu4zIaDMzD+NQq+vwcVj0MlX43DEhBYzRJDY0yM+S+NiK1+OZK3UkTFaYecSykImE1NmnPu66IMHswIY87l5+6NUkozKNccs9ebNgUpHTESmftRE4GkTm+lIGIqnADin+v6An6OYanuFG0oM7NYpyQPmCADPoRi0BNCY9937QVy1DVMX1Jv+vspcLo/6VZAv/kZ+qCBltetlEVtTAEGrAghPIYbZu2EHLA5aUlMwaRniy3NlkCWyYEEg3Uc9pKJTgCknjJqgXTmJD0b/xxh5r/BggcYzxsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V41zfrfDtJHmHHrUYfZuwyWiigfqDvUIFJiqjTQP5IU=;
 b=F9bkAW8S/zGt0qbzsN84I6qWO9SGeK8QdXlopxvhJ4ntPKP5FrZgQMAQ3Ap9e6lMb4bd1gz+OhNiimzudEWM/Ltqemx/RQqA4AwM4vT7O7vBtcC+9i2yD8yG3/gQWJL3jkzvYz4qlHGg00ZaJLpNw8P3n2N6S786t0i5OqsJBOAgRg11p8pDcVwdIgcFTOY+iBQbIZzVmQFd50vnXCPNBVcm1dYDi2E5yWwayxZu8fXiREq3fYIEd6vqVQV7/ly3TVz6Iaih3sXnlPFTorFlP/tAjMrM62IyCllgTjrzbEbduXroLxlHERml9WL5R/IaZ7Nujrgl5c5UQF01WVVQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V41zfrfDtJHmHHrUYfZuwyWiigfqDvUIFJiqjTQP5IU=;
 b=GgjUXBHYPo7/SyrMvp5ypANqjuJBDvkoC0KuRfpfw1bEh9uDwxi9k2zfS8mkXV3NIJjr91sPHo7E/eSVsdOtjyV5eDZMSmVPrwrKuG7B9CZ3C4M8NJaUWXoCE93MUMMRz9iRXOaUy4a4cZSxQWWY89GVgrEQlkYL4bzIOa4gOc8DAZw+bVMiYldKpzf6BBdiR3Dnr9BdIGviCOCStUyGmJuWmcZcLfvzW1LhjLbVwpwnhtJ86chxXYMJDMofQ9MacmdEX0hYDglhhmgdxhPQtpVyJnIiDudbeacMgCqb50J5s5LTLp+lvEaNECAhXCUC6qGUpU1RdYZjUk06J46b8A==
Received: from CH0PR03CA0403.namprd03.prod.outlook.com (2603:10b6:610:11b::13)
 by DS4PR12MB9564.namprd12.prod.outlook.com (2603:10b6:8:27e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:31:20 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::6) by CH0PR03CA0403.outlook.office365.com
 (2603:10b6:610:11b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 15:31:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:31:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:47 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:42 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 15/15] RDMA/mlx5: Fix signed integer overflow in EQE qp_srq type shift
Date: Tue, 8 Sep 2026 18:28:51 +0300
Message-ID: <20260908152851.1307294-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DS4PR12MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: d5358669-176b-48a6-76e1-08df0dbe3b8f
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|7416014|1800799024|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	YJuXXI5NjMhHUHwifqibE1yPKvzQgAsglJQx5FlGFel1ZtJDdE06Zq7alMkrM55R3LVX7MPla6CgeQBoniQ7nkd/5ZT7AlYOKzDJHJRM/GymQJ29aNMTRASePZdh/l63fnjiw1IFHC7lsMbMWn84tAxW7BThb9QC2UhLj9zuZI9ei/vuGDOoMW90mwZwMm1nt5rE1CBJsKak0zIMb+N9cVYLxjstkbew0eGyK91/Wr4rEhVGlBj2P149QzbAJK5GdK/Qcx9wP5CHDlua4MeXWNGakXfRXlTa/kqlzAtzRNMyL2dtYzKtoRtjqsoMbpMBeje0ZrL9N7LMGh/cY9m1GiYuywJso50WZGw/MiR0ZkOcZE2PxwB9HG/0I+5Tps5Md80Q/fl4jI/73SyrX0CvYwKe2j2t+s+tT3BxW7VErAGzD4xK0hTXSg+JGuTROkWYsUjh5SN6Fn/WmWoCCcME7VLzQTbYjO1r3OQhw/yw7W41vxwEUOWheRVAl0dwbRlcDajhQKhVgm7YcXNU3yZnO9zQ/awgCm54iXGKODKcNI/qv1XgAowYoInHsrdw5mspklZiiXVjNFDfftiI/57966UmpTBuD1kuL7+NnzMigsF6seAP3OAhjXyKd8QoUd9RaPaZBc0uvAOIDovYpJZPXjDHVfUWhSEAP08w58d5JY/JOVABWcFOMchuKn6ueW5U9CZ77PslBkVZqdjiBKdUWg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lQvk3VSpSPs6oShQUE5YEx0bxOZfXiD8QKQX6Ojkk5xfdoDOn/Y+j7QK6Ye42tiNYx74UN9SH+cJs6JO2A1LKLVj3rOAJI0M9MAH3KzIN7Th5hDIO7taCo66BB3HAQmS/WOxvRhFxcBkFdpPlRud+1kmEu5Zq8d6VKQlnQE2ZejYRTS07HIY0lXxfwLDw+dTcZ97r/woy/E/YrOvgMHLKd0wmIH6TtoWKmWxl3/g4JHpp+EmXwMiBSkEi7OZevKUcwxQ6EJIw4F8gHzefKEGXSx2sbWjVb1HrxGpq2v6BxioKVxLfsc08bPvgDEr8i3yFiQOujefn2VuWVoJk0v5uYDQbowhO3aZI9fJtZVcSVKmEbFJwpWmnILXBMqeWBJgmOadRkqKPfmzyyf5f4yNMDAJDqDsl3mpySSGP6+ld5fNqMVFNaMt2k8tyH7SGuhe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:31:20.2570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5358669-176b-48a6-76e1-08df0dbe3b8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9564

eqe->data.qp_srq.type is a u8 field (values 0-255). Shifting it left by
MLX5_USER_INDEX_LEN (24) promotes it to signed int before the shift,
causing undefined behavior when type >= 128: the result overflows into
the sign bit of int, which a signed-overflow sanitizer would flag.

Cast to u32 before the shift so the operation is well-defined across the
full 0-255 range of the EQE-supplied type field.

All currently defined and used type values (QP=0, RQ=1, SQ=2, SRQ=3,
XSRQ=4, XRQ=5, DCT=6) are well below 128, so this is not a bug that
manifests with current hardware. The cast is a preventive fix to make
the code well-defined against any future or firmware-forged type value.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 8b5bd33a7f0f..ce2ef8828c09 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -128,7 +128,7 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
 	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
 		rsn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
-		rsn |= (eqe->data.qp_srq.type << MLX5_USER_INDEX_LEN);
+		rsn |= ((u32)eqe->data.qp_srq.type << MLX5_USER_INDEX_LEN);
 		break;
 	default:
 		return NOTIFY_DONE;
-- 
2.18.1

