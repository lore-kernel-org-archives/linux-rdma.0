From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [PATCH 03/11] opensm: Allow the routing engine to participate
 in path SL calculations.
Date: Mon, 18 Jan 2010 22:19:38 +0200
Message-ID: <4B54C25A.2050504@mellanox.co.il>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov> <1258744509-11148-4-git-send-email-jaschut@sandia.gov> <4B4F452B.7040007@mellanox.co.il> <1263842661.5550.43.camel@sale659.sandia.gov>
Reply-To: kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1263842661.5550.43.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On 18/Jan/10 21:24, Jim Schutt wrote:
> Hi Yevgeny,
>
> On Thu, 2010-01-14 at 09:24 -0700, Yevgeny Kliteynik wrote:
>    
>> Jim,
>>
>> On 20/Nov/09 21:15, Jim Schutt wrote:
>>      
>>> LASH already does this, in a hard-coded fashion.
>>>
>>> Generalize this by adding a callback to struct osm_routing_engine that
>>> computes a path SL value, and fix up LASH to use it.
>>>
>>> This patchset causes the requested or QoS-computed SL value to be passed
>>> to the routing engine path SL computation as a hint.  In the event the
>>> routing engine's use of SLs allows it to support more than one QoS level,
>>> it may be able to make use of the SL hint to do so.
>>>
>>> For now, LASH just ignores the hint.
>>>
>>> Note that before this change, if LASH was configured and a specific path
>>> SL value was requested that differed from what LASH needed to route the
>>> fabric without credit loops, the path SL lookup would fail.  Now LASH's
>>> SL value is always used.
>>>
>>> Possibly the choice between failing a path SL request when it conflicts
>>> with routing, vs. always providing an SL value that gives a credit-loop-
>>> free routing, should be user-configurable?
>>>        
>> SL can come from the following places:
>>    - user requested specific SL in PathRecord query
>>    - QoS policy configuration
>>    - SL specified in partition parameters
>>    - basic QoS (no policies, only SL2VL table)
>>    - routing engine
>>
>> Except for QoS policy being able to override SL that is specified in
>> the partition parameters (with an error message in the log), IMHO if
>> there's a conflict between SLs coming from different constraints
>> PathRecord should fail to find a satisfiable path, or at least we
>> should see some error message in the log that the selected SL
>> conflicts with other OSM configurations, but will be used anyway.
>>
>> [snip...]
>>
>>      
>>> @@ -725,6 +707,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>>>    		goto Exit;
>>>    	}
>>>
>>> +	/*
>>> +	 * If the routing engine wants to have a say in path SL selection,
>>> +	 * send the currently computed SL value as a hint and let the routing
>>> +	 * engine override it.
>>> +	 */
>>> +	if (p_re&&   p_re->path_sl)
>>> +		sl = p_re->path_sl(p_re->context, sl, p_src_port, p_dest_port);
>>>
>>>        
>> In addition to error message if routing engine overrides the provided
>> hint, need to check whether the returned SL is valid - check the
>> corresponding bit in valid_sl_mask. It might be irrelevant for torus-2QoS
>> routing (not sure yet, need to read more patches :-) ), but it's
>> probably needed in general case.
>>
>> Also, perhaps it would be better to provide the bitmask of available
>> SLs as a hint if there are more than one suitable SL?
>>
>> I mean something like this (didn't try it, didn't even compile it,
>> need corresponding change in the p_re->path_sl callback, it's just
>> to illustrate what I mean):
>>      
> Your suggestion below won't accomplish what I was trying to
> accomplish.
>
> Torus-2QoS needs to encode global path information into the
> SL value in order to provide routing free of credit loops.
>
> But it only needs 3 bits of SL to do this, leaving one free.
> So, it uses that bit to provide two "levels" of quality of
> service.
>
> This usage of SL clashes with the QoS policy engine, which
> uses each SL value to provide up to 16 "levels" of quality
> of service.  So to the QoS policy engine, every SL value
> is distinct, but to torus-2QoS, SL values 0-7 are all the
> same wrt. QoS "level", and SL values 8-15 are also all the
> same wrt. a second QoS "level".
>    

Understood. Please ignore my suggestion.

-- Yevgeny

> I wanted to use the QoS policy engine to configure QoS
> "level" in torus-2QoS, so I used this "hint" idea.
> What torus-2QoS' path_sl() does is append the high-order
> bit from the SL hint, as computed by the QoS policy engine,
> onto the 3 low-order bits that it computes are needed
> to avoid deadlock.
>
> Does that help explain what I'm after?
>
> -- Jim
>
>    
>> ---
>>    opensm/opensm/osm_sa_path_record.c |   47
>> ++++++++++++++++++++++-------------
>>    1 files changed, 29 insertions(+), 18 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_sa_path_record.c
>> b/opensm/opensm/osm_sa_path_record.c
>> index 7120d65..6de8979 100644
>> --- a/opensm/opensm/osm_sa_path_record.c
>> +++ b/opensm/opensm/osm_sa_path_record.c
>> @@ -171,7 +171,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN
>> osm_sa_t * sa,
>>        uint8_t required_mtu;
>>        uint8_t required_rate;
>>        uint8_t required_pkt_life;
>> -    uint8_t sl;
>> +    uint8_t sl = OSM_DEFAULT_SL;
>>        uint8_t in_port_num;
>>        ib_net16_t dest_lid;
>>        uint8_t i;
>> @@ -688,33 +688,44 @@ static ib_api_status_t pr_rcv_get_path_parms(IN
>> osm_sa_t * sa,
>>                    cl_ntoh16(pkey), sl);
>>            } else
>>                sl = p_prtn->sl;
>> -    } else if (sa->p_subn->opt.qos) {
>> +    }
>> +
>> +    /*
>> +     * If the routing engine wants to have a say in path SL selection,
>> +     * send the currently computed SL value as a hint and let the routing
>> +     * engine override it.
>> +     */
>> +    if (p_re&&  p_re->path_sl)
>> +        sl = p_re->path_sl(p_re->context, valid_sl_mask, p_src_port,
>> p_dest_port);
>> +
>> +    if (sa->p_subn->opt.qos&&  !(valid_sl_mask&  (1<<  sl))) {
>> +        OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F24: "
>> +            "Selected SL (%u) leads to VL15\n", sl);
>> +        status = IB_NOT_FOUND;
>> +        goto Exit;
>> +    }
>> +
>> +    if (!(p_re&&  p_re->path_sl)&&
>> +        !(comp_mask&  IB_PR_COMPMASK_SL)&&
>> +        !(p_qos_level&&  p_qos_level->sl_set)&&
>> +        !pkey&&
>> +        (sa->p_subn->opt.qos)) {
>>            if (valid_sl_mask&  (1<<  OSM_DEFAULT_SL))
>>                sl = OSM_DEFAULT_SL;
>>            else {
>>                for (i = 0; i<  IB_MAX_NUM_VLS; i++)
>>                    if (valid_sl_mask&  (1<<  i))
>>                        break;
>> +            if (i == IB_MAX_NUM_VLS) {
>> +                OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR ABCD: "
>> +                    "bla bla bla\n");
>> +                status = IB_NOT_FOUND;
>> +                goto Exit;
>> +            }
>>                sl = i;
>>            }
>> -    } else
>> -        sl = OSM_DEFAULT_SL;
>> -
>> -    if (sa->p_subn->opt.qos&&  !(valid_sl_mask&  (1<<  sl))) {
>> -        OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F24: "
>> -            "Selected SL (%u) leads to VL15\n", sl);
>> -        status = IB_NOT_FOUND;
>> -        goto Exit;
>>        }
>>
>> -    /*
>> -     * If the routing engine wants to have a say in path SL selection,
>> -     * send the currently computed SL value as a hint and let the routing
>> -     * engine override it.
>> -     */
>> -    if (p_re&&  p_re->path_sl)
>> -        sl = p_re->path_sl(p_re->context, sl, p_src_port, p_dest_port);
>> -
>>        /* reset pkey when raw traffic */
>>        if (comp_mask&  IB_PR_COMPMASK_RAWTRAFFIC&&
>>            cl_ntoh32(p_pr->hop_flow_raw)&  (1<<  31))
>>      
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
