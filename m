From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.5-rc 0/4] ocrdma bug fixes
Date: Fri, 5 Feb 2016 15:12:51 -0500
Message-ID: <56B50243.3050003@redhat.com>
References: <1454683001-21275-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lqFUoja2HP29RokL5vukj00bTDlkeUaCE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454683001-21275-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lqFUoja2HP29RokL5vukj00bTDlkeUaCE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/05/2016 09:36 AM, Selvin Xavier wrote:
> This patch series contains some of the bug fixes for ocrdma driver.
>=20
> Selvin Xavier (4):
>   RDMA/ocrdma: Initialize stats resources in the driver before ib devic=
e
>     registration.
>   RDMA/ocrdma: populate max_sge_rd in device attributes
>   RDMA/ocrdma: Fix pkey_index returned by driver in rq work completion
>   RDMA/ocrdma: Fixing ocrdma debugfs directory remove
>=20
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  6 ++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 16 +++++-----------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.h |  2 ++
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  7 +++----
>  4 files changed, 16 insertions(+), 15 deletions(-)
>=20

I was just about to post a crash report for ocrdma in 4.5-rc2 + my
queued fixes.  I'll pull these and see if the crash is gone (the first
patch looks a good candidate to fix the crash).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--lqFUoja2HP29RokL5vukj00bTDlkeUaCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWtQJDAAoJELgmozMOVy/d8NAQAJc+ctSSTSet1AXStbdqYxmK
T1HUyZth3v6Xfc3hwildDVMzMCGxWsW7qgUuD/jSkvVi+nKqpoVtfClCNMc/SRel
visWt2bc8Ou/TtL1T9iyDS3bLaeA3fI5p2ilznbE2HYP+eY3E+BMfuWgxE/f6Rmn
+AsfnIEsZNr97nR1HwxR7Dqt/X3UwA8NtADfe8nF7vy6Ay4WGfSLtNI8GOhi1B4Y
AVNkmb6m87sjNvd66PwTqJvjVURpkc9AAKU7ee31P8kbm7B3dgOPm0FXwhYL635X
+QD0WV7ywfrVCDo4u2+Zl1HL373isfEQeQuHdmvE4ldkgcebOCEPK+R/u9vaJOet
vi35NGnYjPXZpLYOtNpUPv9lbSRd08rnrqulSNuMOV9d8BKG1ly6j6B7eMTT3w+g
06ItqdSXNOtmtvzvF4ATyzvh6adj38v4jyUb9cY74vh0b9AoWo10r1KaLfpoNiFP
38hywBwqVgGAwofkaAJbKp3RvvruO1bDlmZ9f/EzdtyM5kHS6phwPzEkZCNzXA35
ixDW9AouLGBPuDdnXVO4hFlVZGpuMU7SdFa+6U+Z+7HAjXKqcTPmu3aq0gz79OXx
MluVcSTO4Gw0CWTl0x2GNScIGwP+V1Psc6LK/8GB22p80bIsFPob4VfITtpN1SPg
TJa4TJftWT0D0YhjBkHD
=MmK9
-----END PGP SIGNATURE-----

--lqFUoja2HP29RokL5vukj00bTDlkeUaCE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
