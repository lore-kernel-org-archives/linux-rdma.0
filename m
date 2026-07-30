Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDDE389473;
	Thu, 30 Jul 2026 07:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785396320; cv=none; b=Mny4b3REqPGxEAJoeyqhKTWi1EUIrwCsXSoJDCch/Dk7ZRRg+/tG2mLP+8vjrZ/71l2lwUXwcgSbGUFhzgjjzEWZRX6aiGrQmKshOeWeQ+ZPN5J3deu/hzaMrC/mnSWAw5deOYqFRY6pZGpPGpht7E+9IUWRaqWc9bdDuAvloAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785396320; c=relaxed/simple;
	bh=BLdWqPUp+7FmrV80qqPMYH4S9Xj6Uiny8rj8fDcSe9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h5J+CudUhZaYJMsDYq3IfCePNjMJfRrHCHgv58xVLBVRaiqoTsiSBCGl2+ebufX2HHHAmZhMKqrUzDjWCfIkd6+9JUglFwt+aIw+60PAbp74CawBRbPpky1EUX1NVA460caSQm+d66OhaFudBt+hvD1ykunAuLV2lPLi4QDtwZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M7UyVGk8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M7UyVGk8"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6lghk2193171;
	Thu, 30 Jul 2026 07:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kUnaYu
	7woz6SEbRNde+L9WerO0WZWK6oYSMtlxH7Rqo=; b=M7UyVGk8VMnwieLyC62nvl
	6beE3e5yGEKA3FyryIiSQMX6hZgFOdD+gqkCtNADpHqAYRdCYVi1jnVmzVAEDb6t
	1mq4kxPOkX2HhBQv9r6dxGVCnzUxvNY+BAjqul66mazRTSpUTeyftVgLs1zAJKzA
	qHPMADyRoZdDBOIfQJL7dcIjbn84F8Ny7osa45QCtu+jsxzc7RNJ3pOSTyZ7G+6Z
	MOpOKy6c847lBZcxZryNxtUFnn2336HP1uA1SvxFVojyJ3quCgIUtmLJ38LyGaHG
	138aHnHcXIPpxX5liV7zDfX3CbB3zX+3XRk1NQrsA9L9MInCizqQQHrfMc9qfNag
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjdphg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 07:25:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U7BR6e031167;
	Thu, 30 Jul 2026 07:25:10 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhj66r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 07:25:10 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U7P89w38797900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 07:25:08 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AFCF5805A;
	Thu, 30 Jul 2026 07:25:08 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1DA0558064;
	Thu, 30 Jul 2026 07:25:02 +0000 (GMT)
Received: from [9.124.209.182] (unknown [9.124.209.182])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 07:25:01 +0000 (GMT)
Message-ID: <9f873ee1-599e-4e3b-b2e5-4880699f178b@linux.ibm.com>
Date: Thu, 30 Jul 2026 12:55:00 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 3/3] net/smc: transition to RDMA core CQ
 pooling
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: wenjia@linux.ibm.com, wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-4-alibuda@linux.alibaba.com>
 <92ba5a37-3496-424c-8425-6535515c01ce@linux.ibm.com>
 <20260730054342.GA116570@j66a10360.sqa.eu95>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260730054342.GA116570@j66a10360.sqa.eu95>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA1MCBTYWx0ZWRfX5YgCi98xIGJt
 FLBjCsD4IXBF/7/SSKCyj4iYU1VPYf2rrWj8BhLPRjcoEpNM19upzX/awPEXZGV5ERguLPq4EyE
 C2N119yYBVAp5l9egxuwK77bsEjz/QI=
X-Proofpoint-GUID: h5I78xr1thhsKW2veCP3gnGrsePkzVZ-
X-Proofpoint-ORIG-GUID: vUeeVdxDLzXwhwqK0Mu6iaanhFzGwdXu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA1MCBTYWx0ZWRfX+hsbKKfuFkpA
 XXhUtURF7IrZ44q8syXFW7O17ynHor2rU8KlqkSRibykZbcekGA127Q8Joz66QadF/IOhIG++sd
 dH8+n2+uSlxPpnoSozBG4/ML3IHTuaA2d2BgB27NBf90PDrEeS9zAcUhf+JIKnSPTL64Pfa2rHj
 kOKuTmQXtdqWMkIisvMfCVffqYGD037Iz0FRnTvue5xNlpULHeQ1p7K3DyPP4nkPJMbqDNDMUmj
 SVs/qZjCErY8OUEn6YxaY8FW+Skx0SPw1ExwD2BHe2VGk5GVSpZg9cqInrXFT+zMMRE1SquLxSB
 jF+wCuEXxf0s1ExZSfP+iTPT7dkUGiV75H9uwMRtDETJ46j86JUn51EdAcOH4wi+o8KRztme8kc
 Qp/uFWj2+lcjWbN9t0G1VmWZhbClbjMers/QalyeVZiBHmPUF8L2f5pUOF/XoCLNyQ7qIVKyv9N
 B6JRL1pz3e6dDj/7pwQ==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6afc57 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=uXagFE_kSg624K14DQIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300050



On 30/07/26 11:13 am, D. Wythe wrote:
> On Wed, Jul 22, 2026 at 05:17:15PM +0530, Mahanta Jambigi wrote:
>>
>>
>> On 16/07/26 5:07 pm, D. Wythe wrote:
>>> Performance Test: redis-benchmark with max 32 connections per QP
>>> Data format: Requests Per Second (RPS), Percentage in brackets
>>> represents the gain/loss compared to TCP.
>>>
>>> | Clients | TCP      | SMC (original)      | SMC (cq_pool)       |
>>> |---------|----------|---------------------|---------------------|
>>> | c = 1   | 24449    | 31172  (+27%)       | 34039  (+39%)       |
>>> | c = 2   | 46420    | 53216  (+14%)       | 64391  (+38%)       |
>>> | c = 16  | 159673   | 83668  (-48%)  <--  | 216947 (+36%)       |
>>> | c = 32  | 164956   | 97631  (-41%)  <--  | 249376 (+51%)       |
>>> | c = 64  | 166322   | 118192 (-29%)  <--  | 249488 (+50%)       |
>>> | c = 128 | 167700   | 121497 (-27%)  <--  | 249480 (+48%)       |
>>> | c = 256 | 175021   | 146109 (-16%)  <--  | 240384 (+37%)       |
>>> | c = 512 | 168987   | 101479 (-40%)  <--  | 226634 (+34%)       |
>>>
>>> The results demonstrate that this optimization effectively resolves the
>>> scalability bottleneck, with RPS increasing by over 110% at c=64
>>> compared to the original implementation.
>>
>> Thanks for the performance numbers — the scalability improvement at high
>> client counts is striking. A few questions to help reproduce these results:
>>
>> 1) Was net.smc.smcr_max_conns_per_lgr=32 the value used? The "max 32
>> connections per QP" in the description suggests so, but the sysctl
>> wasn't explicitly listed.
>>
>> 2) Were net.smc.smcr_max_send_wr and net.smc.smcr_max_recv_wr left at
>> their defaults, or tuned? With per-link CQs the optimal WR counts may
>> differ from the global-CQ case, so knowing whether these were touched
>> would help interpret the numbers.
>>
>> 3) Was this SMC-R v2? The v2 TX path (smc_wr_tx_get_v2_slot,
>> wr_tx_v2_ib) has different concurrency characteristics, so confirming
>> the version matters for the contention analysis in patch 2/3 as well.
> 
> In our tests, we set net.smc.smcr_max_conns_per_lgr=32 via sysctl. We
> also tuned net.smc.smcr_max_send_wr and net.smc.smcr_max_recv_wr from
> their default to 64 to provide sufficient work request depth. 
> 
> All tests were run with SMC-R v2.
> 
> And the performance numbers do need a refresh: with recent improvements—including
> thundering herd mitigation in earlier patches, the original SMC implementation’s
> regression in the c=16–512 range is expected to be largely resolved.

I believe that Patch 2/3, "net/smc: reduce TX slot contention with
exclusive wait", largely mitigates the thundering herd effect.

> 
>>
>> 4) Was uperf tested for v4 as well, as we did for v1[1] in
>> February-2026? uperf exercises a wider range of message sizes and thread
>> counts, so its numbers would strengthen the case — particularly for the
>> intermediate client counts (c=16 to c=64) where the original
>> implementation regresses below TCP.
> 
> Of course uperf was tested. We’ll include a comprehensive uperf
> evaluation in the next version. 
> 
> Given that this CQ-pooling patch may require additional review time, I
> plan to send the first two patches of the series separately.
> They’ve already been reviewed and are ready to merge. This patch
> will follow as a standalone submission once the uperf results are
> ready.

Sounds good. I'll be looking forward to the standalone patch that
introduces CQ pooling and the accompanying uperf results.

> 
> D. Wythe
> 
>>
>> [1]
>> https://lore.kernel.org/netdev/20260202094800.30373-1-alibuda@linux.alibaba.com/

