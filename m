Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57178382F08
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 12:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785846899; cv=none; b=kam3ff4M6AlK38FuYxUOmzIL+n7Rq/OYWIl7RjRdHXPvirjLo/h/yiuPOHUD6JXcXKAgnnCLd/H9yhwrHzMCtnclg+pZLz6SYvkckpD4ggRFnSTA9jVG2nl+SkpboyflKxmxllw2F5Dft/4p7dJ8IAMAEviaLn3ZDrMY3R+7Evk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785846899; c=relaxed/simple;
	bh=xvzx6jNSlsMnElj3JdiPx7NYYZ80ry82gdfZdzM/6/E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j7kUr6Ua0/31rWj3iw/Px1DdOWpmd1vNo09AC22nGRx4CHJBxNSgWClc5xb3OX/nwk7YWUxTv+HMlskT4QXV7o/6XIHqVdcErzphhapUoJYLpJkJdjfbxUQxB0f4r1/pFYjD7u5NE80fl/55qRAju81aBUOb28ecUFLN7r7/i2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TgsAtjym; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TgsAtjym"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2caced6038eso11881075ad.0
        for <linux-rdma@vger.kernel.org>; Tue, 04 Aug 2026 05:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785846896; x=1786451696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CB1U22h59ehvXfT2urrNAh9x6cLRqc+DhUPBJEXZPtY=;
        b=TgsAtjym+JauGZITblkq2/wv8Rt71NgbklCUFYV7f6fJ42+CY36ESviPPPJhlMChfT
         s83gYQ1rda7PS8CWkAhR9iwdwwMPN79TZOxOznHRt7ziCtRAjf1xaS4uzc+Qn8/meD3b
         utmCmwnZmJEOtx1ZNsqZgso4KFjaQzSjhP65Yr0NufcUsTBwtnl9fXbGoXzJMB2l9Gcc
         2aBon0QoKkYPYqn9uY63JRAuccukPP7fTSsyQc3W5xT0nmzFx3BAuIqgejZpGlS0WfVR
         Y5EN/znE+/NGvY2XyQNTnvr/UZwwGVCp3uQEX4/K18uIGPpvABiO2sAUVWSkXYfjS+MH
         B4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785846896; x=1786451696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CB1U22h59ehvXfT2urrNAh9x6cLRqc+DhUPBJEXZPtY=;
        b=ffTJmQVU2qgS70mAvwKWuWwaVf3Ey7bbn0ABco7H/My2Zs1RVs8/4OFk61h0cYErh1
         KSwIJHgvGS/l9LNnjL/XNj0g23isUnb6Hzg4OkR5sOxpaZbIPPyGLjc3NdyKwtMALLSs
         Th8FsoLkWBoI5VixbeMzxE2mleCWAdgpCfQpXwqbY0prp2/oMjkcgSGmJy9/Gr0xU/E3
         0no5XGmLLskK7J4zZCQJDopV3E4Ia+505/V97H5UlAfQ5AuWouTlpg/x820jComgVs2P
         d7rylsYuc7i3IrbWljCb7kl1uhrEYBBS6qoUTGwy0Fo0OaHC06oRBiTgPDuKiDizl4lW
         e2aQ==
X-Gm-Message-State: AOJu0Yw3wLYmGmVfVXGGlHWvPgQtdNT8P5xdyoZpK7XcgDChMedTFDm5
	nWqPACS+AOcWBxL/RHCyLQ9LU0w52FXoL6z5fhtywh3NiC7Xt2goNh3p
X-Gm-Gg: AR+sD12lYQ0ISavj1PvqCI//kBEnH1wBwQTPjepvy1ybVMKQxHqGxRB6nEMZbYOB02H
	1b7FR3gaDt6FQbaljlnfd2vIu7YdDR/DsKr5nC6j96aGEb/Yey0uRO+Wjktf356x162ecD/ZqSb
	YcAQrqiPzsKFR64NpXug/Ix70DFymj1iBtgCaKylHb54GO16EZuJD6R4P5SRVPMEDNxmwLhMLzT
	IpHS+cv/lhUmRdkT+OyvBOwc/0JNXkXDhqQknpJZcRRbFiMO79eFpIasRooeRyPKuqML1HNEuU0
	QcEQBF5R4yB/1WCQgMEfvU2N8vudqJCTqbhxk8oewLTxoN79X5HAKLsQZKv762N14y82acDC2/B
	dEeoGMSUmQ5I8SU2vZxAGTooX5bqaDPUVeyHCE4M2bja7Q2b/+VEQKdiWze5dWwJkJfZQYdPcQB
	8Z4n/Ct3hLUkR4rTUjPwpqZnG3jQg9oC07pCdrAqNAc/DREWiGcCqQj6XwdEaDZ0SCVg326x/Rf
	j7Q91eYV2b16BG2WGEM6WFwRqthmQG+fH7uJ7pd8eaocA==
X-Received: by 2002:a17:903:2ecb:b0:2cf:70d2:da7c with SMTP id d9443c01a7336-2d08aa7fdddmr31872815ad.12.1785846896392;
        Tue, 04 Aug 2026 05:34:56 -0700 (PDT)
Received: from chcpu15.cse.ust.hk (191host116.mobilenet.cse.ust.hk. [143.89.191.116])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9f9370esm7101365ad.8.2026.08.04.05.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:34:55 -0700 (PDT)
From: Qi Zhang <marsy12010123@gmail.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org,
	Qi Zhang <marsy12010123@gmail.com>
Subject: [PATCH net] net/smc: prevent device removal during connection setup
Date: Tue,  4 Aug 2026 20:34:18 +0800
Message-Id: <20260804123418.2214979-1-marsy12010123@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Track selected-device users separately from established links. Acquire a
selection reference while smc_ib_devices.mutex protects the device list,
and release it when the connection initialization data is discarded. After
delisting a device, wait for these users before terminating its links. This
lets in-flight setup either fail or make any newly created link visible to
the termination pass, while delisting prevents new users.

Fixes: a046d57da19f ("smc: CLC handshake (incl. preparation steps)")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Qi Zhang <marsy12010123@gmail.com>
---
 net/smc/af_smc.c   | 11 +++++++----
 net/smc/smc_core.c | 11 +++++++++++
 net/smc/smc_core.h |  3 +++
 net/smc/smc_ib.c   |  5 +++++
 net/smc/smc_ib.h   | 13 +++++++++++++
 net/smc/smc_llc.c  |  8 ++++----
 net/smc/smc_pnet.c |  8 ++++++++
 7 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b5db69073e20..160271464305 100644
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
 
@@ -2343,7 +2343,10 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 
 not_found:
 	ini->smcr_version &= ~SMC_V2;
+	if (ini->smcrv2.ib_dev_v2_ref)
+		smc_ibdev_init_put(ini->smcrv2.ib_dev_v2);
 	ini->smcrv2.ib_dev_v2 = NULL;
+	ini->smcrv2.ib_dev_v2_ref = false;
 	ini->check_smcrv2 = false;
 }
 
@@ -2587,7 +2590,7 @@ static void smc_listen_work(struct work_struct *work)
 	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0,
 			   proposal_version);
 out_free:
-	kfree(ini);
+	smc_init_info_free(ini);
 	kfree(buf);
 }
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cf6b620fef05..e59f327f294c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -55,6 +55,17 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 
 static void smc_link_down_work(struct work_struct *work);
 
+void smc_init_info_free(struct smc_init_info *ini)
+{
+	if (!ini)
+		return;
+	if (ini->ib_dev_ref)
+		smc_ibdev_init_put(ini->ib_dev);
+	if (ini->smcrv2.ib_dev_v2_ref)
+		smc_ibdev_init_put(ini->smcrv2.ib_dev_v2);
+	kfree(ini);
+}
+
 /* return head of link group list and its lock for a given link group */
 static inline struct list_head *smc_lgr_list_head(struct smc_link_group *lgr,
 						  spinlock_t **lgr_lock)
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 5c18f08a4c8a..385f16cc5368 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -403,6 +403,7 @@ struct smc_init_info_smcrv2 {
 
 	/* Output fields when saddr is set */
 	struct smc_ib_device	*ib_dev_v2;
+	bool			ib_dev_v2_ref;
 	u8			ib_port_v2;
 	u8			ib_gid_v2[SMC_GID_SIZE];
 
@@ -438,6 +439,7 @@ struct smc_init_info {
 	u8			peer_mac[ETH_ALEN];
 	u8			peer_systemid[SMC_SYSTEMID_LEN];
 	struct smc_ib_device	*ib_dev;
+	bool			ib_dev_ref;
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
index 9bb495707445..01c9b5c62df7 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -950,6 +950,8 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 
 	smcibdev->ibdev = ibdev;
 	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
+	atomic_set(&smcibdev->init_cnt, 0);
+	init_waitqueue_head(&smcibdev->init_wait);
 	atomic_set(&smcibdev->lnk_cnt, 0);
 	init_waitqueue_head(&smcibdev->lnks_deleted);
 	mutex_init(&smcibdev->mutex);
@@ -1000,6 +1002,9 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 	mutex_unlock(&smc_ib_devices.mutex);
 	pr_warn_ratelimited("smc: removing ib device %s\n",
 			    smcibdev->ibdev->name);
+	if (atomic_read(&smcibdev->init_cnt))
+		wait_event(smcibdev->init_wait,
+			   !atomic_read(&smcibdev->init_cnt));
 	smc_smcr_terminate_all(smcibdev);
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index ef8ac2b7546d..8e9fd5a200a2 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -51,6 +51,8 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct work_struct	port_event_work;
 	unsigned long		port_event_mask;
 	DECLARE_BITMAP(ports_going_away, SMC_MAX_PORTS);
+	atomic_t		init_cnt;	/* number of device selections */
+	wait_queue_head_t	init_wait;	/* wait for selections to end */
 	atomic_t		lnk_cnt;	/* number of links on ibdev */
 	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
 	struct mutex		mutex;		/* protect dev setup+cleanup */
@@ -59,6 +61,17 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	int			ndev_ifidx[SMC_MAX_PORTS]; /* ndev if indexes */
 };
 
+static inline void smc_ibdev_init_get(struct smc_ib_device *smcibdev)
+{
+	atomic_inc(&smcibdev->init_cnt);
+}
+
+static inline void smc_ibdev_init_put(struct smc_ib_device *smcibdev)
+{
+	if (atomic_dec_and_test(&smcibdev->init_cnt))
+		wake_up(&smcibdev->init_wait);
+}
+
 static inline __be32 smc_ib_gid_to_ipv4(u8 gid[SMC_GID_SIZE])
 {
 	struct in6_addr *addr6 = (struct in6_addr *)gid;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 954b2ff1815c..15ae19a9db07 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1118,7 +1118,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 out_reject:
 	smc_llc_cli_add_link_reject(qentry);
 out:
-	kfree(ini);
+	smc_init_info_free(ini);
 	kfree(qentry);
 	return rc;
 }
@@ -1192,7 +1192,7 @@ static void smc_llc_cli_add_link_invite(struct smc_link *link,
 	smc_llc_send_add_link(link, ini->ib_dev->mac[ini->ib_port - 1],
 			      ini->ib_gid, NULL, SMC_LLC_REQ);
 out:
-	kfree(ini);
+	smc_init_info_free(ini);
 	kfree(qentry);
 }
 
@@ -1512,7 +1512,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
 	if (rc)
 		goto out_err;
-	kfree(ini);
+	smc_init_info_free(ini);
 	return 0;
 out_err:
 	if (link_new) {
@@ -1520,7 +1520,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 		smcr_link_clear(link_new, false);
 	}
 out:
-	kfree(ini);
+	smc_init_info_free(ini);
 	if (send_req_add_link_resp)
 		smc_llc_send_req_add_link_response(req_qentry);
 	return rc;
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 63e286e2dfaa..7e01e01a522b 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -980,14 +980,22 @@ static int smc_pnet_determine_gid(struct smc_ib_device *ibdev, int i,
 	if (!ini->check_smcrv2 &&
 	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->ib_gid, NULL,
 				  NULL)) {
+		if (ini->ib_dev_ref)
+			smc_ibdev_init_put(ini->ib_dev);
+		smc_ibdev_init_get(ibdev);
 		ini->ib_dev = ibdev;
+		ini->ib_dev_ref = true;
 		ini->ib_port = i;
 		return 0;
 	}
 	if (ini->check_smcrv2 &&
 	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->smcrv2.ib_gid_v2,
 				  NULL, &ini->smcrv2)) {
+		if (ini->smcrv2.ib_dev_v2_ref)
+			smc_ibdev_init_put(ini->smcrv2.ib_dev_v2);
+		smc_ibdev_init_get(ibdev);
 		ini->smcrv2.ib_dev_v2 = ibdev;
+		ini->smcrv2.ib_dev_v2_ref = true;
 		ini->smcrv2.ib_port_v2 = i;
 		return 0;
 	}
-- 
2.43.0

