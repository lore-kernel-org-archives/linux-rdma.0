From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add -DIN_PLACE=1 to cmake
Date: Fri, 23 Dec 2016 07:12:19 -0500
Message-ID: <0be714f3-0b71-a86a-98f1-6e9da3605f43@redhat.com>
References: <20161222221559.GA15947@obsidianresearch.com>
 <029801d25ca2$f8bb2f80$ea318e80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Uxj7HsdQNSU06sUnMhHXh9nGbjuhJb6bn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <029801d25ca2$f8bb2f80$ea318e80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Uxj7HsdQNSU06sUnMhHXh9nGbjuhJb6bn
Content-Type: multipart/mixed; boundary="ou6qlG8vViU39C58IxmHKRBxNwp9F5Jgp";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <0be714f3-0b71-a86a-98f1-6e9da3605f43-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add -DIN_PLACE=1 to cmake
References: <20161222221559.GA15947-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <029801d25ca2$f8bb2f80$ea318e80$@opengridcomputing.com>
In-Reply-To: <029801d25ca2$f8bb2f80$ea318e80$@opengridcomputing.com>

--ou6qlG8vViU39C58IxmHKRBxNwp9F5Jgp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 5:30 PM, Steve Wise wrote:
>=20
>> This configures the paths to run the software from the local build
>> directory. Much of this is done automatically by how cmake uses rpath,=

>> but the two cases where we dlopen things have to be handled by us.
>>
>> The simple solution is to hard wire the build directory path into the
>> binaries.
>>
>> 'etc' is also relocated to build/etc/ as that is part of how the verbs=

>> providers are located.
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> ---
>>  CMakeLists.txt                | 23 +++++++++++++++++++++--
>>  README.md                     |  3 ++-
>>  build.sh                      |  4 ++--
>>  buildlib/rdma_functions.cmake |  4 ++--
>>  ibacm/CMakeLists.txt          |  5 +++++
>>  5 files changed, 32 insertions(+), 7 deletions(-)
>>
>> Steve, this is a refined version of what I sent you ealier, does it
>> work for you?
>>
>=20
> I was able to run rping from build/bin/rping and it loaded
> build/lib/libcxgb4-rdmav2.so, so it worked for me.
>=20
> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied, and new -rc version pushed out.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--ou6qlG8vViU39C58IxmHKRBxNwp9F5Jgp--

--Uxj7HsdQNSU06sUnMhHXh9nGbjuhJb6bn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXRSjAAoJELgmozMOVy/dploP/2WoErslf4uqWkpm4uIGsWZw
uxS9okabZLb9xZv/wKAqEE7sTnACIhR6ObUeIcznsgT8mM35fnzLr6S+T7F5uEY9
QqLnyW1gIf2ONh7hAVAvpxDLVGPS1YzwgJoLRIMlRAZSlpUpf3ewf2A7yr7yg5C9
Avox6TYX2KIOv95zNFR77iUszx2hm5MpO4b0Ohvs7y2pk+8h8YVoJZ7ho3+NPhbV
UQ8jUuRKxklHwuFW+RViNg62gfsvoK3pOv8OJjQ98We6gXoNPZN0nYIS9Uo6jJvB
2RbEkK7kkTh9uI1ut9U03f5LEF8gI1OXDG4OkhnTpW8civvMPlABgxYhdFwR9zAy
qJoPmjYj0jtu9n0y9H0EPYUWbIU20aEfToS346Vq/+OmG0Gez2LrASvSxv49azYG
LT46TBAR3ei2fgdE0v21hpmLEvI2E65UAd1kCvmTM1pW08wRjwRMq/ChBsdipJiJ
+AovThdmOdcjM9gYnXHoKusfMz3C4z80Pq8Hmx9eCw04exWDyeiZviOZkxU9csyu
SpXSA7tnUEnRvJb/l1XHuqEhRJvWdiUMdYbuJVCdLpaD5g3SdyD6AZdtaiHNQwDq
iD+BSmvA5PjbpsQf/jQY4Cu+RJN40L+IU+EU7/DKqv2Ll1oEPz7C6ch0g2ifjE26
vwV4ppgBWYm2t1RMlaNu
=4Py+
-----END PGP SIGNATURE-----

--Uxj7HsdQNSU06sUnMhHXh9nGbjuhJb6bn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
