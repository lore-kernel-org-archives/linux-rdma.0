Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870908;
	b=NCfnGw3/MMD5GJcYibcvkEIanUkm2ljUo/4uO0Wcdcmr6Fy71uOTxb9d8YSXfagTLDtC
	 bG3MEG5A+rA2uigeBxh9cqbCAQkMBpVxuJQD8CqnQeNIJ3//k2HBlatOZaCzV7rN6s8sb
	 /DSDdbaeFdSbTkkr6kwuW7ySWLx27NRfeQvjzlwxcYQmkmPcH+wMM7F+VKQdUR7V5RBCR
	 ves+k1MSTXHBKdt/6s9nThU8848EybuHhKCtZmEcePWVCGGDJ4GV55VhuSDz1offvCOQs
	 bO9a4wO4nzd1zK4u3mBrPF7U+rTrNVTAXVe3fQaaEDNcHR+WW0fhWmEn+5KahI50m5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870908;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=33WPS99D1Hze3kLthuGi+tUt6I2Jqp8kEY7oRUjhv7c=;
	b=S2r8WKKp8CEMl54Zh5s0s4g0MAIKdSkW6ZvSPYPrWOe16X4ohSJS6kWv21ndiogXdhX0
	 vrCLPHDzi+mdAlZAtMVFsQAhrE25DoDeeFe3Z/uozfQ8/00CUiywT0H9SSomZFlj409bH
	 XGkftJftWYe2vCL0PBEonOBnqsaX6mcxlxtrizQQXjyEnkpkAZwNqUuI6p9FAUWkWWmN8
	 Nwf5l5DF5EnlPqDslqYejhBVMLhFfxfA8Sb3sMGQYBMPiMKugwtsL69GXcA2o/CcqPdCg
	 JLKelhNCf+HOdcocxbX5CZ1k68gFEiG2vKmsYrXAvTxTByOm4WdhhKczZBgUsQpu7MA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tcxflRmF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.39
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012039.outbound.protection.outlook.com [40.107.209.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE6C606A32E;
	Sat, 28 Nov 2026 13:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DE6C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tcxflRmF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RnQTqLFiOm21Sm3JD8fSOI5sZeww94IQVNqIE6lz6hrH4ccrVkCCJiY/sMjbnRamAJczcOwQ/3VRmzOyZfhY1cLVYmI7wkJOxRHN89McD8hIhisiVKzaOsGTKHnFk4WKSittqSx/bydCZ2VSRA6QGx6tfXWziWu9vMs5oHUynDWecW9GIjAMRhKp/ZkZ8WXvhu2Sr63eUfzPrHEO6beW+T6uRcVlkxvqz292eISTQWu0Tr9JAKwMsInACtFArZvDfgh4JCt+7TNNGBwrtD/IK4FUQCT87RxmPGJuD8ddncsOu2w5om0Pxgf1tR/talOLTelynLJ78+NqsvUFENr0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33WPS99D1Hze3kLthuGi+tUt6I2Jqp8kEY7oRUjhv7c=;
 b=DmCMr8hqY9THIB4uXi3mwT2o6kjtluPVukuscF1usp5RsXHHss2BY1FKakOey9dHDdCahk3UvX93T/fceV563dHGEaLL1mMqNwyEY5ld6BM7KnrwMxk8F2XXp2AhJrR6m1JsuR+CnvOCwqaBL6t1M4aDlGmKXuQ2ZV7Ut2WEREwAyVaqXM4TRpkTI91tJyhJcdURYMS4zZ+Et7YjSiNWWO6TJ2rvRZYw9WrLbX8n/sfBdAXn5iFE3808UOYUQ0Cg+F7p945q7tsXfs0ZB1z5lHg9WOjIVaMhurJAoJ+DSbNczKLW8Wk59k81NLHJMlMQBtnCk92DcGBKdq0wMmvVsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33WPS99D1Hze3kLthuGi+tUt6I2Jqp8kEY7oRUjhv7c=;
 b=tcxflRmFbZ7htBQbwFMquKiInaC2Xx3PXGSkqxuNslbPYDTWWB6/YscH2aGOFbik4qIdP5DaLRwLftBIV/GlCiK9MURIoUkbMUEHdE8zhDBWjq4KsbXwNSD5gdiiRXM8/snb29IURP4jeTR+0ZtGdtZuFOtLrl4R7PtLVBCg5Vxpw3Z95aCCailAc0CKwkMRScHmx//zQqJZuwbZoKg1fhBSYu3C7kucAV6pWqz7QZN/CKFs9Ee5cRFQjrtjnPlKl5WgRPJcmtaQuhYhl9FusqD1ft19g1U8YjgMARUBGVBoSdZoJvlB/vxahZANxGjTWVYJYS/AotiRixY0Y4BTzg==
Received: from BN9PR03CA0399.namprd03.prod.outlook.com (2603:10b6:408:111::14)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Sat, 28 Nov
 2026 13:01:38 +0000
Received: from BN5PEPF0004698C.namprd02.prod.outlook.com
 (2603:10b6:408:111:cafe::94) by BN9PR03CA0399.outlook.office365.com
 (2603:10b6:408:111::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698C.mail.protection.outlook.com (10.167.245.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:26 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:25 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:24 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:15 +0200
Subject: [PATCH rdma-next v2 02/11] RDMA/mlx5: Rename to_mdev() helpers
 that return an IB device
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
Content-Transfer-Encoding: 7bit
Message-ID: <20261128-mlx5-sd-prep-v2-2-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=90612;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=u/BbMvyoemniEBGhlMmX9H9WQz/YI5GhQW0FRah4ro0=;
 b=ckVAGg2hH6GdUGXZV+0a//ouZXlkh0XUzJeHcfjT6P5h+0HVwk0jPumptYpaSyD2S/FdNuQ6i
 IIHjzqutWumBMS/IpMwAWR95+MXJ3iG4DBGqXvLCSgClh/nQP/IW7Hg
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698C:EE_|BY5PR12MB4051:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3dc024-6954-4a1f-19fa-08df4d4fbd7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|36860700016|6133799003|261009223327099003|261009221227099003|261009221727099003|261009220027099003|261009223027099003|18002099003|22082099003|11063799006|261028144727099003|10067099003|260925021911599003|260925022911599003|260925021311599003|56012099006|261102123227099003|261021121427099003|261022075727099003|261021123027099003|261022105027099003|261026121527099003|261026140227099003|261022115727099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	0UyZ+WEXhErfyK9QcGNXpeLNK7ddSjxr6igBSNLKDo8wx7Yx3iVXEJwJ5Z8t5L2AUSDPr6Bv64Sftuandxfvjhuwwsymxo2qYpnM/yaeR03HqgMdBTNGo5bq2TQSdoQjBqANd809QYfl5AGPCax3WpLCNJM9Ez/Fr9aIB8Dv2j4hrQvBNXpqDowPY2lQ/K58fgOlX7TSLx3xUyNpaXB/kSjBlFJgVcpnTjPrGwOg+eT3nALg1KP7GkqCkXtTP7vL0xkQxuCDjaMSbUhy9YcCSZhvbKttFqXB1jBB4lzZcvFkHpOOITSD37V2wJRfQZGdTDoUUYMSjdmFbRyZ7oDU6WViR0NLP/I8/eIQK6Vw+6CsezYGD9aWgWw6p5zzKvC/wDsQ1eXVxs8gd4QSC+DC3WE4fJpQ6AFky1IPvXZ0qEdogxPM1jPBCWjV7VF0lc48bcAlvmmomOE9ltws3eT5O83QctalGEJ28PWS/8eih4Euhjt9Qs0IhndQlJVpLWVBVdJuuCUCek6dE4mt7cBsbxhMg4g469zDFKezeHZNCq62Cj7jW9elGC31CkRYoRDWPA33f5qd6TqXtPGwhLdJCJ2Wv9v7UvKoVTQSHvFwGvgYX5ZKiCL0vG/NezNp9zhXlaRBPBLqrMCijzbziZIQOO3+FPtfrspAZvDqR649Wb4uj8Y9ycLJFArioOMcB4kNwNMgv2VL7HGjVGO1yH7yZw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(6133799003)(261009223327099003)(261009221227099003)(261009221727099003)(261009220027099003)(261009223027099003)(18002099003)(22082099003)(11063799006)(261028144727099003)(10067099003)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(261102123227099003)(261021121427099003)(261022075727099003)(261021123027099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022115727099003)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RQKTjp487b5i92gEJc2wZE21i5A9ikU4cV7wXuS3xxacc/WWZbiTRRa7Z4I9Gle7qFKjRzbzJLDACBzko9EuUoUJcck+6B+VWUJtW6ft82t+0ngfdj7E8hOXIvj6gqCrn+6OSlX1H3x4VKWaq0RQ+mcSX8VM6CtOCGehUoYmmmVizPcBMvUEBH+hYOhnTfdzZX2FihkSZOPuinw/Qnn92u5JG2a4nGpDkqy+5+C6ev/IsY5c2193wB4a+BFgOtv2ElZkKvDypeN0wV+ZsbPoGnzkvUcPEgAMOko8lfOYjAhCqaMowlGrzs1V+2UC0r5bG21XA7qFV3L07dluLguvo/Mq8Luvjw8UZRG4iocOSBsWP8egsJvzyQX095bHttBOW9SP02/qCuI1FCjNVIKaVzpEzczVoqZxfpM3bSK9Kz6VSnxIL5K0BF3Nu8IMfYWa
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:38.4795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3dc024-6954-4a1f-19fa-08df4d4fbd7d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051

From: Akiva Goldberger <agoldberger@nvidia.com>

to_mdev(), mr_to_mdev() and mlx5_udata_to_mdev() all return a
struct mlx5_ib_dev, but their "mdev" name reads as a struct mlx5_core_dev
under the driver's dev/mdev convention, where mdev is the core device.
This is a constant source of confusion.

Rename them to say what they return: an mlx5_ib_dev is "dev", so the
generic ib_device converter becomes to_dev() and the object-specific
wrappers become mr_to_dev() and udata_to_dev(). The udata helper also
drops its mlx5_ prefix, so every resolver is named after the resource it
takes.

Pure rename; no functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ah.c        |  2 +-
 drivers/infiniband/hw/mlx5/counters.c  | 32 +++++++-------
 drivers/infiniband/hw/mlx5/cq.c        | 24 +++++-----
 drivers/infiniband/hw/mlx5/devx.c      | 32 +++++++-------
 drivers/infiniband/hw/mlx5/dm.c        | 12 ++---
 drivers/infiniband/hw/mlx5/dmah.c      |  4 +-
 drivers/infiniband/hw/mlx5/fs.c        | 18 ++++----
 drivers/infiniband/hw/mlx5/gsi.c       | 14 +++---
 drivers/infiniband/hw/mlx5/ib_virt.c   | 12 ++---
 drivers/infiniband/hw/mlx5/macsec.c    | 10 ++---
 drivers/infiniband/hw/mlx5/mad.c       | 14 +++---
 drivers/infiniband/hw/mlx5/main.c      | 80 +++++++++++++++++-----------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h   | 17 ++++----
 drivers/infiniband/hw/mlx5/mr.c        | 68 ++++++++++++++---------------
 drivers/infiniband/hw/mlx5/odp.c       | 28 ++++++------
 drivers/infiniband/hw/mlx5/qos.c       |  4 +-
 drivers/infiniband/hw/mlx5/qp.c        | 48 ++++++++++----------
 drivers/infiniband/hw/mlx5/restrack.c  |  6 +--
 drivers/infiniband/hw/mlx5/srq.c       | 12 ++---
 drivers/infiniband/hw/mlx5/std_types.c |  4 +-
 drivers/infiniband/hw/mlx5/umr.c       | 18 ++++----
 drivers/infiniband/hw/mlx5/wr.c        | 10 ++---
 22 files changed, 235 insertions(+), 234 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index a3aa700d08355d063466b8c48d9c08c478788c60..643d0ce3452696352f7edac5bbf83012b8689033 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -102,7 +102,7 @@ int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 {
 	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	struct mlx5_ib_ah *ah = to_mah(ibah);
-	struct mlx5_ib_dev *dev = to_mdev(ibah->device);
+	struct mlx5_ib_dev *dev = to_dev(ibah->device);
 	enum rdma_ah_attr_type ah_type = ah_attr->type;
 
 	if ((ah_type == RDMA_AH_ATTR_TYPE_ROCE) &&
diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 742bb10adc57f52e6f87d4e7fceb08c5c358dcbf..04f56de0b1ed7a7ff45c243c4f10d173512111c0 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -206,7 +206,7 @@ static int mlx5_ib_destroy_counters(struct ib_counters *counters)
 
 	mlx5_ib_counters_clear_description(counters);
 	if (mcounters->hw_cntrs_hndl)
-		mlx5_fc_destroy(to_mdev(counters->device)->mdev,
+		mlx5_fc_destroy(to_dev(counters->device)->mdev,
 				mcounters->hw_cntrs_hndl);
 	return 0;
 }
@@ -277,7 +277,7 @@ static struct rdma_hw_stats *do_alloc_stats(const struct mlx5_ib_counters *cnts)
 static struct rdma_hw_stats *
 mlx5_ib_alloc_hw_device_stats(struct ib_device *ibdev)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	const struct mlx5_ib_counters *cnts = &dev->port[0].cnts;
 
 	return do_alloc_stats(cnts);
@@ -286,7 +286,7 @@ mlx5_ib_alloc_hw_device_stats(struct ib_device *ibdev)
 static struct rdma_hw_stats *
 mlx5_ib_alloc_hw_port_stats(struct ib_device *ibdev, u32 port_num)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num);
 
 	return do_alloc_stats(cnts);
@@ -387,7 +387,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 			   struct rdma_hw_stats *stats,
 			   u32 port_num, int index)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num);
 	struct mlx5_core_dev *mdev;
 	int ret, num_counters;
@@ -458,7 +458,7 @@ static bool is_rdma_bytes_counter(u32 type)
 
 static int do_per_qp_get_op_stat(struct rdma_counter *counter)
 {
-	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_dev *dev = to_dev(counter->device);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, counter->port);
 	struct mlx5_rdma_counter *mcounter = to_mcounter(counter);
 	int i, ret, index, num_hw_counters;
@@ -495,7 +495,7 @@ static int do_get_op_stat(struct ib_device *ibdev,
 			  struct rdma_hw_stats *stats,
 			  u32 port_num, int index)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	const struct mlx5_ib_counters *cnts;
 	const struct mlx5_ib_op_fc *opfcs;
 	u64 packets, bytes;
@@ -529,7 +529,7 @@ static int do_get_op_stats(struct ib_device *ibdev,
 			   struct rdma_hw_stats *stats,
 			   u32 port_num)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	const struct mlx5_ib_counters *cnts;
 	int index, ret, num_hw_counters;
 
@@ -551,7 +551,7 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 				u32 port_num, int index)
 {
 	int num_counters, num_hw_counters, num_op_counters;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	const struct mlx5_ib_counters *cnts;
 
 	cnts = get_counters(dev, port_num);
@@ -580,7 +580,7 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 static struct rdma_hw_stats *
 mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 {
-	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_dev *dev = to_dev(counter->device);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, counter->port);
 
 	return do_alloc_stats(cnts);
@@ -588,7 +588,7 @@ mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 
 static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
 {
-	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_dev *dev = to_dev(counter->device);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, counter->port);
 	int ret;
 
@@ -606,7 +606,7 @@ static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
 static int mlx5_ib_counter_dealloc(struct rdma_counter *counter)
 {
 	struct mlx5_rdma_counter *mcounter = to_mcounter(counter);
-	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	struct mlx5_ib_dev *dev = to_dev(counter->device);
 	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
 
 	if (!counter->id)
@@ -624,7 +624,7 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 				   struct ib_qp *qp, u32 port)
 {
 	struct mlx5_rdma_counter *mcounter = to_mcounter(counter);
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	bool new = false;
 	int err;
 
@@ -1011,7 +1011,7 @@ static int read_flow_counters(struct ib_device *ibdev,
 			      struct mlx5_read_counters_attr *read_attr)
 {
 	struct mlx5_fc *fc = read_attr->hw_cntrs_hndl;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 
 	return mlx5_fc_query(dev->mdev, fc,
 			     &read_attr->out[IB_COUNTER_PACKETS],
@@ -1083,7 +1083,7 @@ int mlx5_ib_flow_counters_set_data(struct ib_counters *ibcounters,
 
 	if (!mcounters->hw_cntrs_hndl) {
 		mcounters->hw_cntrs_hndl = mlx5_fc_create(
-			to_mdev(ibcounters->device)->mdev, false);
+			to_dev(ibcounters->device)->mdev, false);
 		if (IS_ERR(mcounters->hw_cntrs_hndl)) {
 			ret = PTR_ERR(mcounters->hw_cntrs_hndl);
 			goto free;
@@ -1115,7 +1115,7 @@ int mlx5_ib_flow_counters_set_data(struct ib_counters *ibcounters,
 
 free_hndl:
 	if (hw_hndl) {
-		mlx5_fc_destroy(to_mdev(ibcounters->device)->mdev,
+		mlx5_fc_destroy(to_dev(ibcounters->device)->mdev,
 				mcounters->hw_cntrs_hndl);
 		mcounters->hw_cntrs_hndl = NULL;
 	}
@@ -1143,7 +1143,7 @@ void mlx5_ib_counters_clear_description(struct ib_counters *counters)
 static int mlx5_ib_modify_stat(struct ib_device *device, u32 port,
 			       unsigned int index, bool enable)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct mlx5_ib_op_fc *opfc, *in_use_opfc;
 	struct mlx5_ib_counters *cnts;
 	u32 num_hw_counters, type;
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b7a01460c6e92ebfccc9b4bf5ce22ca872bb2a42..6b9777e2622ea30abce1156bb4369668e07cc3c9 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -51,7 +51,7 @@ static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
 static void mlx5_ib_cq_event(struct mlx5_core_cq *mcq, enum mlx5_event type)
 {
 	struct mlx5_ib_cq *cq = container_of(mcq, struct mlx5_ib_cq, mcq);
-	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
 	struct ib_cq *ibcq = &cq->ibcq;
 	struct ib_event event;
 
@@ -166,7 +166,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 {
 	enum rdma_link_layer ll =
 		rdma_port_get_link_layer(qp->ibqp.device, qp->port);
-	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
+	struct mlx5_ib_dev *dev = to_dev(qp->ibqp.device);
 	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
 	u16 wqe_ctr;
@@ -447,7 +447,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 			 struct mlx5_ib_qp **cur_qp,
 			 struct ib_wc *wc)
 {
-	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
 	struct mlx5_err_cqe *err_cqe;
 	struct mlx5_cqe64 *cqe64;
 	struct mlx5_core_qp *mqp;
@@ -571,7 +571,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
 			struct ib_wc *wc, bool is_fatal_err)
 {
-	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
 	struct mlx5_ib_wc *soft_wc, *next;
 	int npolled = 0;
 
@@ -598,7 +598,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	struct mlx5_ib_qp *cur_qp = NULL;
-	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	unsigned long flags;
 	int soft_polled = 0;
@@ -633,7 +633,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
-	struct mlx5_core_dev *mdev = to_mdev(ibcq->device)->mdev;
+	struct mlx5_core_dev *mdev = to_dev(ibcq->device)->mdev;
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	void __iomem *uar_page = mdev->priv.bfreg.up->map;
 	unsigned long irq_flags;
@@ -942,7 +942,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	struct mlx5_ib_create_cq_resp uresp = {};
 	int entries = attr->cqe;
 	int vector = attr->comp_vector;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	int index;
@@ -1030,7 +1030,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	struct ib_device *ibdev = ibcq->device;
 	int entries = attr->cqe;
 	int vector = attr->comp_vector;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	int index;
@@ -1100,7 +1100,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 {
-	struct mlx5_ib_dev *dev = to_mdev(cq->device);
+	struct mlx5_ib_dev *dev = to_dev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
 	if (!cq->uobject)
@@ -1112,7 +1112,7 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 void mlx5_ib_post_destroy_cq(struct ib_cq *cq)
 {
 	WARN_ON(!list_empty(&to_mcq(cq)->wc_list));
-	destroy_cq_kernel(to_mdev(cq->device), to_mcq(cq));
+	destroy_cq_kernel(to_dev(cq->device), to_mcq(cq));
 }
 
 int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
@@ -1199,7 +1199,7 @@ void mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq)
 
 int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 {
-	struct mlx5_ib_dev *dev = to_mdev(cq->device);
+	struct mlx5_ib_dev *dev = to_dev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 	int err;
 
@@ -1253,7 +1253,7 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 		      struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibcq->device);
+	struct mlx5_ib_dev *dev = to_dev(ibcq->device);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	void *cqc;
 	u32 *in;
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index e74f44819ac8ae60571429a4943c72591f82b319..9c5527a10d0ac832859cbf8e948addb3c50c4bed 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -634,7 +634,7 @@ static u64 devx_get_obj_id(const void *in)
 static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 				 struct ib_uobject *uobj, const void *in)
 {
-	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	u64 obj_id = devx_get_obj_id(in);
 
 	if (!obj_id)
@@ -979,7 +979,7 @@ static int devx_get_uid(struct mlx5_ib_ucontext *c, void *cmd_in)
 		if (c->devx_uid)
 			return c->devx_uid;
 
-		dev = to_mdev(c->ibucontext.device);
+		dev = to_dev(c->ibucontext.device);
 		if (dev->devx_whitelist_uid)
 			return dev->devx_whitelist_uid;
 
@@ -1043,7 +1043,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 
 	err = mlx5_comp_eqn_get(dev->mdev, user_vector, &dev_eqn);
 	if (err < 0)
@@ -1087,7 +1087,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_UAR)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 
 	if (uverbs_copy_from(&user_idx, attrs,
 			     MLX5_IB_ATTR_DEVX_QUERY_UAR_USER_IDX))
@@ -1120,7 +1120,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
@@ -1455,7 +1455,7 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	struct mlx5_ib_dev *dev;
 	int ret;
 
-	dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	dev = udata_to_dev(&attrs->driver_udata);
 	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY &&
 	    xa_erase(&obj->ib_dev->odp_mkeys,
 		     mlx5_base_mkey(obj->mkey.key)))
@@ -1534,7 +1534,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE);
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct devx_obj *obj;
 	u16 obj_type = 0;
@@ -1652,7 +1652,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 							  MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 	void *cmd_out;
 	int err, err2;
 	int uid;
@@ -1702,7 +1702,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	void *cmd_out;
 	int err, err2;
 	int uid;
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 
 	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
 		return -EINVAL;
@@ -1764,7 +1764,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC)(
 
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DEVX_ASYNC_CMD_FD_ALLOC_HANDLE);
-	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 
 	ev_file = container_of(uobj, struct devx_async_cmd_event_file,
 			       uobj);
@@ -1781,7 +1781,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_EVENT_FD_ALLOC)(
 	struct devx_async_event_file *ev_file;
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 	u32 flags;
 	int err;
 
@@ -1841,7 +1841,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	struct ib_uobject *fd_uobj;
 	int err;
 	int uid;
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 	struct devx_async_cmd_event_file *ev_file;
 	struct devx_async_data *async_data;
 
@@ -2077,7 +2077,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_OBJ_HANDLE);
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 	struct ib_uobject *fd_uobj;
 	struct devx_obj *obj = NULL;
 	struct devx_async_event_file *ev_file;
@@ -2407,7 +2407,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	u32 obj_id;
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
 	int access_flags;
 	int err;
 
@@ -2721,7 +2721,7 @@ void mlx5_ib_ufile_hw_cleanup(struct ib_uverbs_file *ufile)
 	struct mlx5_async_cmd *async_cmd;
 	struct ib_ucontext *ucontext = ufile->ucontext;
 	struct ib_device *device = ucontext->device;
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct ib_uobject *uobject;
 	struct devx_obj *obj;
 	int head = 0;
@@ -3254,7 +3254,7 @@ DECLARE_UVERBS_NAMED_OBJECT(
 
 static bool devx_is_supported(struct ib_device *device)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 
 	return MLX5_CAP_GEN(dev->mdev, log_max_uctx);
 }
diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 141331c4eb747d5b0b6973dfedc63ae4f7acf5c5..67df5944abece4601dc48db4e2672c6de1b3867d 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -167,7 +167,7 @@ static void mlx5_ib_dm_memic_free(struct kref *kref)
 {
 	struct mlx5_ib_dm_memic *dm =
 		container_of(kref, struct mlx5_ib_dm_memic, ref);
-	struct mlx5_ib_dev *dev = to_mdev(dm->base.ibdm.device);
+	struct mlx5_ib_dev *dev = to_dev(dm->base.ibdm.device);
 
 	mlx5_cmd_dealloc_memic(&dev->dm, dm->base.dev_addr, dm->base.size);
 	kfree(dm);
@@ -209,7 +209,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
-	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
+	struct mlx5_ib_dev *dev = to_dev(uobj->context->device);
 	struct ib_dm *ibdm = uobj->object;
 	struct mlx5_ib_dm *mdm = to_mdm(ibdm);
 	struct mlx5_ib_dm_memic *dm = to_memic(ibdm);
@@ -284,7 +284,7 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 					   struct ib_dm_alloc_attr *attr,
 					   struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_dm *dm_db = &to_mdev(ctx->device)->dm;
+	struct mlx5_dm *dm_db = &to_dev(ctx->device)->dm;
 	struct mlx5_ib_dm_memic *dm;
 	u64 start_offset;
 	u16 page_idx;
@@ -363,7 +363,7 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 					    struct uverbs_attr_bundle *attrs,
 					    int type)
 {
-	struct mlx5_core_dev *mdev = to_mdev(ctx->device)->mdev;
+	struct mlx5_core_dev *mdev = to_dev(ctx->device)->mdev;
 	enum mlx5_sw_icm_type icm_type;
 	struct mlx5_ib_dm_icm *dm;
 	u64 act_size;
@@ -441,7 +441,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 	if (err)
 		return ERR_PTR(err);
 
-	mlx5_ib_dbg(to_mdev(ibdev), "alloc_dm req: dm_type=%d user_length=0x%llx log_alignment=%d\n",
+	mlx5_ib_dbg(to_dev(ibdev), "alloc_dm req: dm_type=%d user_length=0x%llx log_alignment=%d\n",
 		    type, attr->length, attr->alignment);
 
 	switch (type) {
@@ -480,7 +480,7 @@ static int mlx5_dm_icm_dealloc(struct mlx5_ib_ucontext *ctx,
 			       struct mlx5_ib_dm_icm *dm)
 {
 	enum mlx5_sw_icm_type type = get_icm_type(dm->base.type);
-	struct mlx5_core_dev *mdev = to_mdev(dm->base.ibdm.device)->mdev;
+	struct mlx5_core_dev *mdev = to_dev(dm->base.ibdm.device)->mdev;
 	int err;
 
 	err = mlx5_dm_sw_icm_dealloc(mdev, type, dm->base.size, ctx->devx_uid,
diff --git a/drivers/infiniband/hw/mlx5/dmah.c b/drivers/infiniband/hw/mlx5/dmah.c
index 362a88992ffa2d5411c65c02e429b569adba8d74..84641e06d63c1ebc20ac57dbc11c36a46554b638 100644
--- a/drivers/infiniband/hw/mlx5/dmah.c
+++ b/drivers/infiniband/hw/mlx5/dmah.c
@@ -13,7 +13,7 @@
 static int mlx5_ib_alloc_dmah(struct ib_dmah *ibdmah,
 			      struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_core_dev *mdev = to_mdev(ibdmah->device)->mdev;
+	struct mlx5_core_dev *mdev = to_dev(ibdmah->device)->mdev;
 	struct mlx5_ib_dmah *dmah = to_mdmah(ibdmah);
 	u16 st_bits = BIT(IB_DMAH_CPU_ID_EXISTS) |
 		      BIT(IB_DMAH_MEM_TYPE_EXISTS);
@@ -40,7 +40,7 @@ static int mlx5_ib_dealloc_dmah(struct ib_dmah *ibdmah,
 				struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_dmah *dmah = to_mdmah(ibdmah);
-	struct mlx5_core_dev *mdev = to_mdev(ibdmah->device)->mdev;
+	struct mlx5_core_dev *mdev = to_dev(ibdmah->device)->mdev;
 
 	if (ibdmah->valid_fields & BIT(IB_DMAH_CPU_ID_EXISTS))
 		return mlx5_st_dealloc_index(mdev, dmah->st_index);
diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 8199d66bbfaf20cfc8f511f8b26e56923098032a..a9d47035eb54976517a78e0e431d755e1468cc77 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -687,7 +687,7 @@ enum flow_table_type {
 
 static bool __maybe_unused mlx5_ib_shared_ft_allowed(struct ib_device *device)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 
 	return MLX5_CAP_GEN(dev->mdev, shared_object_to_user_object_allowed);
 }
@@ -1364,7 +1364,7 @@ void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
 
 void mlx5r_fs_unbind_op_fc(struct ib_qp *qp, struct xarray *qpn_opfc_xa)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_per_qp_opfc *per_qp_opfc;
 	struct mlx5_ib_op_fc *in_use_opfc;
 	struct mlx5_ib_flow_prio *prio;
@@ -1403,7 +1403,7 @@ int mlx5r_fs_bind_op_fc(struct ib_qp *qp,
 			struct mlx5_fc *fc_arr[MLX5_IB_OPCOUNTER_MAX],
 			struct xarray *qpn_opfc_xa, u32 port)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_per_qp_opfc *per_qp_opfc;
 	struct mlx5_ib_flow_prio *prio;
 	struct mlx5_ib_counters *cnts;
@@ -1729,7 +1729,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 					   struct ib_flow_attr *flow_attr,
 					   struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	struct mlx5_ib_flow_handler *handler = NULL;
 	struct mlx5_flow_destination *dst = NULL;
@@ -2499,7 +2499,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	fs_matcher = uverbs_attr_get_obj(attrs,
 					 MLX5_IB_ATTR_CREATE_FLOW_MATCHER);
 	uobj =  uverbs_attr_get_uobject(attrs, MLX5_IB_ATTR_CREATE_FLOW_HANDLE);
-	dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	dev = udata_to_dev(&attrs->driver_udata);
 
 	if (get_dests(attrs, fs_matcher, &dest_id, &dest_type, &qp, &flags))
 		return -EINVAL;
@@ -2940,7 +2940,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE);
-	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	struct mlx5_ib_flow_matcher *obj;
 	int err;
 
@@ -3019,7 +3019,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_STEERING_ANCHOR_CREATE_HANDLE);
-	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	enum mlx5_ib_uapi_flow_table_type ib_uapi_ft_type;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5_ib_steering_anchor *obj;
@@ -3147,7 +3147,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE);
-	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	enum mlx5_ib_uapi_flow_table_type ft_type;
 	struct ib_flow_action *action;
 	int num_actions;
@@ -3273,7 +3273,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
 		MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE);
-	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	enum mlx5_ib_uapi_flow_action_packet_reformat_type dv_prt;
 	enum mlx5_ib_uapi_flow_table_type ft_type;
 	struct mlx5_ib_flow_action *maction;
diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 535a9f45fb33c124bf37ed7fccfdabc88186498c..65668bd1b30fcab6a5e6775e09505d417f33656a 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -88,7 +88,7 @@ static void handle_single_completion(struct ib_cq *cq, struct ib_wc *wc)
 int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
 		       struct ib_qp_init_attr *attr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_gsi_qp *gsi;
 	struct ib_qp_init_attr hw_init_attr = *attr;
 	const u8 port_num = attr->port_num;
@@ -168,7 +168,7 @@ int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
 
 int mlx5_ib_destroy_gsi(struct mlx5_ib_qp *mqp)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mqp->ibqp.device);
+	struct mlx5_ib_dev *dev = to_dev(mqp->ibqp.device);
 	struct mlx5_ib_gsi_qp *gsi = &mqp->gsi;
 	const int port_num = gsi->port_num;
 	int qp_index;
@@ -220,7 +220,7 @@ static struct ib_qp *create_gsi_ud_qp(struct mlx5_ib_gsi_qp *gsi)
 static int modify_to_rts(struct mlx5_ib_gsi_qp *gsi, struct ib_qp *qp,
 			 u16 pkey_index)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct ib_qp_attr attr;
 	int mask;
 	int ret;
@@ -260,7 +260,7 @@ static int modify_to_rts(struct mlx5_ib_gsi_qp *gsi, struct ib_qp *qp,
 static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
 {
 	struct ib_device *device = gsi->rx_qp->device;
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	int pkey_index = qp_index;
 	struct mlx5_ib_qp *mqp;
 	struct ib_qp *qp;
@@ -322,7 +322,7 @@ static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
 int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 			  int attr_mask)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	struct mlx5_ib_gsi_qp *gsi = &mqp->gsi;
 	u16 qp_index;
@@ -362,7 +362,7 @@ static int mlx5_ib_add_outstanding_wr(struct mlx5_ib_qp *mqp,
 				      struct ib_ud_wr *wr, struct ib_wc *wc)
 {
 	struct mlx5_ib_gsi_qp *gsi = &mqp->gsi;
-	struct mlx5_ib_dev *dev = to_mdev(gsi->rx_qp->device);
+	struct mlx5_ib_dev *dev = to_dev(gsi->rx_qp->device);
 	struct mlx5_ib_gsi_wr *gsi_wr;
 
 	if (gsi->outstanding_pi == gsi->outstanding_ci + gsi->cap.max_send_wr) {
@@ -412,7 +412,7 @@ static int mlx5_ib_gsi_silent_drop(struct mlx5_ib_qp *mqp, struct ib_ud_wr *wr)
 /* Call with gsi->lock locked */
 static struct ib_qp *get_tx_qp(struct mlx5_ib_gsi_qp *gsi, struct ib_ud_wr *wr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(gsi->rx_qp->device);
+	struct mlx5_ib_dev *dev = to_dev(gsi->rx_qp->device);
 	struct mlx5_ib_ah *ah = to_mah(wr->ah);
 	int qp_index = wr->pkey_index;
 
diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index 2c81a4e6712ef2b54576d1d3187b33d8a436cd4d..2c0122f26a49b1bbf5ef884c68080c613a5415d7 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -50,7 +50,7 @@ static inline u32 mlx_to_net_policy(enum port_state_policy mlx_policy)
 int mlx5_ib_get_vf_config(struct ib_device *device, int vf, u32 port,
 			  struct ifla_vf_info *info)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *rep;
 	int err;
@@ -92,7 +92,7 @@ static inline enum port_state_policy net_to_mlx_policy(int policy)
 int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 			      u32 port, int state)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
 	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
@@ -126,7 +126,7 @@ int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 	void *out;
 	int err;
 
-	dev = to_mdev(device);
+	dev = to_dev(device);
 	mdev = dev->mdev;
 
 	out = kzalloc(out_sz, GFP_KERNEL);
@@ -151,7 +151,7 @@ int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 static int set_vf_node_guid(struct ib_device *device, int vf, u32 port,
 			    u64 guid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
 	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
@@ -175,7 +175,7 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u32 port,
 static int set_vf_port_guid(struct ib_device *device, int vf, u32 port,
 			    u64 guid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *in;
 	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
@@ -211,7 +211,7 @@ int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 			struct ifla_vf_guid *node_guid,
 			struct ifla_vf_guid *port_guid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 
diff --git a/drivers/infiniband/hw/mlx5/macsec.c b/drivers/infiniband/hw/mlx5/macsec.c
index b44832025ab7c13fac82d2f987eda205586b7fec..0ea649298a96d8c0acd8902b453b1387c1c78185 100644
--- a/drivers/infiniband/hw/mlx5/macsec.c
+++ b/drivers/infiniband/hw/mlx5/macsec.c
@@ -216,7 +216,7 @@ void mlx5r_macsec_dealloc_gids(struct mlx5_ib_dev *dev)
 
 int mlx5r_add_gid_macsec_operations(const struct ib_gid_attr *attr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(attr->device);
+	struct mlx5_ib_dev *dev = to_dev(attr->device);
 	struct mlx5_macsec_device *macsec_device;
 	const struct ib_gid_attr *physical_gid;
 	struct mlx5_reserved_gids *mgids;
@@ -259,7 +259,7 @@ int mlx5r_add_gid_macsec_operations(const struct ib_gid_attr *attr)
 	physical_gid = rdma_find_gid(attr->device, &attr->gid,
 				     attr->gid_type, NULL);
 	if (!IS_ERR(physical_gid)) {
-		ret = set_roce_addr(to_mdev(physical_gid->device),
+		ret = set_roce_addr(to_dev(physical_gid->device),
 				    physical_gid->port_num,
 				    physical_gid->index, NULL,
 				    physical_gid);
@@ -286,7 +286,7 @@ int mlx5r_add_gid_macsec_operations(const struct ib_gid_attr *attr)
 	return ret;
 
 rule_err:
-	set_roce_addr(to_mdev(physical_gid->device), physical_gid->port_num,
+	set_roce_addr(to_dev(physical_gid->device), physical_gid->port_num,
 		      physical_gid->index, &physical_gid->gid, physical_gid);
 	mgids->macsec_index = -1;
 gid_err:
@@ -300,7 +300,7 @@ int mlx5r_add_gid_macsec_operations(const struct ib_gid_attr *attr)
 
 void mlx5r_del_gid_macsec_operations(const struct ib_gid_attr *attr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(attr->device);
+	struct mlx5_ib_dev *dev = to_dev(attr->device);
 	struct mlx5_macsec_device *macsec_device;
 	struct mlx5_reserved_gids *mgids;
 	struct net_device *ndev;
@@ -342,7 +342,7 @@ void mlx5r_del_gid_macsec_operations(const struct ib_gid_attr *attr)
 		if (mgids->macsec_index == attr->index) {
 			const struct ib_gid_attr *physical_gid = mgids->physical_gid;
 
-			set_roce_addr(to_mdev(physical_gid->device),
+			set_roce_addr(to_dev(physical_gid->device),
 				      physical_gid->port_num,
 				      physical_gid->index,
 				      &physical_gid->gid, physical_gid);
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 7fe6285359612b6cb92562b2ab8be459b4aeace4..c21f0632d83de4709ae133193f4b3e9f08b3f76e 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -302,7 +302,7 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 			const struct ib_mad *in, struct ib_mad *out,
 			size_t *out_mad_size, u16 *out_mad_pkey_index)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	u8 mgmt_class = in->mad_hdr.mgmt_class;
 	u8 method = in->mad_hdr.method;
 	u16 slid;
@@ -343,7 +343,7 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 		return IB_MAD_RESULT_SUCCESS;
 	}
 
-	err = mlx5_MAD_IFC(to_mdev(ibdev), mad_flags & IB_MAD_IGNORE_MKEY,
+	err = mlx5_MAD_IFC(to_dev(ibdev), mad_flags & IB_MAD_IGNORE_MKEY,
 			   mad_flags & IB_MAD_IGNORE_BKEY, port_num, in_wc,
 			   in_grh, in, out);
 	if (err)
@@ -402,7 +402,7 @@ static int mlx5_query_mad_ifc_smp_attr_node_info(struct ib_device *ibdev,
 	ib_init_query_mad(in_mad);
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
-	err = mlx5_MAD_IFC(to_mdev(ibdev), 1, 1, 1, NULL, NULL, in_mad,
+	err = mlx5_MAD_IFC(to_dev(ibdev), 1, 1, 1, NULL, NULL, in_mad,
 			   out_mad);
 
 	kfree(in_mad);
@@ -541,7 +541,7 @@ int mlx5_query_mad_ifc_pkey(struct ib_device *ibdev, u32 port, u16 index,
 	in_mad->attr_id  = IB_SMP_ATTR_PKEY_TABLE;
 	in_mad->attr_mod = cpu_to_be32(index / 32);
 
-	err = mlx5_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad,
+	err = mlx5_MAD_IFC(to_dev(ibdev), 1, 1, port, NULL, NULL, in_mad,
 			   out_mad);
 	if (err)
 		goto out;
@@ -570,7 +570,7 @@ int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u32 port, int index,
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
 	in_mad->attr_mod = cpu_to_be32(port);
 
-	err = mlx5_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad,
+	err = mlx5_MAD_IFC(to_dev(ibdev), 1, 1, port, NULL, NULL, in_mad,
 			   out_mad);
 	if (err)
 		goto out;
@@ -581,7 +581,7 @@ int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u32 port, int index,
 	in_mad->attr_id  = IB_SMP_ATTR_GUID_INFO;
 	in_mad->attr_mod = cpu_to_be32(index / 8);
 
-	err = mlx5_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad,
+	err = mlx5_MAD_IFC(to_dev(ibdev), 1, 1, port, NULL, NULL, in_mad,
 			   out_mad);
 	if (err)
 		goto out;
@@ -597,7 +597,7 @@ int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u32 port, int index,
 int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u32 port,
 			    struct ib_port_attr *props)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct ib_smp *in_mad;
 	struct ib_smp *out_mad;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9861683df051791bf9d3856c1ec0bcd20775eb18..b5d887250c05cdd5389113f69b8bbd2846253521 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -110,7 +110,7 @@ mlx5_port_type_cap_to_rdma_ll(int port_type_cap)
 static enum rdma_link_layer
 mlx5_ib_port_link_layer(struct ib_device *device, u32 port_num)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	int port_type_cap = MLX5_CAP_GEN(dev->mdev, port_type);
 
 	return mlx5_port_type_cap_to_rdma_ll(port_type_cap);
@@ -536,7 +536,7 @@ static int translate_eth_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 				struct ib_port_attr *props)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {0};
 	struct mlx5_core_dev *mdev;
 	struct net_device *ndev, *upper;
@@ -687,7 +687,7 @@ static int mlx5_ib_add_gid(const struct ib_gid_attr *attr,
 	if (ret)
 		return ret;
 
-	return set_roce_addr(to_mdev(attr->device), attr->port_num,
+	return set_roce_addr(to_dev(attr->device), attr->port_num,
 			     attr->index, &attr->gid, attr);
 }
 
@@ -696,7 +696,7 @@ static int mlx5_ib_del_gid(const struct ib_gid_attr *attr,
 {
 	int ret;
 
-	ret = set_roce_addr(to_mdev(attr->device), attr->port_num,
+	ret = set_roce_addr(to_dev(attr->device), attr->port_num,
 			    attr->index, NULL, attr);
 	if (ret)
 		return ret;
@@ -729,7 +729,7 @@ enum {
 
 static int mlx5_get_vport_access_method(struct ib_device *ibdev)
 {
-	if (mlx5_use_mad_ifc(to_mdev(ibdev)))
+	if (mlx5_use_mad_ifc(to_dev(ibdev)))
 		return MLX5_VPORT_ACCESS_METHOD_MAD;
 
 	if (mlx5_ib_port_link_layer(ibdev, 1) ==
@@ -772,7 +772,7 @@ static void get_atomic_caps_qp(struct mlx5_ib_dev *dev,
 static int mlx5_query_system_image_guid(struct ib_device *ibdev,
 					__be64 *sys_image_guid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	u64 tmp;
 	int err;
@@ -804,7 +804,7 @@ static int mlx5_query_system_image_guid(struct ib_device *ibdev,
 static int mlx5_query_max_pkeys(struct ib_device *ibdev,
 				u16 *max_pkeys)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 
 	switch (mlx5_get_vport_access_method(ibdev)) {
@@ -825,7 +825,7 @@ static int mlx5_query_max_pkeys(struct ib_device *ibdev,
 static int mlx5_query_vendor_id(struct ib_device *ibdev,
 				u32 *vendor_id)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 
 	switch (mlx5_get_vport_access_method(ibdev)) {
 	case MLX5_VPORT_ACCESS_METHOD_MAD:
@@ -947,7 +947,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				struct ib_udata *uhw)
 {
 	size_t uhw_outlen = (uhw) ? uhw->outlen : 0;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	int err = -ENOMEM;
 	int max_sq_desc;
@@ -1376,7 +1376,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 static void translate_active_width(struct ib_device *ibdev, u16 active_width,
 				   u8 *ib_width)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 
 	if (active_width & MLX5_PTYS_WIDTH_1X)
 		*ib_width = IB_WIDTH_1X;
@@ -1461,7 +1461,7 @@ static int translate_max_vl_num(struct ib_device *ibdev, u8 vl_hw_cap,
 static int mlx5_query_hca_port(struct ib_device *ibdev, u32 port,
 			       struct ib_port_attr *props)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_hca_vport_context *rep;
 	u8 vl_hw_cap, plane_index = 0;
@@ -1562,7 +1562,7 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u32 port,
 	}
 
 	if (!ret && props) {
-		struct mlx5_ib_dev *dev = to_mdev(ibdev);
+		struct mlx5_ib_dev *dev = to_dev(ibdev);
 		struct mlx5_core_dev *mdev;
 		bool put_mdev = true;
 
@@ -1709,7 +1709,7 @@ static int mlx5_ib_query_port_speed_rep(struct mlx5_ib_dev *dev, u32 port_num,
 
 int mlx5_ib_query_port_speed(struct ib_device *ibdev, u32 port_num, u64 *speed)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 
 	if (mlx5_ib_port_link_layer(ibdev, port_num) ==
 	    IB_LINK_LAYER_INFINIBAND || mlx5_core_mp_enabled(dev->mdev))
@@ -1723,7 +1723,7 @@ int mlx5_ib_query_port_speed(struct ib_device *ibdev, u32 port_num, u64 *speed)
 static int mlx5_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 			     union ib_gid *gid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 
 	switch (mlx5_get_vport_access_method(ibdev)) {
@@ -1742,7 +1742,7 @@ static int mlx5_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 static int mlx5_query_hca_nic_pkey(struct ib_device *ibdev, u32 port,
 				   u16 index, u16 *pkey)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_core_dev *mdev;
 	bool put_mdev = true;
 	u32 mdev_port_num;
@@ -1784,7 +1784,7 @@ static int mlx5_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 static int mlx5_ib_modify_device(struct ib_device *ibdev, int mask,
 				 struct ib_device_modify *props)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_reg_node_desc in;
 	struct mlx5_reg_node_desc out;
 	int err;
@@ -1847,7 +1847,7 @@ static int set_port_caps_atomic(struct mlx5_ib_dev *dev, u32 port_num, u32 mask,
 static int mlx5_ib_modify_port(struct ib_device *ibdev, u32 port, int mask,
 			       struct ib_port_modify *props)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct ib_port_attr attr;
 	u32 tmp;
 	int err;
@@ -2116,7 +2116,7 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 			     struct mlx5_ib_alloc_ucontext_resp *resp)
 {
 	struct ib_device *ibdev = uctx->device;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_ib_ucontext *context = to_mucontext(uctx);
 	struct mlx5_bfreg_info *bfregi = &context->bfregi;
 
@@ -2200,7 +2200,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 				  struct ib_udata *udata)
 {
 	struct ib_device *ibdev = uctx->device;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_ib_alloc_ucontext_req_v2 req;
 	struct mlx5_ib_alloc_ucontext_resp resp = {};
 	struct mlx5_ib_ucontext *context = to_mucontext(uctx);
@@ -2372,7 +2372,7 @@ static int mlx5_ib_query_ucontext(struct ib_ucontext *ibcontext,
 static void mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 {
 	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
-	struct mlx5_ib_dev *dev = to_mdev(ibcontext->device);
+	struct mlx5_ib_dev *dev = to_dev(ibcontext->device);
 	struct mlx5_bfreg_info *bfregi;
 
 	bfregi = &context->bfregi;
@@ -2503,7 +2503,7 @@ static int mlx5_ib_mmap_get_pfns(struct rdma_user_mmap_entry *entry,
 				 struct p2pdma_provider **provider)
 {
 	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
-	struct pci_dev *pdev = to_mdev(entry->ucontext->device)->mdev->pdev;
+	struct pci_dev *pdev = to_dev(entry->ucontext->device)->mdev->pdev;
 	int bar;
 
 	phys_vec->paddr = mentry->address;
@@ -2551,7 +2551,7 @@ static void mlx5_ib_free_var_mmap_entry(struct mlx5_user_mmap_entry *mentry,
 static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
 {
 	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
-	struct mlx5_ib_dev *dev = to_mdev(entry->ucontext->device);
+	struct mlx5_ib_dev *dev = to_dev(entry->ucontext->device);
 	struct mlx5_var_table *var_table = &dev->var_table;
 	struct mlx5_ib_ucontext *context = to_mucontext(entry->ucontext);
 	struct mlx5_var_region *var_region;
@@ -2743,7 +2743,7 @@ static u64 mlx5_entry_to_mmap_offset(struct mlx5_user_mmap_entry *entry)
 static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
 {
 	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
-	struct mlx5_ib_dev *dev = to_mdev(ibcontext->device);
+	struct mlx5_ib_dev *dev = to_dev(ibcontext->device);
 	unsigned long command;
 	phys_addr_t pfn;
 
@@ -2805,7 +2805,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	uid = context ? context->devx_uid : 0;
 	MLX5_SET(alloc_pd_in, in, opcode, MLX5_CMD_OP_ALLOC_PD);
 	MLX5_SET(alloc_pd_in, in, uid, uid);
-	err = mlx5_cmd_exec_inout(to_mdev(ibdev)->mdev, alloc_pd, in, out);
+	err = mlx5_cmd_exec_inout(to_dev(ibdev)->mdev, alloc_pd, in, out);
 	if (err)
 		return err;
 
@@ -2815,7 +2815,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 		resp.pdn = pd->pdn;
 		err = ib_respond_udata(udata, resp);
 		if (err) {
-			mlx5_cmd_dealloc_pd(to_mdev(ibdev)->mdev, pd->pdn, uid);
+			mlx5_cmd_dealloc_pd(to_dev(ibdev)->mdev, pd->pdn, uid);
 			return err;
 		}
 	}
@@ -2825,7 +2825,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 
 static int mlx5_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_pd *mpd = to_mpd(pd);
 
 	return mlx5_cmd_dealloc_pd(dev->mdev, mpd->pdn, mpd->uid);
@@ -2833,7 +2833,7 @@ static int mlx5_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
 
 static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(ibqp);
 	int err;
 	u16 uid;
@@ -2856,7 +2856,7 @@ static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 
 static int mlx5_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	int err;
 	u16 uid;
 
@@ -3587,7 +3587,7 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 static u32 get_core_cap_flags(struct ib_device *ibdev,
 			      struct mlx5_hca_vport_context *rep)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, 1);
 	u8 l3_type_cap = MLX5_CAP_ROCE(dev->mdev, l3_type);
 	u8 roce_version_cap = MLX5_CAP_ROCE(dev->mdev, roce_version);
@@ -3629,7 +3629,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, port_num);
 	struct mlx5_hca_vport_context rep = {0};
 	int err;
@@ -3888,7 +3888,7 @@ static int mlx5_ib_rn_get_params(struct ib_device *device, u32 port_num,
 	if (type != RDMA_NETDEV_IPOIB)
 		return -EOPNOTSUPP;
 
-	return mlx5_rdma_rn_get_params(to_mdev(device)->mdev, device, params);
+	return mlx5_rdma_rn_get_params(to_dev(device)->mdev, device, params);
 }
 
 static ssize_t delay_drop_timeout_read(struct file *filp, char __user *buf,
@@ -4221,7 +4221,7 @@ alloc_var_entry(struct mlx5_ib_ucontext *c, u32 flags)
 	u32 page_idx;
 	int err;
 
-	var_table = &to_mdev(c->ibucontext.device)->var_table;
+	var_table = &to_dev(c->ibucontext.device)->var_table;
 	if (flags & MLX5_IB_UAPI_VAR_ALLOC_FLAG_TLP)
 		var_region = &var_table->tlp_var_region;
 	else
@@ -4289,11 +4289,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_VAR_OBJ_ALLOC)(
 		return err;
 
 	if (flags & MLX5_IB_UAPI_VAR_ALLOC_FLAG_TLP) {
-		if (!MLX5_CAP_GEN(to_mdev(c->ibucontext.device)->mdev,
+		if (!MLX5_CAP_GEN(to_dev(c->ibucontext.device)->mdev,
 				  tlp_device_emulation_manager))
 			return -EOPNOTSUPP;
 	} else {
-		if (!(MLX5_CAP_GEN_64(to_mdev(c->ibucontext.device)->mdev,
+		if (!(MLX5_CAP_GEN_64(to_dev(c->ibucontext.device)->mdev,
 				      general_obj_types) &
 		      MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q))
 			return -EOPNOTSUPP;
@@ -4356,7 +4356,7 @@ DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_VAR,
 
 static bool var_is_supported(struct ib_device *device)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 
 	return (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
 			MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) ||
@@ -4376,7 +4376,7 @@ alloc_uar_entry(struct mlx5_ib_ucontext *c,
 	if (!entry)
 		return ERR_PTR(-ENOMEM);
 
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 	err = mlx5_cmd_uar_alloc(dev->mdev, &uar_index, c->devx_uid);
 	if (err)
 		goto end;
@@ -4426,7 +4426,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_UAR_OBJ_ALLOC)(
 	    alloc_type != MLX5_IB_UAPI_UAR_ALLOC_TYPE_NC)
 		return -EOPNOTSUPP;
 
-	if (!mlx5_wc_support_get(to_mdev(c->ibucontext.device)->mdev) &&
+	if (!mlx5_wc_support_get(to_dev(c->ibucontext.device)->mdev) &&
 	    alloc_type == MLX5_IB_UAPI_UAR_ALLOC_TYPE_BF)
 		return -EOPNOTSUPP;
 
@@ -5379,7 +5379,7 @@ static struct ib_device *mlx5_ib_add_sub_dev(struct ib_device *parent,
 					     enum rdma_nl_dev_type type,
 					     const char *name)
 {
-	struct mlx5_ib_dev *mparent = to_mdev(parent), *mplane;
+	struct mlx5_ib_dev *mparent = to_dev(parent), *mplane;
 	enum rdma_link_layer ll;
 	int ret;
 
@@ -5427,9 +5427,9 @@ static struct ib_device *mlx5_ib_add_sub_dev(struct ib_device *parent,
 
 static void mlx5_ib_del_sub_dev(struct ib_device *sub_dev)
 {
-	struct mlx5_ib_dev *dev = to_mdev(sub_dev);
+	struct mlx5_ib_dev *dev = to_dev(sub_dev);
 
-	to_mdev(sub_dev->parent)->smi_dev = NULL;
+	to_dev(sub_dev->parent)->smi_dev = NULL;
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 99220cb2a781d6caeaa86527e1f15c065635eb14..6fb4069660c43643424ffc65622817467c8cbc3a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1186,22 +1186,23 @@ static inline struct mlx5_ib_xrcd *to_mxrcd(struct ib_xrcd *ibxrcd)
 	return container_of(ibxrcd, struct mlx5_ib_xrcd, ibxrcd);
 }
 
-static inline struct mlx5_ib_dev *to_mdev(struct ib_device *ibdev)
+static inline struct mlx5_ib_dev *to_dev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct mlx5_ib_dev, ib_dev);
 }
 
-static inline struct mlx5_ib_dev *mr_to_mdev(struct mlx5_ib_mr *mr)
+static inline struct mlx5_ib_dev *mr_to_dev(struct mlx5_ib_mr *mr)
 {
-	return to_mdev(mr->ibmr.device);
+	return to_dev(mr->ibmr.device);
 }
 
-static inline struct mlx5_ib_dev *mlx5_udata_to_mdev(struct ib_udata *udata)
+static inline struct mlx5_ib_dev *udata_to_dev(struct ib_udata *udata)
 {
-	struct mlx5_ib_ucontext *context = rdma_udata_to_drv_context(
-		udata, struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_ib_ucontext *context =
+		rdma_udata_to_drv_context(udata, struct mlx5_ib_ucontext,
+					  ibucontext);
 
-	return to_mdev(context->ibucontext.device);
+	return to_dev(context->ibucontext.device);
 }
 
 static inline struct mlx5_ib_cq *to_mcq(struct ib_cq *ibcq)
@@ -1771,7 +1772,7 @@ static inline unsigned long
 mlx5_umem_dmabuf_find_best_pgsz(struct ib_umem_dmabuf *umem_dmabuf,
 				int access_mode)
 {
-	return mlx5_umem_mkc_find_best_pgsz(to_mdev(umem_dmabuf->umem.ibdev),
+	return mlx5_umem_mkc_find_best_pgsz(to_dev(umem_dmabuf->umem.ibdev),
 					    &umem_dmabuf->umem,
 					    umem_dmabuf->umem.iova,
 					    access_mode);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index a0fdfb509216f9cfdcbe2dd319f7682eb7ea6fc5..70cbb9b1997ce4168f4ee2d0e8ff8200c3444373 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -62,7 +62,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 					  struct ib_pd *pd)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 
 	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
@@ -226,7 +226,7 @@ static int mlx5r_create_mkeys(struct ib_device *device, struct ib_frmr_key *key,
 			MLX5_MKC_ACCESS_MODE_KSM :
 			MLX5_MKC_ACCESS_MODE_MTT;
 
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	u16 st_index;
 	void *mkc;
@@ -281,7 +281,7 @@ static int mlx5r_create_mkeys(struct ib_device *device, struct ib_frmr_key *key,
 static void mlx5r_destroy_mkeys(struct ib_device *device, u32 *handles,
 				unsigned int count)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	int i, err;
 
 	for (i = 0; i < count; i++) {
@@ -297,7 +297,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 				const struct ib_frmr_key *in,
 				struct ib_frmr_key *out)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	int err;
 
 	/* check HW capabilities of users requested frmr key */
@@ -329,7 +329,7 @@ static const struct ib_frmr_pool_ops mlx5r_frmr_pool_ops = {
 
 int mlx5r_frmr_pools_init(struct ib_device *device)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 
 	mutex_init(&dev->slow_path_mutex);
 	return ib_frmr_pools_init(device, &mlx5r_frmr_pool_ops);
@@ -342,7 +342,7 @@ void mlx5r_frmr_pools_cleanup(struct ib_device *device)
 
 struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	struct mlx5_ib_mr *mr;
 	void *mkc;
@@ -426,7 +426,7 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 					     int access_flags, int access_mode,
 					     u16 st_index, u8 ph)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_mr *mr;
 	unsigned long page_size;
 
@@ -456,7 +456,7 @@ static struct ib_mr *
 reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_flags,
 			    u32 crossed_lkey)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int access_mode = MLX5_MKC_ACCESS_MODE_CROSSING;
 	struct mlx5_ib_mr *mr;
 	void *mkc;
@@ -518,7 +518,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 				     unsigned long page_size, bool populate,
 				     int access_mode, u16 st_index, u8 ph)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_mr *mr;
 	__be64 *pas;
 	void *mkc;
@@ -623,7 +623,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 				       u64 length, int acc, int mode)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	struct mlx5_ib_mr *mr;
 	void *mkc;
@@ -687,8 +687,8 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 				struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_dm *mdm = to_mdm(dm);
-	struct mlx5_core_dev *mdev = to_mdev(dm->device)->mdev;
-	struct mlx5_ib_dev *ib_dev = to_mdev(dm->device);
+	struct mlx5_core_dev *mdev = to_dev(dm->device)->mdev;
+	struct mlx5_ib_dev *ib_dev = to_dev(dm->device);
 	u64 start_addr = mdm->dev_addr + attr->offset;
 	int mode, err;
 
@@ -725,7 +725,7 @@ static struct ib_mr *create_real_mr(struct ib_pd *pd, struct ib_umem *umem,
 				    u64 iova, int access_flags,
 				    struct ib_dmah *dmah)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_mr *mr = NULL;
 	bool xlt_with_umr;
 	u16 st_index = MLX5_MKC_PCIE_TPH_NO_STEERING_TAG_INDEX;
@@ -784,7 +784,7 @@ static struct ib_mr *create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length,
 					u64 iova, int access_flags,
 					struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct ib_umem_odp *odp;
 	struct mlx5_ib_mr *mr;
 	int err;
@@ -846,7 +846,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  struct ib_dmah *dmah,
 				  struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct ib_umem *umem;
 	int err;
 
@@ -901,7 +901,7 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 		   struct ib_dmah *dmah)
 {
 	bool pinned_mode = (access_mode == MLX5_MKC_ACCESS_MODE_KSM);
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_mr *mr = NULL;
 	struct ib_umem_dmabuf *umem_dmabuf;
 	u16 st_index = MLX5_MKC_PCIE_TPH_NO_STEERING_TAG_INDEX;
@@ -977,7 +977,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
 				  u64 length, u64 virt_addr,
 				  int fd, int access_flags)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_data_direct_dev *data_direct_dev;
 	struct ib_mr *crossing_mr;
 	struct ib_mr *crossed_mr;
@@ -1032,7 +1032,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
 					 struct ib_dmah *dmah,
 					 struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int mlx5_access_flags = 0;
 	int err;
 
@@ -1091,7 +1091,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 				  int new_access_flags, u64 iova,
 				  unsigned long *page_size)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
+	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	u8 access_mode;
 
 	/* We only track the allocated sizes of MRs from the frmr pools */
@@ -1117,7 +1117,7 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 			 int access_flags, int flags, struct ib_umem *new_umem,
 			 u64 iova, unsigned long page_size)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
+	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	int upd_flags = MLX5_IB_UPD_XLT_ADDR | MLX5_IB_UPD_XLT_ENABLE;
 	struct ib_umem *old_umem = mr->umem;
 	int err;
@@ -1163,7 +1163,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 				    struct ib_pd *new_pd,
 				    struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ib_mr->device);
+	struct mlx5_ib_dev *dev = to_dev(ib_mr->device);
 	struct mlx5_ib_mr *mr = to_mmr(ib_mr);
 	int err;
 
@@ -1285,7 +1285,7 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 		      int ndescs,
 		      int desc_size)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	int size = ndescs * desc_size;
 	int add_size;
@@ -1324,7 +1324,7 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 	    mr->ibmr.type != IB_MR_TYPE_DM && mr->descs) {
 		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_descs * mr->desc_size;
-		struct mlx5_ib_dev *dev = to_mdev(device);
+		struct mlx5_ib_dev *dev = to_dev(device);
 
 		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
 				 DMA_TO_DEVICE);
@@ -1335,7 +1335,7 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 
 static int mlx5_ib_revoke_data_direct_mr(struct mlx5_ib_mr *mr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
+	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	struct ib_umem_dmabuf *umem_dmabuf = to_ib_umem_dmabuf(mr->umem);
 	int err;
 
@@ -1397,7 +1397,7 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 {
 	bool is_odp_dma_buf = is_dmabuf_mr(mr) &&
 			      !to_ib_umem_dmabuf(mr->umem)->pinned;
-	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
+	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	bool is_odp = is_odp_mr(mr);
 	int ret;
 
@@ -1437,7 +1437,7 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
-	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_dev *dev = to_dev(ibmr->device);
 	int rc;
 
 	/*
@@ -1447,7 +1447,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	 */
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) &&
 	    refcount_read(&mr->mmkey.usecount) != 0 &&
-	    xa_erase(&mr_to_mdev(mr)->odp_mkeys, mlx5_base_mkey(mr->mmkey.key)))
+	    xa_erase(&mr_to_dev(mr)->odp_mkeys, mlx5_base_mkey(mr->mmkey.key)))
 		mlx5r_deref_wait_odp_mkey(&mr->mmkey);
 
 	if (ibmr->type == IB_MR_TYPE_INTEGRITY) {
@@ -1523,7 +1523,7 @@ static int dereg_crossing_data_direct_mr(struct mlx5_ib_dev *dev,
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
-	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_dev *dev = to_dev(ibmr->device);
 
 	if (mr->data_direct)
 		return dereg_crossing_data_direct_mr(dev, mr);
@@ -1534,7 +1534,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
 				   int access_mode, int page_shift)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	void *mkc;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
@@ -1556,7 +1556,7 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 				  int ndescs, int desc_size, int page_shift,
 				  int access_mode, u32 *in, int inlen)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int err;
 
 	mr->access_mode = access_mode;
@@ -1647,7 +1647,7 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 				      int max_num_sg, int max_num_meta_sg,
 				      u32 *in, int inlen)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	u32 psv_index[2];
 	void *mkc;
 	int err;
@@ -1725,7 +1725,7 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 					enum ib_mr_type mr_type, u32 max_num_sg,
 					u32 max_num_meta_sg)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	int ndescs = ALIGN(max_num_sg, 4);
 	struct mlx5_ib_mr *mr;
@@ -1790,7 +1790,7 @@ struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd,
 
 int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibmw->device);
+	struct mlx5_ib_dev *dev = to_dev(ibmw->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	struct mlx5_ib_mw *mw = to_mmw(ibmw);
 	unsigned int ndescs;
@@ -1863,7 +1863,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 
 int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mw->device);
+	struct mlx5_ib_dev *dev = to_dev(mw->device);
 	struct mlx5_ib_mw *mmw = to_mmw(mw);
 
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) &&
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index edb6be79f3da5618f2b9e777784090051df0ce20..d39611aa20f4b872c0c567dc601dd67a508024ec 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -107,12 +107,12 @@ static u8 mlx5_imr_ksm_page_shift;
 static void populate_ksm(struct mlx5_ksm *pksm, size_t idx, size_t nentries,
 			struct mlx5_ib_mr *imr, int flags)
 {
-	struct mlx5_core_dev *mdev = mr_to_mdev(imr)->mdev;
+	struct mlx5_core_dev *mdev = mr_to_dev(imr)->mdev;
 	struct mlx5_ksm *end = pksm + nentries;
 	u64 step = MLX5_CAP_ODP(mdev, mem_page_fault) ? mlx5_imr_mtt_size : 0;
 	__be32 key = MLX5_CAP_ODP(mdev, mem_page_fault) ?
 			     cpu_to_be32(imr->null_mmkey.key) :
-			     mr_to_mdev(imr)->mkeys.null_mkey;
+			     mr_to_dev(imr)->mkeys.null_mkey;
 	u64 va = MLX5_CAP_ODP(mdev, mem_page_fault) ?
 			     idx * mlx5_imr_mtt_size : 0;
 
@@ -254,8 +254,8 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 		return;
 	}
 
-	if (MLX5_CAP_ODP(mr_to_mdev(mr)->mdev, mem_page_fault))
-		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
+	if (MLX5_CAP_ODP(mr_to_dev(mr)->mdev, mem_page_fault))
+		xa_erase(&mr_to_dev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->mmkey.key));
 	xa_unlock(&imr->implicit_children);
 
@@ -469,7 +469,7 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
 static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 						unsigned long idx)
 {
-	struct mlx5_ib_dev *dev = mr_to_mdev(imr);
+	struct mlx5_ib_dev *dev = mr_to_dev(imr);
 	struct ib_umem_odp *odp;
 	struct mlx5_ib_mr *mr;
 	struct mlx5_ib_mr *ret;
@@ -491,7 +491,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 
 	mr->access_flags = imr->access_flags;
 	mr->ibmr.pd = imr->ibmr.pd;
-	mr->ibmr.device = &mr_to_mdev(imr)->ib_dev;
+	mr->ibmr.device = &mr_to_dev(imr)->ib_dev;
 	mr->umem = &odp->umem;
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
@@ -540,7 +540,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 		mr->mmkey.type = MLX5_MKEY_IMPLICIT_CHILD;
 	}
 	xa_unlock(&imr->implicit_children);
-	mlx5_ib_dbg(mr_to_mdev(imr), "key %x mr %p\n", mr->mmkey.key, mr);
+	mlx5_ib_dbg(mr_to_dev(imr), "key %x mr %p\n", mr->mmkey.key, mr);
 	return mr;
 
 out_lock:
@@ -605,7 +605,7 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 					     int access_flags)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->ibpd.device);
+	struct mlx5_ib_dev *dev = to_dev(pd->ibpd.device);
 	struct ib_umem_odp *umem_odp;
 	struct mlx5_ib_mr *imr;
 	int err;
@@ -681,10 +681,10 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
 	}
 
 	if (mr->null_mmkey.key) {
-		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
+		xa_erase(&mr_to_dev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->null_mmkey.key));
 
-		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
+		mlx5_core_destroy_mkey(mr_to_dev(mr)->mdev,
 				       mr->null_mmkey.key);
 	}
 }
@@ -733,7 +733,7 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 
 	if (ret < 0) {
 		if (ret != -EAGAIN)
-			mlx5_ib_err(mr_to_mdev(mr),
+			mlx5_ib_err(mr_to_dev(mr),
 				    "Failed to update mkey page tables\n");
 		goto out;
 	}
@@ -831,7 +831,7 @@ static int pagefault_implicit_mr(struct mlx5_ib_mr *imr,
 		MLX5_IB_UPD_XLT_INDIRECT | MLX5_IB_UPD_XLT_ATOMIC, 0);
 	mutex_unlock(&odp_imr->umem_mutex);
 	if (err) {
-		mlx5_ib_err(mr_to_mdev(imr), "Failed to update PAS\n");
+		mlx5_ib_err(mr_to_dev(imr), "Failed to update PAS\n");
 		return err;
 	}
 	return ret;
@@ -949,7 +949,7 @@ int mlx5_ib_init_odp_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 
 int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 {
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	u32 pdn;
 	int ret;
 
@@ -1968,7 +1968,7 @@ static struct mlx5_ib_mr *
 get_prefetchable_mr(struct ib_pd *pd, enum ib_uverbs_advise_mr_advice advice,
 		    u32 lkey)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_mr *mr = NULL;
 	struct mlx5_ib_mkey *mmkey;
 
diff --git a/drivers/infiniband/hw/mlx5/qos.c b/drivers/infiniband/hw/mlx5/qos.c
index ab7f5db18c9333009b9c916399e006026ac6b0f7..fea229c29611d46dae2ecaa39f786f9063063233 100644
--- a/drivers/infiniband/hw/mlx5/qos.c
+++ b/drivers/infiniband/hw/mlx5/qos.c
@@ -14,7 +14,7 @@
 
 static bool pp_is_supported(struct ib_device *device)
 {
-	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_dev(device);
 
 	return (MLX5_CAP_GEN(dev->mdev, qos) &&
 		MLX5_CAP_QOS(dev->mdev, packet_pacing) &&
@@ -44,7 +44,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	if (!c->devx_uid)
 		return -EINVAL;
 
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 	pp_entry = kzalloc_obj(*pp_entry);
 	if (!pp_entry)
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 52e2aff0df470882e311754a3a06505f67cfbd58..b8ca60903090298a41c11df2e10f612a10236fca 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -326,7 +326,7 @@ int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
 
 static void mlx5_ib_qp_err_syndrome(struct ib_qp *ibqp)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	int outlen = MLX5_ST_SZ_BYTES(query_qp_out);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	void *pas_ext_union, *err_syn;
@@ -3247,7 +3247,7 @@ static int get_qp_uidx(struct mlx5_ib_qp *qp,
 
 static int mlx5_ib_destroy_dct(struct mlx5_ib_qp *mqp)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mqp->ibqp.device);
+	struct mlx5_ib_dev *dev = to_dev(mqp->ibqp.device);
 
 	if (mqp->state == IB_QPS_RTR) {
 		int err;
@@ -3301,7 +3301,7 @@ int mlx5_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		      struct ib_udata *udata)
 {
 	struct mlx5_create_qp_params params = {};
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct ib_pd *pd = ibqp->pd;
 	enum ib_qp_type type;
@@ -3400,7 +3400,7 @@ int mlx5_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 int mlx5_ib_destroy_qp(struct ib_qp *qp, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 
 	if (mqp->type == IB_QPT_GSI)
@@ -3417,7 +3417,7 @@ static int set_qpc_atomic_flags(struct mlx5_ib_qp *qp,
 				const struct ib_qp_attr *attr, int attr_mask,
 				void *qpc)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
+	struct mlx5_ib_dev *dev = to_dev(qp->ibqp.device);
 	u8 dest_rd_atomic;
 	u32 access_flags;
 
@@ -4166,7 +4166,7 @@ static unsigned int get_tx_affinity(struct ib_qp *qp,
 {
 	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
 		udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	struct mlx5_ib_qp_base *qp_base;
 	unsigned int tx_affinity;
@@ -4222,7 +4222,7 @@ static int __mlx5_ib_qp_set_raw_qp_counter(struct mlx5_ib_qp *qp, u32 set_id,
 static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 				    struct rdma_counter *counter)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	u32 in[MLX5_ST_SZ_DW(rts2rts_qp_in)] = {};
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	struct mlx5_ib_qp_base *base;
@@ -4295,7 +4295,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	};
 
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
 	struct mlx5_ib_cq *send_cq, *recv_cq;
@@ -4663,7 +4663,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			      struct ib_udata *udata)
 {
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	enum ib_qp_state cur_state, new_state;
 	int required = IB_QP_STATE;
 	void *dctc;
@@ -4826,7 +4826,7 @@ static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_ib_modify_qp_resp resp = {};
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_ib_modify_qp ucmd = {};
@@ -5238,7 +5238,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		     int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	int err = 0;
 	u8 raw_packet_qp_state;
@@ -5307,7 +5307,7 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 int mlx5_ib_alloc_xrcd(struct ib_xrcd *ibxrcd, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibxrcd->device);
+	struct mlx5_ib_dev *dev = to_dev(ibxrcd->device);
 	struct mlx5_ib_xrcd *xrcd = to_mxrcd(ibxrcd);
 
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
@@ -5318,7 +5318,7 @@ int mlx5_ib_alloc_xrcd(struct ib_xrcd *ibxrcd, struct ib_udata *udata)
 
 int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(xrcd->device);
+	struct mlx5_ib_dev *dev = to_dev(xrcd->device);
 	u32 xrcdn = to_mxrcd(xrcd)->xrcdn;
 
 	return mlx5_cmd_xrcd_dealloc(dev->mdev, xrcdn, 0);
@@ -5327,7 +5327,7 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd, struct ib_udata *udata)
 static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
 {
 	struct mlx5_ib_rwq *rwq = to_mibrwq(core_qp);
-	struct mlx5_ib_dev *dev = to_mdev(rwq->ibwq.device);
+	struct mlx5_ib_dev *dev = to_dev(rwq->ibwq.device);
 	struct ib_event event;
 
 	if (rwq->ibwq.event_handler) {
@@ -5383,7 +5383,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	int inlen;
 	int err;
 
-	dev = to_mdev(pd->device);
+	dev = to_dev(pd->device);
 
 	ts_format = get_rq_ts_format(dev, to_mcq(init_attr->cq));
 	if (ts_format < 0)
@@ -5525,7 +5525,7 @@ static int prepare_user_rq(struct ib_pd *pd,
 			   struct ib_udata *udata,
 			   struct mlx5_ib_rwq *rwq)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_create_wq ucmd;
 	int err;
 
@@ -5608,7 +5608,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 	    init_attr->create_flags & IB_WQ_FLAGS_DELAY_DROP)
 		return ERR_PTR(-EPERM);
 
-	dev = to_mdev(pd->device);
+	dev = to_dev(pd->device);
 	switch (init_attr->wq_type) {
 	case IB_WQT_RQ:
 		rwq = kzalloc_obj(*rwq);
@@ -5652,7 +5652,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 
 int mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(wq->device);
+	struct mlx5_ib_dev *dev = to_dev(wq->device);
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
 	int ret;
 
@@ -5670,7 +5670,7 @@ int mlx5_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 {
 	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl =
 		to_mrwq_ind_table(ib_rwq_ind_table);
-	struct mlx5_ib_dev *dev = to_mdev(ib_rwq_ind_table->device);
+	struct mlx5_ib_dev *dev = to_dev(ib_rwq_ind_table->device);
 	int sz = 1 << init_attr->log_ind_tbl_size;
 	struct mlx5_ib_create_rwq_ind_tbl_resp resp = {};
 	size_t min_resp_len;
@@ -5738,7 +5738,7 @@ int mlx5_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
 int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
 {
 	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl = to_mrwq_ind_table(ib_rwq_ind_tbl);
-	struct mlx5_ib_dev *dev = to_mdev(ib_rwq_ind_tbl->device);
+	struct mlx5_ib_dev *dev = to_dev(ib_rwq_ind_tbl->device);
 
 	return mlx5_cmd_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn, rwq_ind_tbl->uid);
 }
@@ -5746,7 +5746,7 @@ int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
 int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(wq->device);
+	struct mlx5_ib_dev *dev = to_dev(wq->device);
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
 	struct mlx5_ib_modify_wq ucmd = {};
 	int curr_wq_state;
@@ -5902,7 +5902,7 @@ void mlx5_ib_drain_sq(struct ib_qp *qp)
 		},
 	};
 	int ret;
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 
 	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
@@ -5931,7 +5931,7 @@ void mlx5_ib_drain_rq(struct ib_qp *qp)
 	struct ib_recv_wr rwr = {};
 	const struct ib_recv_wr *bad_rwr;
 	int ret;
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 
 	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
@@ -5959,7 +5959,7 @@ void mlx5_ib_drain_rq(struct ib_qp *qp)
  */
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter)
 {
-	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_dev *dev = to_dev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	int err = 0;
 
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index 8a68b083b1b610215441438ab7bce189b97eba0f..866252cdce52452968519c8e785068a27cd40a34 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -124,7 +124,7 @@ static int fill_res_mr_entry_raw(struct sk_buff *msg, struct ib_mr *ibmr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 
-	return fill_res_raw(msg, mr_to_mdev(mr), MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
+	return fill_res_raw(msg, mr_to_dev(mr), MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
 			    mlx5_mkey_to_idx(mr->mmkey.key));
 }
 
@@ -158,7 +158,7 @@ static int fill_res_mr_entry(struct sk_buff *msg, struct ib_mr *ibmr)
 
 static int fill_res_cq_entry_raw(struct sk_buff *msg, struct ib_cq *ibcq)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibcq->device);
+	struct mlx5_ib_dev *dev = to_dev(ibcq->device);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 
 	return fill_res_raw(msg, dev, MLX5_SGMT_TYPE_PRM_QUERY_CQ, cq->mcq.cqn);
@@ -191,7 +191,7 @@ static int fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp)
 
 static int fill_res_qp_entry_raw(struct sk_buff *msg, struct ib_qp *ibqp)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 
 	return fill_res_raw(msg, dev, MLX5_SGMT_TYPE_PRM_QUERY_QP,
 			    ibqp->qp_num);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 95f18e97cf695e84c42a624bfaaa28f329de82d0..f87b4c62d7d17867f16b65d5cd02ee09e3d64c51 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -47,7 +47,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 			   struct mlx5_srq_attr *in,
 			   struct ib_udata *udata, int buf_size)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_create_srq ucmd;
 	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
 		udata, struct mlx5_ib_ucontext, ibucontext);
@@ -192,7 +192,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 		       struct ib_srq_init_attr *init_attr,
 		       struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ib_srq->device);
+	struct mlx5_ib_dev *dev = to_dev(ib_srq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ib_srq);
 	size_t desc_size;
 	size_t buf_size;
@@ -324,7 +324,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		       enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibsrq->device);
+	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	int ret;
 
@@ -349,7 +349,7 @@ int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibsrq->device);
+	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	int ret;
 	struct mlx5_srq_attr *out;
@@ -373,7 +373,7 @@ int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 
 int mlx5_ib_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_mdev(srq->device);
+	struct mlx5_ib_dev *dev = to_dev(srq->device);
 	struct mlx5_ib_srq *msrq = to_msrq(srq);
 	int ret;
 
@@ -408,7 +408,7 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	struct mlx5_wqe_srq_next_seg *next;
 	struct mlx5_wqe_data_seg *scat;
-	struct mlx5_ib_dev *dev = to_mdev(ibsrq->device);
+	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	unsigned long flags;
 	int err = 0;
diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index b705b88dc917b9a91a3216abf780caa4c805bf37..3f15feca98b529fda3d2619a4c260b2398d895ee 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -166,7 +166,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_QUERY_PORT)(
 	c = to_mucontext(ib_uverbs_get_ucontext(attrs));
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 
 	if (!rdma_is_port_valid(&dev->ib_dev, port_num))
 		return -EINVAL;
@@ -200,7 +200,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 	c = to_mucontext(ib_uverbs_get_ucontext(attrs));
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_mdev(c->ibucontext.device);
+	dev = to_dev(c->ibucontext.device);
 	mutex_lock(&dev->data_direct_lock);
 	data_direct_dev = mlx5_data_direct_get_dev(dev->mdev->data_direct);
 	if (!data_direct_dev) {
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 2f3147c7f78f302eb63ae14d53754106177a54ab..14f679d2d4d41784ed7dc6dbc35749fc8a7d0fc1 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -243,7 +243,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 		with_data ? sizeof(struct mlx5r_umr_wqe) :
 			    sizeof(struct mlx5r_umr_wqe) -
 				    sizeof(struct mlx5_wqe_data_seg);
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_ctrl_seg *ctrl;
@@ -422,7 +422,7 @@ static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
  */
 int mlx5r_umr_revoke_mr(struct mlx5_ib_mr *mr)
 {
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 
 	if (dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
@@ -458,7 +458,7 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 			      int access_flags)
 {
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 	int err;
 
@@ -670,7 +670,7 @@ static void _mlx5r_umr_init_wqe(struct mlx5_ib_mr *mr,
 				unsigned int flags, u32 pdn,
 				unsigned int page_shift)
 {
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 
 	mlx5r_umr_set_update_xlt_ctrl_seg(&wqe->ctrl_seg, flags, sg);
 	mlx5r_umr_set_update_xlt_mkey_seg(dev, &wqe->mkey_seg, mr, pdn,
@@ -683,7 +683,7 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 				    size_t nblocks)
 {
 	size_t ent_size = dd ? sizeof(struct mlx5_ksm) : sizeof(struct mlx5_mtt);
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	struct mlx5r_umr_wqe wqe = {};
 	size_t processed_blocks = 0;
@@ -808,7 +808,7 @@ int mlx5r_umr_update_data_direct_ksm_pas_range(struct mlx5_ib_mr *mr,
 		return -EINVAL;
 
 	return _mlx5r_umr_update_mr_pas(mr, flags,
-					mr_to_mdev(mr)->mdev->data_direct->pdn,
+					mr_to_dev(mr)->mdev->data_direct->pdn,
 					true, start_block, nblocks);
 }
 
@@ -850,7 +850,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 			       ? sizeof(struct mlx5_klm)
 			       : sizeof(struct mlx5_mtt);
 	const int page_align = MLX5_UMR_FLEX_ALIGNMENT / desc_size;
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	const int page_mask = page_align - 1;
 	struct mlx5r_umr_wqe wqe = {};
@@ -939,7 +939,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
 				   unsigned int page_shift)
 {
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 	int err;
 
@@ -992,7 +992,7 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr, unsigned int flags,
 			       u32 pdn, bool dd)
 {
 	unsigned int old_page_shift = mr->page_shift;
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	unsigned int max_page_shift;
 	size_t page_shift_nblocks;
 	unsigned int max_log_size;
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index bb2c60380fe2169a0b9d9bdeae461c7aedb8d3d3..3d3fdbce1354f4390b1ebbd14114c0efd93f46df 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -639,7 +639,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 {
 	struct mlx5_ib_mr *mr = to_mmr(wr->mr);
 	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
-	struct mlx5_ib_dev *dev = to_mdev(pd->ibpd.device);
+	struct mlx5_ib_dev *dev = to_dev(pd->ibpd.device);
 	int mr_list_size = (mr->mmkey.ndescs + mr->meta_ndescs) * mr->desc_size;
 	bool umr_inline = mr_list_size <= MLX5_IB_SQ_UMR_INLINE_THRESHOLD;
 	bool atomic = wr->access & IB_ACCESS_REMOTE_ATOMIC;
@@ -651,13 +651,13 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	 */
 	if (!mlx5r_umr_can_reconfig(dev, 0, wr->access)) {
 		mlx5_ib_warn(
-			to_mdev(qp->ibqp.device),
+			to_dev(qp->ibqp.device),
 			"Fast update for MR access flags is not possible\n");
 		return -EINVAL;
 	}
 
 	if (unlikely(wr->wr.send_flags & IB_SEND_INLINE)) {
-		mlx5_ib_warn(to_mdev(qp->ibqp.device),
+		mlx5_ib_warn(to_dev(qp->ibqp.device),
 			     "Invalid IB_SEND_INLINE send flag\n");
 		return -EINVAL;
 	}
@@ -1055,7 +1055,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr, bool drain)
 {
 	struct mlx5_wqe_ctrl_seg *ctrl = NULL;  /* compiler warning */
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_xrc_seg *xrc;
@@ -1212,7 +1212,7 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_data_seg *scat;
 	struct mlx5_rwqe_sig *sig;
-	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	unsigned long flags;
 	int err = 0;

-- 
2.49.0

