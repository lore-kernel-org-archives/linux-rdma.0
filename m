From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 14:36:16 -0400
Message-ID: <b7f1735c-5362-514e-268a-49a09b316a88@redhat.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu> <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
 <20160504181509.GA20488@obsidianresearch.com>
 <20160505063834.GH29160@leon.nu>
 <20160505120033.GA23895@phlsvsds.ph.intel.com>
 <20160505123932.GK29160@leon.nu> <20160505180843.GA5957@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BhrdTQF9ERcOWDXsp9SSlLJACaKwBueUO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160505180843.GA5957-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BhrdTQF9ERcOWDXsp9SSlLJACaKwBueUO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/05/2016 02:08 PM, Jason Gunthorpe wrote:
> On Thu, May 05, 2016 at 03:39:32PM +0300, Leon Romanovsky wrote:
>=20
>>> I think the message really should be that if your driver contains uAP=
I
>>> changes those should be in separate patches that are clearly identifi=
ed. So
>>> if you have a driver that is developed off-list initially, instead of=
 just
>>> breaking it up into chunks for submission add another step.
>>>
>>> Something like this:
>>> 1) Submit patch series which break-ups internally developed code
>>> 2) Submit patch series with separated out uAPI code
>>> 3) Submit patch that makes the build go-live
>=20
> Yes. Perhaps even submit #2 after getting #1 mainlined.
>=20
> Make it easy to find the important/controversial things and the review
> process will work much better for everyone. Buring stuff in a monster
> patch is just going to stretch it out.
>=20
>>> These can all be submitted together, but with the patches broken up l=
ike
>>> this reviewers can target uAPI code more easily.
> =20
>> At the end, there is no point of accepting (1) without finished review=

>> of (2 and 3). Right now all patch series already have such internal se=
paration
>> in a slightly different order.
>=20
> Eh?
>=20
> Drivers should be able to stand alone without dedicated uapis
> (excluding the udata stuff).

That's probably true most of the time...

> For instance, the HFI1 driver is as functional as any other RDMA
> driver without it's cdev, eeprom, debug and sysfs uAPIs. Those are all
> value add features that do not impact the driver's ability to operate
> as an RDMA device.

In this case though, not so much.  The qib and hfi1 devices have always
been PSM devices first, verbs devices merely as a compat layer.  It's
easier to provides a verbs interface for kernel ULPs than it is to write
PSM in the kernel.  But their hardware is designed around the way PSM
uses it, and how verbs makes use of it is decidedly sub-optimal.  They
could do without the eeprom, debug, and sysfs stuff, but the cdev and
PSM not so much.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BhrdTQF9ERcOWDXsp9SSlLJACaKwBueUO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXK5KgAAoJELgmozMOVy/dF4gP/iWt19Q1C18QDl6BNxtptCIH
wbM2vDbinQZuY0yRVh55NqlPC/EW2iBUkK9VAo2kyXcART1qNucUMRmEmdRh9Eq/
0lPClPOKOYf9J4HRNhtwT+X0AWBZ60yvKPBLgiWECf9RilubL6ir9iyFivBRixa4
KU0fh2CgnmhHzy9QdoV55KZi6ukoq/nhgAYcO1DYi5YwRPxzc8wHWXIK/HNyCb3F
RYLm7VLbSJ+eNqo3rIfIyzKhpNiAf7tM3bdPV1FDVgWvJUHkhRIH+boDZAZ/uu9m
54pX37leM4nAdB87xMdlL+NkopJDGnOWGAo9/hwQcLy5JYTT1iNObQxXD6H1afea
vTacFSBeGzwUn7eQGysGDZJ/yUf9BwgZ389Iqpq8AuEF0M0Xv8v8ysaCnO6Wo2hY
HbDqn46TtF7sOdBxaf5aB1Zkc0kxrX7DFtE58i7qjZY1Qi0zbR827NAMkQMKjxMS
Mbihm6KNhvK8By9T5zW5R03RafWM7dxkW7YG7Lrt7bYWDz0GRg4SIPl0R7D/x2iL
xnFPFnpSitqfwaGSsPULgxnsdC+6FLenUMq6JybzqwK1TO2EXSdKY7G0iKzQpTy8
5Ym5PLZjap5e4THT/rrCtDudP01JkzqgNugSOcwtlNowJINmXRQAXL8QT60WEYMB
bxZuP/1u9mrwF2y1+NR+
=i7+8
-----END PGP SIGNATURE-----

--BhrdTQF9ERcOWDXsp9SSlLJACaKwBueUO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
