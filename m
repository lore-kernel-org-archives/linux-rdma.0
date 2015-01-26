From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Mon, 26 Jan 2015 14:38:26 -0500
Message-ID: <1422301106.2854.41.camel@redhat.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ru6GA/yGdsEY6Xa4j68W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ru6GA/yGdsEY6Xa4j68W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-26 at 15:16 +0200, Or Gerlitz wrote:
> On Mon, Jan 26, 2015 at 3:00 PM, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage" both
> > IPv6 traffic and for the most cases all IPv4 multicast traffic aren't
> > working.
>=20
>=20
> Hi Doug + Roland
>=20
> Erez was very patiently reviewing and testing all the six (V0...V5)
> patch series you sent to fix the 3.19-rc1 regression.

Yes he has.

>  Can you also
> give this patch a try?

I can test it.  But I need to know how it's supposed to be applied.  Is
this in lieu of my entire patchset?  If so, I know there are some things
not addressed here that should be pulled in from my patchset.

>  We believe it addresses your concerns re the
> previous versions of it and fix the RC1 regression.

It might fix the regression, it might also reintroduce a race on
ifup/ifdown.  I'll test and see.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-ru6GA/yGdsEY6Xa4j68W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAABAgAGBQJUxpeyAAoJELgmozMOVy/dnL8P+LYg1LjrFBjP+ZcAlu7MxXXI
VcaO6+Kqtivq6eqZjS2V4uyBTSf0qD8hiMpx8AWb2msBwlFt57hul1vFLE5ojMBg
g/lo/OvGKIzm/9aNKWpMmnehukp91WGdahO30lOy7JcgmvGot6xzycdx8swpjU/f
TNXRi+ivKHJNPPmKtg2nn6pEfNsJ3rT4sdzTB417C4MhckLIiOQOkTshleR6gx6G
DTUly+CJtpR2Bsz0buwPYyMfyQWfdB7xVBl2AzjNh4ldIFac0HuWI3ic7ll4VBWd
r0H7eehAVxo3TPoJ3IFjMHmi6oFtEG4ej2rxz6xqYl6x3yjceYzLWbvSm3z4W0UC
M2wJPoOlR3HMkiP1rIKGcOsxzdns1vvAbWB8sQNARdY8ESagkk+vZofwfMzv+pKM
jWb3mEYG/w+7HkfhBeptwSOS1oPqP6A9b9r5QCMZohe+RCMGb8ltNxv0XWGWCdzr
iVL/lextH6uZde8beJ3dmT7u5unUud/p1KmgDhMM5X5caN591mnTsKyTIDG4nBa6
sj0RBhL6mfYOs9ktcxCsjf9jv2MK+o84P7PIwjx0P8fycGQUBiX9KU/xTHAQ0s5Q
oVA1JLoxpOFGTi13XlC2s6gfK9DpQCCNDQES5lwaQqaX/kHL+fKoyJ6B4XB4Yza6
bke9PFjlQ/ELQ+Oh9+c=
=pHvK
-----END PGP SIGNATURE-----

--=-ru6GA/yGdsEY6Xa4j68W--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
