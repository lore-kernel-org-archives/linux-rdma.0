From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add configurable retries for transactions
Date: Fri, 30 Oct 2009 04:55:41 +0200
Message-ID: <20091030025541.GU20136@me>
References: <20091024140538.GA5213@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091024140538.GA5213-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:05 Sat 24 Oct     , Hal Rosenstock wrote:
> 
> As part of this change, transaction timeouts (and retries) are per
> umad agent (supplied at osm_vendor_bind).
> 
> Old ABI is supported without these bind parameters.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/include/opensm/osm_madw.h b/opensm/include/opensm/osm_madw.h
> index afa7047..10a065b 100644
> --- a/opensm/include/opensm/osm_madw.h
> +++ b/opensm/include/opensm/osm_madw.h
> @@ -2,6 +2,7 @@
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -76,6 +77,8 @@ typedef struct osm_bind_info {
>  	boolean_t is_report_processor;
>  	uint32_t send_q_size;
>  	uint32_t recv_q_size;
> +	uint32_t timeout;
> +	uint32_t retries;
>  } osm_bind_info_t;
>  /*
>  * FIELDS
> @@ -103,6 +106,12 @@ typedef struct osm_bind_info {
>  *	recv_q_size
>  *		Receive Queue Size
>  *
> +*	timeout
> +*		Transaction timeout
> +*
> +*	retries
> +*		Number of retries for transaction
> +*
>  * SEE ALSO
>  *********/
>  
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
> index b63c97e..77347c8 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -4,6 +4,7 @@
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
>   * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -149,6 +150,7 @@ typedef struct osm_subn_opt {
>  	uint32_t sweep_interval;
>  	uint32_t max_wire_smps;
>  	uint32_t transaction_timeout;
> +	uint32_t transaction_retries;
>  	uint8_t sm_priority;
>  	uint8_t lmc;
>  	boolean_t lmc_esp0;
> @@ -261,6 +263,9 @@ typedef struct osm_subn_opt {
>  *		The maximum time in milliseconds allowed for a transaction
>  *		to complete.  Default is 200.
>  *
> +*	transaction_retries
> +*		The number of retries for a transaction. Default is 3.
> +*
>  *	sm_priority
>  *		The priority of this SM as specified by the user.  This
>  *		value is made available in the SMInfo attribute.
> diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
> index 8d3c680..c98141e 100644
> --- a/opensm/libvendor/osm_vendor_ibumad.c
> +++ b/opensm/libvendor/osm_vendor_ibumad.c
> @@ -85,6 +85,8 @@ typedef struct _osm_umad_bind_info {
>  	int port_id;
>  	int agent_id;
>  	int agent_id1;		/* SMI requires two agents */
> +	uint32_t timeout;
> +	uint32_t max_retries;

You don't need fixed size types for those values, do you? And umad_send()
and umad_recv() accept timeout and retries parameters as 'int' - would
be better to be consistent with types.

>  } osm_umad_bind_info_t;
>  
>  typedef struct _umad_receiver {
> @@ -476,7 +478,7 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
>  			p_vend->mtbl.max = tmp;
>  		else
>  			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "Error:"
> -				"OSM_UMAD_MAX_PENDING=%d is invalid",
> +				"OSM_UMAD_MAX_PENDING=%d is invalid\n",
>  				tmp);
>  	}
>  
> @@ -819,6 +821,13 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
>  	p_bind->send_err_callback = send_err_callback;
>  	p_bind->p_mad_pool = p_mad_pool;
>  	p_bind->port_guid = port_guid;
> +	if (p_vend->timeout == -1) {
> +		p_bind->timeout = p_user_bind->timeout;
> +		p_bind->max_retries = p_user_bind->retries;
> +	} else {
> +		p_bind->timeout = p_vend->timeout;
> +		p_bind->max_retries = p_vend->max_retries;
> +	}

Hmm, shouldn't we respect user requested data? Something like:

	p_bind->timeout = p_user_bind->timeout ? p_user_bind->timeout :
				p_vend->timeout;
	p_bind->retries = p_user_bind->retries ? p_user_bind->retries :
				p_vend->retries;

?

>  
>  	memset(method_mask, 0, sizeof method_mask);
>  	if (p_user_bind->is_responder) {
> @@ -1086,8 +1095,8 @@ Resp:
>  #endif
>  	if ((ret = umad_send(p_bind->port_id, p_bind->agent_id, p_vw->umad,
>  			     sent_mad_size,
> -			     resp_expected ? p_vend->timeout : 0,
> -			     p_vend->max_retries)) < 0) {
> +			     resp_expected ? p_bind->timeout : 0,
> +			     p_bind->max_retries)) < 0) {
>  		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5430: "
>  			"Send p_madw = %p of size %d failed %d (%m)\n",
>  			p_madw, sent_mad_size, ret);
> diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
> index 03002c0..bd8ab4e 100644
> --- a/opensm/man/opensm.8.in
> +++ b/opensm/man/opensm.8.in
> @@ -1,4 +1,4 @@
> -.TH OPENSM 8 "September 14, 2009" "OpenIB" "OpenIB Management"
> +.TH OPENSM 8 "October 22, 2009" "OpenIB" "OpenIB Management"
>  
>  .SH NAME
>  opensm \- InfiniBand subnet manager and administration (SM/SA)
> @@ -31,6 +31,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
>  [\-o(nce)]
>  [\-s(weep) <interval>]
>  [\-t(imeout) <milliseconds>]
> +[\-\-retries <number>]
>  [\-maxsmps <number>]
>  [\-console [off | local | socket | loopback]]
>  [\-console-port <port>]
> @@ -233,6 +234,12 @@ Specifying -t 0 disables timeouts.
>  Without -t, OpenSM defaults to a timeout value of
>  200 milliseconds.
>  .TP
> +\fB\-\-retries\fR <number>
> +This option specifies the number of retries used
> +for transactions.
> +Without --retries, OpenSM defaults to 3 retries
> +for transactions.
> +.TP
>  \fB\-maxsmps\fR <number>
>  This option specifies the number of VL15 SMP MADs
>  allowed on the wire at any one time.
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index 2e28c83..b697994 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -248,6 +248,11 @@ static void show_usage(void)
>  	       "          Specifying -t 0 disables timeouts.\n"
>  	       "          Without -t, OpenSM defaults to a timeout value of\n"
>  	       "          200 milliseconds.\n\n");
> +	printf("--retries <number>\n"
> +	       "          This option specifies the number of retries used\n"
> +	       "          for transactions.\n"
> +	       "          Without --retries, OpenSM defaults to %u retries\n"
> +	       "          for transactions.\n\n", OSM_DEFAULT_RETRY_COUNT);
>  	printf("--maxsmps, -n <number>\n"
>  	       "          This option specifies the number of VL15 SMP MADs\n"
>  	       "          allowed on the wire at any one time.\n"
> @@ -610,6 +615,7 @@ int main(int argc, char *argv[])
>  		{"do_mesh_analysis", 0, NULL, 5},
>  		{"lash_start_vl", 1, NULL, 6},
>  		{"sm_sl", 1, NULL, 7},
> +		{"retries", 1, NULL, 8},
>  		{NULL, 0, NULL, 0}	/* Required at the end of the array */
>  	};
>  
> @@ -983,6 +989,11 @@ int main(int argc, char *argv[])
>  			opt.sm_sl = (uint8_t) temp;
>  			printf(" SMSL = %d\n", opt.sm_sl);
>  			break;
> +		case 8:
> +			opt.transaction_retries = strtol(optarg, NULL, 0);

Please use strtoul().

> +			printf(" Transaction retries = %u\n",
> +			       opt.transaction_retries);
> +			break;
>  		case 'h':
>  		case '?':
>  		case ':':
> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
> index 1f2b067..52668ca 100644
> --- a/opensm/opensm/osm_opensm.c
> +++ b/opensm/opensm/osm_opensm.c
> @@ -2,6 +2,7 @@
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -392,8 +393,7 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
>  	if (status != IB_SUCCESS)
>  		goto Exit;
>  
> -	p_osm->p_vendor =
> -	    osm_vendor_new(&p_osm->log, p_opt->transaction_timeout);
> +	p_osm->p_vendor = osm_vendor_new(&p_osm->log, -1);

Why to not make p_opt->transaction_timeout as default for newly
allocated vendor object?

Sasha

>  	if (p_osm->p_vendor == NULL) {
>  		status = IB_INSUFFICIENT_RESOURCES;
>  		goto Exit;
> diff --git a/opensm/opensm/osm_perfmgr.c b/opensm/opensm/osm_perfmgr.c
> index f95610e..f0ec92d 100644
> --- a/opensm/opensm/osm_perfmgr.c
> +++ b/opensm/opensm/osm_perfmgr.c
> @@ -264,6 +264,8 @@ ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, ib_net64_t port_guid)
>  	bind_info.is_trap_processor = FALSE;
>  	bind_info.recv_q_size = OSM_PM_DEFAULT_QP1_RCV_SIZE;
>  	bind_info.send_q_size = OSM_PM_DEFAULT_QP1_SEND_SIZE;
> +	bind_info.timeout = pm->subn->opt.transaction_timeout;
> +	bind_info.retries = pm->subn->opt.transaction_retries;
>  
>  	OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>  		"Binding to port GUID 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
> diff --git a/opensm/opensm/osm_sa_mad_ctrl.c b/opensm/opensm/osm_sa_mad_ctrl.c
> index f22411b..04b6693 100644
> --- a/opensm/opensm/osm_sa_mad_ctrl.c
> +++ b/opensm/opensm/osm_sa_mad_ctrl.c
> @@ -2,6 +2,7 @@
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -528,6 +529,8 @@ ib_api_status_t osm_sa_mad_ctrl_bind(IN osm_sa_mad_ctrl_t * p_ctrl,
>  	bind_info.port_guid = port_guid;
>  	bind_info.recv_q_size = OSM_SM_DEFAULT_QP1_RCV_SIZE;
>  	bind_info.send_q_size = OSM_SM_DEFAULT_QP1_SEND_SIZE;
> +	bind_info.timeout = p_ctrl->sa->p_subn->opt.transaction_timeout;
> +	bind_info.retries = p_ctrl->sa->p_subn->opt.transaction_retries;
>  
>  	OSM_LOG(p_ctrl->p_log, OSM_LOG_VERBOSE,
>  		"Binding to port GUID 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
> diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
> index f96aff4..c51c158 100644
> --- a/opensm/opensm/osm_sm_mad_ctrl.c
> +++ b/opensm/opensm/osm_sm_mad_ctrl.c
> @@ -885,6 +885,8 @@ ib_api_status_t osm_sm_mad_ctrl_bind(IN osm_sm_mad_ctrl_t * p_ctrl,
>  	bind_info.port_guid = port_guid;
>  	bind_info.recv_q_size = OSM_SM_DEFAULT_QP0_RCV_SIZE;
>  	bind_info.send_q_size = OSM_SM_DEFAULT_QP0_SEND_SIZE;
> +	bind_info.timeout = p_ctrl->p_subn->opt.transaction_timeout;
> +	bind_info.retries = p_ctrl->p_subn->opt.transaction_retries;
>  
>  	OSM_LOG(p_ctrl->p_log, OSM_LOG_VERBOSE,
>  		"Binding to port 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index 8976b5f..a9a7981 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -4,6 +4,7 @@
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
>   * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -299,6 +300,7 @@ static const opt_rec_t opt_tbl[] = {
>  	{ "console", OPT_OFFSET(console), opts_parse_charp, NULL, 0 },
>  	{ "console_port", OPT_OFFSET(console_port), opts_parse_uint16, NULL, 0 },
>  	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 1 },
> +	{ "transaction_retries", OPT_OFFSET(transaction_retries), opts_parse_uint32, NULL, 1 },
>  	{ "max_msg_fifo_timeout", OPT_OFFSET(max_msg_fifo_timeout), opts_parse_uint32, NULL, 1 },
>  	{ "sm_priority", OPT_OFFSET(sm_priority), opts_parse_uint8, opts_setup_sm_priority, 1 },
>  	{ "lmc", OPT_OFFSET(lmc), opts_parse_uint8, NULL, 1 },
> @@ -694,6 +696,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	p_opt->console = strdup(OSM_DEFAULT_CONSOLE);
>  	p_opt->console_port = OSM_DEFAULT_CONSOLE_PORT;
>  	p_opt->transaction_timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
> +	p_opt->transaction_retries = OSM_DEFAULT_RETRY_COUNT;
>  	/* by default we will consider waiting for 50x transaction timeout normal */
>  	p_opt->max_msg_fifo_timeout = 50 * OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
>  	p_opt->sm_priority = OSM_DEFAULT_SM_PRIORITY;
> @@ -1500,6 +1503,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		"max_wire_smps %u\n\n"
>  		"# The maximum time in [msec] allowed for a transaction to complete\n"
>  		"transaction_timeout %u\n\n"
> +		" The maximum number of retries allowed for a transaction to complete\n"
> +		"transaction_retries %u\n\n"
>  		"# Maximal time in [msec] a message can stay in the incoming message queue.\n"
>  		"# If there is more than one message in the queue and the last message\n"
>  		"# stayed in the queue more than this value, any SA request will be\n"
> @@ -1509,6 +1514,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		"single_thread %s\n\n",
>  		p_opts->max_wire_smps,
>  		p_opts->transaction_timeout,
> +		p_opts->transaction_retries,
>  		p_opts->max_msg_fifo_timeout,
>  		p_opts->single_thread ? "TRUE" : "FALSE");
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
