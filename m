Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DEE3DEFF1;
	Thu,  6 Aug 2026 06:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785998585; cv=none; b=cMr+voK3ZNnnUnpxfnh4sA+0xgf5DY9pJE+P8voUUPAnF8aVTIDYVOFz+pr+yRH4ZL28JhOM7JZTVrfkeFR+E726OQ1MeEhDUeG84rZeNL2jtF6/NZjudFHD0FnSdG7Cb0AyCG7Pt6FJWgFFjGIjxJCDDj0lEpG0Mc1ofgg9igg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785998585; c=relaxed/simple;
	bh=UuxxuPwtlwv1z0VLwsC59IoGkyzD6FKxCpH4f7BEHL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK1Awl8FZmkhAh/kIWg1VaVcV/U7bBZ+8AamoryzT9AVoy+xEFowmMd8zlLjkBdi92vGMfVQZ8Ps7il4s3BfdXubr4LQyKfXwFv6FGzjkyhFMz1QCIN/HNTTHuHm2N70Cb2UJcBnNAUlyJQ6FqVH4Q56hWy823PvxRrtZcAqmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bXFGZoH+; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bXFGZoH+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785998578; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=323XBgsfWGd1iiNGmUIYOeMwhpndXcqvEJE1zqaHULE=;
	b=bXFGZoH+c1Woxcw8RzY9zJz0dEqudv5ZG2rAMJVRuJCx6hY/pbr39X3BSktbupIGwhVX0Mg8UBMfFfP7VKIDJL+vrNtqdh7gITBQijGApRrdErJUGEimxq2GaxnyYrz0E1G6yu07Vm9HdoB7Dk1quiEzRGOtRFVJOJu3+tgSI2Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X8TC9tE_1785998576;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X8TC9tE_1785998576 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 14:42:57 +0800
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
Subject: [PATCH net-next v1 1/2] net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
Date: Thu,  6 Aug 2026 14:42:51 +0800
Message-ID: <20260806064252.39180-2-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260806064252.39180-1-alibuda@linux.alibaba.com>
References: <20260806064252.39180-1-alibuda@linux.alibaba.com>
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
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
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

