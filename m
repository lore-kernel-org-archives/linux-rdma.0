From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning failures
 in the resource destroy path
Date: Fri, 15 May 2015 11:56:12 -0400
Message-ID: <1431705372.29187.6.camel@redhat.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
	 <1431762709-20740-11-git-send-email-selvin.xavier@avagotech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FOL4JbZsd/iVPlXpEBfa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-11-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-FOL4JbZsd/iVPlXpEBfa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2015-05-16 at 13:21 +0530, Selvin Xavier wrote:
> Avoid returning FW failures in the resource destroy verbs.

This patch looks extremely unsafe to someone that doesn't have the
benefit of being able to look at your firmware code.  What firmware
errors are you ignoring?  What state is the card in whenever these
errors are returned?  Is there even a remote possibility that the
firmware being in this state and returning these errors will either A)
cause erroneous attempts to write to user memory or B) interfere with
future attempts to create PDs or other contexts on the card?

> Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index 48ec56f..b1f9d7d 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -531,13 +531,12 @@ map_err:
> =20
>  int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
>  {
> -	int status =3D 0;
>  	struct ocrdma_mm *mm, *tmp;
>  	struct ocrdma_ucontext *uctx =3D get_ocrdma_ucontext(ibctx);
>  	struct ocrdma_dev *dev =3D get_ocrdma_dev(ibctx->device);
>  	struct pci_dev *pdev =3D dev->nic_info.pdev;
> =20
> -	status =3D ocrdma_dealloc_ucontext_pd(uctx);
> +	(void)ocrdma_dealloc_ucontext_pd(uctx);
> =20
>  	ocrdma_del_mmap(uctx, uctx->ah_tbl.pa, uctx->ah_tbl.len);
>  	dma_free_coherent(&pdev->dev, uctx->ah_tbl.len, uctx->ah_tbl.va,
> @@ -548,7 +547,7 @@ int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx=
)
>  		kfree(mm);
>  	}
>  	kfree(uctx);
> -	return status;
> +	return 0;
>  }
> =20
>  int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
> @@ -690,7 +689,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
>  	struct ocrdma_pd *pd =3D get_ocrdma_pd(ibpd);
>  	struct ocrdma_dev *dev =3D get_ocrdma_dev(ibpd->device);
>  	struct ocrdma_ucontext *uctx =3D NULL;
> -	int status =3D 0;
>  	u64 usr_db;
> =20
>  	uctx =3D pd->uctx;
> @@ -704,11 +702,11 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
> =20
>  		if (is_ucontext_pd(uctx, pd)) {
>  			ocrdma_release_ucontext_pd(uctx);
> -			return status;
> +			return 0;
>  		}
>  	}
> -	status =3D _ocrdma_dealloc_pd(dev, pd);
> -	return status;
> +	(void)_ocrdma_dealloc_pd(dev, pd);
> +	return 0;
>  }
> =20
>  static int ocrdma_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_mr *m=
r,
> @@ -1905,13 +1903,12 @@ int ocrdma_query_srq(struct ib_srq *ibsrq, struct=
 ib_srq_attr *srq_attr)
> =20
>  int ocrdma_destroy_srq(struct ib_srq *ibsrq)
>  {
> -	int status;
>  	struct ocrdma_srq *srq;
>  	struct ocrdma_dev *dev =3D get_ocrdma_dev(ibsrq->device);
> =20
>  	srq =3D get_ocrdma_srq(ibsrq);
> =20
> -	status =3D ocrdma_mbx_destroy_srq(dev, srq);
> +	(void)ocrdma_mbx_destroy_srq(dev, srq);
> =20
>  	if (srq->pd->uctx)
>  		ocrdma_del_mmap(srq->pd->uctx, (u64) srq->rq.pa,
> @@ -1920,7 +1917,7 @@ int ocrdma_destroy_srq(struct ib_srq *ibsrq)
>  	kfree(srq->idx_bit_fields);
>  	kfree(srq->rqe_wr_id_tbl);
>  	kfree(srq);
> -	return status;
> +	return 0;
>  }
> =20
>  /* unprivileged verbs and their support functions. */


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-FOL4JbZsd/iVPlXpEBfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVVhccAAoJELgmozMOVy/ddi4P/jMA1dqjVXqPKw3QnVW1ntIV
n4PrYbtle9aDpy5riZAiTYPadRymg5sHao01/Fe+dxYKAZdZQvrM0hhQKWUBhG8k
7fIOrXQwwjJ7Gwt3+4euxCDPIFk/7VfFj/waN1ZFlFbrSHyMjnR5ON8v+6yPdbDS
6QxcKXwmBluplUUcx1hJ4UvMDk7eBBo27hg2amBBtw54AmfoFfga+LEACPMXEBF4
eT7FoQUJSHjMIyeG4pX+2bKQmT1epiEdIOFW2lFZj8paOjV4LoJkSzp3TfZkAtWi
j5wt+uMKPcF7sgjDObNYgF/NTeBil3qU/t3Z7xYbDeML5BXYzBiyoN7gQnepSj12
+XGf+nJo+S02T+r0p6kHiigdrSS9eZrQdPQSCUvY0vFKIXr56yAR1wbKwN1ZKwge
Q/2vgUUsBB/7packqO9Q30gGKSqCPVzjga115G0ojtEX3FwJCxgyiizDOwC6g3ye
xcDV8NdvXxR0hVO2TB5F+jI6G23skBTf0y4orPSgUQXmFiaTDwhkYk1cdP0zIio/
1yaniEiQ08MXGZbO2md9kQo98QhFLY8osAdq16LcIlucT2Qc/Ud/7IXHA1ZanzPt
s4nQKs0wYJ/5MS6FUtxKrxtzYSRM2fneB//gBmxmg0Dj8TQ2+UoGnqcfR6Zb5ROt
spN7Kii5mleqiXsgWzA1
=7Ntq
-----END PGP SIGNATURE-----

--=-FOL4JbZsd/iVPlXpEBfa--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
