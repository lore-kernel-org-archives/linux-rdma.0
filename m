Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010051.outbound.protection.outlook.com [40.93.198.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F445BE3;
	Mon, 22 Jun 2026 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127826; cv=fail; b=fmceyYMXU6cJ4v6/QevtZ1N5F0Q0aiiklT4U6C3snnwyzG6OjuWbRuRuynPXKAAawsPYVfQaem3qUak7h2xszO0KTkFfX+s4Zn5sLdb4F7qwwavj7q5k+OZIx+BCrr6s340yKP0bi3WW5qta6WB6ov51jHq5C1zJYJ8TqBQdwzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127826; c=relaxed/simple;
	bh=FvVePcBTWg/9cOuSIgNeT4VjfRIa5f6UEvkc6825uBI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jNyAcuzgNjRNJuORkmeMzIKaXYCZMc/i8nRWI9+iXuTvW6guNlhFA0OopyeuCYokEZhjBFeCpdLvWeyIsUIXGfc9GRD6OEB55YuoDvhI/ua+qcVPqy5YNop352zQobxNtVoORot7/RR8j8F4rKnHyM/+Kp/Q3uGVG25OLEsn19k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b8hjAyY5; arc=fail smtp.client-ip=40.93.198.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b8hjAyY5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gTIUGyFKd0EhdrHHp7DhBGu1qD+3nNKZG/XRTPlAs5T/11e3N35CgZsQ5ODx3+WS6cSmCPlPMVvpt9R7IxdPEBJF6KTA6kFcNNKrVSlwFQl7daiNVoX5t6ipe9poylQZ3qcXDDV9C+UrqUb1kqjrrU5OTEVpXm12vyRnuR8CUecyTQNnRumBRO1Z8xDExCEWdgoHOin2fEv/NV4BzmY4zgxgStGo1seGPUFCNh2Qls8xAxFSo4E/5C1nxf+wMWqA8HoeurKrHuP8gQdH/V0Xk5052Bw9rkB2rEIyVWiXS8vyO8EVvE9fuj4MUMNsdK9OJWEbfT+vtyAl4wT4gIuY1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amo7UOh7S5rXkkAZEs/Kkz/uWgX0+7yjmCrnEanMx6U=;
 b=B2mE3J3FCvSvo9tcvFEYsP5fM+iSIE6Nc10d6G+2w/3lsVFAWGsCM0zBnVeX9irODj1ue8I/Wm9l2lZWWjBMnE4Q+nZw4twylBdL1FPi9sgNj6i3FL50Ar9YB9+ZYemn/glWK4j4wiL86Uw0xF/bl1rfSl43XX453Wb9GjLYIHF250HJJwCh78hpxrP5yXKuwZS9PkcVRdM68t6ODxII5H3h2RihvzMDIFfutj5Z6SBJyCl8w/T2nEDewoGYEYJ1W8vCQu+D7QvD/LsqEUUU92IdHdDycg/UN/7c1d+5pejU2iZRhXxmkKPEPcYofNKAv6O1iLu9v3r103DbU+y2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amo7UOh7S5rXkkAZEs/Kkz/uWgX0+7yjmCrnEanMx6U=;
 b=b8hjAyY5iaW2DyEsW/5vB4vVyqj8gxPYCgRszVLxNmcii0F3zpvDTLFoO7XwJFlVNCFjUowbbyiw/EaEG7rDlTf+rQa2lWVG/TiBxpH3CCsgy1F0JHxM9QXyAwbwPwgRuKE5C66OVod9wWSLFvqR1aM8R/nWAze9XP3YqfxQ2PlgWquyfEpOjivDLs5+TnH/ORJqF5RzYXmUvDrKfzjxb111PMu0Acscw+7eRw6o9dRTAhMBew4EHwYtOo46KTu3WCj4ztWiAIQ5MTflvf7xTARPHrif45k3gYwsyreujeCJEnOHiFAM/ZzAh8CnBcrHKWnMPRQCpWUtARsijlrvFQ==
Received: from DSSP221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::14) by
 DM4PR12MB5772.namprd12.prod.outlook.com (2603:10b6:8:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.18; Mon, 22 Jun 2026 11:30:17 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:8:3d5:cafe::3f) by DSSP221CA0008.outlook.office365.com
 (2603:10b6:8:3d5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.12 via Frontend Transport; Mon,
 22 Jun 2026 11:30:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 22 Jun 2026 11:30:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 22 Jun
 2026 04:30:04 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 22 Jun 2026 04:30:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 22 Jun 2026 04:29:59 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman
	<gal@nvidia.com>
Subject: [PATCH net 2/3] net/mlx5e: Validate bandwidth for non-ETS traffic classes
Date: Mon, 22 Jun 2026 14:29:24 +0300
Message-ID: <20260622112925.624795-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260622112925.624795-1-tariqt@nvidia.com>
References: <20260622112925.624795-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|DM4PR12MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: 26694698-8726-4208-e565-08ded051a23d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|23010399003|82310400026|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	qoJp0k/lDOf5Wu+QUrdZN1V24xhiqqVHAir16sBETICb/jtRCKTMGSQqMjdhPzVemDAmDnCUmgxARLgDawBhBdV8XA8ajlNyRaz/0DR/WnN2YsKI+iNMITjvE2tE/sN1A99Pezn61dP515+kuHIX7AD63ExJaUmTiDQ9nx16rQWaM9k2Hil1USk1s3oodzQxyJOZ03zmBogf1hMJSObbq78LmASLB35z1sA08a/NAHgcrWcPkjEpmWBBXbbV2tWOQz/2HmIw2Ywbzi/2Zik2IW7jVZ01h7tuhYbAPifKOptzsnalw15qTZ7ii9vKrmfyhBJrFY0NXKcsAQhyWsLHpP7jN1m6DH+bK9NBo55StEgWfdVzB/xLBYN+1Q2uKTUlmz5A9tZ9UbyO5FwIAR2E3Z6BTMvefSgzv1dEhmah5d32BwiELf7fwsAmzLcex8WvwARm2Km8K5HqaI0S4SGKbFQv6/4HNBRhLJtHGFdzncXZqWETwMYS0znubfprLkY5tp1DOmFU6AwsBWr8iQuYT6/G7Z/UF69ao+S875I3xEZ6RRCz3qDM45avzY7Mlc76UpAb5dY7bzxm0einCq02YyiGHA3Iqcm6KQF9RyVd/W1Lb1cyPLbG1LtE6bnkABxHVHfmpNeJPa2aJi6lCcg/1d4Y7+Yeb/ZP0wDlcuoOeEp5uMRQ7pKOXCTEjA72Opqze7hyFd9yqokuboAMDPVAqQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(23010399003)(82310400026)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eir6NymvtjzUu1YC4rywtnV0dIDqun+JRG4o5otBGD4oODzboMKcmMpjVOGa0gZAduBo638lSVTROoxm3II+XDhMLbUKjraeRfU5x0wasIeYcYBLYEJsjEG8fvzyKM54rfw24xZ2yn6XskczQ5SWzeAK7szhZbHZwII9ph57kItB1OG8KhbKgnTThA4gnhxngPd+7t7Pk7kSieUxZ8wyrT4irJIjKw/seNwHss593HE/REQZUaQjumKpVCoW72nYZehYgS3aeLy9OIKfENDLGuxarnu63e9EN6MSvnPypbKQ+vbDoIU8rNxsclQdPXXyNWQCCJ2Ky4ZPftOTLHaj8EAplV18EV59+TOjAIY2G5DFUwwHCFRbyQZvzmUr0C8tlQWqvD0etQ3yj5fkT4tzsuOoUkGXsseOjGgn58RFcs60TMGURDdLbhTun8D1zxrD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 11:30:16.4719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26694698-8726-4208-e565-08ded051a23d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5772

From: Alexei Lazar <alazar@nvidia.com>

The IEEE 802.1Qaz standard defines that bandwidth allocation percentages
only apply to ETS traffic classes.

Reject ETS configurations that specify non-zero bandwidth for traffic
classes.

Fixes: 08fb1dacdd76 ("net/mlx5e: Support DCBNL IEEE ETS")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 762f0a46c120..e4161603cdc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -324,6 +324,17 @@ static int mlx5e_dbcnl_validate_ets(struct net_device *netdev,
 		}
 	}
 
+	/* Validate Non ETS BW */
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		if (ets->tc_tsa[i] != IEEE_8021QAZ_TSA_ETS &&
+		    ets->tc_tx_bw[i]) {
+			netdev_err(netdev,
+				   "Failed to validate ETS: tc=%d BW is not 0 for non-ETS TC (tsa=%u, bw=%u)\n",
+				   i, ets->tc_tsa[i], ets->tc_tx_bw[i]);
+			return -EINVAL;
+		}
+	}
+
 	/* Validate Bandwidth Sum */
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_ETS) {
-- 
2.44.0

