Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856478;
	b=NpGAa2Oh6KVtwndQSUyhotTJfzIuGy7gh363mt3Wkj8RWizF9sEwvrQ7W2B3nhNf+63N
	 6nAAk/pTtXQgfRs2LZ4DCciNRdFplWGf6cFKxcro94R6lQ+wTQjSbeUywF66qUULrCOvK
	 8JMvjQVLF1M/xl741q/4jnSA9/SOJviY7jmRo8U8qU8uhHmpqkd1U4uoyG3pDjY/dLGW4
	 qJG68z2U1820+bbd7Il07GjU5x1xMNCpRhexA4G1UClnXAfLQcUKIkEQgz1ojpjxKuVx+
	 HE7xoL4dAEWW3A+NJshWLw/XuqhEg6H3tNZS4ZdtsZNtJXLHJYtiOr+dL5FiOpuaomQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856478;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=6zgk7UdDlYMy8H3W0+vsTfOJUe/2ciaeMTnMfHY6ayg=;
	b=yXbYF6HL9GlOYbl1VXbs2Sova6n7Qv/+TAr+DRwR8D7Un++Xw9MmNcJWuxMR9egYjaHW
	 gC4d7IziDanTiwP+LEicFs69SORbg0sWieniVVnxMY4QCdStINgUtSgxo58zSswh+N2rV
	 9ouiav0saMzVb6iH0gnqbz2TnhMMVafm962pP5GtaUeGSZ6QI8D5Ro4OsYpFqvZ14li/9
	 UEEfqnksnIo16wZTyk+fOhgxaKR2ZRBIWllanayX72saxeozEOEcObGECdUt4+RLmIPag
	 4Vu0ZFzBcf+9H5SWhnb6vAPPVYz+rSddLlVr0vAiUAgqjGRyM4uaJF8BJnfpIxhQytA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Z1f3idAB;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34093606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 15:41:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34093606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Z1f3idAB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792856477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=6zgk7UdDlYMy8H3W0+vsTfOJUe/2ciaeMTnMfHY6ayg=;
	b=Z1f3idAB9oCHLC+ddaP1i7dCqZ2usHeD069g/ED5wYE03PYX61yraBAqYKSjzHzivzqIPN
	nCumPXmolrCpPuio8nNr4TpYvQscx0nuPVMKs1J3/3d1oSgDj+xNMxKwDMwbesGUsUKrff
	LXjpLaOjvQnH8E0VMO4ZA2oVR5XTcvI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-pwniv8GbM6a06qULngbciQ-1; Sat,
 24 Oct 2026 11:41:07 -0400
X-MC-Unique: pwniv8GbM6a06qULngbciQ-1
X-Mimecast-MFC-AGG-ID: pwniv8GbM6a06qULngbciQ_1792856466
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63D90180057E;
	Sat, 24 Oct 2026 15:41:06 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4C13541B;
	Sat, 24 Oct 2026 15:41:04 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Sat, 24 Oct 2026 17:41:06 +0200 (CEST)
Date: Sat, 24 Oct 2026 17:41:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>,
	Joel Granados <joel.granados@kernel.org>
Cc: pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH 4/5] net/rds/tcp.c: move sysctl-only code under CONFIG_SYSCTL
Message-ID: <atzRj8MBpUEPWcHh@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Collect all code used only when CONFIG_SYSCTL=y into a single block and
wrap it in #ifdef CONFIG_SYSCTL. rds_tcp_init_net_sysctl no longer needs
the IS_ENABLED() check.

Add the corresponding init/exit stubs for the CONFIG_SYSCTL=n case.

Also #ifdef the rds_tcp_sysctl and ctl_table fields in struct rds_tcp_net.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

