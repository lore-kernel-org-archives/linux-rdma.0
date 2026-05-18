Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C251A2392
	for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 18:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779130761; cv=none; b=hyhdx2hYakiSCGcSjdml2p+J4qaWtgLsPMmuAr2a7YkyoOalUXgqCT7Qkm/rTK4ql3l34sRp2/GFdQ3E58D9lP9F0MU4/TEn1wxlx/C7NjzrOIwsKfvS4lyx4tXbxYdKw61CNokTzcgk1ZM0ZcLV4viGYa6FW8BamAPkKy/f0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779130761; c=relaxed/simple;
	bh=UEft3WY5Gmk+Qy0997MWOoS5bTqKPHQpyWMfHOt7Zps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J57zOzLseyiAdz0wE+4xl/RHh0HUIMRWbyC+aOJ+EJqyP3gReLV/ETyS3GPHqZ96L4QsZBBjJgiqcJ05TRVsAftIoLQFqOjgjncd96AsaZ4O0FAmGrEPtr5pinPvzuOebhfE5mw8BseTllJjhZ/JAj7Yckhv0Eexs9d6dDQoacs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pTiiXzq2; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pTiiXzq2"
Message-ID: <e06988e3-97f2-48ae-9358-932af4e840d4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779130756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oSf+LGF5W/Gz1vcJGj9mDkU0de611D0MsevGsuiqTG4=;
	b=pTiiXzq24qKl541sJMcXihrpSzfTdF9ozlkm5kPFwcMGuar8UTxvW2PYQUEaUUFYiZQ+hY
	1q5BNWNn7OZaDiloujwgVbkrQn3omrpXN9TIfYOUkGKh81cmCOA0+6m6ieB2OngXS1U1Xv
	x6y74RRsVB9Uns8XBumBcjb9A8heEmY=
Date: Mon, 18 May 2026 11:59:12 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] RDMA/rxe: Fix Use-After-Free problem in rxe_net_del
To: Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
 syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
References: <20260517044747.475621-1-yanjun.zhu@linux.dev>
 <20260518113913.GO33515@unreal>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260518113913.GO33515@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 5/18/26 4:39 AM, Leon Romanovsky wrote:
> On Sun, May 17, 2026 at 06:47:47AM +0200, Zhu Yanjun wrote:
>> +	rxe_ns_lock(net);
>> +
>>   	sk = rxe_ns_pernet_sk4(net);
>>   	if (sk)
>>   		rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);
>> @@ -663,6 +665,8 @@ void rxe_net_del(struct ib_device *dev)
>>   	if (sk)
>>   		rxe_sock_put(sk, rxe_ns_pernet_set_sk6, net);
>>   
>> +	rxe_ns_unlock(net);
>> +
>>   	dev_put(ndev);
>>   }
>>   
>> diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
>> index 8b9d734229b2..799a727bc1fe 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_ns.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_ns.c
>> @@ -16,6 +16,7 @@
>>   struct rxe_ns_sock {
>>   	struct sock __rcu *rxe_sk4;
>>   	struct sock __rcu *rxe_sk6;
>> +	struct mutex	release_lock;
> 
> This change renders the existing rcu_read_lock() and rcu_read_unlock()
> calls unnecessary.

Thanks, Leon. I fully agree with you.
In the next version, I will remove the existing rcu locks.

Zhu Yanjun

> 
> Thanks

