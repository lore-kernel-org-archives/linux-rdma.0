From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v1] libibverbs: Add support for checksum offload
Date: Wed, 23 Sep 2015 12:16:34 -0400
Message-ID: <5602D062.1010706@redhat.com>
References: <1442953221-104830-1-git-send-email-bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BxSftlhFXUxx4AVgAwml29BVwIlNq8Btk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442953221-104830-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BxSftlhFXUxx4AVgAwml29BVwIlNq8Btk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/22/2015 04:20 PM, wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Changes from v1:
>  * Use the CSUM caps from device_cap_flags rather than defining new fil=
eds
>=20
> Bodong Wang (1):
>   libibverbs: Report checksum offload capabilities
>=20
>  include/infiniband/verbs.h | 14 ++++++++++++--
>  man/ibv_poll_cq.3          |  5 +++++
>  man/ibv_post_send.3        |  4 ++++
>  3 files changed, 21 insertions(+), 2 deletions(-)
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BxSftlhFXUxx4AVgAwml29BVwIlNq8Btk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWAtBiAAoJELgmozMOVy/dsEwQAJr1QiwLLosYSJIMdRBwbngi
zqtdBY4Zns5ILvA6kO84RjqHlac/mZn8kccWfGbJYXjYRML9hTuHnQY5Fb7FNe9J
f0ZJOckQAeolGjyL4d45Jk/jIJ6gKRYtUBdMnDG7EI4Yd2A7QROHdgXX7DLKz2Dj
gWQCu3hLIw+RJi762F2VlcOYXQrWdv3CR4gAVZYs/b9jqGMIuqbWmnDsNhTXZWfL
Q2OiRDpglPYwfkojFfyaacpT1O2ttbkKkpaUTwYWSjON2ZsJI5YPpEf/1gbEXzH5
wL+mEmjhK3qzK1Jg93fbkyYK59ZGqCqZBcsLo77bjnKS83kXJ06t8ClHaVEVBDew
77p73i77PsAKAznCeYcIO6KqW6kD82V09cDJYWSy+TTXi0nBVRJOIWIAxpj0hsQo
5FxrgC/xgbN0i3jIMwzGgYC1ZwL7Mq+6wYyV+obErv9x3ZmSx1zA8IhtSusSqASH
tGUJQLHs3lCE1EbRzlG0+VaFQ1Yioj3XxwptyMo6YeEd72Oc8GYLmNOK+efDtgSe
SzJBN9C6HbP+3ejFfxvMVFqCKl+Kyi582CNFqoh0E1IkqoMAW5YEZVSpV8bmmUxh
vI018GlgvpWFLYqdzfJrEGRbRfuY8vzkBxhyJcaF+/mIcHXEKULBTa9hVgatmiy4
pkxTtTANq42jlvQkxgwG
=g5yX
-----END PGP SIGNATURE-----

--BxSftlhFXUxx4AVgAwml29BVwIlNq8Btk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
