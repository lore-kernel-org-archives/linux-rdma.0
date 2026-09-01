Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6CC27FD4F
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 11:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788262237; cv=none; b=Q2FQVBlK8W8bQyzhxa7VuymUeriqMW9g/ApR9OwnPl6gsBIm7xubhTgbJ+V85lM4ryt4gzSNHtIMAjtsUyhZMOQNfcanqQi43j8Xhxb6V/P7TsYPa9NHlYaUTNocYQza8Wa5GIdaw+/vC/N0on94mTciyfJMzmarXGQLpZONtEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788262237; c=relaxed/simple;
	bh=K5PmhPD6YB0d2dV9gW3BWfzad6teVblREfbtV6kxrws=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ADJXoUg9G0AKP+ANaPY5b9LQQiBY2KGNTyklENl1/8rKrVUBGwr7wWpt9vJuYKA8+TP1LBwNb4cCtzvOPb7ic/1PYe3Unomx6jcSqzGwWW8B1QmFNEaNjjISodAmxsHzgQjBLlOHGMZ17ro9utt9/Fjj09k0RNAPMO6npl5rjAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=GLx2at2h; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="GLx2at2h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788262236; x=1819798236;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UsOFdXB+Gfb69WRblae/66AjV0NNrqmtdzfk/KgxJCM=;
  b=GLx2at2hoy9lMosECKpxuWyaZcMvSZKfIqbJJXlq0H7yiWVmHkXioPy0
   zEIskOAmedtsRgXwaX7zyiozoaQWZQs9nVHhAZ/1PjauW1kxwEdWWyAtk
   yXRkxMa3KKXJw3rz6tUXYiTZgvZ/xCqzsdwxQ5epVga/SJQLQxRYVjXtr
   8rcJZdGOjA0slyMj8W4dCCD6cwKpysgK1as1bNmvWHi2FrJuehkynCj7p
   sfNRBtDQ7M32jquoJW+r/AwsKzhkGQZ41MCLKmnWGd+tCNIdr00dr4q50
   in4ND1l0X2ySyxC3cqFGbWIdTO+oBE4APsSRCmidRfrY2aH73C+aEF/9h
   g==;
X-CSE-ConnectionGUID: U+yiDPEdQR2mnaFDE5E/iA==
X-CSE-MsgGUID: JlzRjXTOT368En/ii+uGPw==
X-IronPort-AV: E=Sophos;i="6.25,255,1779148800"; 
   d="scan'208";a="27283106"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 11:30:33 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:8707]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.51:2525] with esmtp (Farcaster)
 id 721d101f-0b9b-4a11-bfca-3e07ce4fc0c8; Tue, 1 Sep 2026 11:30:33 +0000 (UTC)
X-Farcaster-Flow-ID: 721d101f-0b9b-4a11-bfca-3e07ce4fc0c8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 1 Sep 2026 11:30:33 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Tue, 1 Sep 2026
 11:30:31 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: [PATCH for-rc] RDMA/efa: Fix race between admin command timeout and completion
Date: Tue, 1 Sep 2026 11:30:16 +0000
Message-ID: <20260901113016.581935-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWB001.ant.amazon.com (10.13.139.133) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

When an admin command times out, there is a potential race between the
interrupt handler processing the completion and the timeout path
releasing the completion context. The interrupt handler may observe the
command as still submitted and attempt to complete it while the timeout
path is concurrently freeing the context.

Fix this by introducing a timed-out state in the completion context. On
timeout, both the polling and interrupt wait paths set the status to
timed-out under the CQ lock before returning. The completion handler
only process commands in submitted state, eliminating the race.

Fixes: 0420e542569b ("RDMA/efa: Implement functions that submit and complete admin commands")
Reviewed-by: Tom Sela <tomsela@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 583b1cf0d721..a91de9283b6b 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -41,6 +41,7 @@ enum efa_cmd_status {
 	EFA_CMD_ALLOCATED,
 	EFA_CMD_SUBMITTED,
 	EFA_CMD_COMPLETED,
+	EFA_CMD_TIMED_OUT,
 };
 
 struct efa_comp_ctx {
@@ -605,6 +606,10 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 			break;
 
 		if (time_is_before_jiffies(timeout)) {
+			spin_lock_irqsave(&aq->cq.lock, flags);
+			comp_ctx->status = EFA_CMD_TIMED_OUT;
+			spin_unlock_irqrestore(&aq->cq.lock, flags);
+
 			ibdev_err_ratelimited(
 				aq->efa_dev,
 				"Wait for completion (polling) timeout\n");
@@ -639,7 +644,6 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 	if (comp_ctx->status == EFA_CMD_SUBMITTED) {
 		spin_lock_irqsave(&aq->cq.lock, flags);
 		efa_com_handle_admin_completion(aq);
-		spin_unlock_irqrestore(&aq->cq.lock, flags);
 
 		atomic64_inc(&aq->stats.no_completion);
 
@@ -660,6 +664,9 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 				comp_ctx->cmd_id, aq->sq.pc, aq->sq.cc,
 				aq->cq.cc);
 
+		comp_ctx->status = EFA_CMD_TIMED_OUT;
+		spin_unlock_irqrestore(&aq->cq.lock, flags);
+
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
 		return -ETIME;
 	}
-- 
2.50.1

