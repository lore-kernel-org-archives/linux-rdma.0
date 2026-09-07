Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EA9492502;
	Mon,  7 Sep 2026 11:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781658; cv=none; b=SU+Jdpfe512VhdkmOA9TzntBOk/3oyCfJHqTNZgO1+GtNHU4Nr16F4ts3cL15K6IeOsUe02x7vW0/ERWWoRfRGBq+KFUn+Yk7Xce+kD+/oFFpYtkh0t8NvdaN3lKvw7ctXFChk6Wq/BtOAkjKh/i9ndhN0qW+k6Je4GEItlsGMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781658; c=relaxed/simple;
	bh=KPDuoA73XA6jW4RcIkGUVjTWwHMf7F6ebsi3aHMFaJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kQVAdajFTGPF2JAlpPA8Y7j3Spm7hUrANay2BYeV6wHrpZwgFG4GdLjFpUQgYCM3qCTdRzrIfIdoe5I22LaKASfAS2z4lhK63IEn+mE5genqcSzpOSurQBKvcu4ysWHCLjtTCYQG1UB4O4TgT+xI6KpEUNVz3p8XH8eAL44iJ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R2LVovtW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R2LVovtW"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687B1c4B627793;
	Mon, 7 Sep 2026 11:47:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Ojd4mWe432CCLUzS2OJnJCk9pMWrdwRtWpi4qvVDX
	Ws=; b=R2LVovtWcch48CiO4uj6vX9M+p9DuJC4Dve2f2t2BqucZmCjCX8RftUaJ
	1U2roCpopxiL6vjF7nIwm6/c4wqwBvr/3xR6tMzlQoOkp36Av+D+jbRdkuSLcpZb
	UU7HAwIFWz3Yvh3OdNH2ye4kSOKohzMDkC2nXqs2iwSvuDOWHmmQ07WhPf4mFeDz
	yVPXPM+hxxss5aWQkvpp6mfSMvs3Sev6/TsyMhLGR/cPovfn6ghW59rPZVrgQSex
	PHBpn37gra9HMCpCivIkkquj2Ib3h1U55c2L8ckDHojNknoZ8mLBgDZ5Ll81v+Ob
	jjneIsmJCMUZJN8luZaNK0Tvi1shQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrgat0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 11:47:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 687BfGEW026152;
	Mon, 7 Sep 2026 11:47:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gh03y5g0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 11:47:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 687BlMuW45154724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 11:47:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 893492004B;
	Mon,  7 Sep 2026 11:47:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 495C720043;
	Mon,  7 Sep 2026 11:47:22 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 11:47:22 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        horms@kernel.org, pasic@linux.ibm.com, hidayath@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net v2] net/smc: fix abort_work termination in smc_conn_free()
Date: Mon,  7 Sep 2026 13:47:21 +0200
Message-ID: <20260907114721.1303498-1-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6a9ea450 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=LEs0kG9u15w8AA0dF9YA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDEyNyBTYWx0ZWRfX9hqrfDfSJLkY
 5kQU7tTve/75V+hZ61zplWTPOhOLilVCCGJXVwOQHqpW5dI5nOSRppZYdJNZSGQy3HUu43Zy57K
 C7c0CB0D03/PszJeg8pQ++3/6lsKH+0=
X-Proofpoint-ORIG-GUID: U0pTEOVWAxM1Ng3SWnmIO0fSjzncArPg
X-Proofpoint-GUID: 0hl-og_vWirgBy20Ctas52uRFi9R6Y2E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDEyNyBTYWx0ZWRfXxbmgBiZUaCDM
 3RyjQVj/hAVJsnsRrHepGIcoWIzucBSSxnon1RLLjocvTTHr6TqRHKnxrHx0yEnSaaKm3PbBMSt
 a99/P2ELtdhyFtCAX2ypXvVHObaK6dCYoPXQJyXJgSowCMsDqColb7CAYYAyd7cGqNZ52uiku3d
 vMXFLmowo+Nbd76mL6WOLUUdhsHQLwcfSHbOGy7p9I8MS7unCPNJ99NirD4eE/A3gui2Ob4IMbD
 uMqPGNNpsiFNVH3ASZtxS3iQDVWWJ0IAF0i4HU3znGUEycW3VT5FxWzdkMBiIHMZkLYe55OvmGp
 gIs2uIy4HrsL7Ih5C5+0w/eQKiRQ2EoAzsEmePiKv9BiUblADGshPbrFdgdsdqycMBzbZSUqTm0
 Rmu4KEzCDX8XLij3fqAk0T8uDV+hh9ATNJwKFVGA38hmw3OMPeh2Y0urQuqjBqSF/na/qoHZ5TX
 INaCcYMmvEG0LKIrcOQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070127

smc_conn_free() disposes of a pending conn->abort_work, but it gets three
things wrong:

1. Deadlock: smc_conn_free() runs with the socket lock held and calls
   cancel_work_sync(), while smc_conn_abort_work() takes the same lock.
   If the work has already started on another CPU and is waiting for that
   lock, the cancel waits for the work and the work waits for the caller.
   The current_work() test only stops the work from cancelling itself,
   not when the two run on different CPUs.

2. Reference leak: Schedulers of abort_work take a socket reference, and
   smc_conn_abort_work() drops it when it runs. If cancel_work_sync()
   removes a pending work item before it runs, that reference is never
   returned and the socket is never freed.

Both are fixed the way smc_close_cancel_work() handles close_work: drop
the socket lock around the cancel, and release the reference when the
cancel reports that it removed a pending item.

3. Late-queued work race: smc_cdc_rx_handler() finds the connection and
   drops lgr->conns_lock before smc_cdc_msg_validate() decides to queue:

     CPU0 (smc_conn_free)              CPU1 (smc_cdc_rx_handler)
                                       conn = smc_lgr_find_conn()
                                       sock_hold()
                                       read_unlock_bh(&lgr->conns_lock)
     cancel_work_sync()                  /* nothing queued yet */
     smc_buf_unuse()
                                       smc_cdc_msg_validate()
                                         queue_work(&conn->abort_work)

   cancel_work_sync() only guarantees that the work is not pending or
   running when it returns; a racing enqueue lands after that. The work
   then calls smc_conn_kill() on a connection whose buffers have already
   been returned.

Nothing smc_conn_free() does can prevent that enqueue, because the
receiver already holds the connection pointer. Make the late work
harmless instead: smc_conn_free() sets conn->freed with the socket lock
held before it releases anything, and smc_conn_abort_work() takes the same
lock. Check conn->freed inside smc_conn_abort_work() to skip
smc_conn_kill() if teardown has started. The work still drops its socket
reference.

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
v2:
- Extended the fix to cover the deadlock and racing enqueue issues flagged
  during v1 review.
- Moved the cancel into a helper smc_conn_cancel_abort_work() that drops
  the socket lock around cancel_work_sync().
- Added a check for conn->freed under lock_sock in smc_conn_abort_work() to
  safely handle late-queued work items without fragile reordering.
- Updated patch subject to reflect the broader termination fix.
  Link: https://lore.kernel.org/netdev/20260806081549.595001-1-hidayath@linux.ibm.com/

 net/smc/smc_core.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 04aedd957543..9a109eae73b9 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1251,6 +1251,25 @@ static void smc_buf_unuse(struct smc_connection *conn,
 	}
 }
 
+/* Cancel a pending abort work item.  smc_conn_abort_work() takes the socket
+ * lock, so the lock has to be dropped here.  Otherwise cancel_work_sync()
+ * waits for a worker that is itself blocked on the caller.  This is the idiom
+ * smc_close_cancel_work() already uses for close_work.
+ */
+static void smc_conn_cancel_abort_work(struct smc_connection *conn)
+{
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
+	struct sock *sk = &smc->sk;
+
+	if (current_work() == &conn->abort_work)
+		return;
+
+	release_sock(sk);
+	if (cancel_work_sync(&conn->abort_work))
+		sock_put(sk); /* sock_hold done by schedulers of abort_work */
+	lock_sock(sk);
+}
+
 /* remove a finished connection from its link group */
 void smc_conn_free(struct smc_connection *conn)
 {
@@ -1276,8 +1295,7 @@ void smc_conn_free(struct smc_connection *conn)
 			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
-		if (current_work() != &conn->abort_work)
-			cancel_work_sync(&conn->abort_work);
+		smc_conn_cancel_abort_work(conn);
 	}
 	if (!list_empty(&lgr->list)) {
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
@@ -1750,7 +1768,12 @@ static void smc_conn_abort_work(struct work_struct *work)
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
 	lock_sock(&smc->sk);
-	smc_conn_kill(conn, true);
+	/* smc_conn_free() sets freed with this lock held and before it
+	 * releases anything, so a work item queued after the cancel has
+	 * nothing left to do.
+	 */
+	if (!conn->freed)
+		smc_conn_kill(conn, true);
 	release_sock(&smc->sk);
 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
 }

base-commit: e9abfc6803fcd57ecca1a647638df773b6429eb9
-- 
2.52.0

