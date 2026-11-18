Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.109
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977578;
	b=5bAiePhI+ygqWDWj4AW0E6Aqi2wzsgtkuNSTlSf8bYBMhkd0Nmgvg4RQvizk/kyalH7N
	 XOyrZLUOK4lBgrBU2J9KPg3WP86nwglosgSoeEVoQHTIbTP3Q89pe54/AxMCkWg451F8M
	 r4Xn8U3bUBI+nPTFmxByWArw52DmaRwEakmQazYM6EUTHeUIQ/Fcr3AiiLGMZoLSdLa7A
	 9RiuvI9ICW0YLRUqOBSRBVLEGHX9ao3aPk9QcXRu4aPOoG89HhMZZL3G4e4M7rHHiWbbR
	 RvCKCCG9sJCjsVJVmpTWAxG6dJ/3rcV3hR6za9zRfy6LnDLw4VLxNOb/YrAoGCfUCeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977578;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oofxtfkkh73E5bUkbZDiScgw+5AH2SAOWNFSk9Rc5Vc=;
	b=Z7SjfCveaqbrIixxFjjKw1SwlJ5CI1yiB4nubJvtaAMoVXzTBLNz15K6d3Zd/f6oqHaZ
	 9u7iNxYT3iqkV8Qz9Rv7QW5KWg5qv/nLA9TDb7twke8GwqYJ0wIiGE+vJDgkBnU2TMQlB
	 EApsoKO1z2dw1OZWN6Xbdq1xz7WdABpoofgHoJEz2TVJBTh1hwFX900cSxUJJJCYQ3vk/
	 cOZc3zoR9MVUpOsNQQZFAil2kRNV9kUf/MSr7ZX3eVKo0N4Hr7hJ3u9O9zVO2PCjL8/ia
	 jzAb+Q+7bCTfVJ+HStnrlceI96GUrBiboTdNtuyGBNE0X1Gv2AbRdD7NtC8B3g6/igQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="wPURTbh/";
	arc=none smtp.remote-ip=91.218.175.109
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411FD606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 04:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 411FD606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wPURTbh/
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kAIv7118emGvagKignUXPaY+Bvvg+mULTSVlWAPkJog=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794977576; v=1; x=1795582376;
 b=wPURTbh/L1Hp3DXRgxXiHIhlkmiJHJ8MzQ8J+QgKW8a3AohOIcC7s0BuPZMtIyFSqfSvk/zo
 7bUQbBQNx4St1zyYsQy9VD1ALe4WxnylBSvF6/PpLR+jB/pfOJnJ14WNNf3SUDel2Sz4T3iujqf
 VgV3tk3/4EVHJOD9z+gvgrT4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 84ad6aedd69ecd07;
	Wed, 18 Nov 2026 04:52:56 +0000
X-Mizu-Trace-ID: 84ad6aedd69ecd07
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netdev@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-s390@vger.kernel.org
Subject: [PATCH net-next v2 4/5] rds: annotate data-races around core rds sysctls
Date: Wed, 18 Nov 2026 12:51:19 +0800
Message-ID: <20261118045137.174026-5-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118045137.174026-1-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

reconnect_min_delay_ms, reconnect_max_delay_ms, max_unacked_packets,
max_unacked_bytes and ping_enable are read without any lock while their
sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to the
readers.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
---
 net/rds/recv.c    | 2 +-
 net/rds/send.c    | 8 ++++----
 net/rds/threads.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 00ab60f2d9969..daccbfc8cb8a2 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -370,7 +370,7 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 	}
 	cp->cp_next_rx_seq = be64_to_cpu(inc->i_hdr.h_sequence) + 1;
 
-	if (rds_sysctl_ping_enable && inc->i_hdr.h_dport == 0) {
+	if (READ_ONCE(rds_sysctl_ping_enable) && inc->i_hdr.h_dport == 0) {
 		if (inc->i_hdr.h_sport == 0) {
 			rdsdebug("ignore ping with 0 sport from %pI6c\n",
 				 saddr);
diff --git a/net/rds/send.c b/net/rds/send.c
index f38967f65af18..66e75a382bcc7 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -87,8 +87,8 @@ void rds_send_path_reset(struct rds_conn_path *cp)
 
 	cp->cp_conn->c_map_queued = 0;
 
-	cp->cp_unacked_packets = rds_sysctl_max_unacked_packets;
-	cp->cp_unacked_bytes = rds_sysctl_max_unacked_bytes;
+	cp->cp_unacked_packets = READ_ONCE(rds_sysctl_max_unacked_packets);
+	cp->cp_unacked_bytes = READ_ONCE(rds_sysctl_max_unacked_bytes);
 
 	/* Mark messages as retransmissions, and move them to the send q */
 	spin_lock_irqsave(&cp->cp_lock, flags);
@@ -380,9 +380,9 @@ int rds_send_xmit(struct rds_conn_path *cp)
 				set_bit(RDS_MSG_ACK_REQUIRED, &rm->m_flags);
 
 				cp->cp_unacked_packets =
-					rds_sysctl_max_unacked_packets;
+					READ_ONCE(rds_sysctl_max_unacked_packets);
 				cp->cp_unacked_bytes =
-					rds_sysctl_max_unacked_bytes;
+					READ_ONCE(rds_sysctl_max_unacked_bytes);
 				rds_stats_inc(s_send_ack_required);
 			} else {
 				cp->cp_unacked_bytes -= len;
diff --git a/net/rds/threads.c b/net/rds/threads.c
index 639302bab51ef..115fcff0a5b13 100644
--- a/net/rds/threads.c
+++ b/net/rds/threads.c
@@ -137,7 +137,7 @@ void rds_queue_reconnect(struct rds_conn_path *cp)
 
 	set_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
 	if (cp->cp_reconnect_jiffies == 0) {
-		cp->cp_reconnect_jiffies = rds_sysctl_reconnect_min_jiffies;
+		cp->cp_reconnect_jiffies = READ_ONCE(rds_sysctl_reconnect_min_jiffies);
 		rcu_read_lock();
 		if (!rds_destroy_pending(cp->cp_conn))
 			queue_delayed_work(cp->cp_wq, &cp->cp_conn_w, 0);
@@ -156,7 +156,7 @@ void rds_queue_reconnect(struct rds_conn_path *cp)
 	rcu_read_unlock();
 
 	cp->cp_reconnect_jiffies = min(cp->cp_reconnect_jiffies * 2,
-					rds_sysctl_reconnect_max_jiffies);
+					READ_ONCE(rds_sysctl_reconnect_max_jiffies));
 }
 
 void rds_connect_worker(struct work_struct *work)
-- 
2.43.0

