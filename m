From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 7/9] ib/pma: add include file for IBA performance
 counters definitions
Date: Wed, 15 Jun 2011 16:46:19 -0700
Message-ID: <20110615164619.994a49a4.weiny2@llnl.gov>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
	<1828884A29C6694DAF28B7E6B8A8237302148F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302148F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Minor issue.

PM is defined in the spec glossary to be "Partition Manager".  :-(  Therefore I have refrained from using "PM" or "pm" in structs or defines.  I would not mind settling on an abbreviation; "PMA" perhaps?

Ira

On Wed, 15 Jun 2011 16:10:24 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Other than that one nit, the other patches in this series look good to me.  See below for comments on this one.
> 
> > +/*
> > + * PMA class portinfo capability mask bits
> > + */
> > +#define IB_PMA_CLASS_CAP_ALLPORTSELECT  cpu_to_be16(1 << 8)
> > +#define IB_PMA_CLASS_CAP_EXT_WIDTH      cpu_to_be16(1 << 9)
> > +#define IB_PMA_CLASS_CAP_XMIT_WAIT      cpu_to_be16(1 << 12)
> > +
> > +#define IB_PMA_CLASS_PORT_INFO          cpu_to_be16(0x0001)
> 
> Hmm... we're defining attributes in different ways (see ib_sa.h and ib_smi.h).  Someday we may want to make things consistent.
> 
> > +#define IB_PMA_PORT_SAMPLES_CONTROL     cpu_to_be16(0x0010)
> > +#define IB_PMA_PORT_SAMPLES_RESULT      cpu_to_be16(0x0011)
> > +#define IB_PMA_PORT_COUNTERS            cpu_to_be16(0x0012)
> > +#define IB_PMA_PORT_COUNTERS_EXT        cpu_to_be16(0x001D)
> > +#define IB_PMA_PORT_SAMPLES_RESULT_EXT  cpu_to_be16(0x001E)
> > +#define IB_PMA_PORT_COUNTERS_CONG       cpu_to_be16(0xFF00)
> > +
> > +struct ib_perf {
> > +	u8 base_version;
> > +	u8 mgmt_class;
> > +	u8 class_version;
> > +	u8 method;
> > +	__be16 status;
> > +	__be16 unused;
> > +	__be64 tid;
> > +	__be16 attr_id;
> > +	__be16 resv;
> > +	__be32 attr_mod;
> > +	u8 reserved[40];
> > +	u8 data[192];
> > +} __attribute__ ((packed));
> 
> This should use struct ib_mad_hdr, possibly adding appropriate values to ib_mad.h for the 40 and 192.  See the enum in ib_mad.h with IB_MGMT_* values.  I would also rename this to struct ib_pm_mad to better match the existing mad definitions.
> 
> > +
> > +struct ib_pma_classportinfo {
> > +	u8 base_version;
> > +	u8 class_version;
> > +	__be16 cap_mask;
> > +	u8 reserved[3];
> > +	u8 resp_time_value;     /* only lower 5 bits */
> > +	union ib_gid redirect_gid;
> > +	__be32 redirect_tc_sl_fl;       /* 8, 4, 20 bits respectively */
> > +	__be16 redirect_lid;
> > +	__be16 redirect_pkey;
> > +	__be32 redirect_qp;     /* only lower 24 bits */
> > +	__be32 redirect_qkey;
> > +	union ib_gid trap_gid;
> > +	__be32 trap_tc_sl_fl;   /* 8, 4, 20 bits respectively */
> > +	__be16 trap_lid;
> > +	__be16 trap_pkey;
> > +	__be32 trap_hl_qp;      /* 8, 24 bits respectively */
> > +	__be32 trap_qkey;
> > +} __attribute__ ((packed));
> 
> This needs to be replaced with struct ib_class_port_info in ib_mad.h.
> 
> > +
> > +struct ib_pma_portsamplescontrol {
> > +	u8 opcode;
> > +	u8 port_select;
> > +	u8 tick;
> > +	u8 counter_width;       /* only lower 3 bits */
> > +	__be32 counter_mask0_9; /* 2, 10 * 3, bits */
> > +	__be16 counter_mask10_14;       /* 1, 5 * 3, bits */
> 
> Comments for the bit fields aren't very clear, maybe say something more like '10 3-bit fields'.  For things like counter_width, my preference is something like /* resv: 7:3, counter width: 2:0 */ to clarify which bits are used and indicate that the others are currently reserved.
> 
> > +	u8 sample_mechanisms;
> > +	u8 sample_status;       /* only lower 2 bits */
> > +	__be64 option_mask;
> > +	__be64 vendor_mask;
> > +	__be32 sample_start;
> > +	__be32 sample_interval;
> > +	__be16 tag;
> > +	__be16 counter_select[15];
> > +} __attribute__ ((packed));
> 
> There are fields missing at the end: reserved 32-bits, SamplesOnlyOptionMask 64-bit, reserved 896-bits.  This should make the structure naturally aligned, which could remove the packed attribute.
> 
> > +struct ib_pma_portsamplesresult {
> > +	__be16 tag;
> > +	__be16 sample_status;   /* only lower 2 bits */
> > +	__be32 counter[15];
> > +} __attribute__ ((packed));
> 
> this is naturally aligned
> 
> > +struct ib_pma_portsamplesresult_ext {
> > +	__be16 tag;
> > +	__be16 sample_status;   /* only lower 2 bits */
> > +	__be32 extended_width;  /* only upper 2 bits */
> > +	__be64 counter[15];
> > +} __attribute__ ((packed));
> 
> this is naturally aligned
> 
> > +struct ib_pma_portcounters {
> > +	u8 reserved;
> > +	u8 port_select;
> > +	__be16 counter_select;
> > +	__be16 symbol_error_counter;
> > +	u8 link_error_recovery_counter;
> > +	u8 link_downed_counter;
> > +	__be16 port_rcv_errors;
> > +	__be16 port_rcv_remphys_errors;
> > +	__be16 port_rcv_switch_relay_errors;
> > +	__be16 port_xmit_discards;
> > +	u8 port_xmit_constraint_errors;
> > +	u8 port_rcv_constraint_errors;
> > +	u8 reserved1;
> > +	u8 lli_ebor_errors;     /* 4, 4, bits */
> 
> lli_ebor?  what about link_overrun_errors instead, or at least something a little more descriptive?
> 
> Enhancing the comment can also help: /* LocalLink: 7:4, BufferOverrun: 3:0 */
> 
> > +	__be16 reserved2;
> > +	__be16 vl15_dropped;
> > +	__be32 port_xmit_data;
> > +	__be32 port_rcv_data;
> > +	__be32 port_xmit_packets;
> > +	__be32 port_rcv_packets;
> > +} __attribute__ ((packed));
> 
> missing PortXmitWait 32-bits at end
> 
> > +
> > +struct ib_pma_portcounters_cong {
> > +	u8 reserved;
> > +	u8 reserved1;
> > +	__be16 port_check_rate;
> > +	__be16 symbol_error_counter;
> > +	u8 link_error_recovery_counter;
> > +	u8 link_downed_counter;
> > +	__be16 port_rcv_errors;
> > +	__be16 port_rcv_remphys_errors;
> > +	__be16 port_rcv_switch_relay_errors;
> > +	__be16 port_xmit_discards;
> > +	u8 port_xmit_constraint_errors;
> > +	u8 port_rcv_constraint_errors;
> > +	u8 reserved2;
> > +	u8 lli_ebor_errors;    /* 4, 4, bits */
> > +	__be16 reserved3;
> > +	__be16 vl15_dropped;
> > +	__be64 port_xmit_data;
> > +	__be64 port_rcv_data;
> > +	__be64 port_xmit_packets;
> > +	__be64 port_rcv_packets;
> > +	__be64 port_xmit_wait;
> > +	__be64 port_adr_events;
> > +} __attribute__ ((packed));
> > +
> > +#define IB_PMA_CONG_HW_CONTROL_TIMER            0x00
> > +#define IB_PMA_CONG_HW_CONTROL_SAMPLE           0x01
> >
> > +#define IB_PMA_SEL_SYMBOL_ERROR                 cpu_to_be16(0x0001)
> > +#define IB_PMA_SEL_LINK_ERROR_RECOVERY          cpu_to_be16(0x0002)
> > +#define IB_PMA_SEL_LINK_DOWNED                  cpu_to_be16(0x0004)
> > +#define IB_PMA_SEL_PORT_RCV_ERRORS              cpu_to_be16(0x0008)
> > +#define IB_PMA_SEL_PORT_RCV_REMPHYS_ERRORS      cpu_to_be16(0x0010)
> > +#define IB_PMA_SEL_PORT_XMIT_DISCARDS           cpu_to_be16(0x0040)
> > +#define IB_PMA_SEL_LOCAL_LINK_INTEGRITY_ERRORS  cpu_to_be16(0x0200)
> > +#define IB_PMA_SEL_EXCESSIVE_BUFFER_OVERRUNS    cpu_to_be16(0x0400)
> > +#define IB_PMA_SEL_PORT_VL15_DROPPED            cpu_to_be16(0x0800)
> > +#define IB_PMA_SEL_PORT_XMIT_DATA               cpu_to_be16(0x1000)
> > +#define IB_PMA_SEL_PORT_RCV_DATA                cpu_to_be16(0x2000)
> > +#define IB_PMA_SEL_PORT_XMIT_PACKETS            cpu_to_be16(0x4000)
> > +#define IB_PMA_SEL_PORT_RCV_PACKETS             cpu_to_be16(0x8000)
> > +
> > +#define IB_PMA_SEL_CONG_ALL                     0x01
> > +#define IB_PMA_SEL_CONG_PORT_DATA               0x02
> > +#define IB_PMA_SEL_CONG_XMIT                    0x04
> > +#define IB_PMA_SEL_CONG_ROUTING                 0x08
> > +
> > +struct ib_pma_portcounters_ext {
> > +	u8 reserved;
> > +	u8 port_select;
> > +	__be16 counter_select;
> > +	__be32 reserved1;
> > +	__be64 port_xmit_data;
> > +	__be64 port_rcv_data;
> > +	__be64 port_xmit_packets;
> > +	__be64 port_rcv_packets;
> > +	__be64 port_unicast_xmit_packets;
> > +	__be64 port_unicast_rcv_packets;
> > +	__be64 port_multicast_xmit_packets;
> > +	__be64 port_multicast_rcv_packets;
> > +} __attribute__ ((packed));
> > +
> > +#define IB_PMA_SELX_PORT_XMIT_DATA              cpu_to_be16(0x0001)
> > +#define IB_PMA_SELX_PORT_RCV_DATA               cpu_to_be16(0x0002)
> > +#define IB_PMA_SELX_PORT_XMIT_PACKETS           cpu_to_be16(0x0004)
> > +#define IB_PMA_SELX_PORT_RCV_PACKETS            cpu_to_be16(0x0008)
> > +#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS       cpu_to_be16(0x0010)
> > +#define IB_PMA_SELX_PORT_UNI_RCV_PACKETS        cpu_to_be16(0x0020)
> > +#define IB_PMA_SELX_PORT_MULTI_XMIT_PACKETS     cpu_to_be16(0x0040)
> > +#define IB_PMA_SELX_PORT_MULTI_RCV_PACKETS      cpu_to_be16(0x0080)
> 
> Rather than having IB_PMA_SEL_* and IB_PMA_SELX_*, we could follow what's done in ib_sa.h:
> 
> IB_PM_<structure>_<field>
> 
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
