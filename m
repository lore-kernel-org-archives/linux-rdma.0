From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v1 0/2] Checksum offload capability report
Date: Wed, 23 Sep 2015 09:53:20 -0400
Message-ID: <5602AED0.3020100@redhat.com>
References: <1442953091-102103-1-git-send-email-bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nejRGbwBXfbvRmeMeejDx1xfboISLEarl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442953091-102103-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nejRGbwBXfbvRmeMeejDx1xfboISLEarl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/22/2015 04:18 PM, wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This series adds kernel support for checksum offload cap report. The fi=
rst patch
> adds reporting for RAW and RC QPs. Patch 2 sets the capability accordin=
g to
> hardware.
>=20
> Changes from v1:
>   * The cap is reported through existing device_cap_flags. Only new enu=
m members
>     are added rather than to use an extra structure. IB_DEVICE_UD_IP_CS=
UM is
>     already defined there.
>   * Note: although there is no link layer info indicated here, normally=
 UD and
>     RC QPs are only available through IB, RAW QP is only available over=

>     Ethernet.
>=20
> Bodong Wang (2):
>   IB/core: Add support of checksum capability reporting for RC and RAW
>   IB/mlx4: Report checksum offload cap for RAW QP when query device
>=20
>  drivers/infiniband/hw/mlx4/main.c | 2 ++
>  include/rdma/ib_verbs.h           | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20

Thanks.  I'm happy with this.  Picked up for next.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nejRGbwBXfbvRmeMeejDx1xfboISLEarl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWAq7QAAoJELgmozMOVy/diwwQAKqFY9X/9Xsjhsm4lf41ItmK
ODEf8rI5lj3CDdcbQZRKKWuNyZxXmz80fmnr0tHaKQwpVveMq5Yg/tpb4seTVPKg
0xbDrlKFayq7m5hD2lWDwAbuMB7084UuCSt1ulqFZKChHkHfjgEaDgeF+7SiJQEI
5iP8qUiusXtHqblkiNjhcvnK9aeRdr76oWD9UOsXAiSS7pKEXGwxcxlVusjZ1Q4z
3pVwS9DxBVIDTUAjYpEiTQHbuAEl3Rf1OejDWwhV/UpeLNAXv5W8j4PvTY/8H04i
a/6DafBukno0XLlEsIg0JF46g1wR1MWtDcRLxlHztITLrjSd+QwgPnFFR+NVWP9A
zPlK/Amfusv0tDSbK11RB/wiAm7wdtioc2Ysy6PzpqUt9A6MdgYcgeEbOdvsHTFh
jfSrX0rXWytaF5CJR/ajkWuM1HUY3Qu0VH4zByABWlvqBOTvFDznec56PSaJ6fQ+
EIXxJKVRI+UcSiO0nEjUMULlYKIYaRSioq7hPs5kOH/w2RTMiGAPSJrxmXnNda3g
ZSpnhxCk8AumAZ6nslBmXck5nx2C8kjkaz9s+P9hfd9TCifDAuYNY0KBRrGXvQEW
FiNrPt/V6BEYqtk0uDJkYWU4fh51r6oHFGHxEKDR933JQbGAXNeDMt2lSNdfy734
lqmOX84P5mk0Rfh+A9DG
=Jmls
-----END PGP SIGNATURE-----

--nejRGbwBXfbvRmeMeejDx1xfboISLEarl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
