From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_state_mgr.c: Don't rely on PortInfo:PortState
 for base SP0
Date: Wed, 20 Apr 2011 10:43:15 -0400
Message-ID: <4DAEF103.1000706@dev.mellanox.co.il>
References: <4DAC3CCC.4090101@dev.mellanox.co.il> <20110420141713.GD28761@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110420141713.GD28761-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 4/20/2011 10:17 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 09:29 Mon 18 Apr     , Hal Rosenstock wrote:
>>
>> For base SP0, PortState in SM PortInfo attribute is not used and base SP0
>> is always "active". 
> 
> How SM can be attached to base SP0?

What precludes this ? AFAIK SM can run on any switch port 0 whether
enhanced or base.

> Moreover, if during discovery we found that SM is attached to base SP0, don't
> we want to act like the port is down?

For base SP0, PortState and PortPhysicalState are "not used" in the SM
PortInfo attribute. That means they're "vendor" specific and they should
not be relied upon to be valid.

The point of this patch is that base SP0 is always up regardless of what
PortInfo for that port says.

If SM wasn't allowed to run on base SP0, it would be a different patch:
to prohibit such a port from being used at all as the SM port so the
failure would be earlier in the code flow when the SM tries to bind to
such a port.

-- Hal

>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
>> index 2e1ef94..dd308f2 100644
>> --- a/opensm/osm_state_mgr.c
>> +++ b/opensm/osm_state_mgr.c
>> @@ -352,7 +352,11 @@ static boolean_t state_mgr_is_sm_port_down(IN osm_sm_t * sm)
>>  
>>  	CL_ASSERT(p_physp);
>>  
>> -	state = osm_physp_get_port_state(p_physp);
>> +	if (p_port->p_node->sw &&
>> +	    !ib_switch_info_is_enhanced_port0(&p_port->p_node->sw->switch_info))
>> +		state = IB_LINK_ACTIVE;	/* base SP0 */
>> +	else
>> +		state = osm_physp_get_port_state(p_physp);
>>  	CL_PLOCK_RELEASE(sm->p_lock);
>>  
>>  Exit:
>> --

> 
> -- Alex


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
