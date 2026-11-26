Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675953;
	b=u1zrHBcYPm5s7W/elU2B95rf2lX6tQEXhuJjVUr2vfS1kQ5Bwdc7Bko4hsDeO7W2wN/P
	 EkS4B7+k9CO9vEG4iIgq6ppj8inm7G6KaY7kCN6ieECFr1iaVIf72gDtkz479Pu3B1J8w
	 Yt7spEcfkSBlqdzVZCpVoyhTiySA5UE9ZcgqVSnMyZNSblMeuG6eEolMUNwOximhZK5hg
	 kxvXss6GH2uGveGdoSy/iRqCEbsQTEQ3WLs8Rwen9BAhPDUlB0xD4u93tlb39Bdm7d5b6
	 5rDqR03nkCRVk3DdErVvd2SEd532RSwN0Asq8xHwh1ujOYib7bATTUiAEfXqg+WXM6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675953;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=6q+k1KW0uvMcUqpdAQSdRSc3h6zCB9cBt8oZisHqa6s=;
	b=SKK5YsbHe+voWsftVK5F1vkNlobbwhWKiONZeg52JDQlLskrsvHNomYwYp5M/ArUKfXg
	 McfkP0XdnaPXUcYUCNSlvZFRpQ+8aQMbNckzPYA8kfAmFVnFqLceGHbrsYWb1y46OBZMr
	 whzTJcUNw79klUHb4TR3ZOSWgRJNkvO9zjwLPJadrdHn6ag2gnZphb06zWCW/Ftl79Bn/
	 PABdmUNsgP9USJd7j27l+6rcm4JgTGVSdFllBhe5Qsycj0oo0GJ4m7eAvCqg3/1EMdzE+
	 h09JfUKeKPSiwL+vSuhGcwc2bslmKZC5m2j5QC1mxYrgMpM/yPL47q2g49dUtShjVpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=TUp+Ebvz;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1297606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 06:52:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1297606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=TUp+Ebvz
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34Z8F3130364;
	Thu, 26 Nov 2026 06:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=6q+k1KW0uvMcUqpdAQSdRSc3h6zCB9cBt8oZisHqa
	6s=; b=TUp+EbvzBJHc4zkqVxicd3FomyxLDT7JMhQgXW45JpuJAPEcojOYg7x2A
	AwXpFw1wspdW/PgV9mTQ/dWVKua4pqKMbeSqdHNjzvGzNZmGhsdqHLcutGhWqO8z
	vwTSVNEDXB01arUylC9cLeHfQiIHypBqvQQH23cokgviwGs7AKeYo3zbcpneXTwb
	K8F8gcy3twEYJYM/PmvbDD5Xuu+lO7HGfCVGaPZ3zoAKQTPGqWEmaIL8g6orarCF
	ve7HfbCASbE2l1HDIdWjti4qpyaHbMDQyskmQ4GHiGETpjWpCFkj3w7f86vM/OAv
	fTZUKw8n+cNZSK+SQDmWeIEmKej4Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fkr2dd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:52:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34Mak1635195;
	Thu, 26 Nov 2026 06:52:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5axkxxc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:52:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6qP3W49807832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:52:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0DB120043;
	Thu, 26 Nov 2026 06:52:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D51B920040;
	Thu, 26 Nov 2026 06:52:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 26 Nov 2026 06:52:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id BBA7116176A; Thu, 26 Nov 2026 07:52:24 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH rdma-next v2] RDMA/mlx5: Read the CQ consumer index under cq->lock when arming
Date: Thu, 26 Nov 2026 07:52:19 +0100
Message-ID: <20261126065219.1367677-1-mjambigi@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX2o/Hpb2B3sLS
 vMAwDbW+d6y4kwHVbMFPhvm8tfi58GQ1qXlWEVBB20Bfz6kBvx0bPYQXeNNfTQV/XlffMEjBy9y
 iY5k3B044Bav8U4qppu8lrn+aSQO2HtUo8uaYkM0NvFsMkdOVWYi72gJUAi08pVufoKa8xWOz4f
 SrkU8TbWb44MT44enCut62mfXIKFYbEDeQDjWXqiiNo4c4t/hPlMyX25SNtNO3onA49ADI2fInN
 jalDZqpLX2NWk24zvi+2fdLvt1qbIsr3e3FwDzgb5CntqabufmjxEFmKcv3lrYaF67G19zdkGu2
 /ckR7ZVYDwGCtOg+CC6gyQTfQ+oSTrnQ2K7ILLxidHl/+8Jiy53k1iykwf24YW4xRJaDmPTnZHH
 mqT+FgX06IMgec9bsAERPbzbLfVbWE1B1VcgecWSljqBk2kq2+komSQs4/9DSmmzBKgofYGb77E
 Pvwk9oTAYEkCQM6MQxA==
X-Proofpoint-ORIG-GUID: K6BzbQMwmkyNbcr7WIQ2oKrGa649n-OJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfXyFNJ1vtR2rfK
 fozQWMzomItnAlwFq01XsSLF7Pv6KynM+NTy1javrQit6NNuZQFF0hoh+TFBZFwV7DvQyqqDw+o
 z0Ecx5gyUo/xg3q6xNiJUxt4n9n5IoY=
X-Authority-Analysis: v=2.4 cv=A9z5rKWG c=1 sm=1 tr=0 ts=6b07d72b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=K1o--kdIHIAxDJrx0LIA:9
X-Proofpoint-GUID: K6BzbQMwmkyNbcr7WIQ2oKrGa649n-OJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260025

mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
the poll path advances the index under that lock. A ULP that arms the CQ
from process context while the completion tasklet polls races on the
index, as SMC-R does from smc_wr_tx_send():

    BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / mlx5_poll_one
    [mlx5_ib]

Read the index under cq->lock, which every runtime writer already holds,
so the value handed to mlx5_cq_arm() is a synchronized snapshot. A stale
index can cause a spurious completion event, never a lost one.

Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
Changes in v2:
- Drop the Fixes: tag. The unlocked read predates ce0f75093282; the race
  is as old as the driver and this is a KCSAN annotation rather than a
  regression fix.
- Reword the justification to cover only what the change does: the value
  handed to mlx5_cq_arm() is a synchronized snapshot. The arm record and
  the doorbell can still be overwritten by concurrent arm callers, which
  is a separate pre-existing issue and not addressed here.

Note: mlx5_cq_arm() also reads cq->arm_sn, which eq.c increments without
cq->lock. That pair is pre-existing and separate from the race fixed here=
;
this patch does not change it, and I have not analyzed what a stale sn
does to the arm protocol.

 drivers/infiniband/hw/mlx5/cq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
index 55ffd7d4de51..8f4389b4eb6f 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -651,6 +651,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_not=
ify_flags flags)
 	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
 	void __iomem *uar_page =3D mdev->priv.bfreg.up->map;
 	unsigned long irq_flags;
+	u32 cons_index;
 	int ret =3D 0;
=20
 	spin_lock_irqsave(&cq->lock, irq_flags);
@@ -659,12 +660,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_n=
otify_flags flags)
=20
 	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
 		ret =3D 1;
+	/* The poll path advances cons_index under cq->lock; take the
+	 * snapshot here so the doorbell sees a consistent index.
+	 */
+	cons_index =3D cq->mcq.cons_index;
 	spin_unlock_irqrestore(&cq->lock, irq_flags);
=20
 	mlx5_cq_arm(&cq->mcq,
 		    (flags & IB_CQ_SOLICITED_MASK) =3D=3D IB_CQ_SOLICITED ?
 		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
-		    uar_page, to_mcq(ibcq)->mcq.cons_index);
+		    uar_page, cons_index);
=20
 	return ret;
 }
--
2.39.2

