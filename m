Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794668750;
	b=AXGEdQc/TB+/X9qNk9umyizrRzPp1V9s3rZAsf6NykgDn73fneYTZezuQUkvqJoDJT0O
	 t5tEzFZSt623IwndTWQK5BPkBQkIJMaPgU5UHJQlEc4fbu78QPZhMlRfXPlVqZO6X1Agd
	 cwhc73ipBestA8GqrALy2BGgiZonLm2m/u/N4NjSSho7RNZRJC/ZxXkJXZKu5hgqgb+PL
	 Ueh3enjHvh2PPEmuc0TsnVCDVj/zAN3LzvtsIpvFA9Gt8POYNK0Ft6NUa5Dcbo1qbtvU9
	 PPRHcgzADsQCl1TeKOBN/xPOSKqxHFnGhdFJ9JVBMJ481EZFVQoIaSJFtlEzjfmuiog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794668750;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MknYh1wdceisoj5BD7eTiAMi//3cMI6ldwjYjtC94HY=;
	b=4TD8zLwPZkJwO6ZHbxWFTQIfm8vFbG8Sk2ONVivbzOgc/MkJabqUEgbZOMe8t57BQ07M
	 1g5RU6sbadwFSW/hbOnOudFu3311fwbtI7bXKBrJfi3Eetw96+hvmDKSpVKmdj56DqwRN
	 3DRisI0FmwJ/44tK2oq7lYzUOH1HZrVrfD1905Z3lEcs53rbHXnsGRbf7a1iJW3NjGk4g
	 +AYKrUd7NE8O+28/5xCuZ8u5LjDAanrIwAtZeoqK2W1lbWHedytLhBtZx4EupSA9X+RDc
	 FDIXyyvSTqcAsSG5QoiToH9rYcVWeP5KpGaH6f4R8O1A3Pxfiq3ACzF+p0sZFQwVvhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ojjO05m+;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D322606A32D;
	Sat, 14 Nov 2026 15:05:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D322606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ojjO05m+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ojjO05m+amjySMBH98i9bWYiy6rc2mTAuL2hLCRak0cXVZ2n4cgEnpzHDQ348gF7rbyK5y2/1Q6sW
	 weyHEtvG0BtFtS+PYna2Ci2GkK2kEIlgVqIFuN+eZFU3WR8BYi78GRhzhkgMC3megwS6dyU1whm3u3
	 qyuv8LyhtfTPc85E=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56af878c6dde-ef5bc;
	Sat, 14 Nov 2026 23:05:45 +0800 (CST)
X-RM-TRANSID:2ee56af878c6dde-ef5bc
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36af878c6a22-46641;
	Sat, 14 Nov 2026 23:05:45 +0800 (CST)
X-RM-TRANSID:2ee36af878c6a22-46641
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	achender@kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	hdanton@sina.com,
	hackerowskiy@gmail.com,
	syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com,
	Aibing Chen <chenaibing@cmss.chinamobile.com>
Subject: [PATCH] RDMA/cma: add rdma_destroy_id_wq() and use it from RDS
Date: Sat, 14 Nov 2026 23:05:41 +0800
Message-ID: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
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

syzbot reported a possible circular locking dependency between
rds_trans_sem and the RDMA CM handler mutex:

  CPU0 (bind path)                    CPU1 (CM callback path)
  ----                                ----
  down_read(&rds_trans_sem)           mutex_lock(&handler_mutex)
  rds_ib_laddr_check()                cma_ib_req_handler()
    rdma_destroy_id()                   rds_ib_cm_handle_connect()
      mutex_lock(&handler_mutex)          rds_conn_create()
                                            rds_trans_get_preferred()
                                              down_read(&rds_trans_sem)

rds_ib_laddr_check_cm() destroys the CM id from inside
rds_trans_get_preferred()'s read-side critical section, while CM
callbacks create RDS connections (taking the same read lock) from
under handler_mutex.

Break the cycle by destroying the CM id asynchronously: add
rdma_destroy_id_wq(), which queues the destruction on cma_wq, and
switch rds_ib_laddr_check_cm() to it.  The destroy work is embedded
in struct rdma_id_private, which keeps the id alive until the work
runs; rds does not touch cm_id after the destroy call.

This formalizes the approach proposed and syzbot-tested by Hillf
Danton; Eduard Zateev additionally verified the fix on a real QEMU
system (KASAN + lockdep + RDMA_RXE, active and passive RDS
connections established without any lockdep output).

Reported-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccdb5058c3df2d94811c
Suggested-by: Hillf Danton <hdanton@sina.com>
Tested-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
Tested-by: Eduard Zateev <hackerowskiy@gmail.com>
Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
 drivers/infiniband/core/cma.c      | 19 +++++++++++++++++++
 drivers/infiniband/core/cma_priv.h |  1 +
 include/rdma/rdma_cm.h             |  1 +
 net/rds/ib.c                       |  2 +-
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1a..d10aaf51e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2126,6 +2126,25 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 }
 EXPORT_SYMBOL(rdma_destroy_id);
 
+static void destroy_id_work(struct work_struct *work)
+{
+	struct rdma_id_private *id_priv =
+		container_of(work, struct rdma_id_private, destroy_work);
+
+	mutex_lock(&id_priv->handler_mutex);
+	destroy_id_handler_unlock(id_priv);
+}
+
+void rdma_destroy_id_wq(struct rdma_cm_id *id)
+{
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
+
+	INIT_WORK(&id_priv->destroy_work, destroy_id_work);
+	queue_work(cma_wq, &id_priv->destroy_work);
+}
+EXPORT_SYMBOL(rdma_destroy_id_wq);
+
 static int cma_rep_recv(struct rdma_id_private *id_priv)
 {
 	int ret;
diff --git a/drivers/infiniband/core/cma_priv.h b/drivers/infiniband/core/cma_priv.h
index 04332eb82..95ff8bbd4 100644
--- a/drivers/infiniband/core/cma_priv.h
+++ b/drivers/infiniband/core/cma_priv.h
@@ -110,6 +110,7 @@ struct rdma_id_private {
 	 */
 	struct rdma_restrack_entry     res;
 	struct rdma_ucm_ece ece;
+	struct work_struct destroy_work;
 };
 
 #if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index d639ff889..ac1c1d917 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -167,6 +167,7 @@ struct rdma_cm_id *rdma_create_user_id(rdma_cm_event_handler event_handler,
   * asynchronous operations associated with the id.
   */
 void rdma_destroy_id(struct rdma_cm_id *id);
+void rdma_destroy_id_wq(struct rdma_cm_id *id);
 
 /**
  * rdma_restrict_node_type - Restrict an RDMA identifier to specific
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4ea9838d0..1290747cd 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -484,7 +484,7 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 		 cm_id->device ? cm_id->device->node_type : -1);
 
 out:
-	rdma_destroy_id(cm_id);
+	rdma_destroy_id_wq(cm_id);
 
 	return ret;
 }
-- 
2.50.1.windows.1



