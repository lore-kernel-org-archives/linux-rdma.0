Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F63F37E301
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 13:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787750159; cv=none; b=tYiFUBW34w6MK5sGss8mf5q8o43sCjFm/Uu/prU+HTDlKFp21ErfbYqbh2v0FraHd62qbO0575jtfPdiBgUBU0bGKknfjdArs/5yH7r+6mjQxXwEJoi+BITNom9JC9o2gCoGJVzdkCl1TJoKdGCzPzVhQj87p+trPA2ZxsQQh30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787750159; c=relaxed/simple;
	bh=xxUY0ybzS7rmSHwnDjKDvikujyYdDZ07AUWzJLup0HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rHwkpInD7Y6thmRdyn7aTFzrqtDitJqIIlTXkFXtBFcJMFRAUhaFMFV7sZNpLA6I7K/KXyAYezujKMg1t8cqiVQXTSQAOe+yE2hpS+P0XuR9EoZExtQ7fuZQYHKiPJOrx8//ZgM9BAaIeLyxrp4uSId9ul+us3P5giVsn1WPlfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sNwz7g7v; arc=none smtp.client-ip=91.218.175.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sNwz7g7v"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xxUY0ybzS7rmSHwnDjKDvikujyYdDZ07AUWzJLup0HU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787750154; v=1; x=1788354954;
 b=sNwz7g7vA/qGNK3RyXbwWiUYGTmadsJGyizD1DPHsgG/q3XAm1TDlg24SQNzldUEYT+9HzlV
 tgd7kjDRIDwUtQBZBCvtM9Te6kiiy6bW3uGWRdlHPCxR3TPrvHNYwVLxUmQ9DJq4+gwkBGQRAQ2
 ca7V/XzhZDzjalLG2SZvFsI0=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [192.168.38.216] (123.123.45.164)
	by smtp.migadu.com with ESMTPS id 54c21eb5f529f479;
	Wed, 26 Aug 2026 13:15:54 +0000
X-Mizu-Trace-ID: 54c21eb5f529f479
X-Migadu-Flow: FLOW_OUT
Message-ID: <5cfe3bc7-0ccf-67c9-aee4-7fdec0c5fb02@linux.dev>
Date: Wed, 26 Aug 2026 21:15:47 +0800
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
 <05b91f98-e3a3-793a-9197-f09d84acfaf7@linux.dev>
 <04ee2054-b5a6-41c3-9493-e5a6df338453@linux.dev>
Content-Language: en-US
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <04ee2054-b5a6-41c3-9493-e5a6df338453@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/26/26 20:19, Bernard Metzler wrote:
> On 26.08.2026 08:38, Guoqing Jiang wrote:
>> Hi Bernard,
>>
>> On 8/25/26 21:53, Bernard Metzler wrote:
>>> On 25.08.2026 15:09, Guoqing Jiang wrote:
>>>> We need to clear qp and cep before release state_lock as 
>>>> siw_qp_llp_closeo
>>>> and siw_qp_modify->siw_qp_llp_close did.
>>>>
>>>> Otherwise if siw_qp_modify() fails in siw_accept(), the QP's 
>>>> state_lock
>>>> is released before the error path cleanup. A concurrent 
>>>> ibv_modify_qp()
>>>> transitioning the QP to ERROR can race in this window:
>>>>
>>>>    siw_accept()                       ibv_modify_qp(ERROR)
>>>>    ----------------------             ----------------------
>>>>    siw_qp_modify() fails
>>>>    up_write(&qp->state_lock)
>>>> down_write(&qp->state_lock)
>>>>                                       nextstate_from_idle():
>>>>                      if (qp->cep)
>>>> siw_cep_put(qp->cep) <- frees cep
>>>>                                         qp->cep = NULL
>>>>    goto error
>>>>      cep->qp = NULL                   <- UAF
>>>>
>>>> Clear qp->cep and cep->qp, and drop the association reference taken by
>>>> siw_cep_get(), all under the write lock held from the initial
>>>> down_write(&qp->state_lock). Thread B therefore sees qp->cep == NULL,
>>>> skips its own put, and cannot free the cep before siw_accept() is done
>>>> with it.
>>>>
>>>> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>>>> Link: 
>>>> https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
>>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>>>> ---
>>>>   drivers/infiniband/sw/siw/siw_cm.c | 8 ++++++--
>>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/sw/siw/siw_cm.c 
>>>> b/drivers/infiniband/sw/siw/siw_cm.c
>>>> index 0245b25e7271..1573f2e888b2 100644
>>>> --- a/drivers/infiniband/sw/siw/siw_cm.c
>>>> +++ b/drivers/infiniband/sw/siw/siw_cm.c
>>>> @@ -1719,9 +1719,13 @@ int siw_accept(struct iw_cm_id *id, struct 
>>>> iw_cm_conn_param *params)
>>>>                  SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>>>>                      SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>>>>                      SIW_QP_ATTR_MPA);
>>>> +    if (rv) {
>>>> +        cep->qp = NULL;
>>> This can better be omitted since done in error_unlock path
>>> anyway and is redundant otherwise.
>>
>> Right, thanks for the review! And probably call siw_cep_put before 
>> set qp->cep to
>> NULL as other places did.
>>
>>> It would also better retain the logic of calling siw_qp_put(qp) 
>>> right after
>>> clearing cep's reference to the qp, as done in error path.
>>
>> I suppose this change could be okay.
>>
>> @@ -1719,9 +1719,12 @@ int siw_accept(struct iw_cm_id *id, struct 
>> iw_cm_conn_param *params)
>>                             SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>>                                     SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>>                                     SIW_QP_ATTR_MPA);
>> +       if (rv) {
>> +               siw_cep_put(cep);
>> +               qp->cep = NULL;
>> +               goto error_unlock;
>> +       }
>>          up_write(&qp->state_lock);
>> -       if (rv)
>> -               goto error;
>>
> That looks good, while I think we should always NULL a pointer to
> something before releasing a hold/reference to it. Putting the reference
> implies a memory barrier and so it's guaranteed others see that NULL 
> as well.

Hmm, good point.

> You are right - there are places where this is not done as it should.
>
>> I am wondering if there is another use-after-free case in 
>> siw_qp_cm_drop. Because
>> the beginning of siw_qp_cm_drop borrows the qp->cep pointer without 
>> holding a
>> reference. If another thread put the last reference of cep, then 
>> siw_qp_cm_drop
>> wakes and deferences cep which has been freed.
>>
> Let's put this in an extra thread. You may have a point ;)

I will dig a little bit more before start a new thread.

Thanks,
Guoqing
