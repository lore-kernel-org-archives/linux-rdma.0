Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268147A88D;
	Thu, 17 Sep 2026 07:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630871; cv=none; b=t3qhdjgCRneQO96BEMHjHzCL082/W7FoJFNcuVZRte4yKZCPcPlHTzd5FrC/pLBo2RiW3rFGU90KY87g0XcJqky7xE0lpDUhOOk+MFWSZ9xgVxJd98bieVPjk1JCFWtV0NLtA8YCoPgux+RhKj5LIHbWmLtdZ/d/R5VwZ/cm5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630871; c=relaxed/simple;
	bh=l5+ksHVrfdyqxhledb8ghljWsiXAkyRtQ7zJYE6MNYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qtNzZTWqBIkMjxVH2bPMt2p3btAHBZaGC3alJaszWrKpzBjnT38e2uHnnK992iUhQBa8PL00R49lMdDcb6Rjy9IsQhXbHvZTengs3g/dtloBvyyOnVmS8PbFhPIKRcFWv0TcfYF5MFkqi0of804M9vFArIZHo82A0SCA9K0o+Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuZ/7q1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuZ/7q1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6BF1F00893;
	Thu, 17 Sep 2026 07:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630869;
	bh=hMTJp6lkhsWldonH2TVjtktXUT7se4eSz/mgRPX6dp0=;
	h=From:To:Cc:Subject:Date;
	b=CuZ/7q1d9G9Dpq8VwZARD/soOvx/rVBkAy5MDD5j7ZO3JrGITJHmoD3aTv5o1L544
	 bpkCNa5E/aEWAJ/UdGaF5XYvAaFV9vF849tKUC9z03dYS0AaE2IoLPPdU7yvV/nQlz
	 FKgALSSsT6qegnSSWMpD7QHJIfMMSOMBXPjzi1z+RClcLD3z0MqWFrsNNW4RuVUUl1
	 kxyH2l/leY1zGGWkOgx5kjBoOXaVBFWENwJ5EyLVMA1cT6FHqfv2Q52RbeVUsmLnt+
	 MENja5ExqYKYvJCu28YGcdA118wE2HNjv9ZEfMIh43m9yUOvHFtNLKQDV6+pz/nbZg
	 2yzcrzIUHq6Qg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next] net/rds: restrict the rdma_cm ids to IB devices
Date: Thu, 17 Sep 2026 00:41:08 -0700
Message-Id: <20260917074108.174262-1-achender@kernel.org>
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
 net/rds/ib.c             | 11 +++++------
 net/rds/ib_cm.c          | 10 ++++++++++
 net/rds/rdma_transport.c |  8 ++++++++
 3 files changed, 23 insertions(+), 6 deletions(-)

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
index 4feb0edc360c..a859c252fd9a 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -999,6 +999,16 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 		goto out;
 	}
 
+	/* rds_ib_laddr_check() only vouched for the local address being
+	 * on an IB device; the address resolution below picks the device
+	 * on its own, so restrict it to the same kind.
+	 */
+	ret = rdma_restrict_node_type(ic->i_cm_id, RDMA_NODE_IB_CA);
+	if (ret) {
+		rdsdebug("rdma_restrict_node_type() failed: %d\n", ret);
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

