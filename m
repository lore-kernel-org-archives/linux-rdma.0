Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7643822AA;
	Thu,  6 Aug 2026 07:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786001501; cv=fail; b=j2Rs6ZjAoILrcfvpAOCKALhieGR/9HrkXFWM90cXnRw1gx8l3QdF8AT4o/Em8sfP/Lg6huWJJ8PcOBOgq0ZxZ3t33D1FAg3kROydQq9F57X0QOHKR7uDriR/hngIdOQYaPVDeOZldPwnDdXB4L2ek22K3gqdyD5Id74fkdxkiko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786001501; c=relaxed/simple;
	bh=+qrGhZIxr2PWcKVT8KWzRKp2s+Z6SEXVXun3XoTOnl0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kRQceEd+gJVskK/R7LuRFwo70RZQlfsdhVgS0E98bf7ORnw2VeAYHocIyLgCvve7XtVChWdu/3+9i5orK9+7gbhy+kNzFXnnr6Pd3r21+7L/q5ukAAV4G0CVMMslvdH2m+21Aej+d5LP77IiXgdB8xQcH/FgPOSuIptQ82kOR3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gehqnicj; arc=fail smtp.client-ip=40.107.209.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gehqnicj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNi1TaZi8eeCmctdzwn6ZMLKZrI61/FAMrg5KQ33lJ12qL9emXCkj49hIDuejBI7zBjYMXdtE7h1BJcQ3MkJIJ2Tp5BnTPKVqfejdVmw0NMGiaf0o+UxPEi/LWGd1kvH/sqes/WBrAM/O0BqDhtIM7W/j/S6Wah3p4VPLoobK3HaCKkg/iLL2loVDV0ug0LK5X6yIbg6Bif5AMT/CQ1TIABSPKjBIp3B8lSIoNTgRwdGPmZ/IpNX6k7u7Zt733BmZ54rkwWYc0IInUWnjvSh0Xx5LSDxGZkgfl4i+T49t8gNCkYpvAS4MnYt32ivovJYJjZWyGSvN2MM7bsEaJfW/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwqtyR4AFEt34cmHK8Ee9FJcph73wuLOGkx5QI+45us=;
 b=dEcg7srnn3xPZwwpceY4JqvkgP7vlRWig0BvvEHnpA0f1OQXd0QEohXuiiGsZ1C7KGf8L3PpGrgG2pGA/KOwhWbIYXpN5FQXTleyYVYv58boOyqJLnz3SmYN96d6r9PLg2dtgH6R6jLghasIdrCj/OpY5mN7hfKSmdRvrO6Gg6XYjlnE6KRR4lev2w74npV/G2WY7guwYg9gJr/7jpQoV9s/4hGPvEVniHUFliVVvhMPJXonsuUYeDIMXcOkTQrTrPaotFq00xBjm7fFVv+XNXpZs+JNxm2lHUHhKCR5ZM+VaCGQgA0hEgqhfiGEku/MOLH1T6k2ZGmtpE5CHyKyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwqtyR4AFEt34cmHK8Ee9FJcph73wuLOGkx5QI+45us=;
 b=Gehqnicjn7hOtAangV0+Ipo0mqYG0I6glcMRF3F9XPFOMJWZpELRg5wm9MMgMawB71Sh+hA+90iDVcxOFdrB0P/o4Z2EZk0gu5ugW1ce+j/imTe4T9OR7ZwBpA2deiFwXEGR+TAILBT+xSN0KlLvEWOURnnnOsBK0bugryfmdOevW1jBBzabVg1/CzXUH2TvhxgUIIngxXEB3jeGWgQG8mqygUEd1QMf8DFFWR7eqRl51dw9wdgO8c6gDhES9Ll93lzsO3g7EKt9d6PEvpDiId6H2tIa1PqYtFr3q9J45T6O2dFE1CzJo1q99CTbnf4hYVG+UHk+acPzPNMd1FBGSA==
Received: from SA1P222CA0062.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::13)
 by DM4PR12MB8570.namprd12.prod.outlook.com (2603:10b6:8:18b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 07:31:28 +0000
Received: from SA2PEPF00003F64.namprd04.prod.outlook.com
 (2603:10b6:806:2c1:cafe::68) by SA1P222CA0062.outlook.office365.com
 (2603:10b6:806:2c1::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.19 via Frontend Transport; Thu, 6
 Aug 2026 07:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F64.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Thu, 6 Aug 2026 07:31:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 6 Aug
 2026 00:31:05 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 6 Aug 2026 00:31:05 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 6 Aug 2026 00:30:59 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexander Lobakin
	<aleksander.lobakin@intel.com>, Arthur Kiyanovski <akiyano@amazon.com>,
	Daniel Zahka <daniel.zahka@gmail.com>, David Ahern <dsahern@kernel.org>, "Gal
 Pressman" <gal@nvidia.com>, Jiri Pirko <jiri@nvidia.com>, Jiri Pirko
	<jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Nikolay Aleksandrov <nikolay@nvidia.com>, "Nikolay
 Aleksandrov" <razor@blackwall.org>, Petr Machata <petrm@nvidia.com>, "Przemek
 Kitszel" <przemyslaw.kitszel@intel.com>, Ratheesh Kannoth
	<rkannoth@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: [PATCH net-next V5 0/2] devlink: add generic device max_sfs parameter
Date: Thu, 6 Aug 2026 10:30:35 +0300
Message-ID: <20260806073037.3001886-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F64:EE_|DM4PR12MB8570:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e973edd-771c-43e3-e0ee-08def38cb9b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|1800799024|23010399003|82310400026|18002099003|11063799006|56012099006|3023799007|13003099007|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	j3KON7ssvvOVn3sjykfKWTHg9G0wTFMIG4ax98GBjgywof9rmTG+UJLRFmn/A8iccFHUOfQKEB4PgodUCrO/sLNKTiVtIEjOx9EG9Sct2eqXzM5klbLSgGSk9uCaBlsLkphnJv+Aa0U3WQCM7JVtJIevnNKE7GCsfAYtg6P90OnM0l5V/T30Cx2EQOMjxUFRhWUdPNkY9GKiHqs9gMnW6pUuBydFuJv43H439wxtS3MMAj+/FIdY/JZCTqQ/2dqqM4vKozDA3usQP4GxTCdER4U4kiX+SeFiP/YLO/Knbdfp7l0lErWda1qT3ups5aJWqA0c0r/kgxCBe5fdi6+pSCmDmo6a8OsXbgG2jR3qutp78j4g9JkaCpEeM/6c2bYX1wPojzZ6NfGHmkgMX5EojrjmrehwWOzG9Qsuq1Sjv0yhev3P0P544dOoRWxEwtWl7WOhhD6iy9o7wloa1CW2NV3bpv4XRTpGFTbxlL9hHbPA7XVl6Se9KW2efF3o0lcVvWAw8mhBTHVEyAvs3U9xXAKtYMEXxkrhfOzNaWZFdpJ6s1YcIbiVUrlyZmoNEYv0LabJzu1rbt8UvoM0tGTfB9Jid47vt29aybPaW3HIO8Uh75xaMcWIKE91lzqIJonoL+GGt04PYU0vU5QcdzN//9r5yXYtq3lKtqG+iHSR/y/GWhQ07OwFOvwPXvf2rsRwjDHtYTMi7a0QJ3KdsSnsHw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(1800799024)(23010399003)(82310400026)(18002099003)(11063799006)(56012099006)(3023799007)(13003099007)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	awtpq20Gv4ESz9TeUv2XLOjB+2lKTqwvVzRKFiRomL7ALnSHt4+T2PSV3jTigvT+v1JKtz+SE0yc0FYyy54Gg0C3/w8XT4eVeY1HnU/ZCkbIjprxfy8HMCgTy9o38eaOrELrlZe0ihaVYNz6mWv8erQV0iiHyXtGmOkUPDeO2ORC7kR8xR+tMIFn7Ha/WB81KCG1FNOC6ELCPKq1XgaebGbj0sDb6a1zhSMy9oo0oeH+9Scvdrt7oSy1dq+ozfcSZ/qhp9DUJiwyLWdI6yJv0Fz9mxpfZm8s+Cixqq8Vxb7wCpTsuTCaKPgXR8ZkExrq9X7w4vTlzk2Ta5G7dG0ZkCUBwvYxwGILXHs4vS+LNRYAS1xqsSiPf6NYw5b1bo/lQ/l4w6K4iwXK7Gi30zMZL5jFd37o60W5k7jOW5Bf8iNXkIbaE9qG8HrSrXX7xRj+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 07:31:26.8403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e973edd-771c-43e3-e0ee-08def38cb9b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8570

Hi,

This series by Nikolay introduces a new generic devlink device
parameter, max_sfs, to control the number of light-weight NIC
subfunctions (SFs) that can be created on a device.

The first patch adds the generic devlink parameter and infrastructure
support.
The second patch implements support for the parameter in the mlx5
driver.

With this addition, users can enable or disable SF creation directly via
devlink, without relying on external vendor-specific tools.

Regards,
Tariq

Notes about a few items from a previous Sashiko review:
 > Should there be a validate callback analogous to
 > mlx5_devlink_total_vfs_validate() that reads the cap and rejects values
 > above the device-reported maximum, so the documented "device-specific
 > max" is actually enforced?

 N: I don't know of such cap, if there was I'd have added it.

 > mlx5_devlink_total_vfs_set() rejects with -EOPNOTSUPP and an extack
 > "SRIOV is not per PF on this device" when sriov_support or
 > per_pf_total_vf_supported is clear, but no equivalent
 > per_pf_num_sf_supported (or any SF-related) capability bit is added to
 > nv_global_pci_cap_bits or queried here.  On hardware that lacks the
 > feature, the user only sees the generic firmware error "Failed to
 > change ... global PCI configuration".

 N: I don't know of such bit, if there was such bit I'd have added it.

 > At this point, a successful write of per_pf_num_sf has already been
 > committed to non-volatile firmware storage.  If the subsequent
 > mlx5_nv_param_read_per_host_pf_conf() or the second mlx5_nv_param_write()
 > fails (for example, transient firmware/PCIe issue), is there a path that
 > rolls back per_pf_num_sf?
 >
 > Because these are permanent parameters that "require a reboot to take
 > effect", a half-applied state (e.g., per_pf_num_sf=1 but
 > pf_total_sf_en=0/total_sf=0) appears to persist across reboots until
 > the user issues another successful set.

 N: That is expected and in line with the rest of the code.

 > The commit message says max_sfs is to "control the total light-weight
 > NIC subfunctions"; the BAR-size side-effect is not mentioned, and any
 > previously configured log_sf_bar_size is overwritten on every
 > max_sfs set.  Should that behavior be documented or split out from the
 > count knob?

 N: It should be documented when it is split out, at present time - no.

 > Does this unconditionally overwrite any existing configuration for the
 > SubFunction BAR size?
 > When a user configures a custom log_sf_bar_size via firmware tools like
 > mlxconfig, and then later uses devlink to change max_sfs, it appears this
 > line discards any non-zero value already present in the configuration data
 > and forcibly replaces it with MLX5_DEFAULT_LOG_SF_BAR_SIZE.
 > Should this code preserve the existing log_sf_bar_size if it was already
 > configured?

 N: Yes, it does and it is expected and intentional.

V5:
- rebase again
- patch 02: always enable per_pf_num_sf when setting SFs > 0 because other
  PFs might be using SFs as well (sashiko)
- patch 02: use NL_SET_ERR_MSG_MOD in max_sfs set

V4:
https://lore.kernel.org/netdev/20260723082643.1870844-1-tariqt@nvidia.com/
- rebase due to build failure because of commit:
  d603517771d8 ("devlink: pass param values by pointer")
  fixed in patch 02
- added Alexander Lobakin's reviewed-by tags (please let me know
  if that is not ok, the change in patch 02 is minor and mechanical
  due to the commit above)

V3, all changes are in patch 02 (mlx5 implementation):
https://lore.kernel.org/netdev/b087dc20-7398-4ad3-9787-efef883d81b1@blackwall.org
- Cap max_sfs at U16_MAX using a validate callback (sashiko)
- Change the warning message to match the docs (sashiko)
- On get verify that per_pf_num_sf & pf_total_sf_en are set
  otherwise return 0 since it means SFs are not properly enabled (sashiko)
- Define the default log bar size and use it instead of raw value (sashiko)

V2:
https://lore.kernel.org/netdev/20260519200436.353249-1-tariqt@nvidia.com/
- Add missing ` (Aleksandr Loktionov).
- Add review tag to patch 1.

V1:
https://lore.kernel.org/all/20260517112700.343575-1-tariqt@nvidia.com/

Nikolay Aleksandrov (2):
  devlink: add generic device max_sfs parameter
  net/mlx5: implement max_sfs parameter

 .../networking/devlink/devlink-params.rst     |   6 +
 Documentation/networking/devlink/mlx5.rst     |   7 +-
 .../mellanox/mlx5/core/lib/nv_param.c         | 125 +++++++++++++++++-
 include/net/devlink.h                         |   4 +
 net/devlink/param.c                           |   5 +
 5 files changed, 143 insertions(+), 4 deletions(-)


base-commit: b0057c68df711bf6a62033c072ac61c4f9d3cbc1
-- 
2.44.0

