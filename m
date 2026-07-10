Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E03624D4;
	Fri, 10 Jul 2026 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783654453; cv=none; b=TBG5KtTiUc6ORhj89s/a3/4SmRrLoilq1ASJhV8jvNpbLqDHM8Vu4TlXOpmeFFo4REDLX4+GsZ6dewA7uI7Kg+bpLVyo53tSNbA/nnVIG/ZgEOSlrLWCpj5jqL1bQfU55uBgWu5mKJi6qb08Ih0ybcKuG8/XQiNYp6jCFDpXoxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783654453; c=relaxed/simple;
	bh=Th8njBNhRmAL/JX4tIYE0XHYYmlM/MU2eq2Bx2+eTng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG5kF4hRPKER+M3S/DQhv9qqjLHc3ImtSI//0c3zU+7D7ZW1KEF7gAlvGeRaRF3ry0YkaSL2CW9Uz5Cf7sCMkQVBeMx/mp++4CarNh/22F9msN45a51EQdYnkcPxK+A99Wuklt5GDKrcRK+p9VYnF9QxVbm9Jop/oa6W8hc0yg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sx+EaFNn; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sx+EaFNn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783654443; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=5Z/vHcsRXLPe4mrwAll7G57kLJEopXOQT16h2ZZdWLs=;
	b=sx+EaFNn/1YSfWpgdKeUJ5050nmZNeekxcnyuLPgkSk7WXtfdwJnmlUknPRPUd7f9eI/JTpwTKXiq3WxWGEzd9eDVR7qeJUS9ivDmqsdnOF111rux23lzDSYZloqu8NY0/n8Q5ZNMJwWYoBc9cD0DA0iA4UtfWSfkw7qzqbvgVQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X6mSWf._1783654442;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X6mSWf._1783654442 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 11:34:02 +0800
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
Subject: [PATCH net-next v3 1/3] net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
Date: Fri, 10 Jul 2026 11:33:54 +0800
Message-ID: <20260710033356.16460-2-alibuda@linux.alibaba.com>
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

smc_wr_tx_put_slot() tries to reset the v2 pending slot and buffer with
memset(&link->wr_tx_v2_pend, 0, sizeof(link->wr_tx_v2_pend)) and the
equivalent for wr_tx_buf_v2. Both are pointers, so this zeroes the 8-byte
pointer variable instead of the structure it points to. The pending slot
and buffer are therefore never actually cleared, and the pointers get
overwritten with NULL.

Pass the pointers directly and use sizeof(*pointer) so the intended
structures are cleared.

Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_wr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 59c92b46945c..6b5add922993 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -288,10 +288,10 @@ int smc_wr_tx_put_slot(struct smc_link *link,
 	} else if (link->lgr->smc_version == SMC_V2 &&
 		   pend->idx == link->wr_tx_cnt) {
 		/* Large v2 buffer */
-		memset(&link->wr_tx_v2_pend, 0,
-		       sizeof(link->wr_tx_v2_pend));
-		memset(&link->lgr->wr_tx_buf_v2, 0,
-		       sizeof(link->lgr->wr_tx_buf_v2));
+		memset(link->wr_tx_v2_pend, 0,
+		       sizeof(*link->wr_tx_v2_pend));
+		memset(link->lgr->wr_tx_buf_v2, 0,
+		       sizeof(*link->lgr->wr_tx_buf_v2));
 		return 1;
 	}
 
-- 
2.45.0

