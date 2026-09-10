Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA98459AE1;
	Thu, 10 Sep 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037098; cv=none; b=ZzhB5m3MBcIh8qTTjrnSJvZvJHIiNIKDgRNiO3vdIFPUytYE/6IS7P4yt5I27NHMqHbUG9ABsiukVoIsLfraXvr8AkxvgjnNwLjagwD4C2JWt/1Z6UPP0LmvPAgHyYqxUDVtFjDTo3xZoSVqyAR3DSyiFnBYuhT3xiHOjHWTveE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037098; c=relaxed/simple;
	bh=wTt/8lEffTdt4Ok3xQSHtowMcvzEU4ka+qft5bmtpPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=upfTEVQ6XWcYtprfTFlBKL5+gSn62PzbSblQNxSmYwSAIw2YVK6VX4hSgNeTLSfOw5ViOML7EVboDjG6oVibJK9nxYWu4bbgQ+4Sk4ewH5vZmwJglV5Bo0buUnQxkZ03XU0j+wldeyVZ0jLlfmGBuLlv3gDr5NxHOKFW4I6y02g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EI0tR3ec; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EI0tR3ec"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789037089; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=IVoYlgnQkXtvQuGLmiBxSk2oGphfizmfATmoBP0wAhc=;
	b=EI0tR3ecO6kJzwwufrlg7eoi2ePpsZKPVQxh8Z8gZyJ351W7g6ikfyPj7eQTlvaO8aiqquhikzCkUiiI/S7XbwLKfJf/vJw0L4VxFts98ol88LOP1PGpQw83TW6PN7CHrTfwEK9W6vyRpb2vTcyVZNiHBd9xl7fssQK2Ggky91s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAhM9N3_1789037086;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0XAhM9N3_1789037086 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 18:44:48 +0800
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
Subject: [PATCH net-next 0/2] net/smc: fix v2 slot clearing and reduce TX slot contention
Date: Thu, 10 Sep 2026 18:44:44 +0800
Message-ID: <20260910104446.41423-1-alibuda@linux.alibaba.com>
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
Link: https://lore.kernel.org/netdev/20260821091702.21458-2-alibuda@linux.alibaba.com/

D. Wythe (2):
  net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
  net/smc: reduce TX slot contention with exclusive wait

 net/smc/smc_wr.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

-- 
2.45.0

