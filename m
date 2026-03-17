Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06DB3E8677
	for <linux-rdma@vger.kernel.org>; Tue, 17 Mar 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773758344; cv=none; b=rEvk/ra0YEFt1KauecUle1Ti4SszLJc1RkhIFXr/PR5Yp1CN/eZ8SfVSNvW26Iwp+1xT0mHZgTB+8FtTDWLvIVHljpstwJv2++4dGKGDPeVab5DapN/1xOG/MjKkMcvTOPpty6Zs0Z/ip25aryH4D73Z3KCFphUCpKSRC3lwinU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773758344; c=relaxed/simple;
	bh=A147bc2bT4KeYZIRrgqu8fITAQVo9jfiIw91PSZaPR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZ+oqh5AtXh8WLwXqgWqLwep+mxVFlVy5TI4NI/zLuPoVcm50HnuqUL6MVIHo0wtZIq2WoE0bGqOsnV1O5BUBmEmPjlpyI18VD8Wr87so+Z5YTYibaXsHAQl77IVS9n9qBCmZJzCDPhmVcgZssDQbb1HuR8b+mDTeOGAPPSluNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k6Sjz6TS; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k6Sjz6TS"
Message-ID: <c5374d12-84ed-4298-92d3-90062988f68d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773758340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63wRMo0FngaKINvt5+DIgmP+fsqgLbRaWZ8w/1faLk8=;
	b=k6Sjz6TSdC2nyKK9J9E+a8l366kISxnRJfdxzpVkQlPVTK/IWd0VPDIiPnVsblmcjLK10M
	ys1G65d5PpN3bhe92/K0dHRc7WJ3ElveCMa+WXW46uw/+EDJ0YYyeagk0so/h4qtEXG8Bt
	4EP6xNeD+esG33CS6wCEbQVw2N/Z72g=
Date: Tue, 17 Mar 2026 07:38:49 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] RDMA/rxe: Replace use of system_unbound_wq with
 system_dfl_wq
To: Leon Romanovsky <leon@kernel.org>,
 Marco Crivellari <marco.crivellari@suse.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Michal Hocko <mhocko@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <20260313154023.298325-1-marco.crivellari@suse.com>
 <20260316201301.GL61385@unreal>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260316201301.GL61385@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/3/16 13:13, Leon Romanovsky 写道:
> On Fri, Mar 13, 2026 at 04:40:23PM +0100, Marco Crivellari wrote:
>> This patch continues the effort to refactor workqueue APIs, which has begun
>> with the changes introducing new workqueues and a new alloc_workqueue flag:
>>
>>     commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>>     commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
>>
>> The point of the refactoring is to eventually alter the default behavior of
>> workqueues to become unbound by default so that their workload placement is
>> optimized by the scheduler.
>>
>> Before that to happen, workqueue users must be converted to the better named
>> new workqueues with no intended behaviour changes:
>>
>>     system_wq -> system_percpu_wq
>>     system_unbound_wq -> system_dfl_wq
>>
>> This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
>> removed in the future.
> 
> I recall earlier efforts to replace system workqueues with per‑driver queues,
> because unloading a driver forces a flush of the entire system workqueue,
> which is undesirable for overall system behavior.
> 
> Wouldn't it be better to introduce a local workqueue here and use that instead?

Thanks.

1.The initialization should be:

my_wq = alloc_workqueue("my_driver_queue", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
if (!my_wq)
     return -ENOMEM;

2. The Submission should be:

queue_work(my_wq, &my_work);

3. Destroy should be:

destroy_workqueue()

Thanks,
Zhu Yanjun

> 
> Thanks
> 
>>
>> Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
>> Suggested-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
>> ---
>>   drivers/infiniband/sw/rxe/rxe_odp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
>> index bc11b1ec59ac..d440c8cbaea5 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
>> @@ -545,7 +545,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
>>   		work->frags[i].mr = mr;
>>   	}
>>   
>> -	queue_work(system_unbound_wq, &work->work);
>> +	queue_work(system_dfl_wq, &work->work);
>>   
>>   	return 0;
>>   
>> -- 
>> 2.53.0
>>

