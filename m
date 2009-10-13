From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenSM Failover
Date: Tue, 13 Oct 2009 18:13:32 +0200
Message-ID: <4AD4A72C.6000108@dev.mellanox.co.il>
References: <B1EF3F77-622B-40DA-BB3D-DC35973B60A6@gmail.com>	 <CBC039F5-9019-436D-AF6D-F887E860D07B@gmail.com>	 <4AD2D75A.2020403@dev.mellanox.co.il> <4AD2E582.8010202@voltaire.com>	 <4AD2E736.4050803@dev.mellanox.co.il>	 <eafd71280910120703y7dfa04cbq114cf07d46c909fb@mail.gmail.com>	 <4AD49DAB.4020206@dev.mellanox.co.il> <eafd71280910130852k1166b980kdf7129a52dacd42f@mail.gmail.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <eafd71280910130852k1166b980kdf7129a52dacd42f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Aaron Knister wrote:
> Thanks! I really appreciate that.
> 
> I still have a question about the initial failover- I'm still
> wondering why there's a 30 second delay. Wouldn't nodeA send some type
> of handover message (my IB knowledge is limited) to notify a subnet
> manager of a lower priority to take over?

When master SM dies, it can't notify anyone that it is dead.
Standby SM keeps polling the master SM, and if the latter is
dead, it will be getting timeouts on these polls.
The number of polls, and the time that passes between these
polls is configurable.
Default is 4 polls with 10 seconds waiting in between.

Note that SM fail-over might be very destructive to the 
traffic. Depending on the SM configuration, it can change LIDs,
routing, it will require flushing of all the path resolutions
on all the fabric nodes and refreshing all the multicast
membership in the subnet.

> As I said, the older opensms
> on the older mellanox model HCAs failsover and failsback instantly.

The instant failback is expected, and this is the bug that
we're discussing. As for the instant failover - I'll check
how the things supposed to work and get back to you.

-- Yevgeny

> On Tue, Oct 13, 2009 at 11:32 AM, Yevgeny Kliteynik
> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> Aaron,
>>
>> Thanks for the logs, this was really helpful.
>> Looks like there is a handover race in the OSM -
>> SM on node A misses the fact that SM on node B
>> have gave up its mastership.
>>
>> There is a bugzilla issue the describes all the
>> details of this race:
>>
>> https://bugs.openfabrics.org/show_bug.cgi?id=1499
>>
>> I've updated the issue form with your case, and we will continue following
>> this bug there.
>>
>> -- Yevgeny
>>
>> Aaron Knister wrote:
>>> While the adapters have mellanox chipsets their actually IBM OEM
>>> branded and IBM hasn't released the 2.7 fw yet. I'm a little hesitant
>>> to apply the generic Mellanox FW.
>>>
>>> On Mon, Oct 12, 2009 at 4:22 AM, Yevgeny Kliteynik
>>> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>> Or Gerlitz wrote:
>>>>> Yevgeny Kliteynik wrote:
>>>>>> There was a hand-over problem in OFED 1.4, but later it turned  out to
>>>>>> be
>>>>>> FW issue. The thing is, FW version 2.6.648 doesn't  have this bug any
>>>>>> more...
>>>>> so things should work fine with the newly released 2.7 firmware?
>>>> Yes
>>>>
>>>>> if this is still under question, Aaron, I suggest you open a bugzilla
>>>>> case
>>>>> @ https://bugs.openfabrics.org and we can track from there.
>>>> Good idea.
>>>>
>>>> -- Yevgeny
>>>>
>>>>> Or.
>>>>>
>>>>>
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
