From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibtracert.c: Remove checking the port
 0 state for BasePort0 switches
Date: Wed, 28 Jan 2015 17:41:10 -0500
Message-ID: <54C96586.3080309@dev.mellanox.co.il>
References: <54BE514B.5030904@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC0D7F9@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC0D7F9-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/28/2015 1:27 PM, Weiny, Ira wrote:
> Sorry for the delay.
> 
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
>> Sent: Tuesday, January 20, 2015 5:00 AM
>> To: Weiny, Ira
>> Cc: Dan Ben-Yosef; linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>> Subject: [PATCH infiniband-diags] ibtracert.c: Remove checking the port 0 state
>> for BasePort0 switches
>>
>> From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> The port 0 state check is needed only for HCA/Routers and
>> EnhancedPort0 switches.
>>
>> For BasePort0 switches, the PortState field in the PortInfo attribute for port0 is
>> undefined (not used).
>>
>> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  src/ibtracert.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
>>  1 files changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/src/ibtracert.c b/src/ibtracert.c index d32968b..326200b 100644
>> --- a/src/ibtracert.c
>> +++ b/src/ibtracert.c
>> @@ -92,6 +92,7 @@ struct Switch {
>>  	int mccap;
>>  	int linearFDBtop;
>>  	int fdb_base;
>> +	int enhsp0;
>>  	int8_t fdb[64];
>>  	char switchinfo[64];
>>  };
>> @@ -114,6 +115,17 @@ struct Node {
>>  Node *nodesdist[MAXHOPS];
>>  uint64_t target_portguid;
>>
>> +static int is_route_inactive_port0(Node * node, Port * port, Switch *
>> +sw) {
> 
> I would prefer this function be named something like:
> 
> port_inactive_not_bsp0
> 
> The current name is confusing as to what the logic is.

How about is_port_inactive ?

>> +	int res = 0;
>> +	/* not active for HCA and for enhanced port0 Switches */
>> +	if (port->state != 4 &&
> 
> Please use #defines here even though the original code did not.

This is an issue throughout infiniband-diags. I think it should be
addressed by separate patch(es) for this.

>> +	    (node->type != IB_NODE_SWITCH ||
>> +	     (node->type == IB_NODE_SWITCH && sw->enhsp0)))
>> +		res = 1;
>> +	return res;
>> +}
>> +
>>  static int get_node(Node * node, Port * port, ib_portid_t * portid)  {
>>  	void *pi = port->portinfo, *ni = node->nodeinfo, *nd = node->nodedesc;
>> @@ -164,6 +176,7 @@ static int switch_lookup(Switch * sw, ib_portid_t *
>> portid, int lid)
>>
>>  	mad_decode_field(si, IB_SW_LINEAR_FDB_CAP_F, &sw->linearcap);
>>  	mad_decode_field(si, IB_SW_LINEAR_FDB_TOP_F, &sw-
>>> linearFDBtop);
>> +	mad_decode_field(si, IB_SW_ENHANCED_PORT0_F, &sw->enhsp0);
>>
>>  	if (lid >= sw->linearcap && lid > sw->linearFDBtop)
>>  		return -1;
>> @@ -248,7 +261,7 @@ static int find_route(ib_portid_t * from, ib_portid_t *
>> to, int dump)
>>  	Port *port, fromport, toport, nextport;
>>  	Switch sw;
>>  	int maxhops = MAXHOPS;
>> -	int portnum, outport;
>> +	int portnum, outport = 255, next_sw_outport = 255;
>>
>>  	memset(&fromnode,0,sizeof(Node));
>>  	memset(&tonode,0,sizeof(Node));
>> @@ -274,20 +287,28 @@ static int find_route(ib_portid_t * from, ib_portid_t *
>> to, int dump)
>>  	portnum = port->portnum;
>>
>>  	dump_endnode(dump, "From", node, port);
>> +	if (node->type == IB_NODE_SWITCH) {
>> +		next_sw_outport = switch_lookup(&sw, from, to->lid);
>> +		if (next_sw_outport < 0 || next_sw_outport > node->numports)
>> {
>> +			/* needed to print the port in badtbl */
>> +			outport = next_sw_outport;
>> +			goto badtbl;
>> +		}
>> +	}
>>
>>  	while (maxhops--) {
>> -		if (port->state != 4)
>> +		/* checking if the port state isn't active.
>> +		 * The "sw" argument is only relevant when the port is a
>> +		 * switch port for HCAs this argument is ignored */
> 
> This comment should go above the function signature and be enhanced to clarify that it is checking for port state inactive except for BSP0 which has no state.

Will do that in next version of the patch.

-- Hal

> 
> Ira
> 
> 
>> +		if (is_route_inactive_port0(node, port, &sw))
>>  			goto badport;
>>
>>  		if (sameport(port, &toport))
>>  			break;	/* found */
>>
>> -		outport = portnum;
>>  		if (node->type == IB_NODE_SWITCH) {
>>  			DEBUG("switch node");
>> -			if ((outport = switch_lookup(&sw, from, to->lid)) < 0 ||
>> -			    outport > node->numports)
>> -				goto badtbl;
>> +			outport = next_sw_outport;
>>
>>  			if (extend_dpath(&from->drpath, outport) < 0)
>>  				goto badpath;
>> @@ -307,6 +328,7 @@ static int find_route(ib_portid_t * from, ib_portid_t *
>> to, int dump)
>>  			   (node->type == IB_NODE_ROUTER)) {
>>  			int ca_src = 0;
>>
>> +			outport = portnum;
>>  			DEBUG("ca or router node");
>>  			if (!sameport(port, &fromport)) {
>>  				IBWARN
>> @@ -335,8 +357,19 @@ static int find_route(ib_portid_t * from, ib_portid_t *
>> to, int dump)
>>  				nextport.portnum =
>>  				    from->drpath.p[from->drpath.cnt + 1];
>>  		}
>> +		/* only if the next node is a switch, get switch info */
>> +		if (nextnode.type == IB_NODE_SWITCH) {
>> +			next_sw_outport = switch_lookup(&sw, from, to->lid);
>> +			if (next_sw_outport < 0 ||
>> +			    next_sw_outport > nextnode.numports) {
>> +				/* needed to print the port in badtbl */
>> +				outport = next_sw_outport;
>> +				goto badtbl;
>> +			}
>> +		}
>> +
>>  		port = &nextport;
>> -		if (port->state != 4)
>> +		if (is_route_inactive_port0(&nextnode, port, &sw))
>>  			goto badoutport;
>>  		node = &nextnode;
>>  		portnum = port->portnum;
>> --
>> 1.7.8.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
