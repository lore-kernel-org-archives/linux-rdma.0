Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35E350A05;
	Fri, 10 Jul 2026 03:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783654449; cv=none; b=LnElOVqhiuKc6spQmTS0PBqjXt/v2HF6UqxmCpqY+YEJEsSWJwC0NSfqtvmtVHLoG4FZzZr6p6IoX1ftemwlodsQ65pJif5R/3AXADk0O5Rm7wgzPeGr/EnnUMp0hKiUwXMbBX+4xWpRZ4q8iDb28qkPln1uaeTprYTeh61xLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783654449; c=relaxed/simple;
	bh=XjJO2o8KL4djatoFQ7BCyE16HEIEj4hHPSuABP54PtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6UJWa6LLGfePvKyF7XScfoAs8Dcf9322zlgNaY28wncEwWQg7e/UBBnrgU6ortOG8pbbiFSoDnrcoCiV7T1jDjaHlmbYi6o7NpZsgf0gSZUhcQdUoldhSWkrDOgdfJ6zmwF8gLWwenbugKIA5VE8fIQ0ho+4tymV7cH/JA5zwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XCzvz7v/; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XCzvz7v/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783654444; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=OukEeOHQHOHrfRd33rKhzMvs9JGMiSa3dH45xlsItH4=;
	b=XCzvz7v/6rUO+TD9j6qoTDcVnFlQF5+E3t7VyvleAxVIxBeStWDPYSEB33JDeHtC7PxoDupV3JkZEq5mFpnP75XCdx2pJw4m9KOE4jOd+asl+kkex+3T8jfknovdXqnRTeM7GdgnVXTV8bzuewsn8cRDeX/DrHx6heMItJCWh+Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X6mSWfo_1783654443;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X6mSWfo_1783654443 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 11:34:03 +0800
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
	pabeni@redhat.com,
	edumazet@google.com,
	sidraya@linux.ibm.com,
	jaka@linux.ibm.com
Subject: [PATCH net-next v3 3/3] net/smc: reduce TX slot contention with exclusive wait
Date: Fri, 10 Jul 2026 11:33:56 +0800
Message-ID: <20260710033356.16460-4-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260710033356.16460-1-alibuda@linux.alibaba.com>
References: <20260710033356.16460-1-alibuda@linux.alibaba.com>
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

Performance measured with netperf TCP_RR (63 flows, 200B write /
1000B read, 60s duration):

+-------------------------------+---------------+---------------+
| smcr_max_conns_per_lgr        | 32            | 255           |
|-------------------------------+---------------+---------------|
| before                        | 4.85 Gb/s     | 657.95 Mb/s   |
|-------------------------------+---------------+---------------+
| after                         | 5.01 Gb/s     | 2.2 Gb/s      |
+-------------------------------+---------------+---------------+

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_wr.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 675bfe633e39..dfa242549876 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -153,9 +153,11 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 			    struct smc_rdma_wr **wr_rdma_buf,
 			    struct smc_wr_tx_pend_priv **wr_pend_priv)
 {
+	unsigned long timeout = SMC_WR_TX_WAIT_FREE_SLOT_TIME;
 	struct smc_link_group *lgr = smc_get_lgr(link);
 	struct smc_wr_tx_pend *wr_pend;
 	u32 idx = link->wr_tx_cnt;
+	DEFINE_WAIT(wait);
 	int rc;
 
 	*wr_buf = NULL;
@@ -165,17 +167,31 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
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

