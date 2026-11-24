Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506609;
	b=YYicQc61P5UBVKJ6HuU3Xi20DchxAZuHQ+vUArX8Vbcx1EzZYOKFuvUBzx+CLWeHp6sc
	 ogLPipGu3HqupZxJs3WFDM64DYs1u+JNkFIl3wL+3gO8o0oxN9OlYV0M52TpTtou9UAtL
	 KgJGlzQxmt6oHwaYawOey3dXnXEhliYP/ZkLWX1aTA5it3P1a83Sv3/lyl5So+yWj/Kg6
	 sgz66/rvsyVUXqNYU4I3/Q9e1y9FmZH5ulpJuINd9ips9AU8Z3FERSMQp3tKGDEaNTg/O
	 w8lrlt24iP4IwOaJ76zUrvE62n50pwnFUALCrJw2YsBLPWu8zxcuhKHgeN+RYvwSbug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506609;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=f+OshaMEDulHRNhR3Q1l1KGElObgx6lnMxz1yHn0XBw=;
	b=PsVKw58taqHZmNqIjvEHtZGhpWPoseXLdSj4d4zWnXCTH4YgBpYLGXl/a0p17iyent0i
	 VR4oclbBIbLwh+KnSGd8G8TmefinFikvaXvVy8jGJVEgh9sKEOhQGtJ+BrqiEuBqvHc2P
	 t0pWlHr7qx77/sfQjg6tCnl064XQinfstAw3SZJT1ZjvnohpXWZU3zoS9fD6sHAEbWRQW
	 QoUWW4fKWu2EW2OvRonst4BysxVwqNHHq1Zlh+Cs4gaJ7nErveKmniJbIhn3bKR8mQN79
	 ix4YId6PnhE/wTxxu7pM10xyy1O87EoReXEhikfPhIOdW6S5pnmtTYyDSwZv425O0og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=EMiLLcnO;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D4606A321;
	Tue, 24 Nov 2026 07:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC7D4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=EMiLLcnO
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO34mD91412604;
	Tue, 24 Nov 2026 07:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f+OshaMEDulHRNhR3
	Q1l1KGElObgx6lnMxz1yHn0XBw=; b=EMiLLcnOMwPNeYuic2OnMHlWzU0Po4dK3
	eFcHLOSDUcOXPxU6V0IYIzCFHNwdJmU7r4zLUMdy6r4MpYNNJCoG8acWwzdc2tZv
	15nnJkBT/W4hlaDAniiMfSNc0Y81peAoNjO6Rkr2EAPo3Wqhv6z94fOkrSp/7dLZ
	f5jLTFRGxmkbHK7pg6iPZjjTOWaBqiWgkUJtlVMrHGYxFhj88djTnN7OMR6Gn5+U
	5lBVxO6hqGwIIt2TiLX/4C07+cWgskvMBHTBLUBLT+CzPY3r+EMETG0BBmgUU3BC
	Y6STl9kBCRDRA/e2jkaCVBmjrgPwbmNZqHNtJKAUcZ77f7b2P50dw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fa6nxe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:49:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2nARU2838089;
	Tue, 24 Nov 2026 07:49:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j3rayhfbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:49:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO7nerW47579524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 07:49:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48B472004B;
	Tue, 24 Nov 2026 07:49:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17B5320043;
	Tue, 24 Nov 2026 07:49:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 07:49:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 03FCD1616BE; Tue, 24 Nov 2026 08:49:40 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next v2 1/3] net/smc: keep clcsock until socket release
Date: Tue, 24 Nov 2026 08:49:25 +0100
Message-ID: <20261124074927.3622245-2-mjambigi@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
References: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX2nHOyS1hVj7v
 +Xm17O314+VkfD52tfkHczEYfOPI2xJBET0o7ocvH+NsLfKSi3EaNx9773FwKYCGa7CO2JOEZI1
 bWTqDFVvpAttIJBGruvm0+HYRHtMNdbNwZMQ6zeud/MSPMOBw3L8nBuofCVEyDfCFSmKFL+wN1l
 rb+fZyRdzXq9QZ2ZqR4YTEXVeWu1DYs15UpZFYNhFAJSsrp0P3My3wm2rwiAZNQrq3IljfoK+qC
 +4yztCrX2uwGwDdeyyqIhC9ruHne0h8olmEFLfjy9E5+gLM1g9ZNMej2TqSVfZZAGA5zpYpk6X9
 2VqtEACrfQROp+LPCzhDNmkB3628KJx5o/yAPjgwZIj6Zj97Ck+L/+gzWga+WSX0OIRmvawDtzZ
 FAgGP6t3UcNTG+QwZXAvqfwAaiv7Iq0Q04gLb2Uq51PpYRvAiRdcCXFj23Rhtl0IDFGfzLdj8Ze
 Kf7uz4JDcnIkGA3ccgQ==
X-Proofpoint-ORIG-GUID: yzUld2_kElrGRqhp7h1nNwWZ_VIx8ths
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b054199 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=zmzxMRKWTMvrz3c1K5kA:9
X-Proofpoint-GUID: 4hVAlTV02JlaujhXNCklbSKxF0fuzy9j
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX/5aUmINWNNU3
 iHHP2ku2OQs7q74/9tW9UR0Fa8//L3g1+/iV6gPQvX9iK3+PirZXdLC2AVrsjn7jE+5ZoPKZT6x
 8NMmS3xGRJghhIykIdYHwLbJQQljPdE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611240030

The clcsock of an SMC socket can be freed from asynchronous contexts:
link group termination reaches smc_close_active_abort() and peer close
reaches smc_close_passive_work(), and both can run while the socket is
referenced by an open file. A task that uses the fd then operates on a
released socket; this was found by code inspection, not from a reported
regression.

Free the clcsock only when no socket file can reference it: from the
release paths, and from the abnormal close paths only once the socket
has no file left. __smc_release() now tears the connection down before
releasing the clcsock, which is safe because smc_conn_kill() and
smc_close_passive_work() return early once conn->freed is set, so a
clcsock can stay allocated until the application closes the socket.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c    |  4 ++--
 net/smc/smc_close.c | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c0d9051..7415829 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -313,13 +313,13 @@ static int __smc_release(struct smc_sock *smc)
 	sk->sk_prot->unhash(sk);

 	if (sk->sk_state =3D=3D SMC_CLOSED) {
+		if (!smc->use_fallback)
+			smc_conn_free(&smc->conn);
 		if (smc->clcsock) {
 			release_sock(sk);
 			smc_clcsock_release(smc);
 			lock_sock(sk);
 		}
-		if (!smc->use_fallback)
-			smc_conn_free(&smc->conn);
 	}

 	return rc;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 736abfb..cf1add1 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -36,6 +36,14 @@ void smc_clcsock_release(struct smc_sock *smc)
 	mutex_unlock(&smc->clcsock_release_lock);
 }

+/* The clcsock can be released once no socket file can reach it; while a
+ * file is still open, smc_release() releases it.
+ */
+static bool smc_clcsock_can_release(struct smc_sock *smc)
+{
+	return smc->clcsock && !smc->sk.sk_socket;
+}
+
 static void smc_close_cleanup_listen(struct sock *parent)
 {
 	struct sock *sk;
@@ -157,7 +165,8 @@ void smc_close_active_abort(struct smc_sock *smc)
 		sk->sk_state =3D SMC_CLOSED;
 		sk->sk_prot->unhash(sk);
 		smc_conn_free(&smc->conn);
-		release_clcsock =3D true;
+		if (smc_clcsock_can_release(smc))
+			release_clcsock =3D true;
 		sock_put(sk); /* passive closing */
 		break;
 	case SMC_PROCESSABORT:
@@ -169,7 +178,8 @@ void smc_close_active_abort(struct smc_sock *smc)
 		sk->sk_state =3D SMC_CLOSED;
 		sk->sk_prot->unhash(sk);
 		smc_conn_free(&smc->conn);
-		release_clcsock =3D true;
+		if (smc_clcsock_can_release(smc))
+			release_clcsock =3D true;
 		break;
 	case SMC_INIT:
 	case SMC_PEERABORTWAIT:
@@ -452,7 +462,7 @@ wakeup:
 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
 			sk->sk_prot->unhash(sk);
 			smc_conn_free(conn);
-			if (smc->clcsock)
+			if (smc_clcsock_can_release(smc))
 				release_clcsock =3D true;
 		}
 	}
--=20
2.50.1 (Apple Git-155)

