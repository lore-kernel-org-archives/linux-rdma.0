Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2744428461;
	Thu, 30 Jul 2026 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415363; cv=none; b=CsNNUjXhyz4TkvaLY2HAN5e9wIcQ2TCyCw6LLvWhvZUSR0CIhIMZLhLi9nFTY8uB/m5VHDJUCixgUZ/DdgKbcvG4RKa1YdocMxSLiath5fAiBD4u/p8ODvAgFaD3R9TwEKIWUqCH8ht+NIUggv5lTJqojHg5UUWOIyenUcihJyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415363; c=relaxed/simple;
	bh=djzoND6+I9bMLJT6Ve+hVfa211MF+DaRgfvQC0m5HbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rszYuqDxXWdidJnnNoRGFWjG11yL3MHQXnYL1RfzSjAQu/P1HZt1g6/ZCrGP9TJFg8h/tNboaCjVsqqd530af3dLcvohXkjv8RhyqYpRd0RgN4XFyZ5EUQmwiuWb1qowtZBgs8d/zyZGYo5ipmgef9ts6362jZXn5+S/LasYCQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aObKH4rw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aObKH4rw"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UAHhew2709036;
	Thu, 30 Jul 2026 12:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Neh5A43Vld1XWH3gCiCLoKz8u1yOTqDmC2j7K6d01
	kw=; b=aObKH4rwYDAdl4BpxO9vlmPEEu9JF1ljV23hdo8NwBVnyjh3ysq2MQAM1
	YHVmUmUP5HaKzr55X7OhTgL0x+1gp6Hqr0VVNDhza1iJ0GVvw3z1FM5MdnZaIVfy
	SppT58PmQFD1v1nHVr+mwuhuKLpSCufI4O592+mcJsbQw2NtmCojdJcODHWqK2tC
	/peri/nm3AiZTGN9ntqwMSOZeT+lDsKNt2TDLO2x3ugHiPVSBPhaL2VyrDPCyQ5/
	776aXzJrZJVGRFiFM9kHhM8BbZMAdXH5pnrFduy/lkxW41wGBWxviT8in5CSUegL
	os5ofNUhxZoHjXLdglsOPv7KEF0Ew==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7qqe9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 12:42:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UCfNF8031790;
	Thu, 30 Jul 2026 12:42:32 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhk81c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 12:42:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UCgRkq47972830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 12:42:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D60D820049;
	Thu, 30 Jul 2026 12:42:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C49F20040;
	Thu, 30 Jul 2026 12:42:27 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 12:42:27 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wintera@linux.ibm.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com
Cc: mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        horms@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        hidayath@linux.ibm.com
Subject: [PATCH net] dibs: initialise dibs->lock in dibs_dev_alloc()
Date: Thu, 30 Jul 2026 14:42:27 +0200
Message-ID: <20260730124227.167829-1-hidayath@linux.ibm.com>
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
X-Proofpoint-GUID: kufcna7hGJkClU4YDK8ygFbZJyayLZO_
X-Proofpoint-ORIG-GUID: KQ4F-bSYKGmQSNGBhfhDMCd_6j-8TMkx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA5MyBTYWx0ZWRfXzo3b05l3Ghw7
 Mn9ivJ17xHJ2eIXOUpyqpctgbSidKzEvWNqFXY+mdVoq96g8u3QCowmqCKUl6YVHAcr9GwHtOEO
 WGGHA7V+USchJrvD8XCGUsQoMBB6oIl2DlYfMxFNcvX+GWPD6DKAxv/txJC1G8yiQ/glvT+WxpN
 0rTh9vMy8iOIqP57WPjcVAKERn6elY48saJ1ybh0JbTm8NA9lxqL8iV8I90Cxe/ItIXn0GVAgPd
 aJwuf9NMBySPx/b7d6ty/miXBM6M8UugS0MSAlaR9LZoB+/jM13ppmnXU0JuOeXtN6/ja13fz4D
 Anfq/m29Vz4oveuzR9dF9XDkhn/SmgUKmtq38qf6FhoIqFvi/naD+rcKItnt+OgP9GAgkiODzDF
 39qp+HoMt4MifLCc8DpHNAHpFWDPpX1bMtjwg/T+R/U4Bx5kM4OQQ1XYGcSs86BxVYsD+lraJJx
 r40LzyZtrIxioxcvoSg==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6b46b9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=RQjwLAIJwXB5NLIMB7kA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA5MyBTYWx0ZWRfX2GUs+aH2u5CE
 jFrZXxnXp2VuDvdRiO9Qggb/vyz2WzzSGn2KJFjKq/F+6/04I/HxMGb8cVq7V3R6sHwoACZ0l8P
 BulpKdYs5qSh3tyvOpfnW7sLFKplFCc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_03,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300093

dibs->lock is initialised by dibs_dev_add(), but a dibs device can
already take interrupts before that call: ism_probe() runs
ism_dev_init(), and hence request_irq(), before it calls
dibs_dev_add(). No client can have registered a dmb at that point, so
no dmb interrupt can occur, but a GID event interrupt can, and
ism_handle_irq() takes dibs->lock unconditionally on entry, before it
inspects anything else.

Initialise the lock in dibs_dev_alloc() instead, so that it is valid as
soon as a driver can publish the device to its interrupt handler.

Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
 drivers/dibs/dibs_main.c | 2 +-
 include/linux/dibs.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dibs/dibs_main.c b/drivers/dibs/dibs_main.c
index 14c3e2d84902..4c26fd06973f 100644
--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -138,6 +138,7 @@ struct dibs_dev *dibs_dev_alloc(void)
 	dibs = kzalloc_obj(*dibs);
 	if (!dibs)
 		return dibs;
+	spin_lock_init(&dibs->lock);
 	dibs->dev.release = dibs_dev_release;
 	dibs->dev.class = &dibs_class;
 	device_initialize(&dibs->dev);
@@ -186,7 +187,6 @@ int dibs_dev_add(struct dibs_dev *dibs)
 	int i, ret;
 
 	max_dmbs = dibs->ops->max_dmbs();
-	spin_lock_init(&dibs->lock);
 	dibs->dmb_clientid_arr = kzalloc(max_dmbs, GFP_KERNEL);
 	if (!dibs->dmb_clientid_arr)
 		return -ENOMEM;
diff --git a/include/linux/dibs.h b/include/linux/dibs.h
index c75607f8a5cf..d3e0777f25ae 100644
--- a/include/linux/dibs.h
+++ b/include/linux/dibs.h
@@ -439,7 +439,7 @@ static inline void *dibs_get_priv(struct dibs_dev *dev,
 /**
  * dibs_dev_alloc() - allocate and reference device structure
  *
- * The following fields will be valid upon successful return: dev
+ * The following fields will be valid upon successful return: dev, lock
  * NOTE: Use put_device(dibs_get_dev(@dibs)) to give up your reference instead
  * of freeing @dibs @dev directly once you have successfully called this
  * function.

base-commit: 10019318fb9fd64fda6ed43f9b34d0c9077d5802
-- 
2.52.0

