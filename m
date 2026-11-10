Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335979;
	b=L0KjxrSpGBbB31AT+wKBK2U6JSUtxNxnhKRCYU7OE6SdRNUodnRcfDD4O8CD/igogjjk
	 ZljlDr1joWpMXPafiS0dANAj9EE+2j0qhkL8rkLi5JSAkfDrKTLY5hcpXpVPPpUyQcCCj
	 7hJXuM+Oeb9SqQ6xLGXCh89Lm5ikVKHlcgjqiCxfpuMrn/ccLR4cnGjkksIx3aG3pscVo
	 G+MXJ9aL29J26kT4T2FJDQ+ZM1Xs0tfg6LSshwYY4VWFr532ymarMlLD/NsAOPTITiRM7
	 9B0NjA+SeIzlOwd4XeeGOxHoINXP89BgLmn+gKF+G5YcTLPTv900+wT443MKeGzPrUw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335979;
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
	bh=eTiu2+HHY1gP6CI6frT7mplFdcP8fgAdYeKlWtotjwQ=;
	b=V7Eeyb/zuEXVPpfN+QaDNGEKdB4y4Rfkfwqr47i3tqjRYay9Szac7Oe/jOBVsWPY32AI
	 onUXyPNrFgk067toPw5jQb1spScpOBff2zufVXDsaiPKOLbjBV8uUHCGzeiBuzjxhLqqB
	 64kZwx5dg0vy8SVj3Z1srHm35waP/ldryhnTnS0TWeU6j3UTqKOcOqN1DxEL1U+q1u5CS
	 abha7EmCTM0mAijZD3oD7YL/jFYAEPJBkpR06UG9X7FgHQxyo4cGFBBocfHw1/te9aOWh
	 6kZWMQNOMxNpoPGatam8UYG3Qk32O2JIlXlx6NDUBeSFtT1cUbxj2pgukGue44cS+GQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CJORKnQj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.58
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90148606A32E;
	Tue, 10 Nov 2026 18:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90148606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CJORKnQj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ail+oppXFHkGolYDQnwVVq+LwBFHX7QmuMO416QtDKNzP+D6MMzni40QnaZcmRo3kfIox6gwE5qvtqzmTXp159tSOK2OVQ4Ospgq3zfLYmELur3FmL6NmP6792MMy4Vdus+0d7U7h84+tZkbOYiGhYk99RAsV0Evv8N71dWiIOPWMX9c1vgOX6oD0o+bZsHFVsFCzRdBERIBh02KRG6L/wrVDtH50eLbR7l1IxytGV58uHr50YbqggYmj1UOkL1JQGtjjoDhFKeqhq3L3f6U/4UkAcjIlQHueSrYNnXUgEBspWoid9J1nTSChjaTz4G2+T5neQV2XrqlF+fXKcZClA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTiu2+HHY1gP6CI6frT7mplFdcP8fgAdYeKlWtotjwQ=;
 b=mcVQklqPcZ+qRiC3PUlDPlcwsyK5teEO6JTpCiMsfMj/Z2cis2wxqL6v/uufEp+SrtS7lcNmHvYT5CF9Dgm3JX9QA0ifMsTyYm9uLt+bw7S0nUa+GEDmAtT4VR8cnNdljdGSHk1/H+T1rA2dI+hafBtrMLx6zwxWlmqyJb0zeoy75f0oF7C01Z4k4nZEu/+9ISj+KgXH1lyRkHwwr2eDrjUdeI7384EIma1lzHWw3HcCUBmdSL4sk02f9GplLbHh3aPOBaGxlynWHEYsN0I7mLwMtpHUiUYUy/nnMaccapx4KDhJtRdxb7GPl6NucjmIOtycr6W6G3J1IF7FIy9A6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTiu2+HHY1gP6CI6frT7mplFdcP8fgAdYeKlWtotjwQ=;
 b=CJORKnQjFG9V2vVB76WWOC6qlxQwc9u4WSa/LY3B2o6aT8Tpz3PY+JPAOQbPuJcN/cDbXLKA/1Tny5xqbaq+g4h+4pHvqsIM2Nq2sOjkVnvtV5yS//ZCL2YKCpC59hiVdmKAS170XnQQv87HqfzaB+cYiZyhGcg2e3O96f4Qr2Wf/5g3GSr3KhwUCWBW/o52ZkPQPGdWKdyFi1WL60Y9CukeOPMoBMOrIKNTxcyiQ0YALoYz/Au5EVXQd9ssIjd4w9w3gPd5T+8KxfSlhElZeqDesysicDNaBv31MW3EgKfyL2AzYy1gomMcNs8ixIAtZ+VQgREQtKewHyYnfBnZzw==
Received: from CY8PR22CA0019.namprd22.prod.outlook.com (2603:10b6:930:45::26)
 by LV0PR12MB768130.namprd12.prod.outlook.com (2603:10b6:408:3df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:39:33 +0000
Received: from PH2PEPF00048919.namprd05.prod.outlook.com
 (2603:10b6:930:45:cafe::95) by CY8PR22CA0019.outlook.office365.com
 (2603:10b6:930:45::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048919.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:11 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:10 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:03 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 03/13] net/mlx5e: Register supported netdevs as data direct users
Date: Tue, 10 Nov 2026 20:38:16 +0200
Message-ID: <20261110183826.2927274-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048919:EE_|LV0PR12MB768130:EE_
X-MS-Office365-Filtering-Correlation-Id: 55982143-8186-4f41-ff02-08df3f59f648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|23010399003|1800799024|22082099003|18002099003|11063799006|56012099006|261102123227099003|261009223027099003|261021121427099003|261021135927099003|261022075727099003|10067099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	4UI2CW1Dj3ol9o2kOVnhE9iAWMlnDaAtX8hA4W3j2UGF0Io0hcCX6wfOKdxTUrJ/OmFxQb4CT/H/2E6KWQNW9vcEUkOOjPh80pcg+Z9a7eamyLq/eCKB7TwM8UNR56ercGnBTLsA5ynpjnaBscvOaXu5iTom2BJmpQ8oiDvcFpqyVGYkjkE0Vo8MRpHiaxxzNbk8PON9ff39DPDWkzG215Qu7MNm5YB5qREFggEuajr6Q7Y+Hsn9KkwL5fV4y95Lhu/al2dJBET1dXVKA5+sL/ZBVF//sXy2dPKTdzBfnVd/TvIcwCvlxQ3nstxjniDhF5wyx3xLWhFZMI3vVeVcJ7MWdu0i9KP/2p2tmdR8NiToFp6h9ZOSOoItnoIJdb1WMskevJFqX/UV4FZGiK/pzKnsjvXndub7DXMU5mJycqCnUk69Lr/okxzx/49WmM75u6GGJM9UnW++p3YfNcH3JJ4Ahuhi1/YHlQoOARg4d2LLBIc0b8v3WVrg4rEWQajECI8UrEiAmkvFvXALn39cO1B4q1ypV2ttA+37en0vaVE8zRQ5jG3M8b3jvl+VMYHLPE79YvL+6RCkKspEdGp0xDDLLy8jKcJPD/LCjxnqlO21V/XpteMeAbUo3nsqYIpQg0qIndr+ERcpWTnUDpKYkfOJ4MEMcNQ1DT7p+eCtYbNqynhZ6rdyaAdym0UP4Rhu6qO3/hMVGkn0Cu2WpAh7iw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006)(261102123227099003)(261009223027099003)(261021121427099003)(261021135927099003)(261022075727099003)(10067099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xG2PkeZMsMCDRM8RVoIBsTUeSIHBsVwx6Tk+RcRTqms8l2cjPgP/Y6G3AqO9XlQA2gGBa+HYeYPa1TMgxENziSGkoUNrXzKS0K8vATBTLpPK6tO1yOwxQQoksjVCkOsrZ5rJ4qsCPy3AVLNqCCYRBM8tcvvPRP3S9z4tutGSIEPyny7Ta0fChaCo6rYlWxs8iOozSQFuHWEO3u5wf+QOYIHcpPKhaq4Rh6G4QgGqZI8iV3OS/u6avc5c/yGsIu618ds4sZV+bwThjI63koCIjmkgJELtcNsFN9Nr/9J3GyAeQ1sbg8Nt127L3xSfKvNJZDeQsXM0kQ38rwNK8visYGOlmZmRq6hLZkF/BoV4ewQoqDnMaoM87dayYPKYy9JNhm0jGF4ykHkw/K6QxPH2OLpDI1NM6PSlDQa9aw5fipa4V/MnVNZXY/j+pH8hdoFO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:32.5948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55982143-8186-4f41-ff02-08df3f59f648
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048919.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB768130

From: Dragos Tatulea <dtatulea@nvidia.com>

Register the netdev as a data direct user so it is notified when the
affiliated data direct device is unbound.

Register during NIC enable and unregister during disable so suspend
and resume follow the data direct registration lifetime in mlx5_core.

The notifier callback only traces the unbind event for now; tearing down
the data direct datapath is wired up together with that datapath in
later patches.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..78cf6aedd04d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -984,6 +984,7 @@ struct mlx5e_priv {
 	struct mlx5e_mqprio_rl    *mqprio_rl;
 	struct dentry             *dfs_root;
 	struct mlx5_devcom_comp_dev *devcom;
+	struct notifier_block      data_direct_nb;
 };
 
 static inline u16 mlx5e_stats_nch_read(const struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..1993da0fdb91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -33,6 +33,7 @@
 #include <linux/dim.h>
 #include <net/tc_act/tc_gact.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/data_direct.h>
 #include <net/vxlan.h>
 #include <net/geneve.h>
 #include <linux/bpf.h>
@@ -6022,6 +6023,18 @@ void mlx5e_destroy_q_counters(struct mlx5e_priv *priv)
 	}
 }
 
+static int mlx5e_data_direct_event(struct notifier_block *nb,
+				   unsigned long action, void *data)
+{
+	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv,
+					       data_direct_nb);
+
+	if (action == MLX5_DATA_DIRECT_UNBIND)
+		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
+
+	return NOTIFY_OK;
+}
+
 static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 			  struct net_device *netdev)
 {
@@ -6224,6 +6237,12 @@ static int mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 	mlx5e_pcie_cong_event_init(priv);
 	mlx5e_hv_vhca_stats_create(priv);
+
+	if (mlx5_data_direct_supported(mdev)) {
+		priv->data_direct_nb.notifier_call = mlx5e_data_direct_event;
+		mlx5_data_direct_register(mdev, &priv->data_direct_nb);
+	}
+
 	if (netdev->reg_state != NETREG_REGISTERED)
 		return 0;
 	mlx5e_dcbnl_init_app(priv);
@@ -6268,6 +6287,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 
 	mlx5e_nic_set_rx_mode(priv);
 
+	mlx5_data_direct_unregister(mdev, &priv->data_direct_nb);
 	mlx5e_pcie_cong_event_cleanup(priv);
 	mlx5e_hv_vhca_stats_destroy(priv);
 	if (mlx5e_monitor_counter_supported(priv))
-- 
2.44.0

