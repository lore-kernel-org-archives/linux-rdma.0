Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711FA3F4DC5;
	Thu, 16 Jul 2026 08:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191786; cv=fail; b=rKPEEYakxkT0B6QPkJt1IHGK9m97oCrtNalB0RVGwm3LNXgr8cdqEQwqcaFutgvZTKFXumVbzdi9ULCtGr6EDpVWqTRoEeViTO9WQ4CEhWqrKO44ogNaoWR7C7jLk6hkdFYxZ6yad/2vgxc3HRUpshGbkYMyva83DOM9YBPymZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191786; c=relaxed/simple;
	bh=VDZwevIGyxcqVv5LfG6ngzjHQrHMj4jQqSj+WWNT0o8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRHJCEsUBr4wwWGkDfPcNt2f0xQ/a0jPrJaXZPh3x0vjZnvJBskDDOJJqSYUqI3RvgdX0IxpdWfbVThU6vnsY/ExVMZEZ8+qkiRiplRbK9OEwVYnjfouA2QLGj8kHPxxvAM+/dgxebez4BGk2AjH/yQgKF6MYhrOKmr2JM/UWpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vz7bSCuK; arc=fail smtp.client-ip=52.101.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vz7bSCuK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4CqN7LujXMZQE8/dSoUfkAQ34GPv+oJfVWcyLAl0kTPTexbAXnaEG563OZtcizvDmv8aWBis78JThQq/j2F8K/MIN6dgbNz76LOq1P7ipluBqQIEm3BoMkh8FnoAR5mRRylJSjiDwQ5PjrFg6YgT6wHCV3Unk03P8YjI0Fqu6NzP+CvMt9LyB/yXDvfc+bLBSHJVwXp5mLCdHF91pzBmBx5/T5Jbt1h4lLm1QKCtYA1x1Q7KFGmLohiutW9PvNJVS1+D0//YHhCWSS6GOuqbMZ53D6AsmW87YCkGJBDbxoYX9hSYoxSDLAfCdf22Vksr25iBSGtvl9puVbeOf/xTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xpk7XunyHf8LwjQM12vNWvMtbCdxpmSoDfd47nPtW4=;
 b=l+hQHS6HQEBE3CUHgeCXwe3314Il/vkKMS+zZPsdqMiX+gmsuZaudJbObX1GYBGLEm75catHC3w+Nn7/r7Qh1/zPgPK3m0s0d4CzPQqksNq93gYwjjrOB94zULmKQ3f82eUYaqYT+mIdpuL8hxm3R8iwRqETm3L2UHDskmAlZ+7kWjDzMRhLVrP1wDZ8Uev2IQDt+uFwb8EmmBQNQtv4Kwpo49vC/Y9pVjrZ0JrzvyVDLnQAejV43sDT3QOPcprj+/KgUaizP3WEs4AP4nK72k+WrwJT1ojSm9fAhb05y56gV9opak5OO5fBpMeebZDNLKtuTJE+A+z+c8iAW/vmEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xpk7XunyHf8LwjQM12vNWvMtbCdxpmSoDfd47nPtW4=;
 b=Vz7bSCuKTonOFNHlspCQ+3n6hjXZM1XsmhMuXoO7R3IweHx8ObuxHTMMVggtmKQALyOGH3rFiB6bl/lQigVccbrW2W+Akv/6dy+I40O36AslqZ5nWgYLVA0IV/YC3xP73Mk5QXTsVTqP3CGGWGSPzpc69mEI7gvq/5/0Wityohbb7L5QaIkGKVN7UtwqX/9H4rEP9gO9DtAARoCEnBVVqSrFsE44BCAQ/tH0/787ZpyoqpXVxu9LQaRgGPMD5U/ZELD1duBJvNmF3epdgKM8eq4i71YyPcZILVHL4QRBnCZAlKLtrKnzJdSR8zJIblwFgflvu/orwQDF+eX/NZXxdA==
Received: from BY5PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:1d0::21)
 by BN3PR12MB9596.namprd12.prod.outlook.com (2603:10b6:408:2cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Thu, 16 Jul
 2026 08:49:25 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::a4) by BY5PR04CA0011.outlook.office365.com
 (2603:10b6:a03:1d0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Thu,
 16 Jul 2026 08:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Thu, 16 Jul 2026 08:49:24 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 01:49:08 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 16 Jul 2026 01:49:08 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 16 Jul 2026 01:49:04 -0700
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
Subject: [PATCH net-next V7 2/4] devlink: Factor out eswitch mode setting
Date: Thu, 16 Jul 2026 11:48:50 +0300
Message-ID: <20260716084852.549909-3-mbloch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|BN3PR12MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: fcaf9319-781a-44f6-97a5-08dee31722df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|376014|7416014|82310400026|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	FOAG14MG2sLooyZycIOAezpkyQRP5NtwgCxsOm9wSyK6YUrRxldekFuF/UMcdWJSSbdYo/i7hbfeIXyQWf6GZmFNBz1ewkO4rueXrxSXBoJmfHEdSQO8y1lCFNA4cPxViLE555GGxKeXhdh0L4C1ukIteV0vx0ZJOyFTYETH2xIn8P89jv1gQTx+Y89aVZeMEOhm5/7PV5ns32LUlSVv2mV1trBgc2pH7sVYE1jsM8l46xnQeRPUMBUMma9Ri5IwpmlQsl2uW5dVQTNUSYxyQN5sepL3xrXnwMzhOD49NrImpWqEpbgrTFEKJ6aoARw/2obKe+Fj20fnvgyi9jt3cYLxOCB7xHRPtdijBdZimufWiS3lQ06D2ng8AH8GEO65tEKxpz3f0Ceyote/zKLBMW4SxHUuH78xxx/7ci1moOf0Q+U9lOJOl60hPk4LlPN0nENSsT0G9MVdkA3DRPIDe+c6kHNlAJBsbXzWdDolC2PcH1hZcnMiPlD6OZ5uAy2dCBhVZhzVkVXzuAvedlG9rQEpyPR/9N9MpKWziyLFSQ6a8np2XZga1P4vckkwEJTB3J/H3CuUCAOnVbWhSRywhDwEWB3lXA8uKmPv99MhmIU619skS9CMn2fi4l+hqF4Xe8lnxrdhVyxOoB0G50CCzpfabUu8d7nraKe5bCzzh/6Si87enJkBIiPEyHQlpEeN
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(376014)(7416014)(82310400026)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kCQWhADhUWtxmEMPGvpzXrt4ssqoGXtYGOeHQJ4hFL66bCiQUPminQ5rKd/EqBUdjE8pJubllvKd0maTghgQFleeo6QXS8j1zACc+Fxu3JIBoiV4S0KchS5oz5/MLOmXdIK0sY2Hjlg3UoG52nK2x7ueQdnOgscSpaQ6x4Oj/VzUvN72P9YAdoxQoW+v8Oc1ymkTVZFS7mx2wRkupDW89wasM7g+iZESljhSOcrB5QAKp9TcRdvICPMMRAyLqGJmseI26Z+rXYnABJBwdwvSstYbuIsfzDhXwpz9F+BNInu0h/bCF/K+hSnS5Nj2KxP7AXZXuy/OiQhJXgOiteCmSTrQHD66KxIq4stX1HkE7VKA/C1ccSIL2jaM+pkKpuI4qCTuRKjO1N32PDkmM7pOXU7iR84FKJmhP620LmDa0K5Y2KlYK31D3lb727K8f6dl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 08:49:24.1029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcaf9319-781a-44f6-97a5-08dee31722df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9596

Move the common eswitch mode set checks into a small helper and use it
from the netlink eswitch set command. This makes the same validation
available to the devlink core path that applies eswitch mode defaults.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 net/devlink/dev.c           | 27 ++++++++++++++++++++-------
 net/devlink/devl_internal.h |  3 +++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index bcf001554e84..119ef105d0a7 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -702,6 +702,25 @@ int devlink_nl_eswitch_get_doit(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
+int devlink_eswitch_mode_set(struct devlink *devlink,
+			     enum devlink_eswitch_mode mode,
+			     struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink->ops;
+	int err;
+
+	devl_assert_locked(devlink);
+
+	if (!ops->eswitch_mode_set)
+		return -EOPNOTSUPP;
+
+	err = devlink_rates_check(devlink, devlink_rate_is_node, extack);
+	if (err)
+		return err;
+
+	return ops->eswitch_mode_set(devlink, mode, extack);
+}
+
 int devlink_nl_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = devlink_nl_ctx(info)->devlink;
@@ -712,14 +731,8 @@ int devlink_nl_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info)
 	u16 mode;
 
 	if (info->attrs[DEVLINK_ATTR_ESWITCH_MODE]) {
-		if (!ops->eswitch_mode_set)
-			return -EOPNOTSUPP;
-		err = devlink_rates_check(devlink, devlink_rate_is_node,
-					  info->extack);
-		if (err)
-			return err;
 		mode = nla_get_u16(info->attrs[DEVLINK_ATTR_ESWITCH_MODE]);
-		err = ops->eswitch_mode_set(devlink, mode, info->extack);
+		err = devlink_eswitch_mode_set(devlink, mode, info->extack);
 		if (err)
 			return err;
 	}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index cdf894ba5a9d..af43b7163f78 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -348,6 +348,9 @@ bool devlink_rate_is_node(const struct devlink_rate *devlink_rate);
 int devlink_rates_check(struct devlink *devlink,
 			bool (*rate_filter)(const struct devlink_rate *),
 			struct netlink_ext_ack *extack);
+int devlink_eswitch_mode_set(struct devlink *devlink,
+			     enum devlink_eswitch_mode mode,
+			     struct netlink_ext_ack *extack);
 
 /* Linecards */
 unsigned int devlink_linecard_index(struct devlink_linecard *linecard);
-- 
2.43.0

