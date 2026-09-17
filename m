Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	by smtp.subspace.kernel.org (Postfix) with SMTP id CE4F83F4829
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 05:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789622435; cv=none; b=i2mF6QZG0LCzc4MoNEs7nj6LwdHwIrDCAVds3Tmy+n6KWY8HDYjs+AcO29nCzPPII8ONLv3l/tBbVXsS4CXVcpBf5PtK4s3J95/3E2obPrK99+dZwcTmtiSaZOwmUJYiGID1eiKQ4Xv7GPQERVWtWEFdFL0ePXSwBwClJrsB5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789622435; c=relaxed/simple;
	bh=beXvzjsecmzJjrlmyuvibryNZ2R//h/hqnTlmTvAxus=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RlzFienbmldpKjh1tJ+V2Ol0T1hyjRaeuA8cXOIL67ruylZeWFa8jgZwm6ONm5F/e3uj6n4CU/Y1xywrua0yNlLA/2xM4hXa6Yn1J5Dsuil3u/hW7FFbRZvWq7rsnQsQt+ZlVhZ4yzZrcByz0ULjj4FC0P7GmJNmN3NQY/eoKJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=CARtYZhd; arc=none smtp.client-ip=111.202.115.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="CARtYZhd"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Kees Cook <kees@kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: [PATCH] RDMA/multicast: Fix rb-tree corruption on MGID reassignment in join_handler
Date: Thu, 17 Sep 2026 13:20:12 +0800
Message-ID: <20260917052012.2181-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc10.internal.baidu.com (172.31.3.20) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789622420;
	bh=srSW4T6ozUzSG6rf3eAL+AQxv0aWJm43EF+zJxtMuHY=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=CARtYZhda6uM6lp9lyJrbBVYX8AWN6xT34bR5+12bdSFPijwfDMtn29TgAb4A2/VK
	 8M6jnlVhsECF4QuiYsonq09WM8G4Y5VhLw+I3pdclJwMzQ3m4mckV84VpPoIK8tSxX
	 ScU6YKKVPcg8XV5/I0ptAcLf9UgZJ9DLcb+fSvQ6fN5/SsXXqImIyMKN7V2XmUggZC
	 UxXN0qI0kSfJC3SwrA6DIx8oHZEcb4RyxyugMFP7Qrg9O2RgNfYthjGomEXai+8IpE
	 k6cFeHow+JJcdveNjbvFyL5rvFu68mJMgUO5tvncpbdSMlP3QHYrrC4BCF/kFrt/Dw
	 jeK+GPt76jTMg==

From: Li RongQing <lirongqing@baidu.com>

When the SA assigns a wildcard (mgid0) join a concrete MGID that already
has a group in the port table, join_handler() erases the group from the
tree and calls mcast_insert() with allow_duplicates=false.  mcast_insert()
then finds the existing group and returns it without re-inserting, but
join_handler() discards the return value, leaving the group erased yet
still alive.

When the orphaned group's refcount later drops to zero, release_group()
calls rb_erase() on the node that is no longer in the tree, corrupting
the rb-tree (a stale parent pointer causes a valid subtree link to be
overwritten with NULL).

Clear the node with RB_CLEAR_NODE() after the erase in join_handler() so
release_group() can detect via RB_EMPTY_NODE() that it is already out of
the tree and skip the second erase.  A successful re-insert by
mcast_insert() restores the in-tree state via rb_link_node().

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/multicast.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index bea7df3..f549fd9 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -189,7 +189,10 @@ static void release_group(struct mcast_group *group)
 
 	spin_lock_irqsave(&port->lock, flags);
 	if (atomic_dec_and_test(&group->refcount)) {
-		rb_erase(&group->node, &port->table);
+
+		if (!RB_EMPTY_NODE(&group->node))
+			rb_erase(&group->node, &port->table);
+
 		spin_unlock_irqrestore(&port->lock, flags);
 		kfree(group);
 		deref_port(port);
@@ -533,6 +536,8 @@ static void join_handler(int status, struct ib_sa_mcmember_rec *rec,
 		group->rec = *rec;
 		if (mgids_changed) {
 			rb_erase(&group->node, &group->port->table);
+
+			RB_CLEAR_NODE(&group->node);
 			is_mgid0 = !memcmp(&mgid0, &group->rec.mgid,
 					   sizeof(mgid0));
 			mcast_insert(group->port, group, is_mgid0);
-- 
2.9.4

