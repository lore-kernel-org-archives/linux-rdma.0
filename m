From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma_cm NULL deref in 4.11.0+
Date: Wed, 24 May 2017 21:52:56 +0300
Message-ID: <20170524185256.GT17751@mtr-leonro.local>
References: <acc72471-eb22-4474-04f5-db23227faadd@grimberg.me>
 <VI1PR0502MB30083E6CB505CA90A9E047C0D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170521154443.GD17751@mtr-leonro.local>
 <20170524163832.GA23034@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tZCmRiovzb4sxAVa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170524163832.GA23034-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tZCmRiovzb4sxAVa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 24, 2017 at 10:38:32AM -0600, Jason Gunthorpe wrote:
> On Sun, May 21, 2017 at 06:44:43PM +0300, Leon Romanovsky wrote:
> > On Sun, May 21, 2017 at 02:30:04PM +0000, Parav Pandit wrote:
> > > Hi Sagi,
> > >
> > > Majd encountered same sometime back and reported [1].
> > > He has the fix should be posting the fix soon.
> > >
> > > Majd/Leon?
> >
> > The fix is in our rdma-rc branch.
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=f1fff656d55c52aeb12129f57347886b02f90e1d
> >
> > I planned to submit it today.
>
> Is someone going to look at the segfault in librdmacm?

Does it reproduce with these two patches?
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=f1fff656d55c52aeb12129f57347886b02f90e1d
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=1d6af11df23f7df4963af7513a3dad109acbcd4c

We are successfully run our regression suite on my rdma-rc branch.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-rc

>
> Jason

--tZCmRiovzb4sxAVa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkl1ogACgkQ5GN7iDZy
WKdNMRAAuKNbfH2CQRYzMxwj6FMktJ0bQO5LtMVokiW8cQytGHMFdLoFmf/Pohc3
gucin51XLZzisQ6qwT08ug8FtETv9zJm4sE+Lp3pNdpK5jFuTDRFIvHduYQ8fp+r
G/tAjQvX9aidLb8Y+KVLg02AO+YCbSt1ilNaRCCHGFp5idI0ipYV/HRp2k7HOMEU
U4ustr7Uw45CTUhZslo2umOh8UuCEYBa6YQ9JLknE8qq6/Z2JoJN13qisd66TrAn
QBrt3WmkJyYB4hhJ8tXBWT7SgozL64kv3DUUWNqxf6OCY3+gWhu9cq0glbFy44Pe
EL0GfT7uqiDrYdVJGv64UvrCXAjhtdztj8zqn1i8HoO4BkEJryP1Em6RPM9EwryF
iQzcy0t1PECX/6kT6WNqFwYbcDHCRobsh0YzkIYni1aUdCiYhtlI+qR5x6kp9lYY
4q7nomWI4TbrAj3FXAxo0lBBorYTHwaw1tmZExTQdHUnIDypINHXGDHwtdwn3XEl
Ti/BRgXkdQ9TMdX06SEHWsV/+ZcroIVtC1IIXlJaZnUYSqMm8887XcJvyV6AX21L
c5GXWOye198+nFSOwiaC5LrLlwj/5VJ7kgn7Buf4luOoWmDQGB2FXJuHYrrqwwPf
a6JOWjC9+2uWGik/SsK041btORVc5WyzfwrqBBwixt9VyvFrw/U=
=Q+XU
-----END PGP SIGNATURE-----

--tZCmRiovzb4sxAVa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
