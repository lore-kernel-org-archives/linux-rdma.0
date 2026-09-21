Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626452E4257;
	Mon, 21 Sep 2026 21:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027430; cv=none; b=T2C096pk6ZIQ3c8w0j4vbgdjrb4n/xsd1Oq566vmcATqjXFIBQyOdrjFyDF8a10/nl0pDnZiRiYb+LIKx/Gcc8KhWXkzVbdiGEqzGyc7bfbXSIX+iKTIjyMwLnzWjaU4vTqhVzg77VrZ1beHQUYplv3DRx2ndq9qeXZHK/Mp6YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027430; c=relaxed/simple;
	bh=ZXFuSexSjcaO9C2kLRzh0bAaTuReuOintSOEo4XTOA4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZlYmk1HtmfoxKMrZQGuxGT1wbePbGtN217+Yji67WkFpUmTSBAQKoC/y/pgWROQiMD4Gj1ZW8E9HkGNxTLDJRqhBDxbFdH2mpPfLMEExsP6RcRay9Ac/Yr9NfTD2LPxdQm05m8GLi9MShWP1X6Me6gi3kXa19BvV38ffeFBLdRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1es6Gk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1es6Gk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC3C1F000FF;
	Mon, 21 Sep 2026 21:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790027428;
	bh=kjOeNXulRANbAxNBOQMOOOfsTuV70e2AmehNq3O70Qc=;
	h=From:To:Cc:Subject:Date;
	b=U1es6Gk2f5PFvUXE+AfrcvrAXxqacsbTjPjdj9W6LJRCbIeNBKZiDovuIBTbYt9g6
	 03rzRq12OXQF7V1CxMecidfwp3R6pl2NFS7BfMamSWnxUzBxIgwMcowbddmx+H40Pz
	 lSug1L4POS4DaRCZufgx8FTjpYImDJKGnT42PZwyWBfiBIREe0MKIe0y/Cq48WifV+
	 jF5G260A7nFZ/qaCSy/TWTBuHJXfMfQ/vor0+zlZJX5n8Mav2V02A4BNoEYtzalKsc
	 5xPS8d/pZJ6ozKKpNZmDZ7qkVaATy+qttsNWqOnxBIYeoxizhdAlGudKZzdxG4dATE
	 MWJy07/spOEhQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net] net/rds: size a connection's path set by the transport it ends up with
Date: Mon, 21 Sep 2026 14:50:27 -0700
Message-Id: <20260921215027.174657-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__rds_conn_create() computes npaths from the caller's transport before
it decides whether a connection to one of the host's own addresses is
to be handled by the loopback transport instead.  That substitution is
what an RDS/TCP socket sending to a local address gets, and after it
the path init loop still runs for the TCP transport's RDS_MPATH_WORKERS
paths and allocates an ordered workqueue for each, while
rds_loop_conn_alloc() only ever provides transport data for path 0.

rds_conn_destroy() sizes its teardown from c_trans, by then the
loopback transport, so it visits path 0 only - and
rds_conn_path_destroy() would skip the other paths anyway, since it
returns before destroy_workqueue() for a path without transport data.
kfree(c_path) then drops the last pointers to seven workqueues.  That
repeats for every such connection, on every netns teardown or module
unload, and every distinct local destination address is a separate
connection.

Recompute npaths once the transport is final, so that creation and
destruction agree on the set of paths.  The c_path array stays sized
for the caller's transport; the unused entries are freed with it.

Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueue")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index b6c4beb50eaf..c752a8623cfc 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -276,6 +276,12 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 
 	conn->c_trans = trans;
 
+	/* The transport may just have been swapped for loopback; size the
+	 * set of paths - which is also what rds_conn_destroy() tears down
+	 * again - by the transport the connection actually uses.
+	 */
+	npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
+
 	init_waitqueue_head(&conn->c_hs_waitq);
 	for (i = 0; i < npaths; i++) {
 		__rds_conn_path_init(conn, &conn->c_path[i],
-- 
2.25.1

