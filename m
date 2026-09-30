Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DF4C226F;
	Wed, 30 Sep 2026 11:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768664; cv=fail; b=Cj7NlOYo9xczvjLirJ3U0zA02Q4dWscV5GAIc97Y8zb5vilC+OLQfw2S6rtZVB5RhI+upY84hKItLfBsLyadruclO5kk/ec285JcMFuYP6PNl2qqk0Wh9QLRyS+V83Y+u6k6kiFuu2USvvjm4UWT5xG6tWK7NW5T3g5O6vCBinE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768664; c=relaxed/simple;
	bh=iobE+xXctZz1x36xYgHg+bAsYvmewib/tESJzu4e5Pk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c5I7dXW5qjN76T9Tbfqz93j9MuUUp/ctJ1K2tMam/V9D7qINTZENmUUXd6X2bDjdw/NUUuecEe0VVA2AEQ4ZDTvRcGi7W0aEWpNmjyFAUZpe3xBViL4yk9JIfTqT4DfNpA1U4MKi4r42Nz5LmSW4XdiMA3EwjuhbzUWbBavmI+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pb0cpVCp; arc=fail smtp.client-ip=40.107.200.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pb0cpVCp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kDw2Ywq/GOMn8mDwYn61EFSUkNQ1aIEsiWILK0qFMvSv4hqRLblAQt73G+fusaAKwJaoUKzTan2Eu7r+QyfEq5DfyUx/xL5Lr0NUCnw1Fgf2ozPwwPuoSUTZnWeB/Er1zOqVSeoUEaYoZnEbCt5gBHZg0RdSQ0brNEuHEUoTVHdG3YRaXdULmo1i8pEBA0OAKXSCuUHLeFrxLYoPJWFHBlm+c+0OJy24KiaT5bI6XLhmauSwQMgbfL+XGt9WT/tzMv1EROmVBdUdP8oIOYkXd7EUq7Hd6Cx1xlQB4kVdSNxJs4hEGl4seKUD+2ToL2D9JbKBDuEz9amnoMWGR7xRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wsWXcaOz14c4fM39zri9koK17nGC9ab7/cL0rMSi/U=;
 b=IuIEIvmpLQMTXQzSxAE93cqEXBLEFwPg45HZhHePh6ICD3xiVkRDPGzAC5hBEpqTsRnitRUmw47C5bdrOuRc8jKc2mG6Bnn5Fnxbpe5UMxtmXIZ1w/VitNoQJgg2yDSDmFz72xjfml/sIHckYwUQ3hnXeK1QoUM24xGOq+9TZPX8tbWlX4CjZ5w0lFQ18O20cGJZQPKLyDcsSYvpIvq2PgkgA3BQrXjRgHTy5mrUJd88mn36fn5peX8NYKZFWNmDg+xWbNH2Jz3sOabWQTtI9Oo73zYfHdJfjMY0x9sal2QCJtMBaqTD/iGjgTeMgToNDPGNogtd9agLJSsEqUpXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wsWXcaOz14c4fM39zri9koK17nGC9ab7/cL0rMSi/U=;
 b=Pb0cpVCpSl5CIKojg+1DMwMR5iWxBrdSGbCTo6CUBLxZ9w7APrBO1soxb0eL2kQMrKyaSH7fKEXnMj3BYjTZk5pumQKc9aDFVPE96I0kL+SrAFSMu5T/8aoxYN6EBmf8zFjLds7syB+8/scNrhzk5jP52RbS9z5vB2aHWNoD3knKPtvvdX0AggzD4WXVdCeoTBexBqEOHNkZF0retOuNXJLcpZUTGfyNfmpoVvDXli+Z9WdjMmtzdNikmqxj2WueYE7Zqz5136SJ6miJWoia55S9Fo9LWh0ZTfro30GHXNkQtxrn+TI0qH3p2dNqrNmt5bpzp48smHSB6MiQS0S0+w==
Received: from BLAPR03CA0118.namprd03.prod.outlook.com (2603:10b6:208:32a::33)
 by SJ0PR12MB5675.namprd12.prod.outlook.com (2603:10b6:a03:42d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:44:16 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:208:32a:cafe::6d) by BLAPR03CA0118.outlook.office365.com
 (2603:10b6:208:32a::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:44:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:58 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:53 -0700
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
Subject: [PATCH mlx5-next V2 07/10] RDMA/mlx5: Extract IB specific lock out of data direct
Date: Wed, 30 Sep 2026 14:42:24 +0300
Message-ID: <20260930114227.139274-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|SJ0PR12MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: 285894b4-72e6-4cd6-3c9a-08df1ee827c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|36860700016|82310400026|11063799006|10067099003|260925022911599003|260925021911599003|260925021311599003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d5WLENNr8a9qEWiID7gVEh2iP1oghz4w5GpqihmhKRLnIG+30ZbI1g1LL8r+EPm45CGm6AeCQzdsxB7B7/loEeOryPU683kLzWfO7QPCB+LxFSoli6c568Y6g3JWEb8L8NuSDYR3I05XZwDHEqU/bnjjwqiveqpvEfrgMfwvn2dcNAGmxwG5WWbIcuhjBYTQbWqVFGgCYTBrpaa18B/hn2XHc+fOLOvEmKdhvbVoZgx19fdElr/sls+FZ6hRJQYBDXV4cv7fMCtdUDUh4lEhD17mMUej0xvM54Up75RExtU8YeBw+G76D+l6t38btIfoIT7qFls4XLq51azsuK94NT1K2eDAeqYOxbtrVGdJsdo0n3azYqU4sweThrmVCF0tK5Gk5/9ZG4MbeH+3TlmSrowX154bQwcfzQMYvWVs8up1BDZM7R8IYFpKLNe3sbY12kAAQEvpciyPjFZXlvUZcTlARmhysYtfYIuSD1dnuNCoJLSNlqetjVRvKqKyWrvNm1ij3vo0cCDcHUREDd+LHEoT94l/YOQKklil9O+DJ6naqEpOgKMBasAtLslbAQ8q9Xz15l+3AcpLqXGHigCsFduZC0Z6ipPrP40EEinZZ9AkXvAjral8o2k5iPLK6nXUtlQa2+QcomgJZHtXrtnrPoMZMS8gFGnMNT2EP1BzjLkK7UWq3a4XymFsNvxr2edzqnFAkUVIy8YRC/oHDMmX2w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(11063799006)(10067099003)(260925022911599003)(260925021911599003)(260925021311599003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	liEcHy5nqC/aE1Dt/OTZ5IUhONTXcyQ58uoeIuO1HLvKX4PZDMkuXxcMWUJzS0FH4wuWLjtLMYE5v4geln2BLg1aduj5eUCS4Lwy0hY5XXjQCOrlzJkYnDRcnW4PI/tcYhXRRVDnq2XEX8GdM7j7H/NlDmwW60oCRxK9ORpENr8EThIjglAJPqk4DheKicCXCWxbfztdirFkobB6KdyeGnwq6mHqvFKVHBHGxGV6l2Qm1LvjcrJiQkbaM6onqE6tkpftt6V9rzLYgJ++vkxbjqxMsNz8uEQUyNkr6xzCUuVuFFCh66G1EWIWxJaaIFgLX5LH7g4jY07CCdoW5AdYZ2oIQVtaTFQ37pFT2CBVcj/iFJju1AaMIN0KZkR1LRwK3b3fp34PUz2toimqPv9v+rvCP0jAD7trmaUU+jWOGctckLUX5a92bOfM50ul9qO6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:15.6424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 285894b4-72e6-4cd6-3c9a-08df1ee827c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5675

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
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
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

