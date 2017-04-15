From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 05/18] IB/rxe: Initialize ib_ah_attr during
 query_ah
Date: Sat, 15 Apr 2017 17:34:30 +0300
Message-ID: <20170415143430.GL1343@mtr-leonro.local>
References: <1492212538-32459-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492212538-32459-6-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KaGhPsiNaI6/sRd6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492212538-32459-6-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--KaGhPsiNaI6/sRd6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 14, 2017 at 07:28:45PM -0400, Dasaratharaman Chandramouli wrote:
> Zero out ib_ah_attr before calling query_ah. Set ah_flags
> appropriately.
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c    | 1 +
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 1 +
>  2 files changed, 2 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--KaGhPsiNaI6/sRd6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljyL3YACgkQ5GN7iDZy
WKcFdw//Z83NYdIeVn6Dtn/V2J1LB0W7PUA9Hq1eK7YjzHHvXsvZYNWpr36T7Lww
RVzaIkzR9kv42wAoeV6127vv6dpKNUDQ0YXM2di6lxV/m3Q4VkpMwNiKs+tkUmFI
q6bPcaY6+d6PXAfADYSVPAYT0eKUNzeZBTwCKXADcj0wYDwpVPgYFIKVOqSK+wRe
Yz3PXm6mCtFzZ2xfj6GPIyBCEKtuBgjb+mX8blQEOMn7tj14YEnKMfNn8GWKvgCv
thj5OYtPwhzmzlwNFKBCxjchmzaJSUo1DDuJ3rk0hZUu+6oBVuFBd7fvelKelUo8
2pYY1Ujf1H8ln96mIVlvCXaX1hhYCrT8/mv1TrS40E3OR1qmXnB9Q7N08h8lwpv9
EvuhWVUUwYQm/QJK5JPNtewSRib0jM/lPNFJYdIVi8n+7c+CecunaOsdEpo2FTE1
4hGP/QZzL+/62eYWg8TOp5HqtYmYKJej98b4mICL6onKSU97sWqbxSeG3P57yXDl
DgbfYjt5kRgcAouYjaRQ8ZuXjvf2EmDTVlS1pCkr0aPBT5MGfwhSUpfhOzuhAjJd
W72f8wm/2p1CedywrpuepQ6OyyXmDDpWcVmx2kooLilwODJMbJ/G9VRvBWGWfpM4
SS+9pukdnAzo/Sz5MFBLshNm5DlCFhUCGf3dFNH2bv6AJMSlj2Y=
=JKU9
-----END PGP SIGNATURE-----

--KaGhPsiNaI6/sRd6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
