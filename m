Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318296;
	b=skYF7CCm0XIHeZLrm4XyvhbEffi+nNdBkgqreWCtM8x2IpVH5SB0kmYTscWGNNHJW0Uy
	 EngNuuQ1/8o3Daj/DZwHlJlOqg7AyRkbYj1RgH80PFu3fnO4SL4huRwRd6y1Dx3/d8lR8
	 KKbaWrS4hdN0V8SeIKMej0oL8RZCmNVxUGNMs56Jvq3uCVrumvgT7BUlpNSgnSQlyseU0
	 BPEJFWfmYw29wOWWVGuTx5D7vEjQelrZUdJYXg8qFsaT2jjAMs7lO4m/CXgcuS4Yya21q
	 sh6vPkZwfSEtBRevou9G42OcTLubVi/42o2hvXbH/NSOn3YxAMVeMXl1jsKBBzFkuPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318296;
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
	bh=1F7aGRiIQo5/+dUpBIKH9NSN2Bfgz/VijjvFvfMqXjE=;
	b=m6+vXYCJZMCIandlwPgVOvlCP01Qb2OovQjXRXWubX1KY7+KUtZsyF7hYN5yGUQ4LmzK
	 MPZititPSTEkslx/C9mKsUSdZUkZoFywkJi2KNy+dReDAFrEmxCK7m8ahPU6UMs3qI58E
	 90CHIw6wQkJPbbWcHUxaG3qa/ENtxuzF+858vRdsYPgnOjDewrTPRC93MGWQpUFhAkUxe
	 ZIvh8TjyyfYHylp15ugO8z2SjlKOFUMwco8cD3CPYSsEB47o+9HEgnYc8xBdEDfgK6ude
	 XGCzN6P7yJKW6t4wEPb06urVTTxGOdqoagkcR1OQ0ViEvt5mTWPnBT59KyvrlREM7sA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RmrmlgLE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.14
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061F6606A332;
	Tue, 10 Nov 2026 13:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 061F6606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RmrmlgLE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyzENvDL6uo1EKxT70tupbFw0+/d161a6n5o/3N9TYlCuiNL2EiegbpPHjyZlpP6hTNrdBqPAmQ/FCVkMUH0/VZRq7BYOBL1k+wxw2p00KHeTL2zALqRoA+AyXrTlGxt1miDz+SCcNtNWDbUOWMBmUo2RcxwWf3PPrTk/c9ag4J947MtIgNYi9oFS1KSCdXaIVrZG8tv7UWLCVPgpUqNdgVpIwkN1p1Hj64/EP4YUvlqZTmCAZoZEP5UTAV+w1lqBrb7MqWNBYb8u2F5dThunI+DN5GGohHsBp6jiRUrNT3/uoKh3UKIRWQIOMV2ShP+rO71idPiXmnbnqpvXJMjvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1F7aGRiIQo5/+dUpBIKH9NSN2Bfgz/VijjvFvfMqXjE=;
 b=YKYfUTZ/pGKuJ1xa1Yd2/IO4wlmbuIya76tFcgaoWkziFKfRKh0yYF0ATkvGs++vS62EyGn2mNKhTutUYQvKWWBQagCUoOvl4QK0DOCMspTzDwZK/OGJB3YLiGxPqA3XR8sMqe77YU9j2cafwCGfFBHqEAtbOFA3QddPEbnWtRQsatKPLYna9vCws4lDj/aZoQRpWJ0hav4/6nhg4+tlqTeD7UtdWtWeCH5t6ucYRnENvME01i8YMmdN8VigcCHd85EzPCsHnNYeTkV4lLGNGfXR7zAq2y1g+CvDjrVw3pxqxHMIeAxrVS+76hSI8gSy5w8zHzY8n9o8Yfy88YhRNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F7aGRiIQo5/+dUpBIKH9NSN2Bfgz/VijjvFvfMqXjE=;
 b=RmrmlgLE+wEqttCXvvYmveU/gCcELY0eEtsZiWqN/+DQTEr2eN4GLkNT+qmlBGKvwPAP/OhO42JNag4SUdA9Ipvtvpmgjmfbq3LbFe0fYdghwmcJRuXHRGb4T2NOHQ9MZZOC/Vrc16O0wY6uJ8tRlyFXUjtbaFaQ50XWKgygY5qCuMV1Gf5Tp1UYVBnL2rnIlWTN2g56ANdj2FxzvwAEUCwxNweAUqxAMIkrkcq822/PW18V3fkEOHvfDEulBZgrD/E6wVxYo/ACd843L6pBpMbpaB1xAZECruNd5GPZ3BeaiOJK9XWlt3sgILVQtZ+kk7b9fhI62pylTwcheFPnww==
Received: from DS1PR06CA0006.namprd06.prod.outlook.com (2603:10b6:8:458::12)
 by MN0PR12MB6004.namprd12.prod.outlook.com (2603:10b6:208:380::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:44:50 +0000
Received: from CY4PEPF000392D6.namprd03.prod.outlook.com
 (2603:10b6:8:458:cafe::9e) by DS1PR06CA0006.outlook.office365.com
 (2603:10b6:8:458::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D6.mail.protection.outlook.com (10.167.247.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:25 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:25 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:21 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 08/24] RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from mlx5_core adversarial API
Date: Tue, 10 Nov 2026 15:43:04 +0200
Message-ID: <20261110134320.34408-9-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D6:EE_|MN0PR12MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 163330df-2f9c-4f95-710f-08df3f30cab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|11063799006|56012099006|18002099003|22082099003|10067099003|261009223027099003|261102123227099003|261026140227099003|261021121427099003|261022105027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	wkuyrNkwu3DVSh3/0KUpvpYQKLPlswVOQSLrrPBRdzv+RuNy2e82AtZap6EoIBK7Y7KXaleX+9bS33NjcZycrvw3t1Wuve6J5/53HrUvFz/YUbuUsB8YwnemBATw7tEDQ3FKNKqm/M6y5l/dBKD2xrrVXiQyjdLdHxwn1hu1+rdfWxLLJocycQ5NeIfoaLF/u9F8RiOJByDbZMQjlh942qmRziJpVzGfAyhf0VRCJxh5EvRbdFe1D/kGvtn4WQixijMcNsrZ0piJmSY3Wza+FGcRDNy4X+OTDqM9H6dfYCGCp2pWLAeX6kjcBUh1U/ck6IYlocsb7YSwwdfRryT/86g/JCfHAfRAu360UBv7DiaVL4+cyXe8G7DRPsNtcNBbRfufCc6DYsYz4rTj1cA+fdP/enZsIynb6auilujSclKe9Q0o3R6gB6VxUREUdjHITuFa+jisJhbLaWlAzZGRQU+d8aHiwcZhroBSRLyhkTZvX4X16GfVnNvmOWY9eV47OGc03XeFIxi4kvy4FKvbxJW9CH3KTgh9ArG1RJkFcgivSA2xAa3QzkcwA1k6lu4JO6dQ/78xCeAGcFrsHnaKnI/TB0mFJEfvllZqF3Qj9D+NAccb+fl5F7kVdlBrWjX6kZCYZu6aalXGKlsOCWcmn9pqYZ3sBvbEjySxB4T3Zcs8kEk2GCzNHuLvFgdbUAlQL/B000frcsbYFDVkV4nz5g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003)(261009223027099003)(261102123227099003)(261026140227099003)(261021121427099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tHWyhI1CFbAezbKDzzeJLWDtJ4ax6CKUTdzUYfQJoyHKAL3LRgq36CIql6wkD3zzn4Smaa61zqfKKCgTBduWKMHMNpzTiz9uBM3Z2kGtJxv/JPRXMOJmDqzG9c1l78kwOXaY8oHZuNfNkwqjx5xS5gTt/8b7TGi1lQpSJlKXZiu3eZpk3fUBUb7EVpmJZXePnFqIYQQX/mi2qnRHawrA2DR+7i2P/ZQ+BA6+w4NWyPwttG9KRqrvVE4yO+3fM1gqSz7CRNPoYJv98gCgJrSVpf4XRGitWz6DGM4sndjrecql47qHG2zaJlb9Q6FLUqRgN0fvEN750B+JvDSsfyZxVj6ejNw/ETsT3w2lkM1b3wU3QiqCrRsjy/qCZcivLWiergOqJyLnsCyL8xFGesQjlIsvig6LLhmlvBr0awGGgLs4fFI3WStz+QzGQKrujoI1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:50.0708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 163330df-2f9c-4f95-710f-08df3f30cab4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6004

Cache mlx5_is_adversarial() in a driver-wide mlx5_ib_adversarial_mode
in mlx5_ib_init(), shared through mlx5_ib.h. The mode is the same for
all devices, so a global avoids reading it through every mlx5_ib_dev
and keeps the checks at the call sites simple.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 3 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 65455aedd559..f4f2ad80e76c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -76,6 +76,7 @@ enum {
 	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
 };
 
+bool mlx5_ib_adversarial_mode;
 static struct workqueue_struct *mlx5_ib_event_wq;
 static LIST_HEAD(mlx5_ib_unaffiliated_port_list);
 static LIST_HEAD(mlx5_ib_dev_list);
@@ -5431,6 +5432,8 @@ static int __init mlx5_ib_init(void)
 		return -ENOMEM;
 	}
 
+	mlx5_ib_adversarial_mode = mlx5_is_adversarial();
+
 	ret = mlx5_ib_qp_event_init();
 	if (ret)
 		goto qp_event_err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4a6ee14ffd7d..0f81b8aa487e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1582,6 +1582,7 @@ static inline int get_uars_per_sys_page(struct mlx5_ib_dev *dev, bool lib_suppor
 }
 
 extern void *xlt_emergency_page;
+extern bool mlx5_ib_adversarial_mode;
 
 int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
-- 
2.18.1

