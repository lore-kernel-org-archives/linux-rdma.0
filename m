From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/iser: Fix connection teardown race condition
Date: Sat, 22 Jul 2017 13:17:01 -0400
Message-ID: <cb84b7c0-7347-74cc-db23-0cff4504cb1a@redhat.com>
References: <20170521161731.22223-1-leon@kernel.org>
 <98334f53-a7ff-d465-989f-a5ee7add2291@mellanox.com>
 <fa976fe5-be25-1c6a-5997-8fa7524e89d8@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jrBcaGQnL87xjKPCaDstGLEoLO3qidNgg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fa976fe5-be25-1c6a-5997-8fa7524e89d8-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jrBcaGQnL87xjKPCaDstGLEoLO3qidNgg
Content-Type: multipart/mixed; boundary="aJVtu2I49XPBM93GepNFuXljnA9VQpEDb";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <cb84b7c0-7347-74cc-db23-0cff4504cb1a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/iser: Fix connection teardown race condition
References: <20170521161731.22223-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <98334f53-a7ff-d465-989f-a5ee7add2291-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <fa976fe5-be25-1c6a-5997-8fa7524e89d8-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
In-Reply-To: <fa976fe5-be25-1c6a-5997-8fa7524e89d8-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

--aJVtu2I49XPBM93GepNFuXljnA9VQpEDb
Content-Type: text/plain; charset=windows-1255
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/30/2017 7:50 AM, Sagi Grimberg wrote:
>=20
>> Hi Sagi,
>>
>> what do you think on this approach ?
>> we must somehow defend on the NULL deref in case dd_data in iscsi_conn=

>> (the iser_conn) already NULL due to conn_stop call.
>=20
> Sounds like we get conn_stop duing lun scanning. Generally speaking I
> don't like a global lock for this, but given the non trivial iscsi stat=
e
> machine
> we can do with that.
>=20
> Reviewed-by: Sagi Grimberg <sagi-egDjqUIXVlxBDLzU/O5InQ@public.gmane.org>

This patch was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--aJVtu2I49XPBM93GepNFuXljnA9VQpEDb--

--jrBcaGQnL87xjKPCaDstGLEoLO3qidNgg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4iNAAoJELgmozMOVy/daqsQAIA2g2XJIHPh1dd8y9HdEWOl
O0iUct2mrh9jUG6gDyZw3m2mh+nX9/G/86OYe+NULvxKm18m6gCMjhFHqFVeLxJo
SUHM7QIv5scsEMurkRwdBtu5vGsK82UNHLsyvbehrj+vMjhQJGFFCYc5q0hRbMJP
d47EjrrqcBPys8TY1p0BO2Rr8oFgZLL883Pv+emNT1aOVlymGS3eiEcmEIWKl1tD
9KLq33ZKBa+fjsnpGsflgfaIrx6Jq51SLShIZCPeeLoOvo10Jx77rJYAqedUulXq
Ou329E70AKDA+Qf2n2ZWsmu8qcjvojrqtNaSPQ3kWErYtumSbv4k4x/ZGj5do6oQ
pbaMfxKp2/ikcl1APuzvoC2m9JW2NCCncyWsrpW6fqQMhSxP94PYqeh2zN9+KNQ/
EXspZCugD6He3PdVwufDWtB5T8W8yhBX9IN5nqY+qJpH/x7rns2OHe0k9OcuMVjg
VArVC1dsQwtlQ6B5IdsNbStU81xv6icd1WfxiVC4SZPlrsCKVS+bq7srB4lxoY7A
QTHmyxo2zM80Q+Xt2sNyUsHcURahPNv6bI1kDD8nNl/drQSc3VWqTIT6jV/vFhBV
8ESkuk2SOBIhosnKB1u2xHhyMvSiXe+J+fHdcpeN0pvVnyz4De6HwhTYCAkMy+V3
n3/WdTyR54zRAzChSh/n
=6P5s
-----END PGP SIGNATURE-----

--jrBcaGQnL87xjKPCaDstGLEoLO3qidNgg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
