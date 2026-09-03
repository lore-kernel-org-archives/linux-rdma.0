Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12847397930
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 10:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431786; cv=none; b=P/5guw2jJTZtebI8k+HUtSh65TpdVTUS/96BpBbaBnJFS4z9uPRPsl6Z+3JP3I8K3x0xnyqn32pAD/lXTubhtRfX7R4GDcqEbOcSuQbEPXVClUUmo3kXHSOHfG68vcl+anLtAkWDIBiK6psHlRAw5DDHdAi3pMgr7bqiOf1lRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431786; c=relaxed/simple;
	bh=hPnvmN+ed4I7sDQZeeSQFGf0rqmwsLQ5tR6puj11d0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFQ7RnJ7ZjONDrbxrCGVL0/YiOZ0tsrkC6rJad4OXoTkAGtR/vYXH4pQSFKyotlDHon8emhUUeESDz+IT4qF6zZXvZBlZK3ylpm73mMxP7RY5jSkPBY5xVOLv+yW6g9mbpouANIoqmvlF+fEhB1YIFppsRM+SFQ1kWvgm0HeSjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VmaW2pbH; arc=none smtp.client-ip=91.218.175.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VmaW2pbH"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hPnvmN+ed4I7sDQZeeSQFGf0rqmwsLQ5tR6puj11d0E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788431778; v=1; x=1789036578;
 b=VmaW2pbHSQQYmUZzeo6Fuz6cUqE45BE6F9JiT3QOM3Mpap78I/SVRTb9Aqi/cJ4Ds2/NFQxw
 oYySHG/cG4hJxT33zWPaN8IAhpVvMFxj6a4CgeSSLMEBsqXL4xNUv/KBsKTq4P2YKHAPMLw4k8T
 XaRIgnZKnOVy2JH6iZJbcVGc=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 75467c2e337fc301;
	Thu, 03 Sep 2026 10:36:18 +0000
X-Mizu-Trace-ID: 75467c2e337fc301
X-Migadu-Flow: FLOW_OUT
Message-ID: <98c99860-90b0-4c0f-ba09-4aa75a3bcb16@linux.dev>
Date: Thu, 3 Sep 2026 12:36:17 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/siw: Clear association under lock if
 siw_qp_modify fails in siw_accept
To: Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>, jgg@ziepe.ca,
 linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
References: <20260827125553.12831-1-guoqing.jiang@linux.dev>
 <b08cb248-e7eb-48ea-9873-02032c0ed0ff@linux.dev>
 <20260901073230.GF24140@unreal>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260901073230.GF24140@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.09.2026 09:32, Leon Romanovsky wrote:
> On Thu, Aug 27, 2026 at 03:28:20PM +0200, Bernard Metzler wrote:
>> On 27.08.2026 14:55, Guoqing Jiang wrote:
>>> We need to clear cep before release state_lock as siw_qp_llp_close and
>>> siw_qp_modify->siw_qp_llp_close did.
>>>
>>> Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
>>> is released before the error path cleanup. A concurrent ibv_modify_qp()
>>> transitioning the QP to ERROR can race in this window:
>>>
>>>     siw_accept()                       ibv_modify_qp(ERROR)
>>>     ----------------------             ----------------------
>>>     siw_qp_modify() fails
>>>     up_write(&qp->state_lock)
>>>                                        down_write(&qp->state_lock)
>>>                                        nextstate_from_idle():
>>> 				     if (qp->cep)
>>>                                          siw_cep_put(qp->cep) <- frees cep
>>>                                          qp->cep = NULL
>>>     goto error
>>>       cep->qp = NULL                   <- UAF
>>>
>>> Clear qp->cep and drop the association reference taken by siw_cep_get(),
>>> all under the write lock held from the initial down_write(&qp->state_lock).
>>> Thread B therefore sees qp->cep == NULL, skips its own put, and cannot free
>>> the cep before siw_accept() is done with it.
>>>
>>> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>>> Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>>> ---
>>> V2: remove redundant code per Bernard's review
>>>
>>>    drivers/infiniband/sw/siw/siw_cm.c | 7 +++++--
>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
>>> index 0245b25e7271..ed49818793dd 100644
>>> --- a/drivers/infiniband/sw/siw/siw_cm.c
>>> +++ b/drivers/infiniband/sw/siw/siw_cm.c
>>> @@ -1719,9 +1719,12 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>>>    			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>>>    				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>>>    				   SIW_QP_ATTR_MPA);
>>> +	if (rv) {
>>> +		qp->cep = NULL;
>>> +		siw_cep_put(cep);
>>> +		goto error_unlock;
>>> +	}
>>>    	up_write(&qp->state_lock);
>>> -	if (rv)
>>> -		goto error;
>>>    	siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
>>>    		    qp_id(qp), params->private_data_len);
>>
>> Looks good. Thank you, Guoqing.
>>
>> Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
> 
> Bernard,
> 
> I will take this patch. However, siw_accept() looks wrong to me. It
> mixes locking, qp->cep handling, and siw_cep_put() in a seemingly
> inconsistent manner.
> 
> For example, here you clear qp->cep and call siw_cep_put() while holding
> the lock, whereas in the error unwind path you do exactly the opposite.
> 
> Be aware that AI-generated suggestions for SIW are complete garbage. If
> you do not clean up these code paths, your driver will soon end up in a
> broken and unmaintainable state. The same applies to RXE.
> 
> Thanks

That's probably an accurate assessment. Thanks for your candid remarks.
I will try to clean up some obvious things.

I share you opinion on those current AI generated remarks.

Thnk you,
Bernard.
