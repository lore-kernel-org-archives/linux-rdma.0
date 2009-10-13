From: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM Failover
Date: Tue, 13 Oct 2009 11:52:00 -0400
Message-ID: <eafd71280910130852k1166b980kdf7129a52dacd42f@mail.gmail.com>
References: <B1EF3F77-622B-40DA-BB3D-DC35973B60A6@gmail.com>
	 <CBC039F5-9019-436D-AF6D-F887E860D07B@gmail.com>
	 <4AD2D75A.2020403@dev.mellanox.co.il> <4AD2E582.8010202@voltaire.com>
	 <4AD2E736.4050803@dev.mellanox.co.il>
	 <eafd71280910120703y7dfa04cbq114cf07d46c909fb@mail.gmail.com>
	 <4AD49DAB.4020206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD49DAB.4020206-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks! I really appreciate that.

I still have a question about the initial failover- I'm still
wondering why there's a 30 second delay. Wouldn't nodeA send some type
of handover message (my IB knowledge is limited) to notify a subnet
manager of a lower priority to take over? As I said, the older opensms
on the older mellanox model HCAs failsover and failsback instantly.

On Tue, Oct 13, 2009 at 11:32 AM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Aaron,
>
> Thanks for the logs, this was really helpful.
> Looks like there is a handover race in the OSM -
> SM on node A misses the fact that SM on node B
> have gave up its mastership.
>
> There is a bugzilla issue the describes all the
> details of this race:
>
> https://bugs.openfabrics.org/show_bug.cgi?id=3D1499
>
> I've updated the issue form with your case, and we will continue foll=
owing
> this bug there.
>
> -- Yevgeny
>
> Aaron Knister wrote:
>>
>> While the adapters have mellanox chipsets their actually IBM OEM
>> branded and IBM hasn't released the 2.7 fw yet. I'm a little hesitan=
t
>> to apply the generic Mellanox FW.
>>
>> On Mon, Oct 12, 2009 at 4:22 AM, Yevgeny Kliteynik
>> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>
>>> Or Gerlitz wrote:
>>>>
>>>> Yevgeny Kliteynik wrote:
>>>>>
>>>>> There was a hand-over problem in OFED 1.4, but later it turned =A0=
out to
>>>>> be
>>>>> FW issue. The thing is, FW version 2.6.648 doesn't =A0have this b=
ug any
>>>>> more...
>>>>
>>>> so things should work fine with the newly released 2.7 firmware?
>>>
>>> Yes
>>>
>>>> if this is still under question, Aaron, I suggest you open a bugzi=
lla
>>>> case
>>>> @ https://bugs.openfabrics.org and we can track from there.
>>>
>>> Good idea.
>>>
>>> -- Yevgeny
>>>
>>>> Or.
>>>>
>>>>
>>>
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
