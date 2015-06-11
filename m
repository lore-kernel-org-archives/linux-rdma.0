From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: fix double free on pd
Date: Thu, 11 Jun 2015 01:15:30 -0400
Message-ID: <1433999730.71666.149.camel@redhat.com>
References: <1433515647-28059-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-NdysXpOQQjXQrldXWQ6w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433515647-28059-1-git-send-email-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-NdysXpOQQjXQrldXWQ6w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-06-05 at 15:47 +0100, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>=20
> A reorganisation of the PD allocation and deallocation in commit
> 9ba1377daa ("RDMA/ocrdma: Move PD resource management to driver.")
> introduced a double free on pd, as detected by static analysis by
> smatch:
>=20
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:682 ocrdma_alloc_pd()
>   error: double free of 'pd'^
>=20
> The original call to ocrdma_mbx_dealloc_pd() (which does not kfree
> pd) was replaced with a call to _ocrdma_dealloc_pd() (which does
> kfree pd).  The kfree following this call causes the double free,
> so just remove it to fix the problem.
>=20
> Fixes: 9ba1377daa ("RDMA/ocrdma: Move PD resource management to driver.")
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index 9dcb660..219f212 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -679,7 +679,6 @@ err:
>  		ocrdma_release_ucontext_pd(uctx);
>  	} else {
>  		status =3D _ocrdma_dealloc_pd(dev, pd);
> -		kfree(pd);
>  	}
>  exit:
>  	return ERR_PTR(status);

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-NdysXpOQQjXQrldXWQ6w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeRlyAAoJELgmozMOVy/d6RsP/i1Dxzx+BJJSC8/x+lN8MHjE
/bhV2zsFeHjvsklLpVoqhuppyZQVZEqF8hPp2GSU/x0t4YubPmlmm7LxJiLjf6J2
FeqxVHm2kHvWLE2RY+mnbkIdTx2rZivUnFbwfpuya0WltSEPbRmLzoqGe50nvHtR
3rODYlSdweL5Uocpw9ew0VCIfmG020ZENKaAv0VEzDLeO+r5s6WrTGj2fTJPDEn7
nlPYg4M4CxmL9HT4NYiiJuEY+1azW2gZ6ItWH8bONMMWGPSGwAMoetLOLa1PmL6f
vs2Flp/LqLpZRseYLBk2ldLf/5JqAzv1aqjfxp6Z7oYQXns19OgwebPR12GFH5fg
yLpXCzT+mJMOpXsEp9ZaKTvQ2m4opv55aT+P8ue4o9Dk+E+l6eXODy5/rrPy7Qn0
PBasp2gKQzG1IxVf6yjD0BM0XPtlXNV/9ZBM2/ALyRGf613xtzTYmMZ2e41E91AA
zXlrManxjKcUoV0nwSH8t+e92p1ZplMo4iiaKRLnD+yy13+Wlo9JkGEqQ9Nu8I0k
r4aT+19RguWvTPpNml4hOpXHKwMOtdMtfUMvNe8An05dWJeIUL9qpizF7O7YpUdw
xp/ArE4rcurppB8xAwMQ6I5VdCNYNYk/qcwA3F8sdeEqG10H/D81LrSdpl8UDcR7
Ccz3Tklu8vy+wx/7jt/f
=nuDu
-----END PGP SIGNATURE-----

--=-NdysXpOQQjXQrldXWQ6w--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
