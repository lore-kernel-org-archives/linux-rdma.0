From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies,
 descriptions, formatting
Date: Thu, 22 Dec 2016 14:14:49 -0500
Message-ID: <8f7c255b-1916-e1ec-f277-94b117117270@redhat.com>
References: <20161222180220.49558-1-jarod@redhat.com>
 <20161222181323.GA5053@obsidianresearch.com>
 <bf346322-4ef4-032d-9ea2-5a63ae7737e5@redhat.com>
 <20161222183536.GB5660@obsidianresearch.com>
 <f5f043f3-a396-ee44-6f7f-ef3b14daae15@redhat.com>
 <20161222190057.GC5660@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aTtiFRdFgwv7OfKKE7N9qnIdtbXXvnLEE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222190057.GC5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aTtiFRdFgwv7OfKKE7N9qnIdtbXXvnLEE
Content-Type: multipart/mixed; boundary="H7FohQHCf7jdPWBSG8jRnPgltW7AdBj3M";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <8f7c255b-1916-e1ec-f277-94b117117270-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies,
 descriptions, formatting
References: <20161222180220.49558-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222181323.GA5053-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <bf346322-4ef4-032d-9ea2-5a63ae7737e5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222183536.GB5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <f5f043f3-a396-ee44-6f7f-ef3b14daae15-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222190057.GC5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161222190057.GC5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--H7FohQHCf7jdPWBSG8jRnPgltW7AdBj3M
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 2:00 PM, Jason Gunthorpe wrote:
> On Thu, Dec 22, 2016 at 01:41:59PM -0500, Doug Ledford wrote:
>> On 12/22/2016 1:35 PM, Jason Gunthorpe wrote:
>>> On Thu, Dec 22, 2016 at 01:17:00PM -0500, Jarod Wilson wrote:
>>>
>>>>>> - Add explicit dependencies on kmod, initscripts and systemd, as t=
here
>>>>>>  are container and vm cases where there might not be a kernel
>>>>>>  installed
>>>>>
>>>>> Do we need initscripts?
>>>>
>>>> Not really sure, the Fedora package reviewer insists we do.
>>>
>>> Hm, no idea what for. We don't provide any LSB init scripts any more,=

>>> right?
>>
>> I think this is a distro specific thing.  Last I knew, there might sti=
ll
>> be one or two things that haven't been migrated from initscripts to
>> systemd, or maybe they want the functions that the initscripts package=

>> provides?
>=20
> No idea, but it is a big dependency (12 pacakges, 5M)
>=20
> If the reviewer wants it, lets have them propose a comment about what
> it is needed for since none of us seem to know :)

Fair enough ;-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--H7FohQHCf7jdPWBSG8jRnPgltW7AdBj3M--

--aTtiFRdFgwv7OfKKE7N9qnIdtbXXvnLEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXCYpAAoJELgmozMOVy/dxMEP+wW7HQOSoGCu0Df/D7GdJEh/
TeFXahf4pCKj9xfFdsUoS6eVd1kiL46fnlMdYe1rJjPkIN+HO3Sj1hY0nrzc2H3b
PFPCIPENKLYNZguoZk5HUi5eyajIpezTgncFCRAm40tFYoXpBTy0anJNoJuwPMIv
LGfUHCqto1DFI8IthPbKX3IX5HB/La8/015f3MysTkE6mWOEfOQu2CS0ldUggy+O
4KPo0o6HwP5oNsaMJ6mbUZC4349Nup7zUu1uAxlIBALiVLnyYnYP63o3FZcaMJIa
K7qYI+G3tkTH6Yhobp13/y8Ae+g1kaC8l2Gx3/3ViYhDGOqoiLoSXWGhaCwZWNVZ
fLd2A724ycBANbFiT1Yt8jk/Ys/UsgIoWFM7gkKrhC9sNpeRAnHkZG28/YzGYgJa
bUjCs7WD4+pfDFziHkVIH/CipPrSzHVcJiyp6jrfNa0KxaqRkbnopdT9jg6108O6
dDbbEXtU7hKZMQoPgBmFMjPVRBFrSKOmcAsYh5CHU1VQE0sarftITybruL0geEBO
NZrVpnMUEIHrcdagI9PaB0i6LoF5k+PLxLV3O4/ZviP4wD6QMJ/3LYvI3W+srnTE
X97ZlSrsJojAq0MdN6nmf/ZvwJKwXIPslE7OfVmXzLce6XsN8AmkSEZs8Tgh2RFQ
sDQwkSg7RL6wYG6tZG9P
=fH6a
-----END PGP SIGNATURE-----

--aTtiFRdFgwv7OfKKE7N9qnIdtbXXvnLEE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
