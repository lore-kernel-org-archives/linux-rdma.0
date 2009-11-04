From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_state_mgr.c: force heavy sweep when fabric
 consists of single switch
Date: Wed, 04 Nov 2009 18:42:52 +0100
Message-ID: <4AF1BD1C.4090703@Sun.COM>
References: <4AF0056A.5030503@dev.mellanox.co.il> <20091103221217.GE29388@me>
 <4AF14DCD.3010407@dev.mellanox.co.il> <4AF16740.3080600@Sun.COM>
 <4AF1A3CA.9070902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4AF1A3CA.9070902-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/ 4/09 04:54 PM, Yevgeny Kliteynik wrote:
> Line Holen wrote:
>> On 11/ 4/09 10:47 AM, Yevgeny Kliteynik wrote:
>>> Sasha Khapyorsky wrote:
>>>> On 12:26 Tue 03 Nov     , Yevgeny Kliteynik wrote:
>>>>> Always do heavy sweep when there is only one node in the
>>>>> fabric, and this node is a switch, and SM runs on top of it -
>>>>> there may be a race when OSM starts running before the
>>>>> external ports are ports are up, or if they went through
>>>>> reset while SM was starting.
>>>>> In this race switch brings up the ports and turns on the
>>>>> PSC bit, but OSM might get PortInfo before SwitchInfo, and it
>>>>> might see all ports as down, but PSC bit on. If that happens,
>>>>> OSM turns off PSC bit, and it will never see external ports
>>>>> again - it won't perform any heavy sweep, only light sweep
>>>> Could such race happen when there are more than one node in a fabric?
>>> I think that my description of the race was misleading.
>>> The race can happen on *any* fabric when SM runs on switch.
>>> But when it does happen, SM thinks that the whole subnet
>>> is just one switch - that's what it managed to discover.
>>> I've actually seen it happening.
>>> So the patch fixes this particular case.
>>>
>>> So the next question that you would probably ask is can
>>> this race happen on some *other* switch and not the one
>>> SM is running on?
>>>
>>> Well, I don't know. I have a hunch that it can't, but I
>>> couldn't prove it to myself yet.
>>>
>>> The race on the managed switch is a special case because
>>> SM always sees port 0, and always gets responses to its
>>> SMP queries. On any other switch, if the ports were reset,
>>> SM won't get any response until the ports are up again.
>>>
>>> Perhaps there might be a case where SM got some port as down,
>>> and by the time SM got SwitchInfo with PSC bit the port
>>> was already up, so SM won't start discovery beyond this
>>> port. But this race would be fixed on the next heavy sweep,
>>> when SM will discover this port that it missed the previous
>>> time, whereas race on managed switch is fatal - SM won't
>>> ever do any heavy sweep.
>>>
>>> -- Yevgeny
>>
>> At least for the 3.2 branch there is a general race regardless of
>> where the SM is running. I haven't checked the current master, but
>> I cannot recall seeing any patches related to this so I assume
>> the race is still there.
>>
>> There is a window between SM discovering a switch and clearing PSC
>> for the same switch. The SM will not detect a state change on the
>> switch ports during this time.
> 
> If the port changes state during that period, the switch issues
> new trap 128, which (I think) should cause SM to re-discover the
> fabric once this discovery cycle is over. Is this correct?
> 

I think the switch shall send a trap whenever it sets the PSC bit.
Once set I believe it will not send another trap until it is reset.
Or do I misinterpret the spec ?

> Or perhaps the more serious problem happens when SM LID is not
> configured yet on the switch, hence the trap is not going to the
> right place?
> 
>> I have a patch for the 3.2 branch that I can merge into master.
> 
> Sure, that would be nice :)
> 
> -- Yevgeny
> 
> 
>> Line
>>
>>>> Sasha
>>>>
>>>>> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>>> ---
>>>>>  opensm/opensm/osm_state_mgr.c |   15 ++++++++++-----
>>>>>  1 files changed, 10 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/opensm/opensm/osm_state_mgr.c
>>>>> b/opensm/opensm/osm_state_mgr.c
>>>>> index 4303d6e..537c855 100644
>>>>> --- a/opensm/opensm/osm_state_mgr.c
>>>>> +++ b/opensm/opensm/osm_state_mgr.c
>>>>> @@ -1062,13 +1062,18 @@ static void do_sweep(osm_sm_t * sm)
>>>>>       * Otherwise, this is probably our first discovery pass
>>>>>       * or we are connected in loopback. In both cases do a
>>>>>       * heavy sweep.
>>>>> -     * Note: If we are connected in loopback we want a heavy
>>>>> -     * sweep, since we will not be getting any traps if there is
>>>>> -     * a lost connection.
>>>>> +     * Note the following:
>>>>> +     * 1. If we are connected in loopback we want a heavy sweep,
>>>>> since we
>>>>> +     *    will not be getting any traps if there is a lost
>>>>> connection.
>>>>> +     * 2. If we are in DISCOVERING state - this means it is either in
>>>>> +     *    initializing or wake up from STANDBY - run the heavy sweep.
>>>>> +     * 3. If there is only one node in the fabric, and this node is a
>>>>> +     *    switch, and OSM runs on top of it, there might be a race
>>>>> when
>>>>> +     *    OSM starts running before the external ports are up -
>>>>> run the
>>>>> +     *    heavy sweep.
>>>>>       */
>>>>> -    /*  if we are in DISCOVERING state - this means it is either in
>>>>> -     *  initializing or wake up from STANDBY - run the heavy sweep */
>>>>>      if (cl_qmap_count(&sm->p_subn->sw_guid_tbl)
>>>>> +        && cl_qmap_count(&sm->p_subn->node_guid_tbl) != 1
>>>>>          && sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING
>>>>>          && sm->p_subn->opt.force_heavy_sweep == FALSE
>>>>>          && sm->p_subn->force_heavy_sweep == FALSE
>>>>> -- 
>>>>> 1.5.1.4
>>>>>
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
>>
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
