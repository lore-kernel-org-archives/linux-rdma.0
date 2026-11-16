Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794815674;
	b=DreGxcKrqXzW+krDJe84oHSxx9VXuwIBTL1fO2Vqv+7oABbBYMwfky4z9apYrGUJ07rz
	 Yu9Ac2Dpi4AeN3Cp0Q+eRoJqfz4yT4kGp7fnyrKEhUwl+xUHbvYEc6tID4KJsJDyPPvvS
	 t1cQiH2Ypiz28riD2742kV6lUJyzMp2K52AoZ2tPxraFn1fUH9KURmZ4D6V2zz5ggIKVr
	 IGWhJDBk5va16AVVsObEI0sb5CBTA2iQazEMmJP38KaLkBMn5m5G0zJlzz1fzXQqeNXW9
	 ZU48xzavMAayxgycASnHMhzAkjug/KoTX/9QttzjD+QJwDQmyW8/I+2IANnZXEUzhqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794815674;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oMNfobqpRSVZ/RPyQdQw1yQT2pAF5tFb5iwD71xAuiI=;
	b=vms9Vk6pPcNB0FvfWGrfNNz57Gr5+2nrXC5NfJYOaN/I2NwLfA48dgQoK/iObEUcYMKs
	 +H+94jWQEjtQwHSszhP0hUewBlNcV0P/sGlhZeweJBzuZWId7OpStGJdRNj734DkSypZ8
	 aHt+mfdc4V+MYYwRcsqiM5OSGRocQ8kNaI5suwRL7unhzLO0PEa6SkWbl1hc8cMA2RPqT
	 l/Z1oibHwIrb5lgt1+2Q/qt5P0gXxPCgmtH4zbp42hqIxC5CXVx5X0gymCgliq2HkQemU
	 XcUUnCZrmNBGnoDgR0BoopsG6FHUVwO9J1GA6FJgnb0rmc3HMInKZnkdJZus3Yt+z9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ygIuYZdH;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95BA606A31C;
	Mon, 16 Nov 2026 07:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C95BA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ygIuYZdH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ygIuYZdHre9g7Kx26GzdcSbX8KuksBbQqPckqqz+sTy3Bv60SCTj7WKcgIgqmirbFWnYiPqzSrSMg
	 11vXUSr3XDnOhzozaGq0EPQWZWCROd3j+HvA5TCw8MMf7R7g+ghhq4mJT6br4MSCjKrP4gdXUcWULS
	 BuwXqC6MZSTt9kcc=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66afab6b03fc-ca3c8;
	Mon, 16 Nov 2026 15:54:26 +0800 (CST)
X-RM-TRANSID:2ee66afab6b03fc-ca3c8
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26afab6b0a9e-83d33;
	Mon, 16 Nov 2026 15:54:26 +0800 (CST)
X-RM-TRANSID:2ee26afab6b0a9e-83d33
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: Allison Henderson <achender@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net/rds: defer CM id destruction to a workqueue
Date: Mon, 16 Nov 2026 15:54:23 +0800
Message-ID: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
References: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
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

rds_ib_laddr_check_cm() destroys the RDMA CM id it created while
rds_trans_get_preferred() holds rds_trans_sem for reading.  The bind
path then takes rds_trans_sem and afterwards handler_mutex in
rdma_destroy_id(), while the CM callback path takes handler_mutex in
cma_ib_req_handler() and afterwards rds_trans_sem through
rds_conn_create().  lockdep reports the resulting cycle.

Queue the destruction on rds_wq instead, so that rds_trans_sem is
released before handler_mutex is taken.  The work item allocated here
owns the cm_id until rdma_destroy_id() has run; if the allocation fails,
the id is destroyed synchronously as before.

rds_ib_exit() flushes rds_wq after rds_trans_unregister() so that no
queued destroy runs after the module text is gone.

Reported-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccdb5058c3df2d94811c
Suggested-by: Hillf Danton <hdanton@sina.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Suggested-by: Allison Henderson <achender@kernel.org>
Fixes: ec16227e1414 ("RDS/IB: Infiniband transport")
Cc: stable@vger.kernel.org
Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
v2:
- move the workqueue from RDMA core into RDS, as suggested in review.
- flush rds_wq in rds_ib_exit() so a queued destroy cannot run after
  the module text is freed.
- add the Fixes tag, drop the Tested-by tags.

 net/rds/ib.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4ea9838d0..66af4a72a 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -391,6 +391,20 @@ static void rds6_ib_ic_info(struct socket *sock, unsigned int len,
 }
 #endif
 
+struct rds_ib_destroy_work {
+	struct work_struct work;
+	struct rdma_cm_id *cm_id;
+};
+
+static void rds_ib_destroy_id_work(struct work_struct *work)
+{
+	struct rds_ib_destroy_work *w =
+		container_of(work, struct rds_ib_destroy_work, work);
+
+	rdma_destroy_id(w->cm_id);
+	kfree(w);
+}
+
 /*
  * Early RDS/IB was built to only bind to an address if there is an IPoIB
  * device with that address set.
@@ -411,6 +425,7 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 #endif
 	struct sockaddr_in sin;
 	struct sockaddr *sa;
+	struct rds_ib_destroy_work *w;
 	bool isv4;
 
 	isv4 = ipv6_addr_v4mapped(addr);
@@ -419,6 +434,15 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 			       NULL, RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
+
+	/*
+	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls this
+	 * function with rds_trans_sem held for reading, and rdma_destroy_id()
+	 * takes handler_mutex, which the CM callback path acquires before
+	 * taking rds_trans_sem.  If the allocation fails, fall back to the
+	 * synchronous destroy.
+	 */
+	w = kzalloc_obj(*w, GFP_KERNEL);
 	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
 	if (ret)
 		goto out;
@@ -484,7 +508,13 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 		 cm_id->device ? cm_id->device->node_type : -1);
 
 out:
-	rdma_destroy_id(cm_id);
+	if (w) {
+		INIT_WORK(&w->work, rds_ib_destroy_id_work);
+		w->cm_id = cm_id;
+		queue_work(rds_wq, &w->work);
+	} else {
+		rdma_destroy_id(cm_id);
+	}
 
 	return ret;
 }
@@ -542,6 +572,11 @@ void rds_ib_exit(void)
 	rds_ib_sysctl_exit();
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
+	/*
+	 * rds_ib_laddr_check_cm() may have queued rdma_destroy_id() on rds_wq;
+	 * wait for it before the module text goes away.
+	 */
+	flush_workqueue(rds_wq);
 	rds_ib_mr_exit();
 }
 


