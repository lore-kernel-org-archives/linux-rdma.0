Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722693446C7
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804167; cv=none; b=FVJ28XkM55if2ZlxislbZKH/+qYqeb6dDqYLcE34qa4XzbuNpHSnUfj2XvIVIf4Iscg8pPDX3vbwXacEpuQrYNjizXsv14bNcQfQ+YbD069+tskGozt1qk2mFE5Z126rMkbfqpnEvfstci69JOdUmQwJbHgld6GPcrWr8s8emU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804167; c=relaxed/simple;
	bh=9rxoLCRqSNVSSHw6DC195I+0fKa72nHj18A2Wle8798=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i2jVenTs7GC2DK7dMEuMBKpm89odAJFrRH3Vd7h37SvEhuDE6LPV8k5FNh9syZbat3LmxcsaD9SRrh2CSKCd72cUV5APkZP0fQEUjRLsRkKWQSkQu4VVzw1Lktob0h+Mh4H9XaHa/1GHT/0iDwD8hzLBM5bCoRWvpUuE6axQywk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VEF1xN6R; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VEF1xN6R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784804160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bgp1gURqCnNNv68p8sCgcv9sqD4HO0W1reMIZt6kLWk=;
	b=VEF1xN6RMmwKqy1WaP6GOqkOLEQZVoaWbermIcDIbiLn3ZDO0fw/jCNIINZA9ysDauNskb
	K92CC921g3aIyPur+32K2ynO17pZDXhxXwxot4xJJUKtYerwIUvM3+aBGapBIhQ6y4HuiD
	ieGrffugbF1psKApp20b28m3NVeTpmE=
From: xuanqiang.luo@linux.dev
To: netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kgraul@linux.ibm.com,
	ubraun@linux.ibm.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH net v1] net/smc: fix socket use-after-free during link group termination
Date: Thu, 23 Jul 2026 18:54:54 +0800
Message-ID: <20260723105454.87016-1-xuanqiang.luo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

__smc_lgr_terminate() drops conns_lock after finding a connection in
lgr->conns_all, but before taking a reference on its socket. The connection
is embedded in the socket, and its registration reference protects it only
while the connection remains in the tree.

A concurrent close can unregister the connection and drop that reference,
freeing the socket before the termination worker reaches sock_hold().

The race is reachable when close overlaps link group termination.
Local stress testing reproduced the use-after-free and KASAN reported:

  BUG: KASAN: slab-use-after-free in __smc_lgr_terminate.part.0 [smc]
  Write of size 4 by task kworker/3:3
  Workqueue: events smc_lgr_terminate_work [smc]
  __smc_lgr_terminate.part.0 [smc]

The socket was allocated by smc_create(), freed through
slab_free_after_rcu_debug(), and was followed by:

  refcount_t: addition on 0; use-after-free.
  __smc_lgr_terminate.part.0 [smc]

Take the socket reference while conns_lock still protects the tree entry.
The unregister path then cannot drop the last reference until termination
has finished using the socket.

Fixes: 69318b5215f2 ("net/smc: improve abnormal termination locking")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cf6b620fef05f..b4208cb186c5e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1572,10 +1572,10 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	read_lock_bh(&lgr->conns_lock);
 	node = rb_first(&lgr->conns_all);
 	while (node) {
-		read_unlock_bh(&lgr->conns_lock);
 		conn = rb_entry(node, struct smc_connection, alert_node);
 		smc = container_of(conn, struct smc_sock, conn);
 		sock_hold(&smc->sk); /* sock_put below */
+		read_unlock_bh(&lgr->conns_lock);
 		lock_sock(&smc->sk);
 		smc_conn_kill(conn, soft);
 		release_sock(&smc->sk);
-- 
2.43.0

