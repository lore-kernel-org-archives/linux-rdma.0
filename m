From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix static analysis warning in
 ib_policy_change_task
Date: Sat, 1 Jul 2017 15:41:20 -0400
Message-ID: <5fd731d6-a5ae-9894-be72-8a5d41603206@redhat.com>
References: <1498835756-7610-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhQC4VO2W6TCOWxKdfsra=fG12ZYXaJdKQJVXtLz92XtoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3rLUJN3oIBdptVq0e4pKg6tl7rrrn0twl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhQC4VO2W6TCOWxKdfsra=fG12ZYXaJdKQJVXtLz92XtoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3rLUJN3oIBdptVq0e4pKg6tl7rrrn0twl
Content-Type: multipart/mixed; boundary="e6HxkGdJUUw8w7GbEPiXeSpA5claJthx4";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <5fd731d6-a5ae-9894-be72-8a5d41603206-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix static analysis warning in
 ib_policy_change_task
References: <1498835756-7610-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <CAHC9VhQC4VO2W6TCOWxKdfsra=fG12ZYXaJdKQJVXtLz92XtoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAHC9VhQC4VO2W6TCOWxKdfsra=fG12ZYXaJdKQJVXtLz92XtoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--e6HxkGdJUUw8w7GbEPiXeSpA5claJthx4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/1/2017 9:42 AM, Paul Moore wrote:
> On Fri, Jun 30, 2017 at 11:15 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> ib_get_cached_subnet_prefix can technically fail, but the only way it
>> could is not possible based on the loop conditions. Check the return
>> value before using the variable sp to resolve a static analysis warnin=
g.
>>
>> Fixes: 8f408ab64be6 ("selinux lsm IB/core: Implement LSM notification
>> system")
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/device.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> Similar question as with the other fix: SELinux tree or IB/RDMA tree?
>=20

The SELinux tree will be fine with me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--e6HxkGdJUUw8w7GbEPiXeSpA5claJthx4--

--3rLUJN3oIBdptVq0e4pKg6tl7rrrn0twl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZV/rmAAoJELgmozMOVy/dAioP/Au7nHalUokmVh9G449zRfUo
9qpNvuAqhldr3iwN8Lvl1X8ptdR1SipF7rKBeREbPd/3vGrWkdGdFP77zptCN3YJ
nKck93KMhfs97zl/9LmsTjjrc1ne5S3uJczntscQAbtqVf11+7OKxLaFAsPJ+BtM
WzIO9v7AKy2kYH2lHHxLhslynYq/9XgwXGbnAGD/Mla2rm5cuytF0EpVkY2tkEHU
73N6KjfzTSr1z/7DME7MHpCTiPtJ7twidblgOk7l9AYyfDh5ktECOj1fzHgA4x8B
MJutfyr6gk77FYOgftR7JL75KKd0uE0LHWn+Arb/UZsclyhFX41sYbO8Kh6+TBgc
/OZj/A961slT7PBi/S4jShsJVpwLcAaSO6EpurbqPB9hBerGJHSughkRdz9wG6dz
qi5DdVxCw4Iz56oELhdB28KwVrs2oyzRPuSI1X5XjTRVyuJQEEsCJNPU8kfwetLv
/rEqgnjHdx5927dKk+I72P5OGIN0k9wT28TF80K4sClVn5HHoAgjqaBrpQetx/rd
T9kuhaOwGd4rEhk/zWpbng84XlP2VoC/ek5TzRmjKd3xIkGlCTMqSr3n+sEHB1J3
PQY+PVRoMRFpJYGP+CosPdYFpYkdLmTwhiI9N2h1mOZRtXVNyC39fpwM7Q/vGiYX
KE/G3ArrZiFrNTA26O3g
=p+/x
-----END PGP SIGNATURE-----

--3rLUJN3oIBdptVq0e4pKg6tl7rrrn0twl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
