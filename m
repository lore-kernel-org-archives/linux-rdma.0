From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/hfi1: Fix indentation
Date: Fri, 3 Jun 2016 12:53:22 -0700
Message-ID: <1beef469-13a1-8076-574e-9100eedba461@sandisk.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
 <54ad6b3b-4185-9345-26d0-ab3fd9ce36e4@sandisk.com>
 <20160603192638.GA946@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160603192638.GA946-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/03/2016 12:26 PM, Dennis Dalessandro wrote:
> On Fri, Jun 03, 2016 at 12:09:56PM -0700, Bart Van Assche wrote:
>> #define C_MAX_NAME 13 /* 12 chars + one for /0 */
>> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
>> index 5cc492e..0d28a5a 100644
>> --- a/drivers/infiniband/hw/hfi1/init.c
>> +++ b/drivers/infiniband/hw/hfi1/init.c
>> @@ -1337,7 +1337,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
>> 		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
>> 				  (void *)dd->rcvhdrtail_dummy_kvaddr,
>> 				  dd->rcvhdrtail_dummy_physaddr);
>> -				  dd->rcvhdrtail_dummy_kvaddr = NULL;
>> +		dd->rcvhdrtail_dummy_kvaddr = NULL;
>> 	}
>>
>> 	for (ctxt = 0; tmp && ctxt < dd->num_rcv_contexts; ctxt++) {
>
> This is the same thing as a patch from Dan Carpenter I think?
> https://patchwork.kernel.org/patch/9139133/

Indeed, and apparently I forgot that I had already reviewed that patch :-)

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
