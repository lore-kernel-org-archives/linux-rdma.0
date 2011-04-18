From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid port.  Otherwise leave it as 0
Date: Sun, 17 Apr 2011 18:26:11 -0700
Message-ID: <53790366-BE39-4A3D-8144-EA1DE3F0197A@llnl.gov>
References: <20110415151736.809c550b.weiny2@llnl.gov> <4DAB0565.8020505@dev.mellanox.co.il>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DAB0565.8020505-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 17, 2011, at 8:21 AM, Hal Rosenstock wrote:

> On 4/15/2011 6:17 PM, Ira Weiny wrote:
>> 
>> Subject: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid port.  Otherwise leave it as 0
>> 
>> 
>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>> ---
>> opensm/osm_perfmgr.c |    4 +++-
>> 1 files changed, 3 insertions(+), 1 deletions(-)
>> 
>> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
>> index 6a1fa63..3e1575a 100644
>> --- a/opensm/osm_perfmgr.c
>> +++ b/opensm/osm_perfmgr.c
>> @@ -454,7 +454,9 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
>> 				  ib_switch_info_is_enhanced_port0(&node->sw->
>> 								   switch_info));
>> 		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
>> -			mon_node->port[port].orig_lid = get_base_lid(node, port);
>> +			mon_node->port[port].orig_lid = 0;
>> +			if (osm_physp_is_valid(&node->physp_table[port]))
>> +				mon_node->port[port].orig_lid = get_base_lid(node, port);
>> 			mon_node->port[port].valid = TRUE;
>> 		}
>> 
> 
> There are several other calls to get_base_lid. Is it also an issue there
> too or is port always valid there ? If it's not always valid for those
> cases, why not just move this check into get_base_lid ?

I believe this is a special case because we are looping through the ports of a CA node and not all of it's ports are valid on this fabric.  Most of the other places where get_base_lid is called I believe the port is known to be good, therefore there is an assertion in there just to protect us.

I think the better way to "fix" this would probably be to change the perfmgr to track ports rather than nodes.[*]  Unfortunately this will take a significant amount of coding effort.  I think the best thing to do is just check if the physical port is valid as I did above.

As to Alex's comment I think the port should be marked invalid as well.  (I should have CC'ed the list on my response to him.)  I will resend the patch with that change.

Ira

[*] At the time I coded the perfmgr it seemed to make more sense to track nodes rather than ports.  In hindsight this might have been a mistake but for this small place I don't see a reason to re-architect it all yet.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
