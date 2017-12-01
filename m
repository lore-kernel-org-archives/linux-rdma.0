From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Fri, 01 Dec 2017 19:13:05 +0100
Message-ID: <1512151985.9183.4.camel@profitbricks.com>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
         <20171130174750.GD7754@ziepe.ca> <1512066118.4246.2.camel@profitbricks.com>
         <20171130185822.GE7754@ziepe.ca> <1512079788.3878.1.camel@profitbricks.com>
         <20171201055732.GC8126@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LUsWcY1gAmehn8pX3gpw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171201055732.GC8126-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-LUsWcY1gAmehn8pX3gpw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 01.12.2017, 07:57 +0200 schrieb Leon Romanovsky:
> On Thu, Nov 30, 2017 at 11:09:48PM +0100, Benjamin Drung wrote:
> > Am Donnerstag, den 30.11.2017, 11:58 -0700 schrieb Jason Gunthorpe:
> > > On Thu, Nov 30, 2017 at 07:21:58PM +0100, Benjamin Drung wrote:
> > > > Am Donnerstag, den 30.11.2017, 10:47 -0700 schrieb Jason
> > > > Gunthorpe:
> > > > > On Thu, Nov 30, 2017 at 01:39:37PM +0100, Benjamin Drung
> > > > > wrote:
> > > > >=20
> > > > > >   debian: Add m68k as non-coherent DMA architecture
> > > > > >   debian: Mark libraries as Multi-Arch: same
> > > > >=20
> > > > > As Leon says, shouldn't these go on the mainline branch also?
> > > >=20
> > > > The complete patch set targets the master branch.
> > >=20
> > > Oh, I see how you working this, I saw them already applied to the
> > > debian branch and didn't quite get it :)
> > >=20
> > > Looks fine to me
> >=20
> > Since you approved these change, may I do the rebase and merge to
> > master
> > or is that task restricted to certain people or workflows?
>=20
> debian/* is yours, feel free to merge it.

GitHub does not allow to rebase & merge the pull request. Is there any
reason to not allow the rebase & merge workflow? My commits are atomic
and the git history is cleaner without the merge commits.

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg
--=-LUsWcY1gAmehn8pX3gpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaIZuxAAoJEN2M1aXejH56kjsP/092o5dG4FxCulkDCDIJXrKQ
5rZOl/MmHbEeNwUVjKgtHz4MIleV4rrNfJYkAe65xSF3qS/9XgwwWK7aG1ug4Fgt
fU5S6y7QUrIVsoFHTri9EzlFRipFjZkJm8xIHTOUElGxAQoX7+DCVXHYIpleR8Zn
PMxiysKscsJYeW5/xH9lshS6Z4c1io7Hii78UpgT+sPVfFyxJzFGTO2Tknq/iHuq
KnNtn0Szxd2NifUw9+ZtPaBRgU2DF4Q64wqr3TLRLtuvGSu3OzBDKGZFD9HD2up8
9mt4BnUU4ZejrUjr0pApO2xKJxk4gUTkKbG2t+L8mSs5wzQmJZa0IsRVH9ztKg70
BYIQhK69fK4qWdJasWLm8Tt40fQIkoCk8Vwg1wWT5qT9vP//FlL5qi8gmSr+GBbL
hBnlteb/zjgoaUSJse8EEyIdVVYo8Btp3PuWPXDOhiWNN5o7ATs0HOR0bgCyjEco
vj6OD+1MhosIuPcRGnns2OZgFK9vF4t9zsE5k+z4wOqy6F5kE0xDHsDma93riUDX
jDT6hBFGhphldprNtclApqgKjvS1iYE4alOCySv72+kkAfCDMXX0/JMXQ1K/ITnt
lHDdNY/lkJB7xKOtOpMHgfhRnSuVtMjcEFn7Rghd2/BO30TQIs/ROGlIQ9pGB5kE
zO1SMXY0SORJVW+NwEkR
=TLvQ
-----END PGP SIGNATURE-----

--=-LUsWcY1gAmehn8pX3gpw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
