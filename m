Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC437F001;
	Mon, 28 Sep 2026 05:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790575031; cv=none; b=MPr/CzblTlByHd0RzwAYAIsPyEqhM6hiXcUBGnns9wexALqnWt4A6GzwoliYk31c/+TQOY7RKo7fMh20/pzDQ81p+BLhyHgLL0w1bRGIW+27L7GKte7p56Zo2+47mFKdtd72HJFyJT7Ckx9bIHKaEL1Yf4qiEunSe+OF9AT+Huc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790575031; c=relaxed/simple;
	bh=VaBdn5/4eyku5eCM/H9gAe8dnrP6K3AE3mbV+4KKGhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p7MsexERDLDsbBAarKabw/Ix8JkaOi74fqzI7NnO3y/Oz8hO1XyLhdrNLkRRF+7p2skt0PzKWdp1a66BbefHexipm2NPM/Qk+5Kaz2Dk8qbETJrnkwewS5yxI37f/JqUuQfyrVYVa6gcwFFomHvEPSlWQRYlCfUinN1sWNApLYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b1eyqxOS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b1eyqxOS"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68RLdmJm986650;
	Mon, 28 Sep 2026 05:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5C46zn
	l+fz3Fcmow214k3Bma9CDzZe8ZuUM1fvjbxHk=; b=b1eyqxOSsbrkpH7eXu6vuq
	jwgNGMYPt06VkiiTIHgZFhA8BIZchX6ISxpMIWGlveOL1mqjtrgYCZ8dz7mCj20X
	Cy1Pq5LSpynrvbgRfSih21NxIzakvH8uSRQNu0u/EZfrxCSnWq/hPrVefiepOVl1
	euNw8JA6OHxiuu2g7qbBBiwmIvzbYjKmRNamZkQwCL4CFxhFSgXmtKP6NYrUGH20
	/++UQHDXY4XIBk3b2yRxyk+QEinLcMNPQwC6aCu9p0Snjt3AackPt99aLxEmSjQG
	wbI+/pFXQmrA9asmzX5r7Z0+NpEZioJSvoS/b9MvaeQ+jXU28YKKl9gXXxfY56RA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5psy7m4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 05:57:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68S3Wcwl2070653;
	Mon, 28 Sep 2026 05:57:00 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsck3vfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 05:57:00 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68S5uxiW56099316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 05:56:59 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5619C58052;
	Mon, 28 Sep 2026 05:56:59 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC3BD58056;
	Mon, 28 Sep 2026 05:56:52 +0000 (GMT)
Received: from [9.39.20.37] (unknown [9.39.20.37])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 05:56:52 +0000 (GMT)
Message-ID: <7960d73e-e316-4853-8398-144742e866d3@linux.ibm.com>
Date: Mon, 28 Sep 2026 11:26:50 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: serialize sndbuf descriptor release with
 diagnostic dumps
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
        "D. Wythe"
 <alibuda@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Tony Lu
 <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260927073203.3694279-1-nicoyip.dev@gmail.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260927073203.3694279-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: j5QSBf6hnu4gFjl0DmN0HbIBEwuT2KN9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDAyMiBTYWx0ZWRfXz7pw0chf3PJZ
 Mb99ouu4dBk2tDRMmi9MF8HiCAe5+NXAfAoEcJaDulLiX3aQxEIdA32BMjDQTQ8eeJUc+BqGj9j
 btjhUdtRRlSNLk8rliRmghheTOAF/r8Oc11fgk9CBCJYQjjGyoZI+Npa5++bty9MS4T/LHrlDBf
 NSzD5iZHHX31zMFe/xR44r2N/0NvpDNoR1+ohdrneAv9AtXF/yD4lXIt6rgY+oivJMT9SpKaMbc
 bt2Vr/zBXaUQgNTq4nbLWp/QcBm3SNjOMfVxqDadO3U+P+JMiNHarflvh5FntOIEC5QZtmtWGME
 P/AOIlYZiGKJEIOfrJRmGMNCLldLofZmZUECYpfLgmhiGOqQjBLIqcylCzcf2oDjqtHf7kJdbiY
 98AWXbl4xxlgNOpN0Imh2lpSp8dydaPEWMrq7pA0sLUQJ1OrellCOVDyfOGpn6HeRwhx0O4RNrL
 cEmiWc0inUUrMjI1pFA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDAyMiBTYWx0ZWRfX3Dd8pCY31Kc9
 jXPmu8eyGc3u+ySkiQUHF2lIaIQjOfsMpCk1yHGCRngGm5/4c0Ejxer70523pZz/pQNgfAMn8d4
 nHY5CqgbPTSPmpF5UEqwqkkQyylLaOU=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6aba01ad cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=B3kcKS1toMKKngqSjDsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 2dlgop4EcxiqUDLEkERlk-6rUzB4D3N_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280022



On 27/09/26 1:02 pm, Chengfeng Ye wrote:
> An SMC-D connection can remain in the socket hash while smc_conn_kill()
> tears it down. For devices supporting DMB nocopy, smcd_buf_detach() frees
> the send buffer descriptor without taking the hash lock held by the
> diagnostic reader.
> 
> __smc_diag_dump() can load a non-NULL conn->sndbuf_desc, then a concurrent
> smc_conn_kill() can clear the pointer and free the descriptor before the
> dump reads its len field. The socket lock held by the teardown path does
> not exclude the dump, and clearing the pointer before freeing it does
> not protect a reader that has already loaded it.

Agreed. This is addressed in v6[1] by unhashing the socket at the top of
smc_conn_kill(), before smcd_buf_detach() runs, so no hashed socket can
have its sndbuf_desc freed under a concurrent diag reader.

[1]
https://lore.kernel.org/netdev/20260926065023.1629497-1-mjambigi@linux.ibm.com/


