From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 13:52:36 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In our previous posting to the mailing list, we proposed to send a MAD request from kernel (more
specifically, from ib_sa module) to a user space application (ibacm in this case) through netlink.
The user space application will send back the response. This simple scheme can achieve the goal 
of a local SA cache in user space.

The format of the request and response is diagrammed below:

  ------------------
  | netlink header |
  ------------------
  |     MAD        |
  ------------------

The kernel requests for a pathrecord, and the user application finds it in its local cache and sends
it to the kernel. If the netlink request fails, the kernel will send the request to SA through the
normal IB path (ib_mad -> hca driver -> wire).

Jason pointed out that this message format was limited to lower stack format (MAD) and its use
could not be readily extended to upper layer modules like rdma_cm. After lengthy discussions, we 
come up with a new and modified scheme, as described below.

The general format of the request and response will be the same:

  ------------------
  | netlink header |
  ------------------
  |  Data header   |
  ------------------
  |      Data      |
  ------------------

The data header contains information about the type of request/response, the status (for response),
the type (format) of the data, the total length of the data header + data, and a flags field about
the request/response or data.

Based on the type of the data, the data section may be in different format: a string about the host
name to resolve, an IP4/IP6 address, a pathrecord, a user pathrecord (struct ib_user_path_rec),
or simply a MAD (like our posted patches), etc. Essentially it can be of any format based on the 
data type. The key is to document the format so that the kernel and user space can communicate 
correctly.

The details are described below:

#define IB_NL_VERSION		0x01

#define IB_NL_OP_MASK		0x0F
#define IB_NL_OP_RESOLVE	0x01
#define IB_NL_OP_QUERY_PATH	0x02
#define IB_NL_OP_SET_TIMEOUT	0x03
#define IB_NL_OP_ACK		0x80

#define IB_NL_STATUS_SUCCESS	0x0000
#define IB_NL_STATUS_ENODATA	0x0001

#define IB_NL_DATA_TYPE_INVALID			0x0000
#define IB_NL_DATA_TYPE_NAME			0x0001
#define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
#define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
#define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
#define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005
#define IB_NL_DATA_TYPE_MAD			0x0006

#define IB_NL_FLAGS_PATH_GMP			1
#define IB_NL_FLAGS_PATH_PRIMARY		(1<<1)
#define IB_NL_FLAGS_PATH_ALTERNATE		(1<<2)
#define IB_NL_FLAGS_PATH_OUTBOUND		(1<<3)
#define IB_NL_FLAGS_PATH_INBOUND		(1<<4)
#define IB_NL_FLAGS_PATH_INBOUND_REVERSE 	(1<<5)
#define IB_NL_FLAGS_PATH_BIDIRECTIONAL		(IB_PATH_OUTBOUND | IB_PATH_INBOUND_REVERSE)
#define IB_NL_FLAGS_QUERY_SA			(1<<31)
#define IB_NL_FLAGS_NODELAY			(1<<30)

struct ib_nl_data_hdr {
	__u8	version;
	__u8	opcode;
	__u16	status;
	__u16	type;
	__u16	reserved;
	__u32	flags;
	__u32	length;
};

struct ib_nl_data {
	struct ib_nl_data_hdr		hdr;
	__u8				data[0];
};


These defines and structures can be added to file include/upai/rdma/rdma_netlink.h (replace with
RDMA_NL prefix) or contained in a seperate file (include/upai/rdma/ib_netlink.h ???). 

Please share your thoughts.

Kaike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
