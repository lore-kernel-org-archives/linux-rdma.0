Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF07489886;
	Sat,  3 Oct 2026 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045251; cv=none; b=rDNndc8CHzrj5Db65k8JCVxjkwErpYpWUtoLA2JG8Z9/YZNv2U6jDAPG21YmhkxjOil5fQpe5Uw5BQSajysPJy3qythujzt4oZ1ShCpnzIMOAWkgAfeb5ojb84Z8Al4vGq1jOE9QsA3v8JYCQ+x2Jd3PWJwot2ayjAXwxXnir08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045251; c=relaxed/simple;
	bh=E1hNeV82HDK3goxiw1FusSBVLQK4+pfT6niLrS7Bh1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fwtjhIFujOwiw3FsXOlCmsdOp0SlQ6BwI1krAhAY5cILZRFhXfvSfy2EXygW0vciIgQpjHfozk+4Q+wo3Tp8hnjMGg6h9pu+Vi/cWCYZ4ogsgh3i7QmptGLWRPGxA1kCDYLOXSLrcqInf1sZPpe3TZbpSC6fjBSYdKFEWf21yF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KssdhpjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KssdhpjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28ED1F0089E;
	Sat,  3 Oct 2026 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045250;
	bh=Ze79KNEF88HEPIOSJKRWuuSikhGmKGMI/i57XL0c2is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KssdhpjDgY9iKgYvaa1WA6BguX4rxTOjG1ugSce58z8Yj6A6F52xT2T4aMiselmEz
	 3CfXqjKeKXpD3JEeG4+zykDeY5L/P8e77IUsbt91gD5K33c35yGH47H7Pq4PH6wGeq
	 2n/QJ6OhMofQpYKCdPm4m+pRQ+zKvkLb+ZWHbgo4j5PyEzxWdznLi3Fk5KLuADmvAE
	 sTubWNk3HN4+qVLRjkoQcVTFS20MCyk9jc2BvD1Yd+xiV2j93TgoRm5vPg+/aj/cIk
	 dsFnMUQ+QitqyqL9AL1p/xmFGx0Ma8TsyKoEtNgytGVb6rvqMm0vGMRsQLat38ahRN
	 9EcDUOBFmUpug==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	ljp1205831794@gmail.com,
	henrymei@tencent.com
Subject: [PATCH net v4 1/2] net: rds: fix uninitialized trans dereference in CM event handler
Date: Sat,  3 Oct 2026 09:34:07 -0700
Message-Id: <20261003163408.250568-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003163408.250568-1-achender@kernel.org>
References: <20261003163408.250568-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

rds_rdma_cm_event_handler_cmn() assigns trans only when the RDMA
device is an InfiniBand CA (RDMA_NODE_IB_CA).  On any other device
type, e.g. an iWARP RNIC such as siw, trans stays uninitialized, but
the event switch dereferences it: unconditionally in the
RDMA_CM_EVENT_CONNECT_REQUEST case via trans->cm_handle_connect(),
and (with a connection context) in the ROUTE_RESOLVED and
ESTABLISHED cases.

An RDS listener on an iWARP device therefore crashes the kernel as
soon as a connect request arrives: with CONFIG_INIT_STACK_ALL_ZERO
the wild load becomes a NULL dereference at offset 0xa0
(&trans->cm_handle_connect) in the iw_cm_wq workqueue.

GCC masks the bug in default builds by folding the uninitialized
load into &rds_ib_transport; Clang-built kernels take the real
uninitialized path and oops.

The active side can land on a non-IB device too: the id that
rds_ib_conn_path_connect() creates is not restricted to a node type,
so rdma_resolve_addr() binds it to whichever device serves the local
address, and an iWARP RNIC on the same netdev qualifies.  The crash
there is different: resolving a route on an iWARP id never fills in
cm_id->route.path_rec, and the ROUTE_RESOLVED case writes
path_rec[0].sl before it calls into the transport.

The iWARP transport was dropped long ago and IB is the only
transport left, so make that explicit: initialize trans to
&rds_ib_transport at declaration, drop the conditional assignment,
reject a connect request that arrives on a non-IB device, and drop a
connection whose address resolved to one instead of resolving a
route on it.  The rejection is limited to RDMA_CM_EVENT_CONNECT_REQUEST
on purpose: a non-zero return from the handler makes rdma_cm destroy
the id the event was delivered on, which is right for the request's
freshly created id but would free a connection id that RDS still owns
for any other event.  On the active side the id stays ic->i_cm_id and
the connection's shutdown destroys it, so that case returns 0.

Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794@gmail.com/
Link: https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
[achender: reject only on RDMA_CM_EVENT_CONNECT_REQUEST instead of
 bailing out for every event on a non-IB device, so that rdma_cm does
 not destroy connection ids RDS still tracks; drop a connection whose
 address resolved to a non-IB device before a route is resolved on it;
 changelog adjusted]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/rdma_transport.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a..09cc2ba23570 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -52,7 +52,7 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 {
 	/* this can be null in the listening path */
 	struct rds_connection *conn = cm_id->context;
-	struct rds_transport *trans;
+	struct rds_transport *trans = &rds_ib_transport;
 	int ret = 0;
 	int *err;
 	u8 len;
@@ -60,9 +60,6 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
 		 event->event, rdma_event_msg(event->event));
 
-	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
-		trans = &rds_ib_transport;
-
 	/* Prevent shutdown from tearing down the connection
 	 * while we're executing. */
 	if (conn) {
@@ -82,11 +79,32 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
+		/* Only the IB transport is supported, but RDS listens on
+		 * every RDMA device: reject a request that arrived on any
+		 * other kind.  A non-zero return has rdma_cm destroy the
+		 * request's id, which is what we want here and only here.
+		 */
+		if (cm_id->device->node_type != RDMA_NODE_IB_CA) {
+			ret = 1;
+			break;
+		}
 		ret = trans->cm_handle_connect(cm_id, event, isv6);
 		break;
 
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		if (conn) {
+			/* The address resolved to a device RDS has no
+			 * transport for.  Do not go on to resolve a route:
+			 * an iWARP route leaves cm_id->route.path_rec
+			 * unset, which the ROUTE_RESOLVED case below
+			 * dereferences.  Drop the connection instead; the
+			 * id is still ic->i_cm_id, so return 0 and let the
+			 * shutdown destroy it.
+			 */
+			if (cm_id->device->node_type != RDMA_NODE_IB_CA) {
+				rds_conn_drop(conn);
+				break;
+			}
 			rdma_set_service_type(cm_id, conn->c_tos);
 			rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
 			/* XXX do we need to clean up if this fails? */
-- 
2.25.1

