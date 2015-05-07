From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: use wildcard mapping for getting remote addr
 info
Date: Thu, 07 May 2015 11:20:20 -0400
Message-ID: <1431012020.2407.389.camel@redhat.com>
References: <20150507145224.28735.97977.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Jud8w3p34OqsdAghyabK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150507145224.28735.97977.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Jud8w3p34OqsdAghyabK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-07 at 09:52 -0500, Steve Wise wrote:
> For listening endpoints bound to the wildcard address, we need to pass
> the wildcard address mapping to iwpm_get_remote_info() instead of the
> mapped address of the new child connection.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxg=
b4/cm.c
> index bb95a6c..3ad8dc7 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -583,18 +583,18 @@ static void c4iw_record_pm_msg(struct c4iw_ep *ep,
>  		sizeof(ep->com.mapped_remote_addr));
>  }
> =20
> -static int get_remote_addr(struct c4iw_ep *ep)
> +static int get_remote_addr(struct c4iw_ep *parent_ep, struct c4iw_ep *ch=
ild_ep)
>  {
>  	int ret;
> =20
> -	print_addr(&ep->com, __func__, "get_remote_addr");
> +	print_addr(&parent_ep->com, __func__, "get_remote_addr parent_ep ");
> +	print_addr(&child_ep->com, __func__, "get_remote_addr child_ep ");
> =20
> -	ret =3D iwpm_get_remote_info(&ep->com.mapped_local_addr,
> -				   &ep->com.mapped_remote_addr,
> -				   &ep->com.remote_addr, RDMA_NL_C4IW);
> +	ret =3D iwpm_get_remote_info(&parent_ep->com.mapped_local_addr,
> +				   &child_ep->com.mapped_remote_addr,
> +				   &child_ep->com.remote_addr, RDMA_NL_C4IW);
>  	if (ret)
> -		pr_info(MOD "Unable to find remote peer addr info - err %d\n",
> -			ret);
> +		PDBG("Unable to find remote peer addr info - err %d\n", ret);
> =20
>  	return ret;
>  }
> @@ -2420,7 +2420,7 @@ static int pass_accept_req(struct c4iw_dev *dev, st=
ruct sk_buff *skb)
>  	}
>  	memcpy(&child_ep->com.remote_addr, &child_ep->com.mapped_remote_addr,
>  	       sizeof(child_ep->com.remote_addr));
> -	get_remote_addr(child_ep);
> +	get_remote_addr(parent_ep, child_ep);
> =20
>  	c4iw_get_ep(&parent_ep->com);
>  	child_ep->parent_ep =3D parent_ep;
>=20

Seems sane.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-Jud8w3p34OqsdAghyabK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVS4K0AAoJELgmozMOVy/dEJUP/jjR/Im7C3S6Hhus4lbTycmO
LrRWkUGry/PtCH9eCIRsFNON+HrAq8/pJYTHV28eMdSII3r4VBWGue/UBbwtDXU6
XRNwzPwVrxbO725gdPz9VCTgMpkmI43YDkzlk5t7gzqz3WE6Umwf6NVtGX2EHuwV
RXSBYQakeyptH9TK53Gbmd34bpq/DiILW7cqhxRVSaM3ZMh7cqGJXIi+8eLiBqST
ay2NGqngt3XuzOEEsIs2jj4TG/mAHG9jxLBsoS/8RD3416Yyrx9HEmlVMecSBuFy
aqbO7XOCDD9qzxq45D6NEParjlTLCLD9hXlryCwTUIu1ez+TXhpKDtQF/kUUruiB
kfPpJu8GMaX1dfO4X5rV9kAm3z8Y1wZ421Kvnpd3S4y8JFLt6UQJ3fi3k75Ef4T7
EiTvWSE4CTml/V+QwnPq07Jj0X3jYFMwgtzHpICbQwtvELv7BXmyLHzJ94l7tg9P
xuNp9d87fV//hjYWgw+rzxrWVUAog1VfmbS1Y4tzJG3eog+jl7uejX66fw0PLoPf
pyn4/8dVbOUG7CX4MbpQnDOjvV/RAaM5OvDD6UmepWmMdZC2YhG1WzmppmqJ238f
095Q4v1WvBbnK82Z+UGP1/XctYeBcV+5HDrUtUf4eEUK24WrJaLrSWIx0MpIVuaI
Sh6E7Ix+REsxfPV1sT6v
=adLD
-----END PGP SIGNATURE-----

--=-Jud8w3p34OqsdAghyabK--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
