Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011000.outbound.protection.outlook.com [52.101.57.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC83F4DD4;
	Thu, 16 Jul 2026 08:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191790; cv=fail; b=gVsMVBLXLU6xb5D8B+ma87hJ74Mdgs6dgMECJvzYjgc+MrCLtV8zgmPUCnodrYS3DMUSgQsVBSmijx3NG2PunsLHQGxXshd05M++pGmp9aGLbalIeWkbRWyfwaMR/G3w3CTFdZDLagud+faRXPfj5Vlv3TnqBoV8fsjfwttgpzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191790; c=relaxed/simple;
	bh=RaDIcGiKSn2n2iFkLULtWlPwZwkorx/MQjGmFbzzrbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+kmXV+OnXy5E3X/sDgsEVS/J1aotShI0GRJlmrsFPko6A7C+Rvrb9FzBb1LjFajYGtFi+aoMHiJ7xGWLwZFUZSOZ0dWmX6Fi+Xj+0x7zZuTX9V0XgfOm5MejdZ3m26vjfR3IHq+rfDnezoOUMrZp6fp9qq8JMsK/XZSeVJxjMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X+/YL77L; arc=fail smtp.client-ip=52.101.57.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X+/YL77L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpPR6vGGp5cnNy/XdsCouAZ5myqmg6BfrJzCBKthv3tNSbHlsCLbC2XyRZZUa8a4q1pFT3hDY2WGYScWPukMjuhiCTxv9BDjYDOfORaCnImzWXDC5SHcAJArdBy8JqQYe6wkPmf9JRFDzAXT1lMvhtZdI9Q66mO3PSJZbjo/Zqc7sTao8ZZhf2D3zZQ7dlBLs6wzpEXsmgdpNbKpoN9X1EvyAm0QuNZpRkerujcVsK27MuW0XqZdw0Tvly+xKbShpC7IUzsVWXu3xwQ4cItq6itwBBnMMXYqGaVAo+NazN6dEyr0K4aeL1gJfbyxYQzJDINkquDSDT9NQqM2RiEwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OD1rZ1o16Rdsk0xsGncmdhNFcvvAzepUIG+zy3M18Jc=;
 b=LU3RoDOnVeL00+/7onDxJJWjCFjQAZClngy4c44FZnz1Wo/0rAPB7dwNNJgipJczNedNFOBgtJ5S/oqnK6iRiR5YaqSZAd6FBiT7RRYP+313z/QOigQazwfpT9ggy9beooxaFctJ74VamZ5corneEz+h39s2xk0kCEoF6DqvBOnMfQgwsPn5WKY5PM2MMWNi0AyRi34qw7tkt8JZ1a03+rVbhZTDqTbI/Zf/MZjuA8TJqhA59xp1WKHRKV8B4Y2nn63tmL2mlXRe4eJfCmj0+mTzJY7jxIY3IDG4C1LKFpjG9ATSi3VEyQH8gMp5D2E9vlfsSLuolp2Mr5e8A3QWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OD1rZ1o16Rdsk0xsGncmdhNFcvvAzepUIG+zy3M18Jc=;
 b=X+/YL77LkrZYwDuXPP/unbB96SPOaUd3Id95jrPtJIQ8hPlDa0/AivZKyGM50GSalI2nBK0sQA0Fqaj4OaJ9z4+MznmOlfIpgtw0afTjAnEdNh8fZJoHjGW6c4M2PGzxp9/OAFS6obmKQpTf7oqLysumgAAWKh0SKuFOHfVkt9jnSSnFFPFD/dDRMebuBVHSI0+GjQbBU9zQuuDqu9xbgRRpETB0fHyy/g6enInzDTneBse6sk6/cajHYbfX7yPOPkBMs2u6vDQ2ZwJPtpluxwKhYUuSCTdePXDuC7CXYhSW8Fy3Z182v34pqzQtJWGjtQ+RqcsOFG26w2PJuPBExg==
Received: from SJ2P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::9)
 by PH0PR12MB999114.namprd12.prod.outlook.com (2603:10b6:510:390::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 16 Jul
 2026 08:49:33 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:5db:cafe::5d) by SJ2P221CA0014.outlook.office365.com
 (2603:10b6:a03:5db::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Thu,
 16 Jul 2026 08:49:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Thu, 16 Jul 2026 08:49:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 01:49:17 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 16 Jul 2026 01:49:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 16 Jul 2026 01:49:13 -0700
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
Subject: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot defaults
Date: Thu, 16 Jul 2026 11:48:52 +0300
Message-ID: <20260716084852.549909-5-mbloch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|PH0PR12MB999114:EE_
X-MS-Office365-Filtering-Correlation-Id: 562d444e-e5d2-4fe7-96bd-08dee317286a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|23010399003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	QmN2sr4cv75LHRj28EBCm8EbVE+T3UTY0QD5TzbRrty8oJ6c/2V1pvzf+Mtx9kL+vY4UGCrbmaSuPJopdArvaF4+9xB9LIlSuZa4/BguXQ8isegdUlbjrQ9s/9VjDSCNoFkDsoshw5IuS8GrDvVKbYAV9HnyXcF+oKHxcL1gMSbs2GdFfy8UEmPhlCU+eBkGKTJo68wd5AOgVbiCozvamnHQQ8Q3Vc1pqfMp+oazf+E8T9eIXBoYBnEJaNM+CSiJR5GNiI/EQlvL+WxizPjZtElxFGHhWu8zK0nBqpLo/Ao5ndv8wGUGPbP/nhR5BtwolJg1yi/T3BgdwP6Gj+EyLBQpogp4x9RXFv2zMGXbh8YH2o/FWB1qYRjLib8d1qIXAj8eFitJx+A/w1tT5mxGeVZ+QDA1qcj/Xh1n2Qp01qcUmL4+IZ6zdqqvd/0sdTipE0VUTw3T7xnHnZsD/Vus76P8DDpgSQ11Z5+LKOXAildzd2WEmSqB5SUx1vu+H9IUBAHxWEzCnvcjlrHDqcizAjEF6RAcH+qACoVwM9JKK43zKQwi11NtJ8c5zp8e95YIbNYCVly3j/KnWcCGTRLJOWN++tMiPYSea1myOU/A1Ppum/JZFFiKkCG3T5jATCHH4mC4jshuA7nS4pj4pCayfgKqGVC8h3lqAjwN+4/X4CxAoC9EKuffbHC9LXPY7W7IReAQ3U1LcTZIFIhjpCiOCg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eXWLVs8CbRBll55OW1K5+CvpdhDZzeSqAo0zLzNDel/PkkWuI80CKKQBTqkq50TMM8jo3MyAHQwWUl9TAOKtsznFrfsvxoJNrerVzPBO2acToaZUYkOLjNHDWcMZ1UCwcz5FIbeDfXPUQmUShaA3r5XkPZoJNY35bnH5J/z3QT7uC7nNXhZ6Vj8c2J8tYmF1q9FdDWqNOEUnJU7eV6oiG6s5QFBqZdtFr3QIAmfZuS7fSJXK1w7KMiaTtdDkaFipIuZ03A6RWu1heSM1kC2W+I6qdoGAByTY/gIbTutv4saBpU/WAHKxtGhI64UmdWVNrq+u5UYA3IW5QEmVqEl6c59zCXEMqKrSo1KlJjrLTqxHESltzJC5XQq9G6KcDD6T8KvtYzkO218d8M3/prFCCxfGeH7Xb+UyvtXrijUXUOCeCXPMCE8cjA+uUZ5rnvnJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 08:49:33.3950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 562d444e-e5d2-4fe7-96bd-08dee317286a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999114

Apply parsed devlink_eswitch_mode= defaults after devlink registration
and after successful reload.

Mark the default as pending when a devlink instance is allocated. Before
devl_unlock() releases the instance lock, apply a pending default when
the instance is registered. Since the default is applied while the lock
is still held, userspace cannot race with it.

Clear the pending state before calling into the driver so the boot
default remains a one-shot operation even if the mode change fails.

For successful reloads that performed DRIVER_REINIT, devlink_reload()
already holds the devlink instance lock and the driver has completed
reload_up(). Clear the pending state and apply the default directly from
the reload path.

Treat an explicit userspace eswitch mode request as consuming the pending
default, and clear it when unregistering the devlink instance.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 net/devlink/core.c          |  3 ++
 net/devlink/default.c       | 70 +++++++++++++++++++++++++++++++++++--
 net/devlink/dev.c           |  6 ++++
 net/devlink/devl_internal.h |  5 +++
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index d791a8e4317d..02e6d3ef32f8 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -317,6 +317,7 @@ EXPORT_SYMBOL_GPL(devl_trylock);
 
 void devl_unlock(struct devlink *devlink)
 {
+	devlink_default_eswitch_mode_apply_pending(devlink);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devl_unlock);
@@ -429,6 +430,7 @@ void devl_unregister(struct devlink *devlink)
 	ASSERT_DEVLINK_REGISTERED(devlink);
 	devl_assert_locked(devlink);
 
+	devlink_default_eswitch_mode_apply_pending_clear(devlink);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_rel_put(devlink);
@@ -490,6 +492,7 @@ struct devlink *__devlink_alloc(const struct devlink_ops *ops, size_t priv_size,
 	INIT_LIST_HEAD(&devlink->trap_group_list);
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
 	INIT_RCU_WORK(&devlink->rwork, devlink_release);
+	devlink_default_eswitch_mode_init(devlink);
 	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
diff --git a/net/devlink/default.c b/net/devlink/default.c
index 9b15b7b23e00..b80e3d0399e1 100644
--- a/net/devlink/default.c
+++ b/net/devlink/default.c
@@ -10,6 +10,7 @@
 
 static char *devlink_default_esw_mode_param;
 static bool devlink_default_esw_mode_match_all;
+static bool devlink_default_esw_mode_enabled;
 static enum devlink_eswitch_mode devlink_default_esw_mode;
 static LIST_HEAD(devlink_default_esw_mode_nodes);
 
@@ -154,6 +155,7 @@ static void __init devlink_default_eswitch_mode_nodes_clear(void)
 	}
 
 	devlink_default_esw_mode_match_all = false;
+	devlink_default_esw_mode_enabled = false;
 }
 
 static int __init devlink_default_eswitch_mode_parse(char *str)
@@ -180,14 +182,78 @@ static int __init devlink_default_eswitch_mode_parse(char *str)
 		return err;
 
 	err = devlink_default_eswitch_mode_handles_parse(handles);
-	if (err)
+	if (err) {
 		devlink_default_eswitch_mode_nodes_clear();
-	else
+	} else {
 		devlink_default_esw_mode = esw_mode;
+		devlink_default_esw_mode_enabled = true;
+	}
 
 	return err;
 }
 
+static bool devlink_default_eswitch_mode_match(struct devlink *devlink)
+{
+	const char *bus_name = devlink_bus_name(devlink);
+	const char *dev_name = devlink_dev_name(devlink);
+	struct devlink_default_esw_mode_node *node;
+
+	if (devlink_default_esw_mode_match_all)
+		return true;
+
+	node = devlink_default_eswitch_mode_node_find(bus_name, dev_name);
+	return !!node;
+}
+
+void devlink_default_eswitch_mode_apply_locked(struct devlink *devlink)
+{
+	const struct devlink_ops *ops = devlink->ops;
+	int err;
+
+	devl_assert_locked(devlink);
+
+	if (!devlink_default_eswitch_mode_match(devlink))
+		return;
+
+	if (!ops->eswitch_mode_set) {
+		if (!devlink_default_esw_mode_match_all)
+			devl_warn(devlink,
+				  "devlink_eswitch_mode= selected this device but eswitch mode setting is not supported\n");
+		return;
+	}
+
+	err = devlink_eswitch_mode_set(devlink, devlink_default_esw_mode, NULL);
+	if (err)
+		devl_warn(devlink,
+			  "Couldn't apply default eswitch mode, err %d\n",
+			  err);
+}
+
+void devlink_default_eswitch_mode_apply_pending(struct devlink *devlink)
+{
+	devl_assert_locked(devlink);
+
+	if (!devlink->default_esw_mode_apply_pending ||
+	    !__devl_is_registered(devlink))
+		return;
+
+	devlink->default_esw_mode_apply_pending = false;
+	devlink_default_eswitch_mode_apply_locked(devlink);
+}
+
+void devlink_default_eswitch_mode_init(struct devlink *devlink)
+{
+	devlink->default_esw_mode_apply_pending =
+		devlink_default_esw_mode_enabled;
+}
+
+void devlink_default_eswitch_mode_apply_pending_clear(struct devlink *devlink)
+{
+	devl_assert_locked(devlink);
+
+	devlink->default_esw_mode_apply_pending = false;
+}
+
 static int __init devlink_default_eswitch_mode_setup(char *str)
 {
 	devlink_default_esw_mode_param = str;
diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 119ef105d0a7..6a8d4e1100c2 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -478,6 +478,11 @@ int devlink_reload(struct devlink *devlink, struct net *dest_net,
 		return err;
 
 	WARN_ON(!(*actions_performed & BIT(action)));
+	if (*actions_performed & BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT)) {
+		devlink_default_eswitch_mode_apply_pending_clear(devlink);
+		devlink_default_eswitch_mode_apply_locked(devlink);
+	}
+
 	/* Catch driver on updating the remote action within devlink reload */
 	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
 		       sizeof(remote_reload_stats)));
@@ -731,6 +736,7 @@ int devlink_nl_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info)
 	u16 mode;
 
 	if (info->attrs[DEVLINK_ATTR_ESWITCH_MODE]) {
+		devlink_default_eswitch_mode_apply_pending_clear(devlink);
 		mode = nla_get_u16(info->attrs[DEVLINK_ATTR_ESWITCH_MODE]);
 		err = devlink_eswitch_mode_set(devlink, mode, info->extack);
 		if (err)
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 8fde867f2c14..8270f91c9e84 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -58,6 +58,7 @@ struct devlink {
 	struct mutex lock;
 	struct lock_class_key lock_key;
 	u8 reload_failed:1;
+	u8 default_esw_mode_apply_pending:1;
 	refcount_t refcount;
 	struct rcu_work rwork;
 	struct devlink_rel *rel;
@@ -73,6 +74,10 @@ struct devlink *__devlink_alloc(const struct devlink_ops *ops, size_t priv_size,
 				const struct device_driver *dev_driver);
 int devlink_default_eswitch_mode_cmdline_init(void);
 void devlink_default_eswitch_mode_cleanup(void);
+void devlink_default_eswitch_mode_init(struct devlink *devlink);
+void devlink_default_eswitch_mode_apply_locked(struct devlink *devlink);
+void devlink_default_eswitch_mode_apply_pending(struct devlink *devlink);
+void devlink_default_eswitch_mode_apply_pending_clear(struct devlink *devlink);
 
 #define devl_warn(devlink, format, args...)				\
 	do {								\
-- 
2.43.0

