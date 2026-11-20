Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795178764;
	b=hZs3b3q+h+E7/MOeaRFrHD9S8WsKPV40a0I1h+F0xTXv/hC+wuEHdLGuypceWq+Q1bAA
	 8i0oXLlGASDWJ4vnl+egUfbUg/qPKdVn/l6+yIehEHSku46M7lBCrgouH1wbsa9S/15Eb
	 cBSurUUKGibknJ0mz20P8OATyhApoVOX1SUEME5k2YE8RGsuzVn+yh7sluY6QqbCX3QQI
	 t+dCeM7CLLVI0woFjfld9jfhg3rbzkJm+XR7b535B31NmEhs3EsiqedO/phUCE4KkVSgj
	 FDQcJ+uR9rAy04vFTzE9cPfL2iehBBtt6MI42nCxDiiUf+8jRbhYBeFxUspUOavOaeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795178764;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qw7skbb/Yq8+KrzgBD+4DEFZTJqSpnJEFM+uTwTxDW0=;
	b=Yyvg0gxFrr1TMIDAZFVHJfC+qhRfvQfbIJYZOi5/xCQVZUM86tCHwugpQJ7IfKmLsXr+
	 64oasRISBeH7D1J1ZuE5qbW0ZLsL3lAiraJPmTFeeKZwVRhlobjaI41O9xKjtFX/n7Ie/
	 XYRuP00ojMeGrGzCNo1rNQREI6FQlxmYAACUrxxFVxjq1jrygIvUeYDlKxlkrVDeEBsuU
	 LMrLZ2+ZaBDxGZsxiLtnYd6qKNFs3p6YKv1VgkSBq8EXVBUVigyZ1vPKs/pBftsC4HHSM
	 Iul9XJahnlTcDhS+fONdJu8jkgbQquYzPMiASdR5Eqg6k5xWBj8T/CdzhzBCQn03TKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=aKr+4kOF;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E163606A32C;
	Fri, 20 Nov 2026 12:46:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E163606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=aKr+4kOF
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAu1Jx3026356;
	Fri, 20 Nov 2026 12:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qw7skbb/Yq8+KrzgB
	D+4DEFZTJqSpnJEFM+uTwTxDW0=; b=aKr+4kOFWe/eeNWiL4/CbS8Vj0wAUSCZU
	rkBqIykBFH87UbE1eyPgkwwgmsj6V/B1uj8Wtqffv0rzWjAsHGshxc37xMnvIYy/
	SkLNbMzfJM/mr0vwVv/GhpxhKZNwisEbabmzMNwCcP7MZWt2A+jgRBLO2HMA3PX6
	tQrA1RMlfKjvJhbWJ7L3wPFsVWtRc0Ju2xtjY4dYKEa00wMybDH5K2bHQWBpa1ZR
	XtVHDDBLGOOwn1m9tzHWe+xRqQ/h5SCJXHvRHIT3IKzWgQWEYQDWYdbBL5xBsm4u
	zym74KWcRhUh+lidfusMz1PZtJDdUDZ8mkImLh3rgU2LA+y8TA59g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105nrd97-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 12:45:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAo3324130847;
	Fri, 20 Nov 2026 12:45:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j1v9xg2ke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 12:45:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKCjhRo32768482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 12:45:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8716620043;
	Fri, 20 Nov 2026 12:45:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A0A320040;
	Fri, 20 Nov 2026 12:45:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 20 Nov 2026 12:45:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 328EA160DEF; Fri, 20 Nov 2026 13:45:43 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next 3/3] net/smc: document the clcsock lifetime
Date: Fri, 20 Nov 2026 13:45:34 +0100
Message-ID: <20261120124534.430200-4-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261120124534.430200-1-mjambigi@linux.ibm.com>
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0OSBTYWx0ZWRfX/t75durnS3HG
 Iv9mIWXco7PV3cn/eyvJc6EiLEIrqX6H7UxomPLD7D0TRC/PTCClur2r5BOQsVRSdL4Jccq1Dll
 pyWqwnKNv7wAN58qbPtlR23fkNOj4+iXPHhU+cw9jc+fIRl32uCy9C7mefMv57fPINeAaZDGFUA
 3tGEFC0lx36VYUQW0+WVA7+QWz8JaPMb4zmUfsz8KcobhprWTxYiIXJ08IRi47QPmMCiNtoV2qh
 k7Ved4bi+7hksmON1OFcZY1LrekF5CrEloGhsFOhqXj7szHPwDYgWstLK9nFpCLt8+lqWtv4lYC
 pjR4+Wv4iVs6O8NVzNlxKZ4UdCHbyMdc1oAD7JHWON+2raDm3rKYOpQc3L+f+OfcLwOrINDm6yF
 eSgxvE8rG7Ft8c6Xru9znVpfMAIy7H6etwZLS3+peUWGmbz8puPvfxIl3WZSjU0SYnLj6Hz54HQ
 5exd08rKep4SKj4mcYA==
X-Authority-Analysis: v=2.4 cv=HN9WhYtv c=1 sm=1 tr=0 ts=6b0040fc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=yV60tvTADACx1VT-17AA:9
X-Proofpoint-GUID: Xc81P_FaRCUkRxLKXMe1otriLJakuAUL
X-Proofpoint-ORIG-GUID: naJFilHXbXTUD0_S22ZXDde4eKj950hB
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0OSBTYWx0ZWRfX+37Zf8SWK5AF
 kTVNVJV6bofv8SmJRw8MN/+AmbbKjEln49nsj1kKmmMM8sB9zWwdRQa4bhQzW2TASjEsLP5mBsB
 K8fgXspUPp31JcX0+/MTqwp8biQTFEU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200049

The clcsock is freed only when no socket file can reference it. Record
that invariant where it is relied upon: at the clcsock field, at the
release helper, at the diag dump, which can find a socket before its
clcsock has been created, at the accept cleanup, which must not wait for
the listen work with the child and listener locks held, and in the
destructor, which warns if a clcsock is left.

Freeing the clcsock from the destructor is not possible: it can run from
an RCU callback or a softirq.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c    | 13 +++++++++++++
 net/smc/smc.h       |  4 +++-
 net/smc/smc_close.c |  7 ++++++-
 net/smc/smc_diag.c  |  3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index cc7fb2d90637..dfe34b5fdc93 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -373,6 +373,14 @@ int smc_release(struct socket *sock)

 static void smc_destruct(struct sock *sk)
 {
+	struct smc_sock *smc =3D smc_sk(sk);
+
+	/* The destructor can run from an RCU callback or a softirq, where
+	 * sock_release() must not be called. Every path that drops an SMC
+	 * socket therefore releases its clcsock before the final
+	 * sock_put().
+	 */
+	WARN_ON_ONCE(smc->clcsock);
 	if (sk->sk_state !=3D SMC_CLOSED)
 		return;
 	if (!sock_flag(sk, SOCK_DEAD))
@@ -1825,6 +1833,11 @@ struct sock *smc_accept_dequeue(struct sock *paren=
t,
 		lock_sock(new_sk);
 		if (new_sk->sk_state =3D=3D SMC_CLOSED) {
 			new_sk->sk_prot->unhash(new_sk);
+			/* The child is on the accept queue, so its
+			 * smc_listen_work() no longer uses the clcsock. Do not
+			 * wait for that work here, the child and listener locks
+			 * are held.
+			 */
 			tcp =3D xchg(&isk->clcsock, NULL);
 			release_sock(new_sk);
 			if (tcp)
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 616bb3245f7b..c6bfe63a947a 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -288,7 +288,9 @@ struct smc_sock {				/* smc sock container */
 		struct sock		sk;
 		struct inet_sock	icsk_inet;
 	};
-	struct socket		*clcsock;	/* internal tcp socket */
+	struct socket		*clcsock;	/* internal tcp socket, freed
+						 * when no file can use it
+						 */
 	void			(*clcsk_state_change)(struct sock *sk);
 						/* original stat_change fct. */
 	void			(*clcsk_data_ready)(struct sock *sk);
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index e71245dbb296..d359436e5304 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -20,7 +20,12 @@
 #include "smc_cdc.h"
 #include "smc_close.h"

-/* release the clcsock that is assigned to the smc_sock */
+/* Release the clcsock.  Call this only after the socket has been
+ * unhashed, and only when no socket file can reach the clcsock: from
+ * smc_release(), from the listener cleanup, and from the abnormal
+ * close paths once the socket has no file left. While a file is open,
+ * the clcsock stays in place until smc_release() runs.
+ */
 void smc_clcsock_release(struct smc_sock *smc)
 {
 	struct socket *tcp;
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 15485a08d9a0..42828ffe90b8 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -39,6 +39,9 @@ static void smc_diag_msg_common_fill(struct smc_diag_ms=
g *r, struct sock *sk)
 	memset(r, 0, sizeof(*r));
 	r->diag_family =3D sk->sk_family;
 	sock_diag_save_cookie(sk, r->id.idiag_cookie);
+	/* The socket is hashed in smc_sk_init(), before its clcsock is
+	 * created, so a dump can find it without one.
+	 */
 	if (!smc->clcsock)
 		return;
 	r->id.idiag_sport =3D htons(smc->clcsock->sk->sk_num);
--=20
2.50.1 (Apple Git-155)

