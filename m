Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.66
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977537;
	b=2NHa/2uINo+BXUJ5lJj/StdVg5P8rmExlGc5/DsH4GSW4DYx3i4/Dkp4UJ83YnUVc4ha
	 t1O60n1mr1EU3+8/Oy496cdZyb5iYyP9H23ciiSizdG5fpjx1e9B0bnxP84HFwNqXA1AT
	 M8ILwbdk2kr/5inVn4wcpQofVEBYKQSQCjDFRnh/9lTZPWqnCkuD/inxWtCvEXgblmNhy
	 3mgKZC4s4dG1FVrlVMUWpkmyHtVOdzUQ4eW5eG+GiIEMpuWaOyxO9vCA5hUzZp0WEao8L
	 dczB4j+N/rX3LYndMq3GlB+9LdwpW2C1S4kLx6yqkXyuChgNQ1X+h4eHAExeqU3ry0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977537;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D4Glb/phafOO2J4NO7289AZtRKHSGknHG2wh1OwjCi4=;
	b=R65m4yBmjfw42U6zFtUogU9aPRg9xlsM6Ni+RueTqNjNpuccVTu3NzLpzZwiJmx2BNIr
	 qb+f315eHF8pyRXz2F0U90j5JZWyzfMB7XZ/zpRY4JQ8kWeRltb1saU1oMAoF0uxdBlTq
	 gvCYEZJW7frHOi+6AVp29CN4hMEOINibHhpFuRd6/o4hnNV/Rg2xbpMgnFwGt5ErQHQcU
	 CS/9KK5Ru+rKLoiUoTYMm7P1ZOmOGt3zP/CDI6nsIGQYvnTYZTeoztDhK0SMbcP2vi6QS
	 jg4DCmoD0WEB7KPUuqZkYrvdpBEO2PKwsXjDMqh8ZcWteznDOZXICi+5bLYw1eLH7Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qHk+1IWp;
	arc=none smtp.remote-ip=91.218.175.66
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C98606A332
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 04:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59C98606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qHk+1IWp
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D3DeV3YkG5u10TKSbuUfjvJgZyIgkf+zdkPJkso3qVI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794977531; v=1; x=1795582331;
 b=qHk+1IWpFiYNCgRhRAelEnhQmvIkckZ8ZqfVdS5K2Vt0WdBoMSxfrgCpCETdXgMTlCFJ0euE
 oQS4GhrheBzYA+ru98V59USQr8qrUSQaao1SjIlasYWaXrR7fS9HSMS+SvLMLKrK7mQMQTxpEjO
 BWysdS1ye+jAjxR6ZOTWVllg=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9116fc7c9e291cd0;
	Wed, 18 Nov 2026 04:52:10 +0000
X-Mizu-Trace-ID: 9116fc7c9e291cd0
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
Subject: [PATCH net-next v2 1/5] inet: frags: annotate data-races around fqdir->timeout and fqdir->max_dist
Date: Wed, 18 Nov 2026 12:51:16 +0800
Message-ID: <20261118045137.174026-2-jiayuan.chen@linux.dev>
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

fqdir->timeout and fqdir->max_dist are read without any lock while their
sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to the
readers.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
---
 net/ipv4/inet_fragment.c | 2 +-
 net/ipv4/ip_fragment.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index f330d0a398233..8143162eb9f53 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -416,7 +416,7 @@ static struct inet_frag_queue *inet_frag_create(struct fqdir *fqdir,
 		inet_frag_putn(q, 2);
 		return NULL;
 	}
-	mod_timer(&q->timer, jiffies + fqdir->timeout);
+	mod_timer(&q->timer, jiffies + READ_ONCE(fqdir->timeout));
 	spin_unlock_bh(&q->lock);
 	return q;
 }
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index ef7fd61284a3f..5ac69d716da2a 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -89,7 +89,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 
 	q->key.v4 = *key;
 	qp->ecn = 0;
-	if (q->fqdir->max_dist) {
+	if (READ_ONCE(q->fqdir->max_dist)) {
 		rcu_read_lock();
 		p = inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif);
 		if (p && !refcount_inc_not_zero(&p->refcnt))
@@ -220,7 +220,7 @@ static struct ipq *ip_find(struct net *net, struct iphdr *iph,
 static int ip_frag_too_far(struct ipq *qp)
 {
 	struct inet_peer *peer = qp->peer;
-	unsigned int max = qp->q.fqdir->max_dist;
+	unsigned int max = READ_ONCE(qp->q.fqdir->max_dist);
 	unsigned int start, end;
 
 	int rc;
@@ -242,7 +242,7 @@ static int ip_frag_too_far(struct ipq *qp)
 
 static int ip_frag_reinit(struct ipq *qp)
 {
-	if (!mod_timer_pending(&qp->q.timer, jiffies + qp->q.fqdir->timeout))
+	if (!mod_timer_pending(&qp->q.timer, jiffies + READ_ONCE(qp->q.fqdir->timeout)))
 		return -ETIMEDOUT;
 
 	inet_frag_queue_flush(&qp->q, SKB_DROP_REASON_FRAG_TOO_FAR);
-- 
2.43.0

