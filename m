From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Fri, 1 Dec 2017 07:57:32 +0200
Message-ID: <20171201055732.GC8126@mtr-leonro.local>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
 <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512079788.3878.1.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2017 at 11:09:48PM +0100, Benjamin Drung wrote:
> Am Donnerstag, den 30.11.2017, 11:58 -0700 schrieb Jason Gunthorpe:
> > On Thu, Nov 30, 2017 at 07:21:58PM +0100, Benjamin Drung wrote:
> > > Am Donnerstag, den 30.11.2017, 10:47 -0700 schrieb Jason Gunthorpe:
> > > > On Thu, Nov 30, 2017 at 01:39:37PM +0100, Benjamin Drung wrote:
> > > >
> > > > >   debian: Add m68k as non-coherent DMA architecture
> > > > >   debian: Mark libraries as Multi-Arch: same
> > > >
> > > > As Leon says, shouldn't these go on the mainline branch also?
> > >
> > > The complete patch set targets the master branch.
> >
> > Oh, I see how you working this, I saw them already applied to the
> > debian branch and didn't quite get it :)
> >
> > Looks fine to me
>
> Since you approved these change, may I do the rebase and merge to master
> or is that task restricted to certain people or workflows?

debian/* is yours, feel free to merge it.

Thanks

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
> URL:  http://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlog70kACgkQ5GN7iDZy
WKeG8g//dfAoxZmIbYVkWeDFUH0SL5VoS6sNbKAAZ32vITT4Y9IlW2YO+GVf1cXl
yEHUE/Hls9L57izgXADJfR0PgWEF/8gQae5/4BMe5Wx6wuXZYMCEHTd5bqcsr+A1
9SbMHJhDVpwnIMgZZFSbSOra9Btyh9/UQO87Cb8yokPQSTz8XihpSKbAOY/ILtVz
6yH0abM3SIBrcKrVh8qCVQBBenHyF+ltFZKWPQS6peJxiXFw3Y17JHX5LRmWGcgO
AsLdgaYn3A/sMwX7biQAwAlvfyWZb8+f/mJXruDIFxoAiiy4HkEATivUyHePIpzf
dwd3JSdvupKT0K/jkBHENd6ocaK/vKxlJmJZ/XlVLpLEzXwog7c7eXejRFYt9X7D
jIlIG7hhcWC3b6/P4cOuzoRe/Ckauqb0XYpsESyzd5yLwVZDqzXN6rmJuoe+oPiy
ZF6ngVOTMtbEAkH1ddYtO8xGWELIBdmpZEVTSwGO7Rqq7p/T54hBFZev2WyY/yPD
UBnMYvlIuGxCYH+ReFDnmILx7sBxyc3n9MEWPQxYJPZ91ycjFIoYLUt55OCmfeNK
Z5OqpzEeVvK7iRiq1BmnelLJUt1Zvrf2DboyhnZJxlxHEWKozLgGUfdcR6ucGRHa
JCI23JVnTwhF2bVktzKNlxhWZmGZsFxrDmpyuQSnt1GDYYyclgI=
=iM46
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
