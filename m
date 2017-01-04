From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/srp: fix invalid indirect_sg_entries parameter
 value
Date: Wed, 4 Jan 2017 15:09:38 +0000
Message-ID: <1483542561.3048.13.camel@sandisk.com>
References: <1483538377-19379-1-git-send-email-maxg@mellanox.com>
         <1483538377-19379-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483538377-19379-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <8491466410B8634A9FD4205CC0C0A2B4-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-01-04 at 15:59 +0200, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> After setting indirect_sg_entries module_param to huge value (e.g 500,000=
),
> srp_alloc_req_data() fails to allocate indirect descriptors for the reque=
st
> ring (kmalloc fails). This commit enforces the maximum value of indirect_=
sg_entries
> to be SG_MAX_SEGMENTS as signified in module param description.
>=20
> Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
> index 0f67cf9..79bf484 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3699,6 +3699,12 @@ static int __init srp_init_module(void)
>  		indirect_sg_entries =3D cmd_sg_entries;
>  	}
> =20
> +	if (indirect_sg_entries > SG_MAX_SEGMENTS) {
> +		pr_warn("Clamping indirect_sg_entries to %u\n",
> +			SG_MAX_SEGMENTS);
> +		indirect_sg_entries =3D SG_MAX_SEGMENTS;
> +	}
> +
>  	srp_remove_wq =3D create_workqueue("srp_remove");
>  	if (!srp_remove_wq) {
>  		ret =3D -ENOMEM;

Thanks!

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
