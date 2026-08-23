Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550A7322B9F
	for <linux-rdma@vger.kernel.org>; Sun, 23 Aug 2026 07:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787469595; cv=none; b=XB4Y+Szc9VcFQx0H8wNdrnJPBZ9EhEeB7ZmDhReRRsiyK4JLVTYdugaibikBkI7nVEfGgh4RGaLRZHZaGhO3vuU4IQVJ64c1CkOwztP0kYAHhEEtqpNCfPIeps8BVtGtfnRcQT0VHx12bTqH5t/yY+PJhVTyGqEaPlc+t+2EadQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787469595; c=relaxed/simple;
	bh=soPX9URTqu+PEA5vsxlPEJtSFHBOiIVK5TIIyiXZW9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tAXOxXCHtyre5EmP/n8ikuRVHsFwAkSjRgMEcKGM8URIpq0bY4GxNGbYPEMQiLkGYA7uYTM1QIzmZF7Gc8T8RnPDfZoRFq7PHJLEYGnlvS4qVu/KlUuzuc+Lo9cRT0CKsDwK4PtHKtvt2rOaEK01P9L1A+ku6UBW9RK8XOOqSe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FO1+ab+i; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO1+ab+i"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caea3f742bso38643425ad.0
        for <linux-rdma@vger.kernel.org>; Sun, 23 Aug 2026 00:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787469593; x=1788074393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DrGHq8r3D01YmLa3ynPoRNi1Se8roY1+DBnK05JQYrk=;
        b=FO1+ab+iJhJJGYLgrHlAECVDIQ1nGs7P0su931NS5IcIR7MnKcXXFMi79edtV7jReh
         t1b7vDOP/In0xd6H80svk2cDoy512vHFa9I3N74YVjHOJqtIcDz4AnSREUdtllEA21Ri
         /RdwkOO9oPjAaOGhdft4nNEr5k4eNlZCb+rpNFI7W32CHdXl1jvslD1pQQGbh9xom2LI
         VJhzwPu4wCDTTfkDgz9FWNqnmrtwPF/4jsFkcYCQZRE0KO2IDJrZgeS18HSNyYf0ljuw
         3lG8/Y1NJ+CSKT0HNu7IhEsNS28MfpnIlCj+yuLRV73hQRw8MBS7iAaTX0qB3bWySNF8
         oAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787469593; x=1788074393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DrGHq8r3D01YmLa3ynPoRNi1Se8roY1+DBnK05JQYrk=;
        b=pLoOiqtk0Dv3CXsY/oBloBCjcogoDK051mtCgSZ62H+I8AVaXb1yzwnMUIbj+BtCLC
         G+jRmrkWk3MKI14nlydy7XuyOPP9BJi0q1BH647QaCGTuErjgSHaM7F7GRhA2qgy4fvm
         Id1vEAVK3gYrwVywba6TdTtVQ96m2/HtU/Av6ewMsvJHZ+67UqnyqYIlsNDVXFmdKb0w
         1hsj1FjwJ7Nr2ob5M7tVrLO5eUSwDhTgSbUy2w7QtCbgXC2A/Sp9SmM6046xG8Pvz4lP
         sA4pCim6F7s4sLYI2QoD+9k4otmFqkNpvuJQk0/VmnXKzqzu+TsKljv4U9dnd4yd+JOC
         jHMg==
X-Forwarded-Encrypted: i=1; AHgh+RrFVzK6EMn2Juu4IEbtkvPB0HS56zV2ppzMKYbhBsobBavNfSIPYUypYQxsqsfOqOFamyvzV5W7HqjA@vger.kernel.org
X-Gm-Message-State: AFuF++nRt/63GEjPdHR2ee/xA5GJUJiSXD5U7EUU6BrjY2bBsb/kTFcx
	oUShEC0bwFE1Fe1BRrn22eMra+L5eeJQKhQxWS8/FNIiq8OJzudNqCR0
X-Gm-Gg: AR+sD125nKxtiyN7Jws2d5+I7QJXUAFA8YYpjnNrttwab3JE+r9XDvr4PKI9F02FRUm
	/TJwaFNS60dl4+5sCku85ifB3lK5tfoq+guA0bwzOZoDTGRoitOdmXuNAYnSK3ZIbmutTBj8Jwg
	F2jKM86hILUG+4x39usjBVeIlIQwkkjTXbOH6nSq//3GFpIwIlXuN5+248eB9n+aglQB3Lsd1hR
	5NVrUF3h/bidHTv1qXy2RBuOmghDAS9yb2oIG072eRcHM7OwQMwGYwdRLSW/Xv/D6dbahh8xm7K
	El6ymVKDVHl5Wdn5dsZfyPa2uoO6S7Lsi5R5tJgxIRz2dvrITZUNMkbIcXldY9h2SXqbbcVoxkX
	9b8N8UUoEzdEOQJPx+0/Lw3AE11UltKpaDVQS6xfKROcIkJQbzU2y5VlV1BDObhBr4zBlU+pdHE
	veMAAu/uBCMo9rUD8gFtXV0ylJPCshD3xX2jO14iXrW0kW0YqEgo32eixbyWPHC/mc7OPJHG1oR
	QXAkoakiJ92ITkctUXgraZACDA7XVOuQ43CxgK3z4ycP4SCUNB6ySoNgJv/xB/pr23/3bOO9/JT
	PTTu+bs=
X-Received: by 2002:a05:6a21:1644:b0:3bf:ba48:ca88 with SMTP id adf61e73a8af0-3cd3011c9e3mr35880462637.15.1787469592503;
        Sun, 23 Aug 2026 00:19:52 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([45.135.228.94])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209f51sm22644122eec.22.2026.08.23.00.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 00:19:51 -0700 (PDT)
From: Qi Zhang <marsy12010123@gmail.com>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	nicoyip.dev@gmail.com,
	Qi Zhang <marsy12010123@gmail.com>
Subject: [PATCH net v2] net/smc: prevent device removal during connection setup
Date: Sun, 23 Aug 2026 15:19:08 +0800
Message-ID: <20260823071908.93212-1-marsy12010123@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <nicoyip.dev@gmail.com>

smc_pnet_determine_gid() stores an smc_ib_device pointer in connection
initialization data while holding smc_ib_devices.mutex. Connection setup
keeps using the pointer after releasing the mutex, but device removal only
waits for links which have already incremented lnk_cnt.

This permits the following interleaving:

  connection setup                 device removal
  ----------------                 --------------
  select smcibdev
  store ini->smcrv2.ib_dev_v2
  mutex_unlock()
                                   remove smcibdev from the device list
                                   observe lnk_cnt == 0
                                   return from the remove callback
                                   kfree(smcibdev)
  copy smcibdev->pnetid

KASAN reported:

  BUG: KASAN: slab-use-after-free in smc_conn_create+0x1330/0x2680
  Read of size 16 at addr ffff888112dbd934 by task smc_bug86/97
  Call Trace:
   __asan_memcpy
   smc_conn_create
   __smc_connect
   smc_connect
   __sys_connect
  Allocated by task 93:
   smc_ib_add_dev
   add_client_context
   ib_register_device
   nldev_newlink
  Freed by task 98:
   kfree
   remove_client_context
   __ib_unregister_device
   nldev_dellink

Hold a lifetime reference on every SMCR device selected for connection
setup. The reference also pins the underlying ib_device, but does not make
device removal wait for the peer-controlled CLC handshake.

Before turning the selection into a link, check under
smc_ib_devices.mutex that the device is still registered. Track only the
short local interval between that check and publishing the new link group.
Device removal waits for this interval before terminating links, ensuring
that it cannot miss a link being created concurrently. Keep the lifetime
reference until after the final counter decrement and wakeup, and serialize
begin/end with device delisting so no thread touches a freed smcibdev.

This change is limited to the reported SMCR lifetime race. SMC-D device
selection has a similar pre-existing borrowed-pointer lifetime issue and
requires a separate fix.

Fixes: a046d57da19f ("smc: CLC handshake (incl. preparation steps)")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Qi Zhang <marsy12010123@gmail.com>
---
Changes in v2:
- Replace the handshake-long removal wait with a lifetime reference that
  defers object release without blocking device removal.
- Revalidate the selected device and wait only while a new link is being
  published, so the removal-side termination pass cannot miss it.
- Keep a lifetime reference across the final publication-counter decrement
  and wakeup, and serialize begin/end with device delisting to close the
  reviewed wake-after-free window.
- Explicitly scope this patch to SMC-R; the analogous pre-existing SMC-D
  borrowed-pointer lifetime issue requires a separate fix.
- Rebase onto net/main at 7cbfb180945c and preserve the intervening LLC
  qentry lifetime fixes.

v1: https://lore.kernel.org/r/20260804123418.2214979-1-marsy12010123@gmail.com
Review: https://lore.kernel.org/r/20260805151051.GV51943@horms.kernel.org

 net/smc/af_smc.c   | 11 +++++++----
 net/smc/smc_core.c | 29 ++++++++++++++++++++++++----
 net/smc/smc_core.h |  3 +++
 net/smc/smc_ib.c   | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_ib.h   |  9 +++++++++
 net/smc/smc_llc.c  |  8 +++++---
 net/smc/smc_pnet.c |  8 ++++++++
 7 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..d781dee1b329 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1225,7 +1225,7 @@ void smc_fill_gid_list(struct smc_link_group *lgr,
 	       SMC_GID_SIZE);
 
 out:
-	kfree(alt_ini);
+	smc_init_info_free(alt_ini);
 }
 
 static int smc_connect_rdma_v2_prepare(struct smc_sock *smc,
@@ -1596,14 +1596,14 @@ static int __smc_connect(struct smc_sock *smc)
 	SMC_STAT_CLNT_SUCC_INC(sock_net(smc->clcsock->sk), aclc);
 	smc_connect_ism_vlan_cleanup(ini);
 	kfree(buf);
-	kfree(ini);
+	smc_init_info_free(ini);
 	return 0;
 
 vlan_cleanup:
 	smc_connect_ism_vlan_cleanup(ini);
 	kfree(buf);
 fallback:
-	kfree(ini);
+	smc_init_info_free(ini);
 	return smc_connect_decline_fallback(smc, rc, version);
 }
 
@@ -2344,7 +2344,10 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 
 not_found:
 	ini->smcr_version &= ~SMC_V2;
+	if (ini->smcrv2.ib_dev_v2_ref)
+		smc_ibdev_put(ini->smcrv2.ib_dev_v2);
 	ini->smcrv2.ib_dev_v2 = NULL;
+	ini->smcrv2.ib_dev_v2_ref = false;
 	ini->check_smcrv2 = false;
 }
 
@@ -2588,7 +2591,7 @@ static void smc_listen_work(struct work_struct *work)
 	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0,
 			   proposal_version);
 out_free:
-	kfree(ini);
+	smc_init_info_free(ini);
 	kfree(buf);
 }
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 181647982490..d97bc7323106 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -55,6 +55,17 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 
 static void smc_link_down_work(struct work_struct *work);
 
+void smc_init_info_free(struct smc_init_info *ini)
+{
+	if (!ini)
+		return;
+	if (ini->ib_dev_ref)
+		smc_ibdev_put(ini->ib_dev);
+	if (ini->smcrv2.ib_dev_v2_ref)
+		smc_ibdev_put(ini->smcrv2.ib_dev_v2);
+	kfree(ini);
+}
+
 /* return head of link group list and its lock for a given link group */
 static inline struct list_head *smc_lgr_list_head(struct smc_link_group *lgr,
 						  spinlock_t **lgr_lock)
@@ -793,14 +804,21 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	int rc;
 
 	if (lgr->smc_version == SMC_V2) {
-		lnk->smcibdev = ini->smcrv2.ib_dev_v2;
+		smcibdev = ini->smcrv2.ib_dev_v2;
 		lnk->ibport = ini->smcrv2.ib_port_v2;
-		lnk->wr_rx_sge_cnt = lnk->smcibdev->ibdev->attrs.max_recv_sge < 2 ? 1 : 2;
+	} else {
+		smcibdev = ini->ib_dev;
+		lnk->ibport = ini->ib_port;
+	}
+	rc = smc_ibdev_init_begin(smcibdev);
+	if (rc)
+		return rc;
+	lnk->smcibdev = smcibdev;
+	if (lgr->smc_version == SMC_V2) {
+		lnk->wr_rx_sge_cnt = smcibdev->ibdev->attrs.max_recv_sge < 2 ? 1 : 2;
 		lnk->wr_rx_buflen = smc_link_shared_v2_rxbuf(lnk) ?
 			SMC_WR_BUF_SIZE : SMC_WR_BUF_V2_SIZE;
 	} else {
-		lnk->smcibdev = ini->ib_dev;
-		lnk->ibport = ini->ib_port;
 		lnk->wr_rx_sge_cnt = 1;
 		lnk->wr_rx_buflen = SMC_WR_BUF_SIZE;
 	}
@@ -882,6 +900,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	if (!atomic_dec_return(&smcibdev->lnk_cnt))
 		wake_up(&smcibdev->lnks_deleted);
 	smc_lgr_put(lgr); /* lgr_hold above */
+	smc_ibdev_init_end(smcibdev);
 	return rc;
 }
 
@@ -997,6 +1016,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	spin_lock_bh(lgr_lock);
 	list_add_tail(&lgr->list, lgr_list);
 	spin_unlock_bh(lgr_lock);
+	if (!ini->is_smcd)
+		smc_ibdev_init_end(lnk->smcibdev);
 	return 0;
 
 free_wq:
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 5c18f08a4c8a..9f5a69a30cb3 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -403,6 +403,7 @@ struct smc_init_info_smcrv2 {
 
 	/* Output fields when saddr is set */
 	struct smc_ib_device	*ib_dev_v2;
+	bool			ib_dev_v2_ref; /* owns an smc_ibdev reference */
 	u8			ib_port_v2;
 	u8			ib_gid_v2[SMC_GID_SIZE];
 
@@ -438,6 +439,7 @@ struct smc_init_info {
 	u8			peer_mac[ETH_ALEN];
 	u8			peer_systemid[SMC_SYSTEMID_LEN];
 	struct smc_ib_device	*ib_dev;
+	bool			ib_dev_ref; /* owns an smc_ibdev reference */
 	u8			ib_gid[SMC_GID_SIZE];
 	u8			ib_port;
 	u32			ib_clcqpn;
@@ -594,6 +596,7 @@ void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn);
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn);
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini);
+void smc_init_info_free(struct smc_init_info *ini);
 
 void smc_conn_free(struct smc_connection *conn);
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 9bb495707445..d858453c64d9 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -934,6 +934,44 @@ void smc_ib_ndev_change(struct net_device *ndev, unsigned long event)
 	mutex_unlock(&smc_ib_devices.mutex);
 }
 
+static void smc_ibdev_release(struct smc_ib_device *smcibdev)
+{
+	put_device(&smcibdev->ibdev->dev);
+	kfree(smcibdev);
+}
+
+void smc_ibdev_get(struct smc_ib_device *smcibdev)
+{
+	refcount_inc(&smcibdev->refcnt);
+}
+
+void smc_ibdev_put(struct smc_ib_device *smcibdev)
+{
+	if (refcount_dec_and_test(&smcibdev->refcnt))
+		smc_ibdev_release(smcibdev);
+}
+
+int smc_ibdev_init_begin(struct smc_ib_device *smcibdev)
+{
+	int rc = 0;
+
+	mutex_lock(&smc_ib_devices.mutex);
+	if (list_empty(&smcibdev->list))
+		rc = -ENODEV;
+	else
+		atomic_inc(&smcibdev->init_cnt);
+	mutex_unlock(&smc_ib_devices.mutex);
+	return rc;
+}
+
+void smc_ibdev_init_end(struct smc_ib_device *smcibdev)
+{
+	mutex_lock(&smc_ib_devices.mutex);
+	if (atomic_dec_and_test(&smcibdev->init_cnt))
+		wake_up(&smcibdev->init_wait);
+	mutex_unlock(&smc_ib_devices.mutex);
+}
+
 /* callback function for ib_register_client() */
 static int smc_ib_add_dev(struct ib_device *ibdev)
 {
@@ -949,7 +987,11 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 		return -ENOMEM;
 
 	smcibdev->ibdev = ibdev;
+	get_device(&ibdev->dev);
+	refcount_set(&smcibdev->refcnt, 1);
 	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
+	atomic_set(&smcibdev->init_cnt, 0);
+	init_waitqueue_head(&smcibdev->init_wait);
 	atomic_set(&smcibdev->lnk_cnt, 0);
 	init_waitqueue_head(&smcibdev->lnks_deleted);
 	mutex_init(&smcibdev->mutex);
@@ -1000,11 +1042,14 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 	mutex_unlock(&smc_ib_devices.mutex);
 	pr_warn_ratelimited("smc: removing ib device %s\n",
 			    smcibdev->ibdev->name);
+	if (atomic_read(&smcibdev->init_cnt))
+		wait_event(smcibdev->init_wait,
+			   !atomic_read(&smcibdev->init_cnt));
 	smc_smcr_terminate_all(smcibdev);
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
 	cancel_work_sync(&smcibdev->port_event_work);
-	kfree(smcibdev);
+	smc_ibdev_put(smcibdev);
 }
 
 static struct ib_client smc_ib_client = {
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index ef8ac2b7546d..d32547350e8b 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/wait.h>
 #include <rdma/ib_verbs.h>
 #include <net/smc.h>
@@ -51,6 +52,9 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct work_struct	port_event_work;
 	unsigned long		port_event_mask;
 	DECLARE_BITMAP(ports_going_away, SMC_MAX_PORTS);
+	refcount_t		refcnt;		/* object lifetime */
+	atomic_t		init_cnt;	/* unpublished link initializations */
+	wait_queue_head_t	init_wait;	/* wait for links to be published */
 	atomic_t		lnk_cnt;	/* number of links on ibdev */
 	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
 	struct mutex		mutex;		/* protect dev setup+cleanup */
@@ -59,6 +63,11 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	int			ndev_ifidx[SMC_MAX_PORTS]; /* ndev if indexes */
 };
 
+void smc_ibdev_get(struct smc_ib_device *smcibdev);
+void smc_ibdev_put(struct smc_ib_device *smcibdev);
+int smc_ibdev_init_begin(struct smc_ib_device *smcibdev);
+void smc_ibdev_init_end(struct smc_ib_device *smcibdev);
+
 static inline __be32 smc_ib_gid_to_ipv4(u8 gid[SMC_GID_SIZE])
 {
 	struct in6_addr *addr6 = (struct in6_addr *)gid;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index c9ccd8480369..e16aaa514368 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1108,6 +1108,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	rc = smcr_link_init(lgr, lnk_new, lnk_idx, ini);
 	if (rc)
 		goto out_reject;
+	smc_ibdev_init_end(lnk_new->smcibdev);
 	smc_llc_save_add_link_info(lnk_new, llc);
 	lnk_new->link_id = llc->link_num;	/* SMC server assigns link id */
 	smc_llc_link_set_uid(lnk_new);
@@ -1143,7 +1144,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 out_reject:
 	smc_llc_cli_add_link_reject(qentry);
 out:
-	kfree(ini);
+	smc_init_info_free(ini);
 	kfree(qentry);
 	return rc;
 }
@@ -1217,7 +1218,7 @@ static void smc_llc_cli_add_link_invite(struct smc_link *link,
 	smc_llc_send_add_link(link, ini->ib_dev->mac[ini->ib_port - 1],
 			      ini->ib_gid, NULL, SMC_LLC_REQ);
 out:
-	kfree(ini);
+	smc_init_info_free(ini);
 	kfree(qentry);
 }
 
@@ -1487,6 +1488,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	if (rc)
 		goto out;
 	link_new = &lgr->lnk[lnk_idx];
+	smc_ibdev_init_end(link_new->smcibdev);
 
 	rc = smcr_buf_map_lgr(link_new);
 	if (rc)
@@ -1544,7 +1546,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	}
 out:
 	kfree(qentry);
-	kfree(ini);
+	smc_init_info_free(ini);
 	if (send_req_add_link_resp)
 		smc_llc_send_req_add_link_response(req_qentry);
 	return rc;
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 63e286e2dfaa..be1f5137c8ee 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -980,14 +980,22 @@ static int smc_pnet_determine_gid(struct smc_ib_device *ibdev, int i,
 	if (!ini->check_smcrv2 &&
 	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->ib_gid, NULL,
 				  NULL)) {
+		if (ini->ib_dev_ref)
+			smc_ibdev_put(ini->ib_dev);
+		smc_ibdev_get(ibdev);
 		ini->ib_dev = ibdev;
+		ini->ib_dev_ref = true;
 		ini->ib_port = i;
 		return 0;
 	}
 	if (ini->check_smcrv2 &&
 	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->smcrv2.ib_gid_v2,
 				  NULL, &ini->smcrv2)) {
+		if (ini->smcrv2.ib_dev_v2_ref)
+			smc_ibdev_put(ini->smcrv2.ib_dev_v2);
+		smc_ibdev_get(ibdev);
 		ini->smcrv2.ib_dev_v2 = ibdev;
+		ini->smcrv2.ib_dev_v2_ref = true;
 		ini->smcrv2.ib_port_v2 = i;
 		return 0;
 	}
-- 
2.25.1

