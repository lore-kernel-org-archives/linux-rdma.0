From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 23 Oct 2017 20:39:46 +0300
Message-ID: <20171023173946.GP2106@mtr-leonro.local>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30086B735FD4B5948B521673D14D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CANjDDBhJK=s28zrdCASUVSSeem=NVRWwsHT=jWS2N4jGh2Uvfw@mail.gmail.com>
 <VI1PR0502MB300803053059AA7CC0E6DA7DD1420@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <VI1PR0502MB30087224F41436F787C4997FD1460@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EM2WAHSp0JAC5kZ2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30087224F41436F787C4997FD1460-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--EM2WAHSp0JAC5kZ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 04:28:43PM +0000, Parav Pandit wrote:
> Hi Devesh,
>
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Parav Pandit
> > Sent: Wednesday, October 18, 2017 11:54 PM
> > To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>; Somnath Kotur
> > <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> > <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Roland Dreier
> > <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> > Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
> >
> > Hi Devesh,
> >
> > > -----Original Message-----
> > > From: Devesh Sharma [mailto:devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org]
> > > Sent: Wednesday, October 18, 2017 11:32 PM
> > > To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>; Somnath Kotur
> > > <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> > > <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
> > > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Roland Dreier
> > > <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> > > Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
> > >
> > > Hello Parav,
> > >
> > > Thanks for you note here. I can supply you a fix, but before that
> > > please find a query inline below:
> >
> So I am going forward to fix the ib core as discussed.
> Please fix bnx_re driver whenever you find it appropriate in your schedule.

I would like to have proper deadline here, from one side, I don't want
to wait for Broadcom's fix forever, but from another, I don't want to
forward ANY patch which breaks other vendors.

Thanks

>
> > That will be good. More inline below.
>

--EM2WAHSp0JAC5kZ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuKWIACgkQ5GN7iDZy
WKfM4Q/+OdaKTjGq3urrcZFWw9UKgqdIwxDymEoQ6eR5HA5x9/RsA0P8V8D56Gv9
PnWzTnRTg0cTC1PgWJ45BDQNOZFvNnwBRegmjZo0alG/eAzRrvd47JLE05cGCBtN
lPzMVi6vYm7ipIPsIXP3HXDlQvxRwL37yiBoTJjqIAO72JkCoFhiIrFmmwlhgH69
9X11ziEew9Sb3Qj6z7ebAZ+bMLnJTgX+kiML3xdlvC+vYD0TThXFqEI1jmHMtD+G
Om2AvnCWMbSINOmOO5DcpRu6nZmLMxrBugIn7zOMnnBozUSJQGRH8YIPgie7yalJ
XK5GgzQWWHzzSqB0JblJmc+SACWEp6ZNSRJfqyjOsH5B+1ab3RUTREJ/EAdCmhJX
PBZARKpUBI837j2WMEnPMKIXTvohbwRUVAkKMSTHFQTQrRHcZA8jY0QveGF4gY3P
yMb3P1BgCuGDMBhQh32fc35HmTXek/Non8GD7Q7FmTzAGY5//ZihKM8EqWz0n/Dd
W4SRgVd17hjomIb5HX34nhRpH81z8ggqoYgz6ZRcWGv+hZfTO9RtRvi3pk+ZdZNM
ARWAesG9VzSmI8jbPNFgYSZEGzltPf6LVly/qBA2RtpW8CLt3sz4t8vzIMIZ6nMC
VPsBc8tU2AZbmKzYuTOWGTcGD7M/u318I/dUJuIMuBOJxrFs4ek=
=OQC/
-----END PGP SIGNATURE-----

--EM2WAHSp0JAC5kZ2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
