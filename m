From: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM Failover
Date: Wed, 14 Oct 2009 09:13:38 -0400
Message-ID: <eafd71280910140613q387a057fu7ee49f305a0f830b@mail.gmail.com>
References: <B1EF3F77-622B-40DA-BB3D-DC35973B60A6@gmail.com>
	 <4AD2D75A.2020403@dev.mellanox.co.il> <4AD2E582.8010202@voltaire.com>
	 <4AD2E736.4050803@dev.mellanox.co.il>
	 <eafd71280910120703y7dfa04cbq114cf07d46c909fb@mail.gmail.com>
	 <4AD49DAB.4020206@dev.mellanox.co.il>
	 <eafd71280910130852k1166b980kdf7129a52dacd42f@mail.gmail.com>
	 <4AD4A72C.6000108@dev.mellanox.co.il>
	 <eafd71280910131426g1cd68d7k1c28aee185ac3b8d@mail.gmail.com>
	 <4AD58FED.1060800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD58FED.1060800-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It will be difficult to get you those logs until the older cluster is
decommissioned (which in theory should be soon), but as soon as I am
able I will get them too you.

On Wed, Oct 14, 2009 at 4:46 AM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Aaron,
>
> Aaron Knister wrote:
>>>>
>>>> As I said, the older opensms
>>>> on the older mellanox model HCAs failsover and failsback instantly=
=2E
>>>
>>> The instant failback is expected, and this is the bug that
>>> we're discussing. As for the instant failover - I'll check
>>> how the things supposed to work and get back to you.
>
> After checking this thing, I don't understand how the
> instant failover is possible. The only case it can
> work is if you don't have a switch in your subnet - just two HCAs con=
nected
> directly to each other.
> Is this the case?
>
> If not, then I'd like to see opensm logs.
> Please run opensm as before (-V -s 0 -e).
> Start OSM on node A with high priority.
> Start OSM on node B with low priority.
> Kill OSM on node A, and see that OSM on
> node B becomes master.
>
> I need only the log of the opensm on node B.
> Best if you could just attach it to the bugzilla
> issue form, but if you can't - you can mail it to me.
>
> -- Yevgeny
>
>>> -- Yevgeny
>>>
>>>> On Tue, Oct 13, 2009 at 11:32 AM, Yevgeny Kliteynik
>>>> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>>>
>>>>> Aaron,
>>>>>
>>>>> Thanks for the logs, this was really helpful.
>>>>> Looks like there is a handover race in the OSM -
>>>>> SM on node A misses the fact that SM on node B
>>>>> have gave up its mastership.
>>>>>
>>>>> There is a bugzilla issue the describes all the
>>>>> details of this race:
>>>>>
>>>>> https://bugs.openfabrics.org/show_bug.cgi?id=3D1499
>>>>>
>>>>> I've updated the issue form with your case, and we will continue
>>>>> following
>>>>> this bug there.
>>>>>
>>>>> -- Yevgeny
>>>>>
>>>>> Aaron Knister wrote:
>>>>>>
>>>>>> While the adapters have mellanox chipsets their actually IBM OEM
>>>>>> branded and IBM hasn't released the 2.7 fw yet. I'm a little hes=
itant
>>>>>> to apply the generic Mellanox FW.
>>>>>>
>>>>>> On Mon, Oct 12, 2009 at 4:22 AM, Yevgeny Kliteynik
>>>>>> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>>>>>
>>>>>>> Or Gerlitz wrote:
>>>>>>>>
>>>>>>>> Yevgeny Kliteynik wrote:
>>>>>>>>>
>>>>>>>>> There was a hand-over problem in OFED 1.4, but later it turne=
d =A0out
>>>>>>>>> to
>>>>>>>>> be
>>>>>>>>> FW issue. The thing is, FW version 2.6.648 doesn't =A0have th=
is bug
>>>>>>>>> any
>>>>>>>>> more...
>>>>>>>>
>>>>>>>> so things should work fine with the newly released 2.7 firmwar=
e?
>>>>>>>
>>>>>>> Yes
>>>>>>>
>>>>>>>> if this is still under question, Aaron, I suggest you open a
>>>>>>>> bugzilla
>>>>>>>> case
>>>>>>>> @ https://bugs.openfabrics.org and we can track from there.
>>>>>>>
>>>>>>> Good idea.
>>>>>>>
>>>>>>> -- Yevgeny
>>>>>>>
>>>>>>>> Or.
>>>>>>>>
>>>>>>>>
>>>
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
