From: Marian Marinov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [IPoIB] Missing join mcast events causing full machine lockup
Date: Thu, 4 Aug 2016 03:17:49 +0300
Message-ID: <05c7a1b5-c101-b398-b4e8-c3048c7e6ce9@kyup.com>
References: <57907A37.3000902@kyup.com> <1470165672.18081.37.camel@redhat.com>
 <CAJFSNy6USnLqcBiPEOcFOG8MrGq8gXwvakG48jHHi_-YgVaQ3g@mail.gmail.com>
 <1470169770.18081.44.camel@redhat.com> <57A1A8F2.8040709@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57A1A8F2.8040709-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/03/2016 11:18 AM, Nikolay Borisov wrote:
> 
> 
> On 08/02/2016 11:29 PM, Doug Ledford wrote:
>> On Tue, 2016-08-02 at 23:18 +0300, Nikolay Borisov wrote:
>>> On Tue, Aug 2, 2016 at 10:21 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> wrote:
>>>>
>>>> On Thu, 2016-07-21 at 10:31 +0300, Nikolay Borisov wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> With running the risk of sounding like a broken record, I came
>>>>> across
>>>>> another case where ipoib can cause the machine to go haywire due
>>>>> to
>>>>> missed join requests. This is on 4.4.14 kernel. Here is what I
>>>>> believe
>>>>> happens:
>>>>
>>>> [ snip long traces ]
>>>>
>>>>>
>>>>> This makes me wonder if using timeouts is actually better than
>>>>> blindly relying on completing the join.
>>>>
>>>> Blindly relying on the join completions is not what we do.  We are
>>>> very
>>>> careful to make sure we always have the right locking so that we
>>>> never
>>>> leave a join request in the BUSY state without running the
>>>> completion
>>>> at some time.  If you are seeing us do that, then it means we have
>>>> a
>>>> bug in our locking or state processing.  The answer then is to find
>>>> that bug and not to paper over it with a timeout.  Can you find
>>>> some
>>>> way to reproduce this with a 4.7 kernel?
>>>
>>> Unfortunately my environment is constrained to 4.4 kernel. I will,
>>> however,
>>> try and check if I can get a couple of IB-enabled nodes on 4.7 and
>>> see
>>> if something
>>> shows up. And while I don't have a 100% reproducer for it I see those
>>> symptoms rather regularly
>>> on production nodes. I'm able and happy to extract any runtime state
>>> that might be useful in debugging this i.e I can obtain crashdumps
>>> and
>>> reverse the state of the ipoib stacks. I've seen this issue on 3.12
>>> and on 4.4.
>>> Some of my previous emails also show this manifesting in hangs in
>>> cm_destroy_id
>>> as well. So clearly there is a problem there but it proves very
>>> elusive.
>>
>> Can you give any clues as to what's causing it?  Do you have link flap?
>> SM bounces?  Lots of multicast joins/leaves?
> 
> I spoke with the network admins and they said that the network is not flapping, 
> we shouldn't have a lot of join/leaves since the network is not that big and is 
> stable. E.g. once nodes joins they usually are not restarted. 
> 
> Here are some messages which result after the said hangs happen: 
> 
> Aug  1 04:53:51 node1 kernel: [29100.763267] ib0: Budget exhausted after napi rescheduled 
> Jul 31 21:29:46 node1 kernel: [ 2457.666476] NETDEV WATCHDOG: ib0 (ib_qib): transmit queue 0 timed out
> Jul 29 05:17:36 node1 kernel: [ 8797.968402] ib0: dev_queue_xmit failed to requeue packet
> Jul 23 19:27:22 node1 kernel: ib0: packet len 2200 (> 2048) too long to send, dropping
> Jul 25 01:01:52 node1 kernel: ib0: queue stopped 1, tx_head 124520708, tx_tail 124520580
> 
> Aug  2 10:05:26 node15 bird6: LocalIPv6: Socket error on ib0: No buffer space available
> 
> Also I'm being told that *sometimes* doing a remote port reset actually fixes the issue,
> but only sometimes as otherwise the port is completely inactive. 
> 
> I realize this is not much information but this issue really just rears its ugly head out
> of nowhere and usually there doesn't seem to be that much information ;(

Actually this happens when we setup 6-8 IB switches in a Ring topology with the MinHop SM routing algorithm. As this topology is not ok with the MinHop algorithm, the SM is regularly dropping some of the switches and leaving nodes there configured
but without access to the actual IB network outside their current switch. After some the SM again enables that port but disables another and so the network topology actually changes, frequently.

We are now changing the topology, but we would like to find why IPoIB behaves the way it behaves.

Marian
> 
>>
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
