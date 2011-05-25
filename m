From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2 V2] infiniband-diags: perfquery; Support PortCountersExtendedNoIETF
Date: Wed, 25 May 2011 17:46:28 -0400
Message-ID: <4DDD78B4.7030301@dev.mellanox.co.il>
References: <20110524144206.edb3b5d4.weiny2@llnl.gov>	<4DDCF65C.6000309@dev.mellanox.co.il>	<20110525095037.c7a945e7.weiny2@llnl.gov>	<4DDD480C.7050607@dev.mellanox.co.il> <20110525134155.91dc6614.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110525134155.91dc6614.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/25/2011 4:41 PM, Ira Weiny wrote:
> On Wed, 25 May 2011 11:18:52 -0700
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 5/25/2011 12:50 PM, Ira Weiny wrote:
>>>
>>> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>>> Date: Fri, 13 May 2011 22:28:55 -0700
>>> Subject: [PATCH 2/2] infiniband-diags: perfquery; Support PortCountersExtendedNoIETF
>>>
>>> Changes since V1:
>>> fix typo
>>>    if (cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP) {
>>> to
>>> 	if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) {
>>>
>>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>>> ---
>>>  src/perfquery.c |   52 ++++++++++++++++++++++++++++++++--------------------
>>>  1 files changed, 32 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/src/perfquery.c b/src/perfquery.c
>>> index 165c419..8923654 100644
>>> --- a/src/perfquery.c
>>> +++ b/src/perfquery.c
>>> @@ -227,7 +227,7 @@ static void output_aggregate_perfcounters(ib_portid_t * portid,
>>>  	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), buf);
>>>  }
>>>  
>>> -static void aggregate_perfcounters_ext(void)
>>> +static void aggregate_perfcounters_ext(uint16_t cap_mask)
>>>  {
>>>  	uint32_t val;
>>>  	uint64_t val64;
>>> @@ -244,14 +244,17 @@ static void aggregate_perfcounters_ext(void)
>>>  	aggregate_64bit(&perf_count_ext.portxmitpkts, val64);
>>>  	mad_decode_field(pc, IB_PC_EXT_RCV_PKTS_F, &val64);
>>>  	aggregate_64bit(&perf_count_ext.portrcvpkts, val64);
>>> -	mad_decode_field(pc, IB_PC_EXT_XMT_UPKTS_F, &val64);
>>> -	aggregate_64bit(&perf_count_ext.portunicastxmitpkts, val64);
>>> -	mad_decode_field(pc, IB_PC_EXT_RCV_UPKTS_F, &val64);
>>> -	aggregate_64bit(&perf_count_ext.portunicastrcvpkts, val64);
>>> -	mad_decode_field(pc, IB_PC_EXT_XMT_MPKTS_F, &val64);
>>> -	aggregate_64bit(&perf_count_ext.portmulticastxmitpkits, val64);
>>> -	mad_decode_field(pc, IB_PC_EXT_RCV_MPKTS_F, &val64);
>>> -	aggregate_64bit(&perf_count_ext.portmulticastrcvpkts, val64);
>>> +
>>> +	if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) {
>>> +		mad_decode_field(pc, IB_PC_EXT_XMT_UPKTS_F, &val64);
>>> +		aggregate_64bit(&perf_count_ext.portunicastxmitpkts, val64);
>>> +		mad_decode_field(pc, IB_PC_EXT_RCV_UPKTS_F, &val64);
>>> +		aggregate_64bit(&perf_count_ext.portunicastrcvpkts, val64);
>>> +		mad_decode_field(pc, IB_PC_EXT_XMT_MPKTS_F, &val64);
>>> +		aggregate_64bit(&perf_count_ext.portmulticastxmitpkits, val64);
>>> +		mad_decode_field(pc, IB_PC_EXT_RCV_MPKTS_F, &val64);
>>> +		aggregate_64bit(&perf_count_ext.portmulticastrcvpkts, val64);
>>> +	}
>>
>> Since all these fields are already 64 bits, why is the aggregation even
>> needed for the extended counters ? Should any perfcounters_ext
>> aggregation routines just get excised ?
> 
> Not quite sure what you mean here.  aggregate_perfcounters_ext must exist as it is
> used to sum readings across all ports.  (Mainly to simulate AllPortSelect when
> the node does not support it.)  I don't see anything which can be removed
> without removing that functionality.

Never mind; my bad; I forgot about emulating all ports when it's not
supported.

-- Hal

> 
> Ira
> 
>>
>> -- Hal
>>
>>>  }
>>>  
>>>  static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
>>> @@ -260,6 +263,8 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
>>>  	char buf[1024];
>>>  	uint32_t val = ALL_PORTS;
>>>  
>>> +	memset(buf, 0, 1024);
>>> +
>>>  	/* set port_select to 255 to emulate AllPortSelect */
>>>  	mad_encode_field(pc, IB_PC_EXT_PORT_SELECT_F, &val);
>>>  	mad_encode_field(pc, IB_PC_EXT_COUNTER_SELECT_F,
>>> @@ -271,14 +276,17 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
>>>  	mad_encode_field(pc, IB_PC_EXT_XMT_PKTS_F,
>>>  			 &perf_count_ext.portxmitpkts);
>>>  	mad_encode_field(pc, IB_PC_EXT_RCV_PKTS_F, &perf_count_ext.portrcvpkts);
>>> -	mad_encode_field(pc, IB_PC_EXT_XMT_UPKTS_F,
>>> -			 &perf_count_ext.portunicastxmitpkts);
>>> -	mad_encode_field(pc, IB_PC_EXT_RCV_UPKTS_F,
>>> -			 &perf_count_ext.portunicastrcvpkts);
>>> -	mad_encode_field(pc, IB_PC_EXT_XMT_MPKTS_F,
>>> -			 &perf_count_ext.portmulticastxmitpkits);
>>> -	mad_encode_field(pc, IB_PC_EXT_RCV_MPKTS_F,
>>> -			 &perf_count_ext.portmulticastrcvpkts);
>>> +
>>> +	if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) {
>>> +		mad_encode_field(pc, IB_PC_EXT_XMT_UPKTS_F,
>>> +				 &perf_count_ext.portunicastxmitpkts);
>>> +		mad_encode_field(pc, IB_PC_EXT_RCV_UPKTS_F,
>>> +				 &perf_count_ext.portunicastrcvpkts);
>>> +		mad_encode_field(pc, IB_PC_EXT_XMT_MPKTS_F,
>>> +				 &perf_count_ext.portmulticastxmitpkits);
>>> +		mad_encode_field(pc, IB_PC_EXT_RCV_MPKTS_F,
>>> +				 &perf_count_ext.portmulticastrcvpkts);
>>> +	}
>>>  	mad_dump_perfcounters_ext(buf, sizeof buf, pc, sizeof pc);
>>>  
>>> @@ -312,9 +320,13 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
>>>  							(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)?IB_PC_LAST_F:(IB_PC_RCV_PKTS_F+1));
>>>  
>>>  	} else {
>>> -		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED))	/* 1.2 errata: bit 9 is extended counter support */
>>> +		/* 1.2 errata: bit 9 is extended counter support
>>> +		 * bit 10 is extended counter NoIETF
>>> +		 */
>>> +		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) &&
>>> +		    !(cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP))
>>>  			IBWARN
>>> -			    ("PerfMgt ClassPortInfo 0x%x extended counters not indicated\n",
>>> +			    ("PerfMgt ClassPortInfo 0x%x; No extended counter support indicated\n",
>>>  			     ntohs(cap_mask));
>>>  
>>>  		memset(pc, 0, sizeof(pc));
>>> @@ -322,7 +334,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
>>>  				   IB_GSI_PORT_COUNTERS_EXT, srcport))
>>>  			IBERROR("perfextquery");
>>>  		if (aggregate)
>>> -			aggregate_perfcounters_ext();
>>> +			aggregate_perfcounters_ext(cap_mask);
>>>  		else
>>>  			mad_dump_perfcounters_ext(buf, sizeof buf, pc,
>>>  						  sizeof pc);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
