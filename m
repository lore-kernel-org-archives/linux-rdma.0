Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A8435E95C;
	Fri, 10 Jul 2026 03:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783654452; cv=none; b=ekvuKX95jNfcSn8dw9hkERpJD0tYl5KDfSlNK/AIFE45mO1qINE1w2R8Hk7kH+mj4jlfydcHApGFyEAJH2IWMxAp8zXVKOqHfoOSly99Pf3/erlrpWXg7xJoGwrI63wFVS/F091IPsLPPLFQLGwJxCG+t98pS4QJMo0J0GqU/2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783654452; c=relaxed/simple;
	bh=4XW8A4/bhU/l0n2A2mVESVBFBZHJcKiViicPlcMOPFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hALBNjIo6BfSemD2NAHe6MEkAaij860grjpNEO/LuORQshDgcE9oOVCpQEEItAzMp4yQVUGNizMZ/qYR5RKpk0qh0tWb1LJ73xNd4Z9Cmw6WPJftXwcmfLZAWUyMj6G1SiRQzSiiHox/SSKXesi3dmhKZlf/6MqYfgf/iK1/M58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qGS+xEDl; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qGS+xEDl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783654442; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wZp3SDNMhMcixAufm65TuZRozT66qpaOyktDEsVoLdY=;
	b=qGS+xEDlq/bj/GvqwYGoqBiJGYs8wj0/IN4tGYen4seJXzGVXQ2mHbQWiGl9PEqSGrgdCA8Inw/cYjJEjIUlPoT/D88Eh4jMQa1TnGUfT1OgEYqDl5dytu8bS0rkaSzI7di/XH6nWnFigGCVPNHPswBMwv8wjpcNdvFjSNAMumU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X6mSWcu_1783654436;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X6mSWcu_1783654436 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 11:34:01 +0800
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
Subject: [PATCH net-next v3 0/3] net/smc: transition to RDMA core CQ pooling
Date: Fri, 10 Jul 2026 11:33:53 +0800
Message-ID: <20260710033356.16460-1-alibuda@linux.alibaba.com>
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

As a side effect, the increased concurrency can amplify contention for TX
slots on the shared wait queue. Patch 3 addresses this by switching TX slot
allocation from non-exclusive wait_event() to prepare_to_wait_exclusive(),
which avoids thundering-herd wakeups under contention.

Patch 1 fixes smc_wr_tx_put_slot() to clear the v2 pending slot and buffer
structures instead of the pointer variables.
Patch 2 replaces the global per-device CQ and manual tasklet polling model
with RDMA core CQ pooling.
Patch 3 reduces TX slot contention by using exclusive wait queue entries
during allocation.

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

D. Wythe (3):
  net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
  net/smc: transition to RDMA core CQ pooling
  net/smc: reduce TX slot contention with exclusive wait

 net/smc/smc_core.c |  10 +-
 net/smc/smc_core.h |  32 +++-
 net/smc/smc_ib.c   | 115 ++++---------
 net/smc/smc_ib.h   |   7 -
 net/smc/smc_tx.c   |   1 -
 net/smc/smc_wr.c   | 420 ++++++++++++++++++++++-----------------------
 net/smc/smc_wr.h   |  48 ++----
 7 files changed, 285 insertions(+), 348 deletions(-)

-- 
2.45.0

