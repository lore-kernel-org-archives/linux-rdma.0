Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161650;
	b=CqjeXC//gDi3Z5w4U+7UMJhBogBCyvwNyCXOs5NRVhZ32MdsL9i5hCW1+iUIrFsNB1hN
	 OUcHNI5LTv+phhGU4TvOMH/3LI1SR1N1AiGOaU2gO6fNvzKqAUya4f2CwSLHYBYWhqr1h
	 1KG0E3hthKU4qAQLLzh0PMItESTbjX1Gpk5/l114Ux2UZ38JvZZIS0tor1ox1XfmrWRgu
	 BgdAz1Jhh9iZKsf5q0u0f4168AKcqsMd+E9NJs4H2j+niAcSDR9H2Hh1Gw7AoigvSDDmI
	 t+GhIP8c+yPeYip4RlG3yYXMphu3P5K6rleAJSbDiv7II+DDM6xsJQVmIwJnjV2UOmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161650;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yJ+YnkDOSuy9ZnaojIayPWqgXwKu75oy+Q7tIExEnkQ=;
	b=oaDydAGgLfjY+mYLhDQheaJVtekurnfTUOawV2It+YaPaOqxXavsOtcx6vsNP79q0k1k
	 lEu/B/m7oGEWYDbdSGMg7vfkK+Hz6mOTseaSPoBgP1iY0qTAbMN1gQMM8tlYPV1iAnTcn
	 lKYtr/0FZ6yJSInxCaVDY9UHhpEejQqlTSy8iRtf8XI+NKyceMcjEhOnQnqXMgmTnLG6P
	 Mm6ZVhepkjB4EITfipJ6kBFmZAKKpOguVTJ0GYFmte2sNfyIbJdsZ0gnsgBrJWj9g5G8J
	 CkDNEEBnpKoBubhKGZZsY9ZLgKIs713EQHlTj5D8+bZw64hhLnSuGWnP6V59FHZhN/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FlLW5jAB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.61
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011061.outbound.protection.outlook.com [52.101.57.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A99606A325;
	Fri, 20 Nov 2026 08:00:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87A99606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FlLW5jAB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aHqM1DgNqok+YB9cx2gW6+dKfGtcRianKlRjX0vOTyIhutHUgp2niOTmwJKKcT23gBR1jPYdsy1Ey/mq5GVmLGVZNdYCSTDSr6QscURg7rR34WqqwfFQoxfZT6emo4uTEiuNgIbMMEQzk0H1qRj4Y+H5qyaRJ6fuRMWpsmcE5A56FSEmV10xau4smk9q4E1Js7kqOTaHVneFOQD4EaNfzajw0zq0DDNBG+m9MYtFKU1okPDeLrcQq7ldDHDSXv0C2UMHJt3I0B1vuvTLHrtiH9hEQyGDHmugzx90mdptOUSnZTuylRb2x2l3mtfU571hA5Ova72T/3tqX8BDPfN6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJ+YnkDOSuy9ZnaojIayPWqgXwKu75oy+Q7tIExEnkQ=;
 b=OGRes+ZFPcbptVK882aFKbkac7K9HVzfZtvWB4u3zaIXho2WDRliBXxPT/Tg7rEa4K5nWnJValVEzmCgjnyvEvLi6ySncuBewJw9WDBKPWAnYmg9hdbCxFnQxCO133SUCTiRxFYBNZzjZHAZg8fTAZYzmv8EidW1oLVe7wr/K8uDA3vk4IUWpq+slwoBOKQUqA8OsvWWlDPpNf3a0CVhE4wuafEAnOev3maQYcdG9FIE5RsPMmFvNJ5XU2WIbcVnPI8cVAvJkQD3EywTz+Cfwdc5IvRETH3aH0nPSs1u+rPIhNIVi4dqdCUT04CmCpBLFTg1eMqjOSze4pjzU7RGDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ+YnkDOSuy9ZnaojIayPWqgXwKu75oy+Q7tIExEnkQ=;
 b=FlLW5jAB0qs2/06iv2KGXnnyK8NE0LX0DpSpfBkWjx9psKt3NPfbY2lKRhLDsw2UKOlsg34e9PP6pxLYs9YlKejX7JTyEZq57Igepbbq/wE86bXHtNbb39TmBcRkq1D6aIH9N5RSBjQ0HLwEMVWm1z+qDGrASvEFeeVhcaPaNC7+9lzmhwjxbFAcA3hQ03DQhTJuU7CMzhwdEea/jRhKbyI89JrwTFiKejoBNhlGhi57zncoroTKSIJls/1vmEqjfmnTOeu8OnoFgnLFwYJsj9E13mbaUySG6BHmQn3wmKPz30dZ33IE2CMTbskphWqeDA1L/YQF9AvHMK9nOB71+w==
Received: from CH5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:610:1f1::28)
 by MN0PR12MB5905.namprd12.prod.outlook.com (2603:10b6:208:379::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:00:42 +0000
Received: from BN2PEPF0000A805.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::8c) by CH5PR03CA0016.outlook.office365.com
 (2603:10b6:610:1f1::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:00:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A805.mail.protection.outlook.com (10.167.245.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:00:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:20 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:19 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:00:15 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 0/5] net/mlx5: LAG over VFs/SFs (virtual LAG)
Date: Fri, 20 Nov 2026 09:59:53 +0200
Message-ID: <20261120075959.2533702-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A805:EE_|MN0PR12MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ae4abf-cc22-4699-d870-08df46dc5f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|6133799003|18002099003|3023799007|13003099007|5023799004|11063799006|56012099006|261026121527099003|261026140227099003|261102123227099003|261028144727099003|261021135927099003|261021123027099003|261022115727099003|261022113327099003|261022075727099003|261022105027099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5RjULBAkHC8Mkn5nH6U5IDG/eEzsRhgYNaxTti0eHqRp99ndtNvTYrpfOTwhxAokgGzttFkqCOwoQtf+/fvgS9C1tgtQEzjHXGzP/hS0Wd5+ydg1uYfoNzRRNNp8i9H9u3FZWlDoEVbMnHYrLU/rEFqCF3VEi4gmAeCtYfF4tFW01v4mpenzp+KOLNKlOWEC6SHN6fZFPcvhdYGbLKo2yTXUWy2RQK94uemXvrdAM3ZsKT1d7tPKC+39chzOlieyuna19052zVT0afwm3n+4o1p63Rmjd/tMJ6tN2jmMmZ7QyhklAn1611XMGfPtBmEpdw3UipSj1L75IwPB1vkDTLGKvysWUY2ISgUgFGU1CP597nuq33ZYYiNvg9/JbD6/LlD1mwb4JJMFuhu4jBr7Cpnqa4On3X4JogtFQMUjWBl7Jk2VgsJFjsPyUFQ+nilBa8ByxuUKVidWE9Fsdu5RrC7PCo1w1kE3Xc8NxH+IyOtKLK1FxcfKmI2MIr+sLEfPCWaf3oPuKmSwJC0nuyIAgnIHRBeqd2UjgXtfu/JqJlCb5xDLqKYYNN0OBfSBXOB8cnR0ldqSnOtucMBCummNifpNqzF+s7kCU5iu6l6GQZj+I7R6Gw75cxj2yMpDOlOCm/R28x5brNk8KDAFhgQo6sW67DsCgveYT14wgIZ+8TtPSlvSS9C+80eS/SBBEke1Lh3z0rIbeGDemHyt9zt4pQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(6133799003)(18002099003)(3023799007)(13003099007)(5023799004)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(261021135927099003)(261021123027099003)(261022115727099003)(261022113327099003)(261022075727099003)(261022105027099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XFMoHiXCUoEu71HBUroFDkjkb2DOFH+Bb3L6XrJZaMHQGjl3Frc5ZeqxPSVBEj+6GBvfguqbwjeoVyak1SlWdGqHH7gs73jIxSntfDFYes2t1S/9dbWst0GZMzdWIcp12AfGZKieKMZSudpE1lxqA6NNuZgZ3JXsKgeum/d2l2Z3IT/aJhhqFExH09c7JkI9yQ2yImZTKdNWfAxc8Ojb3Zo8UUpyBqs5FFxjPJencwWvh/yhuIYkDjOYcjS9Z3izfiSHIX8pV+GlbRRnWAJ2vPn+QIMTk7emYC+EvpHmoUwO9v4Stney0erJ5Dbjq16g7ZvtxAI5JYAIYwXDdJYiLpARAo2xAcvUESfYZk6ZqGiJpKtFjPDpSFrLk/E/X/NTKtvZYW/J9FldlY5Ot+xKqfb1sLt0y6OM2X/gB4RUOUtXveTYoTeiU0MXPYpqvbkn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:00:41.6343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ae4abf-cc22-4699-d870-08df46dc5f72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A805.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5905

This is V2 of the top patches submitted previously here [1].

This series by Shay enables a LAG over functions that do not represent a
physical port - a "virtual LAG" (virt LAG) of VFs or SFs acting as
nested e-switch managers. New FW lets a VF/SF front the physical uplinks
through a multi-uplink e-switch; such a function reports num_lag_ports <
2 and drives port selection via the e-switch (port_select_eswitch)
rather than the HW port-selection flow table. A virt LAG is therefore a
software-managed, shared-FDB MPESW LAG: the driver builds the LAG demux
and vport-LAG in software.

It depends on [2] which prepared the LAG core.

The patches fall into two parts.

E-switch and representors (patches 1, 2, 3, 4)
  - A dedicated match-metadata allocator for nested VF/SF e-switches, so
    VFs/SFs sharing an FDB get unique source-port metadata.
  - Match the master egress bounce rule by vport metadata.
  - Drop the master egress rule while a software vport LAG is installed:
    the SW emulation is a rule in the slave's egress ACL and cannot act
    on a packet the master egress rule redirects after the FDB. Restore
    it when the vport LAG is removed.
  - Register a VF/SF e-switch-manager self-port with a switch-id so it
    groups with the representors it manages.

Virtual LAG enablement (patch 5)
  - Enable LAG over functions that do not represent a physical port -
    the gate that admits a virt LAG.

Regards,
Tariq

[1] https://lore.kernel.org/all/20261103171009.563034-1-tariqt@nvidia.com/
[2] https://lore.kernel.org/all/20261116103010.1129666-1-tariqt@nvidia.com/

V2:
- Split the patch set to ease the review: this is v1 patches 11-15; v1
  patches 1-10 are sent as "net/mlx5: LAG, preparations for LAG over
  VFs/SFs", which this series depends on.
- Patch 1: commit message describes which non-PF eswitches take the
  nested metadata layout, and no longer implies a PF may have the virt
  LAG capabilities. The reg_c_0 comment in include/linux/mlx5/eswitch.h
  describes the nested layout (Sashiko).
- Patch 3: commit message names the field ldev->max_fns, not
  ldev->max_funcs (Sashiko).
- Patch 5: do not assign an RDMA TX port affinity on a virt LAG capable
  function, and do not register the multipath FIB notifier for a virt
  LAG (Sashiko).

V1:
https://lore.kernel.org/all/20261103171009.563034-1-tariqt@nvidia.com/

Answers to sashiko comments on v1:

net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches

  > +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
  > +		return mlx5_nested_esw_match_metadata_alloc(esw);

  Q: mlx5_virt_lag_nonmember() is false when virt LAG is unsupported, so a
  standalone non-PF eswitch without virt LAG support takes the nested path
  and fails switchdev with -ENOSPC. Could it keep the PFNUM allocator?

  [SD] A non-PF eswitch manager without virt LAG support doesn't exist at
  the moment. FW doesn't expose such a VF/SF.

  Q: The nested allocator gives each eswitch 254 ids (2-255), yet a
  nested eswitch can enumerate up to max_num_sf SF vports, each taking an
  id. Also, LAG admission accepts slots 0-254, while the allocator gives
  no metadata to slots above 239. Can switchdev fail with -ENOSPC in
  either case?

  [SD] Both are theoretical only; there is no such use case.

net/mlx5: E-switch, match master egress rule by vport metadata

  Q: Is mlx5_virt_lag_is_supported() enough to decide on reg_c_0 matching
  here? Outside MPESW both uplinks share MLX5_ESW_METADATA_RSVD_UPLINK. A
  PF that reports the virt LAG capability bits and also supports SD would
  create a shared FDB with only the reserved uplink metadata in place. The
  commit "add match-metadata allocator for nested VF/SF eswitches" says
  PFs may have virt LAG capabilities.

  [SD] This is not correct, PFs cannot have virt LAG caps; FW exposes
  them only on VF/SF nested eswitch managers. The misleading wording in
  the "add match-metadata allocator" commit message is fixed in v2.

net/mlx5: E-switch, drop master egress rule under a SW vport LAG

  Q: If restoring the master egress rule fails in
  mlx5_eswitch_offloads_vport_lag_del_one(), only a warning is printed
  and the slave rule is removed anyway, so the slave loses forwarding.
  Should the error be propagated?

  [SD] If restoring fails, FW is dead, and the lost traffic is not the
  real problem at that point.

net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id

  Q: The only condition here is MLX5_ESWITCH_MANAGER(mdev), but
  mlx5_query_nic_sw_system_image_guid() makes a VF/SF id differ from the
  PF's only when virt LAG is supported. Can a VF/SF eswitch manager without
  the virt LAG caps give its uplink netdev the same phys_switch_id as its
  parent PF's switch? Should this branch set the switch_id only when the
  resulting GUID differs from the PF's?

  [SD] A VF/SF eswitch manager without the virt LAG caps doesn't exist. New
  FW will let a VF/SF be an eswitch manager only as a nested eswitch
  manager, and such a function reports multi_uplink_eswitch, lag_master and
  num_lag_ports < 2, so mlx5_query_nic_sw_system_image_guid() gives it the
  VF/SF marker and its switch_id differs from its PF's.

  Q: If the system image GUID query fails, the self-port is registered
  with an empty switch id, and nothing fixes it later. Should the error
  be propagated?

  [SD] This is the same behavior as the existing PF self-port path.

net/mlx5: LAG, enable LAG over functions that do not represent a physical port

  > -	if (group_id)
  > +	if (group_id || ldev->virt_lag)
  >  		return 0;

  Q: mlx5_lag_set_vports_agg_speed() iterates ports only, so a virt LAG gets
  no aggregate vport speed, and its members skip the port-change notifier.
  Is there an alternative virt LAG speed policy?

  [SD] This is on purpose.

  Q: members_show() uses mlx5_ldev_for_each(), so the debugfs members file
  is empty for a virt LAG. Could it list all members?

  [SD] Left as is for now, since all VFs in the system share the LAG.

  > -	if (!mlx5_lag_is_supported(dev))
  > +	if (!mlx5_lag_is_supported(dev) && !mlx5_virt_lag_is_supported(dev))
  >  		return;

  Q: mlx5_virt_lag_is_supported() checks multi_uplink_eswitch, lag_master and
  num_lag_ports < 2, but it does not exclude PFs with mlx5_core_is_pf(). Can
  a PF with these caps also get here? Such a PF would keep the plain PF
  devcom key and get an ldev with virt_lag = true. Should this gate exclude
  PFs as well?

  [SD] No PF has these caps. FW exposes multi_uplink_eswitch together with
  lag_master and num_lag_ports < 2 only on the VF/SF that acts as a nested
  eswitch manager, so mlx5_virt_lag_is_supported() is a pure capability
  check on purpose, with no is_vf()/is_sf() in it. The !mlx5_core_is_pf()
  tests in eswitch_offloads.c select an id layout for non-PF eswitches;
  they don't mean a PF can be virt-capable.

  > +	err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
  > +		       GFP_KERNEL);

  Q: mlx5_virt_lag_is_supported() has no limit on the number of members.
  Once 255 fns exist, the next xa_alloc() returns -EBUSY, and
  mlx5_lag_add_mdev() only bails out on -EOPNOTSUPP. Can the 256th
  function keep retrying inside mlx5_load() forever?

  [SD] The retry loop is pre-existing: mlx5_lag_add_mdev() retried every
  error before this series as well, and no HW exposes this yet; -EBUSY can
  only be returned by future HW. The fix will be sent to net as a separate
  patch.

  Q: mlx5_ib_modify_dct() picks the DCT port with get_tx_affinity_rr()
  whenever mlx5_lag_is_active(), bypassing
  mlx5_ib_lag_should_assign_affinity(). If mlx5_eth_lag_init() left
  lag_active unset, e.g. without a LAG flow namespace, the divisor is
  num_lag_ports, which is 0 on such a function. Can this divide by zero?

  [SD] This is theoretical only; there is no such setup.

  Q: end_flow_index is inclusive, so the master egress group spans
  max_fns + 1 entries in a table created with max_fte = max_fns. With
  max_fns == 128 the table is exactly 128 entries. Can the group creation
  fail?

  [SD] This is theoretical only; there is no such use case.


Shay Drory (5):
  net/mlx5: E-switch, add match-metadata allocator for nested VF/SF
    eswitches
  net/mlx5: E-switch, match master egress rule by vport metadata
  net/mlx5: E-switch, drop master egress rule under a SW vport LAG
  net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id
  net/mlx5: LAG, enable LAG over functions that do not represent a
    physical port

 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |   5 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   3 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 150 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  49 ++++--
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |   4 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |   6 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 include/linux/mlx5/eswitch.h                  |   4 +
 9 files changed, 185 insertions(+), 40 deletions(-)


base-commit: 2208ab00f4f213ade91ab775e7f8c4dacdcc856e
-- 
2.44.0

