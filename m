From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 15/20] IB/hfi1: Permanently enable P_Key checking in HFI
Date: Sat, 15 Apr 2017 17:53:17 +0300
Message-ID: <20170415145317.GM1343@mtr-leonro.local>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171658.10579.67996.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="37cJpJlYZwAfNbm5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170409171658.10579.67996.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--37cJpJlYZwAfNbm5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 09, 2017 at 10:16:59AM -0700, Dennis Dalessandro wrote:
> From: Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Ingress and egress port P_Key checking should always be performed for
> HFIs. This patch will enable ingress and egress P_Key checking when
> the port is initialized and will ignore the P_Key information sent by
> the FM in the port info structure which is meant to be used only by the
> switch.
>
> Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/init.c |    3 +++
>  drivers/infiniband/hw/hfi1/mad.c  |   10 ----------
>  2 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hf=
i1/init.c
> index 55a11a6..838d3a8 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -482,6 +482,9 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct=
 hfi1_pportdata *ppd,
>  	default_pkey_idx =3D 1;
>
>  	ppd->pkeys[default_pkey_idx] =3D DEFAULT_P_KEY;
> +	ppd->part_enforce |=3D HFI1_PART_ENFORCE_IN;
> +	ppd->part_enforce |=3D HFI1_PART_ENFORCE_OUT;
> +

Isn't better just remove these enforcement checks if it always should be pe=
rformed?

=E2=9E=9C  linux-rdma git:(rdma-next) git grep part_enforce drivers/infinib=
and/
drivers/infiniband/hw/hfi1/hfi.h:       u8 part_enforce; /* partition enfor=
cement flags */
drivers/infiniband/hw/hfi1/hfi.h:       if (!(ppd->part_enforce & HFI1_PART=
_ENFORCE_IN))
drivers/infiniband/hw/hfi1/hfi.h:       if (!(ppd->part_enforce & HFI1_PART=
_ENFORCE_IN))
drivers/infiniband/hw/hfi1/mad.c:       if (ppd->part_enforce & HFI1_PART_E=
NFORCE_IN)
drivers/infiniband/hw/hfi1/mad.c:       if (ppd->part_enforce & HFI1_PART_E=
NFORCE_OUT)
drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce |=3D HFI1=
_PART_ENFORCE_IN;
drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce &=3D ~HFI=
1_PART_ENFORCE_IN;
drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce |=3D HFI1=
_PART_ENFORCE_OUT;
drivers/infiniband/hw/hfi1/mad.c:               ppd->part_enforce &=3D ~HFI=
1_PART_ENFORCE_OUT;
drivers/infiniband/hw/hfi1/verbs.c:     if (!(ppd->part_enforce & HFI1_PART=
_ENFORCE_OUT))

Thanks

>  	if (loopback) {
>  		hfi1_early_err(&pdev->dev,
>  			       "Faking data partition 0x8001 in idx %u\n",
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi=
1/mad.c
> index db5494d..7059a0f 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -1151,16 +1151,6 @@ static int __subn_set_opa_portinfo(struct opa_smp =
*smp, u32 am, u8 *data,
>  		ppd->linkinit_reason =3D
>  			(pi->partenforce_filterraw &
>  			 OPA_PI_MASK_LINKINIT_REASON);
> -	/* enable/disable SW pkey checking as per FM control */
> -	if (pi->partenforce_filterraw & OPA_PI_MASK_PARTITION_ENFORCE_IN)
> -		ppd->part_enforce |=3D HFI1_PART_ENFORCE_IN;
> -	else
> -		ppd->part_enforce &=3D ~HFI1_PART_ENFORCE_IN;
> -
> -	if (pi->partenforce_filterraw & OPA_PI_MASK_PARTITION_ENFORCE_OUT)
> -		ppd->part_enforce |=3D HFI1_PART_ENFORCE_OUT;
> -	else
> -		ppd->part_enforce &=3D ~HFI1_PART_ENFORCE_OUT;
>
>  	/* Must be a valid unicast LID address. */
>  	if ((smlid =3D=3D 0 && ls_old > IB_PORT_INIT) ||
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--37cJpJlYZwAfNbm5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljyM90ACgkQ5GN7iDZy
WKf7ZA//dQW79kcoAz1U2LpGtM1KuEM8rB+ElrIGYfg/ADrnKl+CHhqcRwfaDzHK
5/zFwLv9Ud/yJ54zMzhRdzvUGh0GNYj0+UNAuSsOVYJ+jVEWWeKTN+HpGoTs6z5B
2lRzVxalqrTyucWXfZ+ZSCZRGgO7NbgLcKXcR8o5t96S2YewrcY1jwJut02HtshQ
hylBnnlUDyyid5Q2efJzVC3ZN1nyoRFCxIwzRqfgJ3oPbFWaYTrsaMK1LojiQ7ic
0/bTsg/FXIkkWv+asl+kLLVXxCdNi5YJyGOEIVN82l/juMHGcqBImUIFkJslZH3j
GVZpdDJufvjlIgUg5tpgJsz2KcP//t+TWII79SrX3LqrripBavpcvKg8EkU3dgcV
miVUpJRGWzS2bXdbopreU2FxtAdhu4EO7T2hnR1j/AyBWu8B+qy4CUGz+1+otHvm
U+jSEOUAvJOiFyh119rB9kJcHiZrz/3cwIDB1au1iDs0iY+5sSn49flj3dHfw8Nw
PpKw/XzkIUucMZMLt8fDJqaeLfS7awwC0XOJrP51XOeHHYfwUmhE7A9Mwk1/Gi3y
HmwFNPdqQnMmNcUQax1ClAa/Id01zlLVpN5EKnlcxJL56oGoMLcI8/L62juV3akI
O+4nRYIaiv2RxiM0qRAR4ZzaDe1QaTPoYC23s5HZSVCNdfXAI58=
=TA0P
-----END PGP SIGNATURE-----

--37cJpJlYZwAfNbm5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
