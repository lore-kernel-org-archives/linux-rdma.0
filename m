Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F35A3CF02D
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 03:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788493236; cv=none; b=EAIdyFwR3P5GCTO0xYdXO0R+aGyWWxqqGE072hQAO2A/xzhTWuyvfYZNyiAxYkfHGkB9KsRx0yOUH7kj/ze/JMeNTEToM8DKaHWVGRCuzPKbHgBL73EoyQ4zSkrmczb3YbFscmnSeW0jLCld5TOdeB+2GgWfvDdhhB9GHIWwECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788493236; c=relaxed/simple;
	bh=NNVpWv/Kk2hFa0bWXWO0XL+uoPG38XjcfbL5Jv3zzy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFbs8wBSCUnILxuZSZ6+kwatRVubNu22rXTA0kjZl2YB9C9iXJ5hVDoS281lTcXDaVaHXBs0TMIDS01LLugAnOaqkd81oy39v0xIKTwXs6edn4OusY8vsoRz1ykD8XsXGkT8nd4hEDty2mI370DIuHj3mxe470wQA6yzXuPEpvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YhL9m56X; arc=none smtp.client-ip=95.215.58.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YhL9m56X"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NNVpWv/Kk2hFa0bWXWO0XL+uoPG38XjcfbL5Jv3zzy0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788493232; v=1; x=1789098032;
 b=YhL9m56XjhPXvRCA1DkmJ9fgt5fm2nrSiUDtv/c9Odb0BoLdWoSqJog7k34tmW+N5KL9PVcV
 mhLEM6Y4Zth6uZ+RQ28KdxmxItII63YP6QGOrYMR32I1h85VszbUfpQykVhqvG+Ja52fPVDW3x8
 RHCYbHBDMHdJnla28iKhoUSI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2e79bd444d517d91;
	Fri, 04 Sep 2026 03:40:32 +0000
X-Mizu-Trace-ID: 2e79bd444d517d91
X-Migadu-Flow: FLOW_OUT
Message-ID: <f81c6142-1a36-4dcd-bbd3-8daac9df24b5@linux.dev>
Date: Thu, 3 Sep 2026 20:40:25 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/siw: Clear association under lock if
 siw_qp_modify fails in siw_accept
To: Leon Romanovsky <leon@kernel.org>,
 Bernard Metzler <bernard.metzler@linux.dev>,
 Zhu Yanjun <zyjzyj2000@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>, jgg@ziepe.ca,
 linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
References: <20260827125553.12831-1-guoqing.jiang@linux.dev>
 <b08cb248-e7eb-48ea-9873-02032c0ed0ff@linux.dev>
 <20260901073230.GF24140@unreal>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260901073230.GF24140@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/1 0:32, Leon Romanovsky 写道:
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

Agree with you. Thanks a lot.

Zhu Yanjun

> 
> Thanks

