From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 7/9] ib/pma: add include file for IBA performance	counters
 definitions
Date: Thu, 16 Jun 2011 10:39:05 +0300
Message-ID: <4DF9B319.6070100@mellanox.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com> <1828884A29C6694DAF28B7E6B8A8237302148F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302148F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> Other than that one nit, the other patches in this series look good to me.  See below for comments on this one.

>> +struct ib_perf {
>> +	u8 base_version;
>> +	u8 mgmt_class;
>> +	u8 class_version;
>> +	u8 method;
>> +	__be16 status;
>> +	__be16 unused;
>> +	__be64 tid;
>> +	__be16 attr_id;
>> +	__be16 resv;
>> +	__be32 attr_mod;
>> +	u8 reserved[40];
>> +	u8 data[192];
>> +} __attribute__ ((packed));

> This should use struct ib_mad_hdr, possibly adding appropriate values to ib_mad.h for the 40 and 192.  
> See the enum in ib_mad.h with IB_MGMT_* values.  I would also rename this to struct ib_pm_mad to better 
> match the existing mad definitions.

okay, replaced all the fields except for the last two with struct 
ib_mad_hdr and renamed the structure to ib_pma_mad (long live sed)

>> +struct ib_pma_classportinfo {
> This needs to be replaced with struct ib_class_port_info in ib_mad.h.

good catch, done

>> +struct ib_pma_portsamplescontrol {
>> +	u8 counter_width;       /* only lower 3 bits */
>> +	__be32 counter_mask0_9; /* 2, 10 * 3, bits */
>> +	__be16 counter_mask10_14;       /* 1, 5 * 3, bits */

> Comments for the bit fields aren't very clear, maybe say something more like '10 3-bit fields'.  
> For things like counter_width, my preference is something like /* resv: 7:3, counter width: 2:0 */ 
> to clarify which bits are used and indicate that the others are currently reserved.

done, changed the comments as you suggested

>> +	__be16 counter_select[15];
>> +} __attribute__ ((packed));

> There are fields missing at the end: reserved 32-bits, SamplesOnlyOptionMask 64-bit, reserved 896-bits.  
> This should make the structure naturally aligned, which could remove the packed attribute.

done, added reserved fields and removed packing.

>> +struct ib_pma_portsamplesresult {
> this is naturally aligned

OKAY, removed packing here

> 
>> +struct ib_pma_portsamplesresult_ext {
> this is naturally aligned

OKAY, removed packing also here

>> +struct ib_pma_portcounters {
>> +	u8 lli_ebor_errors;     /* 4, 4, bits */

> lli_ebor?  what about link_overrun_errors instead, or at least something a little more descriptive?
> Enhancing the comment can also help: /* LocalLink: 7:4, BufferOverrun: 3:0 */

done, changed field name to link_overrun_errors and added the comment 
you suggested.

>> +	__be32 port_xmit_data;
>> +	__be32 port_rcv_data;
>> +	__be32 port_xmit_packets;
>> +	__be32 port_rcv_packets;
>> +} __attribute__ ((packed));

> missing PortXmitWait 32-bits at end

added, thanks


> Rather than having IB_PMA_SEL_* and IB_PMA_SELX_*, we could follow what's done in ib_sa.h:
> IB_PM_<structure>_<field>

I would need some guidance here...  maybe you can elaborate a little 
further with the V1 posting which will follow soon

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
