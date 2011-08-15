From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 12/37] add rxe_verbs.h
Date: Mon, 15 Aug 2011 14:32:01 +0200
Message-ID: <CAO+b5-okTDAJ6iOTv_JKXeGttt0MFM+na-FRaNwJMFqHktKHJQ@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.710989476@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.710989476-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +static inline int pkey_match(u16 key1, u16 key2)
> +{
> +	return (((key1 & 0x7fff) != 0) &&
> +		((key1 & 0x7fff) == (key2 & 0x7fff)) &&
> +		((key1 & 0x8000) || (key2 & 0x8000))) ? 1 : 0;
> +}

Shouldn't the return type of the above function be "bool" instead of
"int" ? Also, the "? 1 : 0" part at the end of the above expression
looks superfluous to me.

> +
> +/* Return >0 if psn_a > psn_b
> + *	   0 if psn_a == psn_b
> + *	  <0 if psn_a < psn_b
> + */
> +static inline int psn_compare(u32 psn_a, u32 psn_b)
> +{
> +	s32 diff;
> +	diff = (psn_a - psn_b) << 8;
> +	return diff;
> +}

Mentioning in the comment block that (according to IBTA) PSNs are
24-bit quantities would help IMHO.

> +#define RXE_LL_ADDR_LEN		(16)
> +
> +struct rxe_av {
> +	struct ib_ah_attr	attr;
> +	u8			ll_addr[RXE_LL_ADDR_LEN];
> +};

Since the ib_rxe kernel module can be used in combination with other
network drivers than only Ethernet drivers, the number of bytes stored
in ll_addr[] by init_av() depends on the link layer type. Shouldn't
the address length be stored in this structure too ?

> +/* must match corresponding data structure in librxe */
> +struct rxe_send_wqe {
> +	struct ib_send_wr	ibwr;
> +	struct rxe_av		av;	/* UD only */
> +	u32			status;
> +	u32			state;
> +	u64			iova;
> +	u32			mask;
> +	u32			first_psn;
> +	u32			last_psn;
> +	u32			ack_length;
> +	u32			ssn;
> +	u32			has_rd_atomic;
> +	struct rxe_dma_info	dma;	/* must go last */
> +};

Can't librxe use this header file instead of duplicating the above definition ?

> +struct rxe_port {
> +	struct ib_port_attr	attr;
> +	u16			*pkey_tbl;
> +	__be64			*guid_tbl;
> +	__be64			subnet_prefix;
> +
> +	/* rate control */
> +	/* TODO */
> +
> +	spinlock_t		port_lock;
> +
> +	unsigned int		mtu_cap;
> +
> +	/* special QPs */
> +	u32			qp_smi_index;
> +	u32			qp_gsi_index;
> +};

Regarding the "to do" item above: is rate control something planned
for the first submission of this driver ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
