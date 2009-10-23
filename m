From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Fri, 23 Oct 2009 09:52:01 -0700
Message-ID: <4AE1DF31.6090300@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <4AD63681.6080901@mellanox.com>	 <adaljjd8zrj.fsf@cisco.com> <4AD63DB1.3060906@mellanox.com>	 <adahbu18uf5.fsf@cisco.com>	 <1255570760.13845.4.camel@obelisk.thedillows.org>	 <4AD74C88.8030604@mellanox.com>	 <1255634715.29829.9.camel@lap75545.ornl.gov>	 <20091015213512.GW5191@obsidianresearch.com>	 <4AE0E71E.20309@mellanox.com> <e2e108260910222313o27c8b97dh483d846b6c98e480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260910222313o27c8b97dh483d846b6c98e480-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche wrote:
> On Fri, Oct 23, 2009 at 1:13 AM, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>   
>> [ ... ]
>>
>> Here is the updated patch which implement the device_loss_timeout for each target instead of module parameter. It also reflects changes from previous feedbacks. Please review
>>
>>
>>
>> Introducing device_loss_timeout per target granularity. Creating a timer to
>> clean up connection after device_loss_timeout expired. During
>> device_loss_timeout, the QP is in error state, srp will return DID_RESET
>> for outstanding I/Os and return FAILED for abort_cmd, reset_lun, and return
>> SUCCESS (without retrying reconnect) on reset_host
>>
>> Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> -----------------------------------------------------------------------
>>
>> drivers/infiniband/ulp/srp/ib_srp.c |   94 ++++++++++++++++++++++++++++++++++-
>>  drivers/infiniband/ulp/srp/ib_srp.h |    3 +
>>  2 files changed, 95 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index e44939a..12404d5 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -433,6 +433,10 @@ static void srp_remove_work(struct work_struct *work)
>>                return;
>>        }
>>        target->state = SRP_TARGET_REMOVED;
>> +
>> +       if (timer_pending(&target->qp_err_timer))
>> +               del_timer_sync(&target->qp_err_timer);
>> +
>>        spin_unlock_irq(target->scsi_host->host_lock);
>>
>>        spin_lock(&target->srp_host->target_lock);
>>
>> [ ... ]
>>     
>
> Calling del_timer_sync() while holding a spinlock can cause locking
> inversion. Has this code been tested on a kernel with LOCKDEP enabled
> ?
>
> Bart.
>   
I have not tested with LOCKDEP enabled., probably del_timer() would be 
sufficient inside target_lock
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
