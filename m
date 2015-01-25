From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Sun, 25 Jan 2015 14:54:43 +0200
Message-ID: <54C4E793.2010103@dev.mellanox.co.il>
References: <cover.1421936879.git.dledford@redhat.com> <1422031938.3352.286.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422031938.3352.286.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/23/2015 6:52 PM, Doug Ledford wrote:
> On Thu, 2015-01-22 at 09:31 -0500, Doug Ledford wrote:
>> My 8 patch set taken into 3.19 caused some regressions.  This patch
>> set resolves those issues.
>>
>> These patches are to resolve issues created by my previous patch set.
>> While that set worked fine in my testing, there were problems with
>> multicast joins after the initial set of joins had completed.  Since my
>> testing relied upon the normal set of multicast joins that happen
>> when the interface is first brought up, I missed those problems.
>>
>> Symptoms vary from failure to send packets due to a failed join, to
>> loss of connectivity after a subnet manager restart, to failure
>> to properly release multicast groups on shutdown resulting in hangs
>> when the mlx4 driver attempts to unload itself via its reboot
>> notifier handler.
>>
>> This set of patches has passed a number of tests above and beyond my
>> original tests.  As suggested by Or Gerlitz I added IPv6 and IPv4
>> multicast tests.  I also added both subnet manager restarts and
>> manual shutdown/restart of individual ports at the switch in order to
>> ensure that the ENETRESET path was properly tested.  I included
>> testing, then a subnet manager restart, then a quiescent period for
>> caches to expire, then restarting testing to make sure that arp and
>> neighbor discovery work after the subnet manager restart.
>>
>> All in all, I have not been able to trip the multicast joins up any
>> longer.
>>
>> Additionally, the original impetus for my first 8 patch set was that
>> it was simply too easy to break the IPoIB subsystem with this simple
>> loop:
>>
>> while true; do
>>      ifconfig ib0 up
>>      ifconfig ib0 down
>> done
>>
>> Just to be safe, I made sure this problem did not resurface.
>>
>> v5: fix an oversight in mcast_restart_task that leaked mcast joins
>>      fix a failure to flush the ipoib_workqueue on deregister that
>>      meant we could end up running our code after our device had been
>>      removed, resulting in an oops
>>      remove a debug message that could be trigger so fast that the
>>      kernel printk mechanism would starve out the mcast join task thread
>>      resulting in what looked like a mcast failure that was really just
>>      delayed action
>>
>>
>> Doug Ledford (10):
>>    IB/ipoib: fix IPOIB_MCAST_RUN flag usage
>>    IB/ipoib: Add a helper to restart the multicast task
>>    IB/ipoib: make delayed tasks not hold up everything
>>    IB/ipoib: Handle -ENETRESET properly in our callback
>>    IB/ipoib: don't restart our thread on ENETRESET
>>    IB/ipoib: remove unneeded locks
>>    IB/ipoib: fix race between mcast_dev_flush and mcast_join
>>    IB/ipoib: fix ipoib_mcast_restart_task
>>    IB/ipoib: flush the ipoib_workqueue on unregister
>>    IB/ipoib: cleanup a couple debug messages
>>
>>   drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
>>   drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +
>>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 234 ++++++++++++++-----------
>>   3 files changed, 131 insertions(+), 106 deletions(-)
>>
> FWIW, a couple different customers have tried a test kernel I built
> internally with my patches and I've had multiple reports that all
> previously observed issues have been resolved.
>

Hi Doug,
still see an issue with the last version, and as a result no sendonly or 
IPv6 is working.
The scenario is some how simple to reproduce, if there is a sendonly 
multicast group that failed to join (sm refuses, perhaps the group was 
closed, etc.) that causes all the other mcg's to be blocked behind it 
forever.
for example, there is bad mcg ff12:601b:ffff:0000:0000:0000:0000:0016 
that the sm refuses to join, and after some time the user tries to send 
packets to ip address 225.5.5.5 (mcg: 
ff12:401b:ffff:0000:0000:0000:0105:0505 )
the log will show something like:
[1561627.426080] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561633.726768] ib0: setting up send only multicast group for 
ff12:401b:ffff:0000:0000:0000:0105:0505
[1561643.498990] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561675.645424] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561691.718464] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561707.791609] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561723.864839] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561739.937981] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[1561756.010895] ib0: no multicast record for 
ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
....
....
for ever or till the sm will decide in the future to let 
ff12:601b:ffff:0000:0000:0000:0000:0016 join, till than no sendonly traffic.


The main cause is the concept that was broken for the send-only join, 
when you treat the sendonly like a regular mcg and add it to the mc list 
and to the mc_task etc.
(not consider other issues like packet drop, and bw of the sendonly traffic)
IMHO, sendonly is part of the TX flow as it was till now in the ipoib 
driver and should stay in that way.

I went over your comments to my patch, will try to response/ cover them 
ASAP.

Thanks, Erez






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
