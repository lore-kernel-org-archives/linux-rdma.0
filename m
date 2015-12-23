From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Handle 0 counts in resource allocation
Date: Wed, 23 Dec 2015 14:48:03 -0500
Message-ID: <567AFA73.3040609@redhat.com>
References: <1449686539-29959-6-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="E9jmi5K5MwUSTtVEM2Lmcaj6cINd8oVKj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686539-29959-6-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--E9jmi5K5MwUSTtVEM2Lmcaj6cINd8oVKj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:42 PM, Nelson Escobar wrote:
> Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_vnic.c | 54 +++++++++++++++++-------=
--------
>  1 file changed, 29 insertions(+), 25 deletions(-)

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--E9jmi5K5MwUSTtVEM2Lmcaj6cINd8oVKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBCAAGBQJWevpzAAoJELgmozMOVy/djhAP+K5weAFHQ7raEzwFmsCzLiJ2
3e7VsCfMU6/NlAY1hE+NBpzXkeKkLqTXBUPV83gP8XotRESDCTzLI83pBGkoRfTn
ccs18/VHrNLX3QJHHHrgUkLGpwLfzqDcRDtxV/sOoVHbJfaFKLhpDDdD779ROCVr
Ur+kJNXSovd9EYnf6H+V5KCa9NhetKpr2TCSpbXMkiM+IJKp1/5R7XFSRcvSGQ/j
ByBh+t7LtZIKedzvs9TmltvLDi6M3i6S5E5byBD35iCGS8BFxKmI1eK7YhFZckJa
hNwe0nye3+lKr+iwXXiyB4RTPYZTBVTsgRo1Zg5+Z9sA/OjMiNRgY2LJ0ftqh9h+
8SZD9w4DW13poTWN9vGRIcoxM6zJORRYezr3tjTWTTITSAo31OC+CubFxiQdQOg3
+M2EsuoW4PuEeUcTpSBGzR9aR9b/aVJtNOMgWVzDA51NqdM+Sq07BKdoyFSxYT6u
4Qgum/0aTxJYJPaXli9Gg2UMRDUsqjTjbGXSz65QGCwLZ1ZNA1hwxM3U3sDcblEq
Rd9NYk5X2mT2tbxOqmC8TuYHx5nA1fRHtrRTFuct1TUx3GNzTxTHIAvw+qmnKxHE
unOyy/OImV/fb8i/VsQJkKuqrixfmUWtsnTVeTAlBOtPX8y2qGMFezgRpfC7uEfL
R/YTH4M2PwAzv67VOZI=
=aRji
-----END PGP SIGNATURE-----

--E9jmi5K5MwUSTtVEM2Lmcaj6cINd8oVKj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
