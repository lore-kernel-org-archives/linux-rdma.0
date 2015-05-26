From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 RFC] IB/sa: Route SA pathrecord query through netlink
Date: Tue, 26 May 2015 14:03:48 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB3806@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I. Introduction

After posting our design to the mailing list, we received comments concerning various aspects of the
design from Sean Hefty, Ira Weiny, Jason Gunthorpe, and Doug Ledford. Thank you all for the help.

The main issues are listed below:
1. Extensibility: the design should be flexible and readily extended to other applications;
2. Multiple data records: a query can return multiple data records (eg multiple pathrecords);
3. Existing code: the design should use existing code as much as possible;
4. Various query points in the kernel: what are the requirements (parameters, expected results) for
   various queries that may exist in the kernel (IPoIB, RDMA CM, etc).

As our subject title indicates, we are trying to design for the kernel to query a local user-space
service, more specifically, for the ib_sa module to send a pathrecord query to a local user-space SA cache.
If anyone has information or requirements for other kernel query points, we will be happy to know.

In our previous design, we created a data header to contain various information about the query and
response:

struct ib_nl_data_hdr {
	__u8	version;
	__u8	opcode;
	__u16	status;
	__u16	type;
	__u16	reserved;
	__u32	flags;
	__u32	length;
};

This was modeled after the ibacm messages and the message layout is diagrammed below:

  +----------------+
  | netlink header |
  +----------------+
  |  Data header   |
  +----------------+
  |      Data      |
  +----------------+

The design was extensible, but suffered from the fact that it did not take full use of the netlink 
message header.

In this version of the design, we will make full use of the netlink header and the existing attribute
interface, as detailed below.

II. Message layout

The general message layout is shown here:


  +----------------+
  | netlink header |
  +----------------+
  |  Attribute 1   |
  +----------------+
  |  Attribute 2   |
  +----------------+
  |       ...      |
  +----------------+
  |  Attribute N   |
  +----------------+

The number of attributes present in the request/response varies. As shown, there is no new data 
header to describe either the request nor the response. The netlink header and various attributes
will be described later.

III. Netlink protocol, multicast group, and kernel client

This design is targeted to the NETLINK_RDMA protocol, and a new multicast group RDMA_NL_GROUP_LS is
added for the local service:

enum {
	RDMA_NL_GROUP_CM = 1,
	RDMA_NL_GROUP_IWPM,
	RDMA_NL_GROUP_LS,
	RDMA_NL_NUM_GROUPS
};

In addition, each kernel client should define a client index so that the common rdma code could
route the response to the right client. For this purpose, we define the RDMA_NL_SA client for the
ib_sa module:

enum {
	RDMA_NL_RDMA_CM = 1,
	RDMA_NL_NES,
	RDMA_NL_C4IW,
	RDMA_NL_SA,
	RDMA_NL_NUM_CLIENTS
};

As mentioned previously, each query point in the kernel should have its own client index.

IV. Netlink message header

The netlink header is copied here:

struct nlmsghdr {
	__u32		nlmsg_len;	/* Length of message including header */
	__u16		nlmsg_type;	/* Message content */
	__u16		nlmsg_flags;	/* Additional flags */
	__u32		nlmsg_seq;	/* Sequence number */
	__u32		nlmsg_pid;	/* Sending process port ID */
};

The message type for rdma clients is also copied below:

#define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)

More clearly:

    Bits  	Description
   --------------------------
    15-10       Client index
    09-00       Opcode

As described previously, a netlink message is routed by protocol (NETLINK_RDMA), multicast group
(RDMA_NL_LS), and client (encoded in the nlmsg_type field for rdma messages). Therefore, the
opcode (encoded in nlmsg_type), the sequence number (nlmsg_seq) and addition flags (nlmsg_flags)
are all local to the client. This is important when we define these fields as they can overlap for 
different clients.

(1) Opcode

The opcode for local service SA client is defined below:

enum {
	RDMA_NL_LS_OP_RESOLVE = 0,
	RDMA_NL_LS_OP_SET_TIMEOUT,
	RDMA_NL_LS_NUM_OPS
};

The RESOLVE opcode is used by the ib_sa to send pathrecord query to the user-space application 
while the SET_TIMEOUT opcode can be used by the user-space application to set the netlink timeout
value for the kernel client. Additional opcodes can be added if necessary.

It should be emphasized that the opcode is client specific and therefore can be overlapped for 
different clients. Therefore, the 10 bits should be large enough for various requests.

(2) nlmsg_flags

This flags fields are again client specific. But the lower byte (bits 7-0) is generally reserved
and the upper bits can be used to define request specific flags:

#define RDMA_NL_LS_F_OK		0x0100	/* Success response */
#define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */

These two bits can be used to indicate whether a message is a response. If the status is ERR, an
error code can be contained in a status attribute, as described low.

(3) Attribute type

Request parameters and response data records can be embedded in attributes.

The attribute header is copied here:

struct nlattr {
	__u16           nla_len;
	__u16           nla_type;
};

Each attribute is preceded by the attribute header and followed by attribute specific data.

It should be reminded that attribute type is request (opcode) specific and therefore could be 
overloaded for different requests if needed.

For ib_sa RESOLVE query, the following attribute types are defined:

enum {
	LS_NLA_TYPE_STATUS = 0,
	LS_NLA_TYPE_ADDRESS,
	LS_NLA_TYPE_PATH_RECORD,
	LS_NLA_TYPE_MAX
};

(4) Status attribute

The status attribute is mostly used to carry error code if the RDMA_NL_LS_F_ERR bits in nlmsg_flags
field in the netlink message header is set. If the response is success, there is no need to include
this attribute in the response data (it's not an error, either).

num {
	LS_NLA_STATUS_SUCCESS = 0,
	LS_NLA_STATUS_INVAL,
	LS_NLA_STATUS_ENODATA,
	LS_NLA_STATUS_MAX
};

struct rdma_nla_ls_status {
	__u32		status;
};

(5) Address attribute

This attribute is normally included in the RESOLVE request.

num {
	LS_NLA_ADDR_F_SRC		= 1,
	LS_NLA_ADDR_F_DST		= (1<<1),
	LS_NLA_ADDR_F_HOSTNAME		= {1<<2},
	LS_NLA_ADDR_F_IPV4		= (1<<3),
	LS_NLA_ADDR_F_IPV6		= (1<<4)
};

struct rdma_nla_ls_addr {
	__u32		flags;
	__u32		addr[0];
};

The address can be hostname (string), IPv4 or IPv6 address. The source and destination flags are
also defined.

(6) Pathrecord attribute

This attribute can be included in both the RESOLVE request and response.

num {
	LS_NLA_PATH_F_GMP		= 1,
	LS_NLA_PATH_F_PRIMARY		= (1<<1),
	LS_NLA_PATH_F_ALTERNATE		= (1<<2),
	LS_NLA_PATH_F_OUTBOUND		= (1<<3),
	LS_NLA_PATH_F_INBOUND		= (1<<4),
	LS_NLA_PATH_F_INBOUND_REVERSE 	= (1<<5),
	LS_NLA_PATH_F_BIDIRECTIONAL	= IB_PATH_OUTBOUND | IB_PATH_INBOUND_REVERSE,
	LS_NLA_PATH_F_USER		= (1<6)
};

struct rdma_nla_ls_path_rec {
	__u32	flags;
	__u32	path_rec[0];
};

The format of the pathrecord can be indicated by the flags and the data is contained in path_rec[].
For example, when LS_NLA_PATH_F_USER is set, the format is struct ib_user_path_rec.

V. Summary

It's clear that this design is flexible, extensible, and can be easily enhanced to address various
kernel query points. It uses the existing netlink message header and attribute interface, and can
contain multiple attribute records.



Change since v1:
-- Completely revised the design to use netlink header and attribute interface.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
