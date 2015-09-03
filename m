From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/core: Remove unnecessary defines from ib_mad.h
Date: Thu, 3 Sep 2015 15:51:47 -0400
Message-ID: <55E8A4D3.9020501@redhat.com>
References: <1441233955-31743-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g9U5s0wW1CKW5XPfONSj5XP2HP0s6SALF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441233955-31743-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g9U5s0wW1CKW5XPfONSj5XP2HP0s6SALF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/02/2015 06:45 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Remove the unused IB_NOTICE_REPRESS_* defines.
>=20
> When the hfi1 driver was added these definitions were moved from the qi=
b driver
> to ib_mad.h.  They should have been removed instead.
>=20
> Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")=

> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/rdma/ib_mad.h | 12 ------------
>  1 file changed, 12 deletions(-)
>=20
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index c206205bbf98..7f2cf855a0b6 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -157,18 +157,6 @@
>  #define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
> =20
>  /*
> - * Repress trap/notice flags
> - */
> -#define IB_NOTICE_REPRESS_LLI_THRESH	(1 << 0)
> -#define IB_NOTICE_REPRESS_EBO_THRESH	(1 << 1)
> -#define IB_NOTICE_REPRESS_FLOW_UPDATE	(1 << 2)
> -#define IB_NOTICE_REPRESS_CAP_MASK_CHG	(1 << 3)
> -#define IB_NOTICE_REPRESS_SYS_GUID_CHG	(1 << 4)
> -#define IB_NOTICE_REPRESS_BAD_MKEY	(1 << 5)
> -#define IB_NOTICE_REPRESS_BAD_PKEY	(1 << 6)
> -#define IB_NOTICE_REPRESS_BAD_QKEY	(1 << 7)
> -
> -/*
>   * Generic trap/notice other local changes flags (trap 144).
>   */
>  #define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--g9U5s0wW1CKW5XPfONSj5XP2HP0s6SALF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6KTTAAoJELgmozMOVy/dw4EQAK/obfEmiCHy2qN+S2KYrNMZ
GHoJsx6jqQYSHvC6IOLyf8aYcVzykxrDNGRzIpXa7gz4Y6uQCC5OnLryaft6I2yk
OfNX3DOrtMS/1AcjYraWRcMGSlaHqYt/UVjU5CyWGaYMeck/CsChT0Fo5EtZ4IHY
fi+6Je9PVrZ/WEAaaxqEBWH4lzR8UZdq7L1dDo2mlCjsJ9yNc2bPI3w2J+OKPmUV
PWzK/O1eAKsuCfGkeibiNCPbklirCbXQJVYKFIXULQi7sziw5N41JOFqZUrPqie/
7IgYOegTCPlcGIbGwBfSGWJE0+cgrHHe7ZKzSvP1A7LTnFUHbEnVVsbKjVp823V+
4exsqJn/P2+eOWJD30MNCDfm11hude+/coYMTaAHHhUbNaOtGsOzSXEx5EQLDCCu
OZu2ZjHIDd9SE2SD549ALR7dwo0Jg90SJ/JdYYSS0KoRftqbssCef3b/CH3PAems
gLeS0M1t4+jGyLs99tkj477shXKd3XQduWx5371p1upOiyjQb5RDmAhsHO3d8Hgf
9PDaQvkVaUMvAqvZLLfcWO54MMlek06E+CCVTQapLtDZAW/BSmwb7Qw/JO5Ly2vT
5wLQTVdActsIvarSNR3uTxNhkthi2rsN4I/jMJIJqmKdjXKOG90lzpVK+P4OBweP
e7kySdDgtwGV2CXeELg5
=VLPP
-----END PGP SIGNATURE-----

--g9U5s0wW1CKW5XPfONSj5XP2HP0s6SALF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
