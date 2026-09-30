Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEC63C2796;
	Wed, 30 Sep 2026 07:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752269; cv=none; b=q0F8GoyWXjfORdo+qAP4r6aM5A/mH1DBtJQFszKT4kbYqNvIe4qRtVEh/qIf1ijIYTuoMBdckSdKVu1dISxwcdSZUdlVFPNOiw7b9txFvjCYMGfwvO8vbZy+OPXkbO4dq3V9ZSI4XrDzJTM4ceAd4t5Yft9hBQ8aLRHMW9bvBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752269; c=relaxed/simple;
	bh=g2cgFuQ8e8T6eg7EvtvItyPdG4mOo33yWflvFCkz3AY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vv9f7mLq1INiOqKjRKPiwTTFOs2KhDCxi1QDa/7A6IdzrET11QZJ/jPoDSFtJ+foLRq6o3P70/qSh7UINqZ5q7IPT8tOrIof8F5e2ZwwW5/ySic7SFYiSDR3EUJBYSomMsowvvtjAL+oQLv6UU/v1u2wjkXvMDj4my/a5LUiIQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sLEKRdBw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sLEKRdBw"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TNatnu1397176;
	Wed, 30 Sep 2026 07:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=I+p6Vf
	PkFpGQSdt2uUJgOI7WBcPPRqCReCXjQFAGnaQ=; b=sLEKRdBwIrx3ZC+9qEzMpe
	Kz0DQ3FcFtNyjvT5qH609DNmvxoxRQgXpGVHfRycBLbsXIrqnGqUY7o0eUwUuZiZ
	ty9QJyiIRT27yNNxRqZIiZeYUhzHAfPSQ3Ns6ruplrGdt+I59n9ff4zu2VXdT6iI
	ikYz8yM7zUn4tcSPfS/9PKTStOlHHgSaNMlaQmtI6A30JJoTloXQBVytHdaXOWqN
	AriZJ/Yv7n3Fw2uBsVdwDzJ/Fq4aSDHG8Qu0T8uBpy8Cyvdr/6PAGv83ECEh1wzw
	4xe3huY6QUF4EJ5ZfMxsg5JLF5Bl4WtaLGg/lCCMB36ESFhGlfWUYpxJ6uCdXm1A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5bk1a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:11:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68U4j8TD2581689;
	Wed, 30 Sep 2026 07:11:00 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h0j23jguv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:11:00 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68U7AwHt36831674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Sep 2026 07:10:58 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28B665806C;
	Wed, 30 Sep 2026 07:10:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C51658056;
	Wed, 30 Sep 2026 07:10:53 +0000 (GMT)
Received: from [9.123.5.239] (unknown [9.123.5.239])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Sep 2026 07:10:52 +0000 (GMT)
Message-ID: <98de2dad-829b-4c80-9075-480ff2c7c516@linux.ibm.com>
Date: Wed, 30 Sep 2026 12:40:51 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
 <179072950825.434549.9827562031861482481@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179072950825.434549.9827562031861482481@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAyOCBTYWx0ZWRfX0tdKoKYGRclk
 X7+dq4+i7E+BmpGtL/IrgaxgYBCyFfUihc+ZlWhAaQcyjfug2cyTO4z4ZHYJYrIXRhIIeqNLAW2
 MIIKzCG5kinxyyyKBcwS6jNCfNKeIco=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAyOCBTYWx0ZWRfX479zPbArP4JF
 9A2KZHLig8G3HEaony5zWdEFJP3x1zQT2iwgdXkhAF5BmaxuiJI+fzYO4TcCpC2uZLDn27ofp/Q
 kQGEjIufEyUjhVBoc1kE4zgav5+SgmZ1hTsypHqnqtQyqurNX8+GLbhv2wS3agw+TQQqJ+uMC7j
 yLJanyI9EhwB5RUdyyoIoKBd3PJRNA356Q6ipJYP3TERm+GhFaTHe/ANeZiWxA14Zefb3sRrSr0
 2CyENNG6oVWhTLwfJJ9VSo8xLaRN/y7QMisQHjyQbsWoNYKl1sbFXHPUHadzq8uoJNV944ovQNs
 dRE7u839hriu3lnXNAJwOgUaAd1Vrg5H9H+1xMWwRkU0mSxnkDz+wgpJGHKke++4946TFgPONL1
 pceid5yj52UZV6wNYGaO31e2ne5FwIMuXehDoQ7k0sZx2nNSliVmGpJ86uEwU5+KK0/XJHd7Izi
 9I3Ssflv7tWE49v0EVg==
X-Proofpoint-GUID: XMhLbB8BAUTZth4OTgJ4yCpqZ6358Zsi
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6abcb605 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=KAZRpFaLNGtyIlc6ilwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: r8IocDF9f7UieyMX4lMHTnItcUKcFijy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300028



On 30/09/26 6:21 am, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 2 (1) · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch leaves open another window of the class it says it
>   closes ('a hashed socket has freed or partially freed conn/lgr/lnk…
> - [Medium] The new early exit in __smc_diag_dump()
>   (net/smc/smc_diag.c:107-108, `if (sk->sk_state == SMC_INIT ||…
> - [Medium] For the smc_conn_abort() path, the patch's only protection
>   against dereferencing a freed conn->lgr in __smc_diag_dump() is two…
> - [Low] The second race the patch fixes is smcd_buf_detach() freeing
>   conn->sndbuf_desc in smc_conn_kill() while the socket is hashed and…
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but
>   smc_diag_handler_dump() (net/smc/smc_diag.c:245-260) starts the dump…

I'll address the applicable issues in v7. I missed the following line in
my previous reply:

pw-bot: cr
