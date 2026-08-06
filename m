Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08AA3876A7;
	Thu,  6 Aug 2026 06:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785998584; cv=none; b=oHoWUqqXcNBDj8t9GclRf8e2cC2rZEaWUO6bA5DzlV3Od/jAqgkTbYq6GCgWeSQUOs71/70JzesHMGz5ubKNc/JmpgUzopZ3KZlTMQbu6DSsEKr4Ja6iMaO1G/HSz+1x0094yra35rhr1lGLYiV3kpC9uI7kOizK1Zja4/zaRrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785998584; c=relaxed/simple;
	bh=5B8ZH2bzcVnNLb2eCDMRjRYjXcOtFj/PswzfEYTQgfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z6Ds/d1sUJfI09S1CrQrS7Cco4d5cvEU6bK3danNm4xp4zB3u03It2/mlu8UytlSG0V58PnPaqAQ5HSfptdzzyziNgOLOgLdPhGGkVEMpYeZvCv56BeBqy3z/QWIyyTBEVQ9vo0J5iDWMexfFpr6y6GfprWjNzM/hurP1G+E9TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dZcLgjRD; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dZcLgjRD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785998577; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Y8XomnGQjYj2vGTkl2kHwptn31v0sHIj0Bcicxtou2k=;
	b=dZcLgjRDQdfxaSN7BBlf6P5MsMpCiP5iwj5+rK/WgRJzEXqbxQPyiU57v54HcDr/f2AUgTuecR2sWbu6rcxJYrchy4+nktiGkTcUhKBRceDHsZJ9A1Kgyeq+2ftMV0JNF9PdT8pSaDHLQAUnuUQdSsROcWztOYD+OMeXL4kDIp8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X8TC9qs_1785998572;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X8TC9qs_1785998572 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 14:42:56 +0800
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
Subject: [PATCH net-next v1 0/2] net/smc: fix v2 slot clearing and reduce TX slot contention
Date: Thu,  6 Aug 2026 14:42:50 +0800
Message-ID: <20260806064252.39180-1-alibuda@linux.alibaba.com>
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

Link: https://lore.kernel.org/netdev/20260721175309.321b6503@kernel.org/
Link: https://lore.kernel.org/netdev/20260716113745.65234-1-alibuda@linux.alibaba.com/

---
This is a repost of patch 1/2 and 2/2 from the v4 "net/smc: transition to
RDMA core CQ pooling" series, with no code changes. Version numbering is
restarted at v1 since the series is now standalone.

D. Wythe (2):
  net/smc: clear the correct v2 slot and buffer in smc_wr_tx_put_slot()
  net/smc: reduce TX slot contention with exclusive wait

 net/smc/smc_wr.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

-- 
2.45.0

