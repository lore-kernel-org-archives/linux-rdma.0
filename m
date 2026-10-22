Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697516;
	b=TZCDw3Nks+gMmaXXylw83hAvBJs/arc2Ix/D/OCz26jcXBqy4GCi8qdVO8gQg4rnIksP
	 8gqrpoyYBlszMlJII1tPy0CwNR6PJxJbrj14pLnlmP3IUgOJVSHlrM79bjVoijnfHrhbd
	 KoPPoplfBaDo6E5u5MkacBLYeImuQJ49bMpxzRbV75ASui3pWbVapm4yM/WPo07EroizG
	 Z92YTnFj0Z1KsXUFflWBAk6ZlYB8M1Yrc8GtRydz9mrb61VTO4i2X53au+fLqCF5MpjTj
	 GUXEENFtABSbC1V0c3LpdRa36jds7Qc6/hNy5KkDgEi6smrztz7Rg6JD1ZDln+M4MXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697516;
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
	bh=oGiYp7iSAM1dtsGEORn4JyEe/gWZ0FoeMthNEME1xIs=;
	b=VoO1yZ0hhSho1MGpwWLwlYxV6KMMmr2r4d+Si6I5OZFF4+ISBnlsA44eB+V2l90Xyu+Y
	 dJuSQgymuV37SKfgnMCYRt3i9QeT1lLByd1azcJC/ErJjGGX6o9LJ+WUz/GvkKyZtHXyd
	 YCQjJTzbCJ6MrTbt+2iV/jfpixQugifz1GWCY2/TxL7XEyUD2uvGUKkPqGQ9aahjyNPbX
	 tvx0BTdJ0VCXzp/hBurU2J10NVQj/D4mMDLrXb/ks5UwN0wZ1fCUK67l6yjPXCwzsUv2V
	 og/AqsadjtD9nGPCuzgqajRI2vChFnokbiOrxQ2/qVhEZMo9yvUoau3kPxMXXXDLiHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QsMCF8fi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.41
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA6C606A31A;
	Thu, 22 Oct 2026 19:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BA6C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QsMCF8fi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPzaKtrHDeKncZu87Z7DL3kZZpQVCazHMBmfP/VKrfQZdXJV1ph6pdSjNCsNsNrvcnMavuEyg3YFz16jZ3SXNFLKUOiu4KP1gfPb4hVn/L8W8IDXH3rcNoSS2wQ+hoByYLAeq87OoRcLnZFKNRBqfDpk7XUEj7BEwb/Uo7+tDnGPJIafIQw9U/Ipjy4njMPslpFFS1h6i8E3Wjrpw4SvgV8gL8of1tD1bS2t+J2pA66gW4pHL90HezNrBSUT1GcXFPuNTtnUIZ1y2OviFO1VokcASlLnS7f5CMUGXJwS/Z1Bnz/DZi3k2Z2JZfmuTLGLrOVl6KUNLrjEuhcNe/+UKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGiYp7iSAM1dtsGEORn4JyEe/gWZ0FoeMthNEME1xIs=;
 b=jjWqyiZRL0/fEkWtazwFvSwMf7sGoTnkAD5DF77bbIyBdsWZUJUYe8rPQUovU/vsfhLEeCb7tzDb5EGNZ6y6J2ZNfdrEENvpVg0H2PcKW5MxCuFMUJbu6B0KAXTVwEJyBpCiOLqM5mvBkCKcPo7F516DN93eV8B1tsmXMJbSMqXCONgmB5Q/gJIagDzuGIOcIYY5aG5lYHZgSqPLX23i2IIlnazViLk+t2H1dQonF3024n7IsjiSZxVNDWgYUAPkE7B4kbLLpV0cyolwKMln2sl9bdbvQAfaQNybM5pok4M78/J0rimxN4KGqy55VodgnWpVhK/X8wP6mU8nF4QP4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGiYp7iSAM1dtsGEORn4JyEe/gWZ0FoeMthNEME1xIs=;
 b=QsMCF8fiSYL+R8VHd7VlFRP51geOzn8Vx+J+pBgaqwhyPe+YuNU/aTWlD0Z3IRfjIyCEDW68XqLdpjTtSkTZAx6YpTv5/TQj3iNeYDKNwJhEPklFuf9PnvZJyJvwuu7exrguEp7S2eVmp80Jzl7ZJZegE24TZkbnUfibD8DsX1jdHwxLrTmZD1vIARuCIatmvjF/Xf85DS89DZHLZE1RJXiqI+YLgIVX9CCiBdhn65iARV9zDN/VGg7HoaL++JSsO9XLT73K867CUE2icy0kfkvuBHHbOByajGSXDM4p9uIwurY8o56Jx5c2iiJB57lvCrUtvY4bbl3/SoKsWHLsMA==
Received: from BN9PR03CA0558.namprd03.prod.outlook.com (2603:10b6:408:138::23)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 19:31:44 +0000
Received: from BN7PEPF00000091.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::81) by BN9PR03CA0558.outlook.office365.com
 (2603:10b6:408:138::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu,
 22 Oct 2026 19:31:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN7PEPF00000091.mail.protection.outlook.com (10.167.245.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 19:31:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 22 Oct
 2026 12:31:15 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 22 Oct 2026 12:31:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 22 Oct 2026 12:31:09 -0700
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
Subject: [PATCH net V2 0/4] net/mlx5: fixes for LAG max_tx_speed update flow
Date: Thu, 22 Oct 2026 22:30:49 +0300
Message-ID: <20261022193053.3815866-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000091:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 420a6040-74bb-4f52-5da5-08df30731992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|23010399003|13003099007|261022113327099003|11063799006|56012099006|10067099003|261021121427099003|261021135927099003|261021123027099003|261009223027099003|18002099003|6133799003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	sJpSkj4a21s4+G7koCfZjH9UzevXFZoLx9YWuAhffzoyg5kEqu69S9Oo518ecI3XSG+aaU486CvC7j9z5JqKaTPRAWksDJlzlyusqhKtV+YaEELUCdlOFnMKwTRU9mIpEdyxhvZ9tYkDpmVHda8SCWE4DgAFmaZyHzuyMOo6bMTE5IqlgtQTLhIlVJHR3wnWPrtJZVd2VzoslPrSuOQWPMko/Sz9uG63/HIOWgfh93BVJXoOrRaJcIGL21eYHNq9EjlYZ3yOJBB+a82rrPAby+mzaI8AOKF5qlbgFuHKzFojUPgVRqVEvN5NZYc6s2b7mH5vSqIteTlTqzXS+NDocEoGeyYVBoDfpfv9K+T5uvWecE4UBxm7b+uHV0LNrg+NjpTJ9r/PZHfIx9vioDZowRbcqV4Yk2ksv+hGJWjuKIXWc74U9mxBn7wKPKyRCiRrlHh60mEfcpU5q05V9GzWApHS25peNoWcTJA8vT2b/9XBeqUuEnUoax4kbBZezZFyWjikbH1PQJICK1Vacnk+9pRJBe/V7iQw5QWe+MQ428Qh1BhQ1OF9AaSJDQcnR0mzpX9OF33orkZ7+qbaYAshGF7HNkttG1coRtFJy4G9zZ6OxAiLZ4Xczj8E/h8JwWmVThwwbRzkSwfVBJDOdsFiiA34Dm9V3m3Vf3691qmEz1TbSaG6sWNpBnyW+FPF6+IbzA5R3e54JtXQ1/XrvWXS8w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(23010399003)(13003099007)(261022113327099003)(11063799006)(56012099006)(10067099003)(261021121427099003)(261021135927099003)(261021123027099003)(261009223027099003)(18002099003)(6133799003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ejG8l7WbVwrhgnLdTU/v8Sqtc3HB+oLCOplVusKdOul1/rtXAsXNIx0G9kv5l0BAEAdhsY2XRdYLYZNXjJt8i1rf+met2/olh8LBInaxam7q9LOA4yvZmQlEja5ZXTuMMlmvmFB8BbwvxfnpH9U2t5dpwoiQL+LfMztdD+wIw4daMJwKJ58o/pVnCw/Cmmh9vlHFkUAxfnkTq2IGUmWCgt8jtDk+mNFsewWfugFmauBPeIPVy8Yi9hs25UT4S4AdXKp3+Vbuh+3kwJH7/rpDu8DJcncwMTC01KLFH4W1x0hs2MU0KXKblbez78WaLPj28fxvQXZD2JMmLzmPxs/4WKxl7m9bmWOiNe6IGwjsQ2L21Khi0SELl+V7paiPplxWrSk5rmKGkN/CYBPnce7D5kTPq4QdHh7uHRtXGWBBaFPKzY/CuLtG4aYH7ybH7vLi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:31:41.6338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 420a6040-74bb-4f52-5da5-08df30731992
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634

Hi,

Commit 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to
vports") added a mechanism that computes the aggregated LAG TX speed and
programs it into each vport's max_tx_speed via MODIFY_VPORT_STATE. This
series fixes bugs found in that flow.

The bugs:

1. The aggregate was not limited by the NIC's PCIe bandwidth. It was
   taken from the bond speed, which is calculated from PTYS, and PTYS
   is not bounded by the PCI bandwidth of the NIC. FW initializes
   max_tx_speed to the minimum of the port speed and the PCIe
   bandwidth, so modifying it with a value computed by different rules
   changes the meaning of the field rather than updating it.

2. RoCE LAG never told the RDMA layer about speed changes. The NIC is
   considered to be in a bare metal configuration, without a valid or
   enabled eswitch, so there are no VF, SF or PF rep vports to modify
   and no event of speed change was raised.

3. LAG teardown did not reset the vport speeds correctly. It wrote back
   the oper speed of the link, which reads 0 for a down link, and FW
   ignores max_tx_speed=0 as "not provided", so the aggregate stayed on
   the vports. With the link up, it replaced the max_tx_speed of a
   vport with the speed of the link instead of the value the vport had
   before the LAG, for example when FW limits it by the PCIe bandwidth.

Patch #1 caches the TX-enabled aggregate speed and programs that into
        the vports, instead of reading it back from the bond netdev.

Patch #2 limits the aggregated TX speed by the NIC's PCIe bandwidth.

Patch #3 notifies the RDMA layer of LAG aggregate speed changes via a
        new driver event.

Patch #4 saves the max_tx_speed of each vport when it is enabled and
        restores it at LAG teardown, with a link-derived fallback when
        no value was saved or the link is down. It fixes bug 3.

Regards,
Tariq

V2:
- Patch "cache and use TX-enabled aggregate speed for vports": only
  TX-enabled, link-up ports from the LAG tracker are counted in
  non-MPESW modes, which was part of the split patch in v1 and moved
  here, mlx5_lag_update_agg_speed() now returns int and
  propagates query errors, the cached speed starts as unknown and a
  failed measurement invalidates it, so that
  mlx5_lag_query_aggregated_speed() returns -ENODATA instead of a zero
  speed.
- Patch "limit aggregated TX speed by PCIe bandwidth": the aggregate is
  clamped as a whole rather than clamping each port's speed to its own
  PCIe bandwidth before summing, which could let the total reach a
  multiple of a shared link's real bandwidth. Only ports that
  contribute to the aggregate are counted. In Socket Direct the
  bandwidths of the mdevs of a port are summed, and a bandwidth that
  cannot be read fails the calculation instead of skipping the clamp.
- Patch "notify IB uplink on LAG aggregate speed change": the event is
  raised whenever the cached aggregate changes, in any LAG mode, and
  the commit message describes the gap it closes.
- New patch: "Lag, save and restore vport max_tx_speed across LAG".

V1:
https://lore.kernel.org/all/20260910102432.3845360-1-tariqt@nvidia.com/

Or Har-Toov (4):
  {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
  net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth
  {RDMA,net}/mlx5: notify IB uplink on LAG aggregate speed change
  net/mlx5: Lag, save and restore vport max_tx_speed across LAG

 drivers/infiniband/hw/mlx5/main.c             |  12 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  22 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   1 +
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 251 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  17 +-
 drivers/pci/pci.c                             |  16 ++
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   2 +-
 include/linux/pci.h                           |   2 +
 10 files changed, 291 insertions(+), 34 deletions(-)


base-commit: f4377bf85887f57b59abb5479f7660a81ffe4449
-- 
2.44.0

