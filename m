From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core, cma: Make __attribute_const__ declarations
 sparse-friendly
Date: Fri, 14 Aug 2015 15:27:08 -0400
Message-ID: <55CE410C.7080002@redhat.com>
References: <55BF9E80.3030306@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="onNTgXINsVQhoRhnKFQQvtxVg27KT0BhP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BF9E80.3030306-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--onNTgXINsVQhoRhnKFQQvtxVg27KT0BhP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/03/2015 01:01 PM, Bart Van Assche wrote:
> Move the __attribute_const__ declarations such that sparse understands
> that these apply to the function itself and not to the return type.
> This avoids that sparse reports error messages like the following:
>=20
> drivers/infiniband/core/verbs.c:73:12: error: symbol 'ib_event_msg' red=
eclared with different type (originally declared at include/rdma/ib_verbs=
=2Eh:470) - different modifiers
>=20
> Fixes: 2b1b5b601230 ("IB/core, cma: Nice log-friendly string helpers")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--onNTgXINsVQhoRhnKFQQvtxVg27KT0BhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzkEMAAoJELgmozMOVy/db/8P/i6kto1L997wW7qtHYhq5ZYf
k2w9ynwyuNq3agk/eGTdVxyjwj1l7Zc+EH0sc9KFYa3r3heT30S14W9er2B8iwpN
ODluVDSw/37IH4RWjvLcyHBJRjJ8QtUKnzD7nw8lfSLzOqjwXksMTxiny6H6Na/b
o0JJDtndNk4IxFLuOk4e22aoA+AVG/CZjVu/gnkAwrfLawes1teLQHrlrV/BAM7I
OIv8rJUdZh9BySZuuUyCiCQycCIqUy2INSIxnlu3xvi0gJ0TUDYQ3KDoyq5+DwJK
vVedSfezVVBLWTtVYI+/tLe/keHGZ+7FrAY8ZS0oybRKHSl9qD+6fdjfNWJp1of0
Ofppgy0DUpHpaxTK0bmc6LCBHbisLBcg5jvB0naD0lMG3frvipvUP9Q8REW7vEGi
zuAuwVGhQ6eNPFsPdcKkz6PhjSapQQ33tpWWJrXtcY8+bQzHRJPKuT+q42tbcsWe
nUlSiRJJr5to/Iz+aetNbv5quTeZXyl4M5c1wcSAnYwjrI9kUf28lDpuURve/pWr
OneLsVUQ5CakBgGCzJM+Qgwy2IlJMLQ/Csjej6g772I3cBKKnvnc1MMdo4L3+rK1
JpHluEOZN7JJaqwf1TS5Cn8VRl6uJJ08ZGajxfrGd66zi/ReIpIM6Bpv9vav80YE
+oocklPxBdkM7xWeUWDO
=8uta
-----END PGP SIGNATURE-----

--onNTgXINsVQhoRhnKFQQvtxVg27KT0BhP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
