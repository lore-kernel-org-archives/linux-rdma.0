From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Subject: [PATCH] infiniband-diags: saquery: Dump SwitchInfoRecord
 based on IsSetMulticastFDBTopSupported SA Capability
Date: Mon, 24 Jun 2013 08:40:54 -0400
Message-ID: <51C83E56.3050008@dev.mellanox.co.il>
References: <20130622144213.9d9d5bfbef1a9fbed45dce59@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130622144213.9d9d5bfbef1a9fbed45dce59-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/22/2013 5:42 PM, Ira Weiny wrote:
> 
> Only include MulticastFDBTop when SA
> ClassPortInfo:CapabilityMask2.IsSetMulticastFDBTopSupported is set
> 
> In order to do this, SA CPI is queried prior to other queries and passed to all
> dump functions via query_params when required.
> 
> Original patch supplied by Hal Rosenstock.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This looks mainly fine to me. Just a nit below...

> ---
>  src/saquery.c |  206 ++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 118 insertions(+), 88 deletions(-)
> 
> diff --git a/src/saquery.c b/src/saquery.c
> index 26b2a9d..8c17dd4 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -1,8 +1,8 @@
>  /*
>   * Copyright (c) 2006,2007 The Regents of the University of California.
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
> - * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2002-2013 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 1996-2013 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * Produced at Lawrence Livermore National Laboratory.
> @@ -65,6 +65,8 @@
>  				  IB_PR_COMPMASK_SERVICEID_LSB)
>  #endif
>  
> +#define UMAD_SA_CAP_MASK2_IS_MCAST_TOP_SUP (1 << 3)
> +
>  struct query_params {
>  	uint64_t service_id;
>  	ib_gid_t sgid, dgid, gid, mgid;
> @@ -80,6 +82,7 @@ struct query_params {
>  	uint8_t scope;
>  	uint8_t join_state;
>  	int proxy_join;
> +	ib_class_port_info_t cpi;
>  };
>  
>  struct query_cmd {
> @@ -137,7 +140,7 @@ static void print_node_desc(ib_node_record_t * node_record)
>  	}
>  }
>  
> -static void dump_node_record(void *data)
> +static void dump_node_record(void *data, struct query_params *p)
>  {
>  	ib_node_record_t *nr = data;
>  	ib_node_info_t *ni = &nr->node_info;
> @@ -201,10 +204,10 @@ static void print_node_record(ib_node_record_t * node_record)
>  		break;
>  	}
>  
> -	dump_node_record(node_record);
> +	dump_node_record(node_record, 0);
>  }
>  
> -static void dump_path_record(void *data)
> +static void dump_path_record(void *data, struct query_params *p)
>  {
>  	char gid_str[INET6_ADDRSTRLEN];
>  	char gid_str2[INET6_ADDRSTRLEN];
> @@ -238,11 +241,10 @@ static void dump_path_record(void *data)
>  	       p_pr->resv2[3], p_pr->resv2[4], p_pr->resv2[5]);
>  }
>  
> -static void dump_class_port_info(void *data)
> +static void dump_class_port_info(ib_class_port_info_t *cpi)
>  {
>  	char gid_str[INET6_ADDRSTRLEN];
>  	char gid_str2[INET6_ADDRSTRLEN];
> -	ib_class_port_info_t *cpi = data;
>  
>  	printf("SA ClassPortInfo:\n"
>  	       "\t\tBase version.............%d\n"
> @@ -262,19 +264,19 @@ static void dump_class_port_info(void *data)
>  	       "\t\tTrap PKey................0x%04X\n"
>  	       "\t\tTrap HL/QP...............0x%08X\n"
>  	       "\t\tTrap QKey................0x%08X\n",
> -	       cpi->base_ver, cpi->class_ver, cl_ntoh16(cpi->cap_mask),
> +	       cpi->base_ver, cpi->class_ver, ntohs(cpi->cap_mask),
>  	       ib_class_cap_mask2(cpi), ib_class_resp_time_val(cpi),
>  	       inet_ntop(AF_INET6, &(cpi->redir_gid), gid_str, sizeof gid_str),
> -	       cl_ntoh32(cpi->redir_tc_sl_fl), cl_ntoh16(cpi->redir_lid),
> -	       cl_ntoh16(cpi->redir_pkey), cl_ntoh32(cpi->redir_qp),
> -	       cl_ntoh32(cpi->redir_qkey),
> +	       ntohl(cpi->redir_tc_sl_fl), ntohs(cpi->redir_lid),
> +	       ntohs(cpi->redir_pkey), ntohl(cpi->redir_qp),
> +	       ntohl(cpi->redir_qkey),
>  	       inet_ntop(AF_INET6, &(cpi->trap_gid), gid_str2, sizeof gid_str2),
> -	       cl_ntoh32(cpi->trap_tc_sl_fl), cl_ntoh16(cpi->trap_lid),
> -	       cl_ntoh16(cpi->trap_pkey), cl_ntoh32(cpi->trap_hop_qp),
> -	       cl_ntoh32(cpi->trap_qkey));
> +	       ntohl(cpi->trap_tc_sl_fl), ntohs(cpi->trap_lid),
> +	       ntohs(cpi->trap_pkey), ntohl(cpi->trap_hop_qp),
> +	       ntohl(cpi->trap_qkey));

There are other places in saquery where cl_ntoh is used. Should cl_ntohx
-> ntohx conversion for saquery be done in separate patch ?

-- Hal

>  }
>  
> -static void dump_portinfo_record(void *data)
> +static void dump_portinfo_record(void *data, struct query_params *p)
>  {
>  	ib_portinfo_record_t *p_pir = data;
>  	const ib_port_info_t *const p_pi = &p_pir->port_info;
> @@ -290,7 +292,7 @@ static void dump_portinfo_record(void *data)
>  	       cl_ntoh32(p_pi->capability_mask));
>  }
>  
> -static void dump_one_portinfo_record(void *data)
> +static void dump_one_portinfo_record(void *data, struct query_params *p)
>  {
>  	ib_portinfo_record_t *pir = data;
>  	ib_port_info_t *pi = &pir->port_info;
> @@ -305,7 +307,7 @@ static void dump_one_portinfo_record(void *data)
>  	dump_portinfo(pi, sizeof(*pi), 2);
>  }
>  
> -static void dump_one_mcmember_record(void *data)
> +static void dump_one_mcmember_record(void *data, struct query_params *p)
>  {
>  	char mgid[INET6_ADDRSTRLEN], gid[INET6_ADDRSTRLEN];
>  	ib_member_rec_t *mr = data;
> @@ -336,7 +338,7 @@ static void dump_one_mcmember_record(void *data)
>  	       flow, hop, scope, join, mr->proxy_join);
>  }
>  
> -static void dump_multicast_group_record(void *data)
> +static void dump_multicast_group_record(void *data, struct query_params *p)
>  {
>  	char gid_str[INET6_ADDRSTRLEN];
>  	ib_member_rec_t *p_mcmr = data;
> @@ -355,7 +357,8 @@ static void dump_multicast_group_record(void *data)
>  }
>  
>  static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
> -					 struct sa_query_result *nr_result)
> +					 struct sa_query_result *nr_result,
> +					 struct query_params *params)
>  {
>  	char gid_str[INET6_ADDRSTRLEN];
>  	char gid_str2[INET6_ADDRSTRLEN];
> @@ -403,7 +406,7 @@ static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
>  	free(node_name);
>  }
>  
> -static void dump_service_record(void *data)
> +static void dump_service_record(void *data, struct query_params *p)
>  {
>  	char gid[INET6_ADDRSTRLEN];
>  	char buf_service_key[35];
> @@ -489,9 +492,10 @@ static void dump_service_record(void *data)
>  	       cl_ntoh64(p_sr->service_data64[1]));
>  }
>  
> -static void dump_switch_info_record(void *data)
> +static void dump_switch_info_record(void *data, struct query_params *p)
>  {
>  	ib_switch_info_record_t *p_sir = data;
> +	uint32_t sa_cap_mask2 = ib_class_cap_mask2(&p->cpi);
>  
>  	printf("SwitchInfoRecord dump:\n"
>  		"\t\tRID\n"
> @@ -507,8 +511,7 @@ static void dump_switch_info_record(void *data)
>  		"\t\tLifeTimeValue/PortStateChange/OpSL2VL...0x%X\n"
>  		"\t\tLIDsPerPort.............................0x%X\n"
>  		"\t\tPartitionEnforcementCap.................0x%X\n"
> -		"\t\tflags...................................0x%X\n"
> -		"\t\tMulticastFDBTop.........................0x%X\n",
> +		"\t\tflags...................................0x%X\n",
>  		cl_ntoh16(p_sir->lid),
>  		cl_ntoh16(p_sir->switch_info.lin_cap),
>  		cl_ntoh16(p_sir->switch_info.rand_cap),
> @@ -520,11 +523,13 @@ static void dump_switch_info_record(void *data)
>  		p_sir->switch_info.life_state,
>  		cl_ntoh16(p_sir->switch_info.lids_per_port),
>  		cl_ntoh16(p_sir->switch_info.enforce_cap),
> -		p_sir->switch_info.flags,
> -		cl_ntoh16(p_sir->switch_info.mcast_top));
> +		p_sir->switch_info.flags);
> +	if (sa_cap_mask2 & UMAD_SA_CAP_MASK2_IS_MCAST_TOP_SUP)
> +		printf("\t\tMulticastFDBTop.........................0x%X\n",
> +		       cl_ntoh16(p_sir->switch_info.mcast_top));
>  }
>  
> -static void dump_inform_info_record(void *data)
> +static void dump_inform_info_record(void *data, struct query_params *p)
>  {
>  	char gid_str[INET6_ADDRSTRLEN];
>  	char gid_str2[INET6_ADDRSTRLEN];
> @@ -610,7 +615,7 @@ static void dump_inform_info_record(void *data)
>  	}
>  }
>  
> -static void dump_one_link_record(void *data)
> +static void dump_one_link_record(void *data, struct query_params *p)
>  {
>  	ib_link_record_t *lr = data;
>  	printf("LinkRecord dump:\n"
> @@ -622,7 +627,7 @@ static void dump_one_link_record(void *data)
>  	       lr->to_port_num, cl_ntoh16(lr->to_lid));
>  }
>  
> -static void dump_one_slvl_record(void *data)
> +static void dump_one_slvl_record(void *data, struct query_params *p)
>  {
>  	ib_slvl_table_record_t *slvl = data;
>  	ib_slvl_table_t *t = &slvl->slvl_tbl;
> @@ -644,7 +649,7 @@ static void dump_one_slvl_record(void *data)
>  	       ib_slvl_table_get(t, 14), ib_slvl_table_get(t, 15));
>  }
>  
> -static void dump_one_vlarb_record(void *data)
> +static void dump_one_vlarb_record(void *data, struct query_params *p)
>  {
>  	ib_vl_arb_table_record_t *vlarb = data;
>  	ib_vl_arb_element_t *e = vlarb->vl_arb_tbl.vl_entry;
> @@ -671,7 +676,7 @@ static void dump_one_vlarb_record(void *data)
>  		       e[i + 15].weight);
>  }
>  
> -static void dump_one_pkey_tbl_record(void *data)
> +static void dump_one_pkey_tbl_record(void *data, struct query_params *params)
>  {
>  	ib_pkey_table_record_t *pktr = data;
>  	ib_net16_t *p = pktr->pkey_tbl.pkey_entry;
> @@ -692,7 +697,7 @@ static void dump_one_pkey_tbl_record(void *data)
>  	printf("\n");
>  }
>  
> -static void dump_one_lft_record(void *data)
> +static void dump_one_lft_record(void *data, struct query_params *p)
>  {
>  	ib_lft_record_t *lftr = data;
>  	unsigned block = cl_ntoh16(lftr->block_num);
> @@ -706,7 +711,7 @@ static void dump_one_lft_record(void *data)
>  	printf("\n");
>  }
>  
> -static void dump_one_guidinfo_record(void *data)
> +static void dump_one_guidinfo_record(void *data, struct query_params *p)
>  {
>  	ib_guidinfo_record_t *gir = data;
>  	printf("GUIDInfo Record dump:\n"
> @@ -731,7 +736,7 @@ static void dump_one_guidinfo_record(void *data)
>  	       cl_ntoh64(gir->guid_info.guid[7]));
>  }
>  
> -static void dump_one_mft_record(void *data)
> +static void dump_one_mft_record(void *data, struct query_params *p)
>  {
>  	ib_mft_record_t *mftr = data;
>  	unsigned position = cl_ntoh16(mftr->position_block_num) >> 12;
> @@ -753,12 +758,14 @@ static void dump_one_mft_record(void *data)
>  	printf("\n");
>  }
>  
> -static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
> +static void dump_results(struct sa_query_result *r,
> +			 void (*dump_func) (void *, struct query_params *),
> +			 struct query_params *p)
>  {
>  	unsigned i;
>  	for (i = 0; i < r->result_cnt; i++) {
>  		void *data = sa_get_query_rec(r->p_result_madw, i);
> -		dump_func(data);
> +		dump_func(data, p);
>  	}
>  }
>  
> @@ -790,7 +797,9 @@ static int get_and_dump_any_records(struct sa_handle * h, uint16_t attr_id,
>  				    uint32_t attr_mod, ib_net64_t comp_mask,
>  				    void *attr,
>  				    size_t attr_size,
> -				    void (*dump_func) (void *))
> +				    void (*dump_func) (void *,
> +				    		       struct query_params *),
> +				    struct query_params *p)
>  {
>  	struct sa_query_result result;
>  	int ret = get_any_records(h, attr_id, attr_mod, comp_mask, attr,
> @@ -798,7 +807,7 @@ static int get_and_dump_any_records(struct sa_handle * h, uint16_t attr_id,
>  	if (ret)
>  		return ret;
>  
> -	dump_results(&result, dump_func);
> +	dump_results(&result, dump_func, p);
>  	sa_free_result_mad(&result);
>  	return 0;
>  }
> @@ -813,14 +822,16 @@ static int get_all_records(struct sa_handle * h, uint16_t attr_id,
>  }
>  
>  static int get_and_dump_all_records(struct sa_handle * h, uint16_t attr_id,
> -				    void (*dump_func) (void *))
> +				    void (*dump_func) (void *,
> +						       struct query_params *p),
> +				    struct query_params *p)
>  {
>  	struct sa_query_result result;
>  	int ret = get_all_records(h, attr_id, &result);
>  	if (ret)
>  		return ret;
>  
> -	dump_results(&result, dump_func);
> +	dump_results(&result, dump_func, p);
>  	sa_free_result_mad(&result);
>  	return ret;
>  }
> @@ -949,7 +960,7 @@ static int get_issm_records(struct sa_handle * h, ib_net32_t capability_mask,
>  			       IB_PIR_COMPMASK_CAPMASK, &attr, sizeof(attr), result);
>  }
>  
> -static int print_node_records(struct sa_handle * h)
> +static int print_node_records(struct sa_handle * h, struct query_params *p)
>  {
>  	unsigned i;
>  	int ret;
> @@ -994,26 +1005,6 @@ static int print_node_records(struct sa_handle * h)
>  	return ret;
>  }
>  
> -static int get_print_class_port_info(struct sa_handle * h)
> -{
> -	struct sa_query_result result;
> -	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
> -			   ibd_sakey, NULL, 0, &result);
> -	if (ret) {
> -		fprintf(stderr, "ERROR: Query SA failed: %s\n", strerror(ret));
> -		return ret;
> -	}
> -	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
> -		sa_report_err(result.status);
> -		ret = EIO;
> -		goto Exit;
> -	}
> -	dump_results(&result, dump_class_port_info);
> -Exit:
> -	sa_free_result_mad(&result);
> -	return ret;
> -}
> -
>  static int query_path_records(const struct query_cmd *q, struct sa_handle * h,
>  			      struct query_params *p, int argc, char *argv[])
>  {
> @@ -1046,10 +1037,10 @@ static int query_path_records(const struct query_cmd *q, struct sa_handle * h,
>  				  SELEC);
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_PATHRECORD, 0, comp_mask,
> -					&pr, sizeof(pr), dump_path_record);
> +					&pr, sizeof(pr), dump_path_record, p);
>  }
>  
> -static int print_issm_records(struct sa_handle * h)
> +static int print_issm_records(struct sa_handle * h, struct query_params *p)
>  {
>  	struct sa_query_result result;
>  	int ret = 0;
> @@ -1060,7 +1051,7 @@ static int print_issm_records(struct sa_handle * h)
>  		return (ret);
>  
>  	printf("IsSM ports\n");
> -	dump_results(&result, dump_portinfo_record);
> +	dump_results(&result, dump_portinfo_record, p);
>  	sa_free_result_mad(&result);
>  
>  	/* Now, get IsSMdisabled records */
> @@ -1069,13 +1060,14 @@ static int print_issm_records(struct sa_handle * h)
>  		return (ret);
>  
>  	printf("\nIsSMdisabled ports\n");
> -	dump_results(&result, dump_portinfo_record);
> +	dump_results(&result, dump_portinfo_record, p);
>  	sa_free_result_mad(&result);
>  
>  	return (ret);
>  }
>  
> -static int print_multicast_member_records(struct sa_handle * h)
> +static int print_multicast_member_records(struct sa_handle * h,
> +					struct query_params *params)
>  {
>  	struct sa_query_result mc_group_result;
>  	struct sa_query_result nr_result;
> @@ -1094,7 +1086,7 @@ static int print_multicast_member_records(struct sa_handle * h)
>  		ib_member_rec_t *rec = (ib_member_rec_t *)
>  				sa_get_query_rec(mc_group_result.p_result_madw,
>  					      i);
> -		dump_multicast_member_record(rec, &nr_result);
> +		dump_multicast_member_record(rec, &nr_result, params);
>  	}
>  
>  	sa_free_result_mad(&nr_result);
> @@ -1105,16 +1097,18 @@ return_mc:
>  	return ret;
>  }
>  
> -static int print_multicast_group_records(struct sa_handle * h)
> +static int print_multicast_group_records(struct sa_handle * h,
> +					 struct query_params *p)
>  {
>  	return get_and_dump_all_records(h, IB_SA_ATTR_MCRECORD,
> -					dump_multicast_group_record);
> +					dump_multicast_group_record, p);
>  }
>  
>  static int query_class_port_info(const struct query_cmd *q, struct sa_handle * h,
>  				 struct query_params *p, int argc, char *argv[])
>  {
> -	return get_print_class_port_info(h);
> +	dump_class_port_info(&p->cpi);
> +	return (0);
>  }
>  
>  static int query_node_records(const struct query_cmd *q, struct sa_handle * h,
> @@ -1131,7 +1125,7 @@ static int query_node_records(const struct query_cmd *q, struct sa_handle * h,
>  	CHECK_AND_SET_VAL(lid, 16, 0, nr.lid, NR, LID);
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_NODERECORD, 0, comp_mask,
> -					&nr, sizeof(nr), dump_node_record);
> +					&nr, sizeof(nr), dump_node_record, p);
>  }
>  
>  static int query_portinfo_records(const struct query_cmd *q,
> @@ -1152,7 +1146,7 @@ static int query_portinfo_records(const struct query_cmd *q,
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_PORTINFORECORD, 0,
>  					comp_mask, &pir, sizeof(pir),
> -					dump_one_portinfo_record);
> +					dump_one_portinfo_record, p);
>  }
>  
>  static int query_mcmember_records(const struct query_cmd *q,
> @@ -1184,14 +1178,14 @@ static int query_mcmember_records(const struct query_cmd *q,
>  	CHECK_AND_SET_VAL(p->proxy_join, 8, -1, mr.proxy_join, MCR, PROXY);
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_MCRECORD, 0, comp_mask,
> -					&mr, sizeof(mr), dump_one_mcmember_record);
> +					&mr, sizeof(mr), dump_one_mcmember_record, p);
>  }
>  
>  static int query_service_records(const struct query_cmd *q, struct sa_handle * h,
>  				 struct query_params *p, int argc, char *argv[])
>  {
>  	return get_and_dump_all_records(h, IB_SA_ATTR_SERVICERECORD,
> -					dump_service_record);
> +					dump_service_record, p);
>  }
>  
>  static int query_switchinfo_records(const struct query_cmd *q,
> @@ -1208,8 +1202,9 @@ static int query_switchinfo_records(const struct query_cmd *q,
>  	memset(&swir, 0, sizeof(swir));
>  	CHECK_AND_SET_VAL(lid, 16, 0, swir.lid, SWIR, LID);
>  
> -	return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, comp_mask,
> -					&swir, sizeof(swir), dump_switch_info_record);
> +	return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0,
> +					comp_mask, &swir, sizeof(swir),
> +					dump_switch_info_record, p);
>  }
>  
>  static int query_inform_info_records(const struct query_cmd *q,
> @@ -1228,7 +1223,7 @@ static int query_inform_info_records(const struct query_cmd *q,
>         }
>  
>         return get_and_dump_any_records(h, IB_SA_ATTR_INFORMINFORECORD, 0, comp_mask,
> -				       &ir, sizeof(ir), dump_inform_info_record);
> +				       &ir, sizeof(ir), dump_inform_info_record, p);
>  
>  }
>  
> @@ -1252,7 +1247,7 @@ static int query_link_records(const struct query_cmd *q, struct sa_handle * h,
>  	CHECK_AND_SET_VAL(to_port, 8, -1, lr.to_port_num, LR, TO_PORT);
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_LINKRECORD, 0, comp_mask,
> -					&lr, sizeof(lr), dump_one_link_record);
> +					&lr, sizeof(lr), dump_one_link_record, p);
>  }
>  
>  static int query_sl2vl_records(const struct query_cmd *q, struct sa_handle * h,
> @@ -1272,7 +1267,7 @@ static int query_sl2vl_records(const struct query_cmd *q, struct sa_handle * h,
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_SL2VLTABLERECORD, 0,
>  					comp_mask, &slvl, sizeof(slvl),
> -					dump_one_slvl_record);
> +					dump_one_slvl_record, p);
>  }
>  
>  static int query_vlarb_records(const struct query_cmd *q, struct sa_handle * h,
> @@ -1292,7 +1287,7 @@ static int query_vlarb_records(const struct query_cmd *q, struct sa_handle * h,
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_VLARBTABLERECORD, 0,
>  					comp_mask, &vlarb, sizeof(vlarb),
> -					dump_one_vlarb_record);
> +					dump_one_vlarb_record, p);
>  }
>  
>  static int query_pkey_tbl_records(const struct query_cmd *q,
> @@ -1313,7 +1308,7 @@ static int query_pkey_tbl_records(const struct query_cmd *q,
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_PKEYTABLERECORD, 0,
>  					comp_mask, &pktr, sizeof(pktr),
> -					dump_one_pkey_tbl_record);
> +					dump_one_pkey_tbl_record, p);
>  }
>  
>  static int query_lft_records(const struct query_cmd *q, struct sa_handle * h,
> @@ -1331,7 +1326,7 @@ static int query_lft_records(const struct query_cmd *q, struct sa_handle * h,
>  	CHECK_AND_SET_VAL(block, 16, -1, lftr.block_num, LFTR, BLOCK);
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_LFTRECORD, 0, comp_mask,
> -					&lftr, sizeof(lftr), dump_one_lft_record);
> +					&lftr, sizeof(lftr), dump_one_lft_record, p);
>  }
>  
>  static int query_guidinfo_records(const struct query_cmd *q, struct sa_handle * h,
> @@ -1350,7 +1345,7 @@ static int query_guidinfo_records(const struct query_cmd *q, struct sa_handle *
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_GUIDINFORECORD, 0,
>  					comp_mask, &gir, sizeof(gir),
> -					dump_one_guidinfo_record);
> +					dump_one_guidinfo_record, p);
>  }
>  
>  static int query_mft_records(const struct query_cmd *q, struct sa_handle * h,
> @@ -1372,7 +1367,30 @@ static int query_mft_records(const struct query_cmd *q, struct sa_handle * h,
>  	mftr.position_block_num |= cl_hton16(pos << 12);
>  
>  	return get_and_dump_any_records(h, IB_SA_ATTR_MFTRECORD, 0, comp_mask,
> -					&mftr, sizeof(mftr), dump_one_mft_record);
> +					&mftr, sizeof(mftr), dump_one_mft_record, p);
> +}
> +
> +static int query_sa_cpi(struct sa_handle *h, struct query_params *query_params)
> +{
> +	ib_class_port_info_t *cpi;
> +	struct sa_query_result result;
> +	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
> +		       ibd_sakey, NULL, 0, &result);
> +	if (ret) {
> +		fprintf(stderr, "ERROR: Query SA failed: %s\n", strerror(ret));
> +		return ret;
> +	}
> +
> +	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
> +		sa_report_err(result.status);
> +		ret = EIO;
> +		goto Exit;
> +	}
> +	cpi = sa_get_query_rec(result.p_result_madw, 0);
> +	memcpy(&query_params->cpi, cpi, sizeof(query_params->cpi));
> +Exit:
> +	sa_free_result_mad(&result);
> +	return (0);
>  }
>  
>  static const struct query_cmd query_cmds[] = {
> @@ -1626,6 +1644,7 @@ static int process_opt(void *context, int ch, char *optarg)
>  
>  int main(int argc, char **argv)
>  {
> +	int sa_cpi_required = 0;
>  	char usage_args[1024];
>  	struct sa_handle * h;
>  	struct query_params params;
> @@ -1789,21 +1808,31 @@ int main(int argc, char **argv)
>  	if (dst_lid && *dst_lid)
>  		params.dlid = get_lid(h, dst_lid);
>  
> +	if (command == SAQUERY_CMD_CLASS_PORT_INFO ||
> +	    query_type == IB_SA_ATTR_SWITCHINFORECORD)
> +		sa_cpi_required = 1;
> +
> +	if (sa_cpi_required && (status = query_sa_cpi(h, &params)) != 0) {
> +		fprintf(stderr, "Failed to query SA:ClassPortInfo\n");
> +		goto error;
> +	}
> +
>  	switch (command) {
>  	case SAQUERY_CMD_NODE_RECORD:
> -		status = print_node_records(h);
> +		status = print_node_records(h, &params);
>  		break;
>  	case SAQUERY_CMD_CLASS_PORT_INFO:
> -		status = get_print_class_port_info(h);
> +		dump_class_port_info(&params.cpi);
> +		status = 0;
>  		break;
>  	case SAQUERY_CMD_ISSM:
> -		status = print_issm_records(h);
> +		status = print_issm_records(h, &params);
>  		break;
>  	case SAQUERY_CMD_MCGROUPS:
> -		status = print_multicast_group_records(h);
> +		status = print_multicast_group_records(h, &params);
>  		break;
>  	case SAQUERY_CMD_MCMEMBERS:
> -		status = print_multicast_member_records(h);
> +		status = print_multicast_member_records(h, &params);
>  		break;
>  	default:
>  		if ((!q && !(q = find_query_by_type(query_type)))
> @@ -1816,6 +1845,7 @@ int main(int argc, char **argv)
>  		break;
>  	}
>  
> +error:
>  	if (src_lid)
>  		free(src_lid);
>  	sa_free_handle(h);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
