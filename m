From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipath: Move ipath driver to staging.
Date: Thu, 30 Jul 2015 11:08:04 -0400
Message-ID: <55BA3DD4.4070604@redhat.com>
References: <1438262742-4182-1-git-send-email-dennis.dalessandro@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WJWBBdTJELolLNejvTFBJofjK5wDfhLSG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438262742-4182-1-git-send-email-dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WJWBBdTJELolLNejvTFBJofjK5wDfhLSG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 09:25 AM, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> It is now time for the ipath driver to begin to be phased out of the ke=
rnel.
> This patch moves the ipath driver from the Infiniband sub tree to the s=
taging
> area where it will remain until the code is removed from the kernel in =
a few
> releases.
>=20
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, picked up for 4.3.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--WJWBBdTJELolLNejvTFBJofjK5wDfhLSG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuj3UAAoJELgmozMOVy/dd6EQAKB3RajPK2ggj4E39gd/54JM
b1n1/wGWgCAr2atgloCmF8tyX6T7/yHWPEYtoBCvbJMX/FYUsPifkyrMRlQJEybN
MUmQCpw8Q+hKbwNqqsyjW/ucjeJWScarxieBDZjbq26aFU+CFNBSyelq7iLRkvCq
xQUPSJUVeBp+41vNi0wQ1NOD/VQjeh7sxEvTydNVUbjONH9gEhtOfdwCt4Bejf3X
BFvLbztX1qg0aYwhrNavKOs6Ny7kMTypism7w7mJGGAapHt9kAEwIhH6Y9JgvCop
JdmhPKE5UwtHhw87YpbmRxz9lToPG3281woGKd5ee8+XRXvlr8E5jLB6LR7kxcwg
FpwPlqrxqjhAkITkM7IDuR0a4E00irtzFj+sepQFKqovzlhhHi/Ln2QAcXOfOLGu
JQSe3FeT5lsF/e4+9G//xdDpK0CVO767+rsyYhEmRFZx5wOhnImdVo+Oo+bJ3uIm
kzX0tbETxydVfOG3GVjkLgrEpft2swf8nqk0sWzzkO0WkQByoHeSdnULvoFoq10B
RgQvCmtL1vh1YDXN73t+aMNf4s9qAcn/TXoZhF8jQTasMn/FmmEpPCUaXBjqgTD9
fIOJXiuHt8lAMvkMRYogSPshKL2AZBmiGaJ3Xl0KrB7ncrtFldHAMSSVIJfdFFRL
+LIzBVhY9P0d+MsuPEWB
=I0A/
-----END PGP SIGNATURE-----

--WJWBBdTJELolLNejvTFBJofjK5wDfhLSG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
