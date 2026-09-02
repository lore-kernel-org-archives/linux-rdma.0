Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1823C8C77;
	Wed,  2 Sep 2026 19:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377691; cv=fail; b=eyDQY5Si9s1MPSLq5DE65r3KnbhGSZOFDv3pF82IB3+0IqgR7wj9bp4ZGbgO15SEtXrNDr43EyPU4mnNag2pGESoaLuUubol01l8Nrv467pSRILiEM18E7K2l58/x7+ljzJf8ngNvSw4SqWupa73O3r7aP0k7Kx7Jipw/1o0vPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377691; c=relaxed/simple;
	bh=K2HS2xjVjwAvSXog9oJPy/ktJHZYBL6f89D7Ga+fskk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jRUIyQmcWWqRBzaIV9ONs44CEusGk8flncQ6Xul6eEIrD1xuWJtl03eVOTS5w3tesdEPvT8KNcKehEPtnIcLzLM/UDIvQ55j/ELKbPN+04JAw+pI6YDnv2+R6XHt8KfKrLguwtEnqIw+ic50F6B/HgAfG3CKIN8Q+zJBQM3mAH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PFswV18n; arc=fail smtp.client-ip=52.101.48.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PFswV18n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUBWIvaiUJMD1j6m5a9EtJtf0yNI5hHlzkwgAhKKoSvuoW9sRa/IooQqys+CcGj8FV0DOLv++ozdDp3TB6CXNdPrNZczoidg0Kn5TAA26hNXFNL1bNH1uGQQqt3pSWq5kKcc2bpE1m/+s2kQto1jegpMJj4BadiBc88LRGT65fQfj5auqa4sYFPW0NDP9lKvaDv7SOm47yn3Fl6g94etYzA2BUeyawr670kHyIdDBpkit16CE4it9XFwWC5R+ocDwRdNKMwOz47z8QlI4ifesN1Yect8zDOCl6zkoKOVsB0LA2OYTNtPrcl80BuUZ9MKIOypeHsDr/+8IOKKSZNtNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psRQhAweGTAVyBiHaEsj+rDkSRRsoK4ZgM0mg7NgPYY=;
 b=dBDh2n9A61oadRkm/YZV8iVkx00qX0fLUYgTqCF/EeOb6wy3k8XYVL+A39Jng9C+hCOwRtN4qCXwQly7h1ruKnAxk+5YpyVawkVfBtdiNnKcH2gjXUzLfn7a9do9KpedWMtVGwa9Kc8YIlppHFaeqFn/GrbWX6jk94BwM1597B7YamiFBlAs0iHdZ2iR04CNYp1415H4z9be3Z0a8FrMRuyn+Bw6nVY9kC3joa7uP++JiFq4zFh54noq6j5K5zvAUAo/GH57Nsl453VzLDqSt7grQ7EtFtZS58xC3Cyv0GAV8w8SIjhbEpEsacMsb7WW9/5ommoBXmznHnytyS31Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psRQhAweGTAVyBiHaEsj+rDkSRRsoK4ZgM0mg7NgPYY=;
 b=PFswV18ndn1K+nCQUXBXMJhb1TEfOmL7eWltDeDpzRUxkcpsMBeOIg8H2rR85FuJ1+7ip7FVRuaixw6P3kfSljy0qGQplc9jduVIh0yYNDcCZEMhcqFOeyc9WJjpfjHDIhFTAyIufasrY1Mth7ZujiGKV0ajhX3dXGLGTknH8oyOVkyxv0KSf1UxjE3n1Bpk93rV5SjhueNKp/QszIe/cqOoIL4cuVoM3VXgJoyb3q898EroiWQ2McBqzcgJivHditu8FwoDbvACjdwevofqYrVJzpDNFBwCzjY/s01sO/xRbUmm0UpQaQIdkyeiiMEkBFkhKRrX1Ueugq5QlpZ6QA==
Received: from CH0PR13CA0018.namprd13.prod.outlook.com (2603:10b6:610:b1::23)
 by SA1PR12MB9514.namprd12.prod.outlook.com (2603:10b6:806:458::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 19:34:29 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::9a) by CH0PR13CA0018.outlook.office365.com
 (2603:10b6:610:b1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Wed, 2
 Sep 2026 19:34:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 19:34:28 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:33:58 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 12:33:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 12:33:54 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Oz Shlomo
	<ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit
	<shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Fix use-after-free race in sample_restore_put()
Date: Wed, 2 Sep 2026 22:33:41 +0300
Message-ID: <20260902193341.3668809-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|SA1PR12MB9514:EE_
X-MS-Office365-Filtering-Correlation-Id: f973cf59-2561-4b70-a0bd-08df09293479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|11063799006|10067099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	2ohUlAdCousy9vHp0gULoCOonrxrkufV5l+Lvu7AP7ejMkk1PPxhsSBM8l7nEdofy6wzcEWPuPIxtku9hhjOSpBQlGprbKQ2s0Dl3BnvYpI6z1gKSTvSa+vs2w1BV8VQeg8WFn5eDwBNJaYbM94CMJRwwfwJnBA8gmoIGH9fR8V36Zppse9INhk6U76GxeCuQDQaa5aU2sHUhVeQVD0y3S0bKjM7yFZYvwvGoSI2J3WNjaD74bU6k1YEwj0VBl6YMVC6Ba49976Ug921u+xszPBBIzulxCLcQI89U1fkLdyeURo2uFZeD4tGpDpFGJzaYWNQaDLVxfayAldBo71tKKuM8lXBgwZ5xsC58+rXlpK3ebQ9GPABpG6F5DPPr5tMquC2kjygBEd76nB5IuYUI2PB07CRcWOKeTSzGdqlNVnORBIpurhqeYgTTcySBxy7T0UOIz8qYccT053A99mHeFJ4mvQWRf3NmVAVtRnuonBlAQ8oqO3dyOZNj8zOkaEkNYzuFRTN4lEaXyTZYYzQ7jazpCh/RVsXQrNUYf1EquHodHneb3uV7E1z1Z4ozgHVHwfxzrDqeKHMenhluNjQxU1RBHM64e2V8tLYkfWtJYxEGPVT5ryyPEi74LF8sArkXx/P2VSOMqBZlQCrVNR6unsQDgRaURr+h3jP45aliWJ30r0BAWhcKmf3wNIN7hmol/0DgsKJaYWMdhV1P1lCcQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(11063799006)(10067099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iBiRK2ifMUaKX4UKEz9oY3l8/QMwNEqcAzjEx3EkC6JRzKOjJ41wpPHyOOvsCx/dnnLeYkaXWfeciZI7ZIdoY1H3sdSpEtzGZCpQgGG0NluZ52l246LauFbvOpkkZzlDTmK8mpLWs6y1jRSwEZ+8cjE9m/ofrJXvL3WPRMrwKwapZzpwVGaIqUd3ZT8kwUxQZP85sNFCLjNLZ7GWPUdY1iOrz45bkI3YxR5L0kFtCg7Y6Ls0tvjtiyREnkATgqghFwVK1fpraDkPrU1q3W39DxyUY5TUHbbyc3tKbGwSAPWoLeVKI5WmsUNmZvk0Vec5mNgoT48LonUgDGrJjOhucJ9nfhS6m6UCQzpfqg644qeVC5HuqdGrEA8dgc0B9u2bWYWz7T04TiR09fjw7ibLJkcb1kp3tG+vxmcuSZ6rrLO2PXGnuUjbMHqCbrcuEE1z
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 19:34:28.6686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f973cf59-2561-4b70-a0bd-08df09293479
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9514

From: Carolina Jubran <cjubran@nvidia.com>

Concurrent teardown of TC sample rules sharing the same restore
context may re-read restore->count after dropping restore_lock.
At that point another thread may already have completed cleanup and
freed the restore object.

Use the result of the refcount decrement while holding restore_lock to
determine whether cleanup is needed.

Fixes: 36a3196256bf ("net/mlx5e: TC, Add sampler restore handle API")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 89490f687a9c..93c62d3f3e5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -311,12 +311,15 @@ sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id,
 static void
 sample_restore_put(struct mlx5e_tc_psample *tc_psample, struct mlx5e_sample_restore *restore)
 {
+	bool last;
+
 	mutex_lock(&tc_psample->restore_lock);
-	if (--restore->count == 0)
+	last = --restore->count == 0;
+	if (last)
 		hash_del(&restore->hlist);
 	mutex_unlock(&tc_psample->restore_lock);
 
-	if (!restore->count) {
+	if (last) {
 		mlx5_del_flow_rules(restore->rule);
 		mlx5_modify_header_dealloc(tc_psample->esw->dev, restore->modify_hdr);
 		kfree(restore);
-- 
2.44.0

