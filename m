Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697515;
	b=MGAwCILOEWyfbd16tECeKbmnkxN/OOmvbEM7+hM6oNcKJxQSV8paOLqSuOVOYRn5hkip
	 Yza2zeEq1UjYwHttznbfe9zokJCnlp8M00UWtO2pnL728/71Nuy/32KXqTzVkTX9ywSoq
	 VHy62qSalPNibenlIU/OGtOnZ1fBn7yztMkR6vqbWWgJt7ydYnd6msWZsrnK/6C8KK376
	 4Cc+vSlnZ6gAd1FLM0p0yrW8FAHgxcBmqVnPsbFlTRlKfoU/6qWs1QIBjeHN7tHoG0MDv
	 MLZ+ZDaNfGCHCa4ztClmatLceEfU6u+IHedEHVN63LtQEGs6zCjcx6KlFFWp9Gbhaeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697515;
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
	bh=mDrr5Ee+j4Mzc2snflbIdj5DRvnD7pqu1J+qx6AwHsc=;
	b=HMYWzpEYcxMM+FavxXe92Au7+Ys0ty9eS0L4iNjAag9Og7tKQo1c4LtrCKzYyx5A1lEo
	 pwagio1jkII/7UGEk6F2lRVydqFOp1kC0E3ZN0wQ4ORjizeyngBWAOp4xqU5ihT7UveOQ
	 dIksoviNvztT4gW/GrY+gVr4vVy11gWv5nwTuVDpsPLGNGkGWPRI1geW9OSzZCBiHBl2e
	 X2vDuAHKAC98mtq+ZYu3qd3FVxdZEMDHYmVxWJrSnlCNmTzr3G8WmkNznMhpUvpZY3HL7
	 edBJa/KPN8jmWU/YOSADy3yJ1KX0wteDFzz3LNCBK2SXVkHGZrvkfxF+Ps2qKHzlqVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=neH4wTOr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.70
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A56606A319;
	Thu, 22 Oct 2026 19:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52A56606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=neH4wTOr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EH3zPvItNIeLFdd1M4GFP2nt88DyEdZ3+dYoD/LulJwErLqbQn8M+wL4kuJPGw2HWGajijDCm7qMn0hC1SNDKX6UEmEpy7v3ikkJdBLnm3bNYL95TyBzlCfqsq51+uDrtjYc1ySomHJginWJe8Zu4OCJ9Dhb7jkCnNgFPy5VIwlN+Qn7fxorvKYRAbir1Pz+aBFDE1uzSK6lfzEIRKnWGIRbbuTK4dZA95mXJ5UUxb3f4Y0BFZ6N8RZu6DKIl5aZEniLkhMC4HZEQyz8UoPvF2K4nNs3kAG4YvkV/cJPqUpNwTYO72juqw1glF0lZ+RUiJgB2owersHyisU/+CROaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDrr5Ee+j4Mzc2snflbIdj5DRvnD7pqu1J+qx6AwHsc=;
 b=SkWIHtdS3AmiiOvH7W4XsdsNcI4+ZNw9gvH/5WRDTbGVZz7xyjz4jN2mkwkzsZas4+uPgXBAYrI5uRqYJzws/VGmasLSpCqADj4KlIN+RyMP2+iie5okZWOJcdwfA2MMKeqC4Y5qyKR+VWIpDODUjfA/+yy9K0LjMH7Z13Gl0/08XmtlPevwbpfaBkc5do0xPBdjvvy5bbotI/BpxuPhwM5ZJLzG3VL7j1eN/CVScQwVyxsML1H0TvQe78V3/WOveZp8SYQtshQK19L4v85syHeAOhCM/hZbsVCNPdy869Jbo8NWQYerwdIZ3BnAGZrIuz048DBuaqOt99tJeoUrlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDrr5Ee+j4Mzc2snflbIdj5DRvnD7pqu1J+qx6AwHsc=;
 b=neH4wTOrFSHQxyoiEoXIqaugwDvmTMt2hYbaqAzeYBwPj7SVCxEZnA1+fyGWaI2cBp5f8hAIqpp0eN8+nXlXrnlZUZq+nTA7GWvWZNnIlRXrXhHdDRx+IlKg9YFtMkNX8Jfrp47pECFCRsi7UIvdN/qt3v0NFQIomtBJH2yIgnEwXIpFHmjxfDBHUi9mpUdIk2rA8+at07ghH6HVMmSHHX9G96970HG8p6HpyVjs/dsmTkm6gdKNQWUvfleM6uLGJdhx+ziUWwcTY2HNzyxhxGBhYDpAda94bJ0bLJwpnqH7NVF32j8IKooziAeoOOJb2CCIssUQme5QSjkYfE+Bow==
Received: from BN9PR03CA0683.namprd03.prod.outlook.com (2603:10b6:408:10e::28)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 19:31:50 +0000
Received: from BN7PEPF00000090.namprd03.prod.outlook.com
 (2603:10b6:408:10e:cafe::94) by BN9PR03CA0683.outlook.office365.com
 (2603:10b6:408:10e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.17 via Frontend Transport; Thu,
 22 Oct 2026 19:31:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN7PEPF00000090.mail.protection.outlook.com (10.167.245.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 19:31:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 22 Oct
 2026 12:31:26 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 22 Oct 2026 12:31:25 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 22 Oct 2026 12:31:20 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji <edwards@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2 2/4] net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth
Date: Thu, 22 Oct 2026 22:30:51 +0300
Message-ID: <20261022193053.3815866-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261022193053.3815866-1-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000090:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f7d51fa-5060-472a-d953-08df30731e8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|7416014|376014|261021121427099003|6133799003|22082099003|18002099003|261022113327099003|261021135927099003|10067099003|261021123027099003|11063799006|261009223027099003|261022105027099003|56012099006|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	vX0x8tbrKzsxQtCC5JUrbioZU5LubhQ1qvFCDA0WT6WvBqIjkCHrWeWR6cApzGz6pumQBf6BLOWQHsZbKU0LLaU6Zi8d4Ms0WQoC+lEdsZkZcw0XEC0UoT7qF1II0CZh6AZ5byuljQ+6Q1w2WokQSdsNTGChlzr6So9nWMezq7IBmrPs7Q/TlLc6w67V2mTZrWJsXO3e1MvlvDxbOJ+EGNl6h6ZKbnMQp1FyC5qK0kVgDnS1locjTnJ0OeuXOwu6aCgv92eWSJpaqEuJE3+4+W0ye/VzO+klnjr4YCIrUlJ0vuJvNCIbUpBjl4fBERXFiSc+c29RG6+jIP4RntbDPvpOBz6huR2AUI++l5c/M6B7NCegFECLNM3c9j9ophdb8hShup4S1J+iTMcAeu7gLy5kgv16LA6jkyuZYnEedXmB7NZKlKNJMy0HZnoN1GPk/Ak3d2/gucEu9hBfvOdc5/Rjyv8WKUE3rhQGTGaXbaIszMiHSuJ7Rs+MD5YJsl5C+Hc3q1rq+gJzONiyELItx4o7m2O1tvk5AVFkIVnCHR//FXuSwG1CO3TEi94vYtXdoGyho7JDgQnPL6UGpLQADU766FAt30O+fT3Kp0wtym4PKmgTyDrELXxiNF9Zo1yiLihbvRkzpEodNKtw9Ncuv2jtSZkz9WeNRopChGxXCqxE2NBqnscJqwfBVgSYQjPG18Wn93Yj30/Sp/3ZjQ44Zw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(7416014)(376014)(261021121427099003)(6133799003)(22082099003)(18002099003)(261022113327099003)(261021135927099003)(10067099003)(261021123027099003)(11063799006)(261009223027099003)(261022105027099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+SrHjGy9pcwquxeeWQc+IM2OqmHHS3S+0ZV4iQuABLWTwaQpVkmyk6bUFYjrldK/eUoOY2KTGPPJZvBZ1YB9eeBfBx/a5wB+E/XQOJR9nIWM04Yf5TFJn4p99qsX63MkHgKbBL3OgzhYtXjGh+X0l7cIiR0g0kOJ2lNDulkmP6kB0cplsePF+KYfuMl/cS0t2W0LQrmOzy4dfUZWcbuzAf0g3Oev6W+HMe4nFMXb4KKZdSPpF956Ss5NtyTSmtIAg0wMl1834Ozj3iTH4J298a6cQdKowfcQsQD71261v6CW3NL87fTMS+CRgpdfzN5E8PVJYc9Y+vZehjs+acu0trvlcbceFEYYYbV0TYJ3yo6CwEId9c0tTjcnm+yeRVFAnCgr+bCXLS5VLUoBujfCcDUeYvn35fgbLKrKbU5oirZBVKAJrFaLy1ROsp7JyEcz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:31:49.9944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f7d51fa-5060-472a-d953-08df30731e8d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29

From: Or Har-Toov <ohartoov@nvidia.com>

FW initializes max_tx_speed to the minimum of the port speed and the
PCI bandwidth. Modifying it with a value computed by different rules
changes the meaning of the field rather than updating it.

Limit the aggregated LAG TX speed by the PCIe bandwidth. Clamping each
uplink separately and then summing could let the aggregate reach a
multiple of the link's real bandwidth, so clamp the sum once instead,
counting only the ports that contribute to it.

This assumes the bonded PFs share a single PCIe link, which holds when
they are functions of the same device. In Socket Direct, each port spans
multiple mdevs on separate PCIe links, so the PCIe budget for that port
is the sum of its mdevs' PCIe bandwidths. Where Socket Direct ports do
not have equal PCIe budgets, the aggregate is clamped to the narrowest
port, which under-reports rather than over-reports the available
bandwidth.

pcie_bandwidth_mbps() reads the endpoint link only, without traversing
upstream bridges, and uses the nominal per-lane transfer rate times the
link width, without encoding overhead. FW initializes max_tx_speed from
the same endpoint-only link status, so using the same calculation keeps
the clamp consistent with the value FW programs before LAG. Ethernet
speeds and max_tx_speed are likewise nominal rates, so the comparison is
like for like. A more accurate bandwidth estimate would make the
aggregate differ from the per-vport value FW sets up for the same link.

If the PCIe bandwidth of a contributing port cannot be read, the speed
calculation fails instead of returning an unclamped or partial result.
A device that has no Link Status register, an RC integrated endpoint,
has no PCIe budget to apply and is not clamped.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 79 ++++++++++++++++++-
 drivers/pci/pci.c                             | 16 ++++
 include/linux/pci.h                           |  2 +
 3 files changed, 95 insertions(+), 2 deletions(-)

v1: https://lore.kernel.org/all/20260910102432.3845360-5-tariqt@nvidia.com/

Changes in v2:
- Clamp the aggregate sum once by the narrowest PCIe link instead of
  clamping each uplink before summing, which could let the aggregate
  exceed the real bandwidth
- Document the shared PCIe link assumption in the changelog
- Add pcie_bandwidth_mbps() to drivers/pci/pci.c, which reads
  PCI_EXP_LNKSTA once and decodes both speed and width from that
  value, avoiding a race between separate reads of speed and width
- In Socket Direct, sum the PCIe bandwidths of all mdevs in the same
  port group instead of taking the minimum, since those links are
  independent
- Fail the aggregate and max speed calculations when a PCIe bandwidth
  cannot be read, instead of skipping the clamp; an RC integrated
  endpoint has no Link Status and is not clamped

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 57755ceab8a7..05e6d0aa31fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1432,10 +1432,55 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
 	       ldev->mode != MLX5_LAG_MODE_MPESW;
 }
 
+static int mlx5_lag_dev_pcie_bw(struct mlx5_core_dev *dev, u32 *bw)
+{
+	if (pci_pcie_type(dev->pdev) == PCI_EXP_TYPE_RC_END) {
+		*bw = U32_MAX;
+		return 0;
+	}
+
+	*bw = pcie_bandwidth_mbps(dev->pdev);
+	return *bw ? 0 : -EIO;
+}
+
+static int mlx5_lag_port_pcie_bw(struct mlx5_lag *ldev, struct lag_func *port,
+				 u32 *bw)
+{
+	struct lag_func *member;
+	bool unlimited = false;
+	u32 member_bw;
+	int idx;
+	int err;
+
+	if (!port->group_id)
+		return mlx5_lag_dev_pcie_bw(port->dev, bw);
+
+	*bw = 0;
+	mlx5_lag_for_each(idx, 0, ldev, port->group_id) {
+		member = mlx5_lag_pf(ldev, idx);
+		if (!member)
+			continue;
+
+		err = mlx5_lag_dev_pcie_bw(member->dev, &member_bw);
+		if (err)
+			return err;
+
+		if (member_bw == U32_MAX)
+			unlimited = true;
+		else
+			*bw += member_bw;
+	}
+
+	if (unlimited)
+		*bw = U32_MAX;
+	return 0;
+}
+
 static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 					   u32 *sum_speed)
 {
 	bool mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
+	u32 pci_bw = U32_MAX;
 	int pf_idx;
 
 	*sum_speed = 0;
@@ -1443,6 +1488,7 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 		u8 opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
 		struct mlx5_core_dev *pf_mdev;
 		struct lag_func *pf;
+		u32 dev_pci_bw;
 		u32 speed;
 		u8 state;
 		int ret;
@@ -1477,9 +1523,20 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 			return ret;
 		}
 
+		ret = mlx5_lag_port_pcie_bw(ldev, pf, &dev_pci_bw);
+		if (ret) {
+			mlx5_core_dbg(pf_mdev,
+				      "Failed to get PCIe bandwidth (err=%d)\n",
+				      ret);
+			return ret;
+		}
+
+		pci_bw = min(pci_bw, dev_pci_bw);
 		*sum_speed += speed;
 	}
 
+	*sum_speed = min(*sum_speed, pci_bw);
+
 	return 0;
 }
 
@@ -1510,6 +1567,7 @@ void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev)
 #ifdef CONFIG_MLX5_ESWITCH
 static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 {
+	u32 pci_bw = U32_MAX;
 	bool take_max;
 	int pf_idx;
 
@@ -1521,6 +1579,7 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
 		struct mlx5_core_dev *pf_mdev;
 		struct lag_func *pf;
+		u32 dev_pci_bw;
 		u32 speed;
 		int ret;
 
@@ -1539,10 +1598,26 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 			return ret;
 		}
 
-		*max_speed = take_max ?
-			max(*max_speed, speed) : *max_speed + speed;
+		ret = mlx5_lag_port_pcie_bw(ldev, pf, &dev_pci_bw);
+		if (ret) {
+			mlx5_core_dbg(pf_mdev,
+				      "Failed to get PCIe bandwidth (err=%d)\n",
+				      ret);
+			return ret;
+		}
+
+		if (take_max) {
+			speed = min(speed, dev_pci_bw);
+			*max_speed = max(*max_speed, speed);
+		} else {
+			pci_bw = min(pci_bw, dev_pci_bw);
+			*max_speed += speed;
+		}
 	}
 
+	if (!take_max)
+		*max_speed = min(*max_speed, pci_bw);
+
 	return 0;
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8cc6a89130b5..064eef237d6f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6006,6 +6006,22 @@ int pcie_link_speed_mbps(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pcie_link_speed_mbps);
 
+u32 pcie_bandwidth_mbps(struct pci_dev *pdev)
+{
+	u16 lnksta;
+	u32 width;
+	int speed;
+
+	if (pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta))
+		return 0;
+	speed = pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
+	if (speed <= 0)
+		return 0;
+	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
+	return speed * width;
+}
+EXPORT_SYMBOL_GPL(pcie_bandwidth_mbps);
+
 /**
  * pcie_bandwidth_available - determine minimum link settings of a PCIe
  *			      device and its bandwidth limitation
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5ffcf5ce8c96..202bc8680601 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1479,6 +1479,8 @@ u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
 			     enum pci_bus_speed *speed,
 			     enum pcie_link_width *width);
 int pcie_link_speed_mbps(struct pci_dev *pdev);
+u32 pcie_bandwidth_mbps(struct pci_dev *pdev);
+
 void pcie_print_link_status(struct pci_dev *dev);
 int pcie_reset_flr(struct pci_dev *dev, bool probe);
 int pcie_flr(struct pci_dev *dev);
-- 
2.44.0

