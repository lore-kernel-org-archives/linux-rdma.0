Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787E828C2BF;
	Wed,  1 Jul 2026 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782891289; cv=fail; b=jzSZs5/tSvnokNIuEnoNu2QdSUwfIgqyNAVuuVZMmJ4+Yp2UJfsNh594Ra+On7obEBuVZAfuY3ZOEpf22FXFhvelV6gmP59pJEWbVV2I8/eUn51Cb+1lOYGrqgz2a+QdasdGyA2ZD6nGDfQpbuvjnSwl7NYimxU/Xr9oN9A1GLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782891289; c=relaxed/simple;
	bh=p7IpDsna3Ov6RA2NW2CnsU0KLvXxvm5/oLLnX+s0I80=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DsYkY/vVnCTwCz2bz9JtYbnvq6jUNGNKeUKyt04agaV1qkYRaasVNNQVU/6hvBiqFPMM/z8b37W9hE7C5pd8xfScvp2ZJ88Sn11NbHYCmpZ4y6gTl9q68AV4IyJsnw2bJw+flQKy6nlxFqXrUB625vyM7DkxIZDSw+3aICML2LU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d3Tg/qtz; arc=fail smtp.client-ip=52.101.56.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d3Tg/qtz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkJdQxw35v/FrGvkVwEo1kQsIQ4sHtDfYOtL3icThYKfMGO8RFRErbbnqi0QUHNncH6NuzR1tIFARk9vbzF2aiBc+Hxb1/xFR7ljBi9ZhQDl70Ip5bEn2So3sr+g9eXYcMSsOOgh8NySlxZIcFckSD0KnSqkZVTnKhqTlv1EmI1QksIYILc28OlUvoYL5ALcsLwqy4CTP3vPjy2OtiA5Vlja9nW7BFx3AQqNl9T9a0+WVFzJ68csbbUek52dIzWZjZTSdlkWwuwOTAYOUBCrBEXqOYxIV6FaK6XsqmLLTnqpzzQpbD7ruV7MyGirE4X1cxqXSnWns6beN+V3wJpmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHLYi8dcw2pV79qluL5W/rwwza7CbhC0qkhc/cecEBA=;
 b=fNS2VPzvgl/1xLwTyUVo4nqlTyCi/Z30nCfN8r9Id53Redoxby8qnJix4B+ExmQD3OmRkkkiN1UAlkjJHvlmw1wxx5Pvbj4y7MTNPfB9zkkVTY0KCoPQpGgd0Fzkj0PuF8M70cJ62jLfBEzBDm2eHrNlMK5ZUkhXsLePBh3ivG2pMSBwUpLTS3L4iul2EcciYaKA/moELuTeADMD/rdGpE60NyKENdaPlUGNT/PmhVJpMf7ZZueDRBN+N+ZsbWhNk/ge7E3sXDOuUq7/MAbOK+S2FOwjyD4mfnR3uLDCo9z7OI3Jo7zN5EoddFvU7RFvTBi7YE/u5BAm6Bno7LZ4fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHLYi8dcw2pV79qluL5W/rwwza7CbhC0qkhc/cecEBA=;
 b=d3Tg/qtz+YPnMNDuMKANqUdzo5SpU7bRs5134Vqt5x0bKiNnZGOZllAHWXUWFSag/cNyaAy4swKq7NujR0fFwsDRsylNPVEXNltbfQMwxx0gKE+0qI+/Am6SkJIUEQ7t9Z08SlRDxhpLFmERq8k8mIKAKyBQeJM2mv8dY/6lPys9iXI0bZvtChsEXJ98SRFjwkCDsbeJpB2iIELZnJVSOunCQiU8HJcEtb8nIcOipOABXWr/g1Dgj/AajipTtpxaiu0sbQoaIDTsozIr3GCWYLX/1DNnOhmBTdv5a3wjupSkZJ4FiAm4Lpir1UEWY9yzMsLm1MZNJ5MobNeiDZO1bw==
Received: from DS7PR07CA0012.namprd07.prod.outlook.com (2603:10b6:5:3af::20)
 by DS0PR12MB7827.namprd12.prod.outlook.com (2603:10b6:8:146::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 07:34:39 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::4) by DS7PR07CA0012.outlook.office365.com
 (2603:10b6:5:3af::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.9 via Frontend Transport; Wed, 1
 Jul 2026 07:34:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 07:34:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Jul
 2026 00:34:14 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Jul
 2026 00:34:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 1 Jul
 2026 00:34:04 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Jurgens
	<danielj@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Donald Hunter <donald.hunter@gmail.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Jiri Pirko <jiri@nvidia.com>, Jiri Pirko
	<jiri@resnulli.us>, Joe Damato <joe@dama.to>, Jonathan Corbet
	<corbet@lwn.net>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Petr Machata <petrm@nvidia.com>, Ratheesh Kannoth
	<rkannoth@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit
	<shshitrit@nvidia.com>, Shay Drori <shayd@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Tariq Toukan
	<tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Gal Pressman
	<gal@nvidia.com>
Subject: [PATCH net-next V10 05/14] devlink: Add parent dev to devlink API
Date: Wed, 1 Jul 2026 10:32:45 +0300
Message-ID: <20260701073254.754518-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260701073254.754518-1-tariqt@nvidia.com>
References: <20260701073254.754518-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|DS0PR12MB7827:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dd0662e-621f-4c7d-b35f-08ded7433543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|82310400026|36860700016|22082099003|18002099003|3023799007|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	OSaRHLEImoziKbzqMruD1nbaqWDaHwfrL4t+gUEBpiVMUbTXc/wvqri6mkzaZesSl//noQYRFW9iCuccNLGbdmd1CnQOAsGiRYqxAJPE7P8PSje7CR7++sK3xKhzJxg9YLdBYc0ITF0LYvRfvFyWon9D4nmQGG9KTSp5aBDgsECCEB8ZI1LRuStRRR2jLU6Mu9ckRIYu0rcOXByvGLmie7xcs46re67T+CZziCUgfwy7w+5SeoBG3Ih53jfHp2wucu5N4bVITRnJTNVD5iyqZqcGlToe1IzKGI3NbsqwRgKJ8aVfM3rQLZgBwxvA841WBSEeEBaqi69Ghjw/mcbRf2fkhMJk81jf/mc183y6snDvAHJ8pR+K40GghvWBA88AoiMOuRSSrb1DpRsERJbB8/TpEW+z7fF/vJjy8HqzAk8Ds6Of6HYtgqmRcIlYYogJfG9N5PITddCwgpo6hp/jRTZktqL0ybJNUvZ42LQh90QsiHndVYgxyMxtM/0FFPhadcJ0mwXMT7mxQw9FxTbSBEVoxjlV1MxrCAs5rA94Ns67BrecuS/HFig3RaF+4va7/LHJeJf//PWy4rozTaABjdgSQFivZl5vBJssD0CWlnUTIsJ0Dkyr+ZyWab8jJ30AR/c66EmavGpaNK/09OBLyR2wkSCg5uxkBpBIl/ivMS1Aq/GS0JkVS75ZSkWXcz8dNWQ51whnQCFL9egYomwKBg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(82310400026)(36860700016)(22082099003)(18002099003)(3023799007)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ux93eM1ytoTaFlKBWqU/IC0e75EFuAjEkpcqip9IcZDobh00dZZFV9fF/A0GRjRCMB66HFsWIoWB3SIpqaXIxnWRnqXkxKlV4hvcwsQWibpG0W/Bkn/0zBQABWRm5i3dA2WpSMIOUomZjrUBrEhdSk9+LY+SbBM0Gy7zaq7jZ5M/vshiRbUNWHbjbtGHVxvnvGhqPTRfyPpZJOtRcLHsQcWcsa2od5Ih2cam0ExHj03Sw5HREmCByqISGcGWj1LqL6BSzx9HSEbTxzScjN+3Q/dZbxA3uQLMZbROg970leHQfNcGiW0jk6NEPVlL7FS8OFio0mV+opWHV6xqcDGRl5mSQ1xB7LavY3AWLn956UUlnMPP2WeWMVQtMWm3+2hp1CA791tc/sOhcTjZf6ef4n9hvLwYWqd9qI/zmck0o9aTObLbLDB7HdmilP+bRGHI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 07:34:38.7375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd0662e-621f-4c7d-b35f-08ded7433543
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7827

From: Cosmin Ratiu <cratiu@nvidia.com>

Upcoming changes to the rate commands need the parent devlink specified.
This change adds a nested 'parent-dev' attribute to the API and helpers
to obtain and put a reference to the parent devlink instance in
info->ctx.

To avoid deadlocks, the parent devlink is unlocked before obtaining the
main devlink instance that is the target of the request.
A reference to the parent is kept until the end of the request to avoid
it suddenly disappearing.

This means that this reference is of limited use without additional
protection.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/netlink/specs/devlink.yaml | 20 +++++++++++++
 include/uapi/linux/devlink.h             |  2 ++
 net/devlink/devl_internal.h              |  3 ++
 net/devlink/netlink.c                    | 36 ++++++++++++++++++++----
 4 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/Documentation/netlink/specs/devlink.yaml b/Documentation/netlink/specs/devlink.yaml
index 52ad1e7805d1..13d960b3abb1 100644
--- a/Documentation/netlink/specs/devlink.yaml
+++ b/Documentation/netlink/specs/devlink.yaml
@@ -895,6 +895,16 @@ attribute-sets:
           resource-dump response. Bit 0 (dev) selects device-level
           resources; bit 1 (port) selects port-level resources.
           When absent all classes are returned.
+      -
+        name: parent-dev
+        type: nest
+        nested-attributes: dl-parent-dev
+        doc: |
+          Identifies the devlink instance which owns the parent rate node.
+          Used with rate-set and rate-new to parent a rate object to a node on
+          a different devlink instance, enabling cross-device rate scheduling.
+          When absent, the parent node is resolved on the same instance.
+
   -
     name: dl-dev-stats
     subset-of: devlink
@@ -1317,6 +1327,16 @@ attribute-sets:
              Specifies the bandwidth share assigned to the Traffic Class.
              The bandwidth for the traffic class is determined
              in proportion to the sum of the shares of all configured classes.
+  -
+    name: dl-parent-dev
+    subset-of: devlink
+    attributes:
+      -
+        name: bus-name
+      -
+        name: dev-name
+      -
+        name: index
 
 operations:
   enum-model: directional
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ca713bcc47b9..a6801feb7744 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -648,6 +648,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_INDEX,			/* uint */
 	DEVLINK_ATTR_RESOURCE_SCOPE_MASK,	/* u32 */
 
+	DEVLINK_ATTR_PARENT_DEV,		/* nested */
+
 	/* Add new attributes above here, update the spec in
 	 * Documentation/netlink/specs/devlink.yaml and re-generate
 	 * net/devlink/netlink_gen.c.
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 52c8bf359dd4..cdf894ba5a9d 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -154,6 +154,7 @@ int devlink_rel_devlink_handle_put(struct sk_buff *msg, struct devlink *devlink,
 struct devlink_nl_ctx {
 	struct devlink *devlink;
 	struct devlink_port *devlink_port;
+	struct devlink *parent_devlink;
 };
 
 static inline struct devlink_nl_ctx *
@@ -197,6 +198,8 @@ typedef int devlink_nl_dump_one_func_t(struct sk_buff *msg,
 struct devlink *
 devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs,
 			    bool dev_lock);
+struct devlink *
+devlink_get_parent_from_attrs_lock(struct net *net, struct nlattr **attrs);
 
 int devlink_nl_dumpit(struct sk_buff *msg, struct netlink_callback *cb,
 		      devlink_nl_dump_one_func_t *dump_one);
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index f0a857e286bc..5a057dc86b0f 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -12,6 +12,7 @@
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
 #define DEVLINK_NL_FLAG_NEED_DEV_LOCK		BIT(2)
+#define DEVLINK_NL_FLAG_OPTIONAL_PARENT_DEV	BIT(3)
 
 static const struct genl_multicast_group devlink_nl_mcgrps[] = {
 	[DEVLINK_MCGRP_CONFIG] = { .name = DEVLINK_GENL_MCGRP_CONFIG_NAME },
@@ -239,19 +240,39 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs,
 	return ERR_PTR(-ENODEV);
 }
 
+struct devlink *
+devlink_get_parent_from_attrs_lock(struct net *net, struct nlattr **attrs)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static int __devlink_nl_pre_doit(struct sk_buff *skb, struct genl_info *info,
 				 u8 flags)
 {
+	bool parent_dev = flags & DEVLINK_NL_FLAG_OPTIONAL_PARENT_DEV;
 	bool dev_lock = flags & DEVLINK_NL_FLAG_NEED_DEV_LOCK;
+	struct devlink *devlink, *parent_devlink = NULL;
+	struct net *net = genl_info_net(info);
+	struct nlattr **attrs = info->attrs;
 	struct devlink_port *devlink_port;
-	struct devlink *devlink;
 	int err;
 
-	devlink = devlink_get_from_attrs_lock(genl_info_net(info), info->attrs,
-					      dev_lock);
-	if (IS_ERR(devlink))
-		return PTR_ERR(devlink);
+	if (parent_dev && attrs[DEVLINK_ATTR_PARENT_DEV]) {
+		parent_devlink = devlink_get_parent_from_attrs_lock(net, attrs);
+		if (IS_ERR(parent_devlink))
+			return PTR_ERR(parent_devlink);
+		devlink_nl_ctx(info)->parent_devlink = parent_devlink;
+		/* Drop the parent devlink lock but don't release the reference.
+		 * This will keep it alive until the end of the request.
+		 */
+		devl_unlock(parent_devlink);
+	}
 
+	devlink = devlink_get_from_attrs_lock(net, attrs, dev_lock);
+	if (IS_ERR(devlink)) {
+		err = PTR_ERR(devlink);
+		goto parent_put;
+	}
 	devlink_nl_ctx(info)->devlink = devlink;
 	if (flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -270,6 +291,9 @@ static int __devlink_nl_pre_doit(struct sk_buff *skb, struct genl_info *info,
 unlock:
 	devl_dev_unlock(devlink, dev_lock);
 	devlink_put(devlink);
+parent_put:
+	if (parent_dev && parent_devlink)
+		devlink_put(parent_devlink);
 	return err;
 }
 
@@ -307,6 +331,8 @@ static void __devlink_nl_post_doit(struct sk_buff *skb, struct genl_info *info,
 	devlink = devlink_nl_ctx(info)->devlink;
 	devl_dev_unlock(devlink, dev_lock);
 	devlink_put(devlink);
+	if (devlink_nl_ctx(info)->parent_devlink)
+		devlink_put(devlink_nl_ctx(info)->parent_devlink);
 }
 
 void devlink_nl_post_doit(const struct genl_split_ops *ops,
-- 
2.44.0

