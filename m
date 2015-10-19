From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Mon, 19 Oct 2015 08:23:10 -0400
Message-ID: <5624E0AE.8050702@redhat.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
 <561FE452.3050304@redhat.com>
 <CAAKD3BBEfKTHPKyoTzMW3YESKJmGkcUkui=hjhsbyFRY+xDDEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NLA1NCqm3j0S6PTaMq4RCmDCUHtXFx1ax"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBEfKTHPKyoTzMW3YESKJmGkcUkui=hjhsbyFRY+xDDEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NLA1NCqm3j0S6PTaMq4RCmDCUHtXFx1ax
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/18/2015 03:49 AM, Matan Barak wrote:
> On Thu, Oct 15, 2015 at 8:37 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 10/15/2015 08:01 AM, Matan Barak wrote:
>>> When using ifup/ifdown while executing enum_netdev_ipv4_ips,
>>> ifa could become invalid and cause use after free error.
>>> Fixing it by protecting with RCU lock.
>>>
>>> Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>
>>> Hi Doug,
>>>
>>> This patch fixes a bug in RoCE GID table implementation. Under stress=
 conditions
>>> where ifup/ifdown are used, the ifa pointer could become invalid. Usi=
ng a
>>> RCU lock in order to avoid freeing the ifa node (as done in other ine=
t functions
>>> (for example, inet_addr_onlink).
>>>
>>> Our QA team verified that this patch fixes this issue.
>>
>> This doesn't look like a good fix to me.  In particular, I think you
>> merely shifted the bug around, you didn't actually resolve it.
>>
>> In the original code, you called update_gid_ip while holding a referen=
ce
>> to in_dev.  The reference to in_dev was not enough to keep the ifa lis=
t
>> from changing while you were doing your work.  It's not surprising tha=
t
>> you hit a race with the ifa list because update_gid_ip being called
>> synchronously can both A) sleep because of the mutexes it takes and B)=

>> be slow because of how many locks it takes (and it can really take a l=
ot
>> due to find_gid) and C) be slow again because of updating the gid tabl=
e
>> calling into the low level driver and actually writing a mailbox comma=
nd
>> to the card.  So, for all those reasons, not only did you hit this rac=
e,
>> but you were *likely* to hit this race.
>>
>=20
> I don't mind that the list could be changing between the inet event
> and the work handler.
> I do mind the ifa is released while working on it. I think the major
> reason for possible slowness is the vendor call.

No, it's not.

> Most locks are
> per-entry and are read-write locks.

This is a major cause of the slowness.  Unless you have a specific need
of them, per-entry rwlocks are *NOT* a good idea.  I was going to bring
this up separately, so I'll just mention it here.  Per entry locks help
reduce contention when you have lots of multiple accessors.  Using
rwlocks help reduce contention when you have a read-mostly entry that is
only occasionally changed.  But every lock and every unlock (just like
every atomic access) still requires a locked memory cycle.  That means
every lock acquire and every lock release requires a synchronization
event between all CPUs.  Using per-entry locks means that every entry
triggers two of those synchronization events.  On modern Intel CPUs,
they cost about 32 cycles per event.  If you are going to do something,
and it can't be done without a lock, then grab a single lock and do it
as fast as you can.  Only in rare cases would you want per-entry locks.

>> Now, you've put an rcu_read_lock on ndev instead.  And you're no longe=
r
>> seeing the race.  However, does taking the rcu_read_lock on ndev
>> actually protect the ifa list on ndev, or is the real fix the fact tha=
t
>> you moved update_gid_ip out of the main loop?  Before, you blocked whi=
le
>> processing the ifa list, making hitting your race likely.  Now you
>> process the ifa list very fast and build your own sin_list that is no
>> longer impacted by changes to the ifa list, but I don't know that the
>> rcu_read_lock you have taken actually makes you for sure safe here
>> versus the possibility that you have just made the race much harder to=

>> hit and hidden it.
>>
>=20
> As Jason wrote, the release of the ifa is protected by call_rcu. So
> protecting the usage of ifa with RCU should be enough to eliminate
> this bug.

OK, I'm happy enough with the explanation to take this patch.  But
please think about the per-entry locks you mention above.  Those need to
go if possible.  I'm relatively certain that you will be able to
demonstrate a *drastic* speed up in this code with them removed (try
running the cmtime application from librdmacm-utils and see what the
results are with per-entry locks and a per table lock instead).

>=20
>> And even if the rcu_read_lock is for sure safe in terms of accessing t=
he
>> ifa list, these changes may have just introduced a totally new bug tha=
t
>> your QE tests haven't exposed but might exist none the less.  In
>> particular, we have now queued up adding a bunch of gids to the ndev.
>> But we drop our reference to the rcu lock, then we invoke a (possibly
>> large number) of sleeping iterations.  What's to prevent a situation
>> where we get enum_netdev_ipv4_ips() called on say a vlan child interfa=
ce
>> of a primary RoCE netdev, create our address list, release our lock,
>> then the user destroys our vlan device, and we race with del_netdev_ip=
s
>> on the vlan device, such that del_netdev_ips completes and removes all=

>> the gids for that netdev, but we still have backlogged gid add events =
in
>> enum_netdev_ipv4_ips and so we add back in what will become permanentl=
y
>> stale gids?  I don't think we hold rtnl_lock while running in
>> enum_netdev_ipv4_ips and that's probably the only lock that would
>> exclude the user from deleting the vlan device, so as far as I can tel=
l
>> we can easily call del_netdev_ips while the tail end of
>> enum_netdev_ipv4_ips is sleeping.  Am I wrong here?  A test would be t=
o
>> take whatever QE test you have that hit this bug in the first place, a=
nd
>> on a different terminal add a while loop of adding/removing the same
>> vlan interface that you are updating gids on and see if the gid table
>> starts filling up with stale, unremovable entries.
>>
>=20
> The RoCE GID management design uses events handlers and one workqueue.
> When an event (inet/net) is handled, we hold the net device and
> execute a work in the workqueue.
> The works are executed in a queue - thus first-come first-served.
> That's why if you add/del a vlan (or its IP)
> we do dev_hold in the event itself. Since the ndev is available in the
> event and is held when executing the event - it can't be deleted until
> we handle this
> event in the workqueue. If the user tries to delete the vlan before
> our add (inet/ndev) work was completed, we'll get an UNREGISTER event,
> but since the dev is held, the stack will have to wait until we free
> all our ref counts to this device. Using a queue guarantees us the
> order - we'll first complete adding the vlan and then delete it. Only
> after all reference counts are dropped, the net device could be
> deleted.
> Anyway, I'll ask the QA team here to add this test.

OK.  And it works for now, but if there is ever added an additional
means of running one of these functions that isn't on the work queue,
then it can break subtly.

> Thanks for taking a look on this patch.
>=20
>>> Thanks,
>>> Matan
>>>
>>>  drivers/infiniband/core/roce_gid_mgmt.c | 35 +++++++++++++++++++++++=
++--------
>>>  1 file changed, 27 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infini=
band/core/roce_gid_mgmt.c
>>> index 6b24cba..178f984 100644
>>> --- a/drivers/infiniband/core/roce_gid_mgmt.c
>>> +++ b/drivers/infiniband/core/roce_gid_mgmt.c
>>> @@ -250,25 +250,44 @@ static void enum_netdev_ipv4_ips(struct ib_devi=
ce *ib_dev,
>>>                                u8 port, struct net_device *ndev)
>>>  {
>>>       struct in_device *in_dev;
>>> +     struct sin_list {
>>> +             struct list_head        list;
>>> +             struct sockaddr_in      ip;
>>> +     };
>>> +     struct sin_list *sin_iter;
>>> +     struct sin_list *sin_temp;
>>>
>>> +     LIST_HEAD(sin_list);
>>>       if (ndev->reg_state >=3D NETREG_UNREGISTERING)
>>>               return;
>>>
>>> -     in_dev =3D in_dev_get(ndev);
>>> -     if (!in_dev)
>>> +     rcu_read_lock();
>>> +     in_dev =3D __in_dev_get_rcu(ndev);
>>> +     if (!in_dev) {
>>> +             rcu_read_unlock();
>>>               return;
>>> +     }
>>>
>>>       for_ifa(in_dev) {
>>> -             struct sockaddr_in ip;
>>> +             struct sin_list *entry =3D kzalloc(sizeof(*entry), GFP_=
ATOMIC);
>>>
>>> -             ip.sin_family =3D AF_INET;
>>> -             ip.sin_addr.s_addr =3D ifa->ifa_address;
>>> -             update_gid_ip(GID_ADD, ib_dev, port, ndev,
>>> -                           (struct sockaddr *)&ip);
>>> +             if (!entry) {
>>> +                     pr_warn("roce_gid_mgmt: couldn't allocate entry=
 for IPv4 update\n");
>>> +                     continue;
>>> +             }
>>> +             entry->ip.sin_family =3D AF_INET;
>>> +             entry->ip.sin_addr.s_addr =3D ifa->ifa_address;
>>> +             list_add_tail(&entry->list, &sin_list);
>>>       }
>>>       endfor_ifa(in_dev);
>>> +     rcu_read_unlock();
>>>
>>> -     in_dev_put(in_dev);
>>> +     list_for_each_entry_safe(sin_iter, sin_temp, &sin_list, list) {=

>>> +             update_gid_ip(GID_ADD, ib_dev, port, ndev,
>>> +                           (struct sockaddr *)&sin_iter->ip);
>>> +             list_del(&sin_iter->list);
>>> +             kfree(sin_iter);
>>> +     }
>>>  }
>>>
>>>  static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
>>>
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--NLA1NCqm3j0S6PTaMq4RCmDCUHtXFx1ax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJOCuAAoJELgmozMOVy/dbIIQAIscpy1mrjvQTOOX00W1jHEl
kYTQsp/eqIndCEoVDIB0Smrm5bXV0ozbxhvug9wjR6c6wyQD9gnYm9oRRlfFc6GO
PDxqj604xGNdtWtUvZ8JW6G3CRa0Np11ypGIguWhy9EvphQWg+bsOW1kFLEsKoHi
cMGLLr9A1Pkyn0sKWkZWohH9APhmOEtNHGU8TB8r7TvZAAVVECAByvtXxLKHc/OT
hgnWuDUNqPR0FjIgsPRty9J3rXwlDF5aCLv9xgC2+pL2vPU1vjo9vM1CwpdizVAS
4x0JRB22pt8LS3N00gK2znemOOxESB0Evl33/uGyW73cS8lWbgwordQMxfKdN4HZ
9+d8sqOCoMhWOw8A30gW23wSbAma2EnQeCiFQukTms07OikqZbhSeVnAsk8zXd0e
GPBcVs+9bIVPajbkRwPSXCcUxkMnWjZzHnxHpts5v0WhfRZV9/kqmFNK4AURpy1h
wdh+BsscpkL5T9YdDA/P1xUxJxeJSVdWfS83Op9DLLko8W6zLTs3i9WMj/+UMI5h
cNvnkdcPiFcGHdOjdwOAI9vstf1m/WJpvZZUyUjzGiQWEe0Oky6v1CtusoQOGaXD
EuDk6eHUXw197cdHSV+Ewil0U3WucSo1GoNOIUb7g1vLYA21ek8rCrUD8TlKXqIm
A2aPC8pp3wdrsupUBIhP
=Mnbh
-----END PGP SIGNATURE-----

--NLA1NCqm3j0S6PTaMq4RCmDCUHtXFx1ax--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
