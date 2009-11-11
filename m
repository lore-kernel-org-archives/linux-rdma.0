From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_state_mgr.c: force heavy sweep when fabric
 consists of single switch
Date: Wed, 11 Nov 2009 11:15:17 +0200
Message-ID: <4AFA80A5.8080809@dev.mellanox.co.il>
References: <4AF0056A.5030503@dev.mellanox.co.il> <20091103221217.GE29388@me> <4AF14DCD.3010407@dev.mellanox.co.il> <4AF16740.3080600@Sun.COM> <4AF1A3CA.9070902@dev.mellanox.co.il> <4AF1BD1C.4090703@Sun.COM> <4AF1CA61.2020007@dev.mellanox.co.il> <4AF27EDB.6070604@dev.mellanox.co.il> <4AF6D619.8000908@gmail.com> <4AF7D040.2060807@dev.mellanox.co.il> <4AF7F22D.9010609@gmail.com> <4AF7F864.6030809@dev.mellanox.co.il> <4AF81F15.1080205@gmail.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF81F15.1080205-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Dorfman (Voltaire) wrote:
> Yevgeny Kliteynik wrote:
>> Eli Dorfman (Voltaire) wrote:
>>> Yevgeny Kliteynik wrote:
>>>> Eli Dorfman (Voltaire) wrote:
>>>>> Yevgeny Kliteynik wrote:
>>>>>> Yevgeny Kliteynik wrote:
>>>>>>> Line Holen wrote:
>>>>>>>> On 11/ 4/09 04:54 PM, Yevgeny Kliteynik wrote:
>>>>>>>>> Line Holen wrote:
>>>>>>>>>> On 11/ 4/09 10:47 AM, Yevgeny Kliteynik wrote:
>>>>>>>>>>> Sasha Khapyorsky wrote:
>>>>>>>>>>>> On 12:26 Tue 03 Nov     , Yevgeny Kliteynik wrote:
>>>>>>>>>>>>> Always do heavy sweep when there is only one node in the
>>>>>>>>>>>>> fabric, and this node is a switch, and SM runs on top of it -
>>>>>>>>>>>>> there may be a race when OSM starts running before the
>>>>>>>>>>>>> external ports are ports are up, or if they went through
>>>>>>>>>>>>> reset while SM was starting.
>>>>>>>>>>>>> In this race switch brings up the ports and turns on the
>>>>>>>>>>>>> PSC bit, but OSM might get PortInfo before SwitchInfo, and it
>>>>>>>>>>>>> might see all ports as down, but PSC bit on. If that happens,
>>>>>>>>>>>>> OSM turns off PSC bit, and it will never see external ports
>>>>>>>>>>>>> again - it won't perform any heavy sweep, only light sweep
>>>>>>>>>>>> Could such race happen when there are more than one node in a
>>>>>>>>>>>> fabric?
>>>>>>>>>>> I think that my description of the race was misleading.
>>>>>>>>>>> The race can happen on *any* fabric when SM runs on switch.
>>>>>>>>>>> But when it does happen, SM thinks that the whole subnet
>>>>>>>>>>> is just one switch - that's what it managed to discover.
>>>>>>>>>>> I've actually seen it happening.
>>>>>>>>>>> So the patch fixes this particular case.
>>>>>>>>>>>
>>>>>>>>>>> So the next question that you would probably ask is can
>>>>>>>>>>> this race happen on some *other* switch and not the one
>>>>>>>>>>> SM is running on?
>>>>>>>>>>>
>>>>>>>>>>> Well, I don't know. I have a hunch that it can't, but I
>>>>>>>>>>> couldn't prove it to myself yet.
>>>>>>>>>>>
>>>>>>>>>>> The race on the managed switch is a special case because
>>>>>>>>>>> SM always sees port 0, and always gets responses to its
>>>>>>>>>>> SMP queries. On any other switch, if the ports were reset,
>>>>>>>>>>> SM won't get any response until the ports are up again.
>>>>>>>>>>>
>>>>>>>>>>> Perhaps there might be a case where SM got some port as down,
>>>>>>>>>>> and by the time SM got SwitchInfo with PSC bit the port
>>>>>>>>>>> was already up, so SM won't start discovery beyond this
>>>>>>>>>>> port. But this race would be fixed on the next heavy sweep,
>>>>>>>>>>> when SM will discover this port that it missed the previous
>>>>>>>>>>> time, whereas race on managed switch is fatal - SM won't
>>>>>>>>>>> ever do any heavy sweep.
>>>>>>>>>>>
>>>>>>>>>>> -- Yevgeny
>>>>>>>>>> At least for the 3.2 branch there is a general race regardless of
>>>>>>>>>> where the SM is running. I haven't checked the current master, but
>>>>>>>>>> I cannot recall seeing any patches related to this so I assume
>>>>>>>>>> the race is still there.
>>>>>>>>>>
>>>>>>>>>> There is a window between SM discovering a switch and clearing PSC
>>>>>>>>>> for the same switch. The SM will not detect a state change on the
>>>>>>>>>> switch ports during this time.
>>>>>>>>> If the port changes state during that period, the switch issues
>>>>>>>>> new trap 128, which (I think) should cause SM to re-discover the
>>>>>>>>> fabric once this discovery cycle is over. Is this correct?
>>>>>>>>>
>>>>>>>> I think the switch shall send a trap whenever it sets the PSC bit.
>>>>>>>> Once set I believe it will not send another trap until it is reset.
>>>>>>>> Or do I misinterpret the spec ?
>>>>>>> I may be wrong, but I thought that this is how things work:
>>>>>>> - port state changes
>>>>>>> - switch turns on PSC bit and starts sending traps
>>>>>>> - SM gets the trap, sends trap repress
>>>>>>> - switch gets trap repress and stops sending traps
>>>>>>> - PSC is still on
>>>>>>> - port state changes again (the same or any other port)
>>>>>>> - switch turns on PSC bit (which doesn't matter as PSC is
>>>>>>>   already on) and starts sending traps again
>>>>>>> - etc...
>>>>>>>
>>>>>>> Anyway, I'll double-check this issue.
>>>>>> Yep, verified.
>>>>>> Switch sends traps regardless the PSC bit status.
>>>>>> Also, the spec doesn't link them together:
>>>>>>
>>>>>>   o14-5.1.1: If a switch supports Traps (PortInfo:
>>>>>>   CapabilityMask.IsTrap-Supported is one), its SMA
>>>>>>   shall send trap 128 to the SM indicated by the  
>>>>>> PortInfo:MasterSMLID
>>>>>> under any condition that   would cause SwitchInfo:PortStateChange to
>>>>>> be set
>>>>>>   to one. (See 14.2.5.4 SwitchInfo on page 827.)
>>>>>>
>>>>> Trap will be sent according to the SMLID. After first bring up the
>>>>> SMLID is not set yet and trap will not be sent.
>>>>> In that case the opensm would discover the change only by PSC bit.
>>>>> For IS3 chips the PSC bit and/or trap were set only after one or more
>>>>> ports changed their state, so I don't understand how can the SM
>>>>> discover PSC bit set while all ports are down. Or is this a change in
>>>>> IS4?
>>>> It can happen when SM runs on the switch, not not host.
>>>> In this case if all ports are going down, SM will see
>>>> them all down and it will see PSC bit on.
>>> So this patch is only for SM running on a switch which is the only
>>> node in the fabric?
>>> I don't see the race when there is more than one switch - please explain.
>> Quoting from above:
>>
>>   The race can happen on *any* fabric when SM runs on switch.
>>   But when it does happen, SM thinks that the whole subnet
>>   is just one switch - that's what it managed to discover.
> 
> I saw that but I don't understand how this can happen.
> If PSC bit is set after *every* port state change and
> SM clears PSC bit before reading PortInfo from the switch,

osm_node_info_rcv.c, ni_rcv_process_switch():
I see in the code that SM receives NodeInfo, then it requests
SwitchInfo and right after that it requests PortInfo for all
the ports w/o waiting for the SwitchInfo response.
In addition to that, if it happens during the first master
sweep, SM LID is not configured yet, or configured to the
wrong value, so no traps will be received by the SM.

-- Yevgeny

> then there is no race condition.
> As I mentioned before for IS3 switches that is correct.
> Is there a different behavior with IS4 switches?
> 
>>> Also AFAIK the PSC bit is set only after any physical port state change.
>> Yes, but it is set only once.
> 
> PSC bit should be set after *every* port state change.
> 
> Eli
> 
>> Meanwhile, the ports can change from up to down,
>> then SM discovers them, and then from down to up.
>>
>> -- Yevgeny
>>
>>
>>> So if we clear the PSC bit and only then get PortInfo we will still
>>> catch any new state change.
>>> right?
>>>
>>> Eli
>>>
>>>
>>>> -- Yevgeny
>>>>
>>>>> Eli
>>>>>
>>>>>> -- Yevgeny
>>>>>>
>>>>>>> -- Yevgeny
>>>>>>>
>>>>>>>>> Or perhaps the more serious problem happens when SM LID is not
>>>>>>>>> configured yet on the switch, hence the trap is not going to the
>>>>>>>>> right place?
>>>>>>>>>
>>>>>>>>>> I have a patch for the 3.2 branch that I can merge into master.
>>>>>>>>> Sure, that would be nice :)
>>>>>>>>>
>>>>>>>>> -- Yevgeny
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>> Line
>>>>>>>>>>
>>>>>>>>>>>> Sasha
>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>  opensm/opensm/osm_state_mgr.c |   15 ++++++++++-----
>>>>>>>>>>>>>  1 files changed, 10 insertions(+), 5 deletions(-)
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>> b/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>> index 4303d6e..537c855 100644
>>>>>>>>>>>>> --- a/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>> +++ b/opensm/opensm/osm_state_mgr.c
>>>>>>>>>>>>> @@ -1062,13 +1062,18 @@ static void do_sweep(osm_sm_t * sm)
>>>>>>>>>>>>>       * Otherwise, this is probably our first discovery pass
>>>>>>>>>>>>>       * or we are connected in loopback. In both cases do a
>>>>>>>>>>>>>       * heavy sweep.
>>>>>>>>>>>>> -     * Note: If we are connected in loopback we want a heavy
>>>>>>>>>>>>> -     * sweep, since we will not be getting any traps if
>>>>>>>>>>>>> there is
>>>>>>>>>>>>> -     * a lost connection.
>>>>>>>>>>>>> +     * Note the following:
>>>>>>>>>>>>> +     * 1. If we are connected in loopback we want a heavy
>>>>>>>>>>>>> sweep,
>>>>>>>>>>>>> since we
>>>>>>>>>>>>> +     *    will not be getting any traps if there is a lost
>>>>>>>>>>>>> connection.
>>>>>>>>>>>>> +     * 2. If we are in DISCOVERING state - this means it is
>>>>>>>>>>>>> either in
>>>>>>>>>>>>> +     *    initializing or wake up from STANDBY - run the heavy
>>>>>>>>>>>>> sweep.
>>>>>>>>>>>>> +     * 3. If there is only one node in the fabric, and this
>>>>>>>>>>>>> node is a
>>>>>>>>>>>>> +     *    switch, and OSM runs on top of it, there might be a
>>>>>>>>>>>>> race
>>>>>>>>>>>>> when
>>>>>>>>>>>>> +     *    OSM starts running before the external ports are
>>>>>>>>>>>>> up -
>>>>>>>>>>>>> run the
>>>>>>>>>>>>> +     *    heavy sweep.
>>>>>>>>>>>>>       */
>>>>>>>>>>>>> -    /*  if we are in DISCOVERING state - this means it is
>>>>>>>>>>>>> either in
>>>>>>>>>>>>> -     *  initializing or wake up from STANDBY - run the heavy
>>>>>>>>>>>>> sweep */
>>>>>>>>>>>>>      if (cl_qmap_count(&sm->p_subn->sw_guid_tbl)
>>>>>>>>>>>>> +        && cl_qmap_count(&sm->p_subn->node_guid_tbl) != 1
>>>>>>>>>>>>>          && sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING
>>>>>>>>>>>>>          && sm->p_subn->opt.force_heavy_sweep == FALSE
>>>>>>>>>>>>>          && sm->p_subn->force_heavy_sweep == FALSE
>>>>>>>>>>>>> -- 
>>>>>>>>>>>>> 1.5.1.4
>>>>>>>>>>>>>
>>>>>>>>>>>>> -- 
>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>>>>> linux-rdma" in
>>>>>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>>>>>> More majordomo info at
>>>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>>
>>>>>>>>>>> -- 
>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>>> linux-rdma" in
>>>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>>>> More majordomo info at 
>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>> -- 
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-rdma" in
>>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>> -- 
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-rdma" in
>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>> -- 
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-rdma" in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> -- 
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-rdma" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
