From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 01/49] IB/core: Add header definitions
Date: Wed, 17 Jun 2015 10:12:41 -0400
Message-ID: <55818059.90701@dev.mellanox.co.il>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com> <20150617122840.8744.38451.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122840.8744.38451.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/17/2015 8:28 AM, Mike Marciniszyn wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add common OPA header definitions for driver
> build:
> - opa_port_info.h
> - opa_smi.h
> - hfi1_user.sh
> 
> Additionally, ib_mad.h, has additional definitions
> that are common to ib_drivers including:
> - trap support
> - cca support
> 
> The qib driver has the duplication removed in favor
> those in ib_mad.h
> 
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_mad.h |  147 +-----------
>  include/rdma/ib_mad.h               |  138 +++++++++++
>  include/rdma/opa_port_info.h        |  433 +++++++++++++++++++++++++++++++++++

Should opa_port_info.h be in include/rdma or in drivers/infiniband/hw/hfi1 ?

>  include/rdma/opa_smi.h              |   47 ++++
>  include/uapi/rdma/hfi/hfi1_user.h   |  427 +++++++++++++++++++++++++++++++++++
>  5 files changed, 1053 insertions(+), 139 deletions(-)
>  create mode 100644 include/rdma/opa_port_info.h
>  create mode 100644 include/uapi/rdma/hfi/hfi1_user.h
> 
> diff --git a/drivers/infiniband/hw/qib/qib_mad.h b/drivers/infiniband/hw/qib/qib_mad.h
> index 941d4d5..57e99dc 100644
> --- a/drivers/infiniband/hw/qib/qib_mad.h
> +++ b/drivers/infiniband/hw/qib/qib_mad.h
> @@ -36,148 +36,17 @@
>  
>  #include <rdma/ib_pma.h>
>  
> -#define IB_SMP_UNSUP_VERSION    cpu_to_be16(0x0004)
> -#define IB_SMP_UNSUP_METHOD     cpu_to_be16(0x0008)
> -#define IB_SMP_UNSUP_METH_ATTR  cpu_to_be16(0x000C)
> -#define IB_SMP_INVALID_FIELD    cpu_to_be16(0x001C)
> +#define IB_SMP_UNSUP_VERSION \
> +cpu_to_be16(IB_MGMT_MAD_STATUS_BAD_VERSION)
>  
> -struct ib_node_info {
> -	u8 base_version;
> -	u8 class_version;
> -	u8 node_type;
> -	u8 num_ports;
> -	__be64 sys_guid;
> -	__be64 node_guid;
> -	__be64 port_guid;
> -	__be16 partition_cap;
> -	__be16 device_id;
> -	__be32 revision;
> -	u8 local_port_num;
> -	u8 vendor_id[3];
> -} __packed;
> -
> -struct ib_mad_notice_attr {
> -	u8 generic_type;
> -	u8 prod_type_msb;
> -	__be16 prod_type_lsb;
> -	__be16 trap_num;
> -	__be16 issuer_lid;
> -	__be16 toggle_count;
> -
> -	union {
> -		struct {
> -			u8	details[54];
> -		} raw_data;
> -
> -		struct {
> -			__be16	reserved;
> -			__be16	lid;		/* where violation happened */
> -			u8	port_num;	/* where violation happened */
> -		} __packed ntc_129_131;
> -
> -		struct {
> -			__be16	reserved;
> -			__be16	lid;		/* LID where change occurred */
> -			u8	reserved2;
> -			u8	local_changes;	/* low bit - local changes */
> -			__be32	new_cap_mask;	/* new capability mask */
> -			u8	reserved3;
> -			u8	change_flags;	/* low 3 bits only */
> -		} __packed ntc_144;
> -
> -		struct {
> -			__be16	reserved;
> -			__be16	lid;		/* lid where sys guid changed */
> -			__be16	reserved2;
> -			__be64	new_sys_guid;
> -		} __packed ntc_145;
> -
> -		struct {
> -			__be16	reserved;
> -			__be16	lid;
> -			__be16	dr_slid;
> -			u8	method;
> -			u8	reserved2;
> -			__be16	attr_id;
> -			__be32	attr_mod;
> -			__be64	mkey;
> -			u8	reserved3;
> -			u8	dr_trunc_hop;
> -			u8	dr_rtn_path[30];
> -		} __packed ntc_256;
> -
> -		struct {
> -			__be16		reserved;
> -			__be16		lid1;
> -			__be16		lid2;
> -			__be32		key;
> -			__be32		sl_qp1;	/* SL: high 4 bits */
> -			__be32		qp2;	/* high 8 bits reserved */
> -			union ib_gid	gid1;
> -			union ib_gid	gid2;
> -		} __packed ntc_257_258;
> -
> -	} details;
> -};
> -
> -/*
> - * Generic trap/notice types
> - */
> -#define IB_NOTICE_TYPE_FATAL	0x80
> -#define IB_NOTICE_TYPE_URGENT	0x81
> -#define IB_NOTICE_TYPE_SECURITY	0x82
> -#define IB_NOTICE_TYPE_SM	0x83
> -#define IB_NOTICE_TYPE_INFO	0x84
> +#define IB_SMP_UNSUP_METHOD \
> +cpu_to_be16(IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD)
>  
> -/*
> - * Generic trap/notice producers
> - */
> -#define IB_NOTICE_PROD_CA		cpu_to_be16(1)
> -#define IB_NOTICE_PROD_SWITCH		cpu_to_be16(2)
> -#define IB_NOTICE_PROD_ROUTER		cpu_to_be16(3)
> -#define IB_NOTICE_PROD_CLASS_MGR	cpu_to_be16(4)
> +#define IB_SMP_UNSUP_METH_ATTR \
> +cpu_to_be16(IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB)
>  
> -/*
> - * Generic trap/notice numbers
> - */
> -#define IB_NOTICE_TRAP_LLI_THRESH	cpu_to_be16(129)
> -#define IB_NOTICE_TRAP_EBO_THRESH	cpu_to_be16(130)
> -#define IB_NOTICE_TRAP_FLOW_UPDATE	cpu_to_be16(131)
> -#define IB_NOTICE_TRAP_CAP_MASK_CHG	cpu_to_be16(144)
> -#define IB_NOTICE_TRAP_SYS_GUID_CHG	cpu_to_be16(145)
> -#define IB_NOTICE_TRAP_BAD_MKEY		cpu_to_be16(256)
> -#define IB_NOTICE_TRAP_BAD_PKEY		cpu_to_be16(257)
> -#define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
> -
> -/*
> - * Repress trap/notice flags
> - */
> -#define IB_NOTICE_REPRESS_LLI_THRESH	(1 << 0)
> -#define IB_NOTICE_REPRESS_EBO_THRESH	(1 << 1)
> -#define IB_NOTICE_REPRESS_FLOW_UPDATE	(1 << 2)
> -#define IB_NOTICE_REPRESS_CAP_MASK_CHG	(1 << 3)
> -#define IB_NOTICE_REPRESS_SYS_GUID_CHG	(1 << 4)
> -#define IB_NOTICE_REPRESS_BAD_MKEY	(1 << 5)
> -#define IB_NOTICE_REPRESS_BAD_PKEY	(1 << 6)
> -#define IB_NOTICE_REPRESS_BAD_QKEY	(1 << 7)
> -
> -/*
> - * Generic trap/notice other local changes flags (trap 144).
> - */
> -#define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
> -#define IB_NOTICE_TRAP_LWE_CHG		0x02	/* Link Width Enable changed */
> -#define IB_NOTICE_TRAP_NODE_DESC_CHG	0x01
> -
> -/*
> - * Generic trap/notice M_Key volation flags in dr_trunc_hop (trap 256).
> - */
> -#define IB_NOTICE_TRAP_DR_NOTICE	0x80
> -#define IB_NOTICE_TRAP_DR_TRUNC		0x40
> -
> -struct ib_vl_weight_elem {
> -	u8      vl;     /* Only low 4 bits, upper 4 bits reserved */
> -	u8      weight;
> -};
> +#define IB_SMP_INVALID_FIELD \
> +cpu_to_be16(IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE)
>  
>  #define IB_VLARB_LOWPRI_0_31    1
>  #define IB_VLARB_LOWPRI_32_63   2
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index c8422d5..d5ac022 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -127,6 +127,60 @@
>  #define IB_DEFAULT_PKEY_PARTIAL 0x7FFF
>  #define IB_DEFAULT_PKEY_FULL	0xFFFF
>  
> +/*
> + * Generic trap/notice types
> + */
> +#define IB_NOTICE_TYPE_FATAL	0x80
> +#define IB_NOTICE_TYPE_URGENT	0x81
> +#define IB_NOTICE_TYPE_SECURITY	0x82
> +#define IB_NOTICE_TYPE_SM	0x83
> +#define IB_NOTICE_TYPE_INFO	0x84
> +
> +/*
> + * Generic trap/notice producers
> + */
> +#define IB_NOTICE_PROD_CA		cpu_to_be16(1)
> +#define IB_NOTICE_PROD_SWITCH		cpu_to_be16(2)
> +#define IB_NOTICE_PROD_ROUTER		cpu_to_be16(3)
> +#define IB_NOTICE_PROD_CLASS_MGR	cpu_to_be16(4)
> +
> +/*
> + * Generic trap/notice numbers

SM Class trap/notice numbers

As such, should they be in ib_smi.h rather than ib_mad.h ?

> + */
> +#define IB_NOTICE_TRAP_LLI_THRESH	cpu_to_be16(129)
> +#define IB_NOTICE_TRAP_EBO_THRESH	cpu_to_be16(130)
> +#define IB_NOTICE_TRAP_FLOW_UPDATE	cpu_to_be16(131)
> +#define IB_NOTICE_TRAP_CAP_MASK_CHG	cpu_to_be16(144)
> +#define IB_NOTICE_TRAP_SYS_GUID_CHG	cpu_to_be16(145)
> +#define IB_NOTICE_TRAP_BAD_MKEY		cpu_to_be16(256)
> +#define IB_NOTICE_TRAP_BAD_PKEY		cpu_to_be16(257)
> +#define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
> +
> +/*
> + * Repress trap/notice flags
> + */
> +#define IB_NOTICE_REPRESS_LLI_THRESH	(1 << 0)
> +#define IB_NOTICE_REPRESS_EBO_THRESH	(1 << 1)
> +#define IB_NOTICE_REPRESS_FLOW_UPDATE	(1 << 2)
> +#define IB_NOTICE_REPRESS_CAP_MASK_CHG	(1 << 3)
> +#define IB_NOTICE_REPRESS_SYS_GUID_CHG	(1 << 4)
> +#define IB_NOTICE_REPRESS_BAD_MKEY	(1 << 5)
> +#define IB_NOTICE_REPRESS_BAD_PKEY	(1 << 6)
> +#define IB_NOTICE_REPRESS_BAD_QKEY	(1 << 7)

What does this correspond to ? Is this some standard thing or are these
defines driver specific ?

> +
> +/*
> + * Generic trap/notice other local changes flags (trap 144).

SM Class trap/notice other local changes flags (trap 144)

As such, should they be in ib_smi.h rather than ib_mad.h ?

> + */
> +#define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
> +#define IB_NOTICE_TRAP_LWE_CHG		0x02	/* Link Width Enable changed */
> +#define IB_NOTICE_TRAP_NODE_DESC_CHG	0x01
> +
> +/*
> + * Generic trap/notice M_Key volation flags in dr_trunc_hop (trap 256).

SM Class trap/notice M_Key violation flags in dr_trunc_hop (trap 256)

As such, should they be in ib_smi.h rather than ib_mad.h ?

> + */
> +#define IB_NOTICE_TRAP_DR_NOTICE	0x80
> +#define IB_NOTICE_TRAP_DR_TRUNC		0x40
> +
>  enum {
>  	IB_MGMT_MAD_HDR = 24,
>  	IB_MGMT_MAD_DATA = 232,
> @@ -240,6 +294,90 @@ struct ib_class_port_info {
>  	__be32			trap_qkey;
>  };
>  
> +struct ib_node_info {
> +	u8 base_version;
> +	u8 class_version;
> +	u8 node_type;
> +	u8 num_ports;
> +	__be64 sys_guid;
> +	__be64 node_guid;
> +	__be64 port_guid;
> +	__be16 partition_cap;
> +	__be16 device_id;
> +	__be32 revision;
> +	u8 local_port_num;
> +	u8 vendor_id[3];
> +} __packed;

This is SM attribute. Should it go into ib_smi.h like ib_port_info ?

> +
> +struct ib_mad_notice_attr {
> +	u8 generic_type;
> +	u8 prod_type_msb;
> +	__be16 prod_type_lsb;
> +	__be16 trap_num;
> +	__be16 issuer_lid;
> +	__be16 toggle_count;
> +
> +	union {
> +		struct {
> +			u8	details[54];
> +		} raw_data;
> +
> +		struct {
> +			__be16	reserved;
> +			__be16	lid;		/* where violation happened */
> +			u8	port_num;	/* where violation happened */
> +		} __packed ntc_129_131;
> +
> +		struct {
> +			__be16	reserved;
> +			__be16	lid;		/* LID where change occurred */
> +			u8	reserved2;
> +			u8	local_changes;	/* low bit - local changes */
> +			__be32	new_cap_mask;	/* new capability mask */
> +			u8	reserved3;
> +			u8	change_flags;	/* low 3 bits only */

I think these 2 fields above should be combined to:
			__be16	change_flags;
per IBA 1.3

> +		} __packed ntc_144;
> +
> +		struct {
> +			__be16	reserved;
> +			__be16	lid;		/* lid where sys guid changed */
> +			__be16	reserved2;
> +			__be64	new_sys_guid;
> +		} __packed ntc_145;
> +
> +		struct {
> +			__be16	reserved;
> +			__be16	lid;
> +			__be16	dr_slid;
> +			u8	method;
> +			u8	reserved2;
> +			__be16	attr_id;
> +			__be32	attr_mod;
> +			__be64	mkey;
> +			u8	reserved3;
> +			u8	dr_trunc_hop;
> +			u8	dr_rtn_path[30];
> +		} __packed ntc_256;
> +
> +		struct {
> +			__be16		reserved;
> +			__be16		lid1;
> +			__be16		lid2;
> +			__be32		key;
> +			__be32		sl_qp1;	/* SL: high 4 bits */
> +			__be32		qp2;	/* high 8 bits reserved */
> +			union ib_gid	gid1;
> +			union ib_gid	gid2;
> +		} __packed ntc_257_258;
> +
> +	} details;
> +};
> +
> +struct ib_vl_weight_elem {
> +	u8      vl;     /* VL is low 5 bits, upper 3 bits reserved */

Comment is appropriate for OPA. IBA is VL is low 4 bits, upper 4 bits
reserved.

> +	u8      weight;
> +};

As this is SM class attribute, should it be in ib_smi.h rather than
ib_mad.h ?

> +
>  /**
>   * ib_mad_send_buf - MAD data buffer and work request for sends.
>   * @next: A pointer used to chain together MADs for posting.
> diff --git a/include/rdma/opa_port_info.h b/include/rdma/opa_port_info.h
> new file mode 100644
> index 0000000..391dae1
> --- /dev/null
> +++ b/include/rdma/opa_port_info.h
> @@ -0,0 +1,433 @@
> +/*
> + * Copyright (c) 2014 Intel Corporation.  All rights reserved.
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
> + */
> +
> +#if !defined(OPA_PORT_INFO_H)
> +#define OPA_PORT_INFO_H
> +
> +/* Temporary until HFI driver is updated */
> +#ifndef USE_PI_LED_ENABLE
> +#define USE_PI_LED_ENABLE 0
> +#endif
> +
> +#define OPA_PORT_LINK_MODE_NOP	0		/* No change */
> +#define OPA_PORT_LINK_MODE_OPA	4		/* Port mode is OPA */
> +
> +#define OPA_PORT_PACKET_FORMAT_NOP	0		/* No change */
> +#define OPA_PORT_PACKET_FORMAT_8B	1		/* Format 8B */
> +#define OPA_PORT_PACKET_FORMAT_9B	2		/* Format 9B */
> +#define OPA_PORT_PACKET_FORMAT_10B	4		/* Format 10B */
> +#define OPA_PORT_PACKET_FORMAT_16B	8		/* Format 16B */
> +
> +#define OPA_PORT_LTP_CRC_MODE_NONE	0	/* No change */
> +#define OPA_PORT_LTP_CRC_MODE_14	1	/* 14-bit LTP CRC mode (optional) */
> +#define OPA_PORT_LTP_CRC_MODE_16	2	/* 16-bit LTP CRC mode */
> +#define OPA_PORT_LTP_CRC_MODE_48	4	/* 48-bit LTP CRC mode (optional) */
> +#define OPA_PORT_LTP_CRC_MODE_PER_LANE  8	/* 12/16-bit per lane LTP CRC mode */
> +
> +/* Link Down / Neighbor Link Down Reason; indicated as follows: */
> +#define OPA_LINKDOWN_REASON_NONE				0	/* No specified reason */
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_0				1
> +#define OPA_LINKDOWN_REASON_BAD_PKT_LEN				2
> +#define OPA_LINKDOWN_REASON_PKT_TOO_LONG			3
> +#define OPA_LINKDOWN_REASON_PKT_TOO_SHORT			4
> +#define OPA_LINKDOWN_REASON_BAD_SLID				5
> +#define OPA_LINKDOWN_REASON_BAD_DLID				6
> +#define OPA_LINKDOWN_REASON_BAD_L2				7
> +#define OPA_LINKDOWN_REASON_BAD_SC				8
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_8				9
> +#define OPA_LINKDOWN_REASON_BAD_MID_TAIL			10
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_10			11
> +#define OPA_LINKDOWN_REASON_PREEMPT_ERROR			12
> +#define OPA_LINKDOWN_REASON_PREEMPT_VL15			13
> +#define OPA_LINKDOWN_REASON_BAD_VL_MARKER			14
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_14			15
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_15			16
> +#define OPA_LINKDOWN_REASON_BAD_HEAD_DIST			17
> +#define OPA_LINKDOWN_REASON_BAD_TAIL_DIST			18
> +#define OPA_LINKDOWN_REASON_BAD_CTRL_DIST			19
> +#define OPA_LINKDOWN_REASON_BAD_CREDIT_ACK			20
> +#define OPA_LINKDOWN_REASON_UNSUPPORTED_VL_MARKER		21
> +#define OPA_LINKDOWN_REASON_BAD_PREEMPT				22
> +#define OPA_LINKDOWN_REASON_BAD_CONTROL_FLIT			23
> +#define OPA_LINKDOWN_REASON_EXCEED_MULTICAST_LIMIT		24
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_24			25
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_25			26
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_26			27
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_27			28
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_28			29
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_29			30
> +#define OPA_LINKDOWN_REASON_RCV_ERROR_30			31
> +#define OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN		32
> +#define OPA_LINKDOWN_REASON_UNKNOWN				33
> +/* 34 -reserved */
> +#define OPA_LINKDOWN_REASON_REBOOT				35
> +#define OPA_LINKDOWN_REASON_NEIGHBOR_UNKNOWN			36
> +/* 37-38 reserved */
> +#define OPA_LINKDOWN_REASON_FM_BOUNCE				39
> +#define OPA_LINKDOWN_REASON_SPEED_POLICY			40
> +#define OPA_LINKDOWN_REASON_WIDTH_POLICY			41
> +/* 42-48 reserved */
> +#define OPA_LINKDOWN_REASON_DISCONNECTED			49
> +#define OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED		50
> +#define OPA_LINKDOWN_REASON_NOT_INSTALLED			51
> +#define OPA_LINKDOWN_REASON_CHASSIS_CONFIG			52
> +/* 53 reserved */
> +#define OPA_LINKDOWN_REASON_END_TO_END_NOT_INSTALLED		54
> +/* 55 reserved */
> +#define OPA_LINKDOWN_REASON_POWER_POLICY			56
> +#define OPA_LINKDOWN_REASON_LINKSPEED_POLICY			57
> +#define OPA_LINKDOWN_REASON_LINKWIDTH_POLICY			58
> +/* 59 reserved */
> +#define OPA_LINKDOWN_REASON_SWITCH_MGMT				60
> +#define OPA_LINKDOWN_REASON_SMA_DISABLED			61
> +/* 62 reserved */
> +#define OPA_LINKDOWN_REASON_TRANSIENT				63
> +/* 64-255 reserved */
> +
> +/* OPA Link Init reason; indicated as follows: */
> +/* 3-7; 11-15 reserved; 8-15 cleared on Polling->LinkUp */
> +#define OPA_LINKINIT_REASON_NOP                 0
> +#define OPA_LINKINIT_REASON_LINKUP              (1 << 4)
> +#define OPA_LINKINIT_REASON_FLAPPING            (2 << 4)
> +#define OPA_LINKINIT_REASON_CLEAR               (8 << 4)
> +#define OPA_LINKINIT_OUTSIDE_POLICY             (8 << 4)
> +#define OPA_LINKINIT_QUARANTINED                (9 << 4)
> +#define OPA_LINKINIT_INSUFIC_CAPABILITY         (10 << 4)
> +
> +#define OPA_LINK_SPEED_NOP              0x0000  /*  Reserved (1-5 Gbps) */
> +#define OPA_LINK_SPEED_12_5G            0x0001  /*  12.5 Gbps */
> +#define OPA_LINK_SPEED_25G              0x0002  /*  25.78125?  Gbps (EDR) */
> +
> +#define OPA_LINK_WIDTH_1X            0x0001
> +#define OPA_LINK_WIDTH_2X            0x0002
> +#define OPA_LINK_WIDTH_3X            0x0004
> +#define OPA_LINK_WIDTH_4X            0x0008
> +
> +#define OPA_CAP_MASK3_IsSnoopSupported            (1 << 7)
> +#define OPA_CAP_MASK3_IsAsyncSC2VLSupported       (1 << 6)
> +#define OPA_CAP_MASK3_IsAddrRangeConfigSupported  (1 << 5)
> +#define OPA_CAP_MASK3_IsPassThroughSupported      (1 << 4)
> +#define OPA_CAP_MASK3_IsSharedSpaceSupported      (1 << 3)
> +/* reserved (1 << 2) */
> +#define OPA_CAP_MASK3_IsVLMarkerSupported         (1 << 1)
> +#define OPA_CAP_MASK3_IsVLrSupported              (1 << 0)
> +
> +/**
> + * new MTU values
> + */
> +enum {
> +	OPA_MTU_8192  = 6,
> +	OPA_MTU_10240 = 7,
> +};
> +
> +enum {
> +	OPA_PORT_PHYS_CONF_DISCONNECTED = 0,
> +	OPA_PORT_PHYS_CONF_STANDARD     = 1,
> +	OPA_PORT_PHYS_CONF_FIXED        = 2,
> +	OPA_PORT_PHYS_CONF_VARIABLE     = 3,
> +	OPA_PORT_PHYS_CONF_SI_PHOTO     = 4
> +};
> +
> +enum port_info_field_masks {
> +	/* vl.cap */
> +	OPA_PI_MASK_VL_CAP                        = 0x1F,
> +	/* port_states.ledenable_offlinereason */
> +	OPA_PI_MASK_OFFLINE_REASON                = 0x0F,
> +	OPA_PI_MASK_LED_ENABLE                    = 0x40,
> +	/* port_states.unsleepstate_downdefstate */
> +	OPA_PI_MASK_UNSLEEP_STATE                 = 0xF0,
> +	OPA_PI_MASK_DOWNDEF_STATE                 = 0x0F,
> +	/* port_states.portphysstate_portstate */
> +	OPA_PI_MASK_PORT_PHYSICAL_STATE           = 0xF0,
> +	OPA_PI_MASK_PORT_STATE                    = 0x0F,
> +	/* port_phys_conf */
> +	OPA_PI_MASK_PORT_PHYSICAL_CONF            = 0x0F,
> +	/* collectivemask_multicastmask */
> +	OPA_PI_MASK_COLLECT_MASK                  = 0x38,
> +	OPA_PI_MASK_MULTICAST_MASK                = 0x07,
> +	/* mkeyprotect_lmc */
> +	OPA_PI_MASK_MKEY_PROT_BIT                 = 0xC0,
> +	OPA_PI_MASK_LMC                           = 0x0F,
> +	/* smsl */
> +	OPA_PI_MASK_SMSL                          = 0x1F,
> +	/* partenforce_filterraw */
> +	/* Filter Raw In/Out bits 1 and 2 were removed */
> +	OPA_PI_MASK_LINKINIT_REASON               = 0xF0,
> +	OPA_PI_MASK_PARTITION_ENFORCE_IN          = 0x08,
> +	OPA_PI_MASK_PARTITION_ENFORCE_OUT         = 0x04,
> +	/* operational_vls */
> +	OPA_PI_MASK_OPERATIONAL_VL                = 0x1F,
> +	/* sa_qp */
> +	OPA_PI_MASK_SA_QP                         = 0x00FFFFFF,
> +	/* sm_trap_qp */
> +	OPA_PI_MASK_SM_TRAP_QP                    = 0x00FFFFFF,
> +	/* localphy_overrun_errors */
> +	OPA_PI_MASK_LOCAL_PHY_ERRORS              = 0xF0,
> +	OPA_PI_MASK_OVERRUN_ERRORS                = 0x0F,
> +	/* clientrereg_subnettimeout */
> +	OPA_PI_MASK_CLIENT_REREGISTER             = 0x80,
> +	OPA_PI_MASK_SUBNET_TIMEOUT                = 0x1F,
> +	/* port_link_mode */
> +	OPA_PI_MASK_PORT_LINK_SUPPORTED           = (0x001F << 10),
> +	OPA_PI_MASK_PORT_LINK_ENABLED             = (0x001F <<  5),
> +	OPA_PI_MASK_PORT_LINK_ACTIVE              = (0x001F <<  0),
> +	/* port_link_crc_mode */
> +	OPA_PI_MASK_PORT_LINK_CRC_SUPPORTED       = 0x0F00,
> +	OPA_PI_MASK_PORT_LINK_CRC_ENABLED         = 0x00F0,
> +	OPA_PI_MASK_PORT_LINK_CRC_ACTIVE          = 0x000F,
> +	/* port_mode */
> +	OPA_PI_MASK_PORT_MODE_SECURITY_CHECK      = 0x0001,
> +	OPA_PI_MASK_PORT_MODE_16B_TRAP_QUERY      = 0x0002,
> +	OPA_PI_MASK_PORT_MODE_PKEY_CONVERT        = 0x0004,
> +	OPA_PI_MASK_PORT_MODE_SC2SC_MAPPING       = 0x0008,
> +	OPA_PI_MASK_PORT_MODE_VL_MARKER           = 0x0010,
> +	OPA_PI_MASK_PORT_PASS_THROUGH             = 0x0020,
> +	OPA_PI_MASK_PORT_ACTIVE_OPTOMIZE          = 0x0040,
> +	/* flit_control.interleave */
> +	OPA_PI_MASK_INTERLEAVE_DIST_SUP           = (0x0003 << 12),
> +	OPA_PI_MASK_INTERLEAVE_DIST_ENABLE        = (0x0003 << 10),
> +	OPA_PI_MASK_INTERLEAVE_MAX_NEST_TX        = (0x001F <<  5),
> +	OPA_PI_MASK_INTERLEAVE_MAX_NEST_RX        = (0x001F <<  0),
> +
> +	/* port_error_action */
> +	OPA_PI_MASK_EX_BUFFER_OVERRUN                  = 0x80000000,
> +		/* 7 bits reserved */
> +	OPA_PI_MASK_FM_CFG_ERR_EXCEED_MULTICAST_LIMIT  = 0x00800000,
> +	OPA_PI_MASK_FM_CFG_BAD_CONTROL_FLIT            = 0x00400000,
> +	OPA_PI_MASK_FM_CFG_BAD_PREEMPT                 = 0x00200000,
> +	OPA_PI_MASK_FM_CFG_UNSUPPORTED_VL_MARKER       = 0x00100000,
> +	OPA_PI_MASK_FM_CFG_BAD_CRDT_ACK                = 0x00080000,
> +	OPA_PI_MASK_FM_CFG_BAD_CTRL_DIST               = 0x00040000,
> +	OPA_PI_MASK_FM_CFG_BAD_TAIL_DIST               = 0x00020000,
> +	OPA_PI_MASK_FM_CFG_BAD_HEAD_DIST               = 0x00010000,
> +		/* 2 bits reserved */
> +	OPA_PI_MASK_PORT_RCV_BAD_VL_MARKER             = 0x00002000,
> +	OPA_PI_MASK_PORT_RCV_PREEMPT_VL15              = 0x00001000,
> +	OPA_PI_MASK_PORT_RCV_PREEMPT_ERROR             = 0x00000800,
> +		/* 1 bit reserved */
> +	OPA_PI_MASK_PORT_RCV_BAD_MidTail               = 0x00000200,
> +		/* 1 bit reserved */
> +	OPA_PI_MASK_PORT_RCV_BAD_SC                    = 0x00000080,
> +	OPA_PI_MASK_PORT_RCV_BAD_L2                    = 0x00000040,
> +	OPA_PI_MASK_PORT_RCV_BAD_DLID                  = 0x00000020,
> +	OPA_PI_MASK_PORT_RCV_BAD_SLID                  = 0x00000010,
> +	OPA_PI_MASK_PORT_RCV_PKTLEN_TOOSHORT           = 0x00000008,
> +	OPA_PI_MASK_PORT_RCV_PKTLEN_TOOLONG            = 0x00000004,
> +	OPA_PI_MASK_PORT_RCV_BAD_PKTLEN                = 0x00000002,
> +	OPA_PI_MASK_PORT_RCV_BAD_LT                    = 0x00000001,
> +
> +	/* pass_through.res_drctl */
> +	OPA_PI_MASK_PASS_THROUGH_DR_CONTROL       = 0x01,
> +
> +	/* buffer_units */
> +	OPA_PI_MASK_BUF_UNIT_VL15_INIT            = (0x00000FFF  << 11),
> +	OPA_PI_MASK_BUF_UNIT_VL15_CREDIT_RATE     = (0x0000001F  <<  6),
> +	OPA_PI_MASK_BUF_UNIT_CREDIT_ACK           = (0x00000003  <<  3),
> +	OPA_PI_MASK_BUF_UNIT_BUF_ALLOC            = (0x00000003  <<  0),
> +
> +	/* neigh_mtu.pvlx_to_mtu */
> +	OPA_PI_MASK_NEIGH_MTU_PVL0                = 0xF0,
> +	OPA_PI_MASK_NEIGH_MTU_PVL1                = 0x0F,
> +
> +	/* neigh_mtu.vlstall_hoq_life */
> +	OPA_PI_MASK_VL_STALL                      = (0x03 << 5),
> +	OPA_PI_MASK_HOQ_LIFE                      = (0x1F << 0),
> +
> +	/* port_neigh_mode */
> +	OPA_PI_MASK_NEIGH_MGMT_ALLOWED            = (0x01 << 3),
> +	OPA_PI_MASK_NEIGH_FW_AUTH_BYPASS          = (0x01 << 2),
> +	OPA_PI_MASK_NEIGH_NODE_TYPE               = (0x03 << 0),
> +
> +	/* resptime_value */
> +	OPA_PI_MASK_RESPONSE_TIME_VALUE           = 0x1F,
> +
> +	/* mtucap */
> +	OPA_PI_MASK_MTU_CAP                       = 0x0F,
> +};
> +
> +#if USE_PI_LED_ENABLE
> +struct opa_port_states {
> +	u8     reserved;
> +	u8     ledenable_offlinereason;   /* 1 res, 1 bit, 6 bits */
> +	u8     reserved2;
> +	u8     portphysstate_portstate;   /* 4 bits, 4 bits */
> +};
> +#define PI_LED_ENABLE_SUP 1
> +#else
> +struct opa_port_states {
> +	u8     reserved;
> +	u8     offline_reason;            /* 2 res, 6 bits */
> +	u8     reserved2;
> +	u8     portphysstate_portstate;   /* 4 bits, 4 bits */
> +};
> +#define PI_LED_ENABLE_SUP 0
> +#endif
> +
> +struct opa_port_state_info {
> +	struct opa_port_states port_states;
> +	u16 link_width_downgrade_tx_active;
> +	u16 link_width_downgrade_rx_active;
> +};
> +
> +struct opa_port_info {
> +	__be32 lid;
> +	__be32 flow_control_mask;
> +
> +	struct {
> +		u8     res;                       /* was inittype */
> +		u8     cap;                       /* 3 res, 5 bits */
> +		__be16 high_limit;
> +		__be16 preempt_limit;
> +		u8     arb_high_cap;
> +		u8     arb_low_cap;
> +	} vl;
> +
> +	struct opa_port_states  port_states;
> +	u8     port_phys_conf;                    /* 4 res, 4 bits */
> +	u8     collectivemask_multicastmask;      /* 2 res, 3, 3 */
> +	u8     mkeyprotect_lmc;                   /* 2 bits, 2 res, 4 bits */
> +	u8     smsl;                              /* 3 res, 5 bits */
> +
> +	u8     partenforce_filterraw;             /* bit fields */
> +	u8     operational_vls;                    /* 3 res, 5 bits */
> +	__be16 pkey_8b;
> +	__be16 pkey_10b;
> +	__be16 mkey_violations;
> +
> +	__be16 pkey_violations;
> +	__be16 qkey_violations;
> +	__be32 sm_trap_qp;                        /* 8 bits, 24 bits */
> +
> +	__be32 sa_qp;                             /* 8 bits, 24 bits */
> +	u8     neigh_port_num;
> +	u8     link_down_reason;
> +	u8     neigh_link_down_reason;
> +	u8     clientrereg_subnettimeout;	  /* 1 bit, 2 bits, 5 */
> +
> +	struct {
> +		__be16 supported;
> +		__be16 enabled;
> +		__be16 active;
> +	} link_speed;
> +	struct {
> +		__be16 supported;
> +		__be16 enabled;
> +		__be16 active;
> +	} link_width;
> +	struct {
> +		__be16 supported;
> +		__be16 enabled;
> +		__be16 tx_active;
> +		__be16 rx_active;
> +	} link_width_downgrade;
> +	__be16 port_link_mode;                  /* 1 res, 5 bits, 5 bits, 5 bits */
> +	__be16 port_ltp_crc_mode;               /* 4 res, 4 bits, 4 bits, 4 bits */
> +
> +	__be16 port_mode;                       /* 9 res, bit fields */
> +	struct {
> +		__be16 supported;
> +		__be16 enabled;
> +	} port_packet_format;
> +	struct {
> +		__be16 interleave;  /* 2 res, 2,2,5,5 */
> +		struct {
> +			__be16 min_initial;
> +			__be16 min_tail;
> +			u8     large_pkt_limit;
> +			u8     small_pkt_limit;
> +			u8     max_small_pkt_limit;
> +			u8     preemption_limit;
> +		} preemption;
> +	} flit_control;
> +
> +	__be32 reserved4;
> +	__be32 port_error_action; /* bit field */
> +
> +	struct {
> +		u8 egress_port;
> +		u8 res_drctl;                    /* 7 res, 1 */
> +	} pass_through;
> +	__be16 mkey_lease_period;
> +	__be32 buffer_units;                     /* 9 res, 12, 5, 3, 3 */
> +
> +	__be32 reserved5;
> +	__be32 sm_lid;
> +
> +	__be64 mkey;
> +
> +	__be64 subnet_prefix;
> +
> +	struct {
> +		u8 pvlx_to_mtu[OPA_MAX_VLS/2]; /* 4 bits, 4 bits */
> +	} neigh_mtu;
> +
> +	struct {
> +		u8 vlstall_hoqlife;             /* 3 bits, 5 bits */
> +	} xmit_q[OPA_MAX_VLS];
> +
> +	struct {
> +		u8 addr[16];
> +	} ipaddr_ipv6;
> +
> +	struct {
> +		u8 addr[4];
> +	} ipaddr_ipv4;
> +
> +	u32    reserved6;
> +	u32    reserved7;
> +	u32    reserved8;
> +
> +	__be64 neigh_node_guid;
> +
> +	__be32 ib_cap_mask;
> +	__be16 reserved9;                    /* was ib_cap_mask2 */
> +	__be16 opa_cap_mask;
> +
> +	__be32 reserved10;                   /* was link_roundtrip_latency */
> +	__be16 overall_buffer_space;
> +	__be16 reserved11;                   /* was max_credit_hint */
> +
> +	__be16 diag_code;
> +	struct {
> +		u8 buffer;
> +		u8 wire;
> +	} replay_depth;
> +	u8     port_neigh_mode;
> +	u8     mtucap;                          /* 4 res, 4 bits */
> +
> +	u8     resptimevalue;		        /* 3 res, 5 bits */
> +	u8     local_port_num;
> +	u8     reserved12;
> +	u8     reserved13;                       /* was guid_cap */
> +} __attribute__ ((packed));
> +
> +#endif /* OPA_PORT_INFO_H */
> diff --git a/include/rdma/opa_smi.h b/include/rdma/opa_smi.h
> index 29063e8..4a529ef 100644
> --- a/include/rdma/opa_smi.h
> +++ b/include/rdma/opa_smi.h
> @@ -40,6 +40,10 @@
>  #define OPA_SMP_DR_DATA_SIZE			1872
>  #define OPA_SMP_MAX_PATH_HOPS			64
>  
> +#define OPA_MAX_VLS				32
> +#define OPA_MAX_SLS				32
> +#define OPA_MAX_SCS				32
> +
>  #define OPA_SMI_CLASS_VERSION			0x80
>  
>  #define OPA_LID_PERMISSIVE			cpu_to_be32(0xFFFFFFFF)
> @@ -73,6 +77,49 @@ struct opa_smp {
>  } __packed;
>  
>  
> +/* Subnet management attributes */
> +/* ... */
> +#define OPA_ATTRIB_ID_NODE_DESCRIPTION		cpu_to_be16(0x0010)
> +#define OPA_ATTRIB_ID_NODE_INFO			cpu_to_be16(0x0011)
> +#define OPA_ATTRIB_ID_PORT_INFO			cpu_to_be16(0x0015)
> +#define OPA_ATTRIB_ID_PARTITION_TABLE		cpu_to_be16(0x0016)
> +#define OPA_ATTRIB_ID_SL_TO_SC_MAP		cpu_to_be16(0x0017)

Is this really SL_TO_SC or SL_TO_VL ? The IDs < 0x8000 appear to map to
IB standard attributes.

> +#define OPA_ATTRIB_ID_VL_ARBITRATION		cpu_to_be16(0x0018)
> +#define OPA_ATTRIB_ID_SM_INFO			cpu_to_be16(0x0020)
> +#define OPA_ATTRIB_ID_CABLE_INFO		cpu_to_be16(0x0032)
> +#define OPA_ATTRIB_ID_AGGREGATE			cpu_to_be16(0x0080)
> +#define OPA_ATTRIB_ID_SC_TO_SL_MAP		cpu_to_be16(0x0082)
> +#define OPA_ATTRIB_ID_SC_TO_VLR_MAP		cpu_to_be16(0x0083)
> +#define OPA_ATTRIB_ID_SC_TO_VLT_MAP		cpu_to_be16(0x0084)
> +#define OPA_ATTRIB_ID_SC_TO_VLNT_MAP		cpu_to_be16(0x0085)
> +/* ... */
> +#define OPA_ATTRIB_ID_PORT_STATE_INFO		cpu_to_be16(0x0087)
> +/* ... */
> +#define OPA_ATTRIB_ID_BUFFER_CONTROL_TABLE	cpu_to_be16(0x008A)
> +/* ... */
> +
> +struct opa_node_description {
> +	u8 data[64];
> +} __attribute__ ((packed));
> +
> +struct opa_node_info {
> +	u8      base_version;
> +	u8      class_version;
> +	u8      node_type;
> +	u8      num_ports;
> +	__be32  reserved;
> +	__be64  system_image_guid;
> +	__be64  node_guid;
> +	__be64  port_guid;
> +	__be16  partition_cap;
> +	__be16  device_id;
> +	__be32  revision;
> +	u8      local_port_num;
> +	u8      vendor_id[3];   /* network byte order */
> +} __attribute__ ((packed));
> +
> +#define OPA_PARTITION_TABLE_BLK_SIZE 32
> +
>  static inline u8
>  opa_get_smp_direction(struct opa_smp *smp)
>  {


<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
