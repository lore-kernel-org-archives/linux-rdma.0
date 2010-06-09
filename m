From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Add a rate based mechanism for SMP
 transactions
Date: Wed, 9 Jun 2010 09:05:15 +0300
Message-ID: <20100609060515.GL28549@me>
References: <20100607124057.GA2060@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100607124057.GA2060-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 08:40 Mon 07 Jun     , Hal Rosenstock wrote:
> 
> In order to better handle non responsive SMAs (when link is physically up
> but the SMA does not respond), a rate based mechanism for SMPs is added
> to better enable forward progress in a more timely fashion. So rather than
> wait for timeouts and outstanding wire SMPs to drop below some configured
> value, there is also a periodic rate for transaction based SMPs. These
> rate based SMPs are capped at a configured maximum value.
> 
> Two new options are added for this:
> rate_based_smp_usecs indicates the number of microseconds between rate
> based SMPs.
> max_rate_based_smps indicates the maximum number of rate based SMPs
> supported. When this limit is reached, rate based SMPs are no longer
> sent (until the number of outstanding ones drops below this limit).
> 
> The rate based SMP mechanism can be disabled by setting rate_based_smp_usecs
> to 0. This is equivalent to the (current) algorithm prior to this change.
> 
> By default, this mechanism is disabled.

I would strongly suggest to rework the terminology here to make things
clearer.

Actually we don't have here any "rate based" SMPs, but instead two mad
injection limits (regular and timedout) and timeout value (which BTW
likely should be a function of --timeout parameter). Isn't it?

Sasha

> 
> Also, the maximum max_wire_smps is reduced to 0x3FFFFFFF from 0x7FFFFFFF so
> the sum of max_wire_smps and max_rate_based_smps does not wrap.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes from v1:
> Algorithm change is isolated to vl15_poller rather than involving
> the vendor layer.
> 
> diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
> index e0d6c66..16241ec 100644
> --- a/opensm/include/opensm/osm_base.h
> +++ b/opensm/include/opensm/osm_base.h
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
>   *
> @@ -440,6 +440,30 @@ BEGIN_C_DECLS
>  */
>  #define OSM_DEFAULT_SMP_MAX_ON_WIRE 4
>  /***********/
> +/****d* OpenSM: Base/OSM_DEFAULT_SMP_RATE_MAX
> +* NAME
> +*	OSM_DEFAULT_SMP_RATE_MAX
> +*
> +* DESCRIPTION
> +*	Specifies the default maximum number of outstanding rate based SMPs.
> +*
> +* SYNOPSIS
> +*/
> +#define OSM_DEFAULT_SMP_RATE_MAX 100
> +/***********/
> +/****d* OpenSM: Base/OSM_DEFAULT_SMP_RATE
> +* NAME
> +*	OSM_DEFAULT_SMP_RATE
> +*
> +* DESCRIPTION
> +*	Specifies the default rate (in usec) for rate based SMPs.
> +*	The default rate is 0. A value of 0 (or EVENT_NO_TIMEOUT)
> +*	disables the rate based SMP mechanism.
> +*
> +* SYNOPSIS
> +*/
> +#define OSM_DEFAULT_SMP_RATE 0
> +/***********/
>  /****d* OpenSM: Base/OSM_SM_DEFAULT_QP0_RCV_SIZE
>  * NAME
>  *	OSM_SM_DEFAULT_QP0_RCV_SIZE
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
> index 4e8c862..49acf2d 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
>   * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
> @@ -149,6 +149,8 @@ typedef struct osm_subn_opt {
>  	ib_net16_t m_key_lease_period;
>  	uint32_t sweep_interval;
>  	uint32_t max_wire_smps;
> +	uint32_t max_rate_based_smps;
> +	uint32_t rate_based_smp_usecs;
>  	uint32_t transaction_timeout;
>  	uint32_t transaction_retries;
>  	uint8_t sm_priority;
> @@ -264,6 +266,14 @@ typedef struct osm_subn_opt {
>  *	max_wire_smps
>  *		The maximum number of SMPs sent in parallel.  Default is 4.
>  *
> +*	max_rate_based_smps
> +*		The maximum number of rate based SMPs allowed to be outstanding.
> +*		Default is 1000.
> +*
> +*	rate_based_smp_usecs
> +*		The wait time in usec for rate based SMPs.  Default is 0
> +*		(disabled). 
> +*
>  *	transaction_timeout
>  *		The maximum time in milliseconds allowed for a transaction
>  *		to complete.  Default is 200.
> diff --git a/opensm/include/opensm/osm_vl15intf.h b/opensm/include/opensm/osm_vl15intf.h
> index 15ed56c..887733f 100644
> --- a/opensm/include/opensm/osm_vl15intf.h
> +++ b/opensm/include/opensm/osm_vl15intf.h
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -117,6 +117,8 @@ typedef struct osm_vl15 {
>  	osm_thread_state_t thread_state;
>  	osm_vl15_state_t state;
>  	uint32_t max_wire_smps;
> +	uint32_t max_rate_based_smps;
> +	uint32_t rate_based_smp_usecs;
>  	cl_event_t signal;
>  	cl_thread_t poller;
>  	cl_qlist_t rfifo;
> @@ -137,6 +139,12 @@ typedef struct osm_vl15 {
>  *	max_wire_smps
>  *		Maximum number of VL15 MADs allowed on the wire at one time.
>  *
> +*	max_rate_based_smps
> +*		Maximum number of rate based SMPs allowed to be outstanding.
> +*
> +*	rate_based_smp_usecs
> +*		Wait time in usec for rate based SMPs.
> +*
>  *	signal
>  *		Event on which the poller sleeps.
>  *
> @@ -243,7 +251,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl15, IN struct osm_mad_pool *p_pool);
>  */
>  ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
>  			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
> -			      IN int32_t max_wire_smps);
> +			      IN int32_t max_wire_smps,
> +			      IN int32_t max_rate_based_smps,
> +			      IN uint32_t rate_based_smp_usecs);
>  /*
>  * PARAMETERS
>  *	p_vl15
> @@ -261,6 +271,14 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
>  *	max_wire_smps
>  *		[in] Maximum number of MADs allowed on the wire at one time.
>  *
> +*	max_rate_based_smps
> +*		[in] Maximum number of rate based SMPs allowed to be
> +*		     outstanding.
> +*
> +*	rate_based_smp_usecs
> +*		[in] Wait time in usec for rate based SMPs.
> +*
> +*
>  * RETURN VALUES
>  *	IB_SUCCESS if the VL15 object was initialized successfully.
>  *
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index 0093aa7..83b94b0 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
> @@ -743,8 +743,8 @@ int main(int argc, char *argv[])
>  		case 'n':
>  			opt.max_wire_smps = strtoul(optarg, NULL, 0);
>  			if (opt.max_wire_smps == 0 ||
> -			    opt.max_wire_smps > 0x7FFFFFFF)
> -				opt.max_wire_smps = 0x7FFFFFFF;
> +			    opt.max_wire_smps > 0x3FFFFFFF)
> +				opt.max_wire_smps = 0x3FFFFFFF;
>  			printf(" Max wire smp's = %d\n", opt.max_wire_smps);
>  			break;
>  
> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
> index d0f39da..bf2014f 100644
> --- a/opensm/opensm/osm_opensm.c
> +++ b/opensm/opensm/osm_opensm.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -392,7 +392,9 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
>  
>  	status = osm_vl15_init(&p_osm->vl15, p_osm->p_vendor,
>  			       &p_osm->log, &p_osm->stats,
> -			       p_opt->max_wire_smps);
> +			       p_opt->max_wire_smps,
> +			       p_opt->max_rate_based_smps,
> +			       p_opt->rate_based_smp_usecs);
>  	if (status != IB_SUCCESS)
>  		goto Exit;
>  
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index ba2c812..6aaf6dc 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
>   * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
> @@ -297,6 +297,8 @@ static const opt_rec_t opt_tbl[] = {
>  	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_parse_net16, NULL, 1 },
>  	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_parse_uint32, NULL, 1 },
>  	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
> +	{ "max_rate_based_smps", OPT_OFFSET(max_rate_based_smps), opts_parse_uint32, NULL, 1 },
> +	{ "rate_based_smp_usecs", OPT_OFFSET(rate_based_smp_usecs), opts_parse_uint32, NULL, 1 },
>  	{ "console", OPT_OFFSET(console), opts_parse_charp, NULL, 0 },
>  	{ "console_port", OPT_OFFSET(console_port), opts_parse_uint16, NULL, 0 },
>  	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 0 },
> @@ -670,6 +672,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	p_opt->m_key_lease_period = 0;
>  	p_opt->sweep_interval = OSM_DEFAULT_SWEEP_INTERVAL_SECS;
>  	p_opt->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
> +	p_opt->max_rate_based_smps = OSM_DEFAULT_SMP_RATE_MAX;
> +	p_opt->rate_based_smp_usecs = OSM_DEFAULT_SMP_RATE;
>  	p_opt->console = strdup(OSM_DEFAULT_CONSOLE);
>  	p_opt->console_port = OSM_DEFAULT_CONSOLE_PORT;
>  	p_opt->transaction_timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
> @@ -1066,14 +1070,22 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
>  	}
>  
>  	if (p_opts->max_wire_smps == 0)
> -		p_opts->max_wire_smps = 0x7FFFFFFF;
> -	else if (p_opts->max_wire_smps > 0x7FFFFFFF) {
> +		p_opts->max_wire_smps = 0x3FFFFFFF;
> +	else if (p_opts->max_wire_smps > 0x3FFFFFFF) {
>  		log_report(" Invalid Cached Option Value: max_wire_smps = %u,"
>  			   " Using Default: %u\n",
>  			   p_opts->max_wire_smps, OSM_DEFAULT_SMP_MAX_ON_WIRE);
>  		p_opts->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
>  	}
>  
> +	if (p_opts->max_rate_based_smps > 0x3FFFFFFF) {
> +		log_report(" Invalid Cached Option Value:"
> +			   " max_rate_based_smps = %u, Using Default: %u",
> +			   p_opts->max_rate_based_smps,
> +			   OSM_DEFAULT_SMP_RATE_MAX);
> +		p_opts->max_rate_based_smps = OSM_DEFAULT_SMP_RATE_MAX;
> +	}
> +
>  	if (strcmp(p_opts->console, OSM_DISABLE_CONSOLE)
>  	    && strcmp(p_opts->console, OSM_LOCAL_CONSOLE)
>  #ifdef ENABLE_OSM_CONSOLE_SOCKET
> @@ -1482,6 +1494,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		"#\n# TIMING AND THREADING OPTIONS\n#\n"
>  		"# Maximum number of SMPs sent in parallel\n"
>  		"max_wire_smps %u\n\n"
> +		"# Maximum number of rate based SMPs allowed to be outstanding\n"
> +		"max_rate_based_smps %u\n\n"
> +		"# The rate in [usec] at which rate based SMPs are sent\n"
> +		"# A value of 0 disables the rate based SMP mechanism\n"
> +		"rate_based_smp_usecs %u\n\n"
>  		"# The maximum time in [msec] allowed for a transaction to complete\n"
>  		"transaction_timeout %u\n\n"
>  		"# The maximum number of retries allowed for a transaction to complete\n"
> @@ -1494,6 +1511,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		"# Use a single thread for handling SA queries\n"
>  		"single_thread %s\n\n",
>  		p_opts->max_wire_smps,
> +		p_opts->max_rate_based_smps,
> +		p_opts->rate_based_smp_usecs,
>  		p_opts->transaction_timeout,
>  		p_opts->transaction_retries,
>  		p_opts->max_msg_fifo_timeout,
> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
> index ff9e4db..fdcca44 100644
> --- a/opensm/opensm/osm_vl15intf.c
> +++ b/opensm/opensm/osm_vl15intf.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2006,2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -113,6 +113,8 @@ static void vl15_poller(IN void *p_ptr)
>  	osm_madw_t *p_madw;
>  	osm_vl15_t *p_vl = p_ptr;
>  	cl_qlist_t *p_fifo;
> +	int32_t max_smps = p_vl->max_wire_smps;
> +	int32_t max_smps2 = p_vl->max_wire_smps + p_vl->max_rate_based_smps;
>  
>  	OSM_LOG_ENTER(p_vl->p_log);
>  
> @@ -155,17 +157,22 @@ static void vl15_poller(IN void *p_ptr)
>  			status = cl_event_wait_on(&p_vl->signal,
>  						  EVENT_NO_TIMEOUT, TRUE);
>  
> -		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >=
> -		       (int32_t) p_vl->max_wire_smps &&
> +		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >= max_smps &&
>  		       p_vl->thread_state == OSM_THREAD_STATE_RUN) {
>  			status = cl_event_wait_on(&p_vl->signal,
> -						  EVENT_NO_TIMEOUT, TRUE);
> -			if (status != CL_SUCCESS) {
> +						  p_vl->rate_based_smp_usecs,
> +						  TRUE);
> +			if (status == CL_TIMEOUT) {
> +				if (max_smps < max_smps2)
> +					max_smps++;
> +				break;
> +			} else if (status != CL_SUCCESS) {
>  				OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E02: "
>  					"Event wait failed (%s)\n",
>  					CL_STATUS_MSG(status));
>  				break;
>  			}
> +			max_smps = p_vl->max_wire_smps;
>  		}
>  	}
>  
> @@ -236,7 +243,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN struct osm_mad_pool *p_pool)
>  
>  ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
>  			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
> -			      IN int32_t max_wire_smps)
> +			      IN int32_t max_wire_smps,
> +			      IN int32_t max_rate_based_smps,
> +			      IN uint32_t rate_based_smp_usecs)
>  {
>  	ib_api_status_t status = IB_SUCCESS;
>  
> @@ -246,6 +255,10 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
>  	p_vl->p_log = p_log;
>  	p_vl->p_stats = p_stats;
>  	p_vl->max_wire_smps = max_wire_smps;
> +	p_vl->max_rate_based_smps = rate_based_smp_usecs && max_rate_based_smps ?
> +				    max_rate_based_smps : 0;
> +	p_vl->rate_based_smp_usecs = rate_based_smp_usecs && max_rate_based_smps ?
> +				     rate_based_smp_usecs : EVENT_NO_TIMEOUT;
>  
>  	status = cl_event_init(&p_vl->signal, FALSE);
>  	if (status != IB_SUCCESS)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
