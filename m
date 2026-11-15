Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749131;
	b=YO8CWQstg8Nmh9W3Up4mdJ2w5gIM5vE2W6foh2r5VcIrL2V6HMDr0S8/EUPTC+HX7czX
	 EbgZmUh1poUJ5az6IvdGkniTBvZruTk/5DM/Zqmcc/fkvRLsWpKLi/SroeOZ6z2hyOyqw
	 LUL8nTR/ObKtzen8yrS0GnGjEb52Q1wFetVUiey/9bGyQkfg6w8zX4jeO3OI3h78rqO8z
	 tK4Cxl9x80MAKV2kispCruTtU45OjGHvyAk52wD1/IyoQa0znp01n5whCs5nEhcN89qd/
	 KzxfrrFttwdaPeSmpqk/qWNAQJBEJgBl9Ktlx1A4tbUwInx/GKhP0l71Zwe0+nFNesg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749131;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=mpsNKtp41glLKZwU90iCfdt+UrBVV2orIvZTwj/O78g=;
	b=KiMKoqFLzHuOzaCkAURg41W4D2xYRlqzA5VfDRS4gz25j6gTgfIHW+S56ttBhPBr5ovP
	 kahOmvQTY0R8qzFGKLGKWxPtc8G8R13zLZ2hI5vMcq1SxvD1XY+xxN0EnGJwHsIHd57LD
	 rm3+yGq0hRhb2QO2G/xOferPV0Sqd34hv1vs56KkbCyiqBe43xCk3VNQjrE5Z3l6Iceoq
	 hjrTne89evPsEbpqQEG3TOXgLPHOOpFDZixcmzF325Ecxb0IPt1DKPpHbnqhBFFboP2j6
	 59axhvs+PlOg0cilIz4glQ7LzL7b6I9EN0DKXhFD/OLmjUGHC9qNrEHLogwSaGfn7bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ekkv8fJB;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD6606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43FD6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ekkv8fJB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794749130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=mpsNKtp41glLKZwU90iCfdt+UrBVV2orIvZTwj/O78g=;
	b=ekkv8fJBvup4DdA1Bk/SXstODrAf1Ot3Y6hF6iNhos2vlJyO4GAZTTLW3/sa9paLL9aJIw
	QiGfMc/lHvNsH9q5D8xU9tzj7lt1S25cjzcVlQNVIAZyks//aP+2ojdqqtKQtH7I2AtcMY
	+ewSkAhrqX1R7t8q46XlrHMrr/iUAxA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-DpzIh-X-OFaRiv-eh1aY3A-1; Sun,
 15 Nov 2026 08:25:26 -0500
X-MC-Unique: DpzIh-X-OFaRiv-eh1aY3A-1
X-Mimecast-MFC-AGG-ID: DpzIh-X-OFaRiv-eh1aY3A_1794749125
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D8301800556;
	Sun, 15 Nov 2026 13:25:25 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5556818004FF;
	Sun, 15 Nov 2026 13:25:23 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sun, 15 Nov 2026 14:25:25 +0100 (CET)
Date: Sun, 15 Nov 2026 14:25:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH v2 net-next 4/5] net/rds/tcp.c: move sysctl-only code under
 CONFIG_SYSCTL
Message-ID: <avmywjLAQO-9fhw5@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Collect all code used only when CONFIG_SYSCTL=y into a single block and
wrap it in #ifdef CONFIG_SYSCTL. rds_tcp_init_net_sysctl no longer needs
the IS_ENABLED() check.

Add the corresponding init/exit stubs for the CONFIG_SYSCTL=n case.

Also #ifdef the rds_tcp_sysctl and ctl_table fields in struct rds_tcp_net.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>
---
 net/rds/tcp.c | 139 ++++++++++++++++++++++++++------------------------
 net/rds/tcp.h |   2 +
 2 files changed, 74 insertions(+), 67 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index d6c542371611..9f18c4f4a406 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -53,13 +53,71 @@ static atomic_t rds_tcp_unloading = ATOMIC_INIT(0);
 
 static struct kmem_cache *rds_tcp_conn_slab;
 
+#ifdef CONFIG_SYSCTL
+static int rds_tcp_min_sndbuf = SOCK_MIN_SNDBUF;
+static int rds_tcp_min_rcvbuf = SOCK_MIN_RCVBUF;
+
+/* when sysctl is used to modify some kernel socket parameters,this
+ * function  resets the RDS connections in that netns  so that we can
+ * restart with new parameters.  The assumption is that such reset
+ * events are few and far-between.
+ */
+static void rds_tcp_sysctl_reset(struct net *net)
+{
+	struct rds_tcp_connection *tc, *_tc;
+
+	spin_lock_irq(&rds_tcp_conn_lock);
+	list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node) {
+		struct net *c_net = read_pnet(&tc->t_cpath->cp_conn->c_net);
+
+		if (net != c_net || !tc->t_sock)
+			continue;
+
+		/* reconnect with new parameters */
+		rds_conn_path_drop(tc->t_cpath, false);
+	}
+	spin_unlock_irq(&rds_tcp_conn_lock);
+}
+
+static int rds_tcp_skbuf_handler(struct rds_tcp_net *rtn,
+				 const struct ctl_table *ctl, int write,
+				 void *buffer, size_t *lenp, loff_t *fpos)
+{
+	int err;
+
+	err = proc_dointvec_minmax(ctl, write, buffer, lenp, fpos);
+	if (err < 0) {
+		pr_warn("Invalid input. Must be >= %d\n",
+			*(int *)(ctl->extra1));
+		return err;
+	}
+
+	if (write && rtn->rds_tcp_listen_sock && rtn->rds_tcp_listen_sock->sk) {
+		struct net *net = sock_net(rtn->rds_tcp_listen_sock->sk);
+
+		rds_tcp_sysctl_reset(net);
+	}
+
+	return 0;
+}
+
 static int rds_tcp_sndbuf_handler(const struct ctl_table *ctl, int write,
-				  void *buffer, size_t *lenp, loff_t *fpos);
+				  void *buffer, size_t *lenp, loff_t *fpos)
+{
+	struct rds_tcp_net *rtn = container_of(ctl->data, struct rds_tcp_net,
+					       sndbuf_size);
+
+	return rds_tcp_skbuf_handler(rtn, ctl, write, buffer, lenp, fpos);
+}
+
 static int rds_tcp_rcvbuf_handler(const struct ctl_table *ctl, int write,
-				  void *buffer, size_t *lenp, loff_t *fpos);
+				  void *buffer, size_t *lenp, loff_t *fpos)
+{
+	struct rds_tcp_net *rtn = container_of(ctl->data, struct rds_tcp_net,
+					       rcvbuf_size);
 
-static int rds_tcp_min_sndbuf = SOCK_MIN_SNDBUF;
-static int rds_tcp_min_rcvbuf = SOCK_MIN_RCVBUF;
+	return rds_tcp_skbuf_handler(rtn, ctl, write, buffer, lenp, fpos);
+}
 
 static struct ctl_table rds_tcp_sysctl_table[] = {
 #define	RDS_TCP_SNDBUF	0
@@ -105,7 +163,7 @@ static __net_init int rds_tcp_init_net_sysctl(struct net *net)
 	tbl[RDS_TCP_RCVBUF].data = &rtn->rcvbuf_size;
 	rtn->rds_tcp_sysctl = register_net_sysctl_sz(net, "net/rds/tcp", tbl,
 						     ARRAY_SIZE(rds_tcp_sysctl_table));
-	if (!rtn->rds_tcp_sysctl && IS_ENABLED(CONFIG_SYSCTL)) {
+	if (!rtn->rds_tcp_sysctl) {
 		pr_warn("could not register sysctl\n");
 		if (net != &init_net)
 			kfree(tbl);
@@ -127,6 +185,15 @@ static void __net_exit rds_tcp_exit_net_sysctl(struct net *net)
 	if (net != &init_net)
 		kfree(rtn->ctl_table);
 }
+#else
+static inline int rds_tcp_init_net_sysctl(struct net *net)
+{
+	return 0;
+}
+static inline void rds_tcp_exit_net_sysctl(struct net *net)
+{
+}
+#endif
 
 u32 rds_tcp_write_seq(struct rds_tcp_connection *tc)
 {
@@ -744,68 +811,6 @@ void *rds_tcp_listen_sock_def_readable(struct net *net)
 	return lsock->sk->sk_user_data;
 }
 
-/* when sysctl is used to modify some kernel socket parameters,this
- * function  resets the RDS connections in that netns  so that we can
- * restart with new parameters.  The assumption is that such reset
- * events are few and far-between.
- */
-static void rds_tcp_sysctl_reset(struct net *net)
-{
-	struct rds_tcp_connection *tc, *_tc;
-
-	spin_lock_irq(&rds_tcp_conn_lock);
-	list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node) {
-		struct net *c_net = read_pnet(&tc->t_cpath->cp_conn->c_net);
-
-		if (net != c_net || !tc->t_sock)
-			continue;
-
-		/* reconnect with new parameters */
-		rds_conn_path_drop(tc->t_cpath, false);
-	}
-	spin_unlock_irq(&rds_tcp_conn_lock);
-}
-
-static int rds_tcp_skbuf_handler(struct rds_tcp_net *rtn,
-				 const struct ctl_table *ctl, int write,
-				 void *buffer, size_t *lenp, loff_t *fpos)
-{
-	int err;
-
-	err = proc_dointvec_minmax(ctl, write, buffer, lenp, fpos);
-	if (err < 0) {
-		pr_warn("Invalid input. Must be >= %d\n",
-			*(int *)(ctl->extra1));
-		return err;
-	}
-
-	if (write && rtn->rds_tcp_listen_sock && rtn->rds_tcp_listen_sock->sk) {
-		struct net *net = sock_net(rtn->rds_tcp_listen_sock->sk);
-
-		rds_tcp_sysctl_reset(net);
-	}
-
-	return 0;
-}
-
-static int rds_tcp_sndbuf_handler(const struct ctl_table *ctl, int write,
-				  void *buffer, size_t *lenp, loff_t *fpos)
-{
-	struct rds_tcp_net *rtn = container_of(ctl->data, struct rds_tcp_net,
-					       sndbuf_size);
-
-	return rds_tcp_skbuf_handler(rtn, ctl, write, buffer, lenp, fpos);
-}
-
-static int rds_tcp_rcvbuf_handler(const struct ctl_table *ctl, int write,
-				  void *buffer, size_t *lenp, loff_t *fpos)
-{
-	struct rds_tcp_net *rtn = container_of(ctl->data, struct rds_tcp_net,
-					       rcvbuf_size);
-
-	return rds_tcp_skbuf_handler(rtn, ctl, write, buffer, lenp, fpos);
-}
-
 static void rds_tcp_exit(void)
 {
 	rds_tcp_set_unloading();
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index 39c86347188c..12b58d76c089 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -13,8 +13,10 @@ struct rds_tcp_net {
 	struct socket		*rds_tcp_listen_sock;
 	struct socket		*rds_tcp_accepted_sock;
 	struct work_struct	rds_tcp_accept_w;
+#ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*rds_tcp_sysctl;
 	const struct ctl_table	*ctl_table;
+#endif
 	int			sndbuf_size;
 	int			rcvbuf_size;
 };
-- 
2.55.0

