From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_sm_state_mgr.c: Fix handling of polling retry number
Date: Tue, 03 Dec 2013 08:17:41 -0500
Message-ID: <529DD9F5.2050902@dev.mellanox.co.il>
References: <3b0cb098-1e00-417d-8a5b-0aa766926867@default> <5295E2AF.2050909@dev.mellanox.co.il> <529604BB.4010001@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <529604BB.4010001-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/27/2013 9:42 AM, Line Holen wrote:
> On 11/27/13 13:16, Hal Rosenstock wrote:
>> On 11/15/2013 7:15 AM, Line Holen wrote:
>>> The retry counter is now only updated if a packet is actually sent.
>>> (But as before the initial request is also counted.)
>>>
>>> Prior to this change the actual maximum number of packets sent were
>>> polling retry number minus one.
>>>
>>> Signed-off-by: Line Holen<line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>
>>> ---
>>>
>>> diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
>>> index 596ad8f..6eff9ee 100644
>>> --- a/opensm/osm_sm_state_mgr.c
>>> +++ b/opensm/osm_sm_state_mgr.c
>>> @@ -197,16 +197,14 @@ void osm_sm_state_mgr_polling_callback(IN void
>>> *context)
>>>       }
>>>
>>>       /*
>>> -     * Incr the retry number.
>>> -     * If it reached the max_retry_number in the subnet opt - call
>>> +     * If retry number reached the max_retry_number in the subnet
>>> opt - call
>>>        * osm_sm_state_mgr_process with signal
>>> OSM_SM_SIGNAL_POLLING_TIMEOUT
>>>        */
>>> -    sm->retry_number++;
>>>       OSM_LOG(sm->p_log, OSM_LOG_VERBOSE, "SM State %d (%s), Retry
>>> number:%d\n",
>>>           sm->p_subn->sm_state, 
>>> osm_get_sm_mgr_state_str(sm->p_subn->sm_state),
>>>           sm->retry_number);
>>>
>>> -    if (sm->retry_number>= sm->p_subn->opt.polling_retry_number) {
>>> +    if (sm->retry_number>  sm->p_subn->opt.polling_retry_number) {
>>>           OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
>>>               "Reached polling_retry_number value in retry_number. "
>>>               "Go to DISCOVERY state\n");
>>> @@ -214,6 +212,9 @@ void osm_sm_state_mgr_polling_callback(IN void
>>> *context)
>>>           goto Exit;
>>>       }
>>>
>>> +    /* Increment the retry number */
>>> +    sm->retry_number++;
>> Would it be better to increment retry number if
>> sm_state_mgr_send_master_sm_info_req call just below this succeeds ?
>>
>> -- Hal
> I'm not sure really.

All I was proposing was a minor variation to what you proposed:
to add a status return to sm_state_mgr_send_master_sm_info_req and only
increment the retry_number if that call was "successful".

> The current placement was to avoid potential race
> with response handling
> and the clearing of the counter there (incrementing after the response
> were received). 

Maybe I'm missing something but I don't see how this changes any
potential race condition other than perhaps a smaller time window.

> Seemed to me that this could happen with the current locking.

Yes, it looks to me like the locking here needs fixing. I'll send a
patch for this shortly...

-- Hal

> 
> Line
>>
>>> +
>>>       /* Send a SubnGet(SMInfo) request to the remote sm (depends on
>>> our state) */
>>>       sm_state_mgr_send_master_sm_info_req(sm);
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
