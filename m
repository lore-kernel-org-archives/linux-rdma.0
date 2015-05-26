From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 RFC] IB/sa: Route SA pathrecord query through netlink
Date: Tue, 26 May 2015 10:57:18 -0400
Message-ID: <1432652238.28905.108.camel@redhat.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB3806@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-PzplKS/VEl2D0s+VmR+r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB3806-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-PzplKS/VEl2D0s+VmR+r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-26 at 14:03 +0000, Wan, Kaike wrote:
> I. Introduction
>=20
> After posting our design to the mailing list, we received comments concer=
ning various aspects of the
> design from Sean Hefty, Ira Weiny, Jason Gunthorpe, and Doug Ledford. Tha=
nk you all for the help.
>=20
> The main issues are listed below:
> 1. Extensibility: the design should be flexible and readily extended to o=
ther applications;
> 2. Multiple data records: a query can return multiple data records (eg mu=
ltiple pathrecords);
> 3. Existing code: the design should use existing code as much as possible=
;
> 4. Various query points in the kernel: what are the requirements (paramet=
ers, expected results) for
>    various queries that may exist in the kernel (IPoIB, RDMA CM, etc).
>=20
> As our subject title indicates, we are trying to design for the kernel to=
 query a local user-space
> service, more specifically, for the ib_sa module to send a pathrecord que=
ry to a local user-space SA cache.
> If anyone has information or requirements for other kernel query points, =
we will be happy to know.
>=20
> In our previous design, we created a data header to contain various infor=
mation about the query and
> response:
>=20
> struct ib_nl_data_hdr {
> 	__u8	version;
> 	__u8	opcode;
> 	__u16	status;
> 	__u16	type;
> 	__u16	reserved;
> 	__u32	flags;
> 	__u32	length;
> };
>=20
> This was modeled after the ibacm messages and the message layout is diagr=
ammed below:
>=20
>   +----------------+
>   | netlink header |
>   +----------------+
>   |  Data header   |
>   +----------------+
>   |      Data      |
>   +----------------+
>=20
> The design was extensible, but suffered from the fact that it did not tak=
e full use of the netlink=20
> message header.
>=20
> In this version of the design, we will make full use of the netlink heade=
r and the existing attribute
> interface, as detailed below.
>=20
> II. Message layout
>=20
> The general message layout is shown here:
>=20
>=20
>   +----------------+
>   | netlink header |
>   +----------------+
>   |  Attribute 1   |
>   +----------------+
>   |  Attribute 2   |
>   +----------------+
>   |       ...      |
>   +----------------+
>   |  Attribute N   |
>   +----------------+
>=20
> The number of attributes present in the request/response varies. As shown=
, there is no new data=20
> header to describe either the request nor the response. The netlink heade=
r and various attributes
> will be described later.
>=20
> III. Netlink protocol, multicast group, and kernel client
>=20
> This design is targeted to the NETLINK_RDMA protocol, and a new multicast=
 group RDMA_NL_GROUP_LS is
> added for the local service:
>=20
> enum {
> 	RDMA_NL_GROUP_CM =3D 1,
> 	RDMA_NL_GROUP_IWPM,
> 	RDMA_NL_GROUP_LS,
> 	RDMA_NL_NUM_GROUPS
> };
>=20
> In addition, each kernel client should define a client index so that the =
common rdma code could
> route the response to the right client. For this purpose, we define the R=
DMA_NL_SA client for the
> ib_sa module:
>=20
> enum {
> 	RDMA_NL_RDMA_CM =3D 1,
> 	RDMA_NL_NES,
> 	RDMA_NL_C4IW,
> 	RDMA_NL_SA,
> 	RDMA_NL_NUM_CLIENTS
> };
>=20
> As mentioned previously, each query point in the kernel should have its o=
wn client index.
>=20
> IV. Netlink message header
>=20
> The netlink header is copied here:
>=20
> struct nlmsghdr {
> 	__u32		nlmsg_len;	/* Length of message including header */
> 	__u16		nlmsg_type;	/* Message content */
> 	__u16		nlmsg_flags;	/* Additional flags */
> 	__u32		nlmsg_seq;	/* Sequence number */
> 	__u32		nlmsg_pid;	/* Sending process port ID */
> };
>=20
> The message type for rdma clients is also copied below:
>=20
> #define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)
>=20
> More clearly:
>=20
>     Bits  	Description
>    --------------------------
>     15-10       Client index
>     09-00       Opcode
>=20
> As described previously, a netlink message is routed by protocol (NETLINK=
_RDMA), multicast group
> (RDMA_NL_LS), and client (encoded in the nlmsg_type field for rdma messag=
es). Therefore, the
> opcode (encoded in nlmsg_type), the sequence number (nlmsg_seq) and addit=
ion flags (nlmsg_flags)
> are all local to the client. This is important when we define these field=
s as they can overlap for=20
> different clients.
>=20
> (1) Opcode
>=20
> The opcode for local service SA client is defined below:
>=20
> enum {
> 	RDMA_NL_LS_OP_RESOLVE =3D 0,
> 	RDMA_NL_LS_OP_SET_TIMEOUT,
> 	RDMA_NL_LS_NUM_OPS
> };
>=20
> The RESOLVE opcode is used by the ib_sa to send pathrecord query to the u=
ser-space application=20
> while the SET_TIMEOUT opcode can be used by the user-space application to=
 set the netlink timeout
> value for the kernel client. Additional opcodes can be added if necessary=
.
>=20
> It should be emphasized that the opcode is client specific and therefore =
can be overlapped for=20
> different clients. Therefore, the 10 bits should be large enough for vari=
ous requests.
>=20
> (2) nlmsg_flags
>=20
> This flags fields are again client specific. But the lower byte (bits 7-0=
) is generally reserved
> and the upper bits can be used to define request specific flags:
>=20
> #define RDMA_NL_LS_F_OK		0x0100	/* Success response */
> #define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */
>=20
> These two bits can be used to indicate whether a message is a response. I=
f the status is ERR, an
> error code can be contained in a status attribute, as described low.
>=20
> (3) Attribute type
>=20
> Request parameters and response data records can be embedded in attribute=
s.
>=20
> The attribute header is copied here:
>=20
> struct nlattr {
> 	__u16           nla_len;
> 	__u16           nla_type;
> };
>=20
> Each attribute is preceded by the attribute header and followed by attrib=
ute specific data.
>=20
> It should be reminded that attribute type is request (opcode) specific an=
d therefore could be=20
> overloaded for different requests if needed.
>=20
> For ib_sa RESOLVE query, the following attribute types are defined:
>=20
> enum {
> 	LS_NLA_TYPE_STATUS =3D 0,
> 	LS_NLA_TYPE_ADDRESS,
> 	LS_NLA_TYPE_PATH_RECORD,
> 	LS_NLA_TYPE_MAX
> };
>=20
> (4) Status attribute
>=20
> The status attribute is mostly used to carry error code if the RDMA_NL_LS=
_F_ERR bits in nlmsg_flags
> field in the netlink message header is set. If the response is success, t=
here is no need to include
> this attribute in the response data (it's not an error, either).
>=20
> num {
> 	LS_NLA_STATUS_SUCCESS =3D 0,
> 	LS_NLA_STATUS_INVAL,
> 	LS_NLA_STATUS_ENODATA,
> 	LS_NLA_STATUS_MAX
> };
>=20
> struct rdma_nla_ls_status {
> 	__u32		status;
> };
>=20
> (5) Address attribute
>=20
> This attribute is normally included in the RESOLVE request.
>=20
> num {
> 	LS_NLA_ADDR_F_SRC		=3D 1,
> 	LS_NLA_ADDR_F_DST		=3D (1<<1),
> 	LS_NLA_ADDR_F_HOSTNAME		=3D {1<<2},
> 	LS_NLA_ADDR_F_IPV4		=3D (1<<3),
> 	LS_NLA_ADDR_F_IPV6		=3D (1<<4)
> };
>=20
> struct rdma_nla_ls_addr {
> 	__u32		flags;
> 	__u32		addr[0];
> };
>=20
> The address can be hostname (string), IPv4 or IPv6 address. The source an=
d destination flags are
> also defined.
>=20
> (6) Pathrecord attribute
>=20
> This attribute can be included in both the RESOLVE request and response.
>=20
> num {
> 	LS_NLA_PATH_F_GMP		=3D 1,
> 	LS_NLA_PATH_F_PRIMARY		=3D (1<<1),
> 	LS_NLA_PATH_F_ALTERNATE		=3D (1<<2),
> 	LS_NLA_PATH_F_OUTBOUND		=3D (1<<3),
> 	LS_NLA_PATH_F_INBOUND		=3D (1<<4),
> 	LS_NLA_PATH_F_INBOUND_REVERSE 	=3D (1<<5),
> 	LS_NLA_PATH_F_BIDIRECTIONAL	=3D IB_PATH_OUTBOUND | IB_PATH_INBOUND_REVER=
SE,
> 	LS_NLA_PATH_F_USER		=3D (1<6)
> };
>=20
> struct rdma_nla_ls_path_rec {
> 	__u32	flags;
> 	__u32	path_rec[0];
> };
>=20
> The format of the pathrecord can be indicated by the flags and the data i=
s contained in path_rec[].
> For example, when LS_NLA_PATH_F_USER is set, the format is struct ib_user=
_path_rec.
>=20
> V. Summary
>=20
> It's clear that this design is flexible, extensible, and can be easily en=
hanced to address various
> kernel query points. It uses the existing netlink message header and attr=
ibute interface, and can
> contain multiple attribute records.
>=20
>=20
>=20
> Change since v1:
> -- Completely revised the design to use netlink header and attribute inte=
rface.

On the face of it, this is a much improved design.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-PzplKS/VEl2D0s+VmR+r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZInOAAoJELgmozMOVy/dSRoP/iCrI6osU2jI5MZrqDbHF1XH
s4b2XE8yTCvcw/kEVcKOEgy302PJgbX666JyGogjxdR2ndUOyjqV/5+kyUdtM5Vb
+Yo6c44zIi113ocqeEzUiOO6oBFg7+5oim3rxJm21Quufm05F3CGwSPFwW2RNifh
7fKr2rIO7r12n9Rl95EyHMf6iRqFlSGEJQSqy8MNbH11xzJ5MPnmt7iaj0WB/Tpj
JNMVEhRBaE0182txzC9vXSM2rV29t9zANtHXbyhTfjZNUrvL33LF4CmnMzQoVrP2
TMfhTK/mXg0Yl1C55rql73yN9R73AxqrWF+ZfUSiOiKQDplnIvCf16EY+hBLHumP
M3zK5J9k9jo+feaJjr36UK+nwF0EW1yM9wsgUuC/KYOFEjsoofFAn0xb2UiTBm1v
ShNuxTH9VhWq3PG9F3ctTZ1nCmvU9kAdUa7epB+ftXucsk2WXaQOp4pUKRFHO6YM
7no6Qt+9J22QLHdg1AFTfqVcT3qs0g0mc4i3ELFXQUH2kiOUBsgl+t1jWcH5QKc4
ApnhrhQrVRz1jhCB77e9+JZi4S/PlcRm/0NOUtErA+yW31Ux0MnNBIpenUagfJWu
3m3B4T4Y7XVMW32X0j9s5OMLd/1KlphusVt/w/NRtNh77/9k//XpXfyZDAK7N/DZ
jiMKLkzWarKME02yFjNm
=wAbc
-----END PGP SIGNATURE-----

--=-PzplKS/VEl2D0s+VmR+r--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
