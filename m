From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densities
 exceeding the page size
Date: Tue, 09 Jun 2015 10:03:14 -0400
Message-ID: <1433858594.90034.14.camel@redhat.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
	 <1433854392-6531-3-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-CG/SVYMS5VCf4C8WMm29"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433854392-6531-3-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-CG/SVYMS5VCf4C8WMm29
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-09 at 18:23 +0530, Hariprasad Shenai wrote:
> Handle this configuration:
>=20
>         Queues Per Page * SGE BAR2 Queue Register Area Size > Page Size
>=20
> Use cxgb4_bar2_sge_qregs() to obtain the proper location within the
> bar2 region for a given qid.
>=20
> Rework the DB and GTS write functions to make use of this bar2 info.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cq.c       | 22 ++++++------
>  drivers/infiniband/hw/cxgb4/device.c   | 16 +++------
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  5 +--
>  drivers/infiniband/hw/cxgb4/qp.c       | 64 ++++++++++++++++++++++------=
------
>  drivers/infiniband/hw/cxgb4/t4.h       | 60 ++++++++++++++++++++--------=
---
>  5 files changed, 98 insertions(+), 69 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxg=
b4/cq.c
> index 68ddb37..8e5bbcb 100644
> --- a/drivers/infiniband/hw/cxgb4/cq.c
> +++ b/drivers/infiniband/hw/cxgb4/cq.c
> @@ -156,19 +156,17 @@ static int create_cq(struct c4iw_rdev *rdev, struct=
 t4_cq *cq,
>  		goto err4;
> =20
>  	cq->gen =3D 1;
> +	cq->gts =3D rdev->lldi.gts_reg;
>  	cq->rdev =3D rdev;
> -	if (user) {
> -		u32 off =3D (cq->cqid << rdev->cqshift) & PAGE_MASK;
> =20
> -		cq->ugts =3D (u64)rdev->bar2_pa + off;
> -	} else if (is_t4(rdev->lldi.adapter_type)) {
> -		cq->gts =3D rdev->lldi.gts_reg;
> -		cq->qid_mask =3D -1U;
> -	} else {
> -		u32 off =3D ((cq->cqid << rdev->cqshift) & PAGE_MASK) + 12;
> -
> -		cq->gts =3D rdev->bar2_kva + off;
> -		cq->qid_mask =3D rdev->qpmask;
> +	cq->bar2_va =3D c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRESS,
> +				      &cq->bar2_qid,
> +				      user ? &cq->bar2_pa : NULL);
> +	if (user && !cq->bar2_va) {
> +		pr_warn(MOD "%s: cqid %u not in BAR2 range.\n",
> +			pci_name(rdev->lldi.pdev), cq->cqid);
> +		ret =3D -EINVAL;
> +		goto err4;
>  	}
>  	return 0;
>  err4:
> @@ -971,7 +969,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,=
 int entries,
>  		insert_mmap(ucontext, mm);
> =20
>  		mm2->key =3D uresp.gts_key;
> -		mm2->addr =3D chp->cq.ugts;
> +		mm2->addr =3D (u64)(uintptr_t)chp->cq.bar2_pa;

Why are you using a cast here at all?  bar2_pa is already u64...


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-CG/SVYMS5VCf4C8WMm29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVdvIiAAoJELgmozMOVy/dkJMP/jvGFIge4MjGcX4UaK9tr4Kx
4QHfo2GPniAKES+UK2cjKSSzjw+nR56rchFO7g0RUuH1Rp8igIDV9rdeRt/kLqx6
fIKpcr0u6YfxsOiliMVgefqiE+RbJyNQ8vkP9vi3JwVZuX/S1t+j0ORox6ArAxK2
GuVZ5FgisUwB67euOybzvy5V2o/ccClwljpJucrNcaZBYWbImCT150YbYghVrqAp
2tQhG7D6ivh6o318KOyByj28/xGv2Tzt22C5Wy2ewrdq0S1++pqE9dtgbRHjHmSP
hX7mu2/NZ1n0OcktyaVeN8iIvAgtTLslledZ44DG6ndh1EFj4R3pSuSlPk/MsPF5
RI4cLN0fgvCXf0Ee14NDRzBnd/QASasOK9zevsJ5OsSVt2WbUbe8yzYB6xJBMvtT
X2P3vCUG/7OsoKRxsrf+xYD+LTA5IA9JJ71Xl6SIg+4E0sYrcNWF8mk4bMF7ZQlL
QZth5VC6qtNwWA2GssdNtIptjThnbcW/SqoHcx5C5c5ApNFT/u8d3PC1asvDmcqg
CC1vbwqKH4XrBPP3xdgEn5o++ExqeAOcReRo1bG/h5zrSHENy0c0DF96IrVtknZb
60PfRrvo3XBIFW9mrpOMS/Mhc7KspZW0vVYbrHWE12JFdOp/aS7z7rY6r3eZRuoH
iTvp9wO19um6//9dnBsS
=1VJQ
-----END PGP SIGNATURE-----

--=-CG/SVYMS5VCf4C8WMm29--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
