Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346CE46EC98;
	Wed, 12 Aug 2026 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546785; cv=fail; b=MwO+e+eUZHbLEOQ3dVAEsLG+0oq8ICNQamubSu+6BF0EzSyqrif2Ny6C9uRHF6FYFWbqMc8kH9/MHTX5BzAfS3A/b2J7B26lKk4pO2MlQdjXqfHtRuC/NFU366x8bWLnxjAwz4q5V2ZKUAXhZCmF8uX18qPzecmi9QRRQmmAsr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546785; c=relaxed/simple;
	bh=DuL24sEjcVd49OtZCOGLwkDHmaERsUuXine6oxuOOeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cr/dRSDQk4esVDt6rUPuMCJ5ZHfc4dEojREDI9435saDQH2J1lSwgmVKgC9V27X1vK0liybHak+xPceLhS/B2ZLkkLM+ZPIBfRHONmfXvEANWDvpe8bjhve/hOOuDkQjkpJ3/tTNhY0y6LEKGQxv/K7G+TARQUdmh1Px2fmzNkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EFNK3Pke; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EFNK3Pke"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIGA3PNA6rkBzQ9puepTeQcibdKQkQJZBZsDI6XmXK/x3W9sMt0cj4dku1dXfYg2ahHMr6OFfjk2xZRy749Ows5N86VVFgOYbUwpDDsUGkdpt5qFRRz9ZXz5qEKNYNKLxY0HM7frmxEofD+2lJwvC6O1oybMP9ILeYgcIsmQgwPRwXRqWyGOs2dNWu25t5CPsjUrwAsokz8mpAm1xs/emEh7QYll+Tkymx5OkSCr7paUJiFijjAkCdWSnh74kHrc5AGOriSQBJNbk/tr/t4lgQg17Q6nxE2FB+LS5jBdsEwGfDIl7gzeqahc/c24Q9Qa4vri6HCuIJ7fUvXrahN9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whxClA7xbQOd7gzmbsOAH+Vk6ImmSHE5s22SIWAwXmE=;
 b=a5h9StziAJ7vyDZiZuVNc2U/bFsT5f6KCdmbYCw3mkUjkrRe+Jezo0ICXG26IkQDgobo62ZaLqFZGIViw5Ik8gcbTt0QFzTJ9IUSAXNIt5JqM09LHlPANpmOqh8l4jahuJa9I8my4K9CTJu9OCcdO16SsZ/fzGeKQ08G9wIa0McLKLc5LyZ7oMBOsbjC0NB16iEdEWj5mFclTSvFhhYUlHp/IUIVhbar5y5OyWCoFQxNbLfN4HzFrqT9rK4yHDVI+g/HzIq0MqmPQ8uv+Hv4x3V/ZxglEp1Y0PSUqo0zgfbGYkIbGljbLXc55EFRR82yLlrdva4WdNQ7ldFlfyhF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whxClA7xbQOd7gzmbsOAH+Vk6ImmSHE5s22SIWAwXmE=;
 b=EFNK3PkeleWwWEgVGMjJzW1TBH5KmEehUyGwVrJOXZNNluo09C4sghZn068kephKOVBIPCI967a8AfRPRhxE/liW55HjPDR6pdhKNvoqA1GAXHOMjclv/oPnKlUQ5bpdjFXHmPvck6qmw9erUW4G2TUbTJSxId4o3ZD3f5SXRBE1V/KJUr0Vw1kYdzMhFhwCTQElMIw2rRcbIQt4ep0QOtdrAI97RrSggCawtFSioC/0ifi+74AR8q3jm04d/KinwszDWw7UrGW8j5AU2efA8nu9w3fqzeKvhiiiXXOGC7S40IXl48dYp7VlhZ+b8wYond29llLccpTWRB87jQsBlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v4 09/10] vfio: selftests: Add mlx5 driver - data path and memcpy ops
Date: Wed, 12 Aug 2026 11:59:07 -0300
Message-ID: <9-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:408:f4::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: d9a527e1-1c66-4eb6-70d1-08def8824467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	3jRCX6lJDKDBX8FyDTrl32VAL1S6rxyIbmK0PF18DPnuxWTXTcGeHzeEaPq3BuzloGEKYE63Q/af4yxUeGX6F5/I6dymbDw7jm24zrfskfnFPlwPy65iYNuMPDROEwRhY0FUWtkTDL6c/+cGrTzfPFyZHjgFY/XyJxHJkbKKL6gk+72iLwADPE1E6rWxc473yLgjbA06Ff0cx3j5t3NSWpAk+LaPxkqnYAbb9bR263Sagzv1B3WXcAKCYpxmVRA/2+WLdTVuOFGnHXBM+iIT2JXQC8u9Onha5EHOaB3203/FlMqypch2SIV9ZC1veHjuan+caskLUxaTCz9VdzdwCqWxoxQj9tfEqtbFM0DdkD1+nLh3eDpkFB2bb0FuSn+TcxyEjj2TbNqHbgVIeV0K+SooMEwiRvt0wWhlda2mhXmO4i0pvXvW962drYwmY9VCHga78Ym+31a7tKRUn3ZhS2suUfCxaUOZU5HJEqQDIJqUYlY4c5G5GixyajVvvzkGs1H0MKRMm7Kph/NdXZ9T16T+Z7NmjGoNeaxZQ3JeQ2f4k7P3cbknvqS4JJGDxEv8+iArGJHyHhgF55pX0XPyK0lhIcyZLuhwS8dHuc97Y2Vxfkk6J38jUzUVmRiJZjVgH/wotaFiqvMidgIPekw5kYLAC3kM0UdcEe8Kaw8Cg+J2kw3fyzDRTwqjbVobjFM0cl6PJsFU0Kh7ZPbFtUxowg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hXvWdYWP3nvoOlUn/URXiVzxq8zhIGdMiKei0G5iYrF0PhUTAu3ZTLP/wgyN?=
 =?us-ascii?Q?yRCqKqD896rvrUBiMzdvoOA+oPmzGcx/v/bTLXXMEbcO5NLSCzsoZf50S5n6?=
 =?us-ascii?Q?6J+dfIia5Hlig3/YxlnuhM/ffw/cQqkxssu/hZFgV+zYp4OpD9XTwEV+yem4?=
 =?us-ascii?Q?aJE9dktVgTne12obJAv+QQe38ohmTGV9/TtKrc7U51YqJXPhqQtxFlGfuZGB?=
 =?us-ascii?Q?Sr5cd7xdEauPFOuHa7l87FEc12PJ8E4Mt4tHQAE+LvSW+XT9nnlocneoF7xu?=
 =?us-ascii?Q?YZsUAuKaPZsQJWl/B9xbfgGoSAoD+ZhkFBQRr8TcZ1Qvl/C4WRtBsEezDd2c?=
 =?us-ascii?Q?+BhDAovqPWn9IFNEKrvP6iF5MgqQXeRtxICVR0wNGx0B4QuijaMkwNOpUn+9?=
 =?us-ascii?Q?O+09Pbz6dfBGjPuV4VnP8kxRfwDKpdhkdVshACQE2lUw8khXlN2ULzbyaW8g?=
 =?us-ascii?Q?BRIWqHSZbsGvlyDMyE40ZODPqD1rbvYZ1GNh2/iE7rKBD+3NWBh0bi11jFft?=
 =?us-ascii?Q?h6k+YOtdSMC2du4RSH97c7qsRmR/i6pmSKssXir5et/LAKbk5b5aLsyhb3Ku?=
 =?us-ascii?Q?dnOA34R/3rxkFlH9jc9ty5EJM8gVaqDeVZgqUIsF1ONA0LzuXaDTe6M4SMPV?=
 =?us-ascii?Q?fCpCdtj/+ctl9+TWdk1LUhqnn0lZVCLoxpWbd97M6X58OcWrXm4doSNnAsEN?=
 =?us-ascii?Q?yMLDqTWcebYmljzUOR9mdiYKpe4j2a4izSHNc/nzXtJxQieB324haUMWZfqB?=
 =?us-ascii?Q?IDrfy3+0lJXmxLxs+6iAZh0GIAifyFLgPikAM68uzNAeAGRnIn5otf6PWuKU?=
 =?us-ascii?Q?A84x7NxHfdwyZMAbKjVS69e2qCsndzh8vI+NUFm/qNUZkTAXfLjKd7qlpnxh?=
 =?us-ascii?Q?MwPBleyzvKkWq1QkRppAvQeATVLC1mmL/Vgabw9zIWCW87mzGsoKiN/AGil1?=
 =?us-ascii?Q?4JUULeai5WNfFNGkrAzvOtUmEd6oIX/ng7niZHIejTONZwjkLdBcWdaXiLB9?=
 =?us-ascii?Q?XTgUmHXQO/Vzd1fY7WMlmnO8EeRkXGmLnhYpjCq5w9p8tCV1ao9jIbrVFS1u?=
 =?us-ascii?Q?fM+CcFiI8LvNEp23mp1qLOKzMJwj/Dk5fAucCJJQxUifEBsu4RIsZ+y9k9Ol?=
 =?us-ascii?Q?lx4fM5ZXnplBfY6CZnQEDwbIJGHGMrDWlhblRHvakbOCowztj+9KtofKGkq6?=
 =?us-ascii?Q?2Ko0IlZ5uDDEaSJ2cIaGWjfJkKo/dA3AZrHCtwnszhtoVIhlvxHI6Zjtakh8?=
 =?us-ascii?Q?BQVMWrS4W4HO6I+fLzsKoG6gQAp8MqQVfkwo8gXCB9qDkWLY8PbGPM/G5TX0?=
 =?us-ascii?Q?vYbaImyEq1cnf2WQpvzF2NcgzVTphCGCVTNANaegJRkyRfqRcYMFCSXai9U3?=
 =?us-ascii?Q?Ff39+A/FtsdunnU+hen15G59KPjT70OPRCh+h6tkWMnPNFo1EqpoG91cAaAT?=
 =?us-ascii?Q?zwM3RReM26A2xRBXngswQWhfnlftX4cbgdNv1dB94dRRZEdacp0woP5D5HQb?=
 =?us-ascii?Q?+T+ZPV8W8gPiaXt9G/LzkHdP/F3js+vaoGVhfh6JN+oPZo8X2fdAkVG2xgba?=
 =?us-ascii?Q?rX/d9LHTNqgg3oHwC2zutX9BgatjD1mtjv/cKFF8ppA7tnINP5jJu1wT7ScG?=
 =?us-ascii?Q?nfeUh2/ALVV9agnglshkNDyHUq5JYQCwH+LcWKxYNujRfYq8zs8x/lCYk0eh?=
 =?us-ascii?Q?JT8Gn3fRJz8N7L3yHqNBAG4j50sQD7K5HjtT/zExJeYN+5khcLN22Ad/mcQ0?=
 =?us-ascii?Q?Q2Bg7sVHfQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a527e1-1c66-4eb6-70d1-08def8824467
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:11.3624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xANmbT/dQ002ZeQqtePKEWkXhMeBG1ACPdAe8ePQ5wHZHNaudeHoys7y9U59k6WA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

Complete the mlx5 driver by adding CQ/QP creation, QP state
transitions, WQE posting, CQ polling, and the
memcpy_start/memcpy_wait callbacks. After this patch the driver is
functional for DMA tests.

The data path implements RDMA Write self-loopback via an RC QP with
force-loopback.  WQEs are posted to a 16-entry send queue with an
NC doorbell, and completions are polled from a 16-entry CQ.

Assisted-by: Claude:claude-opus-4.6
Acked-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 359 +++++++++++++++++-
 1 file changed, 357 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
index 804801cc564e7a..e5e75adb253166 100644
--- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
+++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
@@ -1343,6 +1343,354 @@ static void mlx5st_destroy_mkey(struct mlx5st_device *dev)
 	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+/*
+ * CQ create/destroy
+ */
+
+static void mlx5st_create_cq(struct mlx5st_device *dev)
+{
+	struct vfio_pci_device *device = dev->device;
+	u64 in[MLX5_ST_SZ_QW(create_cq_in) + 1] = {};
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)] = {};
+	struct mlx5_ifc_cqc_bits *cqc;
+	unsigned int i;
+	__be64 *pas;
+
+	/* Initialize CQEs before CREATE_CQ: opcode=0xF, owner=1 */
+	for (i = 0; i < CQ_CQE_CNT; i++) {
+		struct mlx5st_cqe64 *cqe = &dev->cq_buf[i];
+
+		MLX5_SET(cqe64, cqe, opcode, 0xF);
+		MLX5_SET_ONCE(cqe64, cqe, owner, 1);
+	}
+
+	MLX5_SET(create_cq_in, in, opcode, MLX5_CMD_OP_CREATE_CQ);
+
+	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
+	MLX5_SET(cqc, cqc, log_cq_size, LOG_CQ_SIZE);
+	MLX5_SET(cqc, cqc, uar_page, dev->uar_page);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, dev->eqn);
+	MLX5_SET(cqc, cqc, cqe_sz, 0);
+	pas = MLX5_ADDR_OF(create_cq_in, in, pas);
+	MLX5_SET(cqc, cqc, page_offset, mlx5st_fill_pas(device, dev->cq_buf, pas));
+	MLX5_SET(cqc, cqc, log_page_size, 0);
+	MLX5_SET64(cqc, cqc, dbr_addr, to_iova(device, &dev->cq_dbrec));
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+
+	dev->cqn = MLX5_GET(create_cq_out, out, cqn);
+	dev->cq_ci = 0;
+	dev_dbg(device, "Created CQ: cqn=%u, %d entries\n", dev->cqn,
+		 CQ_CQE_CNT);
+}
+
+static void mlx5st_destroy_cq(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_cq_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
+
+	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
+	MLX5_SET(destroy_cq_in, in, cqn, dev->cqn);
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+/*
+ * QP create/destroy
+ */
+
+static void mlx5st_create_qp(struct mlx5st_device *dev)
+{
+	struct vfio_pci_device *device = dev->device;
+	u64 in[MLX5_ST_SZ_QW(create_qp_in) + 1] = {};
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
+	struct mlx5_ifc_qpc_bits *qpc;
+	__be64 *pas;
+
+	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
+
+	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+	MLX5_SET(qpc, qpc, st, MLX5_QPC_ST_RC);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QPC_PM_STATE_MIGRATED);
+	MLX5_SET(qpc, qpc, pd, dev->pdn);
+	MLX5_SET(qpc, qpc, uar_page, dev->uar_page);
+	MLX5_SET(qpc, qpc, cqn_snd, dev->cqn);
+	MLX5_SET(qpc, qpc, cqn_rcv, dev->cqn);
+	MLX5_SET(qpc, qpc, log_sq_size, LOG_SQ_SIZE);
+	MLX5_SET(qpc, qpc, log_msg_max, dev->log_max_msg);
+	MLX5_SET(qpc, qpc, rq_type, 0x3);
+	MLX5_SET(qpc, qpc, ts_format, 1);
+	pas = MLX5_ADDR_OF(create_qp_in, in, pas);
+	MLX5_SET(qpc, qpc, page_offset,
+		 mlx5st_fill_pas(device, dev->sq_buf, pas));
+	MLX5_SET(qpc, qpc, log_page_size, 0);
+	MLX5_SET64(qpc, qpc, dbr_addr, to_iova(device, &dev->qp_dbrec));
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+
+	dev->qpn = MLX5_GET(create_qp_out, out, qpn);
+	dev->sq_pi = 0;
+	dev_dbg(device, "Created QP: qpn=%u, RC, sq=%d wqes\n", dev->qpn,
+		 SQ_WQE_CNT);
+}
+
+static void mlx5st_destroy_qp(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
+
+	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
+	MLX5_SET(destroy_qp_in, in, qpn, dev->qpn);
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+/*
+ * QP state transitions
+ */
+
+static void mlx5st_qp_rst2init(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(rst2init_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(rst2init_qp_in)] = {};
+	struct mlx5_ifc_qpc_bits *qpc = MLX5_ADDR_OF(rst2init_qp_in, in, qpc);
+
+	MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
+	MLX5_SET(rst2init_qp_in, in, qpn, dev->qpn);
+
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QPC_PM_STATE_MIGRATED);
+	MLX5_SET(qpc, qpc, rre, 1);
+	MLX5_SET(qpc, qpc, rwe, 1);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	dev_dbg(dev->device, "QP RST->INIT\n");
+}
+
+static void mlx5st_qp_init2rtr(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(init2rtr_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(init2rtr_qp_in)] = {};
+	struct mlx5_ifc_qpc_bits *qpc = MLX5_ADDR_OF(init2rtr_qp_in, in, qpc);
+
+	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
+	MLX5_SET(init2rtr_qp_in, in, qpn, dev->qpn);
+
+	MLX5_SET(qpc, qpc, mtu, 3);
+	MLX5_SET(qpc, qpc, log_msg_max, dev->log_max_msg);
+	MLX5_SET(qpc, qpc, remote_qpn, dev->qpn);
+	MLX5_SET(qpc, qpc, min_rnr_nak, 12);
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+	MLX5_SET(qpc, qpc, primary_address_path.fl, 1);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	dev_dbg(dev->device, "QP INIT->RTR (fl=1)\n");
+}
+
+static void mlx5st_qp_rtr2rts(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(rtr2rts_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] = {};
+	struct mlx5_ifc_qpc_bits *qpc = MLX5_ADDR_OF(rtr2rts_qp_in, in, qpc);
+
+	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, dev->qpn);
+
+	MLX5_SET(qpc, qpc, log_ack_req_freq, 0);
+	MLX5_SET(qpc, qpc, retry_count, 7);
+	MLX5_SET(qpc, qpc, rnr_retry, 7);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 14);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	dev_dbg(dev->device, "QP RTR->RTS\n");
+}
+
+/*
+ * Post RDMA Write WQE
+ */
+static void mlx5st_post_rdma_write(struct mlx5st_device *dev, u64 src_addr,
+				    u32 src_lkey, u64 dst_addr, u32 dst_rkey,
+				    u32 length, bool signaled)
+{
+	struct mlx5st_send_wqe *wqe;
+	unsigned int idx;
+
+	idx = dev->sq_pi % SQ_WQE_CNT;
+	wqe = &dev->sq_buf[idx];
+
+	memset(wqe, 0, sizeof(*wqe));
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, opcode, MLX5_OPCODE_RDMA_WRITE);
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, wqe_index, dev->sq_pi);
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, qp_or_sq, dev->qpn);
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, ds, MLX5_RDMA_WRITE_DS);
+	if (signaled)
+		MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, ce, MLX5_WQE_CE_CQE_ALWAYS);
+
+	MLX5_SET64(wqe_raddr_seg, &wqe->raddr, raddr, dst_addr);
+	MLX5_SET(wqe_raddr_seg, &wqe->raddr, rkey, dst_rkey);
+
+	MLX5_SET(wqe_data_seg, &wqe->data, byte_count, length);
+	MLX5_SET(wqe_data_seg, &wqe->data, lkey, src_lkey);
+	MLX5_SET64(wqe_data_seg, &wqe->data, addr, src_addr);
+
+	dev->sq_pi++;
+
+	/* Ensure WQE is visible to device before doorbell record */
+	dma_wmb();
+
+	WRITE_ONCE(dev->qp_dbrec.send_counter,
+		   cpu_to_be32(dev->sq_pi & 0xffff));
+
+	/*
+	 * Ring doorbell: write first 8 bytes of ctrl to UAR BF register,
+	 * iowrite has an internal dma_wmb() so the doorbell record will be
+	 * visible.
+	 */
+	iowrite64be(be64_to_cpu(*(__be64 *)wqe),
+		    (u8 __iomem *)dev->uar_base + dev->uar_bf_offset);
+	dev->uar_bf_offset ^= MLX5_BF_SIZE;
+}
+
+/*
+ * Poll CQ
+ */
+static int mlx5st_poll_cq_batch(struct mlx5st_device *dev,
+				unsigned int max_cqe)
+{
+	unsigned int polled = 0;
+
+	while (polled < max_cqe) {
+		unsigned int idx = dev->cq_ci % CQ_CQE_CNT;
+		struct mlx5st_cqe64 *cqe = &dev->cq_buf[idx];
+		u8 owner, opcode;
+
+		owner = MLX5_GET_ONCE(cqe64, cqe, owner);
+		if (owner != ((dev->cq_ci >> LOG_CQ_SIZE) & 1))
+			break;
+
+		dma_rmb();
+
+		opcode = MLX5_GET(cqe64, cqe, opcode);
+
+		dev->cq_ci++;
+		WRITE_ONCE(dev->cq_dbrec.recv_counter,
+			   cpu_to_be32(dev->cq_ci & 0xffffff));
+
+		if (opcode == MLX5_CQE_REQ) {
+			dev->sq_ci =
+				(u16)(MLX5_GET(cqe64, cqe, wqe_counter) + 1);
+			polled++;
+			continue;
+		}
+		if (opcode == MLX5_CQE_REQ_ERR ||
+		    opcode == MLX5_CQE_RESP_ERR) {
+			dev_dbg(dev->device,
+				"CQE error: opcode=0x%x syndrome=0x%x vendor=0x%x\n",
+				opcode,
+				MLX5_GET(cqe64, cqe, error_syndrome.syndrome),
+				MLX5_GET(cqe64, cqe,
+					 error_syndrome.vendor_error_syndrome));
+			return -1;
+		}
+		dev_err(dev->device, "CQE unexpected opcode=0x%x\n", opcode);
+		return -1;
+	}
+
+	return polled;
+}
+
+static int mlx5st_poll_cq(struct mlx5st_device *dev, unsigned int timeout_ms)
+{
+	struct timespec start, now;
+	unsigned int elapsed;
+	int ret;
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	for (;;) {
+		ret = mlx5st_poll_cq_batch(dev, 1);
+		if (ret < 0)
+			return -1;
+		if (ret > 0)
+			return 0;
+
+		if (dev->have_eq)
+			mlx5st_process_events(dev);
+
+		clock_gettime(CLOCK_MONOTONIC, &now);
+		elapsed = (now.tv_sec - start.tv_sec) * 1000 +
+			  (now.tv_nsec - start.tv_nsec) / 1000000;
+		if (elapsed > timeout_ms) {
+			dev_err(dev->device, "CQ poll timeout after %u ms\n",
+				timeout_ms);
+			return -1;
+		}
+	}
+}
+
+/*
+ * Data path setup/teardown helpers
+ */
+
+static void mlx5st_setup_datapath(struct mlx5st_device *dev)
+{
+	mlx5st_create_cq(dev);
+	mlx5st_create_qp(dev);
+	mlx5st_qp_rst2init(dev);
+	mlx5st_qp_init2rtr(dev);
+	mlx5st_qp_rtr2rts(dev);
+}
+
+static void mlx5st_teardown_datapath(struct mlx5st_device *dev)
+{
+	if (dev->qpn) {
+		mlx5st_destroy_qp(dev);
+		dev->qpn = 0;
+	}
+	if (dev->cqn) {
+		mlx5st_destroy_cq(dev);
+		dev->cqn = 0;
+	}
+	dev->sq_pi = 0;
+	dev->sq_ci = 0;
+	memset(&dev->qp_dbrec, 0, sizeof(dev->qp_dbrec));
+	memset(&dev->cq_dbrec, 0, sizeof(dev->cq_dbrec));
+}
+
+/*
+ * memcpy callbacks
+ */
+
+#define MLX5ST_MEMCPY_TIMEOUT_MS 60000
+
+static void mlx5st_memcpy_start(struct vfio_pci_device *device,
+				 iova_t src, iova_t dst, u64 size, u64 count)
+{
+	struct mlx5st_device *dev = to_mlx5st(device);
+	u64 i;
+
+	for (i = 0; i < count; i++) {
+		bool signaled = (i == count - 1);
+
+		mlx5st_post_rdma_write(dev, src, dev->global_lkey, dst,
+				       dev->global_rkey, size, signaled);
+	}
+}
+
+static int mlx5st_memcpy_wait(struct vfio_pci_device *device)
+{
+	struct mlx5st_device *dev = to_mlx5st(device);
+	int ret;
+
+	ret = mlx5st_poll_cq(dev, MLX5ST_MEMCPY_TIMEOUT_MS);
+	if (ret) {
+		/*
+		 * CQE error puts the QP in error state.  Rebuild the data path
+		 * so subsequent operations can succeed.
+		 */
+		mlx5st_teardown_datapath(dev);
+		mlx5st_setup_datapath(dev);
+	}
+	return ret;
+}
+
 /*
  * Driver ops callbacks
  */
@@ -1373,6 +1721,11 @@ static void mlx5st_init(struct vfio_pci_device *device)
 	mlx5st_alloc_pd(dev);
 	mlx5st_create_mkey(dev);
 
+	mlx5st_setup_datapath(dev);
+
+	device->driver.max_memcpy_size = 1ULL << dev->log_max_msg;
+	device->driver.max_memcpy_count = SQ_WQE_CNT - 1;
+
 	dev_dbg(device, "mlx5 driver initialized\n");
 }
 
@@ -1380,6 +1733,8 @@ static void mlx5st_remove(struct vfio_pci_device *device)
 {
 	struct mlx5st_device *dev = to_mlx5st(device);
 
+	mlx5st_teardown_datapath(dev);
+
 	dev_dbg(device, "teardown: destroy_mkey\n");
 	if (dev->mkey_index) {
 		mlx5st_destroy_mkey(dev);
@@ -1408,7 +1763,7 @@ struct vfio_pci_driver_ops mlx5st_ops = {
 	.probe = mlx5st_probe,
 	.init = mlx5st_init,
 	.remove = mlx5st_remove,
-	.memcpy_start = NULL,
-	.memcpy_wait = NULL,
+	.memcpy_start = mlx5st_memcpy_start,
+	.memcpy_wait = mlx5st_memcpy_wait,
 	.send_msi = NULL,
 };
-- 
2.43.0

