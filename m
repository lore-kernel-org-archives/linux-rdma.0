Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010016.outbound.protection.outlook.com [52.101.201.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8380C367B87
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481521; cv=fail; b=CO9WEGLa1YyC2w6O6/orhMfpb2NzH0xUIxJMfW4TLS6qk9MDPRoS0J3zDL9u8WR+UNBmSww7MLyD5fDyfhFJjqdVC9x7MdIBgFbM01+KhSGzLVKvj9TtGJnTG3aP0Fa0HzZtqtb/CzGU9V69LVNXH4AQjuPyIrSVyYPggDzFg2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481521; c=relaxed/simple;
	bh=pF6Czj1dU3n9N7lIQpYSp6vRqyXe075M24l/lEApwy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CA4QYu9f2UNKING8TVtmbzXw57yEDAeZRdWc2iN2QDr77R6TuKSetL8YYOngdT3B65gdYjpt3LTlSNOx3M/OGju+62dnF/JXKzYEy+Vsfn4M1VPzNjVnzmHWGvwDeXMfsBlqrg8kCY+/jnSb/AtdukWtoWJFWABFvSM3xOq1zW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XvoqjD0h; arc=fail smtp.client-ip=52.101.201.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XvoqjD0h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OUtaxlEodeOPpGaT75p5UrVXhOpRJXOwcOtlSdR7iG4N5Hp26dTT5B04wCCQq/ODL7i+mWrzqJQfwnpdP3B0ucKlmmr+toqUM0nev4Ou9pV0BI6OEwz82RY2wW2KZyD0KENJ26iv/WayVVrayyw2LsF0l+HNnF9eiJHZvrxgwWP336OLFYsO0vnQqD/lSZ2B78NHhaQs3QLS2Qo3R0RrtFUtrcBREvkdAATwQlM4hiL9cW74prYhyB6fBgK1F79sbJ2oK+Wrb/qiHv59ZIP8GQfbLJ5oUF3w8VCVeykl+rq80Wdbj2OIckcli3OqEGEey/Z0RYmvSu4bGlvLKgNMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQ8ol2U11K0V/sfasf9FmKEi6JTdiU6Nuhk1zthCmLM=;
 b=CzrnYhNEa7xzAbZxLdMIEX9uKYGj893HTLamZpUvb57ynqLcy8/YnArlZaA4jWJ+oHU28gpz1x6R5qV8ubn7TIR2iBLw6zHK64jFS1Sk8JyzFTocgKdfol9P+zbHTYYP4p0b4laqne8COtyHHqXAKF4u3iQ5WysOzhtzjj3pjfGb5asyhKLo+P1hoQa2ptpZR3Qe1CAS4TPijaaUoA3ewVue7mPjwCAqrc/4QhLRFHhseahPbH7ap0Bx7T9sTFYBPY+AUW4nnxjp5uw7rpGzatL7ViHaJVlT+NpP0Dui3LNqQ15w+e4++3yX9cCs/0iEqpPGsTZ6QQhhqvctkN6H1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQ8ol2U11K0V/sfasf9FmKEi6JTdiU6Nuhk1zthCmLM=;
 b=XvoqjD0h9498xf5JCDl5ZLwpYuwsKL5whCZSIpTMs6WSQfYRjPN2LD3IaYLJolxAAElYo3j8U4YpT2S/8FrNgxXgOkjM8i6CnQIpqzTHJVUBdRaUM9jWljTNSfhhGtMVEdjvSR3K968MzAeJ1YiUZ59z+vuHuiQUlZ70bE3ge16hD0h86qEMz/tnsW3QHPifQsNAJCcB4MbgSIBZ4ny+SJEX8Y27fp2KBlMNhXY8+uVrby1HwN29UY0RvnjWGqIIiLqxugNGJOGXUitl7lDdLMHrk0Xj5+SArpwrykq8u3phwJA5tjrlYlsMq6hB3vSRY8kJwS4p1TJ7x7cAFVI1Wg==
Received: from BL1PR13CA0221.namprd13.prod.outlook.com (2603:10b6:208:2bf::16)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:11:54 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:2bf:cafe::8a) by BL1PR13CA0221.outlook.office365.com
 (2603:10b6:208:2bf::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:11:24 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:11:23 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:11:19 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 15/15] RDMA/mlx5: Fix signed integer overflow in EQE qp_srq type shift
Date: Tue, 15 Sep 2026 17:09:33 +0300
Message-ID: <20260915140933.40580-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 554135cb-e28f-4a5b-d0c7-08df13334b87
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|23010399003|7416014|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kQd//jpyMrXja+WqiuOtqCaPi84MVOswq7wO29jfHYfbL7pWgAKEwIP75oCPzVuhcxTDMvG2YEJz31Rswqj35PdHurVF+YT4sRrND1MYi8Bkab8f5D1QNGkPYoLio7SIrEk6taE6gTcN1VKMKFkrNEZOWliCGCnDXCulNGW+oyVaF0Ka4XIVbXIIEuVBwp6RhgpTe/hiwrsxlAP7daGQ8YNEBIYZWx2WOx89K1B71y63vEcZ9ZCkCF5xNvv4mCk+7i6uSzHwUEaMNFZP7mTX6O3IwImQkBf+JZgE2A+vAiGSjFDHjFaW41Q0RYquGjioJHI687kl0v3X4bFAxIcEHqX9AtVKM2ngUs00XhKWJ93n3yeMiLXpr2C4yhpt7bWDhgExKaPrDMMw6nszDIhnHLkOQGuOPzRidqEzz/Ekw0UxKjHicGKaPTFf/3FeoXGYymLHxW3zyVUCIiGDpZCpqYzxnEGDe5T/84cvEIZw3q/MNIh3Wz9K3RYvM+KaVnVhzg7UBEbmRh54uUWWQCxcFO2wAKtDd2x8ES4nsOSSxjdCEY7tpKamgpPktihbBNYVbdoigCL34mYCqRh/U93g9xgt4dQsElO0TtScP5HJq46mJVFP9K4xCR24SfXbkGtdSJ6MOkmibiJMAw0/VRVtiqAR156KVuSaR4ZXYJQ9SdkeQPB1lCmmoRXwxkOk6tPMw/e17ago8FYgQ6cK56gP1w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(23010399003)(7416014)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZO5PzLmVMOdAJb2DChB04SFO7baJWb1uLLtlGV9cHau1GOdGJnbjNlyXGUR6+IW5YnFObStF9UptH7erbNgbdDNAczk7xPaIOmtV4E4hgX5rPtJKJmCcYoVDy1oYsRG7JLrSJO67V4X2ANPjw/mivSXxFAhWsvDp9p472TjzetiojGuD660PjRvyeTBI37MtvdPDTX0kNTzuu42LaqaXNM3uj943lp30mcGH6kpc8rkQwayszVTm4i8Q/WdKinlHAM67/+vStIubDoz6bmu0RxfMqSeZQswm9sJ805ettXE8rp137TLbmA9c1Iv4zMFXKx9IG/CBdxi39YSyinsc/zamwdzAQPPk666NSUhBhgJZDEFxTYitGCPDDl/7uKfjbIq96PiCb1rRHc5dUl8Gfds7ihuwNjddFx/NiIXirYvITrtfADlgtHetmNN0EKen
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:53.9551
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 554135cb-e28f-4a5b-d0c7-08df13334b87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259

eqe->data.qp_srq.type is a u8. Shifting it left by MLX5_USER_INDEX_LEN
(24) without a cast promotes it to signed int, causing undefined
behaviour for values >= 128.

All currently used type values are well below 128, so this does not
manifest with current hardware. Cast to u32 before the shift to make the
code well-defined across the full range.

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

