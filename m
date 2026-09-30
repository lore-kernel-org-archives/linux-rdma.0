Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA99364EA4;
	Wed, 30 Sep 2026 11:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768662; cv=fail; b=mMxAsExzZREVF/b7lZrbcwVddSH3cO+4emmRAK5E4sR9oUf1TEgfzaKF0amDa/XYh59/SPLtu/+s8hMnht+KB+sDqJqve0NXS7l58lA3Zt3KnMHl99C4DT7AYbQEvXk+veJWf22EyRbAOLzcU8iD+wvxqCbZp+e9rw8aRexYBVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768662; c=relaxed/simple;
	bh=4aqZJIlfBJFTuQcncxhh++aNQKgJEI3PlEE9xoVXUJo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gK8GdGJH04T5++wouLA2lXadkGACkETryrO53GqpEoelP3AnDHg6J2UadWycgOo5RzzeArv2+GhNk8WhOPWDBeKvSptYlEu434/50fOz/F0LI8DjE3H7PUBymnpYyN6APgewa78l2hRF70YJKTghCGzyRE76tQP6jZkRbL6DCGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JT3ipgQK; arc=fail smtp.client-ip=40.93.196.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JT3ipgQK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=swOWkObQS3gonY0eTGTvN5Y14lmgUbv88RJQVFY66D5EIFbEHXwqMPrRBaPHXMCMw418AwmaKHFmfM6hTw3CDBQ3xyYSE0Jir/epni02LonYTg7wlYeBgDGEHe1jVHigXVeefZ9lI5Ux00mySJdZZDVOgT/nwUR9C+tANmM/o4ZjCKidpeex1EdeB07h7o+flipdm6xAdH0NhMWmuhG+5qpAb484v8nAsullyOHjskka2tuGOcNJLz33qglNCag/wtTrMlk0H3z6n8MsGAJ4P2s3Lvr9a3xvxIijqRR2R1qA6DPHhDgvNleHY93lYOFb4+j7AhVHcoRD5bS2gmUFgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUDzhOK/m/tJL9esPgGFcgNIFurlVdnxvwQxFrdlrHY=;
 b=uE7H/ytHFDcjiMrlybP31y4t7R5xX4TE7YYqJdvB4vyOiAXdvfq4F2Upd+9j2FWduOuUU21EBDsINs4N16VsW+WcGyXRcKlndN0YkKrV6f/ejdienZbN14Z6oFoRN5/v7+R5FIAyzwvw47Ov5norA7foMRddCfkbwqo0/hs75/YP+pqd5fMbG4rez/Y2HUn0G/8tXX3rl0I/ilHDwnIWWeTKWvzxwrRURgNx5w0CoKwKiVC7rbrPb1Jgtp3FHx4C9W6pCLAosy60Egdr9S2OQu3oTjE2XUJwgNsb2mZTqIGGcsKVRAnUsdgBaDnDBdyXUS5wkBT8b4VQXGSqLMQQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUDzhOK/m/tJL9esPgGFcgNIFurlVdnxvwQxFrdlrHY=;
 b=JT3ipgQKwgmSesiNw6Yt0zeBusMZMbYoekiAY6Jh+dRsBnRobTD9c+QKs5JBO5LLlCFgARQgQtJV/jiPsdDsr45TTW+M3KhTdj2whh20hRF3BioNofq0VzdADZPbd7wEUo0TBEajHxULr4DT7EmAnzPYfCk0WkQHt6C44Zro5AotZbWL6tukD14XvwRpXmM0WGFt9MTJKv2eG/oW3jLotDEB7dO9dbG5959S1n+0tcwm/gc3cC3DKti/6vN5iEnEgUcQ2IPD/9nrKNIpKXxvisDzO0Wd55Z1VWsJaaCqFRzTOrF2obiM+JbdNXltze61pPysgOfQERpZHEjKUt9HHA==
Received: from BLAPR03CA0119.namprd03.prod.outlook.com (2603:10b6:208:32a::34)
 by CY5PR12MB6405.namprd12.prod.outlook.com (2603:10b6:930:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:44:11 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:208:32a:cafe::9e) by BLAPR03CA0119.outlook.office365.com
 (2603:10b6:208:32a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 11:44:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:53 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:48 -0700
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
Subject: [PATCH mlx5-next V2 06/10] RDMA/mlx5: Add new registration stage for data direct users
Date: Wed, 30 Sep 2026 14:42:23 +0300
Message-ID: <20260930114227.139274-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930114227.139274-1-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|CY5PR12MB6405:EE_
X-MS-Office365-Filtering-Correlation-Id: da772cb4-1227-44ad-337b-08df1ee82523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|7416014|376014|82310400026|10067099003|56012099006|260925022911599003|260925021311599003|260925021911599003|6133799003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2ZtiG3pJc95y0l6ToC9wkv6Koh+42Iep+1cXI6uOqoHga1AU7dsncb6fjfA3BxaKn9kpDh3abtSnckdUcDoOrvqn/FwhnlZdzkU6Gclj9T17sM4RQjfcAptL4ZApvO5XsOkXgftGE6njqsxTleP77kQINRbYHW5+MWjiR2uShvFTRLq1ND8kIAIVCGoIrkUIHzXCCYK3R0i93oJRQxZf73bjycLa+WZIlxQP2mAgirzAowWZS9oQeir1dpn13mG8WcWVuJZkQy15M67xc9zW2up95291UrgrfO6+lRUrwblzuiOEKZf5Fk3qiJ5HdnwEI7r7RZRNSWtXtsoPEKK0KVbNG1qog8aTyQWNdQDNHvT1nYV6avgArM5A00Ube30CHLZm8jsTBy6f268aFbCEnGSv8nsoaiEayNywJO6t+ylaorW7kvxNYCgnwbM709HytwHE6h2stXwh8S6DnLMu4V6Wrq5AvbcF9+/N+l5kDTFkPQqY5Cx6EO2StzaKvdnSiVyX1OWwf1CdtO42CPZ6AEyRdw/Kti3c7ZuVQ7rB7ipfULs40kBR7VH+B19p/LVhT8GTOg9GIs5dC1txexbtsFUx0Cmd/5elUsH2BLoR5gOS2hFKiNTccJfDFhQqw2rR3eFbO3Xq2YkuTj3m6yRHkOTzjKR61nGaFtGarpCg5c1tEnKfA0qTb4JwQyvQGKHlPJv8OmR55ePN0FwU9lWa/Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(7416014)(376014)(82310400026)(10067099003)(56012099006)(260925022911599003)(260925021311599003)(260925021911599003)(6133799003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xQNuvPhsNF1oszG0Urs/KkomvjAla8YvpMMfTcsRrWqF35mesqsJWwR321HaXEOqmMv55TMyp0g0k/zsolfFG8PPOD8SkFQz6x2a8HfwBZKA+7c60CJIwVh5f8ufrzf2sNeomhrjx4tzLFoQ1G2E9I+HAN6GkRa9SwFahwc37y2cgKxt8saIIkDw+TM7n+8L+pfGhMV3mPMhebczxxPlcUgbJ3QKCw/6ofmly0w2Q06qF+d3nbEyjlsZYeiSTREEOG8PbXDSWmxteyuxcCp1o5kY3KTZOUwzJ3lOi/ayyoZEfrMsohsQGHsdSWhyAAf2NcpUHm1AHEH4G1Xbfvn7i0AX77TbiaqxXtiIYtU1+3MImLkiC3hUBnIQkmLzpvvLR5Adq5WpjzygUB6kQCop6X8w+IfbSeJEFc/UtglVmLsGdr8q9lG9qyHJfNm3MOju
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:11.2412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da772cb4-1227-44ad-337b-08df1ee82523
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6405

From: Dragos Tatulea <dtatulea@nvidia.com>

For the upcoming move of data direct to mlx5_core driver,
the API needs to be split into init and register stages.
That's because only the core will do the init phase but
both IB and netdev devices will need to register.

While data direct still lives in mlx5_ib, do all steps in
mlx5_ib_data_direct_init().

While at it, make mlx5_data_direct_query_vuid() private
as it is no longer needed.

This patch has no functional changes. It is a preparation
for moving data direct infrastructure to mlx5_core. For
this reason the new functions are added to the new header.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 114 ++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/data_direct.h |   5 -
 drivers/infiniband/hw/mlx5/main.c        |  41 ++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |   3 -
 include/linux/mlx5/data_direct.h         |  10 +-
 5 files changed, 118 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index cc3f741b4f81..f871e3ce9f73 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -24,7 +24,8 @@ struct mlx5_data_direct_registration {
 	struct blocking_notifier_head users;
 };
 
-int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid)
+static int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev,
+				       char *out_vuid)
 {
 	u8 out[MLX5_ST_SZ_BYTES(query_vuid_out) +
 	       MLX5_ST_SZ_BYTES(array1024_auto)] = {};
@@ -182,25 +183,65 @@ void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
 	memset(&dev->ddr, 0, sizeof(dev->ddr));
 }
 
-int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
-			    struct notifier_block *nb)
+static struct mlx5_data_direct_registration *
+mlx5_data_direct_get_reg(struct mlx5_ib_dev *ibdev)
+{
+	struct mlx5_data_direct_registration *reg;
+
+	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list)
+		if (reg->ibdev == ibdev)
+			return reg;
+	return NULL;
+}
+
+static void mlx5_data_direct_bind(struct mlx5_ib_dev *ibdev,
+				  struct mlx5_data_direct_dev *dev)
+{
+	mutex_lock(&ibdev->data_direct_lock);
+	ibdev->data_direct_dev = dev;
+	mutex_unlock(&ibdev->data_direct_lock);
+}
+
+static void
+mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
+{
+	struct mlx5_ib_dev *ibdev = reg->ibdev;
+
+	mutex_lock(&ibdev->data_direct_lock);
+	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
+				     NULL);
+	ibdev->data_direct_dev = NULL;
+	mutex_unlock(&ibdev->data_direct_lock);
+}
+
+int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 {
 	struct mlx5_data_direct_registration *reg;
 	struct mlx5_data_direct_dev *dev;
+	int err;
+
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return 0;
 
 	reg = kzalloc_obj(*reg);
 	if (!reg)
 		return -ENOMEM;
 
 	reg->ibdev = ibdev;
-	strscpy(reg->vuid, vuid);
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
-	blocking_notifier_chain_register(&reg->users, nb);
+
+	err = mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
+	if (err) {
+		mlx5_ib_warn(ibdev, "Failed to query VUID, disabling data direct, err=%d\n",
+			     err);
+		kfree(reg);
+		return err;
+	}
 
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(dev, &mlx5_data_direct_dev_list, list) {
-		if (strcmp(dev->vuid, vuid) == 0) {
-			mlx5_ib_data_direct_bind(ibdev, dev);
+		if (strcmp(dev->vuid, reg->vuid) == 0) {
+			mlx5_data_direct_bind(ibdev, dev);
 			break;
 		}
 	}
@@ -213,25 +254,56 @@ int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
 	return 0;
 }
 
-void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
-			       struct notifier_block *nb)
+void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev)
 {
 	struct mlx5_data_direct_registration *reg;
 
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return;
+
 	mutex_lock(&mlx5_data_direct_mutex);
-	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
-		if (reg->ibdev == ibdev) {
-			blocking_notifier_chain_unregister(&reg->users, nb);
-			list_del(&reg->list);
-			kfree(reg);
-			goto end;
-		}
+	reg = mlx5_data_direct_get_reg(ibdev);
+	if (reg) {
+		list_del(&reg->list);
+		mlx5_data_direct_do_unbind(reg);
 	}
+	mutex_unlock(&mlx5_data_direct_mutex);
 
-	WARN_ON(true);
-end:
+	kfree(reg);
+}
+
+int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
+			      struct notifier_block *nb)
+{
+	struct mlx5_data_direct_registration *reg;
+
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return 0;
+
+	mutex_lock(&mlx5_data_direct_mutex);
+	reg = mlx5_data_direct_get_reg(ibdev);
+	if (reg)
+		blocking_notifier_chain_register(&reg->users, nb);
+	mutex_unlock(&mlx5_data_direct_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_data_direct_register);
+
+void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
+				 struct notifier_block *nb)
+{
+	struct mlx5_data_direct_registration *reg;
+
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return;
+
+	mutex_lock(&mlx5_data_direct_mutex);
+	reg = mlx5_data_direct_get_reg(ibdev);
+	if (reg)
+		blocking_notifier_chain_unregister(&reg->users, nb);
 	mutex_unlock(&mlx5_data_direct_mutex);
 }
+EXPORT_SYMBOL_GPL(mlx5_data_direct_unregister);
 
 static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
 {
@@ -240,7 +312,7 @@ static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0)
-			mlx5_ib_data_direct_bind(reg->ibdev, dev);
+			mlx5_data_direct_bind(reg->ibdev, dev);
 	}
 
 	/* Add the data direct device to the global list, further IB devices may
@@ -259,9 +331,7 @@ static void mlx5_data_direct_dev_unreg(struct mlx5_data_direct_dev *dev)
 	list_del(&dev->list);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0)
-			blocking_notifier_call_chain(&reg->users,
-						     MLX5_DATA_DIRECT_UNBIND,
-						     NULL);
+			mlx5_data_direct_do_unbind(reg);
 	}
 	mutex_unlock(&mlx5_data_direct_mutex);
 }
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index 90e0565d7333..f207239461bf 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -33,11 +33,6 @@ struct mlx5_data_direct_resources {
 int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev);
 void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev);
 
-int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
-int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
-			    struct notifier_block *nb);
-void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
-			       struct notifier_block *nb);
 int mlx5_data_direct_driver_register(void);
 void mlx5_data_direct_driver_unregister(void);
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0bece3e55109..d0141509870a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3945,33 +3945,41 @@ static int mlx5_ib_data_direct_event(struct notifier_block *nb,
 	struct mlx5_ib_dev *dev =
 		container_of(nb, struct mlx5_ib_dev, data_direct_nb);
 
-	if (action == MLX5_DATA_DIRECT_UNBIND)
-		mlx5_ib_data_direct_unbind(dev);
+	if (action != MLX5_DATA_DIRECT_UNBIND)
+		return NOTIFY_DONE;
+
+	mlx5_ib_revoke_data_direct_mrs(dev);
 
 	return NOTIFY_OK;
 }
 
 static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 {
-	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1] = {};
 	int ret;
 
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
-	ret = mlx5_data_direct_query_vuid(dev->mdev, vuid);
+	ret = mlx5_data_direct_init(dev);
 	if (ret)
 		return ret;
 
 	ret = mlx5_data_direct_create_resources(dev);
 	if (ret)
-		return ret;
+		goto err_resources;
 
 	INIT_LIST_HEAD(&dev->data_direct_mr_list);
 	dev->data_direct_nb.notifier_call = mlx5_ib_data_direct_event;
-	ret = mlx5_data_direct_ib_reg(dev, vuid, &dev->data_direct_nb);
+	ret = mlx5_data_direct_register(dev, &dev->data_direct_nb);
 	if (ret)
-		mlx5_data_direct_free_resources(dev);
+		goto err_register;
+
+	return ret;
+
+err_register:
+	mlx5_data_direct_free_resources(dev);
+err_resources:
+	mlx5_data_direct_cleanup(dev);
 
 	return ret;
 }
@@ -3981,8 +3989,9 @@ static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return;
 
-	mlx5_data_direct_ib_unreg(dev, &dev->data_direct_nb);
+	mlx5_data_direct_unregister(dev, &dev->data_direct_nb);
 	mlx5_data_direct_free_resources(dev);
+	mlx5_data_direct_cleanup(dev);
 }
 
 static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
@@ -5008,22 +5017,6 @@ static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
 		cancel_work_sync(&devr->ports[port].pkey_change_work);
 }
 
-void mlx5_ib_data_direct_bind(struct mlx5_ib_dev *ibdev,
-			      struct mlx5_data_direct_dev *dev)
-{
-	mutex_lock(&ibdev->data_direct_lock);
-	ibdev->data_direct_dev = dev;
-	mutex_unlock(&ibdev->data_direct_lock);
-}
-
-void mlx5_ib_data_direct_unbind(struct mlx5_ib_dev *ibdev)
-{
-	mutex_lock(&ibdev->data_direct_lock);
-	mlx5_ib_revoke_data_direct_mrs(ibdev);
-	ibdev->data_direct_dev = NULL;
-	mutex_unlock(&ibdev->data_direct_lock);
-}
-
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index ff026985e293..e56f3eee7ba1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1396,9 +1396,6 @@ int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 				struct ib_dm_mr_attr *attr,
 				struct uverbs_attr_bundle *attrs);
-void mlx5_ib_data_direct_bind(struct mlx5_ib_dev *ibdev,
-			      struct mlx5_data_direct_dev *dev);
-void mlx5_ib_data_direct_unbind(struct mlx5_ib_dev *ibdev);
 void mlx5_ib_revoke_data_direct_mrs(struct mlx5_ib_dev *dev);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
diff --git a/include/linux/mlx5/data_direct.h b/include/linux/mlx5/data_direct.h
index 4556e58c6d03..71f47547aebb 100644
--- a/include/linux/mlx5/data_direct.h
+++ b/include/linux/mlx5/data_direct.h
@@ -7,7 +7,15 @@
 #define _MLX5_DATA_DIRECT_H
 
 struct mlx5_core_dev;
+struct mlx5_ib_dev;
+struct notifier_block;
 
-int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
+int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev);
+void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev);
+
+int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
+			      struct notifier_block *nb);
+void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
+				 struct notifier_block *nb);
 
 #endif
-- 
2.44.0

