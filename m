Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD233C552E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Mar 2026 10:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223534; cv=none; b=ZcwPhHrmnY4xvMhDJehzmnnxcos5oZwlRPZHplGdgNL8v2YE/4wiN2Me9goOU9Mk+dOFU535Mzix1omJJXwOewiqPPjUXyRswHOcmGp4QAL8DtRYHgBuM340gCHXU3EDAkzuS4HYwwQhZKFGQquyBV/KWrb18DKUB/lAh7hgB+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223534; c=relaxed/simple;
	bh=eqU/5BnJKOJlR1FdtcUXeRxD+EUuZKPFDPPHRgJzyvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X9Chrli6zEnoViDOc8/sHDG8QU9+Pi7YiClfwGeOn8yrVd1Y6qAWV3af1mXvH2oh1pjbAv7OBaJqfXkYNLy/rtie2/HEgaVOYxJMJb1l9m8jLpe+C0t9aH2odFyB1tPKfdEb1fmSCNIwFj9GwRoz7OhSYGbDETcAxBR41aQCbCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ClFaG+B8; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ClFaG+B8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773223519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TJPijmcfrfEJXCi7cp3stmP+ZVQVwHsicfzn56uoQd8=;
	b=ClFaG+B8mpPo/ijxxq2hh3niOfNzIUCOUhghsWGCMguuau412dcXGzRdG1cen4mxdgaloj
	47DmfHQIyk7GXkrHc11CK5+BecE9389o5kHRLh5W/qBGY7b4b+Hrqid4zSg3ggQrK7NHao
	tdVhOe1m6wZ0hzC5vwn+r1kyGwdFSOs=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jianzhou Zhao <luckd0g@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kees Cook <kees@kernel.org>,
	Jang Ingyu <ingyujang25@korea.ac.kr>,
	Moni Shoua <monis@mellanox.com>,
	Doug Ledford <dledford@redhat.com>,
	Christian Benvenuti <benve@cisco.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Yuval Shaia <yuval.shaia@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v1] IB/core: Fix use-after-free of ipvlan phy_dev in ib_get_eth_speed
Date: Wed, 11 Mar 2026 18:03:08 +0800
Message-ID: <20260311100313.284589-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Jianzhou Zhao reported a NULL pointer dereference in
__ethtool_get_link_ksettings [1]. The root cause is a use-after-free
of ipvlan->phy_dev.

In ib_get_eth_speed(), ib_device_get_netdev() obtains a reference to the
ipvlan device outside of rtnl_lock(). This creates a race window: between
ib_device_get_netdev() and rtnl_lock(), the underlying phy_dev (e.g. a
dummy device) can be unregistered and freed by another thread. When the
ethtool call later recurses through ipvlan_ethtool_get_link_ksettings()
into the freed phy_dev, it dereferences freed memory whose ethtool_ops
reads as NULL, causing the crash at offset 0x1f8.

Fix this by moving ib_device_get_netdev() inside the rtnl_lock() section
so that netdev lookup and the ethtool call are atomic with respect to
device unregistration. Under RTNL, if the phy_dev has been deleted, the
ipvlan device is also unregistered and ib_device_get_netdev() returns NULL
safely.

None of the existing callers of ib_get_eth_speed() hold rtnl_lock, so this
change does not introduce any deadlock.

[1] https://lore.kernel.org/netdev/94089b74-def5-4dd0-9143-1cfbc722fe73@linux.dev/T/#t

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Reported-by: Jianzhou Zhao <luckd0g@163.com>
Closes: https://lore.kernel.org/netdev/94089b74-def5-4dd0-9143-1cfbc722fe73@linux.dev/T/#t
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 drivers/infiniband/core/verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 575b4a4b200b..f16d11e7c2e3 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2046,11 +2046,13 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 	if (rdma_port_get_link_layer(dev, port_num) != IB_LINK_LAYER_ETHERNET)
 		return -EINVAL;
 
+	rtnl_lock();
 	netdev = ib_device_get_netdev(dev, port_num);
-	if (!netdev)
+	if (!netdev) {
+		rtnl_unlock();
 		return -ENODEV;
+	}
 
-	rtnl_lock();
 	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
 	rtnl_unlock();
 
-- 
2.43.0

