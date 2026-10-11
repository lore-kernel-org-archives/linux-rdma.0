Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011042.outbound.protection.outlook.com [52.101.52.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BD41C75F9;
	Sun, 11 Oct 2026 09:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791712251; cv=fail; b=STFdAjXn2GG8yQO2AXwqf9VVWE+vMa9pCLSUCMIrBfrQMQ9IaQ3Z7emLN9vn3+e9QKBFvyHZ6egRWGHLCpCqb0gbFbgX5hNmKoaZo2x+FNgMZV6sNaG1ULwwgkO9zl3pafQQpBasSnH55utz7mKYAvWVAtrVRl4MCqe2wOPXFhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791712251; c=relaxed/simple;
	bh=+yLsR8gNgtrDYpllKxbPnsCNxcrsK7h5ySoPGYhaHcA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cS4hSgbbBzM1TQ9F6H9O3SViLQ40436+eW8bpG0xhJtAg0aPBFZI0DISDWNmWqC6VgKoSNxBrCValwlXtbFiVAcu4Qnf94/td+RJSyQrBJo5Dkswr+HmsHvoCqWLyiBNwzi/B36gECS0BZd9GVwEaUBgrxoWpZW4tuV1XyZDdYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VYpVSLoP; arc=fail smtp.client-ip=52.101.52.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VYpVSLoP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zWhWUTtKfEF1pKPH4T6RIlBB04FKLhPE/sIV8zMWDpThOAO6eJ5dfcW7MYkEDZEIu80lA2fksl6Q3ctkoyupfiUHRT7Oj3/NVj1r8ihu+e6juJJeXKu75W41O/mw3NyRMf3UkBUQZG/qCvNBzeL5k7ABrP6vDLhzRuJ96fJu2XLyHJErIZvnrISNEoz+WTq4Xxw3hl7rOsjSFiLzmhDMgdR+pNOk8Cjps9pBpydxCvpjgUOCVbk3PF4GaEeZAZoXw+gErM75gZV6TzS5lLvcsqCvUDXk6TqdhoIv3MpY4jfoQrWSfAnhU+1XH+v3TpFGRLOdGFxKZjRHoXFAcg9lDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k37Uq8XDeWKf51FKF2gBHvApBCm0az6tV5pSeaDNnCE=;
 b=tgZa5S54KC26qylmCczaOGiZj47H3O4T591JmvkPqOkKKMGwDbz4sPGWDdv6JMSsRu4+hIBLL6JRSYf5f2toTkPiYZPHpfShDKxDKapUgdGWLVRu6kUVaxZbwBm0SUdPtOUUUJc9w/vdrxFoVwzmPBMNu/mnMIqwEDyz820NijOt6J2GbTEDNzDsP/8Lwhqr1uAfQqGqxzVmPlXA4ZQG6+oTDU54RsNw6kPOz8QXme50UzNi0bShvXFKAoyVBzXiGr4sNbCLE5JZ76zu0DyYr4tPMpyt0btyWbrVNJ7yG+yjUceqklHMSbZZsBfbMispMOYPBS+C16Lrn68r7hMZoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k37Uq8XDeWKf51FKF2gBHvApBCm0az6tV5pSeaDNnCE=;
 b=VYpVSLoPmzXWm6SUkee80asav+wvSweskpWT+cVeJekxnnbG8h51l4NY4U4gIWxdp9UTPw1wRC0gle4N7HudD/9OuJGRvSr4YENXXBfaZO5eb1+MrDf7kX16149Ag4YCGO1EeVnDcNaqlQ/Vw7elNb3soSarFBNhev+qd3JMNVLUvSZNjyYMGQqnbCSwImWS6oc3bK/RWNAR8qDaAhGNzqjwaN4TS8PNj/cB4wDy55qNW4hYc34UhxxRANZspoD8HF7MXaowsk7HNChSS4XHGdp3KOaWxJCBa0FYa79CP1dKYH/MyI+ucshcZwrIg9K2jf8ingrH+jCx6rNcHcC4Ww==
Received: from BN9PR03CA0696.namprd03.prod.outlook.com (2603:10b6:408:ef::11)
 by SA1PR12MB999228.namprd12.prod.outlook.com (2603:10b6:806:4db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.18; Sun, 11 Oct
 2026 09:48:46 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2603:10b6:408:ef:cafe::7) by BN9PR03CA0696.outlook.office365.com
 (2603:10b6:408:ef::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Sun,
 11 Oct 2026 09:48:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 09:48:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 02:48:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 02:48:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 11
 Oct 2026 02:48:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Add reset_prepare and reset_done callbacks
Date: Sun, 11 Oct 2026 12:48:09 +0300
Message-ID: <20261011094809.790798-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|SA1PR12MB999228:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4a0b56-8a62-4f7d-ba8d-08df277cd819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|1800799024|23010399003|6133799003|18002099003|10067099003|3023799007|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	v79RVnbeIrgGi43kj5H4mS9gz+KBCu8jOXbmVL7s/5wa2guFuK5eulCNw6FAIJdnQmKHce/H2BmgCuQ6oJf/kQ/x4H8P2DAp5UEm7/4z1omDxHC8U2ZUZifV3b4slFk6fG3m2cYAfPirc2EJhf7nTFsjI2eZLISwJ/oK91xXof+6BtFrbHpipVrNI8t10wCil5kXitbyaoYsD02/IAbzG53Tvn9XH/vaC6FnwWT9TYFnG0VcZ4tC3HsNhMx0bHCBQN6SOxD94uipwuY00knpuZiTu0HTYvSVwWCr2RC7cJrLSITOfRzXh7lNx/iFObsxEy8p3oxhd3O5efOpSbiKSs8rgR6aX2CZUFZTqPQDLkVFURrz1Mtin8FBUkOO0qxLfBue2Agw2aSAIxZkkTiU3ilfclU+v4Ew1xTPE3TAgnVTCINJuiJsxzMGxCT9CB+m8lMOnlMLOd+ePYP/6yzRJlBf+cx6aYWJb2Rk2pPdS2RRDxn5tZpkZxKJFoJPhvhOMKjhm3CrnqInudJlTYy+ZAWQT3i+7hRM3b55tEfYDGHRQUDgcZEIWUejFbwbWPI3M/5gBSr5ohw6RG6fhGEJBriGIzMxFbruG3J7CK/bxDaPJDVh4LGj3hwN28WpyPGMOKti1PM6jBzfr9mbQK1kfv2LSL4fluhN9DbQvqvlNShp05NUTneQxTnjjcoUkdh2B7el/MZ6u+ucEUe7jB0iyA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(1800799024)(23010399003)(6133799003)(18002099003)(10067099003)(3023799007)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dq0Cy+wej+unj14oCBaAbzTpMdvk/9jCOzPxQM0+9SUcrVWtPS4MvkMfdKCJCS1HzzrN/KfS2GaOElgCUeVvo5sjQgWXs6Fmt+BVBeY+Vcr2hmF5yBGvx3ugXb0JScBvJKrj7TtorOY2qJj9O2kAN9BQed5C9oCR6GDy5BqhjfHnKHaIijEXz8Wu7thAl2vGbVjkxONlsKHbNMMtinX98DET4J073ax/JlZEXt8ND8q0jo45mEqRDDodkPKEjtMv2V7/bKvfBk4pyS+XTAicIX7vBNUBWE/0BpCYHZpW5Jv53WdQMEoXscKtslpHGKbJMOgGHHha1kqEJwdEw195ASJkJclVvYoZSLj2eN5ax8LZWrvuHKHuEFtU4zDUPrgIiVygP0jmd5TAdoL6YX7MrwnWkFCC2AUlVlnsaXdnXkMxBBUtIO/odpOkQwZagyYf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 09:48:46.3032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4a0b56-8a62-4f7d-ba8d-08df277cd819
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999228

From: Akiva Goldberger <agoldberger@nvidia.com>

Currently, the mlx5_core driver registers only the error_detected,
slot_reset and resume PCI error handlers. Add the reset_prepare and
reset_done callbacks, which are triggered by the PCI core before and
after a PCI reset, respectively. These callbacks let mlx5 quiesce and
restore device resources and commands around a PCI reset, so the driver
no longer relies on the reset happening while the device is otherwise
idle.

Additionally, add a device flag to indicate when a PCI reset is in
progress to serialize PCI reset flows with other reset flows, namely FW
reset. This flag also indicates to the reset_prepare and reset_done
callbacks when to do a full unload/reload of the driver. When the
callbacks are triggered by the hot-reset FW reset method, they leave the
teardown and reload to the FW reset.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  7 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 89 ++++++++++++++++++-
 include/linux/mlx5/driver.h                   |  1 +
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 7c0585fe1ee7..2ba2f6dac263 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -501,6 +501,13 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 		return;
 	}
 
+	if (dev->pci_reset_in_progress) {
+		err = mlx5_fw_reset_set_reset_sync_nack(dev);
+		mlx5_core_warn(dev, "PCI reset in progress, Sync FW Update Reset Nack %s",
+			       err ? "Failed" : "Sent");
+		goto unlock;
+	}
+
 	if (mlx5_sync_reset_set_reset_requested(dev))
 		goto unlock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a45474ce03d..fe7c0331b183 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2138,10 +2138,97 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 		       !err ? "recovered" : "Failed");
 }
 
+static void mlx5_pci_reset_prepare(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+	struct devlink *devlink;
+	bool fw_reset_in_prog;
+
+	if (!dev)
+		return;
+
+	devlink = priv_to_devlink(dev);
+
+	devl_lock(devlink);
+	fw_reset_in_prog = mlx5_fw_reset_in_progress(dev);
+	if (!fw_reset_in_prog)
+		dev->pci_reset_in_progress = true;
+	devl_unlock(devlink);
+
+	if (fw_reset_in_prog) {
+		mlx5_core_info(dev,
+			       "%s: fw reset in progress, leaving drain to fw_reset flow\n",
+			       __func__);
+		return;
+	}
+
+	mlx5_core_info(dev, "%s: resetting, device state = %d, pci_status = %d, intf_state = 0x%lx\n",
+		       __func__, dev->state, dev->pci_status, dev->intf_state);
+
+	mlx5_enter_error_state(dev, true);
+	mlx5_drain_health_wq(dev);
+	mlx5_unload_one(dev, false);
+	mlx5_pci_disable_device(dev);
+}
+
+static void mlx5_pci_reset_done(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+	struct devlink *devlink;
+	int err;
+
+	if (!dev)
+		return;
+
+	devlink = priv_to_devlink(dev);
+
+	if (!dev->pci_reset_in_progress) {
+		mlx5_core_info(dev,
+			       "%s: reset owned by fw_reset flow, leaving reload to it\n",
+			       __func__);
+		return;
+	}
+
+	err = mlx5_pci_enable_device(dev);
+	if (err) {
+		mlx5_core_err(dev, "%s: mlx5_pci_enable_device failed, err = %d\n",
+			      __func__, err);
+		goto clear_pci_reset_flag;
+	}
+
+	pci_set_master(pdev);
+	err = wait_vital(pdev);
+	if (err) {
+		mlx5_core_err(dev, "%s: wait_vital failed, err = %d\n",
+			      __func__, err);
+		goto disable;
+	}
+
+	err = mlx5_load_one(dev, true);
+	if (err) {
+		mlx5_core_err(dev, "%s: mlx5_load_one failed, err = %d\n",
+			      __func__, err);
+		goto disable;
+	}
+
+	mlx5_core_info(dev, "%s: reset done, device state = %d, pci_status = %d\n",
+		       __func__, dev->state, dev->pci_status);
+	goto clear_pci_reset_flag;
+
+disable:
+	mlx5_pci_disable_device(dev);
+clear_pci_reset_flag:
+	devl_lock(devlink);
+	dev->pci_reset_in_progress = false;
+	devl_unlock(devlink);
+}
+
 static const struct pci_error_handlers mlx5_err_handler = {
 	.error_detected = mlx5_pci_err_detected,
 	.slot_reset	= mlx5_pci_slot_reset,
-	.resume		= mlx5_pci_resume
+	.resume		= mlx5_pci_resume,
+	.reset_prepare	= mlx5_pci_reset_prepare,
+	.reset_done	= mlx5_pci_reset_done,
 };
 
 static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..7b9f3cd23e0b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -746,6 +746,7 @@ struct mlx5_core_dev {
 	/* sync pci state */
 	struct mutex		pci_status_mutex;
 	enum mlx5_pci_status	pci_status;
+	bool			pci_reset_in_progress;
 	u8			rev_id;
 	char			board_id[MLX5_BOARD_ID_LEN];
 	struct mlx5_cmd		cmd;

base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.44.0

