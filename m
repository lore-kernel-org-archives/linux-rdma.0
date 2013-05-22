From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3 infiniband-diags] saquery: Add SwitchInfoRecord
 support
Date: Tue, 21 May 2013 21:20:39 -0700
Message-ID: <20130521212039.a211fc2a65ca1e48eb0252f5@intel.com>
References: <519BD19E.6000805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519BD19E.6000805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Husam Kahalah <HKahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 21 May 2013 15:57:18 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> This patch is the combination of the 2 patches supplied by Husam Kahalah
>         [v2] infiniband-diags/saquery.c: switchinfo support added
>         switchinfo support added manual
> 
> In addition, this version changes the field names to match those in Vol1 v1.2.1
> and Errata.
> 
> Signed-off-by: Husam Kahalah <hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since Ira's version:
> Fixed doc as SWIR option only has LID and not block
> Made LifeTimeValue/PortStateChange/OpSL2VL output in hex rather than decimal
> Also, made PIR RID output consistent with others
> Deferring handling of different size SwitchInfoRecords based on SA capability to a subsequent patch

Sounds fine to me.

Thanks Applied,
Ira

> 
> diff --git a/doc/man/saquery.8.in b/doc/man/saquery.8.in
> index e9a05cd..65ede4a 100644
> --- a/doc/man/saquery.8.in
> +++ b/doc/man/saquery.8.in
> @@ -183,6 +183,7 @@ MCMemberRecord (MCMR)
>  LFTRecord (LFTR) [[lid]/[block]]
>  MFTRecord (MFTR) [[mlid]/[position]/[block]]
>  GUIDInfoRecord (GIR) [[lid]/[block]]
> +SwitchInfoRecord (SWIR) [lid]
>  .ft P
>  .fi
>  .UNINDENT
> diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
> index 98f7d1f..8d87096 100644
> --- a/doc/rst/saquery.8.in.rst
> +++ b/doc/rst/saquery.8.in.rst
> @@ -155,6 +155,7 @@ Supported query names (and aliases):
>          LFTRecord (LFTR) [[lid]/[block]]
>          MFTRecord (MFTR) [[mlid]/[position]/[block]]
>          GUIDInfoRecord (GIR) [[lid]/[block]]
> +        SwitchInfoRecord (SWIR) [lid]
>  
>  
>  
> diff --git a/src/saquery.c b/src/saquery.c
> index 72a0fe9..a5f9171 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -296,7 +296,7 @@ static void dump_one_portinfo_record(void *data)
>  	ib_port_info_t *pi = &pir->port_info;
>  
>  	printf("PortInfoRecord dump:\n"
> -	       "\tRID:\n"
> +	       "\tRID\n"
>  	       "\t\tEndPortLid..............%u\n"
>  	       "\t\tPortNum.................%u\n"
>  	       "\t\tOptions.................0x%x\n"
> @@ -487,6 +487,41 @@ static void dump_service_record(void *data)
>  	       cl_ntoh64(p_sr->service_data64[1]));
>  }
>  
> +static void dump_switch_info_record(void *data)
> +{
> +	ib_switch_info_record_t *p_sir = data;
> +
> +	printf("SwitchInfoRecord dump:\n"
> +		"\t\tRID\n"
> +		"\t\tLID.....................................%u\n"
> +		"\t\tSwitchInfo dump:\n"
> +		"\t\tLinearFDBCap............................0x%X\n"
> +		"\t\tRandomFDBCap............................0x%X\n"
> +		"\t\tMulticastFDBCap.........................0x%X\n"
> +		"\t\tLinearFDBTop............................0x%X\n"
> +		"\t\tDefaultPort.............................%u\n"
> +		"\t\tDefaultMulticastPrimaryPort.............%u\n"
> +		"\t\tDefaultMulticastNotPrimaryPort..........%u\n"
> +		"\t\tLifeTimeValue/PortStateChange/OpSL2VL...0x%X\n"
> +		"\t\tLIDsPerPort.............................0x%X\n"
> +		"\t\tPartitionEnforcementCap.................0x%X\n"
> +		"\t\tflags...................................0x%X\n"
> +		"\t\tMulticastFDBTop.........................0x%X\n",
> +		cl_ntoh16(p_sir->lid),
> +		cl_ntoh16(p_sir->switch_info.lin_cap),
> +		cl_ntoh16(p_sir->switch_info.rand_cap),
> +		cl_ntoh16(p_sir->switch_info.mcast_cap),
> +		cl_ntoh16(p_sir->switch_info.lin_top),
> +		p_sir->switch_info.def_port,
> +		p_sir->switch_info.def_mcast_pri_port,
> +		p_sir->switch_info.def_mcast_not_port,
> +		p_sir->switch_info.life_state,
> +		cl_ntoh16(p_sir->switch_info.lids_per_port),
> +		cl_ntoh16(p_sir->switch_info.enforce_cap),
> +		p_sir->switch_info.flags,
> +		cl_ntoh16(p_sir->switch_info.mcast_top));
> +}
> +
>  static void dump_inform_info_record(void *data)
>  {
>  	char gid_str[INET6_ADDRSTRLEN];
> @@ -1157,6 +1192,24 @@ static int query_service_records(const struct query_cmd *q, struct sa_handle * h
>  					dump_service_record);
>  }
>  
> +static int query_switchinfo_records(const struct query_cmd *q,
> +				struct sa_handle * h, struct query_params *p,
> +				int argc, char *argv[])
> +{
> +	ib_switch_info_record_t swir;
> +	ib_net64_t comp_mask = 0;
> +	int lid = 0;
> +
> +	if (argc > 0)
> +		parse_lid_and_ports(h, argv[0], &lid, NULL, NULL);
> +
> +	memset(&swir, 0, sizeof(swir));
> +	CHECK_AND_SET_VAL(lid, 16, 0, swir.lid, SWIR, LID);
> +
> +	return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, comp_mask,
> +					&swir, sizeof(swir), dump_switch_info_record);
> +}
> +
>  static int query_inform_info_records(const struct query_cmd *q,
>  				    struct sa_handle * h, struct query_params *p,
>  				    int argc, char *argv[])
> @@ -1349,6 +1402,8 @@ static const struct query_cmd query_cmds[] = {
>  	 "[[mlid]/[position]/[block]]", query_mft_records},
>  	{"GUIDInfoRecord", "GIR", IB_SA_ATTR_GUIDINFORECORD,
>  	 "[[lid]/[block]]", query_guidinfo_records},
> +	{"SwitchInfoRecord", "SWIR", IB_SA_ATTR_SWITCHINFORECORD,
> +	 "[lid]", query_switchinfo_records},
>  	{0}
>  };
>  


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
