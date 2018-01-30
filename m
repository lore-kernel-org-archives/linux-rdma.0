From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/rxe: remove redudant parameter in function
Date: Tue, 30 Jan 2018 09:27:22 +0200
Message-ID: <20180130072722.GC2055@mtr-leonro.local>
References: <1517296074-14459-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517296074-14459-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2018 at 02:07:54AM -0500, Zhu Yanjun wrote:
> In the function rxe_av_from_attr, the parameter rxe
> is not used. So it is removed.
>
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c    | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 5 ++---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
>  4 files changed, 7 insertions(+), 8 deletions(-)

Thanks, while you are doing that, can you please change the function
signature to be void? And do the same trick for rxe_av_fill_ip_info(),
it doesn't use rxe too.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpwHloACgkQ5GN7iDZy
WKfhig/+Klt8eB4cqmWkLpj7FHsjMJj2z1cpGbzKBvlFRtjZP2jWF0e1z96Bsel5
Bv9HIwVh9gcJRslTDRQJyLcs1jy7G2rFZ+10Zo2UrejjicnaMkQ90p2vb0vUEQVi
3Q/y9deFcY0kiG7P37qcLjVtqBTIIAEefHh9vLM5ErvJxxaDRZOrbSF0bc6bfkWA
y30AKfdEwu5eoR7tFODLZMAuXH0LcMdVc3rI7tr6YD6Aiz9HJpLOOCLvVu4TCsTp
D+LKzM83GB9KUsGtBO6WnWPbmKUcXlxxjUFFAhx1+MSBjO10qusld37kzL4/2LiE
xwuDuXc3CWosy6uQ8N2IgjgMMKDnR5By5j5GskPWppqKG/AmWcFq1UZocv5S4okh
w9XqLSA4CnN7kD9arhchR/UMFo/mFdjKhZcPS8e5lh1An1iXkS5zPWLuuNEuXCUL
JvB+BTxxBLWOeiBjMV5eu252RdwLpibsQwWv8k/EJKj4qmwEw7WjWeFpTfy1Yyl/
3HoJW3YXCKI/yt9cnVTO2KAU/XlMa/WkIfnMXgyUTzhk6cy/PRjFOko3WxMayhu6
EFLT+7xJeOrH4KdrJyB295fZgmZqZ8ApoTpHUtNoG5jOSHRWALw/CWLW2Jei7EWE
4mWTa1MIG+uaPm/1HT8OBMxWwJiWYkaKkU3bzci/dlDQqeYqrGg=
=ngkV
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
