Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE67D3CFF62;
	Fri, 21 Aug 2026 09:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303852; cv=none; b=bTAEd8HJhLRgKJkRx8EpeW9jpLfv/I9g9XBCxdXcHYYZEgAmqlKfSlqehNrcwJYvsL+jYjWCDRjnbqQn5fb0wjfUupaybPURRDT9/YFEvcJUY69aEFlbWgHuAKZu+cZS3XxsI5cQRAo0a3TM6iC5WAJLjalyjsuTZ3bGvSL1gVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303852; c=relaxed/simple;
	bh=rRVWNtK5LAG8F8JMlY1rGH0LSjqoZBKrtew58v8LOXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gapmGdL+jGNS3MPLKCaSb9cUXKn0sTQFHG8rw89NISASkshsmk6rNms1w535ByWxO/ik7EYScDHJnbX5WTjqG9JspUuxEfe+9Lq2FknESSAQ7rOJPxH3FpoMZ+he+5L6UB5R88jWj7FfLrnT8B1w+JXrFcpYRTMKAC9mtCaE++o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PttqLCOF; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PttqLCOF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787303829; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=7fLqANOUy4E0CjqMFn+fvJvJwRP+zJD3LCCtx+HnPJ8=;
	b=PttqLCOFazyuf906T6c+4aglZPaEm/Aiu1DfFoTaFogitnoKzyJPtp/5f6oq0hyPwi6D75J8BxcoUOM/XF0EEEKor4aI0AkWyBm3D2irfjTDmfd9zsS4VbxopGCBVksQTI/4fpbnjAONmrK/nyyE7c7JkzRHqMqCniv4EeYLkCg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X9LvYCp_1787303828;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X9LvYCp_1787303828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 17:17:09 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: mjambigi@linux.ibm.com,
	wenjia@linux.ibm.com,
	wintera@linux.ibm.com,
	dust.li@linux.alibaba.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	pabeni@redhat.com,
	edumazet@google.com,
	sidraya@linux.ibm.com,
	jaka@linux.ibm.com,
	oliver.yang@linux.alibaba.com
Subject: [PATCH net-next v2 2/2] net/smc: reduce TX slot contention with exclusive wait
Date: Fri, 21 Aug 2026 17:17:02 +0800
Message-ID: <20260821091702.21458-3-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260821091702.21458-1-alibuda@linux.alibaba.com>
References: <20260821091702.21458-1-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_wr_tx_get_free_slot() waits for a free TX slot with
wait_event_interruptible_timeout(). Since the wait_event family
enqueues waiters as non-exclusive, wake_up() may wake multiple
waiters even though only one can use the slot, causing
thundering-herd contention when slots are scarce.

Use an exclusive wait loop with prepare_to_wait_exclusive() so
wake_up() wakes only one waiter per freed slot.
smc_wr_wakeup_tx_wait() still uses wake_up_all() during link
teardown, so teardown behavior is unchanged.

This also corrects the return value on a pending signal: the previous
wait_event_interruptible_timeout() path fell through to the "no free
slot" case and returned -EPIPE, masking the signal as a connection
error. The open-coded loop now returns -ERESTARTSYS, matching the
standard interruptible-wait semantics and letting the syscall restart
machinery handle it.

Performance
===========

Measured with uperf between two peers over SMC-R. The benefit depends
on how often the TX slot wait path is actually taken.

With the default settings, where many connections share a link group
and the send queue is small, slots are scarce and the wait path is hot:

  net.smc.smcr_max_conns_per_lgr = 255
  net.smc.smcr_max_send_wr       = 16
  net.smc.smcr_max_recv_wr       = 48

  workload                 baseline      patched     delta
  ---------------------------------------------------------
  rr1c-200x1000-50.xml     655.06 Mb/s   1.53 Gb/s   +134%
  rr1c-1x1-250.xml         371.03 Kb/s   2.07 Mb/s   +458%

With a tuned configuration, where slots are mostly available and the
wait path is rarely entered, the change is neutral to slightly positive:

  net.smc.smcr_max_conns_per_lgr = 32
  net.smc.smcr_max_send_wr       = 64
  net.smc.smcr_max_recv_wr       = 64

  workload                 baseline      patched     delta
  ---------------------------------------------------------
  rr1c-200x1000-50.xml     1.74 Gb/s     1.80 Gb/s   +3.4%
  rr1c-1x1-250.xml         3.11 Mb/s     3.14 Mb/s   +1.0%

So the change does not regress the uncontended case, and recovers most
of the throughput lost to thundering-herd wakeups once slots become
scarce.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_wr.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 6b5add922993..2cdd4063c13d 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -198,11 +198,13 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 			    struct smc_rdma_wr **wr_rdma_buf,
 			    struct smc_wr_tx_pend_priv **wr_pend_priv)
 {
+	unsigned long timeout = SMC_WR_TX_WAIT_FREE_SLOT_TIME;
 	struct smc_link_group *lgr = smc_get_lgr(link);
 	struct smc_wr_tx_pend *wr_pend;
 	u32 idx = link->wr_tx_cnt;
 	struct ib_send_wr *wr_ib;
 	u64 wr_id;
+	DEFINE_WAIT(wait);
 	int rc;
 
 	*wr_buf = NULL;
@@ -212,17 +214,31 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 		if (rc)
 			return rc;
 	} else {
-		rc = wait_event_interruptible_timeout(
-			link->wr_tx_wait,
-			!smc_link_sendable(link) ||
-			lgr->terminating ||
-			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
-			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
-		if (!rc) {
-			/* timeout - terminate link */
-			smcr_link_down_cond_sched(link);
-			return -EPIPE;
+		rc = 0;
+		for (;;) {
+			prepare_to_wait_exclusive(&link->wr_tx_wait, &wait,
+						  TASK_INTERRUPTIBLE);
+			if (!smc_link_sendable(link) || lgr->terminating ||
+			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
+				break;
+			timeout = schedule_timeout(timeout);
+			/* re-check */
+			if (!smc_link_sendable(link) || lgr->terminating ||
+			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
+				break;
+			if (!timeout) {
+				/* timeout - terminate link */
+				smcr_link_down_cond_sched(link);
+				break;
+			}
+			if (signal_pending(current)) {
+				rc = -ERESTARTSYS;
+				break;
+			}
 		}
+		finish_wait(&link->wr_tx_wait, &wait);
+		if (rc)
+			return rc;
 		if (idx == link->wr_tx_cnt)
 			return -EPIPE;
 	}
-- 
2.45.0

