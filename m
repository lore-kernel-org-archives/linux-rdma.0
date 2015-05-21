From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 13:35:23 -0400
Message-ID: <1432229723.28905.40.camel@redhat.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
	 <1432228874.28905.35.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aoDumVZyl8GHpthh7k1g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432228874.28905.35.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-aoDumVZyl8GHpthh7k1g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 13:21 -0400, Doug Ledford wrote:
> On Thu, 2015-05-21 at 13:52 +0000, Wan, Kaike wrote:
> > In our previous posting to the mailing list, we proposed to send a MAD =
request from kernel (more
> > specifically, from ib_sa module) to a user space application (ibacm in =
this case) through netlink.
> > The user space application will send back the response. This simple sch=
eme can achieve the goal=20
> > of a local SA cache in user space.
> >=20
> > The format of the request and response is diagrammed below:
> >=20
> >   ------------------
> >   | netlink header |
> >   ------------------
> >   |     MAD        |
> >   ------------------
> >=20
> > The kernel requests for a pathrecord, and the user application finds it=
 in its local cache and sends
> > it to the kernel. If the netlink request fails, the kernel will send th=
e request to SA through the
> > normal IB path (ib_mad -> hca driver -> wire).
> >=20
> > Jason pointed out that this message format was limited to lower stack f=
ormat (MAD) and its use
> > could not be readily extended to upper layer modules like rdma_cm. Afte=
r lengthy discussions, we=20
> > come up with a new and modified scheme, as described below.
> >=20
> > The general format of the request and response will be the same:
> >=20
> >   ------------------
> >   | netlink header |
> >   ------------------
> >   |  Data header   |
> >   ------------------
> >   |      Data      |
> >   ------------------
> >=20
> > The data header contains information about the type of request/response=
, the status (for response),
> > the type (format) of the data, the total length of the data header + da=
ta, and a flags field about
> > the request/response or data.
> >=20
> > Based on the type of the data, the data section may be in different for=
mat: a string about the host
> > name to resolve, an IP4/IP6 address, a pathrecord, a user pathrecord (s=
truct ib_user_path_rec),
> > or simply a MAD (like our posted patches), etc. Essentially it can be o=
f any format based on the=20
> > data type. The key is to document the format so that the kernel and use=
r space can communicate=20
> > correctly.
> >=20
> > The details are described below:
> >=20
> > #define IB_NL_VERSION		0x01
> >=20
> > #define IB_NL_OP_MASK		0x0F
> > #define IB_NL_OP_RESOLVE	0x01
> > #define IB_NL_OP_QUERY_PATH	0x02
> > #define IB_NL_OP_SET_TIMEOUT	0x03
> > #define IB_NL_OP_ACK		0x80
>=20
> If OP_ACK is one bit, why isn't the OP_MASK 0x7f?
>=20
> > #define IB_NL_STATUS_SUCCESS	0x0000
> > #define IB_NL_STATUS_ENODATA	0x0001
>=20
> Do we need 16 bits for a bool?  In fact, couldn't this actually be
> switched so that the return of the message uses OP_SUCCESS instead of
> OP_ACK?
>=20
> In other words, instead of two items here, couldn't the ACK bit be
> dropped entirely and replaced with SUCCESS so that when the user app
> returns the netlink packet, if the op on return =3D=3D to the op on send,=
 it
> failed, if it's op | SUCCESS, it succeeded?
>=20
> > #define IB_NL_DATA_TYPE_INVALID			0x0000
> > #define IB_NL_DATA_TYPE_NAME			0x0001
> > #define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
> > #define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
> > #define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
> > #define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005
> > #define IB_NL_DATA_TYPE_MAD			0x0006
> >=20
> > #define IB_NL_FLAGS_PATH_GMP			1
> > #define IB_NL_FLAGS_PATH_PRIMARY		(1<<1)
> > #define IB_NL_FLAGS_PATH_ALTERNATE		(1<<2)
> > #define IB_NL_FLAGS_PATH_OUTBOUND		(1<<3)
> > #define IB_NL_FLAGS_PATH_INBOUND		(1<<4)
> > #define IB_NL_FLAGS_PATH_INBOUND_REVERSE 	(1<<5)
> > #define IB_NL_FLAGS_PATH_BIDIRECTIONAL		(IB_PATH_OUTBOUND | IB_PATH_INB=
OUND_REVERSE)
> > #define IB_NL_FLAGS_QUERY_SA			(1<<31)
> > #define IB_NL_FLAGS_NODELAY			(1<<30)
>=20
> Please keep these in numerical order, don't put <<31 and below it <<30
>=20
> > struct ib_nl_data_hdr {
> > 	__u8	version;
> > 	__u8	opcode;
> > 	__u16	status;
> Drop status because we fold it into opcode
> > 	__u16	type;
> > 	__u16	reserved;
> Drop reserved because we don't need alignment any more
> > 	__u32	flags;
> Flags is the only thing using bits fast, and we would want to make this
> header an even 128bits in length, so add a __u32 reserved; here.  That's
> more likely to be useful than the current layout since we are likely to
> run out of flags before anything else.
> > 	__u32	length;
> > };
> >=20
> > struct ib_nl_data {
> > 	struct ib_nl_data_hdr		hdr;
> > 	__u8				data[0];
> > };
> >=20
> >=20
> > These defines and structures can be added to file include/upai/rdma/rdm=
a_netlink.h (replace with
> > RDMA_NL prefix) or contained in a seperate file (include/upai/rdma/ib_n=
etlink.h ???).=20
> >=20
> > Please share your thoughts.
>=20
> I think an extensible netlink framework here is the right way to go,
> certainly better than the one shot method you had first.

The one thing I left out of the above that might be worth changing is
the fact that you bury your sequence number down in your mad header.  If
there is a generic mechanism that multiple modules can use to send
customized data via nl, then it might be worthwhile to have the sequence
moved to the generic level.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-aoDumVZyl8GHpthh7k1g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXhdbAAoJELgmozMOVy/d0lgP/iRR6/AkXBb2JD5TLKfMJXpX
4KO8rxqfhHz7g9rqLWZXZBzGKcHia9Ki5s9shcxHGIxFN4lGa2QXotkkvjv3BZku
Ee1T/cL9wuDIHu61c767NY1uKT8oYm2dXRSEZ/tMLbkVYsBhg4zvUCV2VRppGbzG
3amCG5Gw+s4yt7vrbLZTi9BbTMLtLg51unEmXnwPgL0OCt6ngD0jbvjcyjHjCddP
x5a1bUiQBOHG513z9FiMrlA3eTscQErYV5eiyq1Qj2Bt5JAkdC8xYxG0mOUagxpq
iVH9W2ulc/XCTOEBQxUs1BdWl+bSFdmHPgj4hwp9ix8sADf2ojJmwn/LAvbLvcl2
ouo6oLq6ePLEguCPZZNs1wsF8VHl3aUdzebWdNc2Oh2F6j9XAs2rPEnIr4a7BxrN
dC4VgABwomT6DsXLkLcQRKke0eOacmsuxt0GguiXkRHzmMmiyhaj87rPyS50vXR+
5A4rtbNdSTaDwlCbdDYTx6ttAATCNBhKl2yxE9tKA2oSZz9rGEA3BGWqjeUoekFb
OFpLCf4bAkzVcOEBiEuEgym+EJZHlto5yfMD02In2C6NMRKNP2MJ/mxHVEs8Lhlc
I5lLCUPvvRphzP7Lwis1axOUAyjvvDmEejux9Tf9Vi5bHzDJ757RmBFabEs/4VUw
wrEnj5i2AB0P7IHCHakc
=paaW
-----END PGP SIGNATURE-----

--=-aoDumVZyl8GHpthh7k1g--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
