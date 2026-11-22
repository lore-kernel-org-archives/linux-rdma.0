Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795359120;
	b=P6/IL8NkdkDizDoi/91i/hijrM9vocYPEeECTlYFHyA5oMd8vH3ZbStP1JRCI/6M+IPh
	 DrpNVgILKPzRPDOl+yDG37Y1lDGkWUUBdywzxpMQ6/TWPTqcDg902HmquXQaZTV8yxpxq
	 tkQugK/M8fj2ifRM2JNywtzGRxUXrG3cSiTCmxIEECtbLtE9RhIR20H6wS5fgcrh+jeRR
	 6kok9kWKqY+SYpmirLPtqmv5fMImivWpQx7TXM0MlRSNbDg7GVQtCsaNAZaEJkX3PTX5E
	 RkORcVHHp3WePqzoasuyE5SiPIySrCE5pwrcd51nFIrq46qU1bGpoxU/3u0Kb0CP+iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795359120;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rSO4ALisH8jyfd0JkfLxMr351B/lt+GHAhFQPJIOu1I=;
	b=trVmMCTFhUID3ghF7Rrt3AuI7ceTF2T1IvQw487xHZ4x+HDbaRoMndTJCIxA8ZX5GpMj
	 WcB9T6DEyFXftn7m61Z6AWzN8MhZi93lB1R7aI0UzgduZlb4LT3fUq7ugpD1fX8epBVJZ
	 mfkB8JuBKvESzsZOyXt7FELXU6XSTH5tCm2+uHruiOvYcIUGA7f1AqRMfqBvsNu9cjIj8
	 1QqBE3tJDM/VPfl73EtCjvCPDpE/M9wCaTRkL+dxprgB9GXpKSg3D8MEpGcfhzKw5IXT8
	 llhkTWpIYNsTc+GQI9RDS+DYdMqp2wsjkEa2ZU8MaUczaI6tUFY5yYJ2RhfOX6RpyUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=uqO+Fbsl;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FDD606A320;
	Sun, 22 Nov 2026 14:51:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42FDD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=uqO+Fbsl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=uqO+Fbsl1MrJhHQ+R2zoR2uSEP2GEdgA3h37G4f3jU77wEJieNywlJcfujaOVCI68EaNzSelWQQFD
	 NycbIgULV6yZC4AfVp18mS5LupvCoTfuKZhwFpZPZlf5387ecvHNly0GxUSAvkOzMh6gT4IgnyWjzS
	 v+euzaRXSAr7isNc=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26b030181a29-70102;
	Sun, 22 Nov 2026 22:51:51 +0800 (CST)
X-RM-TRANSID:2ee26b030181a29-70102
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66b0301847ec-71d52;
	Sun, 22 Nov 2026 22:51:51 +0800 (CST)
X-RM-TRANSID:2ee66b0301847ec-71d52
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
Subject: [PATCH net v4] net/rds: defer CM id destruction to a workqueue
Date: Sun, 22 Nov 2026 22:51:48 +0800
Message-ID: <20261122145148.1250-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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

Deferring the destruction keeps the CM id alive after bind() returns:
until the worker runs it pins a cma_dev reference and an RDMA_PS_TCP
port, and cma_process_remove() waits for every pending destroy.  An
unprivileged user can call bind() in a loop, so bound the number of
pending probes with rds_ib_pending_probes and fail the address check
with -EAGAIN above RDS_IB_MAX_PENDING_PROBES.

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
v4:
- bound the pending probe ids with an atomic counter and return -EAGAIN
  above RDS_IB_MAX_PENDING_PROBES, since each pending id pins a
  cma_dev reference and an RDMA_PS_TCP port until the worker runs.
- document that exposure in the commit message.

v3:
- allocate the work item before rdma_create_id() and fail with -ENOMEM
  instead of falling back to the synchronous destroy.
- free the work item when rdma_create_id() fails and drop the now
  redundant fallback in the out path.

v2:
- move the workqueue from RDMA core into RDS, as suggested in review.
- flush rds_wq in rds_ib_exit() so a queued destroy cannot run after
  the module text is freed.
- add the Fixes tag, drop the Tested-by tags.

 net/rds/ib.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4ea9838d0..c4c10e3ea 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -391,6 +391,30 @@ static void rds6_ib_ic_info(struct socket *sock, unsigned int len,
 }
 #endif
 
+/*
+ * Maximum number of probe cm_ids whose destruction is still pending on
+ * rds_wq.  Each of them pins a cma_dev reference and an RDMA_PS_TCP port,
+ * so the number of in-flight probes has to be bounded.
+ */
+#define RDS_IB_MAX_PENDING_PROBES	64
+
+static atomic_t rds_ib_pending_probes = ATOMIC_INIT(0);
+
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
+	atomic_dec(&rds_ib_pending_probes);
+}
+
 /*
  * Early RDS/IB was built to only bind to an address if there is an IPoIB
  * device with that address set.
@@ -411,14 +435,39 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
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
+	 * taking rds_trans_sem.  Reserve a pending-probe slot first, so that a
+	 * loop of bind() calls cannot pile up ids that pin a cma_dev reference
+	 * and an RDMA_PS_TCP port.
+	 */
+	if (atomic_inc_return(&rds_ib_pending_probes) >
+	    RDS_IB_MAX_PENDING_PROBES) {
+		atomic_dec(&rds_ib_pending_probes);
+		return -EAGAIN;
+	}
+
+	w = kzalloc_obj(*w, GFP_KERNEL);
+	if (!w) {
+		atomic_dec(&rds_ib_pending_probes);
+		return -ENOMEM;
+	}
+
 	/* Create a CMA ID restricted to IB devices and try to bind it. */
 	cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler,
 			       NULL, RDMA_PS_TCP, IB_QPT_RC);
-	if (IS_ERR(cm_id))
+	if (IS_ERR(cm_id)) {
+		atomic_dec(&rds_ib_pending_probes);
+		kfree(w);
 		return PTR_ERR(cm_id);
+	}
 	ret = rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
 	if (ret)
 		goto out;
@@ -484,7 +533,9 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 		 cm_id->device ? cm_id->device->node_type : -1);
 
 out:
-	rdma_destroy_id(cm_id);
+	INIT_WORK(&w->work, rds_ib_destroy_id_work);
+	w->cm_id = cm_id;
+	queue_work(rds_wq, &w->work);
 
 	return ret;
 }
@@ -542,6 +593,11 @@ void rds_ib_exit(void)
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
 


