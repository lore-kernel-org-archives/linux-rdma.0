Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7C377A8F;
	Thu, 15 Oct 2026 08:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052506; cv=none; b=e9bx1bD3KtMz9BVpF6LvBsy0dlUqDXKiLcWhcHCawG5KW2GP2XAB9S9yqmxSTu83cFsn6njSEtGXRF1WmanVibPV4VGDlACzfCgLJjKKRjJorEGyEK9nBiCcS/GSwxZPrgmoFaIxGaYchaFVfXwY6su6jnVXI7xFGjnkYtHWnAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052506; c=relaxed/simple;
	bh=tEAhPltH6kaujt+czroww60W5f2aCWpfDimppARNwaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9voME+mopf3uaLbxqILZxyX2rACqxEZ2Y5qc4qjsSeUoFO1npQzjJ0CxtrNSTsJPBJ5tSgzuXnU4r26HZFKAnLfYPWLm/Q4n159YcfvlboulOX78ckTpHJA0JjzmAhQ07sDMgcTUoNrLaM+M/zA6wX7KFuXYiGC0cQ8Bb1Q1yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HKRhooZ5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HKRhooZ5"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F3WCc02426472;
	Thu, 15 Oct 2026 08:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/ByL6I
	4DKQyfLUGtnxHltRSsPBvMP9rx2vgcCYvjVWA=; b=HKRhooZ5w46mM/JSdH4PhL
	u4HRzcvgJNHaSd6Z20MWbItHIXsTX82ZgMC0uwtAmHStmn/bWtGSbVGCc2Juy/Cy
	2Xs2a4RzwTGp63Om7oZ+zMoJH1p5y4TB0WJ3XuQbNmIt+azfj5w6uLejjc1B2xjv
	0yNQWWjaYbR+A4vFeF79sY3sva1MfLLnMo5Wgl9YBm4WBsc5e4YpBvLyUh/Q2fAp
	nHkqjfZexjwfX682/fiXAkvF8i2G+vPIMLuWlFdhyLQDJNvbMyR3P5ZA3DPl56Qf
	4zThvl4/aOP9o1+WaS4AICGpPBSuzCF8JEn5oa+xt63HNnAHrBxYbAqdUI74KTEQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dv3rvf5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 08:21:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69F528nx702814;
	Thu, 15 Oct 2026 08:21:37 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h816hb3yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 08:21:37 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69F8LaFo21365502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 08:21:36 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3138B58056;
	Thu, 15 Oct 2026 08:21:36 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 692055803F;
	Thu, 15 Oct 2026 08:21:29 +0000 (GMT)
Received: from [9.123.14.182] (unknown [9.123.14.182])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Oct 2026 08:21:29 +0000 (GMT)
Message-ID: <11848237-e3b5-4964-a512-6e2099179308@linux.ibm.com>
Date: Thu, 15 Oct 2026 13:51:27 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v11] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
 <179205238616.408196.12778446349366057336@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179205238616.408196.12778446349366057336@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: xZHUWa6MAE3e-e-L1IdQV7g8hVcb66vv
X-Proofpoint-ORIG-GUID: oUumIShsHBXW6gtsN4ehswobsRMo-FKy
X-Authority-Analysis: v=2.4 cv=aqInmiZV c=1 sm=1 tr=0 ts=6ad08d13 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAzMiBTYWx0ZWRfX0Lg18KqUrKjR
 qz20CNcvwDqzUc3OYpl2385RO9ehUD6Q5G5CyjPnCRcY8TKvsujPVQ49aiGbtVOQwgzTUqyL8XW
 3Rm6xT+bKuewSJKid0K9N3Ylcm2O8GU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAzMiBTYWx0ZWRfX9KvAsdMLQUa6
 R0Jd+SU/Gs3v7xljNNRSv1q7nysEMkHrePuO8T9jLtRdDSU8xzQd29eZkA7tzk/fM7iHlu5kag0
 IXOgNDnXglwiAaOs7gQDjoWE0DE9L/lS2YV8Vd3fDc9+oiv4lxCyK0uUFdgFI2dgHPc861TYvLy
 zCfJPWYzwhTha/rVqwDR5/P7OIi2LHUlwyOUl1Np55LPZEFmcKuqf4VXo0EELcLvR/Fvj/XHizG
 gmATp9OJ79ugMrpyMgmIRAoj1CwxHID2BpqyrFLQYHyxwpFspZniU0Pj19HzSFhfA3GyiTLMOfE
 2ORpy605UnpwZwM+1bSDy2ZV2sXSz96yh58YHAJosg2wB4wXPa2oO2AVnsKdmKdwJBmyWt5EKgj
 4lDwv6B/R7gCwZl6EtUGsAURQZdS0jYaoc+fhYnqAdlkgkyqdJz6ibOJdxCw4iKn7g6aK207WOs
 NZbi2pCEu+pb9TcgCFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150032



On 15/10/26 1:49 pm, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

The issue was found by manual code inspection while reviewing the diag
dump path in net/smc/smc_diag.c.

> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

The races are theoretical — none of the three windows were triggered in
practice. The smc_conn_kill() / smcd_buf_detach() race requires an
active smcss poll to coincide with an SMC-D lgr termination on the
dmb_nocopy path; the smc_close_active_abort() and
smc_close_passive_work() races require a concurrent diag dump during the
narrow teardown window between sk_state = SMC_CLOSED and
smc_conn_free(). No stack trace or error message is available since the
bugs were not hit in a running system.

