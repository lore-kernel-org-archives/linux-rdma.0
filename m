Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7528C41B8D7;
	Thu, 16 Jul 2026 11:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201888; cv=none; b=KnsPel2cZRGvibN76GOqbQKjnzQ87yNy7CjRcwbdbX76tjDZ3OCnvju8Ab4tKV8Ypaq9uETiTPjdt/3iUcAWGjUHDAC7TiY7Xpd0AvY4zcuypBYsUWpmH06UG4uWo2d7MWMR0R3qkgMxhCxXul+GJapOtLah0vTcHzVq4IcEuvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201888; c=relaxed/simple;
	bh=tekPMub4IEaHSpjFZSKU4B3CQ0wd7sFPbgHH9Tzj2Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzQ1qJOGI7xy1UoaBOWXo7wPyx+4eWtYuLZZ70WLxDZZGGSg+ZuHHo+YyiPekV3gnJIqLGsUTTF51cJMEFw5ftEIBTb/AFNntAGcB6gcQ6YsdQzIGePmOvUtZHgDTW0D8zftxfx1cBPOslWQ02512lN/F5khLkXrRztAtdvIqNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AAxqEACa; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AAxqEACa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784201878; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=AMOlS2v5ALg4J1j5nUpgf0lp+P3VlMmVDiiKLr52URo=;
	b=AAxqEACapKKKhSAXlpgFk3M2L9gApkUjiNEpxlMnW8pZ8rhbihJeV183TIdz46uQszRokzvuy0e1Sblk06R+XNP7+DWS7vjM8V/JKwsAfPuAuen7eqYcC6EecnbY7vw/mpQF63O88MsMk7Ml4GM537HQvrfEOIE+rckayeyxKo4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X7EH86p_1784201877;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X7EH86p_1784201877 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 19:37:57 +0800
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
Subject: [PATCH net-next v4 2/3] net/smc: reduce TX slot contention with exclusive wait
Date: Thu, 16 Jul 2026 19:37:44 +0800
Message-ID: <20260716113745.65234-3-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260716113745.65234-1-alibuda@linux.alibaba.com>
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
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

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
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

