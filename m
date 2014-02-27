From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 3/3] IB/srp: Protect free_tx iu list from concurrent
 flows
Date: Thu, 27 Feb 2014 13:51:42 +0200
Message-ID: <530F26CE.5070404@dev.mellanox.co.il>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-4-git-send-email-sagig@mellanox.com> <530B677A.1040508@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530B677A.1040508-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/24/2014 5:38 PM, Bart Van Assche wrote:
> On 02/24/14 15:30, Sagi Grimberg wrote:
>> From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> srp_reconnect_rport() serializes calls of srp_rport_reconnect()
>> with srp_queuecommand(), srp_abort(), srp_reset_device(),
>> srp_reset_host() via rport->mutex and also blocks srp_queuecommand();
>> however, it cannot block scsi error handler commands (stu, tur).
>> This may introduces corruption in free_tx IUs list and IU itself
>>
>> Signed-off-by: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index b615135..656602b 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -859,6 +859,7 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>>   {
>>   	struct srp_target_port *target = rport->lld_data;
>>   	int i, ret;
>> +	unsigned long flags;
>>   
>>   	srp_disconnect_target(target);
>>   	/*
>> @@ -882,9 +883,11 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>>   		srp_finish_req(target, req, DID_RESET << 16);
>>   	}
>>   
>> +	spin_lock_irqsave(&target->lock, flags);
>>   	INIT_LIST_HEAD(&target->free_tx);
>>   	for (i = 0; i < target->queue_size; ++i)
>>   		list_add(&target->tx_ring[i]->list, &target->free_tx);
>> +	spin_unlock_irqrestore(&target->lock, flags);
>>   
>>   	if (ret == 0)
>>   		ret = srp_connect_target(target);
> Hello Sagi and Vu,
>
> srp_rport_reconnect() should never get invoked concurrently with
> srp_queuecommand() - see e.g. the "in_scsi_eh" variable in
> srp_queuecommand(). Is the list corruption reproducible with the patch
> mentioned in my reply to patch 1/3 ?
>
> Thanks,
>
> Bart.

I need to re-test this.

Regarding in_scsi_eh, can you end-up still posting a send if you are in 
an interrupt context?
it's just that we have a *very* rare case (not easy to reproduce) in 
RH6.5 where we end-up posting on a just destroyed QP
(race right in between destroy_qp and assignment of new qp in 
srp_create_target_ib).
We tested it with in_scsi_eh patch and it still happened.

As I see it, SRP problems comes in a distinct period when rport is in 
state BLOCKED.
On one hand, all request processing are allowed (not failing commands), 
and on the other reconnect flow may be running in concurrently.
Will it be acceptable to take the rport_mutex in queue_command if rport 
is in BLOCKED state?

Thoughts?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
