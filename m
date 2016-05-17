From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Tue, 17 May 2016 10:58:19 -0400
Message-ID: <910c3e4c-2427-34c4-cc42-f8e951c7d157@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
 <20160517054834.GD4662@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VwMgX6nBjjRpvq2HWGvs7XCcsxPLKTeRE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160517054834.GD4662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VwMgX6nBjjRpvq2HWGvs7XCcsxPLKTeRE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/17/2016 01:48 AM, Leon Romanovsky wrote:
> On Mon, May 16, 2016 at 04:27:05PM -0400, Doug Ledford wrote:

>> It's not removing two lines.  If someone wants to be able to boot both=

>> kernels prior to this change and kernel post this change, they have to=

>> now write their script to handle both conditions sanely.  And they hav=
e
>> to know to do so, where as very often they simply get caught off guard=

>> and things are broken for some period of time.  If the change to ib_ad=
dr
>> actually solved a problem that couldn't be solved otherwise, that woul=
d
>> be one thing.  But it doesn't.  It's a complete no-op.
>=20
> I think that your position is too tight for not allowing modules
> restructure. It looks like that this complexity doesn't exist outside
> testing scripts.

No, they were/are production scripts.

> For my testings, I'm using Debian Sid with inbox scripts/packages and i=
t handles
> correctly IB stack with different kernels and different set of modules.=


Does it support reloading the stack and have you tried it if it does?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--VwMgX6nBjjRpvq2HWGvs7XCcsxPLKTeRE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOzGLAAoJELgmozMOVy/d9UYP/2pRKGalCGirXxPPCBjM2Whr
uC1x81xYjpSQYqock0cSR7365udFr+00Jl5mgj5u910PPEk165iaOg3jyNoy4TP5
t5tBy7Q1MSr5Qf37r3hvqdYaopYCZRuXro1vHLI0Yymxpjkx1FhQKugkLAml43bV
LmbyzK761jzwUwak5msEcyDDb2KA2JIgAbxF2OOw53ul4bY72x6f43f09TqMqUX1
QnUoiNkMKWUTBk7HChuZA59o1wisRLuFPeQkhE9Ii5d1Qskx7LWqF9ba4XQLpWD4
+fy70yNAIBlpe2dWjzs1yMAiMQT+HikUdhYY8C6VC7B2L0R7nWjX7S+rBdM6dZM7
xgyLGM03lGwnlTlEaDaK196CwTVsBIbgpKzTezNXSgHmyTRhrrtw1wRgXYuhbIFP
GT82gRYAp9oAB2Q8Emby6Z0CEe+jy4fSoZKinVr1hN/1HXmzAa0fS/7s89u/zJVA
P53s90WoV5MSjQjSiNtsQxFNj/DAogvWuSgAQePvFuQQyGg931lRY6AiBxxM2csT
OIBprjAZ9xpDytYU4RK5grG5dViwPOJavPBbcWm33eXsJx6yDuuEE1oqY0RMjdCK
TGGSB++ompMNny3VwQoXr76fSFKq0YnyjJ+lyuPONISjpkFRGg/pCUY4TtFoGJyZ
8VVAK2b4kcvRBSgEqbGA
=RzG1
-----END PGP SIGNATURE-----

--VwMgX6nBjjRpvq2HWGvs7XCcsxPLKTeRE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
