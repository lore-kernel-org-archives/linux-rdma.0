From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core debian/master branch
Date: Thu, 16 Nov 2017 11:17:48 +0200
Message-ID: <20171116091748.GH18825@mtr-leonro.local>
References: <1510658470.4026.27.camel@profitbricks.com>
 <20171114184725.GH18825@mtr-leonro.local>
 <1510686066.4026.43.camel@profitbricks.com>
 <20171116064730.GG18825@mtr-leonro.local>
 <1510822703.4026.79.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E34ZW7oKuETSiVN+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510822703.4026.79.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--E34ZW7oKuETSiVN+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 16, 2017 at 09:58:23AM +0100, Benjamin Drung wrote:
> Am Donnerstag, den 16.11.2017, 08:47 +0200 schrieb Leon Romanovsky:
> > On Tue, Nov 14, 2017 at 08:01:06PM +0100, Benjamin Drung wrote:
> > > Am Dienstag, den 14.11.2017, 20:47 +0200 schrieb Leon Romanovsky:
> > > > On Tue, Nov 14, 2017 at 12:21:10PM +0100, Benjamin Drung wrote:
> > > > > Hi,
> > > > >
> > > > > I have a debian/master branch in my personal rdma-core fork:
> > > > > https://github.com/bdrung/rdma-core/commits/debian/master
> > > > > In addition, I tagged the upload with debian/15-1.
> > > > >
> > > > > This branch contains the exact content of the uploaded package
> > > > > to
> > > > > Debian. It would be nice if this branch could be included in
> > > > > the
> > > > > linux-
> > > > > rdma/rdma-core repository.
> > > >
> > > > Is it possible to align it with stable-v15 branch?
> > >
> > > Not really. This branch is more or less aligned with the master
> > > branch
> > > (as long as Debian does not hit the feature freeze), i.e. I will
> > > upload
> > > rdma-core 16 to Debian unstable once it is released (instead of
> > > 15.1).
> >
> > Last question, will this branch be rolling or you will need to create
> > new branch for "next" unstable?
>
> This will be a rolling branch which reflects the content of Debian
> unstable. There might come some additional branches like debian/stretch
> for the stable releases.

Thanks, I'm fine to add new branch for debian, but would like to hear
other feedback too, before doing it.

>
> Explanation for the naming:
> http://dep.debian.net/deps/dep14/
>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL: https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=E4ftsf=FChrer: Achim Weiss, Matthias Steinberg



--E34ZW7oKuETSiVN+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloNV7wACgkQ5GN7iDZy
WKfz7g/+NHwHm1zoGzWvdxCfEwVWfW5UxggZy5kwfCfNqHmIqnPBk1JqKaMtsinC
ocryHLnf4aeXkqRltriS8PKVZYIZ68Vkp9jhTKOSSSSIrkLueF5lpYxBM/81G5Ll
weUJoNzfahtQMEicIdeg6vDmF+bcgcqDWi5oqarQ7H96HrS/qt02vjET6k6Wyo/P
OlsXNg9pcKb29flNTBxWlktngU4Jb1W19DBwWNT45ImKaO/xeYipb1ede/IwkYWx
g3nbSRftD2jSUGaeGYvkaaqPAFbxldsWBGAR8OQSoIuA6mGLYajkOzozZqTmH2KQ
qBl5T+bgyJm3o+eI5fZDhN5jk1eoK63LeQ8LhU73VrVE5mulsZQWNi0WUwDcOHWw
QZnwNEeORfKXdzFw3IZ4Vp726cR6RusTpewqoH1GjsWPrddlX3REvl0fox7cEosE
ntqe7zTvW/QVNNbOgN0b/yRO479AtzBoIQzTimX2XzxCIs64n1OEcpxYgyJHiT9r
KqO4X4FXjJcxoAIH/C3dHQrf1CAlRzQ3o9ElpnDawX3+QwySBgVi1aYIh1aMootx
EtB1fhliWSjoiHQsMIaR7ua3i6S4Nztc6Jofp5of9G2vmoZvePgEpiyW9mJP5zuy
DvNYj068PnP3Q3CKGFu9xfUwkYfI50Ws46TE1BNnGvCoDGgoqLQ=
=bH/1
-----END PGP SIGNATURE-----

--E34ZW7oKuETSiVN+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
