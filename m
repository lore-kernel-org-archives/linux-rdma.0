Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010031.outbound.protection.outlook.com [52.101.193.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E832EC54C;
	Thu, 16 Jul 2026 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191777; cv=fail; b=LIrjAUdYmzAhZ4rD46eu1zzTCqaF2HZQENG+V754FjhSVvRv1kUqhR/AAGnvYDx6BcqmsbChZXwB6r3+pb5hfaVgFc0VB6J5sSfyWtyw2JHA8s5QMgi7wZs8F/ldVxq/nOjDEQNv+DRalIGgBjiAy2PgosBaLY1lDm3a149wboQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191777; c=relaxed/simple;
	bh=+JB5Qr3QgkF1ZA+XwmyMehgPa7kaYaHSnt46FkMHXjI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VassVfDXbKAykGonWi12GKE+jNFWcE3dbAz+VWaOThL3dO67iIQMAF/PDC+Mrtnv7gP9e1w+2sqC5qASzyJ2juPmrDrP1ywaOoUix9r/iVzbTEEfy8CHYTDNm/CX6yWPLx3fjCDJ+XObFCsV0NleUNdFiMS9wQa/E/sMBbM7Wig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aYVl9Udd; arc=fail smtp.client-ip=52.101.193.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aYVl9Udd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDS62scX2piLzLZ2t9yhSGru1c9ia489k1wJaSWgSRTrEdWgkqF/OmkWdOW90Lef+RpQaKL1qbDYLfiDPLsIBSO4/conFveZpO0DBqxJBLDQKtzuyheYTRRqnHZUtddbe/7n0NJDtz++Fh75RNeG5h+YWWMRunLJXyiFvXXuXPM1xYoV46awUYTXXU9ijXPY2jU7/rfYxpa0VpwwWZQrknUWCP8w9q1Q/T2HKWImDsG/ipEmsxAFVwzF2q89+AWB5ArzsmnN2uv7eKZ7OGj+kReVmZpDwXHpml84axOS9gcLZLvKSR+GBWmtiWgeFvsjFfa4Gr57n/SRxccVdO5syw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObWxo8yNDID3QqO+0uIlX6pfxAOL9uSO/3LkXGR3rks=;
 b=Y/aND48ivFYdKBVrrySaSyotZFNx+5gqOLVhLrHVCo1wT+xp1bJND9dFCXs63HjlEjfbj2Sl3R1dR9u3ydi4ekj4JYCxHydowyXZRstGhkXHpPzAqVvRyu3SRigwzxS6p1FT0xkcRZRMR9czPIpaLA+G8VkJ84Q8lOtJbQPt3q3XeT7h2hksZN3S7rRvAR3wLIKncVN3pNxBw+eigsWxbhnyHp+CNjOT/szhFCM8EVkMsQfQAf8oQM1MDJNt/qEcG6T8rtew3vPHD0ioTcZBJQAExa4RA/u3UQDjrRMM5BeaOCOB3JDZ/IdJ4yMmhVzR53bcquxlV+zGm7mVj/X0QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObWxo8yNDID3QqO+0uIlX6pfxAOL9uSO/3LkXGR3rks=;
 b=aYVl9Udd6MQsKJ07Qgll/am+FJm0T+UWN/hby8hglzyUaGYi/iHGgcR9c8vVx3VSpJBiZ61gZXAWsfmSc53xxz4371/SZIxINnVWqgnCeglVxUaR/HvoTcifJPSJ5Ar3Qoqb/sSlBTY4JZ+mtLy5gi8i25Vr7PA9SHvaFOTvkYIp4AZk/UwVXkDJeMlnC1vQfB+ZG+8uDDRa4kWAiRAWmPc7SYEMajUMyCANmMTdf51XlL9iLVBuN9g9t7/grGjTngTaU/eAexgw06G7IclioK5DuNX9Hdty1UUmYOlzA8Ep10mth37DEi50BKptC5SacXlolipxz83ikHxDD1ocOA==
Received: from SJ0PR05CA0157.namprd05.prod.outlook.com (2603:10b6:a03:339::12)
 by MN0PR12MB5715.namprd12.prod.outlook.com (2603:10b6:208:372::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 08:49:16 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::6) by SJ0PR05CA0157.outlook.office365.com
 (2603:10b6:a03:339::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.4 via Frontend Transport; Thu, 16
 Jul 2026 08:49:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Thu, 16 Jul 2026 08:49:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Jul
 2026 01:49:00 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 16 Jul 2026 01:48:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 16 Jul 2026 01:48:56 -0700
From: Mark Bloch <mbloch@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH net-next V7 0/4] devlink: Add boot-time eswitch mode defaults
Date: Thu, 16 Jul 2026 11:48:48 +0300
Message-ID: <20260716084852.549909-1-mbloch@nvidia.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|MN0PR12MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: 1302fdf9-a885-4258-9aaf-08dee3171dda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|82310400026|376014|7416014|13003099007|3023799007|6133799003|10067099003|56012099006|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	7CDHgmmjI8k7ALigRZ1pAdCxI3BBzeVWdust9n+mDcs+iZWFAXHvYTXyRKcuxAuIAJ/JyxRqE9OKYLf/44qo3nznc/axcvJfjx1xQp084wj0Nju3VxrKyV78ysXDo8GMTpWOB/PQkO3ii7IV7mZ/4ehcWSW7sYC0WMYZU4+myNq0v7GQk1sbtdwoIVJn6yX312XIxU4u3eQUIL0YZOVOYq43iKV9hRBeaX99ZZ1hn6l2CF98lrLoGi188rGLkGPsOqVGfxu5muP59VCUlzcIKVZ1KEM+SeYyNcoGr61A3nuQWdV/XwYFXulWL6GyVZyxIzEMl5+5n641wFwr/gciQOOM/wwGWKzEU3Jnw7Z0stquCBQCflqnhC+Od1VpeMVkj89kJP8zH8/GL3zRytv/LAiXUW1YMMbNXvJoOVxKFTdUf6H3opn5t6MM43jyY67UbbPWG3fTfrySj2OICSPAKrhT9l8LadnUc/tOB6vQdrh2K09uVgvTA8Pb3/tnKq8DjXNllou2pgUCwfyNpzlssO54tdTmdFZAu5Xu7fVR6bPShPTy+lRCy2Zx4aXb4cRdajyDGyO+dNgBNkPHYujzcnQL1Pr+8xeyhsduZut4ciCMDM6HtH+VSUiJ7M7HvBCp0QtMsemeDY1LKRXJCcfjrpH6j6XcZamE9ENa3sOlkp/Sgdd3NOpGDtqvq45qsksmESfWWFSOF7fv1E6Ms9XrUA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(82310400026)(376014)(7416014)(13003099007)(3023799007)(6133799003)(10067099003)(56012099006)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wzAA10hU6/qs0xwML4iSlKddRa9Ojet5S8dlEu3jBohdZBIMGyr8+MRls9izhteSZx7qRp5xA8ImGgc5pkqIfAZL75UMEZ5NNctDmmRxSJpSNyO6vs8OnUieOx0fPCCFDx8E9hL9uenygcSXiNCAHMHWT4FKwEtEn3WhYBCv6SXTMogqow7zHbeUd9EMrTE/ZuTdPBb5G4DStJEgtyJiuqBQMGAmjXnZhoe1u8mZ988g2PvuNz/E38hTZZxh4hnCq0+4VG9d65YH0OO2ybTYi5WVY2tJViL5ypKt72PFDQmCsEzsmovaU9tRKdafL/2R3cCuvaz2edG6AwhbG+nooGigZMiWSLUKpIWDngkhqGcX+D27190l0sE1IKPudlL4q4mDuksDWngmQ3EIPvpnqP8gMVKxNPWI81uUDkzRSIvKmGqAbPHpEOK572daBvtP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 08:49:15.6613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1302fdf9-a885-4258-9aaf-08dee3171dda
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5715

This series adds a devlink_eswitch_mode= kernel command line parameter
for setting a default devlink eswitch mode during boot.

Following the discussion with Jakub[1] and the feedback on the RFC
postings, this version keeps the scope limited to a boot-time devlink
eswitch mode default only.

The option selects either all devlink handles or an explicit
comma-separated handle list:

devlink_eswitch_mode=*=switchdev
devlink_eswitch_mode=pci/0000:08:00.0,pci/0000:09:00.1=switchdev_inactive

The supported modes are legacy, switchdev and switchdev_inactive. The
selected mode is applied through the existing eswitch_mode_set() devlink
operation, the same operation used by the devlink eswitch mode command.

Registration may happen while a driver holds the devlink lock and
continues device initialization. Devlink core marks the default as
pending and applies it from devl_unlock() once the instance is
registered, before releasing the lock. This prevents userspace from
racing with the boot default.

After a successful reload that performed DRIVER_REINIT, devlink core
already holds the devlink instance lock and the driver completed
reload_up(), so the default is applied directly from the reload path.

Patch 1 clears the mlx5 FW reset-in-progress bit before reload.

Patch 2 factors the common eswitch mode set validation into a helper.

Patch 3 adds the devlink_eswitch_mode= parser and documentation.

Patch 4 applies parsed defaults from devlink core.

Changelog:

v6 -> v7:

- Added Reviewed-by tags from Jiri Pirko.

- Renamed the default eswitch mode functions to spell out eswitch instead
  of esw.

- Renamed the per-devlink initialization helper to
  devlink_default_eswitch_mode_init(), dropping instance from its name.

v5 -> v6:

- Dropped regular work and applied a pending default directly from
  devl_unlock() while the devlink instance lock is still held.

- Dropped the driver API and mlx5-specific default application patches.

v4 -> v5:

- Moved the default eswitch mode code into a separate file, per Jiri's
  comment.

- Dropped the delayed workqueue and switched to regular work triggered
  via devl_unlock(), per Jiri's comment.

- Renamed some functions to better align with devlink code.

v3 -> v4:

- Rework registration time apply to use per devlink work queued from
  devl_unlock(), instead of calling eswitch_mode_set() directly from
  devl_register().

- Apply the default directly after successful DRIVER_REINIT devlink reload,
  where the devlink lock is already held and reload_up() has completed.

- Add devl_apply_default_esw_mode() for drivers that know their exact ready
  point.

- Drop the driver registration-ordering preparation patches that are no
  longer needed with the async registration apply path.

v2 -> v3:

- Change the devlink_eswitch_mode= API syntax to use <selector>=<mode>
  instead of [<selector>]:<mode>, following a comment from Randy Dunlap.

v1 -> v2:

- Move default eswitch mode application into devlink core. The default is
  now applied during devlink registration and after a successful devlink
  reload that performed DRIVER_REINIT.

- Remove the exported devl_apply_default_esw_mode() driver API and the mlx5
  driver-side call to it.

- Skip devlink health recovery notifications while the devlink instance is
  not registered, so drivers can move registration later without early
  health work hitting registration assertions.

- Move mlx5 devlink registration after device initialization, including the
  lightweight init path, so the core can apply the default through the
  normal registration flow.

- Move the matching netdevsim and mlx5 unregister paths before object
  teardown, so unregister notifications come from devl_unregister() and the
  later object teardown paths run while the devlink instance is no longer
  registered.

- Add registration-ordering preparation patches for netdevsim and octeontx2
  AF/PF, so their eswitch state is ready before registration-time defaults
  may call eswitch_mode_set().

[1] lore.kernel.org/r/20260502184153.4fd8d06f@kernel.org/
RFC v1: lore.kernel.org/r/20260506123739.1959770-1-mbloch@nvidia.com/
RFC v2: lore.kernel.org/r/20260510185424.2041415-1-mbloch@nvidia.com/
v1: lore.kernel.org/r/20260521072434.362624-1-tariqt@nvidia.com/
v2: lore.kernel.org/all/20260603193259.3412464-1-mbloch@nvidia.com/
v3: lore.kernel.org/all/20260605181030.3486619-1-mbloch@nvidia.com/
v4: lore.kernel.org/all/20260629182102.245150-1-mbloch@nvidia.com/
v5: lore.kernel.org/all/20260707174527.425134-1-mbloch@nvidia.com/
v6: lore.kernel.org/all/20260714061731.531849-1-mbloch@nvidia.com/

Signed-off-by: Mark Bloch <mbloch@nvidia.com>

Mark Bloch (4):
  net/mlx5: Clear FW reset-in-progress bit before reload
  devlink: Factor out eswitch mode setting
  devlink: Parse eswitch mode boot defaults
  devlink: Apply eswitch mode boot defaults

 .../admin-guide/kernel-parameters.txt         |  25 ++
 .../networking/devlink/devlink-defaults.rst   |  78 +++++
 Documentation/networking/devlink/index.rst    |   1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  28 +-
 net/devlink/Makefile                          |   2 +-
 net/devlink/core.c                            |  10 +
 net/devlink/default.c                         | 303 ++++++++++++++++++
 net/devlink/dev.c                             |  33 +-
 net/devlink/devl_internal.h                   |  10 +
 9 files changed, 471 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-defaults.rst
 create mode 100644 net/devlink/default.c


base-commit: f6f3b36c15ed44de1fbb44e645e4fae8c4a4453e
-- 
2.43.0

