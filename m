Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CB230C164;
	Wed, 22 Jul 2026 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704031; cv=none; b=kI8PGLxS7fGRKIXfmLaihLEHyUJ7z8MzCLdqrRZbTjj9BLCoJsapMLpPkXMZKGN5oxCvy9x2md3cTcaIhH6J/2IxzOU7IIyCuRZ7P2vxt4ZKuanbx4iZ4R/4JgSo7RHXS5E52HB/nzb/1jr6B+dIsATo2LDozs6AXdYl5MHNt9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704031; c=relaxed/simple;
	bh=M6rd/wvm3LuvSAYvyPEu14wGul3N+uGiTHIKOw6eG6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjfEQLRhxbAI/EhIq50caDX5SnuTSaiv+1KGmiqLZCs6jRaZP/jmmE9RBbasJ1TxXc8QOpWum727aHCCRZ8tKXXzE3ysWKztttVW5tnntFgrIfnSFMB9uJpuUdIInJ60AjhtWNM5r2gkKeakw9+9OqCbSArYrV5ctQTz69pzzBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cmaIdTZQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cmaIdTZQ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M5BeVB3147767;
	Wed, 22 Jul 2026 07:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M4sSuU
	kIvsqMX+riGT3pYgHVklSJ/VpUcUN95pvf0Ko=; b=cmaIdTZQULclJX4G+yXMQZ
	DvbDlCe00stxHXNtX/4r4mJ9o73n2vZXUqYxxI3gmIiPUh0FrDh3zKoJ7Zb90AKF
	k4n5ROdMRQ3Auy2Cpgja+oEl5C6NQmcai7AfxPCk6wP8L0sIu7ZicarWY+xep+du
	15lHAnQw/gTsOzE6vfM/nkIbC83U9u8G+ii0Yab+1FiewjeiO8NSE/jztxAYoaYV
	9wg3zq6WldkrXZEeq8v3ap0ZonvSA58uSHcTTJWYEGr/KkXtBRWOnWShye/YfdDR
	TNF846X9spqTaHao2rnBzjseucOumyQfoK/vVsbQwJ3rRCbBykYNeoh6f/zb5c/Q
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abgrdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:06:54 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M74dsK001931;
	Wed, 22 Jul 2026 07:06:53 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1gdwqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:06:53 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M76qAP48365956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 07:06:52 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E747458063;
	Wed, 22 Jul 2026 07:06:51 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EAAB5804B;
	Wed, 22 Jul 2026 07:06:41 +0000 (GMT)
Received: from [9.123.4.151] (unknown [9.123.4.151])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 07:06:41 +0000 (GMT)
Message-ID: <30ee395a-2005-4915-9766-ae2b0afdcd5d@linux.ibm.com>
Date: Wed, 22 Jul 2026 12:36:38 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 0/3] net/smc: transition to RDMA core CQ
 pooling
To: Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>
Cc: wenjia@linux.ibm.com, wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, leonro@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260721175309.321b6503@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260721175309.321b6503@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA2MSBTYWx0ZWRfX6kgtUdkYe7cg
 2PT/7IDtw7f+2XOELr/nL1ErnpTXkdcV0+HgA3hYMYlXtoH5v6JJXvN+4UR/dwtOiuTAh9JnMsO
 NOdD1wCqcpgf8KfaC8+qE4AoD0WHv45SnA14v3TwkHT447aHT5E8qyRNyEUCpy2TCCYXqJ2Ye90
 PNcpX9Dzg6vQ66gVPGkb/Bnp0H3S++b6KhIVjRKjzAoyVgaUx3+GpVeas6IJInHD58Y5ecLn4ym
 GMlpiCBM0wQSyc5ObD+02NCB1jnuXLrFw0YZCYARrTxDwjCjplveH7bz0Mtj0ITzRW50qQR45av
 KM38JUGPECOyL7x6No2M/C6096OVKT64VYxsKJH7ZVMHgLF9MCh83TcQItG+1P4OmjdVJ1sS0js
 F9AUQE/Jw36RR7nkrtgxwb3eee37jzkMAo54WD8jTrapE5W1Mt02pVjOqFMF+1wP3DKNHA9wP0G
 rjHXwAM/hQKAIXtGVAA==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a606c0e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=6Ov3Vrx_pWbtEMIe9AgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: cG2Yq2lLpREDXD9qC0dYjjtGOv4O8sXA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA2MSBTYWx0ZWRfXwO3AAuEThC79
 BrLOZjerMqUnixvNhcy8QOZ3S8+ZnUW/bjRSSk5kD1lTyF5m6gK2l6nxSSXCOGO2czDGg2FAcrU
 JDOUc3Sg0pJfWvBMZpIaKMHtusH2+jI=
X-Proofpoint-GUID: zvSbQwGaamGDTvO0BA6rDJA8h-GIIvvk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220061



On 22/07/26 6:23 am, Jakub Kicinski wrote:
> On Thu, 16 Jul 2026 19:37:42 +0800 D. Wythe wrote:
>> This series transitions SMC-R completion handling to RDMA core CQ pooling
>> via the ib_cqe API. The new completion model improves scalability by
>> allowing per-link completion processing across multiple cores and enables
>> DIM-based interrupt moderation.
> 
> There are 2 fixes for SMC on the list waiting for review.
> It'd also be great to get someone to review this series, preferably
> from IBM. There are 7 reviewers/maintainers for this code.
> Pinging y'all is getting really tedious.

Sorry for the delay, I was tied up with other work. I'm reviewing the
series now.

