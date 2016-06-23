From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] ConnectX-4/Connect-IB Port Counters
Date: Thu, 23 Jun 2016 12:21:23 -0400
Message-ID: <09e6e3c1-5eba-df8b-7d0f-2c2572ed83c9@redhat.com>
References: <1466165456-31857-1-git-send-email-leon@kernel.org>
 <b4dc9bd0-a84c-201a-475a-a9afd9bffb44@redhat.com>
 <20160623161748.GB23995@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3egNWMkw7xX4snIjRAhgiwfvXPGUHAVFb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160623161748.GB23995-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3egNWMkw7xX4snIjRAhgiwfvXPGUHAVFb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/23/2016 12:17 PM, Leon Romanovsky wrote:
> On Thu, Jun 23, 2016 at 11:41:11AM -0400, Doug Ledford wrote:
>> On 06/17/2016 08:10 AM, Leon Romanovsky wrote:
>>> This is supplementary part of mlx5 driver to generic IB counters infr=
astructure.
>>>
>>> Mark Bloch (2):
>>>   IB/mlx5: Add per port counters
>>>   IB/mlx5: Add port protocol stats
>>>
>>>  drivers/infiniband/hw/mlx5/main.c    | 134 +++++++++++++++++++++++++=
+++++++++-
>>>  drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 ++
>>>  drivers/infiniband/hw/mlx5/qp.c      |   9 +++
>>>  3 files changed, 147 insertions(+), 2 deletions(-)
>>>
>>
>> Took a little work to make it apply, but series applied for 4.8, thank=
s.
>=20
> Thanks Doug,
>=20
> I'm limited in my ability to predict the order of applies, and for
> example this patchset applied cleanly for me.
>=20
> For your reference, I have reference branch (testing/rdma-next) with al=
l
> topics in it.
>=20
> Do you want to see it organized differently?

No, I'm just making you aware of the fact that I had to fix things up so
that if you want to double check how I did the fix up, you can.  It
would be bad if I merged something and broke things subtly and no one
knew until much later.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3egNWMkw7xX4snIjRAhgiwfvXPGUHAVFb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbAyDAAoJELgmozMOVy/denEQAJV/uk+m0Tqy2gObw//wMiVr
VGLQbCCjpac9yIQDqYZuFQwmmDvJnpD4dzmcvSBI9W8kaWIRWJfO7YPszOLIU/AA
+tPT4jVMyW1Ixp7A+BLeqs+8J7mhrRIFlOlt6Nrv0ZGK1qq1NUhbzyjfa5wnH8Im
zd0QheXw5MnaMCl+whtNsd9mfGXLESeDQbvJ22FgeAVTR11q2sijTqEC3mwC7QWG
K1MyRseFuRlRhHj7EesK8tcmL2xMdmTK6kzIFJK6IieqQeJRAyjymgtIZC4rB3Ze
MAo/ryLUTIKi5D/zSpDtCXXWq+re/sU2JJnJlNFpRa8L3yNTDmwTZWdoncybV6nN
Sn2lG8JgZxj9mM1PinCh0uzDAtuqJvf0/JOREoFb1mwQyhk1137Z8NU3S0Wf8G7h
PiWLLZr+w/1QcbVqhY17WDg+pEKDKYZBDvTffMWQwpb/8rv/dyPRRmOAsugAsuk4
xGaUJHrKIqLQpgYpG5KuJIhRsAdzL1VOApU9YiZv753ueBq2ovhBiffRdgc2xfjr
RaE5/+ogL5qzbi+UGDNxhuZM6FCheaGZ/KtCszchLruS+HBBqcFD/rTV0Wy1ZWuo
+bTPaUN/iWgJgHzNyqmkPg8sDFt474PkW8Eyb3p1ttf4ejyqHBVeLvV87qrc+z86
jpNubnoVdRePM6toNBDM
=0AhJ
-----END PGP SIGNATURE-----

--3egNWMkw7xX4snIjRAhgiwfvXPGUHAVFb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
