From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Tue, 20 Oct 2015 17:50:30 +0300
Message-ID: <562654B6.8090501@mellanox.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
 <561FE452.3050304@redhat.com>
 <CAAKD3BBEfKTHPKyoTzMW3YESKJmGkcUkui=hjhsbyFRY+xDDEw@mail.gmail.com>
 <5624E0AE.8050702@redhat.com> <5624FC13.1090200@mellanox.com>
 <56250BD6.2050503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56250BD6.2050503-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/19/2015 6:27 PM, Doug Ledford wrote:
> On 10/19/2015 10:20 AM, Matan Barak wrote:
>> On 10/19/2015 3:23 PM, Doug Ledford wrote:
>
>>> This is a major cause of the slowness.  Unless you have a specific need
>>> of them, per-entry rwlocks are *NOT* a good idea.  I was going to bring
>>> this up separately, so I'll just mention it here.  Per entry locks help
>>> reduce contention when you have lots of multiple accessors.  Using
>>> rwlocks help reduce contention when you have a read-mostly entry that is
>>> only occasionally changed.  But every lock and every unlock (just like
>>> every atomic access) still requires a locked memory cycle.  That means
>>> every lock acquire and every lock release requires a synchronization
>>> event between all CPUs.  Using per-entry locks means that every entry
>>> triggers two of those synchronization events.  On modern Intel CPUs,
>>> they cost about 32 cycles per event.  If you are going to do something,
>>> and it can't be done without a lock, then grab a single lock and do it
>>> as fast as you can.  Only in rare cases would you want per-entry locks.
>>>
>>
>> I agree that every rwlock costs us locked access. However, lets look at
>> the common scenario here.
>
> No, let's not.  Especially if your "common scenario" causes you to
> ignore pathological bad behavior.  Optimizing for the common case is not
> an excuse to enable pathological behavior.
>
>> I think that in production stable systems, the
>> IPs our rdma-cm stack uses (and thus GIDs) should be pretty stable.
>
> Probably true.
>
>> Thus, most accesses should be read calls.
>
> Probably true.
>
>> That's why IMHO read-write
>> access makes sense here.
>
> Probably true.
>
>> Regarding single-lock vs per entry lock, it really depends on common an
>> entry could be updated while another entry is being used by an
>> application.
>
> No, it depends on more than that.  In addition to the frequency of
> updates versus lookups, there is also the issue of lookup cost and
> update cost.  Using per entry locks makes both the lookup cost and the
> update cost of anything other than the first gid in the table grow
> exponentially.  A good way to demonstrate this would be to create 100
> vlans on a RoCE device, then run the cmtime test between two hosts using
> the 100th vlan IP at each end.  Using per-entry locks, the performance
> of this test relative to using the first IP on the device will be
> pathologically bad.
>

That's correct, we"waste" #entries * <time of lock and unlock>. But we 
have to note this is mainly during the connecting part.

>> In a (future) dynamic system, you might want to create
>> containers dynamically, which will add a net device and change the
>> hardware GID table while other application (maybe in another container)
>> uses other GIDs, but this might be rare scenario.
>
> This is a non-issue.  Creating a container and an application inside
> that container to use an RDMA interface is already a heavy weight
> operation (minimum fork/exec/program startup).  Table lookups can be
> needed thousands of times per second under certain conditions and must
> be fast.  Per-entry locks are only fast for the first item in the list.
>   After that, they progressively get slower and slower than usage with a
> single lock.
>

We first used RCU and seqcount in order to protect each entry. When we 
changed that to rwlock, we added some per-entry work.

>> Ok, refactoring this code for a single lock shouldn't be problematic.
>> Regarding performance, I think the results here are vastly impacted by
>> the rate we'll add/remove IPs or upper net-devices in the background.
>
> Not really.  You will never add/remove IPs fast enough to justify
> per-entry locks, especially when you consider that ib_cache_gid_add
> calls find_gid twice, once going over the entire table if the gid isn't
> found, before ever calling add_gid.  The ocrdma table isn't bad because
> it's only 16 entries.  But the mlx4 table is going to be 128 I suspect,
> so you can do the test I mentioned above and use 100 vlans.  In that
> scenario, the 101st gid will require that you take and release 128 locks
> to scan for the entry in the list, it will come back empty, then you
> will take and release 101 locks until you find an empty entry, and then
> you will take a write lock as you write the gid.  That's 230 total
> locks, for 460 total locked memory operations at 32 cycles each, so a
> total of 14,720 cycles spent doing nothing but locking the memory bus.
> And each of those operations slows down all of the CPUs in the system.
>
> Where I've seen this sort of behavior totally wreck a production system
> is when the GID you need to look up is on port 2.  Even if it is the
> firstmost GID on port 2, if you have to search all of port 1's table
> first, then by the time you get to port 2's table, you've already lost.
>
> So, here's some suggestions:
>
> 1)  Use a single lock on the table per port.

Make sense as an enhancement.

> 2)  Change find_gid so that it will take an additional element, int
> *empty_idx, and as it is scanning the gid table, when it runs across an
> empty entry, if empty_idx != NULL, *empty_idx = idx;.  This prevents
> needing to scan the array twice.

Make sense as an enhancement.

> 3)  Consider optimizing the code by requiring that any time a GID is
> added, it must take the first empty spot, and any time one is deleted,
> any valid entries after it must be moved up to fill the empty spot, then
> optimize find_gid to quit once it finds an empty slot because it knows
> the rest of the table is empty.  Given that mlx4 keeps a huge 128 table
> array, this can be very helpful.

I don't think we want to change existing GID entries. Entities sometimes 
want to refer to GIDs via GID indices. Changing the GIDs order under 
their feet could be problematic.

> 4)  Does the table port struct have to use a mutex?  Could it be changed
> to a rwlock instead?  If so, you could changing write_gid so that it
> assumes it is called with the read lock on the port already held and it
> merely updates itself to a write lock when it is ready to write the
> entry to the array and update the card.  It would then downgrade back to
> a read lock on return and the calling function would hold the single
> read lock from the time it is ready to call find_gid until write_gid has
> returned.

AFAIK, read_locks can't be "upgraded" to write_locks. In addition, the 
cost of the locks here is negligible (assuming it's a per-table rwlock 
and not per entry lock). In all code paths that uses the table mutex, we 
call the vendor's command to write the GID table. Updating the GID table 
usually cost a lot more than the mutex locks.

> 5)  I noticed that ib_cache_gid_find_by_port calls find_gid without even
> taking the read lock, that needs fixed.
>
>

find_gid takes a per-entry read_lock. Which lock do you think is missing 
here?

Although it's mostly used in the connection part, I think the locking 
refactoring here is a good performance enhancement.
Because it is an enhancement, do you agree we could work here by gradual 
changes and change the locking schema later?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
