Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB49388E7A;
	Thu, 30 Jul 2026 07:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398202; cv=none; b=qrYE/ckLUmyQo3LxtfloD/lnKPDBnCT6zg7zAHVq0IT0LY7+Rsiivxk9WeTih1e8eIrOMmTU2F+f6FIaNvD7SgSeVRah7VSb+J5qaeq8gcQBDgYcXXjSsDFMl32FclqgaXf6rkWvu8hLIPAssIK2yZRrzFO3CtcAbHB3BTtDoLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398202; c=relaxed/simple;
	bh=lfCd83wlnK2yYwxnTrJj6bXjEBCsKfR1al4IeWNcH28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l75TWbCB75AWeww0nPKIOJnvEbMHwbowZ4gzlE8IB87xkgk5/FUexER7oWdVqiVw6yL6SeKVpPYXeGhkIi3opq0kucDoAvvCf1x0utbaZDbehaf5VAB9ucQbmLqGEEku5xFolMYw6S7NgIyLlHRvohxSaeS8RPaCm2D3ExzqVHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mAx8AFz0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mAx8AFz0"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6ll192193257;
	Thu, 30 Jul 2026 07:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=i5Foh+HxRSdT7/xEiUWmClXolFVnL3jAUjnokCpK5
	eU=; b=mAx8AFz0scb27SKUDoAQW6a5Yk+CctCQshbLRZkxzxECGG25wV6gzjgFb
	xZI58ijL30VSJAAC3tqH255A69TapwXOmygznSL79nyNraMY/FqgVmDk5ozmG5Vx
	qiP6Q5aIaPywL8I3OSzV7t3L54Lp4pVg4PJVzm32ciHP7afVuX9xASD9TyOQAliQ
	n2PJkw/QnviInABiFpOimckD7Yhn0wNg1rtHL6QCucah2VTwHQjSchRC5syyaCIB
	vVlNdf7Fp7xArfYwvKlbMJGT9IPef/iSm1YKIxhYeySOZLSi8FTeFwSjaoEgbKfL
	dUo8Hg8QS7TUdwuKBJusxzcDJl1yg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjdtcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 07:56:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U7uQOB021168;
	Thu, 30 Jul 2026 07:56:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwagd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 07:56:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U7uOtC33620258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 07:56:24 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBB232004E;
	Thu, 30 Jul 2026 07:56:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 621712004B;
	Thu, 30 Jul 2026 07:56:24 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 07:56:24 +0000 (GMT)
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
Subject: [PATCH net] dibs: fix double free of dmb_clientid_arr
Date: Thu, 30 Jul 2026 09:56:24 +0200
Message-ID: <20260730075624.114778-1-hidayath@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA1NSBTYWx0ZWRfXwavfkeF4/Kt6
 JoOxs/lXNV6ejkeSz1wRu5cOxKjFHpgXqn9EAInIQP5m82MxQBZUhhAx5yxSuKl+3ZwU+b2yM9z
 PbvmGmEyCXzmRM3SHEW1J4GHcJVXYg0=
X-Proofpoint-GUID: Qknss0pyhU9cLSpgH2kGICeVnBYw5r1C
X-Proofpoint-ORIG-GUID: eu5Yn7kJEpYarRcB3EoH6X1j_meabnsC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA1NSBTYWx0ZWRfXy6i7XPPWhEC7
 Eo6LIkLVau9jMO9pmu0RBXpcx1FmyRZ6mZmq5mxkpzCmh5ifUuE0xkCIyaEA6Ofozrv1bsXQJ73
 vm2hXSmPLJU3u/lXlIyOCtdeLac80M3WlwfFKVH7pNXep71+x4TvxGfnCAgjyRWzdC6K+ApzFOl
 eybYCmjZYnueOJBx8+ypwcs9JZ0G9l/R71Smr0aerNYpYmVRGdBY0rwYBqdeIeCzjzwvGh21J3Y
 d7fduZ4jtjfqrxdQb9NofP1ptMYAtI4fWlIQxzDGae4E6H4l7PVEoMRyyzCTjV6DLyiCag61diS
 moBsSqzV80ZQbjOzyhv2F3kJ2bTIFsJL0ZmN4agGYD3rX7KKBTtgsOlwvJqXD6X1PGZTvNWxYE7
 stDtwRkwMXTI0q9rMgM858Fj0C53ORx72b22x0p+oNkUp9627JQW/DSVnedS4Dm4OIr72CU7r+F
 2qrRZd9bwWBX9fqruCg==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6b03ae cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=NnsqlADyzmQ-ARdX89kA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300055

dibs_dev_add() frees dibs->dmb_clientid_arr on both of its failure
paths, but does not clear the pointer. dibs_lo_dev_probe() then frees
the same pointer again in its err_reg path, so a failing device_add()
or sysfs_create_group() results in a double free.

Drop the kfree() from dibs_lo_dev_probe().

Note: commit cc21191b584c ("dibs: Move data path to dibs layer") moved
the code to its current location; the race was introduced earlier by
commit c3a910f2380f ("net/smc: implement DMB-merged operations of
loopback-ism").

Fixes: c3a910f2380f ("net/smc: implement DMB-merged operations of loopback-ism")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
---
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

base-commit: 98379cf6109c0adb5879f86ba3efd4afe389a64a
prerequisite-patch-id: da145e40ff1ce22e9701dd49676606f612c03872
-- 
2.52.0

