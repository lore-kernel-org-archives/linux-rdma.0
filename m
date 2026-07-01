Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012049.outbound.protection.outlook.com [40.107.200.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F93B0AE7;
	Wed,  1 Jul 2026 07:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782891257; cv=fail; b=PKEe3oagT7EtdZTahgsMOfyGifjsN/x4u3YiXLdO+g0Xo/M4pS+LD6PwEgvU0xklOZmO+xfZR7TEK9jC+1xK9+SpLyDsAzAaGt7dS2Xk18RwKG+/YcYMEvkZJeSQUzJP/PUBYkNyOD0Zti/1aCgGl6d1jPl981oS2Q6FSci4AE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782891257; c=relaxed/simple;
	bh=9mv0ltrKjiecIgayt60KGUxf+nD1XnTQsjfSk7ZKaBc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fep1+mb53BcqtWhnf/MCwfPcI81hmSGtEdviqUYeORjDy+tBwxPrfn/bXXigA0OX1DbvIg9T2ERS+s540qQx3qPXE2s69fAMIsT9uTQG+EDxuOwWlsEzZhFnOLGGHdx904jKFV9blIbYFuTmQ1ln/0ts+l2/rs/l0hpY00sCKWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pts97LqI; arc=fail smtp.client-ip=40.107.200.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pts97LqI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pzv7DcSs1gWRWC2lQMrnlv3Co+YP+y6xH2hUOTYz/vGqDWY7DYA9J0j7HeQ8zmvIQueMznAvj7V07CCzdudOoaNLSpE5HLjJE2KRp0a3EVofJNvwEZNrRB/zd2M+x8AoVqS/EabZPWE3Pw4PmEzIr6U5P7qMJ1L9ilKoKy4KmGU1puOXY6rNUV0U7Yzhx0qHHUkFEztpMHjIpjxkcOvBMUtyoyNumgzkrgSGbPVYwvhtN2hcLMI+SUdld12KkO+MK0mZ4jAlXI6kUOB+0rFEWCiIQu8A4YT823o9lhNTPdW1vgS0o4nkFBDUbsce8/7R7qqqaC7EO2imaT0cXV8wSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Th89mV8u9qzJ58FwXTm+/ewdTmIYmgeoyOIeOIsWgO0=;
 b=F8KkZ/eKawCgX1HA2pQXVPJz3qshUy2yF8HoqCUSUXzsTSLU98WKAD911NCKn7O3VTRegYcoFJJbjpmJepXPRrPXQzSLSIMSX6tyYdDpV0s3elNMaUEE61kQ06Tjm/2N/EbTIF5dg0Mr3y2pv7TbDtnvpVN/R+8Ecawhde6Lwr3t9wwqkmTXEj2Fe0Cwyjs/DdF9b0pO6ZVtRYGIJ3V9MTv3UoKyey9TwkuHWltY3xiPhOQqRfkjFm8p8qI/uhbVt49ogBtzgXaA+evGK6LTvW8xHnRCzw5v7Pn0boo0/WE547ZKYzG4RZZpnLcUhNkwj6aKrN2NA751j6LehWJhjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Th89mV8u9qzJ58FwXTm+/ewdTmIYmgeoyOIeOIsWgO0=;
 b=Pts97LqIRnwf99EnUHbKYFhs7bPOt/8M+q/rd/kQYM8VVI2Cf/Q93UJ6oXET0ncCMlYSGVRRiwUJg34vCyQw/yjigIO/7VeGQmSylS+isqUtgMEylzMQXvcpQ1Lc7960E6ggXSi+aJNdHXxrXsCHVJrX9zW4PZV73JV3A282jl+xKZByZxdfzAWFple57c/0FWB5PJKlAaUq9FyS/bRCUK1Wa9qVtuARsfgOhSjh7NpCXpKdCiI9raYQnVhDBEghVrgf64PrDTca2WRUK/bhLaIGytqZoMZq9Aq2OVdJzc4+ErZo6TG0mXPwP9GRDJfJ/c8WZs0nyqBz9apZmobmNQ==
Received: from DM6PR01CA0027.prod.exchangelabs.com (2603:10b6:5:296::32) by
 CY5PR12MB6646.namprd12.prod.outlook.com (2603:10b6:930:41::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.16; Wed, 1 Jul 2026 07:34:07 +0000
Received: from DS1PEPF00017094.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::3c) by DM6PR01CA0027.outlook.office365.com
 (2603:10b6:5:296::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Wed, 1
 Jul 2026 07:34:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017094.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 07:34:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Jul
 2026 00:33:43 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Jul
 2026 00:33:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 1 Jul
 2026 00:33:33 -0700
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
Subject: [PATCH net-next V10 02/14] devlink: Add a helper for getting a nested-in instance
Date: Wed, 1 Jul 2026 10:32:42 +0300
Message-ID: <20260701073254.754518-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|CY5PR12MB6646:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b9dad0-7a5c-4c25-f868-08ded7432260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|7416014|23010399003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	qiGAlJmzejAN/KRBMKvmh7s/Q8TE/iEWvNcq5Sq+n82Z5EnB/QgxHR4k4hpwl24TYbpdcAY8G2YNc86ahY/q9qCq7G+kM7gsFEI8McWu0ICU4d1tjbCTAheXC8DvW6deAvaYDa2nnGP0NHtDMT577UCXnForoKsdUMdn17xZjJc1UliqN3DU2CAhusiEeh4UUT21etFdrr9Ix1sqaxAbvqmxKZdLS043f/iF6kCl3/wjrNYZP786sj2IS3gIJrxTtEPkGapiBrlr0gqka3qL/rSiK1bKaYPRV5UZY1AQR45HkTNL+BiqiHAK+3Q/CxmSSkkvtNRmK7LsjTj/xgah87/vC23ZuzBf139AkwoKeawXbFW9WrUPsLbwoiv8bjVlkdAxQqQptByDMkdNlgNZIM/F80czUcbON7273c3vJNJ6+9gpzypRkWcJ5SJRhIgpuE06BVAHVB7UrtCwzlSlr5kvdN2jRNB6Fmb3Gx9/ux4c25bFGm7ahapHuW5kL83gUlsKTrNt5jKhZ39uGsIFPUz7Jieax9MNnSwXBLPY48DTtYG22UfomLIXDjFrSUWXvG+g1E5fe+lt3/ldbH7IuIbJfrsQY4FhLE8EfWjpoG8oNPP1ZGDYKnw+eIA1A5k1WdZNORkLrRVTM2BshJOLd2MvP0cDBrl1eQmEs1GFjfEx09Z/FX/FyaWmdRBGrN+epTfdYvbOsfusfvvSjAz89w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C+48xfFRrYfaJ5p/kE9OcUiB42LvlSLwKVNpfD65gbeCYcl2CzT7cGVV1s5zAObDrDrcbVh5VvLTi0Wv8C3HXJDk6X4AI5uOolyjPUHROlP0dVb9hgulu2+GgeSRmN67yqvqpkvTPq0WxFDfpMkA+jetXoy2BTEaSZiCONh7coYZcie/uDbyc7l5nUcAxLo+ck03MjYAiLvgZLRqPiOJhKRjEY8kWnp0bO5KRjordjSem85FaZe7JYASnd1RtkX9X6uG7zfQFNmHROm1PKuhQ1HoL7gKV7Q69ntJOX+XINUXa3J4iqT4a7K9Fm5gLsYsyQDHohr+e7/Kl1WU/7Tn/RgafZF5vJPG4EhOTMTt9f9CtDyUqy4ybQkCHyODEjziASTuyE5uGhRzSqpsve4oXVArNLqjahJESSzbMXmLqzliOcIQFqrrMWacEAf4Ie1D
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 07:34:06.9388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b9dad0-7a5c-4c25-f868-08ded7432260
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017094.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6646

From: Cosmin Ratiu <cratiu@nvidia.com>

Upcoming code will need to obtain references to locked nested-in
devlink instances. Add a helper to lock, reference and return the
nested-in instance.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/devlink/core.c          | 16 ++++++++++++++++
 net/devlink/devl_internal.h |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index fe9f6a0a67d5..ee26c50b4118 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -67,6 +67,22 @@ static void __devlink_rel_put(struct devlink_rel *rel)
 		devlink_rel_free(rel);
 }
 
+struct devlink *__must_check devlink_nested_in_get_lock(struct devlink *devlink)
+{
+	devl_assert_locked(devlink);
+	if (!devlink->rel)
+		return NULL;
+	devlink = devlinks_xa_get(devlink->rel->nested_in.devlink_index);
+	if (!devlink)
+		return NULL;
+	devl_lock(devlink);
+	if (devl_is_registered(devlink))
+		return devlink;
+	devl_unlock(devlink);
+	devlink_put(devlink);
+	return NULL;
+}
+
 static void devlink_rel_nested_in_notify_work(struct work_struct *work)
 {
 	struct devlink_rel *rel = container_of(work, struct devlink_rel,
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index e4e48ee2da5a..36dff282f9b0 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -136,6 +136,10 @@ typedef void devlink_rel_notify_cb_t(struct devlink *devlink, u32 obj_index);
 typedef void devlink_rel_cleanup_cb_t(struct devlink *devlink, u32 obj_index,
 				      u32 rel_index);
 
+/* Returns the locked+referenced nested-in instance or NULL. */
+struct devlink *__must_check
+devlink_nested_in_get_lock(struct devlink *devlink);
+
 void devlink_rel_nested_in_clear(u32 rel_index);
 int devlink_rel_nested_in_add(u32 *rel_index, u32 devlink_index,
 			      u32 obj_index, devlink_rel_notify_cb_t *notify_cb,
-- 
2.44.0

