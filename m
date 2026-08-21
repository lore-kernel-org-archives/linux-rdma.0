Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B35E450413;
	Fri, 21 Aug 2026 09:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303843; cv=none; b=DKifoW7Mv0uHoGAdCPSmkxEhaIvSF8yBLH3s3V23iCe25SBlPrUlb6Wbt2cSsxWLPTNRIfp1lLPt1eLL/tTsJ/9BIeCtWcv40Q4icZtWhQf3pdAy31BUo+f/8cke2L1LI9Y8hFhUNivZss0y337PVx4xHE99HT/hnzSuZXD48cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303843; c=relaxed/simple;
	bh=biYorewS+7QfKXbMU/mFnxuBrbIxXQee4XHknl62Dj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YfqnuljE2HiWfCAkB1M6Vct1WFbChTd1M5keZegtLlAfBIeYgtzojKbqEiKu//Ytam9mvfPimV7y0j/494Eca0D+T77ETWzrsxNPuN3Jzgz6be60/s/dhaNE8EMGfiGMt/7OsovsbnPblRzlgo1IznYhZJb4hS1wQkVkUx3PUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NI68KyrN; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NI68KyrN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787303828; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=gPio7wwE0LlkzrAEQBY/XfKk1zUQAiAh0qjCT6TGUSs=;
	b=NI68KyrNsI7cnSL+/dTProc3Z0Zh8cXtW+9zqOSGancCCzWGBxK6KjR5wHjPs9c4vry43QVLQ2Q57t89aOkUDhuD9ZlhbkHwK/QZQOuhFZi3pJAunrInQ4m0l++y6YpuvTXzZ7hz8oYkJZ6eanOz624diieVs1bxlNcgcuHjZtY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X9LvYAe_1787303822;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X9LvYAe_1787303822 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 17:17:07 +0800
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
Subject: [PATCH net-next v2 0/2] net/smc: fix v2 slot clearing and reduce TX slot contention
Date: Fri, 21 Aug 2026 17:17:00 +0800
Message-ID: <20260821091702.21458-1-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains the two reviewed patches from the previously posted
"net/smc: transition to RDMA core CQ pooling" series (v4), reposted as a
standalone series so they can land independently. The remaining CQ pooling
patch will be reposted separately after these two are merged.

Patch 1 fixes smc_wr_tx_put_slot() to clear the v2 pending slot and buffer
structures instead of the pointer variables, the memset targets were the
8-byte pointers themselves so the structures were never actually cleared.
Patch 2 reduces TX slot contention by switching TX slot allocation from
non-exclusive wait_event() to prepare_to_wait_exclusive(), avoiding
thundering-herd wakes when slots are scarce.

For patch 2, uperf numbers are now included in the commit message, as
requested by Mahanta during v1 review. The short version is that the
gain tracks how often the TX slot wait path is actually taken: with the
default sysctl settings, where a link group multiplexes many connections
over a small send queue, throughput improves by 134% on the 200x1000
request/response workload and by 458% on the 1-byte ping-pong workload;
with a tuned configuration where slots are rarely exhausted, the change
is neutral (+3.4% and +1.0%, i.e. within noise). See patch 2 for the
full table.

Link: https://lore.kernel.org/netdev/20260721175309.321b6503@kernel.org/
Link: https://lore.kernel.org/netdev/20260716113745.65234-1-alibuda@linux.alibaba.com/

---
v1 -> v2:
 - patch 2: add uperf baseline vs patched throughput figures to the
   commit message, as requested by Mahanta Jambigi. No functional
   change.
   Link: https://lore.kernel.org/netdev/e16d16f1-029b-4d30-b393-2e9e525a2998@linux.ibm.com/
 - patch 1: unchanged.

v1: https://lore.kernel.org/netdev/20260806064252.39180-1-alibuda@linux.alibaba.com/

D. Wythe (2):
  net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
  net/smc: reduce TX slot contention with exclusive wait

 net/smc/smc_wr.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

-- 
2.45.0

