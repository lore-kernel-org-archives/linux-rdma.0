Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEF3182D6;
	Sun, 16 Aug 2026 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890082; cv=fail; b=qJgTGRU3lpvNVnIU0t+Sne2kjQPGKEVkXTSim0jM8UeHmJsXCZmXekCpHwqqLgzS7HEOhfUgeVFyIsEqNRUd/XEdkCfC8f3c/amu/L/txMpZDh84OR1MQRQ00yukaVRfOEq8h11pYQwvxOhH7evAnAbSRdYyzEvTK8nsMZSVWDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890082; c=relaxed/simple;
	bh=KtAuWBb8R0Qpcp4CHs+sSHTCdxDtAgF0ct87+NJjjiU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zf7JNOKYJxWxtpgMzinG+fyY4MdFj7ID4GefDU7Izxy4jM0tcfqj2NroaM+Y4a7H5Hm7MrZqUhbghDJHw+HK4qegNQ33vKz7RKiybJTLjfN993K43Jd3d9IHRXkblPhj2nX3xnxpz/PH3NwovLkJmHqt4yxIHrfdH08WfNhiKCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VoIdvHJr; arc=fail smtp.client-ip=40.93.196.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VoIdvHJr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtwrmMgBwR4vGklZ8lGfSwPB8szXuG3aN0oPY/lUfowIAM/LrhCFeV+lMeV1d2VDYyxofOfiNT6vNadD4oc5mmG2WAFuIFl9feojT9C94GI+dwNzuYmD4f2sBTWImLJtK/r+mvuMceCSWIvoL7yd59Vv5PTTL2wnLBYHO1xCZ9mA9Nv10jT5VB7yD22Hyw8bxVe7dYqZcUvHyaZnINy7GpPfpJzDPbN24ZZstgZDgLf8wzmm22CmUBFvK9+hpeRCjlPezXTC2VrZ7bLuwNQev55xYKUppbNFh5BY1zD+b3BdjQk7FDQ4x+iYQQ6x3dUWvOaMoCTJGI6P1+HsOTDvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skTuBs57RteFOpl7cFRtM+cwtT++hzwBPuM5iCND/QI=;
 b=kgaMLtw+LCyGlm6/xnuD23H1w1h+FtLCIPpVnH+VoayVerwO+otgz4cl0FwBh59ssDS06HZfUEvZvoMgaaehMzkWrvFRhKmqLL5m78jum1yqbzjC989AP5bkDm9a9yPmfj1uq1xmhWs5E/Y1uoEiE0jSkS3zrPDqIUTwT5vPbWVuvNrMeTlCEWkbceG0HedOYngv6xxo7hhDYjiwayr4haqDA+NoGxBS92sNRcnNFOdV1MgcE1C3kqdAHO98hre1w+ppLYcU9oJYgwmX94OBDoLHQ1mHPqKWpTvL5htVrEVnSwf1BLywgp/dZe7sDNcsbaQY1TGWXNNbo9nKBYbV5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skTuBs57RteFOpl7cFRtM+cwtT++hzwBPuM5iCND/QI=;
 b=VoIdvHJrmuDxhShRpk9STpuqrvPUvnr+4isf7QMJ/t3a+uNMjBL0j97fG/bwZgUY8XPcaKg5+i1YdAakMtjrHFIQtORm0pS9pQNdtHUwHvCZxqyGE+8Zv8TdmEa/PpcUe3SqnwJIoaZkd+v57lmAQxdxTVLxHQatyW5zSZxvPB7GdLl5Ii1Z1i0zcAVZ1HfMCYmHFMENHBA4kkmcg82YbeDel1mz4L0q1IFCdaPGZ0tcZaBYEZojWKsQ2NmEBB97H0pC+p+VbFket9QgOdIihETuTh7gvwQRDS1Ctqq+miyKnfjg3ewr9mvEu5ZYe3UwprJAC11LgKlRhBqFZUPCew==
Received: from DM6PR05CA0041.namprd05.prod.outlook.com (2603:10b6:5:335::10)
 by SA0PR12MB4477.namprd12.prod.outlook.com (2603:10b6:806:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Sun, 16 Aug
 2026 14:21:16 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:335:cafe::73) by DM6PR05CA0041.outlook.office365.com
 (2603:10b6:5:335::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Sun, 16
 Aug 2026 14:21:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 14:21:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:05 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 16
 Aug 2026 07:20:58 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alex Vesker <valex@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Erez
 Shitrit" <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V3 0/5] net/mlx5: HWS misc enhancements
Date: Sun, 16 Aug 2026 17:20:40 +0300
Message-ID: <20260816142045.3289452-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|SA0PR12MB4477:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ce8f41e-113d-4fd9-7249-08defba1a18e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|82310400026|1800799024|36860700016|13003099007|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	20tMoGIZNJH1fl4DAwBvMI9LMmGkC8fcz1U3d44752sh2cJl9asUUuVQOg/f7sBm3mg49ZBKX3cf01+5aKIZZ+usmW4gZ/L0JLhfNcMUXxSbHz0onkDG56z3yixihbnLmdx4ypYTfwLdd4sc/WpntNJ3RAMlo4FhnN/hdsYZeMIKrXr+4Hph5ALBXTjK1ttTaImvb5RZZ4dPZbXnhalvCDzgBJDL+C5pK8/GpZLHAWjZivv21hvIhuRMTVGHC/Mo99BVz1VradUGu4tsHXNPiAQVmLk/nWPitPbG1Thv8Em57bY8iPVeBO2aCZQxgJfsts0A788PB5Ur/YP5rWJDI7UbxrpZs6ETCJyXEVGEc4rrWlstw12fF/iGpHEKLmRIFECYP9lqO2WICAijJjBH+Az3PFvKvjRJTUCFAvTMP3VOEw4qm0vDNfJEXwCdzuc6gwYxp0CkaqIoYdsnjh3UNrWABePmjHU2h/jUWEFu9mcEE1Z3/Cmor1Mk2DyYcfr4CsKN0IOXymAsZ5BhoHUwo1KCl8jWxKTWOrLxG+yrLYCUnhP0GgtsgD9ZJRvrd+GFC85m+wdEEYou8F1EtFh2gVXtQXnCd+E4hHXT3UEKpyujPAZZi53kd3794rxTmgVXPKgtdDxv3Ad8f74eBvR6HOyF5PWTuGDT1YNdytpWSqDYxiIRbaYKIbmSruOPnHpYbrI8345R5FVeWtywJ8soDA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(82310400026)(1800799024)(36860700016)(13003099007)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ybBwWxaxZbB7dIQaT9KSbiMyLIRWnRKp5PTyyCg1FsHWsxcfggYitJ0hr7424r9IxM2mdmVoJXX8LyBR/Tn0zlaidAx7ZxoY9AmGACKSV7xexBYJir/KLyZ8IVBIPE/4U/OBrSvpZmuLGmy4wDQeZc9dbJ0BiY2cpgVVRT3RYV+mVWYohwmG1HnUjFgUVLGaWBdH+mTP6g48CJuAPsASn3SJgfj0KrVdAWbY6qvNZo25jL/DLiqRlluht+SWXL2TCwzMDF4MpGmOppqTefoyzfq4yNki1VbgBa7zR7CXOd/bWyt1CMMnn6CWl7/amKc6VJFlX4V/Noi1q+aJEYvOIlw3dV2MNOjaF8umhugmYL3HDSukb/Ke/Hzbycs7hZXO2p8PiTRbfDCVvsL97FWII+oTyp644b0C1TbepKo1sStERgJ2K6uXpE2NcnAbjkeL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 14:21:15.0478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce8f41e-113d-4fd9-7249-08defba1a18e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4477

Hi,

This series by Yevgeny brings several misc improvements to the mlx5 HWS
driver.

Regards,
Tariq

V3:
- Removed repeated log message in patch #1.

V2:
https://lore.kernel.org/all/20260810092630.3137666-1-tariqt@nvidia.com/

V1:
https://lore.kernel.org/all/20260723095349.1890983-1-tariqt@nvidia.com/

    [timing] prompt build: 0s, prompt size: 13097 bytes
    [timing] claude -p: 0s
    [timing] line-wrap: 0s

Yevgeny Kliteynik (5):
  net/mlx5: HWS, Print more details for bad completion
  net/mlx5: HWS, Log syndrome on STC modify failure
  net/mlx5: HWS, Set the num of queues only when alloc succeeded
  net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
  net/mlx5: HWS, Remove redundant FW command when reading caps

 .../mellanox/mlx5/core/steering/hws/cmd.c     | 15 ++---
 .../mellanox/mlx5/core/steering/hws/send.c    | 67 +++++++++++++------
 2 files changed, 51 insertions(+), 31 deletions(-)


base-commit: e6a5d573d24cd375e09d24f136523cb3cc85c9d3
-- 
2.44.0

