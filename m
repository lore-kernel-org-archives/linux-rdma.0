From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/15] IB/hfi1: Adjust default eager_buffer_size to 8MB
Date: Thu, 4 May 2017 15:42:32 +0300
Message-ID: <20170504124232.GT22833@mtr-leonro.local>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
 <20170504121421.32747.27378.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Tu8ztk+XgTAiG9Id"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170504121421.32747.27378.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Tu8ztk+XgTAiG9Id
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 04, 2017 at 05:14:22AM -0700, Dennis Dalessandro wrote:
> From: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Performance analysis shows benefits for PSM2 in increasing eager buffer
> size from 2MB to 8MB. The change has neutral impact on verbs.
> Make change to the module parameter's default value. Allocation
> ring down was verified to work with the larger buffer size.
>
> Reviewed-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Impressive list :)


>  drivers/infiniband/hw/hfi1/init.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> index 71b0204..c573f06 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -102,9 +102,9 @@
>  module_param_named(rcvarr_split, hfi1_rcvarr_split, uint, S_IRUGO);
>  MODULE_PARM_DESC(rcvarr_split, "Percent of context's RcvArray entries used for Eager buffers");
>
> -static uint eager_buffer_size = (2 << 20); /* 2MB */
> +static uint eager_buffer_size = (8 << 20); /* 8MB */
>  module_param(eager_buffer_size, uint, S_IRUGO);
> -MODULE_PARM_DESC(eager_buffer_size, "Size of the eager buffers, default: 2MB");
> +MODULE_PARM_DESC(eager_buffer_size, "Size of the eager buffers, default: 8MB");
>
>  static uint rcvhdrcnt = 2048; /* 2x the max eager buffer count */
>  module_param_named(rcvhdrcnt, rcvhdrcnt, uint, S_IRUGO);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Tu8ztk+XgTAiG9Id
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkLIbgACgkQ5GN7iDZy
WKduMRAAyXD+bCnzlX67pQ4G6V6gaQnGrVDTKt8sxSG10JzEYDsodWP22UBzKTLs
9qAwtWxy5l74w2dBt2V7wS8Zow220TkG7FUgBt4z9bEzZkC4iEfhozuG5dXtfhjV
wOkDonqsf7tR0B4UWxTFBmQhT8lN53fNtuHmdDJ0i2cJ7efEPajhMzLT+UdpI6hc
o2Vs+8dkk2ZemJZjpkJGKd3l5rCFxPrR7R7lxlVGD7qr77fThiJK+fp2oM+RG+Fs
WKTdy1J1RViBpbbNafv41mlMnZ0jePdbhK2jImStbJfxKn35I3u6VqpAc/CE8+zc
tjKZbvqntw+8+HWRuknGD/KJipuT0xU924SxoONeh03BJ+HqbtYoDDrTgSg2A9OP
ZxFxk6FgIcJTKhEOWzhLu4mHxDsMra/mSg4SWh//Lm3yJN+kHHYvzuiTBUQn9C0O
mbr//Tx4l1fiiw9Naz4LYGMO7nLn1EK9smeuyVXe8aZ33VXoHYz27yfReJwlZ1Da
w2nPr0RkI0q649at/nnCGOimOOhCN8i928bicnou8radqdcStMWseKXHBNAs7lAK
myyF53jzPHF/S8eU4byx5V8dsFhMdA8eM9vhkaHgK5ryCG2I0/+NpXGME//lEDS1
fNlhLzy3+/b8ObHxAq5RGEQoRdtHUotXNFEJHXzUFKHFUIYwwbs=
=s+XS
-----END PGP SIGNATURE-----

--Tu8ztk+XgTAiG9Id--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
