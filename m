Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A86280CFB
	for <linux-rdma@vger.kernel.org>; Sat, 25 Apr 2026 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777097085; cv=none; b=HhuqwUjOIDUltG1HaWY6mjUZxwvUqtKikwN1ljr9Jh9WrveNY3KKr1RY8GQyHCIPymTFoVAsrVwOcgHPT+yrRFL2Yezdcm/B+mpJfbsvnFAYRNUuyxVSDlV9IpApR93TY3HriZSRAQTCFeaRNi1Zkzvo7lsHkH1RCBVhuLn9Duc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777097085; c=relaxed/simple;
	bh=nVP7a4u4kcoKhc95G5SJm+ut0OW6aixMLGxLSXddiGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bXKrf/Lje4aVt6XMUopPMFA5OJ4Ot36Q01MHR0QBF/zADs2O+13wQySFvheHK/utJTFL1SKpfngZztB9jsqtEPSzdrdA5IeLa0+v/9n2z3kt4L4QEgi4QIMTpUy5cUJBEmFdrXV0ZEZhCA7z2ug25LU7cOtSWR9qnkSTBC3itag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fh5A37ap; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fh5A37ap"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f9aa52c92so8864919b3a.1
        for <linux-rdma@vger.kernel.org>; Fri, 24 Apr 2026 23:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777097083; x=1777701883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wG5jMzgODlf9E7FvlCb3oQpSui4d6D8ekFhYY5Msm4A=;
        b=fh5A37apedI+VMTBZfJIgN0jbI9z1ymjUoglBDNi4kAbGxGuteFKua2lt9aeIEblsk
         FFajpAaKA7o410M6Pdw4lPIHbEsa/T40ly+BGQyVkUIBNzFFKyXvQkAdgOl4aBofkhFH
         DwkbLDgmV+6EVFsRktSwWe9taYO5L003Rv70PcfVts5whmsRn5NwOaegZDaCLec/KSUw
         Gx1dw6cf35rXb3SqVmbLK4sCO9IcFiUDYjPua1YOXpvAOJ8WNdyjboKfL8lKQScszgD4
         hBMvLSm8vQjZGE66pBcUoq9sD7BFNcSJ7WtzvIcXXKvlJ+l32yO/vCrXyLHbPjRSX+y4
         9DSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777097083; x=1777701883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wG5jMzgODlf9E7FvlCb3oQpSui4d6D8ekFhYY5Msm4A=;
        b=iSqAH2VNsGoQ30nZD9WgN41ZB+PLsIdMRXMC/BfKee3Kn+2GY5/mDYH5xzVd55mhLi
         0hwm4HDgVqSfk75JzKPkFS+zqJ9Zwj+QbSZvsX6Pn94GwamAQ1vb7FzeK4E3uOlLzdb7
         cDJMjtXLlr4fR1rQNRs1jWPIc4gel8XoQVuonLt0wKrPy4guF8Bw1vA74sVtnPv35SPk
         JYdujrJ0Zs0J8Z6Kp8PGM990Zk3/jCljfJFYpezH3/EaDmuOt0f9wFsmQ9ebWktQceMX
         I64eS+A+NHI5JoVoJ5tpJk6eUGrcLFllljTJfGYhPEUNZ5zxC75LzkaFjbXCqK41XSsL
         NKag==
X-Forwarded-Encrypted: i=1; AFNElJ9glYQcYdo2w59skyYeV171pkFqoTlBYojPr/rq2KgM3Bn/g5B6eAIJ8PjTPoaRufGEpMZ5JB8z5Cbc@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+z5bDLKjbHqFFnY5VH6Xhshi5koSKezuEeC3g7tbAFrxSKZCR
	POqWwvGw8ujxjHEI71RUO/bFj9u5iSev3/SNXuOHx2ABOz7Z3LdOYcpf7oAJnF4bTnBk+2vjoCZ
	57bDZrw==
X-Received: from pfbfc32.prod.google.com ([2002:a05:6a00:2e20:b0:82f:5eca:2b2d])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4088:b0:82c:6d88:2a8e
 with SMTP id d2e1a72fcca58-82f8c836788mr39038563b3a.20.1777097083160; Fri, 24
 Apr 2026 23:04:43 -0700 (PDT)
Date: Sat, 25 Apr 2026 06:04:14 +0000
In-Reply-To: <20260425060436.2316620-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260425060436.2316620-1-kuniyu@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260425060436.2316620-3-kuniyu@google.com>
Subject: [PATCH v2 2/2] RDMA/rxe: Fix up RCU usage for rxe_ns_pernet_sk6().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

rxe_ns_pernet_sk6() is fundamentally broken.

rcu_read_lock() only silences rcu_dereference() splat.

The returned socket is no longer protected, and it may be
freed during ip6_dst_lookup_flow().

Let's call rxe_ns_pernet_sk6() and ip6_dst_lookup_flow()
under RCU.

Fixes: f1327abd6abe ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 11 ++++++++---
 drivers/infiniband/sw/rxe/rxe_ns.c  |  7 +------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 9080d4c893a1..8fca5c24c8b1 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -133,16 +133,21 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 					 struct in6_addr *saddr,
 					 struct in6_addr *daddr)
 {
-	struct dst_entry *ndst;
+	struct dst_entry *ndst = NULL;
 	struct flowi6 fl6 = {};
+	struct sock *sk;
 
 	fl6.flowi6_oif = ndev->ifindex;
 	memcpy(&fl6.saddr, saddr, sizeof(*saddr));
 	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	ndst = ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);
-	if (IS_ERR(ndst)) {
+	rcu_read_lock();
+	sk = rxe_ns_pernet_sk6(net);
+	if (sk)
+		ndst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);
+	rcu_read_unlock();
+	if (IS_ERR_OR_NULL(ndst)) {
 		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
 		return NULL;
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
index 06eb2e2387a1..ef408ffc0558 100644
--- a/drivers/infiniband/sw/rxe/rxe_ns.c
+++ b/drivers/infiniband/sw/rxe/rxe_ns.c
@@ -91,13 +91,8 @@ static struct pernet_operations rxe_net_ops = {
 struct sock *rxe_ns_pernet_sk6(struct net *net)
 {
 	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-	struct sock *sk;
-
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk6);
-	rcu_read_unlock();
 
-	return sk;
+	return rcu_dereference(ns_sk->rxe_sk6);
 }
 #endif /* IPV6 */
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

