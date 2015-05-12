From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Tue, 12 May 2015 13:21:47 -0400
Message-ID: <1431451307.43876.67.camel@redhat.com>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com>
	 <1431432329-859-2-git-send-email-sagig@mellanox.com>
	 <CAJ3xEMhOnrZJrUfwtMs7Tod7YeGy_Be6yF543+xds_05hO-F-A@mail.gmail.com>
	 <E27932C3-BDF3-4FED-ABD6-416454EFA5C0@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-BKiQit7qdLXpPfAe+jqL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E27932C3-BDF3-4FED-ABD6-416454EFA5C0-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-BKiQit7qdLXpPfAe+jqL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 09:56 -0400, Chuck Lever wrote:
> On May 12, 2015, at 8:59 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > On Tue, May 12, 2015 at 3:05 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> >> Some of us keep revisiting the code to decode enumerations that
> >> appear in out logs. Let's borrow the nice logging helpers that
> >> exists in xprtrdma and rds for CMA events, IB events and WC statuses.
> >=20
> > [...]
> >=20
> >> +static const char * const cma_events[] =3D {
> >> +       [RDMA_CM_EVENT_ADDR_RESOLVED]   =3D "ADDR_RESOLVED",
> >> +       [RDMA_CM_EVENT_ADDR_ERROR]      =3D "ADDR_ERROR",
> >> +       [RDMA_CM_EVENT_ROUTE_RESOLVED]  =3D "ROUTE_RESOLVED",
> >> +       [RDMA_CM_EVENT_ROUTE_ERROR]     =3D "ROUTE_ERROR",
> >> +       [RDMA_CM_EVENT_CONNECT_REQUEST] =3D "CONNECT_REQUEST",
> >> +       [RDMA_CM_EVENT_CONNECT_RESPONSE]=3D "CONNECT_RESPONSE",
> >> +       [RDMA_CM_EVENT_CONNECT_ERROR]   =3D "CONNECT_ERROR",
> >> +       [RDMA_CM_EVENT_UNREACHABLE]     =3D "UNREACHABLE",
> >> +       [RDMA_CM_EVENT_REJECTED]        =3D "REJECTED",
> >> +       [RDMA_CM_EVENT_ESTABLISHED]     =3D "ESTABLISHED",
> >> +       [RDMA_CM_EVENT_DISCONNECTED]    =3D "DISCONNECTED",
> >> +       [RDMA_CM_EVENT_DEVICE_REMOVAL]  =3D "DEVICE_REMOVAL",
> >> +       [RDMA_CM_EVENT_MULTICAST_JOIN]  =3D "MULTICAST_JOIN",
> >> +       [RDMA_CM_EVENT_MULTICAST_ERROR] =3D "MULTICAST_ERROR",
> >> +       [RDMA_CM_EVENT_ADDR_CHANGE]     =3D "ADDR_CHANGE",
> >> +       [RDMA_CM_EVENT_TIMEWAIT_EXIT]   =3D "TIMEWAIT_EXIT",
> >> +};
> >=20
> > Sagi,
> >=20
> > My vote goes to using easy-to-digest human-readable non-capital
> > letters strings here and
> > elsewhere (IB events, etc),  as done today by the NFS code and
> > generally by errno based
> > helpers such as strerror, e.g
> >=20
> > "address resolved"
> > "address error"
> > "route resolved"
> >=20
> > Will be happy to hear what others think
>=20
> I generally prefer spelled-out strings over symbol names.
>=20
> For the strings in xprtrdma, I looked up the symbols in the IBTA spec,
> and used part of the description of each error. It=E2=80=99s obvious in m=
ost
> cases, but there are one or two that are a little odd (eg. MW_BIND_ERR
> is =E2=80=9Cmemory management operation error=E2=80=9D).

Likewise, I prefer the more complete description to a simple
regurgitation of C preprocessor symbols.  Aside from that, I'm glad to
see this patchset come along because I hate looking up error numbers
too.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-BKiQit7qdLXpPfAe+jqL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUjarAAoJELgmozMOVy/drtoP/3/z8SN9IAuqtTWzEpClIQ0N
Xc1CDILV1iR86JZEBo/PV6Xzue93GWU361OcYjj+9TM8Vz8xP5FlK8IDaWq00SFe
UIMjS0B4mCMffjxEIXv80HiaDWuGc8NZai6w38Nz21DplTJZQ9TZxr4XTi+ikEPo
LoU114EVj9qelC9IC3vcZmJd8ZdYLl61YePP8mForbsqnKbWkSSqrQ4VlbI0+X4H
rmG6vJM08JEAkrxXShQed3fP8fTtj1OIC64OsLk2rBQ5ZpmmKI4WRjAX1eT31Cec
sLp2OVY+obDK4XKyinktGVsiEOM0zuOBbugix20dhRameOM3aHkKG9gW4qb7aGKM
p9YjLAzuRb9kYttlc5HixooQCzsbyOuvqNOEUhggBa7jjQpO23gsMBplCXvfe9t1
dYi5QJADlwDycVGFnR7e/j2ZesHhm27q8oLMSTp04X95VMZ90iFidVJh1Xt0Q7vw
kDmKUePw2vzIpKkzkAgUdf8I5v9dAWyL81ShJwqTZMquWTUqDvZVt7vIsqv1G/lQ
F31JExWQ3up8DfDj/oIUOUTUf/cf0R45m7v1uyAQYDw+TN+wkIk3dI3nx2+ceULq
hkNcWLvNeZzUQCgDh1fkcdmmDgN6YXIcG26ZKo25qBelf/PRLUk2ZMRVU0X5NlPr
GTFDy+/gecUyF6ogklsr
=A6wb
-----END PGP SIGNATURE-----

--=-BKiQit7qdLXpPfAe+jqL--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
