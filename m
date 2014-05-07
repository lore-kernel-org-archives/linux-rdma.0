From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 6/9] IB/srp: Make srp_alloc_req_data() reallocate request
 data
Date: Wed, 07 May 2014 16:11:20 +0200
Message-ID: <536A3F08.7030108@acm.org>
References: <5368DA5B.80609@acm.org> <5368DB90.9050209@acm.org> <536A0FF7.7050608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <536A0FF7.7050608-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/07/14 12:50, Sagi Grimberg wrote:
> On 5/6/2014 3:54 PM, Bart Van Assche wrote:
>> -static void srp_free_req_data(struct srp_target_port *target)
>> +static void srp_free_req_data(struct srp_target_port *target,
>> +                  struct srp_request *req_ring)
>>   {
>>       struct ib_device *ibdev = target->srp_host->srp_dev->dev;
>>       struct srp_request *req;
>>       int i;
>>   -    if (!target->req_ring)
>> +    if (!req_ring)
>>           return;
>>         for (i = 0; i < target->req_ring_size; ++i) {
>> -        req = &target->req_ring[i];
>> +        req = &req_ring[i];
> 
> You loop for {ring A size} and operates on ring B elements. They will
> probably be the same but the notion seems buggy.
> Will it be better to untie this routine from srp_target_port at all?

Hello Sagi,

Had you noticed that target->req_ring_size is not modified during
resource allocation or reallocation ? That is why target->req_ring_size
has not been converted into a function argument in this patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
