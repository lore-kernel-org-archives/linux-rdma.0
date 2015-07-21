From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: deprecating amso1100
Date: Tue, 21 Jul 2015 16:45:30 -0400
Message-ID: <0F66BC31-60A1-4513-B858-17A75BFD42DA@redhat.com>
References: <55AE93E0.9060002@opengridcomputing.com> <1AE4059B-F6BD-48ED-A1C6-8A9024DDF217@redhat.com> <D2F193D21ECD8C45917AD3D5B26513300C49590A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D0F86224-6B2F-46B5-B3D3-A31CDA6FA934"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D2F193D21ECD8C45917AD3D5B26513300C49590A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_D0F86224-6B2F-46B5-B3D3-A31CDA6FA934
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jul 21, 2015, at 4:42 PM, Dalessandro, Dennis =
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
>> Sent: Tuesday, July 21, 2015 2:49 PM
>> To: Steve Wise
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: deprecating amso1100
>>=20
>>=20
>>> On Jul 21, 2015, at 2:48 PM, Steve Wise =
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> wrote:
>>>=20
>>> Hey Doug,
>>>=20
>>> How should I submit changes to deprecate amso1100?  The HW hasn't =
been
>> sold since 2005, and the SW has definite bit rot.  Its time to remove =
it...
>>>=20
>>> Thanks,
>>>=20
>>> Steve.
>>=20
>> Send me a git patch that uses git mv to move it to staging and =
we=C3=A2=C2=80=C2=99ll leave it
>> there for a release or two and then remove it after that.
>=20
> Steve, "git format-patch -M" does a nice job creating a patch that can =
actually be looked at via email.
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D143593782206479&w=3D2
>=20
> For the Ipath driver I was going to send directly to the staging =
maintainer/list. Doug, should that come to you through linux-rdma =
instead?

I sent an email to Greg K-H to ask that question.  It doesn=E2=80=99t =
matter to me.  If you want, send the email to this list and if I get a =
response from GKH that he wants to take it, I=E2=80=99ll just point him =
to it once he lands.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_D0F86224-6B2F-46B5-B3D3-A31CDA6FA934
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVrq9rAAoJELgmozMOVy/dBakQAL6yxwLAxCQ0kLIMV0+nmixb
x6rezdnoeDHilyZ8Vh0oH197vIQomEDXfPnAJT0ZBYXjGX5MlFz/ysUBD1k+icOn
3QGE98zUtqp14fN6L0soY5qH/dN+dSI4TV9OO+kY5NJmg+zV/o+sU0L9ju6HQLIu
N/baYvkPt4eIeLtQ/lQ1S6iZuCfvz5/KrFH3tEYSzj0opfVem/8jZFJb6pJhC8nw
ia12AUaHg5S0ocY3dDDDMPPDqvAxV05gof6fKEyosom8c7e03lEkITDIMzBqYG0P
WpYfGPPY/R75B88nRAc4xBGV2Gb1OUGwKYIUKq3mOjeyhKmp4zjHF2ZpO2KMFgaM
svK7D0BgIGUJRWgGh8nJ+w4mxqvFyNc8t71kkyNh4XvHjBkNP62eXaw8LpNMrbJG
3rCo6/Wd16QnxCblkMMu0YAZ3JJfzVGfRehZJUhwnOFjWSOQtsbWMcvl/8B5+NP9
6RzrO2a09ElU1tY681xX8cxf3zlQo/N7i3l8TH3eWvq/OaJ1ATELvwaAK66LkX5n
evmH3yO7Bv2S9oFNuHutpJwCm3Qm+twyl0bPprVs7D6eD+j++E40mAJpYy3ftAUb
rvShp4//k2PTRcuW526xYuaqYH4qXxXtis9T36SAXskCdyYZZanUj1kA7zvcaOJQ
nktjbqqsqxJiv+1z7CEK
=Dtlh
-----END PGP SIGNATURE-----

--Apple-Mail=_D0F86224-6B2F-46B5-B3D3-A31CDA6FA934--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
