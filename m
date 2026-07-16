Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011010.outbound.protection.outlook.com [52.101.57.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCA22931E5;
	Thu, 16 Jul 2026 08:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191786; cv=fail; b=NEVsnNJU/+NWY/a4Gw2jhKyTnAp6M40mRnxcZsOyEjqm6Qpal5FXWfYMzIY4BzhHQgHsZX+gxAxHO8P3CmrSJPjNWkZ71l4B1Gmc0U4Y5Rz+dc5gmREJ3aMn+kVdWUD2NM/N9unzFmhcMVnKlz2W2xUm2KKwnsLsaAvAis1wQek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191786; c=relaxed/simple;
	bh=ZGojiHO4amLPbTYKdAv4pSEUz5wUN39hrthZuJD7LOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIHpOrAWfIPvTTSWW3PSO+OcepaueFbDyIphIQ6YKpaIGcecNBYUzbwZzmkm0QljpKsF5rWfmma80kYdk4a7RCM77yqzAaGlPVhtjr0s+RMYOR2MQeh8BcI0lOosNHuSWeyErlLwGXiYck2TtljJ1cUvVP1O4FS8Y0e1A7b2v3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IuSHDvkO; arc=fail smtp.client-ip=52.101.57.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IuSHDvkO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u8ioHR7m/WDwclAiq6sTy7NPgOFcI4YtqYK+B9WUUmNr3Y7lBJer6j83YToku1oMHClUoCbqr+7hpmR5R5GZYl/0OZODNnfph1VnsHRKJWW6y7q/bnuG3EKgAJMVGec0IL6GRVX3R1KbYTR71BUNMin9VTx9j3xCuNEOCTr9jHF9hOilbwG1fqwIcLW2XD2P2dpqQCtctProASeLgapguEUesKHi4WaKKBKrZt5EyrP3p/yOBJYVWg1vEGAHxkegU6p7i9woHhndtg5qRHHvIHdlJ3CQuc1sc19CRwCotOB+b8qmHQbWUu2aWGy5HV1pr6ISXDAl+wARXISeJaDn/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOGTpiGj1fMxytYup4ayio/1RkIJYY5I/MgWo/QgiPg=;
 b=Px+GwbUmEV/hwqQQ/XgTPEQU6TzK64wBV7syVtnWKM03Je8yLDSlNHF5Oh5qs9KYJcb/Jb0c6djPk2z/qiHQulMRnLb1nVAFzfrbA1IrZaMHJHSf30PKDM3tPHa9+0u+H2p5bVBnQiIUk4lpdFylJ8Ug1GgKxyzPy9Swv5zyfm7yEPe0ZBsidq3LFi9PfpYm9MRXILfO6R09DU68Uq8wpc7JKhoaH66Aw3J1nNoNuMPifReyM51eTxxTjRN8lBrFV5L+y0g1Rwuh7917b9sT3s/Ho69ZasAMAhXkAAGQOK2bf2FS2vNJneDDmDVP8M6YQLTKZk3bDs6snz6nudfjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOGTpiGj1fMxytYup4ayio/1RkIJYY5I/MgWo/QgiPg=;
 b=IuSHDvkO9zAAUo8N68bB1G9St7Rdb9uXhOEFJvZY37HmkqCbNxQ/70aTkLLrXyH7KpIWr8Xu3M8gyvPNfSNxYwvLR4ZRSRcFGsi/t/wSq3I2LQExAtRSzjplLhYn9AXu0lQc8xqWodEUEQrpsbefNhQ/2KRr8FPMAqfW9l+1YU8YC2V4pnDNFaIhAI9lfTNcpn8dIchJsu4QQrmkK+15vXSU4pV8bc4VRLAiEFVcKMaBiP9i90Vy1r7Dm8pAG4g25g/9QYW101BsT2YHRi/QV9CKPx4lHwfaAvQshMAFfeXTSYp58EDcZZlghBfF8aMJj4UlOWc6r0FuSvewm2WwLQ==
Received: from BY5PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:1e0::22)
 by DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Thu, 16 Jul
 2026 08:49:30 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::7b) by BY5PR03CA0012.outlook.office365.com
 (2603:10b6:a03:1e0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Thu,
 16 Jul 2026 08:49:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Thu, 16 Jul 2026 08:49:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 01:49:13 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 16 Jul 2026 01:49:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 16 Jul 2026 01:49:08 -0700
From: Mark Bloch <mbloch@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Jiri Pirko
	<jiri@nvidia.com>
Subject: [PATCH net-next V7 3/4] devlink: Parse eswitch mode boot defaults
Date: Thu, 16 Jul 2026 11:48:51 +0300
Message-ID: <20260716084852.549909-4-mbloch@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716084852.549909-1-mbloch@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 629f3c02-4ac2-4b39-8b94-08dee3172646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|56012099006|11063799006|3023799007|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Kdclme+waQNgelQaLGAIfadreK9LY+qc+uTPXdCamEI9++SWW2WWsN/lhDqUbuDG+vxzR5pU8Wv4aTjej4YS4CjoVzL5RGHkUtFHzCDgPbyoJ2cRUN/cM58Jy/szp4+3kahmPvyJDSk39EHV9XBnPHIF+DM0H9jBXW5SH1mZ+vMNwWdRSwEGPTRiyhu3Lrj0N3NJMYXTH7E5us0SPCRv/7RsNn412VeEhJbHoFsbQI3BFZhkc6OSQcx1NiIUn9TEXJPcgoBcM8kVgRZcJbKNg56aQpy+U58pgZ/Uy6Eho4K9XYLAZjkdL7cO3K8aT4+Uwzx90A7BWcMl7/jEFn65i5/TENW4RiDG68c8HVk1qC2YvJuBsiJ9zb7p5S9KCLX/3/c3RXPDDWBUapgpGEQL0Zt9i8gn/ZBt88RMH5eR1r+sEXxBcSBKdAd8UIg5xO4YBsR7qwHh8tV/H1ZccT+sVZTQaFr7OcQgVjOwlsaOJPh/C7uMhZxpp9t40q4ujZULDnW7c/qjjwWpz+/GPZWWnPzp3Ref5DwC+t+4ubJkVJ9Qhe+7YzgCgyGbHCbNX2or1bJ7XiZSfdgXqKjzMQghWnIXKFEq5d5H41hKYCp0YYP8yk/re/EexQ/U149wMFGLrmim0TuB9j+GrxXCtgAJ6rNqr43Pt6NPL1YctCahmsRIWm/6O4LI5aK61ginLEJrF8sc7bgarNZYth2cRbuzPQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(56012099006)(11063799006)(3023799007)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UgneXrjJWWm5/sO+r4IBt1iYEcCA33wxjAi3Zv0c/7y/JqmSR4uI6vE3PKTAchcr/loIV1qCtBHOzA3lV77ItlNDRigfmXVmYOvW4FJMCv01+29QtKGEl3wklXR+6AvhbE8YNlVHpm0HsB0v0FQlgXFSWl6NmAhXb+AUYjyfd2VATGxF38ziOrPsgMQCiFEc+uscsgf75Fd/iVBt69wm7c6BhDyARjmWPpxLvCZYRM/UZFLdz45StB/NfhSbDwS0Wg90KxJlBsP5tcVFOkD+6AsYdWCx0StN6MEg8N6T1pEPB7d3o9wAT2dCLTtc6D6cUxh4PCPX3KP1jPR2DSQYgr6ih3SAA3RIunEmIRz17SU1Gby8dPcR9abvVZHARIV1lfb82R/LS1ALeiIuoFcKCMMTV9WbE1Qw6lYmIzAugZKHvVJCnJNjId0O8dEPeW7e
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 08:49:29.7784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 629f3c02-4ac2-4b39-8b94-08dee3172646
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958

Add devlink_eswitch_mode= kernel command line parsing for a default
eswitch mode.

The supported syntax selects either all devlink handles or one explicit
comma-separated handle list:

  devlink_eswitch_mode=*=<mode>

  devlink_eswitch_mode=<handle>[,<handle>...]=<mode>

where <mode> is one of legacy, switchdev or switchdev_inactive. All
selected handles receive the same mode. Assigning different modes to
different handle lists in the same parameter value is not supported.

Store the parsed selector and mode in devlink core so the default can be
applied by a downstream patch.

Document the devlink_eswitch_mode= syntax and duplicate handle handling.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 .../admin-guide/kernel-parameters.txt         |  25 ++
 .../networking/devlink/devlink-defaults.rst   |  78 ++++++
 Documentation/networking/devlink/index.rst    |   1 +
 net/devlink/Makefile                          |   2 +-
 net/devlink/core.c                            |   7 +
 net/devlink/default.c                         | 237 ++++++++++++++++++
 net/devlink/devl_internal.h                   |   2 +
 7 files changed, 351 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/devlink/devlink-defaults.rst
 create mode 100644 net/devlink/default.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..117300dd589c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1249,6 +1249,31 @@ Kernel parameters
 	dell_smm_hwmon.fan_max=
 			[HW] Maximum configurable fan speed.
 
+	devlink_eswitch_mode=
+			[NET]
+			Format:
+			<selector>=<mode>
+
+			<selector>:
+			* | <handle>[,<handle>...]
+
+			<handle>:
+			<bus-name>/<dev-name>
+
+			Configure default devlink eswitch mode for matching
+			devlink instances during device initialization.
+
+			<mode>:
+			legacy | switchdev | switchdev_inactive
+
+			Examples:
+			devlink_eswitch_mode=*=switchdev
+			devlink_eswitch_mode=pci/0000:08:00.0=switchdev
+			devlink_eswitch_mode=pci/0000:08:00.0,pci/0000:09:00.1=switchdev_inactive
+
+			See Documentation/networking/devlink/devlink-defaults.rst
+			for the full syntax.
+
 	dfltcc=		[HW,S390]
 			Format: { on | off | def_only | inf_only | always }
 			on:       s390 zlib hardware support for compression on
diff --git a/Documentation/networking/devlink/devlink-defaults.rst b/Documentation/networking/devlink/devlink-defaults.rst
new file mode 100644
index 000000000000..380c9e99210e
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-defaults.rst
@@ -0,0 +1,78 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================
+Devlink Eswitch Mode Defaults
+==============================
+
+Devlink eswitch mode defaults allow the eswitch mode to be provided on the
+kernel command line and applied to matching devlink instances during device
+initialization.
+
+The devlink device is selected by its devlink handle. For PCI devices this is
+the same handle shown by ``devlink dev show``, for example
+``pci/0000:08:00.0``.
+
+Kernel command line syntax
+==========================
+
+Defaults are specified with the ``devlink_eswitch_mode=`` kernel command line
+parameter.
+
+The general syntax is::
+
+  devlink_eswitch_mode=<selector>=<mode>
+
+``<selector>`` is either ``*`` or one or more devlink handles::
+
+  * | <bus-name>/<dev-name>[,<bus-name>/<dev-name>...]
+
+``*`` applies the mode to every devlink instance. All handles in the same
+selector receive the same eswitch mode.
+
+``<mode>`` is one of ``legacy``, ``switchdev`` or ``switchdev_inactive``.
+
+Syntax rules
+------------
+
+The following syntax rules apply:
+
+* Specify the default in one ``devlink_eswitch_mode=`` parameter. Repeated
+  ``devlink_eswitch_mode=`` parameters are not accumulated.
+* The ``devlink_eswitch_mode=`` value is limited by the kernel command line
+  size.
+* Whitespace is not allowed within the parameter value.
+* ``<selector>`` must be either ``*`` or a handle list. ``*`` cannot be
+  combined with explicit handles.
+* ``<bus-name>`` and ``<dev-name>`` must not be empty.
+* ``<dev-name>`` may contain ``:``. This allows PCI names such as
+  ``0000:08:00.0``.
+* Handles must not contain whitespace, ``*``, ``=`` or more than one ``/``.
+* A comma separates handles.
+* Comma-separated default assignments are not supported.
+* Duplicate handles are rejected and the devlink eswitch mode default is
+  ignored.
+
+The eswitch mode default corresponds to the userspace command::
+
+  devlink dev eswitch set <handle> mode <value>
+
+
+Examples
+========
+
+Set all devlink instances to switchdev mode::
+
+  devlink_eswitch_mode=*=switchdev
+
+Set one PCI devlink instance to switchdev mode::
+
+  devlink_eswitch_mode=pci/0000:08:00.0=switchdev
+
+Set two PCI devlink instances to switchdev inactive mode::
+
+  devlink_eswitch_mode=pci/0000:08:00.0,pci/0000:09:00.1=switchdev_inactive
+
+The following is invalid because comma-separated default assignments are not
+supported::
+
+  devlink_eswitch_mode=pci/0000:08:00.0=switchdev,pci/0000:09:00.0=switchdev_inactive
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 4745148fecf4..134d2f319922 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -56,6 +56,7 @@ general.
    :maxdepth: 1
 
    devlink-dpipe
+   devlink-defaults
    devlink-eswitch-attr
    devlink-flash
    devlink-health
diff --git a/net/devlink/Makefile b/net/devlink/Makefile
index 8f2adb5e5836..99ca0ef7cf1e 100644
--- a/net/devlink/Makefile
+++ b/net/devlink/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := core.o netlink.o netlink_gen.o dev.o port.o sb.o dpipe.o \
+obj-y := core.o netlink.o netlink_gen.o dev.o default.o port.o sb.o dpipe.o \
 	 resource.o param.o region.o health.o trap.o rate.o linecard.o sh_dev.o
diff --git a/net/devlink/core.c b/net/devlink/core.c
index c53a42e17a58..d791a8e4317d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -598,6 +598,10 @@ static int __init devlink_init(void)
 {
 	int err;
 
+	err = devlink_default_eswitch_mode_cmdline_init();
+	if (err)
+		goto out;
+
 	err = register_pernet_subsys(&devlink_pernet_ops);
 	if (err)
 		goto out;
@@ -613,7 +617,10 @@ static int __init devlink_init(void)
 out_unreg_pernet_subsys:
 	unregister_pernet_subsys(&devlink_pernet_ops);
 out:
+	if (err)
+		devlink_default_eswitch_mode_cleanup();
 	WARN_ON(err);
+
 	return err;
 }
 
diff --git a/net/devlink/default.c b/net/devlink/default.c
new file mode 100644
index 000000000000..9b15b7b23e00
--- /dev/null
+++ b/net/devlink/default.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "devl_internal.h"
+
+static char *devlink_default_esw_mode_param;
+static bool devlink_default_esw_mode_match_all;
+static enum devlink_eswitch_mode devlink_default_esw_mode;
+static LIST_HEAD(devlink_default_esw_mode_nodes);
+
+struct devlink_default_esw_mode_node {
+	struct list_head list;
+	char *bus_name;
+	char *dev_name;
+};
+
+static int __init
+devlink_default_eswitch_mode_to_value(const char *str,
+				      enum devlink_eswitch_mode *mode)
+{
+	if (!strcmp(str, "legacy")) {
+		*mode = DEVLINK_ESWITCH_MODE_LEGACY;
+		return 0;
+	}
+	if (!strcmp(str, "switchdev")) {
+		*mode = DEVLINK_ESWITCH_MODE_SWITCHDEV;
+		return 0;
+	}
+	if (!strcmp(str, "switchdev_inactive")) {
+		*mode = DEVLINK_ESWITCH_MODE_SWITCHDEV_INACTIVE;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int __init
+devlink_default_eswitch_mode_handle_parse(char *handle, char **bus_name,
+					  char **dev_name)
+{
+	char *slash;
+	char *p;
+
+	if (!*handle)
+		return -EINVAL;
+
+	for (p = handle; *p; p++) {
+		if (*p == '*' || *p == '=')
+			return -EINVAL;
+	}
+
+	slash = strchr(handle, '/');
+	if (!slash || slash == handle || !slash[1])
+		return -EINVAL;
+	if (strchr(slash + 1, '/'))
+		return -EINVAL;
+
+	*slash = '\0';
+
+	*bus_name = handle;
+	*dev_name = slash + 1;
+	return 0;
+}
+
+static struct devlink_default_esw_mode_node *
+devlink_default_eswitch_mode_node_find(const char *bus_name, const char *dev_name)
+{
+	struct devlink_default_esw_mode_node *node;
+
+	list_for_each_entry(node, &devlink_default_esw_mode_nodes, list) {
+		if (!strcmp(node->bus_name, bus_name) &&
+		    !strcmp(node->dev_name, dev_name))
+			return node;
+	}
+
+	return NULL;
+}
+
+static int __init
+devlink_default_eswitch_mode_node_add(const char *bus_name, const char *dev_name)
+{
+	struct devlink_default_esw_mode_node *node;
+
+	if (devlink_default_eswitch_mode_node_find(bus_name, dev_name))
+		return -EEXIST;
+
+	node = kzalloc_obj(*node);
+	if (!node)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&node->list);
+	node->bus_name = kstrdup(bus_name, GFP_KERNEL);
+	node->dev_name = kstrdup(dev_name, GFP_KERNEL);
+	if (!node->bus_name || !node->dev_name) {
+		kfree(node->bus_name);
+		kfree(node->dev_name);
+		kfree(node);
+		return -ENOMEM;
+	}
+
+	list_add_tail(&node->list, &devlink_default_esw_mode_nodes);
+	return 0;
+}
+
+static int __init devlink_default_eswitch_mode_handles_parse(char *handles)
+{
+	char *handle;
+	int err;
+
+	if (!strcmp(handles, "*")) {
+		devlink_default_esw_mode_match_all = true;
+		return 0;
+	}
+
+	while ((handle = strsep(&handles, ",")) != NULL) {
+		char *bus_name;
+		char *dev_name;
+
+		err = devlink_default_eswitch_mode_handle_parse(handle, &bus_name,
+								&dev_name);
+		if (err)
+			return err;
+
+		err = devlink_default_eswitch_mode_node_add(bus_name, dev_name);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void __init
+devlink_default_eswitch_mode_node_free(struct devlink_default_esw_mode_node *node)
+{
+	kfree(node->bus_name);
+	kfree(node->dev_name);
+	kfree(node);
+}
+
+static void __init devlink_default_eswitch_mode_nodes_clear(void)
+{
+	struct devlink_default_esw_mode_node *node_tmp;
+	struct devlink_default_esw_mode_node *node;
+
+	list_for_each_entry_safe(node, node_tmp,
+				 &devlink_default_esw_mode_nodes, list) {
+		list_del(&node->list);
+		devlink_default_eswitch_mode_node_free(node);
+	}
+
+	devlink_default_esw_mode_match_all = false;
+}
+
+static int __init devlink_default_eswitch_mode_parse(char *str)
+{
+	enum devlink_eswitch_mode esw_mode;
+	char *separator;
+	char *handles;
+	char *mode;
+	int err;
+
+	if (!*str)
+		return -EINVAL;
+
+	separator = strrchr(str, '=');
+	if (!separator || separator == str || !separator[1])
+		return -EINVAL;
+
+	*separator = '\0';
+	handles = str;
+	mode = separator + 1;
+
+	err = devlink_default_eswitch_mode_to_value(mode, &esw_mode);
+	if (err)
+		return err;
+
+	err = devlink_default_eswitch_mode_handles_parse(handles);
+	if (err)
+		devlink_default_eswitch_mode_nodes_clear();
+	else
+		devlink_default_esw_mode = esw_mode;
+
+	return err;
+}
+
+static int __init devlink_default_eswitch_mode_setup(char *str)
+{
+	devlink_default_esw_mode_param = str;
+	return 1;
+}
+__setup("devlink_eswitch_mode=", devlink_default_eswitch_mode_setup);
+
+int __init devlink_default_eswitch_mode_cmdline_init(void)
+{
+	char *def;
+	int err;
+
+	if (!devlink_default_esw_mode_param)
+		return 0;
+
+	def = kstrdup(devlink_default_esw_mode_param, GFP_KERNEL);
+	if (!def) {
+		devlink_default_esw_mode_param = NULL;
+		pr_warn("devlink: devlink_eswitch_mode parameter ignored, failed to allocate memory\n");
+		return 0;
+	}
+
+	err = devlink_default_eswitch_mode_parse(def);
+	kfree(def);
+	if (err == -EEXIST) {
+		devlink_default_esw_mode_param = NULL;
+		pr_warn("devlink: duplicate eswitch mode handles ignored\n");
+		return 0;
+	} else if (err == -EINVAL) {
+		devlink_default_esw_mode_param = NULL;
+		pr_warn("devlink: invalid devlink_eswitch_mode parameter ignored\n");
+		return 0;
+	} else if (err == -ENOMEM) {
+		devlink_default_esw_mode_param = NULL;
+		pr_warn("devlink: devlink_eswitch_mode parameter ignored, failed to allocate memory\n");
+		return 0;
+	} else if (err) {
+		return err;
+	}
+
+	return 0;
+}
+
+void __init devlink_default_eswitch_mode_cleanup(void)
+{
+	devlink_default_eswitch_mode_nodes_clear();
+}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index af43b7163f78..8fde867f2c14 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -71,6 +71,8 @@ extern struct genl_family devlink_nl_family;
 struct devlink *__devlink_alloc(const struct devlink_ops *ops, size_t priv_size,
 				struct net *net, struct device *dev,
 				const struct device_driver *dev_driver);
+int devlink_default_eswitch_mode_cmdline_init(void);
+void devlink_default_eswitch_mode_cleanup(void);
 
 #define devl_warn(devlink, format, args...)				\
 	do {								\
-- 
2.43.0

