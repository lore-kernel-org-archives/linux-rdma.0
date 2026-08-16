Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD01C3CB573;
	Sun, 16 Aug 2026 06:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786863092; cv=fail; b=r3+L919RJlanu3c6H3/w7tGlALqsaOjn6BkoP/SC36xHFbU+EFHa+eQW6VcHesHP0SFUcMlQB72umXOu5qsA2PL6O3aW3zUHTzRYyW28irAbz2UYSaR7Cui05eKu8uRF4VwftwvRiSsoPYxIQJLcpSPv9LIEQ3ud3CqRh2SE3Hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786863092; c=relaxed/simple;
	bh=vfznen/WL6uOEz2gfxYIuknNlCBgqjlGF+1PmRisQ5o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i/d2y1Cx7R1ST54M0x3nZ1XXxKweJK7xD3M0BgLKTVwBp6wGsjPxJdo6wRMc5VLKbN85qvX09YuuB2QQz2i1GemzaKi6jFUoy2mVxqz3bChCjzh+qRGtvZuAAoel3LXk5MckNDhwm1FwnMPsQju+FTY2E0ItY2drb4V7j+Hiu1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KWVN/OZu; arc=fail smtp.client-ip=52.101.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KWVN/OZu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SX0HTeHfaTh0Jkn2GcGwu7cQlVk2ufIETWSBQE4Ybvlv1+6lf+4g3wMr+fg7x8zYw1WpY/JcGz32iXLQMRks1Gzkp55xggBqjvPtIL6/MTw6dCZTXDFihM2bC0F8FUGKaVYdoPrpTicVm98RC4TG6q9EeQ6/Xag2I6/nOTQDGY1IwdyHvxxtVKVX2yaVJbezKcq0VChEybsVrSyFTsp0+xoHYMLs/CwlNWZaMm12xE+evcRGINQkkhKGdpG4qwVHAKmpSomdiMTI7Te2pwptLQXcncZsx+VAdvNvPSjBJizZeIq5wOAKrttO7qndQxZm11AJRmzV8LHoVY3SdZRWpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvv/TNRt+l6z6j/O9j7z/f306IKmK2iXYAsvJH9T9MI=;
 b=yvAC+3Z5KTl8q+nhePQUjFVUMdhBQy4VWONnOkGpN6pv6bM9cMWcUKhzGJFd4hWPpC0ewplO4gWXIx6pKhlXVJvOMg1xyMn661unzmAGLbTHbs1k3FRpyE6DEW36z5R9VvNjpa/FbZAUbF0Iyb8i22peVYxSr+LE7xA4wCHBSn/K7QrochZs3YeTmHj6FLJbJt8MOMTtQarvbNUePPIlTTttITId+iWtFrt+CMORseKeTLAdAJrTMF5GnhEQ84m/4u0AeZfvQ9fWYW0EwJntcVMvNbIHmF2oGKzBX9BicKYSuSvbfY0Gjf1WuMjFym9PowVpd6m8ly0hJInj29R8LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvv/TNRt+l6z6j/O9j7z/f306IKmK2iXYAsvJH9T9MI=;
 b=KWVN/OZuGQ/EnnPWv1keT9KgoHGXpqkx4e8TKtNVsd4uZZX1ybwLQyiXi9Om5+yWjUSGVhE9W+mISZ0/DYxMsd6zjPBMBLbgT/WeZRt49RXldgnJ10OWNWJiWGZ1UfHsMdwy9CqdWTjVpCYyzhYPpPd7x6F6+7CPc0utetnSMjoeF9ALZzGwSpJxf/NSbNtCQsN0OX/dihRsjnU+9IuXKldpt+7/lFXs+v/ylUNA2Mxl3hEU2a+3O3uojq3hnBpntXna9SzMShYpgsolZ5gyZXQK6KMrrbLbN4IhPnqMdDapFItGeozdCa3Wv/6yb7c6BKoGKF+DQbs2KrRKw8myVA==
Received: from CH0PR03CA0272.namprd03.prod.outlook.com (2603:10b6:610:e6::7)
 by CH3PR12MB8545.namprd12.prod.outlook.com (2603:10b6:610:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 06:51:25 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:610:e6:cafe::2e) by CH0PR03CA0272.outlook.office365.com
 (2603:10b6:610:e6::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Sun,
 16 Aug 2026 06:51:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Sun, 16 Aug 2026 06:51:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 15 Aug
 2026 23:51:15 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sat, 15 Aug 2026 23:51:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Sat, 15 Aug 2026 23:51:09 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net 0/3] net/mlx5: Preserve speed and state across vport modify commands
Date: Sun, 16 Aug 2026 09:50:12 +0300
Message-ID: <20260816065015.3280733-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|CH3PR12MB8545:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e7804a0-8e5b-4a8f-42f3-08defb62ca93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700016|23010399003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	E/lnZKWs26J5P8rG+ny0y4ll2DwEjq9vRr4yOOv4Dl3aPm8C3XSFUBnh65K6fLVUDTeEmEugv1tKkm0op/VgfGqnTX/rnejy2adANh2e2MYob++EW0Rl3jWkkaAfLGv31NkZx0qogbduNRi7OVEwBNn00kXBq6CHqQZyt3RiEtf1+aVBx6PHnO6HlDomeK10QiTWiZwXRMQx7LvoCsa19qO6DCSjaSk1sItmlE2krsR4/UmJA204CGv3sHNaNupb2vKSoQnSDX5yOXes65A4QoNOpIgfG6+K4lG7o5rcfEaBZUIlLCjZCUXvQxX6UrFfd+mfJwmFUidZPEoH4pJoDE5UcQtl0XU9xB6H3OWfCPfCLuq85QxjuX0sXy2BkgviOiIuAfrCDyPzsdchOTc9b/HRwsguWWA5RlNdvntFPHHI8DcrY8rvdhEdFH4UyQavH2xhXDxPHIy8c+PuqzKCIdYvGU7zObj/tp9PXtUp48ZhMeoF+TiZW4CrHHEzEkQjm95ZFGUtKtmKx69D13fvjvGs1PvmHfQrWoo3KQF6+kgEnBz3VI/dy1F/DnyGa0hnLdksq7fU2e/0FTF1YFYOu65c0FvKE46y9m6oNm5dzzcZUkkm87eH0BmBWzx/1D8Ul1kS47rcjioRgExCFsa9eE9gGgi/mPZl14YWXxalNHh45U8WLxDPHJM4c75JbKLrn9clsZriYnz9suLZPH6ifA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700016)(23010399003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tU8Q3eSh1Hx9d67n+r93Yey9Hc2e66BigrF6rdT4lgOdELejUSTEvns1/Q4vLwCYm/NcIbylAPq1NiExPpLEHOdsH/DbFTL/e4AKrbhECLKSNpMLM0R0X2ucG410FYSABY+YKvGb7zkd1TU/slwxrdh2R96Mq1J+L0levly/fMwNeyXG9CMevX8X6u2NibGZDj2kOEoEOr5LcdfiI5SnxPCyyY07xEIHunbu375RPn7U/SuTnkaFU5v0VsQoKDRRoKHiGfSPx5KB2e7CiDQ636CEE0c/YoRdAtx7jaw2yNMUfMaBejkPhGTKyU+xQYLQ+aF5GdlTr/c+NdK4BO92ZtDwMlHcKqdV0so1BjNcKx0s8htFy0BRYCsskSrUFUNNeNLFmqpGDqBM2I+m42gXysZfZc9rMp9lSFiF3kRHWUiHpNQm3tgSEFxd7LOJG4vM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 06:51:25.5715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7804a0-8e5b-4a8f-42f3-08defb62ca93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8545

Hi,

The firmware vport modify command bundles both admin state and max tx
speed in a single operation, which requires each side to preserve the
other field when it only intends to change one.

When modifying max tx speed, the driver already queries the current
admin state and passes it back to avoid overwriting it. However, this
query and the subsequent modify were not atomic, a state change
between the two could cause the modify to overwrite the new state with
a stale value. The fix holds esw->state_lock across the query-modify
sequence.

When support for setting max tx speed via the vport modify command was
introduced, the existing admin state modify path was not updated to
preserve the current speed. As a result, the firmware interprets the
zero speed field as an intentional reset. The fix adds a speed query
before the state modify and passes the result back in the command.

To support that, mlx5_query_vport_max_tx_speed() had to be fixed first:
it was returning zero whenever the vport was DOWN, which was correct
for the query_port_speed verb but would defeat the purpose of querying
before a state modify. The DOWN-to-zero logic is moved to the
verb-layer caller so the function returns the raw firmware value.

Patch #1  holds esw->state_lock across the state query and modify in
          the speed modify path
Patch #2  moves the vport DOWN zero mapping to the verb-layer caller
          so the query returns the raw firmware value
Patch #3  queries current max tx speed before modifying vport state to
          preserve it

Regards,
Tariq

Mark Bloch (1):
  net/mlx5: E-Switch, use state lock for vport state changes

Or Har-Toov (2):
  net/mlx5: Move vport DOWN state check out of
    mlx5_query_vport_max_tx_speed()
  net/mlx5: E-Switch, preserve max tx speed on vport state modification

 drivers/infiniband/hw/mlx5/main.c             |  5 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 ++++++---
 .../mellanox/mlx5/core/esw/adj_vport.c        | 22 ++++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 ++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 44 +++++++++++++++----
 include/linux/mlx5/vport.h                    |  3 +-
 7 files changed, 84 insertions(+), 16 deletions(-)


base-commit: 24ef02f934eeb48830cff6b739abc3c62b1d107b
-- 
2.44.0

