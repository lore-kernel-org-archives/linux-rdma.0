Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010012.outbound.protection.outlook.com [52.101.85.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195883FDC0C;
	Tue,  9 Jun 2026 11:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003835; cv=fail; b=q9NEUYVEgUoqCq64U4ACK1m4FUqyFQG1//nom61NgPYM1hxczXlHEdNSGGL3s+pvu6doGMqymyDjoGPia/UNU7Cf5KouxFxWeVTE2lzyJii/YXwMN/qr0ZUluTBOqzyC9Eui7XZ1nRfELb7OieuROVOVdT2XLvT2JujO/pmUsvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003835; c=relaxed/simple;
	bh=vsdcSk0NI8yDxszuxUi9iYMF0E3ZJrXnhA0G9VVoMf4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=Rcr+QZD5XpmugAbH8jHAxBoyDDvu7L0RSADMBhxY7lOaHgXpjjoDXRdPtI7x5QG5Yfar0SBEMd24WGuu+vXn6w/jIPqPGNHVNBQl0K+YcEpjMoW7xxfqzP5MXyilfff/yMy+/JvKJ5WYJ0KpmPkCIFibPEYHGT7zqDIZnzfvlV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OZ0KkAcv; arc=fail smtp.client-ip=52.101.85.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OZ0KkAcv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKGtcQWNDngacMHHe0pGwrqPyyAnBizejOUFK8lfs2TBN/2KJVvncx/P+1yxSQKkawpmWiUev4OJ67I25CKa42Rt7o5Q4KtrJ9W3oum8FJTtnJy9HHmOx4F7zfT2y62Dc3PVgYMPL2LLugRozEfJRXRQtG2CRXMcMjwlBueWcb03y8E2gs+ZrXE5Qe7j8LEsY/fJCF6obBLAkBYu7l1FYX3F9iHLdAw9HtONPGFUdS0wHYqjYx5v0YGm7vrXkbuydVBTuXhfhDGvaT77np77lsGRnRm6wOrIC1cqPmjmgTlo4z6w/9za0jGqPMYn/eGcHDFKrRO6bmo9QXm9FUvmKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwUMbe8NVEf4lYh4+3aQnCF/avPIzmGB3JdXg8p0eC0=;
 b=FuYw01ds0rg5JZlYBl/wAkEUgWi2Arw5wVDam+GN6U1L+IkXdxzkpYG5h6hn+C1MiRYbUfAwhhpuESOQLTd4qtGB6s/UD+rlOI5ny33YN2Z4dkAYRvR8JchHjN6Yz6LVB5jynnenF1odgz6wxhF3sKNSiv/eXEmbMuh6zCGbIMzNEYzS36P2I9QZToOonSQpjhd5IJnCnMk4w1Vo4atQfbE1HSpfJUL/+PjTGys/f6X9Sx22n7UnrbWF3C9MB6zaLHgtgnqKMfEwHgxwAqE35jk8nakQrq6GKv8T8+lTBsy/Cgjlf3Rapatk74JFZGzWJH+reXQw9K5CkcGg5uq6qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwUMbe8NVEf4lYh4+3aQnCF/avPIzmGB3JdXg8p0eC0=;
 b=OZ0KkAcvqpLbAuGH3DhokV5ZogffbitoIxPdpN0xnep/qa75I9HUdCU22yrelD9LAdj9ssNXtmEL9I+g0BiuZm7LVqReX+KouMs00/kbC6sXS9uchq+nTwToBdmtVQc6LlJUMUAGh5z14D48twUHuThB0Xdtb6s/53LQeUJtxct7Ie18tJyuIW2g3XQgKhPDutNCJSlTkcFeJ8gXY3GmuWPK22q1iaoX6r+h2ub7cK9jbm9jvvg82I92+A1nDZ1ZP8hop6hAUIW1VfZRbiMZZ35Fa5dW37SQAMf1S21wcjamm4J/ThoBBFIGNIA9hhMlGMy/DsiNjqrLk0E4Eomxdg==
Received: from SA1PR02CA0004.namprd02.prod.outlook.com (2603:10b6:806:2cf::8)
 by LV8PR12MB9229.namprd12.prod.outlook.com (2603:10b6:408:191::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Tue, 9 Jun 2026
 11:17:10 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:806:2cf:cafe::23) by SA1PR02CA0004.outlook.office365.com
 (2603:10b6:806:2cf::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.10 via Frontend Transport; Tue, 9
 Jun 2026 11:17:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Tue, 9 Jun 2026 11:17:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Jun
 2026 04:16:53 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Jun
 2026 04:16:52 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 9 Jun
 2026 04:16:50 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 9 Jun 2026 14:16:38 +0300
Subject: [PATCH rdma-next] RDMA/core: Fix broadcast address falsely
 detected as local
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260609-fix-rdma-resolve-addr-v1-1-449b8b4e6c09@nvidia.com>
X-B4-Tracking: v=1; b=H4sIABX2J2oC/x2MwQqDMBAFf0X27EISamj9FfGQmtd2oUbZSBDEf
 zd4HJiZgzJUkKlvDlIUybKkCrZtaPqF9AVLrEzOOG+8efFHdtY4B1bk5V/AIUZlO8Hbzj2ebx+
 otquiivd3oFtP2Dcaz/MCVXEimXIAAAA=
X-Change-ID: 20260609-fix-rdma-resolve-addr-1ce615248b6a
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Parav
 Pandit" <parav@nvidia.com>, Vlad Dumitrescu <vdumitrescu@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Maher
 Sanalla" <msanalla@nvidia.com>, <stable@vger.kernel.org>, Edward Srouji
	<edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781003809; l=1721;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=TZcXUcr/X5vnjq0PsylV4vrl67Ka0lUeFmGIQ55hxdU=;
 b=BGRFYjvjBBjGTnqZ4+R77gtac0KbK1dvrWAS8sSVlc+qyEaSCAYCkxhBTP+jV1jmMxBHBh8NE
 /m1+goK+GxwC84u03+k7FkQtlkkiys2FzMfgdo7EgbiLjZ/ceSLhWz4
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|LV8PR12MB9229:EE_
X-MS-Office365-Filtering-Correlation-Id: e547b40b-0279-438c-de9b-08dec618a67c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|6133799003|18002099003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	5R+unMNAUSFtKHiHh8zLMfukEiEMZsK8OiveLvyZCpzGS7BGc7Rb3mDPOg3oDFkehcSRoYAfDqY6WNq3pp89H0L42OLYN6yffaWPpzT+RGTQlkAHrAwZ4uSSVUxbJ7cZx1e3w9oeiUSp6GOCR5JNYRPs8jNsAhq4d1Zvj+v1y8Q20o91Zi0XjQu2mSsk29hgs91eKy2Z4IcNMhGbdg/FOsRkMTHw3/OjelUE8/jTCoGZI3OlE6ahC9dYOfsP+MsBpYaNoFJRePfBNwOLpjlyB0qL/DxvaN1587+zjy4km0R9l4eVi1hA7V6LoSij+NlC+o9u3XEZ0OBIoMtLUfwaWbzNYeCS2kldk7xJdaEQeG+yQxgncsOxivaGDAK4XAobNqmthksUJrb8DRgz+h98CInj3pUmK02codxUi316x3ccMNYCqhZNA9M5VYsjwBjoEjVL2Xigrlusajmj7WRntmDhha5+8qt72g3iP7y4RdiqXs4wXv91SabcnWOHAvYzrbE+mOYW/Ksp5nthDWF7HIVGK6hpdMn63kD2LJ9Mi+WQFMExhJTq+zdVvWEz3rHRaHyS42mn1bQHCYzi1NgTxA9PzwgadgWuijUJI6CFp8um76jZwvQnopUvcigxRBBhvyBJVfPMuhZMPDZ67STaiVxtNs6RncFqHGfnim0krEfhcpumQwPSrwT3kwFPrSZd5AXrQ4Iujk40WMT5urrYGsRBioY911TU/A64HrclR14=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(6133799003)(18002099003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vGuGXM/gHaUQGeoyNMxA5OFiQifIhIt1ZjsuaTM2rZOeIxYAB5W6yciJWMNU2OzyJpmb+8HvURoUpWaVt4mj65WbDpPWzTkDbFAvUw0VoxrqV5fIkzuTCm4I3oCa7xTOQKpE0tkfhsWS5tsAPloYR5ThNLk2KU1ISm1K3RvQWc2dZxjE7EB460EVnsf/0rna34+NO9ZH4HBpcyj7y/UaXMaDD0ybLJNfb75Bz+xFl3jJ5MF6RpwB8Nwfjg6s3kpMn2ICH83LECkp628OHP/lkUvnO5aXIJ8LL/eokxoe5c4ohRUxfN4P5RymBBTITKf2oVdh718fOY6RV4czXkQAsj9fwuStCy0nrmIX5OJJMIQzivGnwCi+Z2wP7x8fmEC4BdZ/An4f4dp0cl3cHHiUPz6nLmxdzrHgixowIPvBte6VQSzyDcAax7SW0htoqZDf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 11:17:10.6484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e547b40b-0279-438c-de9b-08dec618a67c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9229

From: Maher Sanalla <msanalla@nvidia.com>

When rdma_resolve_addr() is invoked with a broadcast destination on an
IPoIB interface, is_dst_local() inspects the resolved route and
incorrectly concludes that the address is local. As a result, the
resolution fails with -ENODEV.
The issue stems from using '&' to compare rt_type with RTN_LOCAL. The
RTN_* values form a sequential enum, not a bitmask (RTN_LOCAL=2,
RTN_BROADCAST=3). Thus, "rt_type & RTN_LOCAL" yields a non-zero result
for a broadcast route as well.

Replace '&' with '==' when comparing rt_type against RTN_LOCAL.

Cc: stable@vger.kernel.org
Fixes: c31e4038c97f ("RDMA/core: Use route entry flag to decide on loopback traffic")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 7e62b5b1ffaa364ce0720a09084beca5f4db95a5..e9fb7ad4c377cfe4605b12ed4b4be2e5dba7eb13 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -438,7 +438,7 @@ static int addr6_resolve(struct sockaddr *src_sock,
 static bool is_dst_local(const struct dst_entry *dst)
 {
 	if (dst->ops->family == AF_INET)
-		return !!(dst_rtable(dst)->rt_type & RTN_LOCAL);
+		return dst_rtable(dst)->rt_type == RTN_LOCAL;
 	else if (dst->ops->family == AF_INET6)
 		return !!(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL);
 	else

---
base-commit: ea4f6f6c53577fb3f05dbd78b15e586772d49831
change-id: 20260609-fix-rdma-resolve-addr-1ce615248b6a

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

