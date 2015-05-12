From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: update the official rdma git repo
Date: Tue, 12 May 2015 10:22:52 -0400
Message-ID: <1431440572.43876.22.camel@redhat.com>
References: <2936ae04aa5d7ebfd9921e363a8e8686f8bb5936.1431393236.git.dledford@redhat.com>
	 <CAJ3xEMj6Hz+C=-CWwkefE+eDtcpUx=q74FhBbk-H2D+sOu2U_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-RLGXrGyJQXFlQgx+G7SY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj6Hz+C=-CWwkefE+eDtcpUx=q74FhBbk-H2D+sOu2U_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-RLGXrGyJQXFlQgx+G7SY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 16:30 +0300, Or Gerlitz wrote:
> On Tue, May 12, 2015 at 4:13 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > Linus prefers kernel.org repos to github repos for security.
> >
> > Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 40c14f14204d..c1911a7adb4f 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5048,7 +5048,7 @@ M:        Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8@public.gmane.org=
m>
> >  L:     linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >  W:     http://www.openfabrics.org/
> >  Q:     http://patchwork.kernel.org/project/linux-rdma/list/
> > -T:     git git://github.com/dledford/linux.git
> > +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma=
.git
>=20
> Hi Doug,
>=20
> Could you upload your for-4.2 branch from github to the new spot?

I only plan to upload it once I'm sure it's not going to change.  The
github for-4.2 branch was an early branch that doesn't even have v8 of
Michael's patchset (I think that brnach was made with v7).

> Also, re the series from Michael, is the review done or still some open i=
ssues?

I'm going to go ahead and take the v8 of the set as it is.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-RLGXrGyJQXFlQgx+G7SY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUgy8AAoJELgmozMOVy/dE8sQAIdTykj2QZkFsFZt6u635+qC
x/1uDiwsWMxz+1EC/mql3G8A3HU+90JPfNv/bZXf8DKq5SGq98Gf+K24f8+9+6wT
kDBdb06tsJUUQK6+l6rcTotoXOWkK0VLbSWRBXFFcINYMAEiP45VF+zxvfHMl7Fg
zd1K6RRBiAI2znWUyVN9SoM8krROGYJ8BeJd8v3ezIPkJkiEHkiVazeSTkQNXXWK
EqqNxDUQFMenz5h3H6P9ZLbIXSfrTQ0m3G0htu2j8lD98yCgNkIl7TRfW0QQ8TtL
tlLDtlMhR3euIpDvSUxbOIFmg41VsOEKZlHI6NbFcgpl9HWmZ+/++S3OOujALohu
PwF/jv31qrLRuzEmsOlG85Fh6JZTFx/7T72UMnDbrbEclY74QKZlL9SHHvyn/PEq
+TsJ7zU6EWbRPIv+2hVyP3eYk8LOZ1Ychwlrll4+YHyGyLFxRFnKdFFiS6kDBTDz
unXigpflT4NrIanjQuHL5cu6jHZxA3U9Mx9/QIXQg9qJCUoOY0eI/MRACmCEXadR
Jowa4seH02Y3mx9HTdV0V015U0VEgbQVE5MV4KVOF+wrjh2NruhoBJKYAxIQp863
c6JHc3lS303NfZCu4wyuA6dM7MWuL8MIB+BRr/YYd1hgojtn6CZlwcnJyYyVDpJv
lbOThk9wcvAMFaRtxt+n
=iK+b
-----END PGP SIGNATURE-----

--=-RLGXrGyJQXFlQgx+G7SY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
