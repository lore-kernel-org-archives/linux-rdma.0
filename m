From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-core] librdmacm: Make return value from ucma_init consist
Date: Wed, 8 Nov 2017 16:49:49 +0200
Message-ID: <20171108144949.GU18825@mtr-leonro.local>
References: <20171107084321.6396-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Vr2UxLU0KdcKBaxP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107084321.6396-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Vr2UxLU0KdcKBaxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 07, 2017 at 10:43:21AM +0200, Yuval Shaia wrote:
> When check_abi_version fails we must be consist with rest of exit flows
> of the function and return -1 and set errno with the actual error code.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  librdmacm/cma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks, applied.

--Vr2UxLU0KdcKBaxP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloDGY0ACgkQ5GN7iDZy
WKdsmA//eekBoXTpDEHEtrbXrZ63PlHOwLXfyI3FK+/k52qV4Ory0nVAW1GxluSC
/RlcQqxegcnX66uOTvArk3G6mX+xeWVk2lap0Q+qMxyG1j2K4gGWrpzO0cYMla6U
vtpuV+rXI6/Mm8UDaAqaZXzydQLWOxZnhR+dRIxNoorPdxgOa2rzKl5g7t7JsWNx
g7tJXIegP+x+GnW7q0+zsIcMGm6WuMqlwyVtUaCl4ZYoieCvKNbKUvfn+jmLU/pk
qPtKwVACb4mjn9Pauruk+qFCbDNpt80q0mGyR7+HAJM4wgN2kQhhr6GqZpDV8+V6
yfPnrRaKf2xRPdhCHsKD9WuDIwaJqezsV1uUTXsPNpgijOJ0zrvSy+zHHwZqXjGq
JaqLi4IcdzuDTLW9TofRzUnoAJ8ZfPKTxb5f1oLxqHKmenkKaWasV4YnuFA8fawV
F4OM/DPkN1jMeh2qg3DZ9xw1Hh9145kTMRetRGYI3EKVxHM3Eoinv4d2H9rLAHUC
+yufttAeNt1kB/aaOPl+s8OcBLzlnG0/fX9dn43R93ZTDIbb099sswEDuqF3V+6p
SNLVx+9m4uZM1j1T1nzlE7E9wbhaay8TvyP5DKvt1eHyKKZ/pvfpw8SbEI1ONx3i
089jPGsk0D6qcXz0zmpn5PFAwx8SepZbgdrSV/84GKiibvM57Lw=
=adFE
-----END PGP SIGNATURE-----

--Vr2UxLU0KdcKBaxP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
