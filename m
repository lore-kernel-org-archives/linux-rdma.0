From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 15:44:40 -0400
Message-ID: <20150521194439.GA6389@phlsvsds.ph.intel.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 07:52:36AM -0600, Wan, Kaike wrote:
> 
> The general format of the request and response will be the same:
> 
>   ------------------
>   | netlink header |
>   ------------------
>   |  Data header   |
>   ------------------
>   |      Data      |
>   ------------------
> 
> The data header contains information about the type of request/response, the status (for response),
> the type (format) of the data, the total length of the data header + data, and a flags field about
> the request/response or data.
> 
> Based on the type of the data, the data section may be in different format: a string about the host
> name to resolve, an IP4/IP6 address, a pathrecord, a user pathrecord (struct ib_user_path_rec),
> or simply a MAD (like our posted patches), etc.

I think given the new plans this is not really necessary.

>
> Essentially it can be of any format based on the 
> data type. The key is to document the format so that the kernel and user space can communicate 
> correctly.
> 
> The details are described below:
> 
> #define IB_NL_VERSION		0x01

Change all "IB" to "RDMA"

> 
> #define IB_NL_OP_MASK		0x0F
> #define IB_NL_OP_RESOLVE	0x01
> #define IB_NL_OP_QUERY_PATH	0x02
> #define IB_NL_OP_SET_TIMEOUT	0x03
> #define IB_NL_OP_ACK		0x80
> 
> #define IB_NL_STATUS_SUCCESS	0x0000
> #define IB_NL_STATUS_ENODATA	0x0001

If we do what Doug suggested should we just make OP 16bits with the high bit
ACK/NACK?

Then use the other u8 as a detailed status if needed.

> 
> #define IB_NL_DATA_TYPE_INVALID			0x0000
> #define IB_NL_DATA_TYPE_NAME			0x0001
> #define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
> #define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
> #define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
> #define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005

Do we need both PATH_RECORD and USER_PATH_REC?

I'm having trouble determining when the OP == QUERY_PATH and the DATA_TYPE !=
PATH_RECORD.

Why don't we remove "QUERY_PATH" above and allow OP == RESOLVE and DATA_TYPE ==
PATH_RECORD be a "query for path record"?

> #define IB_NL_DATA_TYPE_MAD			0x0006

I would drop this for now.

> 
> #define IB_NL_FLAGS_PATH_GMP			1
> #define IB_NL_FLAGS_PATH_PRIMARY		(1<<1)
> #define IB_NL_FLAGS_PATH_ALTERNATE		(1<<2)
> #define IB_NL_FLAGS_PATH_OUTBOUND		(1<<3)
> #define IB_NL_FLAGS_PATH_INBOUND		(1<<4)
> #define IB_NL_FLAGS_PATH_INBOUND_REVERSE 	(1<<5)
> #define IB_NL_FLAGS_PATH_BIDIRECTIONAL		(IB_PATH_OUTBOUND | IB_PATH_INBOUND_REVERSE)
> #define IB_NL_FLAGS_QUERY_SA			(1<<31)
> #define IB_NL_FLAGS_NODELAY			(1<<30)
> 
> struct ib_nl_data_hdr {
> 	__u8	version;
> 	__u8	opcode;
> 	__u16	status;
> 	__u16	type;
> 	__u16	reserved;
> 	__u32	flags;
> 	__u32	length;

The overall message length is in the netlink header.  So keeping in mind Jasons
comments regarding returning multiple data records.

I think this should be the length of individual records with a "num records"
also specified.  I would much prefer this over the yucky IBTA RMPP method of
implicit record sizes needing to be divided into the overall message size.

> };

Should we have a "class" value in the header somewhere?  With multiple user
space listeners it could be easier to mux messages with such a value.  The
class/seq would then differentiate the message.

> 
> struct ib_nl_data {
> 	struct ib_nl_data_hdr		hdr;
> 	__u8				data[0];
> };
> 
> 
> These defines and structures can be added to file include/upai/rdma/rdma_netlink.h (replace with
> RDMA_NL prefix) or contained in a seperate file (include/upai/rdma/ib_netlink.h ???). 

This is not as important as getting the protocol down.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
