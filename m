Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FDF299927;
	Sun,  9 Aug 2026 00:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786236667; cv=none; b=VvQDjTx6oBV+Y9wf+JIHLJpnrgYY4hqk6mt2wOP4qnuUnGlLaKbCi5OggCdcdTPUF/3ettNxlbTtrIexZF0BoyEBLzRjmkNqb6AVcMfKjfiI57m8NVqMZA1V5tary8qcb/1cIl5MqRxWrAXIJ+gBv6ms+QT+LAb9xYNEMxRkPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786236667; c=relaxed/simple;
	bh=8j9CD6m8Itx2ZpsamzfTnqCF8le5/dmUln3uYzB5AQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q84RQYFhbaA0OirkEgJRl+f9hEwd5G4kgw74PIEQl/lq/K1B7o+Kn8bTcy9452ZV81aaKKJydQLJsBePfL7Y1KOLTcT90d8AMiQC1E0fK7wdRSr5HU1GSJnjmhcBRLrjY6fYuZU5j6G+fjj4ACh1PgIEmnNfSyAUiLYJrxWHPK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeKR/jbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeKR/jbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC6D1F00A3A;
	Sun,  9 Aug 2026 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786236666;
	bh=xT1Xwy/gSNdl4WFX7xH2jJ4HH2GmcqJT9bQgJ5zKDB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeKR/jbeiAN0eV0k6JPxiMmHByify70ODGvUUox3Vsz1hgeROr4myepGXFOPd7dmo
	 5SCarya9g5ne+/6OaMctw6XFXvZN0is7NZGqA0K96GZgeUj0GZaKvz3wIhovJ4YXL3
	 NBi1k0O1/5dYA6r6/aQGv2V05mQ5CIriUASa6vTY6TIEzrl4pehJmPFcppuYOnLc/0
	 FgPLlI7bU9wHl6k2wHnhL2cEObwkFdGVaAoy8k1+MSp6i0+DovvZ08IPgw65m0gC+M
	 fjuq3Ym9uqs4S/bWM3/2tDLuKZzAjdSW6c4yUdu1EkFv/S/eje5iCIIH+y0+s/kULK
	 i+eIw7wYt7OFQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net-next v2 2/2] net/rds: initialize i_conn_path in rds_inc_init()
Date: Sat,  8 Aug 2026 17:51:03 -0700
Message-Id: <20260809005103.82371-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260809005103.82371-1-achender@kernel.org>
References: <20260809005103.82371-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: William Kucharski <william.kucharski@oracle.com>

rds_inc_init() initializes every field of the embedded rds_incoming
except i_conn_path, and incomings are not zero-allocated (IB carves
them out of a slab cache).  The field therefore holds stale garbage
for incs created by rds_ib.

The loopback transport is different: rds_loop_xmit() re-runs
rds_inc_init() on the message's embedded inc after
rds_send_queue_rm() has already stored the connection path in it, so
there the field holds a live value rather than garbage, and a NULL
store would discard it.  Switch rds_loop_xmit() to
rds_inc_path_init() with the connection's single path, which is
exactly the value readers of the field reconstruct for a
non-multipath transport.

With loopback preserving the field, initialize it to NULL in
rds_inc_init() so that any future reader trips over a clean NULL
pointer instead of a stale one, and so the two init helpers
(rds_inc_init/rds_inc_path_init) leave the structure in an
equivalent, fully-initialized state.  Hardening only; no reader
dereferences i_conn_path for a non-multipath transport today.

This mirrors Oracle UEK commit "rds: rds_inc_init() should initialize
the inc->i_conn_path field".

Signed-off-by: William Kucharski <william.kucharski@oracle.com>
[achender: port to net-next; keep loopback's i_conn_path valid by
 switching rds_loop_xmit() to rds_inc_path_init(); update commit
 message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v2: keep loopback's i_conn_path valid by switching rds_loop_xmit() to
rds_inc_path_init(); rewrite the commit message - for loopback the
field held a live value, not garbage.
v1: https://lore.kernel.org/netdev/20260806072045.1092968-3-achender@kernel.org/
 net/rds/loop.c | 6 +++++-
 net/rds/recv.c | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rds/loop.c b/net/rds/loop.c
index ac9295a766b1..e6b0750bbeda 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -89,7 +89,11 @@ static int rds_loop_xmit(struct rds_connection *conn, struct rds_message *rm,
 
 	BUG_ON(hdr_off || sg || off);
 
-	rds_inc_init(&rm->m_inc, conn, &conn->c_laddr);
+	/* rds_send_queue_rm() stored the connection path in this embedded
+	 * inc; use the path init so the re-initialization keeps the field
+	 * valid instead of discarding it.
+	 */
+	rds_inc_path_init(&rm->m_inc, &conn->c_path[0], &conn->c_laddr);
 	/* For the embedded inc. Matching put is in loop_inc_free() */
 	rds_message_addref(rm);
 
diff --git a/net/rds/recv.c b/net/rds/recv.c
index cf3884d87931..f1513dfb2716 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -47,6 +47,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
 	inc->i_conn = conn;
+	inc->i_conn_path = NULL;
 	inc->i_saddr = *saddr;
 	inc->i_usercopy.rdma_cookie = 0;
 	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);
-- 
2.25.1

