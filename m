From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/srp: Remove target from list before freeing Scsi_Host
 structure
Date: Thu, 10 Oct 2013 14:48:48 +0200
Message-ID: <5256A230.9020007@acm.org>
References: <5256941A.3040506@acm.org> <52569485.8050708@acm.org> <5256A183.3030404@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5256A183.3030404-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/13 14:45, Jack Wang wrote:
> On 10/10/2013 01:50 PM, Bart Van Assche wrote:
>> From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Remove an SRP target from the SRP target list before invoking the
>> last scsi_host_put() call. This change is necessary because that
>> last put frees the memory that holds the srp_target_port structure.
>>
>> This patch prevents that the following kernel oops can be triggered:
>>
>> RIP: 0010:[<ffffffff810b00d0>] __lock_acquire+0x500/0x1570
>> Call Trace:
>>   [<ffffffff810b11e4>] lock_acquire+0xa4/0x120
>>   [<ffffffff81531206>] _spin_lock+0x36/0x70
>>   [<ffffffffa01b6d8f>] srp_remove_work+0xef/0x180 [ib_srp]
>>   [<ffffffff8109125c>] worker_thread+0x21c/0x3d0
>>   [<ffffffff81096e86>] kthread+0x96/0xa0
>>   [<ffffffff8100c20a>] child_rip+0xa/0x20
>>
>> Signed-off-by: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> [bvanassche: Modified path description and CC'ed stable]
>> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
>> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index f93baf8..f1318a8 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -534,6 +534,11 @@ static void srp_remove_target(struct srp_target_port *target)
>>   	ib_destroy_cm_id(target->cm_id);
>>   	srp_free_target_ib(target);
>>   	srp_free_req_data(target);
>> +
>> +	spin_lock(&target->srp_host->target_lock);
>> +	list_del(&target->list);
>> +	spin_unlock(&target->srp_host->target_lock);
>> +
>>   	scsi_host_put(target->scsi_host);
>>   }
>>
>> @@ -545,10 +550,6 @@ static void srp_remove_work(struct work_struct *work)
>>   	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
>>
>>   	srp_remove_target(target);
>> -
>> -	spin_lock(&target->srp_host->target_lock);
>> -	list_del(&target->list);
>> -	spin_unlock(&target->srp_host->target_lock);
>>   }
>
> Or move the 3 line code on top of srp_remove_target(target);?

That would break srp_conn_unique() - removal from the target list must 
only happen after a DREQ has been sent by the initiator to the target.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
