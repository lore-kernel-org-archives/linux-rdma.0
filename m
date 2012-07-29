From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add initial congestion control configuration
 support
Date: Sun, 29 Jul 2012 19:58:06 +0300
Message-ID: <20120729165806.GG5195@calypso>
References: <1343174826.18615.225.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1343174826.18615.225.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Albert,

First of all I want to include "experimental" label next to CC enable/disable
flag in opensm.conf and in the man page.
Second, for consiteny issues cckey parameter should be cc_key and
--congestion-control option should be --congestion_control

Here is the list that should be added to Congestion Control in the future:
1. Keep track of the devices that don't support CC and not configure them.
   CC is optional feature and we can know if the device doesn't support CC
   only if it doesn't answer to some CC mads. I suggest keep some error
   threshold per port and remove ports that exceed that threshold from CC
   config/query loop.
2. Add CC outstanding_mads/outstanding_mads_on_wire counters to the console.
3. Add ESP0 CC support.
4. Add SwitchPortCongestionSetting  support.
5. Use SL that might be configured by the routing engine for CC mads.

-- Alex

On 17:07 Tue 24 Jul     , Albert Chu wrote:
> This patch adds initial support for congestion control configuration
> on a fabric.  Users may configure settings via the Switch Congestion
> Setting, CA Congestion Setting, or Congest Control Table MADs.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/iba/ib_types.h                  |   14 +-
>  include/opensm/osm_congestion_control.h |  132 ++++++
>  include/opensm/osm_madw.h               |   40 ++
>  include/opensm/osm_msgdef.h             |    1 +
>  include/opensm/osm_opensm.h             |    2 +
>  include/opensm/osm_port.h               |   18 +
>  include/opensm/osm_subnet.h             |  158 +++++++
>  man/opensm.8.in                         |   11 +
>  opensm/Makefile.am                      |    4 +-
>  opensm/main.c                           |   16 +
>  opensm/osm_congestion_control.c         |  741 +++++++++++++++++++++++++++++++
>  opensm/osm_opensm.c                     |   13 +
>  opensm/osm_state_mgr.c                  |   13 +
>  opensm/osm_subnet.c                     |  471 ++++++++++++++++++++
>  14 files changed, 1628 insertions(+), 6 deletions(-)
>  create mode 100644 include/opensm/osm_congestion_control.h
>  create mode 100644 opensm/osm_congestion_control.c
> 
> diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
> index d28de17..7639911 100644
> --- a/include/iba/ib_types.h
> +++ b/include/iba/ib_types.h
> @@ -11470,11 +11470,12 @@ typedef struct _ib_cong_log {
>  *
>  * SYNOPSIS
>  */
> +#define IB_CC_PORT_MASK_DATA_SIZE 32
>  #include <complib/cl_packon.h>
>  typedef struct _ib_sw_cong_setting {
>  	ib_net32_t control_map;
> -	uint8_t victim_mask[32];
> -	uint8_t credit_mask[32];
> +	uint8_t victim_mask[IB_CC_PORT_MASK_DATA_SIZE];
> +	uint8_t credit_mask[IB_CC_PORT_MASK_DATA_SIZE];
>  	uint8_t threshold_resv;
>  	uint8_t packet_size;
>  	ib_net16_t cs_threshold_resv;
> @@ -11584,7 +11585,8 @@ typedef struct _ib_sw_port_cong_setting_element {
>  *
>  * SOURCE
>  */
> -typedef ib_sw_port_cong_setting_element_t ib_sw_port_cong_setting_block_t[32];
> +#define IB_CC_SW_PORT_SETTING_ELEMENTS 32
> +typedef ib_sw_port_cong_setting_element_t ib_sw_port_cong_setting_block_t[IB_CC_SW_PORT_SETTING_ELEMENTS];
>  /**********/
>  
>  /****s* IBA Base: Types/ib_sw_port_cong_setting_t
> @@ -11662,11 +11664,12 @@ typedef struct _ib_ca_cong_entry {
>  *
>  * SYNOPSIS
>  */
> +#define IB_CA_CONG_ENTRY_DATA_SIZE 16
>  #include <complib/cl_packon.h>
>  typedef struct _ib_ca_cong_setting {
>  	ib_net16_t port_control;
>  	ib_net16_t control_map;
> -	ib_ca_cong_entry_t entry_list[16];
> +	ib_ca_cong_entry_t entry_list[IB_CA_CONG_ENTRY_DATA_SIZE];
>  } PACK_SUFFIX ib_ca_cong_setting_t;
>  #include <complib/cl_packoff.h>
>  /*
> @@ -11725,11 +11728,12 @@ typedef struct _ib_cc_tbl_entry {
>  *
>  * SYNOPSIS
>  */
> +#define IB_CC_TBL_ENTRY_LIST_MAX 64
>  #include <complib/cl_packon.h>
>  typedef struct _ib_cc_tbl {
>  	ib_net16_t ccti_limit;
>  	ib_net16_t resv;
> -	ib_cc_tbl_entry_t entry_list[64];
> +	ib_cc_tbl_entry_t entry_list[IB_CC_TBL_ENTRY_LIST_MAX];
>  } PACK_SUFFIX ib_cc_tbl_t;
>  #include <complib/cl_packoff.h>
>  /*
> diff --git a/include/opensm/osm_congestion_control.h b/include/opensm/osm_congestion_control.h
> new file mode 100644
> index 0000000..94e4ffb
> --- /dev/null
> +++ b/include/opensm/osm_congestion_control.h
> @@ -0,0 +1,132 @@
> +/*
> + * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2012 Lawrence Livermore National Lab.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +/*
> + * Abstract:
> + *    OSM Congestion Control types and prototypes
> + *
> + * Author:
> + *    Albert Chu, LLNL
> + */
> +
> +#ifndef OSM_CONGESTION_CONTROL_H
> +#define OSM_CONGESTION_CONTROL_H
> +
> +#include <iba/ib_types.h>
> +#include <complib/cl_types_osd.h>
> +#include <complib/cl_dispatcher.h>
> +#include <opensm/osm_subnet.h>
> +#include <opensm/osm_log.h>
> +#include <opensm/osm_sm.h>
> +#include <opensm/osm_opensm.h>
> +#include <opensm/osm_base.h>
> +
> +/****s* OpenSM: Base/OSM_DEFAULT_CC_KEY
> + * NAME
> + *       OSM_DEFAULT_CC_KEY
> + *
> + * DESCRIPTION
> + *       Congestion Control Key used by OpenSM.
> + *
> + * SYNOPSIS
> + */
> +#define OSM_DEFAULT_CC_KEY 0
> +
> +#define OSM_CC_DEFAULT_MAX_OUTSTANDING_QUERIES 500
> +
> +/****s* OpenSM: CongestionControl/osm_congestion_control_t
> +*  This object should be treated as opaque and should
> +*  be manipulated only through the provided functions.
> +*/
> +typedef struct osm_congestion_control {
> +	struct osm_opensm *osm;
> +	osm_subn_t *subn;
> +	osm_sm_t *sm;
> +	osm_log_t *log;
> +	osm_mad_pool_t *mad_pool;
> +	atomic32_t trans_id;
> +	osm_vendor_t *vendor;
> +	osm_bind_handle_t bind_handle;
> +	cl_disp_reg_handle_t cc_disp_h;
> +	ib_net64_t port_guid;
> +	atomic32_t outstanding_mads;
> +	atomic32_t outstanding_mads_on_wire;
> +	cl_qlist_t mad_queue;
> +	cl_spinlock_t mad_queue_lock;
> +	cl_event_t cc_poller_wakeup;
> +	cl_event_t outstanding_mads_done_event;
> +	cl_event_t sig_mads_on_wire_continue;
> +	cl_thread_t cc_poller;
> +	osm_thread_state_t thread_state;
> +	ib_sw_cong_setting_t sw_cong_setting;
> +	ib_ca_cong_setting_t ca_cong_setting;
> +	ib_cc_tbl_t cc_tbl[OSM_CCT_ENTRY_MAD_BLOCKS];
> +	unsigned int cc_tbl_mads;
> +} osm_congestion_control_t;
> +/*
> +* FIELDS
> +*       subn
> +*             Subnet object for this subnet.
> +*
> +*       log
> +*             Pointer to the log object.
> +*
> +*       mad_pool
> +*             Pointer to the MAD pool.
> +*
> +*       mad_ctrl
> +*             Mad Controller
> +*********/
> +
> +struct osm_opensm;
> +
> +int osm_congestion_control_setup(struct osm_opensm *osm);
> +
> +int osm_congestion_control_wait_pending_transactions(struct osm_opensm *osm);
> +
> +ib_api_status_t osm_congestion_control_init(osm_congestion_control_t * p_cc,
> +					    struct osm_opensm *osm,
> +					    const osm_subn_opt_t * p_opt);
> +
> +ib_api_status_t osm_congestion_control_bind(osm_congestion_control_t * p_cc,
> +					    ib_net64_t port_guid);
> +
> +void osm_congestion_control_shutdown(osm_congestion_control_t * p_cc);
> +
> +void osm_congestion_control_destroy(osm_congestion_control_t * p_cc);
> +
> +
> +#endif				/* ifndef OSM_CONGESTION_CONTROL_H */
> diff --git a/include/opensm/osm_madw.h b/include/opensm/osm_madw.h
> index 8f53d54..0204f9b 100644
> --- a/include/opensm/osm_madw.h
> +++ b/include/opensm/osm_madw.h
> @@ -340,6 +340,19 @@ typedef struct osm_perfmgr_context {
>  } osm_perfmgr_context_t;
>  /*********/
>  
> +/****s* OpenSM: MAD Wrapper/osm_cc_context_t
> +* DESCRIPTION
> +*	Context for Congestion Control MADs
> +*/
> +typedef struct osm_cc_context {
> +	ib_net64_t node_guid;
> +	ib_net64_t port_guid;
> +	uint8_t port;
> +	uint8_t mad_method;	/* was this a get or a set */
> +	ib_net32_t attr_mod;
> +} osm_cc_context_t;
> +/*********/
> +
>  #ifndef OSM_VENDOR_INTF_OPENIB
>  /****s* OpenSM: MAD Wrapper/osm_arbitrary_context_t
>  * NAME
> @@ -379,6 +392,7 @@ typedef union _osm_madw_context {
>  	osm_pkey_context_t pkey_context;
>  	osm_vla_context_t vla_context;
>  	osm_perfmgr_context_t perfmgr_context;
> +	osm_cc_context_t cc_context;
>  #ifndef OSM_VENDOR_INTF_OPENIB
>  	osm_arbitrary_context_t arb_context;
>  #endif
> @@ -612,6 +626,32 @@ static inline ib_perfmgt_mad_t *osm_madw_get_perfmgt_mad_ptr(IN const osm_madw_t
>  *	MAD Wrapper object
>  *********/
>  
> +/****f* OpenSM: MAD Wrapper/osm_madw_get_cc_mad_ptr
> +* DESCRIPTION
> +*	Gets a pointer to the Congestion Control MAD in this MAD wrapper.
> +*
> +* SYNOPSIS
> +*/
> +static inline ib_cc_mad_t *osm_madw_get_cc_mad_ptr(IN const osm_madw_t
> +						   * p_madw)
> +{
> +	return ((ib_cc_mad_t *) p_madw->p_mad);
> +}
> +
> +/*
> +* PARAMETERS
> +*	p_madw
> +*		[in] Pointer to an osm_madw_t object.
> +*
> +* RETURN VALUES
> +*	Pointer to the start of the Congestion Control MAD.
> +*
> +* NOTES
> +*
> +* SEE ALSO
> +*	MAD Wrapper object
> +*********/
> +
>  /****f* OpenSM: MAD Wrapper/osm_madw_get_ni_context_ptr
>  * NAME
>  *	osm_madw_get_ni_context_ptr
> diff --git a/include/opensm/osm_msgdef.h b/include/opensm/osm_msgdef.h
> index 0c8af9b..b0d92e0 100644
> --- a/include/opensm/osm_msgdef.h
> +++ b/include/opensm/osm_msgdef.h
> @@ -162,6 +162,7 @@ enum {
>  #endif
>  	OSM_MSG_MAD_PORT_COUNTERS,
>  	OSM_MSG_MAD_MLNX_EXT_PORT_INFO,
> +	OSM_MSG_MAD_CC,
>  	OSM_MSG_MAX
>  };
>  
> diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
> index 9f2c2fa..dbff4f6 100644
> --- a/include/opensm/osm_opensm.h
> +++ b/include/opensm/osm_opensm.h
> @@ -61,6 +61,7 @@
>  #include <opensm/osm_subnet.h>
>  #include <opensm/osm_mad_pool.h>
>  #include <opensm/osm_vl15intf.h>
> +#include <opensm/osm_congestion_control.h>
>  
>  #ifdef __cplusplus
>  #  define BEGIN_C_DECLS extern "C" {
> @@ -203,6 +204,7 @@ typedef struct osm_opensm {
>  #ifdef ENABLE_OSM_PERF_MGR
>  	osm_perfmgr_t perfmgr;
>  #endif				/* ENABLE_OSM_PERF_MGR */
> +	osm_congestion_control_t cc;
>  	cl_qlist_t plugin_list;
>  	osm_db_t db;
>  	osm_mad_pool_t mad_pool;
> diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
> index 56e9c37..e06483a 100644
> --- a/include/opensm/osm_port.h
> +++ b/include/opensm/osm_port.h
> @@ -119,6 +119,15 @@ typedef struct osm_physp {
>  	ib_vl_arb_table_t vl_arb[4];
>  	cl_ptr_vector_t slvl_by_port;
>  	uint8_t hop_wf;
> +	union {
> +		struct {
> +			ib_sw_cong_setting_t sw_cong_setting;
> +		} sw;
> +		struct {
> +			ib_ca_cong_setting_t ca_cong_setting;
> +			ib_cc_tbl_t cc_tbl[OSM_CCT_ENTRY_MAD_BLOCKS];
> +		} ca;
> +	} cc;
>  } osm_physp_t;
>  /*
>  * FIELDS
> @@ -186,6 +195,15 @@ typedef struct osm_physp {
>  *	hop_wf
>  *		Hop weighting factor to be used in the routing.
>  *
> +*	sw_cong_setting
> +*		Physical port switch congestion settings (switches only)
> +*
> +*	ca_cong_setting
> +*		Physical port ca congestion settings (cas only)
> +*
> +*	cc_tbl
> +*		Physical port ca congestion control table (cas only)
> +*
>  * SEE ALSO
>  *	Port
>  *********/
> diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
> index 838ca82..60ed7d6 100644
> --- a/include/opensm/osm_subnet.h
> +++ b/include/opensm/osm_subnet.h
> @@ -86,6 +86,10 @@ typedef enum _osm_partition_enforce_type_enum {
>  	OSM_PARTITION_ENFORCE_TYPE_OFF
>  } osm_partition_enforce_type_enum;
>  
> +/* XXX: not actual max, max we're currently going to support */
> +#define OSM_CCT_ENTRY_MAX        128
> +#define OSM_CCT_ENTRY_MAD_BLOCKS (OSM_CCT_ENTRY_MAX/64)
> +
>  struct osm_opensm;
>  struct osm_qos_policy;
>  
> @@ -147,6 +151,91 @@ typedef struct osm_qos_options {
>  *
>  *********/
>  
> +/****s* OpenSM: Subnet/osm_cct_entry_t
> +* NAME
> +*	osm_cct_entry_t
> +*
> +* DESCRIPTION
> +*	Subnet Congestion Control Table entry.  See A10.2.2.1.1 for format details.
> +*
> +* SYNOPSIS
> +*/
> +typedef struct osm_cct_entry {
> +	uint8_t shift; //Alex: shift 2 bits
> +	uint16_t multiplier; //Alex multiplier 14 bits
> +} osm_cct_entry_t;
> +/*
> +* FIELDS
> +*
> +*	shift
> +*		shift field in CCT entry.  See A10.2.2.1.1.
> +*
> +*	multiplier
> +*		multiplier field in CCT entry.  See A10.2.2.1.1.
> +*
> +*********/
> +
> +/****s* OpenSM: Subnet/osm_cacongestion_entry_t
> +* NAME
> +*	osm_cacongestion_entry_t
> +*
> +* DESCRIPTION
> +*	Subnet CA Congestion entry.  See A10.4.3.8.4 for format details.
> +*
> +* SYNOPSIS
> +*/
> +typedef struct osm_cacongestion_entry {
> +	ib_net16_t ccti_timer; //Alex: ccti_timer and ccti_increase should be replaced
> +	uint8_t ccti_increase;
> +	uint8_t trigger_threshold;
> +	uint8_t ccti_min;
> +} osm_cacongestion_entry_t;
> +/*
> +* FIELDS
> +*
> +*	ccti_timer
> +*		CCTI Timer
> +*
> +*	ccti_increase
> +*		CCTI Increase
> +*
> +*	trigger_threshold
> +*		CCTI trigger for log message
> +*
> +*	ccti_min
> +*		CCTI Minimum
> +*
> +*********/
> +
> +/****s* OpenSM: Subnet/osm_cct_t
> +* NAME
> +*	osm_cct_t
> +*
> +* DESCRIPTION
> +*	Subnet CongestionControlTable.  See A10.4.3.9 for format details.
> +*
> +* SYNOPSIS
> +*/
> +typedef struct osm_cct {
> +	osm_cct_entry_t entries[OSM_CCT_ENTRY_MAX];
> +	unsigned int entries_len;
> +	char *input_str;
> +} osm_cct_t;
> +/*
> +* FIELDS
> +*
> +*	entries
> +*		Entries in CCT
> +*
> +*	entries_len
> +*		Length of entries
> +*
> +*	input_str
> +*		Original str input
> +*
> +*********/
> +
> +
>  /****s* OpenSM: Subnet/osm_subn_opt_t
>  * NAME
>  *	osm_subn_opt_t
> @@ -244,6 +333,21 @@ typedef struct osm_subn_opt {
>  	osm_qos_options_t qos_sw0_options;
>  	osm_qos_options_t qos_swe_options;
>  	osm_qos_options_t qos_rtr_options;
> +	boolean_t congestion_control;
> +	ib_net64_t cckey;
> +	uint32_t cc_max_outstanding_mads;
> +	ib_net32_t cc_sw_cong_setting_control_map;
> +	uint8_t cc_sw_cong_setting_victim_mask[IB_CC_PORT_MASK_DATA_SIZE];
> +	uint8_t cc_sw_cong_setting_credit_mask[IB_CC_PORT_MASK_DATA_SIZE];
> +	uint8_t cc_sw_cong_setting_threshold;
> +	uint8_t cc_sw_cong_setting_packet_size;
> +	uint8_t cc_sw_cong_setting_credit_starvation_threshold;
> +	osm_cct_entry_t cc_sw_cong_setting_credit_starvation_return_delay;
> +	ib_net16_t cc_sw_cong_setting_marking_rate;
> +	ib_net16_t cc_ca_cong_setting_port_control;
> +	ib_net16_t cc_ca_cong_setting_control_map;
> +	osm_cacongestion_entry_t cc_ca_cong_entries[IB_CA_CONG_ENTRY_DATA_SIZE];
> +	osm_cct_t cc_cct;
>  	boolean_t enable_quirks;
>  	boolean_t no_clients_rereg;
>  #ifdef ENABLE_OSM_PERF_MGR
> @@ -527,6 +631,60 @@ typedef struct osm_subn_opt {
>  *	qos_rtr_options
>  *		QoS options for router ports
>  *
> +*	congestion_control
> +*		Boolean that specifies whether OpenSM congestion control configuration
> +*		should be off or no.
> +*
> +*	cckey
> +*		CCkey to use when configuring congestion control.
> +*
> +*	cc_max_outstanding_mads
> +*		Max number of outstanding CC mads that can be on the wire.
> +*
> +*	cc_sw_cong_setting_control_map
> +*		Congestion Control Switch Congestion Setting Control Map
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_victim_mask
> +*		Congestion Control Switch Congestion Setting Victim Mask
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_credit_mask
> +*		Congestion Control Switch Congestion Setting Credit Mask
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_threshold
> +*		Congestion Control Switch Congestion Setting Threshold
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_packet_size
> +*		Congestion Control Switch Congestion Setting Packet Size
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_credit_starvation_threshold
> +*		Congestion Control Switch Congestion Setting Credit Staraction Threshold
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_credit_starvation_return_delay
> +*		Congestion Control Switch Congestion Setting Credit Starvation Return Delay
> +*		configuration setting.
> +*
> +*	cc_sw_cong_setting_marking_rate
> +*		Congestion Control Switch Congestion Setting Marking Rate
> +*		configuration setting.
> +*
> +*	cc_ca_cong_setting_port_control
> +*		Congestion Control CA Congestion Setting Port Control
> +*
> +*	cc_ca_cong_setting_control_map
> +*		Congestion Control CA Congestion Setting Control Map
> +
> +*	cc_ca_cong_entries
> +*		Congestion Control CA Congestion Setting Entries
> +*
> +*	cc_cct
> +*		Congestion Control Table array of entries
> +*
>  *	enable_quirks
>  *		Enable high risk new features and not fully qualified
>  *		hardware specific work arounds
> diff --git a/man/opensm.8.in b/man/opensm.8.in
> index 888d6a6..5420837 100644
> --- a/man/opensm.8.in
> +++ b/man/opensm.8.in
> @@ -48,6 +48,8 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
>  [\-Z | \-\-part_enforce [both | in | out | off]]
>  [\-W | \-\-allow_both_pkeys]
>  [\-Q | \-\-qos [\-Y | \-\-qos_policy_file <file name>]]
> +[\-\-congestion\-control]
> +[\-\-cckey <key>]
>  [\-y | \-\-stay_on_fatal]
>  [\-B | \-\-daemon]
>  [\-I | \-\-inactive]
> @@ -369,6 +371,15 @@ name is \fB\%@OPENSM_CONFIG_DIR@/@QOS_POLICY_FILE@\fP. See
>  QoS_management_in_OpenSM.txt in opensm doc for more information on
>  configuring QoS policy via this file.
>  .TP
> +\fB\-\-congestion\-control\fR
> +This option enables congestion control configuration.  It is disabled
> +by default.  See config file for congestion control configuration
> +options.
> +\fB\-\-cckey\fR <key>
> +This option configures the CCkey to use when configuring congestion
> +control.  Note that this option does not configure a new CCkey into
> +switches and CAs.  Defaults to 0.
> +.TP
>  \fB\-N\fR, \fB\-\-no_part_enforce\fR \fB(DEPRECATED)\fR
>  This is a deprecated flag. Please use \fB\-\-part_enforce\fR instead.
>  This option disables partition enforcement on switch external ports.
> diff --git a/opensm/Makefile.am b/opensm/Makefile.am
> index 855042c..7fd6bc6 100644
> --- a/opensm/Makefile.am
> +++ b/opensm/Makefile.am
> @@ -57,7 +57,8 @@ opensm_SOURCES = main.c osm_console_io.c osm_console.c osm_db_files.c \
>  		 osm_ucast_dfsssp.c osm_vl15intf.c \
>  		 osm_vl_arb_rcv.c st.c osm_perfmgr.c osm_perfmgr_db.c \
>  		 osm_event_plugin.c osm_dump.c osm_ucast_cache.c \
> -		 osm_qos_parser_y.y osm_qos_parser_l.l osm_qos_policy.c
> +		 osm_qos_parser_y.y osm_qos_parser_l.l osm_qos_policy.c \
> +		 osm_congestion_control.c
>  
>  AM_YFLAGS:= -d
>  
> @@ -102,6 +103,7 @@ opensminclude_HEADERS = \
>  	$(srcdir)/../include/opensm/osm_port_profile.h \
>  	$(srcdir)/../include/opensm/osm_prefix_route.h \
>  	$(srcdir)/../include/opensm/osm_qos_policy.h \
> +	$(srcdir)/../include/opensm/osm_congestion_control.h \
>  	$(srcdir)/../include/opensm/osm_remote_sm.h \
>  	$(srcdir)/../include/opensm/osm_router.h \
>  	$(srcdir)/../include/opensm/osm_sa.h \
> diff --git a/opensm/main.c b/opensm/main.c
> index 4218cc6..eaf25f7 100644
> --- a/opensm/main.c
> +++ b/opensm/main.c
> @@ -340,6 +340,11 @@ static void show_usage(void)
>  	       "          This option defines the optional QoS policy file.\n"
>  	       "          The default name is \'" OSM_DEFAULT_QOS_POLICY_FILE
>  	       "\'.\n\n");
> +	printf("--congestion-control\n"
> +	       "          This option enables congestion control configuration.\n\n");
> +	printf("--cckey <key>\n"
> +	       "          This option configures the CCkey to use when configuring congestion"
> +	       "          control.\n\n");
>  	printf("--stay_on_fatal, -y\n"
>  	       "          This option will cause SM not to exit on fatal initialization\n"
>  	       "          issues: if SM discovers duplicated guids or 12x link with\n"
> @@ -614,6 +619,8 @@ int main(int argc, char *argv[])
>  		{"allow_both_pkeys", 0, NULL, 'W'},
>  		{"qos", 0, NULL, 'Q'},
>  		{"qos_policy_file", 1, NULL, 'Y'},
> +		{"congestion-control", 0, NULL, 128},
> +		{"cckey", 1, NULL, 129},
>  		{"maxsmps", 1, NULL, 'n'},
>  		{"console", 1, NULL, 'q'},
>  		{"V", 0, NULL, 'V'},
> @@ -920,6 +927,15 @@ int main(int argc, char *argv[])
>  			printf(" QoS policy file \'%s\'\n", optarg);
>  			break;
>  
> +		case 128:
> +			opt.congestion_control = TRUE;
> +			break;
> +
> +		case 129:
> +			opt.cckey = strtoull(optarg, NULL, 0);
> +			printf(" CC Key 0x%" PRIx64 "\n", opt.cckey);
> +			break;
> +
>  		case 'y':
>  			opt.exit_on_fatal = FALSE;
>  			printf(" Staying on fatal initialization errors\n");
> diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
> new file mode 100644
> index 0000000..061e8bb
> --- /dev/null
> +++ b/opensm/osm_congestion_control.c
> @@ -0,0 +1,741 @@
> +/*
> + * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
> + * Copyright (c) 2012 Lawrence Livermore National Lab.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +/*
> + * Abstract:
> + *    OSM Congestion Control configuration implementation
> + *
> + * Author:
> + *    Albert Chu, LLNL
> + */
> +
> +#if HAVE_CONFIG_H
> +#  include <config.h>
> +#endif				/* HAVE_CONFIG_H */
> +
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <iba/ib_types.h>
> +#include <complib/cl_debug.h>
> +#include <opensm/osm_subnet.h>
> +#include <opensm/osm_opensm.h>
> +#include <opensm/osm_log.h>
> +#include <opensm/osm_subnet.h>
> +#include <opensm/osm_congestion_control.h>
> +
> +#define CONGESTION_CONTROL_INITIAL_TID_VALUE 0xbabe
> +
> +static void cc_mad_post(osm_congestion_control_t *p_cc,
> +			osm_madw_t *p_madw,
> +			osm_node_t *p_node,
> +			osm_physp_t *p_physp,
> +			ib_net16_t attr_id,
> +			ib_net32_t attr_mod)
> +{
> +	osm_subn_opt_t *p_opt = &p_cc->subn->opt;
> +	ib_cc_mad_t *p_cc_mad;
> +	uint8_t port;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	port = osm_physp_get_port_num(p_physp);
> +
> +	p_cc_mad = osm_madw_get_cc_mad_ptr(p_madw);
> +
> +	p_cc_mad->header.base_ver = 1;
> +	p_cc_mad->header.mgmt_class = IB_MCLASS_CC;
> +	p_cc_mad->header.class_ver = 2;
> +	p_cc_mad->header.method = IB_MAD_METHOD_SET;
> +	p_cc_mad->header.status = 0;
> +	p_cc_mad->header.class_spec = 0;
> +	p_cc_mad->header.trans_id =
> +		cl_hton64((uint64_t) cl_atomic_inc(&p_cc->trans_id));
> +	p_cc_mad->header.attr_id = attr_id;
> +	p_cc_mad->header.resv = 0;
> +	p_cc_mad->header.attr_mod = attr_mod;
> +
> +	p_cc_mad->cc_key = p_opt->cckey;
> +
> +	memset(p_cc_mad->log_data, '\0', IB_CC_LOG_DATA_SIZE);
> +
> +	p_madw->mad_addr.dest_lid = osm_node_get_base_lid(p_node, port);
> +	p_madw->mad_addr.addr_type.gsi.remote_qp = IB_QP1;
> +	p_madw->mad_addr.addr_type.gsi.remote_qkey =
> +		cl_hton32(IB_QP1_WELL_KNOWN_Q_KEY);
> +	p_madw->resp_expected = TRUE;
> +	p_madw->fail_msg = CL_DISP_MSGID_NONE;
> +
> +	p_madw->context.cc_context.node_guid = osm_node_get_node_guid(p_node);
> +	p_madw->context.cc_context.port_guid = osm_physp_get_port_guid(p_physp);
> +	p_madw->context.cc_context.port = port;
> +	p_madw->context.cc_context.mad_method = IB_MAD_METHOD_SET;
> +	p_madw->context.cc_context.attr_mod = attr_mod;
> +
> +	cl_spinlock_acquire(&p_cc->mad_queue_lock);
> +	cl_atomic_inc(&p_cc->outstanding_mads);
> +	cl_qlist_insert_tail(&p_cc->mad_queue, &p_madw->list_item);
> +	cl_spinlock_release(&p_cc->mad_queue_lock);
> +
> +	cl_event_signal(&p_cc->cc_poller_wakeup);
> +
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> +
> +static void cc_setup_mad_data(osm_sm_t * p_sm)
> +{
> +	osm_congestion_control_t *p_cc = &p_sm->p_subn->p_osm->cc;
> +	osm_subn_opt_t *p_opt = &p_sm->p_subn->opt;
> +	uint16_t ccti_limit;
> +	int i;
> +
> +	/* Switch Congestion Setting */
> +	p_cc->sw_cong_setting.control_map = p_opt->cc_sw_cong_setting_control_map;
> +
> +	memcpy(p_cc->sw_cong_setting.victim_mask,
> +	       p_opt->cc_sw_cong_setting_victim_mask,
> +	       IB_CC_PORT_MASK_DATA_SIZE);
> +
> +	memcpy(p_cc->sw_cong_setting.credit_mask,
> +	       p_opt->cc_sw_cong_setting_credit_mask,
> +	       IB_CC_PORT_MASK_DATA_SIZE);
> +
> +	/* threshold is 4 bits, takes up upper nibble of byte */
> +	p_cc->sw_cong_setting.threshold_resv = (p_opt->cc_sw_cong_setting_threshold << 4);
> +
> +	p_cc->sw_cong_setting.packet_size = p_opt->cc_sw_cong_setting_packet_size;
> +
> +	/* cs threshold is 4 bits, takes up upper nibble of short */
> +	p_cc->sw_cong_setting.cs_threshold_resv =
> +		cl_hton16(p_opt->cc_sw_cong_setting_credit_starvation_threshold << 12);
> +
> +	p_cc->sw_cong_setting.cs_return_delay =
> +		cl_hton16(p_opt->cc_sw_cong_setting_credit_starvation_return_delay.shift << 14
> +			  | p_opt->cc_sw_cong_setting_credit_starvation_return_delay.multiplier);
> +
> +	p_cc->sw_cong_setting.marking_rate = p_opt->cc_sw_cong_setting_marking_rate;
> +
> +	/* CA Congestion Setting */
> +	p_cc->ca_cong_setting.port_control = p_opt->cc_ca_cong_setting_port_control;
> +	p_cc->ca_cong_setting.control_map = p_opt->cc_ca_cong_setting_control_map;
> +
> +	for (i = 0; i < IB_CA_CONG_ENTRY_DATA_SIZE; i++) {
> +		ib_ca_cong_entry_t *p_entry;
> +
> +		p_entry = &p_cc->ca_cong_setting.entry_list[i];
> +
> +		p_entry->ccti_timer = p_opt->cc_ca_cong_entries[i].ccti_timer;
> +		p_entry->ccti_increase = p_opt->cc_ca_cong_entries[i].ccti_increase;
> +		p_entry->trigger_threshold = p_opt->cc_ca_cong_entries[i].trigger_threshold;
> +		p_entry->ccti_min = p_opt->cc_ca_cong_entries[i].ccti_min;
> +		p_entry->resv0 = 0;
> +		p_entry->resv1 = 0;
> +	}
> +
> +	/* Congestion Control Table */
> +
> +	/* if no entries, we will always send atleast 1 mad to set ccti_limit = 0 */
> +	if (!p_opt->cc_cct.entries_len)
> +		p_cc->cc_tbl_mads = 1;
> +	else {
> +		p_cc->cc_tbl_mads = p_opt->cc_cct.entries_len - 1;
> +		p_cc->cc_tbl_mads /= IB_CC_TBL_ENTRY_LIST_MAX;
> +		p_cc->cc_tbl_mads += 1;
> +	}
> +
> +	CL_ASSERT(p_cc->cc_tbl_mads <= OSM_CCT_ENTRY_MAD_BLOCKS);
> +
> +	if (!p_opt->cc_cct.entries_len)
> +		ccti_limit = 0;
> +	else
> +		ccti_limit = p_opt->cc_cct.entries_len - 1;
> +
> +	for (i = 0; i < p_cc->cc_tbl_mads; i++) {
> +		int j;
> +
> +		p_cc->cc_tbl[i].ccti_limit = cl_hton16(ccti_limit);
> +		p_cc->cc_tbl[i].resv = 0;
> +
> +		memset(p_cc->cc_tbl[i].entry_list,
> +		       '\0',
> +		       sizeof(p_cc->cc_tbl[i].entry_list));
> +
> +		if (!ccti_limit)
> +			break;
> +
> +		for (j = 0; j < IB_CC_TBL_ENTRY_LIST_MAX; j++) {
> +			int k;
> +
> +			k = (i * IB_CC_TBL_ENTRY_LIST_MAX) + j;
> +			p_cc->cc_tbl[i].entry_list[j].shift_multiplier =
> +				cl_hton16(p_opt->cc_cct.entries[k].shift << 14
> +					  | p_opt->cc_cct.entries[k].multiplier);
> +		}
> +	}
> +}
> +
> +static ib_api_status_t cc_send_sw_cong_setting(osm_sm_t * p_sm,
> +					       osm_node_t *p_node)
> +{
> +	osm_congestion_control_t *p_cc = &p_sm->p_subn->p_osm->cc;
> +	unsigned force_update;
> +	osm_physp_t *p_physp;
> +	osm_madw_t *p_madw = NULL;
> +	ib_cc_mad_t *p_cc_mad = NULL;
> +	ib_sw_cong_setting_t *p_sw_cong_setting = NULL;
> +
> +	OSM_LOG_ENTER(p_sm->p_log);
> +
> +	p_physp = osm_node_get_physp_ptr(p_node, 0);
> +
> +	force_update = p_physp->need_update || p_sm->p_subn->need_update;
> +
> +	if (!force_update
> +	    && !memcmp(&p_cc->sw_cong_setting,
> +		       &p_physp->cc.sw.sw_cong_setting,
> +		       sizeof(p_cc->sw_cong_setting)))
> +		return IB_SUCCESS;
> +
> +	p_madw = osm_mad_pool_get(p_cc->mad_pool, p_cc->bind_handle,
> +				  MAD_BLOCK_SIZE, NULL);
> +	if (p_madw == NULL) {
> +		OSM_LOG(p_sm->p_log, OSM_LOG_ERROR, "ERR C101: "
> +			"failed to allocate mad\n");
> +		return IB_INSUFFICIENT_MEMORY;
> +	}
> +
> +	p_cc_mad = osm_madw_get_cc_mad_ptr(p_madw);
> +
> +	p_sw_cong_setting = ib_cc_mad_get_mgt_data_ptr(p_cc_mad);
> +
> +	memcpy(p_sw_cong_setting,
> +	       &p_cc->sw_cong_setting,
> +	       sizeof(p_cc->sw_cong_setting));
> +
> +	cc_mad_post(p_cc, p_madw, p_node, p_physp,
> +		    IB_MAD_ATTR_SW_CONG_SETTING, 0);
> +
> +	OSM_LOG_EXIT(p_sm->p_log);
> +
> +	return IB_SUCCESS;
> +}
> +
> +static ib_api_status_t cc_send_ca_cong_setting(osm_sm_t * p_sm,
> +					       osm_node_t *p_node,
> +					       osm_physp_t *p_physp)
> +{
> +	osm_congestion_control_t *p_cc = &p_sm->p_subn->p_osm->cc;
> +	unsigned force_update;
> +	osm_madw_t *p_madw = NULL;
> +	ib_cc_mad_t *p_cc_mad = NULL;
> +	ib_ca_cong_setting_t *p_ca_cong_setting = NULL;
> +
> +	OSM_LOG_ENTER(p_sm->p_log);
> +
> +	force_update = p_physp->need_update || p_sm->p_subn->need_update;
> +
> +	if (!force_update
> +	    && !memcmp(&p_cc->ca_cong_setting,
> +		       &p_physp->cc.ca.ca_cong_setting,
> +		       sizeof(p_cc->ca_cong_setting)))
> +		return IB_SUCCESS;
> +
> +	p_madw = osm_mad_pool_get(p_cc->mad_pool, p_cc->bind_handle,
> +				  MAD_BLOCK_SIZE, NULL);
> +	if (p_madw == NULL) {
> +		OSM_LOG(p_sm->p_log, OSM_LOG_ERROR, "ERR C102: "
> +			"failed to allocate mad\n");
> +		return IB_INSUFFICIENT_MEMORY;
> +	}
> +
> +	p_cc_mad = osm_madw_get_cc_mad_ptr(p_madw);
> +
> +	p_ca_cong_setting = ib_cc_mad_get_mgt_data_ptr(p_cc_mad);
> +
> +	memcpy(p_ca_cong_setting,
> +	       &p_cc->ca_cong_setting,
> +	       sizeof(p_cc->ca_cong_setting));
> +
> +	cc_mad_post(p_cc, p_madw, p_node, p_physp,
> +		    IB_MAD_ATTR_CA_CONG_SETTING, 0);
> +
> +	OSM_LOG_EXIT(p_sm->p_log);
> +
> +	return IB_SUCCESS;
> +}
> +
> +static ib_api_status_t cc_send_cct(osm_sm_t * p_sm,
> +				   osm_node_t *p_node,
> +				   osm_physp_t *p_physp)
> +{
> +	osm_congestion_control_t *p_cc = &p_sm->p_subn->p_osm->cc;
> +	unsigned force_update;
> +	osm_madw_t *p_madw = NULL;
> +	ib_cc_mad_t *p_cc_mad = NULL;
> +	ib_cc_tbl_t *p_cc_tbl = NULL;
> +	unsigned int index = 0;
> +
> +	OSM_LOG_ENTER(p_sm->p_log);
> +
> +	force_update = p_physp->need_update || p_sm->p_subn->need_update;
> +
> +	for (index = 0; index < p_cc->cc_tbl_mads; index++) {
> +		if (!force_update
> +		    && !memcmp(&p_cc->cc_tbl[index],
> +			       &p_physp->cc.ca.cc_tbl[index],
> +			       sizeof(p_cc->cc_tbl[index])))
> +			continue;
> +
> +		p_madw = osm_mad_pool_get(p_cc->mad_pool, p_cc->bind_handle,
> +					  MAD_BLOCK_SIZE, NULL);
> +		if (p_madw == NULL) {
> +			OSM_LOG(p_sm->p_log, OSM_LOG_ERROR, "ERR C103: "
> +				"failed to allocate mad\n");
> +			return IB_INSUFFICIENT_MEMORY;
> +		}
> +
> +		p_cc_mad = osm_madw_get_cc_mad_ptr(p_madw);
> +
> +		p_cc_tbl = (ib_cc_tbl_t *)ib_cc_mad_get_mgt_data_ptr(p_cc_mad);
> +
> +		memcpy(p_cc_tbl,
> +		       &p_cc->cc_tbl[index],
> +		       sizeof(p_cc->cc_tbl[index]));
> +
> +		cc_mad_post(p_cc, p_madw, p_node, p_physp,
> +			    IB_MAD_ATTR_CC_TBL, cl_hton32(index));
> +	}
> +
> +	OSM_LOG_EXIT(p_sm->p_log);
> +
> +	return IB_SUCCESS;
> +}
> +
> +int osm_congestion_control_setup(struct osm_opensm *p_osm)
> +{
> +	cl_qmap_t *p_tbl;
> +	cl_map_item_t *p_next;
> +	int ret = 0;
> +
> +	if (!p_osm->subn.opt.congestion_control)
> +		return 0;
> +
> +	OSM_LOG_ENTER(&p_osm->log);
> +
> +	/*
> +	 * Do nothing unless the most recent routing attempt was successful.
> +	 */
> +	if (!p_osm->sm.p_subn->p_osm->routing_engine_used)
> +		return 0;
> +
> +	cc_setup_mad_data(&p_osm->sm);
> +
> +	cl_plock_acquire(&p_osm->lock);
> +
> +	p_tbl = &p_osm->subn.port_guid_tbl;
> +	p_next = cl_qmap_head(p_tbl);
> +	while (p_next != cl_qmap_end(p_tbl)) {
> +		osm_port_t *p_port = (osm_port_t *) p_next;
> +		osm_node_t *p_node = p_port->p_node;
> +		ib_api_status_t status;
> +
> +		p_next = cl_qmap_next(p_next);
> +
> +		if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH) {
> +			status = cc_send_sw_cong_setting(&p_osm->sm, p_node);
> +			if (status != IB_SUCCESS)
> +				ret = -1;
> +		} else if (osm_node_get_type(p_node) == IB_NODE_TYPE_CA) {
> +			status = cc_send_ca_cong_setting(&p_osm->sm,
> +							 p_node,
> +							 p_port->p_physp);
> +			if (status != IB_SUCCESS)
> +				ret = -1;
> +
> +			status = cc_send_cct(&p_osm->sm,
> +					     p_node,
> +					     p_port->p_physp);
> +			if (status != IB_SUCCESS)
> +				ret = -1;
> +		}
> +	}
> +
> +	cl_plock_release(&p_osm->lock);
> +
> +	OSM_LOG_EXIT(&p_osm->log);
> +
> +	return ret;
> +}
> +
> +int osm_congestion_control_wait_pending_transactions(struct osm_opensm *p_osm)
> +{
> +	osm_congestion_control_t *cc = &p_osm->sm.p_subn->p_osm->cc;
> +
> +	if (!p_osm->subn.opt.congestion_control)
> +		return 0;
> +
> +	while (1) {
> +		unsigned count = cc->outstanding_mads;
> +		if (!count || osm_exit_flag)
> +			break;
> +		cl_event_wait_on(&cc->outstanding_mads_done_event,
> +				 EVENT_NO_TIMEOUT,
> +				 TRUE);
> +	}
> +
> +	return osm_exit_flag;
> +}
> +
> +static inline void decrement_outstanding_mads(osm_congestion_control_t *p_cc)
> +{
> +	uint32_t outstanding;
> +
> +	outstanding = cl_atomic_dec(&p_cc->outstanding_mads);
> +	if (!outstanding)
> +		cl_event_signal(&p_cc->outstanding_mads_done_event);
> +
> +	cl_atomic_dec(&p_cc->outstanding_mads_on_wire);
> +	cl_event_signal(&p_cc->sig_mads_on_wire_continue);
> +}
> +
> +
> +static void cc_rcv_mad(void *context, void *data)
> +{
> +	osm_congestion_control_t *p_cc = context;
> +	osm_opensm_t *p_osm = p_cc->osm;
> +	osm_madw_t *p_madw = data;
> +	ib_cc_mad_t *p_cc_mad;
> +	osm_madw_context_t *p_mad_context = &p_madw->context;
> +	ib_mad_t *p_mad = osm_madw_get_mad_ptr(p_madw);
> +	uint64_t node_guid = p_mad_context->cc_context.node_guid;
> +	uint64_t port_guid = p_mad_context->cc_context.port_guid;
> +	uint8_t port = p_mad_context->cc_context.port;
> +	osm_port_t *p_port;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	OSM_LOG(p_cc->log, OSM_LOG_VERBOSE,
> +		"Processing received MAD status 0x%x context 0x%"
> +		PRIx64 "port %u\n", p_mad->status, node_guid, port);
> +
> +	p_cc_mad = osm_madw_get_cc_mad_ptr(p_madw);
> +
> +	cl_plock_acquire(&p_osm->lock);
> +
> +	p_port = osm_get_port_by_guid(p_cc->subn, port_guid);
> +	if (!p_port) {
> +		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C109: "
> +			"Port guid not in table 0x%" PRIx64 "\n",
> +			   port_guid);
> +		cl_plock_release(&p_osm->lock);
> +		goto Exit;
> +	}
> +
> +	if (p_cc_mad->header.attr_id == IB_MAD_ATTR_SW_CONG_SETTING) {
> +		ib_sw_cong_setting_t *p_sw_cong_setting;
> +
> +		p_sw_cong_setting = ib_cc_mad_get_mgt_data_ptr(p_cc_mad);
> +		p_port->p_physp->cc.sw.sw_cong_setting = *p_sw_cong_setting;
> +	}
> +	else if (p_cc_mad->header.attr_id == IB_MAD_ATTR_CA_CONG_SETTING) {
> +		ib_ca_cong_setting_t *p_ca_cong_setting;
> +
> +		p_ca_cong_setting = ib_cc_mad_get_mgt_data_ptr(p_cc_mad);
> +		p_port->p_physp->cc.ca.ca_cong_setting = *p_ca_cong_setting;
> +	}
> +	else if (p_cc_mad->header.attr_id == IB_MAD_ATTR_CC_TBL) {
> +		ib_net32_t attr_mod = p_mad_context->cc_context.attr_mod;
> +		uint32_t index = cl_ntoh32(attr_mod);
> +		ib_cc_tbl_t *p_cc_tbl;
> +
> +		p_cc_tbl = ib_cc_mad_get_mgt_data_ptr(p_cc_mad);
> +		p_port->p_physp->cc.ca.cc_tbl[index] = *p_cc_tbl;
> +	}
> +	else
> +		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C10A: "
> +			"Unexpected MAD attribute received: %u\n",
> +			   p_cc_mad->header.attr_id);
> +
> +	cl_plock_release(&p_osm->lock);
> +
> +Exit:
> +	decrement_outstanding_mads(p_cc);
> +	osm_mad_pool_put(p_cc->mad_pool, p_madw);
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> +
> +static void cc_poller_send(osm_congestion_control_t *p_cc,
> +			   osm_madw_t *p_madw)
> +{
> +	osm_subn_opt_t *p_opt = &p_cc->subn->opt;
> +	ib_api_status_t status;
> +
> +	status = osm_vendor_send(p_cc->bind_handle, p_madw, TRUE);
> +	if (status == IB_SUCCESS) {
> +		cl_atomic_inc(&p_cc->outstanding_mads_on_wire);
> +		if (p_cc->outstanding_mads_on_wire >
> +		    p_opt->cc_max_outstanding_mads)
> +			cl_event_wait_on(&p_cc->sig_mads_on_wire_continue,
> +					 EVENT_NO_TIMEOUT,
> +					 TRUE);
> +	}
> +	else {
> +		osm_madw_context_t *mad_context = &p_madw->context;
> +
> +		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C104: "
> +			"send failed to node 0x%" PRIx64 "port %u\n",
> +			mad_context->cc_context.node_guid,
> +			mad_context->cc_context.port);
> +	}
> +}
> +
> +static void cc_poller(void *p_ptr)
> +{
> +	osm_congestion_control_t *p_cc = p_ptr;
> +	osm_madw_t *p_madw;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	if (p_cc->thread_state == OSM_THREAD_STATE_NONE)
> +		p_cc->thread_state = OSM_THREAD_STATE_RUN;
> +
> +	while (p_cc->thread_state == OSM_THREAD_STATE_RUN) {
> +		cl_spinlock_acquire(&p_cc->mad_queue_lock);
> +
> +		p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_cc->mad_queue);
> +
> +		cl_spinlock_release(&p_cc->mad_queue_lock);
> +
> +		if (p_madw != (osm_madw_t *) cl_qlist_end(&p_cc->mad_queue))
> +			cc_poller_send(p_cc, p_madw);
> +		else
> +			cl_event_wait_on(&p_cc->cc_poller_wakeup,
> +					 EVENT_NO_TIMEOUT, TRUE);
> +	}
> +
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> +
> +ib_api_status_t osm_congestion_control_init(osm_congestion_control_t * p_cc,
> +					    struct osm_opensm *p_osm,
> +					    const osm_subn_opt_t * p_opt)
> +{
> +	ib_api_status_t status = IB_SUCCESS;
> +
> +	OSM_LOG_ENTER(&p_osm->log);
> +
> +	memset(p_cc, 0, sizeof(*p_cc));
> +
> +	p_cc->osm = p_osm;
> +	p_cc->subn = &p_osm->subn;
> +	p_cc->sm = &p_osm->sm;
> +	p_cc->log = &p_osm->log;
> +	p_cc->mad_pool = &p_osm->mad_pool;
> +	p_cc->trans_id = CONGESTION_CONTROL_INITIAL_TID_VALUE;
> +	p_cc->vendor = p_osm->p_vendor;
> +
> +	p_cc->cc_disp_h = cl_disp_register(&p_osm->disp, OSM_MSG_MAD_CC,
> +					   cc_rcv_mad, p_cc);
> +	if (p_cc->cc_disp_h == CL_DISP_INVALID_HANDLE)
> +		goto Exit;
> +
> +	cl_qlist_init(&p_cc->mad_queue);
> +
> +	status = cl_spinlock_init(&p_cc->mad_queue_lock);
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
> +	cl_event_construct(&p_cc->cc_poller_wakeup);
> +	status = cl_event_init(&p_cc->cc_poller_wakeup, FALSE);
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
> +	cl_event_construct(&p_cc->outstanding_mads_done_event);
> +	status = cl_event_init(&p_cc->outstanding_mads_done_event, FALSE);
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
> +	cl_event_construct(&p_cc->sig_mads_on_wire_continue);
> +	status = cl_event_init(&p_cc->sig_mads_on_wire_continue, FALSE);
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
> +	p_cc->thread_state = OSM_THREAD_STATE_NONE;
> +
> +	status = cl_thread_init(&p_cc->cc_poller, cc_poller, p_cc,
> +				"cc poller");
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
> +	status = IB_SUCCESS;
> +Exit:
> +	OSM_LOG_EXIT(p_cc->log);
> +	return status;
> +}
> +
> +static void cc_mad_recv_callback(osm_madw_t * p_madw, void *bind_context,
> +				 osm_madw_t * p_req_madw)
> +{
> +	osm_congestion_control_t *p_cc = bind_context;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	osm_madw_copy_context(p_madw, p_req_madw);
> +	osm_mad_pool_put(p_cc->mad_pool, p_req_madw);
> +
> +	/* Do not decrement outstanding mads here, do it in the dispatcher */
> +
> +	if (cl_disp_post(p_cc->cc_disp_h, OSM_MSG_MAD_CC,
> +			 p_madw, NULL, NULL) != CL_SUCCESS) {
> +		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C105: "
> +			"Congestion Control Dispatcher post failed\n");
> +		osm_mad_pool_put(p_cc->mad_pool, p_madw);
> +	}
> +
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> +
> +static void cc_mad_send_err_callback(void *bind_context,
> +				     osm_madw_t * p_madw)
> +{
> +	osm_congestion_control_t *p_cc = bind_context;
> +	osm_madw_context_t *p_madw_context = &p_madw->context;
> +	uint64_t node_guid = p_madw_context->cc_context.node_guid;
> +	uint8_t port = p_madw_context->cc_context.port;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C106: MAD Error (%s): "
> +		"attr id = %u LID %u GUID 0x%016" PRIx64 " port %u "
> +		"TID 0x%" PRIx64 "\n",
> +		ib_get_err_str(p_madw->status),
> +		p_madw->p_mad->attr_id,
> +		cl_ntoh16(p_madw->mad_addr.dest_lid),
> +		node_guid,
> +		port,
> +		cl_ntoh64(p_madw->p_mad->trans_id));
> +
> +	p_cc->subn->subnet_initialization_error = TRUE;
> +
> +	osm_mad_pool_put(p_cc->mad_pool, p_madw);
> +
> +	decrement_outstanding_mads(p_cc);
> +
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> +
> +ib_api_status_t osm_congestion_control_bind(osm_congestion_control_t * p_cc,
> +					    ib_net64_t port_guid)
> +{
> +	osm_bind_info_t bind_info;
> +	ib_api_status_t status = IB_SUCCESS;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	bind_info.port_guid = p_cc->port_guid = port_guid;
> +	bind_info.mad_class = IB_MCLASS_CC;
> +	bind_info.class_version = 2;
> +	bind_info.is_responder = FALSE;
> +	bind_info.is_report_processor = FALSE;
> +	bind_info.is_trap_processor = FALSE;
> +	bind_info.recv_q_size = OSM_SM_DEFAULT_QP1_RCV_SIZE;
> +	bind_info.send_q_size = OSM_SM_DEFAULT_QP1_SEND_SIZE;
> +	bind_info.timeout = p_cc->subn->opt.transaction_timeout;
> +	bind_info.retries = p_cc->subn->opt.transaction_retries;
> +
> +	OSM_LOG(p_cc->log, OSM_LOG_VERBOSE,
> +		"Binding to port GUID 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
> +
> +	p_cc->bind_handle = osm_vendor_bind(p_cc->vendor, &bind_info,
> +					    p_cc->mad_pool,
> +					    cc_mad_recv_callback,
> +					    cc_mad_send_err_callback, p_cc);
> +
> +	if (p_cc->bind_handle == OSM_BIND_INVALID_HANDLE) {
> +		status = IB_ERROR;
> +		OSM_LOG(p_cc->log, OSM_LOG_ERROR,
> +			"ERR C107: Vendor specific bind failed (%s)\n",
> +			ib_get_err_str(status));
> +		goto Exit;
> +	}
> +
> +Exit:
> +	OSM_LOG_EXIT(p_cc->log);
> +	return status;
> +}
> +
> +void osm_congestion_control_shutdown(osm_congestion_control_t * p_cc)
> +{
> +	OSM_LOG_ENTER(p_cc->log);
> +	if (p_cc->bind_handle == OSM_BIND_INVALID_HANDLE) {
> +		OSM_LOG(p_cc->log, OSM_LOG_ERROR,
> +			"ERR C108: No previous bind\n");
> +		goto Exit;
> +	}
> +	cl_disp_unregister(p_cc->cc_disp_h);
> +Exit:
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> +
> +void osm_congestion_control_destroy(osm_congestion_control_t * p_cc)
> +{
> +	osm_madw_t *p_madw;
> +
> +	OSM_LOG_ENTER(p_cc->log);
> +
> +	p_cc->thread_state = OSM_THREAD_STATE_EXIT;
> +
> +	cl_event_signal(&p_cc->sig_mads_on_wire_continue);
> +	cl_event_signal(&p_cc->cc_poller_wakeup);
> +
> +	cl_thread_destroy(&p_cc->cc_poller);
> +
> +	cl_spinlock_acquire(&p_cc->mad_queue_lock);
> +
> +	while (!cl_is_qlist_empty(&p_cc->mad_queue)) {
> +		p_madw = (osm_madw_t *) cl_qlist_remove_head(&p_cc->mad_queue);
> +		osm_mad_pool_put(p_cc->mad_pool, p_madw);
> +	}
> +
> +	cl_spinlock_release(&p_cc->mad_queue_lock);
> +
> +	cl_spinlock_destroy(&p_cc->mad_queue_lock);
> +
> +	cl_event_destroy(&p_cc->cc_poller_wakeup);
> +	cl_event_destroy(&p_cc->outstanding_mads_done_event);
> +	cl_event_destroy(&p_cc->sig_mads_on_wire_continue);
> +
> +	OSM_LOG_EXIT(p_cc->log);
> +}
> diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
> index 429108a..c7328ef 100644
> --- a/opensm/osm_opensm.c
> +++ b/opensm/osm_opensm.c
> @@ -61,6 +61,7 @@
>  #include <opensm/osm_sm.h>
>  #include <opensm/osm_vl15intf.h>
>  #include <opensm/osm_event_plugin.h>
> +#include <opensm/osm_congestion_control.h>
>  
>  struct routing_engine_module {
>  	const char *name;
> @@ -291,6 +292,8 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
>  	osm_perfmgr_shutdown(&p_osm->perfmgr);
>  #endif				/* ENABLE_OSM_PERF_MGR */
>  
> +	osm_congestion_control_shutdown(&p_osm->cc);
> +
>  	/* shut down the SA
>  	 * - unbind from QP1 messages
>  	 */
> @@ -320,6 +323,7 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
>  #ifdef ENABLE_OSM_PERF_MGR
>  	osm_perfmgr_destroy(&p_osm->perfmgr);
>  #endif				/* ENABLE_OSM_PERF_MGR */
> +	osm_congestion_control_destroy(&p_osm->cc);
>  	osm_db_destroy(&p_osm->db);
>  	osm_vl15_destroy(&p_osm->vl15, &p_osm->mad_pool);
>  	osm_mad_pool_destroy(&p_osm->mad_pool);
> @@ -464,6 +468,11 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
>  		goto Exit;
>  #endif				/* ENABLE_OSM_PERF_MGR */
>  
> +	status = osm_congestion_control_init(&p_osm->cc,
> +					     p_osm, p_opt);
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
>  	p_osm->no_fallback_routing_engine = FALSE;
>  
>  	setup_routing_engines(p_osm, p_opt->routing_engine_names);
> @@ -497,6 +506,10 @@ ib_api_status_t osm_opensm_bind(IN osm_opensm_t * p_osm, IN ib_net64_t guid)
>  		goto Exit;
>  #endif				/* ENABLE_OSM_PERF_MGR */
>  
> +	status = osm_congestion_control_bind(&p_osm->cc, guid);
> +	if (status != IB_SUCCESS)
> +		goto Exit;
> +
>  	/* setting IS_SM in capability mask */
>  	OSM_LOG(&p_osm->log, OSM_LOG_INFO, "Setting IS_SM on port 0x%016" PRIx64 "\n",
>  			cl_ntoh64(guid));
> diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
> index 143b744..4d762a3 100644
> --- a/opensm/osm_state_mgr.c
> +++ b/opensm/osm_state_mgr.c
> @@ -66,6 +66,7 @@
>  #include <vendor/osm_vendor_api.h>
>  #include <opensm/osm_inform.h>
>  #include <opensm/osm_opensm.h>
> +#include <opensm/osm_congestion_control.h>
>  
>  extern void osm_drop_mgr_process(IN osm_sm_t * sm);
>  extern int osm_qos_setup(IN osm_opensm_t * p_osm);
> @@ -1156,6 +1157,11 @@ static void do_sweep(osm_sm_t * sm)
>  		if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
>  			return;
>  
> +		osm_congestion_control_setup(sm->p_subn->p_osm);
> +
> +		if (osm_congestion_control_wait_pending_transactions (sm->p_subn->p_osm))
> +			return;
> +
>  		if (!sm->p_subn->subnet_initialization_error) {
>  			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
>  					"REROUTE COMPLETE");
> @@ -1401,6 +1407,13 @@ repeat_discovery:
>  	 * The sweep completed!
>  	 */
>  
> +	/* Now do GSI configuration */
> +
> +	osm_congestion_control_setup(sm->p_subn->p_osm);
> +
> +	if (osm_congestion_control_wait_pending_transactions (sm->p_subn->p_osm))
> +		return;
> +
>  	/*
>  	 * Send trap 64 on newly discovered endports
>  	 */
> diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> index 7fb5c8f..21bb588 100644
> --- a/opensm/osm_subnet.c
> +++ b/opensm/osm_subnet.c
> @@ -72,6 +72,7 @@
>  #include <opensm/osm_inform.h>
>  #include <opensm/osm_console.h>
>  #include <opensm/osm_perfmgr.h>
> +#include <opensm/osm_congestion_control.h>
>  #include <opensm/osm_event_plugin.h>
>  #include <opensm/osm_qos_policy.h>
>  #include <opensm/osm_service.h>
> @@ -300,6 +301,22 @@ static void opts_parse_uint32(IN osm_subn_t *p_subn, IN char *p_key,
>  	}
>  }
>  
> +static void opts_parse_net32(IN osm_subn_t *p_subn, IN char *p_key,
> +			     IN char *p_val_str, void *p_v1, void *p_v2,
> +			     void (*pfn)(osm_subn_t *, void *))
> +{
> +	uint32_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	uint32_t val = strtoul(p_val_str, NULL, 0);
> +
> +	if (cl_hton32(val) != *p_val1) {
> +		log_config_value(p_key, "%u", val);
> +		if (pfn)
> +			pfn(p_subn, &val);
> +		*p_val1 = *p_val2 = cl_hton32(val);
> +	}
> +}
> +
> +
>  static void opts_parse_int32(IN osm_subn_t *p_subn, IN char *p_key,
>  			     IN char *p_val_str, void *p_v1, void *p_v2,
>  			     void (*pfn)(osm_subn_t *, void *))
> @@ -405,6 +422,274 @@ static void opts_parse_charp(IN osm_subn_t *p_subn, IN char *p_key,
>  	}
>  }
>  
> +static void opts_parse_256bit(IN osm_subn_t *p_subn, IN char *p_key,
> +			      IN char *p_val_str, void *p_v1, void *p_v2,
> +			      void (*pfn)(osm_subn_t *, void *))
> +{
> +	uint8_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	uint8_t val[IB_CC_PORT_MASK_DATA_SIZE] = { 0 };
> +	char tmpbuf[3] = { 0 };
> +	uint8_t tmpint;
> +	int numdigits = 0;
> +	int startindex;
> +	char *strptr = p_val_str;
> +	char *ptr;
> +	int i;
> +
> +	/* parse like it's hypothetically a 256 bit integer code
> +	 *
> +	 * store "big endian"
> +	 */
> +
> +	if (!strncmp(strptr, "0x", 2) || !strncmp(strptr, "0X", 2))
> +		strptr+=2;
> +
> +	for (ptr = strptr; *ptr; ptr++) {
> +		if (!isxdigit(*ptr)) {
> +			log_report("invalid hex digit in bitmask\n");
> +			return;
> +		}
> +		numdigits++;
> +	}
> +
> +	if (!numdigits) {
> +		log_report("invalid length bitmask\n");
> +		return;
> +	}
> +
> +	/* max of 2 hex chars per byte */
> +	if (numdigits > IB_CC_PORT_MASK_DATA_SIZE * 2)
> +		numdigits = IB_CC_PORT_MASK_DATA_SIZE * 2;
> +
> +	startindex = IB_CC_PORT_MASK_DATA_SIZE - ((numdigits - 1) / 2) - 1;
> +
> +	if (numdigits % 2) {
> +		memcpy(tmpbuf, strptr, 1);
> +		strptr += 1;
> +	}
> +	else {
> +		memcpy(tmpbuf, strptr, 2);
> +		strptr += 2;
> +	}
> +
> +	tmpint = strtoul(tmpbuf, NULL, 16);
> +	val[startindex] = tmpint;
> +
> +	for (i = (startindex + 1); i < IB_CC_PORT_MASK_DATA_SIZE; i++) {
> +		memcpy(tmpbuf, strptr, 2);
> +		strptr += 2;
> +		tmpint = strtoul(tmpbuf, NULL, 16);
> +		val[i] = tmpint;
> +	}
> +
> +	if (memcmp(val, p_val1, IB_CC_PORT_MASK_DATA_SIZE)) {
> +		log_config_value(p_key, "%s", p_val_str);
> +		if (pfn)
> +			pfn(p_subn, val);
> +		memcpy(p_val1, val, IB_CC_PORT_MASK_DATA_SIZE);
> +		memcpy(p_val2, val, IB_CC_PORT_MASK_DATA_SIZE);
> +	}
> +
> +}
> +
> +static void opts_parse_cct_entry(IN osm_subn_t *p_subn, IN char *p_key,
> +				 IN char *p_val_str, void *p_v1, void *p_v2,
> +				 void (*pfn)(osm_subn_t *, void *))
> +{
> +	osm_cct_entry_t *p_cct1 = p_v1, *p_cct2 = p_v2;
> +	osm_cct_entry_t cct;
> +	char buf[512] = { 0 };
> +	char *ptr;
> +
> +	strncpy(buf, p_val_str, 511);
> +
> +	if (!(ptr = strchr(buf, ':'))) {
> +		log_report("invalid CCT entry\n");
> +		return;
> +	}
> +
> +	*ptr = '\0';
> +	ptr++;
> +
> +	cct.shift = strtoul(buf, NULL, 0);
> +	cct.multiplier = strtoul(ptr, NULL, 0);
> +
> +	if (cct.shift != p_cct1->shift
> +	    || cct.multiplier != p_cct1->multiplier) {
> +		log_config_value(p_key, "%s", p_val_str);
> +		if (pfn)
> +			pfn(p_subn, &cct);
> +		p_cct1->shift = p_cct2->shift = cct.shift;
> +		p_cct1->multiplier = p_cct2->multiplier = cct.multiplier;
> +	}
> +}
> +
> +static void opts_parse_cc_cct(IN osm_subn_t *p_subn, IN char *p_key,
> +			      IN char *p_val_str, void *p_v1, void *p_v2,
> +			      void (*pfn)(osm_subn_t *, void *))
> +{
> +	osm_cct_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	const char *current_str = p_val1->input_str ? p_val1->input_str : null_str;
> +
> +	if (p_val_str && strcmp(p_val_str, current_str)) {
> +		osm_cct_t newcct;
> +		char *new;
> +		unsigned int len = 0;
> +		char *lasts;
> +		char *tok;
> +		char *ptr;
> +
> +		/* special case the "(null)" string */
> +		new = strcmp(null_str, p_val_str) ? strdup(p_val_str) : NULL;
> +
> +		if (!new) {
> +			log_config_value(p_key, "%s", p_val_str);
> +			if (pfn)
> +				pfn(p_subn, NULL);
> +			memset(p_val1->entries, '\0', sizeof(p_val1->entries));
> +			memset(p_val2->entries, '\0', sizeof(p_val2->entries));
> +			p_val1->entries_len = p_val2->entries_len = 0;
> +			p_val1->input_str = p_val2->input_str = NULL;
> +			return;
> +		}
> +
> +		memset(&newcct, '\0', sizeof(newcct));
> +
> +		tok = strtok_r(new, ",", &lasts);
> +		while (tok && len < OSM_CCT_ENTRY_MAX) {
> +
> +			if (!(ptr = strchr(tok, ':'))) {
> +				log_report("invalid CCT entry\n");
> +				free(new);
> +				return;
> +			}
> +			*ptr = '\0';
> +			ptr++;
> +
> +			newcct.entries[len].shift = strtoul(tok, NULL, 0);
> +			newcct.entries[len].multiplier = strtoul(ptr, NULL, 0);
> +			len++;
> +			tok = strtok_r(NULL, ",", &lasts);
> +		}
> +
> +		free(new);
> +
> +		newcct.entries_len = len;
> +		newcct.input_str = strdup(p_val_str);
> +
> +		log_config_value(p_key, "%s", p_val_str);
> +		if (pfn)
> +			pfn(p_subn, &newcct);
> +		if (p_val1->input_str && p_val1->input_str != p_val2->input_str)
> +			free(p_val1->input_str);
> +		if (p_val2->input_str)
> +			free(p_val2->input_str);
> +		memcpy(p_val1->entries, newcct.entries, sizeof(newcct.entries));
> +		memcpy(p_val2->entries, newcct.entries, sizeof(newcct.entries));
> +		p_val1->entries_len = p_val2->entries_len = newcct.entries_len;
> +		p_val1->input_str = p_val2->input_str = newcct.input_str;
> +	}
> +}
> +
> +static int parse_ca_cong_common(char *p_val_str, uint8_t *sl, unsigned int *val_offset) {
> +	char *new, *lasts, *sl_str, *val_str;
> +	uint8_t sltmp;
> +
> +	new = strcmp(null_str, p_val_str) ? strdup(p_val_str) : NULL;
> +	if (!new)
> +		return -1;
> +
> +	sl_str = strtok_r(new, " \t", &lasts);
> +	val_str = strtok_r(NULL, " \t", &lasts);
> +
> +	if (!val_str) {
> +		log_report("value must be specified in addition to SL\n");
> +		free(new);
> +		return -1;
> +	}
> +
> +	sltmp = strtoul(sl_str, NULL, 0);
> +	if (sltmp >= IB_CA_CONG_ENTRY_DATA_SIZE) {
> +		log_report("invalid SL specified\n");
> +		free(new);
> +		return -1;
> +	}
> +
> +	*sl = sltmp;
> +	*val_offset = (unsigned int)(val_str - new);
> +
> +	free(new);
> +	return 0;
> +}
> +
> +static void opts_parse_ccti_timer(IN osm_subn_t *p_subn, IN char *p_key,
> +				  IN char *p_val_str, void *p_v1, void *p_v2,
> +				  void (*pfn)(osm_subn_t *, void *))
> +{
> +	osm_cacongestion_entry_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	unsigned int val_offset = 0;
> +	uint8_t sl = 0;
> +
> +	if (parse_ca_cong_common(p_val_str, &sl, &val_offset) < 0)
> +		return;
> +
> +	opts_parse_net16(p_subn, p_key, p_val_str + val_offset,
> +			 &p_val1[sl].ccti_timer,
> +			 &p_val2[sl].ccti_timer,
> +			 pfn);
> +}
> +
> +static void opts_parse_ccti_increase(IN osm_subn_t *p_subn, IN char *p_key,
> +				     IN char *p_val_str, void *p_v1, void *p_v2,
> +				     void (*pfn)(osm_subn_t *, void *))
> +{
> +	osm_cacongestion_entry_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	unsigned int val_offset = 0;
> +	uint8_t sl = 0;
> +
> +	if (parse_ca_cong_common(p_val_str, &sl, &val_offset) < 0)
> +		return;
> +
> +	opts_parse_uint8(p_subn, p_key, p_val_str + val_offset,
> +			 &p_val1[sl].ccti_increase,
> +			 &p_val2[sl].ccti_increase,
> +			 pfn);
> +}
> +
> +static void opts_parse_trigger_threshold(IN osm_subn_t *p_subn, IN char *p_key,
> +					 IN char *p_val_str, void *p_v1, void *p_v2,
> +					 void (*pfn)(osm_subn_t *, void *))
> +{
> +	osm_cacongestion_entry_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	unsigned int val_offset = 0;
> +	uint8_t sl = 0;
> +
> +	if (parse_ca_cong_common(p_val_str, &sl, &val_offset) < 0)
> +		return;
> +
> +	opts_parse_uint8(p_subn, p_key, p_val_str + val_offset,
> +			 &p_val1[sl].trigger_threshold,
> +			 &p_val2[sl].trigger_threshold,
> +			 pfn);
> +}
> +
> +static void opts_parse_ccti_min(IN osm_subn_t *p_subn, IN char *p_key,
> +				IN char *p_val_str, void *p_v1, void *p_v2,
> +				void (*pfn)(osm_subn_t *, void *))
> +{
> +	osm_cacongestion_entry_t *p_val1 = p_v1, *p_val2 = p_v2;
> +	unsigned int val_offset = 0;
> +	uint8_t sl = 0;
> +
> +	if (parse_ca_cong_common(p_val_str, &sl, &val_offset) < 0)
> +		return;
> +
> +	opts_parse_uint8(p_subn, p_key, p_val_str + val_offset,
> +			 &p_val1[sl].ccti_min,
> +			 &p_val2[sl].ccti_min,
> +			 pfn);
> +}
> +
>  static const opt_rec_t opt_tbl[] = {
>  	{ "guid", OPT_OFFSET(guid), opts_parse_net64, NULL, 0 },
>  	{ "m_key", OPT_OFFSET(m_key), opts_parse_net64, NULL, 1 },
> @@ -521,6 +806,24 @@ static const opt_rec_t opt_tbl[] = {
>  	{ "qos_rtr_vlarb_high", OPT_OFFSET(qos_rtr_options.vlarb_high), opts_parse_charp, NULL, 1 },
>  	{ "qos_rtr_vlarb_low", OPT_OFFSET(qos_rtr_options.vlarb_low), opts_parse_charp, NULL, 1 },
>  	{ "qos_rtr_sl2vl", OPT_OFFSET(qos_rtr_options.sl2vl), opts_parse_charp, NULL, 1 },
> +	{ "congestion_control", OPT_OFFSET(congestion_control), opts_parse_boolean, NULL, 1 },
> +	{ "cckey", OPT_OFFSET(cckey), opts_parse_net64, NULL, 0},
> +	{ "cc_max_outstanding_mads", OPT_OFFSET(cc_max_outstanding_mads), opts_parse_uint32, NULL, 0 },
> +	{ "cc_sw_cong_setting_control_map", OPT_OFFSET(cc_sw_cong_setting_control_map), opts_parse_net32, NULL, 1},
> +	{ "cc_sw_cong_setting_victim_mask", OPT_OFFSET(cc_sw_cong_setting_victim_mask), opts_parse_256bit, NULL, 1},
> +	{ "cc_sw_cong_setting_credit_mask", OPT_OFFSET(cc_sw_cong_setting_credit_mask), opts_parse_256bit, NULL, 1},
> +	{ "cc_sw_cong_setting_threshold", OPT_OFFSET(cc_sw_cong_setting_threshold), opts_parse_uint8, NULL, 1},
> +	{ "cc_sw_cong_setting_packet_size", OPT_OFFSET(cc_sw_cong_setting_packet_size), opts_parse_uint8, NULL, 1},
> +	{ "cc_sw_cong_setting_credit_starvation_threshold", OPT_OFFSET(cc_sw_cong_setting_credit_starvation_threshold), opts_parse_uint8, NULL, 1},
> +	{ "cc_sw_cong_setting_credit_starvation_return_delay", OPT_OFFSET(cc_sw_cong_setting_credit_starvation_return_delay), opts_parse_cct_entry, NULL, 1},
> +	{ "cc_sw_cong_setting_marking_rate", OPT_OFFSET(cc_sw_cong_setting_marking_rate), opts_parse_net16, NULL, 1},
> +	{ "cc_ca_cong_setting_port_control", OPT_OFFSET(cc_ca_cong_setting_port_control), opts_parse_net16, NULL, 1},
> +	{ "cc_ca_cong_setting_control_map", OPT_OFFSET(cc_ca_cong_setting_control_map), opts_parse_net16, NULL, 1},
> +	{ "cc_ca_cong_setting_ccti_timer", OPT_OFFSET(cc_ca_cong_entries), opts_parse_ccti_timer, NULL, 1},
> +	{ "cc_ca_cong_setting_ccti_increase", OPT_OFFSET(cc_ca_cong_entries), opts_parse_ccti_increase, NULL, 1},
> +	{ "cc_ca_cong_setting_trigger_threshold", OPT_OFFSET(cc_ca_cong_entries), opts_parse_trigger_threshold, NULL, 1},
> +	{ "cc_ca_cong_setting_ccti_min", OPT_OFFSET(cc_ca_cong_entries), opts_parse_ccti_min, NULL, 1},
> +	{ "cc_cct", OPT_OFFSET(cc_cct), opts_parse_cc_cct, NULL, 1},
>  	{ "enable_quirks", OPT_OFFSET(enable_quirks), opts_parse_boolean, NULL, 1 },
>  	{ "no_clients_rereg", OPT_OFFSET(no_clients_rereg), opts_parse_boolean, NULL, 1 },
>  	{ "prefix_routes_file", OPT_OFFSET(prefix_routes_file), opts_parse_charp, NULL, 0 },
> @@ -597,6 +900,7 @@ static void subn_opt_destroy(IN osm_subn_opt_t * p_opt)
>  	subn_destroy_qos_options(&p_opt->qos_sw0_options);
>  	subn_destroy_qos_options(&p_opt->qos_swe_options);
>  	subn_destroy_qos_options(&p_opt->qos_rtr_options);
> +	free(p_opt->cc_cct.input_str);
>  }
>  
>  void osm_subn_destroy(IN osm_subn_t * p_subn)
> @@ -1002,6 +1306,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	p_opt->sm_assigned_guid = 0;
>  	p_opt->qos = FALSE;
>  	p_opt->qos_policy_file = strdup(OSM_DEFAULT_QOS_POLICY_FILE);
> +	p_opt->cckey = OSM_DEFAULT_CC_KEY;
>  	p_opt->accum_log_file = TRUE;
>  	p_opt->port_prof_ignore_file = NULL;
>  	p_opt->hop_weights_file = NULL;
> @@ -1026,6 +1331,9 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	p_opt->torus_conf_file = strdup(OSM_DEFAULT_TORUS_CONF_FILE);
>  	p_opt->do_mesh_analysis = FALSE;
>  	p_opt->exit_on_fatal = TRUE;
> +	p_opt->congestion_control = FALSE;
> +	p_opt->cckey = OSM_DEFAULT_CC_KEY;
> +	p_opt->cc_max_outstanding_mads = OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES;
>  	p_opt->enable_quirks = FALSE;
>  	p_opt->no_clients_rereg = FALSE;
>  	p_opt->prefix_routes_file = strdup(OSM_DEFAULT_PREFIX_ROUTES_FILE);
> @@ -1040,6 +1348,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
>  	subn_init_qos_options(&p_opt->qos_swe_options, NULL);
>  	subn_init_qos_options(&p_opt->qos_rtr_options, NULL);
> +	p_opt->cc_cct.entries_len = 0;
> +	p_opt->cc_cct.input_str = NULL;
>  }
>  
>  static char *clean_val(char *val)
> @@ -1667,6 +1977,9 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
>  
>  int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  {
> +	int cacongoutputcount = 0;
> +	int i;
> +
>  	fprintf(out,
>  		"#\n# DEVICE ATTRIBUTES OPTIONS\n#\n"
>  		"# The port GUID on which the OpenSM is running\n"
> @@ -2123,6 +2436,164 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  	fprintf(out, "\n");
>  
>  	fprintf(out,
> +		"#\n# Congestion Control OPTIONS\n#\n\n"
> +		"# Enable Congestion Control Configuration\n"
> +		"congestion_control %s\n\n"
> +		"# CCKey to use when configuring congestion control\n"
> +		"# note that this does not configure a new CCkey, only the CCkey to use\n"
> +		"cckey 0x%016" PRIx64 "\n\n"
> +		"# Congestion Control Max outstanding MAD\n"
> +		"cc_max_outstanding_mads %u\n\n",
> +		p_opts->congestion_control ? "TRUE" : "FALSE",
> +		cl_ntoh64(p_opts->cckey),
> +		p_opts->cc_max_outstanding_mads);
> +
> +	fprintf(out,
> +		"#\n# Congestion Control SwitchCongestionSetting options\n#\n"
> +		"# Control Map - bitmask indicating which of the following attributes are to be used\n"
> +		"# bit 0 - victim mask\n"
> +		"# bit 1 - credit mask\n"
> +		"# bit 2 - threshold + packet size\n"
> +		"# bit 3 - credit starvation threshold + return delay valid\n"
> +		"# bit 4 - marking rate valid\n"
> +		"cc_sw_cong_setting_control_map 0x%X\n\n",
> +		cl_ntoh32(p_opts->cc_sw_cong_setting_control_map));
> +
> +	fprintf(out,
> +		"# Victim Mask - 256 bit mask representing switch ports, mark packets with FECN\n"
> +		"# whether they are the source or victim of congestion\n"
> +		"# bit 0 - port 0 (enhanced port)\n"
> +		"# bit 1 - port 1\n"
> +		"# ...\n"
> +		"# bit 254 - port 254\n"
> +		"# bit 255 - reserved\n"
> +		"cc_sw_cong_setting_victim_mask 0x");
> +
> +	for (i = 0; i < IB_CC_PORT_MASK_DATA_SIZE; i++)
> +		fprintf(out, "%02X", p_opts->cc_sw_cong_setting_victim_mask[i]);
> +	fprintf(out, "\n\n");
> +
> +	fprintf(out,
> +		"# Credit Mask - 256 bit mask representing switch ports to apply credit starvation\n"
> +		"# bit 0 - port 0 (enhanced port)\n"
> +		"# bit 1 - port 1\n"
> +		"# ...\n"
> +		"# bit 254 - port 254\n"
> +		"# bit 255 - reserved\n"
> +		"cc_sw_cong_setting_credit_mask 0x");
> +
> +	for (i = 0; i < IB_CC_PORT_MASK_DATA_SIZE; i++)
> +		fprintf(out, "%02X", p_opts->cc_sw_cong_setting_credit_mask[i]);
> +	fprintf(out, "\n\n");
> +
> +	fprintf(out,
> +		"# Threshold - value indicating aggressiveness of congestion marking\n"
> +		"# 0x0 - none, 0x1 - loose, ..., 0xF - aggressive\n"
> +		"cc_sw_cong_setting_threshold 0x%02X\n\n"
> +		"# Packet Size - any packet less than this size will not be marked with a FECN\n"
> +		"# units are in credits\n"
> +		"cc_sw_cong_setting_packet_size %u\n\n"
> +		"# Credit Starvation Threshold - value indicating aggressiveness of credit starvation\n"
> +		"# 0x0 - none, 0x1 - loose, ..., 0xF - aggressive\n"
> +		"cc_sw_cong_setting_credit_starvation_threshold 0x%02X\n\n"
> +		"# Credit Starvation Return Delay - in CCT entry shift:multiplier format, see IB spec\n"
> +		"cc_sw_cong_setting_credit_starvation_return_delay %u:%u\n\n"
> +		"# Marking Rate - mean number of packets between markings\n"
> +		"cc_sw_cong_setting_marking_rate %u\n\n",
> +		p_opts->cc_sw_cong_setting_threshold,
> +		p_opts->cc_sw_cong_setting_packet_size,
> +		p_opts->cc_sw_cong_setting_credit_starvation_threshold,
> +		p_opts->cc_sw_cong_setting_credit_starvation_return_delay.shift,
> +		p_opts->cc_sw_cong_setting_credit_starvation_return_delay.multiplier,
> +		cl_ntoh16(p_opts->cc_sw_cong_setting_marking_rate));
> +
> +	fprintf(out,
> +		"#\n# Congestion Control CA Congestion Setting options\n#\n"
> +		"# Port Control\n"
> +		"# bit 0 = 0, QP based congestion control\n"
> +		"# bit 0 = 1, SL/port based congestion control\n"
> +		"cc_ca_cong_setting_port_control 0x%04X\n\n"
> +		"# Control Map - 16 bit bitmask indicating which SLs should be configured\n"
> +		"cc_ca_cong_setting_control_map 0x%04X\n\n",
> +		cl_ntoh16(p_opts->cc_ca_cong_setting_port_control),
> +		cl_ntoh16(p_opts->cc_ca_cong_setting_control_map));
> +
> +	fprintf(out,
> +		"#\n# CA Congestion Setting Entries\n#\n"
> +		"# Each of congestion control settings below configures the CA Congestion\n"
> +		"# Settings for an individual SL.  The SL must be specified before the value.\n"
> +		"# These options may be specified multiple times to configure different values\n"
> +		"# for different SLs.\n"
> +		"#\n"
> +		"# ccti timer - when expires decrements 1 from the CCTI\n"
> +		"# ccti increase - number to be added to the table index on receipt of a BECN\n"
> +		"# trigger threshold - when the ccti is equal to this, an event is logged\n"
> +		"# ccti min - the minimum value for the ccti.  This imposes a minimum rate\n"
> +		"#            on the injection rate\n\n");
> +
> +	for (i = 0; i < IB_CA_CONG_ENTRY_DATA_SIZE; i++) {
> +		/* Don't output unless one of the settings has been set, there's no need
> +		 * to output 16 chunks of this with all defaults of 0 */
> +		if (p_opts->cc_ca_cong_entries[i].ccti_timer
> +		    || p_opts->cc_ca_cong_entries[i].ccti_increase
> +		    || p_opts->cc_ca_cong_entries[i].trigger_threshold
> +		    || p_opts->cc_ca_cong_entries[i].ccti_min) {
> +			fprintf(out,
> +				"# SL = %u\n"
> +				"cc_ca_cong_setting_ccti_timer %u %u\n"
> +				"cc_ca_cong_setting_ccti_increase %u %u\n"
> +				"cc_ca_cong_setting_trigger_threshold %u %u\n"
> +				"cc_ca_cong_setting_ccti_min %u %u\n\n",
> +				i,
> +				i,
> +				cl_ntoh16(p_opts->cc_ca_cong_entries[i].ccti_timer),
> +				i,
> +				p_opts->cc_ca_cong_entries[i].ccti_increase,
> +				i,
> +				p_opts->cc_ca_cong_entries[i].trigger_threshold,
> +				i,
> +				p_opts->cc_ca_cong_entries[i].ccti_min);
> +			cacongoutputcount++;
> +		}
> +	}
> +
> +	/* If by chance all the CA Cong Settings are default, output atleast 1 chunk
> +         * for illustration */
> +	if (!cacongoutputcount)
> +		fprintf(out,
> +			"# SL = 0\n"
> +			"cc_ca_cong_setting_ccti_timer 0 %u\n"
> +			"cc_ca_cong_setting_ccti_increase 0 %u\n"
> +			"cc_ca_cong_setting_trigger_threshold 0 %u\n"
> +			"cc_ca_cong_setting_ccti_min 0 %u\n\n",
> +			cl_ntoh16(p_opts->cc_ca_cong_entries[0].ccti_timer),
> +			p_opts->cc_ca_cong_entries[0].ccti_increase,
> +			p_opts->cc_ca_cong_entries[0].trigger_threshold,
> +			p_opts->cc_ca_cong_entries[0].ccti_min);
> +
> +	fprintf(out,
> +		"#\n# Congestion Control Table\n#\n"
> +		"# Comma separated list of CCT entries representing CCT.\n"
> +		"# Format is shift:multipler,shift_multiplier,shift:multiplier,...\n"
> +		"cc_cct ");
> +
> +	if (!p_opts->cc_cct.entries_len) {
> +		fprintf(out, "%s\n", null_str);
> +	}
> +	else {
> +		fprintf(out, "%u:%u",
> +			p_opts->cc_cct.entries[0].shift,
> +			p_opts->cc_cct.entries[0].multiplier);
> +		for (i = 0; i < p_opts->cc_cct.entries_len; i++) {
> +			fprintf(out, ",%u:%u",
> +				p_opts->cc_cct.entries[0].shift,
> +				p_opts->cc_cct.entries[0].multiplier);
> +		}
> +		fprintf(out, "\n");
> +	}
> +	fprintf(out, "\n");
> +
> +	fprintf(out,
>  		"# Prefix routes file name\n"
>  		"prefix_routes_file %s\n\n",
>  		p_opts->prefix_routes_file);
> -- 
> 1.7.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
