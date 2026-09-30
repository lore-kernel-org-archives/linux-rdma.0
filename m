Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010032.outbound.protection.outlook.com [52.101.85.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB44CCDF1;
	Wed, 30 Sep 2026 11:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768643; cv=fail; b=XWRLhrfnonqCamu/JXbdNip5F+324fszNqR/ug03I55GhGYuKBcSbQ7KBZmuOHGww8zEf4cUL6B9DJLBrXFZiCcHqH5JwOd8o2T4r1oqmo3F8ZYavC+38ehFjSb3isW4xwg7CHtR1y+a8uC5eer7J5Cy1vNw6yV05wbAdl1Q39U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768643; c=relaxed/simple;
	bh=4vS2z2hb/Rz/0qgQvVSaCkdoXrpFt7bN5opwVeQGiDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lk2y5a/9/QyxdwLgKI/cIv6GRRJ6rSJ3YmYuEdKzekJw7G4EAd2qUjuLLFxW7Wbt62NJVlAW5ao1LrAxP3BJw8eofob9K5UXHM/fZkTSxAr4S7MxJF353B5kExloOU7wIzEQ0dbqHRJNzRON9zI9XkLOwtc8ixzbXvos4oDK7xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rz8AFv3s; arc=fail smtp.client-ip=52.101.85.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rz8AFv3s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kNaMy1CIWIQNu+I7e1qeFUkArxOZCZC5IS2D//6cHPioYl+OQhbuRvo1A4ogi+UX+4dM4xTez174TXqcVhE5yQlfygL6xl8zxUvNBefBJbwwA0Qef3dj4Uy853rKW5G+VCoIHs1+77NbpK1H8wM56RmS9LMjxONwCBwm4fIIHsjFStelKaegOJcI/7zHx0mLpoFmp/sTMB9GP7l212d6UJxvUHZjfvtmgtTCrkUgz2PSEvs/DqkiqhDRSbUW0wN7PQoXSguEkYTIPY5a7qlRm9nfon7/W0u1EMPsJgL2Rle1j+MBX35q4kbdD1LC46w+M6K5UPyRfVObXaYy6mWpzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQ6nNbMtI6g8PpE9Ap+lajJ5yi1mGSz3xtFJO8BPZWc=;
 b=yDS1gRLhezpRtlYopf40mdlF7OeCjPQV3sAX2pldOQV/r7aS/KRdvCJduhqxNn5u5kghSSESOAMztFcNaBqxWW2fGvL0cam4bwLs14SXp/8xb5Tkcek4Vj3lYG9CMeDp7gQ4ewuA727SYgD/nL9dTXIQ8brA95TbF2SQanx6E2fIBHxOeHGySoyHi2YH7nwmWHs3xu2z9Lw6AZNAGnw1Nswp0HCQKkDRQ9LMxHHBMsnF4pE7HhAE4dm0Xg9LiUu86WsI4QSDNaotG0ppotVfqOzjnWVz1CMOaB+JyZgG8kJdt9ayhT9iCJvqrG+ooSw+bQ6FOVELPlhvY6PAg494bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ6nNbMtI6g8PpE9Ap+lajJ5yi1mGSz3xtFJO8BPZWc=;
 b=Rz8AFv3sB8nzwe9xWUAZsON7hEYzcCQThWEdCuTsyh1XDkfTsaE+A0myij7OXBf5T9QoWtTGFAuJd5H0StsBdPkRwUWLP/OFpQwi4JNMVJ46yCwn6ZsKlMNOwpdBja/yF8vDwPMAPTeWHsCbXBnfcoWf3hSZ5hBjJZZjYuLfSpMWZfbZKHtLSg6Sx7F/RlkhTpm5bkYq1yZ7k5ggxPGDmeqzW+jOp3S4byH8ActrJz+n6jnUvykBKCnNq78GrOaBXl2ZBeXeix1E/HMiF39z0RGT3XQFkYrlc+BfsU9Xslweo5ZwC/JueSkz0yRG/izoAzQ5ZC9Jinfu9E7ic8iQtg==
Received: from BLAPR03CA0019.namprd03.prod.outlook.com (2603:10b6:208:32b::24)
 by SJ5PPFF62310189.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 11:43:56 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:32b:cafe::57) by BLAPR03CA0019.outlook.office365.com
 (2603:10b6:208:32b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:43:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:43:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:39 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:38 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:34 -0700
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
Subject: [PATCH mlx5-next V2 03/10] RDMA/mlx5: Make the data direct VUID query self-contained
Date: Wed, 30 Sep 2026 14:42:20 +0300
Message-ID: <20260930114227.139274-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|SJ5PPFF62310189:EE_
X-MS-Office365-Filtering-Correlation-Id: 806551c3-cb04-4605-7fb0-08df1ee81bca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|7416014|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TPnAfUJBlX3/tNg1pd2SxkFDrhIerOTYff+XL8N9AUdLws9DHjhsHwy95jhLDWpgxldv1B3C8sxOpyK55z5LIJY6hTzRzgQslje9h813Qv4GOhlDRxUYGPzywioZbzIVg8vUCXyINrCI2NlXctU7rzjmSAp3yOqq+F6p4JVw6JBZMLmI6SAYCIxsNHBuN4lhUs0QrA+g0YATbMA6qCbrjm0GIdh/5dnca7D2grUtaH+3xtb62/CXmU8Uaz/27p05Bh14qlRp2wqGhve5MMZnfjeVXtO32ae8UuAXfC/DbRqaLbIy4OBFuNJTPa0q5wEvq6CfcqVF3BlSWsrb0Q9yY4vT55UOifrDH4k+rRBNuMr385cp+D7ZTFPMQ0VaGmXKr04uaoDnPpsl2v3O07zfgHBqRNMQ6/utpRUXdKLgnmw4TIFezFm26sH31soGTKj0sfsb8yycZGx7W+6mv1TGnjoSdocjynyeaVcTIokfl9SmQxfONVdSdYSGFI7l3jbnBJVHxYM0BXw4ZjYKNZLN3As6kOjAaHeNwLcaWOx68z9X4xmHtQsJ+aXoBOjEIpOy8TmaurE1qP+dlfpCPyolW8aqtlQM96A/MNttdculeAo8T6BXzHNF/YaAYxq15tK3v9cgQWPA+F4HgdFZMrqB1kmBdE1NHb0RpUItU9sFf1p1HqhkFuTgWncG8PbPaq93g1qupIMdjDfkxvHKDqNU8Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(7416014)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Qj0FrPVWvB6QiYwCxxPDE8WtKDWG/G1gVi7TjpokfUbR33WYBGebb5+50RafjTUm/d+YjE4eJDrb0r98/iKzN8lRfOQacSim7G5ICi8fmJ4AgllYtjCF3ZFvXD9AN4mV6H6OpOLkbB8uH0g+B8DfY1BWEvNK1XXA9TgX4niWcbik92EPnyiTQnE5mWeI+vJ8pHVbSGjy3F74wWOwqLv08sfMYSJMktXktl4rywDs5AE+qdbdmBMCXZf5KPPPeYLzDnSTAxgk2Ks4Sc4L+HZ3tK6cGcBJTqzp3RNN8LUw4w4Et1zCGUUPGTU4Q8B+NCxZ9i9hJommVv8y/oTDdlXFXsf9yoLzKwP5/ruoAelLQvlBQ/Z4+OW9pof+glk6W1F1GK+X6ckqyd07PGGPE7RZ2m3tbtR7StHscJhooe/7IjOAjNCh/6j1XBvcztHXhVVy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:43:55.5593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 806551c3-cb04-4605-7fb0-08df1ee81bca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF62310189

From: Dragos Tatulea <dtatulea@nvidia.com>

mlx5_cmd_query_vuid() in cmd.c is generic over the data_direct flag but
its only caller is the data direct init path, which always passes
data_direct=true.

Move it into data_direct.c as mlx5_data_direct_query_vuid(), dropping
the always-true parameter and hardcoding data_direct=1. This groups the
query with the rest of the data direct code so that it travels together
when the data direct matching code is relocated to mlx5_core, and lets
it become static there once the query is folded into the core bind path.

This function will become private in a subsequent patch.

No functional change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cmd.c         | 21 ---------------------
 drivers/infiniband/hw/mlx5/cmd.h         |  2 --
 drivers/infiniband/hw/mlx5/data_direct.c | 20 ++++++++++++++++++++
 drivers/infiniband/hw/mlx5/data_direct.h |  3 +++
 drivers/infiniband/hw/mlx5/main.c        |  3 ++-
 include/linux/mlx5/data_direct.h         | 13 +++++++++++++
 6 files changed, 38 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/mlx5/data_direct.h

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 7c08e3008927..895b62cc528d 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -245,24 +245,3 @@ int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *dev, u32 uarn, u16 uid)
 	MLX5_SET(dealloc_uar_in, in, uid, uid);
 	return mlx5_cmd_exec_in(dev, dealloc_uar, in);
 }
-
-int mlx5_cmd_query_vuid(struct mlx5_core_dev *dev, bool data_direct,
-			char *out_vuid)
-{
-	u8 out[MLX5_ST_SZ_BYTES(query_vuid_out) +
-		MLX5_ST_SZ_BYTES(array1024_auto)] = {};
-	u8 in[MLX5_ST_SZ_BYTES(query_vuid_in)] = {};
-	char *vuid;
-	int err;
-
-	MLX5_SET(query_vuid_in, in, opcode, MLX5_CMD_OPCODE_QUERY_VUID);
-	MLX5_SET(query_vuid_in, in, vhca_id, MLX5_CAP_GEN(dev, vhca_id));
-	MLX5_SET(query_vuid_in, in, data_direct, data_direct);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (err)
-		return err;
-
-	vuid = MLX5_ADDR_OF(query_vuid_out, out, vuid);
-	memcpy(out_vuid, vuid, MLX5_ST_SZ_BYTES(array1024_auto));
-	return 0;
-}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index e6c88b6ebd0d..e5cd31270443 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -58,6 +58,4 @@ int mlx5_cmd_mad_ifc(struct mlx5_ib_dev *dev, const void *inb, void *outb,
 		     u16 opmod, u8 port);
 int mlx5_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid);
 int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *dev, u32 uarn, u16 uid);
-int mlx5_cmd_query_vuid(struct mlx5_core_dev *dev, bool data_direct,
-			char *out_vuid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index 04affdbdcb12..8d006b611c63 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -24,6 +24,26 @@ struct mlx5_data_direct_registration {
 	struct blocking_notifier_head users;
 };
 
+int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid)
+{
+	u8 out[MLX5_ST_SZ_BYTES(query_vuid_out) +
+	       MLX5_ST_SZ_BYTES(array1024_auto)] = {};
+	u8 in[MLX5_ST_SZ_BYTES(query_vuid_in)] = {};
+	char *vuid;
+	int err;
+
+	MLX5_SET(query_vuid_in, in, opcode, MLX5_CMD_OPCODE_QUERY_VUID);
+	MLX5_SET(query_vuid_in, in, vhca_id, MLX5_CAP_GEN(dev, vhca_id));
+	MLX5_SET(query_vuid_in, in, data_direct, 1);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	vuid = MLX5_ADDR_OF(query_vuid_out, out, vuid);
+	memcpy(out_vuid, vuid, MLX5_ST_SZ_BYTES(array1024_auto));
+	return 0;
+}
+
 static const struct pci_device_id mlx5_data_direct_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x2100) }, /* ConnectX-8 Data Direct */
 	{ 0, }
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index a9bb471949e2..fa3a145c06c6 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -7,7 +7,9 @@
 #define _MLX5_IB_DATA_DIRECT_H
 
 #include <linux/notifier.h>
+#include <linux/mlx5/data_direct.h>
 
+struct mlx5_core_dev;
 struct mlx5_ib_dev;
 
 enum mlx5_data_direct_event {
@@ -21,6 +23,7 @@ struct mlx5_data_direct_dev {
 	struct list_head list;
 };
 
+int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
 int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
 			    struct notifier_block *nb);
 void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0c57cb39ae7e..8d6914de1442 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -25,6 +25,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/eswitch.h>
+#include <linux/mlx5/data_direct.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/lag.h>
 #include <linux/list.h>
@@ -4039,7 +4040,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
-	ret = mlx5_cmd_query_vuid(dev->mdev, true, vuid);
+	ret = mlx5_data_direct_query_vuid(dev->mdev, vuid);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mlx5/data_direct.h b/include/linux/mlx5/data_direct.h
new file mode 100644
index 000000000000..4556e58c6d03
--- /dev/null
+++ b/include/linux/mlx5/data_direct.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef _MLX5_DATA_DIRECT_H
+#define _MLX5_DATA_DIRECT_H
+
+struct mlx5_core_dev;
+
+int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
+
+#endif
-- 
2.44.0

