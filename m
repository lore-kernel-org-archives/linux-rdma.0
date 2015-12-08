From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Minor fixes to qib per SFF 8636
Date: Tue, 8 Dec 2015 14:07:32 -0500
Message-ID: <56672A74.6010002@redhat.com>
References: <20151102171314.7574.32816.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xSEqV8KOAori4LqDPSb7CqOqSmDtF98c4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102171314.7574.32816.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xSEqV8KOAori4LqDPSb7CqOqSmDtF98c4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/02/2015 12:13 PM, Mike Marciniszyn wrote:
> From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Minor errors found via code inspection during future development.
> SFF 8636 defines bit position 2 to hold the status indication of
> QSFP memory paging. The mask used to test for the value was
> incorrect and is fixed in this patch. Additionally, the dump
> function had a mismatch between the field being printed out and
> the field used to source the data which was fixed.
>=20
> Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reported-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Pulled in for 4.4-rc.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xSEqV8KOAori4LqDPSb7CqOqSmDtF98c4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZyp0AAoJELgmozMOVy/dO1YP/ix2ydCq/aHBBjUugruSjATS
2naFOVdl3pDsqfHuE78PgNawsXZ6L9Ea0zM7wAzZD2JXQfy5mome1zBpXPTteaPg
d8m5FQz3Yfg7jk1h0hVmf8B4iIKBHQ8oYFqLELeLoTlth/roS5yOnV4DlTkaWGR0
nqKzcNXcqhcK8dyfSitX7lfLdIwP086oAGljnpFY8QNy4stHp4nRFP5ouvW6CqIB
U0/cl9xJSOleP7WUPha4ZL8ZqDQr5hfeJ2dkt/quxpt6SGJVqNwimjm70tRVw3ob
p3yMO2L+nOpIZIn6TIL5qLJ7qYKpV0LG32snovxRuOFaSJcctqNqAMbJtYdsqZ/g
RwNLd+P/pZ+4aXk0Lp9qPvZ33ZXsTo8AjlpJ/bpyd0QRB7KUz7FMD3D90no3uz5W
HXC6m1nJM0ue/kBYCmZj3XL9yGxOl6m9f36Avn9ddESgjROBFxXXWJv3qGz5pFIy
YuAoETWcEwPwt+/BDwVBBL8iEYEpbDm8o9RbDxSV6N5XpJkzNjBOWYDPPde5dB9Z
9MRSzdOL1ZKrML32hjDjdI2WHNnMefTrlNr4gPWhkaXTE+7kZ5G3bhsCpRA62tB6
DjIuMXn1Xdkf+waybMrrNOg2fYdZcM5cpBPjvQENTpxMKjOL08+ql9I3QTBKWUaj
wI/nEXIGcM/0Hiondyia
=Hbrx
-----END PGP SIGNATURE-----

--xSEqV8KOAori4LqDPSb7CqOqSmDtF98c4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
