Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B19047988D;
	Thu,  6 Aug 2026 12:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786017618; cv=none; b=MJfFY5ins/fZxu80z7FEk6VuiWSX1FSgqpJ69vF2ropZHuS0DUIfAyUTL4lvDa962CDPLcOvVQS4NpBX5vVkFxfGcHe9epvq1HPC4JegW1WlgoZts5tkMvD3bKuksMLOpFHpMBMrN+aZ3R8/eqTstMBMuVSM0lOYKwtfr3mi4Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786017618; c=relaxed/simple;
	bh=hInYNNR2MRbgIBwO8UgEjL13c2n784AGLihERLLViFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ5M7UboNGxK9Qnm1PzicSYGyBe3ZcHugm62BSifaJIdDKgcK0mokBZTFrFZ1KaVPfxZfR1EGYG9611Hz79aFgvLaFvJVTAx2xVpywGPg8094L09J4GUakuN0WF0BCZy41L/XJ2yT2LpsIxLJjCEN8LpW6aq1Ie+XfughZcPHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=riCL8MLk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="riCL8MLk"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Nlh743403131;
	Thu, 6 Aug 2026 12:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jUArO4QTBrXtvlWIC
	Dou+TBrUpW/gYP9mZLGidHsx0A=; b=riCL8MLkhm6SplQiPSznT/LeaibuYws8o
	ItSXE2RBbQTPKsu88JnmvsUI/gd4anoBZRtHcnoPGMBI07qXeksfWV5KFd7S7hEH
	9YcmEroMHMoDdCWJK7l6qQjHpkFgdkvxL2ZadbMR1THo7dIVqIFXWNr5L0oli++y
	ceaYzB8ezkIzwGNx0NmI0Qqs7zG71OucnKUuUfFOs6bGiRqk9xdnZ3fmvfi3qKje
	3/klydGSU4JKFzFFuf/iMKuLp5atiBfMns5d3Y/BSW6UrZaLQIbJzMgMRb3f30ZO
	4tBlPlS491GZO1hokaH8Q/HrDjq0yamLRhYp1Gc7iXGfxBog2Oesw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqywju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 12:00:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 676BuFiX018410;
	Thu, 6 Aug 2026 12:00:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhjy11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 12:00:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 676C03W526280512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 12:00:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9C7220040;
	Thu,  6 Aug 2026 12:00:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A7F620043;
	Thu,  6 Aug 2026 12:00:02 +0000 (GMT)
Received: from t83lp68.lnxne.boe (unknown [9.87.84.240])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 12:00:02 +0000 (GMT)
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
Date: Thu,  6 Aug 2026 14:00:02 +0200
Message-ID: <20260806120002.596137-1-hidayath@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260730075624.114778-1-hidayath@linux.ibm.com>
References: <20260730075624.114778-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: pqoH-itni5OcseswM1F3gWNq3TDFBURt
X-Proofpoint-ORIG-GUID: TZwEANI92nwd72fQtCss1DPNh-ZZwuHm
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5MyBTYWx0ZWRfX7H03ZeYUA+o8
 gfK7K9GykaX07gQzDgSwOeIr1wMoXcQj6IxGdnIbvEZiI8qTpWuihjJ1K43jX0/u90GiETnaiyL
 inPQDcKtg7nlCJnvAQE1VHUJkhSL2DA=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a747749 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=m-JuoJLILF45OwHNZkAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5MyBTYWx0ZWRfX86PY8FylysNd
 lpPlKuMdIsgOWvQk7h2ZGOixK0rotC8CD5HtPAzVaFYlfVUFVeUBWKfRQJbbmEgyuzvVOjFe117
 9FrP3Y2qsVbXF+sDR3guLwxm7aJRundEqsEoVDU8f5Acuz9hrdaR8beFgY/BUYbfO4DnIlgd/EB
 HINUdoLBfRKFExPN400pEe2tXJQuy7oHJ7z0MIl6j1XTZdOzF3YfGcLUFaVMi6V4XM0iq1F0ncr
 eHk62H4HOh4HGitg9Wp3KV/71IuBAnoVV66+GXc3V9eDdS3qrOH+R/JibPtasQLRPZQJe/vPBM+
 CCusNrty3aQCpzpUu6KSaZt1FPkE9bhCAFKnoSojtXPVSTUaRy41ujbXez7io9dOH4nyaczQ5qv
 TiFSQInLqFNftXsNFA9BMmMdsgJs9dFAQZqqW3avzgQvBH7pABnnIapC98DFxU2HMyODoi/pY3D
 yX3hNhSr8hRFbUxkc8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060093

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

