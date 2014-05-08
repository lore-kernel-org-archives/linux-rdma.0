From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/srp: Add fast registration support
Date: Thu, 08 May 2014 19:18:30 +0300
Message-ID: <536BAE56.1040206@dev.mellanox.co.il>
References: <5368DA5B.80609@acm.org> <5368DC09.70608@acm.org> <536A1A3A.9090208@dev.mellanox.co.il> <536A4A68.4080605@acm.org> <536A6B2F.70807@dev.mellanox.co.il> <536B7ABE.8080502@acm.org> <536B9FB4.5040009@dev.mellanox.co.il> <536BAA13.3050905@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <536BAA13.3050905-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/8/2014 7:00 PM, Bart Van Assche wrote:
> On 05/08/14 17:16, Sagi Grimberg wrote:
>> On 5/8/2014 3:38 PM, Bart Van Assche wrote:
>>> On 05/07/14 19:19, Sagi Grimberg wrote:
>>>> On 5/7/2014 5:59 PM, Bart Van Assche wrote:
>>>>> On 05/07/14 13:34, Sagi Grimberg wrote:
>>>>>>> +        pool = srp_create_fr_pool(dev->dev, dev->pd,
>>>>>>> +                      SRP_MDESC_PER_POOL, max_pages_per_mr);
>>>>>> 1024 FRMRs per connection?! we use 1024 FMRs for all connections
>>>>>> (per-device). I'd say that's a major over-allocation.
>>>>> It depends on how many discontiguous I/O requests are submitted
>>>>> concurrently. Anyway, how about limiting the number of memory
>>>>> regions to
>>>>> the queue size ?
>>>> Perhaps, but we will need to reserve some more for discontinuous IOs.
>>>> It is heuristic, for FS in most cases IO will align nicely, for some
>>>> crazy DB applications - I'm not sure.
>>> If srp_map_sg() runs out of memory descriptors it adds the remaining sg
>>> entries to the SRP indirect descriptor without using memory
>>> registration. In other words, I think a queue full of discontiguous I/O
>>> requests should be handled properly by srp_map_sg().
>> True, SRP can do without registration altogether by passing multiple
>> SGEs, we still strive
>> to register memory though.
>>
>> Would you consider making it configurable with default to queue_size?
>> This way the user which is (hopefully) aware of it's typical IO pattern
>> can choose a suitable value.
> I don't think another configuration parameter is needed. The SRP
> initiator already allows to configure the queue size. If an application
> queues many I/O requests that cannot be registered via a single memory
> descriptor and the SRP initiator runs out of memory descriptors
> temporarily then srp_queuecommand() will return SCSI_MLQUEUE_HOST_BUSY.
> If we change that behavior such that these commands are finished with
> e.g. result code (DID_OK << 16) | (QUEUE_FULL << 1) then the SCSI
> mid-layer will use that information to decrease the queue depth
> dynamically via srp_change_queue_depth(). See e.g.
> scsi_decide_disposition() in drivers/scsi/scsi_error.c.

I see, I'm fine with that. let's set it to queue_size.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
