Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6725083F8;
	Mon, 19 Oct 2026 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418610; cv=none; b=J8bkG7E9T61vLqi/wwALS8vFyiMQ68OlYGGF4KdSZPeolHTU1JSbNJprM6E6WqvJzQi0oKhoJenegdWtia4mLNtM0DsXpvv4oge05rCmLbIBxAFRVfyVyJ5m2vaOXyeVKI7nFddzE83+2dZW+NlnF7bXJZxzwlT5o2Gw54EJifI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418610; c=relaxed/simple;
	bh=XPZO7HjYOKL9Yfs7tTkWDW0J3Tks2Vf6ojTnd+zeTJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EtCfl9b2FbIbGjqGQXQqDNqI7NFomkKFHPmJNlIrRaJlhus4hW03VD3GDEMs5cshGoN+Z7x4T3OPYqhvr6Tn97x2m2u1weI07WdbR6E6afq4tdBtQ3W6wOz0GE12eGj+YA2ZR8NSUkBsHuftHCKfRT9kUfTxNaPFbR8hNk2CzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gr9xehgo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gr9xehgo"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8iAeA3449258;
	Mon, 19 Oct 2026 14:03:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=q2KlCQ
	jcbNERGhm3X6pdqmvS8YP3HykJrntbNaEE0I0=; b=Gr9xehgoJR2ZuoIegRL5tW
	rCD9PeSHiyPF3pOzR/gxBX36XWu485Zyr8KyIHaW3avGCyJAOiibUbwjnRtujFGf
	NipN/n8+ED1uWTRbhgIRrV0x8ehjBHhqhgIyO4KmjRHO5JF5zrC1lyNX4NdDH1Nw
	M8J5BHx0OFGEwzY6/ngqLjYbglX6fxiXFLDyh+FH86JTpDbFY8L6aP4ljjVUU4tp
	asD0cyjsAmxCLOsgUz2D/Dlbao64f2q+hIhax4Fa6dNVrJhPlcn9HY0zxmTkuYwM
	tgSP4J/M06j22ewjpr81p2PmlpDdgWa02I2bVz6dNVw7V4QeFpqDm01vhKCU4BCA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hc0h5bm75-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 14:03:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69JCapfo2651406;
	Mon, 19 Oct 2026 14:03:19 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hcnjgwt3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 14:03:18 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69JE3Hsa39191068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Oct 2026 14:03:17 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20B6858056;
	Mon, 19 Oct 2026 14:03:17 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F169658052;
	Mon, 19 Oct 2026 14:03:10 +0000 (GMT)
Received: from [9.39.16.145] (unknown [9.39.16.145])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 Oct 2026 14:03:10 +0000 (GMT)
Message-ID: <e97615d0-23ed-413e-976d-2caf8588599c@linux.ibm.com>
Date: Mon, 19 Oct 2026 19:33:08 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
 <179240839082.3290.14556767471721761174@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179240839082.3290.14556767471721761174@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1NCBTYWx0ZWRfX4+BQLsN8so4q
 GNEKAy1pG2/j4xtAbL/ptccPEKtjSVPAz4StFRyjg7GVStErpR4qBv1/8vY3JlkYJKp34tqilXf
 8Jjy+uCwuikLK8lURpRKLKK7v/hjtzs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1NCBTYWx0ZWRfXw8uxNidnDBOf
 DwEhJ9CeqaOZth5EVMtPoL9HJrt9xjpfcS1dL75w2erkdU2tXL6Hs78iljD3WajcsXkOXK7FPjc
 Fjc/annPn0KikpOOruDS5DtQCzAKbJjMqBl7+fnCDGm0L+Xfzd6uSkq2cPIOvwmzKQ3XdUB351Y
 i351PHsORn1zXk8dAZETi6ln987FlwmTjNjAHke6eKC/YMwETVPHuw9LSZLjXPzavZxj4UJUaLa
 G6x3cXFuLkMxH8tFZ0om9q+qEtjoHwBFX+J2rF6JMqhhM1Czwk2okH83tQkzUotlraa9t8X159X
 wvbu8Kqn3JJPKZmAjZOUZnQenhPreZpykf1RytKS3p2Ctr2GLbUXJb13llS4bfrePFawVFklh4F
 hzI6UUGgmKfjaCwk0Qwc2qeqijeyX7PEKjBB1Fz40prgA88XtFFn6sSA3T87z55EtQ3gCPJTGXh
 QgQ654eHZa/yjaEmdJA==
X-Proofpoint-ORIG-GUID: oXkWv0V-r3HmhpF52qX_lUtFc0QZcgLX
X-Proofpoint-GUID: mw5TCMOVyXpa9x8j6m5-aXT6fAu0Pbqf
X-Authority-Analysis: v=2.4 cv=KujYSmWN c=1 sm=1 tr=0 ts=6ad62328 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190054



On 19/10/26 4:43 pm, netdev-bot+sinfo@kernel.org wrote:
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
