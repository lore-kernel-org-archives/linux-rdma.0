Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.153.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794139323;
	b=22a3mnDsGlosWie0ekuqiujTx12nzFR6hHRpDibByZenSOTQX+SWjcPEjWNJeo44YtZy
	 vCKw5ryy7nYBz+oCBanpnr4yWtempVhQOQP2FI4I2KYfrMSsyUp/MHSlsvatLbr9Vfh0s
	 lZGbZOyhQgVPdPUNtTI9cA4q0nLQae8JiMoFsUYY1Oi80btgGJHnfzs+o9rEnW1jPx7L2
	 E6tM93qxYlKqlS9liQnKfbAtLBpSIezmcCb46tMyXUkwKGVfDXg+0ugLaX1BDqZj8gaFd
	 vYfMLj0ZoN1v87F0lYAdg9RGZNoRKyrfQjOIyeKyXmzM8Kn3Qz0EqOMRgmNXvS3BvBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794139323;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+Kv8RMGc4Kqj8bJLYodcw8xgNTV/EvlvmXAn+hqBBNQ=;
	b=mB6mtM5RToW6MeS2fvv99UJGafE5PjC7FZ1gzyWd88TmhJA+c+3AKxbaiGmpZRqea9tT
	 GTScy7IB24+7KPfrvvWvmNrtLf65/W4Tn1HPneeo2HnYHZHZvAb2ga7AuQWZHOBvKSTOB
	 SxVIZQ2DFOj5Q15RknE/C5bLXJxl2UXer9LVpIwxh5AkYHrrkG9O7mENeOFRCfOJdzYlc
	 /gB9tlP00U8A1cVjk+IcGjviM0vAbU60TwW4JnG/Z21gbUy5XxBDt2whu8xxIq/qVr3/h
	 uJh3AFFlstLbbRYaTLhhct9FHU1XLKoDHDQUBVxx548tzkEYM1bJUyqX8S7V5p2iMdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=UN+xWIkY;
	arc=none smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A70606A321
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 12:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16A70606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=UN+xWIkY
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794139330; x=1825675330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9NiMau9ASQ4YTV/4lh6tafHs4DXijpsctEYFctn0SFw=;
  b=UN+xWIkYgmZbMg1uTK9dpKOj7N8s83GMvOEwoPo+bxVllvkos4cbCPcH
   DXzhWCXCKMTFXTf/EEcKJteWPB+97Q+1bICCEal7HBLUXhTWcKWXz5Jms
   Wi6dG+36oB0L3WwQ5fK1a8LWUjTRyivGCbQoz1F/ngB6o7fNLT5hs4I1K
   OC6VpUAuYk3Jkfsd3u8Xd6BG5PFDNRFjLK+bh9g0F+3brrPvL63Li9Q2N
   vU358cWGuX4SSRuoSn5Y/WUnlf4/Cu28JNHXbz4mL97Se2SP+dzxdj85O
   LywMEKFqgEANK3VciHTSR4R4J1iveXk/Fcla/YUPt++/tuW52pTf9ff4x
   A==;
X-CSE-ConnectionGUID: 3xh+Fu9LQcuPajqWJR5YEg==
X-CSE-MsgGUID: J8aNDylBScK/TyCb5ipQBg==
X-IronPort-AV: E=Sophos;i="6.27,202,1786982400"; 
   d="scan'208";a="159266833"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2026 20:02:05 +0800
X-CSE-ConnectionGUID: H3X3cwUcR4iR1jZ5+uHPwQ==
X-CSE-MsgGUID: qaBlMTvwSzOVg5MOYuqEfQ==
IronPort-SDR: 6af064b6_vSCzq1snuzzatlCChb7S/HwD8hwxCOquW8BYrmShOu4oNIw
 gveORkC/0hw9+kNWBW6BkkRZ20ISVBsWsC2smIw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2026 04:01:58 -0800
X-CSE-ConnectionGUID: cmbr24pJTeiZUC8YzvYf3w==
X-CSE-MsgGUID: g36sCvGNTWeqlFIY6JJVNg==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 08 Nov 2026 04:01:57 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-rdma@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Surabhi Gogte <sgogte@purestorage.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH RFC 1/2] RDMA/cma: Add rdma_reclassify_id_for_listen()
Date: Sun,  8 Nov 2026 21:01:53 +0900
Message-ID: <20261108120154.148824-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
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

Since the commit 2a8513091d2f ("nvme-rdma: parallelize I/O queue
allocation and startup"), the host sends commands on an I/O queue before
the target has seen RDMA_CM_EVENT_ESTABLISHED for that queue. nvmet-rdma
keeps such commands on queue->rsp_wait_list and executes them from
nvmet_rdma_cm_handler() when the ESTABLISHED event arrives, that is,
with the handler_mutex of the queue's cm_id held. Executing a connect
command takes nvmet_config_sem, which creates a handler_mutex ->
nvmet_config_sem dependency. This is the reverse of the order in
nvmet_port_subsys_drop_link(), which holds nvmet_config_sem and calls
rdma_destroy_id() on the port's listening cm_id via
nvmet_disable_port(). Lockdep reports the warning below when blktests
nvme/004 or nvme/031 is run repeatedly with the rdma transport and the
rxe driver:

    WARNING: possible circular locking dependency detected
    rm/7346 is trying to acquire lock:
     (&id_priv->handler_mutex){+.+.}-{4:4}, at: rdma_destroy_id+0x17/0x20 [rdma_cm]
    but task is already holding lock:
     (nvmet_config_sem){++++}-{4:4}, at: nvmet_port_subsys_drop_link+0x52/0x340 [nvmet]

    -> #1 (nvmet_config_sem){++++}-{4:4}:
           down_read+0xa6/0x530
           nvmet_find_get_subsys+0x1f4/0x630 [nvmet]
           nvmet_ctrl_find_get+0xaa/0x320 [nvmet]
           nvmet_execute_io_connect+0x1e0/0x480 [nvmet]
           nvmet_rdma_execute_command+0x18e/0x480 [nvmet_rdma]
           nvmet_rdma_handle_command+0x428/0xb30 [nvmet_rdma]
           nvmet_rdma_cm_handler+0x8a8/0x30f0 [nvmet_rdma]
           cma_cm_event_handler+0xb0/0x3c0 [rdma_cm]
           cma_ib_handler+0x28a/0x9b0 [rdma_cm]
           cm_process_work+0x4b/0x3e0 [ib_cm]
           cm_work_handler+0x2485/0xac10 [ib_cm]

    -> #0 (&id_priv->handler_mutex){+.+.}-{4:4}:
           rdma_destroy_id+0x17/0x20 [rdma_cm]
           nvmet_rdma_disable_port+0x44/0x300 [nvmet_rdma]
           nvmet_rdma_remove_port+0x42/0x60 [nvmet_rdma]
           nvmet_disable_port+0x120/0x1f0 [nvmet]
           nvmet_port_subsys_drop_link+0x261/0x340 [nvmet]
           configfs_unlink+0x36d/0x790
           vfs_unlink+0x278/0xb40
           filename_unlinkat+0x31d/0x670
           __x64_sys_unlinkat+0xae/0x100

    other info that might help us debug this:

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(nvmet_config_sem);
                                   lock(&id_priv->handler_mutex);
                                   lock(nvmet_config_sem);
      lock(&id_priv->handler_mutex);

     *** DEADLOCK ***

However, the two handler_mutex instances belong to different cm_ids. The
one held during command execution belongs to a connected queue's cm_id,
while the one taken by rdma_destroy_id() belongs to the listening cm_id.
nvmet-rdma does not take nvmet_config_sem while handling events of the
listening cm_id, so this is not a real deadlock. Lockdep handles the two
in the same manner because all handler_mutex instances share a single
lock class.

Add rdma_reclassify_id_for_listen(), which assigns a separate lockdep
class to the handler_mutex of a listening cm_id. rdma users can call it
right after creating the cm_id they listen on. A follow-up patch makes
nvmet-rdma call it.

Link: https://lore.kernel.org/linux-nvme/at36um4zrsfOr3kh@shinmob/
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/infiniband/core/cma.c | 13 +++++++++++++
 include/rdma/rdma_cm.h        |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1acf7..436e2467a36f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1064,6 +1064,19 @@ __rdma_create_kernel_id(struct net *net, rdma_cm_event_handler event_handler,
 }
 EXPORT_SYMBOL(__rdma_create_kernel_id);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key cma_listen_handler_mutex_key;
+void rdma_reclassify_id_for_listen(struct rdma_cm_id *id)
+{
+	struct rdma_id_private *id_priv;
+
+	id_priv = container_of(id, struct rdma_id_private, id);
+	lockdep_set_class(&id_priv->handler_mutex,
+			  &cma_listen_handler_mutex_key);
+}
+EXPORT_SYMBOL(rdma_reclassify_id_for_listen);
+#endif
+
 struct rdma_cm_id *rdma_create_user_id(rdma_cm_event_handler event_handler,
 				       void *context,
 				       enum rdma_ucm_port_space ps,
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index d639ff889e64..59dda4b0173e 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -158,6 +158,12 @@ struct rdma_cm_id *rdma_create_user_id(rdma_cm_event_handler event_handler,
 	__rdma_create_kernel_id(net, event_handler, context, ps, qp_type,      \
 				KBUILD_MODNAME)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+void rdma_reclassify_id_for_listen(struct rdma_cm_id *id);
+#else
+static inline void rdma_reclassify_id_for_listen(struct rdma_cm_id *id) {}
+#endif
+
 /**
   * rdma_destroy_id - Destroys an RDMA identifier.
   *
-- 
2.56.0

