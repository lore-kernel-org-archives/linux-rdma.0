Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023142.outbound.protection.outlook.com [40.93.201.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A99374A06
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 03:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258453; cv=fail; b=dRN30MnOd3sjonAYs2seOCLYxiFx3MRKa3MW+3GDYHMMifZQiM/GxZSlkjCQSYYoLjC44NbmyOwQViht0f/vMri6q1mRg6yyXEa9zFvwhyFDPagdzo6VwzYGLQIBfFv1FX4dCDPCCqakR4VktzjdOjVSaKrNIspcYP4VEmb5OfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258453; c=relaxed/simple;
	bh=fQbVE4YJngnn9pwtTitRq2Lx//x30InTuF92KDDKo7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TkAdllUnI+WFFRvH9iN/OqAxdWhgTo8HpdzastEnVg5zZHpxDFmklnfPbfc2sPsIK5l9MEpwt3jZp8hBra3GiqcsPZXMIvQMqzKbRNVRSKKWOzuicvbus83ybrKUzEkHV1meMhOeCKpEa7/c+ZiTEaXyYopUNXKn/OWNOEgdeYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=vQRn8xLo; arc=fail smtp.client-ip=40.93.201.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="vQRn8xLo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QqWOyeIK6/pPMrEBa0tP6QjlTbYHOfkzivWkFMoPw8U5k1zgfIuAixeZqvjfg4XcFK73+qdnz7UqapsGGuqmq8QLnGsiOPKzNXBgN/dn6Hk31hUUbhhdGENy5R4exoj/q+Fg0KRbUsqw2s5r0BE7v5KK6NbPlmbw4wyBYPY26RJ1rCr4fdNc8lw+5qv9gYFOd+KnYkf+c8Mr0lJ665g4yI1KE+RT386xzITmE7sfQ3PKMTi5oM+iWX7eSQIdaZY5N+hIE1VmYvAlun3fYaKakDRgBvnFyturFFi0fkB4na+tVc9rN51BPrpapJ37eUXXbR1teQbLX7bWWObN6ttTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pqofo4DmSLxw0SABnfMlvJoIDX9xTwm0BggMqpPlbQM=;
 b=svBUYUUTzr+p7ZFVDn6ZNcyocIMM8NeVh2RmdqRhme3rcFo4/OXQzIL85SO7nLE8iWnoMzGmzfV/opghjqpSx7eZ2xAeALpcHNUdrUeLsRivQfCV0V954GjFCk1Cm7EMahJizqgKWxXjT8rNXCtqxxGN0RLIe3XPLjlKCF2+0cg4sB9u2PQ62fTV9d3qx4cXa8+NXpipKGF750iadp7SI7X9tTlu+EMojQ2ZpEzsfzGCLdddrexOFEomXYI1syppN2wPerDcibqhoLIhol6qxSaZ/qccxeBYwIz8jEgvNmT2gb8j0M18vc4PgYBFEZv6qSE5DZI9qsJGkQm57yzlrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pqofo4DmSLxw0SABnfMlvJoIDX9xTwm0BggMqpPlbQM=;
 b=vQRn8xLotkbkj3gzA7ASYHq70vcM+nirEgF4UdjLHazI9y7eM8S9x4aGBQ8Y6iJZTiZOXliWn2+I4ibSIC9RXNAsyFgrY7h1E2WWUUZJxFoifIMuv99wDd9BnKl+WWBxEdIcW15EJisT0OfYdyhZfYXKjGooAHMcS394M5/4hYM+sWB4L6O+Rln/Yc+aXjpVgaXinxQNwhgBkY/QJO0o6w1rdsZ46kSU0Lh9yZ9HKK6yEVd34yVnCllWgewrdIpSGEIIokPN+fg8j45WfAKmlwDg2lLOnK18WNmrpJ1g+1jtUTEa7+4Ruo1acRBAveuEEb2aZN3yCUwTnbBjVelyhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM8PR04MB7992.namprd04.prod.outlook.com (2603:10b6:8:7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 03:20:48 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 03:20:48 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 3/5] RDMA/efa: mark admin CQ consumer state as guarded by the ACQ lock
Date: Thu, 16 Jul 2026 23:16:56 -0400
Message-Id: <20260717031658.477397-4-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: 70dae17b-83c2-4668-c74b-08dee3b26587
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	IFEDFzuq/zYwuiKvOI7wlEuGf0+8GpDjQzJPRP/GUW2GF2cQZb+BXMIMzoDidh8YoL2SXoaL7iWFivjds0FMtzGQPy0l58RROnaBnWYjS+qo3w11M7WgIHcsl5P+Qua8ZkNSJShd4sTU9U6B2vKZDxKPTbcCmNUnxbWwozq46TYEIB/zdq+Qdk5xvkt+wKyTm+NPNv19WxxuZAFw5ibtFsFI9B6hu5ES8dbgPos1wV3BotvNxFKowGSJg+Lzgec1ZPExA0OgB04XCtNRKYpUyoJ1FwBhZ1F8pPBGZAwLTjKHh+fmVlstvSwc1mTEbC9dnTyJrpZqwmigWTxRsB5oHion5WOA0Gr7vvF/RZTE/iTIMWND9IC98hjgvLyQ/8jjnWTIhdy5L8cjqPms6TAX5pdgNE4FkcHFKPCKONaR8FPMwVXxVd4dgT9+XkcY2gQz/ULGyId+HtrbMw54nPGW0Oe18tyh+/INZkgYC7kO/kX+xg/O7ps+QTKCE2113T4REsuO1gilLdJgpK7TuatvbjDwmww2W05aXH3L8i47/LVP2yDSfUXik1lXveeXL6YEvplyxo7mtLZrojOF685xjLvQM+bmRRvVsU3uhMX5RpSID/DuLf8F3QTsDjHKcfWlWGGTDvGOkXmDD99WU9SimDVvrIq7NVgYu5v9moOtXqc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mp+MFQ+LdLjeWYHsCUCqOVySmFMUmHhDgLK8zSO/BR2tq4ydD+tfqMvpNMqZ?=
 =?us-ascii?Q?124S2chBBC7UhxyrQ5b1/0Nz8lcVIBSl77QtnMzr4b+quIrWgSoHgN0SGn5W?=
 =?us-ascii?Q?2Bbb2MYMIeuEcCJduiO0Qw0BAYpqBWk1/FcP9bBFwSuvzB0Fct0yqAabzz4x?=
 =?us-ascii?Q?DPNVndVkimNpPiDboJhOsJKAa26wAp8kcQHIWorHH9Lu/TcLP+QM1gN+t4YO?=
 =?us-ascii?Q?Vzi15ga1eBqN47NZoQT2oRBiNpstx98KvVURWBYl3dg+DLXgNzv6mhx9BZdT?=
 =?us-ascii?Q?PsgV+6FBX1WEwTRNhsTv6c/Qy4ZZCE5tO+G4oYF3RniaaN/PVSHbEV5VhHoU?=
 =?us-ascii?Q?JUjILJHKh2gv8KlhUePn23gHdSkE1F6l+cyGpHgc9eAp/ikM1QJrDyr8YjuA?=
 =?us-ascii?Q?TIeGjIxuxha0C60wpBZnSthUk/+ejuOtDH4LI5k74uYJP9+GrWaChLtxjZSB?=
 =?us-ascii?Q?Lxe1c2Ddgt/OcuYEMlVtehYgwQsjnaO9PWy3KUg0PP0+tQknxAowzZK5O9Wx?=
 =?us-ascii?Q?Wu+LTYy1wbCQrmBl0V0wx50k7RFc1HVRBnL2w5nKzazmzhjGqowvRCvEtqOs?=
 =?us-ascii?Q?0in40Jn9VtvNWnzSHixt7xFVmzpi03csL73qslhKe4Eiw28rhHm8Vokw1z13?=
 =?us-ascii?Q?2TBBSHELEvC/MnxVPR6s7eFOeMgZYrVrwtbEbkpX2tEPbP7KF3sXA0SSfvI7?=
 =?us-ascii?Q?UbRyztCrop1VgBpmjMh//qv1OxkGVpX0k5eJed/uxs7DbXs15I4T/dAO63vp?=
 =?us-ascii?Q?82+8ksI6Yw7rUHUpqOg/0bfgXNqGxTxEsTNQCYSvXozs8GwXIs+OR6eFFzjt?=
 =?us-ascii?Q?zcYySphhu5HcXdXcL6vzWVOPCXbEKM5wnACZ61GVjfjL+Vvev5cBu5/QC63j?=
 =?us-ascii?Q?hMoHUkyrZdfGoj5sgzGK7LyNaaExzfM62VXNrNfS8cRBdeSUO5aW0noR/pCn?=
 =?us-ascii?Q?flW43F5gce+MvzbyV1zvgFda1n+3F+IjZBCC8qpkOzwznoGbkYaA2wru7Dff?=
 =?us-ascii?Q?/mdRy996xPIxSMfGaAwhaiAcX9UZ4DuOgOpxPu7zAyS3l1EZaKDLvqRDxd1K?=
 =?us-ascii?Q?ak2/tPm2fcGBc6GEyCDF2xmw9G4c+b4JJ852v4KwPn1aXWZLLilNnkyQpi76?=
 =?us-ascii?Q?22odCyL37JeZE0JyFagItRzLopp7U8GSRi/D6y+MONVDy+Hhv50NnrtQS681?=
 =?us-ascii?Q?428grzNJpc1EWtGtolXsJvnmTCbcec6V5ZQ6xAs0FxerHzmxVTBo5i5HUjK5?=
 =?us-ascii?Q?F8feaUH1t8zmdiM50fdLhRNszO+0Xi0sPUp7/uSUwkBR4V+kMN42eNRyfvb8?=
 =?us-ascii?Q?OMiVolVUgqmU2wpw30gruUzT6TX7sM8CmnL1A5GOFn3iZ4Ik7fSkn1rxJ2vY?=
 =?us-ascii?Q?WS6yKftYt+6qUPFxjnQHaojHoFxAvpEzAIJIHeD76/jBpdk77mIrZk8uOaPO?=
 =?us-ascii?Q?pEKyBw3Rg9ChaePNimp3gDpVUh+bG0nnAtJiGBMDHvykiysWlfr5My9KWfjd?=
 =?us-ascii?Q?FAqlSOBmGKfWwf3P5Qo4fWT+yo+H+IXD4/zxNnnah/gBLhjd8gtbeTd9Xz2F?=
 =?us-ascii?Q?jv98ycSGNXpWyPMM73WrNlhai6u53sQjvAr92muGMYtDqE5u+k641Om2OBIq?=
 =?us-ascii?Q?y+PljoZW618UPAPTmzbCWQMAfpt6NBq/joHeM8H0qsS7yUNFH6yLlpuiYuUL?=
 =?us-ascii?Q?ex8PSGvvCEjnNkd18PQlKRGpaKDCH0f0wBHfqVCi0kAciLSaskG0spBJlJu9?=
 =?us-ascii?Q?TawRAMf8PG1yf7Ct+rionYuVmQdgCQE=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70dae17b-83c2-4668-c74b-08dee3b26587
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:20:48.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XukiLRjxCyZDt9UVjYuyFAqSb1xc6b3lZpj3/+sMzgyJkw1a78Tc4OnoCNZpukdpf9wJ1w10sMFz7tWCeRdr8VQ9d8eU8KdwaXdF38V9Lko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7992

The admin completion queue consumer counter and phase bit are
accessed with the ACQ lock held. Annotate both fields with
__guarded_by() and annotate the completion handling helpers:

efa_com_handle_admin_completion()
efa_com_handle_single_admin_completion()
efa_com_cqe_checksum_valid()

with __must_hold() for Clang's context analysis.

The initialisation in efa_com_admin_init_cq() runs before the
admin queue is live. No concurrent access is possible. The
ACQ lock is marked guard(spinlock_init) to silence the context
analysis warning.

The prints in efa_com_wait_and_process_admin_cq_interrupts() are
diagnostics on the error path, where a racy read of the
consumer counter is acceptable. Since the lock isn't being taken,
wrap them in context_unsafe().

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 10 +++++++---
 drivers/infiniband/hw/efa/efa_com.h |  4 ++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 4ef5ac363800d..27be07e757e26 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -184,7 +184,7 @@ static int efa_com_admin_init_cq(struct efa_com_dev *edev)
 	if (!cq->entries)
 		return -ENOMEM;
 
-	spin_lock_init(&cq->lock);
+	guard(spinlock_init)(&cq->lock);
 
 	EFA_SET(&crc_min_ver, EFA_REGS_VERSION_MAJOR_VERSION, EFA_CRC_MIN_ADMIN_API_VERSION_MAJOR);
 	EFA_SET(&crc_min_ver, EFA_REGS_VERSION_MINOR_VERSION, EFA_CRC_MIN_ADMIN_API_VERSION_MINOR);
@@ -424,6 +424,7 @@ static int efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 
 static bool efa_com_cqe_checksum_valid(struct efa_com_admin_queue *aq,
 				       struct efa_admin_acq_entry *cqe)
+	__must_hold(&aq->cq.lock)
 {
 	u16 cqe_checksum = cqe->acq_common_descriptor.checksum;
 	u16 calc_checksum;
@@ -444,6 +445,7 @@ static bool efa_com_cqe_checksum_valid(struct efa_com_admin_queue *aq,
 
 static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq,
 						  struct efa_admin_acq_entry *cqe)
+	__must_hold(&aq->cq.lock)
 {
 	struct efa_comp_ctx *comp_ctx;
 	u16 cmd_id;
@@ -473,6 +475,7 @@ static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq
 }
 
 static void efa_com_handle_admin_completion(struct efa_com_admin_queue *aq)
+	__must_hold(&aq->cq.lock)
 {
 	struct efa_admin_acq_entry *cqe;
 	u16 queue_size_mask;
@@ -589,6 +592,7 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 
 		atomic64_inc(&aq->stats.no_completion);
 
+		/* racy reads of the queue counters for diagnostics only */
 		if (comp_ctx->status == EFA_CMD_COMPLETED)
 			ibdev_err_ratelimited(
 				aq->efa_dev,
@@ -596,7 +600,7 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 				efa_com_cmd_str(comp_ctx->cmd_opcode),
 				comp_ctx->cmd_opcode, comp_ctx->status,
 				comp_ctx->cmd_id, aq->sq.pc, aq->sq.cc,
-				aq->cq.cc);
+				context_unsafe(aq->cq.cc));
 		else
 			ibdev_err_ratelimited(
 				aq->efa_dev,
@@ -604,7 +608,7 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 				efa_com_cmd_str(comp_ctx->cmd_opcode),
 				comp_ctx->cmd_opcode, comp_ctx->status,
 				comp_ctx->cmd_id, aq->sq.pc, aq->sq.cc,
-				aq->cq.cc);
+				context_unsafe(aq->cq.cc));
 
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
 		return -ETIME;
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index bf2c0a0f0d9e1..39302559a7a98 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -28,8 +28,8 @@ struct efa_com_admin_cq {
 	spinlock_t lock; /* Protects ACQ */
 	bool validate_checksum;
 
-	u16 cc; /* consumer counter */
-	u8 phase;
+	u16 cc __guarded_by(&lock); /* consumer counter */
+	u8 phase __guarded_by(&lock);
 };
 
 struct efa_com_admin_sq {
-- 
2.39.5

