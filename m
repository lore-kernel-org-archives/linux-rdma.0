From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 4/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 14:11:52 -0700
Message-ID: <4AD63E98.6090309@mellanox.com>
References: <4AD3B466.8060908@mellanox.com> <e2e108260910130409q78e3edbcndd64b7cf419705b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260910130409q78e3edbcndd64b7cf419705b9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche wrote:
>
>> +
>> +       switch (event->event) {
>> +       case IB_EVENT_PORT_ERR:
>> +               list_for_each_entry_safe(host, tmp_host,
>> +                                        &srp_dev->dev_list, list) {
>> +                       if (event->element.port_num == host->port) {
>> +                               spin_lock(&host->target_lock);
>>     
>
> Can srp_remove_work() be executed concurrently with
> srp_event_handler() ? In that case the above code isn't safe and the
> spin_lock(&host->target_lock) should be moved to just before
> list_for_each_entry_safe(). The current implementation can trigger
> reading deallocated memory.
>
>   
>> +                               list_for_each_entry_safe(target, tmp_target,
>> +                                                        &host->target_list, list) {
>> +                                       unsigned long flags;
>> +
>> +                                       spin_lock_irqsave(target->scsi_host->host_lock,
>> +                                                         flags);
>> +                                       if (!target->qp_in_error &&
>> +                                           target->state == SRP_TARGET_LIVE)
>> +                                               srp_qp_err_add_timer(target,
>> +                                                                    srp_dev_loss_tmo);
>> +                                       spin_unlock_irqrestore(target->scsi_host->host_lock,
>> +                                                              flags);
>> +                               }
>> +                               spin_unlock(&host->target_lock);
>> +                       }
>> +               }
>> +               break;
>> +       case IB_EVENT_PORT_ACTIVE:
>> +       case IB_EVENT_LID_CHANGE:
>> +       case IB_EVENT_PKEY_CHANGE:
>> +       case IB_EVENT_SM_CHANGE:
>> +               list_for_each_entry_safe(host, tmp_host, &srp_dev->dev_list,
>> +                                        list) {
>> +                       if (event->element.port_num == host->port) {
>> +                               spin_lock(&host->target_lock);
>>     
>
> A remark similar to the above: this code isn't safe against concurrent
> calls of srp_remove_one().
>
>   
I did not pay attention to the races created by unloading module (same 
for patch 3/4). I'll rework patches and address these races.

thanks,
-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
