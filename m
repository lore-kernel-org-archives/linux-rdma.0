From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 9 Sep 2015 12:11:27 -0400
Message-ID: <55F05A2F.9090005@redhat.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
 <55EFA2BF.7060006@redhat.com>
 <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ@mail.gmail.com>
 <55F02006.5020504@redhat.com>
 <CA+55aFxJovuBGpg04YM0AvrzL_TPDoHebkP21R7tO3=QMQUUXQ@mail.gmail.com>
 <CA+55aFwCwT-K_Qw3aQBXt_HbQX6v4d4EXHb3dJVCkD3kg83gzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fncDiqCQ33hHmxh8T9aiRjKK31TVhATH8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwCwT-K_Qw3aQBXt_HbQX6v4d4EXHb3dJVCkD3kg83gzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fncDiqCQ33hHmxh8T9aiRjKK31TVhATH8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/09/2015 12:10 PM, Linus Torvalds wrote:
> On Wed, Sep 9, 2015 at 8:44 AM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>
>> Ok. I've merged it in my tree now, it's just waiting for the usual com=
pile-test.
>=20
> Compile-test finished, and pushed out.
>=20
> Can somebody check that my conversion of roce_gid_mgmt.c actually
> _works_ though? It compiles, but that's all I'm testing.

Sure.  Thanks!


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--fncDiqCQ33hHmxh8T9aiRjKK31TVhATH8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8FovAAoJELgmozMOVy/dcsQQAJ3n9a0nm8muhBUfAwfQSI7V
Qb0/9cbhra5BuVnlna99VBvCaIPY0/50OoDJZtR9piFoxpdr9V1W2GSy48UASHo/
JsvRSh47+lzTLbkKozi9G1xNHmNx/F/9vHgoWYuxXoaJJGSqnOadiB7zIz3Yh7r4
Bb1RsjNCeMiRTGuzMJ9kHjL4x9H0e8BUaDCoPEa1iUoNrbzBNiMqQmFqEdQ89K/h
2TljT8+GS8eXqgrJfhQjXjRfH4jTlUvq5WfvCS7AsTqLsasJjmXouMJfv6os05lJ
xc20Ww4IqCKoYFkHXreMhnhGpIKCGcvzyHZbCbTP/xsNzDJX6MleuJco86fmoon1
KXQ/QPXdU7Qz3yLHpHXXLhsfAW6RMIXBzbcwEmIiOnKFXmzsIlosZ8vEWocbBtvd
XzobDLeiaAp/aIWRLNDi5QG5U9E31ECSv9zRKGtc4VLQ2yzCptFQys26qnnK2b6m
ulmmCVj6y3ZCvWiy5FWjHDj36ODtsGkEO9v4oUhoZHswov1iwOn4iLdvvKA52MW5
e+p9HoBFxJxE1vfvOsFZsaqo2UlTRvUOpNeKh/1FZ0jEpi1+NTWbePJqXBzjNsjM
UjcdWvH3Bqrq+EuOA+NDzZm1x97GCSNWvMLRp3dlO5D6ifzLDx+Ror5OlcgLxdxj
16Nuhe2HdQtODHE+Uluk
=qpC4
-----END PGP SIGNATURE-----

--fncDiqCQ33hHmxh8T9aiRjKK31TVhATH8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
