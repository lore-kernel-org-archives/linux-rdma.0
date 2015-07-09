From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB: Add rdma_cap_ib_switch helper and use where appropriate
Date: Wed, 08 Jul 2015 20:13:43 -0400
Message-ID: <559DBCB7.70605@redhat.com>
References: <5583536C.3010504@dev.mellanox.co.il> <55914EAC.6010108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="w55KcsImixVjn7Xr0nHlhRtIAGAFHASNN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55914EAC.6010108-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w55KcsImixVjn7Xr0nHlhRtIAGAFHASNN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/29/2015 09:57 AM, Hal Rosenstock wrote:
> Persuant to Liran's comments on node_type on linux-rdma
> mailing list:
>=20
> In an effort to reform the RDMA core and ULPs to minimize use of
> node_type in struct ib_device, an additional bit is added to
> struct ib_device for is_switch (IB switch). This is needed=20
> to be initialized by any IB switch device driver. This is a=20
> NEW requirement on such device drivers which are all
> "out of tree".
>=20
> In addition, an ib_switch helper was added to ib_verbs.h
> based on the is_switch device bit rather than node_type
> (although those should be consistent).
>=20
> The RDMA core (MAD, SMI, agent, sa_query, multicast, sysfs)
> as well as (IPoIB and SRP) ULPs are updated where
> appropriate to use this new helper. In some cases,
> the helper is now used under the covers of using
> rdma_[start end]_port rather than the open coding
> previously used.
>=20
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Tested-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Identical to RFCv2 patch with additional Reviewed and Tested by lines

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--w55KcsImixVjn7Xr0nHlhRtIAGAFHASNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnby3AAoJELgmozMOVy/dvPEP/iCXh5u9//i0WMdswexX/cTE
gmJ5xo/WAv2GRz60KGg9Fl3UTZRhg5jCGW3VcZbnyeuVZSfklFkH+AP7Z7Pr5fSt
36bK0d2DxQPNJcbMkODFc9ikhBU1dbe3UZEI5LR/IvsckVHZHaRlm5HX1H6FFU7B
CBif5FdEIL58p8BCHCUI4zLhQnVyDicZ13XQk0cq9JE9AYhOldJoTBrTaj6ztzMA
LHp8HjnDSpnAbx7o0hhIL2kQ1mRoIPBMfXGoWzJdEN47nb/f5TnapHbV+QI5W2JP
8lb6B7kapyn8NgcSLrjpCwyeX46B5wmPn5qQ9llI/ZE6z6SciRlynNhWEFyG0pDU
wWv9wTe8QVNSJqHjps3R0Y8Cv2wvD/yHJUHm+TSZYMIYKzGn+AZ/wlMJz//PNaU+
vu8zDtGYEHJ9wn22HX5xlJpogiAhAfOXpYUfpivuvVczA7IK7dzdANfeSi1ER0Jb
FPFK0bTcdEpIyt/g5Ynmdja9SX6KT/uWaksHu6Rg3OnAGQz9lTN+Gpgqux7vUuLZ
QT62b6+gjo1gpHkpK5K8ZnHxHPhqUXh8uaeEtNlmPuFx8OBMTOH7ZAdf0cOFQ3aB
WXFCqpFCAPvZHQ9GE9ips6Y5NYWyZtnltykvVvRMc/3xWDavAVIETh3XiuLaz7zp
S4eL+vpN0NZtBtjhRF5F
=KDNj
-----END PGP SIGNATURE-----

--w55KcsImixVjn7Xr0nHlhRtIAGAFHASNN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
