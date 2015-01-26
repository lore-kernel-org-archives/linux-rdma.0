From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Mon, 26 Jan 2015 12:27:52 +0200
Message-ID: <54C616A8.3050804@dev.mellanox.co.il>
References: <cover.1421936879.git.dledford@redhat.com>	 <1422031938.3352.286.camel@redhat.com>	 <54C4E793.2010103@dev.mellanox.co.il> <1422224477.3352.373.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000308000002070109080705"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422224477.3352.373.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000308000002070109080705
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/2015 12:21 AM, Doug Ledford wrote:
> On Sun, 2015-01-25 at 14:54 +0200, Erez Shitrit wrote:
>> On 1/23/2015 6:52 PM, Doug Ledford wrote:
>>> On Thu, 2015-01-22 at 09:31 -0500, Doug Ledford wrote:
>>>> My 8 patch set taken into 3.19 caused some regressions.  This patch
>>>> set resolves those issues.
>>>>
>>>> These patches are to resolve issues created by my previous patch set.
>>>> While that set worked fine in my testing, there were problems with
>>>> multicast joins after the initial set of joins had completed.  Since my
>>>> testing relied upon the normal set of multicast joins that happen
>>>> when the interface is first brought up, I missed those problems.
>>>>
>>>> Symptoms vary from failure to send packets due to a failed join, to
>>>> loss of connectivity after a subnet manager restart, to failure
>>>> to properly release multicast groups on shutdown resulting in hangs
>>>> when the mlx4 driver attempts to unload itself via its reboot
>>>> notifier handler.
>>>>
>>>> This set of patches has passed a number of tests above and beyond my
>>>> original tests.  As suggested by Or Gerlitz I added IPv6 and IPv4
>>>> multicast tests.  I also added both subnet manager restarts and
>>>> manual shutdown/restart of individual ports at the switch in order to
>>>> ensure that the ENETRESET path was properly tested.  I included
>>>> testing, then a subnet manager restart, then a quiescent period for
>>>> caches to expire, then restarting testing to make sure that arp and
>>>> neighbor discovery work after the subnet manager restart.
>>>>
>>>> All in all, I have not been able to trip the multicast joins up any
>>>> longer.
>>>>
>>>> Additionally, the original impetus for my first 8 patch set was that
>>>> it was simply too easy to break the IPoIB subsystem with this simple
>>>> loop:
>>>>
>>>> while true; do
>>>>       ifconfig ib0 up
>>>>       ifconfig ib0 down
>>>> done
>>>>
>>>> Just to be safe, I made sure this problem did not resurface.
>>>>
>>>> v5: fix an oversight in mcast_restart_task that leaked mcast joins
>>>>       fix a failure to flush the ipoib_workqueue on deregister that
>>>>       meant we could end up running our code after our device had been
>>>>       removed, resulting in an oops
>>>>       remove a debug message that could be trigger so fast that the
>>>>       kernel printk mechanism would starve out the mcast join task thread
>>>>       resulting in what looked like a mcast failure that was really just
>>>>       delayed action
>>>>
>>>>
>>>> Doug Ledford (10):
>>>>     IB/ipoib: fix IPOIB_MCAST_RUN flag usage
>>>>     IB/ipoib: Add a helper to restart the multicast task
>>>>     IB/ipoib: make delayed tasks not hold up everything
>>>>     IB/ipoib: Handle -ENETRESET properly in our callback
>>>>     IB/ipoib: don't restart our thread on ENETRESET
>>>>     IB/ipoib: remove unneeded locks
>>>>     IB/ipoib: fix race between mcast_dev_flush and mcast_join
>>>>     IB/ipoib: fix ipoib_mcast_restart_task
>>>>     IB/ipoib: flush the ipoib_workqueue on unregister
>>>>     IB/ipoib: cleanup a couple debug messages
>>>>
>>>>    drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
>>>>    drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +
>>>>    drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 234 ++++++++++++++-----------
>>>>    3 files changed, 131 insertions(+), 106 deletions(-)
>>>>
>>> FWIW, a couple different customers have tried a test kernel I built
>>> internally with my patches and I've had multiple reports that all
>>> previously observed issues have been resolved.
>>>
>> Hi Doug,
>> still see an issue with the last version, and as a result no sendonly or
>> IPv6 is working.
> I disagree with your assessment.  See below.
>
>> The scenario is some how simple to reproduce, if there is a sendonly
>> multicast group that failed to join (sm refuses, perhaps the group was
>> closed, etc.)
> This is not the case.  "failed to join" implies that the join completed
> with an error.  According to the logs below, something impossible is
> happening.
>
>>   that causes all the other mcg's to be blocked behind it
>> forever.
> Your right.  Because the join tasks are serialized and we only queue up
> one join at a time (something I would like to address, but not in the
> 3.19 timeframe), if one join simply never returns, as the logs below
> indicate, then it blocks up the whole system.
>
>> for example, there is bad mcg ff12:601b:ffff:0000:0000:0000:0000:0016
>> that the sm refuses to join, and after some time the user tries to send
>> packets to ip address 225.5.5.5 (mcg:
>> ff12:401b:ffff:0000:0000:0000:0105:0505 )
>> the log will show something like:
>> [1561627.426080] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> This is printed out by sendonly_join
>
>> [1561633.726768] ib0: setting up send only multicast group for
>> ff12:401b:ffff:0000:0000:0000:0105:0505
> This is part of mcast_send and indicates we have created the new group
> and added it to the mcast rbtree, but not that we've started the join.
>
>> [1561643.498990] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> Our mcast task got ran again, and we are restarting the same group for
> some reason.  Theoretically that means we should have cleared the busy
> flag on this group somehow, which requires that sendonly_join_complete
> must have been called.  However, I can't find a single code path in
> sendonly_join_complete that could possibly clear out the busy flag on
> this group and not result in a printout message of some sort.  Are you
> trimming the list of messages here?  The reason I say this is that these
> are the possibilities:
>
> sendonly_join_complete with status == ENETRESET, we silently drop out
> but we would immediately get an ib_event with netreset and process a
> flush, which would print out copious messages
> sendonly_join_complete with status == 0, we would call mcast_join_finish
> and the only silent return is if this is our broadcast group and
> priv->broadcast is not set, in which case we don't have link up and the
> silent failures and the failure to join any other address are normal and
> expected since the ipoib layer considers things dead without the
> broadcast group joined, every other return path will print out
> something, and in particular the attempt to get an ah on the group will
> always print out either success or failure
> sendonly_join_complete with status anything else results in a debug
> message about the join failing.
>
> As far as I know, your setup has the IPv4 broadcast attached and the
> link is up.  The group you are actually showing as bad is the IPv6
> MLDv2-capable Routers group and failure to join it should not be
> blocking anything else.  So I'm back to what I said before: unless you
> are trimming messages, this debug output makes no sense whatsoever and
> should be impossible to generate.

New (and full) dmesg attached, (after modprobe ib_ipoib, with all debug 
flags set) it is all there.

the case is simple: ping6
In device A:
# ip addr show ib0
19: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc mq state UP 
qlen 256
     link/infiniband 
a0:04:02:10:fe:80:00:00:00:00:00:00:00:02:c9:03:00:9f:3b:0a brd 
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
     inet 11.134.33.1/8 brd 11.255.255.255 scope global ib0
     inet6 fe80::202:c903:9f:3b0a/64 scope link
        valid_lft forever preferred_lft forever

In device B, where i have the latest version:
#ping6 fe80::202:c903:9f:3b0a -I ib0


>    Are you sure you have a clean tree
> with no possible merge oddities that are throwing your testing off?

double checked myself, new git, with the last 10 patches, recompiled all 
modules, reboot etc. the same issue.

#git log --oneline
362509a IB/ipoib: cleanup a couple debug messages
e8e1618 IB/ipoib: flush the ipoib_workqueue on unregister
867555c IB/ipoib: fix ipoib_mcast_restart_task
125a466 IB/ipoib: fix race between mcast_dev_flush and mcast_join
9b0908b IB/ipoib: remove unneeded locks
c2fb665 IB/ipoib: don't restart our thread on ENETRESET
2345213 IB/ipoib: Handle -ENETRESET properly in our callback
6ed68e8 IB/ipoib: make delayed tasks not hold up everything
bee92be5 IB/ipoib: Add a helper to restart the multicast task
2084aee IB/ipoib: fix IPOIB_MCAST_RUN flag usage
a7cfef2 Merge branches 'core', 'cxgb4', 'ipoib', 'iser', 'mlx4', 
'ocrdma', 'odp' and 'srp' into for-next
....
....



>> [1561675.645424] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [1561691.718464] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [1561707.791609] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [1561723.864839] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [1561739.937981] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
>> [1561756.010895] ib0: no multicast record for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
> These are all being queued with successively longer backoffs, exactly as
> they should be.
>
> In __ipoib_mcast_continue_join_thread, when we get called with delay !=
> 0, we end up doing two things.  One, we change the mcast->backoff from 1
> to whatever it should be now (minimum of 2, maximum of 16), and we set
> delay_until to jiffies + (HZ * mcast->backoff).  This lets the mcast
> task know to skip this group until such time as its backoff is expired.
>  From the messages above, that seems to be working. The other thing we do
> is we don't queue up the mcast thread just once, we queue it up twice.
> Once at the right time for the backoff, and again now (although there is
> a bug here, the second instance queues it up with delay as the time
> offset, that should be 0, that's a holdover from before, at least
> fortunately it is only ever 1 or 0 so it's not horrible, but things
> would go a little faster if I fix that so that the second instance is
> always 0).  That way the instance that's queued up first will know to
> skip the delayed group and continue on through the list, and that should
> allow us to get these other groups that you say are blocked.
>
>> ....
>> for ever or till the sm will decide in the future to let
>> ff12:601b:ffff:0000:0000:0000:0000:0016 join, till than no sendonly traffic.
>>
>>
>> The main cause is the concept that was broken for the send-only join,
>> when you treat the sendonly like a regular mcg and add it to the mc list
>> and to the mc_task etc.
> I'm looking at 3.18 right now, and 3.18 adds sendonly groups to the mcg
> just like my current code does.  The only difference, and I do mean
> *only*, is that it calls sendonly_join directly instead of via the
> mcast_task.

Yes, and i already wrote that it is more than just "only", it changed 
the concept of the sendonly mc packet.

>    The net effect of that is that sendonly joins are not
> serialized in the old version and they are in the new.  I'm more than
> happy to deserialize them, but I don't think that necessarily means we
> have to call sendonly_join directly from mcast_send, it could also be
> done by allowing the mcast_task to fire off more than one join at a
> time.  Whether we use the mcast_task or call sendonly_join directly is
> in-consequential, it's more an issue of whether or not we serialize the
> joins.
>
>> (not consider other issues like packet drop, and bw of the sendonly traffic)
>> IMHO, sendonly is part of the TX flow as it was till now in the ipoib
>> driver and should stay in that way.
> It seems like you're thinking of the mcast task thread as something that
> only runs as part of mcast joins or leaves when the upper layer calls
> set multicast list in our driver.  It used to be that way, but since I
> reworked the task thread, that's no longer the case.  As such, I don't
> think this distinction you are drawing is necessarily still correct.
>
>> I went over your comments to my patch, will try to response/ cover them
>> ASAP.
>>
>> Thanks, Erez
>>
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--------------000308000002070109080705
Content-Type: text/plain; charset=windows-1252;
 name="dmesg.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.txt"

WyAyNDI1LjkxMzI0NV0gaWIwOiBicmluZ2luZyB1cCBpbnRlcmZhY2UKWyAyNDI1LjkxODAz
NV0gaWIwOiBzdGFydGluZyBtdWx0aWNhc3QgdGhyZWFkClsgMjQyNS45MjIyNjBdIElQdjY6
IEFERFJDT05GKE5FVERFVl9VUCk6IGliMDogbGluayBpcyBub3QgcmVhZHkKWyAyNDI1Ljky
ODU0Ml0gaWIwOiBqb2luaW5nIE1HSUQgZmYxMjo0MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6
ZmZmZjpmZmZmClsgMjQyNS45MzUwNjVdIGliMDogcmVzdGFydGluZyBtdWx0aWNhc3QgdGFz
awpbIDI0MjUuOTM5MjI4XSBpYjA6IGFkZGluZyBtdWx0aWNhc3QgZW50cnkgZm9yIG1naWQg
ZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDAxClsgMjQyNS45MzkzMzVd
IGliMDogam9pbiBjb21wbGV0aW9uIGZvciBmZjEyOjQwMWI6ZmZmZjowMDAwOjAwMDA6MDAw
MDpmZmZmOmZmZmYgKHN0YXR1cyAwKQpbIDI0MjUuOTU1NTM4XSBpYjA6IGFkZGluZyBtdWx0
aWNhc3QgZW50cnkgZm9yIG1naWQgZmYxMjo0MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAw
MDowMDAxClsgMjQyNS45NjQ4OTFdIGliMDogQ3JlYXRlZCBhaCBmZmZmODgwMGNhMGIyNGMw
ClsgMjQyNS45NjkyMzFdIGliMDogTUdJRCBmZjEyOjQwMWI6ZmZmZjowMDAwOjAwMDA6MDAw
MDpmZmZmOmZmZmYgQVYgZmZmZjg4MDBjYTBiMjRjMCwgTElEIDB4YzAwMCwgU0wgMApbIDI0
MjUuOTc4NDM0XSBpYjA6IGpvaW5pbmcgTUdJRCBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6
MDAwMDowMDAwOjAwMDEKWyAyNDI1Ljk4NTYxM10gaWIwOiBqb2luaW5nIE1HSUQgZmYxMjo0
MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDAxClsgMjQyNS45OTI1OTVdIElQdjY6
IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBpYjA6IGxpbmsgYmVjb21lcyByZWFkeQpbIDI0
MjUuOTk4OTY3XSBpYjA6IHJlc3RhcnRpbmcgbXVsdGljYXN0IHRhc2sKWyAyNDI2LjAwMTE4
M10gaWIwOiBzZXR0aW5nIHVwIHNlbmQgb25seSBtdWx0aWNhc3QgZ3JvdXAgZm9yIGZmMTI6
NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNgpbIDI0MjYuMDEyMTIzXSBpYjA6
IGFkZGluZyBtdWx0aWNhc3QgZW50cnkgZm9yIG1naWQgZmYxMjo2MDFiOmZmZmY6MDAwMDow
MDAwOjAwMDE6ZmY0MzozYmYxClsgMjQyNi4wMjEwNTldIGliMDogbm8gbXVsdGljYXN0IHJl
Y29yZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGFy
dGluZyBzZW5kb25seSBqb2luClsgMjQyNi4zMzAyOTddIGliMDogam9pbiBjb21wbGV0aW9u
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMDEgKHN0YXR1cyAw
KQpbIDI0MjYuMzM5MDU0XSBpYjA6IENyZWF0ZWQgYWggZmZmZjg4MDBjYTBiMjVjMApbIDI0
MjYuMzQzMzg5XSBpYjA6IE1HSUQgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAw
MDowMDAxIEFWIGZmZmY4ODAwY2EwYjI1YzAsIExJRCAweGMwMTYsIFNMIDAKWyAyNDI2LjM1
MzkwMV0gaWIwOiBqb2luIGNvbXBsZXRpb24gZm9yIGZmMTI6NDAxYjpmZmZmOjAwMDA6MDAw
MDowMDAwOjAwMDA6MDAwMSAoc3RhdHVzIDApClsgMjQyNi4zNjI5ODRdIGliMDogQ3JlYXRl
ZCBhaCBmZmZmODgwNDFmMTA0NDQwClsgMjQyNi4zNjczMTZdIGliMDogTUdJRCBmZjEyOjQw
MWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMDEgQVYgZmZmZjg4MDQxZjEwNDQ0MCwg
TElEIDB4YzAxNCwgU0wgMApbIDI0MjYuMzc2NDg3XSBpYjA6IHNlbmRvbmx5IG11bHRpY2Fz
dCBqb2luIGZhaWxlZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDow
MDE2LCBzdGF0dXMgLTIyClsgMjQyNi4zODYwMzJdIGliMDogam9pbmluZyBNR0lEIGZmMTI6
NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAxOmZmNDM6M2JmMQpbIDI0MjYuMzkzMTYyXSBpYjA6
IGpvaW4gY29tcGxldGlvbiBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDE6ZmY0
MzozYmYxIChzdGF0dXMgMCkKWyAyNDI2LjQwMjAxM10gaWIwOiBDcmVhdGVkIGFoIGZmZmY4
ODA0MWYxMTUzNDAKWyAyNDI2LjQwNjM0OV0gaWIwOiBNR0lEIGZmMTI6NjAxYjpmZmZmOjAw
MDA6MDAwMDowMDAxOmZmNDM6M2JmMSBBViBmZmZmODgwNDFmMTE1MzQwLCBMSUQgMHhjMDE4
LCBTTCAwClsgMjQyNi40MTU1NjddIGliMDogc3VjY2Vzc2Z1bGx5IGpvaW5lZCBhbGwgbXVs
dGljYXN0IGdyb3VwcwpbIDI0MjYuNDIxNjEwXSBpYjA6IHN1Y2Nlc3NmdWxseSBqb2luZWQg
YWxsIG11bHRpY2FzdCBncm91cHMKWyAyNDI3LjAzNzkwM10gaWIwOiBzZXR0aW5nIHVwIHNl
bmQgb25seSBtdWx0aWNhc3QgZ3JvdXAgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDow
MDAwOjAwMDA6MDAwMgpbIDI0MjcuMDQ3Njc3XSBpYjA6IG5vIG11bHRpY2FzdCByZWNvcmQg
Zm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAwMiwgc3RhcnRpbmcg
c2VuZG9ubHkgam9pbgpbIDI0MjcuMDU3MzYyXSBpYjA6IHNlbmRvbmx5IG11bHRpY2FzdCBq
b2luIGZhaWxlZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDAy
LCBzdGF0dXMgLTIyClsgMjQyOS4wNzM3NzRdIGliMDogbm8gbXVsdGljYXN0IHJlY29yZCBm
b3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGFydGluZyBz
ZW5kb25seSBqb2luClsgMjQyOS4wODMzOTFdIGliMDogc2VuZG9ubHkgbXVsdGljYXN0IGpv
aW4gZmFpbGVkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYs
IHN0YXR1cyAtMjIKWyAyNDMzLjEwMDIwN10gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3JkIGZv
ciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5nIHNl
bmRvbmx5IGpvaW4KWyAyNDMzLjEwOTgyMF0gaWIwOiBzZW5kb25seSBtdWx0aWNhc3Qgam9p
biBmYWlsZWQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwg
c3RhdHVzIC0yMgpbIDI0MzQuNTk0NjM3XSBpYjA6IHNldHRpbmcgdXAgc2VuZCBvbmx5IG11
bHRpY2FzdCBncm91cCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDE6ZmY5Zjoz
YjBhClsgMjQ0MS4xMzY2NzFdIGliMDogbm8gbXVsdGljYXN0IHJlY29yZCBmb3IgZmYxMjo2
MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGFydGluZyBzZW5kb25seSBq
b2luClsgMjQ0MS4xNDYyNzldIGliMDogc2VuZG9ubHkgbXVsdGljYXN0IGpvaW4gZmFpbGVk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXR1cyAt
MjIKWyAyNDU3LjIxMDA0NF0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3JkIGZvciBmZjEyOjYw
MWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5nIHNlbmRvbmx5IGpv
aW4KWyAyNDU3LjIxOTY1Ml0gaWIwOiBzZW5kb25seSBtdWx0aWNhc3Qgam9pbiBmYWlsZWQg
Zm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwgc3RhdHVzIC0y
MgpbIDI0NzMuMjgyODY5XSBpYjA6IG5vIG11bHRpY2FzdCByZWNvcmQgZm9yIGZmMTI6NjAx
YjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwgc3RhcnRpbmcgc2VuZG9ubHkgam9p
bgpbIDI0NzMuMjkyNDgyXSBpYjA6IHNlbmRvbmx5IG11bHRpY2FzdCBqb2luIGZhaWxlZCBm
b3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGF0dXMgLTIy
ClsgMjQ4OS4zNTYxMzhdIGliMDogbm8gbXVsdGljYXN0IHJlY29yZCBmb3IgZmYxMjo2MDFi
OmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGFydGluZyBzZW5kb25seSBqb2lu
ClsgMjQ4OS4zNjU3NDldIGliMDogc2VuZG9ubHkgbXVsdGljYXN0IGpvaW4gZmFpbGVkIGZv
ciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXR1cyAtMjIK
WyAyNTA1LjQyOTMyNV0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3JkIGZvciBmZjEyOjYwMWI6
ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5nIHNlbmRvbmx5IGpvaW4K
WyAyNTA1LjQzODk0MV0gaWIwOiBzZW5kb25seSBtdWx0aWNhc3Qgam9pbiBmYWlsZWQgZm9y
IGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwgc3RhdHVzIC0yMgpb
IDI1MTYuMTkxMzM5XSBpYjA6IG5laWdoIGZyZWUgZm9yIGZmZmZmZiBmZjEyOjYwMWI6ZmZm
ZjowMDAwOjAwMDA6MDAwMTpmZjQzOjNiZjEKWyAyNTIxLjUwMjE0MV0gaWIwOiBubyBtdWx0
aWNhc3QgcmVjb3JkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAw
MTYsIHN0YXJ0aW5nIHNlbmRvbmx5IGpvaW4KWyAyNTIxLjUxMTc0NF0gaWIwOiBzZW5kb25s
eSBtdWx0aWNhc3Qgam9pbiBmYWlsZWQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDow
MDAwOjAwMDA6MDAxNiwgc3RhdHVzIC0yMgpbIDI1MzcuNTc1Mzc1XSBpYjA6IG5vIG11bHRp
Y2FzdCByZWNvcmQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAx
Niwgc3RhcnRpbmcgc2VuZG9ubHkgam9pbgpbIDI1MzcuNTg0OTgwXSBpYjA6IHNlbmRvbmx5
IG11bHRpY2FzdCBqb2luIGZhaWxlZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAw
MDA6MDAwMDowMDE2LCBzdGF0dXMgLTIyClsgMjU1My42NDg1MzFdIGliMDogbm8gbXVsdGlj
YXN0IHJlY29yZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2
LCBzdGFydGluZyBzZW5kb25seSBqb2luClsgMjU1My42NTgxMzddIGliMDogc2VuZG9ubHkg
bXVsdGljYXN0IGpvaW4gZmFpbGVkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAw
MDowMDAwOjAwMTYsIHN0YXR1cyAtMjIKWyAyNTY5LjcyMTUzOV0gaWIwOiBubyBtdWx0aWNh
c3QgcmVjb3JkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYs
IHN0YXJ0aW5nIHNlbmRvbmx5IGpvaW4KWyAyNTY5LjczMTE0M10gaWIwOiBzZW5kb25seSBt
dWx0aWNhc3Qgam9pbiBmYWlsZWQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAw
OjAwMDA6MDAxNiwgc3RhdHVzIC0yMgpbIDI1ODUuNzk0Njk0XSBpYjA6IG5vIG11bHRpY2Fz
dCByZWNvcmQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwg
c3RhcnRpbmcgc2VuZG9ubHkgam9pbgpbIDI1ODUuODA0MzA3XSBpYjA6IHNlbmRvbmx5IG11
bHRpY2FzdCBqb2luIGZhaWxlZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6
MDAwMDowMDE2LCBzdGF0dXMgLTIyClsgMjYwMS44Njc5OTNdIGliMDogbm8gbXVsdGljYXN0
IHJlY29yZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBz
dGFydGluZyBzZW5kb25seSBqb2luClsgMjYwMS44Nzc2MDBdIGliMDogc2VuZG9ubHkgbXVs
dGljYXN0IGpvaW4gZmFpbGVkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDow
MDAwOjAwMTYsIHN0YXR1cyAtMjIKWyAyNjE3Ljk0MDkyOV0gaWIwOiBubyBtdWx0aWNhc3Qg
cmVjb3JkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0
YXJ0aW5nIHNlbmRvbmx5IGpvaW4KWyAyNjE3Ljk1MDUzOF0gaWIwOiBzZW5kb25seSBtdWx0
aWNhc3Qgam9pbiBmYWlsZWQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAw
MDA6MDAxNiwgc3RhdHVzIC0yMgpbIDI2MzQuMDE0MTY1XSBpYjA6IG5vIG11bHRpY2FzdCBy
ZWNvcmQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwgc3Rh
cnRpbmcgc2VuZG9ubHkgam9pbgpbIDI2MzQuMDIzNzc2XSBpYjA6IHNlbmRvbmx5IG11bHRp
Y2FzdCBqb2luIGZhaWxlZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAw
MDowMDE2LCBzdGF0dXMgLTIyClsgMjY1MC4wODczNjddIGliMDogbm8gbXVsdGljYXN0IHJl
Y29yZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGFy
dGluZyBzZW5kb25seSBqb2luClsgMjY1MC4wOTY5NzJdIGliMDogc2VuZG9ubHkgbXVsdGlj
YXN0IGpvaW4gZmFpbGVkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAw
OjAwMTYsIHN0YXR1cyAtMjIKWyAyNjY2LjE2MDE5Nl0gaWIwOiBubyBtdWx0aWNhc3QgcmVj
b3JkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0
aW5nIHNlbmRvbmx5IGpvaW4KWyAyNjY2LjE2OTgxMV0gaWIwOiBzZW5kb25seSBtdWx0aWNh
c3Qgam9pbiBmYWlsZWQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6
MDAxNiwgc3RhdHVzIC0yMgpbIDI2ODIuMjMzMzU5XSBpYjA6IG5vIG11bHRpY2FzdCByZWNv
cmQgZm9yIGZmMTI6NjAxYjpmZmZmOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAxNiwgc3RhcnRp
bmcgc2VuZG9ubHkgam9pbgpbIDI2ODIuMjQyOTY5XSBpYjA6IHNlbmRvbmx5IG11bHRpY2Fz
dCBqb2luIGZhaWxlZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDow
MDE2LCBzdGF0dXMgLTIyClsgMjY5OC4zMDY1NDVdIGliMDogbm8gbXVsdGljYXN0IHJlY29y
ZCBmb3IgZmYxMjo2MDFiOmZmZmY6MDAwMDowMDAwOjAwMDA6MDAwMDowMDE2LCBzdGFydGlu
ZyBzZW5kb25seSBqb2luClsgMjY5OC4zMTYxNTFdIGliMDogc2VuZG9ubHkgbXVsdGljYXN0
IGpvaW4gZmFpbGVkIGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAw
MTYsIHN0YXR1cyAtMjIKWyAyNzE0LjM3OTUwN10gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyNzMwLjQ1MjY4OF0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyNzQ2LjUyNTgxMV0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyNzYyLjU5ODkyNV0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyNzc4LjY3MjE0Nl0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyNzk0Ljc0NTE3MV0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyODEwLjgxODE3MV0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyODI2Ljg5MTU0MV0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4KWyAyODQyLjk2NDU0Nl0gaWIwOiBubyBtdWx0aWNhc3QgcmVjb3Jk
IGZvciBmZjEyOjYwMWI6ZmZmZjowMDAwOjAwMDA6MDAwMDowMDAwOjAwMTYsIHN0YXJ0aW5n
IHNlbmRvbmx5IGpvaW4K
--------------000308000002070109080705--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
