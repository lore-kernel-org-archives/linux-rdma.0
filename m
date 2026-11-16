Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825086;
	b=e/3Ath3JMrxRty6OwWhRtvDeDVZUG2CSlU3y2VJb83wpeQZjIlOyJrFjL38S5wDslWjM
	 V38EOrfgJE2A8UDq2SJZGSr5f5HHWEQeIg0iDafFRpy4ODVK7S17YNJpD5xUIqQrv8rNx
	 MDDKkHMfQniOAg06a5O9RRTzA2RRYVOIgnagqpbUBsAG2IPqqOHxBmV+QDFdK6Xe8G78Q
	 iMf3o0M9uOUCuC2PLB9sh0SC3SKYtdmsM754mrWmgryv1A8i9vKoolK8j95vtYkjWq32s
	 L5fI/bZ5iToJ4+8YTuc0Q6tJD5UhLWAJcZUZfuu2PeiYumARgfjWKSJ2SKyFFuGY1Xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825086;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=LtWb/gLPYE/tQRrbDKNzlKCjsstPygKhmjwunP9ykGQ=;
	b=hHheP4yhCKrsesYfCbMrOZgGOFsLkjCBdH7jMNNH+RtOFAQsdLqD3yfZpkdN8TlMNT+m
	 EhUKDkHvXtqyX5zvy6YFW5zY0gurbdvdNbCRkJJ4Scyxr1L8LLww8WhOv027NmaskJWdE
	 EfMQZUYvirlkxv79TJav7uxWDVlBG8TRrzYEUZ4aqjrqcqrue8iQ3VeWUtX4fjnQr5Fv2
	 jwUEA/iOCXLiJZRGxTaupSuGMc/tYv3alEIX+BgYRTWJylrsFbdEpouDsUcL8V8ysAZGz
	 i3pxtJE8cYtE3pFXYf1XhFvf6ciK/95vIrFL7j0YHrqOqsrnv8G6t2WQ4LIA6h1wAAA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eyhxhQbR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.40
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012040.outbound.protection.outlook.com [52.101.48.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2916C606A329;
	Mon, 16 Nov 2026 10:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2916C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eyhxhQbR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vokV+0ebxIp5lbIvVVV9pgGgj5UlzMWaOSbFtH8JH3HYPvBvqng83UGhh8MxSHyT5s+y0p4RZh8q/gMvRpLPHnV2RLybuXjzzQnWcsRjuQZ1Xnz3Tp9uMNFWLNaJ7lxzeY0T94IPddSxKglmc2ry18E3uYmlmXPe46l4xrPODYM/KUqD6NEfSxgDSm1cM6seFhTb5UOJ7JQNSISNvGoSsMPLNUkiYstZ5+z0J7RoQ5S11MQ+bvfLjXne6IFk7hqY/An1GN0vzsnPqR2jsYqKSGKW7tJ9kISyyxSPlB0wcrHgyo7HMgpEl2komB009ukw8ZF87G1hZs7fs1E0fZgk+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtWb/gLPYE/tQRrbDKNzlKCjsstPygKhmjwunP9ykGQ=;
 b=h7OHEiip5usa1Ckmkhg2w91QHvi3R9K6VuwsayON1immnSgAV4S3yI+qepoToRzSg4SHmQy3Ht8hB9DanKUvJDOr+FlhxOEEnY8sgZdjJIOeCKPMlwItpwDenPSd/+Yas7REnRPFfmnSD8iNcqeCSWz6QNeC2qDvmP6vituyXvbSBOXcYi1eiufLQwyKeTqYiyseOodGnJ6lci3+vcWCFEF7a9HJDmwEjCvy9Mb44GyEpd3bgVQotfNnkexbif7jdMOopByH6x1tGnTREMWaoS8Pr0pKBcMaFXzIfa1i2P0nU81ubQQYo3SpvxYweWgCPzcy8FUVQM87kJyYhiiAAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtWb/gLPYE/tQRrbDKNzlKCjsstPygKhmjwunP9ykGQ=;
 b=eyhxhQbRlLbKTlaMaXb0VvoZqJLcaWvmqZcKtKo4SW9moAiDnxjScRDkpc36ctpHENgAuDySzm9Skyvvce3WIGpAswgVX205iQnJfL5fK9kV2B+robIIvunI673hfYBfMjsks3ZY8wKKuTlcIPh+hZ9Fu6uawZne3kDXgeJaY42TbD9ikkqd6Nf3MDSsav0HCJmzgQI/vu4FZY4UFeMpk2qZ0MHKeYI9JQFRZhZYHfJ6D/yFV8BDuICZ7Gnn/8R2D7nmuqUnNVmIYBEWMxOJ1pB3E/+j8c7kZDrtpeE693RlMTAYoaj1GH5dCz5oOISGGLIqYc1sNcjKIKgVNHOjcQ==
Received: from PH7P221CA0028.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::16)
 by SJ2PR12MB8652.namprd12.prod.outlook.com (2603:10b6:a03:53a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 10:31:19 +0000
Received: from CY8PEPF0000005B.namprd21.prod.outlook.com
 (2603:10b6:510:32a:cafe::b) by PH7P221CA0028.outlook.office365.com
 (2603:10b6:510:32a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:31:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF0000005B.mail.protection.outlook.com (10.167.247.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:31:04 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 02:31:03 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:30:58 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 04/10] net/mlx5: LAG, treat virt LAG as a software managed LAG
Date: Mon, 16 Nov 2026 12:30:04 +0200
Message-ID: <20261116103010.1129666-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005B:EE_|SJ2PR12MB8652:EE_
X-MS-Office365-Filtering-Correlation-Id: 1811c766-9e1c-4856-cdc8-08df43ccbfff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|11063799006|56012099006|261021121427099003|261021123027099003|261102123227099003|10067099003|261009223027099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	clVvZTG020HhY+DuNROOq9H1T1S2MDfh2T/4MxEOdr47vddmdhjgie+H1DT+U4Rc03IDDR0r0QXlvgkR10NGa8lhagm1NfAs3nZYHh6cy788gpTevjUOA6LO9Ldg+vVOIEfCkheqLNPR/7Z0FiTa/Wd2YAaiUQYMUANpVyW8O53oeXAxGiRqMBXuVIQG4dStioY7ZjKQhWIdcJfAoGp5Jk7mt2cGevBmzd3WPg9W4c9kmLgaMSmsOQ7STo+GydayojG51W11hq77cE2tJP/xC3cWzRynagb0D73Eg+ZK1dp27YWAR9K7ZEWT6ZEdr0kREfgGWtV15RVs12PmpEIeOhRColkQw+M1EJlf9qfr3g8RSZGVCTSB1AHm5qyRlkVHcP5IzibTifMFyva3f7DinqxaF+h7J9ayrL9tkJTaRI6MVoOYAE4/Iad+hLDGMhMPRtbx55H6Gbc2MEJrpVbHF3jlLaby3owgYqwl/F5+aXkrhaaRxbCpHMpmcX/7k8SERrkOp6rIAqEpukhTyWnBM4GoJ/kHBaqjm2PKgXz4Cho7UJmDoTzn51xBlTqyqiFW0yOQTkFETVJ8qMeBkYneiZsIvYQWZ/cvMPQt6L+vDiUqEpXyY7cHD8BFhcMmYJUWcL2g7rdoItGnLP51e9H2Bds9RXLzQj7bmM2+X1UMWNBADvO4Y8nIA29/qjRp5cJ8qoBevMxB8Gai3Fa/aT4tmw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261102123227099003)(10067099003)(261009223027099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kCgx1sVbI77yyC19M+KktQEqJO78nrj9tW4z4HUND1cFqZXWb4zeSxXVvtZde/tP2i2p+E9XP7VhSR8U6wF4y+Z7qiDXyPnChDipfymQuJ1lZQUZB+Uev3nbCU5dPXwxmrmqy81VveAaXNFjBD+Su1UwbaK8V2jc387WnopopidEVSt+orGVfWuU4G5O9Keg6sSH1DVhaYNVanbRTe2SSSN1A7sskIjIkbeOI7auCtGRD+d2cNJmvpLqjCrRi0rnTAyy3tmIOqmqNwWSGl6eUVcwdl8vjNrWABxCr0Rb7Bmy+ZjWgPWy7w56zGdb7zDrA0Qc4tifGkVbS3jYsYjmuqqjKGitP2Iu2lpEm567O6G/E3A3QKbm87sG7SbDnCGg0jZcDf2um4Zkjw5wsaX1HyxXE+HkPPnc2bh9JomyOgeJ/9kLakYn839ra0EYp+Uu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:18.2242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1811c766-9e1c-4856-cdc8-08df43ccbfff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8652

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_is_sw_managed() (renamed from mlx5_lag_is_sw_lag()) marks the
LAG paths the driver builds in software - the LAG demux and vport-LAG -
which must skip the FW vport-LAG commands. A virt LAG is
software-managed like an SD LAG.

In the same manner, block multipath LAG over virt LAG as well.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c  |  4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c7ece82fd457..669b2167a82d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -173,9 +173,11 @@ static u32 mlx5_lag_dev_group_id(struct mlx5_core_dev *dev)
 	return 0;
 }
 
-static int mlx5_lag_is_sw_lag(struct mlx5_core_dev *dev)
+bool mlx5_lag_is_sw_managed(struct mlx5_core_dev *dev)
 {
-	return mlx5_lag_is_sd(dev);
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
+
+	return mlx5_lag_is_sd(dev) || (ldev && ldev->virt_lag);
 }
 
 int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev)
@@ -184,7 +186,7 @@ int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 	int ret;
 
-	if (mlx5_lag_is_sw_lag(dev)) {
+	if (mlx5_lag_is_sw_managed(dev)) {
 		if (!ldev)
 			return -ENODEV;
 
@@ -206,7 +208,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 	u32 in[MLX5_ST_SZ_DW(destroy_vport_lag_in)] = {};
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 
-	if (mlx5_lag_is_sw_lag(dev)) {
+	if (mlx5_lag_is_sw_managed(dev)) {
 		if (!ldev)
 			return 0;
 
@@ -1911,7 +1913,7 @@ int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 
 	xa_init(&pf->lag_demux_rules);
 
-	if (mlx5_lag_is_sw_lag(dev))
+	if (mlx5_lag_is_sw_managed(dev))
 		return mlx5_lag_demux_ft_fg_init(dev, ft_attr, pf);
 
 	return mlx5_lag_demux_fw_init(dev, ft_attr, pf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 21c83f51fcb5..94e07870e506 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -229,6 +229,7 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev);
 void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev);
 void mlx5_lag_clear_master(struct mlx5_lag *ldev);
 bool mlx5_lag_is_sd(struct mlx5_core_dev *dev);
+bool mlx5_lag_is_sw_managed(struct mlx5_core_dev *dev);
 int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 			struct mlx5_flow_table_attr *ft_attr);
 void mlx5_lag_demux_cleanup(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 65c76bd748c6..2077fc5d80c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -26,8 +26,8 @@ static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 	if (__mlx5_lag_is_active(ldev) && !__mlx5_lag_is_multipath(ldev))
 		return false;
 
-	if (__mlx5_lag_is_sd(ldev, mlx5_lag_pf(ldev, idx0)->dev) ||
-	    __mlx5_lag_is_sd(ldev, mlx5_lag_pf(ldev, idx1)->dev))
+	if (mlx5_lag_is_sw_managed(mlx5_lag_pf(ldev, idx0)->dev) ||
+	    mlx5_lag_is_sw_managed(mlx5_lag_pf(ldev, idx1)->dev))
 		return false;
 
 	if (ldev->ports > MLX5_LAG_MULTIPATH_OFFLOADS_SUPPORTED_PORTS)
-- 
2.44.0

