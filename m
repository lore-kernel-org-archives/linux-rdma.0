From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: QLogic driver problem (ib_qib)
Date: Thu, 16 Jul 2015 13:27:58 -0700
Message-ID: <55A813CE.4000109@sandisk.com>
References: <82fd80bcd97dae02558e4122b7c6964f@alukardd.org> <32E1700B9017364D9B60AED9960492BC257631C5@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257631C5-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexey <alukardd-2mZicLuE2MBg9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/16/2015 01:15 PM, Marciniszyn, Mike wrote:
>> Bart Van Assche help us and resulting patch you can see below:
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>> b/drivers/infiniband/ulp/srp/ib_srp.c
>> index c5af67a..470eb54 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -59,6 +59,7 @@
>>    #include "../../../../include/scsi/scsi_transport_srp.h"
>>
>>    #include "ib_srp.h"
>> +#include <linux/delay.h>
>>
>>    #define DRV_NAME	"ib_srp"
>>    #define PFX		DRV_NAME ": "
>> @@ -621,11 +622,7 @@ static void srp_destroy_qp(struct srp_rdma_ch *ch)
>>    	if (ret)
>>    		goto out;
>>
>> -	init_completion(&ch->done);
>> -	ret = ib_post_recv(ch->qp, &wr, &bad_wr);
>> -	WARN_ONCE(ret, "ib_post_recv() returned %d\n", ret);
>> -	if (ret == 0)
>> -		wait_for_completion(&ch->done);
>> +	msleep(100);
>>
>>    out:
>>    	ib_destroy_qp(ch->qp);
>
> Post receive can return a synchronous failure.   The question would be which one and why?
>
> Bart, any ideas?

Hello Mike,

ib_post_recv() can indeed return a synchronous failure. But I think a 
synchronous failure should be handled properly by the SRP initiator 
driver: if ret < 0 then the wait_for_completion() call is skipped. What 
Alexey reported is that the wait_for_completion() call did not finish 
which means that ib_post_recv() returned 0. Or did I perhaps 
misinterpret something ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
