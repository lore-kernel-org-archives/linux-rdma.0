Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795596079;
	b=FUxYCkGK9TgRj7O7U38iJ+fP6LqHJayOwAsVXWVtWw676t6ExZegsvkbS2pokUaubxqD
	 RX4PFbh3hMz5vSwu4rRZaw+stuNVkwvtAmvlJnH9i9/n9LMmIESxbIZN+7azMPqcTTdkS
	 Rteo6DRdRP1OW9YqWKoSpeAwmki8Yzvdqt86RnYLY8WByx6R0eVO4o+rIJWRsOIWMvlwB
	 Nrqnt869Ag3+EA8K/zGtVzLdgM2WjIW6bixmZWhkkchQM6IMNMvRyJH/mbvyy2eQDteBl
	 UGIfok6uIfWXG2+zC64gH/L6jo7Aw/Bza3mhuLJsjlvmpQxsMUB7IIxdwzFdCZps2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795596079;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=hx7ymV6DGgPv0bkBA/qbo0lNZwLbD2t54Q3ph2aro10=;
	b=qQVwm+RFLEK0wOyjoBM+8d/vmFHWdtjtjFAdLs5hcOF4czsEd7GxT1C7Zj5Ljd4YYJsW
	 JTNoi+mWHuTnotzLoUNc2l5SHJNES/FQbkZbubgRkJFyEyvOW9azsza2iFetlwmnXOxRC
	 kekIArWyBkDwGVZYuOHpbWOPLBCpBa+hdUv4AokOXCy/JB01A3tCdDvKVH/kjD6lExyiw
	 VBw9B9yw4R+jjL7LueWEFyh9J9KsoMiq3OX1m8GzSqL4ZeZgMMD6/cNr5JHd+z49ONl2m
	 gU9uJ0JbDDz5IG41bwH7pYlHTdUJFR11iUVgX637KJDa4Htt0W/vaY1Sg24uZPqep/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=LJ6edNlw;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F7606A31E;
	Wed, 25 Nov 2026 08:41:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF2F7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=LJ6edNlw
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AP6Z9Xk3110189;
	Wed, 25 Nov 2026 08:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hx7ymV6DGgPv0bkBA/qbo0lNZwLbD2t54Q3ph2aro
	10=; b=LJ6edNlwjbFmSJzvOO3DWfhEg22tczIWEML+D/6/m7lRkrNsAOPdDI5IH
	OUH7dJdG9WmetF6u2ZP5qD6BSeMhFRiVNTPji0InZSOTpGEO7hBdVDLd9DnLjTCP
	MAKuiMpBnU6NOezG69n4opW/QBZn5cmWQVKoWw28jKUZoqQ+hXh3uHCb4afO3FqP
	fKOzQKnFamT/lZn4KaBgb4HJld981cxEt4gi24gfxEYBQej+pDVT3RHqzxwebX12
	L1/gnQkMgVk8s8W5l1FpkIBtPgnLwSdRGMeEuvfXWGGbfPxG6V+lN2YQ9G8xPD0A
	HbH+tx6R2UPLs8q0bjN1/8IyBuDOQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3bhye-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 08:41:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AP6JJZv1781392;
	Wed, 25 Nov 2026 08:40:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5a413d5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 08:40:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AP8euuK51118564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 08:40:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F06320040;
	Wed, 25 Nov 2026 08:40:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 139D62004E;
	Wed, 25 Nov 2026 08:40:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 25 Nov 2026 08:40:56 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 56341)
	id C706C1616BB; Wed, 25 Nov 2026 09:40:55 +0100 (CET)
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
To: linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-kernel@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>
Subject: [PATCH rdma-next] RDMA/mlx5: Read the CQ consumer index under cq->lock when arming
Date: Wed, 25 Nov 2026 09:40:54 +0100
Message-ID: <20261125084054.1349677-1-mjambigi@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b069f1c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=K1o--kdIHIAxDJrx0LIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDAzNCBTYWx0ZWRfXyZlSfZ8ethD1
 BwL6Nr2siTV/wVhzZ7FwkcowqYprXrrH3af9jP2P2VYemE9i1MJcCcUpfXyiktiZltxD/JPInui
 B+IkcBh9wxUxBuX/kxU9crriQY5RNdI=
X-Proofpoint-ORIG-GUID: Kn9IVE_Z-ORCcl3dUcnKeDd1YDOlQQ_j
X-Proofpoint-GUID: Kn9IVE_Z-ORCcl3dUcnKeDd1YDOlQQ_j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDAzNCBTYWx0ZWRfX5KfCi6mVq7eN
 aaJiczE+tTW4moytn8+iGfojwaWEN1sIGB7u40tX/qoyCED4bxPBAGVZzACuZlgib6+ePH8L6Yu
 pNd0qvvMRoaSToa5DasWySfb0bt6OUvk2RErlvamlfiSOSghk0PKECqVXUazpxCLU4wVbgsOlHC
 ouQTxvzt9NI2pJ1EDT/sRh1tiulptRcCJ+Iy9agXqwcyhB3x6CeGUZVsgc3naCDfl/VgkV1IEYV
 aJOPhLId3hP4/wbtRYJc84xpOtWEBp9N3ZtXII0N00VAvnpAdHQcbL9NtuCSLvPZ6s4NifMClGw
 S+pyLaDsipyr2RmXljdP6sbHwQSP9JjTI/cfo7rb+pzLimg2ZnBGWbl+Nn3tIdQFs2idAXokBZa
 A9C1mt/P/WTgH1p4btVhqvtJEXxGfuUNlHwFOfJuf4GWHiYzHOBYWd00Gyp0YUaB2g2byPqIx1/
 kizE5vQGIeaeGmJwAbg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_02,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250034

mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
the poll path advances the index under that lock. A ULP that arms the CQ
from process context while the completion tasklet polls races on the
index, as SMC-R does from smc_wr_tx_send():

    BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / mlx5_poll_one
    [mlx5_ib]

Read the index under cq->lock, which every writer of it already holds,
so the doorbell is programmed with a consistent value. A stale index can
only cause a spurious completion event, never a lost one.

Fixes: ce0f75093282 ("net/mlx5_core: Modify arm CQ in preparation for upc=
oming Ethernet driver")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
---
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

 	spin_lock_irqsave(&cq->lock, irq_flags);
@@ -659,12 +660,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_n=
otify_flags flags)

 	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
 		ret =3D 1;
+	/* The poll path advances cons_index under cq->lock; take the
+	 * snapshot here so the doorbell sees a consistent index.
+	 */
+	cons_index =3D cq->mcq.cons_index;
 	spin_unlock_irqrestore(&cq->lock, irq_flags);

 	mlx5_cq_arm(&cq->mcq,
 		    (flags & IB_CQ_SOLICITED_MASK) =3D=3D IB_CQ_SOLICITED ?
 		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
-		    uar_page, to_mcq(ibcq)->mcq.cons_index);
+		    uar_page, cons_index);

 	return ret;
 }
--
2.39.2

