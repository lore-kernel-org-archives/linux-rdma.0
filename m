Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.165.32
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599421;
	b=fK3d53hMD04PCrxlSa4U7thjSBcUGIfJESXYTVHoZEfjNQzyOUgZuSl6KA/gONRBBLrx
	 bmJNP3wRA3KtsHKZEv0L1/lhSiZuPqMgcH9w6m4GAqXO4bskpnvKjUFqt9i23t5zaKaDJ
	 B5RFoV4p1qFpcWLR1tFyf7LasG5uDv96q0ohSighNnQGVc4eiLqH6zs3NmnTRTSYHQ0Me
	 7KfQA9gM+3Hz7O4okXROnSwz3qnx36opT/lTx6fackdtLl2ePY8l9twpEKNdCL8BlGcVY
	 YgEM8imfNk3GlcU2gTYDCJVbY6r7qAPWGJjoWL96U+8mAfvDNiR8VfF/Nmffb5hVPuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599421;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Reinject:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID;
	bh=ZgPm3j48OhkmU0/nOyw0pk18bjZECBcGo+qJzz6e7t4=;
	b=s+ElR2G4+AJAGMkAys95fkG5DLus+ckrR/nXyyDZBtyR19gLBkcd7fQpjemqJOfAkyrY
	 IoHQeTZjQp3AoeWK3cBT3duO1GGMDKXoi4s4X9c+Nt/5yQWTlYnKltiQifl3GWolLicNv
	 9nDgc7ZzY9Nf7uRhWzpm68mjwBqBi1cdpIf5etdpuaKGJh1xiaz6zqhk4idB6waS+JMPl
	 P7DczJMS3MdvGWFPMmxOCu0obs+gVZB2UaVQXF59V6zYe/IH6QDrNQV+KRfwPamWP1uSm
	 +WVMpvOvaTqw928ttyZKx7Js6BpOZKGSy7Qegs+2lAutvoTA0Xqs33VhrMNqH/8a8zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=mA17eidJ;
	arc=none smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995A6606BF24;
	Wed, 21 Oct 2026 16:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 995A6606BF24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=mA17eidJ
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LDNh9n3856767;
	Wed, 21 Oct 2026 16:16:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=ZgPm3j48OhkmU0/n
	Oyw0pk18bjZECBcGo+qJzz6e7t4=; b=mA17eidJFaH1GaZ3EOjbraIZRCCfqjEe
	ZeSvQ6DnVLzalafbxiC5fOwBQZw457/oAkrYsgd1YMPLV7wG/xkLQhQZqU2XslB4
	7RXe0eZaII5e6JC/UdfGV1jAlMtUuo8dV2bXR2RlVsnTnEe/jFSM51bGj4gG6Gfh
	p/9uT0aTh1ynW0d0YDlgLqzKSzXU5a0IsoXgcwC8nqo2oq91jd+PReZqxQqQu415
	9VbgTwLtt0z+Apz1N8VaUXZLW6+NBQThGgR2bk5TpMbTlPOeaYO52PV4fnI/OWr3
	9jHjNBRAQAilSpAJ4WrGVEotiP/vM6rOtNumxCpESwsjajpf9v4Fdg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hdw4gau8h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 16:16:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFSwUa1109771;
	Wed, 21 Oct 2026 16:16:53 GMT
Received: from lab61.no.oracle.com (lab61.no.oracle.com [10.172.144.82])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4heyqgtfed-1;
	Wed, 21 Oct 2026 16:16:53 +0000 (GMT)
From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>,
        Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Andrew Boyer <andrew.boyer@amd.com>
Cc: stable@vger.kernel.org, Keith Lucas <keith.lucas@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for-next] RDMA/ionic: Fix GSI QP ID release
Date: Wed, 21 Oct 2026 18:16:49 +0200
Message-ID: <20261021161651.4020222-1-haakon.bugge@oracle.com>
X-Mailer: git-send-email 2.43.5
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2610190000 definitions=main-2610210064
X-Authority-Analysis: v=2.4 cv=LPPz05W9 c=1 sm=1 tr=0 ts=6ad8e576 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=sG8J6-wLveFn0xi-oGcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NCBTYWx0ZWRfX3MsJ2goid2Ad
 sZk//upQ8Ih9ar4+/hSvgED1DwUw9z4dWd2XzV09uqNiq+uRjuMIaBsqjjZbuPC66YGgehKCEoY
 3+fypZJiWBgoHq4ugKIowsdv6bqcyE7Dra2NNgW1G9OyFbiYD+eYDz6U/r1E+sV7s7MJ2vtKmBr
 ryt8arfD8gQQWJ8WBOviGxNBQVoaa7WGalQxAks7FVrF1iXREZhf/kqjKcACg5B/MeNdopdobI6
 WUy45RqKuUEtUxfPHx+Wlnd3vN9woktOcwCT4oTEidYNekT1zxFAKvFct07MM8QAvK1pWrE1iIy
 Lq+3h0SThuqRHVXgvmY9TLH6xzuwv02fEefs5VrnpAA3meQhDOS/M0whWXYVzW0t53SlV2kYNly
 OSK1m7I409sZMwOLMdAWE8rZCTXQDycrAuzhlDMmawaO0XW9SOYcckfaFyZkdXcVb5PBqj7qIVI
 5fkkS2tKDRLmKEJWjzk12Dfx/D9dcWQfwkk4uX8Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NCBTYWx0ZWRfX9sKdFjVMMY1H
 CCbgmC9F6UDt5W2DrnPyLSn+hZ2uPFu7kEhfltVC0x7VjcXK8DoPl18uLvRqZN0lr0DwNRGKzNl
 cwD0QahVKQXmSb5SHjnsPdF+eYGoGQDYUi6XLsasRAfB6hOS2qmE
X-Proofpoint-GUID: NcVV2mGxfSVJkl1d9mDU-cDuWqjLoVt2
X-Proofpoint-ORIG-GUID: NcVV2mGxfSVJkl1d9mDU-cDuWqjLoVt2

QPID allocation differs between ordinary QPs and GSI QPs. If GSI QP
creation fails after allocating its QPID, or is destroyed, we see in
the log (trimmed for brevity):

kernel: ida_free called for id=32 which is not allocated.
kernel: WARNING: CPU: 47 PID: 6673 at lib/idr.c:527 ida_free+0xde/0x140
kernel: CPU: 47 UID: 0 PID: 6673 Comm: modprobe Not tainted 6.12.0+ #18
kernel: RIP: 0010:ida_free+0xde/0x140
kernel: Call Trace:
kernel: <TASK>
kernel: ionic_create_qp+0x4f5/0xbe0 [ionic_rdma]
kernel: create_qp+0x19a/0x290 [ib_core]
kernel: ib_create_qp_kernel+0x3a/0xe0 [ib_core]
kernel: create_mad_qp+0x8e/0xd6 [ib_core]
kernel: ib_mad_port_open+0x268/0x3f2 [ib_core]

GSI QPs reserve allocator ID IB_QPT_GSI directly, whereas ordinary QPs
encode the allocated ID in the QPID. Calling ionic_put_qpid() for a
GSI QP incorrectly applies the ordinary QPID conversion and releases
an unallocated ID.

Release IB_QPT_GSI directly in both the creation error path and the
destruction path.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Cc: <stable@vger.kernel.org>
Reported-by: Keith Lucas <keith.lucas@oracle.com>
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Tested-by: Keith Lucas <keith.lucas@oracle.com>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index a70ef59a8064e..cd623f1de38a3 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2450,7 +2450,11 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 err_ahid:
 	kfree(qp->hdr);
 err_ah_alloc:
-	ionic_put_qpid(dev, qp->qpid);
+	if (attr->qp_type == IB_QPT_GSI)
+		ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI);
+	else
+		ionic_put_qpid(dev, qp->qpid);
+
 	return rc;
 }
 
@@ -2762,7 +2766,10 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		ionic_put_ahid(dev, qp->ahid);
 		kfree(qp->hdr);
 	}
-	ionic_put_qpid(dev, qp->qpid);
+	if (qp->qpid == IB_QPT_GSI)
+		ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI);
+	else
+		ionic_put_qpid(dev, qp->qpid);
 
 	return 0;
 }
-- 
2.43.5

