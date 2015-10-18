From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Sun, 18 Oct 2015 10:49:05 +0300
Message-ID: <CAAKD3BBEfKTHPKyoTzMW3YESKJmGkcUkui=hjhsbyFRY+xDDEw@mail.gmail.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
	<1444910463-5688-2-git-send-email-matanb@mellanox.com>
	<561FE452.3050304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561FE452.3050304-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 8:37 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/15/2015 08:01 AM, Matan Barak wrote:
>> When using ifup/ifdown while executing enum_netdev_ipv4_ips,
>> ifa could become invalid and cause use after free error.
>> Fixing it by protecting with RCU lock.
>>
>> Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>
>> Hi Doug,
>>
>> This patch fixes a bug in RoCE GID table implementation. Under stress conditions
>> where ifup/ifdown are used, the ifa pointer could become invalid. Using a
>> RCU lock in order to avoid freeing the ifa node (as done in other inet functions
>> (for example, inet_addr_onlink).
>>
>> Our QA team verified that this patch fixes this issue.
>
> This doesn't look like a good fix to me.  In particular, I think you
> merely shifted the bug around, you didn't actually resolve it.
>
> In the original code, you called update_gid_ip while holding a reference
> to in_dev.  The reference to in_dev was not enough to keep the ifa list
> from changing while you were doing your work.  It's not surprising that
> you hit a race with the ifa list because update_gid_ip being called
> synchronously can both A) sleep because of the mutexes it takes and B)
> be slow because of how many locks it takes (and it can really take a lot
> due to find_gid) and C) be slow again because of updating the gid table
> calling into the low level driver and actually writing a mailbox command
> to the card.  So, for all those reasons, not only did you hit this race,
> but you were *likely* to hit this race.
>

I don't mind that the list could be changing between the inet event
and the work handler.
I do mind the ifa is released while working on it. I think the major
reason for possible slowness is the vendor call. Most locks are
per-entry and are read-write locks.

> Now, you've put an rcu_read_lock on ndev instead.  And you're no longer
> seeing the race.  However, does taking the rcu_read_lock on ndev
> actually protect the ifa list on ndev, or is the real fix the fact that
> you moved update_gid_ip out of the main loop?  Before, you blocked while
> processing the ifa list, making hitting your race likely.  Now you
> process the ifa list very fast and build your own sin_list that is no
> longer impacted by changes to the ifa list, but I don't know that the
> rcu_read_lock you have taken actually makes you for sure safe here
> versus the possibility that you have just made the race much harder to
> hit and hidden it.
>

As Jason wrote, the release of the ifa is protected by call_rcu. So
protecting the usage of ifa with RCU should be enough to eliminate
this bug.


> And even if the rcu_read_lock is for sure safe in terms of accessing the
> ifa list, these changes may have just introduced a totally new bug that
> your QE tests haven't exposed but might exist none the less.  In
> particular, we have now queued up adding a bunch of gids to the ndev.
> But we drop our reference to the rcu lock, then we invoke a (possibly
> large number) of sleeping iterations.  What's to prevent a situation
> where we get enum_netdev_ipv4_ips() called on say a vlan child interface
> of a primary RoCE netdev, create our address list, release our lock,
> then the user destroys our vlan device, and we race with del_netdev_ips
> on the vlan device, such that del_netdev_ips completes and removes all
> the gids for that netdev, but we still have backlogged gid add events in
> enum_netdev_ipv4_ips and so we add back in what will become permanently
> stale gids?  I don't think we hold rtnl_lock while running in
> enum_netdev_ipv4_ips and that's probably the only lock that would
> exclude the user from deleting the vlan device, so as far as I can tell
> we can easily call del_netdev_ips while the tail end of
> enum_netdev_ipv4_ips is sleeping.  Am I wrong here?  A test would be to
> take whatever QE test you have that hit this bug in the first place, and
> on a different terminal add a while loop of adding/removing the same
> vlan interface that you are updating gids on and see if the gid table
> starts filling up with stale, unremovable entries.
>

The RoCE GID management design uses events handlers and one workqueue.
When an event (inet/net) is handled, we hold the net device and
execute a work in the workqueue.
The works are executed in a queue - thus first-come first-served.
That's why if you add/del a vlan (or its IP)
we do dev_hold in the event itself. Since the ndev is available in the
event and is held when executing the event - it can't be deleted until
we handle this
event in the workqueue. If the user tries to delete the vlan before
our add (inet/ndev) work was completed, we'll get an UNREGISTER event,
but since the dev is held, the stack will have to wait until we free
all our ref counts to this device. Using a queue guarantees us the
order - we'll first complete adding the vlan and then delete it. Only
after all reference counts are dropped, the net device could be
deleted.
Anyway, I'll ask the QA team here to add this test.

Thanks for taking a look on this patch.

>> Thanks,
>> Matan
>>
>>  drivers/infiniband/core/roce_gid_mgmt.c | 35 +++++++++++++++++++++++++--------
>>  1 file changed, 27 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
>> index 6b24cba..178f984 100644
>> --- a/drivers/infiniband/core/roce_gid_mgmt.c
>> +++ b/drivers/infiniband/core/roce_gid_mgmt.c
>> @@ -250,25 +250,44 @@ static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
>>                                u8 port, struct net_device *ndev)
>>  {
>>       struct in_device *in_dev;
>> +     struct sin_list {
>> +             struct list_head        list;
>> +             struct sockaddr_in      ip;
>> +     };
>> +     struct sin_list *sin_iter;
>> +     struct sin_list *sin_temp;
>>
>> +     LIST_HEAD(sin_list);
>>       if (ndev->reg_state >= NETREG_UNREGISTERING)
>>               return;
>>
>> -     in_dev = in_dev_get(ndev);
>> -     if (!in_dev)
>> +     rcu_read_lock();
>> +     in_dev = __in_dev_get_rcu(ndev);
>> +     if (!in_dev) {
>> +             rcu_read_unlock();
>>               return;
>> +     }
>>
>>       for_ifa(in_dev) {
>> -             struct sockaddr_in ip;
>> +             struct sin_list *entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
>>
>> -             ip.sin_family = AF_INET;
>> -             ip.sin_addr.s_addr = ifa->ifa_address;
>> -             update_gid_ip(GID_ADD, ib_dev, port, ndev,
>> -                           (struct sockaddr *)&ip);
>> +             if (!entry) {
>> +                     pr_warn("roce_gid_mgmt: couldn't allocate entry for IPv4 update\n");
>> +                     continue;
>> +             }
>> +             entry->ip.sin_family = AF_INET;
>> +             entry->ip.sin_addr.s_addr = ifa->ifa_address;
>> +             list_add_tail(&entry->list, &sin_list);
>>       }
>>       endfor_ifa(in_dev);
>> +     rcu_read_unlock();
>>
>> -     in_dev_put(in_dev);
>> +     list_for_each_entry_safe(sin_iter, sin_temp, &sin_list, list) {
>> +             update_gid_ip(GID_ADD, ib_dev, port, ndev,
>> +                           (struct sockaddr *)&sin_iter->ip);
>> +             list_del(&sin_iter->list);
>> +             kfree(sin_iter);
>> +     }
>>  }
>>
>>  static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
>>
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
