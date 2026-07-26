Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010049.outbound.protection.outlook.com [52.101.85.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D8237EFF0;
	Sun, 26 Jul 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058243; cv=fail; b=TCipS/pYQdOx53IPK3BH1WXIx+KAnQRGnhqpJYZZzN4uXEzO7M3riOyrnFuziWTGQJ2qy5K8F2pAKud0cv81pnXRKfM4RaQrRJFSeOOaS/uo62UUKVILNCWBJIbuvFkQlSNLKTn8qP/6/0rfmBFn+vsiQmLSU91WGgkMqtWfFp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058243; c=relaxed/simple;
	bh=Kte6mUfHC3O3vKQ3mpZYeClzRvENrv8km+gxH3yHXqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MU0N16BMUkEqt7Gv3upMkFT289FU5ClDLU6+6Vw/7XxrenPYJh+b9VYLbhykVw3u7gTOCsL4WuGKQ5XoOftK8PSFS+3e25x161ZSJ30n9g+cSK6RX4ZpfL6zotZDrm0A2Eji3Ces8At3foWiTxtgRwnkIE1Au+KOtjmuDsgewLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GfAFZtEG; arc=fail smtp.client-ip=52.101.85.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GfAFZtEG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s318FFTSs/eQYoJ0UfRhKLhxxN2SF5xkgGjxspRcuUKRK+E7BvSyn3u0ZvaMzojkyeOio/UmIMsmpkoNk8hU+UeeW3iOa/e+EhMik+IdY7njWcbenGmvHZN8KjhP/5xx31m4pBLYHP0Pi5XoLqETQg+LidWyzNO0V+xphdZ764AiGRXfTy5YdjqE39OV+SG+m9vigJ4SvktNBO2AeRLk+StLsImnKlzXi3txbZFfuEblsiiKjNBW6kxQ2L8zKMwg5JfwLCuYnv2P2zK91GIVezyMecCNnuEZMfAQdfCdMjh2S/qTrU4v169z12nSQoBvWpwrQDu4I6NtgxljKPZkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVbPUiV5FFDyJSUENpEIQOUVInleWdoYDoRycV/2nzM=;
 b=fhrf7bnxtNapm6WNDqLKx7MXBrGEL7Ak7g4wZJzHXrq4RfkOlC+iErrDMoyXPQHwGG1s560b/NWuI0ueJPK0MqSo7ApKAZ8nTmHGSjQmVtTWmr3zxLaCRQPSC+2/ivl6WShn47V4fPcl9dX/qDR5R1xWbptM/3ZwYjDkz+UOh2wwd4AdI92ANiwAlDThmZj6i4ijBl2ovwnGNOeDD/SVauTdrWyI7gpM+KQrFnWfIq+J1z2mlYT+O9J9MPLoBXqIoysGxBWL+aCd7J5MTNsSVRjZK5+OchjV28scrP0/s1Jft0i/d0Ce7xEAljNqYVpdpJt4W5B68DzbPkIywOjb/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVbPUiV5FFDyJSUENpEIQOUVInleWdoYDoRycV/2nzM=;
 b=GfAFZtEGibaLQYjMu2/Y/jhGRikPaWjtR9QJf0SZtafj05P9VBVnlvvK4JcDcDwZW60EP7AwjaqWIfU78TNmA7K9t0Gvxl1soPXVmxKQTrcu+fITL1RycGJ1tumLlK8hSJEd8mYcqH8NnFvy26Epc4Y9Simot65km1nZly75/HBiblYVvzbEgAJ1gBvjYEpsJgrw48B8921OR62ERCgkytY6fQeFyiPnotFUPz99OkSv7UaeHhufxcbuwoN3gceTQ4pg3XxzR7dEnZXg+TeNRACiPiOzvU5k+28N3Izj7am/ereqNZBnch2uH9OG1w3KJPPmeGTci8PCUrldI0MsNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:39 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:39 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 06/15] net/mlx5: Add IFC bits for new ordering caps
Date: Sun, 26 Jul 2026 12:29:20 +0300
Message-ID: <20260726092943.2880176-7-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 238ae485-4511-487c-4a6e-08deeaf88e14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	cg+sgZY5uEhyB9+H9Ix2z4YcIObKZ9gIOysRJzmKoqpzJaulxxCSRIEiNfI03dkkdHVHMbOiPpEhqCV2w63h9Mc0U9I9TTlb3bV90UxGH2t/SB6YPFWhGFQ4zLgiSlmfpbtRLD859We7ra7th8m/txfPbpBK8zApkWi25lRCTY9PVegcDrrBDrQfTSRXA9msGqydHjLspO8vgToDVwgGAWcT860JiqLf0W2xNQ61DKTUSQAjUDE375KQelZ/dOwHvqQV2WAi7LxIpfUuyw+cfp/GL91Rf2g1wSQ1PT5pA34xMGUdpEM6IVDGDJ12CpB4BbBNIcpTGGeyJ/uHjzNwxrjjh+kOzD/KROwu5qyMVQeD77D3s1sztW4rIg8vzsKeUTB47lEJwHCyA3suSdFlg4c2zZ6unfesFLD9Eo3gKBYJTY0AGQsfX9m2xjvPib4mio6PbJCRWa5Wu6DNHe72NQ+UXT3+Eb/Gs18ir/p1BxwWK7RClsUiDHFsR7B5NTzdYPIHcK921i7xLW4INaFC5oimLwal1qBcB6L2SgoquLOlNdy98uevLyhH51/lltRAUS1sHkYEXO6XI4KPF1O/5dsDPGwgOpqjVR7bfmKUtVfnIwSIgPukWPt6fEjJpZzAPzxOJMX7/6nxMSgGZcAGsB0sJ6haaoT2cJnesCB2KJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jrsxBS3CCf+iA5FhaugHybn0rAIZ1QS1ixoZ9MVoCflGamfzNWrf4iBZGPF7?=
 =?us-ascii?Q?MF+kcbYzyiSnIqinj40ZfsIMrXCKdcsF9rzQoTsfHbyzy7La3g9kYgnQUFip?=
 =?us-ascii?Q?OWc7zvaqwIdL6jQWauYRRJmwuelYDcY0HuVrq80nIUVTw8P8/7aqr8WZEDAK?=
 =?us-ascii?Q?dXqzr5thR3XZkiguTCJj8DZidoodys9jTdcYqPoH42wb2weVW7ocKrWIxFTU?=
 =?us-ascii?Q?oJZAmPaKYqMnVdJudtJa10D+4B4Az7wTLfJOChTaF/UI9IO2NtS+gqqEslQJ?=
 =?us-ascii?Q?gawV8wC56bkLpcTXXHo6qKD1+nBuPlDIZUX9ihE+tHYVUQp9uY63Q7Ur7Bkm?=
 =?us-ascii?Q?TbUDZ9hONOSmdwoo3dBTCtrd5oR4l5LwtS+mdw9fV/bdSYIs2JFIdaD1RUwJ?=
 =?us-ascii?Q?o1cfDJwDfaC1QV3Ved01ZT0ruPUwGcOJ96tQWxRNPUpceWfOF5VohzsVuFbu?=
 =?us-ascii?Q?TaddDDAIx9+uIxsk/etnBbsn8SuFlEMlII9J8W32bm62+L6ulqz0vcvxICYQ?=
 =?us-ascii?Q?BuEKM8jdpeSw5uIzcDsr5dU4q25clolmFRc6EJDrdRAQnkKOUZfE6pesiuw0?=
 =?us-ascii?Q?YsyqoNYYtSBrEN/LeAv3Vi79mSm5GxuDn7ZhO5w9ptuYLi4bn0PlZkvx4SP8?=
 =?us-ascii?Q?86j8CCR73zJPiB47C5tTfWAlBFx+bHabVshFpEYegrVQDQsW6M3tOaKwrzvd?=
 =?us-ascii?Q?JcLYYHSiOzEGD+tgKxN3wMOypnuqB2b+nJSD1/O+/5aRGqwgKj1aeZqXbOhY?=
 =?us-ascii?Q?fS5dt6mf/XBbc2VrUgMsBgdWKjxlDrd45XXPQQ+dwgist7dVBmu9NR0DYuxS?=
 =?us-ascii?Q?eDktnJfc3wlKIZiOtQd59mLD5NOUlDoTZnIOVLoyGIvFxORl0vxMHc7DEav6?=
 =?us-ascii?Q?slyiJc36JEaG54U4+Q6TPy6rSxG/J5YVx4DVMClue/aS7jAneIxsol+fjwNj?=
 =?us-ascii?Q?1J407DKyCBnWwti4Zx4RHqwGKroe89YVyu1B2jshkx0XEe0uUO1Qi30a8sML?=
 =?us-ascii?Q?zsY7imPudfpbj1g1eooqpmb1oijyCiGfZGTIcbF+rODs5OgTnZJZUC+Nzj0U?=
 =?us-ascii?Q?jXHT2/5J+UEQs3QXI+2v4WQsG23zaoihMHmxkSzhHwycNplXvzDECtMD2ZI2?=
 =?us-ascii?Q?6JvoNP93ZPDxQJgy+n613dStHnrcl/8+fgu9t4cStS7K7Zf/spYXKqlymd1C?=
 =?us-ascii?Q?STHnLPVKIhG4yCSoH6prtvqP/8mzdOOicqZRuiw4G/mofrQDLwZijBprksu9?=
 =?us-ascii?Q?XwcIBc2szJrioh96fglPQVS22idoXQxNc+jhv9w78Jn0rCGYLZdm/Tw7/ILD?=
 =?us-ascii?Q?6I2qsNe1ru56IbQQ6ho+rsyY+JUWzpf3AfbDs1gNEcw2yBKoXY/lsRW1WhEo?=
 =?us-ascii?Q?ooqieQpA0jbEncw7EA3ngdWxrLCXVTnQ3gNZnGHS+Qu++Wg/7QAk5+VpVAWa?=
 =?us-ascii?Q?4Ne/viICP3haWFBrun4jng5ll5YhWku4/VNhMuZax+9ckS6fcs4JQ/ecvRau?=
 =?us-ascii?Q?vTvy63qI6p2BVe/oyOqSUXd1hQE8lHTVQSLGphlTDnmQsElQV4S95ytxYorX?=
 =?us-ascii?Q?s9GN+f8zHuPnQHpXtK1clcBphYzAJcglN2lsGefVdPbui0+y5iJEprcvb5xa?=
 =?us-ascii?Q?Lvr5nxpSWEqRIrGlve6BCOW1PHc6NmQDM7jEUkmR56s5/n4s567j6ZKk11jh?=
 =?us-ascii?Q?nuD16Rxh/qcUgHohfzt0h6xHMEoKB7Tkm1l4/j647Nu9CYmuPAnydpaCqfRL?=
 =?us-ascii?Q?D3XxrWx6Bg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238ae485-4511-487c-4a6e-08deeaf88e14
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:39.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xADyowm4/U2mPnbb0EMQE8TGkjPAzQTajoUBxc6bPVS23b6DsZtkUgI3uPyXLlSOTSp8P+pcEdFD1zrkuXnarw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Add new HCA capability bits:
- mkc_order_read_after_write
- mkc_order_write_after_write_ro_only

Add new mkey context field:
- order_read_after_write (2-bit)

These fields enable a new level of memory access order relaxation,
allowing read-after-write reordering and allow to expose an indication
that devices don't support strict ordering of memory access.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0593913fd25f..160dbbc5d338 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2003,7 +2003,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         roce_rw_supported[0x1];
 	u8         log_max_current_uc_list_wr_supported[0x1];
 	u8         log_max_stride_sz_rq[0x5];
-	u8         reserved_at_3a8[0x3];
+	u8         mkc_order_read_after_write[0x1];
+	u8         mkc_order_write_after_write_ro_only[0x1];
+	u8         reserved_at_3aa[0x1];
 	u8         log_min_stride_sz_rq[0x5];
 	u8         reserved_at_3b0[0x3];
 	u8         log_max_stride_sz_sq[0x5];
@@ -4518,6 +4520,10 @@ enum {
 	MLX5_MKC_PCIE_TPH_NO_STEERING_TAG_INDEX = 0,
 };
 
+enum {
+	MLX5_MKC_ORDER_READ_AFTER_WRITE_RO = 1,
+};
+
 struct mlx5_ifc_mkc_bits {
 	u8         reserved_at_0[0x1];
 	u8         free[0x1];
@@ -4565,7 +4571,9 @@ struct mlx5_ifc_mkc_bits {
 
 	u8         translations_octword_size[0x20];
 
-	u8         reserved_at_1c0[0x19];
+	u8         reserved_at_1c0[0x16];
+	u8         order_read_after_write[0x2];
+	u8         reserved_at_1d8[0x1];
 	u8         pci_relaxed_ordered_read[0x1];
 	u8         log_page_size[0x6];
 
-- 
2.52.0

