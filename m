Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C8C3D1713;
	Thu,  6 Aug 2026 12:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786017900; cv=none; b=gjS3f9+71YDYGrwEvXQ9Tk6lLco6pmIVcFyRWnxLHiAgDtjC3oEktoWXO37pgrjt+dQCQoBv82/tHtc3bKMfP61HiEGnPVC8U2FACxEqZuH8mwY6dwMjhXTXAYM0/8yoznqcD983jU3b85plF4SA5UGW/uSWASHYDw8OthBN+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786017900; c=relaxed/simple;
	bh=hInYNNR2MRbgIBwO8UgEjL13c2n784AGLihERLLViFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sHET5fMA+n4MIEioNXNdkp00qlrpfxN1Keeh+Y3kRbNPhDlFk2q3VrE5L3HqUXrfdmVUnSnduI0UIicOzbsRyr8DFXVVwDA504cE/XkGcYSkHXVC9w+DKOiIQ5+02Kbl7dPW/ow2Mo9LLHO3F7be3Ikd5HEyU52tmxUZt+R0cf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fsR7Nm3l; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fsR7Nm3l"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Nn0J91094475;
	Thu, 6 Aug 2026 12:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=jUArO4QTBrXtvlWICDou+TBrUpW/gYP9mZLGidHsx
	0A=; b=fsR7Nm3lSd4gyJJ3AkbJEQP/Uo7bqRV+3VAhVJLyqn5c9qh8S7piuktGS
	QDe7UQgekSlFMKxVnmQVpSkuqfAV3bhG5MsMyrHksu7EbkqebdFdJIzORWZcF/wG
	eOdLnZCSvZgDFiq+RfUzqastCoKIBlC261ZWZC94nCaL3IinFa7KZMKpIopCFWiF
	zLWnrqZbLVjulOmCg2YQt4jSzIL3cw6dVIURPXp/n9gTfc0zz0afDyo5jTjDfHJY
	AtXseayOU8X5aku7pvciAVXPwoQg0nwfvlITi2VqC3f96SdI3fK+Z5LXf6tX67MZ
	hBqBZY+EFfTf3W5Pof/IimXp7u8RA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h581r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 12:04:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 676BuJNc028048;
	Thu, 6 Aug 2026 12:04:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qu6d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 12:04:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 676C4mWD45154612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 12:04:48 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 542BC20043;
	Thu,  6 Aug 2026 12:04:48 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAC2A2004D;
	Thu,  6 Aug 2026 12:04:47 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 12:04:47 +0000 (GMT)
From: Hidayath Khan <hidayath@linux.ibm.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wintera@linux.ibm.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com
Cc: mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        horms@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] dibs: fix double free of dmb_clientid_arr
Date: Thu,  6 Aug 2026 14:04:47 +0200
Message-ID: <20260806120447.596164-1-hidayath@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5MyBTYWx0ZWRfX+u2dxN+GqGrH
 lh9PTCKo2/25Gq6I2ahWZ8NU5lAGPmVjauFVVsnwKEgx707cxlq0YVxOnoLZ7zCSJyM4klARV7K
 IVgqiytW67dwdJW3zwk04XF6lO6cyrY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5MyBTYWx0ZWRfX70B/0rCFRlE3
 a4CNFhjbVA791xXC5lh3KEbRzTGWsUNUpH6CSeu/ZAy9kWNakdJnJzn/tgO622KRegNf75f23XZ
 dzVwuSn8Hs3TFHsRTsFctXiWU3PsbM1KrkRBBwgCgR4OzPZcElsk1bmX+lA/mroGAUPffV6fkVe
 TxvqxpwbTTEpSRUv3W3m/NaPknm1omjx5hhZMahifhDsPU0VEaMJR0xL67m7ZSmJcyKbPOFVsKx
 9N6GAMwZ4wxDkrmErKGAA5HrIgMTNoEtdIB2EEqCdQZYwHdkAL6yKo+b2qVQ6v9QTrh9ud9YbAl
 UvKB0ZNNjZLi3w9XvXdVEHtzT3Q9OMD3ci6HW9oX23WzWSpPh6l2bUqEZM+2OxI3CW3axqnA/gp
 pXUJDuQJo35mgYGIZz8dNcu8VZi170j+NwLoyWyruWMrd873VAoBotUqFL1XEj4FhOLSareS7Rb
 Dhi26NWMQdHFgl0SEmA==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a747865 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=m-JuoJLILF45OwHNZkAA:9
X-Proofpoint-ORIG-GUID: BBTrFJBgqV3Z7q7frO-uUA_3DTbA-81s
X-Proofpoint-GUID: Tqso5xCSkUji-Aa9hUD9NM_KbzqRl8Ca
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060093

dibs_dev_add() frees dibs->dmb_clientid_arr on both of its failure
paths, but does not clear the pointer. dibs_lo_dev_probe() then frees
the same pointer again in its err_reg path, so a failing device_add()
or sysfs_create_group() results in a double free.

Drop the kfree() from dibs_lo_dev_probe().

Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
v2:
- Fix Fixes: tag (was c3a910f2380f, should be cc21191b584c)
- Remove incorrect Note paragraph copied from a different patch

 drivers/dibs/dibs_loopback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dibs/dibs_loopback.c b/drivers/dibs/dibs_loopback.c
index fd5caf1e19a8..649e4e375be3 100644
--- a/drivers/dibs/dibs_loopback.c
+++ b/drivers/dibs/dibs_loopback.c
@@ -335,7 +335,6 @@ static int dibs_lo_dev_probe(void)
 	return 0;
 
 err_reg:
-	kfree(dibs->dmb_clientid_arr);
 	/* pairs with dibs_dev_alloc() */
 	put_device(&dibs->dev);
 	kfree(ldev);

base-commit: 92a09f2af870e91efb9471b109db15c2030f90f2
-- 
2.52.0

