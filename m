Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870916;
	b=qkMTvR6aSS+OHU89XzbbT6kLIsXrRbasE5iUFgsCk6mmHSZnSIPoAi/SfgLWmUHYfQz1
	 pc596ZkG7kSjQEY6SMBkF4uDuy1tcsdJp6fG3g6Ebxr0vC2MFRddZp3Qqo6n6XQ7ZZIQl
	 SaTP/FukRcmMHlTt0NqNKKGs5x04xY2bO7DeOvkWsLi30TeAlX9wEimmHMHapc1wV+Z0n
	 MlfYBv5hMXDapyhg+b0rHiDQYYRxtvJ9tgGjP5W3jYyDrxeprqlFmZq+Ux5NNS7pI3T8r
	 FBZKyNNI/FRxiFkVnekbBIsf2gKUVwdw5qYych2py174NrhdhODE6jzM744uT/GDkRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870916;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=i48eh/zkd7dhST9F/l1JOp9TXqxXjIAc6DrEeKrASSo=;
	b=0ZN8V5ISbSIBs6yre5K3oGOWLmWR/YOGbVSb76O+rgz6ojR8WPTIhm9f4FAufsNDdPTd
	 I9lMHZQeyOnwoX2yoArakw/cCAbUlyvTu9lK3oE2/c5Srvz2GACsVy+5jDTcAtjAy+OdC
	 27jaiQdsRMIrp9G1aJvj8pasXAWAvg9hDOvFgTmF9BY9VDRdJ/CcHYWGGhDdmU1q+VnwD
	 zDw2d3iSC7CrJzreCodYKZ5Y5QL4mlPk1oA1SJHn1kT6DknEUqu2ehHtLmmK5Id32oz7v
	 JutbfPczAxViKGQDXKXV458hECfJXjdhvLYrdwa6K/B/K5rGiXpq6Pe08oTUtmvNhNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qzM+FUhi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.10
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD82606A31F;
	Sat, 28 Nov 2026 13:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FD82606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qzM+FUhi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8ZYWUwhQlGiL4XPQxYNe0YmeZFkzzdwkiToOdpAfNgA3G4D49ZMrPmSso25RSPHZ6b4mGUEGizBcG18AoVRhQ+iprMUtfQ4b5lpV0p57zZo1zPMZ5QbIsIA0sXHZLCsnubDpZm1ngn4GP/4rfunXPqxuc9stfAIFitN4PAvASvZQ6eM9na73RXmsrwHQw2MawepZ/FQYL3Kti8Dy/V8sBV6Wl4MThQDLV2JWhvINbGt3CtjW6CLhEJQj4pEi8V4VOZxjQznlQ7qWHfErxOdL/iF118MP/4VllV1v3shtKUndLTCX/mx2nFXiulNJSj2bI5zVjWMXOMS5KEEr4Hrxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i48eh/zkd7dhST9F/l1JOp9TXqxXjIAc6DrEeKrASSo=;
 b=HOlfS3DuNR5KbiI2A5hFhxjIod7u1xjev9tHl2vl3NpxDDNS+YtIOaXhKalBntrV3zl+nbctlMS+4bVmqECC/46/aIV8z/lrUwxPEsSDVj1OF/mR4ff+XebS+t1gDkVYWDpQoIAkxwFjgDbOpikD+2b/I0+eLOjjiJ7TdnoDl3wcuLhglBJmH4zal8G0qai15mwvW/w45YNtvDPPYp2cxbzYqVPnyUdfUuy4m2oq95TejICD3lrflEyB/bEuDYZQS0q30GV/WLCn3nKJeUB421riL/dgpt4KaB6WsxQvth5EiPVpdY4QVJwRx57t8kTLAx+8FEF10w8wbg1KyIJykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i48eh/zkd7dhST9F/l1JOp9TXqxXjIAc6DrEeKrASSo=;
 b=qzM+FUhidEpIa636j9qgYrHwqmXXWOIZHizBiACTJTb0BGhTS9esujk5rkwTPK3o5J4HBOKIZzRn5SjQdHE0BHo3ed+relI9Ete2evlx58u3S/djI3ivBQ77HKMwAlgxykNXj6NffG2eye9uCSuc0X68MPqePKEy2DaRHh7vzcuZ3mZpC0m5bHRyakr/isF6k8YoJyr/93q1TjgRTI7FuHazz5v8ZWLlYCU0Z5sCvoFGJrWFY/g0mmGG2qhZgKY38NQdsKMeNNiQiUKVHGdBKpkzTAO4Hc1Qui/ZvHw8srsvMJhyyVQ45nCHpRw1tJpPs7mA39fH1v4UyY9CRyI5Ww==
Received: from BN9PR03CA0409.namprd03.prod.outlook.com (2603:10b6:408:111::24)
 by CH3PR12MB9025.namprd12.prod.outlook.com (2603:10b6:610:129::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Sat, 28 Nov
 2026 13:01:40 +0000
Received: from BN5PEPF0004698C.namprd02.prod.outlook.com
 (2603:10b6:408:111:cafe::a0) by BN9PR03CA0409.outlook.office365.com
 (2603:10b6:408:111::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698C.mail.protection.outlook.com (10.167.245.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:39 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:28 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:26 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:16 +0200
Subject: [PATCH rdma-next v2 03/11] RDMA/mlx5: Select the PD and SRQ core
 device through the PD
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261128-mlx5-sd-prep-v2-3-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=25131;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=AhUJw5+TLP6wX1RVHPUrMehlbPsqiX9YAnzJ7sI/Oq4=;
 b=crOBK1/w5kXL8ZmnK/W3W4XusCYGwWSM6A9W2XYbmO9Eh20QShNiY92A7VRy6ctI+6f0DPOHc
 PL59PjIgyuhAzUkGRK0ojIzWvzasvYWbSHxIHwRzVFkagZgua6HCSlG
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698C:EE_|CH3PR12MB9025:EE_
X-MS-Office365-Filtering-Correlation-Id: 29f13066-1f2d-4544-5f37-08df4d4fbe44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|1800799024|82310400026|261021135927099003|56012099006|10067099003|260925021911599003|260925022911599003|260925021311599003|261021121427099003|261022115727099003|261028144727099003|261022113327099003|261026121527099003|261021123027099003|261026135527099003|261021130227099003|261022075727099003|261026140227099003|261021133027099003|261102123227099003|261026130827099003|261022105027099003|261009223027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	7E8Z3EgR/G/7XC/0MXJB8fbQ9bvQKluBnEJnnNwgWxV9ZmVVcrHAvuJoknqvCuZOq3bRbTvfBpwQrKuEIkCLG/AFottrccYjxF/DpixiJ6AaG66GByQ4O6LqYXdOewY953lGVLlE3kVBw4axBc+WR3PKxfpKZtJ3m1YaF/KtNvblacfaSQcJBMcwhuVvIJhzT0dZiC/s/jg54uVV8krdTWxuHB9w4BQXjYR0CNacEl80WfhlddcFZUy2skoXr1VAsSXnyBp8P+Yx0uKMzebLLZJCD4e+nZeBLuhcw+p+B4wqiXziLziaKa5KCoa7RY61nRbZhxi5H+xKlLefejE5j3y8w0kNMdefKnfKsFsc4u+aWZvgfbfQ7NQJKTHvy4T9l2WDoxxgWybLmoBIXIE5XURcAvXcBEe8mi8DZav6WpmPOcYvImXrBwPVJinEWJNADRa9+THtu9w+HsptPWEeslsVGQPmA89XmXwxjy58bOn6ncMIvwHybnH8mD3dZuMgw49oy2ILFWUc8zO5dDmWZ4pAgX/KuG2W2kd9TzRPN4G378tfsPSLcuCRBKpBj2RTyRCU37DUv5SRJcRoG3QJ5wVwj1LOdY3nboxOxK+yPUpk5SDure8FzjTlT79Dv2YuUceWjEe8U2b1vMpuUnxN/myIvq+ircKKaHcNufWtIOOrQqL1T7bxQ+e/Ygd6dlTpxb7EXpYyvvkuRK8nHrjitA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(261021135927099003)(56012099006)(10067099003)(260925021911599003)(260925022911599003)(260925021311599003)(261021121427099003)(261022115727099003)(261028144727099003)(261022113327099003)(261026121527099003)(261021123027099003)(261026135527099003)(261021130227099003)(261022075727099003)(261026140227099003)(261021133027099003)(261102123227099003)(261026130827099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a0sN3pleWlkEBniYbMADLWUwocnLb4xLLxNZwbGKnnp1zKqw9csGzHvVaf2zVnwlTc79aYNxvWEqWg3M9/bR4g5WYamgbvoYOI9ujMBzNEn8hvfyw869ymwmxiMR3K1Jjz3n/F6hT/SOEY3clM3baDmsKcri9EL/HWHEVtYwDkxrGwsJo5MBImNFLvj0fz0H1iTWOQdhPLfCQ+dA0IZxmgin2THsZuqQ8SFP81xAuRkqCNKYCsHFHyTRS2YI4swt7l7biRQz+MCUuj2D6Rpg7yBv767VUnvvTWcQeDsm4SZ4GzaQHrFWcXgG69gWtwJ/j+kfem1zkjFIFhfGn8TQqjRxxGEiZXEn+NVUxud99bY/0cO2fAiL8vb0Dy/7pkeHsOnjTFPNWrnh0tXYeZRUFdmtuFMwOQO7fqWq5YbCQLwop0YgID9k0okTfbVUf2fR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:39.7958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f13066-1f2d-4544-5f37-08df4d4fbe44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9025

From: Akiva Goldberger <agoldberger@nvidia.com>

An SRQ is tied to a PD when it is allocated. Use the SRQ's PD to select
the backend mlx5_core_dev for all SRQ flows that require it.

Add helpers pd_to_mdev() and srq_to_mdev() to replace dev->mdev
references in the SRQ flows, and allocate and free the PD itself on
the core device pd_to_mdev() returns.

Also, enforce a single naming scheme for dev/mdev resolvers in mlx5_ib.
A resolver is named <resource>_to_mdev() or <resource>_to_dev() after
the resource it takes, as the helpers renamed in the previous patch
already are. Where several resource types have to be accepted, as an
ib_pd and an mlx5_ib_pd are for pd_to_mdev(), the resolver is a
_Generic() over per-type helpers.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    |   8 +--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  27 ++++++++
 drivers/infiniband/hw/mlx5/srq.c     |  42 ++++++------
 drivers/infiniband/hw/mlx5/srq.h     |   4 +-
 drivers/infiniband/hw/mlx5/srq_cmd.c | 124 +++++++++++++++++------------------
 5 files changed, 115 insertions(+), 90 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b5d887250c05cdd5389113f69b8bbd2846253521..6dc25fae205656725d9a118379af04cca41f080f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2793,7 +2793,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
 	struct mlx5_ib_pd *pd = to_mpd(ibpd);
-	struct ib_device *ibdev = ibpd->device;
 	struct mlx5_ib_alloc_pd_resp resp = {};
 	int err;
 	u32 out[MLX5_ST_SZ_DW(alloc_pd_out)] = {};
@@ -2805,7 +2804,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	uid = context ? context->devx_uid : 0;
 	MLX5_SET(alloc_pd_in, in, opcode, MLX5_CMD_OP_ALLOC_PD);
 	MLX5_SET(alloc_pd_in, in, uid, uid);
-	err = mlx5_cmd_exec_inout(to_dev(ibdev)->mdev, alloc_pd, in, out);
+	err = mlx5_cmd_exec_inout(pd_to_mdev(pd), alloc_pd, in, out);
 	if (err)
 		return err;
 
@@ -2815,7 +2814,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 		resp.pdn = pd->pdn;
 		err = ib_respond_udata(udata, resp);
 		if (err) {
-			mlx5_cmd_dealloc_pd(to_dev(ibdev)->mdev, pd->pdn, uid);
+			mlx5_cmd_dealloc_pd(pd_to_mdev(pd), pd->pdn, uid);
 			return err;
 		}
 	}
@@ -2825,10 +2824,9 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 
 static int mlx5_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_pd *mpd = to_mpd(pd);
 
-	return mlx5_cmd_dealloc_pd(dev->mdev, mpd->pdn, mpd->uid);
+	return mlx5_cmd_dealloc_pd(pd_to_mdev(mpd), mpd->pdn, mpd->uid);
 }
 
 static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6fb4069660c43643424ffc65622817467c8cbc3a..c8b658c963b2cfebec49d423dfdebb8a09a597e4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1255,6 +1255,33 @@ static inline struct mlx5_ib_mr *to_mmr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct mlx5_ib_mr, ibmr);
 }
 
+/*
+ * Device resolvers.
+ *
+ * Each helper is named <resource>_to_mdev() or <resource>_to_dev(). Where more
+ * than one resource type has to be accepted, the interface is a _Generic()
+ * that dispatches to one helper per type.
+ */
+static inline struct mlx5_core_dev *__ib_pd_to_mdev(struct ib_pd *pd)
+{
+	return to_dev(pd->device)->mdev;
+}
+
+static inline struct mlx5_core_dev *__mlx5_ib_pd_to_mdev(struct mlx5_ib_pd *pd)
+{
+	return to_dev(pd->ibpd.device)->mdev;
+}
+
+#define pd_to_mdev(pd) \
+	_Generic((pd), \
+		struct ib_pd * : __ib_pd_to_mdev, \
+		struct mlx5_ib_pd * : __mlx5_ib_pd_to_mdev)(pd)
+
+static inline struct mlx5_core_dev *srq_to_mdev(struct mlx5_core_srq *msrq)
+{
+	return pd_to_mdev(to_mibsrq(msrq)->ibsrq.pd);
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index f87b4c62d7d17867f16b65d5cd02ee09e3d64c51..ed0d4ce4b45d2961e265b1fe5d1c373fdd6c415e 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -90,7 +90,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	}
 
 	in->uid = (in->type != IB_SRQT_XRC) ?  to_mpd(pd)->uid : 0;
-	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
+	if (MLX5_CAP_GEN(pd_to_mdev(pd), cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
 		in->user_index = uidx;
 
@@ -105,18 +105,19 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 			     struct mlx5_srq_attr *in, int buf_size)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(srq->ibsrq.pd);
 	int err;
 	int i;
 	struct mlx5_wqe_srq_next_seg *next;
 
-	err = mlx5_db_alloc(dev->mdev, &srq->db);
+	err = mlx5_db_alloc(mdev, &srq->db);
 	if (err) {
 		mlx5_ib_warn(dev, "alloc dbell rec failed\n");
 		return err;
 	}
 
-	if (mlx5_frag_buf_alloc_node(dev->mdev, buf_size, &srq->buf,
-				     dev->mdev->priv.numa_node)) {
+	if (mlx5_frag_buf_alloc_node(mdev, buf_size, &srq->buf,
+				     mdev->priv.numa_node)) {
 		mlx5_ib_dbg(dev, "buf alloc failed\n");
 		err = -ENOMEM;
 		goto err_db;
@@ -151,7 +152,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	srq->wq_sig = 0;
 
 	in->log_page_size = srq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
-	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
+	if (MLX5_CAP_GEN(mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
 		in->user_index = MLX5_IB_DEFAULT_UIDX;
 
@@ -161,10 +162,10 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	kvfree(in->pas);
 
 err_buf:
-	mlx5_frag_buf_free(dev->mdev, &srq->buf);
+	mlx5_frag_buf_free(mdev, &srq->buf);
 
 err_db:
-	mlx5_db_free(dev->mdev, &srq->db);
+	mlx5_db_free(mdev, &srq->db);
 	return err;
 }
 
@@ -181,11 +182,13 @@ static void destroy_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 }
 
 
-static void destroy_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq)
+static void destroy_srq_kernel(struct mlx5_ib_srq *srq)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(srq->ibsrq.pd);
+
 	kvfree(srq->wrid);
-	mlx5_frag_buf_free(dev->mdev, &srq->buf);
-	mlx5_db_free(dev->mdev, &srq->db);
+	mlx5_frag_buf_free(mdev, &srq->buf);
+	mlx5_db_free(mdev, &srq->db);
 }
 
 int mlx5_ib_create_srq(struct ib_srq *ib_srq,
@@ -194,12 +197,13 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 {
 	struct mlx5_ib_dev *dev = to_dev(ib_srq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ib_srq);
+	struct mlx5_core_dev *mdev = pd_to_mdev(ib_srq->pd);
 	size_t desc_size;
 	size_t buf_size;
 	int err;
 	struct mlx5_srq_attr in = {};
-	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
-	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
+	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(mdev, log_max_srq_sz);
+	__u32 max_sge_sz =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
 			    sizeof(struct mlx5_wqe_data_seg);
 
 	if (init_attr->srq_type != IB_SRQT_BASIC &&
@@ -269,7 +273,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 		in.tm_log_list_size =
 			ilog2(init_attr->ext.tag_matching.max_num_tags) + 1;
 		if (in.tm_log_list_size >
-		    MLX5_CAP_GEN(dev->mdev, log_tag_matching_list_sz)) {
+		    MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) {
 			mlx5_ib_dbg(dev, "TM SRQ max_num_tags exceeding limit\n");
 			err = -EINVAL;
 			goto err_usr_kern_srq;
@@ -316,7 +320,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	if (udata)
 		destroy_srq_user(ib_srq->pd, srq, udata);
 	else
-		destroy_srq_kernel(dev, srq);
+		destroy_srq_kernel(srq);
 
 	return err;
 }
@@ -324,7 +328,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		       enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	int ret;
 
@@ -337,7 +340,7 @@ int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			return -EINVAL;
 
 		mutex_lock(&srq->mutex);
-		ret = mlx5_cmd_arm_srq(dev, &srq->msrq, attr->srq_limit, 1);
+		ret = mlx5_cmd_arm_srq(&srq->msrq, attr->srq_limit, 1);
 		mutex_unlock(&srq->mutex);
 
 		if (ret)
@@ -349,7 +352,6 @@ int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	int ret;
 	struct mlx5_srq_attr *out;
@@ -358,7 +360,7 @@ int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_cmd_query_srq(dev, &srq->msrq, out);
+	ret = mlx5_cmd_query_srq(&srq->msrq, out);
 	if (ret)
 		goto out_box;
 
@@ -384,7 +386,7 @@ int mlx5_ib_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 	if (udata)
 		destroy_srq_user(srq->pd, msrq, udata);
 	else
-		destroy_srq_kernel(dev, msrq);
+		destroy_srq_kernel(msrq);
 	return 0;
 }
 
@@ -409,7 +411,7 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 	struct mlx5_wqe_srq_next_seg *next;
 	struct mlx5_wqe_data_seg *scat;
 	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = pd_to_mdev(ibsrq->pd);
 	unsigned long flags;
 	int err = 0;
 	int nreq;
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index a7e3dc5564ac90ec8ddc536480e7ea5201e06cd5..76d389ec6b08f188a74cd555c9477dccb4f2368f 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -58,9 +58,9 @@ struct mlx5_srq_table {
 int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_srq_attr *in);
 int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq);
-int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_query_srq(struct mlx5_core_srq *srq,
 		       struct mlx5_srq_attr *out);
-int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_arm_srq(struct mlx5_core_srq *srq,
 		     u16 lwm, int is_srq);
 struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn);
 
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index c1a088120915c5741f37ed44fd2e8139bcb6802e..944b53074f69dca3a1b25b2dc8a41dae7546dcac 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -111,7 +111,7 @@ static int __set_srq_page_size(struct mlx5_srq_attr *in,
 					MLX5_ADAPTER_PAGE_SHIFT, page_offset,  \
 					64, &(in)->page_offset))
 
-static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_srq_cmd(struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_srq_out)] = {0};
@@ -150,7 +150,7 @@ static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(create_srq_in, create_in, opcode,
 		 MLX5_CMD_OP_CREATE_SRQ);
 
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
 	if (!err) {
@@ -161,7 +161,7 @@ static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int destroy_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_srq_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_srq_in)] = {};
 
@@ -169,10 +169,10 @@ static int destroy_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	MLX5_SET(destroy_srq_in, in, srqn, srq->srqn);
 	MLX5_SET(destroy_srq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, destroy_srq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_srq, in);
 }
 
-static int arm_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int arm_srq_cmd(struct mlx5_core_srq *srq,
 		       u16 lwm, int is_srq)
 {
 	u32 in[MLX5_ST_SZ_DW(arm_rq_in)] = {};
@@ -183,10 +183,10 @@ static int arm_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(arm_rq_in, in, lwm, lwm);
 	MLX5_SET(arm_rq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, arm_rq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), arm_rq, in);
 }
 
-static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int query_srq_cmd(struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_srq_in)] = {};
@@ -200,7 +200,7 @@ static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 
 	MLX5_SET(query_srq_in, in, opcode, MLX5_CMD_OP_QUERY_SRQ);
 	MLX5_SET(query_srq_in, in, srqn, srq->srqn);
-	err = mlx5_cmd_exec_inout(dev->mdev, query_srq, in, srq_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_srq, in, srq_out);
 	if (err)
 		goto out;
 
@@ -213,8 +213,7 @@ static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
-			      struct mlx5_core_srq *srq,
+static int create_xrc_srq_cmd(struct mlx5_core_srq *srq,
 			      struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_xrc_srq_out)];
@@ -255,7 +254,7 @@ static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 		 MLX5_CMD_OP_CREATE_XRC_SRQ);
 
 	memset(create_out, 0, sizeof(create_out));
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
 			    sizeof(create_out));
 	if (err)
 		goto out;
@@ -267,8 +266,7 @@ static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static int destroy_xrc_srq_cmd(struct mlx5_ib_dev *dev,
-			       struct mlx5_core_srq *srq)
+static int destroy_xrc_srq_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_xrc_srq_in)] = {};
 
@@ -276,10 +274,10 @@ static int destroy_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	MLX5_SET(destroy_xrc_srq_in, in, xrc_srqn, srq->srqn);
 	MLX5_SET(destroy_xrc_srq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, destroy_xrc_srq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_xrc_srq, in);
 }
 
-static int arm_xrc_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int arm_xrc_srq_cmd(struct mlx5_core_srq *srq,
 			   u16 lwm)
 {
 	u32 in[MLX5_ST_SZ_DW(arm_xrc_srq_in)] = {};
@@ -291,11 +289,10 @@ static int arm_xrc_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(arm_xrc_srq_in, in, lwm, lwm);
 	MLX5_SET(arm_xrc_srq_in, in, uid, srq->uid);
 
-	return  mlx5_cmd_exec_in(dev->mdev, arm_xrc_srq, in);
+	return  mlx5_cmd_exec_in(srq_to_mdev(srq), arm_xrc_srq, in);
 }
 
-static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
-			     struct mlx5_core_srq *srq,
+static int query_xrc_srq_cmd(struct mlx5_core_srq *srq,
 			     struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_xrc_srq_in)] = {};
@@ -310,7 +307,8 @@ static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	MLX5_SET(query_xrc_srq_in, in, opcode, MLX5_CMD_OP_QUERY_XRC_SRQ);
 	MLX5_SET(query_xrc_srq_in, in, xrc_srqn, srq->srqn);
 
-	err = mlx5_cmd_exec_inout(dev->mdev, query_xrc_srq, in, xrcsrq_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_xrc_srq, in,
+				  xrcsrq_out);
 	if (err)
 		goto out;
 
@@ -325,7 +323,7 @@ static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_rmp_cmd(struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	void *create_out = NULL;
@@ -371,7 +369,8 @@ static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		memcpy(pas, in->pas, pas_size);
 
 	MLX5_SET(create_rmp_in, create_in, opcode, MLX5_CMD_OP_CREATE_RMP);
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out, outlen);
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
+			    outlen);
 	if (!err) {
 		srq->srqn = MLX5_GET(create_rmp_out, create_out, rmpn);
 		srq->uid = in->uid;
@@ -383,17 +382,17 @@ static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int destroy_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_rmp_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_rmp_in)] = {};
 
 	MLX5_SET(destroy_rmp_in, in, opcode, MLX5_CMD_OP_DESTROY_RMP);
 	MLX5_SET(destroy_rmp_in, in, rmpn, srq->srqn);
 	MLX5_SET(destroy_rmp_in, in, uid, srq->uid);
-	return mlx5_cmd_exec_in(dev->mdev, destroy_rmp, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_rmp, in);
 }
 
-static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int arm_rmp_cmd(struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
 	void *out = NULL;
@@ -427,7 +426,7 @@ static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(rmpc, rmpc, state, MLX5_RMPC_STATE_RDY);
 	MLX5_SET(modify_rmp_in, in, opcode, MLX5_CMD_OP_MODIFY_RMP);
 
-	err = mlx5_cmd_exec_inout(dev->mdev, modify_rmp, in, out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), modify_rmp, in, out);
 
 out:
 	kvfree(in);
@@ -435,7 +434,7 @@ static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int query_rmp_cmd(struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 *rmp_out = NULL;
@@ -457,7 +456,7 @@ static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 
 	MLX5_SET(query_rmp_in, rmp_in, opcode, MLX5_CMD_OP_QUERY_RMP);
 	MLX5_SET(query_rmp_in, rmp_in, rmpn,   srq->srqn);
-	err = mlx5_cmd_exec_inout(dev->mdev, query_rmp, rmp_in, rmp_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_rmp, rmp_in, rmp_out);
 	if (err)
 		goto out;
 
@@ -472,7 +471,7 @@ static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_xrq_cmd(struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_xrq_out)] = {0};
@@ -521,7 +520,7 @@ static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(xrqc, xrqc, cqn, in->cqn);
 	MLX5_SET(create_xrq_in, create_in, opcode, MLX5_CMD_OP_CREATE_XRQ);
 	MLX5_SET(create_xrq_in, create_in, uid, in->uid);
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
 	if (!err) {
@@ -532,7 +531,7 @@ static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int destroy_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_xrq_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_xrq_in)] = {};
 
@@ -540,11 +539,10 @@ static int destroy_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	MLX5_SET(destroy_xrq_in, in, xrqn, srq->srqn);
 	MLX5_SET(destroy_xrq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, destroy_xrq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_xrq, in);
 }
 
-static int arm_xrq_cmd(struct mlx5_ib_dev *dev,
-		       struct mlx5_core_srq *srq,
+static int arm_xrq_cmd(struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
 	u32 in[MLX5_ST_SZ_DW(arm_rq_in)] = {};
@@ -555,10 +553,10 @@ static int arm_xrq_cmd(struct mlx5_ib_dev *dev,
 	MLX5_SET(arm_rq_in, in, lwm, lwm);
 	MLX5_SET(arm_rq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, arm_rq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), arm_rq, in);
 }
 
-static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int query_xrq_cmd(struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_xrq_in)] = {};
@@ -574,7 +572,7 @@ static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(query_xrq_in, in, opcode, MLX5_CMD_OP_QUERY_XRQ);
 	MLX5_SET(query_xrq_in, in, xrqn, srq->srqn);
 
-	err = mlx5_cmd_exec_inout(dev->mdev, query_xrq, in, xrq_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_xrq, in, xrq_out);
 	if (err)
 		goto out;
 
@@ -597,32 +595,32 @@ static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int create_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_srq_split(struct mlx5_core_srq *srq,
 			    struct mlx5_srq_attr *in)
 {
-	if (!dev->mdev->issi)
-		return create_srq_cmd(dev, srq, in);
+	if (!srq_to_mdev(srq)->issi)
+		return create_srq_cmd(srq, in);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return create_xrc_srq_cmd(dev, srq, in);
+		return create_xrc_srq_cmd(srq, in);
 	case MLX5_RES_XRQ:
-		return create_xrq_cmd(dev, srq, in);
+		return create_xrq_cmd(srq, in);
 	default:
-		return create_rmp_cmd(dev, srq, in);
+		return create_rmp_cmd(srq, in);
 	}
 }
 
-static int destroy_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_srq_split(struct mlx5_core_srq *srq)
 {
-	if (!dev->mdev->issi)
-		return destroy_srq_cmd(dev, srq);
+	if (!srq_to_mdev(srq)->issi)
+		return destroy_srq_cmd(srq);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return destroy_xrc_srq_cmd(dev, srq);
+		return destroy_xrc_srq_cmd(srq);
 	case MLX5_RES_XRQ:
-		return destroy_xrq_cmd(dev, srq);
+		return destroy_xrq_cmd(srq);
 	default:
-		return destroy_rmp_cmd(dev, srq);
+		return destroy_rmp_cmd(srq);
 	}
 }
 
@@ -643,7 +641,7 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		srq->common.res = MLX5_RES_SRQ;
 	}
 
-	err = create_srq_split(dev, srq, in);
+	err = create_srq_split(srq, in);
 	if (err)
 		return err;
 
@@ -657,7 +655,7 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return 0;
 
 err_destroy_srq_split:
-	destroy_srq_split(dev, srq);
+	destroy_srq_split(srq);
 
 	return err;
 }
@@ -673,7 +671,7 @@ int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	if (WARN_ON(tmp != srq))
 		return xa_err(tmp) ?: -EINVAL;
 
-	err = destroy_srq_split(dev, srq);
+	err = destroy_srq_split(srq);
 	if (err) {
 		/*
 		 * We don't need to check returned result for an error,
@@ -697,33 +695,33 @@ int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	return 0;
 }
 
-int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_query_srq(struct mlx5_core_srq *srq,
 		       struct mlx5_srq_attr *out)
 {
-	if (!dev->mdev->issi)
-		return query_srq_cmd(dev, srq, out);
+	if (!srq_to_mdev(srq)->issi)
+		return query_srq_cmd(srq, out);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return query_xrc_srq_cmd(dev, srq, out);
+		return query_xrc_srq_cmd(srq, out);
 	case MLX5_RES_XRQ:
-		return query_xrq_cmd(dev, srq, out);
+		return query_xrq_cmd(srq, out);
 	default:
-		return query_rmp_cmd(dev, srq, out);
+		return query_rmp_cmd(srq, out);
 	}
 }
 
-int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_arm_srq(struct mlx5_core_srq *srq,
 		     u16 lwm, int is_srq)
 {
-	if (!dev->mdev->issi)
-		return arm_srq_cmd(dev, srq, lwm, is_srq);
+	if (!srq_to_mdev(srq)->issi)
+		return arm_srq_cmd(srq, lwm, is_srq);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return arm_xrc_srq_cmd(dev, srq, lwm);
+		return arm_xrc_srq_cmd(srq, lwm);
 	case MLX5_RES_XRQ:
-		return arm_xrq_cmd(dev, srq, lwm);
+		return arm_xrq_cmd(srq, lwm);
 	default:
-		return arm_rmp_cmd(dev, srq, lwm);
+		return arm_rmp_cmd(srq, lwm);
 	}
 }
 

-- 
2.49.0

