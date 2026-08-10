Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59985345725;
	Mon, 10 Aug 2026 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786341394; cv=none; b=k5aDCUOwWYD40fAXnFN8/v/v70Y97cqoEnnKtBwpQAaa8ziZY5obpIa2WolibbYqqtVQEm3+1Ey2cuVWj0OAx2Z8z2nV7+bQkwspk8zDpq3qTWn4H09t2OVF7aQkqCbYfAl7WZoSl5MMP9OJqui4dkL8eaXwKcbEBP+NYH1THWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786341394; c=relaxed/simple;
	bh=KTjh8lAlmcoYZ75rcUMwLWnHs/49bhWdFxtitsrDals=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kbwVyVeU8TGkZyRtWiOBPJCZTZMh3p+eQAoPOXzGGG8aE2aeFjHPxsbXyACDTdG9ipcvmhlu1onFhQWb2un9bG92MnilTSAWr7oiLrdpoqYW7cEvhLSDwr9wYj3pic79oaoRcfMwEfO9tI60W1RJqIbFrr8/ofd2+kxEtrzC2II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7bdwIZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7bdwIZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F211F000E9;
	Mon, 10 Aug 2026 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786341392;
	bh=BncztfFJGzxfXeWtPbVlIXbET/3khWP8Izjtjfnd1Lc=;
	h=From:To:Cc:Subject:Date;
	b=S7bdwIZ3ygeDDWp78HlsROiJp++wsEL+/YqtGokRSx9CATYRt97nQnFQat/TkJ8fb
	 23ZO3591UlXVZIOH8l3TwnsUnHBagv2pJ+hfcT0wklOR8k19Mm2Jg+Sbm0Y+4jF33G
	 qKj32Z6vvPzdInhVrVMlV5V4Jveh+Ix6jIBKk4B0odnLwAW0DXPxbnEY75eVqDCwXs
	 7Su/2Wy9HfUVt2AMdM+Ixt3OD1dRNZCcvNQjSgLxwBI9uRSKPjJ1OYcnquohBqO4Hf
	 RVPsEqRTM8fOLPHqvusUY0RgzGyBpmuR9uvlCgNfxyVjW/8Gd4AdfBhfmd6FSCjGfG
	 uhVz3/iD7bCGg==
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
Subject: [PATCH net-next] net/rds: clear i_rx_lat_trace in rds_inc_path_init()
Date: Sun,  9 Aug 2026 22:56:31 -0700
Message-Id: <20260810055631.299558-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit that introduced the receive-path latency trace added the
clearing of inc->i_rx_lat_trace[] to rds_inc_init() only;
rds_inc_path_init() never got it.

That asymmetry matters for the one caller that reuses memory:
rds_tcp_data_recv() carves its rds_tcp_incoming out of a kmem_cache
with no zeroing and no constructor, so after rds_inc_path_init() the
array still holds the timestamps of whatever message previously
occupied that slab object.  No stale value is user-visible today -
every message that reaches the socket happens to overwrite all four
slots (RX_HDR at allocation, RX_START when the header completes,
RX_END at delivery, RX_CMSG at recvmsg time) before
RDS_CMSG_RXPATH_LATENCY reads them back as deltas - but that is a
property of the current writers, not of the init contract, and a
future trace point or an early-exit path would expose another
message's timestamps to userspace.

Clear the array in rds_inc_path_init() too, so both init helpers
leave the inc fully initialized.  memset is the form the clearing
already takes on the rds_inc_init() side since commit 1635bb548f84
("net: rds: use memset to optimize the recv").  Hardening only; no
user-visible bug in the current code.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/recv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index f1513dfb2716..6204e577a90a 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -66,6 +66,8 @@ void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
 	inc->i_saddr = *saddr;
 	inc->i_usercopy.rdma_cookie = 0;
 	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);
+
+	memset(inc->i_rx_lat_trace, 0, sizeof(inc->i_rx_lat_trace));
 }
 EXPORT_SYMBOL_GPL(rds_inc_path_init);
 

base-commit: 4fa4977a0d900f936bcae5cd2c510be5554e8dd6
prerequisite-patch-id: ac6fbdba01fa66022d37321e8270d4f9f9fb834b
prerequisite-patch-id: 45883e7cfa080a48b943e4ba58e0da22767c4c01
-- 
2.25.1

