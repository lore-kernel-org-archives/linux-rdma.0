Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88622D595B;
	Sat, 19 Sep 2026 06:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798245; cv=none; b=rBzeUut3JmfFMM2/BJVpr0toDeYtWYQzC5haUTiJKaJ8JMJaJDyvQEgMv+VgnLpZW2ya0DF4oj2GkZCyss0i/mFYLNu5spNF2+nHVV2oT6fEpd5oDWPo4w/pIPe2Mrvilt3HWkU6cLe9UCUq+HlGPqLo6mAbt9XXGNeZe36GBJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798245; c=relaxed/simple;
	bh=Ibgxl9ldEqgAy5mvKOIhkdqx+UUVk7PH+lwc3etHZCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O41uiw4g4ze9ylFN83NdPKLctuYuJ5FCt/SPyHJgI9gDQ+Jx83iwvg1MXPgv2TQ9NhVRVMWTU43CZr2BIZcFOKdOjjXvqk0SiH8b4gvNefOpcrPEYale6+2aVjJl1lIpkFJP+U2xavBXOcflI9KYyKTj1WZfS+2pyvJh+5XU7ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GahkGHlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GahkGHlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D641F000FF;
	Sat, 19 Sep 2026 06:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798243;
	bh=uy4L0wNfa7HGJN5jW6Qg9LORi285S6cAAvWPAYZiEJg=;
	h=From:To:Cc:Subject:Date;
	b=GahkGHlvfEPqJPZfPQ5UradMlr+CTe4z1f2aLCdzKdvjnCnjmQm/ve8j8i3Z+RBRY
	 /j4SJ47WDIpTx93Z+F6Q9rWGiNMV0YjLOwMVKOk7zTfOWfS17ketMqrslO9Xhdrod8
	 MYAH6o7goj1Uxxzw23QZMGirqbGOk0CVp7jcUXvK/WxmxbqxRehlqE+cSGLa2FGTN8
	 UkMuKcTj5UlHlnujfLt7LVjQBfg6t8lDlUk98Bv54fc4M6FdT30clzuYWHM/uy0pql
	 DELAFWezsY92bYtEwk8LdSIn0yX0Nj8U5SPQpUv9QgKeJk/aUeSTjp9pzXa4rys0gK
	 hHdPzoI5X+rDQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v2] net/rds: restrict the rdma_cm ids to IB devices
Date: Fri, 18 Sep 2026 23:10:42 -0700
Message-Id: <20260919061042.250462-1-achender@kernel.org>
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
fails outright on anything else (its explicit node_type test now only
guards against a device with no node type at all).

With that, the connect-request rejection for non-IB devices in the
event handler becomes unreachable; it stays as the last line of
defence and is what stable kernels without the new API rely on.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v2: destroy the freshly created cm_id, and clear ic->i_cm_id, when
    rdma_restrict_node_type() fails in rds_ib_conn_path_connect(), as
    the rdma_resolve_addr() failure path below it does (review of v1).
v1: https://lore.kernel.org/netdev/20260917074108.174262-1-achender@kernel.org/
 net/rds/ib.c             | 11 +++++------
 net/rds/ib_cm.c          | 12 ++++++++++++
 net/rds/rdma_transport.c |  8 ++++++++
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 786f39169bc1..6d367518aafb 100644
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
@@ -473,10 +474,8 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 #endif
 	}
 
-	/* rdma_bind_addr will only succeed for IB & iWARP devices */
+	/* the restriction above means this only succeeds for IB devices */
 	ret = rdma_bind_addr(cm_id, sa);
-	/* due to this, we will claim to support iWARP devices unless we
-	   check node_type. */
 	if (ret || !cm_id->device ||
 	    cm_id->device->node_type != RDMA_NODE_IB_CA)
 		ret = -EADDRNOTAVAIL;
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 4feb0edc360c..d64dad317ebe 100644
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

