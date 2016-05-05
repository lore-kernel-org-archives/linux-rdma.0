From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 15:39:32 +0300
Message-ID: <20160505123932.GK29160@leon.nu>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
 <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
 <20160504181509.GA20488@obsidianresearch.com>
 <20160505063834.GH29160@leon.nu>
 <20160505120033.GA23895@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8kI7hWEHMS8Z+7/0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160505120033.GA23895-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8kI7hWEHMS8Z+7/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2016 at 08:00:34AM -0400, Dennis Dalessandro wrote:
> On Thu, May 05, 2016 at 09:38:34AM +0300, Leon Romanovsky wrote:
> >>I'd also make a very clear message to driver submitters: Do not
> >>include uAPIs in your initial driver patch set. Those should follow on
> >>as dedicated well identified patches so that they attracted the proper
> >>review.
> >
> >It is hard to agree with this point.
> >It contradicts to development model of submitting whole feature at once
> >and not unconnected piece of code, which someone will be needed to
> >maintain without any real user behind it.
>=20
> I think the message really should be that if your driver contains uAPI
> changes those should be in separate patches that are clearly identified. =
So
> if you have a driver that is developed off-list initially, instead of just
> breaking it up into chunks for submission add another step.
>=20
> Something like this:
> 1) Submit patch series which break-ups internally developed code
> 2) Submit patch series with separated out uAPI code
> 3) Submit patch that makes the build go-live
>=20
> These can all be submitted together, but with the patches broken up like
> this reviewers can target uAPI code more easily.

At the end, there is no point of accepting (1) without finished review
of (2 and 3). Right now all patch series already have such internal separat=
ion
in a slightly different order.

I'm as a reviewer prefer to see whole picture and follow logic from the
general entry point to the specific implementation in driver.

>=20
> -Denny

--8kI7hWEHMS8Z+7/0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKz8EAAoJEORje4g2clingUsP/3Dsb+c1ck+wH/UlXmfy1IhV
54bQqK4ZtXoS8+wUlV5sBc40UQ494CmyJQFDa1GWk5n3IALFAurxo8XeUkf6eu7P
NITAu6hhC+E6iKAwAcJoLTeVdAYrpdk9h4wHUm2jFLo12rhi4sbW7hhYM/18xLx9
ith+1NVbabKLKU1/ze8rYXYo/ie4HodQ9V7Bjvo4epXYMn0iFfB5iWkyb9uxdxUT
LBmCKQWXz4GclCUWgD+oiX/kuYZ/nEHhHZb+vqXDqNy6JSGA0ZL3UPMb25HHsD9y
LEtVJ59n0vB9f2F7wtiqnTGoaB7VbX4Us5oXvsFDmT5FVDrKQV/ZPmaapTnoBsKF
/c3TG3/r5GfBs7I4km5d7TQDJTWc+zI619gZ6JLEK32LOycWWVAbC6JBIEzv9sek
iKJqAJkYSifOyOPCNn/uW4oPeX8kfD3VrB3ENocUw+Hhl+2wQhlJIQZBpcb56dC6
tA8Lp20pBp8Cv3A4+tARbEawZqBrnEf4bNJwcExiiUAtocAHjYF3HBMWF6Z6MGsK
L4tiVK00evpiSVzpC+5fDs1KRJdUK2SD7R4hvbYn92nP8PDFHeNv3LvNsQcsVIgQ
UvQ5BypvCWWTf47zeR3OYIPhTwggG8k5zigeNQDCNFJNJbNOebQoAL35dzDt7EnY
SRd9c938CvzpQ0esmF4w
=VBmy
-----END PGP SIGNATURE-----

--8kI7hWEHMS8Z+7/0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
