Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	by smtp.subspace.kernel.org (Postfix) with SMTP id AE56C21E097;
	Mon, 21 Sep 2026 03:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789960315; cv=none; b=qBYdhsn61mhpbB77MRYCMZqZHT+BnWLRvixQSmIOu53NVIoZ2XHyeu4kVxp8kcGUzjC9T0b2GHyOxTFFUQVNYmkj4X1A2MFN0k5wm1CHhu/A2C/ZAGlG39XUadj4usRCuMFMwa8EstWhkyxMXp+VNxHPlozKeiWvElY2NzbGmWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789960315; c=relaxed/simple;
	bh=BpjGcKYePEc2G1NS/E9oGYHsvHIXvtsyxyObptjXvP8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SjbT6YuWxfl9NnsQuAL7MhSXcG2eyY3f/uA9Wu9g/Gr/DIh/HmrHhjDPaod3SET8wyFUNclYfZPwtTPCXUreSUL6nzE152qTtwlFB35bZl+1/tulaQzXtUSQ/Q8l1EtZFDFXFOPboErQLf9yVzt6rp2SfDjV2XWQ/mxzGYIyvz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=iHNA0sOC; arc=none smtp.client-ip=111.202.115.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="iHNA0sOC"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Jenny Derzhavetz <jennyf@mellanox.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>, <linux-rdma@vger.kernel.org>,
	<target-devel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] IB/isert: Don't share drop_cmd_list across concurrent connection teardowns
Date: Mon, 21 Sep 2026 11:11:00 +0800
Message-ID: <20260921031100.2199-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc11.internal.baidu.com (172.31.51.11) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789960302;
	bh=XVSeyTy8qM3u0TDP3lCVovPzJO6kIvIdo6PV9n1k+lA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=iHNA0sOCnDCw9BHobo1KrG9Jt9xQULLVOAf0GIWoeXR0L4WI7WD7d8YqMqYwDCQtn
	 uqPyKrC17fgtwMfhdetYsRpJn+OfudHURg/aLCiRogciFVD9PpxbR8CfqtT75q7p/m
	 idyYsk+HlWU7zW17QwRXWbsg5HyZtHhfAYRLDENm2mHO/PF5d4BZnnKBeZ2Ug/AFsB
	 ap1ceC7oiHWFgy596nPlcWdmfrLkZak7i7igvWvQUXyvcvWS7KW/9cvGVbFETUcrLp
	 26yAqih7nPir+8npW0xWEjmfEzub9uPehgq5/71bO7t4yMNvy+b5JGFn/tKfhx8hqu
	 HIkL19XjHpyBA==

From: Li RongQing <lirongqing@baidu.com>

isert_put_unsol_pending_cmds() declares drop_cmd_list as a static
LIST_HEAD, so the list is shared across all invocations of the function.
It is called from isert_wait_conn(), the per-connection .iscsit_wait_conn
transport callback, which runs independently for each connection during
teardown.

conn->cmd_lock only protects each connection's own conn_cmd_list, not the
shared drop_cmd_list.  If two connections tear down at the same time, both
threads list_move_tail() commands into the same drop_cmd_list without any
mutual exclusion, and then both iterate and list_del/put it concurrently.
This corrupts the linked list and can double-free iscsit_cmd structures.

Make drop_cmd_list a stack-local list, matching the pattern already used
in isert_free_np().

Fixes: 3e03c4b01da3 ("iser-target: Put the reference on commands waiting for unsol data")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e69db43..efa8d7b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2583,7 +2583,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsit_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.9.4

