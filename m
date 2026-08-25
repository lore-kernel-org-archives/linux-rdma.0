Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEBD3D5673
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649080; cv=none; b=u+KKjdAmR6Dmkwj8iCJSO6pUN0Yuru6tI47k9Znl8ijxcoCPzw7smU3Olks3Vhsb6BQQfweAQzHol7l0JdlhFLPhuWoXilbVpRYkF1taDjaj3kAkbszpvNnmI+Lhfm2KGhq8/6oruDcylIxcW6M7J1JctVt8jk0Zo5pRmzXWEf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649080; c=relaxed/simple;
	bh=JuWDoKHZ2bnsbiKF1lOc6Dz6iYhV+sugWR+1vGSNmVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlPmv2ufCGpyqmIyBEriYwbA0Xboiek6cJ4TjAciVSbN1Byj6PZ658rrv6wTXQyPmvqGkmCwn5zs/LoQK9QnVWJhMScNS7IwMjeDhQjwQKWohv696fllMZTsk1im+gAdl55QYJJ0qgGP8Czg1TMcLWdy9VpW99ZfqhbHPOWYh3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WbvXIS04; arc=none smtp.client-ip=91.218.175.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WbvXIS04"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JuWDoKHZ2bnsbiKF1lOc6Dz6iYhV+sugWR+1vGSNmVo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787649076; v=1; x=1788253876;
 b=WbvXIS04pLCrYqeabx0taBZXUTG53r5Hk6BoI2Gm585DD5Tne612qFT9vbRU+Fjm4M1t3Oo8
 SrKVS9UX8J19QTdIkt37wUilu0npQd2XPSJbEBjoMnIv39+Gn3vMEu9H+qFbIdUniGzsbkzfkfp
 Cg4yeDSxT7EVDXD+vYD4T7jw=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [192.168.38.216] (123.123.40.40)
	by smtp.migadu.com with ESMTPS id e89364679e9dc4d3;
	Tue, 25 Aug 2026 09:11:06 +0000
X-Mizu-Trace-ID: e89364679e9dc4d3
X-Migadu-Flow: FLOW_OUT
Message-ID: <d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev>
Date: Tue, 25 Aug 2026 17:11:00 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [BUG] RDMA/siw: KASAN: slab-use-after-free in siw_accept
Content-Language: en-US
To: Bernard Metzler <bernard.metzler@linux.dev>,
 Shuangpeng Bai <shuangpeng.kernel@gmail.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260821194704.835548-1-shuangpeng.kernel@gmail.com>
 <3702388e-3eb9-5f62-f2ae-cac3a01be716@linux.dev>
 <4aa8833a-ab7d-4034-a299-414c3e11ed1d@linux.dev>
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <4aa8833a-ab7d-4034-a299-414c3e11ed1d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 8/24/26 23:24, Bernard Metzler wrote:
>>
>> I suppose it is necessary to clear qp and cep before release 
>> state_lock since both siw_qp_llp_close and
>> siw_qp_modify->siw_qp_llp_close hold the lock during close cep, 
>> something like
>>
>> @@ -1719,6 +1719,16 @@ int siw_accept(struct iw_cm_id *id, struct 
>> iw_cm_conn_param *params)
>>                             SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>>                                     SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>>                                     SIW_QP_ATTR_MPA);
>> +       if (rv) {
>> +               cep->qp = NULL;
>> +               qp->cep = NULL;
>> +               siw_cep_put(cep);
>> +       }
>>          up_write(&qp->state_lock);
>>
> Thanks Guoqing, that should fix it. But even better if we
> goto error_unlock directly and remove the now obsolete
> 'if (rv != 0) goto error' below. 

That is cleaner, thanks for the suggestion.

> Can you pls provide a new patch? 

Sure, will do.

Thanks,
Guoqing
