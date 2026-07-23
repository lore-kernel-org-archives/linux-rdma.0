Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A443F6C2D;
	Thu, 23 Jul 2026 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795265; cv=fail; b=UDFwrHkvZTM1OQsa00xhhrgQMiplLmXFyuQRjOsoDjn9qtampVoMg7iK7WLh8Ad/qf7arDhYD3amBgLnBmJ0mQNhK4FtXFJtii+Q+b9bDUgVEqTzTelhVwb+6RvVCNG54JdNYguBM+zCOvaJt2O0AUW7zzYxX31SKXKHisPsTgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795265; c=relaxed/simple;
	bh=3PJZJ5n5dQ6gsJHxtZ2Ls4rZFlGB4AtPGL1GCAxepAw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ps0JAUY7mqG4IAnTBD/dX8TikUaMyv+G/rUng/JmTntYwEYTfqPu5yjsXfZtiOfFTotkKQls1+P+etYG09n3dfADk7FVvSNUF1xq8JQaBNNCyMXg6It0NBkaKKFWEkyOkhFOHOtv3KF0gPN8gpA+ca20ELO9ECZbxWx+Fb3NbYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q49H0CPd; arc=fail smtp.client-ip=52.101.56.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q49H0CPd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeRIKpdB1tJJIwKm22HIK8/frvGVfHxfi2HtEYztPl8O+1kNPrdVALjvJ8DgHNhHayIwXRkXxWcVIXsI6YktuWSrG6jjM5VcRVl+5aHlg5L28OjvvTMghSfX8BPm9vj1AveS/6BX1lXYKpfcFfqBAJlBQJtTmH6ytFwrhj/svq7SKTaY8cEyP7Fz2Duc7k+gkepBb6a/C27nbfmw2ZHcnx4h/vNuVns5XB9Uv5wvudcWzZhSSk5fg5OJBfZaniLXsanVItMEN+vGUlqj7yWp1H11hkLnZPh8cd3jpj98t0LnUPenS3zX4AopEK3eG8DxVhtIyLeFI3Gp/32pJYykxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIzyOFZpJaYQtlcJKTIobJC9CNCGotPvLHI/gqy5Atw=;
 b=Z8RZveWwKLNLBIvuDkPHT6SNAooyZ3U+YwLQhMFAJykIrGc/eM0iXt15S7DFeK993jC7GySRDEfaYxcq52w2FsYZIDqxsRsxcpCXl+RWlM7E4JuYSQuVtnTWDWPLa9gGNUoxhWNX+GtCIQ+JlsRsckzEC/RKhx0Duc9aF9HGeETtYjS6PVnyEa8Lia8wIj4jVW+3CEd4RlVnRNAfyd3vuPEJs58eKmfWVShE47FJXtRqsGsQc+cOY0lQtB1i+9cUp/oX3klAxBmnga5ztVxpwyAoCvrVXY+mnaZgfWCpxTOb+SESf9SVk3U46F2R5ahe99H2gJVzyvx2MluWp0+mPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIzyOFZpJaYQtlcJKTIobJC9CNCGotPvLHI/gqy5Atw=;
 b=Q49H0CPdGhAC0+jSCvmn8KHJWRNExbswCiEzw5mpWEKIDYrtfW19hQPl8YOV7PHBcaAIi88vjOrI7BoeA+ezXV6wWYXdc6Cmkl48QlP8f3SDxUceeDISJt4nBDQNWS/1ZJN6hFKzqfYKBOB1wkHVZ3Nj27oZxt8gVNPBYQf6w6pmrT18yOADm4JGw7i915JykiQadBjaFlsf6SJ6pgV1taaZ5QVegnZU2jDcx8U6bNg7fx4CCyA0at5KE4wXfGIaT0cpCAEXL0NDDykQNRXly5OzROhHvJjEFaoE4ZN0SqCuxP2iCMlL/5gEaiMczn+7h1wdDtDxVWFPTiLa69j8Zg==
Received: from DS7P220CA0097.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:25a::6) by
 CY5PR12MB6384.namprd12.prod.outlook.com (2603:10b6:930:3c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 08:27:34 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:8:25a:cafe::22) by DS7P220CA0097.outlook.office365.com
 (2603:10b6:8:25a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 08:27:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 08:27:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 01:27:20 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 01:27:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 01:27:11 -0700
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
Subject: [PATCH net-next V4 1/2] devlink: add generic device max_sfs parameter
Date: Thu, 23 Jul 2026 11:26:42 +0300
Message-ID: <20260723082643.1870844-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723082643.1870844-1-tariqt@nvidia.com>
References: <20260723082643.1870844-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|CY5PR12MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b96deac-3e3c-4260-7469-08dee8943e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|7416014|23010399003|376014|22082099003|18002099003|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	wqjAd3raF/2I9Ib4giXlUSv94UMHp5GU9Wc32YR84z9DyHRk2GGb1lppLJl2TxIU8ZbxFoKBBCpwgjAyR+hmMbGeIXqLvOs5dMpXcaxypcIRNPOwChRGIpyI0Zxqvx4vjpRZhvGc6iD6m1bcEPvVGbSXvIm5FnFn+XQ+fWBum3HO9fKk6FTx7f4Pean0lB2BB9x8nvOqFVqOU1XvFJptuyRtlmyfAOAlNw6V0vcT7fYDxtmQFItDjUdwPUo7/AAT0384Ojg8jfpIAz5OS2mu9W4RxdxjOiccd12ab/9/fDsEGnHGqBlO+2RbqczZjQJbHJ+Cp9HKceE34qxTuw0GNT2AuJINlJxwnALeU0OOuofwpDefFwamsEAKxW88Gv9M5AbCYO2jnHEp7aEW3DOSqoh0z3+mXuuIK2Wbp7X30oP0Qs8CWlgYU7Jx9f18fq9kPl/OrfL57dybqg+R2ycGvE+yZcN366r/rRMelKNoootuZZlu47JVOvF/sN42waosBeMGGohOiz8+bOMYXzMmsYDc0kNzOhQQx8Cy984TCmz8u1KHTV8o1kcqiMY78U50gdaufS0WN5cPL+Ue2e8apUyrtQDPnB3Gal0jTldjo0cZe+DOoUiqc8cdFW+3jGkt5OfpNADQOLZQkvCG3zgi1dZUj2re5PUhpSH5tBi54rYw46bqrON3oDorL58YuDOyWXdc8LOLmPPeSYldQMEW2Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(7416014)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	frz1MyO6q9IBEAc1gP0GLmfoERM4XpDUm/l9a2K/Q5ffiiG/K/++yFteudH2Kf7lka6RnMXvxfYVzdVCKX8FZJJaxF55ScX5JmgCyvzi4SpNAxxqnb3N075VauFIvPBA4DJAJ/6Fh0afKev3W9GzpAz3SG+TKJulYPhIr9xpcLG6EP+r9vJ6ghtOn+dvJFIkyCVO1gukKNrZyDVAqCqQ0eqYnBv8Y7HvM0iWWpGKb9wWr8TX+vdPCNQ/d07Mc9CD6WfQho4M79RB7/9l4JRQR42uBMBjSiOZXnhouZJscmoMWBIVIXbhJtl1ijQhM4ZRIqfhod+fQMtvm8RO0TjTjzKwiG8em7iVIAfKO49Bx94RPt03F74PHbH+IQZdkUZl2R4gWz16JT67jr19RhE4Lob7jLnwcRIJK90DqNlZBFJDQNVXs9DIvPdtTh0jEtK/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 08:27:33.0128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b96deac-3e3c-4260-7469-08dee8943e52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6384

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

