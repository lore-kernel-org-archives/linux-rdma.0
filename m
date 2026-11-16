Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825064;
	b=lnuQTPd/9W9oJkaxrFdDKYPmKHeneNFmk2D35v8jr8dVUhsLifU1bQOTK9ll2jzCD/m7
	 dOdRU1hjbA0YWdLHiRYkv62BPqDiwIBdHBtaTWfO25R2lQIFhmMWZrnI6COtnRATpyp6S
	 GB6S8g24CkveAPCoGg/hB7ir776WdzV9R0Ao1WcYcNNVZAevHBLVYIewpH/4P2cPYAfH8
	 2mVprIT8AbXi0Nj0TM1P+UTyIXBbJ5OUWE3y8iWHBn6KPXkPApIo8ezbIlwmHdFifdlMM
	 64zpyUcetZJ0wlIeRL6pPN3ZheiqVv8tPBAoQUMvEsd+UaFuI/tv+K1Fyb142/gfOew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825064;
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
	bh=GOHGmZtiiw07VbUp+Rf50d+1jiBIbqAYuM2Anocu/a8=;
	b=bfnn3HnZ2ZWh/nNdWRXlniguWn96eHuoKusWB0b/951xZaE6CXVEYnJ9nn18q9G3V8TK
	 N5rqcN8IElSLq2dgLD8SIBL8lQSWIQwN1yFOkFmcQJbbLm81eGwhX2mWWtceRRLGZtBAZ
	 IB2ZA7UY6GW5Dn3CRkeGx6IEsN9e+5XhQr9kENDAUC4/RTCR0m2KG529lv3iYIqaUUxFV
	 dxjfh7l+KKic0uA1PO8xYMlLGsSGEyPAnEV3qkAGrX/3hRVvPLYbJoQDOTByaZfbQ7GLI
	 +CeRHUr6BHPEbzhpQQ3KZVw/t1qITvwU99BLcFPWcFTBz9xrFlSf4t7FIng+UId8t3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AOIlMBSC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.67
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011067.outbound.protection.outlook.com [40.107.208.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34D606A336;
	Mon, 16 Nov 2026 10:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D34D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AOIlMBSC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scJQWzlSonPM7vJyBAMWY/nAVaxNbujpcu7Fyj+UxnxzMem8I9029Amnn+nZYj9MO2g8E3Cop8TudQAmW5J1M9MEdvAF/CTFAUAIpIpMX4g5lPiET5SVjRdDoROwLBfvJkODUGSDNAeMg3u3jATuzHrWe1lGzen+3Mwfu14nV1kWc4jEYGsC+VpeqVcsz9VWMyJYNkO5XnPUA//VSuM8e1EtBgaTK01QGwFFSg+eBBYDh757fUkAqzpuo9RtUBxXfMKuVe0NNCpSACjizURS/rMjqoxY0H9sgCl8eJP6QUl0i82h1j2UH4QPoX/NlxhgE/V7SDgCqw76xmujP/Uxlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOHGmZtiiw07VbUp+Rf50d+1jiBIbqAYuM2Anocu/a8=;
 b=BWRJYeyK/f91XPYB6tf64OhnuUHLf7r6iSffpRk2eGKEOO+QPoYYAxOKh0z9Nv0MStwpgGL1xZhoY6XhoEKBbYKTpll03g2EGGLWm/XtWW9f7KYEkNySgqwFK3ar0cw3Sv/ijnKaHYC/NqRY76SzugYp6PkCCA/e7BlhNcEZHTBqXqN+X0rV8MHyoPfK4BMib1J9HRzXwpif6vFU25p/RDd3B1Ed81g+KBTFvH7YVR4EtlNIGk3SWvYvCrxMEPSc2yYkOcGI3mpeW2Qzs9aBA0ZOQVq8l7r8fztVXJp7tWqvwxsdDLuolI5VOU0e4sp7Se3xhXhwxo4yRXEP052onw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOHGmZtiiw07VbUp+Rf50d+1jiBIbqAYuM2Anocu/a8=;
 b=AOIlMBSCWeILqvaVNGlIyE75bT/3c5gHkdPL7Zvfv1P+7BQXDRQHBpn2MrZRHbi8c5UpHv4KVCsqNfP2JBIrEBKW+oGc4NtTx0hoBOiincEFFktq2r94+peySqgJ5VDpC/A8OVh3PO0/ehlKIahY3/IJ1m9tmvQXIehOCNGG+cEGoyIlOKWfQGPPW3Vm5MAfYLzn9DX912eogU9YISvZ65AbIJ5sQ8/DgJq84aAX6baFT7wHttl6Szy1P2WQoTNijqDXhhCYAX7yD8nkXC0X4QmfmRGGYD2AjPevy5JfVG59SO5Dr02S+8ymWBbyzU5fPnptX9BbFeErQ6n5CW7AGw==
Received: from PH7PR17CA0025.namprd17.prod.outlook.com (2603:10b6:510:323::27)
 by DS4PR12MB442241.namprd12.prod.outlook.com (2603:10b6:8:506::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 10:30:58 +0000
Received: from PH4PEPF0000B60C.namprd21.prod.outlook.com
 (2603:10b6:510:323:cafe::63) by PH7PR17CA0025.outlook.office365.com
 (2603:10b6:510:323::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:30:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 PH4PEPF0000B60C.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:30:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:30:43 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 16 Nov 2026 02:30:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:30:37 -0800
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
Subject: [PATCH net-next V2 00/10] net/mlx5: LAG, preparations for LAG over VFs/SFs
Date: Mon, 16 Nov 2026 12:30:00 +0200
Message-ID: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60C:EE_|DS4PR12MB442241:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3c57b5-622c-46f7-8b8b-08df43ccb3dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|10067099003|56012099006|5023799004|11063799006|261026130827099003|261026121527099003|261026140227099003|261028144727099003|261022115727099003|261021135927099003|261021130227099003|261022113327099003|261021121427099003|261022075727099003|261021123027099003|261022105027099003|261102123227099003|261009223027099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	RYUnfNXAtYr6qdWEJKep18g3o9g0fhs71v3oy3fWUfI0g575foOWh3Gpg3jgVG7OTRboDpUAoftzz/odV9tNxx4Or+DrG8tcE6PTvyTbyw+REvtCiJc4tYwNVRsus8up7maTgBALg9lQoEFrHlTkuN1o+p0XYr2oX1h6j1OS/KqmZou1pAIEvPTJZ17d/JBQxH+vzT1z7J08hzhYzf8eTtbAsH0hFDNx5wbuqHaSs0vhQV9moAvs97ymhLSGmTHlLpjLEU5kIKypFNvHVVL1tn1fvwKWi1LqMQyW/BcOCaZ8u2/ZozVFSOrvUgcruPnbll0tgMn/eJ7sXJmbaPB/Sq3filwIMCAj5fFyfbZAhLh+MVQXNlGvBmQzAlmOXhVrbR4ho5diT+3dXzLeF6MH82FO2vRVa/gVB77vF/WDIwmM2Pp7rzKdTKlpffv+D8iKVdc4ruLjyD2cDmNHAFwHRKO3GtBcSJoDIGCmSrh66DS+tPdJn5xX5FPi6fFzZJmQQIKOvbh/zZr6NrQNWlRepfD83MpGmHO7D1Q19kmZtR7OiBOtJJ9wwdmDDygycVuoffnxrcjGYmmpCnreqf23+9slypSUIf1E+9AaPQCr78L0x9EJ5WWSEFa2jbaGr/upCglPctLVzdUPH9bHb7E5zc0D/h2J+LNqH64gD5IdxuHRvQj5OfHq8Wyc+sqLWHUwHGejQrkx7L33Ns/xT3DBXw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(10067099003)(56012099006)(5023799004)(11063799006)(261026130827099003)(261026121527099003)(261026140227099003)(261028144727099003)(261022115727099003)(261021135927099003)(261021130227099003)(261022113327099003)(261021121427099003)(261022075727099003)(261021123027099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TXbQ1EVNWmvLA70dmf5e5AHotBvdBk3wcGlSApMYJXbHq6+mg2YGbPGbSQRFX5ka2/oJugsIciKSsY7rNUMs7g6IYrAvTxo4sIo4PZHQQfNGbou7DKKyMe2e8PwyJcrq/oa0jrxQperYZyClKJbF+OArPKdxwXzyVyYQc+RdfUuZgLwLYxTzkZLVaRinXALduhH/LO6zLGJBq8AZ3cGv0XRTpFQFsMSchfF9+v8olpV2GcyQriwehTJ+VspxS0eP8VkSBPkBJiiHfy8v6aI15BaU97A4m6MFHwhsUD1XDjfY72uU8GfhrkWwQ7mjcR18LZjk1t1UeO47PFswTg+jyj7pThqF7+bTX1raDeogPRmIqtH8miLPeLHeCbruaOVMucV51JWVMtbuB4l7dP6txCTmI5QFbKlDcLNTMLv/v1KPQuqESdvk0QBaG6zBQlAF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:30:57.8987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3c57b5-622c-46f7-8b8b-08df43ccb3dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB442241

Hi,

This series by Shay is the first part of enabling a LAG over functions
that do not represent a physical port - a "virtual LAG" (virt LAG) of
VFs or SFs acting as nested e-switch managers. New FW lets a VF/SF front
the physical uplinks through a multi-uplink e-switch; such a function
reports num_lag_ports < 2 and drives port selection via the e-switch
(port_select_eswitch) rather than the HW port-selection flow table. A
virt LAG is therefore a software-managed, shared-FDB MPESW LAG: the
driver builds the LAG demux and vport-LAG in software.

This part prepares the LAG core. A follow-up series adds the e-switch
and representor support and the patch that admits a virt LAG; until then
no ldev is marked as a virt LAG and the virt LAG paths added here are
unused.

The patches fall into two parts.

LAG code cleanup (patches 5, 6, 7, 8, 9)
  - Finish removing the fixed MLX5_MAX_PORTS sizing the first series
    began: convert the remaining structures to dynamic, port-count-based
    allocation and inline iteration. A virt LAG's member count is
    unrelated to the physical port count.
  - Rename the LAG "pf" naming to "fn", since a member is now any
    function (PF, VF or SF), not necessarily a PF.
  - Resolve the queue-affinity member indices only in that mode, so the
    other port-select modes are not rejected for indices they never use.

Virtual LAG core (patches 1, 2, 3, 4, 10)
  - Distinguish VFs/SFs from their PF in the SW system image GUID, so
    they group into their own LAG instead of with the PF.
  - Select the MPESW master from the live member snapshot: VF/SF members
    are dynamic and not marked by the devcom PAIR event, so the master
    is chosen from the current membership (tie-broken by PCI BDF for
    VFs, sfnum for SFs).
  - Skip the phys-LAG prerequisites (port_select_flow_table,
    create_lag_when_not_master_up, ...) for a virt LAG, and require
    port_select_eswitch instead.
  - Treat a virt LAG as a software-managed LAG (demux + vport-LAG in
    SW).
  - Do not add a device to an already-active virt LAG.

Regards,
Tariq

V2:
- Split the patch set to ease the review: this is v1 patches 1-10; v1
  patches 11-15 will be sent as a follow-up series.
- Patch 1: define mlx5_virt_lag_is_supported() in
  include/linux/mlx5/driver.h, so mlx5_ib can use it in the follow-up
  series.
- Patch 3: fix the commit message: a LAG of VFs/SFs still issues
  CREATE_LAG, but a VF/SF issuing it does not create a LAG of physical
  ports (Sashiko).
- Patch 10: retitled, and the commit message says the rejection applies
  only to a virt LAG, and why the other join paths are safe (Sashiko).


V1:
https://lore.kernel.org/all/20261103171009.563034-1-tariqt@nvidia.com/

Answers to sashiko comments on v1:

net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping

  Q: A VF/SF that reports multi_uplink_eswitch, lag_master and
  num_lag_ports < 2 now gets a key that differs from its PF's key, and
  mlx5_same_hw_devs() requires the keys to match exactly. Does this break
  PF to VF/SF same-HW detection, e.g. mlx5e_tc_is_vf_tunnel() and mirred
  offload in NIC mode? Should mlx5_same_hw_devs() use a key without the
  VF/SF markers?

  [SD] No, this is the point of the patch. A VF/SF that reports
  multi_uplink_eswitch and lag_master (and num_lag_ports < 2) is a nested
  eswitch manager. That makes it a different switch domain from its
  PF, not one more vport of the PF's FDB, so it must not be identified as
  the same HW as the PF. Without the marker it would also be grouped into
  the PF's LAG, which is what the patch prevents.
  A VF/SF that does not report these caps, i.e. every VF/SF that exists
  today, keeps its key unchanged and is still the same HW as its PF, as
  the commit message says. Dropping the markers inside mlx5_same_hw_devs()
  would make a nested eswitch manager the same HW as its PF again, i.e.
  undo the patch.

net/mlx5: LAG, skip phys LAG prerequisites for a virt LAG

  > +	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
  > +	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_eswitch) ||

  Q: mlx5_virt_lag_is_supported() does not check port_select_eswitch. A
  VF/SF that reports multi_uplink_eswitch and lag_master but not
  port_select_eswitch would get the VF/SF marker in its SW GUID and join a
  virt ldev, yet MPESW could never be enabled on it. Should
  port_select_eswitch be checked in mlx5_virt_lag_is_supported() instead,
  so the two checks agree?

  [SD] The two checks are at different stages on purpose. A function with
  the first two and without the third doesn't exist.
  Even if it were, the result is benign: the function stays an inactive
  member and esw_multiport fails cleanly with -EOPNOTSUPP, nothing else
  changes.

net/mlx5: LAG, treat virt LAG as a software managed LAG

  > -static int mlx5_lag_is_sw_lag(struct mlx5_core_dev *dev)
  > +int mlx5_lag_is_sw_managed(struct mlx5_core_dev *dev)
  >  {
  > -	return mlx5_lag_is_sd(dev);
  > +	struct mlx5_lag *ldev = mlx5_lag_dev(dev);

  Q: If dev is NULL, does mlx5_lag_dev(dev) NULL-deref dev->priv.lag? When
  called from mlx5_lag_multipath_check_prereq() via the FIB notifier,
  pf->dev can be NULL due to concurrent removal in mlx5_ldev_remove_mdev().
  __mlx5_lag_is_sd() was safe (lockless pointer compare). Does this need a
  NULL check?

  [SD] mlx5_lag_is_sw_managed() assumes a valid dev pointer, like the rest
  of the mlx5_lag_is_* APIs. It is true mlx5_lag_multipath_check_prereq()
  can provide an invalid device pointer, but that is an existing bug there
  which should be handled in its own patch.

net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS

  > -		if (i < MLX5_MAX_PORTS) {
  > +		if (i < ldev->ports) {
  >  			slave = bond_slave_get_rcu(ndev_tmp);

  Q: Should this compare against ldev->max_funcs, like the other converted
  call sites? A PORT-marked member can sit at an index in
  [ldev->ports, max_funcs) if more PFs than num_lag_ports join the ldev
  and a lower-index one is removed later. Physical ports also share the
  xarray with VFs/SFs. Wouldn't that leave the bond silently not
  offloaded?

  [SD] No. mlx5 creates an ldev per sw_guid, and PFs have a different
  sw_guid than VFs/SFs, so only PFs share this ldev. The only case with
  more PFs than num_lag_ports in one ldev is SD, and for SD the netdev
  notifier, and with it mlx5_handle_changeupper_event(), is not
  registered. So a PORT-marked member here always sits at an index below
  ldev->ports.

  > -	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
  > +	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),

  Q: Physical members and Socket Direct secondaries share the xarray index
  space. Can a physical member get an index >= MLX5_MAX_PORTS and make
  mlx5_ldev_add_netdev() write beyond tracker.netdev_state[]?

  [SD] Such HW doesn't exist; it needs LAG over SD with more than
  MLX5_MAX_PORTS / 2 ports, and when it does MLX5_MAX_PORTS will be
  increased. To protect a new HW running an old driver, a check that
  num_lag_ports times the SD group size fits in MLX5_MAX_PORTS will be added
  to mlx5_lag_is_supported() separately.

  Q: Can removing the xa_alloc() limit let member indices reach 8 or more
  while pf_metadata[], devs[], the cong counter array,
  tracker.netdev_state[] and the port_sel rules[] are still sized
  MLX5_MAX_PORTS? Could the limit stay at MLX5_MAX_PORTS - 1 until all of
  these users are converted?

  [SD] No. In this series a 9th member is impossible: an ldev holds only
  PFs and SD secondaries, and no HW has more than MLX5_MAX_PORTS of them.
  VFs/SFs join an ldev only in the follow-up series.
  The limit can't be kept until all arrays are converted, since not all
  of them will be. Some arrays are used only by a PF LAG, others by both a
  PF LAG and a virt LAG. The shared ones, the fns xarray included, are
  converted in this series (pf_metadata[] and devs[]; the cong counter
  array is converted as well). The PF LAG only ones,
  tracker.netdev_state[] and the port_sel rules[], keep their static
  MLX5_MAX_PORTS size: they are walked only over PORT-marked members, in
  the hash and queue affinity modes. A virt member is never PORT-marked
  and sits in its own ldev, and a virt LAG supports only MPESW, so these
  arrays never see more than MLX5_MAX_PORTS entries.

  > +	/* max_funcs is the iteration ceiling; grow it, never shrink. */
  > +	if (idx >= ldev->max_funcs)
  > +		ldev->max_funcs = idx + 1;

  Q: Is this store safe against readers that only hold lag_lock?
  mlx5_lag_get_next_peer_mdev(), mlx5_lag_get_slave_port() and
  mlx5_lag_query_cong_counters() read max_funcs more than once per walk,
  so a concurrent add could make the sentinel and the loop condition
  disagree, and the body could see a pf whose dev is not set yet.

  [SD] all the readers above running only while LAG is active, and
  mlx5_lag_query_cong_counters() and mlx5_lag_get_slave_port() check
  whether lag is active explicitly before walking over the lag

  > -								   ldev->ports);
  > +								   ldev->max_funcs);

  Q: The commit message says "No functional change". Is that accurate?
  max_slaves sizes the master's egress ACL, so the size of the hardware
  flow table changes whenever max_funcs != ports.

  [SD] Only the ACL size changes, and only for SD, where more PFs than
  ports join the ldev and max_funcs > ports. The rules installed are the
  same as before, so there is no functional change.

  Q: end_flow_index is inclusive, so the master egress group spans
  max_slaves + 1 entries in a table created with max_fte = max_slaves.
  If max_slaves equals a flow table pool size, e.g. 128, can the group
  creation fail?

  [SD] This is theoretical only; there is no such use case. In this
  series max_slaves is at most MLX5_MAX_PORTS, and the table is rounded
  up to 128 entries, so the group fits.

  Q: The patch also changes the xa_alloc() limit in mlx5_ldev_add_mdev(),
  which now accepts a 9th member, and the found check in
  mlx5_handle_changeupper_event(), which now uses i < ldev->ports. Could
  the commit message describe these changes?

  [SD] The xa_alloc() change is already in the commit message ("remove the
  xa_alloc() limit of MLX5_MAX_PORTS"), and the answer above explains why
  it can't let in a 9th member.
  mlx5_handle_changeupper_event() runs only for a PF LAG without SD: the
  netdev notifier is registered only when !mlx5_sd_is_supported(). There
  each LAG port is one PF at an xarray index below ldev->ports
  (num_lag_ports), so "i < ldev->ports" is true in exactly the same cases
  as the old end-of-walk check.

net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation

  > +	ldev = mlx5_lag_dev(dev);
  > +	num_ports = ldev ? max_t(int, ldev->ports, 1) : 1;
  > +	mdev = kcalloc(num_ports, sizeof(mdev[0]), GFP_KERNEL);

  Q: Could mlx5_lag_query_cong_counters() keep a freed ldev across this
  sleeping allocation if teardown removes the association and drops the
  last LAG reference before the query resumes?

  [SD] No. The query runs on the IB device of dev, and dev leaves the LAG
  only in its own teardown, after its IB device is unregistered.

  Q: Can this loop write past the end of mdev[]? The array has
  max(ldev->ports, 1) entries, mlx5_ldev_for_each() writes one entry per
  PORT-marked member, and nothing caps the PORT-marked members at
  ldev->ports. Should the loop break once idx >= num_ports?

  [SD] It can't. The loop runs only for a non-virt LAG, and the
  PORT-marked members of such an ldev are the PFs of one card, at most
  num_lag_ports == ldev->ports of them (an SD secondary is not PORT-marked
  and a virt member is excluded by the !ldev->virt_lag check right here).

  Q: Can mlx5_mpesw_metadata_cleanup() index past the end of
  pf_metadata[]? The buffer is sized by ldev->max_fns when MPESW is
  enabled, but sd_lag_init() can add SD secondaries afterwards and grow
  max_fns, and the cleanup loop stops at the current max_fns.

  [SD] this is pre-existing bug, MPESW should failed if SD Secondary
  is down. this will be handle in separate patch.

net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan

  > +	mlx5_lag_for_each(i, 0, ldev, filter) {
  > +		pf = mlx5_lag_pf(ldev, i);
  > +		...
  > +		mlx5_rescan_drivers_locked(pf->dev);

  Q: Is it safe to iterate the LAG PFs and deref pf->dev while ldev->lock is
  dropped?

  [SD] Valid. Membership can be removed by SD cleanup while ldev->lock
  is dropped; this will be fixed in a separate patch.

  Q: Does using the sparse XArray index directly as a dense-array index
  cause OOB writes elsewhere? With Socket Direct the XArray index (i) for a
  primary port can exceed ldev->ports, and it is used directly in
  mlx5_infer_tx_affinity_mapping() (ports[idx]) and
  mlx5_handle_changelowerstate_event() (tracker->netdev_state[idx]) - could
  these overflow the heap/stack buffers?

  [SD] All these buffers aren't used in LAG over SD; only MPESW is, and
  MPESW doesn't use these APIs.

net/mlx5: LAG, do not add a device to an already-active virt LAG

  Q: After this change only -EOPNOTSUPP is final. Every other error from
  __mlx5_lag_dev_add_mdev() is retried with no limit. xa_alloc() returns
  -EBUSY once all 255 slots are in use, and membership does not change
  while the probe waits. Can mlx5_load() loop forever? Would it make sense
  to retry only on -EAGAIN?

  [SD] This is pre-existing: mlx5_lag_add_mdev() retried every error
  before this series as well. for example future HW can return -EBUSY.
  The fix will be sent as a separate patch.

Shay Drory (10):
  net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG
    grouping
  net/mlx5: LAG, select the MPESW master from the live member snapshot
  net/mlx5: LAG, skip phys LAG prerequisites for a virt LAG
  net/mlx5: LAG, treat virt LAG as a software managed LAG
  net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS
  net/mlx5: LAG, rename PF naming to fn
  net/mlx5: LAG, resolve affinity indices only in queue-affinity mode
  net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic
    allocation
  net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan
  net/mlx5: LAG, do not add a device to an already-active virt LAG

 .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 568 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  62 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |  29 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 125 ++--
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   |   2 +-
 .../mellanox/mlx5/core/lag/port_sel.c         |  25 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  44 +-
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c  |  32 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  12 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  40 +-
 include/linux/mlx5/driver.h                   |  11 +-
 13 files changed, 573 insertions(+), 383 deletions(-)


base-commit: 7ccc5e05043b1bb84326b19a2b05938d8f7a2ae6
-- 
2.44.0

