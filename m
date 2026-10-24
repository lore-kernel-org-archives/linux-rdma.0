Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856470;
	b=IgckgeucR879dYsVUQaLHZ283K7z+32Q1Ef0Z4YRUw47nkRUiBw0NB+aRZKQ2ih3EZhU
	 heaRyRbKaRUk06Sq2kjOhFThoY2vv952wTqLqYTFHB+Z5Dxfy3FYcdLxgDDtMWHfdpcaj
	 m1VUbQFJRyjiL8JJAsblTHZQGADvHNJ7t6vWRFrjKB73FyAdOSKdAGCGkqow8gibtGUqA
	 MdWjopIiK8IpVMQU/iJkcVXMa1UQ++xuXu3Ds/dKEtPLSEwikaORM+C14O0gBdmdQ7XFp
	 NAXom5qoGm6DzUDhJGxYVNsP07KE7k1zB/ycnQpTpKHx1vW/LEM/dQY/CnwRewT5W4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856470;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=V8lmmqxLRqlTZOe2HI26WnNlP1q8PdYJ/KC8WWbjFRs=;
	b=pxuBtUDfUhX9o20bsLs7I11GZnwtpppgZqntM9i0gQ9CHy9ahvj5bpMwQ4wby5gOBt92
	 4PzxrRvPWEuqLtutyyPIEEtMJqySumPVLf0UPMIBBpoSgvkosBVEAiC9v4ygBxN3gZ3NO
	 K5oKlC+9hNZQRM8MDeAWMHLXBZJTcf4/pEvImObt/H7/9sLYj7Ayh1PFnMKOwh/bxEiJy
	 8exSbQlFLf4ucNuGYnxHVO9FvWWf1MYJ7l6owpraCECPbkFwMUULhwNFwPslAoCteNm7m
	 IXCWULifbuGcCrxVcvUnIcykHIHolaPLVBV+VLaLGkTtvS37Tq68hJaCRrTFHdztHXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="cx/aGCzJ";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D620606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 15:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D620606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cx/aGCzJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792856469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=V8lmmqxLRqlTZOe2HI26WnNlP1q8PdYJ/KC8WWbjFRs=;
	b=cx/aGCzJxGg1Tpskd0O93K3/Ysz0GTaaK5AHePcVQ7zAjK7/zPS7S3AdrZEvn9u4/wgfd+
	JJ14CRkVkzzxWD8f1Cvf5+x48wUgC2vjJCM0uQNzSwenVH15+KCzn5O0ja4P/WsMGU9OiB
	o78EEgf0HbUM70oPpk+xre0BCHeugd8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-NrUkP1YgPdOFoUTLwPUtAw-1; Sat,
 24 Oct 2026 11:41:04 -0400
X-MC-Unique: NrUkP1YgPdOFoUTLwPUtAw-1
X-Mimecast-MFC-AGG-ID: NrUkP1YgPdOFoUTLwPUtAw_1792856463
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 016E3180057E;
	Sat, 24 Oct 2026 15:41:03 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E3A3D180057F;
	Sat, 24 Oct 2026 15:41:00 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sat, 24 Oct 2026 17:41:02 +0200 (CEST)
Date: Sat, 24 Oct 2026 17:40:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Joel Granados <joel.granados@kernel.org>
Cc: pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH 3/5] net/rds/tcp.c: introduce
 rds_tcp_{init,exit}_net_sysctl() helpers
Message-ID: <atzRizYzOYIs5wVP@redhat.com>
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
In-Reply-To: <atzRTslzb6CAKPKX@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Preparation to simplify the next change.

Extract the net namespace sysctl registration and unregistration logic
from rds_tcp_init_net() and rds_tcp_exit_net() into new helpers.

This also simplifies the error paths in rds_tcp_init_net(); it can use
rds_tcp_exit_net_sysctl() too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

