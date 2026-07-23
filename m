Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012016.outbound.protection.outlook.com [40.107.209.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470FB318BB8;
	Thu, 23 Jul 2026 08:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794700; cv=fail; b=cUh0GBGgNg8NB/rUilSF5iuodct4HFQiotrHqrpnyotQni4HPEkC3yALm2Bv0/gHX4fhQwY2lCJkGMcd3E4Biq9VKw7a5J+x9T8LU9fbstm6smMbKkw5UiD5Sfcf3UGUckuLg8+1tO4px9hHkYqAiiZuGeERZsZnnxAFGlGUMKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794700; c=relaxed/simple;
	bh=AX6KUp0iUhlrixyHWzKxnm1EOWFwgUD3yZ9xdeP8sRo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lCjAUTWsexN+vcIYjN/mzC5llWTSDPB7yZpoRfm8nf8hrPLjB+UdJi1fWwGNCyAfrdDWI1D5qiouxhiWYOTuZ7Fo/upjfpJeEm0oE3R1I3t3tAI2INZAIgFg8+6SevwlfARHrR5gwNmZgAngyZSuM7IGYxu58T9aekiEZ5bCzGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bHLtr6En; arc=fail smtp.client-ip=40.107.209.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bHLtr6En"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WALy4n6igiuvL7ZpGik3OEztqgaVLIAJTiIYYZJ7EwAQDIaiKhUfwk0e/zw0ZVvxjBfzkjry6b9KlHsHsAQ2b5pOOfkdgxi33eqp2y4Buu3wMzc7AGcu7MYZDqR7pNcXe4OGEbb/or1TjaGLPJ+19XeRfcGZE/FFnGxh0F81ashXO3bmhm2TJ/YGi91OQH21ey624kw9Tjy4s2qiT3M0jDh7OIP2V9i1f+0khZnf+ZcZrkg+YnFUYJE4RA8BOLaVlkB12xhikyxcNxquJ3vFB0TA6jX42+xeo7AJsPYZ9k4kOslrs+RyvTgqCmnySgSFB2J/+fhQfP8d9fAhZZMAvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVzhnWmFKx+CRHB1j2FHZzzKCwI0MD2/IQiwbZiUp/Y=;
 b=xJ68bRMMGym81XuyacCrXYKO/ZpLhMUl3ckNYu2yoyCphpPGs5vgz5q9CAzAcYqcJKnU0X82IgjBmI+JAQAgRTySknzif6wDqGsYBNcznaQyPDobR4I5IQ6qMmnBV+8Gh/ihLKqzoyHm4ycKlNh3S32iVPDjvi/xUhklAl7iN8M2FQ++00dt6y5KbSoKbFLCnyxzqg6/4M/hUdV4G5muwl1pnkd6JFbdqSiJLhTwZ1TH29RGRB6tBaruiWZKRbzJHvEAFFn6I3NBB/B/5NmhHZFwtbCzzh4S0xYFsw5gq60eK/vzI1CfQemcpP9i6+bV7faAWJF+aLuA0MiA/sCRnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVzhnWmFKx+CRHB1j2FHZzzKCwI0MD2/IQiwbZiUp/Y=;
 b=bHLtr6EnKMe2u1mh6MMy6FkM6hfgi3hyYEf2jWwbUWIepZXdVfqi/SLhRfsgB81gUscTYuziWqE9X0rBzLv3SNqi14kO/LsgSc7Wq2FA89/tGQ4C/Y16TQmvXpU8FLJybxVbzrX+o2H7Kk49ToWHfh2dN3W8sIv5O+N6sxPxKkDakz1rlGjMaz49GdU3CjfiDA4k1SY7Z8VxOwUszIC8qWevgaN9tGlOX7g8No61G5/gBDRHbJwzbDcB3hoSlounJpx/s/0ejJV1E3gxihJ/a5pA8BypmHxw4JFMdRan7ENh38rOMQ8n9SwFxt1kJ/Ym0uKpF7LOQlJCdgO6jWvReQ==
Received: from BL1PR13CA0247.namprd13.prod.outlook.com (2603:10b6:208:2ba::12)
 by DS2PR12MB9568.namprd12.prod.outlook.com (2603:10b6:8:27c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 08:18:14 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::95) by BL1PR13CA0247.outlook.office365.com
 (2603:10b6:208:2ba::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5 via Frontend Transport; Thu, 23
 Jul 2026 08:18:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 08:18:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 01:18:02 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 23 Jul 2026 01:18:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 23 Jul 2026 01:17:57 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Jacob
 Keller" <jacob.e.keller@intel.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Nathan Chancellor <nathan@kernel.org>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5e: Remove _once from PCI heuristic debug print
Date: Thu, 23 Jul 2026 11:17:43 +0300
Message-ID: <20260723081743.1868357-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|DS2PR12MB9568:EE_
X-MS-Office365-Filtering-Correlation-Id: 778bba3f-38c6-442a-159b-08dee892f13a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|7416014|376014|82310400026|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	zdAJSM0PnSHAo72+VatJw2dW6fyqBBAotRfqyr8+N6LcfA4Sa6cE0QIZkjZhvqvISznhmKO5NYnhag8DUK4h8Oj8P07RUSvHdB8zVzgMA57jhVGaXvby8a9M9PPGBUosOvdqjLOVrXGWRsXHxejp0qwTK8uXIMBrtH8F2dJgSBLySFlwb/QScCdPJ6yDwhQq15vsKip8xOzicF6sZDhMnCqHO9IxIV+tulIb09c6uybdEMb8ba+rYbxVS2fzHyjlrVRdID6HCRWmhgoDSUGCJShWDmZFVMTNDVTpFjZmceiXNNM6UrL6d5BvdplHT79/H+Wsy3Xqy4zS+uzCgGYZc61NlXWkKX5Vn5ltd72/RwPVFMEwavibe7TsEjyFgaPWBn3jrvKr8GfIZNfRbr+vFVpOz4O2LEofSV+55lXxuYpRyO5+6arOPg0QtSHIkF/eZy1Q8jinb30AnENBmdIE+mzyb7c8WRh2lhYXacWHvsGCLgDbc6mJcsUP5n9lAuLbWdlXO2pezTwg089TJwUACER8WkcWrCG/BNs4ysGEoZjnmS/7UjQE0D+1S4z+mMca9TG6mjpUOMymmT0Ns6bZh9IjJxfoqOcHAjzNzy0jPGozfo43CStK/KpXTj100LDoT9OmTkEZcai7C2kSeDnpV4yfqU50WNE/0U6eVnUtw69LfSTz6f2EAkPTCn1AvazyFft1Hi1nozAHPhbxAqYuJA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(7416014)(376014)(82310400026)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a0DWhSk4o4Xwqsi2U5VC5oawckbvUuyLfJFTzwUC02rgRLaa00BE8yboOxcYgJVqOW522t+Iizpbdc7mrQsEXGQbhf823FcBqpw7MirqfAKvl8meu9XwbgYR0hdJ/ZJH/GzK+vPmGB7DMy0sHrk4OHh4nPLljtpoamQ3MTE9d3F16zlx/ak4OplhgpWgbq9rVEYrzYs2s55Zcdy2l3odC9+YgPoJ02Snhq5H0pN8n1MbVi9zcTLrgBF3n5+Zy1/D1+xEoNPhX1EQBT4qw+O0nrmRw4ZAT29VjMJueiMVx/MLfq6vggZviLANgKWvRvsaWHv5hX6WCaD58tC6HSo9SjC61Qjnfdlyw5JvgNV+qExLTD25XZCkaBp4+FM9QvAbSXxF39ySKcjuYM4olmxwG4YAq6bYhHKTA2lRmuPiRs9fqpqIyFJOgvV3eGIShw8Q
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 08:18:14.1859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 778bba3f-38c6-442a-159b-08dee892f13a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9568

From: Gal Pressman <gal@nvidia.com>

The _once rate-limiting in slow_pci_heuristic() is unnecessary because
this function only runs during probe.

Worse, it interacts poorly with dynamic debug: if the first probe
happens before dynamic debug is enabled for this callsite, the _once
flag is permanently consumed and the message becomes unreachable without
reloading the module.
Additionally, only the first probed device values were printable in case
of multiple devices.

Replace with mlx5_core_dbg() which allows enabling the print via dynamic
debug at any time and observing it on the next probe.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 1f4a547917ba..5caf7820a136 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -545,8 +545,8 @@ bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
 
 	mlx5_port_max_linkspeed(mdev, &link_speed);
 	pci_bw = pcie_bandwidth_available(mdev->pdev, NULL, NULL, NULL);
-	mlx5_core_dbg_once(mdev, "Max link speed = %d, PCI BW = %d\n",
-			   link_speed, pci_bw);
+	mlx5_core_dbg(mdev, "Max link speed = %d, PCI BW = %d\n", link_speed,
+		      pci_bw);
 
 #define MLX5E_SLOW_PCI_RATIO (2)
 

base-commit: 1df10cef2d1e7f9f2fb7eddb67fc70d3abf101f9
-- 
2.44.0

