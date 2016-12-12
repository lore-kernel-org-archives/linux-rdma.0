From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] IB/rxe: Fix kernel panics when tearing down QPs
Date: Mon, 12 Dec 2016 16:42:37 -0500
Message-ID: <2ce6448e-430e-91c1-fa10-86fbdbb1714f@redhat.com>
References: <1480945335-2577-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ivMxelPkSqBbIUNMspBj3gKu6EVmpqmgi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480945335-2577-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ivMxelPkSqBbIUNMspBj3gKu6EVmpqmgi
Content-Type: multipart/mixed; boundary="aQfl3A2WxboG3g0B2TQWtDwtkUOu7UqVR";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <2ce6448e-430e-91c1-fa10-86fbdbb1714f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] IB/rxe: Fix kernel panics when tearing down QPs
References: <1480945335-2577-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
In-Reply-To: <1480945335-2577-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>

--aQfl3A2WxboG3g0B2TQWtDwtkUOu7UqVR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/5/2016 8:42 AM, Andrew Boyer wrote:
> This is a set of two patches that prevent kernel panics seen when teari=
ng
> down QPs. The second patch (holding refs in tasklets) might or might no=
t be
> needed once the first patch (waiting for tasklets to finish) is applied=
=2E
> Feedback welcomed.
>=20
> Update for v2:
>  - Remove default initialization of idle in rxe_cleanup_task() per revi=
ew
>=20
> Andrew Boyer (2):
>   IB/rxe: Wait for tasklets to finish before tearing down QP
>   IB/rxe: Hold refs when running tasklets
>=20
>  drivers/infiniband/sw/rxe/rxe_comp.c |  4 ++++
>  drivers/infiniband/sw/rxe/rxe_req.c  |  4 ++++
>  drivers/infiniband/sw/rxe/rxe_resp.c |  3 +++
>  drivers/infiniband/sw/rxe/rxe_task.c | 19 +++++++++++++++++++
>  drivers/infiniband/sw/rxe/rxe_task.h |  1 +
>  5 files changed, 31 insertions(+)
>=20

Hi Andrew, I took these patches as well.  I had to fix up the second
one, so you might want to double check it.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--aQfl3A2WxboG3g0B2TQWtDwtkUOu7UqVR--

--ivMxelPkSqBbIUNMspBj3gKu6EVmpqmgi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTxnNAAoJELgmozMOVy/dYrkQAJFarzcC8UdRxFleh31T37/4
2XSoJxJAHmEb1YrQXtonLGdhtDSJOCHU+F2BL+HeAyDPjZZhbGhY9L5tSYMiDq3I
bskCTQ059AUnV85kVdwJD9s769F+4h+y1WM+SVwvmFmB/WOjVatq534XO43d4X7J
ElNfA1hZNwCRE8kcnO4fzVfOMMkkvoXEoTPz4VgGA13OFWBa00h9bJV+VefvkKkZ
CZ2dnXyxC+HLPYKjQGuHtczrgNpcABN9MOBKWa8wYELKS9JaGUtQWX4rf5XxtO/T
UJvMfKDpHB71agB9Ki+/2D8wWI7xVsFMZqohdgmb8eOucseJMdpEaAgJ+/4YdpOb
FvZv2eP3ORCSFia7fl06d8x9S7/4YLgHMJmuDRruDv2QhB0XE/vvExEmMLuPbUe2
uTkTfVbTQB91+ulrK3fGe1hQwSlOikH3xK6R7kzK6sFyHaPZbBiulkxC0OtLq5EB
khrF9gZLV4VlMdoJHUJQQHIMYQNnII3YmQ561p5BsQXD6IS6QKrlwooWNTA4flna
qEYTPPjoAqOHQiMmD8TnSXlnHBRrqnZHcL76bgVN9vYT+adDLB1yFGQIDBNqWcYH
UsbWV8RKqv2fRmOB9RdaN308W3Ku/DV3LG3pwIKxOIaTtjqmTfCa+nkOLlaouqMQ
Nqcb6MU2tdNwXxwndDD1
=FBLT
-----END PGP SIGNATURE-----

--ivMxelPkSqBbIUNMspBj3gKu6EVmpqmgi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
