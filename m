From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/3] IB/core: Change per-entry lock in RoCE GID
 table to one lock
Date: Wed, 30 Dec 2015 12:59:36 +0200
Message-ID: <5683B918.3060608@mellanox.com>
References: <1446043961-17667-1-git-send-email-matanb@mellanox.com>
 <1446043961-17667-3-git-send-email-matanb@mellanox.com>
 <56837328.8000902@mellanox.com> <5683897C.8000604@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5683897C.8000604-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/30/2015 9:36 AM, Bart Van Assche wrote:
> On 12/30/2015 07:01 AM, Or Gerlitz wrote:
>> On 10/28/2015 4:52 PM, Matan Barak wrote:
>>> @@ -134,16 +138,14 @@ static int write_gid(struct ib_device *ib_dev,
>>> u8 port,
>>>   {
>>>       int ret = 0;
>>>       struct net_device *old_net_dev;
>>> -    unsigned long flags;
>>>       /* in rdma_cap_roce_gid_table, this funciton should be protected
>>> by a
>>>        * sleep-able lock.
>>>        */
>>> -    write_lock_irqsave(&table->data_vec[ix].lock, flags);
>>>       if (rdma_cap_roce_gid_table(ib_dev, port)) {
>>>           table->data_vec[ix].props |= GID_TABLE_ENTRY_INVALID;
>>> -        write_unlock_irqrestore(&table->data_vec[ix].lock, flags);
>>> +        write_unlock_irq(&table->rwlock);
>>>           /* GID_TABLE_WRITE_ACTION_MODIFY currently isn't supported by
>>>            * RoCE providers and thus only updates the cache.
>>>            */
>>> @@ -153,7 +155,7 @@ static int write_gid(struct ib_device *ib_dev, u8
>>> port,
>>>           else if (action == GID_TABLE_WRITE_ACTION_DEL)
>>>               ret = ib_dev->del_gid(ib_dev, port, ix,
>>>                             &table->data_vec[ix].context);
>>> -        write_lock_irqsave(&table->data_vec[ix].lock, flags);
>>> +        write_lock_irq(&table->rwlock);
>>>       }
>>
>> sparse complains on
>>
>> drivers/infiniband/core/cache.c:186:17: warning: context imbalance in
>> 'write_gid' - unexpected unlock
>>
>> is this false positive?
>

It is false positive.

> Hello Or,
>
> sparse expects __release() and __acquire() annotations for functions
> that unlock a lock object that has been locked by its caller. See e.g.
> http://lists.kernelnewbies.org/pipermail/kernelnewbies/2011-October/003541.html.
>

Thanks - adding __releases and __acquires eliminates this sparse warning.

>
> Bart.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
