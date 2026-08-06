Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539063CB8F1;
	Thu,  6 Aug 2026 07:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786001507; cv=fail; b=mIz1rC2tbaR6oWzKZzuEZrWDRECsXzvRco+mKEybwTrk6SYuOeXgJI4ioqV3/t/SVgHUk09uh8bVgTPow8jIN/f9VwvxLMHFgIoiCvHhlQPIYNTlaG1jUQ4rHSEf/ndH09uC963u9/WX9DFtg6kOjxShNhrh5PhYLar639nZU3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786001507; c=relaxed/simple;
	bh=3PJZJ5n5dQ6gsJHxtZ2Ls4rZFlGB4AtPGL1GCAxepAw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qXU6YvMptKI7L88ICr8gztF8IGKOdoDnav+rXiQhNh4xHYsQQec8mzTfEPGd7xoNnM6e4YZibr2yuGY+eW9kLjqQvMHwRy3QGVNAFuqaVQEFBSacu24ENB1Oxr/iAm+nOSxTjgEbso2S7YEck3kiHWAgqLfK8hTS2OAfbiF9e4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ElIYj0c1; arc=fail smtp.client-ip=40.93.194.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ElIYj0c1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hB/vqRI7B4iEjFlmBQ3IZTlOLyrL4DEZg9x3KQE6NCTlh8pvj3O/wYt54FdRhdcbofCWJJkfgR7XMGWvm9t7mz+6GJh/LP+5PHFH4fx4Rpg9G7kJ0ltn2EBD7UwY8vQv1A1QZcQHiSu+pUMGIMFk3kA013xjeZQ1OIXX0LDT75BqNfJKPsUOKNT3xKEyuiN0xfWQK2Qz8TyzFpjWF4pS050hBzbfgv5Zgnjsr4Wu7SET5y6PKkWmBqZFj4f4Ux3lb63Uhvex3p9iCbXGwc4lVD14+Mw/2bUTT+KRMzYDnzGs5cKou/FK90elB0S06vQU/iUYcj6/uE0xYWoJI0KgqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIzyOFZpJaYQtlcJKTIobJC9CNCGotPvLHI/gqy5Atw=;
 b=tSrZ5yDLSCTRaBbOPvXNmkEV6H+X8qID8Ve8iXWm5lC9lUvPLj3ofDYCPgctY3e6xcJIUsGLEC03sRYRta3LK31oR7RJlWUr4RGaGIQTdfVt5pc80d+4/mxuHSQ3zd1+5zVsM7o6HMwqivS5kHdZbvezdPSAipQuvCa6LbtslqdndoEOvYtGejVbwR+3MjsBaTEdHKrvD2VpSXi/MPhkyItLHdV9AgaSjHkg9x7Hsq24jzsLRhVtubP2j99HsLm4+V55VhaZZEE9E8UoWsnEU6TMeKEM5M9Mdhsf1eTTCbqPlhEHcdktdTXaHrsv4Ftv2NC/qZgc4mjUXYp7WG4+Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIzyOFZpJaYQtlcJKTIobJC9CNCGotPvLHI/gqy5Atw=;
 b=ElIYj0c1XboQJI/fKFU+U4LRx3N9pyRtdS0RWYWXh/goRGocQ7+aLxsCV6aav1X0JjpP3nDD8wO1RsUWeLFI/vQlQzoUT/ceK/hYHiZgvMUjgzwWAejEpu+8KQDYx33+rvDK/zujKa60mXxSnqiVQ4lHmL5vNLmOsbgTqkco9OVyVHdvqZiolseIx/Xriy5wtbtrC3zYrkmW7Ky5cVj25fMhsc6Lf+WuTjP4YDpfhJb8cxeTvmPFCvop57+fG2K0HrohNeQnDCFSe8pha92pwxdSlyJa4usYoPnT6bPn4XTnCvbqvlUpZLFOFRRs/p1rwer4oEHRoO15r2hn1VtzJw==
Received: from PH8P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:2d8::6)
 by DM4PR12MB5771.namprd12.prod.outlook.com (2603:10b6:8:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 07:31:34 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:510:2d8:cafe::21) by PH8P221CA0027.outlook.office365.com
 (2603:10b6:510:2d8::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Thu, 6
 Aug 2026 07:31:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Thu, 6 Aug 2026 07:31:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 6 Aug
 2026 00:31:13 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 6 Aug 2026 00:31:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 6 Aug 2026 00:31:06 -0700
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
Subject: [PATCH net-next V5 1/2] devlink: add generic device max_sfs parameter
Date: Thu, 6 Aug 2026 10:30:36 +0300
Message-ID: <20260806073037.3001886-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260806073037.3001886-1-tariqt@nvidia.com>
References: <20260806073037.3001886-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|DM4PR12MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a002d63-8c24-480e-0ae9-08def38cbd7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|36860700016|376014|7416014|18002099003|22082099003|11063799006|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	bPE3r9mMAm7Z+X1bpzNACEeZlRHF5sRtn8d4YUnb1K3l0LmpZAPhIzCrTTKHmzJLnvNo8/YuG4Y6EXp927/rAD7z52EMW8jmJkV/Ps1j+Ydn/XDhaPw+1JZTOdNasEyQ9l2MXxrqDGqE9CajRTEsJgmX1HuJ5L9s/gN20lj5NHCDnq6tzVOotCWn+zo1fmMYimK8ElX67bRXEiF8uVd94BlAKSrdK8XEAjMwlhcPKOpQh7iaPaymtyFckAePyMLYQTW2mcIAyf0j+Yx98NDikO0e1kR0+R+hqJwcpF+8/ecZF2lDK2Cg2SXWx9tgOnMSCy69sNCcYAjWAauojgSPH+JVlrMqXxiMZHT7uI57xBWJN2s+KPky6x8l+BjWeKYHgBoZ4pS3SLvrtdbznxZOkeBZPNq5EqzdORRV9RkuuvBex30hzgf7iAA5O1Uq3n5FoOixdR/bz3ZH4dS9YuKqQdhkgd9u9HhfEwrsOMdier37812flH3DiAPp79YyuGLcdf2BIb65du0ALirRdV2WZYRpYGD8ySFJXuSZbO2rdnaIrIWFWo8TU+0Zr6PJIuksD67M2q/zBj4aE3TZ2dZfvO4oJ4xAhUFAGVrM1NVbRBMVwgMkWT8JwVQCunNB1+1vdI5Qf92Ma+fM2sPFNSf3JKUKgNY/0VsG4JLaILruOmC4QEr32RQu/U0zsPQKjuwML0mXoqLbzQXSm6nJvarfmw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(36860700016)(376014)(7416014)(18002099003)(22082099003)(11063799006)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vItmtIluCpyk55KXo+kBbedz2N3By4LUVM59jmEwuSm2wmkT+zzDLlgnDqKlqNgWol6SMAMdtPaE5YxREHuqqmOG6HDCkLE5n/DJpIZeGp19thy6o3085ehgPR3zUnstJqEXS0cU351hT/aWuYXHJqK42Dn9H7oOdB7/KgIFyvCv/6p5hz7x2ccWP9fYAOQ1qdkKOIBomqFMKK6la9/zpHoh45I6NZ7Pe/LaoT4cQGefPWNRcyv28NKLCvQbyLZNmR879rG1XG6i9UQFr1z/0EenukxHXoUbbXar12Mav5zGt/hGNMEwPlycHFQn/WIPb7+P0BSA9qB1kE8VSiyvlxyLWIcwtvoY323zUlFmmB9LSnV1gG20VHF7jhsV7+SxeE4yeYGJ5rl6694Y3wcpBwhFqZwymXN+HriTQGKonSgR3PK9KAK9tKjL3lRV6C5Z
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 07:31:33.2499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a002d63-8c24-480e-0ae9-08def38cbd7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5771

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new generic devlink device parameter (max_sfs) to control if and
how many light-weight NIC subfunctions can be created. Subfunctions are
a light-weight network functions backed by an underlying PCI function.
Their lifecycle can already be managed by devlink, but currently users
cannot enable them in the device. They can be enabled/disabled only via
external vendor tools. This parameter allows subfunctions to be enabled
(>0) or disabled (0) via devlink. A subsequent patch will add support
for max_sfs to the mlx5 driver.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++++
 include/net/devlink.h                               | 4 ++++
 net/devlink/param.c                                 | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index ca19ee3e63c8..13eb8aa84c38 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -165,3 +165,9 @@ own name.
      - u32
      - Controls the maximum number of MAC address filters that can be assigned
        to a Virtual Function (VF).
+   * - ``max_sfs``
+     - u32
+     - The maximum number of subfunctions which can be created on the device.
+       Modifying this parameter may require a device restart and PCI bus
+       rescanning because the BAR layout may change. A value of 0 disables
+       subfunction creation.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4830aba4087a..7abd23376319 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -554,6 +554,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_TOTAL_VFS,
 	DEVLINK_PARAM_GENERIC_ID_NUM_DOORBELLS,
 	DEVLINK_PARAM_GENERIC_ID_MAX_MAC_PER_VF,
+	DEVLINK_PARAM_GENERIC_ID_MAX_SFS,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -627,6 +628,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_MAX_MAC_PER_VF_NAME "max_mac_per_vf"
 #define DEVLINK_PARAM_GENERIC_MAX_MAC_PER_VF_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_MAX_SFS_NAME "max_sfs"
+#define DEVLINK_PARAM_GENERIC_MAX_SFS_TYPE DEVLINK_PARAM_TYPE_U32
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/devlink/param.c b/net/devlink/param.c
index 1cc562a6ebfd..8ca0f3ed646c 100644
--- a/net/devlink/param.c
+++ b/net/devlink/param.c
@@ -117,6 +117,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_MAX_MAC_PER_VF_NAME,
 		.type = DEVLINK_PARAM_GENERIC_MAX_MAC_PER_VF_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_MAX_SFS,
+		.name = DEVLINK_PARAM_GENERIC_MAX_SFS_NAME,
+		.type = DEVLINK_PARAM_GENERIC_MAX_SFS_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.44.0

