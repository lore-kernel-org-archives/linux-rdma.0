Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012024.outbound.protection.outlook.com [52.101.48.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DE3F39C2;
	Thu, 23 Jul 2026 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795260; cv=fail; b=uM0tEnLE4HvuT8kiU3dZpt2fZGNwxKSNJxNpvrbMZkj41i28aFW6YHDmzPU9ptnUSN014mgWSyeFsKABQrWlwmsez1vRlk7Okj5RY7D81UQLhATTZxcwkK0pxltdz9J7/WUDEC4QKlOk3tcv4+p9k7UmbPblj3hdEoKRf/A3/uI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795260; c=relaxed/simple;
	bh=jx9/RW0h97vcsD/pwIFRGjet/uoOOi0Lt0GalptKAig=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hgAk842D7pGeRXlSBm0dCZV7k61/aruaJhtF1QRzF0U/xVgFEkH9D8TEU3iJms7nJp/fnXuRuTydgQ+S1Ux8WiSk1vfBoJm5JXpj+a7Zal5/GhZCO1Zm77I2MlR2mEIMfu6ZW1lsHcA/ZW6HvI01KlBBBYciWPNeL0wt3rt2xf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p2nLLhpy; arc=fail smtp.client-ip=52.101.48.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p2nLLhpy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMBzktDt2vWp2MxW5pB4mXs+aZoDrVBEcsveQxGLDptrVeiVg9JMT32kffCA4nsOJKn8C0Y7VOLt3EjofEsqZ/3VZY76Sr3iO0g/TtPg8FhktpzWuMEQ9uTnBetbqn323UEgFC2n+v+EXasDOjyFkcC6FgT+NzyCYe3hrACCitm5t7O9xe0qRIhOCmKEuV+fVl9zl1Flail2NtZvjdtPJL/EeVHLpZt4D14gBiqBhmtsGb/YYXLjZvPlr/K82Ia5CgyNFqyeakIYKsoVt8IjhFE3+O2Voa4F7CWZTpCtLmASeH6Njkai+PgNd7NjN4UXZBubfOnx9Ti0bASDnPHe8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbB5l4gI+FKyBitDKruP4Zjf86mr8J+u4Irbam21Fw4=;
 b=k5Aq7MINGG87RTQcE78QhybFBRY5SkhHLTBwv8rEi2gPKGtW4sxh0eJVG+m1IOuPWglE2WJXwmxjxhillLVNbdETEoJwDr3E+B887O1lT1F45e5riOEw9+YF93gUkpijiD7h7GN27lGkgFM1d2P6I9uGBuSS8asLvkYEx6VBqAM6I7FEr1riU+4YsxHXXtmt/iZH7yDnAiAMIsOlifZZf7CWFD9kix8RzzNGT16mKKg/GW9dZSGsAJQs3m1j6s48sdS9Dn5ifkwHCpOaTa3EM04KA5Au/rFCefTL8uOBsheVtBe6Vf6nKv9ujMKOw4TDIkCzHesIvvChfDlkykZFGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbB5l4gI+FKyBitDKruP4Zjf86mr8J+u4Irbam21Fw4=;
 b=p2nLLhpygn6CGfiKlBwYplOoAWILzwFN9X46Gh9ZBMq2WfI08rSNTG0HzpsOLxTszBumwjpZbO+y2zNjlMNmPm6hIEk85dDYEWpGelVNxM6rKpmNWsXdGhuQQ4cGhzxIdjJqo19U+/H8d/eUx2E/Pe1bQQVBt0fjPxUZo/bVv629/m3U+wiOietzZr/rvBs23jbhS3pD5xCNP/PwkqfXrM5K9GUqmZSsUPIXCo1+lm6pjm9koURWbeaqys7EMqfLdAzROvf7FeOqtVTAPsVN5T5GZj63sghKj0Kt5mU8xRDXZwzXveIYJIcuXiV3+WItjs5PxuMeo2gHuntBwjIRuA==
Received: from CH0PR03CA0359.namprd03.prod.outlook.com (2603:10b6:610:11a::19)
 by SA1PR12MB7410.namprd12.prod.outlook.com (2603:10b6:806:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 08:27:25 +0000
Received: from CH1PEPF0000AD83.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::67) by CH0PR03CA0359.outlook.office365.com
 (2603:10b6:610:11a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 08:27:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD83.mail.protection.outlook.com (10.167.244.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Thu, 23 Jul 2026 08:27:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 01:27:11 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 01:27:11 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 01:27:04 -0700
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
Subject: [PATCH net-next V4 0/2] devlink: add generic device max_sfs parameter
Date: Thu, 23 Jul 2026 11:26:41 +0300
Message-ID: <20260723082643.1870844-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD83:EE_|SA1PR12MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: dd03a744-f8b3-4d54-564a-08dee8943988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|23010399003|1800799024|11063799006|56012099006|6133799003|10067099003|3023799007|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	IVnWixw+E6fdcGWwBkAg6Ps8otkqtGQFWwPQ4l6+ecSrSoTwB4adwm97218jL23DZxXhTQbKSWcwBbWl/ZADyPyZd51ww5zUt4xcjIx0PfbIInrdKsm9ygrqx3Sga+EG7Q1MNQ77DLdjx1twxYZLwgMku9dhpkHP1ySH4XmbtVWc0/FFCGckJLHBWFvfMQtWlVM7jFa4m3CTyNX+tm54d/QxnMHx0Ann666Fcr9arAYczGEXfu+soXbBXNjlJmxIquCHkjwZvxscAnmSBK0jNwF5FNBuzIlofN7pQZxPRkA2lx3ISUyoIXwRYUFD9GlL9wr2snv1MgWg31O6IJ92UDrEz2bK3d5ZEUL5nIHCkQ8KIjiUwsh737SS56wz5hQr17FA/88lFtmnvgVddpWbC91KXsVMYuoL0EUu3UXoowQ/8V3KWgAtAOYYyw3inCEO9J2nZKO/xDaTd17rHWzai0A6qEywGVLF45VCsY1wJB79o5Cf5GMVQjghSEc/v3ao0EVKFF5PexnFnW76iiyQBG12HD9Sligl1gOnlcj3WeoTVcPazAOKQ+/+2nbV9NmkxRwtB/1fH8yQxgB04fYkoX57pQPcL6XHwCUgpfH/XgwkttbHB43AJrH6zKol1fgf7OuKc+EqpUcGcgsivetrV1+n/mcBnU/llNay00KFhsG/cGhFWgiwA5YP94+AxYBsuDOjoKcOkNzny6GVjRtWQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(23010399003)(1800799024)(11063799006)(56012099006)(6133799003)(10067099003)(3023799007)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lh7GfwmWTnQGi2elgzgvBaVoSAFYHm4B3ZLYA4CJPU13py9Yaw5D2qQROLmzMxkSSIbLPHgYHs1Ygz9ANQH4tqprRLqdtZBJj/DP8RWxvwCHNAwL7U6wVBN1J1AaaODWDKFoDDiH7F37ui3YwYbdNNQQ/MPu7WMkU+LGFPmh7JfyEKGLNErjDLdN8NcFEGDUPz5YxQCkX/vWa3Sonya4eoWfyACcrWCkrij1zOoRO0Fz2na/U7A0YUcs4slagCGgTkWQKHCUeWU1yjf/Qm1v2Um2WVGTMFglkC8rLWtfne+qkyDpCVzajlWdjH8HSNp1zj8ch4GkpPw0e1B3I5FanVUCEfD4XyRapDgdAlHl0cd9Y8weHtjRpdIYzWWqVp6HOskQb2Ix82+qTYQwL/eGeMifwb0O+yuB2IecTluIeMntl70QfSM4ydZ0KT1eFYyW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 08:27:24.9431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd03a744-f8b3-4d54-564a-08dee8943988
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD83.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7410

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

V4:
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
https: //lore.kernel.org/all/20260517112700.343575-1-tariqt@nvidia.com/


Nikolay Aleksandrov (2):
  devlink: add generic device max_sfs parameter
  net/mlx5: implement max_sfs parameter

 .../networking/devlink/devlink-params.rst     |   6 +
 Documentation/networking/devlink/mlx5.rst     |   7 +-
 .../mellanox/mlx5/core/lib/nv_param.c         | 118 +++++++++++++++++-
 include/net/devlink.h                         |   4 +
 net/devlink/param.c                           |   5 +
 5 files changed, 136 insertions(+), 4 deletions(-)


base-commit: 1df10cef2d1e7f9f2fb7eddb67fc70d3abf101f9
-- 
2.44.0

