From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 0/4] IB cache port state, use it when resolve address
Date: Thu, 12 Jan 2017 23:02:03 -0500
Message-ID: <1484280123.123135.55.camel@redhat.com>
References: <CAMGffE=-dN6jpJUHyNEHra1P=SLYiO47pMbMoKSNf6Njy=znKA@mail.gmail.com>
         <CAMGffE=xA9GMMWAKPMzAtWxHBSbBVft04LjB+fhc0mLRjmEXfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Wup9S5IuGaTCfpSqxlyz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=xA9GMMWAKPMzAtWxHBSbBVft04LjB+fhc0mLRjmEXfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Wup9S5IuGaTCfpSqxlyz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-11 at 13:26 +0100, Jinpu Wang wrote:
> On Mon, Jan 2, 2017 at 1:15 PM, Jinpu Wang <jinpu.wang@profitbricks.c
> om> wrote:
> >=20
> > Hi Folks,
> >=20
> > This is my forth attempt to fix rdma_revolve_addr may resolve to
> > first
> > port even it's down[1].
> >=20
> > As Jason and Hefty suggested, I now cache port_state in ib_core,
> > and
> > update cma_resolve_ib_dev and cma_bind_loopback to use it.
> >=20
> > 0001-IB-core-add-port-state-cache.patch
> > 0002-IB-core-export-ib_get_cached_port_state.patch
> > 0003-cma-resolve-to-first-active-ib-port.patch
> > 0004-cma-use-cached-port-state-when-bind-loopback.patch
> >=20
> > [1]http://marc.info/?l=3Dlinux-rdma&m=3D148102306632521&w=3D2
> >=20
> > Changes from v1:
> > - Add Hefty's Acked-by.
> > - rebase on Doug's rdma/k.o/for-4.10 (commit
> > 5cc8fabc5e4c588c75a5ec21423e7c3425f69f48)
> > - fix a mem leak in ib_cache_setup_one in error case in first
> > patch.
> >=20
> > --
> Ping Doug?

Sorry, I didn't see this before I wrote my last email. =C2=A0You've already
captured Sean's acks, that's good. =C2=A0You modified the first patch in a
way that negates the comment request I made, so that's fine. =C2=A0But the
patches are still coming through mangled. =C2=A0If you look at them in
patchworks, you can see telltale signs, such as seeing part of the
patch in the patchwork comments and then the full patch later on in the
patch section. =C2=A0When I download those patches, they are mangled. =C2=
=A0You
can *not* both send the patch inline and as an attachment. =C2=A0The
prefered way to send patches, if your mailer is messing with your
submissions, is to use "git send-email" and let it send the patches
directly for you.

However, this time I have fixed the patches up and applied them, but
please don't send mangled patches like this in the future.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Wup9S5IuGaTCfpSqxlyz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYeFE7AAoJELgmozMOVy/d9/IP/A9d9LMTGe9M9grkdW01QFQU
LtmxEgDBKm6TQ71hKYmJlm/bdpw0vtdf7p0BSW8buC8TgmcFNcpb0SDgdvT6pSh3
6BJP8pTVoycODx1bp9zCUu6AmU8soRr8v6DNq5Jtl/oL7v6aLnwzbsLy6Vm0jekH
wAbOqms81DU+po51cIchakzrLVGW1kVCxO1YHxo3CsxdyPNqdA+sEpEn/RD6k8VR
Aj9glp7oBXADpHtpA5EG4tejWxTzujl8bUj9JGXpsWWKTnGa/lqEfq5+uJSAQtcq
TYMTKvWAyBHvPTl6E0GyNHX4aCbpFk7PuMKIftpuKG8RA624TIIPZ1vTtZ1ZBhOO
AFiK/6TgLTDlz5ipGZQ8Wd/Dx+U2hsbeF8sN3ssvtDTyAjn2GMQ2eifWveceJqGj
UYNn/bFJZJrzxe/Jo7Chz6pqf5wOitJMdvPpD3+bsSu2KIu/xlC4bFomAQNfV4H4
EX203QYPd9PptRyF/7+TXYeN0Ze+bi/Xg+S4nNrOziTvYCUGg/r+bo+s6ozzNWJ9
QJ1rDTVdqPqxPVinUjrCwVaXS757f71R3AFyBQMnjwpsdpkhvQx6RnF5OP+4J2fC
71lZSCGcsugBnzxF2OMspembJBBTRdj8JQfnssynrISVQ3rs29YCsDq2uwU6jBqx
pi5WOgD6GB94qQKm9WP6
=7ua2
-----END PGP SIGNATURE-----

--=-Wup9S5IuGaTCfpSqxlyz--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
