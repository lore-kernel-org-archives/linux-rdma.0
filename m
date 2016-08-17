From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [IPoIB] Missing join mcast events causing full machine lockup
Date: Wed, 17 Aug 2016 14:26:43 +0300
Message-ID: <57B449F3.4090804@kyup.com>
References: <57907A37.3000902@kyup.com> <1470165672.18081.37.camel@redhat.com>
 <CAJFSNy6USnLqcBiPEOcFOG8MrGq8gXwvakG48jHHi_-YgVaQ3g@mail.gmail.com>
 <1470169770.18081.44.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470169770.18081.44.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 08/02/2016 11:29 PM, Doug Ledford wrote:
> On Tue, 2016-08-02 at 23:18 +0300, Nikolay Borisov wrote:
>> On Tue, Aug 2, 2016 at 10:21 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>>
>>> On Thu, 2016-07-21 at 10:31 +0300, Nikolay Borisov wrote:
>>>>
>>>> Hello,
>>>>
>>>> With running the risk of sounding like a broken record, I came
>>>> across
>>>> another case where ipoib can cause the machine to go haywire due
>>>> to
>>>> missed join requests. This is on 4.4.14 kernel. Here is what I
>>>> believe
>>>> happens:
>>>
>>> [ snip long traces ]
>>>
>>>>
>>>> This makes me wonder if using timeouts is actually better than
>>>> blindly relying on completing the join.
>>>
>>> Blindly relying on the join completions is not what we do.  We are
>>> very
>>> careful to make sure we always have the right locking so that we
>>> never
>>> leave a join request in the BUSY state without running the
>>> completion
>>> at some time.  If you are seeing us do that, then it means we have
>>> a
>>> bug in our locking or state processing.  The answer then is to find
>>> that bug and not to paper over it with a timeout.  Can you find
>>> some
>>> way to reproduce this with a 4.7 kernel?
>>
>> Unfortunately my environment is constrained to 4.4 kernel. I will,
>> however,
>> try and check if I can get a couple of IB-enabled nodes on 4.7 and
>> see
>> if something
>> shows up. And while I don't have a 100% reproducer for it I see those
>> symptoms rather regularly
>> on production nodes. I'm able and happy to extract any runtime state
>> that might be useful in debugging this i.e I can obtain crashdumps
>> and
>> reverse the state of the ipoib stacks. I've seen this issue on 3.12
>> and on 4.4.
>> Some of my previous emails also show this manifesting in hangs in
>> cm_destroy_id
>> as well. So clearly there is a problem there but it proves very
>> elusive.
> 
> Can you give any clues as to what's causing it?  Do you have link flap?
> SM bounces?  Lots of multicast joins/leaves?

Hello again, after some testing and a lot more reboots I think we've
managed to isolate a culprit. Based on data we've observed on the
switches it seems that when a particular switch is congested it can
start queuing packets internally, and after its queue overflows it will
start dropping packets. Our switches show that they are discarding a lot
of packets when we increase the amount of traffic. Since our network is
linear e.g. switch 1 -> switch 2-> switch 3 then if node on sw1 wants to
send packets to a node on sw2 and sw2 is congested then it might
silently discard packets. And this in turn causes the ipoib (and the MAD
drivers) to wait for a response on a packet they sent, but that never
got sent to its destination. Does that sound plausible?


> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
