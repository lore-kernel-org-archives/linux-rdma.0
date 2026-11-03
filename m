Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676629;
	b=IFm5PeERCU3rrPELbzF6nl9AoMlLn5k6O4sCL5orYc+3H9e4DUY0gtgoP22Pi5orpoou
	 BU4jYacHsxHW98AtjaScMBipNe/GCQkZQQMRelgtXihfMb9ZtiS+YUm3ND/BR+1tLyomi
	 tGAyQ+YzntZ0boRlCfA+I2cc5YYHcaLaEmVDLJGZ1zPONvPvgX13Wy9BiYZJvCalOLkzi
	 /rMk9tWuw1y03z611tcr4kJ6azjegHn08BPbJyKeyook/DBsMBHTPeomnvbn4n+1qdyfO
	 YCfHq0DZ5Bxrhi3HSrl14XIdEbY9bK6MpGpuxvFWxSVk4CQp6quH2Edy3FhYELFEn0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676629;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HG7Is05GGnx6Xp1q3Juz1SqD92hs/Rh27uihZYQ1aPY=;
	b=tuUbDE9TUXL5spgQwJvHroGO1wKe1lXrfAP6JzyaUtdqxGx1r4laPtjvG5zI05bKSKU4
	 GDzUm6V0DbbsMRHofm5d99eLnhCEGRwwja2TSZ0rWiqWPfYRGFfsvNkLz4gKx5Ine07Tm
	 AwwNb6yYq2giYRThN5KYcvl79ci3KkttMk3RXzjO0v5SVPHscpO86pH+foAnUtThjezUW
	 vmtBAQgATHL5ZV9oaY6XlQiTiZX107NHo6NyqauA7I80fFPgMpqNXwYcFIv1pdj0V35ei
	 EDmooZL4tWD3lELibhxfMmNUXindPwdYPfp94K6ajDQG/HjN5pzUYAosQW64EpShmzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DUd4qy6D;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989B2606D812
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 03:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 989B2606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DUd4qy6D
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-353804b591eso6557161eec.0
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 19:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793676628; x=1794281428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HG7Is05GGnx6Xp1q3Juz1SqD92hs/Rh27uihZYQ1aPY=;
        b=DUd4qy6DZN+6NgN4TKPkfhh3T+8GtYq4L5nVU1Lk+2iIZojVWAmkwsr4ii177FedAX
         tjY3SSZAq3HzYrKPm7UXQ6Hj7M7I7xlKxowSi7QImGHI/KCnKj4nAWrAJMGQpPCtZeIl
         U37geBGl1ps8GSi/6rn6xeexWcBwo7RE0HGkoNuifppnd4o8Jmfc6m2k4gsJn7+Dj//N
         4joxmyqh5XdfaI7psody1Z0VukugXIp/B0IoTkXt9FSVfH40AyaYy4jRwazuwBiJK4Jw
         97PsmMr2rbMoTFhB4mV6u7xekj1FBKbL0v3ZQ1TcK+X3Q37EEnwwq4lgcBy5BUoAIB+1
         T1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793676628; x=1794281428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HG7Is05GGnx6Xp1q3Juz1SqD92hs/Rh27uihZYQ1aPY=;
        b=hIa//QalIcFC+/nLItH8CjYt7vgn/jePW1dNjAQVtV/0lqfzOuzEjo5MoRxmw0fWoi
         9bbwsIXaI7KU30HpySwZ3G9m9H91XC3QoZxXVLZaQrXe9fwHkAOtnnNkxihCfp5P02J/
         WrbMzpprUnnIOugkXknUlJoCk6DabX05z/g+sIS5mMl9NZXpFKd5LOq5m1h9SkZ+iWoU
         BkgkwAudjakTUhsmc6lHxzdhU9wx6u2Bt4cFXu6F67hgteCzTul4HUJvyQsRPNm4fDer
         H5agfG5BqMSJFUxNgfW++bXJuO0xvFD4w0xA+MZJkrjp4TZnC5CFhCbubEnJeOhTPTds
         IU2A==
X-Forwarded-Encrypted: i=1; AKwUvBzB5np7XwOSgE6wjq+XckhuWfD9kOm8u4xNU+dTm9hMfoaqu+Pbh3n5F/2ehLVwhQUgSO3eKHI58578@vger.kernel.org
X-Gm-Message-State: APuU4Z9oNfsO80a8BzuifCbcsW82tbCsEyjhvVqfYx+Wyodlymdkqq/+
	NKLvJvUHeyblDyweoyT22vxY3halAEkFcRxPQKXZqprDEb5vAlbgq0sppsGnsMIIUic=
X-Gm-Gg: AYBFou0dW7F5AHCGOe4SioQCFGmjb7ItuJWjTFTOLYLIIWp9zlG2BQFzJ0mor/EvmMs
	WDqhEwyLObIoawNUnVleT7YHD5P8hZPqQ7SrSJYGY2SBzS4a59WyxTa/S0Xl3h2HD15xShdXA4O
	cWS/i5dTJnOp9DgjbsGnpRx5TFNPBcxLU76Zm1cprHs4npfAODfJBzHjAZLsWilMoCp7P0bThuc
	kF4eiSU7PgwoxtU62beK2Y95j+G/8ndl+xY5EzbYfrTasvDIOPhmCYTJuV7FfvHo3E9QAHfIeZ0
	19KKFj00rBlC0Hpa75hRKXtvZCSAxJ0SaEGPfVouriNGblq/jbRjnl6o5uO01TUk6sO/ojR1R5s
	G/nYO8NDVA90+GmyVjan3y5V6rS+AUOLoPVDzkQhpxUeB+7iorvkgZ1gUhR5sOiVxJ8Z53SW0oE
	IjWZRNG0XCDVu8Yk9poYpY81WTKf3xDAx7lItPI+Tixq9yyEsYCo773PtCc6CobypV0uKVKoJaV
	/lLmAl6zZV8Z9khQgDgdTSRpRB14xFg8l1fFtZ++cRCg4TOxPO9FZNMS6KMd7Ea9FqSgDdavtUC
	mxzpR9o//FWeAKMZytExgQ/asIHStMIH2HINbSZAVrxuPOymbKvclzVISQH/loaCWRS12jEZZF7
	hoiQpDiy1t3OedIaqYWDW+ZrVTmcLh5+ih9/wrfE=
X-Received: by 2002:a05:7300:c00f:20b0:36a:4ea9:19ad with SMTP id 5a478bee46e88-36a4ea91fd1mr15426433eec.9.1793676627433;
        Mon, 02 Nov 2026 19:30:27 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm41498577eec.8.2026.11.02.19.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:30:26 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/3] IB/isert: drain the QP without holding isert_conn->mutex
Date: Tue,  3 Nov 2026 12:29:23 +0900
Message-ID: <20261103032924.1073138-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
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

isert_disconnected_handler() drains the QP with isert_conn->mutex held.
The drain waits for the flush completions of the send and receive
queues, and those are reaped by ib_cq_poll_work() on ib-comp-wq, where
isert_login_recv_done() takes isert_conn->mutex before it looks at the
connection state.  If a login receive completes while the handler holds
the mutex, the completion handler blocks on the mutex and the drain
blocks on the completion that handler would have reaped.

Return from isert_conn_terminate() whether this caller moved the
connection to ISER_CONN_TERMINATING, and do the drain and the unbound
connection release after dropping isert_conn->mutex.  Only one caller
sees true for a given connection, so the drain still runs once.

Two test-only delay knobs open the window, one in
isert_login_recv_done() and one before the drain; it does not open on
its own in this setup.  With them, three runs of 7.4-rc1 plus patch 1 of
this series produced ten hung task warnings each, six, six and seven of
them waiting in ib_drain_qp() and four, four and three in
isert_login_recv_done().  Three runs with this patch produced none.

  INFO: task kworker/0:1:10 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-B13-00002-g093ce9c311ad #47
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/0:1     state:D stack:27392 pid:10    tgid:10    ppid:2      task_flags:0x4208060 flags:0x00080000
  Workqueue: ib_cm cm_work_handler
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? _raw_spin_lock_irq+0x1/0xe0
   ? __pfx___schedule+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   schedule+0x70/0x1f0
   schedule_timeout+0x1cd/0x200
   ? __pfx_schedule_timeout+0x10/0x10
   ? rxe_qp_from_attr+0x1497/0x18c0
   ? __pfx__raw_spin_lock_irq+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? _raw_spin_lock_irqsave+0x86/0xe0
   __wait_for_common+0x29e/0x420
   ? __pfx_schedule_timeout+0x10/0x10
   ? __pfx___wait_for_common+0x10/0x10
   __ib_drain_sq+0x251/0x340
   ? __pfx___ib_drain_sq+0x10/0x10
   ? __pfx_ib_drain_qp_done+0x10/0x10
   ? irq_work_queue+0x1c/0xb0
   ? __pfx__printk+0x10/0x10
   ? __pfx_process_timeout+0x10/0x10
   ib_drain_sq+0x146/0x1a0
   ib_drain_qp+0xd/0x50
   isert_disconnected_handler.isra.0+0xc4/0x3f0
   isert_cma_handler+0xd74/0x27f0
   ? ip6_finish_output2+0xc09/0x1bd0
   ? __pfx_isert_cma_handler+0x10/0x10
   ? __pfx_ip6_finish_output2+0x10/0x10
   ? _raw_spin_lock_irqsave+0x86/0xe0
   cma_cm_event_handler+0x3e/0x240
   cma_ib_handler+0x190/0x750
   ? __pfx_cma_ib_handler+0x10/0x10
   cm_process_work+0x41/0x330
   cm_work_handler+0x582b/0xc160
   ? _raw_spin_lock_irqsave+0x86/0xe0
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? hrtimer_start_range_ns+0xa6/0x2c0
   ? __pfx_cm_work_handler+0x10/0x10
   ? finish_task_switch.isra.0+0x1d9/0xa70
   process_one_work+0x697/0x1060
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_cm_work_handler+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  INFO: task kworker/0:0H:11 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-B13-00002-g093ce9c311ad #47
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/0:0H    state:D stack:29592 pid:11    tgid:11    ppid:2      task_flags:0x4208060 flags:0x00080000
  Workqueue: ib-comp-wq ib_cq_poll_work
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? _raw_spin_lock_irq+0x1/0xe0
   ? __pfx___schedule+0x10/0x10
   ? _raw_spin_lock+0x80/0xe0
   schedule+0x70/0x1f0
   schedule_preempt_disabled+0x11/0x20
   __mutex_lock.constprop.0+0xc2f/0x1910
   ? __pfx___mutex_lock.constprop.0+0x10/0x10
   ? _printk+0xba/0xf0
   mutex_lock+0xc2/0xd0
   ? __pfx_mutex_lock+0x10/0x10
   ? _raw_spin_lock_irqsave+0x86/0xe0
   isert_login_recv_done+0x2b9/0x590
   __ib_process_cq+0xe1/0x390
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ib_cq_poll_work+0x46/0x150
   process_one_work+0x697/0x1060
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_ib_cq_poll_work+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  INFO: task kworker/0:0H:11 is blocked on a mutex likely owned by task kworker/3:0:34.

Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 26 +++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8255208e30c7d6..c6f417bb206901 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -578,21 +578,17 @@ isert_handle_unbound_conn(struct isert_conn *isert_conn)
  * isert_conn_terminate() - Initiate connection termination
  * @isert_conn: isert connection struct
  *
- * Notes:
- * In case the connection state is BOUND, move state
- * to TEMINATING and start teardown sequence (rdma_disconnect).
- * In case the connection state is UP, complete flush as well.
- *
- * This routine must be called with mutex held. Thus it is
- * safe to call multiple times.
+ * Returns true if this caller moved the connection to ISER_CONN_TERMINATING.
  */
-static void
+static bool
 isert_conn_terminate(struct isert_conn *isert_conn)
 {
 	int err;
 
+	lockdep_assert_held(&isert_conn->mutex);
+
 	if (isert_conn->state >= ISER_CONN_TERMINATING)
-		return;
+		return false;
 
 	isert_info("Terminating conn %p state %d\n",
 		   isert_conn, isert_conn->state);
@@ -601,6 +597,8 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 	if (err)
 		isert_warn("Failed rdma_disconnect isert_conn %p\n",
 			   isert_conn);
+
+	return true;
 }
 
 static int
@@ -635,15 +633,14 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 			   enum rdma_cm_event_type event)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
+	bool terminated = false;
 
 	mutex_lock(&isert_conn->mutex);
 	switch (isert_conn->state) {
 	case ISER_CONN_TERMINATING:
 		break;
 	case ISER_CONN_UP:
-		isert_conn_terminate(isert_conn);
-		ib_drain_qp(isert_conn->qp);
-		isert_handle_unbound_conn(isert_conn);
+		terminated = isert_conn_terminate(isert_conn);
 		break;
 	case ISER_CONN_BOUND:
 	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
@@ -655,6 +652,11 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 	}
 	mutex_unlock(&isert_conn->mutex);
 
+	if (terminated) {
+		ib_drain_qp(isert_conn->qp);
+		isert_handle_unbound_conn(isert_conn);
+	}
+
 	return 0;
 }
 
-- 
2.43.0

