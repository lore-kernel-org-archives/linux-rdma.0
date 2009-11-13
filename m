From: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_state_mgr.c: force heavy sweep when fabric
	consists of single switch
Date: Fri, 13 Nov 2009 10:24:20 +0200
Message-ID: <694d48600911130024vd803e5fhf835690742f14ba7@mail.gmail.com>
References: <4AF0056A.5030503@dev.mellanox.co.il>
	 <4AF27EDB.6070604@dev.mellanox.co.il> <4AF6D619.8000908@gmail.com>
	 <4AF7D040.2060807@dev.mellanox.co.il> <4AF7F22D.9010609@gmail.com>
	 <4AF7F864.6030809@dev.mellanox.co.il> <4AF81F15.1080205@gmail.com>
	 <4AFA80A5.8080809@dev.mellanox.co.il> <4AFBC1B7.8090509@gmail.com>
	 <4AFC04A8.1040808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AFC04A8.1040808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2009 at 2:50 PM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Eli Dorfman (Voltaire) wrote:
>>
>> Yevgeny Kliteynik wrote:
>>>
>>> Eli Dorfman (Voltaire) wrote:
>>>>
>>>> Yevgeny Kliteynik wrote:
>>>>>
>>>>> Eli Dorfman (Voltaire) wrote:
>>>>>>
>>>>>> Yevgeny Kliteynik wrote:
>>>>>>>
>>>>>>> Eli Dorfman (Voltaire) wrote:
>>>>>>>>
>>>>>>>> Yevgeny Kliteynik wrote:
>>>>>>>>>
>>>>>>>>> Yevgeny Kliteynik wrote:
>>>>>>>>>>
>>>>>>>>>> Line Holen wrote:
>>>>>>>>>>>
>>>>>>>>>>> On 11/ 4/09 04:54 PM, Yevgeny Kliteynik wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> Line Holen wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 11/ 4/09 10:47 AM, Yevgeny Kliteynik wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Sasha Khapyorsky wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 12:26 Tue 03 Nov =C2=A0 =C2=A0 , Yevgeny Kliteynik w=
rote:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Always do heavy sweep when there is only one node in t=
he
>>>>>>>>>>>>>>>> fabric, and this node is a switch, and SM runs on top =
of it
>>>>>>>>>>>>>>>> -
>>>>>>>>>>>>>>>> there may be a race when OSM starts running before the
>>>>>>>>>>>>>>>> external ports are ports are up, or if they went throu=
gh
>>>>>>>>>>>>>>>> reset while SM was starting.
>>>>>>>>>>>>>>>> In this race switch brings up the ports and turns on t=
he
>>>>>>>>>>>>>>>> PSC bit, but OSM might get PortInfo before SwitchInfo,=
 and
>>>>>>>>>>>>>>>> it
>>>>>>>>>>>>>>>> might see all ports as down, but PSC bit on. If that
>>>>>>>>>>>>>>>> happens,
>>>>>>>>>>>>>>>> OSM turns off PSC bit, and it will never see external =
ports
>>>>>>>>>>>>>>>> again - it won't perform any heavy sweep, only light s=
weep
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Could such race happen when there are more than one nod=
e in a
>>>>>>>>>>>>>>> fabric?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I think that my description of the race was misleading.
>>>>>>>>>>>>>> The race can happen on *any* fabric when SM runs on swit=
ch.
>>>>>>>>>>>>>> But when it does happen, SM thinks that the whole subnet
>>>>>>>>>>>>>> is just one switch - that's what it managed to discover.
>>>>>>>>>>>>>> I've actually seen it happening.
>>>>>>>>>>>>>> So the patch fixes this particular case.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So the next question that you would probably ask is can
>>>>>>>>>>>>>> this race happen on some *other* switch and not the one
>>>>>>>>>>>>>> SM is running on?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Well, I don't know. I have a hunch that it can't, but I
>>>>>>>>>>>>>> couldn't prove it to myself yet.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The race on the managed switch is a special case because
>>>>>>>>>>>>>> SM always sees port 0, and always gets responses to its
>>>>>>>>>>>>>> SMP queries. On any other switch, if the ports were rese=
t,
>>>>>>>>>>>>>> SM won't get any response until the ports are up again.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Perhaps there might be a case where SM got some port as =
down,
>>>>>>>>>>>>>> and by the time SM got SwitchInfo with PSC bit the port
>>>>>>>>>>>>>> was already up, so SM won't start discovery beyond this
>>>>>>>>>>>>>> port. But this race would be fixed on the next heavy swe=
ep,
>>>>>>>>>>>>>> when SM will discover this port that it missed the previ=
ous
>>>>>>>>>>>>>> time, whereas race on managed switch is fatal - SM won't
>>>>>>>>>>>>>> ever do any heavy sweep.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> -- Yevgeny
>>>>>>>>>>>>>
>>>>>>>>>>>>> At least for the 3.2 branch there is a general race
>>>>>>>>>>>>> regardless of
>>>>>>>>>>>>> where the SM is running. I haven't checked the current
>>>>>>>>>>>>> master, but
>>>>>>>>>>>>> I cannot recall seeing any patches related to this so I a=
ssume
>>>>>>>>>>>>> the race is still there.
>>>>>>>>>>>>>
>>>>>>>>>>>>> There is a window between SM discovering a switch and
>>>>>>>>>>>>> clearing PSC
>>>>>>>>>>>>> for the same switch. The SM will not detect a state chang=
e on
>>>>>>>>>>>>> the
>>>>>>>>>>>>> switch ports during this time.
>>>>>>>>>>>>
>>>>>>>>>>>> If the port changes state during that period, the switch i=
ssues
>>>>>>>>>>>> new trap 128, which (I think) should cause SM to re-discov=
er the
>>>>>>>>>>>> fabric once this discovery cycle is over. Is this correct?
>>>>>>>>>>>>
>>>>>>>>>>> I think the switch shall send a trap whenever it sets the P=
SC
>>>>>>>>>>> bit.
>>>>>>>>>>> Once set I believe it will not send another trap until it i=
s
>>>>>>>>>>> reset.
>>>>>>>>>>> Or do I misinterpret the spec ?
>>>>>>>>>>
>>>>>>>>>> I may be wrong, but I thought that this is how things work:
>>>>>>>>>> - port state changes
>>>>>>>>>> - switch turns on PSC bit and starts sending traps
>>>>>>>>>> - SM gets the trap, sends trap repress
>>>>>>>>>> - switch gets trap repress and stops sending traps
>>>>>>>>>> - PSC is still on
>>>>>>>>>> - port state changes again (the same or any other port)
>>>>>>>>>> - switch turns on PSC bit (which doesn't matter as PSC is
>>>>>>>>>> =C2=A0already on) and starts sending traps again
>>>>>>>>>> - etc...
>>>>>>>>>>
>>>>>>>>>> Anyway, I'll double-check this issue.
>>>>>>>>>
>>>>>>>>> Yep, verified.
>>>>>>>>> Switch sends traps regardless the PSC bit status.
>>>>>>>>> Also, the spec doesn't link them together:
>>>>>>>>>
>>>>>>>>> =C2=A0o14-5.1.1: If a switch supports Traps (PortInfo:
>>>>>>>>> =C2=A0CapabilityMask.IsTrap-Supported is one), its SMA
>>>>>>>>> =C2=A0shall send trap 128 to the SM indicated by the
>>>>>>>>> PortInfo:MasterSMLID
>>>>>>>>> under any condition that =C2=A0 would cause SwitchInfo:PortSt=
ateChange
>>>>>>>>> to
>>>>>>>>> be set
>>>>>>>>> =C2=A0to one. (See 14.2.5.4 SwitchInfo on page 827.)
>>>>>>>>>
>>>>>>>> Trap will be sent according to the SMLID. After first bring up=
 the
>>>>>>>> SMLID is not set yet and trap will not be sent.
>>>>>>>> In that case the opensm would discover the change only by PSC =
bit.
>>>>>>>> For IS3 chips the PSC bit and/or trap were set only after one =
or
>>>>>>>> more
>>>>>>>> ports changed their state, so I don't understand how can the S=
M
>>>>>>>> discover PSC bit set while all ports are down. Or is this a ch=
ange
>>>>>>>> in
>>>>>>>> IS4?
>>>>>>>
>>>>>>> It can happen when SM runs on the switch, not not host.
>>>>>>> In this case if all ports are going down, SM will see
>>>>>>> them all down and it will see PSC bit on.
>>>>>>
>>>>>> So this patch is only for SM running on a switch which is the on=
ly
>>>>>> node in the fabric?
>>>>>> I don't see the race when there is more than one switch - please
>>>>>> explain.
>>>>>
>>>>> Quoting from above:
>>>>>
>>>>> =C2=A0The race can happen on *any* fabric when SM runs on switch.
>>>>> =C2=A0But when it does happen, SM thinks that the whole subnet
>>>>> =C2=A0is just one switch - that's what it managed to discover.
>>>>
>>>> I saw that but I don't understand how this can happen.
>>>> If PSC bit is set after *every* port state change and
>>>> SM clears PSC bit before reading PortInfo from the switch,
>>>
>>> osm_node_info_rcv.c, ni_rcv_process_switch():
>>> I see in the code that SM receives NodeInfo, then it requests
>>> SwitchInfo and right after that it requests PortInfo for all
>>> the ports w/o waiting for the SwitchInfo response.
>>> In addition to that, if it happens during the first master
>>> sweep, SM LID is not configured yet, or configured to the
>>> wrong value, so no traps will be received by the SM.
>>
>> I agree that trap will not be received but still PSC bit in SwitchIn=
fo
>> will be set for any port transition.
>> See also the spec:
>> "It is set to one anytime the PortState component in the
>> PortInfo of any ports transitions from Down to Initialize,
>> Initialize to Down, Armed to Down, or Active to Down as
>> a result of link state machine logic. Changes in Portstate
>> resulting from SubnSet() do not change this bit.
>> This bit is cleared by writing one, writing zero is
>> ignored."
>>
>> The problem is that switch info PSC bit is cleared too late - in
>> osm_ucast_mgr.c, ucast_mgr_set_fwd_top()
>> and not earlier (i.e. in osm_sw_info_rcv.c,
>> osm_si_rcv_process_existing()).
>> The PSC bit should be cleared before SM reads the PortInfo from that
>> switch.
>
> This may be true, but do you really want to require
> Set(SwitchInfo) *completion* before getting other PortInfo
> MADs from this switch?

I don't see any other good alternative and I'm sure this will solve
all race conditions.
Most of the Set(SwitchInfo) request will be sent in parallel to other
discovery MAD PortInfo, NodeInfo, etc.

> First of all, this means that you will have more than one
> Set(SwitchInfo) for the switch (during the discovery you
> don't know what is the LFT top).

That is correct but number of switches is small and compared to all
the MADs that are sent during discovery
this is a very small penalty.

> Second, it will slow down
> the whole discovery - you will introduce lots of new
> barriers that will damage the whole asynchronous chain
> reaction of the discovery.

not necessarily.
I suggest that when PSC bit is set in SwitchInfo response we will send
Set(SwitchInfo) to clear the PSC bit and
in SwitchInfo response send Get(PortInfo) - this requires adding
another flag to the mad context.
If PSC bit is not set or SM is not in Master state Get(PortInfo) will
be done in the immediately.

what do you think?

Eli

>
> -- Yevgeny
>
>> In that case any PSC change will trigger discovery of new ports even=
 if
>> trap is missed.
>>
>> Eli
>>
>>> -- Yevgeny
>>>
>>>> then there is no race condition.
>>>> As I mentioned before for IS3 switches that is correct.
>>>> Is there a different behavior with IS4 switches?
>>>>
>>>>>> Also AFAIK the PSC bit is set only after any physical port state
>>>>>> change.
>>>>>
>>>>> Yes, but it is set only once.
>>>>
>>>> PSC bit should be set after *every* port state change.
>>>>
>>>> Eli
>>>>
>>>>> Meanwhile, the ports can change from up to down,
>>>>> then SM discovers them, and then from down to up.
>>>>>
>>>>> -- Yevgeny
>>>>>
>>>>>
>>>>>> So if we clear the PSC bit and only then get PortInfo we will st=
ill
>>>>>> catch any new state change.
>>>>>> right?
>>>>>>
>>>>>> Eli
>>>>>>
>>>>>>
>>>>>>> -- Yevgeny
>>>>>>>
>>>>>>>> Eli
>>>>>>>>
>>>>>>>>> -- Yevgeny
>>>>>>>>>
>>>>>>>>>> -- Yevgeny
>>>>>>>>>>
>>>>>>>>>>>> Or perhaps the more serious problem happens when SM LID is=
 not
>>>>>>>>>>>> configured yet on the switch, hence the trap is not going =
to the
>>>>>>>>>>>> right place?
>>>>>>>>>>>>
>>>>>>>>>>>>> I have a patch for the 3.2 branch that I can merge into m=
aster.
>>>>>>>>>>>>
>>>>>>>>>>>> Sure, that would be nice :)
>>>>>>>>>>>>
>>>>>>>>>>>> -- Yevgeny
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>> Line
>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Sasha
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Signed-off-by: Yevgeny Kliteynik
>>>>>>>>>>>>>>>> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>> =C2=A0opensm/opensm/osm_state_mgr.c | =C2=A0 15 ++++++=
++++-----
>>>>>>>>>>>>>>>> =C2=A01 files changed, 10 insertions(+), 5 deletions(-=
)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> diff --git a/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>>>>> b/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>>>>> index 4303d6e..537c855 100644
>>>>>>>>>>>>>>>> --- a/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>>>>> +++ b/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>>>>> @@ -1062,13 +1062,18 @@ static void do_sweep(osm_sm_t =
* sm)
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0* Otherwise, this is probably our =
first discovery pass
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0* or we are connected in loopback.=
 In both cases do a
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0* heavy sweep.
>>>>>>>>>>>>>>>> - =C2=A0 =C2=A0 * Note: If we are connected in loopbac=
k we want a
>>>>>>>>>>>>>>>> heavy
>>>>>>>>>>>>>>>> - =C2=A0 =C2=A0 * sweep, since we will not be getting =
any traps if
>>>>>>>>>>>>>>>> there is
>>>>>>>>>>>>>>>> - =C2=A0 =C2=A0 * a lost connection.
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * Note the following:
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * 1. If we are connected in loopback w=
e want a heavy
>>>>>>>>>>>>>>>> sweep,
>>>>>>>>>>>>>>>> since we
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * =C2=A0 =C2=A0will not be getting any=
 traps if there is a lost
>>>>>>>>>>>>>>>> connection.
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * 2. If we are in DISCOVERING state - =
this means it is
>>>>>>>>>>>>>>>> either in
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * =C2=A0 =C2=A0initializing or wake up=
 from STANDBY - run the
>>>>>>>>>>>>>>>> heavy
>>>>>>>>>>>>>>>> sweep.
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * 3. If there is only one node in the =
fabric, and this
>>>>>>>>>>>>>>>> node is a
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * =C2=A0 =C2=A0switch, and OSM runs on=
 top of it, there might
>>>>>>>>>>>>>>>> be a
>>>>>>>>>>>>>>>> race
>>>>>>>>>>>>>>>> when
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * =C2=A0 =C2=A0OSM starts running befo=
re the external ports are
>>>>>>>>>>>>>>>> up -
>>>>>>>>>>>>>>>> run the
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 * =C2=A0 =C2=A0heavy sweep.
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0*/
>>>>>>>>>>>>>>>> - =C2=A0 =C2=A0/* =C2=A0if we are in DISCOVERING state=
 - this means it is
>>>>>>>>>>>>>>>> either in
>>>>>>>>>>>>>>>> - =C2=A0 =C2=A0 * =C2=A0initializing or wake up from S=
TANDBY - run the
>>>>>>>>>>>>>>>> heavy
>>>>>>>>>>>>>>>> sweep */
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 if (cl_qmap_count(&sm->p_subn->sw_guid_t=
bl)
>>>>>>>>>>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0&& cl_qmap_count(&sm->p_s=
ubn->node_guid_tbl) !=3D 1
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 && sm->p_subn->sm_state !=3D
>>>>>>>>>>>>>>>> IB_SMINFO_STATE_DISCOVERING
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 && sm->p_subn->opt.force_h=
eavy_sweep =3D=3D FALSE
>>>>>>>>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 && sm->p_subn->force_heavy=
_sweep =3D=3D FALSE
>>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>>> 1.5.1.4
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscr=
ibe
>>>>>>>>>>>>>>>> linux-rdma" in
>>>>>>>>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>>>>>>>>> More majordomo info at
>>>>>>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> --
>>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscrib=
e
>>>>>>>>>>>>>> linux-rdma" in
>>>>>>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>>>>>>> More majordomo info at
>>>>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>
>>>>>>>>>>>> --
>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>>>> linux-rdma" in
>>>>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>>>>> More majordomo info at
>>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>> linux-rdma" in
>>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordom=
o-info.html
>>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-rdma" in
>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo=
-info.html
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-rdma" in
>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-=
info.html
>>>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-rdma" in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-in=
fo.html
>>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
