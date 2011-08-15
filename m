From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 02/37] add opcodes to ib_pack.h
Date: Mon, 15 Aug 2011 11:15:58 -0500
Message-ID: <03e001cc5b66$9e9b6e40$dbd24ac0$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.204265835@systemfabricworks.com> <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Originally I had xrc support in rxe but there was nothing in Roland's t=
ree
to support it so I stripped it out.
I was experimenting with congestion notification to see if there was a =
way
to slow down spewing by fast Ethernet devices but that wasn't working, =
also
all the MAD support was stripped out. In the end the only thing left wa=
s the
constants and entries in the opcode table in rxe_opcode.c which as you =
say
are not used elsewhere. I think it is reasonable to have a complete set=
 of
opcodes somewhere.

I want to eventually complete the IB transport parts of the driver alth=
ough
they are not used by RoCE. They would be useful for a soft IB implement=
ation
with say an FPGA based MAC/PHY. The long term goal is to have a complet=
e
reference implementation of the IB Architecture.

> -----Original Message-----
> From: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On
> Behalf Of Bart Van Assche
> Sent: Monday, August 15, 2011 4:13 AM
> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 02/37] add opcodes to ib_pack.h
>=20
> On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wro=
te:
> >
> > Bring up to date with the current version of the IBTA spec.
> > =A0 =A0 =A0 =A0- add new opcodes for RC and RD
> > =A0 =A0 =A0 =A0- add new groups of opcodes for CN and XRC
> >
> > Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
> >
> > ---
> > =A0include/rdma/ib_pack.h | =A0 39
> ++++++++++++++++++++++++++++++++++++++-
> > =A01 file changed, 38 insertions(+), 1 deletion(-)
> >
> > Index: infiniband/include/rdma/ib_pack.h
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- infiniband.orig/include/rdma/ib_pack.h
> > +++ infiniband/include/rdma/ib_pack.h
> > @@ -75,6 +75,8 @@ enum {
> > =A0 =A0 =A0 =A0IB_OPCODE_UC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x20,
> > =A0 =A0 =A0 =A0IB_OPCODE_RD =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x40,
> > =A0 =A0 =A0 =A0IB_OPCODE_UD =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x60,
> > + =A0 =A0 =A0 IB_OPCODE_CN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0=3D 0x80,
> > + =A0 =A0 =A0 IB_OPCODE_XRC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =3D 0xA0,
>=20
> A convention when submitting Linux kernel patches is to add only thos=
e
> constants that are actually used in the code submitted in the same
> patch series. So I'm not sure it's fine to add the XRC constants in
> ib_pack.h through the rxe patch series.
>=20
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
