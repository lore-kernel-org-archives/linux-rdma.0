From: Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] complib/cl_timer.c: fixing cl_timer calculation
Date: Tue, 24 Aug 2010 14:55:31 +0300
Message-ID: <4C73B333.3080007@dev.mellanox.co.il>
References: <4C7287C8.1040106@dev.mellanox.co.il> <20100823185529.GG5837@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100823185529.GG5837@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tzachi Dar <tzachid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 23-Aug-10 9:55 PM, Sasha Khapyorsky wrote:
> On 17:38 Mon 23 Aug     , Yevgeny Kliteynik wrote:
>> When calculating p_timer->timeout.tv_sec and p_timer->timeout.tv_nsec,
>> the carry was ignored, resulting in wrong value in p_timer->timeout.tv_sec,
>> and value>  10^9 in p_timer->timeout.tv_nsec (illegal value).
> 
> Nice catch. And I also see a similar issue in cl_timer_trim().
> 
> See a comments about the patch below.
> 
>>
>> Signed-off-by:  Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>
>> ---
>>   opensm/complib/cl_timer.c |    8 +++++---
>>   1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/opensm/complib/cl_timer.c b/opensm/complib/cl_timer.c
>> index 2acdb51..09a5584 100644
>> --- a/opensm/complib/cl_timer.c
>> +++ b/opensm/complib/cl_timer.c
>> @@ -299,7 +299,8 @@ cl_status_t cl_timer_start(IN cl_timer_t * const p_timer,
>>   {
>>   	struct timeval curtime;
>>   	cl_list_item_t *p_list_item;
>> -	uint32_t delta_time = time_ms;
>> +	uint32_t delta_time_sec = time_ms / 1000;
>> +	uint32_t delta_time_usec = (time_ms % 1000) * 1000;
> 
> In order to prevent compatibility and porting issues would it be better
> to use struct timeval's types here:
> 
> 	time_t delta_time_sec;
> 	suseconds_t delta_time_usec_t delta_time_usec;
> 
> , instead of fixed size integers?
> 
>>
>>   	CL_ASSERT(p_timer);
>>   	CL_ASSERT(p_timer->state == CL_INITIALIZED);
>> @@ -324,9 +325,10 @@ cl_status_t cl_timer_start(IN cl_timer_t * const p_timer,
>>   	/* if (delta_time<  1000.0) {delta_time = 1000;} */
>>
>>   	/* Calculate the timeout. */
>> -	p_timer->timeout.tv_sec = curtime.tv_sec + (delta_time / 1000);
>> +	p_timer->timeout.tv_sec = curtime.tv_sec + delta_time_sec +
>> +		((curtime.tv_usec + delta_time_usec) / 1000000);
>>   	p_timer->timeout.tv_nsec =
>> -	    (curtime.tv_usec + ((delta_time % 1000) * 1000)) * 1000;
>> +	    ((curtime.tv_usec + delta_time_usec) % 1000000) * 1000;
> 
> Or even something like this:
> 
> 	strcut timeval curtime, deltatime;
> 
> 	gettimeofday(&curtime, NULL);
> 
> 	addtime.tv_sec = time_ms / 1000;
> 	addtime.tv_usec = (time_ms % 1000) * 1000;
> 
> 	timeradd(&curtime,&addtime,&timer->timeout);
> 
> ?

Sure, why not. It won't be that clean, because p_timer->timeout
and curtime/deltatime are different types, but I get the idea.

-- Yevgeny
 
> Sasha
> 
>>
>>   	/* Add the timer to the queue. */
>>   	if (cl_is_qlist_empty(&gp_timer_prov->queue)) {
>> -- 
>> 1.6.2.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
