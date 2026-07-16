Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD4E41B8E0;
	Thu, 16 Jul 2026 11:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201885; cv=none; b=senC1NgWohtssEDPDU99wU7MZztiG+RW6Vza+aaN8C3i9gAtlP95K6l4m6Mi+JZYkQu2nxsZZS6RQjOGJsVWweK+WKgDds2CnDrY0Trs9X9JJ7h5ipF0fMAyt9inuZEneXoj54PBkDGdvf3VAj4tEgCFHE4BS7RRnbkcSNLRZvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201885; c=relaxed/simple;
	bh=c79NboGB9hiWAfaIsyeo/tCz8oZPzdohQeOauPBTh3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/c8Q9CzxFBi2voeUrnaA5Fii86/y8CFPnKV55pKuTeeWszDqfHbuSI69zZZqtI9awnxcXajfipVQ9k2K6ET2TZZ/1DBzHOgBG3tTBBFqiMcradgKa16zyKNrvqcf1A+B8QlCFBRyseNvUSLm97myCjB/NOS52jkQaA0JptzUZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FlZaCUVh; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FlZaCUVh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784201877; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=P3n9AlLqwVjZ1NPxmow6M+93yquqP1fL1996Mg02wXE=;
	b=FlZaCUVhQE/kiLrBCfuqIjzDs707tuys9/LmYxClb9BMPbIdPD+oR5cJuAr4kRygXT/umc+p1UbR4JlMv6AkQys/D9NXLWkqeRY03pow9Pz/4pfoP3/C4/2wNJbogzoLk0SiX2I//rWMMTfxj6P8nAv8s09fvWafYsRc5WxOFog=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X7EH86i_1784201876;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X7EH86i_1784201876 cluster:ay36)
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
Subject: [PATCH net-next v4 1/3] net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
Date: Thu, 16 Jul 2026 19:37:43 +0800
Message-ID: <20260716113745.65234-2-alibuda@linux.alibaba.com>
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

