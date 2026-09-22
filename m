Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5296522694;
	Tue, 22 Sep 2026 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066919; cv=none; b=msSpPCzJb/zw6jrPj6r05Mr1YPLEAoXCxMIieXvrQDt6QDLOYF+HkRfl1fczUn6/GKLvoVsksk2nqgwofQzrMH3Y2AydFU4fVhmsJBkOYTv2pdZQMVQQm4PvIKDe1T+leujvbdhQDvQu9iIp7EJt5b5nhAxO/ZVFhdpLl1UJGcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066919; c=relaxed/simple;
	bh=0P2wtBTJ20cgbxtYWMS963Nv6Vkt2v8yy/cVQgexV6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=df+5+hmERWozlqmgGnIP5Ufe4NsUAdLqNxDxHv+Hu5QjmIzLgBmQ9kD2pjUpcHCg//g7W6loH/TPzdD4ORTDsNAop1xEoS17D+dSHg9Vp0N3WyRytqAqu8tDLgC2GGMmfYwgNjh3aCwxSOcEso71cToQOzAEsQyXOkynSTU8lXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMeU66vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMeU66vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5F01F000FF;
	Tue, 22 Sep 2026 08:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790066918;
	bh=WPUcupXJ2dwYdN0gYAZS3UUX1i+FQxTsoZ9ZfxrgN4A=;
	h=From:To:Cc:Subject:Date;
	b=BMeU66vrAN4VG/M4Van+kI8iEMeGG/BWoi6CRe9MqiDyL84QyUbOIB1b/gU6ul0le
	 rJx2G/tvobqRoInTIJNhKv8gbJRG7y8lXz8slExDQQ9yE92FNzX9/h0eRm10zXysFq
	 ell6wR9zf/JBRP87KskZYDcmeEqaFCRt4pgOPbJI2lF8J+lC3zlslSyj4OrskLF195
	 Fhu1naNtZyzzCFczlSG9ELiKTdWXnX1QXxPjPVHjUSNfR+LPhiGXLFymnjv8EaUNZt
	 bGJUi+yQ6qFu60jAlXj3jCjP7Ocrc9h5S0FnqhoSOEaX0vUmEK2rJFou1Pm7s6QUai
	 y9ddK1ENAk4sA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v3] net/rds: restrict the rdma_cm ids to IB devices
Date: Tue, 22 Sep 2026 01:48:37 -0700
Message-Id: <20260922084837.390414-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RDS only has an IB transport, but it never tells the rdma_cm so.  The
listener created in rds_rdma_listen_init() is therefore installed on
every RDMA device in the system, including iWARP RNICs, and the id an
outgoing connection resolves through in rds_ib_conn_path_connect()
may be bound to whichever device the address resolution picks:
rds_ib_laddr_check() only vouched for the local address being served
by one of RDS's IB devices, while cma_acquire_dev_by_src_ip() walks
every RDMA device for the same address, so a software iWARP device
attached to the same netdev can win.  The event handler then runs
the IB transport's callbacks against a device that is not one.

The rdma_cm has an API for exactly this since commit a760e80e90f5
("RDMA/core: introduce rdma_restrict_node_type()").  Restrict all
three ids RDS creates - the listener, the per-connection id and the
probe id in rds_ib_laddr_check_cm() - to RDMA_NODE_IB_CA before they
are bound, so that the listener is only installed on IB devices, an
outgoing connection can only bind one, and the address check's bind
fails outright on anything else - which makes its explicit node_type
test dead, so it goes; the check that the bind produced a device at
all stays.

With that, no rdma_cm event reaches RDS's handler from a device it
has no transport for.  The handler itself still assumes IB: it assigns
its transport pointer only for RDMA_NODE_IB_CA and dereferences it
regardless, which is the crash that first surfaced this.  The fix for
that is a separate net patch, Aohan Mei's "net: rds: fix uninitialized
trans dereference in CM event handler", and is what stable kernels
without rdma_restrict_node_type() - which arrived in commit
a760e80e90f5 ("RDMA/core: introduce rdma_restrict_node_type()") - have
to take; this patch is hardening on top of it, not a fix in its own
right, hence no Fixes tag.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v3: the changelog no longer claims a handler-side rejection exists in
    this tree; it names the separate net fix for the handler and the
    a760e80e90f5 prerequisite.  The node_type half of the
    rds_ib_laddr_check_cm() test, dead once the id is restricted, is
    removed rather than described.
v2: https://lore.kernel.org/netdev/20260919061149.250658-1-achender@kernel.org/
v1: https://lore.kernel.org/netdev/20260917074108.174262-1-achender@kernel.org/
 net/rds/ib.c             | 14 ++++++--------
 net/rds/ib_cm.c          | 12 ++++++++++++
 net/rds/rdma_transport.c |  8 ++++++++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 786f39169bc1..4ea9838d090c 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -414,13 +414,14 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 	bool isv4;
 
 	isv4 = ipv6_addr_v4mapped(addr);
-	/* Create a CMA ID and try to bind it. This catches both
-	 * IB and iWARP capable NICs.
-	 */
+	/* Create a CMA ID restricted to IB devices and try to bind it. */
 	cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler,
 			       NULL, RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
+	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
+	if (ret)
+		goto out;
 
 	if (isv4) {
 		memset(&sin, 0, sizeof(sin));
@@ -473,12 +474,9 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 #endif
 	}
 
-	/* rdma_bind_addr will only succeed for IB & iWARP devices */
+	/* the restriction above means this only succeeds for IB devices */
 	ret = rdma_bind_addr(cm_id, sa);
-	/* due to this, we will claim to support iWARP devices unless we
-	   check node_type. */
-	if (ret || !cm_id->device ||
-	    cm_id->device->node_type != RDMA_NODE_IB_CA)
+	if (ret || !cm_id->device)
 		ret = -EADDRNOTAVAIL;
 
 	rdsdebug("addr %pI6c%%%u ret %d node type %d\n",
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 6e3110a04ae6..e7014453eaec 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -999,6 +999,18 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 		goto out;
 	}
 
+	/* rds_ib_laddr_check() only vouched for the local address being
+	 * on an IB device; the address resolution below picks the device
+	 * on its own, so restrict it to the same kind.
+	 */
+	ret = rdma_restrict_node_type(ic->i_cm_id, RDMA_NODE_IB_CA);
+	if (ret) {
+		rdsdebug("rdma_restrict_node_type() failed: %d\n", ret);
+		rdma_destroy_id(ic->i_cm_id);
+		ic->i_cm_id = NULL;
+		goto out;
+	}
+
 	rdsdebug("created cm id %p for conn %p\n", ic->i_cm_id, conn);
 
 	if (ipv6_addr_v4mapped(&conn->c_faddr)) {
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a..91ff1dde26af 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -210,6 +210,14 @@ static int rds_rdma_listen_init_common(rdma_cm_event_handler handler,
 		return ret;
 	}
 
+	/* Only the IB transport is left, so only listen on IB devices */
+	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
+	if (ret) {
+		pr_err("RDS/RDMA: failed to setup listener, rdma_restrict_node_type() returned %d\n",
+		       ret);
+		goto out;
+	}
+
 	/*
 	 * XXX I bet this binds the cm_id to a device.  If we want to support
 	 * fail-over we'll have to take this into consideration.
-- 
2.25.1

