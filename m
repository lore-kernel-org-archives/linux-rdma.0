Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F28333937E;
	Wed, 22 Jul 2026 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720852; cv=none; b=GRyN5JJ2Pf7n8L9dgnmhtfUyFPvGrbIcGp+XiQLmHQIlSm3A6ELDT2CjR+q6Is58kfmcC80aIyd2FOZI0NjGmCUAThEpqQ3RAbgY0UlUQuhrZamiSMDK+ELoAr8+AR1A4xAtvBafUR1oJm1SRWFx7bjJ6EF59v3cBkNISpeS5ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720852; c=relaxed/simple;
	bh=xYGbXQic4sgBS+zAaVgwNKfC0JG/kSVN2dFSc6eCrLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aBmB6MsFwoZdDKe1/stWnCJ4I37vLoC1HSYhNtHmar+vzAhlBneFjG2Uv0KgmwiZIcROajqGUAhUPJV//5SKq4G83VQ+6rCFyy8f/E2Er1H2UNk7eZw1LGbVi+lyoaWZeFHi51zx+Mq+rxfF8/RwGt3upZx6dWUFM/CP4O21aXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PeETOVVn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PeETOVVn"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M9CBE03672497;
	Wed, 22 Jul 2026 11:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2wA5Df
	WWY2VlBm4NmSq/FtFRC+Q2MSZMNjhAdJ8vmGk=; b=PeETOVVnXX4q3/Ammaru+F
	WyYRZ9dHHlINnqV1Hwwgsx6Tx0ll/vv2OUBp0h3TE6FEW3eTfLhrkhJarOXMkpMG
	DARCesArU9Lgc86AJT1c3WIdCDg6yxnjXsPL+O23LrvMPV+rnL3CWPc1tR0ma3Ni
	pOtdt9e8W8dSgIqyAaHcz4x76kYSJe0tvFKIqnnply9SkeekAtTOSZCS7whIdXrp
	cyN8FNehXNkoIyw+EtjsTFDBCE43TVQ5iP8YczGy7msGmJPywd22SrrI1TrXwFOY
	65ML/VfyLvCHsVw1n4MWJvwmIkOrFq4OSghY19OvWhdUNZtRlurA+TtMIKi9t32Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7911wf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 11:47:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MBdlih026437;
	Wed, 22 Jul 2026 11:47:24 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgyetcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 11:47:24 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66MBlN6d24183322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 11:47:23 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABF2358043;
	Wed, 22 Jul 2026 11:47:23 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 697FA58055;
	Wed, 22 Jul 2026 11:47:17 +0000 (GMT)
Received: from [9.39.18.174] (unknown [9.39.18.174])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 11:47:17 +0000 (GMT)
Message-ID: <92ba5a37-3496-424c-8425-6535515c01ce@linux.ibm.com>
Date: Wed, 22 Jul 2026 17:17:15 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 3/3] net/smc: transition to RDMA core CQ
 pooling
To: "D. Wythe" <alibuda@linux.alibaba.com>, wenjia@linux.ibm.com,
        wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-4-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260716113745.65234-4-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: ZnW59UcXo6UBjMKYMF7zxmkwBf8GZH19
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a60adce cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=4P9Li1RtWcOViQHuidAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDExNCBTYWx0ZWRfX7J8r+NkYixfo
 BrfPwmSAQcHbwj6qNuCK3a1SCym9yS/TTgqFDkWm3V1xDAS8s/PS5NZ0CPnKj4ngmzWPzAZPq5t
 BjBsWkZeRWzPKttHxR1f6USAWsZV65A=
X-Proofpoint-GUID: d6SCE6jsQHcWLeDWlYjyngU9BMpdRKfE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDExNCBTYWx0ZWRfX/RRpif+AlqCC
 x5sNh8iZ+9JpQ4utZ8WPg8T3H4sckUQ4xVXVTuRzRhPINK5EERc0TyMvzYRRGd3MTf3vomDOC50
 4See9Rw17T+mf6wC298FqIz9UGKiIHgkcjUvbGN8b0vNy8f/DI4uXnk4+0Npbtvd3RcF14jMmdw
 bDT/xBhOVisAmSf5x/iNDELz6+SG+tdLBRn1aQtfTy5OTf+cieGxbpoSML3qRltwGjODYOvXMOw
 DkWbfs/N/46zCWdz3Vz87Fw1sdABODflXLxidOxgKFU8/9FVmJBrW+7lA1vsOL3HFkSEfggjKoT
 slrP+sL3tO6FVm2GUPgUPH7pmPYY+Gc0wXXut35M2aIDrTj/JDiddIvdwMk6h7isEa0velXNdo7
 cDJeKFBVXKT3yf/qWjTTYLjA9UiOrHyyCmRQiiI6PUPQfcWiTrbr5ZzkUVVrtvCXeHeHPeAzIVW
 XKil9WxEg9QE6vCnz3g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220114



On 16/07/26 5:07 pm, D. Wythe wrote:
> Performance Test: redis-benchmark with max 32 connections per QP
> Data format: Requests Per Second (RPS), Percentage in brackets
> represents the gain/loss compared to TCP.
> 
> | Clients | TCP      | SMC (original)      | SMC (cq_pool)       |
> |---------|----------|---------------------|---------------------|
> | c = 1   | 24449    | 31172  (+27%)       | 34039  (+39%)       |
> | c = 2   | 46420    | 53216  (+14%)       | 64391  (+38%)       |
> | c = 16  | 159673   | 83668  (-48%)  <--  | 216947 (+36%)       |
> | c = 32  | 164956   | 97631  (-41%)  <--  | 249376 (+51%)       |
> | c = 64  | 166322   | 118192 (-29%)  <--  | 249488 (+50%)       |
> | c = 128 | 167700   | 121497 (-27%)  <--  | 249480 (+48%)       |
> | c = 256 | 175021   | 146109 (-16%)  <--  | 240384 (+37%)       |
> | c = 512 | 168987   | 101479 (-40%)  <--  | 226634 (+34%)       |
> 
> The results demonstrate that this optimization effectively resolves the
> scalability bottleneck, with RPS increasing by over 110% at c=64
> compared to the original implementation.

Thanks for the performance numbers — the scalability improvement at high
client counts is striking. A few questions to help reproduce these results:

1) Was net.smc.smcr_max_conns_per_lgr=32 the value used? The "max 32
connections per QP" in the description suggests so, but the sysctl
wasn't explicitly listed.

2) Were net.smc.smcr_max_send_wr and net.smc.smcr_max_recv_wr left at
their defaults, or tuned? With per-link CQs the optimal WR counts may
differ from the global-CQ case, so knowing whether these were touched
would help interpret the numbers.

3) Was this SMC-R v2? The v2 TX path (smc_wr_tx_get_v2_slot,
wr_tx_v2_ib) has different concurrency characteristics, so confirming
the version matters for the contention analysis in patch 2/3 as well.

4) Was uperf tested for v4 as well, as we did for v1[1] in
February-2026? uperf exercises a wider range of message sizes and thread
counts, so its numbers would strengthen the case — particularly for the
intermediate client counts (c=16 to c=64) where the original
implementation regresses below TCP.

[1]
https://lore.kernel.org/netdev/20260202094800.30373-1-alibuda@linux.alibaba.com/
