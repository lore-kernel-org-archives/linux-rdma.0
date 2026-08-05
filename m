Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CE2352000;
	Wed,  5 Aug 2026 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785910861; cv=none; b=lmuhbJgRF2yDks4uUfQ5hbts9D5TP1Dsc3hClpgkoH9JgR0yE3u6IT81yNz8Gk25GRpvgIvRt7NB0NJmd0kSBuEqx9mpJ9ToPZRZlrR0ZGhb0DRZyp1GpuNh1S8sd/ZgXaRRsYwCJhaBwipoZ4eqbHV/GlmG4kXQSb14Ghwu7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785910861; c=relaxed/simple;
	bh=Y5YHJTXwYMgw2m3rBql18Bkwey74ZBrdvAUgNY7I8mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XfcadD+Rl6NAkLoLYT7Jz2h+cM3q0yOUqPWbDOqs3aL2f8MxQfo6zVkfb+hXE0OAwnN9d1Y8bAQY+zePnyHajNy7veeR5660yqw+a+csc7VjVNgfG67eqTVEYGe3pRpRIODYZ4x/HlCMTnJXHjUcA9E9nK/FcqJM8cFlfqee/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TQvmNCO9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TQvmNCO9"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mn4C2911067;
	Wed, 5 Aug 2026 06:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8lsoYN
	Il1osl+w8vUhovpDMRwV6cG/yO8VTKdza3zic=; b=TQvmNCO9CTLif4gPFFdd6z
	Z/xUBXFDPP+isukispSlP58G4lQ4P/7fWWyv8rj0TGx9TpI06I2wpULRBBIHW0Rh
	zAACBTAblPEbRKcz/k1k+Ruinr/5691qOafn3+pUl0Es0QW9x0zMqw1FKwLd9fdJ
	VsQUMy8rDWbDefIAsicCLb5uZvSbt64Cq+/Hcj1mc7oVmSOchXpb1Fw0qCsVK/wR
	n8iQp6qXafrTZfCjxzT8zikDYiL5ZnwdfDu5d0RjljFooR43ITN41KRNXVe/iIoy
	5k9ePX0i9mKwJrcuQVlwZ9n6tqHSqzmstjWuCgwbRPE6uCFaSZ2U4je6rZUSKJIw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77g98jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:20:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756BH68009135;
	Wed, 5 Aug 2026 06:20:49 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbgd3sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:20:49 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756Kjr027198144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:20:47 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4955A5805C;
	Wed,  5 Aug 2026 06:20:45 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7E9258060;
	Wed,  5 Aug 2026 06:20:37 +0000 (GMT)
Received: from [9.123.4.72] (unknown [9.123.4.72])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:20:37 +0000 (GMT)
Message-ID: <079113de-89a4-4727-b381-5072b55faf1a@linux.ibm.com>
Date: Wed, 5 Aug 2026 11:50:36 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] dibs: initialise dibs->lock in dibs_dev_alloc()
To: Simon Horman <horms@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wintera@linux.ibm.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
        mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260730124227.167829-1-hidayath@linux.ibm.com>
 <20260804170206.526356-1-horms@kernel.org>
Content-Language: en-GB
From: Hidayathulla Khan I <hidayath@linux.ibm.com>
In-Reply-To: <20260804170206.526356-1-horms@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX5/TnYCXAfIEz
 bLahlhE7YxDCcLe10epKv87nk2I7iJuMNSgcL0qV3plMdnMCRgeVLMRHhEjxFW6pjJpXvf8YzOc
 OI1yVf/cKdjnJi2sHOwtoaaKAciQ+o2/L0OmvMamh2mFHtM7x7gJMuitpYRHF2FbV3xKgyg2ANU
 wGkFrD5c6OTX8fdb5QSZe0hmWHhQSmXAaU5jVYBF9f9mibxwCst6zt/qip450qQvZq7hBQ2Shov
 X7pLed/ojJJwEbOpu290uy0l4/MvHtY5Ee0q6OgPo/oVLbckk/FY40HlL2kwHJmGe94KDu+nuSr
 cMJKqVqhB1WvcREgTYVHG2iLHlzTnHNRFF3YNnCz30TaGOT7WyREH/eZZjPU2JXbLg4HH8hdWPL
 8oldsA8ZsZGejx1fse4KWY2La4D9kCHcByfIZnhDcU82Oc0reI1Q5EWMF3PHs66XHaTY/EWUDUA
 L4tydqbf6HRTj+ROsGg==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a72d642 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=9R54UkLUAAAA:8
 a=VnNF1IyMAAAA:8 a=b25_ZEiJ2tfv91LfQsQA:9 a=QEXdDO2ut3YA:10
 a=YTcpBFlVQWkNscrzJ_Dz:22
X-Proofpoint-GUID: vi4j5HFivX1U5a08-sjxJcMmhbMhGrO8
X-Proofpoint-ORIG-GUID: spb2l6T_3BIq2LTrcbz3TmmWRE_7RGO5
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX1OhKP+4+doDV
 m1zIOk0uFAeb3o5SSUBSPXDSwxdv6dNf6W2zzZOJIwGTBtFWZWYN8pLNEkn5Dl4zNBg+ukpO1u/
 7MVb503NQodCq8xwUH4FpG6VAmnaP8c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047

Thanks for the review.

Finding: main-3-1: Confirmed. This issue is already being addressed by 
Alexandra Winter in a separate patch.

Finding: main-3-0: Already addressed by the following patches on the 
netdev mailing list.

[PATCH net] dibs: fix double free of dmb_clientid_arr
[PATCH net] net/dibs: Fix UAF of dmb_clientid_arr after dibs_dev_del()

Neither issue is introduced by this patch.

On 04/08/26 10:32 pm, Simon Horman wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260730124227.167829-1-hidayath@linux.ibm.com?part=1
> ---
> --- Patch [1]: [PATCH net] dibs: initialise dibs->lock in dibs_dev_alloc() ---
> commit d5daf0b54be512c77adffebc7ed60dee0c5e8e74
> Author: Hidayath Khan <hidayath@linux.ibm.com>
>
> dibs: initialise dibs->lock in dibs_dev_alloc()
>
> This moves spin_lock_init(&dibs->lock) from dibs_dev_add() into
> dibs_dev_alloc(), so the lock is valid as soon as a driver can hand the
> device to its interrupt handler, and updates the dibs_dev_alloc()
> kerneldoc accordingly.
>
> While looking at the surrounding lifetime rules for struct dibs_dev, two
> questions came up about pre-existing behaviour in the same area.
>
>> diff --git a/drivers/dibs/dibs_main.c b/drivers/dibs/dibs_main.c
>> index 14c3e2d84902e..4c26fd06973f7 100644
>> --- a/drivers/dibs/dibs_main.c
>> +++ b/drivers/dibs/dibs_main.c
>> @@ -138,6 +138,7 @@ struct dibs_dev *dibs_dev_alloc(void)
>>   	dibs = kzalloc_obj(*dibs);
>>   	if (!dibs)
>>   		return dibs;
>> +	spin_lock_init(&dibs->lock);
>>   	dibs->dev.release = dibs_dev_release;
>>   	dibs->dev.class = &dibs_class;
>>   	device_initialize(&dibs->dev);
> [Severity: High]
> [Finding: main-3-1]
> [Sources: opus-5]
> This isn't a bug introduced by this patch, but since the commit message
> argues about ism_handle_irq() running before dibs_dev_add(), does the
> mirror-image window at teardown need the same attention?
>
> ism_remove() tears things down in this order:
>
> drivers/s390/net/ism_drv.c:ism_remove() {
> 	...
> 	dibs_dev_del(dibs);
> 	ism_dev_exit(ism);
> 	/* pairs with dibs_dev_alloc() */
> 	put_device(&dibs->dev);
> }
>
> and ism_dev_exit() only disarms the interrupt as its last step:
>
> drivers/s390/net/ism_drv.c:ism_dev_exit() {
> 	...
> 	unregister_ieq(ism);
> 	unregister_sba(ism);
> 	free_irq(pci_irq_vector(pdev, 0), ism);
> }
>
> unregister_sba() frees the SBA and sets ism->sba = NULL, but the handler
> writes through it unconditionally on entry:
>
> drivers/s390/net/ism_drv.c:ism_handle_irq() {
> 	spin_lock(&dibs->lock);
> 	ism->sba->s = 0;
> 	...
> }
>
> Likewise unregister_ieq() frees the IEQ buffer and NULLs ism->ieq, while
> ism_handle_event() dereferences it in the loop condition:
>
> 	while ((ism->ieq_idx + 1) != READ_ONCE(ism->ieq->header.idx)) {
>
> Is there anything that serializes ism_handle_irq() against those frees?
> dibs->lock is the only lock the handler takes, and unregister_ieq() /
> unregister_sba() never take it, so an MSI serviced on another CPU during
> ism_remove() looks like it can write to a freed/NULL sba and read a freed
> ieq in hardirq context. Would calling free_irq() (or synchronize_irq())
> before releasing the structures the handler consumes close this?
>
> The same ordering shows up on the probe error path: dibs_dev_add() failure
> frees dmb_clientid_arr and returns to ism_probe(), which only reaches
> ism_dev_exit() (and thus free_irq()) afterwards.
>
>> @@ -186,7 +187,6 @@ int dibs_dev_add(struct dibs_dev *dibs)
>>   	int i, ret;
>>   
>>   	max_dmbs = dibs->ops->max_dmbs();
>> -	spin_lock_init(&dibs->lock);
>>   	dibs->dmb_clientid_arr = kzalloc(max_dmbs, GFP_KERNEL);
>>   	if (!dibs->dmb_clientid_arr)
>>   		return -ENOMEM;
> [Severity: High]
> [Finding: main-3-0]
> [Sources: opus-5]
> This is a pre-existing issue and not something this patch changes, but
> while the ownership rules of dibs_dev_add() are in view: can
> dmb_clientid_arr be freed twice on the loopback probe error path?
>
> dibs_dev_add() frees the array on every failure after the allocation and
> leaves the pointer in place:
>
> drivers/dibs/dibs_main.c:dibs_dev_add() {
> 	...
> 	ret = device_add(&dibs->dev);
> 	if (ret)
> 		goto free_client_arr;
> 	...
> err_device_del:
> 	device_del(&dibs->dev);
> free_client_arr:
> 	kfree(dibs->dmb_clientid_arr);
> 	return ret;
> }
>
> and dibs_lo_dev_probe() frees it again:
>
> drivers/dibs/dibs_loopback.c:dibs_lo_dev_probe() {
> 	ret = dibs_dev_add(dibs);
> 	if (ret)
> 		goto err_reg;
> 	...
> err_reg:
> 	kfree(dibs->dmb_clientid_arr);
> 	/* pairs with dibs_dev_alloc() */
> 	put_device(&dibs->dev);
> 	kfree(ldev);
> }
>
> The early -ENOMEM return is harmless because the pointer is still NULL,
> but a device_add() or sysfs_create_group() failure would reach the same
> slab object twice. The two callers also disagree here: ism_probe()'s
> err_ism / err_dibs paths do not repeat the kfree(). Would setting
> dibs->dmb_clientid_arr = NULL after the kfree() in dibs_dev_add(), or
> documenting who owns the array on failure, resolve the mismatch?
>
> Also, dibs_dev_del() ends with kfree(dibs->dmb_clientid_arr) without
> clearing the pointer, while ism_handle_irq() reads it for any set DMB bit:
>
> drivers/s390/net/ism_drv.c:ism_handle_irq() {
> 	...
> 	client_id = dibs->dmb_clientid_arr[bit];
> 	if (unlikely(client_id == NO_DIBS_CLIENT ||
> 		     !dibs->subs[client_id]))
> 	...
> }
>
> Since client_id comes straight from that buffer and is used unchecked as
> an index into the 8-entry subs[] array before an indirect call, does a
> post-free interrupt here read freed memory and potentially index past the
> end of struct dibs_dev?
>
> [ ... ]
>
