Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82329406817;
	Wed,  5 Aug 2026 09:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923971; cv=none; b=Zb5rWTdDeinVdRLd5aydxJya07qI/F0ntUnDKlUVcRjvYVPNXCjYQkSiub3YCUjluI3Q11+38LEBK8xmp7cOUZl0iZJ4byoVsmGdFVqSigPfKa/7bkmR7t3Bgp5qmspRwCenkskHuQrMKsaQYUGC2cAYa4dntytwCoq86i89yPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923971; c=relaxed/simple;
	bh=isXwDE5de2G+plTKAIzMVH0tySnFsZoP7is7/AXEdWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=obx4AUR10F9CjXnThK7QipURLOQS1Ko9c06vMJbZx7gZtYzHh2xA2FH+47C5G9SQzNU7cf85OXb3a0MjLZsWCqQXRh3Lq9/wskXJJt7UGtuiY6B/83HTOqLTW/K9Czs6idiGbJLld4u7pCSVsIJFnUtSCQYbjrN9iULOGEOV6o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WG5Svriv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WG5Svriv"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758m0cf3355049;
	Wed, 5 Aug 2026 09:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PQXItv
	payZ42iimDhJf9JUftHo6Gt1R0S9oG2gytQ84=; b=WG5SvrivwCKWTrf4H6wEUH
	tgmaWohTA3ODT5UDlM3QvlOSowsAdwGrCFrnHumSYvV8iTorv/UGAVpGllj3fUrX
	FlIi2lBSB5ie9Jh/Nj1XE6RxVnYRBH08s3hXULlSDi75y0EeBLznCR31MvtBlDhg
	5oJmFSf7uS4at6RVW6PGzEyKAEg8TF7+JhqU/utzfFJNX3jrB5DlufHeo7y/Jf+6
	LXpNiyABtXLQt4Ei+nI2bX8h3+WcSR+fsDIQch0dlMsQYjnOiiJtsTy6k6UcTj75
	Arah6gYzC6h8a1a8l8QUbtvs0e6iqoB2rSN7zGk7MjLBEc2yK0TMPUxdHhZ+lAIg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a42ey5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 09:59:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6759uRHh032183;
	Wed, 5 Aug 2026 09:59:22 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw64ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 09:59:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6759xHgi51708248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 09:59:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D19CB2004E;
	Wed,  5 Aug 2026 09:59:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AD1020043;
	Wed,  5 Aug 2026 09:59:17 +0000 (GMT)
Received: from [9.111.207.139] (unknown [9.111.207.139])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 09:59:17 +0000 (GMT)
Message-ID: <0ac0c8ec-f955-4921-933d-1310800ca002@linux.ibm.com>
Date: Wed, 5 Aug 2026 11:59:16 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] dibs: fix double free of dmb_clientid_arr
To: Simon Horman <horms@kernel.org>, hidayath@linux.ibm.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
        mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260730075624.114778-1-hidayath@linux.ibm.com>
 <20260804165217.525335-1-horms@kernel.org>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20260804165217.525335-1-horms@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a73097b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=9R54UkLUAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=47v8NvyK2iWT-m1jnbwA:9 a=QEXdDO2ut3YA:10
 a=YTcpBFlVQWkNscrzJ_Dz:22
X-Proofpoint-ORIG-GUID: Cuz7d9M9JqNyW9ntI3AAq5vSdOhjlyA1
X-Proofpoint-GUID: zDDJpA_ayjBrs2ICrzPDAZHh8gKfgbq4
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA3NyBTYWx0ZWRfX7gB5z2tylk2o
 ELTq/86Tc0lx+7PRolCBiiGx5goX3cu3OutcAfPGu6X0ptN6oY/MnXUSwpei/XKd0xFE6GjnQOn
 ITc9XPeADX6iCagwHjJBZuOVedsge84=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA3NyBTYWx0ZWRfXxgSpC0Hrul6N
 VxhyRtoxwZv8Mp9U25z21QfQw9/Mw2GimU4oi7FFjvgz77S9jDh48vg9P4vCqndP+CPssSZN3JP
 me02AFZZIBzCy02J7GVctbqRhNRx1nmCkroTLPOZ8VJaciUg3TKBh652PcCQqRq8mGb3Xa7rd69
 pE46Kxdv+IOFVSstm2SdG8RpDtZdaln6esZpw+8Ufmjhdin05r4o7n0kndMsp/2OdX0IsA7JsoU
 N3gqIh6ZmGOfxPmBcsCte5Fqqg32D/lstb4MjKHvefiz4nFvsMvyYnAP258VOUYZPqFSZvOvxOh
 BiImy/j1UeO8LI/i4mGwkmDy2kW34QUW0YrSijS4XvB3KJ4EzxXxh1c+3Utr7LuaAWSFFrqudUy
 M71TRQoObnwx8k2uhkDfB/Eq+SDv7YOFvx/t89WNkmtsdtcp2/0qzU6sG+BgdP/UFmuJtBSx3q+
 T9PMgkYxzY6nQXhhF2A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050077



On 04.08.26 18:52, Simon Horman wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260730075624.114778-1-hidayath@linux.ibm.com?part=1
> ---
> --- Patch [1]: [PATCH net] dibs: fix double free of dmb_clientid_arr ---
> commit d9da866ee3cff93c660daf037f85b099a2326866
> Author: Hidayath Khan <hidayath@linux.ibm.com>
> 
> dibs: fix double free of dmb_clientid_arr
> 
> This drops the kfree(dibs->dmb_clientid_arr) from the err_reg path of
> dibs_lo_dev_probe(), since dibs_dev_add() already frees that buffer on
> both of its own failure paths without clearing the pointer.
> 
> Two questions below, one about the commit message tags and one about the
> lifetime of the same buffer on the removal path.
> 
>> dibs: fix double free of dmb_clientid_arr
>>
>> dibs_dev_add() frees dibs->dmb_clientid_arr on both of its failure
>> paths, but does not clear the pointer. dibs_lo_dev_probe() then frees
>> the same pointer again in its err_reg path, so a failing device_add()
>> or sysfs_create_group() results in a double free.
>>
>> Drop the kfree() from dibs_lo_dev_probe().
>>
>> Note: commit cc21191b584c ("dibs: Move data path to dibs layer") moved
>> the code to its current location; the race was introduced earlier by
>> commit c3a910f2380f ("net/smc: implement DMB-merged operations of
>> loopback-ism").
>>
>> Fixes: c3a910f2380f ("net/smc: implement DMB-merged operations of loopback-ism")
>> Cc: stable@vger.kernel.org
> 
> [Severity: Medium]
> [Finding: main-1-0]
> [Sources: opus-5]
> Is c3a910f2380f the right commit to blame here?
> 
> That commit only touches net/smc/smc_loopback.c and net/smc/smc_loopback.h,
> adding DMB refcounting plus attach/detach/nocopy support. It creates no
> client-id array, and it adds no kfree() on any probe error path. At
> c3a910f2380f^ the only matching array in the tree is ISM's private
> sba_client_arr in drivers/s390/net/ism_drv.c and include/linux/ism.h.
> 
> Blame instead points both halves of the double free at cc21191b584c
> ("dibs: Move data path to dibs layer"): the allocation and the free in
> dibs_dev_add(),
> 
> 	dibs->dmb_clientid_arr = kzalloc(max_dmbs, GFP_KERNEL);
> 	...
> 	free_client_arr:
> 		kfree(dibs->dmb_clientid_arr);
> 
> and the duplicate kfree() in dibs_lo_dev_probe()'s err_reg path that this
> patch removes. Would it be more accurate to say cc21191b584c introduced the
> problem, rather than that it "moved the code to its current location; the
> race was introduced earlier"?
> 

Hidayath,
I think, AI is right here, the original smc_loopback.c did not have such a construct.
Only cc21191b584c is to blame.
(Seems you errounously copied this from your other patch
a10ea943356b ("dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister")
Please send a v2



> With Cc: stable@vger.kernel.org present, a Fixes tag naming a v6.10-era
> net/smc commit points backports at trees where neither drivers/dibs/ nor
> dmb_clientid_arr exists, so the patch cannot apply there.
> 
> Also, the note calls this a "race", but the double free happens
> unconditionally on a deterministic error path when device_add() or
> sysfs_create_group() fails. Would "double free" be the better wording?
> 


Correct (but moot, if this paragraph is removed)


>> diff --git a/drivers/dibs/dibs_loopback.c b/drivers/dibs/dibs_loopback.c
>> index fd5caf1e19a8f..649e4e375be33 100644
>> --- a/drivers/dibs/dibs_loopback.c
>> +++ b/drivers/dibs/dibs_loopback.c
>> @@ -335,7 +335,6 @@ static int dibs_lo_dev_probe(void)
>>  	return 0;
>>  
>>  err_reg:
>> -	kfree(dibs->dmb_clientid_arr);
>>  	/* pairs with dibs_dev_alloc() */
>>  	put_device(&dibs->dev);
>>  	kfree(ldev);
> 
> [Severity: High]
> [Finding: main-5-4]
> [Sources: opus-5]
> This isn't a bug introduced by this patch, but while looking at the
> lifetime of dmb_clientid_arr: does the removal path have the same missing
> NULL assignment, and can the ISM interrupt handler read the buffer after it
> is freed?
> 


[PATCH net] net/dibs: Fix UAF of dmb_clientid_arr after dibs_dev_del()
is currently discussed on the netdev mailing list to fix this.




