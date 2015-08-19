From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 20:11:26 -0700
Message-ID: <2EAAE0A5-3B1C-4846-B5A2-50026A91011F@redhat.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com> <20150818161102.GA4040@kroah.com> <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com> <20150818165026.GA25138@kroah.com> <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com> <20150818231150.GB32269@kroah.com> <08B07723-39A2-416E-92F9-E939B21EBBCA@redhat.com> <20150819024904.GA4151@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9232E0A5-E9A7-44EE-8AD1-3ED604C8F695"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150819024904.GA4151-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_9232E0A5-E9A7-44EE-8AD1-3ED604C8F695
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Aug 18, 2015, at 7:49 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Tue, Aug 18, 2015 at 06:24:40PM -0700, Doug Ledford wrote:
>>=20
>>=20
>>> Are
>>> you going to be responsible for all of the patches sent to it and =
you
>>> just want me to ignore them, or will you send patches to me for me =
to
>>> apply?
>>=20
>> I expect the patch load to be significant due to the required TODO
>> item of making it use a transfer engine library.  I wouldn=E2=80=99t =
want to
>> sign you up for that load.  If you are OK with me processing the
>> patches, then I=E2=80=99m happy to do so.  If you would prefer the =
other way
>> around, then I=E2=80=99ll defer to your wishes.
>=20
> What is "significant"?  I'm kind of used to handling a lot of patches =
:)

I have no doubt of that.

> How are you going to handle all of the coding style fixups that will =
end
> up coming in from people?  Want me to just let you handle all of them =
as
> well?  If so, please remove me from the MAINTAINERS entry for this
> subdirectory so that I, and the driverdevel mailing list do not get =
the
> emails.
>=20
> Otherwise, feel free to just send me patches, I can easily handle =
them.

Given the amount of stuff I have on the radar for going through the =
staging tree (two deprecated drivers to be removed entirely, plan is =
move to staging in 4.3, delete from tree in 4.6, this driver and one =
other as-of-yet-to-be-submitted driver to be added to tree, both drivers =
have the same major TODO item, which is to be converted to use a library =
for their transfer engine, which also requires writing said library), =
I=E2=80=99m wondering if it isn=E2=80=99t worthwhile to create a =
staging/infiniband directory, remove your name and driverdevel from the =
maintainer entry for the directory and redirect it to linux-rdma, and =
delete it when this work has passed.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_9232E0A5-E9A7-44EE-8AD1-3ED604C8F695
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJV0/PfAAoJELgmozMOVy/deAEP/jMTzwwegKlwlOmNpOjLs/m+
LIWaBF0tz0jqF7b9CXG05aII8h4ZAmMiAoUUOvuecloVJgdqo4sKyKbIVkqGbSDa
3b92AgSnYTkRWiX2D1cUKO74OFHFS0dnlNHFjy3NiLQXqTvtAS8mYjjfJGUWu+ld
f4oQg8hPKwPchLcuqgRgyVMBN9UQhFELAz0pYiAM0AZwUYnjZpTzowYl2twhFo8I
TC+vn9X+f58uOlRsFGU+lEXNYHiFkhcnastCy5ZL9CrOG4QyO0FK2voNempmG3MM
L67YXn9uOX8u7KC9yslJlUoXqkoSX0OUYKnQSGrRra9xoDlm8vcvQdX7yVDE7hEJ
eLmrKoWjwYW0rrp/fSiVKlnBATFqdLWpDhTy/x/nK89doJm+aDgMZ0pMenaRpAgb
3tljg5S/XpdCGIFTQw6UuKQyDUCAk2VRzcufrKIFtfMqDj8PUfHW2MOU04GJWfWe
dOmGjYzEFTmWBJfo2eqS6OPvxIG+hkgZ3zWjpzZWSmmQp5qJ3KlHZJPddrFjYtY+
Qa55qBUuNI7X+WHDVkBaDw418VJiph0Qb3aajj0cv3DN/d76c+8WV5ARmm/dN9vD
9nc4+kC3yHApG15kQdEJ7bUcHWXLkOWWuR34G82o9bVvk7z6CReqwY3VxnJiMxh+
FSRRIp2tCHGxZjqAAOuA
=TWzO
-----END PGP SIGNATURE-----

--Apple-Mail=_9232E0A5-E9A7-44EE-8AD1-3ED604C8F695--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
