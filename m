From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] osm_port_info_rcv.c Issue a log message if we cannot
 read the MKey of a port
Date: Mon, 26 Aug 2013 12:54:42 +0200
Message-ID: <521B33F2.7030709@oracle.com>
References: <e5b46785-f443-42ef-bf16-660f9e7df190@default> <520E2D86.6080903@dev.mellanox.co.il> <5211F76C.6020501@oracle.com> <52136823.8010104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52136823.8010104-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

I've finally repeated my testing, this time also with protection level 2.
And yes, testing confirms that the new message will only show up with 
level 1.
This is how the log will look like with a single CA port with unknown MKey

* Level 1 will loop on heavy sweep and init:
pi_rcv_process_endport: Port 0x21280001a17ff7 has unknown M_Key, 
protection level 1
log_send_error: ERR 5411: DR SMP Send completed with error (IB_TIMEOUT) 
-- dropping
                         Method 0x2, Attr 0x16, TID 0x1713
Received SMP on a 2 hop path: Initial path = 0,1,31, Return path  = 0,0,0
sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error (IB_TIMEOUT): 
SubnSet(P_KeyTable), attr_mod 0x0, TID 0x1713
sm_mad_ctrl_send_err_cb: ERR 3119: Set method failed for attribute 0x16 
(P_KeyTable)
log_trap_info: Received Generic Notice type:2 num:256 (Bad M_Key) 
Producer:1 (Channel Adapter) from LID:1 TID:0x00000000000000a2
log_notice: Reporting Security Notice "Bad M_Key" from LID 1, GUID 
0x0021280001a17ff7, Method 0x2, Attribute 0x15, AttrMod 0x1, M_Key 
0x0000000000000002
log_send_error: ERR 5411: DR SMP Send completed with error (IB_TIMEOUT) 
-- dropping
                         Method 0x2, Attr 0x15, TID 0x171c
Received SMP on a 2 hop path: Initial path = 0,1,31, Return path  = 0,0,0
sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error (IB_TIMEOUT): 
SubnSet(PortInfo), attr_mod 0x1, TID 0x171c
sm_mad_ctrl_send_err_cb: ERR 3119: Set method failed for attribute 0x15 
(PortInfo)
osm_ucast_mgr_process: minhop tables configured on all switches
log_send_error: ERR 5411: DR SMP Send completed with error (IB_TIMEOUT) 
-- dropping
                         Method 0x2, Attr 0x15, TID 0x173b
Received SMP on a 2 hop path: Initial path = 0,1,31, Return path  = 0,0,0
sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error (IB_TIMEOUT): 
SubnSet(PortInfo), attr_mod 0x1, TID 0x173b
sm_mad_ctrl_send_err_cb: ERR 3119: Set method failed for attribute 0x15 
(PortInfo)
Errors during initialization
do_sweep:

* Level 2 will loop on light sweep:
log_send_error: ERR 5411: DR SMP Send completed with error (IB_TIMEOUT) 
-- dropping
                         Method 0x1, Attr 0x15, TID 0x142f
Received SMP on a 3 hop path: Initial path = 0,1,7,33, Return path  = 
0,0,0,0
sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error (IB_TIMEOUT): 
SubnGet(PortInfo), attr_mod 0x0, TID 0x142f
sm_mad_ctrl_send_err_cb: ERR 3120 Timeout while getting attribute 0x15 
(PortInfo); Possible mis-set mkey?
state_mgr_light_sweep_start: ERR 3315: Unknown remote side for node 
0x0021283bad45c0a0 (SUN IB QDR GW switch o4nm2-gw-2 10.172.144.70) port 
33. Adding to light sweep sampling list
Directed Path Dump of 2 hop path: Path = 0,1,7


Line

On 08/20/13 14:59, Hal Rosenstock wrote:
> On 8/19/2013 6:46 AM, Line Holen wrote:
>> On 08/16/13 15:47, Hal Rosenstock wrote:
>>> On 8/14/2013 6:26 AM, Line Holen wrote:
>>>> Signed-off-by: Line Holen<Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> ---
>>>>
>>>> diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
>>>> index 7dcd15e..961b376 100644
>>>> --- a/opensm/osm_port_info_rcv.c
>>>> +++ b/opensm/osm_port_info_rcv.c
>>>> @@ -85,7 +85,7 @@ static void pi_rcv_process_endport(IN osm_sm_t *
>>>> sm, IN osm_physp_t * p_physp,
>>>>        osm_madw_context_t context;
>>>>        ib_api_status_t status;
>>>>        ib_net64_t port_guid;
>>>> -    uint8_t rate, mtu;
>>>> +    uint8_t rate, mtu, mpb;
>>>>        unsigned data_vls;
>>>>        cl_qmap_t *p_sm_tbl;
>>>>        osm_remote_sm_t *p_sm;
>>>> @@ -126,6 +126,14 @@ static void pi_rcv_process_endport(IN osm_sm_t *
>>>> sm, IN osm_physp_t * p_physp,
>>>>            }
>>>>        }
>>>>
>>>> +    /* Check M_Key vs M_Key protect, can we control the port ? */
>>>> +    mpb = ib_port_info_get_mpb(p_pi);
>>>> +    if (mpb>  0&&  p_pi->m_key == 0) {
>>>> +        OSM_LOG(sm->p_log, OSM_LOG_INFO,
>>>> +            "Port 0x%" PRIx64 " has unknown M_Key, protection level
>>>> %u\n",
>>>> +            cl_ntoh64(port_guid), mpb);
>>>> +    }
>>>> +
>>> It looks to me like the only case here is when protect bits is 1 for
>>> gets; all others fail. Is it more than that ?
>> You are probably right -
> I was referring to that only for protect bits of 1 does this seem to
> have potential value for gets as gets with protect bits of 1 with wrong
> Mkey return port info with 0 MKey. All other mpb cases fail.
>
>> have to admit I haven't tried a higher
>> protection level.
> What protection level(s) have you tried ?
>
>>> Also, would this spam the OpenSM log ?
>> It would print one additional message per heavy sweep.
>> But if you have a system with unknown MKeys configured you would get
>> many error
>> messages as it is. With protection level 2 every MAD operation will
>> generate
>> an error I guess (either 3111 or 3120). And with protection level 1 set
>> operations
>> will fail, but this new message will let you know why it failed.
> I think it would be a 3120 error (timeout) rather than bad status. I
> think that is what is meant in the IBA spec by fail (fail = no
> response). Have you see 3111 or other than 3120 errors for this ?
>
> -- Hal
>
>> Line
>>
>>> -- Hal
>>>
>>>>        if (port_guid != sm->p_subn->sm_port_guid) {
>>>>            p_sm_tbl =&sm->p_subn->sm_guid_tbl;
>>>>            if (p_pi->capability_mask&   IB_PORT_CAP_IS_SM) {
>>>>
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
