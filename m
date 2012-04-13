From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 1/4] librdmacm: Define streaming over RDMA
 interface (rsockets)
Date: Fri, 13 Apr 2012 19:54:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451AD6B9@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373451ACEA5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373451ACEA5-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm a little slow writing this up, but for anyone interested, see below for details on the wire protocol.

> +#define RS_QP_CTRL_SIZE 4

4 entries on the send queue are reserved for control messages.  (At least 1 is needed to avoid deadlock.)

User data is only transferred if there is an available entry on the local send queue, an entry on the remote receive queue, local send buffer space, and remote receive buffer space.  Control messages may be sent as long as there is space available on the local send queue.  Link level flow control (RNR NACKs) is used to prevent control messages from overflowing the remote receive queue.

> +/*
> + * Immediate data format is determined by the upper bits
> + * bit 31: message type, 0 - data, 1 - control
> + * bit 30: buffers updated, 0 - target, 1 - direct-receive
> + * bit 29: more data, 0 - end of transfer, 1 - more data available
> + *
> + * for data transfers:
> + * bits [28:0]: bytes transfered, 0 = 1 GB
> + * for control messages:
> + * bits [28-0]: receive credits granted
> + */

rsockets uses RDMA writes with immediate data.  The RDMA write portion usually carries the user data, but may also specify the remote buffer.  The immediate data is used to generate a CQ entry and contains information about the write as listed below:

> +enum {
> +	RS_OP_DATA,

The RDMA write carried user data.  The size of the transfer is specified in the lower 29 bits in the immediate data.

> +	RS_OP_DATA_MORE,
> +	RS_OP_DRA,
> +	RS_OP_DRA_MORE,

The above 3 operations are not currently implemented.  They are defined for use with a direct data placement algorithm.

> +	RS_OP_SGL,

rsockets transfers user data by:

1. Copying the source application buffer to a send buffer
2. Performing an RDMA write from the send buffer to a remote receive buffer
3. Copying from the receive buffer to the target application buffer

The location of the remote receive buffers mentioned in step 2 are stored in an SGL.  The size and location of the SGL is exchanged during connection setup, along with 1 receive buffer.  To expose additional receive buffers, the remote peer performs an RDMA write into the SGL.

The SGL message is used for two purposes.  It indicates that the above mentioned SGL has been updated and/or indicates that additional receive queue entries are available.

> +	RS_OP_RSVD1,
> +	RS_OP_DRA_SGL,

The above two messages are unused, but the latter is defined for use with a direct data placement algorithm.

> +	RS_OP_CTRL

Defines additional messages used for control purposes.  The only control message defined is:

> +enum {
> +	RS_CTRL_DISCONNECT
> +};

Disconnection is done over the underlying queue pair, rather than through the rdma_cm.  This simplifies select/poll handling, since the rdma_cm and verbs do not share fd's.

> +#define rs_host_is_net() (1 == htonl(1))
> +#define RS_CONN_FLAG_NET 1

During connection setup, a flag indicates if the host is little or big endian.  The format of data written into the remote SGL using RDMA writes are adjusted accordingly.

> +struct rs_conn_data {
> +	uint8_t		  version;
> +	uint8_t		  flags;
> +	uint16_t	  credits;
> +	uint32_t	  reserved2;
> +	struct rs_sge	  target_sgl;
> +	struct rs_sge	  data_buf;
> +};

This structure defines what information is exchanged during connection setup.

The wire protocol is designed around IB.  I've started looking at what modifications would be needed to support other RDMA devices, with the goal of optimizing the protocol/implementation for each specific device type. 

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
