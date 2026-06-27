Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3E3C2D
	for <linux-rdma@vger.kernel.org>; Sat, 27 Jun 2026 01:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782525001; cv=none; b=mxkqbkp3R97EZ/kWuE5lTJnSX8yCKw9Ehq3S907CHIKawwa0gmQX5S0BwrUiZTRH6VhE+6o9GCOaq6vadI1r0cONS3ZPrHAVy75mOiS5nLU4wCIx+3mCKPrOAEcuej1GOJbSgEaU91VwS5uUFBAOwk9tT4sh4Sy0wxbMJqDl36M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782525001; c=relaxed/simple;
	bh=xDiA5DuL4aSX/vjh9grRbpSo0KLZ0CotQ9L65uuTUbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tvIOziiIL+mrj1GuceQqChSPWkDeXdPsGN9whUNWKPhqQDqr5zOGipdzJGBWWIs3C2YvgWkazCap0JXSRj++y1FYAsG9n/KgkAv9z46ae6+M2AuQZslmBiH/QD8kB2KkAQ6S/9WElL+js65qwtmCiFmsZq3niOXvpVQ/gzK5UUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=S9aM0awI; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="S9aM0awI"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c6b67d5fa1so9769645ad.2
        for <linux-rdma@vger.kernel.org>; Fri, 26 Jun 2026 18:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782524998; x=1783129798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0UXUHUjId2cfil9ag+usZlcPYF1aU0mFhw0ihbgDIPo=;
        b=S9aM0awI95G7mptiCcJ+G2ETgRS/x7J+8Ql8Hu4IAfaY6auAxhZt9Ssxd6UwHfag6d
         uUDhZR5rftaulBjB5vTevsGUXmoRUBRZrtw3xRnKUOk5qQcRlaio2aU4kFQY6RiJK7GI
         zE+yXEcRaJRBc1EmKU5p0YT01dmCr+jSkQO/suQjAhOQAr9DEvWl1VDiDGGb26Jyh52/
         oNfB6UJCPh6/U1DsILrFMCLXP156ZUpYjgCXkT/cJiKo9Pu+wNJB/srYNVE+czSgAqbI
         /IvaU8HSCcuBYYbvNFTRHqGAg4sln+/wpmOolbcA3vqjpa0I8uMaAx0k89fnjJhg7aPT
         GF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782524998; x=1783129798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UXUHUjId2cfil9ag+usZlcPYF1aU0mFhw0ihbgDIPo=;
        b=QDAf3uDZa9AiJ8yLllMeda3jIP4Q+J1hXuvVg6blzlbOTYhD1pGSZXeYVFxklB37jd
         t94UDp/AmG+icNo61a7d6FbBqNweFtM18mg+IISyjgBufkCD0gNo0s1jtQrQhDzG4SW1
         xhxDLrl6/k1mOsQ8ZI6BaTPvOx4ag2mc0UjvS+RXzqrC/4eQMeAfO97/mZPDP4Puk5n1
         Nml4prOBengC2vzXCpS+3pujXFaEtXR7jYsn2c/8KdeMIpGxRYD3RwrN5oAxs+8KYzNH
         4nevnjjUN2GlzTy1/V02p80YZlydj8kwec2lTfhDj4C+fWaYW/+gqN6G9hG2YqbasiIf
         0jww==
X-Forwarded-Encrypted: i=1; AHgh+RowvCvs0z4lL777y00x9+KLtPJbmCKxRQBNnjwcBhPxqcb6n88EnUcdWWUUsWHfYFjNVtAQF280MvfY@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd9b6hwl/dZQ61mBEzENr+EpFkjqUAcnEa19QKmTCcLCYINVT/
	DTM+32cQWH83bGfPtwGA2c8y9lFoBdZE/C749+RE8M8RJDWK+CWJdZ6+93oM2Ilq1iqeDgftXVI
	cDeF2JQ==
X-Gm-Gg: AfdE7ckFYQ0KY6EAJvOUr0JtzQue244Wy3LrvwqpieZ6LXO9D6jkjJU7SkmP/F17kd9
	v+qAWrXd86Hwv5ykOPwbHvnIulCgkPnUQnn9rnhDynU6ne8M0r+mZJN5vaMKviiTGBluDGxy0T2
	puMPi5F/kcZ6drP5Qp71kfI+g22oRfn/EhUUzKvxYB58bSPSjWDpV326cwuLj392ePix8wKQ7Tm
	hVNUrFPn8/PR/c0rGjEqSh4zJRs2WhUjDL9gnnGiodCrCWHnUtXDlm6CHKYywoW/0oHzZZGTuPb
	22XSepHM3Mu9CWJ1cAXyV2XAjFZrMBT+3H++nXwQTcXYGH5DoJN5MfkmY0pH2Ipmr3zPAe0hyfz
	bIe/GcEr/ZNUabPHNz77IhPm27uXdSi/5LeV+VfVLZH2FqO8CIpNJP0nu7Hqq0aMVV3K56Vs6BQ
	==
X-Received: by 2002:a17:903:160c:b0:2c0:ca99:3d73 with SMTP id d9443c01a7336-2c7fc665c91mr88173025ad.8.1782524998436;
        Fri, 26 Jun 2026 18:49:58 -0700 (PDT)
Received: from p1.. ([2607:fb91:15af:c6b3:c760:3f53:87ef:d98c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5afdd40sm48970995ad.33.2026.06.26.18.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:49:58 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: "D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Hans Wippel <hwippel@linux.ibm.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH net] net/smc: fix UAF in smc_cdc_rx_handler() by pinning the socket
Date: Fri, 26 Jun 2026 18:49:48 -0700
Message-ID: <20260627014948.3049512-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_cdc_rx_handler() looks up the connection by token under the link
group's conns_lock, drops the lock, and then dereferences conn and the
smc_sock derived from it, ending in sock_hold(&smc->sk) inside
smc_cdc_msg_recv(). No reference is held across the lock release.

The only reference pinning the socket while the connection is
discoverable in the link group is taken in smc_lgr_register_conn()
(sock_hold) and dropped in __smc_lgr_unregister_conn() (sock_put), both
under conns_lock. Once the handler drops conns_lock, a concurrent
close() -> smc_release() -> smc_conn_free() -> smc_lgr_unregister_conn()
can drop that reference and free the smc_sock, so the handler's later
sock_hold() runs on freed memory:

  WARNING: lib/refcount.c:25 at refcount_warn_saturate
  Workqueue: rxe_wq do_work
   refcount_warn_saturate (lib/refcount.c:25)
   smc_cdc_msg_recv (net/smc/smc_cdc.c:430)
   smc_cdc_rx_handler (net/smc/smc_cdc.c:502)
   smc_wr_rx_tasklet_fn (net/smc/smc_wr.c:445)
   tasklet_action_common (kernel/softirq.c:938)
   handle_softirqs (kernel/softirq.c:622)
  Kernel panic - not syncing: panic_on_warn set

Only SMC-R is affected. The SMC-D receive tasklet is stopped by
tasklet_kill(&conn->rx_tsklet) in smc_conn_free() before the connection
is unregistered, so it cannot run concurrently with the free.

Take the socket reference while still holding conns_lock, so the
registration reference can no longer be the last one, and drop it once
the handler is done.

Fixes: d7b0e37c1ac1 ("net/smc: restructure CDC message reception")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/smc/smc_cdc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 619b3bab3824..b809139d7e87 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -483,21 +483,27 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 	lgr = smc_get_lgr(link);
 	read_lock_bh(&lgr->conns_lock);
 	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
+	if (conn && !conn->out_of_sync)
+		sock_hold(&container_of(conn, struct smc_sock, conn)->sk);
+	else
+		conn = NULL;
 	read_unlock_bh(&lgr->conns_lock);
-	if (!conn || conn->out_of_sync)
+	if (!conn)
 		return;
 	smc = container_of(conn, struct smc_sock, conn);
 
 	if (cdc->prod_flags.failover_validation) {
 		smc_cdc_msg_validate(smc, cdc, link);
-		return;
+		goto out;
 	}
 	if (smc_cdc_before(ntohs(cdc->seqno),
 			   conn->local_rx_ctrl.seqno))
 		/* received seqno is old */
-		return;
+		goto out;
 
 	smc_cdc_msg_recv(smc, cdc);
+out:
+	sock_put(&smc->sk);
 }
 
 static struct smc_wr_rx_handler smc_cdc_rx_handlers[] = {
-- 
2.43.0

