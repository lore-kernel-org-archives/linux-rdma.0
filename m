From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Fri, 6 May 2016 07:36:51 +0300
Message-ID: <20160506043651.GL29160@leon.nu>
References: <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
 <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
 <20160504181509.GA20488@obsidianresearch.com>
 <20160505063834.GH29160@leon.nu>
 <20160505120033.GA23895@phlsvsds.ph.intel.com>
 <20160505123932.GK29160@leon.nu>
 <20160505180843.GA5957@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pFej7zHSL6C5fFIz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160505180843.GA5957-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--pFej7zHSL6C5fFIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2016 at 12:08:43PM -0600, Jason Gunthorpe wrote:
> On Thu, May 05, 2016 at 03:39:32PM +0300, Leon Romanovsky wrote:
>=20
> > > I think the message really should be that if your driver contains uAPI
> > > changes those should be in separate patches that are clearly identifi=
ed. So
> > > if you have a driver that is developed off-list initially, instead of=
 just
> > > breaking it up into chunks for submission add another step.
> > >=20
> > > Something like this:
> > > 1) Submit patch series which break-ups internally developed code
> > > 2) Submit patch series with separated out uAPI code
> > > 3) Submit patch that makes the build go-live
>=20
> Yes. Perhaps even submit #2 after getting #1 mainlined.
>=20
> Make it easy to find the important/controversial things and the review
> process will work much better for everyone. Buring stuff in a monster
> patch is just going to stretch it out.
>=20
> > > These can all be submitted together, but with the patches broken up l=
ike
> > > this reviewers can target uAPI code more easily.
> =20
> > At the end, there is no point of accepting (1) without finished review
> > of (2 and 3). Right now all patch series already have such internal sep=
aration
> > in a slightly different order.
>=20
> Eh?
>=20
> Drivers should be able to stand alone without dedicated uapis
> (excluding the udata stuff).

And they are, however the point is a little bit different. There is no
meaning in internal feature implementation without access through
verbs interface.

>=20
> For instance, the HFI1 driver is as functional as any other RDMA
> driver without it's cdev, eeprom, debug and sysfs uAPIs. Those are all
> value add features that do not impact the driver's ability to operate
> as an RDMA device.

Let's close for them PSM and verbs interfaces and see how it is
operable.

>=20
> Jason

--pFej7zHSL6C5fFIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXLB9jAAoJEORje4g2clinbmAQANEp1gYr1GhsIpcqqdk17gRK
6tvMSeDcL/7cBQIHIyhJ77lARECBw8mwOnG+E/roMSu0UQQq+y+PhkIHlkfFLlaf
92Z28XgiMFsjpxL72uL/vx+JodR0De389zOw98KnTg43ji7EHU86AmsWdwVftEld
xSLeI4dtpJbU6Y2UgdUW6dKPo6hVmhK2E+q5llXVrXVAg9Ikc+PooH5U4rcKunYB
i5I2OQCRwyIVnuy/ccT8vlco6Od1EDxVv270o6U6MNUhdqNaPNde3Gkrt0WHluPk
gxaGjLaa5qlzJmCZU5w7Hy8AY6l6TeccRqL2bzUdqeSzixAp/qfe3Htsk3lEAKpy
XDoECj6WlO0lZ1bl7SLBduNc1j3E5DO3khWtTII2FI1EYcOByuqSJO7RMA3ZLmGH
27rSH6spjDbfKS6b7+NafJGpCv8DA76H9+UsU/+fLZxZAsiHarxpd/g3hLSssFFj
/I8IS9YQvpC3ajAyzWwtAwW2uV2U4Orj6kMNEl5wEAS8wW/X1KN82UGnPLGAb4I0
1wUpDGgfpQqf1lgQ2bpdQFBWqtJjF1Jfc9KUEOI0or5DXDjMmUE2/0RLCy+LxjhQ
vkruG+11jCDpxueX1cAy1CmruneYxTOmytCmL1/38nXfTq3dYozGN/w7kzptiZUr
V9bZh1dmz8855PgyiGVW
=Zm40
-----END PGP SIGNATURE-----

--pFej7zHSL6C5fFIz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
