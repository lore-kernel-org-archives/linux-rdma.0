Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F39CBA3D
	for <linux-rdma@vger.kernel.org>; Fri, 24 Apr 2026 04:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777005338; cv=none; b=HjefXGCwlwy+Dl92yxKqm1wcHOCzlDQJTPU3FBDI49EplUbfhyBBhjZk2ZIZDBrXs6Ru1+hvhnfRKbY20qVUnnLPnJBkhVdskcBe7HpdiCoV0WRGep3E5xZHz5rz2NV8DuA9Dsa4fSPDfj+R3o3oQuPtDvmfBXEC1eLg/zB7fP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777005338; c=relaxed/simple;
	bh=HgO9S3BkYHRQ0B11zHzgG0IkSdQcIX7pUgx+hxTXzw4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=izq5B+55bw3caH6hJwgtI4NtSpR11oUDNcSc3jrep8lTDfMicCBRmzIi+hSelwyhCZlBoE+MpQCkexKSXPbzAA2HYBI/Cf2qXbqvJViBRF061AE496lITXrY8nhz3xCajI+frBGUODhurJCaIy8MvzzQ4YP6A5Va/vKvufYFh18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hdpwCntp; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hdpwCntp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777005333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=guuZ0j/x92mkd/RiCiHkM7Z0uXWdf3eeAmssHM3KRAE=;
	b=hdpwCntp9JT9wkwMIHwnUVNbzJh0Xghj2pWIsiErlFqPDq3enKie9Vp4NxfMZjDhg8AWNF
	k0FwlG72zLX30TDai7skgAnX9KJsXqmS6snsKNI27VSk1ybvLQApOl0vR7ZiccUJz7gt+3
	M80S+cEe41selqfjde9N97F0tl34OPw=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH 1/1] RDMA/rxe: Fix unsafe socket release during namespace cleanup
Date: Fri, 24 Apr 2026 06:35:22 +0200
Message-ID: <20260424043522.22901-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since all the sockets are created in rdma link create command
and destroyed in rdma link delete command, keeping
udp_tunnel_sock_release in rxe_ns_exit risks a "double-free" if
the namespace and the device are being cleaned up simultaneously.

Fixes: 13f2a53c2a71 ("RDMA/rxe: Add net namespace support for IPv4/IPv6 sockets")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_ns.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
index 8b9d734229b2..53add78b8e3a 100644
--- a/drivers/infiniband/sw/rxe/rxe_ns.c
+++ b/drivers/infiniband/sw/rxe/rxe_ns.c
@@ -39,26 +39,6 @@ static void rxe_ns_exit(struct net *net)
 {
 	/* called when the network namespace is removed
 	 */
-	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-	struct sock *sk;
-
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk4);
-	rcu_read_unlock();
-	if (sk) {
-		rcu_assign_pointer(ns_sk->rxe_sk4, NULL);
-		udp_tunnel_sock_release(sk->sk_socket);
-	}
-
-#if IS_ENABLED(CONFIG_IPV6)
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk6);
-	rcu_read_unlock();
-	if (sk) {
-		rcu_assign_pointer(ns_sk->rxe_sk6, NULL);
-		udp_tunnel_sock_release(sk->sk_socket);
-	}
-#endif
 }
 
 /*
-- 
2.43.0

