From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 10:59:52 -0400
Message-ID: <1429714792.45956.110.camel@redhat.com>
References: <5534B8C9.506@profitbricks.com>
	 <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-55hfIPu8y1J8l28xYL8Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0-xsq7jzH2t6llkovD9u25SNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-55hfIPu8y1J8l28xYL8Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-04-21 at 23:36 +0000, Liran Liss wrote:
> Hi Michael,
>=20
> The spirit of this patch-set is great, but I think that we need to clarif=
y some concepts.
> Since this will affect the whole patch-set, I am laying out my concerns h=
ere instead.
>=20
> A suggestion for the resulting management helpers is given below.
> I believe the result would be much more coherent.
> --Liran
>=20
> In general
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> An ib_dev (or a port of) should be distinguished by 3 qualifiers:
> - The link layer:
> -- Ethernet (shared by iWARP, USNIC, and ROCE)
> -- Infiniband
>=20
> - The transport (*)
> -- IBTA transport (shared by IB and ROCE)
> -- iWARP transport
> -- USNIC transport
>=20
> (*) Transport means both:
> - The L4 wire protocols (e.g., BTH+ headers of IBTA, optionally encapsula=
ted by UDP in ROCEv2, or the iWARP stack)
> - The transport semantics (for example, there are slight semantic differe=
nces between IBTA and iWARP)
>=20
> - The node type (**)
> -- CA
> -- Switch
> -- Router
>=20
> (**) This has been extended to also encode the transport in the current c=
ode.
> At least for user-space visible APIs, we might chose to leave this for ba=
ckward compatibility, but we can consider cleaning up the kernel code.
>=20
> So, I think that our "old-transport" below is just fine.
> No need to change it (and you aren't, since it is currently implemented a=
s a function).
>=20
> The "new-transport" does not really exist, but is broken into several cap=
ability checks of the L4 transport, optionally with conditions on the link =
type.
> I would remove the table below and tell what we really want to achieve:
> =3D=3D> move technology-specific feature-check logic out of the (multiple=
!) IB code components and various ULPs into per-feature helpers.
>=20
>=20
> Detailed remarks
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1) The introduction of cap_*_*() stuff should have been introduced direct=
ly in patch 02/27.
> This back-and-forth between rdma_ib_or_iboe() and cap_* is confusing and =
increases the number of patches in the patch-set.
> Do this and remove patches 16-24.
>=20
> 2)The name rdma_tech_* is lame.
> rdma_transport_*(), adhering to the above (*) remark, is much better.
> For example, both IB and ROCE *do* use the same transport.=20

I especially want to second this.  I haven't really been happy with the
rdma_tech_* names at all.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-55hfIPu8y1J8l28xYL8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN7doAAoJELgmozMOVy/d084P/jaY1G2WnblDIe8XYRbs/RbN
gw+ivTxdIKS7Hwi1Fs6z8OZ5Kf8FgVEpqarwiLLOLHfz/tStp1fqP+DanluD8M6b
hGlJVxeQOQd+6KQ2XtIilrS7/UqpwH9cltYWtPfClo5wA1r/NNIlaSwOAtZgT/xD
os35/bwNLAxLfKD0doZOiAxo29Ruq54/ytl1NjGublIVNY3zZ5qGNBekjIByNoru
drDA2iQFoQe2xIg4HdHkCOWyZPvDyNpx9TnM56AKcd/z+acY+M5nbQyqRdIB9lKd
jZ5SALGWlD5EJl0ZhwaS3EUyIEPvej4453zEKG0h7FrLU+pPrGrwd4PuG/12xxzn
EXOOkG/ukVrS8Es/6K5QUU6JXUSEjE2/WfCgtE8xHcgY0lmILG1C3rLXKkgIjcfR
WuecKd2ZD1WndDtcM/LITXwmWWhjMcSeHJpazuRHcHcupv/HbUPOFulMs/75nZie
hhg3S7kjJ1uAt0Q/zvngdh38i6Qhokkv7pC2PIZ+mmvFRxynOesz8ntb/ck9k/iw
xKhn69bdjbeEfS/YsUAhd4p7bxfdZtapC2AkJFH+Bm+bOMdi767c4g8w/bzpiT4D
ezgU+1GB4vPgOd3FW7IgKAS4IRidQmQ4o6mGdhEGhjY4dkeiWuiechGBJ3p/Zvw0
PcVnriuXhPPKZFgN+11x
=Kpeu
-----END PGP SIGNATURE-----

--=-55hfIPu8y1J8l28xYL8Z--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
