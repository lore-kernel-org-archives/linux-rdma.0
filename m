From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/49] IB/core: Add header definitions
Date: Mon, 31 Aug 2015 11:40:36 -0400
Message-ID: <20150831154035.GA3313@phlsvsds.ph.intel.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com> <20150617122840.8744.38451.stgit@phlsvslse11.ph.intel.com> <55818059.90701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55818059.90701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal,

I'm working on a couple of patches to address these comments.  I will be
submitting them in the next day or so.

On Wed, Jun 17, 2015 at 10:12:41AM -0400, Hal Rosenstock wrote:
> On 6/17/2015 8:28 AM, Mike Marciniszyn wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Add common OPA header definitions for driver
> > build:
> > - opa_port_info.h
> > - opa_smi.h
> > - hfi1_user.sh
> > 
> > Additionally, ib_mad.h, has additional definitions
> > that are common to ib_drivers including:
> > - trap support
> > - cca support
> > 
> > The qib driver has the duplication removed in favor
> > those in ib_mad.h
> > 
> > Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/qib/qib_mad.h |  147 +-----------
> >  include/rdma/ib_mad.h               |  138 +++++++++++
> >  include/rdma/opa_port_info.h        |  433 +++++++++++++++++++++++++++++++++++
> 
> Should opa_port_info.h be in include/rdma or in drivers/infiniband/hw/hfi1 ?

This file and opa_smi.h were placed here following the pattern of the same
ib_*.h files.  Indeed because there is currently only 1 OPA driver it could be
moved to the hfi1 driver directory.  However, I prefer to keep them in rdma.
If Doug prefers I can send a patch to move them.

<snip>

> > +
> > +/*
> > + * Generic trap/notice producers
> > + */
> > +#define IB_NOTICE_PROD_CA		cpu_to_be16(1)
> > +#define IB_NOTICE_PROD_SWITCH		cpu_to_be16(2)
> > +#define IB_NOTICE_PROD_ROUTER		cpu_to_be16(3)
> > +#define IB_NOTICE_PROD_CLASS_MGR	cpu_to_be16(4)
> > +
> > +/*
> > + * Generic trap/notice numbers
> 
> SM Class trap/notice numbers
> 
> As such, should they be in ib_smi.h rather than ib_mad.h ?

Fixed in my patch series.

> 
> > + */
> > +#define IB_NOTICE_TRAP_LLI_THRESH	cpu_to_be16(129)
> > +#define IB_NOTICE_TRAP_EBO_THRESH	cpu_to_be16(130)
> > +#define IB_NOTICE_TRAP_FLOW_UPDATE	cpu_to_be16(131)
> > +#define IB_NOTICE_TRAP_CAP_MASK_CHG	cpu_to_be16(144)
> > +#define IB_NOTICE_TRAP_SYS_GUID_CHG	cpu_to_be16(145)
> > +#define IB_NOTICE_TRAP_BAD_MKEY		cpu_to_be16(256)
> > +#define IB_NOTICE_TRAP_BAD_PKEY		cpu_to_be16(257)
> > +#define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
> > +
> > +/*
> > + * Repress trap/notice flags
> > + */
> > +#define IB_NOTICE_REPRESS_LLI_THRESH	(1 << 0)
> > +#define IB_NOTICE_REPRESS_EBO_THRESH	(1 << 1)
> > +#define IB_NOTICE_REPRESS_FLOW_UPDATE	(1 << 2)
> > +#define IB_NOTICE_REPRESS_CAP_MASK_CHG	(1 << 3)
> > +#define IB_NOTICE_REPRESS_SYS_GUID_CHG	(1 << 4)
> > +#define IB_NOTICE_REPRESS_BAD_MKEY	(1 << 5)
> > +#define IB_NOTICE_REPRESS_BAD_PKEY	(1 << 6)
> > +#define IB_NOTICE_REPRESS_BAD_QKEY	(1 << 7)
> 
> What does this correspond to ? Is this some standard thing or are these
> defines driver specific ?
>

Fixed in my patch series.

> 
> > +
> > +/*
> > + * Generic trap/notice other local changes flags (trap 144).
> 
> SM Class trap/notice other local changes flags (trap 144)
> 
> As such, should they be in ib_smi.h rather than ib_mad.h ?

Fixed in my patch series.

> 
> > + */
> > +#define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
> > +#define IB_NOTICE_TRAP_LWE_CHG		0x02	/* Link Width Enable changed */
> > +#define IB_NOTICE_TRAP_NODE_DESC_CHG	0x01
> > +
> > +/*
> > + * Generic trap/notice M_Key volation flags in dr_trunc_hop (trap 256).
> 
> SM Class trap/notice M_Key violation flags in dr_trunc_hop (trap 256)
> 
> As such, should they be in ib_smi.h rather than ib_mad.h ?

Fixed in my patch series.

> 
> > + */
> > +#define IB_NOTICE_TRAP_DR_NOTICE	0x80
> > +#define IB_NOTICE_TRAP_DR_TRUNC		0x40
> > +
> >  enum {
> >  	IB_MGMT_MAD_HDR = 24,
> >  	IB_MGMT_MAD_DATA = 232,
> > @@ -240,6 +294,90 @@ struct ib_class_port_info {
> >  	__be32			trap_qkey;
> >  };
> >  
> > +struct ib_node_info {
> > +	u8 base_version;
> > +	u8 class_version;
> > +	u8 node_type;
> > +	u8 num_ports;
> > +	__be64 sys_guid;
> > +	__be64 node_guid;
> > +	__be64 port_guid;
> > +	__be16 partition_cap;
> > +	__be16 device_id;
> > +	__be32 revision;
> > +	u8 local_port_num;
> > +	u8 vendor_id[3];
> > +} __packed;
> 
> This is SM attribute. Should it go into ib_smi.h like ib_port_info ?

Fixed in my patch series.

> 
> > +
> > +struct ib_mad_notice_attr {
> > +	u8 generic_type;
> > +	u8 prod_type_msb;
> > +	__be16 prod_type_lsb;
> > +	__be16 trap_num;
> > +	__be16 issuer_lid;
> > +	__be16 toggle_count;
> > +
> > +	union {
> > +		struct {
> > +			u8	details[54];
> > +		} raw_data;
> > +
> > +		struct {
> > +			__be16	reserved;
> > +			__be16	lid;		/* where violation happened */
> > +			u8	port_num;	/* where violation happened */
> > +		} __packed ntc_129_131;
> > +
> > +		struct {
> > +			__be16	reserved;
> > +			__be16	lid;		/* LID where change occurred */
> > +			u8	reserved2;
> > +			u8	local_changes;	/* low bit - local changes */
> > +			__be32	new_cap_mask;	/* new capability mask */
> > +			u8	reserved3;
> > +			u8	change_flags;	/* low 3 bits only */
> 
> I think these 2 fields above should be combined to:
> 			__be16	change_flags;
> per IBA 1.3

Fixed in my patch series, but I want to do some testing so this patch will lag
the others.

> 
> > +		} __packed ntc_144;
> > +
> > +		struct {
> > +			__be16	reserved;
> > +			__be16	lid;		/* lid where sys guid changed */
> > +			__be16	reserved2;
> > +			__be64	new_sys_guid;
> > +		} __packed ntc_145;
> > +
> > +		struct {
> > +			__be16	reserved;
> > +			__be16	lid;
> > +			__be16	dr_slid;
> > +			u8	method;
> > +			u8	reserved2;
> > +			__be16	attr_id;
> > +			__be32	attr_mod;
> > +			__be64	mkey;
> > +			u8	reserved3;
> > +			u8	dr_trunc_hop;
> > +			u8	dr_rtn_path[30];
> > +		} __packed ntc_256;
> > +
> > +		struct {
> > +			__be16		reserved;
> > +			__be16		lid1;
> > +			__be16		lid2;
> > +			__be32		key;
> > +			__be32		sl_qp1;	/* SL: high 4 bits */
> > +			__be32		qp2;	/* high 8 bits reserved */
> > +			union ib_gid	gid1;
> > +			union ib_gid	gid2;
> > +		} __packed ntc_257_258;
> > +
> > +	} details;
> > +};
> > +
> > +struct ib_vl_weight_elem {
> > +	u8      vl;     /* VL is low 5 bits, upper 3 bits reserved */
> 
> Comment is appropriate for OPA. IBA is VL is low 4 bits, upper 4 bits
> reserved.

Fixed in my patch series.

> 
> > +	u8      weight;
> > +};
> 
> As this is SM class attribute, should it be in ib_smi.h rather than
> ib_mad.h ?

Fixed in my patch series.

<snip>

> >  
> > +/* Subnet management attributes */
> > +/* ... */
> > +#define OPA_ATTRIB_ID_NODE_DESCRIPTION		cpu_to_be16(0x0010)
> > +#define OPA_ATTRIB_ID_NODE_INFO			cpu_to_be16(0x0011)
> > +#define OPA_ATTRIB_ID_PORT_INFO			cpu_to_be16(0x0015)
> > +#define OPA_ATTRIB_ID_PARTITION_TABLE		cpu_to_be16(0x0016)
> > +#define OPA_ATTRIB_ID_SL_TO_SC_MAP		cpu_to_be16(0x0017)
> 
> Is this really SL_TO_SC or SL_TO_VL ? The IDs < 0x8000 appear to map to
> IB standard attributes.

This is SL to SC.  Even though these share the same enumeration value these
attributes are only applicable to an OPA device with the OPA Class Version of
the MAD.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
