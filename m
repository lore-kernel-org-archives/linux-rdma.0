Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06110493644
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 06:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726310; cv=none; b=jb+xiNdofsEiZsLwPQyIKgwxFiZv0n4L7NRfSS0ZoB7y/2Phya9py1PRlzeqoPx/OVD99J4cO87MVLSJoQ0kuSvDqm22bYXlKvGTgPYF45WfsH8btePAYkzXB4SiJi3HBwDBLo+VoxRw5pDDxabAzBy6DXi0tFEkxCEYA/QOg0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726310; c=relaxed/simple;
	bh=PnQ9469HILs6omf+XgmOfzmONizTzc6Is97yEJ6+nno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLxRJW2QnzZl0ykay4A18+gWVqaxb+yR/M8r8zrvHFvSU+mD15NbD0QWJHvyZFIzOZ44Kd3u8HvIq+kwgawLZR0jMkMBKsa8i/wtjOY5MAqxk3RO8DYRXOLjJLAlYIRxfZGNerkd3BShnQCtgBW2FQx8N5ybaVPFo9LOJavPcKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GrtdCUnN; arc=none smtp.client-ip=91.218.175.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GrtdCUnN"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PnQ9469HILs6omf+XgmOfzmONizTzc6Is97yEJ6+nno=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787726304; v=1; x=1788331104;
 b=GrtdCUnNKbG3Qdj0YXpqRXSC8uymq3V7az4N6LwTTuRgFWSJnWvTJeWb4GNP0nb94opWma1w
 hVmT4OakJq+4pbD42FDE3tR8W9O7pfPHkGBHji0uBBRkYJVO3ob9Cr/YyV54hZw9RdM7r0rA1az
 davjZ8RP56qx4je4LKHzVgbo=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [192.168.38.216] (123.123.45.164)
	by smtp.migadu.com with ESMTPS id 493f16deaf9ca199;
	Wed, 26 Aug 2026 06:38:24 +0000
X-Mizu-Trace-ID: 493f16deaf9ca199
X-Migadu-Flow: FLOW_OUT
Message-ID: <05b91f98-e3a3-793a-9197-f09d84acfaf7@linux.dev>
Date: Wed, 26 Aug 2026 14:38:15 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] RDMA/siw: Clear association under lock if siw_qp_modify
 fails in siw_accept
To: Bernard Metzler <bernard.metzler@linux.dev>, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
References: <20260825130954.27327-1-guoqing.jiang@linux.dev>
 <de7ccaed-e270-459b-a34a-d32b2b2ce4e8@linux.dev>
Content-Language: en-US
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <de7ccaed-e270-459b-a34a-d32b2b2ce4e8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Bernard,

On 8/25/26 21:53, Bernard Metzler wrote:
> On 25.08.2026 15:09, Guoqing Jiang wrote:
>> We need to clear qp and cep before release state_lock as 
>> siw_qp_llp_closeo
>> and siw_qp_modify->siw_qp_llp_close did.
>>
>> Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
>> is released before the error path cleanup. A concurrent ibv_modify_qp()
>> transitioning the QP to ERROR can race in this window:
>>
>>    siw_accept()                       ibv_modify_qp(ERROR)
>>    ----------------------             ----------------------
>>    siw_qp_modify() fails
>>    up_write(&qp->state_lock)
>> down_write(&qp->state_lock)
>>                                       nextstate_from_idle():
>>                      if (qp->cep)
>>                                         siw_cep_put(qp->cep) <- frees 
>> cep
>>                                         qp->cep = NULL
>>    goto error
>>      cep->qp = NULL                   <- UAF
>>
>> Clear qp->cep and cep->qp, and drop the association reference taken by
>> siw_cep_get(), all under the write lock held from the initial
>> down_write(&qp->state_lock). Thread B therefore sees qp->cep == NULL,
>> skips its own put, and cannot free the cep before siw_accept() is done
>> with it.
>>
>> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>> Link: 
>> https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>> ---
>>   drivers/infiniband/sw/siw/siw_cm.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/sw/siw/siw_cm.c 
>> b/drivers/infiniband/sw/siw/siw_cm.c
>> index 0245b25e7271..1573f2e888b2 100644
>> --- a/drivers/infiniband/sw/siw/siw_cm.c
>> +++ b/drivers/infiniband/sw/siw/siw_cm.c
>> @@ -1719,9 +1719,13 @@ int siw_accept(struct iw_cm_id *id, struct 
>> iw_cm_conn_param *params)
>>                  SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>>                      SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>>                      SIW_QP_ATTR_MPA);
>> +    if (rv) {
>> +        cep->qp = NULL;
> This can better be omitted since done in error_unlock path
> anyway and is redundant otherwise.

Right, thanks for the review! And probably call siw_cep_put before set 
qp->cep to
NULL as other places did.

> It would also better retain the logic of calling siw_qp_put(qp) right 
> after
> clearing cep's reference to the qp, as done in error path.

I suppose this change could be okay.

@@ -1719,9 +1719,12 @@ int siw_accept(struct iw_cm_id *id, struct 
iw_cm_conn_param *params)
                            SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
                                    SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
                                    SIW_QP_ATTR_MPA);
+       if (rv) {
+               siw_cep_put(cep);
+               qp->cep = NULL;
+               goto error_unlock;
+       }
         up_write(&qp->state_lock);
-       if (rv)
-               goto error;

I am wondering if there is another use-after-free case in 
siw_qp_cm_drop. Because
the beginning of siw_qp_cm_drop borrows the qp->cep pointer without 
holding a
reference. If another thread put the last reference of cep, then 
siw_qp_cm_drop
wakes and deferences cep which has been freed.

>
> Thank you!
> Bernard.> +        qp->cep = NULL;
>> +        siw_cep_put(cep);
>> +        goto error_unlock;
>> +    }
>>       up_write(&qp->state_lock);
>> -    if (rv)
>> -        goto error;
>>         siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
>>               qp_id(qp), params->private_data_len);

Thanks,
Guoqing
