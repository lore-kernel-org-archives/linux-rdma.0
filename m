Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749130;
	b=RDcIARbluyycYnGp9IyaLAQ1BRwz/yCL04Ilx0j/GCpo48ZWn3LLFtU8x3uv/wLKJgcn
	 HuuUue9LhdApxYYtRUDFN59MCAeiMEuZ33WKphOseze3JYwWUsqMAHXfw7gcRqSPsNo2n
	 sZ1uRdMV+25gxsOAJj8rbwPA4kyJ31rExzzIg0SG6o9Q1bOlBwDh/oP/5lkNwzmdAqAa2
	 X/tOua7xV0P/jGHgEySBUAlXg8rxUlFOyIWRSmtiFfNkfmBTEOp6jlX8WALbppJxHY/Lw
	 /lBrsyXQY3GL5wF6iG3xrpqLYpwEZITI4L5CN2l0n660mIz0mBXwgwVKzv9+R77XaQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749130;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=kxwLi3A5QllXfbsd8z/crnInKDY2i2wI+kGnGu/Swck=;
	b=xku6tvc4qYByFzypqErLKSnp+EwNtKHwc8x1nvBfmEw5gWOMy9KRyrs7Jf+V61PBRwKb
	 IK6J8hYSlgX1ZEHCJbAlXbO2vVV603B1ExQf/F2Jfge5xJOZSwg899ydIIiChYwZpHw3e
	 amoFxvbBl+MdkMP8ILpYqxo26aC+KwqfN1aWdRdfCnbrbUvAzD9/1p0wSsdyEm9UtbQtf
	 WitQ6u6pI92/nEKx7p5HRk3QP9XW4IzljR53pOXLl+yLn6E2K83x0jkZQOyx6P5iaDyDM
	 3l/0sIgKJst6t+yU8u13SMtm4wKNti9f2lch6myRnZVpz4x/efwtd4bmfEnqhUBVT/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ep3ifzlR;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A553D606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A553D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ep3ifzlR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794749128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=kxwLi3A5QllXfbsd8z/crnInKDY2i2wI+kGnGu/Swck=;
	b=ep3ifzlR9RbZtEcCv8WOnEm+FpkqrYP8vCnLxkd4NKAm375+UF9SuktS+6tPJt6CnOvM1H
	1rxgFI+ehJJvJ8WlMQNIlZa24dmpEbA5CQr751yBn8g0AdbRGhBCZ6Uts8yWWQkVbyjBC4
	QJgO+Q0TX78fWAPICmzGbhOUGKTWUJ4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-_f285Th1OtKcUXmdvLcu5A-1; Sun,
 15 Nov 2026 08:25:23 -0500
X-MC-Unique: _f285Th1OtKcUXmdvLcu5A-1
X-Mimecast-MFC-AGG-ID: _f285Th1OtKcUXmdvLcu5A_1794749122
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA79B1956078;
	Sun, 15 Nov 2026 13:25:21 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D732718004F7;
	Sun, 15 Nov 2026 13:25:19 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sun, 15 Nov 2026 14:25:21 +0100 (CET)
Date: Sun, 15 Nov 2026 14:25:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2 net-next 3/5] net/rds/tcp.c: introduce
 rds_tcp_{init,exit}_net_sysctl() helpers
Message-ID: <avmyvkuAjrz6IqvJ@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avmymGvelu00X5EH@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Preparation to simplify the next change.

Extract the net namespace sysctl registration and unregistration logic
from rds_tcp_init_net() and rds_tcp_exit_net() into new helpers.

This also simplifies the error paths in rds_tcp_init_net(); it can use
rds_tcp_exit_net_sysctl() too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>
---
 net/rds/tcp.c | 93 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 41 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index c1ad37505417..d6c542371611 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -82,6 +82,52 @@ static struct ctl_table rds_tcp_sysctl_table[] = {
 	},
 };
 
+static __net_init int rds_tcp_init_net_sysctl(struct net *net)
+{
+	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
+	struct ctl_table *tbl;
+
+	/* {snd, rcv}buf_size default to 0, which implies we let the
+	 * stack pick the value, and permit auto-tuning of buffer size.
+	 */
+	if (net == &init_net) {
+		tbl = rds_tcp_sysctl_table;
+	} else {
+		tbl = kmemdup(rds_tcp_sysctl_table,
+			      sizeof(rds_tcp_sysctl_table), GFP_KERNEL);
+		if (!tbl) {
+			pr_warn("could not allocate sysctl table\n");
+			return -ENOMEM;
+		}
+		rtn->ctl_table = tbl;
+	}
+	tbl[RDS_TCP_SNDBUF].data = &rtn->sndbuf_size;
+	tbl[RDS_TCP_RCVBUF].data = &rtn->rcvbuf_size;
+	rtn->rds_tcp_sysctl = register_net_sysctl_sz(net, "net/rds/tcp", tbl,
+						     ARRAY_SIZE(rds_tcp_sysctl_table));
+	if (!rtn->rds_tcp_sysctl && IS_ENABLED(CONFIG_SYSCTL)) {
+		pr_warn("could not register sysctl\n");
+		if (net != &init_net)
+			kfree(tbl);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void __net_exit rds_tcp_exit_net_sysctl(struct net *net)
+{
+	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
+
+	if (rtn->rds_tcp_sysctl) {
+		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
+		rtn->rds_tcp_sysctl = NULL;
+	}
+
+	if (net != &init_net)
+		kfree(rtn->ctl_table);
+}
+
 u32 rds_tcp_write_seq(struct rds_tcp_connection *tc)
 {
 	/* seq# of the last byte of data in tcp send buffer */
@@ -612,36 +658,15 @@ void rds_tcp_accept_work(struct rds_tcp_net *rtn)
 static __net_init int rds_tcp_init_net(struct net *net)
 {
 	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
-	struct ctl_table *tbl;
 	int err = 0;
 
 	memset(rtn, 0, sizeof(*rtn));
 
 	mutex_init(&rtn->rds_tcp_accept_lock);
 
-	/* {snd, rcv}buf_size default to 0, which implies we let the
-	 * stack pick the value, and permit auto-tuning of buffer size.
-	 */
-	if (net == &init_net) {
-		tbl = rds_tcp_sysctl_table;
-	} else {
-		tbl = kmemdup(rds_tcp_sysctl_table,
-			      sizeof(rds_tcp_sysctl_table), GFP_KERNEL);
-		if (!tbl) {
-			pr_warn("could not set allocate sysctl table\n");
-			return -ENOMEM;
-		}
-		rtn->ctl_table = tbl;
-	}
-	tbl[RDS_TCP_SNDBUF].data = &rtn->sndbuf_size;
-	tbl[RDS_TCP_RCVBUF].data = &rtn->rcvbuf_size;
-	rtn->rds_tcp_sysctl = register_net_sysctl_sz(net, "net/rds/tcp", tbl,
-						     ARRAY_SIZE(rds_tcp_sysctl_table));
-	if (!rtn->rds_tcp_sysctl && IS_ENABLED(CONFIG_SYSCTL)) {
-		pr_warn("could not register sysctl\n");
-		err = -ENOMEM;
-		goto fail;
-	}
+	err = rds_tcp_init_net_sysctl(net);
+	if (err)
+		return err;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	rtn->rds_tcp_listen_sock = rds_tcp_listen_init(net, true);
@@ -656,21 +681,14 @@ static __net_init int rds_tcp_init_net(struct net *net)
 		rtn->rds_tcp_listen_sock = rds_tcp_listen_init(net, false);
 		if (!rtn->rds_tcp_listen_sock) {
 #endif
-			unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
-			rtn->rds_tcp_sysctl = NULL;
-			err = -EAFNOSUPPORT;
-			goto fail;
+			rds_tcp_exit_net_sysctl(net);
+			return -EAFNOSUPPORT;
 #if IS_ENABLED(CONFIG_IPV6)
 		}
 #endif
 	}
 	INIT_WORK(&rtn->rds_tcp_accept_w, rds_tcp_accept_worker);
 	return 0;
-
-fail:
-	if (net != &init_net)
-		kfree(tbl);
-	return err;
 }
 
 static void rds_tcp_kill_sock(struct net *net)
@@ -704,14 +722,7 @@ static void rds_tcp_kill_sock(struct net *net)
 
 static void __net_exit rds_tcp_exit_net(struct net *net)
 {
-	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
-
-	if (rtn->rds_tcp_sysctl)
-		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
-
-	if (net != &init_net)
-		kfree(rtn->ctl_table);
-
+	rds_tcp_exit_net_sysctl(net);
 	rds_tcp_kill_sock(net);
 }
 
-- 
2.55.0

