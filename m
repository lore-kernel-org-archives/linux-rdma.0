Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6BD3612F4
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784573407; cv=none; b=jMEL2bNnJdkH5voG6guM67s6/CzxUOyqdpBBrWrGnHRRCf5NTer1jOOzKgRh1aDmUJp0qUBaAkaqMJyTBhicPdLbpRcK3ff8YPqhpEKhrPDWYbxuhhJWu4hMIZOpAHIFyslrwd3qkg/UuL8BEDIwh1Dm6f+biq5SjfM49BilfHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784573407; c=relaxed/simple;
	bh=V8QegDPA1ucXzNfwp1IItNCBavFQej1S4MQNpFDWQcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BUAK1TFBexRiEqVfbBWclSUlkmGBiEFkaAcbkBSR8MbHYXXo5E9lf6fP/X38W3tbpwlSq6qmEhdILsOd/j/WjmzdTfGfwAOtvAHdRw15gdALGeJSW7QfCxex72ZV/D1A8QG/CkFUKpDcg4fs5/GfjkJshEEuMhMse6h7PORhP6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebCjthYG; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebCjthYG"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca53979f8e8so848690a12.2
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 11:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784573404; x=1785178204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sxHcT8HFiLzGJ4nYxQqGgTijAjXRu6HWR5YSk3UWDU4=;
        b=ebCjthYGKdHiCA+kaGEayMJox9M8HA+RzmiaWelzE22wGEytRZABXbyyVyYd0eXa8I
         E7wzdoeWDyoO3zpihLlML3a0kkwn3+MrFJCoYhH3B0DbdA5ydcJ+xFXJX8eWzSNA/oBQ
         KEmWDirCntlmWfqg4vFr7ymPmBKuHE02kCn659Fh5CUTy24zHnOo0ljM1w4Ivv+83gMt
         RBJ0O9UoNncbDIXSLUnM8GtUf2p+NWAMa/3DzjHzlbOWRGlAItCAOSK+dY8xGvuDVeVL
         Lw61kA9k//brhrjTKtEcpHNg2X9bw0yOKe5x6OXX1bLFlJ3Qouer5j91zP9Na4DS1O+m
         4pUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784573404; x=1785178204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sxHcT8HFiLzGJ4nYxQqGgTijAjXRu6HWR5YSk3UWDU4=;
        b=OyX0O1Kpd+jX2Gp1dqsu20UtSFJ6fJ9DUw3RgbcFm8dzr8nMrFyL5wPgh68WB372To
         d37TJ+JrZ2aYYbMmk2dGKcBLJ61Eq6bkU9abnhu7FlqepwOFXLTjCNH4l8cEBDhjKgbG
         VmxL87B4Pzct3y23GjHiRKnQQ/Qn3WjFUvJ5pzh5LJoGuM7H5ndvlXzgGVEYd1nloTuB
         vtnejSMCGRHRDykRfKGeedOavhrIDJE3clwTCV715sEIsYwB1vHm/gh1pR59BY7EYDkv
         cZKqqwxMUV/XtRGFphLmkppwrUQY06/B9HttKbpylM3fiIcxMJ3BYdtiGzGDhH8wIrhm
         THYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrLw7tPEHK6ojwHRQF8PD94qwyHrn4W+Bs/radJIcDqQT1mbwMHVsZQNuo9e7ptT+P/L2wZ+EA6jzeR@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6x691Xm6e5p3Paoil6x5FnTSiQ6Y0M0IvmLvkn+DtTZLRMnCM
	r6LN8np0yP6L/iV5xQhgQaQaDZhu7szlSpjw0KLuEO1jUyXfh7kf0lTn
X-Gm-Gg: AfdE7cknSZWakeHAWXraSAQq7ReNx4sXb3Uf0IUp7RcA5Id1G/vAVwErzFAYSIYplBW
	jpNiLEPhGAqCzy83B3+UtqTuArskNo6KDxvIz38H4bY5NlgoEpvTBw3EIQdRhKn/uwMmhBhK1em
	D1TqgvUn1CVM2N8Qyyg3XlDGwjFlD6beOWvgU8bon9pcKGSYbSyOi1dhOR3h4iXzSpjH0Wgh9+D
	ni3+4fh9mwE3Ndd4A7ZzgVR1K3dh6vIEgKge7t8d/vAGTn2YDVGNp/4+hpJRrqwmsZAgzDC36q6
	u3xIRlq5UIMNjTLM68cdxOXaSe2Pl8kUYxvFSEEj3R0Mgk96iFfpJi9QUwNzpqgejjtCsU896V1
	3mW9d32+C/3qb4hBa2TAzsX49XHaS0DkKqogT5aB4hNiB8lkBhrPNw/Ic0KHbszrXoenkgZQfP4
	mrL1kraR3hP1vqz6IUdBk8Oy88SXj6CkvmTaddrm1tVvmMIfaunY9duR9Wj8PU2HFh3Nof
X-Received: by 2002:a05:6a20:9c8c:b0:3c3:5e14:461b with SMTP id adf61e73a8af0-3c40fa2d957mr138703637.5.1784573403439;
        Mon, 20 Jul 2026 11:50:03 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429ff04absm36349595eec.8.2026.07.20.11.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 11:50:02 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Allison Henderson <achender@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
	Dan Carpenter <error27@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] rds: synchronize info callbacks with connection teardown
Date: Tue, 21 Jul 2026 02:49:55 +0800
Message-ID: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_info_getsockopt() reads an info callback without holding
rds_info_lock across its invocation.  At the same time, rds_exit()
destroys all connections before unregistering the socket info callbacks.

This permits the following interleaving:

  CPU0                              CPU1
  rds_info_getsockopt()
    func = rds6_sock_inc_info
                                    rds_exit()
                                      rds_conn_exit()
                                        rds_conn_destroy()
                                          kmem_cache_free(conn)
    func()
      rds6_inc_info_copy()
        inc->i_conn->c_tos

The receive queue lock keeps the incoming message on its socket queue,
but it does not keep inc->i_conn alive.  KASAN reports:

  BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
  Read of size 1 at addr ffff888106031c50 by task poc/101
  Call Trace:
   rds6_inc_info_copy+0x459/0x530 [rds]
   rds6_sock_inc_info+0x2b9/0x3c0 [rds]
   rds_info_getsockopt+0x19d/0x380 [rds]
   do_sock_getsockopt+0x2ac/0x480
   __sys_getsockopt+0x128/0x210
  Allocated by task 99:
   kmem_cache_alloc_noprof+0x11a/0x360
   __rds_conn_create+0x7e/0xd60 [rds]
   rds_conn_create_outgoing+0x61/0x80 [rds]
   rds_sendmsg+0xb83/0x1d00 [rds]
  Freed by task 102:
   kmem_cache_free+0x1b5/0x3d0
   rds_conn_destroy+0x484/0x600 [rds]
   rds_loop_exit_net+0x32/0x50 [rds]
   unregister_pernet_device+0x2c/0x50
   rds_conn_exit+0x13/0xa0 [rds]
   rds_exit+0x1a/0xc40 [rds]
   __do_sys_delete_module+0x30a/0x4d0

Publish and clear callback pointers with SRCU, and keep the SRCU read-side
critical section across callback execution. SRCU permits callbacks such as
RDS_INFO_COUNTERS to sleep, unlike classic RCU. After clearing a slot,
synchronize_srcu() waits for every in-flight callback.
Move socket callback deregistration ahead of protocol and connection
teardown. This prevents callbacks from reaching a connection after it is
freed.

Fixes: 7d0a06586b26 ("net/rds: Fix info leak in rds6_inc_info_copy()")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/rds/af_rds.c | 12 ++++++------
 net/rds/info.c   | 20 ++++++++++++++------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e3..b3fe2bd6ea35 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -925,6 +925,12 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 static void rds_exit(void)
 {
 	sock_unregister(rds_family_ops.family);
+	rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
+	rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_info);
+#if IS_ENABLED(CONFIG_IPV6)
+	rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
+	rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
+#endif
 	proto_unregister(&rds_proto);
 	rds_conn_exit();
 	rds_cong_exit();
@@ -933,12 +939,6 @@ static void rds_exit(void)
 	rds_stats_exit();
 	rds_page_exit();
 	rds_bind_lock_destroy();
-	rds_info_deregister_func(RDS_INFO_SOCKETS, rds_sock_info);
-	rds_info_deregister_func(RDS_INFO_RECV_MESSAGES, rds_sock_inc_info);
-#if IS_ENABLED(CONFIG_IPV6)
-	rds_info_deregister_func(RDS6_INFO_SOCKETS, rds6_sock_info);
-	rds_info_deregister_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
-#endif
 }
 module_exit(rds_exit);
 
diff --git a/net/rds/info.c b/net/rds/info.c
index 21b32eb16559..7d6f3552d65b 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -32,6 +32,7 @@
  */
 #include <linux/percpu.h>
 #include <linux/seq_file.h>
+#include <linux/srcu.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/export.h>
@@ -68,8 +69,9 @@ struct rds_info_iterator {
 	unsigned long offset;
 };
 
+DEFINE_STATIC_SRCU(rds_info_srcu);
 static DEFINE_SPINLOCK(rds_info_lock);
-static rds_info_func rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1];
+static rds_info_func __rcu rds_info_funcs[RDS_INFO_LAST - RDS_INFO_FIRST + 1];
 
 void rds_info_register_func(int optname, rds_info_func func)
 {
@@ -78,8 +80,8 @@ void rds_info_register_func(int optname, rds_info_func func)
 	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
 
 	spin_lock(&rds_info_lock);
-	BUG_ON(rds_info_funcs[offset]);
-	rds_info_funcs[offset] = func;
+	BUG_ON(rcu_access_pointer(rds_info_funcs[offset]));
+	rcu_assign_pointer(rds_info_funcs[offset], func);
 	spin_unlock(&rds_info_lock);
 }
 EXPORT_SYMBOL_GPL(rds_info_register_func);
@@ -91,9 +93,10 @@ void rds_info_deregister_func(int optname, rds_info_func func)
 	BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
 
 	spin_lock(&rds_info_lock);
-	BUG_ON(rds_info_funcs[offset] != func);
-	rds_info_funcs[offset] = NULL;
+	BUG_ON(rcu_access_pointer(rds_info_funcs[offset]) != func);
+	RCU_INIT_POINTER(rds_info_funcs[offset], NULL);
 	spin_unlock(&rds_info_lock);
+	synchronize_srcu(&rds_info_srcu);
 }
 EXPORT_SYMBOL_GPL(rds_info_deregister_func);
 
@@ -165,6 +168,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	int npages = 0;
 	int ret;
 	int len;
+	int srcu_idx;
 	int total;
 
 	len = opt->optlen;
@@ -214,8 +218,11 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	rdsdebug("len %d nr_pages %lu\n", len, nr_pages);
 
 call_func:
-	func = rds_info_funcs[optname - RDS_INFO_FIRST];
+	srcu_idx = srcu_read_lock(&rds_info_srcu);
+	func = srcu_dereference(rds_info_funcs[optname - RDS_INFO_FIRST],
+				&rds_info_srcu);
 	if (!func) {
+		srcu_read_unlock(&rds_info_srcu, srcu_idx);
 		ret = -ENOPROTOOPT;
 		goto out;
 	}
@@ -225,6 +232,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, sockopt_t *opt)
 	iter.offset = offset0;
 
 	func(sock, len, &iter, &lens);
+	srcu_read_unlock(&rds_info_srcu, srcu_idx);
 	BUG_ON(lens.each == 0);
 
 	total = lens.nr * lens.each;
-- 
2.43.0

