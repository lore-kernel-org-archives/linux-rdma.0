Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7275757EA;
	Tue, 15 Sep 2026 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471193; cv=fail; b=TIG315Vj6kdzN7hZLHfgC6D1sXkiMlFIpAH8eH3TcY15VcOcO6VTNesLbXzgxA6IMEXbbHWzuZFjcpj50YmkXQxdOVOz9wn4/NQUFrfZ2I1U0jS+bjI81zuIDujFYk5aMqjoJsT+S1PkCvNjX47uErZ87YGR2epSaJAR6zqxNwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471193; c=relaxed/simple;
	bh=+SIiMzcBzu8gfgk+oThDxtefwgkvXutOGAeMOs2ODkQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YnyQM8X7qXJ10bE7c2jLejN+baUn7f3Uu/akFywNJmUQFOFSkwrvihZgLDe4khhqvoJFjXcgdXnO6XquDE5lF/9WRtfZ9k4xbI2KSoYR9poq6kjR+ptHTeis55PI/Hn1gNuN0WuWnrnbUjqE7HwPTTEzyNEvhi82aUJB+v65Rso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h89PBpet; arc=fail smtp.client-ip=52.101.61.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h89PBpet"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5+dvyRlUJShPH8QxaTFgzRiPiHkFQ7spSLXUR7HrMYFuOOt+ucPa8aSP4pxKh2yKLTCj6D9GFobT6ERPADki8m8VAbxaYAgle2+Uf4Exe5nKrQR3yQlMB0LwoE5ZtaGRjaRen0ugWaQ2yWyQcF+p8sQiibo1FlWM796pOziOeWbqS+UVPPjx7RWPG3vxv6xXyUi7QSjZVORorauljeoIN2P45zYHG6+OedNwPrmjjhJuDardOcKt/hv9n/PjLhiVclSl8IuZOo2uXHB+z+mVpd1NQ3Y+yRUm2IsTg9e5uAk4yfodJpHIMij7Dy9qQdc83jGl2jJ/ziICjTvhTUicw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlxofDsjXshSkSTMke7jBtPWe3z4NYrwu7kfweVxZ6I=;
 b=KMzvjydr6w3ezB74iyC1J4hhFaKKk73dhx0vQY7ELJKkBbfgXcmcwSP+QmkjATjS+PUT+R1irk65jq7h0HxQKgAUsOlLRfhFDSG6RrXzOW59jMAFUCeApSM6fJVn11N0D+/Rc/GwAgGc23t4XTa58Ja2zoE5RkO8qK1XKmbZE/YFUjk3OEyizSS0FUcF27fIgYfNbp6R6nRYOEP8MtrJCYtfwaQdnlH/KTLYIAVwvZCTW11w8qIGUjN7CbpZHIapMolSWwtFsLvmGwtlE5I2Wz0UOv5fjWKyzi+p5OCN5K2JVJ3pPD915ytrnVpCIUFee4k6IadLaiG041OwCRwCBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlxofDsjXshSkSTMke7jBtPWe3z4NYrwu7kfweVxZ6I=;
 b=h89PBpeteNzf5AO+3CDAhCZeDSljr4oTPgp2vMwhQQDdtSE+RQur76Xz7uxAEQkmE+vbfzekYu8oD9oaBIDd9hgaT/CkRuV+hGz0YH4sHNdBqW4xhde5+6bsC+ZbkHl0bkQIo6HcoNBcZw3nqOkzIjGyJJpjHND7Mx6bn6ApxnEBfosq4VSFgd54ldq5OuP4kPZqhjpW8SpzrntcnYQ0X92N6mMJgiez/zC4RY4w/1XzZlJUrFq+unQnq2oTfOE5PDVHTiCynV4KdQFsPDWto+6S/dOvxoblow7PrN+p8Pui5Ywn3Sp6+ur8jDMYnJlAVJfFz9UKH6DxZ2SFP2V+UA==
Received: from BN0PR04CA0142.namprd04.prod.outlook.com (2603:10b6:408:ed::27)
 by DS0PR12MB9323.namprd12.prod.outlook.com (2603:10b6:8:1b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:19:47 +0000
Received: from BN3PEPF00022BBA.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::3) by BN0PR04CA0142.outlook.office365.com
 (2603:10b6:408:ed::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 11:19:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BBA.mail.protection.outlook.com (10.167.248.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:19:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:30 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 04:19:29 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:25 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 0/6] net/mlx5: more HWS misc enhancements
Date: Tue, 15 Sep 2026 14:19:06 +0300
Message-ID: <20260915111912.3926585-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBA:EE_|DS0PR12MB9323:EE_
X-MS-Office365-Filtering-Correlation-Id: eae2f3a5-765d-439d-ab4e-08df131b3fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	cjjo5+NEtTlT/QscyvWl5vwVSu82+OhIhGJMOUrSHcG3qsO3VrGVmKKgF2IYGQFavzrBjlaHe0ZYxgGK9C4RFNb9UCh9IxZ8u3Q7fjUTd80CxnepKw0DR9hkgzmgmTMVXAkijlqNiaXkBPiedejeSfll57BT9+GvXe8lqUVlcqQPGc3OPlxUfs4D4Owx+FuNZ3cmsw/mq3rENDeXOzg/qdw8ISCKpghN2SKd1kS8KlFIugByEC0iUFlFuYA4boW8nRn7MfLTCQVhDDRlkXK5T0T6SmFN9ZvtGo7LZ9MkOTcparP8VLLSo6nWosfyg5xa1QwCjzR5h4pV5F+kPO+xvwusASoCRjkUV/Uoe48XYhJNv2f5OHcoEnb4QeF1ec359DWHztjf7adPv7QJ2zJAJA9uZhU2QuYCzio5LPcxnC5bujmXLF7AFvis2LcxOMrZwszNi0RQdrngPx9l2b0XdzxJq3oG+PiHkdvCIBL0QEYwREc2+z6x6GkaaCkXzUBgwR3ANxrnJLtp6BgtY2eyH08lua5W7RB8MptzWiE0ooGk0lQdqgYupM+bsVnhGb1AM1ZdLQHHyQB8RQ6FPq2jX2VwkFD41J6IRqL4i9HaBlCKiDBiYyvHE6p50S1rVzmxXZxwdl8rDVPL1uIj6F5JHkGjLKJ677CtGesXziUrLRt/iyAGJXL8uPchXWYMDUfx9C7PM2W47IUYnx9WEvvq2A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eYFQCJGsAuQz71wVdD655rUIpI2SZdQ8vhMxit3SkowU5z7botgIeiqztsUVYmc0hDPk6hBv1aML/oi10e0MfnNgBIP5Jgi502uT57z0n+iG+bZYP40uh6wwjXjcosNCEFUAv5NTkRZMoZDrKSHkoRdRtySm7KIIicIQdvenGQL5ChZNr8lzk89atev5ufutGTNRjazt3zwz6VI0OVf0INvBJ63tiAlH+rQoY4XHpLH7G4DkLNSL9N/5g7QIynPVi8zkA7X4Lmkc3a3ghZthqd4zFCKBGKDDXCp0wj2kPDHyFOo8tJ+g5fVnqDi3/I+roHvsb4O0il2wJpKQ48vu3hP9oD6SLztym8ieQUdohm5PpcKdojZapGzJAbbH8scYKWCw2LYHMro8mJIMMHBCjmc4snGcLfa2C7P6KWEow39y5kxg6/FBNiHTqrTIcSfP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:19:46.3212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eae2f3a5-765d-439d-ab4e-08df131b3fc9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9323

Hi,

This series by Yevgeny brings more misc improvements to the mlx5 HWS
driver.

Regards,
Tariq

Yevgeny Kliteynik (6):
  net/mlx5: HWS, Return meaningful error code in hws_send_wqe_fw
  net/mlx5: HWS, Fix error message in mlx5hws_cmd_generate_wqe
  net/mlx5: HWS, Replace kzalloc with kzalloc_obj
  net/mlx5: HWS, Add timeout mechanism to draining send queues
  net/mlx5: HWS, Handle timeout draining the send queue for FW STEs
  net/mlx5: HWS, Remove unneeded WRITE_ONCE in post send

 .../mellanox/mlx5/core/steering/hws/bwc.c     |  4 ++-
 .../mellanox/mlx5/core/steering/hws/send.c    | 34 +++++++++++++------
 2 files changed, 26 insertions(+), 12 deletions(-)


base-commit: 272a65db243bfa34b9277632830e0e06d7e3518e
-- 
2.44.0

