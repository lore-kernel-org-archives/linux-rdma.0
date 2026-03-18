Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849782BEC45
	for <linux-rdma@vger.kernel.org>; Wed, 18 Mar 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773848094; cv=none; b=VHvd3t6L/e1v/oWuIDac2FMpuZeO0PtxLmf6LKMaxjjH7Qr5nCenHY3zID4OSQiJ2oW1M8F/Bz0HaMfkQiU2OfOoqH+1SuOEqio3tCTHcB9dT4uX93XZE2tnWEFPikXEZehOPKc6G5jJBnGPyMHiEWAcTYhyivMndxXOHZnEAYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773848094; c=relaxed/simple;
	bh=rt59Gg3+m2TMF7oLCAVogyaLAx1OH2kI2D3ISS3Ap98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d7TZxwZHF8PlzCrHyo5FaBJP38ER9AsHx+kOvoG16OD2oOup6y3SpCwAn2dJaXIJdS94dtHpUy7q5p/p4toZqq1uAeTLgdOs6xhnLUCL/9xSW2zqrP4IBSOepmu8M7CkVssEBbOKbRjQRetua+KM1UsWbJhf+HMXDJMCmJVvfvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SrbHnlX7; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SrbHnlX7"
Message-ID: <9963f346-cd53-4f88-bb54-642a5babb768@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773848089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CSL1Eeers7HS8IRM3Jn6u04oRu3qpAkavqq8I3/sH8=;
	b=SrbHnlX7DLGudGnEkHt9a/huMM0KOU6GZCYDE30GqkXeHaaRkNVyBlkuO2N2DRRF2zGOyO
	QnfncFTbSMacGSm0Msd4jORDp8zPSZxKO0vrNaj6uayLXbdRCGUNAcW4ya0h+NU2QGdsoz
	opxwv13LGGW6ycNG35dzqwlw8T1EiaU=
Date: Wed, 18 Mar 2026 08:34:42 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] RDMA/rxe: Use a dedicated and robust workqueue for
 RXE tasks
To: Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
References: <20260318025739.5058-1-yanjun.zhu@linux.dev>
 <20260318145327.GC352386@unreal>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260318145327.GC352386@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/3/18 7:53, Leon Romanovsky 写道:
> On Wed, Mar 18, 2026 at 03:57:39AM +0100, Zhu Yanjun wrote:
>> Currently, the RXE driver uses the system-wide 'system_unbound_wq' for
>> auxiliary tasks like ODP prefetching. This can lead to interference
>> from other system services and lacks guaranteed forward progress
>> under memory pressure.
>>
>> Currently make all the tasks queue into the driver-specific 'rxe_wq'.
>>
>> Suggested-by: Leon Romanovsky <leon@kernel.org>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
>> ---
>>   drivers/infiniband/sw/rxe/rxe_odp.c  |  2 +-
>>   drivers/infiniband/sw/rxe/rxe_task.c | 10 +++++++++-
>>   drivers/infiniband/sw/rxe/rxe_task.h |  1 +
>>   3 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
>> index bc11b1ec59ac..98092dcc1870 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
>> @@ -545,7 +545,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
>>   		work->frags[i].mr = mr;
>>   	}
>>   
>> -	queue_work(system_unbound_wq, &work->work);
>> +	rxe_queue_work(&work->work);
>>   
>>   	return 0;
>>   
>> diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
>> index f522820b950c..4385137eb4d7 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_task.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_task.c
>> @@ -10,7 +10,8 @@ static struct workqueue_struct *rxe_wq;
>>   
>>   int rxe_alloc_wq(void)
>>   {
>> -	rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND, WQ_MAX_ACTIVE);
>> +	rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND | WQ_MEM_RECLAIM,
> Why did you add WQ_MEM_RECLAIM flag? rxe_ib_advise_mr_prefetch() doesn't
> perform any memory reclaim.

You are correct that rxe_ib_advise_mr_prefetch() does not directly call 
memory reclaim functions.

However, the WQ_MEM_RECLAIM flag was added to prevent circular 
dependencies during

low-memory conditions.

Since rxe handles memory regions that may be part of the storage or 
network stack,

the workqueue must be able to make progress even when the system is 
under extreme

memory pressure. Without this flag, if the kernel attempts to reclaim 
memory and that

reclaim process depends on an RDMA operation being processed by this 
workqueue,

the system could deadlock because the workqueue might be unable to spawn 
a new

worker thread.

By setting WQ_MEM_RECLAIM, we ensure that a rescuer thread is pre-allocated,

guaranteeing that prefetch and MR-related tasks can complete and allow the

memory management subsystem to finish its reclaim cycle.


Zhu Yanjun

>
> Thanks

-- 
Best Regards,
Yanjun.Zhu

