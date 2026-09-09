Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4C53CA82;
	Wed,  9 Sep 2026 23:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998295; cv=fail; b=rBHMScLrdlhIkkeSPvY0ziSw7ghk6kmwBmiNMQN+O/33VpJHjP3/pYX/JWYnndfEOCKrvKA5iUiBTcKRz+QE9VIF+IDUwYsB1iTl/A8jz4+bgx7MCEKvQf+ucCE0lmjXtwIZ7GBGvmBITaU8wKF7ymvwdWm5+74otb6j1x6nONc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998295; c=relaxed/simple;
	bh=DuL24sEjcVd49OtZCOGLwkDHmaERsUuXine6oxuOOeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KuoMHSoe24ByhE2Gy8ZnpgoHapBt7MZnsYRzNoqK9uAahl/0to5j4nzLOm/xc/KpxhRSyCIVT4C8ibJPYG62JTyMf+v3cd80ULTc/Dh12ixHjkmdwmE620/Q1bA384rvF+Rujs0UW0D5W85nBSLopTorOiC53oQZeoj/RDAJ3VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YnfpPCX7; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YnfpPCX7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IM9It7dv16CQ7nmwJhpDHMDo2J5PwbVKBNT3R0W2cm5Mhw66lHC5pitE6TmrQAVsAyGkJ+xY1pu95h7mfYzK5Zbi/ulrFmfL08Q6o1QLqNANhDbIeImEi0uQh+sjpWDoftWmWKL52yXUOEzwc0kfHk42r6iac2gNXioSSvc3BmPGU0ScFsSNVXVtGDIJIyvUaaFiURXsrbl8KBHxL15hAWRvTSTxQbxxWty0nHjtqRe9Oi+wmEpRiOvZTB597zX+AK5FaVCYNj455cixE9VDk+LaQ0YHsKqdKyOTTCKj6oWklI0TfVep1GRWqvPwQEqm3MBNnmE9Rl7934JXeQQCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whxClA7xbQOd7gzmbsOAH+Vk6ImmSHE5s22SIWAwXmE=;
 b=fnIWBgQiNsDp42mm1TbTawcZCs8kbA+Zp50qKVXhiZuTHABqaIQkk0lvY/iBjBG+BspH2teyqlEUm9pqhT0R6gTgnkOU+rwgCoBDxIttgK1pGL3a54L2KOG85HLnw3g/OHCLG6cVbWi5LVuGaLLO1sz6mQolUmlsdrU9tHfA2J4OBI1qqtYtkADq1tP9DqZ5QpU7uK2/cTBeaPM41jLuYvNe/5GEM3eyE7mnYnxS8d67sY/XFJZRxtagOqypVUiveaPCVQ5k13VQA6A/4ucgvZgLiTpHMknkMqnF9tlXAryoHIWzx2dol6eZ2L6xWsWpn44ZsD4Zgu8DHggOowd1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whxClA7xbQOd7gzmbsOAH+Vk6ImmSHE5s22SIWAwXmE=;
 b=YnfpPCX7muVnP63jcwrbiSaPF+Ru+A+0QMl6q3CVct2hXA6koGN5YUdvE5etljAXU3vwtm+XqQ11b3SyfCPogT2EG8Wq3m/8NC5vI+1x3WboyA2oKEHwzsWIQZWkRDNW/SVvravGr7zBLLX6/5BkWIokuw5s+xosoRq5fcbb55U4s12lSQ9rKhJy6nNHQ036hhxoq6eAToQrt87ip3pZgHbPsIwQQawTPgwsORSjAvQpCCajn5oC3Vc/hAgk15LmVLvR2smcBwdg0Dz/dGvn5bjbknq43SBDWZNJ6h/qva/BNJqdPuuBz7hBKtBjI9LCdu9LKqy1jIakjg/4R0uhqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Wed, 9 Sep
 2026 23:57:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:50 +0000
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
Subject: [PATCH v5 09/10] vfio: selftests: Add mlx5 driver - data path and memcpy ops
Date: Wed,  9 Sep 2026 20:57:35 -0300
Message-ID: <9-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0058.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: a8cd7348-0386-4a8d-d79c-08df0ece21df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	kfDNsAwcxlomtAO+T/17IXNPSuqSlu2cAidiJVFxZwppPW4XOQYEV4IFEhB8ICKh+mHzMQWHqvMJMk51XivNrjzXRXzrmlSDsCODnKn2me5QR2DKA1mSSebYVtXdPAG1r9UvMDacJV2VitpzyeFdCT831XIPZp69N2ltPHwa2xrhc+UEceP3AQnlx5RLOK8aZawMeufe38z8qh0tR9ysA5cG8Hckwm7GOi4Jj1CtwpicZifRrJEYjKftHNla0fB7k+McXF+7MKq/XkK5F2R18HSHgPsvTkOWnq5X8AaTyheiRMijoHfxDUncVHm183+B7m9+8WjEVc5K+zXnFxmOS9D2SR4BnXgkdGPav4Ms9FGld5OgJ82EbvFMyNAT8y5DIUw5BtQQk8vlfJWnR1ueLGriJN7BG1fnbfrIwgnO+16kOcdcZfYIDM8WNQG+PiEE/n9f4YgjvngCG50tSvGXS23wWd7NtA16eNug3u3sEXxvyQ8s0jhIxC5qG0cjNxW1/wQWYk2YF4bIomtM03q66bdDi1dNH+5iqeaKOYWORQucjerxVBOgl/O9gjFhnM3Khca1VQiE6is86oOyS54FdPZ3g4m3zev7ECgnvtCFuf2VClAwytzpkMblFJfZruWRaz8Euo4zD8Gldk2Yi2wETU/Ylm7GppTbZF8W4OrZYG4VSNaZpDuaF7onnsDlgiO8ZY81vdkHRZD2mJAJvBIwoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sPZlvnXhtyrzt/swG2se0GUtjgYsvwfsE3MU68WxMi9Ix2Kmj66FMhxbCvTJ?=
 =?us-ascii?Q?B5j2V8VOtuePt8fBrUyszxGEQuDQu9znSNuPCkuIZRbdkr+GAjaEEj5wpacz?=
 =?us-ascii?Q?M0Wv9b7Qkwjcc3fWVmuxMkf4viAOQ6Aw8mDUIo+Sy2uUT17qvrbhTooDVAjQ?=
 =?us-ascii?Q?Y9br4+WdgWjvFCXOk8R/tuyFzY4fqaNCRC0WQHZGeoMwbTR8IQu6q8oiW/eS?=
 =?us-ascii?Q?Uw8h7MMjpSOKLaJBV58/eJissbjUHGOfHtx8m2hWkcPs0niZXbgQHxUkOzQO?=
 =?us-ascii?Q?ZrtL1CUB3uQirtGshOTKtsPQucQQDxU8aWWlZVOzyKTBAnpEqlzQUdK160pV?=
 =?us-ascii?Q?bq36ohVOogpB8cw8ayYtV18wRIY7DImNtFyS6TtpQtVi2uLiLPdDwQI51RHb?=
 =?us-ascii?Q?RO/bK7KWKQoBxHik4pYoCJJcdcC60DnRJFYAm+++YvwwUOxeRBfvXQ4PtMFy?=
 =?us-ascii?Q?O+tOsWjFv7uUkXecFVI+r8aMCeExJLHsO+H2OroVDErhIBP4W8RgOEhlnMTR?=
 =?us-ascii?Q?vgtjpRYzmJ9n7XUBVvCrREn5Bmh2K79GnCW/EKINNbSyZeNcM9AsXuvioZUw?=
 =?us-ascii?Q?7UmWMdJ+IJwYYXb36yzvPQGkiZxCU7568sc2W/QOHDxVAktbNjxpHee0gCkF?=
 =?us-ascii?Q?VpLim8rjTGjVQDRaW+LC9ibmeIqGDf0peo/OxRQ0T+3LcCcdUH6XeMDH60sW?=
 =?us-ascii?Q?1meeTmlaU9Fnd9v0f0wdDuIhyRREezN4vdjVWi9Jk33knOAF01uA6cjVUQXz?=
 =?us-ascii?Q?LF6SWrpXGCGttLTqwSR+sI8rQKojvHBdvQsM+I1j3llhlQmYziDsjAo2NooZ?=
 =?us-ascii?Q?5gtsHD1ODrS4IVYxp5ImrBZ3dQzUzXrRCcTVPp5I/bAYnH0laojC2xp5TzRn?=
 =?us-ascii?Q?O6VSi/bO/fyxmh7cZBCXMGbQbMMh6v5qbcC4u/27hIsbtCqI3LzFq3Jjras+?=
 =?us-ascii?Q?BRO3DyGg5q9SqUb/BQKL1xhfOAkrTCaB/+e4XrZlVewtmapQmoHzA/xrnGHm?=
 =?us-ascii?Q?igNZUcL1at2SXGE99W5wiTsv+YOg+V6YnfRK2u7NMgcc1+tjR72tnVI1Pdm8?=
 =?us-ascii?Q?0e5TgGDMHy0qmsGpAHaYbpwCC4ii8pYEUg+c/uDf5OFa2++CIlYInfaFFUvj?=
 =?us-ascii?Q?dFyQ/IRy6ewD+E0RiP6JJ8XguETFhCHEflcgUCw0E6RHtOZ+66dkPkP+YXdq?=
 =?us-ascii?Q?5zUIwotBu5VHihruHwqUSCprlUaIYpRxP2szOjS46stkncBk7fst7GJNt68F?=
 =?us-ascii?Q?3eUQ7WOoYTdZtWEIxfNLKLxL2K4a8ONQdPmr7bR+zq1MQgcMUu8Z4AR3gSbK?=
 =?us-ascii?Q?eLroRVgt7bC2I4oiJu7RBvW6Vy5w3tjaCTDQTj+gD3kTYOxCT4eicK181FDK?=
 =?us-ascii?Q?2o88EOEGcQHyQx8xRyiQC+Jbcmxhsl1xpEZkLcI5h7BKDP02GKRBzmDJdWPK?=
 =?us-ascii?Q?KrcaUMpoJjCdToWMoTA3shEGUJRf/MX7rcnyddKHnM0HpRLdeIvPVL19jvvw?=
 =?us-ascii?Q?cz2L9iOBgMof9BaXzxSmi5zvhFo7uQ4gyEMQjFihKWTfqqHoqoEHGW9HXMv3?=
 =?us-ascii?Q?QsXhazNCfcb7KvtbI3fLxT+iKbQV7t9GrH7Hf+OqbuzGtdtgGUt3uS8zvNLK?=
 =?us-ascii?Q?Le55Nb1qKAyHa/o7mlWa0CJ2+yO/kyLdIFzv1thcaAZRKBGcoeiu6eA9+eXQ?=
 =?us-ascii?Q?ZZFZfbAj1HUerTTTWOwjRuWSiIw9dffmEn8NK0Hs1D1oaA1o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8cd7348-0386-4a8d-d79c-08df0ece21df
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:40.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBLlXfim39bbNVgG4zPcAq7jA09jQO22veL0oSmJBqfWLPNVeIvcHEMBlNmEi5o9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

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

