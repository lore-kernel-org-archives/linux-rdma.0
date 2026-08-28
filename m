Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE3C3DB30F;
	Fri, 28 Aug 2026 06:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900108; cv=none; b=X1qrVqsuE74Kp5zcxIXUSfoQrehrMtoXfCQyy/+2YWV4YH4dhG7nR///wiNcl1uOWqG8DClbDe4czQ8uxH9b1Oz5eX+K9zSQTZiv8TDlVqzFAlg9DejGVrGJSRc9jdpDywQLNkdwshmfqGfudIwEeGdyTNq/N30ZlGlsnwfHoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900108; c=relaxed/simple;
	bh=cC7h6wr/eCcP0EmRwesos0MkIz4XrIEXx1mKkoqAnAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8y15ralynR1SseAiovTVmy1EHpz9ZNy3u/xZJUZW8B37LnGMx2bZCXv6VhPPafvHdhkqLQrZoeER0YGaNuBGLdFoBbOy8iXxaSLflicACLA11zebXm8GAiUkgJ7vUk+y+721dKzyvCeOx8r3pGSdn2FeEws04vridVDHq2qt+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GiE+q8ZX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GiE+q8ZX"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S6Vqqd082098;
	Fri, 28 Aug 2026 06:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vOGrakQG5SbYfeVM5
	NaRpvrfuxVPLXA5dQmfe82s5Zo=; b=GiE+q8ZX5Qqlk0KNZNVZ5LnC1lLuklCoA
	7p9LUCV5XPuFCrsq9atUNOIYNBgfM2tVZkQLiPSBlrLBr4750jAY60LEc4eTKloG
	ES/QTDAEkY/SfbvVi16QXLyOl9EXBGayolmyYzqpDMulBJCGSANr2joT33l+ThJB
	qqcBBXS/Dv+pMhla2S+C/jgpAOKazUimD7K3YBwjiXvtMMQ2XQe4djTVVYkguW5m
	4b8pTnLAp+FwUuWbGdNtrHmwShwLbQUQ2fnxaHpgY8qZeeb6RTwVKz5vgdqK/OLW
	gPg3G4asMW/NpEnTRaxHdOlOQvKgShDagrpr9P/mRxFc0ToZPVNzA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g726f2dy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:54:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67S6fIQ5017458;
	Fri, 28 Aug 2026 06:54:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7pfwmv82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:54:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67S6ssEu7864600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 06:54:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 356FF2004B;
	Fri, 28 Aug 2026 06:54:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2FA220049;
	Fri, 28 Aug 2026 06:54:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 28 Aug 2026 06:54:53 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id DD81E16161F; Fri, 28 Aug 2026 08:54:53 +0200 (CEST)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net v2 1/2] net/smc: add connection lifetime infrastructure for diag
Date: Fri, 28 Aug 2026 08:54:38 +0200
Message-ID: <20260828065439.3582783-2-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=TfimcxQh c=1 sm=1 tr=0 ts=6a9130c3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=yHNEK8bLSx12OPEUpuQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA1NCBTYWx0ZWRfX6Zd9PVXUkNO+
 NrEvuXjk4WgGUGb7sBGVZQtw2JZXOFDSnLJ8V27t8lOELFY1s2hUfWPpp4zyoCobfOEU74o37O+
 jbtEj+j5muMntC1MNbXaNurAKScFHjU=
X-Proofpoint-GUID: S9-33a1AvkjlnNkEeS4X8Wg1LuYZfVSQ
X-Proofpoint-ORIG-GUID: FSfxqo--LIclnhHUkAHI0IS4VVUe34wd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA1NCBTYWx0ZWRfX5JeKlm8Ktsls
 MYcxz2VSb46NJyqujiAtyE7su157Cd/AtE5THpdNg0FCi9/0m06nfQgamSNFj1+gMEfY/Mqp/ex
 /MEnS+1WUaSEig3wfty05Fe/BfQvFYgbtgog8tqCX9AlvoUty4tg3eIaWCtyMY8qDslCPeg6zLW
 s4ALTjNQYk/U85g5wArLMIRD1oUUFAg3m/AsQZNbfdkqFfM0lQ7MJrmfCg+kVUuaOYDjJE8Fe3B
 tN088PkTL4Oki5oUI2Tekvb5ivYsTNwxLt3MZeRr+5jG4lh8SvowLNgBwSKFoQyzmEVoP4GfHv2
 iRh8iKw0tSBh2R+Ln2wdS4z7trBr/QdM7y38MkDRuP1Zdb3m59ztCH0oNYI3SxXqKPjXcBgXbMe
 Q7GTs/GvY3g1zEnK/M3ibfGFFU9LwRZURyAF3zmMap2clhJL0+dK3nHfgLbKbqnuTt34OHhvgFk
 SzNveCfx7+yVh+ogrng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280054

Add the basic lifetime synchronization needed by the diag dump path.  Int=
roduce
a per-connection lock that serializes connection-owned conn->lgr/conn->ln=
k
updates against readers and use the new lock in the switch/free handoff p=
aths.

In smc_conn_free(), NULL out conn->lgr and conn->lnk under lgr_lnk_lock b=
efore
releasing the borrowed references. This closes the window where a concurr=
ent
diag reader could observe a non-NULL conn->lgr that points at already-fre=
ed
memory.

A non-NULL conn->lgr seen under lgr_lnk_lock guarantees the connection-ow=
ned lgr
reference is still held and the object is alive; conn->lnk is likewise va=
lid
when non-NULL under the lock. The follow-on diag fix relies on this invar=
iant to
safely read lgr and link fields without borrowing an extra reference.

Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c   |  1 +
 net/smc/smc.h      |  1 +
 net/smc/smc_core.c | 10 +++++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..8eece96a9edf 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -408,6 +408,7 @@ void smc_sk_init(struct net *net, struct sock *sk, in=
t protocol)
 	sock_lock_init_class_and_name(sk, "slock-AF_SMC", &smc_slock_key,
 				      "sk_lock-AF_SMC", &smc_key);
 	spin_lock_init(&smc->accept_q_lock);
+	spin_lock_init(&smc->conn.lgr_lnk_lock);
 	spin_lock_init(&smc->conn.send_lock);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 52145df83f6e..d5fb5d92809b 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -232,6 +232,7 @@ struct smc_connection {
 	atomic_t		sndbuf_space;	/* remaining space in sndbuf */
 	u16			tx_cdc_seq;	/* sequence # for CDC send */
 	u16			tx_cdc_seq_fin;	/* sequence # - tx completed */
+	spinlock_t		lgr_lnk_lock;	/* protect conn owned lgr/lnk refs */
 	spinlock_t		send_lock;	/* protect wr_sends */
 	atomic_t		cdc_pend_tx_wr; /* number of pending tx CDC wqe
 						 * - inc when post wqe,
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 181647982490..cc69b86b2ee5 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1083,6 +1083,7 @@ static int smc_switch_cursor(struct smc_sock *smc, =
struct smc_cdc_tx_pend *pend,
 void smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk)
 {
+	spin_lock_bh(&conn->lgr_lnk_lock);
 	atomic_dec(&conn->lnk->conn_cnt);
 	/* link_hold in smc_conn_create() */
 	smcr_link_put(conn->lnk);
@@ -1090,6 +1091,7 @@ void smc_switch_link_and_count(struct smc_connectio=
n *conn,
 	atomic_inc(&conn->lnk->conn_cnt);
 	/* link_put in smc_conn_free() */
 	smcr_link_hold(conn->lnk);
+	spin_unlock_bh(&conn->lgr_lnk_lock);
 }

 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
@@ -1255,6 +1257,7 @@ static void smc_buf_unuse(struct smc_connection *co=
nn,
 void smc_conn_free(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr =3D conn->lgr;
+	struct smc_link *lnk;

 	if (!lgr || conn->freed)
 		/* Connection has never been registered in a
@@ -1287,8 +1290,13 @@ void smc_conn_free(struct smc_connection *conn)
 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
 lgr_put:
+	spin_lock_bh(&conn->lgr_lnk_lock);
+	lnk =3D conn->lnk;
+	conn->lnk =3D NULL;
+	conn->lgr =3D NULL;
+	spin_unlock_bh(&conn->lgr_lnk_lock);
 	if (!lgr->is_smcd)
-		smcr_link_put(conn->lnk); /* link_hold in smc_conn_create() */
+		smcr_link_put(lnk); /* link_hold in smc_conn_create() */
 	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
 }

--=20
2.50.1 (Apple Git-155)

