From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Fri, 11 Sep 2015 10:28:47 -0400
Message-ID: <55F2E51F.2040906@redhat.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
 <55EA2CA7.8000702@redhat.com> <55F19F09.7000407@mellanox.com>
 <55F1B571.7020808@redhat.com> <55F27F51.6010406@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T1jGr7oHCblwe89Xm9P88e5LRsxNFpn3c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F27F51.6010406-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T1jGr7oHCblwe89Xm9P88e5LRsxNFpn3c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/11/2015 03:14 AM, Or Gerlitz wrote:
> On 9/10/2015 7:53 PM, Doug Ledford wrote:
>>> >I don't see it in your kernel.org tree [1]
>> Because I didn't push it yet.  I can push it now....
>>
>> Push complete.
>>
>=20
> So we should keep chasing every commit you took and have humans  look
> for it among bunch of trees/branches,

No.  This is libibverbs, not my kernel tree.  There is only one place to
look Or.  I hadn't pushed it out live yet even though I had accepted it
into my tree, that's all.  The rest of your complaints below have no
basis in reality when it comes to the libibverbs tree.

 it's so tired-ing and annoying
> with all our (no human) automation systems that attepmt to pick applied=

> patches into the internal review, build and staging systems completely
> non-functioning for couple of months.
>=20
> Or.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--T1jGr7oHCblwe89Xm9P88e5LRsxNFpn3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8uUfAAoJELgmozMOVy/d4fMP/A+dtZt+GKC1Tz9vbKlewIl8
yrMhZGQxyl7otGx6p450ybcNP8WeHzSRYJ5a2iaYtKfLX4lipTp4fcCBMgvmIaKm
0DucXpCUmIrR0OeoOCxFV3QtiLjP/xp6TWdee8ucI0QFHRoUA8EzCtCj/A0B7saf
o9+1FXykXP6aRMVVdwESfDuALG8OSQg9jXbI+1sG/pmdbQARpICHn0z6yyTy2knb
fyGOz0yNqJ2IN6XxEks4IwjE14doAS6+Kon5uBipix3A/QcODlgJWwp9nEf0OyJ+
xRPMs4c+n5Q8ZnXVAw4Fsz9tzsRNo2yGAaDdHGppy/E/Nn5d3thxxz70ezvfIRSR
OewYmrQ1uPmhlQMuzL50ke1RnzpGmIzdugoQHUUvmHvGVufPZxs4IEIKe1Qc+T36
1fbnvbBxuqoQPQ+K01wj/mWNef+j2PSpNfsIsVMj1zX/dnYqugjrblAYEi2YiO0P
+QGteV2wBB4cJmXEblW1o+jEfN/i0laNv7rLiM4WfH3oCHoeyyupcI8bfNjtjx7O
A6oXe6gKjX0VZ5KWMceZVPH55aw8WvZSQWxkGzKvogIGTkoc+CnlC4UsoLghXSSl
Z7pGZWEgtG8IBIJlNG4RhIDFHDM+dloIKrdhOnTYlDPA5uIZyzs5QSDgeSzGCiSZ
gUcXmSXQxmYBt0W8iSCj
=AAyk
-----END PGP SIGNATURE-----

--T1jGr7oHCblwe89Xm9P88e5LRsxNFpn3c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
