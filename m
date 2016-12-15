From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Thu, 15 Dec 2016 20:35:37 +0200
Message-ID: <20161215183537.GH811@mtr-leonro.local>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
 <20161215165420.GA3264@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161215165420.GA3264-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 15, 2016 at 09:54:20AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 15, 2016 at 08:48:07AM +0200, Leon Romanovsky wrote:
>
> > > I was thinking more like a standard:
> > >
> > >   VERBS_PROVIDER_DEBUG=qp,ah,blah
> > >
> > > parser since other than mlx5 that is what providers use env vars for.
> >
> > It is not providers only, but many other libraries in rdma-core are
> > using env variables for tuning (libibverbs/librdmacm/rdma-ndd).
>
> Other things have different requirements, eg all the *daemons* should
> be using the system log and use a command line arg to enable debug,
> rdma-ndd is doing it OK for instance.

I had in mind much simplier infrastucture, just add pr_debug(..) call
and allow every provider to place in any place in their code.

My main point is that I want to see all ENV variables in one place.

>
> I think it is reasonable to focus on small tasks, considering how much
> there is to do. In this case hoisting only the provider debug
> mechanism to util seems like enough and fixes the ugly problem with
> i40iw where it unconditionally prints debug information to stderr..


>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhS4ngACgkQ5GN7iDZy
WKc94RAAxZz4IuV1xKrbg/E/GKkmEkS3mLga3H8moN3fLx5ES3anVlBwkn7UiS0I
rSYcgrrNtrWlpE43gyUNFpgViqp2/AJxx4FxT2dY+NHjjJK5dxJtdOZta3FVsFKp
eVOotdnhIWWWokFJp+8q4K76W5OvILZO/VDMPV9QnJyJ7h2oxnt+E8/af+leXhmf
kTguZe031jloRp37JoUdLTxRA89cCuODtH5VMOa25NPiOE3zhVNtDeTgb619HC14
aR7S+68QOS/XMnXZV41YP11VzsHC9y5N3lnG9MmGaH8dKgiyUNGhP8+t5/afi4ga
bNcv0VUKV5tbmbKFxX9z0RXymajN4WdCtlVep7++A4nlBtCMRPtNitkz7mPsjymU
I2kIYgnjYnlRAp2fm0UdfsmEzvigLkvxCVFClZnvR8xz4ZRn2+eRg1grEpCKc0ws
zmPl0nu6kaOW6s5CXbdcD+D8D/Svs/76UkY1Wbjn0O7TQwO5vOYd1uOO886cNy1w
bwIR6GYOdCNCVCyy3fSzArQpGoAWopedQJvqkLdEXGx7MCKHjv81vxZDl1kmd4sn
KB7XXoWHnJX6A0SmrR2yCYMA/a8FPdV7I7BSwiabcOqVs7+DNfcvuIklyuQ+i67h
oN6Dl/gK4ePGKMIahBb0Ot1IuLrMVtIRg72aZKFQtaOU88hYr3A=
=uy+B
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
