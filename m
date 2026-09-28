Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D4332917;
	Mon, 28 Sep 2026 04:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790570710; cv=none; b=WEm4G+0u5bcQUxZAgd/an5T+qGFM7PoI6Ej6mRTL4s3oU+VryFdQhoFYjAuU+jG4MfZXDZf6aSpYaPTwsUC5nFB/Qv8bdvP1+GTmrlBYUCnq3t21wtIXN/AwKV2mD1Xe5On6AWwNbbIWTjk9CuydnIn67wZ0k6FQo7xhTn8QeG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790570710; c=relaxed/simple;
	bh=uHSK027wAT+vT0fSPgfpqRQoiyjySElZ5qGWL4D+Qeg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bOcbagd7OgJtJBfyxuawbme3vOkHg8d1GdVvf98fI4NYNB7twYjFJUDhDWdnTvdzxiLm7wEZsR1Y0aUJJqZMnf20NOC5hILb8vMMQaajYchs1ZNb6T8WKuZ+R2XEb3pNSQMl2gaI3+A/yOpvZ9Yu7uftZq3WCgOWdhvWSuQldTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKQoTH6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKQoTH6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1230F1F000FF;
	Mon, 28 Sep 2026 04:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790570708;
	bh=jo/v2cmYOqcCib+9rM1pjDx6LJFXPen+BIF6agsO0vY=;
	h=From:To:Cc:Subject:Date;
	b=eKQoTH6qpk9W71liNDnHCHt4y4EAnNp9Zr1fJZlAEf7lAsfYRH/dk7Ote/lQRxXEK
	 LpUykj6gTSe8Pxq9gOaIOVqcwjFON+diMbSYu+eIZkbB7wRCymA+gsHaIv63BJC/NZ
	 SGbwnSWEOiQ2vbHdrGG3+qBFudDdEX7nlqDwfKAjJgeKuYMFQXKsJmS5cpE/Pk3GRJ
	 y+OWy6jxL3ui0UxPHRJ3yfCw2IWacKuKe4v8bdyNxzZyClYRXTRGLVirMf+BM1jUpV
	 TVOd7anktg87wV+gB/Awxkz+TihV02AysNz3l+ofWEUm2rdIbqlGDM8t5y2mUDgK4j
	 +g+gp8CE/MlXg==
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
Subject: [PATCH net v3] net: rds: fix uninitialized trans dereference in CM event handler
Date: Sun, 27 Sep 2026 21:45:07 -0700
Message-Id: <20260928044507.335883-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
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

The iWARP transport was dropped long ago and IB is the only
transport left, so make that explicit: initialize trans to
&rds_ib_transport at declaration, drop the conditional assignment,
and reject a connect request that arrives on a non-IB device.  The
rejection is limited to RDMA_CM_EVENT_CONNECT_REQUEST on purpose: a
non-zero return from the handler makes rdma_cm destroy the id the
event was delivered on, which is right for the request's freshly
created id but would free a connection id that RDS still owns for
any other event.

Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794@gmail.com/
Link: https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
[achender: reject only on RDMA_CM_EVENT_CONNECT_REQUEST instead of
 bailing out for every event on a non-IB device, so that rdma_cm does
 not destroy connection ids RDS still tracks; changelog adjusted]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
Carrying Aohan's fix forward as v3, since the v2 thread has been quiet
since 2026-08-28 and the crash is still there for stable kernels.

v3 (achender): reject only on RDMA_CM_EVENT_CONNECT_REQUEST rather than
    bail out for every event on a non-IB device - a non-zero return has
    rdma_cm destroy the id the event was delivered on, which is right
    for a request's fresh id but would free a connection id RDS still
    owns for any other event.  Rebased onto current net.
v2: https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/
v1: https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794@gmail.com/

 net/rds/rdma_transport.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a..164bd7cbe208 100644
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
@@ -82,6 +79,15 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 
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
 
-- 
2.25.1

