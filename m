From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V5 07/12] IB/core: Add RoCE table bonding support
Date: Thu, 11 Jun 2015 19:00:02 +0300
Message-ID: <CAAKD3BDAYXk6LsZ3SLUsm+7mfybS8+8vvsaurUrYbd2QUYbKfw@mail.gmail.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
	<1433772735-22416-8-git-send-email-matanb@mellanox.com>
	<20150611061818.GB22369@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611061818.GB22369-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 9:18 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Jun 08, 2015 at 05:12:10PM +0300, Matan Barak wrote:
>
>> +static enum bonding_slave_state is_eth_active_slave_of_bonding(struct net_device *idev,
>> +                                                            struct net_device *upper)
>> +{
>> +     if (upper && IS_NETDEV_BONDING_MASTER(upper)) {
>> +             struct net_device *pdev;
>> +
>> +             rcu_read_lock();
>> +             pdev = bond_option_active_slave_get_rcu(netdev_priv(upper));
>> +             rcu_read_unlock();
>> +             if (pdev)
>> +                     return idev == pdev ? BONDING_SLAVE_STATE_ACTIVE :
>> +                             BONDING_SLAVE_STATE_INACTIVE;
>
> This isn't buggy as written, but I think, it doesn't re-enforce the
> rules for how rcu critical sections should work.
>
> The only reason this is not buggy is because it is a pointer compare
> and it works out that is OK in this particular case. But, it is subtle
> and it might trip up someone down the road.
>
> Keeping with the idomatic RCU pattern is better:
>
>  enum bonding_slave_state res = BONDING_SLAVE_STATE_INACTIVE;;
>
>  rcu_read_lock();
>  pdev = bond_option_active_slave_get_rcu(netdev_priv(upper));
>  if (pdev && pdev == idev)
>    res = BONDING_SLAVE_STATE_ACTIVE;
>  rcu_read_unlock();
>
>  return res;
>
> ie don't leak pdev out of the critical section unless a ref is taken
> on it.
>
> Same comment applies to other similar places in this series.
>

As you stated, pointer comparison is valid. However, I can move it
inside the rcu section if you feel it's clearer.

>> +static bool is_upper_dev_rcu(struct net_device *dev, struct net_device *upper)
>> +{
>> +     struct net_device *_upper = NULL;
>> +     struct list_head *iter;
>> +
>> +     rcu_read_lock();
>
> A _rcu function should *always* be called with rcu_read_lock held.
>
> It makes no sense to take it again in the body.
>
> Change the name, or fix the one call site that doesn't hold the lock.
>
> I see callers that hold the lock and callers that don't hold the lock,
> shouldn't be both kinds.
>

I'll change this name to be with _rcu suffix.

>>  static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
>>                                struct net_device *idev, void *cookie)
>>  {
>> -     struct net_device *rdev;
>> -     struct net_device *mdev;
>> -     struct net_device *ndev = (struct net_device *)cookie;
>> +     return _is_eth_port_of_netdev(ib_dev, port, idev, cookie,
>> +                                   BONDING_SLAVE_STATE_ACTIVE |
>> +                                   BONDING_SLAVE_STATE_NA);
>> +}
>
> Why wrapper _is_eth_port_of_netdev with is_eth_port_of_netdev? There
> is only one caller to _is_eth_port_of_netdev? Please look at all the
> other small functions, there are quite a few..
>

I'll put its implementation in is_eth_port_of_netdev.

>> +static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
>> +                         struct net_device *ndev)
>> +{
>> +     enum_netdev_ipv4_ips(ib_dev, port, ndev);
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +     enum_netdev_ipv6_ips(ib_dev, port, ndev);
>> +#endif
>> +}
>
> Did you try the 'if (IS_ENABLED(CONFIG_IPV6))' version I suggested a
> few versions ago?
>
>> +static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
>> +                             void *cookie,
>> +                             void (*handle_netdev)(struct ib_device *ib_dev,
>> +                                                   u8 port,
>> +                                                   struct
>> net_device *ndev))
> [..]
>

You mentioned it on an IPoIB thread, but I'll adopt that.

>> +     LIST_HEAD(upper_list);
>> +
>> +     rcu_read_lock();
>> +     netdev_for_each_all_upper_dev_rcu(ndev, upper, iter) {
>> +             struct upper_list *entry = kmalloc(sizeof(*entry),
>> +                                                GFP_ATOMIC);
>> +
>> +             if (!entry) {
>> +                     pr_info("roce_gid_mgmt: couldn't allocate entry to delete ndev\n");
>> +                     continue;
>> +             }
>> +
>> +             list_add_tail(&entry->list, &upper_list);
>> +             dev_hold(upper);
>> +             entry->upper = upper;
>
> Everytime I see copying refs onto a stack list I really start to
> wonder..
>
> handle_netdev absolutely cannot be called with rcu_read_lock held? Is
> that a wise design?
>

handle_netdev is a callback the causes a write to the gid_table - so
it can't be called from an atomic context.

>> @@ -309,11 +548,24 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
>>  {
>>       static const struct netdev_event_work_cmd add_cmd = {
>>               .cb = add_netdev_ips, .filter = is_eth_port_of_netdev};
>> +     static const struct netdev_event_work_cmd add_cmd_upper_ips = {
>> +             .cb = add_netdev_upper_ips, .filter = is_eth_port_of_netdev};
>>       static const struct netdev_event_work_cmd del_cmd = {
>>               .cb = del_netdev_ips, .filter = pass_all_filter};
>> +     static const struct netdev_event_work_cmd bonding_default_del_cmd_join = {
>> +             .cb = del_netdev_default_ips_join, .filter = is_eth_port_inactive_slave};
>> +     static const struct netdev_event_work_cmd bonding_default_del_cmd = {
>> +             .cb = del_netdev_default_ips, .filter = is_eth_port_inactive_slave};
>> +     static const struct netdev_event_work_cmd default_del_cmd = {
>> +             .cb = del_netdev_default_ips, .filter = pass_all_filter};
>> +     static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
>> +             .cb = del_netdev_upper_ips, .filter = bonding_slaves_filter};
>> +     static const struct netdev_event_work_cmd upper_ips_del_cmd = {
>> +             .cb = del_netdev_upper_ips, .filter =
>>  upper_device_filter};
>
> I also wonder about all this. Can you talk about why the work queue is
> needed at this level, and is this a wise design? Is it the same reason
> we can't call handle_netdev with rcu read lock held?
>

There are several sources of events - inet, inet6 and net-device. We
would like to treat all of them as first come first served.
This is why we're queuing all of them to the same workqueue and handle
them one after another.
Since we would like to go for a generic mechanism, which handle all
events, no assumptions on the calling context were
being made.

> I'm just guessing, but is it because the driver modify_gid callback is
> allowed to sleep? Would it make more sense to drive only modify_gid
> from a work q and leave the rest of this to run inline with the
> notifier? That would save alot of code..
>

That's one reason for doing so. There are others, for example -
serializing event handling, using rwsem in
ib_enum_roce_ports_of_netdev and minimizing our event handling time.

>> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>> index 4df2894..c4fe29a8 100644
>> +++ b/drivers/net/bonding/bond_options.c
>
> Woah, Woah, this should be a dedicated patch, needs to be approved by
> netdev.
>

I'll make split it off this patch.

> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
