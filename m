From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V6 05/10] IB/core: Add RoCE GID table management
Date: Tue, 21 Jul 2015 11:42:29 +0300
Message-ID: <CAAKD3BA2Qgw87uXiS-M9gO1-jXPfQncyWzscMuusMABPRRzA8w@mail.gmail.com>
References: <1435150766-6803-1-git-send-email-matanb@mellanox.com>
	<1435150766-6803-6-git-send-email-matanb@mellanox.com>
	<20150717190245.GA20632@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150717190245.GA20632-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 17, 2015 at 10:02 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Jun 24, 2015 at 03:59:21PM +0300, Matan Barak wrote:
>> +
>> +     /* in rdma_cap_roce_gid_table, this funciton should be protected by a
>> +      * sleep-able lock.
>> +      */
>> +     write_lock(&table->data_vec[ix].lock);
>
> I'm having a hard time understanding this comment
>

The same function is used for both RoCE and IB. Since RoCE unlocks the
rwlock, calls the vendor's callback and
locks it again. If two write_gid(s) are executed simultaneously,  you
need to protect them from writing to the
same entry. The vendor's callback might sleep so we require a sleep-able lock.

>> +int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
>> +                  union ib_gid *gid, struct ib_gid_attr *attr)
>> +{
>> +     struct ib_gid_table **ports_table =
>> +             READ_ONCE(ib_dev->cache.gid_cache);
>> +     /* all table reads depend on ports_table, no need for smp_rmb() */
>> +     if (!ports_table)
>> +             return -EOPNOTSUPP;
>
> This common pattern does look genuinely odd...
>
> The gid_cache is part of the common API, it really shouldn't be kfree'd
> while held struct ib_devices are around. The kfree for all the cache.c
> stuff should probably be called from ib_device_release, not from the
> client release.
>
> That is actually something the current code does that is possibly
> wrong. It is trivially fixed by moving all the kfrees to
> ib_device_release.
>

But cache as a whole is implemented as a client (cache_client).
Isn't it a bit odd to free a client in ib_device_release?

> Next is the READ_ONCE fencing. I think it is totally unnecessary.
>
> Patch #4 does this:
>
>         down_write(&lists_rwsem);
>         list_del(&device->core_list);
>         up_write(&lists_rwsem);
>
>         list_for_each_entry_reverse(client, &client_list, list)
>                 if (client->remove)
>                         client->remove(device);
>
> So, by the time we get to gid_table_client_cleanup_one, it is no
> longer possible for ib_enum_all_roce_netdevs to use the ib_device we
> are removing (it is taken off the core_list).
>
> Since all the queued work calls ib_enum_all_roce_netdevs, it is
> impossibile for something like ib_cache_gid_add to be called from the
> work queue with the ib_dev under removal.
>
> In fact, even the flush_work is not needed because of how lists_rwsem
> is being used: we can not remove something from the core list until
> there are no ib_enum_all_roce_netdevs callbacks running.
>

Correct, it's no longer needed when rwlock protects the list.
Thanks for pointing this out.

> Also, did you notice the double flush of the work queue? One is
> enough:
>
> static void ib_cache_cleanup_one(struct ib_device *device)
> {
>         ib_unregister_event_handler(&device->cache.event_handler);
>         flush_workqueue(ib_wq);
>         gid_table_client_cleanup_one(device);
> static void gid_table_client_cleanup_one(struct ib_device *ib_dev)
> {
>         flush_workqueue(ib_wq);
>
>

Correct, I'll fix that.

> No other locking problems screamed out at me, but it is a big patch,
> and I have't looked closely at all of it.
>

Thanks for the review. I'll fix those issues.
Matan

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
