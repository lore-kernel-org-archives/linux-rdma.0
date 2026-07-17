Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023142.outbound.protection.outlook.com [40.93.201.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FAF375ADF
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 03:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258455; cv=fail; b=BABasf+7TSF56Jt8tOeJ5zTcrAgWlop4KeK1wLKP+lEGQE6mXA5AnV8kAsZwpIwUvEFQVJCnxM4AcyqNfa4c9z5rJjXU++7RYBfurTRT9WAU0mF8mDUjh6OGe7wqgu9iqqfxkRdTap21HCWkOe2aW+xMmYjxGIq9DULdhg/S9Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258455; c=relaxed/simple;
	bh=gM4GFnN0zxqskIxT+Zr5PAkzPVXsapvzzafGUTylzfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pxfUOs2LqkTYOBD20vJIIG0N6zj2XZrjtpzj3NUNirpFYQ5K2jmqQiML/fTJpvUDFGxgPPRkKey1AFZE21QrSo6AuW6L0ZrlHNeYb0y0bWDrhtVjOM4Hyk91eIcLeUG77Vda/nuFbFxLawX58uz17LWqB/ctFHxuuI9coD4XL8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=bSfHPAg1; arc=fail smtp.client-ip=40.93.201.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="bSfHPAg1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNa3BHv9SIIPpgPRDr/dswEUhLJr37tbK502PTuxN3LPwUDVEepTIFV0NQ1NTTQsTeR80952SsscRKmoh069i6+DwFJObJ2Lz6WorDGz/3SfIRcco7qr4T3eOQn69ccb0MzKKtjTHQc6dthd/ZkMthSYKuSfQFvgf8q0KcuAtc0y9L+Ip0PD9vzxanC99vvuKEzsL/DS1Y/hwa8QqdnaTPPusywFrXFIoLQ748OHaI9midQtCaPc5xPpNlR2MURnSm7QGR2cwVEv9ur11EnOBUDMbUGcDbiPnf8F2DAkL/GzcaYGT40RgWb3JLmgmlyu/l0A6UwhmfovQNgVVls6HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkzZCpLTNo65HJ+7r9P0jKYo3oice17P/sIaG9glwm0=;
 b=WFCuUMLPi/tpGORwbNR+pXH64XcFKMNcbSpGMc0YFXNNf2OMovjhOQTwMvxv4FIDeBLTG5SSDV9DLd139CUKjyG/sYcId/KW2RBNoBNLgNKKb9DxSkR1e1k1K9Lv3eU0KHRfk1UwScXNVbYkl1ezynXuiPrbCb2m8uQG2aPV1u10Iaswp7WWlZeFsFkcRZAdN2uY/3aay8FiNzZE3CBghILaI6PuB5c8JJNZm6QxXBa8lqn2qQEHsXQUUlnHKAF0JHX7BYg8AQf0BxgWN7ty4iQHmH2IykbfdmMOHFDqZfxrXHMMw89wBd2T93NnTUJaybV4ixXjV5cj6SSXZVjEmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkzZCpLTNo65HJ+7r9P0jKYo3oice17P/sIaG9glwm0=;
 b=bSfHPAg14VNILWwyrDcFlvbwrcZxpm/ELpL0k7cTrBNUF9XhAcYAvV5W+ZVvyv+4VZRbYIfYDaDb8Rz25I7pVrRxmWOO2UiKh5SCx/lDM3K4D+NFl5+8B7MsIhhwWjXiuCZxCkhC8dY+tcxzqnnTKQlpPSw4Pk3VXoIR5Pp0Dw+xfRyyYSiYD9AAzhu6HgCg0/Gz2E3HHX/hvHGeVhhwRMUsJ+8ckYEkeYKFSNuDz+AYRTfqGBobm5YCez+UF87LpSkcsSILqgEOkh36EoYteAijboRC66+Rqtbmi2Xpn7pEmGUNrqqk8ivEKBJElYn/ilWL+JB/nVqr07Z3X95bdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM8PR04MB7992.namprd04.prod.outlook.com (2603:10b6:8:7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 03:20:49 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 03:20:49 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 4/5] RDMA/efa: mark admin SQ producer state as guarded by the ASQ lock
Date: Thu, 16 Jul 2026 23:16:57 -0400
Message-Id: <20260717031658.477397-5-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260717031658.477397-1-timday@thelustrecollective.com>
References: <20260717031658.477397-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|DM8PR04MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ea21b8-da5b-40e3-51cd-08dee3b26627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	RAh9xo9LeOiThEk/n452OqJ9Dz8GAwlWA67xTqpwxuAfF8ZovgAlIhjFPzVGUW63a1bi5iErkM4JnBzljDoVzXWczg0WeeR1I/WFrslFxsEH/gOaiT/MiFcdLi/SRo8ePd2cDRZDuohmc8BXUR2UUFKFsioAC20cFrn/6PSelugE4BxVsSXW0sxbDfldCmYqwCbBY53cZ6YkOWniDV3Rz/f3szcXvN6Np8ZHRmF3XeqIVn6wqMv/HwChvc099qa05MJFjxiB07w2iEiEbzO+DyfXfHEdvH08qphfTm+ilPYPV1LOjqQXugsGphSBARAQXK1K4mX3/Z/JBMOluQxrUzEGz35xiZ132ZGFoJeYl7dxkCgFTMA8OTusCcD4yAYJhaYnBW5N2jTBhSQZ5tKWj0Sr/C1EaDKUd2mP9S5a8pbE9GW/chkCv70p6/slVm/oDaLyLmnFSXimn/Gy8hY8A3tA7FI0p68M6F3gMyTyTySj8vmjscoysVmqkn0kI7fiLEXxa8TWAkNa/ywgXsIDrZtgTS8y2CAOYQgH/QExGW8fL44QUcQr8X+tbHQvvEHzugYZXoVilBzEqDEsEyZ+IVY3V5PqjtC2pxLUakbJmVo/KG4B90qBox0+87vjtAMKATbpHqls9t5VsWWgnCnYW7e7M65Q+V+VNGYO1fgVfso=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?avBxpIKQRhkzpTSb0PI8TooyGsicCqireSrULZ4Axr5KI/0W5RIkAbqsTWeM?=
 =?us-ascii?Q?4TYdi89vlmAiFxWuOjSMY+B+MJE2leoYAcU/2s7aj46hPCU2QtiECqWbjV0j?=
 =?us-ascii?Q?tDHvL1kd/Cdv4MbbmY0ioKCgMS/VKzwrHCo3jKBGidaDxWZHutrvFoo3lG/R?=
 =?us-ascii?Q?X0NupwAXW0FTctBzefq3/D94oOlZwTtDtxyT0LiObx1btvDVNKhI9qDNmqiN?=
 =?us-ascii?Q?4qrugCuYIgPTo36hJlEwEMrLB02un09vuKfTJoxJ3gE7snEFs8KkA/r4jIlf?=
 =?us-ascii?Q?064SUhMGki7kgKIAdV0MvjX8z4XFKMKzUtNQvQ5SfW1XZzhnY01S2dyRJwtP?=
 =?us-ascii?Q?plGa9Ami4x5d2SCSYE0uni31pr+zfSnt4/6CjHwOWraUfEQU8cQDeNMvsWoy?=
 =?us-ascii?Q?2WFN7xvVE8T3a+04jpdwpl9zWidp2aPb/yA4jhp1MmQkl1g3aIIECmNaUDdR?=
 =?us-ascii?Q?wRS/N0lVXu0JK0ozsdIso0GkkeEFahCunVPKNM/7utJTwt+qlTYjBDXSZ0m0?=
 =?us-ascii?Q?okdYfLVMYvrmCZ01yuC5imdJFoAD5l998nn7Jr7HZRD1vr4AOcpYNtOZm++l?=
 =?us-ascii?Q?TBzLVGyNWItybPmRse72XlEUjHG3A0kaQSY+HcaSzbIwT4plRP3fPVDeJPSa?=
 =?us-ascii?Q?pXs2AojlvgyvHX7Rh32dvsq1d1DY7FAd6YhjPo7QgP/LofzvkiuM2JoPB4Po?=
 =?us-ascii?Q?NWmbRIIMf31zJc6AdDVPqvB4/AsKB8jBch/tJDDjKBnWdtxgEBy6wFEmQBUI?=
 =?us-ascii?Q?WA8KzoNoUS3rzWPg+Tnec0b/ey1L8DAluYXNJYjx1zLKe/s6ypLM37qkAuXU?=
 =?us-ascii?Q?bES7pzBTp98808ZJIJ2jCj3FdPNtQKptCV9sYZxa9wdL4ziLMS1BlW7ot0Kg?=
 =?us-ascii?Q?0wnDjIUKT3u2pA1NMl/yzubiRhdaGNNpFJGGHH1/jCQPkMeY8OzaXktLzqV0?=
 =?us-ascii?Q?gjWoEvKBmr7+aKYBvRxvtAvwb88DJFlFo7pXgiPUpdU+ldL2ZTo6YEqJiCwk?=
 =?us-ascii?Q?O3nRUvYketYd35h/iJ7Ra/qzxjSHaNiQHMgYp+5Cv904McUYm/cG/P/8E/NF?=
 =?us-ascii?Q?h2WYBbEm+YCNwEz1zBPZJ9JA8sYD1hcBGcA1SY4JZ8HhzmIfITRUkoEQ7CUg?=
 =?us-ascii?Q?ELsXG1U2inOuKp1vu1pe8ME/6YRu+tIKLmL8iQuq+t7ON/lhOO1rYHjJ1poh?=
 =?us-ascii?Q?4W72Yt13gjyJJq+cpy5Bhf4Ls2dUPxoQLgHTnAvhSJqAqKl/4SJhCKZO74sO?=
 =?us-ascii?Q?+i6qw3w+0xxCWwB4icn9uEkYjJLsdZ563U/Q9sV+IdF5dyWZ1XpZRj0tKrVD?=
 =?us-ascii?Q?w2o9orSmlw/wtZfrfhf5njzcRpnTgwr73U/r5U/ufv0oz4kicdYH87kSCv6N?=
 =?us-ascii?Q?QvP9oC04VWBpy6u4u6lA6yyHKPC/9vGbjlJOjMaSQqn2HRR8WTbdaZE2UfmL?=
 =?us-ascii?Q?r8NrwNQz1TdjRv3X6m1Kkw6D/w+J7CSdnY8L4epL4yNhkoC1MafQfssFv7y2?=
 =?us-ascii?Q?3IOHEXtXV8AwyrdwjobOmb/KumXbiXsXD/QtFgZwAzrvZNRlfln7bILuwWU3?=
 =?us-ascii?Q?DtNt3EmdMxw765TdXUK6Mhmp9JbFZ5sS4xcZlKYi93FZ5gjZof1KCKwM3+Oo?=
 =?us-ascii?Q?RSrBqYITP/OPcfk30JlspK7pY0AT/2ln1vM7Vrk31O1IXfu7qUWGErvCAde1?=
 =?us-ascii?Q?83gWnyYJzMxnawHhnEx/nFiFObxmBdax0qWgBRmmO7s9kidz6I+OboTtgxJa?=
 =?us-ascii?Q?HfPOkZl8mAkULbUMlzAcN/I9RxUUch8=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ea21b8-da5b-40e3-51cd-08dee3b26627
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:20:49.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APe6W06OUQD31pMiLn33+Ce3BVq+429YvO5OBllIz5Ytul1u1hAGU2okhEd/cEQ+0bsCDVOZswRtQMxWoutk04vf5yutuWjJsotCY33Boow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7992

The admin submission queue producer counter and phase bit are
accessed with the ASQ lock held. Annotate both fields with
__guarded_by() and __efa_com_submit_admin_cmd() with __must_hold()
for Clang's context analysis.

The initialisation in efa_com_admin_init_sq() runs before the
admin queue is live. No concurrent access is possible. The
ASQ lock is marked guard(spinlock_init) to silence the context
analysis warning.

The prints in efa_com_cqe_checksum_valid(),
efa_com_handle_single_admin_completion() and
efa_com_wait_and_process_admin_cq_interrupts() are diagnostics on
the error path, where a racy read of the producer counter is
acceptable. Since the lock isn't being taken, wrap them in
context_unsafe().

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 21 ++++++++++++---------
 drivers/infiniband/hw/efa/efa_com.h |  4 ++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 27be07e757e26..047b378f88045 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -148,7 +148,7 @@ static int efa_com_admin_init_sq(struct efa_com_dev *edev)
 	if (!sq->entries)
 		return -ENOMEM;
 
-	spin_lock_init(&sq->lock);
+	guard(spinlock_init)(&sq->lock);
 
 	sq->cc = 0;
 	sq->pc = 0;
@@ -329,6 +329,7 @@ static void __efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 				       size_t cmd_size_in_bytes,
 				       struct efa_admin_acq_entry *comp,
 				       size_t comp_size_in_bytes)
+	__must_hold(&aq->sq.lock)
 {
 	struct efa_admin_aq_entry *aqe;
 	u16 queue_size_mask;
@@ -433,10 +434,11 @@ static bool efa_com_cqe_checksum_valid(struct efa_com_admin_queue *aq,
 
 	calc_checksum = crc16(EFA_CRC16_INIT_VAL, (u8 *)cqe, sizeof(*cqe)) ^ EFA_CRC16_INIT_VAL;
 	if (calc_checksum != cqe_checksum) {
+		/* racy read of the SQ producer counter for diagnostics only */
 		ibdev_err(aq->efa_dev,
 			  "Received completion with invalid checksum, cqe[%u], calc[%u], sq producer[%d], sq consumer[%d], cq consumer[%d]\n",
-			  cqe_checksum, calc_checksum, aq->sq.pc, aq->sq.cc,
-			  aq->cq.cc);
+			  cqe_checksum, calc_checksum,
+			  context_unsafe(aq->sq.pc), aq->sq.cc, aq->cq.cc);
 		return false;
 	}
 
@@ -458,10 +460,11 @@ static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq
 
 	comp_ctx = efa_com_get_comp_ctx_by_cmd_id(aq, cmd_id);
 	if (comp_ctx->status != EFA_CMD_SUBMITTED || comp_ctx->cmd_id != cmd_id) {
+		/* racy read of the SQ producer counter for diagnostics only */
 		ibdev_err(aq->efa_dev,
 			  "Received completion with unexpected command id[%x], status[%d] sq producer[%d], sq consumer[%d], cq consumer[%d]\n",
-			  cmd_id, comp_ctx->status, aq->sq.pc, aq->sq.cc,
-			  aq->cq.cc);
+			  cmd_id, comp_ctx->status,
+			  context_unsafe(aq->sq.pc), aq->sq.cc, aq->cq.cc);
 		return -EINVAL;
 	}
 
@@ -599,16 +602,16 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 				"The device sent a completion but the driver didn't receive any MSI-X interrupt for admin cmd %s(%d) status %d (id: %d, sq producer: %d, sq consumer: %d, cq consumer: %d)\n",
 				efa_com_cmd_str(comp_ctx->cmd_opcode),
 				comp_ctx->cmd_opcode, comp_ctx->status,
-				comp_ctx->cmd_id, aq->sq.pc, aq->sq.cc,
-				context_unsafe(aq->cq.cc));
+				comp_ctx->cmd_id, context_unsafe(aq->sq.pc),
+				aq->sq.cc, context_unsafe(aq->cq.cc));
 		else
 			ibdev_err_ratelimited(
 				aq->efa_dev,
 				"The device didn't send any completion for admin cmd %s(%d) status %d (id: %d, sq producer: %d, sq consumer: %d, cq consumer: %d)\n",
 				efa_com_cmd_str(comp_ctx->cmd_opcode),
 				comp_ctx->cmd_opcode, comp_ctx->status,
-				comp_ctx->cmd_id, aq->sq.pc, aq->sq.cc,
-				context_unsafe(aq->cq.cc));
+				comp_ctx->cmd_id, context_unsafe(aq->sq.pc),
+				aq->sq.cc, context_unsafe(aq->cq.cc));
 
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
 		return -ETIME;
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 39302559a7a98..2306666c86c80 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -40,8 +40,8 @@ struct efa_com_admin_sq {
 	u32 __iomem *db_addr;
 
 	u16 cc; /* consumer counter */
-	u16 pc; /* producer counter */
-	u8 phase;
+	u16 pc __guarded_by(&lock); /* producer counter */
+	u8 phase __guarded_by(&lock);
 
 };
 
-- 
2.39.5

