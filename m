Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725874;
	b=w0dioQdW+2ZYxzaRKdQ513EFLuVlLoaSJEQgG52zAC+AG/J0JyvUv9W9vdMHqQMGqicJ
	 pouaAAb2TsBsjX/At+v+62uBhiudwAXjrXFufqcGYrtyYpCdDjviIDwR+l7Xa/vIi9zRc
	 EPOjXbkQbDOeTJkMDwkxvuuVA58/ddCwWnAzGlVK05QrBW/dJC2ya+xouIJw/z6O5/sCC
	 4Fj4KJzoSpPKpFFv0DnMqdivvgSZ+vU6cCecC06sk0VBF9XknSP64AxcFE4030MLbmIt/
	 R9EsCY1wp90uN512LrxhQeulQ2icEM9zCmoTXUK3UL2RcT4MJ+TfF/4i+UxNTvVSrXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725874;
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
	bh=5ojNXXzsaAVnGuOazKNdWkLSMu1dLf8xkuGz4TnRVkg=;
	b=JJSt95TORQjz/Etuv6dLdLK1sPk/HLQjCj5QSMkIQlOi1zCvLRtC0sKCfZoumHENTv4I
	 r+dNvCajqiBwG73MA92Z1bKLMaxEToh5xdJ9pa8ze4/67NqTXASS3lGKbPggTzaq2cDqx
	 rkjIfKbqMjNC00fYTzHX4fpIE4GIC/UBchl8FcrPB9z57ZaWeKRg7JKGklP+EOStOuiSK
	 Lz9ALyRbkOHZcPI8n/zIY/fFIiFiGy2/azCh888GrTrHTqb5hONsnDJ8TLnI3J8xRqG0B
	 i+YFn93flEUwlXkqDWWWrAqAIzUO88GJWHotbLww7pf9MAKIK6pzCi1xRK2Nhh5dZsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GOriqKtj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.38
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1856B606A330;
	Tue,  3 Nov 2026 17:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1856B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GOriqKtj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VxJb3HZqL4qGAADzVc6xFUax7IYTQ3bphNqxm5xGQehWuYV7gnCRAnff+zPNIJgBvwCqsVBxJ0WMeFHz2/rU9D97KagJite++ToGsK4BXOqhAZ5AJIQcr2ZsPNXF9Uv4DyA3wMr2zDgdasE0o676CQHUDz1ToBNG+yU7dvJa+qeLA02uDDimBsJ/yfORYX0aE7sC6jEMbAYEfks6GwPQIYMBFEkfc7i3DoikB4ol6Hwn3r/g4aS4rGu4vVzV/s8wURQFHJ4/lYzNjNoOhsm21ayV6swP4nUlST4U00Dgy26vJByng6t5tNa5MztkZHA772gPsSJBV0l3PzEk91pQgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ojNXXzsaAVnGuOazKNdWkLSMu1dLf8xkuGz4TnRVkg=;
 b=ZMPghf435FwSaa1TfjXiAAQh337Td/EOr560L2mqHilfs5zRDS22rgBlERbhlDxjTyLE9etiPeOTNhp59lJFrdVX2bQvjoO/JfJI02BzO9AhCIS/Vh5z5jKskfQc7rs9XjhF1+15wLa//5jHhQv0EGA1HArbJDa0cy9m6fNUpof5JQtAfLOL6BXkfGIkCAV5tME8FlB+crD42FSkRv81zsCe2SYZ0yk8N11hZFWgLA8yp0HHgPnoTVC5nXJwvVrBG43Vr82bE8dZU75bdeGyHlBe3e+i9krc2bfoU8eith/nIlpCveWvt+sfjQPyCkH7gDvy1d4MZBYr4hzizOq1dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ojNXXzsaAVnGuOazKNdWkLSMu1dLf8xkuGz4TnRVkg=;
 b=GOriqKtjyHnrRBKpayYtGDI/UeiFOfUC5Gln9Nraifh4sQfGz0fGuzgwqNcEckcmkDDSO6SRENnM1PwVpWAZ+MVUl0TZB1yNhjCBKGvga64JmDwmc8KUbKUEMj21Ars0HvxQXWiv6uvg1gv52yc5neFJm21Q2P5gCjKCx5ijuHSQX4bdueYvMu1MsjGUG00f44TNsV1Y+tEwfDidOmnKc2HIuFE5RqHXXg0sgKxFvGjS+ro8xWMl3JkA3+ERYEHz/8v5+ASsJNegoYATiDfpicNbB50ZWlpXxnfROlZCMIeB/YobeTdQntU+O2dH8TC2Rfx64dOQac15VffwWzZ2Tw==
Received: from DS7P220CA0079.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:259::11) by
 IA1PR12MB7757.namprd12.prod.outlook.com (2603:10b6:208:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:11:06 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:8:259:cafe::9a) by DS7P220CA0079.outlook.office365.com
 (2603:10b6:8:259::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:11:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Tue, 3 Nov 2026 17:11:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:10:35 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:10:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:10:30 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/15] net/mlx5: LAG over VFs/SFs (virtual LAG)
Date: Tue, 3 Nov 2026 19:09:54 +0200
Message-ID: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|IA1PR12MB7757:EE_
X-MS-Office365-Filtering-Correlation-Id: 48e0c6d9-f2ae-4377-eae2-08df39cd720f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|6133799003|10067099003|18002099003|261102123227099003|3023799007|261009223027099003|56012099006|261028144727099003|11063799006|261022105027099003|261022075727099003|261022115727099003|261026140227099003|261022113327099003|261026121527099003|261026130827099003|261021121427099003|261021130227099003|261021123027099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	ArXIqmWT6Oi3Y6x1kE9nBYlFalTTIeAGBrBOV8qKgtyKmoRZXQbqFLuVQLbhRsfvFAwHLisW1fszEJR/SU1cODarn+dz/8XpJUiuhg2rU2NMhEaoxFdJzxtqdqCQsSE5DgOIYB0+jb3AJRBtsE8/H9gDkBcFN/cW5kCyfOfjpEEly6YLPA3Mar/MGXJ3MQV166EZQcfpuod56IK3b4EPsDJGwFruPtVp1S9LRc7Zcok3LD6mjJro/cgAArVSFu7qrEcH3ZXXswtpHGNREs0MBWWg2A02dmR9P5UmGoZGDHlCfNnW4pmxjgTtBsQwQQgd1nshFLAOZQKvlRWiZdytRi6hLVzWptAprsWNy3w2vzNGPdPmDXejW8gYKwqI8RoU/hMVO1vTQIJGw7ZNj6mMEweZfnfhixRRvh//l6tUwH6wTP049yBCtbu7y+zpGI1wQ1By3U4lCMx1nvePbzbQNaw97gJZ7l2rZS2N9MoKa20Kz5SHP51Hci1TYUqwZ7pTBRf4JOGH57FnU2Y/k4aYczd6ii4/St7H5UrTH+3+1rAglVBMX7FWVYfQHPuCgpPnvQ+tW6T3T13wNrOjJ9Jeq3ZmVwINzMRxfUMYj+eR93EQTEdbDWgQc0X89c5hrdQJ6exRJs739bLaCdJNu5/rHyLbhHWXbRa85rHNZHAURGuUzReHsoVpH/4Bgq6zZlQGnkc8Mhz1xnC6ejNQQjGkDA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(6133799003)(10067099003)(18002099003)(261102123227099003)(3023799007)(261009223027099003)(56012099006)(261028144727099003)(11063799006)(261022105027099003)(261022075727099003)(261022115727099003)(261026140227099003)(261022113327099003)(261026121527099003)(261026130827099003)(261021121427099003)(261021130227099003)(261021123027099003)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Wl3sTlZoyVuCvyMphEXwcEF7mnm3dvUvmGTKF7+LKr0M+4Wc5PBTUOKvBuIKG+rKXbvK3HLtAKojmbIJPTAK7MWLUOdmtf/esXP53WgPRA745Zh+ksqmuly0tjZf2Lw8tP5n2LsIH5NEykI1yPg2MRCJY2QySwvk01RQi2GPb+wq1xaQUQdJg+ZbUO2kK/C+fe8TJN6tJjWYMkvksMStgj9MlYCPsSEX9hP1q6GFGVh1eN9INMCXTz2bE7A35NYhYl/tBAvMLwyYGWi5hKJIyLpUC7KzlC57RVj4GqCUxMP/xizD1JGT/zYf8dvfxpeXQfBwnlkpPhCDu43lcjX9FSs4w8qSMdvNn6u0kI38OKbUyBrRSrzgc6sS9eaIqDJeE3xwGeAQxciG/HEOrPTgOPkJkmA8a5O15IaG6tg84RCmiT6GRZu0mretAY8cEDd3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:11:05.3276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e0c6d9-f2ae-4377-eae2-08df39cd720f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7757

Hi,

This series by Shay enables a LAG over functions that do not represent a
physical port - a "virtual LAG" (virt LAG) of VFs or SFs acting as nested
e-switch managers. New FW lets a VF/SF front the physical uplinks through
a multi-uplink e-switch; such a function reports num_lag_ports < 2 and
drives port selection via the e-switch (port_select_eswitch) rather than
the HW port-selection flow table. A virt LAG is therefore a
software-managed, shared-FDB MPESW LAG: the driver builds the LAG demux
and vport-LAG in software and skips the FW LAG commands.

The patches fall into three parts.

LAG code cleanup (patches 5, 6, 7, 8, 9)
  - Finish removing the fixed MLX5_MAX_PORTS sizing the first series
    began: convert the remaining structures to dynamic, port-count-based
    allocation and inline iteration. A virt LAG's member count is
    unrelated to the physical port count.
  - Rename the LAG "pf" naming to "func", since a member is now any
    function (PF, VF or SF), not necessarily a PF.
  - Resolve the queue-affinity member indices only in that mode, so the
    other port-select modes are not rejected for indices they never use.

Virtual LAG core (patches 1, 2, 3, 4, 10, 15)
  - Distinguish VFs/SFs from their PF in the SW system image GUID, so they
    group into their own LAG instead of with the PF.
  - Select the MPESW master from the live member snapshot: VF/SF members
    are dynamic and not marked by the devcom PAIR event, so the master is
    chosen from the current membership (tie-broken by PCI BDF for VFs,
    sfnum for SFs).
  - Skip the phys-LAG prerequisites (port_select_flow_table,
    create_lag_when_not_master_up, ...) for a virt LAG, and require
    port_select_eswitch instead.
  - Treat a virt LAG as a software-managed LAG (demux + vport-LAG in SW).
  - Do not add a device to an already-active LAG.
  - Enable LAG over functions that do not represent a physical port - the
    gate that admits a virt LAG.

E-switch and representors (patches 11, 12, 13, 14)
  - A dedicated match-metadata allocator for nested VF/SF e-switches, so
    VFs/SFs sharing an FDB get unique source-port metadata.
  - Match the master egress bounce rule by vport metadata.
  - Drop the master egress rule while a software vport LAG is installed:
    the SW emulation is a rule in the slave's egress ACL and cannot act on
    a packet the master egress rule redirects after the FDB. Restore it
    when the vport LAG is removed.
  - Register a VF/SF e-switch-manager self-port with a switch-id so it
    groups with the representors it manages.

Regards,
Tariq

Answers to sashiko comments:

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

  Q: Could this loop-termination change break LAG activation, since
  physical ports share the XArray ldev->pfs with VFs/SFs?

  [SD] No. mlx5 creates and populates an ldev per sw_guid, and PFs have a
  different sw_guid than VFs/SFs. Hence PFs cannot share an ldev with
  VFs/SFs.

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

net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation

  > +	ldev = mlx5_lag_dev(dev);
  > +	num_ports = ldev ? max_t(int, ldev->ports, 1) : 1;
  > +	mdev = kcalloc(num_ports, sizeof(mdev[0]), GFP_KERNEL);

  Q: Could mlx5_lag_query_cong_counters() keep a freed ldev across this
  sleeping allocation if teardown removes the association and drops the
  last LAG reference before the query resumes?

  [SD] No. The query runs on the IB device of dev, and dev leaves the LAG
  only in its own teardown, after its IB device is unregistered.

net/mlx5: LAG, Drop MLX5_MAX_PORTS scratch array from device rescan

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

net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches

  > +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
  > +		return mlx5_nested_esw_match_metadata_alloc(esw);

  Q: mlx5_virt_lag_nonmember() is false when virt LAG is unsupported, so a
  standalone non-PF eswitch without virt LAG support takes the nested path
  and fails switchdev with -ENOSPC. Could it keep the PFNUM allocator?

  [SD] A non-PF eswitch manager without virt LAG support doesn't exist at
  the moment.

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


Shay Drory (15):
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
  net/mlx5: LAG, do not add a device to an already-active LAG
  net/mlx5: E-switch, add match-metadata allocator for nested VF/SF
    eswitches
  net/mlx5: E-switch, match master egress rule by vport metadata
  net/mlx5: E-switch, drop master egress rule under a SW vport LAG
  net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id
  net/mlx5: LAG, enable LAG over functions that do not represent a
    physical port

 .../ethernet/mellanox/mlx5/core/en/devlink.c  |   5 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   3 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 154 ++++-
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 604 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  71 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |  29 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 129 ++--
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   |   2 +-
 .../mellanox/mlx5/core/lag/port_sel.c         |  25 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  50 +-
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c  |  32 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  |  12 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  41 +-
 include/linux/mlx5/driver.h                   |   2 +-
 16 files changed, 744 insertions(+), 418 deletions(-)


base-commit: 7b6ab4dbc156e2f96419715130b3d5738a306c93
-- 
2.44.0

