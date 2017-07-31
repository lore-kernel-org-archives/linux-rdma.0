From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 20:38:13 +0300
Message-ID: <20170731173813.GH13672@mtr-leonro.local>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
 <20170731164705.GB28204@obsidianresearch.com>
 <20170731165453.GD13672@mtr-leonro.local>
 <20170731170018.GA19061@obsidianresearch.com>
 <20170731170804.GE13672@mtr-leonro.local>
 <20170731172436.GA19375@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="656hIAUFSU7Oh46B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731172436.GA19375-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--656hIAUFSU7Oh46B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 11:24:36AM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 31, 2017 at 08:08:04PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 31, 2017 at 11:00:18AM -0600, Jason Gunthorpe wrote:
> > > On Mon, Jul 31, 2017 at 07:54:53PM +0300, Leon Romanovsky wrote:
> > > > I want to take RDMA one step more,
> > > > https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
> > > >
> > > > I called the topic name "persistent", but the right name is "predictable".
> > >
> > > Once renaming is possible then having udev rework the names isn't a
> > > big step anymore.
> >
> > You need predictable starting point to perform automatic rename,
> > currently neither index, neither names are not.
>
> udev has all the information needed to produce the naming pattern in
> the link above.
>
> You'd end up with names like rdmap3s1f1 for instance.

I'm not so convinced that udev scripts digging into various outputs
(lspci, e.t.c.) are better solution than kernel handles everything
exactly as netdev.

>
> Jason

--656hIAUFSU7Oh46B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/awUACgkQ5GN7iDZy
WKfiFRAAh9oTMY1+n0rtKr9eoWDS4lmkDpzsaAppP0BkTz60G/Hpr7KOAAUWAvRi
1iQjFO0c66Ms1J2UYc4CcewUcU+xkXg/pNPXSUMMEamgEOi6LGfEQ2LTTbah4d1J
swq6GKbi4O/Hk/5wAWz7UhvneTG6kuUxmLt5GzJTp+sa4Q6Ii6T5obViQW1Rgvwy
p81O65kHZPe1h4W1kIuzilabMfSHFvFnthXn6uhx4OyjkhyiGtoFp7juotJHKGaE
CHyVxAI6WUo1V9vFT1/T71tMpFDTEacqtrplpsskVXOZzh6Kw2Pn69OEAfvbxX2a
J3/d3fCGxPD5OTUcbs+FyzXck2uJfOh02runrGrAId495wN3w9R/B+WBdMJm+sAQ
wDK6iz5TolIRsJxJpoPKeyZslebt2SvVgM2aXExNXYf7SEvydVHKqI1ln4be2mm5
woKojdSJrRxN/zG0rYFpo5PiAkW0l0WnNg4QDTPtErwPaUQ1pTn+HzpdBIC4h5F2
5uUwjLBYk7MOeK1tkSAv5/kPb6stj9TMKRUTeUYeRfld1IuCKk6VqZxtNL2HCO88
k2RL//YqDU+/xAFqi6syLISVlJifOSMxAt8ova+geIUZcu23CYXL58VYp2Xs+2En
Ww0X3qHoHkQrJGUC7ER4ZK6/khfLwfXIcSm+VSJmeYgwlHOTfbE=
=ddTy
-----END PGP SIGNATURE-----

--656hIAUFSU7Oh46B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
