Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AB323ED6A
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823895; cv=none; b=m6PEJag2ox0fqARU4WbkcPUbHiUnMjXCGkobOx8xJAXH7bFq+UMovnOYbeaR4LL0AykjOHNk9g6wtTDogQIjiN7c9VnqWi8kZdCvJd9lXcuLIwDGhztFZLHzZRMNaFIQuF3arSs/xwhV4bUrIn2ixbvfyYg88+jqFiKrrga0qJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823895; c=relaxed/simple;
	bh=IL+VO4COGP0HKe4libp4uI+n/Jfy9vlssPLZAkyKZuM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fGlIuAJ3fAu3RaKgNre3dFK69XvJtvYudYTNkICO79gXxhzzy7vG88H43Z+B3S0oiXKeBTzblbfbIse3zWfI6biNjNb+KDrbRc90L8FKGVA36GKN3QSzX+sGtBSy0co7BNTngErC6blaLSx43eHk/T7QX69eiXppWva98c65bL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=cz+5PBVi; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="cz+5PBVi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1791823894; x=1823359894;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7QrH2rlcgkDrQB0mXo1DLZ2j9ZhiZxrbh7i7op2bkM4=;
  b=cz+5PBViFX+tt08vxWwtgCdfx/FVo1d619bj6eGliHH6TVxPcy98LyOf
   odk9QVGXIpPfJKK+5i3NUgeyOLOn+bskNudqIVF+S2lELXjPN8wqZtwZ2
   jcr7YCtfhj3/+Pf+rEKSQ2KozKL3W6SIHxSuhqFyKUIXV6t4MwaeR/VNa
   9qK+dExwvoBZehfSVic0bbpP9zgJieybDwFJZjDqvK2enbG6gj+p1dOcX
   FiayUOIXDxxJkcKUFWkiGc1bzJoHq6svrITicIH9NIqBPYsdzBUcsYj8M
   UhH9d/4vPYKVBhc+HKogKvZxczK+dCqeGoFuDVRv602hA9hTb96UmIcQS
   g==;
X-CSE-ConnectionGUID: nGjBrjB+QgiWJ2dI+C1hRw==
X-CSE-MsgGUID: v/DE72CbQzO9NIw7WTSzjg==
X-IronPort-AV: E=Sophos;i="6.27,154,1787011200"; 
   d="scan'208";a="31042836"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:51:31 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:4929]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.113:2525] with esmtp (Farcaster)
 id c3b7bb37-0cae-4bf2-8cd9-1f3a93c33c33; Mon, 12 Oct 2026 16:51:31 +0000 (UTC)
X-Farcaster-Flow-ID: c3b7bb37-0cae-4bf2-8cd9-1f3a93c33c33
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Mon, 12 Oct 2026 16:51:31 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Mon, 12 Oct 2026
 16:51:29 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>, Michael Margolin <mrgolin@amazon.com>,
	Tom Sela <tomsela@amazon.com>
Subject: [PATCH for-rc v2] RDMA/efa: Fix race between admin command timeout and completion
Date: Mon, 12 Oct 2026 16:51:13 +0000
Message-ID: <20261012165113.576899-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

An admin command that times out can race with the interrupt handler
processing its completion, in two ways.

The timeout path releases the completion context without synchronizing
against the handler. A handler that has already seen the command as
submitted then copies the CQE into the caller's response buffer after
the waiter returned and that buffer went out of scope.

The waiter can also observe the command as completed before the CQE was
copied, since the status is published first. It decodes its own
uninitialized response buffer, returns success with garbage contents and
leaks stack data to the caller. Both wait paths read the status without
the CQ lock.

Add a timed-out state and publish it under the CQ lock in both wait
paths before returning, so the handler, which only completes commands in
submitted state, cannot act on an abandoned context. In the interrupt
wait path test the return value of the wait instead of the status: the
handler signals the completion after copying the CQE, so a successful
wait implies a valid response. Read the status in the polling wait path
inside the critical section that drains the CQ, which also lets a
completion arriving on the last iteration be honored instead of reported
as a timeout.

Fixes: 0420e542569b ("RDMA/efa: Implement functions that submit and complete admin commands")
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Tom Sela <tomsela@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
Changelog:
v2:
 * Read the completion status under the CQ lock in the polling path
   instead of only taking the lock around the timed-out store.
 * Use the wait_for_completion_timeout() return value in the interrupt
   path instead of reading the status unlocked to determine whether the
   command timed out.
v1: https://lore.kernel.org/all/20260901113016.581935-1-ynachum@amazon.com/

 drivers/infiniband/hw/efa/efa_com.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 04c6d63c449e..9c59d127e1e0 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -41,6 +41,7 @@ enum efa_cmd_status {
 	EFA_CMD_ALLOCATED,
 	EFA_CMD_SUBMITTED,
 	EFA_CMD_COMPLETED,
+	EFA_CMD_TIMED_OUT,
 };
 
 struct efa_comp_ctx {
@@ -591,6 +592,7 @@ static int efa_com_comp_status_to_errno(u8 comp_status)
 static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_ctx,
 						     struct efa_com_admin_queue *aq)
 {
+	bool comp_timeout = false;
 	unsigned long timeout;
 	unsigned long flags;
 
@@ -599,12 +601,19 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 	while (1) {
 		spin_lock_irqsave(&aq->cq.lock, flags);
 		efa_com_handle_admin_completion(aq);
-		spin_unlock_irqrestore(&aq->cq.lock, flags);
-
-		if (comp_ctx->status != EFA_CMD_SUBMITTED)
+		if (comp_ctx->status != EFA_CMD_SUBMITTED) {
+			spin_unlock_irqrestore(&aq->cq.lock, flags);
 			break;
+		}
 
 		if (time_is_before_jiffies(timeout)) {
+			comp_ctx->status = EFA_CMD_TIMED_OUT;
+			comp_timeout = true;
+		}
+
+		spin_unlock_irqrestore(&aq->cq.lock, flags);
+
+		if (comp_timeout) {
 			ibdev_err_ratelimited(
 				aq->efa_dev,
 				"Wait for completion (polling) timeout\n");
@@ -625,10 +634,11 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *comp_ctx,
 							struct efa_com_admin_queue *aq)
 {
-	unsigned long flags;
+	unsigned long flags, remaining_jiffies;
+	bool completed;
 
-	wait_for_completion_timeout(&comp_ctx->wait_event,
-				    usecs_to_jiffies(aq->completion_timeout));
+	remaining_jiffies = wait_for_completion_timeout(
+		&comp_ctx->wait_event, usecs_to_jiffies(aq->completion_timeout));
 
 	/*
 	 * In case the command wasn't completed find out the root cause.
@@ -636,14 +646,16 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 	 * 1) No completion (timeout reached)
 	 * 2) There is completion but the device didn't get any msi-x interrupt.
 	 */
-	if (comp_ctx->status == EFA_CMD_SUBMITTED) {
+	if (remaining_jiffies == 0) {
 		spin_lock_irqsave(&aq->cq.lock, flags);
 		efa_com_handle_admin_completion(aq);
+		completed = (comp_ctx->status == EFA_CMD_COMPLETED);
+		comp_ctx->status = EFA_CMD_TIMED_OUT;
 		spin_unlock_irqrestore(&aq->cq.lock, flags);
 
 		atomic64_inc(&aq->stats.no_completion);
 
-		if (comp_ctx->status == EFA_CMD_COMPLETED)
+		if (completed)
 			ibdev_err_ratelimited(
 				aq->efa_dev,
 				"The device sent a completion but the driver didn't receive any MSI-X interrupt for admin cmd %s(%d) status %d (id: %d, sq producer: %d, sq consumer: %d, cq consumer: %d)\n",
-- 
2.50.1

