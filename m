Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795178759;
	b=cvlcDnBDKBui77EYgELspMVpoa/bR4aYKEHNz3e6lZnFqF1m4XqM69J3LfeZEgt7qwOZ
	 vdmp6n94g5SH0QCcTX9W0YeB4rVT3cHd1B9ZwnVhg2GpE5NMLatWLTXW3GBqo5L5CydBH
	 4JuWN6n56lIBUJ/vnhYbyJrWPAU6ezTBpq2VSIIF5hlSn7nKgFbuxDUEVu5Z1a4aqYr/E
	 qKsJQtOhbdyzLmunNirXjz+yPnh988VIRTmSFiQTi/rgvaEz7y9abXPxlEHciLe3MWchb
	 Ce5cCGKjuHg66xGvTS8V4Q1kLI5HWT07ihnT2XoyR8/hZ2C0NdufIIiA2VRwOSlp9Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795178759;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=De2HgVUYKEIAINfe/1hSpHkMnHxovRlzC2jRpg9nyXI=;
	b=Z18PnRksWE4tf+Vedo2ptvB5n/wLKpmvvOwrk9qOqriyTQJqj3DmABq6d4OX19CQBAHb
	 aXZLr6cQ9kbc66d8sbd3IFFJQLEPxdm4d7Am/qiKuwGVYxcMcxE6wjyjJojzh3htJcFy3
	 yEaOXYYXIMcQDyLNktUo3y+9SEXaQlwjgpiaS33KFykKQNdLyGDVtnvKqZF3mcGD7a/hp
	 F/KgMpwAkKiT0wN3O1wu1We9kYo8mrAxP5H8hKZOVk0FVYqoA0BcP2Xj4VFkBMoqpTkHb
	 0qIYaF31cs+kxC1x77ydElwlHoEpLhsw1JFhqZroR1BRgiJQQNBdMwfFrUkOGxohRmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ptAs0fgf;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB2B606A320;
	Fri, 20 Nov 2026 12:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EB2B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ptAs0fgf
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAuRX12860773;
	Fri, 20 Nov 2026 12:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=De2HgVUYKEIAINfe/
	1hSpHkMnHxovRlzC2jRpg9nyXI=; b=ptAs0fgf3TymVKk/1wX7OJHzIazXo1Ng0
	63WlQAy7K/47eI3Er88tnL3GjvxBRWaVKhieEbzWbQytOgjUac5EgE4YlGnoTuO+
	zQTFUTsLY+Nv4eNQGLx1DXvwdT3eSeZRQPDwfgwH68ri+NofprfMXZhPNh2Q0IH9
	7CHa6zZe/XPJOJLxA+rS2vKtrnzIOdbhegoDXaLZVXv/ESwACfq1MeJsexM/ioPJ
	DlmR/7ExM8lNxkFTjzUOnyuF/DXiabpgCwe6goTYVfD9OlgkTyUO6REC1OmukyHS
	kEo7/yveNEtwfw2Pkd7LfUp71O2v53nvx/a17F7snZxthQU1FnfPw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105x82uh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 12:45:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAnvTj2162669;
	Fri, 20 Nov 2026 12:45:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j1m3j25pw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 12:45:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKCjfJP45482414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 12:45:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9227920043;
	Fri, 20 Nov 2026 12:45:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5600620040;
	Fri, 20 Nov 2026 12:45:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 20 Nov 2026 12:45:41 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 3E779160DEF; Fri, 20 Nov 2026 13:45:41 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net-next 1/3] net/smc: keep clcsock until socket release
Date: Fri, 20 Nov 2026 13:45:32 +0100
Message-ID: <20261120124534.430200-2-mjambigi@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: DC0LqePRszzj29xCqpuHKJP1ut7YDKaH
X-Proofpoint-GUID: kAJZemH2CWLqK2uspZi12AGgtAnOIwk5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0OSBTYWx0ZWRfX+JpHBLiy/qjM
 3VZtyGhKrjtdM65LFRG9BIdvDr0hNsBVCgym9BCJlNt0zp2ZfHdHCVGnRgPagLvCdywvRYLBvM8
 xrMg3W7dgbrNe65oh8LxTOE1MItmU8TICYcVpnEOc2/RVPlzVWcSYDwj+9xWcKU7IV9y1fQoc5U
 Lj37tEDoyNfJ4KlJqXJIrgqgyOr4mqyaSXHzdDz5RpBKQlb3LHkTuEGid+IH2MQBjPJHHryfoW3
 Hq6cTqpFMZZwysqGv6XQswgHCr1/5Tmhm2YNgolm9Svu9SmLxQQQSuKsu/wZ6UIDV9Dl6nBszou
 pPhAKgI4pGGPuThnUFoW99zZx8hYg8kVGjKIsb97G440kNvPa3m7usfAPZu2/ycAmcmgk8fEh4Z
 hZuZQilLOUfBxdrSZFJik4m6KzBXo5tyYK+xk+aRh/+x84eNcJL9ZTBdYEZsCw2QLxt0McB4TLu
 dooAZ3kJ/ZRh0n8C8cw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0OSBTYWx0ZWRfX4QD0yOqLPJM8
 Q6nKS+4dmrtJTbyPUY6feAHzDVqRtmUGVc4PgP/suQT6hT+Of9A4KBHefMvz8q4s/Dlhgll+QZa
 WDHIXO2vqqvtUASAoXWaj0/Qm9I/0P8=
X-Authority-Analysis: v=2.4 cv=K+m3jCWI c=1 sm=1 tr=0 ts=6b0040fa cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=zmzxMRKWTMvrz3c1K5kA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200049

The clcsock of an SMC socket can be freed from asynchronous contexts:
link group termination reaches smc_close_active_abort() and peer close
reaches smc_close_passive_work(), and both can run while the socket is
referenced by an open file. A task that uses the fd then operates on a
released socket.

Free the clcsock only when no socket file can reference it: from the
release paths, and from the abnormal close paths only once the socket
has no file left. __smc_release() now tears the connection down before
it releases the clcsock: smc_conn_kill() and smc_close_passive_work()
check conn->freed and return early once the connection has been freed.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/af_smc.c    |  4 ++--
 net/smc/smc_close.c | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bfc0c7e71a12..1d8a602729c1 100644
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
index 736abfbd2aaf..cf1add1ffda6 100644
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
@@ -452,7 +462,7 @@ static void smc_close_passive_work(struct work_struct=
 *work)
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

