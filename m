Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED546568525
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881499; cv=fail; b=VmpaE7Ihloe0UcCnDQO0fVGePjjMpyTVhQA4yq7uRL6syVNCO3iy+BxrrDpYxDvLDeTS51mYwMn+QJ2t4bMKRJgrolwEK0+gv+0IfvYounl6QhiJ7/XYIwF24mvWzFshmVU0ZvbXrFzmSRDjy6tYxMckhYAlY3Zo60F/sUaz7XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881499; c=relaxed/simple;
	bh=FcudszKAbVX9WtPUXnNAVr7UjX8A3G3Ki4GuIpt/R6E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJgWL/W8SJG0dJRnTRL2GiEs3Koc/09GCR1PRDwf2rJdanK4QU72VeenFv+dfoMF31oZ89BHTne8p7TNhOt+JSl6x8ssM3x2fsMX3/1vYVSocsFnQ5NvndaXWiPgJ8aXkSlt2W+faUy9ftJFoMwE3m9tNLZWOWPHBSq/V3J8XaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bpxwwfZg; arc=fail smtp.client-ip=40.93.195.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bpxwwfZg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYknoq5AwSgzXnXSneUIbJjYP7xKvhB8wlbnnFNaSQhBuY1XmZIDYL7O8qmAB2v9wBw7VG9cMbsV9GB3HfTP0LTzMdMuNEPe9oMnODXVCjelgKdM5DWUX6dheY7YxWPqGfgVpu5rGJnNfb90IVW5ReWCA3mWbAF+O9LKl/wYFY2Bwmju5ECRl/HTVFIRor37P4yvWnx5BPviRhD1W07sesJI9D0OVpJKkCds1dLyirG7E3LNwY8NMUnVkkM722VqaUfIJibCSSAkecuIjBmaVhjCpgSgtm9Ah6PxsnQyrOb2rpWoCYBJk+tOeE16zYRkmqzzjE0bh3T3GoZqxbjFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=an+gFN8wrAK0deMmJ5fSdYwRAbHi51h4gIS+LV5GDdc=;
 b=Eg0giuXl2StRuwTKBmoZf6M1EDM/Uog7QygF5/MBxdR2B+qjUG90gnAIErLalMqu9ZYl+6zkcLwQCCFfxtFkDmPapm4hQ154R5XydjSoFA6K5CDUL5O6aMtdzvp/XUaJFYXnGo9cLRgC5XyJVAPYxxKpoY1w5Bb4C/R0oMZNDZRiEzAgQj466rP1MjLTXYZrgBZ/6dlkPJ/R+jFki3vBzwMwbn2LimfQu3HLvjKzmizDKkIcfHFL1B1d3CQ9bcGbv8lynzNevTqgid4rr3L0txWnMrGTVaeek2Vv2WXa8P6S6QThKUcdTN4izAP0G3pH7hB9t0WgQy5gvTorBP1Ypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=an+gFN8wrAK0deMmJ5fSdYwRAbHi51h4gIS+LV5GDdc=;
 b=bpxwwfZgxIvMiB3oh119cN2HNVEhiZCFq6hJ1WPNUfz0H4fCungpsw6m9qX7Dk9gSZEpiL1y53fvmG3+AhFYSwVfXQ+yNQe86R/hnV7Lp44QmnD/FMX3CeQ8eZnXOswR6ugE65KzaP/QxMWyrjkp9oznnKUwQFNkLL69EuSLTnv0kF0+W6eXp6XbAPFRRQCFz58OhoNYsEqL6vM3GBLoIrEUkW+CC6LqZ3KeX0mNb/NScLgQ2uj5f42Obvtvo5hsxdXlWRsbXXsUZUeH/oZaS0GYwSNLykfKhkJrD7rTX3uZF2em1Eq1mK4Tv8HAeUrXsi20CxQM6E8KPgmL4WHdoA==
Received: from PH8P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:2d8::6)
 by BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Tue, 8 Sep
 2026 15:31:23 +0000
Received: from BN2PEPF0000A893.namprd04.prod.outlook.com
 (2603:10b6:510:2d8:cafe::12) by PH8P221CA0027.outlook.office365.com
 (2603:10b6:510:2d8::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 15:31:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A893.mail.protection.outlook.com (10.167.248.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:31:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:42 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:41 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:37 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 14/15] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Tue, 8 Sep 2026 18:28:50 +0300
Message-ID: <20260908152851.1307294-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A893:EE_|BL1PR12MB5753:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f490a19-7b04-4dec-2f0d-08df0dbe3d02
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|7416014|376014|10067099003|6133799003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pPd/CpnndDqCcNW/YyN++w3weIG4t8UIHg9U5EJ4RRkNG8qyfGO0f8m/KIF5XvAlj6mXdXSOKRNP+BxJBCPksST8s5dUSRZG8LmZUVX4iv72tltNpdlKmoK8Ys6Ytn5T+2EQC5pdHK1M0P78jGHqhgW5iLeq9nWBBpTN1iSYX+aVUsaOone9UaiXkc+w9BILts5lk5Rh1z0/KsizuLp1wuNsLlj7laAMpF0y4s+Utl3OrgcSDcJJleEIz/0OQPOo6291pF+5uehR4HDv9m1bqnBIc831eDViFEw6xUKhRTwN+QnzTYxIBJu23AeM65EtCA+p7s9njy7D0obaB+cyLOcJ64mFq3mTCixPIsAODUnuY/9l5p3ELPmknvxNoyuU0uF3pJOgOfUio/+Z0zOP6wXnCQlZjsTQuY9tRPU0v4LW3VBX0AHGq0qHRaOapW9nlTLZ6yOhlnIGGeGxjA4DykNwds0H5Ug65vy3Jh6Tg23Sl6JZwYmAwEVvoezHMTaFKzGP+l2cepSuS/uXwG2A5PlIk/3AJKNN+AfHkIsFrV8RewziTQHoD9uR7PBoVXzGbAfClskq8JQGlno5ZjFJ8PLsv+9tcRV0aDcn5K7j7MziQ1Yx6XWJFioXppbZzJYQamImdiKFodXPFK+PFB7XBY4Q1zl4pIEKVVgnC/yc12gwyi0K/8WYN7T6A03zxLy3/OgtgSLNeOm/1ZWkHPKxow==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(7416014)(376014)(10067099003)(6133799003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FmfD+gyKHHL10w0AHuQcKGQuyRZ/eo4DRQ8AJnWgA7du6fZ3Rc+0zlN30qlgADMx4iAdRjfY6ysUyN82V/5VqgojWS/WZgTe5cZbgf27qJxnzYf76nMYGnx+2lf2mPO6aq7ocaB03Xgw0iXXNu390sYJwBeRyCfe0ZT1AsS5xArZzUCXhHRFYn8BqwL3HXMzjrpWtBk5q7ULthlHYp5s/AGF7ZGK9w6hEYbJfHY7RiIV5oJuP2tj7s6b482EHzIAZFqVCLiE0d8RlOvGTLPg/5AoapdSNAt2JifkeLDwWMKdhVhke5DqKChb8utgEvXsO1RMgaMgJQiKSOLF3slgS+SwBiop13mP7eQJYPo+eal7mdg+2ekNpSgt5/v81NTf0nOobRRfkz8/NTKi6/TRdibZFViIITEgkhbwSgtBzc6irTjOUd8J57x7mUKxIusr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:31:22.6594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f490a19-7b04-4dec-2f0d-08df0dbe3d02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A893.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5753

create_resource_common() inserted the resource into dev->qp_table.tree
before initializing its refcount and completion:

  spin_lock_irq(&table->lock);
  err = radix_tree_insert(&table->tree, ..., qp);
  spin_unlock_irq(&table->lock);
  ...
  refcount_set(&qp->common.refcount, 1);
  init_completion(&qp->common.free);

Once inserted, the resource is reachable by mlx5_get_rsc(), called from
rsc_event_notifier() on any matching firmware event, which does:

  common = radix_tree_lookup(&table->tree, rsn);
  if (common && !common->invalid)
	  refcount_inc(&common->refcount);

qp->common.refcount is zero-initialized (the object is allocated with
kzalloc_obj()) until refcount_set() runs. An EQE arriving in the window
between insertion and refcount_set() calls refcount_inc() on a
still-zero refcount_t, which the refcount API treats as a use-after-free
class bug: it saturates the counter and emits a WARN, permanently
wedging that resource's refcounting for the rest of its lifetime.

Move refcount_set(), init_completion(), and the qp->pid assignment
before the radix_tree_insert() call, so the resource is always fully
initialized by the time it becomes visible to lookups.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 77ddab666ecd..8b5bd33a7f0f 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -167,6 +167,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -175,10 +179,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	if (err)
 		return err;
 
-	refcount_set(&qp->common.refcount, 1);
-	init_completion(&qp->common.free);
-	qp->pid = current->pid;
-
 	return 0;
 }
 
-- 
2.18.1

