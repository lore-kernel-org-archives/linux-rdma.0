Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023088.outbound.protection.outlook.com [40.93.201.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5009375F6C
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786125470; cv=fail; b=JUO7i7RNQ8A5eVthOvV1Nlu2SSNngXI2yK3mzFREiHEG3YCiUX5etS9wrhk5PtD4Ami8zexMdByTdhgltM61IpNwYCtSInAhMsnljoIGhob0vsIFkqtZLJDgTFpgP3xIQit8VCYqiK9AUnW3sc6n3KqpAXd8F79a+mwzGfEUXEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786125470; c=relaxed/simple;
	bh=1vmmw8VQzkjNZIHoWx4RQ4iH/ZND9WfhaswSEplrQLA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YgyBmJUqGyQ21f/7u6ILHAEK2Oruitl6vH6an5hO5TowbyQcsFvrL+B8FDUaTT70mWyLrc2c7sQ5KSLz2Al8jCYAqJ2QTaYkntLx8ng4rdWWwKo7nVAMabYwbckZfuyHUuTXH4yGdfgIGAvPNDWCOUyz4oxovSTqWyb6WpAEyLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=YvRrrdou; arc=fail smtp.client-ip=40.93.201.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="YvRrrdou"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dx7gUDQgci59kOxZu4MHq7elHeHoEwdn5ch8TYYf0MEEhixPL9QjO5aySxwccBvlt+q1NjHkX4q4qrF8vgrMTT52+vMhcSvTmvi1UQIY3mRwnNbRJEpk4Akzut4OOD6Trc0OeodsD4SB4UWBkZFFWbWFt6PxRD0FjwmFefnI2pVOYEpG/n7n0FXILsvJUTvhUOlYxivMPHTjrYu8USThP5id5DrcKjQAxduq7lKkHBdrAlTuPIT2Ijhh5vs04uWSi2b246MugunAOdJyA/5d5CrtD4e9DRp7NqDSaquey9x+8wm2JASavvWHVedwgVJUy3zC3jHTlDkMrUEWmRTLbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iWZN/V5saAG/1bSWptJmLy2LbmJ1ulvC2mItZrGNJA=;
 b=ggrRv/ycYumEcAZetc5fGZyTGnokbcaf7OZTgA6lQJ2L6Brxsz5fDhDp7+r0ZUCmfKUEAWJbm+3vm5/C4p3pxpMlxjM/N8yLUk33xMMPq02k+l41kAwL7PMXoVujNCTUpjPSrmWFoFO8Ch3MmdkXVfVwxw8hlCWKQen/8j9JCRjgmQ2ntc7nqTGe8UDga258jB/RdwbI24hW34rx8LwoTnBAufGIRMMUq7SCeSuCpGf9BQK9hJKNt44K5NAOmmvhGolUwLGKtyH3JtUHJRK48Xk6UpEmIEtOeIdEK8oycLAa4XOZxKD8GxiPI+jzD+ac7Dv2k0oarHGxbcnSCo67vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iWZN/V5saAG/1bSWptJmLy2LbmJ1ulvC2mItZrGNJA=;
 b=YvRrrdouz3nbIoMnUMa2EmuDf/24T5JE36C8I4ILCKSbA8kKFowmwX/NkIl0tubjfU5ZUcRPDs5E51qI19M4Iv/7Bke3dQsiA3/MGvSxn/CFgec0Sk2CiPhl7WMbo3/8NZkiW0jFxUBF0jLtPONZ4W8kjLBg859y2yAqzedDQ09Aqy7t/eejbAth1TO4TckWm22mToRy4JfpmMErYfwvSXoVeItoqCjRvVSEOXdq+fBV+PY6yZySEj1pQYdR18g40IQ9VmPbikaQ2qk24C8f+rqwiPzOrrNI7nZHWivW2oz8K/nE2I2aO8xzA20z2eZQ4f1IQgLTSi0HMTj3jgzF6A==
Received: from BY3PR10CA0029.namprd10.prod.outlook.com (2603:10b6:a03:255::34)
 by SN4PR01MB7470.prod.exchangelabs.com (2603:10b6:806:201::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.19; Fri, 7 Aug 2026 17:57:44 +0000
Received: from CO1PEPF000075F3.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::ae) by BY3PR10CA0029.outlook.office365.com
 (2603:10b6:a03:255::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.24 via Frontend Transport; Fri, 7
 Aug 2026 17:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 CO1PEPF000075F3.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 17:57:43 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 9528B1DAF29;
	Fri,  7 Aug 2026 13:57:42 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 90755186A3082;
	Fri,  7 Aug 2026 13:57:42 -0400 (EDT)
Subject: [PATCH v4 for-next 23/24] RDMA/hfi2: Modernize mmap to use
 rdma_user_mmap_entry infrastructure
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Fri, 07 Aug 2026 13:57:42 -0400
Message-ID: <178612546254.3164235.7417168153149332304.stgit@awdrv-04>
In-Reply-To: <178612534584.3164235.5428549372904350681.stgit@awdrv-04>
References: <178612534584.3164235.5428549372904350681.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F3:EE_|SN4PR01MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 35dbb5ef-88c0-4b3b-9d9d-08def4ad617c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|56012099006|10067099003|3023799007|18002099003|55112099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QGed+mIyhBp/CAPWBgs+5peLRVeZ4RQ/rpZOh/vmWfRFsweSuOIOuJGPT0iP0obftSW9NDZBRCGT6JubpBAh8HZ2HgoWPZ9SsJtsWD5HwKxSls2+ggL6EiGIfrdM+rUZ1ARV9Px3mTlDYmPF7uFq5KYKxUCYDTRBAeUW8PMVNP9cVxnEBZoYxmT+Kmer7uCJpmArtbdCdMX1G//4m7+c4NT72rs5YGqIPT2pItfP1Z1TDx6ZOzazb/LyTRF7pRBZVNBEhydZ/cR17xh5u8/laiQT8LevshcfmZRYE/1T582uPV2rBW0MlE01UukSRdQ8u70B+5RShYrNt/Xm0L3J6aE4REkNKbFYaIXbRTCkO9MriJZe87Un7ITDIIRxmVv3DXhbEBcFC3+xkZ/b/n8dHXYGB7pnmyfS6e936jC/VJ5OEfhniNQgxHztHmS5+V/VMG4YG9RYAz49OvZU3H0NZmpYygUFvr8H+sYZeLwyVb5nNlapcAmnDGZ42qBpOEErIPdySD4nuZ9P5LO+8YKJEJZpxG/NNGdJEh35ZyTr98DAUZX6c6nPJ4EJTNpNRm+qbd3a92mi/U9k/aqADFrlcY9sgvhW8Rjpzz/Ix1D1g7e1J67D0wPSlD5cUBX06tAP9SEa1zMXY2L80TgM4bbkJrF+kW7GfFVdX2umtO2T/oXJ9wR2fzZcoaXt6T24GQDf8ftYkzmfrStCHBNzCvDpaA==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(56012099006)(10067099003)(3023799007)(18002099003)(55112099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+ucj9MYaPtsTSb7ruKIqKZrrKmqYwiMAYIdgQBIJEj8HcQCDDb1AI/VmqstCIO0Yv7E9InN2l/QR+jitC1T/rjbaalVHt+70r62Q1Vlxl/ioGQnsxQ3T6S+KIA0W7cWlFR7eB6JRfYCoRGEzh4P3KEkKLzUbh7kGW8P1Rx8Dd+Ej50DFTNSd9ROzVNUaklY1aGzcyvwMKlN/PcJMX80B21tjCQ6WjvBFgL1JKoX4ALVefFiM7N8XE98/3q4uwdEqIumKDLVcflomC0pJbEZ+nZv2CYQoCCLVCY2N/OM01kWLsQyjhlpR6HIrxecuQDkC7P9BeVa6StSDlJMG4AxQJOE2glqWhZXm18LdeNxB2afPMbKqcPBXc3ATeL5YA3gQ3mwwedxrmA0US7sksgnHypQrAFBQqZVNXP1Pb7MmHv6eFvXRvUAyUhYS1eE2FLjx
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 17:57:43.2756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35dbb5ef-88c0-4b3b-9d9d-08def4ad617c
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7470

New RDMA drivers are required to use the rdma_user_mmap_entry API
instead of encoding buffer types directly into vm_pgoff tokens. Add
the mmap_entries array to hfi2_filedata to track per-context mmap
entry pointers for cleanup on context teardown. Export rvt_mmap()
from rdmavt so hfi2 can call it as a fallback for CQ/QP/SRQ mmaps
managed by rdmavt's pending_mmaps list. Also remove the dead
hfi1_tid_info struct from the hfi2 ABI header.

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
  Changes since v2:
  - rdmavt/cq.c: add synchronize_rcu() before vfree(old_u_wc) and
    vfree(old_k_wc) in rvt_resize_cq() to close free-while-mapped race.
  - rdmavt/srq.c: add synchronize_rcu() before vfree(owq) and
    kvfree(okwq) in rvt_modify_srq() to close free-while-mapped race.
---
 drivers/infiniband/hw/hfi2/hfi2.h   |    6 ++++++
 drivers/infiniband/sw/rdmavt/cq.c   |    9 +++++----
 drivers/infiniband/sw/rdmavt/mmap.c |    7 +++----
 drivers/infiniband/sw/rdmavt/srq.c  |   20 +++++++++-----------
 include/uapi/rdma/hfi2-abi.h        |   11 -----------
 5 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/hfi2.h b/drivers/infiniband/hw/hfi2/hfi2.h
index 8ac895c29612..0939c45e51f3 100644
--- a/drivers/infiniband/hw/hfi2/hfi2.h
+++ b/drivers/infiniband/hw/hfi2/hfi2.h
@@ -1284,6 +1284,12 @@ struct chip_params {
 	u32 csr_err_mask_reg;
 	u32 csr_err_clear_reg;
 
+	/*
+	 * Chip-variant operation callbacks. Function pointers are used here
+	 * to abstract differences between chip variants (e.g. JKR and future
+	 * generations). Each variant populates its own chip_params instance
+	 * with the appropriate implementations at driver init time.
+	 */
 	void (*hfi2_setextled)(struct hfi2_pportdata *ppd, u32 on);
 	void (*start_led_override)(struct hfi2_pportdata *ppd,
 				   unsigned int timeon, unsigned int timeoff);
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 45404611c9ce..be0293434f27 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -318,7 +318,7 @@ int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
 		if (cq->queue) {
 			if (RDMA_READ_UAPI_ATOMIC(cq->queue->head) !=
-				RDMA_READ_UAPI_ATOMIC(cq->queue->tail))
+			    RDMA_READ_UAPI_ATOMIC(cq->queue->tail))
 				ret = 1;
 		} else {
 			if (cq->kqueue->head != cq->kqueue->tail)
@@ -426,6 +426,7 @@ int rvt_resize_cq(struct ib_cq *ibcq, unsigned int cqe, struct ib_udata *udata)
 	}
 	spin_unlock_irq(&cq->lock);
 
+	synchronize_rcu();
 	if (u_wc)
 		vfree(old_u_wc);
 	else
@@ -518,9 +519,9 @@ int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
  */
 int rvt_driver_cq_init(void)
 {
-	comp_vector_wq = alloc_workqueue("%s",
-					 WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_PERCPU,
-					 0, "rdmavt_cq");
+	comp_vector_wq =
+		alloc_workqueue("%s", WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_PERCPU,
+				0, "rdmavt_cq");
 	if (!comp_vector_wq)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 473f464f33fa..f0bd096f457c 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -32,8 +32,7 @@ void rvt_mmap_init(struct rvt_dev_info *rdi)
  */
 void rvt_release_mmap_info(struct kref *ref)
 {
-	struct rvt_mmap_info *ip =
-		container_of(ref, struct rvt_mmap_info, ref);
+	struct rvt_mmap_info *ip = container_of(ref, struct rvt_mmap_info, ref);
 	struct rvt_dev_info *rdi = ib_to_rvt(ip->context->device);
 
 	spin_lock_irq(&rdi->pending_lock);
@@ -91,8 +90,7 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	 * CQ, QP, or SRQ is soon followed by a call to mmap().
 	 */
 	spin_lock_irq(&rdi->pending_lock);
-	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps,
-				 pending_mmaps) {
+	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps, pending_mmaps) {
 		/* Only the creator is allowed to mmap the object */
 		if (context != ip->context || (__u64)offset != ip->offset)
 			continue;
@@ -115,6 +113,7 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 done:
 	return ret;
 }
+EXPORT_SYMBOL(rvt_mmap);
 
 /**
  * rvt_create_mmap_info - allocate information for hfi1_mmap
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index d022aa56c5bf..e9ebe4035572 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -53,10 +53,9 @@ int rvt_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *srq_init_attr,
 	 */
 	srq->rq.size = srq_init_attr->attr.max_wr + 1;
 	srq->rq.max_sge = srq_init_attr->attr.max_sge;
-	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
-		sizeof(struct rvt_rwqe);
-	if (rvt_alloc_rq(&srq->rq, srq->rq.size * sz,
-			 dev->dparms.node, udata)) {
+	sz = sizeof(struct ib_sge) * srq->rq.max_sge + sizeof(struct rvt_rwqe);
+	if (rvt_alloc_rq(&srq->rq, srq->rq.size * sz, dev->dparms.node,
+			 udata)) {
 		ret = -ENOMEM;
 		goto bail_srq;
 	}
@@ -122,8 +121,7 @@ int rvt_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *srq_init_attr,
  * Return: 0 on success
  */
 int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
-		   enum ib_srq_attr_mask attr_mask,
-		   struct ib_udata *udata)
+		   enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
 	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_dev_info *dev = ib_to_rvt(ibsrq->device);
@@ -139,14 +137,13 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 		/* Check that the requested sizes are below the limits. */
 		if ((attr->max_wr > dev->dparms.props.max_srq_wr) ||
-		    ((attr_mask & IB_SRQ_LIMIT) ?
-		     attr->srq_limit : srq->limit) > attr->max_wr)
+		    ((attr_mask & IB_SRQ_LIMIT) ? attr->srq_limit :
+						  srq->limit) > attr->max_wr)
 			return -EINVAL;
 		sz = sizeof(struct rvt_rwqe) +
-			srq->rq.max_sge * sizeof(struct ib_sge);
+		     srq->rq.max_sge * sizeof(struct ib_sge);
 		size = attr->max_wr + 1;
-		if (rvt_alloc_rq(&tmp_rq, size * sz, dev->dparms.node,
-				 udata))
+		if (rvt_alloc_rq(&tmp_rq, size * sz, dev->dparms.node, udata))
 			return -ENOMEM;
 		/* Check that we can write the offset to mmap. */
 		if (udata && udata->inlen >= sizeof(__u64)) {
@@ -220,6 +217,7 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			srq->limit = attr->srq_limit;
 		spin_unlock_irq(&srq->rq.kwq->c_lock);
 
+		synchronize_rcu();
 		vfree(owq);
 		kvfree(okwq);
 
diff --git a/include/uapi/rdma/hfi2-abi.h b/include/uapi/rdma/hfi2-abi.h
index 7b7ca198b539..5b5b619bf1a8 100644
--- a/include/uapi/rdma/hfi2-abi.h
+++ b/include/uapi/rdma/hfi2-abi.h
@@ -248,17 +248,6 @@ struct hfi2_ctxt_info {
 	__u16 sdma_ring_size; /* number of entries in SDMA request ring */
 };
 
-struct hfi1_tid_info {
-	/* virtual address of first page in transfer */
-	__aligned_u64 vaddr;
-	/* pointer to tid array. this array is big enough */
-	__aligned_u64 tidlist;
-	/* number of tids programmed by this request */
-	__u32 tidcnt;
-	/* length of transfer buffer programmed by this request */
-	__u32 length;
-};
-
 #define HFI2_TID_UPDATE_FLAGS_MEMINFO_MASK 0xfUL
 #define HFI2_TID_UPDATE_FLAGS_RESERVED_MASK \
 	(~(__u64)(HFI2_TID_UPDATE_FLAGS_MEMINFO_MASK))


