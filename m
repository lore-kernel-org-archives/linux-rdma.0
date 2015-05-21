From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 13:21:14 -0400
Message-ID: <1432228874.28905.35.camel@redhat.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-nB3uSDb8aYoWIkGhqezb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-nB3uSDb8aYoWIkGhqezb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 13:52 +0000, Wan, Kaike wrote:
> In our previous posting to the mailing list, we proposed to send a MAD re=
quest from kernel (more
> specifically, from ib_sa module) to a user space application (ibacm in th=
is case) through netlink.
> The user space application will send back the response. This simple schem=
e can achieve the goal=20
> of a local SA cache in user space.
>=20
> The format of the request and response is diagrammed below:
>=20
>   ------------------
>   | netlink header |
>   ------------------
>   |     MAD        |
>   ------------------
>=20
> The kernel requests for a pathrecord, and the user application finds it i=
n its local cache and sends
> it to the kernel. If the netlink request fails, the kernel will send the =
request to SA through the
> normal IB path (ib_mad -> hca driver -> wire).
>=20
> Jason pointed out that this message format was limited to lower stack for=
mat (MAD) and its use
> could not be readily extended to upper layer modules like rdma_cm. After =
lengthy discussions, we=20
> come up with a new and modified scheme, as described below.
>=20
> The general format of the request and response will be the same:
>=20
>   ------------------
>   | netlink header |
>   ------------------
>   |  Data header   |
>   ------------------
>   |      Data      |
>   ------------------
>=20
> The data header contains information about the type of request/response, =
the status (for response),
> the type (format) of the data, the total length of the data header + data=
, and a flags field about
> the request/response or data.
>=20
> Based on the type of the data, the data section may be in different forma=
t: a string about the host
> name to resolve, an IP4/IP6 address, a pathrecord, a user pathrecord (str=
uct ib_user_path_rec),
> or simply a MAD (like our posted patches), etc. Essentially it can be of =
any format based on the=20
> data type. The key is to document the format so that the kernel and user =
space can communicate=20
> correctly.
>=20
> The details are described below:
>=20
> #define IB_NL_VERSION		0x01
>=20
> #define IB_NL_OP_MASK		0x0F
> #define IB_NL_OP_RESOLVE	0x01
> #define IB_NL_OP_QUERY_PATH	0x02
> #define IB_NL_OP_SET_TIMEOUT	0x03
> #define IB_NL_OP_ACK		0x80

If OP_ACK is one bit, why isn't the OP_MASK 0x7f?

> #define IB_NL_STATUS_SUCCESS	0x0000
> #define IB_NL_STATUS_ENODATA	0x0001

Do we need 16 bits for a bool?  In fact, couldn't this actually be
switched so that the return of the message uses OP_SUCCESS instead of
OP_ACK?

In other words, instead of two items here, couldn't the ACK bit be
dropped entirely and replaced with SUCCESS so that when the user app
returns the netlink packet, if the op on return =3D=3D to the op on send, i=
t
failed, if it's op | SUCCESS, it succeeded?

> #define IB_NL_DATA_TYPE_INVALID			0x0000
> #define IB_NL_DATA_TYPE_NAME			0x0001
> #define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
> #define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
> #define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
> #define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005
> #define IB_NL_DATA_TYPE_MAD			0x0006
>=20
> #define IB_NL_FLAGS_PATH_GMP			1
> #define IB_NL_FLAGS_PATH_PRIMARY		(1<<1)
> #define IB_NL_FLAGS_PATH_ALTERNATE		(1<<2)
> #define IB_NL_FLAGS_PATH_OUTBOUND		(1<<3)
> #define IB_NL_FLAGS_PATH_INBOUND		(1<<4)
> #define IB_NL_FLAGS_PATH_INBOUND_REVERSE 	(1<<5)
> #define IB_NL_FLAGS_PATH_BIDIRECTIONAL		(IB_PATH_OUTBOUND | IB_PATH_INBOU=
ND_REVERSE)
> #define IB_NL_FLAGS_QUERY_SA			(1<<31)
> #define IB_NL_FLAGS_NODELAY			(1<<30)

Please keep these in numerical order, don't put <<31 and below it <<30

> struct ib_nl_data_hdr {
> 	__u8	version;
> 	__u8	opcode;
> 	__u16	status;
Drop status because we fold it into opcode
> 	__u16	type;
> 	__u16	reserved;
Drop reserved because we don't need alignment any more
> 	__u32	flags;
Flags is the only thing using bits fast, and we would want to make this
header an even 128bits in length, so add a __u32 reserved; here.  That's
more likely to be useful than the current layout since we are likely to
run out of flags before anything else.
> 	__u32	length;
> };
>=20
> struct ib_nl_data {
> 	struct ib_nl_data_hdr		hdr;
> 	__u8				data[0];
> };
>=20
>=20
> These defines and structures can be added to file include/upai/rdma/rdma_=
netlink.h (replace with
> RDMA_NL prefix) or contained in a seperate file (include/upai/rdma/ib_net=
link.h ???).=20
>=20
> Please share your thoughts.

I think an extensible netlink framework here is the right way to go,
certainly better than the one shot method you had first.

> Kaike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-nB3uSDb8aYoWIkGhqezb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXhQKAAoJELgmozMOVy/d4iYQAKwkxQRk20HwJYt+1JfUuheo
CYtNR0piMB88SV6id3FyPKM3JtP8OqZNGYih5oxgyMyovIs9NwAe29JbFLjX/s+l
Esw86A/azw1wmtnbIKWwX+DeL9K+neQS8RQVZjNeM7p5ciALCecCjJFXhHZ+2cLj
qDPrpXRvJXG3K2l5n/iprGbjJ1O8iqY4r8VEodVL+6l3yEBB5i3sQYScvEdh6F2Z
FA9bJDjTJ2u0aD96LAfPpLdVxJp3TTITUJKj58rXaEDF574oaZfA9QUsePc1GpKy
p845oC7gSBL7glAKjE73r6a+sxzNlDn0yVGAsTPG426nbuObNRuoVh6SA09hHwu5
/MvPA9yPDp3N+Zw/0kkfyYZ/wlfxydGp/7k6KbLnN+4WEIBPgZtdw1FYd3fx5nD/
bBfkcJwkY6WgpgV/nxuUFROl0HwRxFw2TsHjmXlMFcKcoY7HmOrb4reP83qLJiBL
X1DxMV7JNSO4Li/Go6/kXM7HeQFA8NhxPzomWuFyqPonhJroXe1ajErbZ7DX/rFU
A3c3aCptDzePXGs/UfafjNWnvkW5xP9PxXCPQYAWzS6CN7TMAXEoTE0kyG2OoNB4
KEflJ48GbdnS7M1V/mHepQZJZf7b+OazDHVKaTbYHwucXNbMFS1FKI5mSlW2lKsy
FlWl5KAodpMHw+HQrx4w
=PgL2
-----END PGP SIGNATURE-----

--=-nB3uSDb8aYoWIkGhqezb--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
