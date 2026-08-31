Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF1D44161C;
	Mon, 31 Aug 2026 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185342; cv=none; b=pvbTfoQ6CqhyatJS4PjvsuWv41GBoZK3oL8uZyg2Swzs9WCl+wwWthVeLm5FOUgrsRujdw/aHe+1O/roEoWGT8rRLD8Rc6rRDbWSFDpWn6LB/wDdiURODgqNNnA3fNeh+UBAYS1tjttO0rfFs6bz27/AD8wELXjYfupGnk7S73A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185342; c=relaxed/simple;
	bh=f/DUOrKSy61hLuWNFjHMr0DP+VfY56/UiRvFuo8LQKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZ4aJAJqVpughUaUxvYwMSaGPfPwtF5AQ/H/qjnJXqwNxqeuWSUEakLunVUmpFku2Lv0zEKOEYO6uOVDU8uNZMN9zzTwQ0xVOh4JFIrjmgwx9fzaEGGXY6lr9ZvAiDMkyrcGI+XqoEh33oSNdaF1n+wAhBCckBUy6wH9xWDI+nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X6OwX15/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X6OwX15/"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VBWAKH957489;
	Mon, 31 Aug 2026 14:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cEPQQ1
	TvXlmhouBm3vAZhlT+2kNVr5Q45Xhm6lsI4Fo=; b=X6OwX15/yOzrGpje3keY5X
	jWVI4j7wxRbRM/J3lzsf7RfKgkItcM9FQWlXOIJu8CB9zEcv1BDZec2FhdivEeuM
	tC8NF+tAA1c1zLk5BhWtwclIGxKROPIoaEQx3ndTZobqEtzI28HDTj3KVViaKdBE
	ItTRgdQw6TrM2sOXcq0r3T0xba9vgGqNHAB4NkCui3UR9VBEOJnAPsnLEUA44HXb
	KxaFjrDrz8zeZhpUFyTm7xu8YKIaTOjGX+OKJIpi2nj4bEeBup9LTDbJ6XWk98+e
	sMQDdYZO/Ylb+wnC0ibFzTcGP+O0TO3OcZ6UZIJH4BbQn9w1Iz2Xj+qCvMEMfyqw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbnudhqwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 14:08:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67VDuJop007389;
	Mon, 31 Aug 2026 14:08:53 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcarjx8tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 14:08:53 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67VE8pc031785724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 14:08:52 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DA1E5805E;
	Mon, 31 Aug 2026 14:08:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E823A5805A;
	Mon, 31 Aug 2026 14:08:45 +0000 (GMT)
Received: from [9.124.217.200] (unknown [9.124.217.200])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 14:08:45 +0000 (GMT)
Message-ID: <df7fd794-2afc-4bcc-b9dd-6264afa2460c@linux.ibm.com>
Date: Mon, 31 Aug 2026 19:38:43 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
To: dust.li@linux.alibaba.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <apWEzobrZ3QR3IfN@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: _7ZcWtJaqza1PaOu_NYjVj9XZfE6cPwR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDEyMSBTYWx0ZWRfX1WMjFPcDYp2j
 0sqSfHCaGl2ValFuU/Nx396yK9pLdLzj3iXkkXjsK44WHVhC0b3NtMgqxh2I1ZNZGxFuhijpNAx
 bEHmOBQkr7k7X6QhqrVgjhTxnjbRlTXtaLQA/7D7FQHBiLCaPgRvytCQHZTzbl55ajkdqHYzZSf
 aHGdBDqG17ej/I8drdSGNzLQ/GPD8aEdskemj/Yng4pMKYvpF+8QANnwMYkKvGCeQK8doFJ4dA3
 QUbXF560j8KEzEWHUCq4WN0FK/zg4QXO4PT4CqKPeY2aOZpxyABI7yoeh4aeXmbZ0E56yP6cYaI
 rY6dFV7Dchk61Yvc/KswS7U9ubvO/WlFoc99b6uPmpFXkb8gZgkH14hnT0haGtFLg5G8FiyV7xK
 d2427Ij/oyLJlWFrI+lEMTYHPi5raLwopgVeVTwjW4MJdMeQ4FXVQkftJi6FvxUhTEx4EahPHsr
 DJt+bDyJiWFoS35JI6Q==
X-Proofpoint-ORIG-GUID: ZqF0f2VTkXPwSjJDzJ_wSdSfmVrx8Wi7
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDEyMSBTYWx0ZWRfX91sey4hBfzaI
 PVbR6f+7nNGJA5jsJtbyPDaElbGu+Ycd2fBOoDwqM4RzvDUGxZSHMGPPOwvuXTTyFriWUGnha9U
 VfInzTJTWld8XyjpuTp8uA496jPGmzI=
X-Authority-Analysis: v=2.4 cv=B92JFutM c=1 sm=1 tr=0 ts=6a958af6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=x973IGAFoIv2PoljAxAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_04,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310121



On 31/08/26 7:12 pm, Dust Li wrote:
> On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>> This series fixes multiple lifetime races in the SMC diag dump path.
>>
>> The first patch adds the basic infrastructure needed to synchronize diag readers
>> against connection-owned conn->lgr/conn->lnk updates. It introduces a
>> per-connection spinlock and uses it in the link switch and connection free
>> handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>> borrowed references are released, so a non-NULL conn->lgr seen under the lock
>> guarantees the lgr object is alive. The diag reader can rely on this invariant
>> without borrowing any extra reference.
>>
>> The second patch fixes two races in smc_diag itself:
>>
>> - serialize clcsock field access against smc_clcsock_release() with
>>  mutex_trylock()
>> - take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>>  smc_conn_lgr_valid() inside the lock to check that the connection is
>>  still registered, then snapshot all required fields and call nla_put()
>>  after releasing the lock
> 
> Hi Mahanta,
> 
> As discussed in the other thread, I think we should defer the release of
> smc->clcsock and remove clcsock_release_lock.
> 
> In that case, we should no longer need these two patches. Also,
> introducing more locks in SMC is the last thing I want to do :)

Does your "[RFC net-next 0/7] net/smc: tie clcsock lifetime to the smc
socket and remove clcsock_release_lock" resolve conn.lgr/conn.lnk races
in __smc_diag_dump() against the concurrent tear-down paths?

