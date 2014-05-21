From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 4/5] Add ibv_query_port_ex support
Date: Wed, 21 May 2014 14:10:59 -0600
Message-ID: <20140521201059.GC26909@obsidianresearch.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <1400405929-14313-5-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1400405929-14313-5-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 18, 2014 at 12:38:48PM +0300, Or Gerlitz wrote:
> +enum ibv_query_port_ex_attr_mask {
> +	IBV_QUERY_PORT_EX_STATE			= 1 << 0,
> +	IBV_QUERY_PORT_EX_MAX_MTU		= 1 << 1,
> +	IBV_QUERY_PORT_EX_ACTIVE_MTU		= 1 << 2,
> +	IBV_QUERY_PORT_EX_GID_TBL_LEN		= 1 << 3,
> +	IBV_QUERY_PORT_EX_CAP_FLAGS		= 1 << 4,
> +	IBV_QUERY_PORT_EX_MAX_MSG_SZ		= 1 << 5,
> +	IBV_QUERY_PORT_EX_BAD_PKEY_CNTR		= 1 << 6,
> +	IBV_QUERY_PORT_EX_QKEY_VIOL_CNTR	= 1 << 7,
> +	IBV_QUERY_PORT_EX_PKEY_TBL_LEN		= 1 << 8,
> +	IBV_QUERY_PORT_EX_LID			= 1 << 9,
> +	IBV_QUERY_PORT_EX_SM_LID		= 1 << 10,
> +	IBV_QUERY_PORT_EX_LMC			= 1 << 11,
> +	IBV_QUERY_PORT_EX_MAX_VL_NUM		= 1 << 12,
> +	IBV_QUERY_PORT_EX_SM_SL			= 1 << 13,
> +	IBV_QUERY_PORT_EX_SUBNET_TIMEOUT	= 1 << 14,
> +	IBV_QUERY_PORT_EX_INIT_TYPE_REPLY	= 1 << 15,
> +	IBV_QUERY_PORT_EX_ACTIVE_WIDTH		= 1 << 16,
> +	IBV_QUERY_PORT_EX_ACTIVE_SPEED		= 1 << 17,
> +	IBV_QUERY_PORT_EX_PHYS_STATE		= 1 << 18,
> +	IBV_QUERY_PORT_EX_LINK_LAYER		= 1 << 19,
> +	/* mask of the fields that exists in the standard query_port_command */
> +	IBV_QUERY_PORT_EX_STD_MASK		= (1 << 20) - 1,
> +	/* mask of all supported fields */
> +	IBV_QUERY_PORT_EX_MASK			= IBV_QUERY_PORT_EX_STD_MASK,
> +};

OK

> +struct ibv_port_attr_ex {
> +	enum ibv_port_state	state;
> +	enum ibv_mtu		max_mtu;
> +	enum ibv_mtu		active_mtu;
> +	int			gid_tbl_len;
> +	uint32_t		port_cap_flags;
> +	uint32_t		max_msg_sz;
> +	uint32_t		bad_pkey_cntr;
> +	uint32_t		qkey_viol_cntr;
> +	uint16_t		pkey_tbl_len;
> +	uint16_t		lid;
> +	uint16_t		sm_lid;
> +	uint8_t			lmc;
> +	uint8_t			max_vl_num;
> +	uint8_t			sm_sl;
> +	uint8_t			subnet_timeout;
> +	uint8_t			init_type_reply;
> +	uint8_t			active_width;
> +	uint8_t			active_speed;
> +	uint8_t			phys_state;
> +	uint8_t			link_layer;
> +	uint8_t			reserved;

OK

> +	uint32_t		comp_mask;

This uses the first 20 bits already, should comp_mask just be 64 bits
off the bat?

> @@ -998,6 +1050,8 @@ enum verbs_context_mask {
>  
>  struct verbs_context {
>  	/*  "grows up" - new fields go here */
> +	int (*query_port_ex)(struct ibv_context *context, uint8_t port_num,
> +			     struct ibv_port_attr_ex *port_attr);

OK

> +static inline int ibv_query_port_ex(struct ibv_context *context,
> +				    uint8_t port_num,
> +				    struct ibv_port_attr_ex *port_attr)
> +{
> +	struct verbs_context *vctx;
> +
> +	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
> +	port_attr->reserved   = 0;

We don't need this. All the calls to ibv_query_port already set these
values and we can simply require that all implementations of
ibv_query_port_ex set them too.

> +	if (0 == port_attr->comp_mask)
> +		return ibv_query_port(context, port_num,
> +				      (struct ibv_port_attr *)port_attr);

I'm confused what this is doing? Why is 0 ever a valid comp_mask?

> +	/* Check that only valid flags were given */
> +	if (port_attr->comp_mask & ~IBV_QUERY_PORT_EX_MASK) {
> +		errno = EINVAL;
> +		return -errno;
> +	}

And this doesn't seem to make sense either.

> +	vctx = verbs_get_ctx_op(context, query_port_ex);
> +
> +	if (!vctx) {
> +		/* Fallback to legacy mode */
> +		if (!(port_attr->comp_mask & ~IBV_QUERY_PORT_EX_STD_MASK))
> +			return ibv_query_port(context, port_num,
> +					      (struct ibv_port_attr *)port_attr);
> +
> +		/* Unsupported field was requested */
> +		errno = ENOSYS;
> +		return -errno;
> +	}
> +
> +	return vctx->query_port_ex(context, port_num, port_attr);
> +}
> +
>  #define ibv_query_port(context, port_num, port_attr) \
>  	___ibv_query_port(context, port_num, port_attr)
>  
> diff --git a/man/ibv_query_port_ex.3 b/man/ibv_query_port_ex.3
> new file mode 100644
> index 0000000..07073fd
> +++ b/man/ibv_query_port_ex.3
> @@ -0,0 +1,97 @@
> +.\" -*- nroff -*-
> +.\"
> +.TH IBV_QUERY_PORT_EX 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
> +.SH "NAME"
> +ibv_query_port_ex \- query an RDMA port's attributes
> +.SH "SYNOPSIS"
> +.nf
> +.B #include <infiniband/verbs.h>
> +.sp
> +.BI "int ibv_query_port_ex(struct ibv_context " "*context" ", uint8_t " "port_num" ,
> +.BI "                      struct ibv_port_attr_ex " "*port_attr" ");
> +.fi
> +.SH "DESCRIPTION"
> +.B ibv_query_port_ex()

I feel it would be nicer to just patch the existing ibv_query_port man
page to have the new call and a paragraph about the extra field.

Similar to how 'man accept' works with accept and accept4


> +returns the attributes of port
> +.I port_num
> +for device context
> +.I context
> +through the pointer
> +.I port_attr\fR.
> +The argument
> +.I port_attr
> +is an ibv_port_attr struct, as defined in <infiniband/verbs.h>.
                 ^^^^^^^

No it isn't. Please proof-read everything.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
