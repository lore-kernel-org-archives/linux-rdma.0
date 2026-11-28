Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870905;
	b=QKAWJrOe8VtkhZnQ2OWdeaszLVze84GefF7GaLpAFTw6vEn1N20JIBX9Lz14ndHK3jSa
	 BVMPplYX7yrcYtI8dsTPMmyUt7yCH8aVr8G2Pd1b6iF4TXjnZ4zgbCtE4t+dbSTDY9IXd
	 FHw1ekGbLAK5GC4oeAShxnoKlpsuwVUQuUeKNntt8ajlcboNgXYZH1JYCz+E1TQnH8g2r
	 8/BfxdN5UFBfQzzUwuYZ6FEnJwWuGMlzMtzxiAP59cJa74Pr8/lo3lACJKVBgAHCWdqyk
	 X6cLMiO+6f6xnQVN68h7JYgqItzGtqtg9UBpbJGn+7xNM4VCOISJtQ6n10qMUCN0YCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870905;
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
	bh=eB0sLleg3d63WsmpGVKBZb0q14Cgh753YrJNQCHJ16M=;
	b=KQ6ZwC4j1SeXM904sDXvm8cJ85hIZSDiNWEEZME3YLisWH/nTW/sf5yYb/7FsKAcqhKU
	 6EYH2BB1oOETiyGc6ek/YuQMLL0EwtrpfatHe9T8IT+2oqqBlOkkWW56pyHkYD5lyz+6G
	 t0xpyeqQwtdOMJ8Ims3fvPJebeVBSoC2ccGmEzxvO/vU2GBGiyz/0Kqcyy3gCaV6pGwJ7
	 R6967dJtPP3BfFICE5WkXWO1Thmg8oj97CVbT8FlaNilTOH2Wp2OGBeMW+hFj6IQOqPsf
	 +D/mJpY2inj6j0OUBdcSH+7jhRtk+t/6L4n4EHb+RhgAJ486mCIN8gPzKa/8Y8SCtiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fl0D1UTW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.69
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011069.outbound.protection.outlook.com [52.101.57.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4678B606A31F;
	Sat, 28 Nov 2026 13:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4678B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fl0D1UTW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CdsYQs9GAqj4jxWtUfjcHedrWzmXhLyssxBfgdPf4Js/Tnmg+SXAncmBiwffF09YEZkMXcsrSlKyylGYGWvNKAnHNEsJIIWV2VV7+4qHw9PDaejxZc7/R9GJnOMQj2AbY68n8A+j0zYwQoSyQVg/YluqBhdQ9JJyhE7teifHNDcw/bPaNREoBciGWIaZbuvtp/sbKrRjEIcrvxfTfeeJPpMnd3Q4v/ymtkEqeZzG2IZ1JiK8dMa5eL5/wUAViOGVOEhUqVZ/RIrju9gnHBwyYBzfuKWO9IvU/PnnRTfeZrqT7+pPk9tacP9fpuncbtqPq6jA0o3raY0RxK+hXqqe3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB0sLleg3d63WsmpGVKBZb0q14Cgh753YrJNQCHJ16M=;
 b=LsTi9GGcUkuL5DQVNcV2LfZhKQaVoF+uQeNtu4pfp/OYktGmVlc4Hv1FE+QXwE01vNvcnqkSFUzTwl3Hvg7+iNEOPI8Mk6Qg1s9gEzxdJqS+oVEwbFy5jweo2Yb/tJi/IXNIPbqLBd24FeBn87zE00ywZWVNFSNeVRXS1ea9lUUEExTRQL0FHdRToNsv+Oph4jR7TVY9rkZNJ5kEcjL1E/2rtVqr0sWAj3JFiTAzNCRz76n/ABmbUpBZoM5KdHnG8lYQ3nYxcd3HtmnKSyjjaxmtOU7/ZLisxdZFan/YycE1QkiZcNFVDdGrqA0j/bnvUoflR0N0qGDW05u7WfIeyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB0sLleg3d63WsmpGVKBZb0q14Cgh753YrJNQCHJ16M=;
 b=fl0D1UTWyZW88j5M65incG6mLK18MLOcSNO570cYm5u32HcZzQ8eVU6kYIAyEIwuN0jlOEBAjbbkIeMLaZsDWcdIM4v/wzzVvj2IkQSipSHLNaU7n14Iw+k9ECpONs6O29PsBYFaUkeW786R9x1MstTO0jyhoybFQteWhWe6VncosaOoWqLhaaft2u/CiZwp0ciBdypQipbj1/9OLPtvI/7RUIryBuMiVtEDVKhuCzmwTTIpfjDsupOmYwLHVkbtU/fGf8R1uPCn4XWo0EvBQA3rkk93RV2IsheEkLjp2aOABoH2Br656IzW9mSIGnp6muhY9jYEifWE/WOXurypzA==
Received: from BN9PR03CA0407.namprd03.prod.outlook.com (2603:10b6:408:111::22)
 by DS7PR12MB9526.namprd12.prod.outlook.com (2603:10b6:8:251::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Sat, 28 Nov
 2026 13:01:36 +0000
Received: from BN5PEPF0004698C.namprd02.prod.outlook.com
 (2603:10b6:408:111:cafe::55) by BN9PR03CA0407.outlook.office365.com
 (2603:10b6:408:111::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698C.mail.protection.outlook.com (10.167.245.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:24 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:23 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:21 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:14 +0200
Subject: [PATCH rdma-next v2 01/11] RDMA/mlx5: Enforce dev/mdev naming for
 device pointers
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
Message-ID: <20261128-mlx5-sd-prep-v2-1-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=43227;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=MTmK6c/3UwtNCcFP7XlMF2H5tV/K3WancuDKx6QUV9k=;
 b=WkumdviZ8bjL511wEVuJrcNS78ighu5jcKd+OtorCYXtz44uSpMWoR3v2A91okr2FPpOUHsiK
 cd7GdFwdp3CAdn82k9B8C51I3627TqgpQCRXR3aVQa7WOfV9Pq4leik
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698C:EE_|DS7PR12MB9526:EE_
X-MS-Office365-Filtering-Correlation-Id: f4289770-0c6d-4aa4-0a4a-08df4d4fbc0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|261102123227099003|10067099003|260925021911599003|260925022911599003|260925021311599003|261026140227099003|261022115727099003|261026130827099003|261028144727099003|261022075727099003|261022113327099003|261022105027099003|261021123027099003|261021133027099003|261021135927099003|261021130227099003|261021121427099003|261026135527099003|261026121527099003|56012099006|261009223027099003|22082099003|18002099003|11063799006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	jDZGMvpHUmaYAPJct0ydQKW+iKzUcoWPJbYzDLenR5pSnr511rHrt1lKTD5kGIsMSFNiLa/gchiHdB3wkedcjrpL2B7F3O77HNDS8pv0pRdYfEmocFo95crui3pJa1gKqxeot45eGdfKpY63v4mQeYFboLSG3ruGibOEn4XDr1ge94dVOLw3bJgKVS+qFIc7YoqMRRUPKEOV1lrIDZSkMBLNKQhE+ZJxeVtScUiiXQVPOHHmh8QfEWk3Skre1toMmTTamaoDRqrIxMqGVT+fbq2fDi9IKbR4KojodASCeezsYUfUmWygTLA2HKseORJEWj0OMNBVnm9rriWHUFnTVNTlURlmC6lkoOh51w8zfTwJFRmChNFLmYEAGo1/wGsSdaYcWKRDhhIhYA8BD1bvfzkO+/tVWCXHXc/BCi4PB4m2hRQnV/4ydTJTto3JJ+UFg8hyPdQ+pIiAtQat4hJiX2c+6gSPkJZoOkb3YT/R6mU6LgaxNEdrzHVrXfU26H3TGmhGYWCw6sFeeevqsB9wWDO5Umu/nU+xAv1EXujJ8fi3HyD1VNpPmlf8ZC22dO2lyvLfMJGql0uIGmqv0kDI0fragJf1o1qdliqEzWw3/vAAOEoqgikIg4tqxK3ZrdZ6EizpaCHr8CLZhODLZOUhwmNi05WBP9oNiu+m5H1ZLb6CIxeHnsQTR9WHtXZwQAPcMVbXBoMP5t2kqp4AE9eQPw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(261102123227099003)(10067099003)(260925021911599003)(260925022911599003)(260925021311599003)(261026140227099003)(261022115727099003)(261026130827099003)(261028144727099003)(261022075727099003)(261022113327099003)(261022105027099003)(261021123027099003)(261021133027099003)(261021135927099003)(261021130227099003)(261021121427099003)(261026135527099003)(261026121527099003)(56012099006)(261009223027099003)(22082099003)(18002099003)(11063799006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VZSsyk7CBYj4G9E4l6+G3ByB8RN5mp95e8c0G7sC9uZqgU47IssgAi/4lugFNuFBtPiKXAnmCAfiNY0cx1c6Jp4FXK+FgHPgraIVfLkz4Pvjm7U6bHl2KOu7Uls1cCi0I7teNCXO0+zr5YNAE5sZ4ze7qMMKnwXbvjXIl+1XCLlSXfgdY3C2IJSkaDNGxpA5jSPomgG7KdZxQarQufTVROjlVip0RqUrcUND/rPqysZBItgpS03kEyOmqacK9nfBfYQSsKv2xN2jAR6UEJeqWnzFeXnq1cWGrrGzkBLjZvV3HK9Q9PyiegEV6fKNlQdCMkrhburSsuzKQyEvmaRjT+ZEV2LeLMXfX+8Z+W+Bsm2JQJ6JCAr7WASZQOFOTUUdYVZniKQSiQPxIYe9KicT1JzOFx7qNI2p2xFHRvoPzfNgqOrffq3HH5MHr2rPQk15
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:36.0850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4289770-0c6d-4aa4-0a4a-08df4d4fbc0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9526

From: Akiva Goldberger <agoldberger@nvidia.com>

The driver mixes two conventions for its two device handles: a struct
mlx5_ib_dev is usually called "dev" and a struct mlx5_core_dev "mdev",
but a number of functions and structs use the opposite name - a core
device called "dev", or an IB device called "mdev". The inconsistent
naming convention makes it easy to grab the wrong handle.

Rename variables, parameters and struct fields so that "dev" refers to
struct mlx5_ib_dev pointer exclusively and "mdev" refers to struct
mlx5_core_dev exclusively. This includes two struct fields: struct
mlx5_dm's core device becomes "mdev" and struct devx_async_data's IB
device becomes "dev". References to either device handle that utilize a
different but obviously specific name (ibdev, core_dev, cur_owner, mdm,
...) are left untouched.

The following commit will apply this naming convention to existing
helpers that return either of the device handles.

Pure rename; no functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cmd.c      | 52 ++++++++++++++---------------
 drivers/infiniband/hw/mlx5/cmd.h      | 26 +++++++--------
 drivers/infiniband/hw/mlx5/devx.c     | 32 +++++++++---------
 drivers/infiniband/hw/mlx5/dm.c       | 63 ++++++++++++++++++-----------------
 drivers/infiniband/hw/mlx5/fs.c       | 18 +++++-----
 drivers/infiniband/hw/mlx5/ib_rep.c   | 45 +++++++++++++------------
 drivers/infiniband/hw/mlx5/mad.c      |  4 +--
 drivers/infiniband/hw/mlx5/main.c     | 10 +++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  2 +-
 drivers/infiniband/hw/mlx5/mr.c       |  4 +--
 drivers/infiniband/hw/mlx5/odp.c      | 10 +++---
 drivers/infiniband/hw/mlx5/qp.c       | 24 ++++++-------
 drivers/infiniband/hw/mlx5/qpc.c      |  2 +-
 drivers/infiniband/hw/mlx5/restrack.c |  3 +-
 14 files changed, 149 insertions(+), 146 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 895b62cc528df6e73f64acd46aea34d56e23c608..40bbb11fb5a23a358af0d46e06181fc56356f22c 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -42,7 +42,7 @@ int mlx5r_cmd_query_special_mkeys(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
+int mlx5_cmd_query_cong_params(struct mlx5_core_dev *mdev, int cong_point,
 			       void *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_cong_params_in)] = {};
@@ -51,40 +51,40 @@ int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 		 MLX5_CMD_OP_QUERY_CONG_PARAMS);
 	MLX5_SET(query_cong_params_in, in, cong_protocol, cong_point);
 
-	return mlx5_cmd_exec_inout(dev, query_cong_params, in, out);
+	return mlx5_cmd_exec_inout(mdev, query_cong_params, in, out);
 }
 
-void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid)
+void mlx5_cmd_destroy_tir(struct mlx5_core_dev *mdev, u32 tirn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_tir_in)] = {};
 
 	MLX5_SET(destroy_tir_in, in, opcode, MLX5_CMD_OP_DESTROY_TIR);
 	MLX5_SET(destroy_tir_in, in, tirn, tirn);
 	MLX5_SET(destroy_tir_in, in, uid, uid);
-	mlx5_cmd_exec_in(dev, destroy_tir, in);
+	mlx5_cmd_exec_in(mdev, destroy_tir, in);
 }
 
-void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid)
+void mlx5_cmd_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_tis_in)] = {};
 
 	MLX5_SET(destroy_tis_in, in, opcode, MLX5_CMD_OP_DESTROY_TIS);
 	MLX5_SET(destroy_tis_in, in, tisn, tisn);
 	MLX5_SET(destroy_tis_in, in, uid, uid);
-	mlx5_cmd_exec_in(dev, destroy_tis, in);
+	mlx5_cmd_exec_in(mdev, destroy_tis, in);
 }
 
-int mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid)
+int mlx5_cmd_destroy_rqt(struct mlx5_core_dev *mdev, u32 rqtn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_rqt_in)] = {};
 
 	MLX5_SET(destroy_rqt_in, in, opcode, MLX5_CMD_OP_DESTROY_RQT);
 	MLX5_SET(destroy_rqt_in, in, rqtn, rqtn);
 	MLX5_SET(destroy_rqt_in, in, uid, uid);
-	return mlx5_cmd_exec_in(dev, destroy_rqt, in);
+	return mlx5_cmd_exec_in(mdev, destroy_rqt, in);
 }
 
-int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
+int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *mdev, u32 *tdn,
 				    u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(alloc_transport_domain_in)] = {};
@@ -95,7 +95,7 @@ int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
 		 MLX5_CMD_OP_ALLOC_TRANSPORT_DOMAIN);
 	MLX5_SET(alloc_transport_domain_in, in, uid, uid);
 
-	err = mlx5_cmd_exec_inout(dev, alloc_transport_domain, in, out);
+	err = mlx5_cmd_exec_inout(mdev, alloc_transport_domain, in, out);
 	if (!err)
 		*tdn = MLX5_GET(alloc_transport_domain_out, out,
 				transport_domain);
@@ -103,7 +103,7 @@ int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
 	return err;
 }
 
-void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
+void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *mdev, u32 tdn,
 				       u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_transport_domain_in)] = {};
@@ -112,20 +112,20 @@ void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
 		 MLX5_CMD_OP_DEALLOC_TRANSPORT_DOMAIN);
 	MLX5_SET(dealloc_transport_domain_in, in, uid, uid);
 	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
-	mlx5_cmd_exec_in(dev, dealloc_transport_domain, in);
+	mlx5_cmd_exec_in(mdev, dealloc_transport_domain, in);
 }
 
-int mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid)
+int mlx5_cmd_dealloc_pd(struct mlx5_core_dev *mdev, u32 pdn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_pd_in)] = {};
 
 	MLX5_SET(dealloc_pd_in, in, opcode, MLX5_CMD_OP_DEALLOC_PD);
 	MLX5_SET(dealloc_pd_in, in, pd, pdn);
 	MLX5_SET(dealloc_pd_in, in, uid, uid);
-	return mlx5_cmd_exec_in(dev, dealloc_pd, in);
+	return mlx5_cmd_exec_in(mdev, dealloc_pd, in);
 }
 
-int mlx5_cmd_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+int mlx5_cmd_attach_mcg(struct mlx5_core_dev *mdev, union ib_gid *mgid,
 			u32 qpn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(attach_to_mcg_in)] = {};
@@ -136,10 +136,10 @@ int mlx5_cmd_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
 	MLX5_SET(attach_to_mcg_in, in, uid, uid);
 	gid = MLX5_ADDR_OF(attach_to_mcg_in, in, multicast_gid);
 	memcpy(gid, mgid, sizeof(*mgid));
-	return mlx5_cmd_exec_in(dev, attach_to_mcg, in);
+	return mlx5_cmd_exec_in(mdev, attach_to_mcg, in);
 }
 
-int mlx5_cmd_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+int mlx5_cmd_detach_mcg(struct mlx5_core_dev *mdev, union ib_gid *mgid,
 			u32 qpn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(detach_from_mcg_in)] = {};
@@ -150,10 +150,10 @@ int mlx5_cmd_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
 	MLX5_SET(detach_from_mcg_in, in, uid, uid);
 	gid = MLX5_ADDR_OF(detach_from_mcg_in, in, multicast_gid);
 	memcpy(gid, mgid, sizeof(*mgid));
-	return mlx5_cmd_exec_in(dev, detach_from_mcg, in);
+	return mlx5_cmd_exec_in(mdev, detach_from_mcg, in);
 }
 
-int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid)
+int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *mdev, u32 *xrcdn, u16 uid)
 {
 	u32 out[MLX5_ST_SZ_DW(alloc_xrcd_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(alloc_xrcd_in)] = {};
@@ -161,20 +161,20 @@ int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid)
 
 	MLX5_SET(alloc_xrcd_in, in, opcode, MLX5_CMD_OP_ALLOC_XRCD);
 	MLX5_SET(alloc_xrcd_in, in, uid, uid);
-	err = mlx5_cmd_exec_inout(dev, alloc_xrcd, in, out);
+	err = mlx5_cmd_exec_inout(mdev, alloc_xrcd, in, out);
 	if (!err)
 		*xrcdn = MLX5_GET(alloc_xrcd_out, out, xrcd);
 	return err;
 }
 
-int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid)
+int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *mdev, u32 xrcdn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_xrcd_in)] = {};
 
 	MLX5_SET(dealloc_xrcd_in, in, opcode, MLX5_CMD_OP_DEALLOC_XRCD);
 	MLX5_SET(dealloc_xrcd_in, in, xrcd, xrcdn);
 	MLX5_SET(dealloc_xrcd_in, in, uid, uid);
-	return mlx5_cmd_exec_in(dev, dealloc_xrcd, in);
+	return mlx5_cmd_exec_in(mdev, dealloc_xrcd, in);
 }
 
 int mlx5_cmd_mad_ifc(struct mlx5_ib_dev *dev, const void *inb, void *outb,
@@ -220,7 +220,7 @@ int mlx5_cmd_mad_ifc(struct mlx5_ib_dev *dev, const void *inb, void *outb,
 	return err;
 }
 
-int mlx5_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid)
+int mlx5_cmd_uar_alloc(struct mlx5_core_dev *mdev, u32 *uarn, u16 uid)
 {
 	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)] = {};
@@ -228,7 +228,7 @@ int mlx5_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid)
 
 	MLX5_SET(alloc_uar_in, in, opcode, MLX5_CMD_OP_ALLOC_UAR);
 	MLX5_SET(alloc_uar_in, in, uid, uid);
-	err = mlx5_cmd_exec_inout(dev, alloc_uar, in, out);
+	err = mlx5_cmd_exec_inout(mdev, alloc_uar, in, out);
 	if (err)
 		return err;
 
@@ -236,12 +236,12 @@ int mlx5_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid)
 	return 0;
 }
 
-int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *dev, u32 uarn, u16 uid)
+int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *mdev, u32 uarn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_uar_in)] = {};
 
 	MLX5_SET(dealloc_uar_in, in, opcode, MLX5_CMD_OP_DEALLOC_UAR);
 	MLX5_SET(dealloc_uar_in, in, uar, uarn);
 	MLX5_SET(dealloc_uar_in, in, uid, uid);
-	return mlx5_cmd_exec_in(dev, dealloc_uar, in);
+	return mlx5_cmd_exec_in(mdev, dealloc_uar, in);
 }
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index e5cd31270443d8f8e7801247d1dad5e8982fd42a..32507443abf3ab46b56d50d4b6a6fa28312e2cf5 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -38,24 +38,24 @@
 #include <linux/mlx5/driver.h>
 
 int mlx5r_cmd_query_special_mkeys(struct mlx5_ib_dev *dev);
-int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
+int mlx5_cmd_query_cong_params(struct mlx5_core_dev *mdev, int cong_point,
 			       void *out);
-int mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid);
-void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
-void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid);
-int mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid);
-int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
+int mlx5_cmd_dealloc_pd(struct mlx5_core_dev *mdev, u32 pdn, u16 uid);
+void mlx5_cmd_destroy_tir(struct mlx5_core_dev *mdev, u32 tirn, u16 uid);
+void mlx5_cmd_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn, u16 uid);
+int mlx5_cmd_destroy_rqt(struct mlx5_core_dev *mdev, u32 rqtn, u16 uid);
+int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *mdev, u32 *tdn,
 				    u16 uid);
-void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
+void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *mdev, u32 tdn,
 				       u16 uid);
-int mlx5_cmd_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+int mlx5_cmd_attach_mcg(struct mlx5_core_dev *mdev, union ib_gid *mgid,
 			u32 qpn, u16 uid);
-int mlx5_cmd_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+int mlx5_cmd_detach_mcg(struct mlx5_core_dev *mdev, union ib_gid *mgid,
 			u32 qpn, u16 uid);
-int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid);
-int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid);
+int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *mdev, u32 *xrcdn, u16 uid);
+int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *mdev, u32 xrcdn, u16 uid);
 int mlx5_cmd_mad_ifc(struct mlx5_ib_dev *dev, const void *inb, void *outb,
 		     u16 opmod, u8 port);
-int mlx5_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid);
-int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *dev, u32 uarn, u16 uid);
+int mlx5_cmd_uar_alloc(struct mlx5_core_dev *mdev, u32 *uarn, u16 uid);
+int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *mdev, u32 uarn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 5ba783bc7f9b78fca8a04cb59da62c16bcfed12b..e74f44819ac8ae60571429a4943c72591f82b319 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -44,7 +44,7 @@ struct mlx5_async_cmd {
 };
 
 struct devx_async_data {
-	struct mlx5_ib_dev *mdev;
+	struct mlx5_ib_dev *dev;
 	struct list_head list;
 	struct devx_async_cmd_event_file *ev_file;
 	struct mlx5_async_work cb_work;
@@ -1652,7 +1652,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 							  MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
 	void *cmd_out;
 	int err, err2;
 	int uid;
@@ -1677,7 +1677,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
-	err = mlx5_cmd_do(mdev->mdev, cmd_in,
+	err = mlx5_cmd_do(dev->mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1702,7 +1702,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	void *cmd_out;
 	int err, err2;
 	int uid;
-	struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
 
 	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
 		return -EINVAL;
@@ -1722,7 +1722,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_do(mdev->mdev, cmd_in,
+	err = mlx5_cmd_do(dev->mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1764,12 +1764,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC)(
 
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DEVX_ASYNC_CMD_FD_ALLOC_HANDLE);
-	struct mlx5_ib_dev *mdev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
 
 	ev_file = container_of(uobj, struct devx_async_cmd_event_file,
 			       uobj);
 	devx_init_event_queue(&ev_file->ev_queue);
-	mlx5_cmd_init_async_ctx(mdev->mdev, &ev_file->async_ctx);
+	mlx5_cmd_init_async_ctx(dev->mdev, &ev_file->async_ctx);
 	return 0;
 }
 
@@ -1841,7 +1841,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	struct ib_uobject *fd_uobj;
 	int err;
 	int uid;
-	struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
+	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
 	struct devx_async_cmd_event_file *ev_file;
 	struct devx_async_data *async_data;
 
@@ -1890,7 +1890,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 		goto free_async;
 
 	async_data->cmd_out_len = cmd_out_len;
-	async_data->mdev = mdev;
+	async_data->dev = dev;
 	async_data->ev_file = ev_file;
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
@@ -2021,7 +2021,7 @@ static bool is_valid_events_legacy(int num_events, u16 *event_type_num_list,
 }
 
 #define MAX_SUPP_EVENT_NUM 255
-static bool is_valid_events(struct mlx5_core_dev *dev,
+static bool is_valid_events(struct mlx5_core_dev *mdev,
 			    int num_events, u16 *event_type_num_list,
 			    struct devx_obj *obj)
 {
@@ -2031,10 +2031,10 @@ static bool is_valid_events(struct mlx5_core_dev *dev,
 	int mask_bit;
 	int i;
 
-	if (MLX5_CAP_GEN(dev, event_cap)) {
-		aff_events = MLX5_CAP_DEV_EVENT(dev,
+	if (MLX5_CAP_GEN(mdev, event_cap)) {
+		aff_events = MLX5_CAP_DEV_EVENT(mdev,
 						user_affiliated_events);
-		unaff_events = MLX5_CAP_DEV_EVENT(dev,
+		unaff_events = MLX5_CAP_DEV_EVENT(mdev,
 						  user_unaffiliated_events);
 	} else {
 		return is_valid_events_legacy(num_events, event_type_num_list,
@@ -2474,17 +2474,17 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
 	return 0;
 }
 
-static bool is_unaffiliated_event(struct mlx5_core_dev *dev,
+static bool is_unaffiliated_event(struct mlx5_core_dev *mdev,
 				  unsigned long event_type)
 {
 	__be64 *unaff_events;
 	int mask_entry;
 	int mask_bit;
 
-	if (!MLX5_CAP_GEN(dev, event_cap))
+	if (!MLX5_CAP_GEN(mdev, event_cap))
 		return is_legacy_unaffiliated_event_num(event_type);
 
-	unaff_events = MLX5_CAP_DEV_EVENT(dev,
+	unaff_events = MLX5_CAP_DEV_EVENT(mdev,
 					  user_unaffiliated_events);
 	WARN_ON(event_type > MAX_SUPP_EVENT_NUM);
 
diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 461e59788af9b4be03fb85bda7c161985e009ffa..141331c4eb747d5b0b6973dfedc63ae4f7acf5c5 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -12,11 +12,12 @@
 static int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
 				u64 length, u32 alignment)
 {
-	struct mlx5_core_dev *dev = dm->dev;
-	u64 num_memic_hw_pages = MLX5_CAP_DEV_MEM(dev, memic_bar_size)
+	struct mlx5_core_dev *mdev = dm->mdev;
+	u64 num_memic_hw_pages = MLX5_CAP_DEV_MEM(mdev, memic_bar_size)
 					>> PAGE_SHIFT;
-	u64 hw_start_addr = MLX5_CAP64_DEV_MEM(dev, memic_bar_start_addr);
-	u32 max_alignment = MLX5_CAP_DEV_MEM(dev, log_max_memic_addr_alignment);
+	u64 hw_start_addr = MLX5_CAP64_DEV_MEM(mdev, memic_bar_start_addr);
+	u32 max_alignment =
+		MLX5_CAP_DEV_MEM(mdev, log_max_memic_addr_alignment);
 	u32 num_pages = DIV_ROUND_UP(length, PAGE_SIZE);
 	u32 out[MLX5_ST_SZ_DW(alloc_memic_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(alloc_memic_in)] = {};
@@ -60,7 +61,7 @@ static int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
 		MLX5_SET64(alloc_memic_in, in, range_start_addr,
 			   hw_start_addr + (page_idx * PAGE_SIZE));
 
-		ret = mlx5_cmd_exec_inout(dev, alloc_memic, in, out);
+		ret = mlx5_cmd_exec_inout(mdev, alloc_memic, in, out);
 		if (ret) {
 			spin_lock(&dm->lock);
 			bitmap_clear(dm->memic_alloc_pages,
@@ -75,7 +76,7 @@ static int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
 			return ret;
 		}
 
-		*addr = dev->bar_addr +
+		*addr = mdev->bar_addr +
 			MLX5_GET64(alloc_memic_out, out, memic_start_addr);
 
 		return 0;
@@ -87,21 +88,21 @@ static int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
 void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 			    u64 length)
 {
-	struct mlx5_core_dev *dev = dm->dev;
-	u64 hw_start_addr = MLX5_CAP64_DEV_MEM(dev, memic_bar_start_addr);
+	struct mlx5_core_dev *mdev = dm->mdev;
+	u64 hw_start_addr = MLX5_CAP64_DEV_MEM(mdev, memic_bar_start_addr);
 	u32 num_pages = DIV_ROUND_UP(length, PAGE_SIZE);
 	u32 in[MLX5_ST_SZ_DW(dealloc_memic_in)] = {};
 	u64 start_page_idx;
 	int err;
 
-	addr -= dev->bar_addr;
+	addr -= mdev->bar_addr;
 	start_page_idx = (addr - hw_start_addr) >> PAGE_SHIFT;
 
 	MLX5_SET(dealloc_memic_in, in, opcode, MLX5_CMD_OP_DEALLOC_MEMIC);
 	MLX5_SET64(dealloc_memic_in, in, memic_start_addr, addr);
 	MLX5_SET(dealloc_memic_in, in, memic_size, length);
 
-	err =  mlx5_cmd_exec_in(dev, dealloc_memic, in);
+	err =  mlx5_cmd_exec_in(mdev, dealloc_memic, in);
 	if (err)
 		return;
 
@@ -115,14 +116,15 @@ void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
 			       u8 operation)
 {
 	u32 in[MLX5_ST_SZ_DW(modify_memic_in)] = {};
-	struct mlx5_core_dev *dev = dm->dev;
+	struct mlx5_core_dev *mdev = dm->mdev;
 
 	MLX5_SET(modify_memic_in, in, opcode, MLX5_CMD_OP_MODIFY_MEMIC);
 	MLX5_SET(modify_memic_in, in, op_mod, MLX5_MODIFY_MEMIC_OP_MOD_DEALLOC);
 	MLX5_SET(modify_memic_in, in, memic_operation_type, operation);
-	MLX5_SET64(modify_memic_in, in, memic_start_addr, addr - dev->bar_addr);
+	MLX5_SET64(modify_memic_in, in, memic_start_addr,
+		   addr - mdev->bar_addr);
 
-	mlx5_cmd_exec_in(dev, modify_memic, in);
+	mlx5_cmd_exec_in(mdev, modify_memic, in);
 }
 
 static int mlx5_cmd_alloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
@@ -130,19 +132,20 @@ static int mlx5_cmd_alloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
 {
 	u32 out[MLX5_ST_SZ_DW(modify_memic_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(modify_memic_in)] = {};
-	struct mlx5_core_dev *dev = dm->dev;
+	struct mlx5_core_dev *mdev = dm->mdev;
 	int err;
 
 	MLX5_SET(modify_memic_in, in, opcode, MLX5_CMD_OP_MODIFY_MEMIC);
 	MLX5_SET(modify_memic_in, in, op_mod, MLX5_MODIFY_MEMIC_OP_MOD_ALLOC);
 	MLX5_SET(modify_memic_in, in, memic_operation_type, operation);
-	MLX5_SET64(modify_memic_in, in, memic_start_addr, addr - dev->bar_addr);
+	MLX5_SET64(modify_memic_in, in, memic_start_addr,
+		   addr - mdev->bar_addr);
 
-	err = mlx5_cmd_exec_inout(dev, modify_memic, in, out);
+	err = mlx5_cmd_exec_inout(mdev, modify_memic, in, out);
 	if (err)
 		return err;
 
-	*op_addr = dev->bar_addr +
+	*op_addr = mdev->bar_addr +
 		   MLX5_GET64(modify_memic_out, out, memic_operation_addr);
 	return 0;
 }
@@ -288,7 +291,7 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 	int err;
 	u64 address;
 
-	if (!dm_db || !MLX5_CAP_DEV_MEM(dm_db->dev, memic))
+	if (!dm_db || !MLX5_CAP_DEV_MEM(dm_db->mdev, memic))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	dm = kzalloc_obj(*dm);
@@ -360,7 +363,7 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 					    struct uverbs_attr_bundle *attrs,
 					    int type)
 {
-	struct mlx5_core_dev *dev = to_mdev(ctx->device)->mdev;
+	struct mlx5_core_dev *mdev = to_mdev(ctx->device)->mdev;
 	enum mlx5_sw_icm_type icm_type;
 	struct mlx5_ib_dm_icm *dm;
 	u64 act_size;
@@ -373,15 +376,15 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
 	case MLX5_IB_UAPI_DM_TYPE_ENCAP_SW_ICM:
-		if (!(MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner) ||
-		      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner) ||
-		      MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) ||
-		      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2)))
+		if (!(MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner) ||
+		      MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner) ||
+		      MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner_v2) ||
+		      MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner_v2)))
 			return ERR_PTR(-EOPNOTSUPP);
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
-		if (!MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) ||
-		    !MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2))
+		if (!MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner_v2) ||
+		    !MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner_v2))
 			return ERR_PTR(-EOPNOTSUPP);
 		break;
 	default:
@@ -398,13 +401,13 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 	/* Allocation size must a multiple of the basic block size
 	 * and a power of 2.
 	 */
-	act_size = round_up(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dev));
+	act_size = round_up(attr->length, MLX5_SW_ICM_BLOCK_SIZE(mdev));
 	act_size = roundup_pow_of_two(act_size);
 
 	dm->base.size = act_size;
 	icm_type = get_icm_type(type);
 
-	err = mlx5_dm_sw_icm_alloc(dev, icm_type, act_size, attr->alignment,
+	err = mlx5_dm_sw_icm_alloc(mdev, icm_type, act_size, attr->alignment,
 				   to_mucontext(ctx)->devx_uid,
 				   &dm->base.dev_addr, &dm->obj_id);
 	if (err)
@@ -413,7 +416,7 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
 			     &dm->base.dev_addr, sizeof(dm->base.dev_addr));
 	if (err) {
-		mlx5_dm_sw_icm_dealloc(dev, icm_type, dm->base.size,
+		mlx5_dm_sw_icm_dealloc(mdev, icm_type, dm->base.size,
 				       to_mucontext(ctx)->devx_uid,
 				       dm->base.dev_addr, dm->obj_id);
 		goto free;
@@ -477,10 +480,10 @@ static int mlx5_dm_icm_dealloc(struct mlx5_ib_ucontext *ctx,
 			       struct mlx5_ib_dm_icm *dm)
 {
 	enum mlx5_sw_icm_type type = get_icm_type(dm->base.type);
-	struct mlx5_core_dev *dev = to_mdev(dm->base.ibdm.device)->mdev;
+	struct mlx5_core_dev *mdev = to_mdev(dm->base.ibdm.device)->mdev;
 	int err;
 
-	err = mlx5_dm_sw_icm_dealloc(dev, type, dm->base.size, ctx->devx_uid,
+	err = mlx5_dm_sw_icm_dealloc(mdev, type, dm->base.size, ctx->devx_uid,
 				     dm->base.dev_addr, dm->obj_id);
 	if (!err)
 		kfree(dm);
diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 07486885e046a9a527371160206d3cb2d911b6c4..8199d66bbfaf20cfc8f511f8b26e56923098032a 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -3147,14 +3147,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_HANDLE);
-	struct mlx5_ib_dev *mdev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
 	enum mlx5_ib_uapi_flow_table_type ft_type;
 	struct ib_flow_action *action;
 	int num_actions;
 	void *in;
 	int ret;
 
-	if (!mlx5_ib_modify_header_supported(mdev))
+	if (!mlx5_ib_modify_header_supported(dev))
 		return -EOPNOTSUPP;
 
 	in = uverbs_attr_get_alloced_ptr(attrs,
@@ -3170,11 +3170,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
 			       MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE);
 	if (ret)
 		return ret;
-	action = mlx5_ib_create_modify_header(mdev, ft_type, num_actions, in);
+	action = mlx5_ib_create_modify_header(dev, ft_type, num_actions, in);
 	if (IS_ERR(action))
 		return PTR_ERR(action);
 
-	uverbs_flow_action_fill_action(action, uobj, &mdev->ib_dev,
+	uverbs_flow_action_fill_action(action, uobj, &dev->ib_dev,
 				       IB_FLOW_ACTION_UNSPECIFIED);
 
 	return 0;
@@ -3273,7 +3273,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
 		MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_HANDLE);
-	struct mlx5_ib_dev *mdev = mlx5_udata_to_mdev(&attrs->driver_udata);
+	struct mlx5_ib_dev *dev = mlx5_udata_to_mdev(&attrs->driver_udata);
 	enum mlx5_ib_uapi_flow_action_packet_reformat_type dv_prt;
 	enum mlx5_ib_uapi_flow_table_type ft_type;
 	struct mlx5_ib_flow_action *maction;
@@ -3289,7 +3289,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(
 	if (ret)
 		return ret;
 
-	if (!mlx5_ib_flow_action_packet_reformat_valid(mdev, dv_prt, ft_type))
+	if (!mlx5_ib_flow_action_packet_reformat_valid(dev, dv_prt, ft_type))
 		return -EOPNOTSUPP;
 
 	maction = kzalloc_obj(*maction);
@@ -3300,7 +3300,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(
 	    MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TUNNEL_TO_L2) {
 		maction->flow_action_raw.sub_type =
 			MLX5_IB_FLOW_ACTION_DECAP;
-		maction->flow_action_raw.dev = mdev;
+		maction->flow_action_raw.dev = dev;
 	} else {
 		void *in;
 		int len;
@@ -3315,13 +3315,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT)(
 		len = uverbs_attr_get_len(attrs,
 			MLX5_IB_ATTR_CREATE_PACKET_REFORMAT_DATA_BUF);
 
-		ret = mlx5_ib_flow_action_create_packet_reformat_ctx(mdev,
+		ret = mlx5_ib_flow_action_create_packet_reformat_ctx(dev,
 			maction, ft_type, dv_prt, in, len);
 		if (ret)
 			goto free_maction;
 	}
 
-	uverbs_flow_action_fill_action(&maction->ib_action, uobj, &mdev->ib_dev,
+	uverbs_flow_action_fill_action(&maction->ib_action, uobj, &dev->ib_dev,
 				       IB_FLOW_ACTION_UNSPECIFIED);
 	return 0;
 
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 249acc9b7cd55b88fdded606b0037fd88b0edc4c..244c22bc09086a2af06d3090e3501a48b539b742 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -9,7 +9,7 @@
 #include "srq.h"
 
 static int
-mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
+mlx5_ib_set_vport_rep(struct mlx5_core_dev *mdev,
 		      struct mlx5_core_dev *rep_dev,
 		      struct mlx5_eswitch_rep *rep,
 		      int vport_index)
@@ -18,7 +18,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 	struct net_device *ndev;
 	int ret;
 
-	ibdev = mlx5_eswitch_uplink_get_proto_dev(dev->priv.eswitch, REP_IB);
+	ibdev = mlx5_eswitch_uplink_get_proto_dev(mdev->priv.eswitch, REP_IB);
 	if (!ibdev)
 		return -EINVAL;
 
@@ -33,7 +33,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 	/* Only Vports that are not native to the LAG master eswitch need to add
 	 * demux rule.
 	 */
-	if (mlx5_eswitch_get_total_vports(dev) > vport_index)
+	if (mlx5_eswitch_get_total_vports(mdev) > vport_index)
 		return 0;
 
 	return mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
@@ -41,12 +41,12 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 
 static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev);
 
-static void mlx5_ib_num_ports_update(struct mlx5_core_dev *dev, u32 *num_ports)
+static void mlx5_ib_num_ports_update(struct mlx5_core_dev *mdev, u32 *num_ports)
 {
 	struct mlx5_core_dev *peer_dev;
 	int i;
 
-	mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
+	mlx5_lag_for_each_peer_mdev(mdev, peer_dev, i) {
 		u32 peer_num_ports = mlx5_eswitch_get_total_vports(peer_dev);
 
 		if (mlx5_lag_is_mpesw(peer_dev))
@@ -97,27 +97,27 @@ static int mlx5_ib_set_owner_transport(struct mlx5_core_dev *cur_owner,
 	return ret;
 }
 
-static void mlx5_ib_release_transport(struct mlx5_core_dev *dev)
+static void mlx5_ib_release_transport(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_core_dev *peer_dev;
 	int i, ret;
 
-	mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
+	mlx5_lag_for_each_peer_mdev(mdev, peer_dev, i) {
 		ret = mlx5_ib_set_owner_transport(peer_dev, peer_dev);
 		WARN_ON_ONCE(ret);
 	}
 }
 
-static int mlx5_ib_take_transport(struct mlx5_core_dev *dev)
+static int mlx5_ib_take_transport(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_core_dev *peer_dev;
 	int ret;
 	int i;
 
-	mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
-		ret = mlx5_ib_set_owner_transport(peer_dev, dev);
+	mlx5_lag_for_each_peer_mdev(mdev, peer_dev, i) {
+		ret = mlx5_ib_set_owner_transport(peer_dev, mdev);
 		if (ret) {
-			mlx5_ib_release_transport(dev);
+			mlx5_ib_release_transport(mdev);
 			return ret;
 		}
 	}
@@ -126,10 +126,10 @@ static int mlx5_ib_take_transport(struct mlx5_core_dev *dev)
 }
 
 static int
-mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
+mlx5_ib_vport_rep_load(struct mlx5_core_dev *mdev, struct mlx5_eswitch_rep *rep)
 {
-	u32 num_ports = mlx5_eswitch_get_total_vports(dev);
-	struct mlx5_core_dev *lag_master = dev;
+	u32 num_ports = mlx5_eswitch_get_total_vports(mdev);
+	struct mlx5_core_dev *lag_master = mdev;
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_core_dev *peer_dev;
 	struct mlx5_ib_dev *ibdev;
@@ -140,16 +140,16 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	vport_index = rep->vport_index;
 
-	if (mlx5_lag_is_shared_fdb(dev)) {
-		if (mlx5_lag_is_master(dev)) {
-			mlx5_ib_num_ports_update(dev, &num_ports);
+	if (mlx5_lag_is_shared_fdb(mdev)) {
+		if (mlx5_lag_is_master(mdev)) {
+			mlx5_ib_num_ports_update(mdev, &num_ports);
 		} else {
 			if (rep->vport == MLX5_VPORT_UPLINK) {
-				if (!mlx5_lag_is_mpesw(dev))
+				if (!mlx5_lag_is_mpesw(mdev))
 					return 0;
 				new_uplink = true;
 			}
-			mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
+			mlx5_lag_for_each_peer_mdev(mdev, peer_dev, i) {
 				u32 peer_n_ports = mlx5_eswitch_get_total_vports(peer_dev);
 
 				if (mlx5_lag_is_master(peer_dev))
@@ -159,7 +159,7 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 					peer_n_ports--;
 
 				if (mlx5_lag_get_dev_seq(peer_dev) <
-				    mlx5_lag_get_dev_seq(dev))
+				    mlx5_lag_get_dev_seq(mdev))
 					vport_index += peer_n_ports;
 			}
 		}
@@ -168,9 +168,10 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	if (rep->vport == MLX5_VPORT_UPLINK && !new_uplink)
 		profile = &raw_eth_profile;
 	else
-		return mlx5_ib_set_vport_rep(lag_master, dev, rep, vport_index);
+		return mlx5_ib_set_vport_rep(lag_master, mdev, rep,
+					     vport_index);
 
-	if (mlx5_lag_is_shared_fdb(dev)) {
+	if (mlx5_lag_is_shared_fdb(mdev)) {
 		ret = mlx5_ib_take_transport(lag_master);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 8925331855ff58f0eebc69efa76a0bf09b62ced2..7fe6285359612b6cb92562b2ab8be459b4aeace4 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -178,7 +178,7 @@ static void pma_cnt_ext_assign_ppcnt(struct ib_pma_portcounters_ext *cnt_ext,
 		cpu_to_be64(MLX5_GET_EXT_CNTR(port_multicast_rcv_pkts));
 }
 
-static int query_ib_ppcnt(struct mlx5_core_dev *dev, u8 port_num, u8 plane_num,
+static int query_ib_ppcnt(struct mlx5_core_dev *mdev, u8 port_num, u8 plane_num,
 			  void *out, size_t sz, bool ext)
 {
 	u32 *in;
@@ -199,7 +199,7 @@ static int query_ib_ppcnt(struct mlx5_core_dev *dev, u8 port_num, u8 plane_num,
 	else
 		MLX5_SET(ppcnt_reg, in, grp,
 			 MLX5_INFINIBAND_PORT_COUNTERS_GROUP);
-	err = mlx5_core_access_reg(dev, in, sz, out,
+	err = mlx5_core_access_reg(mdev, in, sz, out,
 				   sz, MLX5_REG_PPCNT, 0, 0);
 
 	kvfree(in);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1e58aa132c5b5c6d6de694f298fe1d6ed11e4cd1..9861683df051791bf9d3856c1ec0bcd20775eb18 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2825,10 +2825,10 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 
 static int mlx5_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *mdev = to_mdev(pd->device);
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_pd *mpd = to_mpd(pd);
 
-	return mlx5_cmd_dealloc_pd(mdev->mdev, mpd->pdn, mpd->uid);
+	return mlx5_cmd_dealloc_pd(dev->mdev, mpd->pdn, mpd->uid);
 }
 
 static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
@@ -4588,7 +4588,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	atomic_set(&dev->mkey_var, 0);
 
 	spin_lock_init(&dev->dm.lock);
-	dev->dm.dev = mdev;
+	dev->dm.mdev = mdev;
 	err = mlx5_ib_data_direct_init(dev);
 	if (err)
 		goto err_mp;
@@ -5427,10 +5427,10 @@ static struct ib_device *mlx5_ib_add_sub_dev(struct ib_device *parent,
 
 static void mlx5_ib_del_sub_dev(struct ib_device *sub_dev)
 {
-	struct mlx5_ib_dev *mdev = to_mdev(sub_dev);
+	struct mlx5_ib_dev *dev = to_mdev(sub_dev);
 
 	to_mdev(sub_dev->parent)->smi_dev = NULL;
-	__mlx5_ib_remove(mdev, mdev->profile, MLX5_IB_STAGE_MAX);
+	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 }
 
 static int mlx5r_mp_probe(struct auxiliary_device *adev,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index cd3129af157a12fe4785f75f3e98173277f06da3..99220cb2a781d6caeaa86527e1f15c065635eb14 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -990,7 +990,7 @@ struct mlx5_ib_flow_action {
 };
 
 struct mlx5_dm {
-	struct mlx5_core_dev *dev;
+	struct mlx5_core_dev *mdev;
 	/* This lock is used to protect the access to the shared
 	 * allocation map when concurrent requests by different
 	 * processes are handled.
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7952d80349dc6c086758472da762f320ca8e5df8..a0fdfb509216f9cfdcbe2dd319f7682eb7ea6fc5 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -687,7 +687,7 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 				struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_dm *mdm = to_mdm(dm);
-	struct mlx5_core_dev *dev = to_mdev(dm->device)->mdev;
+	struct mlx5_core_dev *mdev = to_mdev(dm->device)->mdev;
 	struct mlx5_ib_dev *ib_dev = to_mdev(dm->device);
 	u64 start_addr = mdm->dev_addr + attr->offset;
 	int mode, err;
@@ -702,7 +702,7 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 			return ERR_PTR(-EINVAL);
 
 		mode = MLX5_MKC_ACCESS_MODE_MEMIC;
-		start_addr -= pci_resource_start(dev->pdev, 0);
+		start_addr -= pci_resource_start(mdev->pdev, 0);
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b2643ff871a36a190293af2f6c4571d243818670..edb6be79f3da5618f2b9e777784090051df0ce20 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -107,14 +107,14 @@ static u8 mlx5_imr_ksm_page_shift;
 static void populate_ksm(struct mlx5_ksm *pksm, size_t idx, size_t nentries,
 			struct mlx5_ib_mr *imr, int flags)
 {
-	struct mlx5_core_dev *dev = mr_to_mdev(imr)->mdev;
+	struct mlx5_core_dev *mdev = mr_to_mdev(imr)->mdev;
 	struct mlx5_ksm *end = pksm + nentries;
-	u64 step = MLX5_CAP_ODP(dev, mem_page_fault) ? mlx5_imr_mtt_size : 0;
-	__be32 key = MLX5_CAP_ODP(dev, mem_page_fault) ?
+	u64 step = MLX5_CAP_ODP(mdev, mem_page_fault) ? mlx5_imr_mtt_size : 0;
+	__be32 key = MLX5_CAP_ODP(mdev, mem_page_fault) ?
 			     cpu_to_be32(imr->null_mmkey.key) :
 			     mr_to_mdev(imr)->mkeys.null_mkey;
-	u64 va =
-		MLX5_CAP_ODP(dev, mem_page_fault) ? idx * mlx5_imr_mtt_size : 0;
+	u64 va = MLX5_CAP_ODP(mdev, mem_page_fault) ?
+			     idx * mlx5_imr_mtt_size : 0;
 
 	if (flags & MLX5_IB_UPD_XLT_ZAP) {
 		for (; pksm != end; pksm++, idx++, va += step) {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5891b0b2a84306c5afc802831b41bc723ddbcdb9..52e2aff0df470882e311754a3a06505f67cfbd58 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3513,7 +3513,7 @@ int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate)
 	return ib_to_mlx5_rate_map(rate);
 }
 
-static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
+static int modify_raw_packet_eth_prio(struct mlx5_core_dev *mdev,
 				      struct mlx5_ib_sq *sq, u8 sl,
 				      struct ib_pd *pd)
 {
@@ -3533,14 +3533,14 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, prio, ((sl & 0x7) << 1));
 
-	err = mlx5_core_modify_tis(dev, sq->tisn, in);
+	err = mlx5_core_modify_tis(mdev, sq->tisn, in);
 
 	kvfree(in);
 
 	return err;
 }
 
-static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
+static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *mdev,
 					 struct mlx5_ib_sq *sq, u8 tx_affinity,
 					 struct ib_pd *pd)
 {
@@ -3560,7 +3560,7 @@ static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, lag_tx_port_affinity, tx_affinity);
 
-	err = mlx5_core_modify_tis(dev, sq->tisn, in);
+	err = mlx5_core_modify_tis(mdev, sq->tisn, in);
 
 	kvfree(in);
 
@@ -3965,27 +3965,27 @@ static int qp_rl_prepare(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
-static void qp_rl_rollback(struct mlx5_core_dev *dev,
+static void qp_rl_rollback(struct mlx5_core_dev *mdev,
 			   struct mlx5_rate_limit_ctx *ctx)
 {
 	if (ctx->rl_desired_index)
-		mlx5_rl_remove_rate(dev, &ctx->rl_desired);
+		mlx5_rl_remove_rate(mdev, &ctx->rl_desired);
 }
 
-static void qp_rl_commit(struct mlx5_core_dev *dev,
+static void qp_rl_commit(struct mlx5_core_dev *mdev,
 			 struct mlx5_ib_qp *qp,
 			 struct mlx5_rate_limit_ctx *ctx,
 			 enum ib_qp_state new_state)
 {
 	if (ctx->rl_changed) {
 		if (ctx->rl_old.rate)
-			mlx5_rl_remove_rate(dev, &ctx->rl_old);
+			mlx5_rl_remove_rate(mdev, &ctx->rl_old);
 		qp->rl = ctx->rl_desired;
 	}
 
 	if (new_state == IB_QPS_RESET || new_state == IB_QPS_ERR) {
 		if (qp->rl.rate)
-			mlx5_rl_remove_rate(dev, &qp->rl);
+			mlx5_rl_remove_rate(mdev, &qp->rl);
 		memset(&qp->rl, 0, sizeof(qp->rl));
 		memset(&qp->rl_desired, 0, sizeof(qp->rl_desired));
 		return;
@@ -3995,7 +3995,7 @@ static void qp_rl_commit(struct mlx5_core_dev *dev,
 }
 
 static int modify_raw_packet_qp_sq(
-	struct mlx5_core_dev *dev, struct mlx5_ib_sq *sq, int new_state,
+	struct mlx5_core_dev *mdev, struct mlx5_ib_sq *sq, int new_state,
 	const struct mlx5_modify_raw_qp_param *raw_qp_param, struct ib_pd *pd)
 {
 	const struct mlx5_rate_limit_ctx *rl_ctx = &raw_qp_param->rl_ctx;
@@ -4028,12 +4028,12 @@ static int modify_raw_packet_qp_sq(
 		}
 	}
 
-	err = mlx5_core_modify_sq(dev, sq->base.mqp.qpn, in);
+	err = mlx5_core_modify_sq(mdev, sq->base.mqp.qpn, in);
 	if (err)
 		goto out;
 
 	if (new_state != MLX5_SQC_STATE_RDY) {
-		mlx5_rl_remove_rate(dev, &ibqp->rl);
+		mlx5_rl_remove_rate(mdev, &ibqp->rl);
 		memset(&ibqp->rl, 0, sizeof(ibqp->rl));
 		memset(&ibqp->rl_desired, 0, sizeof(ibqp->rl_desired));
 	}
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index ce2ef8828c09573b1e1edffabfe16d579f8cd195..a1b15c0346d34e9b969a2b60298b78930d8769d6 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -417,7 +417,7 @@ static int get_ece_from_mbox(void *out, u16 opcode)
 	return ece;
 }
 
-static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
+static int modify_qp_mbox_alloc(struct mlx5_core_dev *mdev, u16 opcode, int qpn,
 				u32 opt_param_mask, void *qpc,
 				struct mbox_info *mbox, u16 uid, u32 ece)
 {
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index 00a9bcb2603f0b094bcef8a4ffe6564699a85769..8a68b083b1b610215441438ab7bce189b97eba0f 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -12,10 +12,9 @@
 
 #define MAX_DUMP_SIZE 1024
 
-static int dump_rsc(struct mlx5_core_dev *dev, enum mlx5_sgmt_type type,
+static int dump_rsc(struct mlx5_core_dev *mdev, enum mlx5_sgmt_type type,
 		    int index, void *data, int *data_len)
 {
-	struct mlx5_core_dev *mdev = dev;
 	struct mlx5_rsc_dump_cmd *cmd;
 	struct mlx5_rsc_key key = {};
 	struct page *page;

-- 
2.49.0

