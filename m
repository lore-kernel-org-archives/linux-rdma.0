From: Dan Ben-Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv2] libibmad: Add new fields for SM:PortInfoExtended and
 for PM:PortExtendedSpeedsCounters
Date: Sun, 09 Nov 2014 15:29:19 +0200
Message-ID: <545F6C2F.7040807@dev.mellanox.co.il>
References: <20141023062532.GA31987@r-ufm96.mtr.labs.mlnx> <2807E5FD2F6FDA4886F6618EAC48510E0CBA7D00@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBA7D00-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,
1. Please see that for PortExtendedSpeedsCounters, when RSFEC is
disabled, we'll use the old enums for the attribute
PortExtendedSpeedsCounters (please see in line 817 in
include/infiniband/mad.h) but when RSFEC is enabled we'll use this patch
new enums. Moreover we can print the fields differently to match as if
the RSFEC is enabled or disabled.
2. please see my comments below.
Thanks,
Dan

On 11/8/2014 4:29 PM, Weiny, Ira wrote:
>> +
>> +	/*
>> +	 * PortExtendedSpeedsCounters RSFEC active fields
>> +	 */
> 
> Use  IB_PESC_RSFEC_FIRST_F and then set IB_PESC_RSFEC_PORT_SELECT_F to that.
done

> 
>> +	IB_PESC_RSFEC_PORT_SELECT_F,
>> +	IB_PESC_RSFEC_COUNTER_SELECT_F,
>> +	IB_PESC_RSFEC_SYNC_HDR_ERR_CTR_F,
>> +	IB_PESC_RSFEC_UNK_BLOCK_CTR_F,
> 
> What about ErrorDetectionCounterLaneX?
please see IB_PESC_ERR_DET_CTR_LANE0_F in line 823

> 
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE0_F,
> 
> 
> I'm not quite sure of the name here because this can be either Symbol or Block counter...
> 
> What if we just drop the "SYMBOL" and leave it as:
> 
> IB_PESC_RSFEC_FEC_CORR_CTR_LANE(X)_F
This is only relevant for RSFEC active, so the name is ok.

> 
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE1_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE2_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE3_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE4_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE5_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE6_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE7_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE8_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE9_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE10_F,
>> +	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE11_F,
> 
> What about FECUncorrectable*CounterLaneX?
please see under: "IB_PESC_FEC_UNCORR_BLOCK_CTR_LANE0_F" line 847, which
are relevant when RSFEC is disabled.
> 
> Again it seems this counter is likely to have multiple meanings so use
> 
> IB_PESC_RSFEC_FEC_UNCORR_CTR_LANE(X)_F
> 
as the old name : "IB_PESC_FEC_UNCORR_BLOCK_CTR_LANE0_F".

>> +	IB_PESC_PORT_FEC_CORR_BLOCK_CTR_F,
>> +	IB_PESC_PORT_FEC_UNCORR_BLOCK_CTR_F,
>> +	IB_PESC_PORT_FEC_CORR_SYMBOL_CTR_F,
>> +	IB_PESC_RSFEC_LAST_F,
>> +
>>  	IB_FIELD_LAST_		/* must be last */
>>  };
>>
>> diff --git a/src/dump.c b/src/dump.c
>> index efe4bc4..64577c0 100644
>> --- a/src/dump.c
>> +++ b/src/dump.c
>> @@ -857,6 +857,13 @@ void mad_dump_portsamples_result(char *buf, int
>> bufsz, void *val, int valsz)
>>  	_dump_fields(buf, bufsz, val, IB_PSR_TAG_F, IB_PSR_LAST_F);  }
>>
>> +void mad_dump_port_ext_speeds_counters_rsfec_active(char *buf, int bufsz,
>> +						    void *val, int valsz)
>> +{
>> +	_dump_fields(buf, bufsz, val, IB_PESC_RSFEC_PORT_SELECT_F,
> 
> Based on the above change use the "FIRST" field here.
done

> 
>> +		     IB_PESC_RSFEC_LAST_F);
>> +}
>> +
>>  void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int
>> valsz)  {
>>  	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F,
>> IB_PESC_LAST_F); @@ -1115,6 +1122,12 @@ void
>> mad_dump_classportinfo(char *buf, int bufsz, void *val, int valsz)
>>  	_dump_fields(buf, bufsz, val, IB_CPI_BASEVER_F, IB_CPI_TRAP_QKEY_F
>> + 1);  }
>>
>> +void mad_dump_portinfo_ext(char *buf, int bufsz, void *val, int valsz)
>> +{
>> +	_dump_fields(buf, bufsz, val, IB_PORT_EXT_CAPMASK_F,
> 
> Use IB_PORT_EXT_FIRST_F here.
done

> 
>> +		     IB_PORT_EXT_LAST_F);
>> +}
>> +
>>  void xdump(FILE * file, char *msg, void *p, int size)  {  #define HEX(x)  ((x) < 10
>> ? '0' + (x) : 'a' + ((x) -10)) diff --git a/src/fields.c b/src/fields.c index
>> 33a6364..a848ebf 100644
>> --- a/src/fields.c
>> +++ b/src/fields.c
>> @@ -949,8 +949,42 @@ static const ib_field_t ib_mad_f[] = {
>>  	{480, 32, "Counter14", mad_dump_uint},
>>  	{0, 0},			/* IB_PSR_LAST_F */
>>
>> -	{0, 0}			/* IB_FIELD_LAST_ */
>> +	/*
>> +	 * PortInfoExtended fields
>> +	 */
>> +	{0, 32, "CapMask", mad_dump_hex},
> 
> I'm not quite sure why the spec was written this way but technically CapMask is only 1 bit???
> 
> Therefore I'm not sure we can define this field as above.  Can we get some assurances from the management WG that the 31 bit reserved field following the CapMask are only going to extend the CapMask?
> 
> 
>> +	{BITSOFFS(32, 16), "FECModeActive", mad_dump_uint},
>> +	{BITSOFFS(48, 16), "FDRFECModeSupported", mad_dump_uint},
> 
> As this is a bit field it is probably better to be printed as hex.
done
> 
>> +	{BITSOFFS(64, 16), "FDRFECModeEnabled", mad_dump_uint},
> 
> Print as hex.
done

> 
>> +	{BITSOFFS(80, 16), "EDRFECModeSupported", mad_dump_uint},
> 
> Print as hex.
done

> 
>> +	{BITSOFFS(96, 16), "EDRFECModeEnabled", mad_dump_uint},
> 
> Print as hex.
done
> 
>> +	{0, 0},			/* IB_PORT_EXT_LAST_F */
>>
>> +	/*
>> +	 * PortExtendedSpeedsCounters RSFEC Active fields
>> +	 */
>> +	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
>> +	{64, 64, "CounterSelect", mad_dump_hex},
>> +	{BITSOFFS(128, 16), "SyncHeaderErrorCounter", mad_dump_uint},
>> +	{BITSOFFS(144, 16), "UnknownBlockCounter", mad_dump_uint},
> 
> Add missing fields.
please see ErrorDetectionCounterLane0 in line 545 in src/fields.c
> 
>> +	{352, 32, "FECCorrectableSymbolCtrLane0", mad_dump_uint},
> 
> Same comment as above regarding the name here.  It is unfortunate that the lib could not change the name based on RS-FEC.  That will be up to other software to decode in a more user friendly way.  For these "raw" dumps we should use the more generic name:
> 
> FECCorrectableCtrLaneX
This is only relevant for RSFEC active, so the name is ok.

> 
>> +	{384, 32, "FECCorrectableSymbolCtrLane1", mad_dump_uint},
>> +	{416, 32, "FECCorrectableSymbolCtrLane2", mad_dump_uint},
>> +	{448, 32, "FECCorrectableSymbolCtrLane3", mad_dump_uint},
>> +	{480, 32, "FECCorrectableSymbolCtrLane4", mad_dump_uint},
>> +	{512, 32, "FECCorrectableSymbolCtrLane5", mad_dump_uint},
>> +	{544, 32, "FECCorrectableSymbolCtrLane6", mad_dump_uint},
>> +	{576, 32, "FECCorrectableSymbolCtrLane7", mad_dump_uint},
>> +	{608, 32, "FECCorrectableSymbolCtrLane8", mad_dump_uint},
>> +	{640, 32, "FECCorrectableSymbolCtrLane9", mad_dump_uint},
>> +	{672, 32, "FECCorrectableSymbolCtrLane10", mad_dump_uint},
>> +	{704, 32, "FECCorrectableSymbolCtrLane11", mad_dump_uint},
> 
> Add missing fields.  Use "FECUncorrectableCtrLaneX".
please see "FECUncorrectableBlockCtrLane0" line 569
> 
> 
> -- Ira
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
