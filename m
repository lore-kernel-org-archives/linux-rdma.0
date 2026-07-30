Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E0367295;
	Thu, 30 Jul 2026 04:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785386849; cv=none; b=ehV8BCvVA55cduEB+eMrdzsRD+W4PAsrQWqcpRJf5bA0hVge8nrAkxd6L3MnG4cOFLlxSEjrIFQbIt2vaAM9X7JMInW2I5EXwginWVww+lu5E6k+jODUPgF4bjZsSNCybDIeHJmQtgy1Jc7bBPqMabzW74K0/V6IyVIn/bzMXCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785386849; c=relaxed/simple;
	bh=ko/plejgoyaFkF8mncExs7LlBjK9u+yCNjnA2uqE2S4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uatAgnmIhfOke8r5kUffMGE/5cCBzZF5eJKRWx29TbHl95NCV+ma4SvyCoaVIBYqQguGylsBMJRvakEzgka9r7PWKL0bOLmYLQmYQTg1lCJttwPbnxwK+8oBof5ymCQEm9pG2XuOWVuLOwuHPaJF/P0W5qStq0H+q122iHhqVwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=d24gGDSy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d24gGDSy"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U3lhoi1828955;
	Thu, 30 Jul 2026 04:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GRDbvd
	ytfBqssjsgGMOujyUAhXvvuSrz5Ct1HOEeNnU=; b=d24gGDSyQmmgD4GiF5QdD/
	MnF+7L3MFgT75Q1NY4UK8bmd87od82gkZVgz18gPC+4uKuMmWTJ1T9QqeHbXLEnV
	7nBYiFmekgX4u8TU2KcutbwnBSSgw+bgeavsJmOAnF9WnjY6/dnwica44gY8nFdu
	potYcFQRXX8Lmi7g6BcfpNbFjEg+Agi3zz8BAfDdsoLpuZak4kL3GS9cxK4cT81/
	QlcvwBHW022RvqlyELuw+I1Xqpd2GcaTjbT9JqJht4hslGYqPuleit7ByjeBcgNS
	09vH4ayqLW/foLCnBdXpThgPZUUdxOY0qoWoQwINa1NudUYrugK+1H0rzeGNOw2g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0nw61g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 04:47:18 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U4fGGn018494;
	Thu, 30 Jul 2026 04:47:17 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y9h2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 04:47:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U4lGEM8192574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 04:47:16 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EE7458056;
	Thu, 30 Jul 2026 04:47:16 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E11E258052;
	Thu, 30 Jul 2026 04:47:10 +0000 (GMT)
Received: from [9.124.209.182] (unknown [9.124.209.182])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 04:47:10 +0000 (GMT)
Message-ID: <c12b60e8-727f-4232-afbe-2cc5f6533079@linux.ibm.com>
Date: Thu, 30 Jul 2026 10:17:08 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 3/3] net/smc: transition to RDMA core CQ
 pooling
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
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
 <92ba5a37-3496-424c-8425-6535515c01ce@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <92ba5a37-3496-424c-8425-6535515c01ce@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAyNSBTYWx0ZWRfX/H5qKL6GcEn9
 S6Nznmgr6saR34unq+hz2j32shsxN5OQwC/ym2E1p9OI3qwNyZ5EJEYU/XqAFL7h+iB1Ok7Qw8C
 NBXvpSatD9CBxU6L3peJmhlfIiRJbbY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAyNSBTYWx0ZWRfX0INZglNAqDdA
 ytd5WEGLh0sZmB9mU8WjxddwCUNKMGsePkh5w+rhOJv7D0m+wJbLtPTOdEVBCJHU8OFKuRomber
 OM+4HqdmgT/alIinIcPfkrKeZJmHYdNh73Qnn+zW31G8Tk1LbUEXInPF4tjk6q5U2jb5VGqOPLo
 LKxDmsgTN8nwHA/arcpKWqRRsNXs1aS4/tvI23wY0GyQNJNbFss3gWnMi8X+mpRQTHpPeCSeInV
 G7NkdBJWf2GoTH1H2XlVdH0Rhnjd/l//Kgepo7M7Zfey9paMIAmTvBZUAZrkTWFpUlbzr6q8SRd
 81umLZFeMHM/gjXxdyVvGN98mHALgliDGGSvSrRXSqPUG+uQvnMLotUgyRmHILlQVcaWJPVn9ox
 6fPyuuHQam2n1/Pk6YkxzvFDQ584jPJYspEhCz1G8imAZrRQKj+AHBYnWwOqiw/SPh+fLUQW2PY
 l+5ySDiXNH2xLu4pLAg==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6ad757 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=T4hTGduiKsk5PSsedNQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: q1NC9aP8prvMCy73BgNFbv7Mm8lQjfo-
X-Proofpoint-ORIG-GUID: 9_IQJPloFO6RIeZd73RkvClhUvAFdJMQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300025



On 22/07/26 5:17 pm, Mahanta Jambigi wrote:
> 
> 
> On 16/07/26 5:07 pm, D. Wythe wrote:
>> Performance Test: redis-benchmark with max 32 connections per QP
>> Data format: Requests Per Second (RPS), Percentage in brackets
>> represents the gain/loss compared to TCP.
>>
>> | Clients | TCP      | SMC (original)      | SMC (cq_pool)       |
>> |---------|----------|---------------------|---------------------|
>> | c = 1   | 24449    | 31172  (+27%)       | 34039  (+39%)       |
>> | c = 2   | 46420    | 53216  (+14%)       | 64391  (+38%)       |
>> | c = 16  | 159673   | 83668  (-48%)  <--  | 216947 (+36%)       |
>> | c = 32  | 164956   | 97631  (-41%)  <--  | 249376 (+51%)       |
>> | c = 64  | 166322   | 118192 (-29%)  <--  | 249488 (+50%)       |
>> | c = 128 | 167700   | 121497 (-27%)  <--  | 249480 (+48%)       |
>> | c = 256 | 175021   | 146109 (-16%)  <--  | 240384 (+37%)       |
>> | c = 512 | 168987   | 101479 (-40%)  <--  | 226634 (+34%)       |
>>
>> The results demonstrate that this optimization effectively resolves the
>> scalability bottleneck, with RPS increasing by over 110% at c=64
>> compared to the original implementation.
> 
> Thanks for the performance numbers — the scalability improvement at high
> client counts is striking. A few questions to help reproduce these results:
> 
> 1) Was net.smc.smcr_max_conns_per_lgr=32 the value used? The "max 32
> connections per QP" in the description suggests so, but the sysctl
> wasn't explicitly listed.
> 
> 2) Were net.smc.smcr_max_send_wr and net.smc.smcr_max_recv_wr left at
> their defaults, or tuned? With per-link CQs the optimal WR counts may
> differ from the global-CQ case, so knowing whether these were touched
> would help interpret the numbers.
> 
> 3) Was this SMC-R v2? The v2 TX path (smc_wr_tx_get_v2_slot,
> wr_tx_v2_ib) has different concurrency characteristics, so confirming
> the version matters for the contention analysis in patch 2/3 as well.
> 
> 4) Was uperf tested for v4 as well, as we did for v1[1] in
> February-2026? uperf exercises a wider range of message sizes and thread
> counts, so its numbers would strengthen the case — particularly for the
> intermediate client counts (c=16 to c=64) where the original
> implementation regresses below TCP.

@D. Wythe: Gentle reminder regarding my earlier questions. Have you had
a chance to look into them?

> 
> [1]
> https://lore.kernel.org/netdev/20260202094800.30373-1-alibuda@linux.alibaba.com/

