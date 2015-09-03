From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Add PSM2 user space header to header_install
Date: Thu, 3 Sep 2015 15:31:38 -0400
Message-ID: <55E8A01A.8060504@redhat.com>
References: <1441233981-32071-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ns681t2SHMFw5JoudhnbGwh33JXP0qbAb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441233981-32071-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ns681t2SHMFw5JoudhnbGwh33JXP0qbAb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/02/2015 06:46 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> When the hfi1 driver was added a user space header file (hfi1_user.h) w=
as added
> to be shared between PSM2 and the driver.  However, the file was not ad=
ded to
> the header install.  Add it now.
>=20
> Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")=

> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/uapi/rdma/Kbuild     | 1 +
>  include/uapi/rdma/hfi/Kbuild | 2 ++
>  2 files changed, 3 insertions(+)
>  create mode 100644 include/uapi/rdma/hfi/Kbuild
>=20
> diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
> index 687ae332200f..231901b08f6c 100644
> --- a/include/uapi/rdma/Kbuild
> +++ b/include/uapi/rdma/Kbuild
> @@ -5,3 +5,4 @@ header-y +=3D ib_user_sa.h
>  header-y +=3D ib_user_verbs.h
>  header-y +=3D rdma_netlink.h
>  header-y +=3D rdma_user_cm.h
> +header-y +=3D hfi/
> diff --git a/include/uapi/rdma/hfi/Kbuild b/include/uapi/rdma/hfi/Kbuil=
d
> new file mode 100644
> index 000000000000..ef23c294fc71
> --- /dev/null
> +++ b/include/uapi/rdma/hfi/Kbuild
> @@ -0,0 +1,2 @@
> +# UAPI Header export list
> +header-y +=3D hfi1_user.h
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ns681t2SHMFw5JoudhnbGwh33JXP0qbAb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6KAaAAoJELgmozMOVy/dmPYP/30ZhWaaRcrpZm9m2adSlm2g
f7ZNxyskf6zdVrsa0gpAlhMiGqU2jot/KXu+VBb5oTM36UV9fvkwTw5XwO4+QSMq
YFDEOntmrmNJu+2aDf5gB8HA1+i0hwtaTZmXWM4iIXJXO627HlEZGSd+XKmx1Dqm
81VBkNKn+6jOtCTuV6OTfuZjloHWlSJr1jjL7Q8ROg31Mpyc6OiCM4rHB6mAWgi+
5c4pY2wqE0QlrDfdjtaL2TtbgF//F4MIFRyTIHiYPMNYMTV/hovIma9F3vYsQzIv
2hoyMXAr67XitQhOCVtCXda9fgEzWz4LzuEnCQPFH05O+MBmxAlqaW26riBngVRw
gSjzIWuuD/mk6rsLrKCNsGMGPMLGugdlN3aSEsNH9tbnAtKnMBBREy6h4QO7Ldck
w5/Pi6e6ITVmx/rOJgG3ptPboLQTSj8V5191rdZfGTXL9eJ+S5N5UDfg6wOR02xh
kO2xyYNdMr2x9QHtAxkl2MEoHyVSmh/c76eD9nWShp/Jl0Q0W9tkXTqLGaf79Yd7
07Utr5vrrDb4so/TRYZhoNFNbhzis23xaoxSRMBVCUc4ibgSz82c3mhoKMqDA1NT
X0fcBhb3jEwkgKDUrDnDlt/ftLPsGNTabZLbPp2z8YU5NlK2BetKRESAY7bPApuW
kbV/d+2ITT/8nljlO/W1
=Vwnw
-----END PGP SIGNATURE-----

--ns681t2SHMFw5JoudhnbGwh33JXP0qbAb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
