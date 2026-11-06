Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970318;
	b=4MSUD1m5slH1GIqEp2ODDtXvT4VDlh/Da1Wq3dkVBFbHMpg/pqc3IJIq2N7fs5dHqIQh
	 XuxmZCIhK9rVaA8+DHqAeSLXsP0mq2AWBIlTmEwtAeFoNLYRpKe8vcpIL0lMdNfG1unv4
	 AuJPWgUekPKhscnSEzqfZfstSbF02Sn+n3teNwH8ObR2m0LqOT/ziLYH0suSz/V2d1NxE
	 USPm1H/Mq26bku854oP/QTAdChw8esbQ/ICEaMAFAi3j5VZVmbymNSTZf1mbmesKhqmf5
	 gwwlhxc9TXfrezbygahgMXynnsm8cNfDn0y3U7HK+TL/YlhlYDz7f73AeOD/SOEd/dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970318;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=mdWy63HVxevzGMLKZ8tBQchM30UjwDbF53J87FGXTN0=;
	b=wItArU2jiRZ+oF5UDSMapBhLiX36XkdDwU2LCvwzYE3noqpVU78zchax+64W2TpMUG/J
	 fghwW8i6Em4TcU4XO0/PD9bvwao02ah09YYlhkh7+3eZrzV9VOT/rZ0+uqPrHKOfZAawG
	 66ZKiN6cXzZH+gEPmH5iAmg2yKOQCeQ9ifAghqG1H/+O8e3KmSVeGqWBcwjTOXqqr9MwT
	 wwyHio7E7OxRA8Zkv/qwsZfSgzfeuQqiPnrfKOfyBDC/cz40JiE4T1EnNdx0AZlKbOnm/
	 vrOm9QpYK1inSG+exU1Au9yXobOD5Si7I4KQYqElecEWvIe+6JIpan+rku4LBq6tGLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=d2IDJpr+;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571D606A326;
	Fri,  6 Nov 2026 13:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6571D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=d2IDJpr+
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6Ai8Vc2143118;
	Fri, 6 Nov 2026 13:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=mdWy63HVxevzGMLKZ8tBQchM30UjwDbF53J87FGXT
	N0=; b=d2IDJpr+Csem1SDUWU85bG7E23R8jhxcLPyP/7oeDWChqPJu4Adxs6F9Q
	RiDGmr84nPMyN4CTarUxG9UeAfGXZz7b5dCIDdwXzX6+kaMaZAL3Q6NI839VtWZa
	x81BNZbWWyPy0yTOaEnAca/YhYwH24SaE+oHaqcEQk1RDU80Z76pkVEZu6XWamaN
	z6uOTSGs2sIdhvAneEWW7vy9Yed9rgP/TiK+QbH3QNgvtkjjrCfBd7oSpULg7NYM
	5CY222ByMcF8NTAH7w71kQI6XOGr3KlVaa/NbmekF3eguzWqsgzjrLl6tXlYwdxv
	/5exIfEwESuSaXC23LIZcHnn7D6zA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hs3r9499p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 13:05:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6AZ1Tm3302174;
	Fri, 6 Nov 2026 13:05:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hrdd7thps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 13:05:04 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A6D50B626739116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Nov 2026 13:05:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DDDD2004E;
	Fri,  6 Nov 2026 13:05:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEE432004D;
	Fri,  6 Nov 2026 13:04:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  6 Nov 2026 13:04:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id B21C8161112; Fri, 06 Nov 2026 14:04:59 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v2] net/smc: fix link group ownership in handshake abort
Date: Fri,  6 Nov 2026 14:04:57 +0100
Message-ID: <20261106130457.1092203-1-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=O86sLx9W c=1 sm=1 tr=0 ts=6aedd082 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=15R1dr1XGQ76E5QmZTkA:9
X-Proofpoint-ORIG-GUID: WeWCDyLygjKVolwd6oLCebpu_lBhAeBm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1MCBTYWx0ZWRfX54v99sdY+lmg
 ryk/q1sNnPQprcUmLgy/EZYjN0BLfEg8i1YoJZ6H4UQNST1Mz7pc1VnwcO0ehEuPGOjKXtRHEbg
 7nux+EnTcF24KYxYX8uqkmN5cB08oakH1ULvvNXr7nUod2WXxQJ4LgEncFdYPZDzHTEufTCEKno
 SzqGpXv2jFEE4KPomscPP+uyZvlUpnCZljsEnFURFzUVFs/ebE5Cj4eFW2Fn4VfOFcuigxq1BtF
 I6TT85IWjwW6iW+CclnXt9uhwbPj9KE3uBglzVK0C8lBusNTNgJuPhyKxB0Qr7uWvl5wh8AUsQN
 esG0LOR0HNATw0EmgP7/GDTwxFgXy/o1JQOk+t0KLLY1hBhRvxpoazpDX3BAeE5RN9iU/JDWg9F
 wwW6SvwTxML4hTNxgx1tENYmEwwzCYa3JQH2UpTljS2kpP1p3dub0U8S3wV6eRBAdlhPcdtDFqN
 /W2U48etxzxJCQcvYxQ==
X-Proofpoint-GUID: QFZbrTiPXSqqwvgFMOxGQs_FhvcUeXSY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1MCBTYWx0ZWRfX5/yZdztYRwnN
 +Uq1z8uEphWRWcXi1pjsVIVWnHkGaERET8w+zZysYYr5ETsbSxrBL/uqyASxMcGsBqlrHHFSYRb
 +hw5mQei8X962MxwvIfQp/jT81aTyPI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_03,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060050

An aborted first-contact handshake can hang the handshake worker on the
socket lock it already holds, reset the clcsock of a socket that has
fallen back to TCP, or corrupt the alert-node lookup when the handshake
retries with the same connection.

The abort leaves a connection registered in a link group that another
context has already unlinked for termination: smc_conn_free() skips the
unregister when lgr->list is empty, so the alert token and alert node
stay in lgr->conns_all. If the handshake retries another device or SMC
version, smc_conn_create() creates a second link group and
smc_lgr_register_conn() inserts the same alert node into it: the token
loop is skipped, rb_link_node() links a node that is still in the old
tree into the new one, and a second sock_hold() is taken where only one
sock_put() will follow. The old group's terminator then keeps returning
that node from rb_first() and can kill a connection that now belongs to
the new group.

smc_lgr_cleanup_early() also starts a second termination of the link
group that is already being terminated, which takes lock_sock() on the
socket the handshake worker holds; if the termination work wins the race
instead, it later kills the freed connection and aborts the clcsock of a
socket that has fallen back to TCP. Making the unregister unconditional
also lets smc_conn_free() reach the delayed free work on a claimed link
group, where the lockless freeing check can arm it after the owner has
cancelled it.

Always unregister the connection, claim a link group for termination
once under lgr_lock, keep the link group alive across the abort, and arm
the delayed free work only under the same lock and cancel it
synchronously before the teardown. Drop an already freed connection in
smc_conn_kill() without running the connection and socket teardown.

Fixes: 2a0674fffb6b ("net/smc: improve abnormal termination of link group=
s")
Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early=
()")
Cc: stable@vger.kernel.org
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c   | 11 ++++----
 net/smc/smc_core.c | 78 +++++++++++++++++++++++++++++++++++++++---------=
------
 net/smc/smc_core.h |  6 ++---
 3 files changed, 65 insertions(+), 30 deletions(-)

Changelog:
v2:
- Always unregister the connection in smc_conn_free(), so a handshake
  that retries another device or SMC version cannot leave a stale alert
  node in a link group it is leaving.
- Claim link group termination once, under lgr_lock, in a helper shared
  by smc_lgr_cleanup_early() and smc_lgr_terminate_sched(); testing
  list_empty() alone missed a link group another context had already
  unlinked.
- Hold a link group reference across smc_conn_free() and
  smc_lgr_cleanup_early().
- Arm the delayed free work under lgr_lock, cancel it synchronously
  before the teardown, and skip a connection that was re-registered in
  another link group.
- Do not share one storage unit between sync_err, terminating and
  freeing.

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d10244af5bd2..db93cbeee9c8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1013,14 +1013,15 @@ static void smc_conn_abort(struct smc_sock *smc, =
int local_first)
 {
 	struct smc_connection *conn =3D &smc->conn;
 	struct smc_link_group *lgr =3D conn->lgr;
-	bool lgr_valid =3D false;
-
-	if (smc_conn_lgr_valid(conn))
-		lgr_valid =3D true;
+	bool lgr_valid =3D local_first && smc_conn_lgr_valid(conn);

+	if (lgr_valid)
+		smc_lgr_hold(lgr);	/* lgr_put below */
 	smc_conn_free(conn);
-	if (local_first && lgr_valid)
+	if (lgr_valid) {
 		smc_lgr_cleanup_early(lgr);
+		smc_lgr_put(lgr);
+	}
 }

 /* check if there is a rdma device available for this connection. */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6021322253e9..d546108d177d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -80,16 +80,21 @@ static void smc_ibdev_cnt_dec(struct smc_link *lnk)

 static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
 {
+	spinlock_t *lgr_lock;
+
 	/* client link group creation always follows the server link group
 	 * creation. For client use a somewhat higher removal delay time,
 	 * otherwise there is a risk of out-of-sync link groups.
 	 */
+	smc_lgr_list_head(lgr, &lgr_lock);
+	spin_lock_bh(lgr_lock);
 	if (!lgr->freeing) {
 		mod_delayed_work(system_percpu_wq, &lgr->free_work,
 				 (!lgr->is_smcd && lgr->role =3D=3D SMC_CLNT) ?
 						SMC_LGR_FREE_DELAY_CLNT :
 						SMC_LGR_FREE_DELAY_SERV);
 	}
+	spin_unlock_bh(lgr_lock);
 }

 /* Register connection's alert token in our lookup structure.
@@ -679,19 +684,34 @@ int smcd_nl_get_lgr(struct sk_buff *skb, struct net=
link_callback *cb)
 	return skb->len;
 }

-void smc_lgr_cleanup_early(struct smc_link_group *lgr)
+/* Claim a link group for termination. Only one context can succeed: the
+ * lgr is removed from its list and marked freeing under lgr_lock.
+ * Returns false if @lgr is NULL or another context owns it.
+ */
+static bool smc_lgr_claim(struct smc_link_group *lgr)
 {
 	spinlock_t *lgr_lock;

 	if (!lgr)
-		return;
-
+		return false;
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
+	if (lgr->freeing || lgr->terminating || list_empty(&lgr->list)) {
+		spin_unlock_bh(lgr_lock);
+		return false;
+	}
 	/* do not use this link group for new connections */
-	if (!list_empty(&lgr->list))
-		list_del_init(&lgr->list);
+	list_del_init(&lgr->list);
+	lgr->freeing =3D 1;
 	spin_unlock_bh(lgr_lock);
+	return true;
+}
+
+/* The caller must keep @lgr alive for the duration of the call. */
+void smc_lgr_cleanup_early(struct smc_link_group *lgr)
+{
+	if (!smc_lgr_claim(lgr))
+		return;	/* another context owns the termination */
 	__smc_lgr_terminate(lgr, true);
 }

@@ -1281,10 +1301,12 @@ void smc_conn_free(struct smc_connection *conn)
 		if (current_work() !=3D &conn->abort_work)
 			cancel_work_sync(&conn->abort_work);
 	}
-	if (!list_empty(&lgr->list)) {
+	/* The handshake can retry another device or SMC version with this
+	 * connection, so it must never stay registered in an lgr it left.
+	 */
+	if (!list_empty(&lgr->list))
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
-		smc_lgr_unregister_conn(conn);
-	}
+	smc_lgr_unregister_conn(conn);

 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
@@ -1519,6 +1541,15 @@ static void smc_conn_kill(struct smc_connection *c=
onn, bool soft)
 {
 	struct smc_sock *smc =3D container_of(conn, struct smc_sock, conn);

+	if (conn->freed) {
+		/* The connection was already freed, e.g. by a close or
+		 * a handshake that fell back to TCP. Do not abort a socket
+		 * that is no longer part of this link group.
+		 */
+		smc_lgr_unregister_conn(conn);
+		return;
+	}
+
 	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort =3D 1;
 	else
@@ -1564,12 +1595,20 @@ static void __smc_lgr_terminate(struct smc_link_g=
roup *lgr, bool soft)
 	struct smc_connection *conn;
 	struct smc_sock *smc;
 	struct rb_node *node;
+	spinlock_t *lgr_lock;

-	if (lgr->terminating)
+	smc_lgr_list_head(lgr, &lgr_lock);
+	spin_lock_bh(lgr_lock);
+	if (lgr->terminating) {
+		spin_unlock_bh(lgr_lock);
 		return;	/* lgr already terminating */
-	/* cancel free_work sync, will terminate when lgr->freeing is set */
-	cancel_delayed_work(&lgr->free_work);
+	}
 	lgr->terminating =3D 1;
+	spin_unlock_bh(lgr_lock);
+	/* The lgr is claimed, so no new free_work can be armed; wait for
+	 * one that is already queued or running.
+	 */
+	cancel_delayed_work_sync(&lgr->free_work);

 	/* kill remaining link group connections */
 	read_lock_bh(&lgr->conns_lock);
@@ -1580,7 +1619,11 @@ static void __smc_lgr_terminate(struct smc_link_gr=
oup *lgr, bool soft)
 		sock_hold(&smc->sk); /* sock_put below */
 		read_unlock_bh(&lgr->conns_lock);
 		lock_sock(&smc->sk);
-		smc_conn_kill(conn, soft);
+		/* The connection may have been re-registered in another
+		 * link group by a retried handshake in the meantime.
+		 */
+		if (conn->lgr =3D=3D lgr)
+			smc_conn_kill(conn, soft);
 		release_sock(&smc->sk);
 		sock_put(&smc->sk); /* sock_hold above */
 		read_lock_bh(&lgr->conns_lock);
@@ -1594,17 +1637,8 @@ static void __smc_lgr_terminate(struct smc_link_gr=
oup *lgr, bool soft)
 /* unlink link group and schedule termination */
 void smc_lgr_terminate_sched(struct smc_link_group *lgr)
 {
-	spinlock_t *lgr_lock;
-
-	smc_lgr_list_head(lgr, &lgr_lock);
-	spin_lock_bh(lgr_lock);
-	if (list_empty(&lgr->list) || lgr->terminating || lgr->freeing) {
-		spin_unlock_bh(lgr_lock);
+	if (!smc_lgr_claim(lgr))
 		return;	/* lgr already terminating */
-	}
-	list_del_init(&lgr->list);
-	lgr->freeing =3D 1;
-	spin_unlock_bh(lgr_lock);
 	schedule_work(&lgr->terminate_work);
 }

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 5c18f08a4c8a..bff4c9e17792 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -301,9 +301,9 @@ struct smc_link_group {
 	struct delayed_work	free_work;	/* delayed freeing of an lgr */
 	struct work_struct	terminate_work;	/* abnormal lgr termination */
 	struct workqueue_struct	*tx_wq;		/* wq for conn. tx workers */
-	u8			sync_err : 1;	/* lgr no longer fits to peer */
-	u8			terminating : 1;/* lgr is terminating */
-	u8			freeing : 1;	/* lgr is being freed */
+	u8			sync_err;	/* lgr no longer fits to peer */
+	u8			terminating;	/* lgr is terminating */
+	u8			freeing;	/* lgr is being freed */

 	refcount_t		refcnt;		/* lgr reference count */
 	bool			is_smcd;	/* SMC-R or SMC-D */
