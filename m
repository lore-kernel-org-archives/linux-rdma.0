Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505804;
	b=ZJGA3W5+dn2QUeQKdtKHeCzT/Ll2dv3AIe/gll9VNdPFXGbtMbC6D6GiuPISqcP39XsC
	 IqH7nhPWs6PCS4owV0khJPDhz96A4FbGodD2V8lOniqBOhqUj17PlDlAISTmtOE0gB+hE
	 k1dVvIghMxfD7PMVhQz538t3FW258dhrE3t1m2eznmKSe5OJDFvHQnuPpdXdtmilP8327
	 Za+MpfBJSwspAATTriT3g2zX2Jau+Cfqu+Eu+tPC0eqMJolDbC0mrDOGLjpmL5+2di5gw
	 JCNIElEQyZkTxEJKeoiLFrb0rH6kOmLTNzdgYR94i+4sLjtPV3r8UC9yZpQo1pmmlHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505804;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nvp0TIIM72pQmGrxbalU/C+A9j6skVIejL51JW7JWHY=;
	b=2AbDv5d75I3vwve1nzsO/bBjkCsPbZFHU6mcCPg9gqyIT5Kd1WQ9U8Hf+JOjWgSw1dZt
	 5NGvlt5v3HQ770RCwptZELD+ljit/NN4/GH79NoyRjhw+jFQ/b20JM6gDXrl+0llxMzS0
	 +aYK6tEhkLnHpEThEVM7PTPpUQRs0CYvlMao8kOdv7ns3CED436eva3tTReiDPsHoRw7G
	 wl4PnNSJEnxzsk2wE4NXSGkqSHcl+07Cguj4MzrB5mLY2uySBLIVHWX2PUPvKR9SZfbey
	 nPXarDbARqXbjxn01yjts9t6K2JbY8iuoq2/z8SAwv+/J3nr8J7TfBS1KFUrFONJ/xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=VxAcHiWw;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1969D606A686;
	Tue, 24 Nov 2026 07:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1969D606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=VxAcHiWw
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO34mE71217045;
	Tue, 24 Nov 2026 07:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=nvp0TIIM72pQmGrxbalU/C+A9j6skVIejL51JW7JW
	HY=; b=VxAcHiWwk69sF9EtLyHIctjMz1lTtyFHi1/U9ISy2G70jOLFokvYtjMUJ
	lA/lWtoAzDbervgzHFFF2k3WynVkk7s0ohgkyFvsjbO6sFVtiXMNxoS8rylLv0Zs
	ydv135PX18W1HmDskNEdtgo7yqbRLPFZLiHkCZe8vURcKmWuhdtbnxegA9LZPbAy
	8lnXWR8njN4wwpPfd2e3X+GjjOvWdO5rbRorDXUENnYBrclgHhpU9N4nVT309Ne6
	1Ywsn6OQp76+cyP5HaBTiQq8ATCSrBag0De8x4hiL4FnSiaJ6SeCdjv5yqD2RySp
	lCZHZhN21lPibvBoNk1XNgHsqNZUw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34gv68xf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:36:12 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2nNVq2838319;
	Tue, 24 Nov 2026 07:36:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j3rayheex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:36:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO7a7qF48890254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 07:36:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CF372004E;
	Tue, 24 Nov 2026 07:36:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48D4020040;
	Tue, 24 Nov 2026 07:36:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 07:36:07 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id 333911616BE; Tue, 24 Nov 2026 08:36:07 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH net] net/smc: fix sock reference leak on abort_work cancel
Date: Tue, 24 Nov 2026 08:36:02 +0100
Message-ID: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=CYCdd7rl c=1 sm=1 tr=0 ts=6b053e6d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=p5Vn_19Q5Cr7Mw5R8fQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfXyuGmSa5q12BO
 FmWfqJbTJf54IeP+SmgmjoAY9ddDwwbyQPujVdRTKaUXfjM7Mdh2fVsLsiUcg58/B1sTWOjXJ3S
 W8P2IPr/BkOz9MNxnuIuDeBmt2E1N3E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX8nTGfTxaWDGe
 NuOXvuPIvErsV0EW+hV3dDylHKBMhGfYhXLbpNbRk93SnkmWFcyFZIfagQYqGLCTd5A3O9/9aNL
 +SpW7/9UuS7ZP9OlUhJ/GQIQsIgklrUyg1ke6albUe+OJaRfWRNeHwiYNjdTU4k15Fx16iCXH7G
 +UCxxUUwb/ovZLTYYn6oxJqjzGB6j3Ql5oQHxB0BpZkbMOXsIOt4MNg1Yv+13tThC2gvp1SQOwW
 BDm9utHNAaQSxk8ev76lBoeHpobSWC4qEXeRQd+1L3xHxAy7NCNR6HnaZ03PXzYNDBzn3G94dkX
 fjlUxfqCLswrPT1xWPJtmWgJmjkNaprrAzWTQIH/CBRp/xxV/g6i66DZDIh2O7NckGu4gOO+R7G
 ngSkIbg/dDU5SDDzMmp8IQCzUMFJtj/F87cy1JIP+IhnmsK/36p6E9lDmjHl05n3yuf9m2JIT3x
 qgmrFvSIDmPuIGRJB0g==
X-Proofpoint-ORIG-GUID: YRMsN2wLhAvF4Oi_EfEOdJb40SgBjyJI
X-Proofpoint-GUID: hfB79F6dPKtxnaXY3PqD0L2mZGfNrCtN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611240030

smc_cdc_msg_validate() takes a reference on the socket before queueing
conn->abort_work, and smc_conn_abort_work() drops it when it runs. When
smc_conn_free() cancels the work while it is still pending, for example
because a close races with a failed CDC validation, the handler never
runs and the reference is leaked, so the SMC socket is never freed.

Drop the reference when cancel_work_sync() reports that it cancelled a
pending work.

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Cc: stable@vger.kernel.org
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
 net/smc/smc_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c142..3c08be976de2 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1276,6 +1276,7 @@ static void smc_buf_unuse(struct smc_connection *co=
nn,
 /* remove a finished connection from its link group */
 void smc_conn_free(struct smc_connection *conn)
 {
+	struct smc_sock *smc =3D container_of(conn, struct smc_sock, conn);
 	struct smc_link_group *lgr =3D conn->lgr;

 	if (!lgr || conn->freed)
@@ -1298,8 +1299,9 @@ void smc_conn_free(struct smc_connection *conn)
 			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
-		if (current_work() !=3D &conn->abort_work)
-			cancel_work_sync(&conn->abort_work);
+		if (current_work() !=3D &conn->abort_work &&
+		    cancel_work_sync(&conn->abort_work))
+			sock_put(&smc->sk);
 	}
 	/* The handshake can retry another device or SMC version with this
 	 * connection, so it must never stay registered in an lgr it left.
--
2.50.1 (Apple Git-155)

