From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] IB/rxe: remove redudant parameter in
 rxe_av_fill_ip_info
Date: Wed, 31 Jan 2018 14:35:06 +0200
Message-ID: <20180131123506.GU2055@mtr-leonro.local>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
 <1517396819-29597-7-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YolNsh7G+K7zsfIR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517396819-29597-7-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YolNsh7G+K7zsfIR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 06:06:59AM -0500, Zhu Yanjun wrote:
> In the function rxe_av_fill_ip_info, the parameter rxe is not used.
> So it is removed.
>
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c    | 3 +--
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 3 +--
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
>  4 files changed, 5 insertions(+), 7 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--YolNsh7G+K7zsfIR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxt/oACgkQ5GN7iDZy
WKdC+g//Z95To6gJ9Hb9rFDiu+tgCYUoWteW9My0vI4i4QHYg8yyE31suvEfjH8J
YfxB/+vi7FnqFRbSjOiAZ7VW3XGOBjNWCyFcqji8rsa8+YLbQssTqI2alMQPIqqo
sxPXfZ6BFO/vVrpm/cOri9LALeY8sWsRbk/graO8WvO3b6t3cXnEPcJf+u69QbWo
T8sZ/w1R1bsHYrg0razIyMjwEkOnWCj8nDvMA+ENxquPU1vSHBKrxJdnLPPrNfiD
6abVFoYmrjjsxe867grAEjLVgdQhZBi8lyEKmDhn7kFHg5mwd0rt6UcGQZzpER5e
oc4u0oeJiT0S1leeefucl9rt2TJ1gpdA/ZU7M6w+eb1XFKMwCrBs96phoRZGrqpC
S/ksBOquGEJBs9Rl4JyG3ooHj3OdOKndnvxss4ILCqVKYmKK2atP4bNYr/yvSaWw
aQgO3VU/fHsi4WjzB6Wzvu5ioMgHKfU/HutHnZIB5z4x5OmmRRcvm5pKO84hHVfd
yhUe3eLoGqEDngww/mSk8vGtDf+p3rypYNT1NbhkOJc3hs/9GxLQkRCQzhHfRej3
X/UU64BqKuL38XtooiALaf3RsL93KcpxAHF4UfhsXb60heDnsIM4Jw9F4wYhxE0P
D5uQnFeKAXPX9Opr+lBuevzYh6X6WZN/AtJVUC1/Ui/cS6fYHKg=
=x1Cl
-----END PGP SIGNATURE-----

--YolNsh7G+K7zsfIR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
