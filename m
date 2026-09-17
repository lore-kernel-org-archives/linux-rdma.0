Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19934418F2;
	Thu, 17 Sep 2026 11:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643765; cv=fail; b=cobj2leUD9UtOtAvtCir8BFANZ8JNRkxoKxQsHFQ6Q8krTJfltr71IWNbSd3aS71j4Ory1gM86o6AAzPQrQABKN8URRxMo9QqRNbi9cjXvOvebHexbBRd0eq4Y5iW2deXrZmVM7d/4WM+BVkLk/GARGoecvE9nIUfrj7ddB8QjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643765; c=relaxed/simple;
	bh=vE8b0gflIteHMiOJYR9b99bhFmMhUO0c2AkEq7qB1yw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qj0IZfsyABBdzi5lr+CKmD3jX6FTQ3B7j2tDRu1jD7fM5ZbSrFwyiXU1+YujZtuYEgGylz+W0bEIeKEFLfruaVYUZkM0uPuY3Fn6KLPgt4NXbgE7az6X5y/rp4eNv+MY5ELQQ1aueVgHUs6UA804BcCfQUmF3rPJOlfmF8GDsW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n7blwyJG; arc=fail smtp.client-ip=52.101.48.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n7blwyJG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJD+ZlsnUpePjQadivOLvgJIt7MWljLt2wLH+q6kdqOaj8BVE40x71nHZGYV69n5AypjER31VeSgfyWVgSw6CM/amFytSfgVNpkPOb0ZNjZywlNU43pnvLNBv/F/9ByTJxLaQdQQM4NlVb3ARpYYL3dkOTDICfSj2ZMTdQEWHTymY7Gj2V812pbrAKk+KVfdCsPGqPFcPPkftAnipkZjv5pwmbfShF8jwAlHZeZQHJY1FJqdRkqsqsr9a0+1nT2eENQ1JR4pOypUThPyBYXTF+uwOCWAQNshXJGQgawtN4L+GT8zqzSyGf4h5E0ZAmee7Wy1FqLtUgemWdbhse+XOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+TsQdTtFdNXoKksNuGIi+20zSAnlM8VgT7Z1KOy2kI=;
 b=FurwNd7zjRjgzBnEQaLE0wBY+tnw4QjhhES9ghe72VDUV8LI8ikQOcj7kDrWlvkGSJ2wOW8yWYxxN1C7rdqoXZW98aHuV5KRLkcyRWU5xdGUXQllV3TjHwjWuOc6zexE9Rg2DBJg0pslgGItFCvUcWql0PJgZmO65FFqMa6euyB4OTPKUSDVOUmpceynp10naafqb+l+XkWiBe/WdLShgIXwURlBNnDE2VQ1Mnklffk184Kck6BlDppCiyrO7wQ8zbHYCwRWfJlfYNyJvJbYgT27L3Ih9lVZ5JLHPDLoy+gHI3Qslajp2wWesGZ04IoFLX1qt7KoNbsmjC2UJD5DfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+TsQdTtFdNXoKksNuGIi+20zSAnlM8VgT7Z1KOy2kI=;
 b=n7blwyJGjAfwzkn/1yI1JpheAlMjr9vKqxJe0eRcKgNYIkZoUmgQKQWJt/7UYTYOFCkosQzoBRxAPRgIjYkQr/3z4FBHULykM0KoGBxLnwUy7QDOrPx1TUL0dW0gNcarzcVg3a5ZScgatsW4PQufEFxyhhhsFSQ5lrgRR1PziQkn3TXn8rvIN3AxVr7FpaTTMoSbr6FrkZNt1ixjQWNhFI/swbNyxybnjxNpH3OYYTDA46EaHQLJEWIrrr+5OdKfhgnzGyh0HrVx8Rx0NcMtY0TIAdekwU3TAFhJX44vlLD7DwFC6xB+r6U+sNkAscXSpzqmAtD7DM1b4KocQsDzxA==
Received: from CH0PR03CA0233.namprd03.prod.outlook.com (2603:10b6:610:e7::28)
 by MW4PR12MB6756.namprd12.prod.outlook.com (2603:10b6:303:1e9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 11:15:43 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::90) by CH0PR03CA0233.outlook.office365.com
 (2603:10b6:610:e7::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 17 Sep 2026 11:15:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:27 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH mlx5-next 07/10] RDMA/mlx5: Extract IB specific lock out of data direct
Date: Thu, 17 Sep 2026 14:14:19 +0300
Message-ID: <20260917111422.4054862-8-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917111422.4054862-1-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|MW4PR12MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3ce762-f429-4da3-e074-08df14ad0310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|1800799024|82310400026|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YpsVaCtlmMH+HfcLNsYaKAClM6pJCLfiDreb06pl1U5MuL4ASKhOGx6E/52g3yyQLw9TgUCrlaWmv5pwbCNyrqqtwOjXrDzj3lj9AU7JVDLEXcpAfmQFSkpxPcx0TIJfxvvkpc499M/x+1VCJRtYT8jqGDZ9sIOtDHfyYbLHc6BQvHoKWmwU7szFw7YPRKKaPHxhzam9KFxhnCMptEPmntbvIK8MTKKyBpNq2mRk453h33ahaQWtwyKARbyBTEOgj07yCcEjRCQbRLsTUHmWJCtLhwK7fABZgz9KtQRgY/Sbb5EKBAJTRMeoxrV4YSPM6Clms01nA8s74394UZF0ZM2hqGBR8SPmn42hbRshzbkWJ4NEaMpC4SmE28Gf369bxDJXI6/SbvXNH6VYCH39XHXMvC/pLExEHCA2kbLMXQYBR9CKfIfpv54LJ9ZHiFs0UsNOC9/vd1OeajfofplqKQbb2pKrKFWaiXY+xBUEbrN8kUk+z1fHelBvgj0FEoy5b3nf1Td0nxZP2VtxJ4GOnjq278fkO4SWZ882/I2odN/XsMSD4JT8QJ9Wq946MlB/yMZi4GtFer6+uC8qBSYT2+QsJ0Eru/GPvmUWqc60JI75ZAL+ZIeIRslfHkqEYhd+ll/wTZ13kKD0jgV1WCcv0was0ZpHuIny02G1ruzfz2pxUEoDMWfP8TuhvpNM1MkHKsGR6ncXWJqhTDKsrOnohA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(1800799024)(82310400026)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ItU5OBjy0YKcnB3pwNdSBCyZj7bIyyRo1Dp5pq6qDn4C0c1lhlU7gc5+qicBi2TQDjagkVKdk9FrT3mbmqdct/nwDL7QaJbw2aBeAW583wl5BrWMr3z3tM6nRvxXmgQMDoEdGtLzBiaYXW+znMmKdnjEEtSKV2GvTi2NqtbBpCIJqUDHd0o26caEudOHPOz9FXEiFk2O93ib4bjGjwKgGpucP37oM3nrLRV+4t6koSWTdwNwkUDx50o4r1YpUYurRB/8RkyLAnj8Hn9hqTz59GK6gLdRpdBR3xCBvzO/oXzLPJ9LhgLiEb808k26ymfTOse4+B8NnXcsGHlTDm5YCuY9E7uzbloM7eB9EDaj4p5PDxYVkhVDkydZlkdXSEwUkRv2+q0kygY8tNOUW+pf51gnIttRsICfrLD1ceGASpClEr0SaVgFIOCJSvfiDcZB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:42.1824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3ce762-f429-4da3-e074-08df14ad0310
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6756

From: Dragos Tatulea <dtatulea@nvidia.com>

The data_direct_lock from struct mlx5_ib_dev is an IB specific lock.
It protects from unbind while mlx5_data_direct_dev is being accessed.

So move data_direct_lock out of the generic bind/unbind functions
and into the IB specific notifier callback.

data_direct_dev can be set during bind/unbind with a simple WRITE_ONCE,
the lock is no longer needed.

Each user of the data direct registration API has to do their own
locking if necessary.

During unbind, the data_direct_dev is set to NULL before calling the
notifiers to avoid multiple users still accessing the data_direct_dev
while unbind is in progress. This is to avoid another data
direct specific lock which can lead to lock ordering issues.

This patch has no functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 8 ++------
 drivers/infiniband/hw/mlx5/main.c        | 2 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h     | 4 +++-
 drivers/infiniband/hw/mlx5/mr.c          | 2 +-
 drivers/infiniband/hw/mlx5/std_types.c   | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index f871e3ce9f73..16afacdd3601 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -197,9 +197,7 @@ mlx5_data_direct_get_reg(struct mlx5_ib_dev *ibdev)
 static void mlx5_data_direct_bind(struct mlx5_ib_dev *ibdev,
 				  struct mlx5_data_direct_dev *dev)
 {
-	mutex_lock(&ibdev->data_direct_lock);
-	ibdev->data_direct_dev = dev;
-	mutex_unlock(&ibdev->data_direct_lock);
+	WRITE_ONCE(ibdev->data_direct_dev, dev);
 }
 
 static void
@@ -207,11 +205,9 @@ mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
 {
 	struct mlx5_ib_dev *ibdev = reg->ibdev;
 
-	mutex_lock(&ibdev->data_direct_lock);
+	WRITE_ONCE(ibdev->data_direct_dev, NULL);
 	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
 				     NULL);
-	ibdev->data_direct_dev = NULL;
-	mutex_unlock(&ibdev->data_direct_lock);
 }
 
 int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d0141509870a..cefbcc816651 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3948,7 +3948,9 @@ static int mlx5_ib_data_direct_event(struct notifier_block *nb,
 	if (action != MLX5_DATA_DIRECT_UNBIND)
 		return NOTIFY_DONE;
 
+	mutex_lock(&dev->data_direct_lock);
 	mlx5_ib_revoke_data_direct_mrs(dev);
+	mutex_unlock(&dev->data_direct_lock);
 
 	return NOTIFY_OK;
 }
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e56f3eee7ba1..8792e10340c5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1092,7 +1092,9 @@ struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
 	struct mlx5_data_direct_dev	*data_direct_dev;
-	/* protect accessing data_direct_dev */
+	/* Protects data_direct_mr_list and serializes mr
+	 * registration/deregistration with data direct device unbind.
+	 */
 	struct mutex			data_direct_lock;
 	struct notifier_block		mdev_events;
 	struct notifier_block		sys_error_events;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index e6b74955d95d..1fc61a680f8a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -997,7 +997,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&dev->data_direct_lock);
-	data_direct_dev = dev->data_direct_dev;
+	data_direct_dev = READ_ONCE(dev->data_direct_dev);
 	if (!data_direct_dev) {
 		ret = -EINVAL;
 		goto end;
diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index 1ee31611b4b3..df949fa634c9 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -203,7 +203,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 		return PTR_ERR(c);
 	dev = to_mdev(c->ibucontext.device);
 	mutex_lock(&dev->data_direct_lock);
-	data_direct_dev = dev->data_direct_dev;
+	data_direct_dev = READ_ONCE(dev->data_direct_dev);
 	if (!data_direct_dev) {
 		ret = -ENODEV;
 		goto end;
-- 
2.44.0

