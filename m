Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903713;
	b=CpybjAO280aegMyNRRS6ighwzlNIcdD2r4PKzNKMmq1lZLIx5kHZT8KBQ1BMJqOr8vIK
	 3j9EBwtPUoNRlAfa0/ruisqOiUL2fG5u+WjYfcOoSCmUa4Yu09zux4L5h9JPUkEFqvGI5
	 qpkYUeq25BSDK/dXkewl/wE714PFKh4JbDcJokC/yV2B+bobZ3YPt1g3q0Vl/gdPuie5b
	 CzOkvZk/LVPSy7Z/aNjLmXCmKMwS9Q63MG+1spqLbOYejZ0qq4XqoLYcyGEpaLX/gQOSk
	 QuWz0OxQi5V2KO+/cUpwV0lTSO7M8XbobvX7yrubSYV3FRHQFhh0TWB7D+/bC14rCLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903713;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=leXxKH6Wk0JtlVzmpwtXgwI4nGtAzqlh2G4jiTJuaWE=;
	b=0TfL3uVmCqKIWm3tAUhJ+NAuWL6c4N5JCMkSCYo8/9H5s94bI2bdWNa2iuQGYCL7mZGv
	 pzRJpfghJzBKnZxpeQJHPY6qre6Tza7N7a0P0zGRnLgXtcQRlmQUonCZLHXd9/NPrbwrw
	 WYVrmffMu6xxyo1yT3vwxMHWjaq5qyl0V8haNczNbUIGcMHEn/T4+TwWFdS8hrgGT5QEf
	 9wq5ZZxbB7W2C51oPFjAXSnLcdKS7LK1l+lcrFaPUG04xQS/6KoTc/4vq7KQjSZWMYE6T
	 TaLZXL1kkp24qg1eVLKh6khepSGsCP+VUs7k3uOI7dwNP2tlaoE/pOfJJIb4hJurNuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=qjjrmJD7;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC718606A31C;
	Tue, 17 Nov 2026 08:21:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC718606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=qjjrmJD7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=qjjrmJD7hVp33AoQ7QIwYeSxagDqSMJ8aXgtzNDfgWR6t42Dbl4CBCqzi1Y4SuExi7qhrLwFRO5oF
	 nb/2qjqxhG8FWQpsOLE7I7GjrMJySp447MUeE/3Zxxtiot1zkLgMjnAzH0MZ6ALBAOGVzlUA8OwyLl
	 0rustSfzfDBlYVv4=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66afc0e9b846-d4902;
	Tue, 17 Nov 2026 16:21:47 +0800 (CST)
X-RM-TRANSID:2ee66afc0e9b846-d4902
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66afc0e98a20-a9e88;
	Tue, 17 Nov 2026 16:21:47 +0800 (CST)
X-RM-TRANSID:2ee66afc0e98a20-a9e88
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
Subject: [PATCH net v3] net/rds: defer CM id destruction to a workqueue
Date: Tue, 17 Nov 2026 16:21:45 +0800
Message-ID: <20261117082145.1737-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
References: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
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
released before handler_mutex is taken.  The work item is allocated
before the CM id is created and owns the id until rdma_destroy_id() has
run; if the allocation fails, the address check fails with -ENOMEM
rather than falling back to the synchronous destroy, which would bring
the deadlock back under memory pressure.

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
v3:
- allocate the work item before rdma_create_id() and fail with -ENOMEM
  instead of falling back to the synchronous destroy, which would bring
  the deadlock back under memory pressure.
- free the work item when rdma_create_id() fails and drop the now
  redundant fallback in the out path.

v2:
- move the workqueue from RDMA core into RDS, as suggested in review.
- flush rds_wq in rds_ib_exit() so a queued destroy cannot run after
  the module text is freed.
- add the Fixes tag, drop the Tested-by tags.

 net/rds/ib.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4ea9838d0..44b46defa 100644
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
@@ -411,14 +425,28 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 #endif
 	struct sockaddr_in sin;
 	struct sockaddr *sa;
+	struct rds_ib_destroy_work *w;
 	bool isv4;
 
 	isv4 = ipv6_addr_v4mapped(addr);
+
+	/*
+	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls this
+	 * function with rds_trans_sem held for reading, and rdma_destroy_id()
+	 * takes handler_mutex, which the CM callback path acquires before
+	 * taking rds_trans_sem.
+	 */
+	w = kzalloc_obj(*w, GFP_KERNEL);
+	if (!w)
+		return -ENOMEM;
+
 	/* Create a CMA ID restricted to IB devices and try to bind it. */
 	cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler,
 			       NULL, RDMA_PS_TCP, IB_QPT_RC);
-	if (IS_ERR(cm_id))
+	if (IS_ERR(cm_id)) {
+		kfree(w);
 		return PTR_ERR(cm_id);
+	}
 	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
 	if (ret)
 		goto out;
@@ -484,7 +512,9 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 		 cm_id->device ? cm_id->device->node_type : -1);
 
 out:
-	rdma_destroy_id(cm_id);
+	INIT_WORK(&w->work, rds_ib_destroy_id_work);
+	w->cm_id = cm_id;
+	queue_work(rds_wq, &w->work);
 
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
 


