Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3CD442376;
	Wed, 30 Sep 2026 07:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790751918; cv=none; b=YtOBEyQ5JTiJvvsc4X8tWVk7KQixr6LNg510Xzg0QMPWvcK5SfLUYW2SogVV6DzVgiyDbJX/qilhBXhr/ZkuufHdaRS8XMQV1egzxv0WV8kSIWhjtnwDFPZlmy4VKIvBDIt1YCnBKAaO3QoIc7dErzn67vI1rNxKYI6FvXAzh44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790751918; c=relaxed/simple;
	bh=cklIuJJ56mich+Qq9nP8fG7uxWGoszW3BZx3+LVgiGg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u21CMpHMBb1jX0RfCRAlE6/PYleZfj9+LmmGvUA628xQgikudYe4OhTHRyDJ8XeIxKdjJVMSxaLQPXswMFT/HTRPibEYT6tpa7ag0bU30dQX+qznJw/FkDi/R9bDZN+/6uUKi8ADh++Mzp0aYimo4yC7FZBaDJfhLd6COYqAY7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=DkmD6pFh; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="DkmD6pFh"
Received: from PC-202605011814.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f9bbca68;
	Wed, 30 Sep 2026 15:05:00 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Wed, 30 Sep 2026 15:04:55 +0800
Message-Id: <20260930070455.2934286-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0f12183ca03a1kunm8f64acc726de24
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGExNVh1OSEhOQkJJSxlLSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=DkmD6pFh4YRbCOFO3Rpn4r+zf5ph3TNd0yFNHGymsCgeTKZdg/RenvKKrZe14d64bY8rXtAoMA3vkBMvQpxzU0BKTFvtQa29At7IOeZGK+g5a5uwcex0zKSkWlshAH3R71W8ESW6J8cnjP7xrn7t2+ygM8zrkHRWT4XzO3C3Yj8=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=aV2Xsk9uJanK5srjyK7lHg+XzOtJCIK8chwR83PExTo=;
	h=date:mime-version:subject:message-id:from;

The HFI1 receive error and synthetic counter timers rearm themselves from
their callbacks. Their cleanup paths use timer_delete_sync(), which only
waits for a running callback and does not prevent a concurrent or
subsequent rearm.

Use timer_shutdown_sync() when releasing these timers. This prevents a
callback from enqueueing either timer after cleanup begins, before the
containing hfi1_devdata is freed.

Preserve the existing work cancellation and workqueue destruction ordering
for synthetic counters.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/infiniband/hw/hfi1/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 592e330e74bf1..faa724ca33bd7 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5567,7 +5567,7 @@ static int init_rcverr(struct hfi1_devdata *dd)
 static void free_rcverr(struct hfi1_devdata *dd)
 {
 	if (dd->rcverr_timer.function)
-		timer_delete_sync(&dd->rcverr_timer);
+		timer_shutdown_sync(&dd->rcverr_timer);
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12300,7 +12300,7 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	int i;
 
 	if (dd->synth_stats_timer.function)
-		timer_delete_sync(&dd->synth_stats_timer);
+		timer_shutdown_sync(&dd->synth_stats_timer);
 	cancel_work_sync(&dd->update_cntr_work);
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
-- 
2.34.1

