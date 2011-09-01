From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 12/37] add rxe_verbs.h
Date: Wed, 31 Aug 2011 23:32:12 -0500
Message-ID: <038501cc6860$1f0bd500$5d237f00$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.710989476@systemfabricworks.com> <CAO+b5-okTDAJ6iOTv_JKXeGttt0MFM+na-FRaNwJMFqHktKHJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-okTDAJ6iOTv_JKXeGttt0MFM+na-FRaNwJMFqHktKHJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On
> Behalf Of Bart Van Assche
> Sent: Monday, August 15, 2011 7:32 AM
> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 12/37] add rxe_verbs.h
> 
> On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > +static inline int pkey_match(u16 key1, u16 key2)
> > +{
> > +	return (((key1 & 0x7fff) != 0) &&
> > +		((key1 & 0x7fff) == (key2 & 0x7fff)) &&
> > +		((key1 & 0x8000) || (key2 & 0x8000))) ? 1 : 0;
> > +}
> 
> Shouldn't the return type of the above function be "bool" instead of
> "int" ? Also, the "? 1 : 0" part at the end of the above expression
> looks superfluous to me.

Sounds fine to me.

> 
> > +
> > +/* Return >0 if psn_a > psn_b
> > + *	   0 if psn_a == psn_b
> > + *	  <0 if psn_a < psn_b
> > + */
> > +static inline int psn_compare(u32 psn_a, u32 psn_b)
> > +{
> > +	s32 diff;
> > +	diff = (psn_a - psn_b) << 8;
> > +	return diff;
> > +}

Sure

> 
> Mentioning in the comment block that (according to IBTA) PSNs are
> 24-bit quantities would help IMHO.
> 
> > +#define RXE_LL_ADDR_LEN		(16)
> > +
> > +struct rxe_av {
> > +	struct ib_ah_attr	attr;
> > +	u8			ll_addr[RXE_LL_ADDR_LEN];
> > +};

Good idea. Can use MAX_ADDR_LEN as well.

> 
> Since the ib_rxe kernel module can be used in combination with other
> network drivers than only Ethernet drivers, the number of bytes stored
> in ll_addr[] by init_av() depends on the link layer type. Shouldn't
> the address length be stored in this structure too ?
> 
> > +/* must match corresponding data structure in librxe */
> > +struct rxe_send_wqe {
> > +	struct ib_send_wr	ibwr;
> > +	struct rxe_av		av;	/* UD only */
> > +	u32			status;
> > +	u32			state;
> > +	u64			iova;
> > +	u32			mask;
> > +	u32			first_psn;
> > +	u32			last_psn;
> > +	u32			ack_length;
> > +	u32			ssn;
> > +	u32			has_rd_atomic;
> > +	struct rxe_dma_info	dma;	/* must go last */
> > +};
> 
> Can't librxe use this header file instead of duplicating the above
definition ?

We followed the local convention which is to keep the header files separate.
(See e.g. nes/nes_user.h, mthca/mthca_user.h, etc...) I can't justify it
except that everyone else does it too.

> 
> > +struct rxe_port {
> > +	struct ib_port_attr	attr;
> > +	u16			*pkey_tbl;
> > +	__be64			*guid_tbl;
> > +	__be64			subnet_prefix;
> > +
> > +	/* rate control */
> > +	/* TODO */
> > +
> > +	spinlock_t		port_lock;
> > +
> > +	unsigned int		mtu_cap;
> > +
> > +	/* special QPs */
> > +	u32			qp_smi_index;
> > +	u32			qp_gsi_index;
> > +};
> 
> Regarding the "to do" item above: is rate control something planned
> for the first submission of this driver ?

Currently rxe only supports one port per device and the injection rate
control is tied to the device.  It is a fairly fussy change to completely
implement multiport devices and doesn't add much value as far as I can tell.
So for now I suppose we can drop this TODO.

> 
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
