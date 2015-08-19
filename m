From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 21:39:51 -0700
Message-ID: <3B208E8E-DEB5-4A98-841F-90AB8949B6C3@redhat.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com> <20150818161102.GA4040@kroah.com> <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com> <20150818165026.GA25138@kroah.com> <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com> <20150818231150.GB32269@kroah.com> <08B07723-39A2-416E-92F9-E939B21EBBCA@redhat.com> <20150819024904.GA4151@kroah.com> <2EAAE0A5-3B1C-4846-B5A2-50026A91011F@redhat.com> <20150819041006.GA9794@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C16B43EA-5B40-49CC-A7AF-21094CA0F694"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150819041006.GA9794-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_C16B43EA-5B40-49CC-A7AF-21094CA0F694
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Aug 18, 2015, at 9:10 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>=20
>>=20
>> a library for their transfer engine, which also requires writing said
>> library), I=E2=80=99m wondering if it isn=E2=80=99t worthwhile to =
create a
>> staging/infiniband directory, remove your name and driverdevel from
>> the maintainer entry for the directory and redirect it to linux-rdma,
>> and delete it when this work has passed.
>=20
> That sounds like a good plan to me.

I=E2=80=99ll rebase my tree and fix it up.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_C16B43EA-5B40-49CC-A7AF-21094CA0F694
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJV1AiXAAoJELgmozMOVy/dZ7wP+wTsAwyW/L1b+VmBAtiQXyIq
vU5W+2sr3Ube1Eg2N5ufh159mF7Zy+iWZ1Ox/+S3wYs3TScvaMJlV/UFd+AyLjGf
bywp+LHQYJx7XOfeTcz7telH8pmjGgydidpPtr2NPudXwpAIPtLPOiM33/jsopeM
XONVMMS/f4MU0r2FYDGSY5HzXxtFV7JayNKSCiF+48Y9z8Cs4vCRvej8bHJHjXaS
mZtvy2wKlF7PSnekgckhNgvQ7jt4zWUsHruveWjLU37GJ7XP5D4bFwEghXO+TQ1l
bbe4OAyxOWDPjqetp4cSPbKN2B9mijX+mUNce922yqz/XxBM8FvC5FV2MzTreQYR
LVqHCESWyDjah/2QVHcL94yReqhWj9MPemmvo0cQ4p6QWXnOUa9p6U7iIDYTuI0u
FUzgbOnhXOPszn0R558aFBdiEoUsi1/m31gJkqZW1yh57VbRtsiNoDjJrzAu1jQn
sdlhKc31BvklIFIRDBmpLUh6idcyEO/gh7lFLlu0nLmqkgg2+ypGvlNNCihVRMyV
/Bjr+PTV6Wst0yQYUg3wfo5Jyngs/8WTyYrIa9qerddXl3mpCI3iBHvy9bRE+82h
b1L6psPTy0rRV7zfFlUHp1WBZ33jP4OthQ6XKae/bkUQix1AORW5bcxjPKP6A1bK
cSDimN2tH6Yr/YCYHWUF
=sHvl
-----END PGP SIGNATURE-----

--Apple-Mail=_C16B43EA-5B40-49CC-A7AF-21094CA0F694--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
