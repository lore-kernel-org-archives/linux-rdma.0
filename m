Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3AB41B8ED;
	Thu, 16 Jul 2026 11:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201892; cv=none; b=Y44addLJHrFJk3BhRzwLstKRCdyXo659RXtN5+WriCwHS30WiPEAPzs0k5diortJa/fTV1RPNXGE2n4JYR2i0+T3IxWoZ4jT5r+cKUKFejygn39TleITmArl0g85elr8ZoJqwtiCrToLt6OWZqNKVeArTO9/idBHtAA827TeksI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201892; c=relaxed/simple;
	bh=tmOBf0HNT6z+xw8Mrxoujh2A1lp0PjC/WoZIcDS58KA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=knz3sPjLTuI4XAkeH8/HYPGxwI9YXBCOUtvTTN8jlCGGODwyD1rxQEt4Iexl8RqcAgGdWKu9ylDcNOQO3bFqqg2HNW9/TjIWlYR8Lv/zHFMePvs1mURxwDv4mKCL/QpUzLxGBrQHEb26ra5wgPoL6791HsXBcASJJ7FwK0RzDoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fvOsL8Oi; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fvOsL8Oi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784201876; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=9EzWgmGCM1Y9ytDB1nGfuLPkAYbwUbqK/GfIJB6+pGU=;
	b=fvOsL8OiLK+9vr4aDTe7jTvxEkNHcwlpMvHh7W4nswgk+/FGv1lb3lkzuyDSNUnH96QPwvtMSfRZmD9CYdd7r5ZAwYNtUXMzveE0N5yDZ4vKXgF+BBaXwv30iFSgLF2htjmQ47PH49GS1HqOx0M8oUVunGTTlhbvPAQIJBRDUaI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X7EH82M_1784201866;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X7EH82M_1784201866 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 19:37:56 +0800
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
Subject: [PATCH net-next v4 0/3] net/smc: transition to RDMA core CQ pooling
Date: Thu, 16 Jul 2026 19:37:42 +0800
Message-ID: <20260716113745.65234-1-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series transitions SMC-R completion handling to RDMA core CQ pooling
via the ib_cqe API. The new completion model improves scalability by
allowing per-link completion processing across multiple cores and enables
DIM-based interrupt moderation.

The increased concurrency can amplify contention for TX slots on the shared
wait queue, so the exclusive-wait change comes first as a standalone
improvement that the CQ pooling teardown then builds on.

Patch 1 fixes smc_wr_tx_put_slot() to clear the v2 pending slot and buffer
structures instead of the pointer variables.
Patch 2 reduces TX slot contention by switching TX slot allocation from
non-exclusive wait_event() to prepare_to_wait_exclusive().
Patch 3 replaces the global per-device CQ and manual tasklet polling model
with RDMA core CQ pooling.

Link: https://lore.kernel.org/netdev/20260305022323.96125-1-alibuda@linux.alibaba.com/

---
Changes v1 -> v2:
https://lore.kernel.org/netdev/20260508063718.101622-1-alibuda@linux.alibaba.com/
1. remove unnecessary inline from static CQE init helpers.
2. Use ib_drain_qp() with +1 max_send_wr;
3. Fix v2 state clearing.
4. Add re-check after schedule_timeout() to fix timeout/signal races.

Changes v2 -> v3:
https://lore.kernel.org/netdev/20260528084819.6059-1-alibuda@linux.alibaba.com/
1. Reserve +3 instead of +1 for the SQ to cover the drain, FastReg and
   SMC-Rv2 SEND WRs, avoiding SQ exhaustion that breaks ib_drain_sq().
2. Guard the recv WR repost with a per-link percpu_ref so no WR is
   reposted after ib_drain_qp(), fixing the RX repost/drain use-after-free.
3. Split the smc_wr_tx_put_slot() v2 clearing fix into a separate patch
   (1/3) with a Fixes: tag and reworded to the verifiable root cause.

Changes v3 -> v4:
https://lore.kernel.org/netdev/20260710033356.16460-1-alibuda@linux.alibaba.com/
1. Reorder: move the exclusive-wait patch before the CQ pooling patch.
2. Fix teardown stall: reintroduce smc_ib_modify_qp_error() and flush the QP
   in smc_wr_stop_link() before waiting for the refs.
3. smc_wr_reg_send(): take the ref before ib_post_send().
4. smc_wr_tx_process_cqe(): wake_up_all() on a flush completion.
5. Merge the three per-link percpu_refs into a single wr_refs.

D. Wythe (3):
  net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
  net/smc: reduce TX slot contention with exclusive wait
  net/smc: transition to RDMA core CQ pooling

 net/smc/smc_core.c |  10 +-
 net/smc/smc_core.h |  36 ++--
 net/smc/smc_ib.c   | 106 ++++-------
 net/smc/smc_ib.h   |   6 -
 net/smc/smc_tx.c   |   1 -
 net/smc/smc_wr.c   | 445 +++++++++++++++++++++------------------------
 net/smc/smc_wr.h   |  50 ++---
 7 files changed, 287 insertions(+), 367 deletions(-)

-- 
2.45.0

