From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/multicast: Check ib_find_pkey() return value
Date: Tue, 22 Nov 2016 09:11:45 +0200
Message-ID: <20161122071145.GD23083@leon.nu>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
 <950a0611-4aad-9b85-8d18-3dff54db2820@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <950a0611-4aad-9b85-8d18-3dff54db2820-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2016 at 10:22:17AM -0800, Bart Van Assche wrote:
> This patch avoids that Coverity complains about not checking the
> ib_find_pkey() return value.
>
> Fixes: commit 547af76521b3 ("IB/multicast: Report errors on multicast groups if P_key changes")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/core/multicast.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
> index e51b739..322cb67 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -518,8 +518,11 @@ static void join_handler(int status, struct ib_sa_mcmember_rec *rec,
>  		process_join_error(group, status);
>  	else {
>  		int mgids_changed, is_mgid0;
> -		ib_find_pkey(group->port->dev->device, group->port->port_num,
> -			     be16_to_cpu(rec->pkey), &pkey_index);
> +
> +		if (ib_find_pkey(group->port->dev->device,
> +				 group->port->port_num, be16_to_cpu(rec->pkey),
> +				 &pkey_index))
> +			pkey_index = MCAST_INVALID_PKEY_INDEX;

The coverity warning is valid, ib_find_pkey() can return ENOMEM
(ib_find_pkey()->ib_query_pkey()->(device->query_pkey())->mlx5_ib_query_pkey()->mlx5_query_mad_ifc_pkey()/mlx5_query_hca_vport_pkey())

I'm not sure that the error handling proposed is enough, pkey_index is initialized to
MCAST_INVALID_PKEY_INDEX at the beginning of function and in case of error it preserves
its value.

Don't you need to update process_group_error() function? It has code
flows with ib_find_pkey() without checking return value, which can be
anything too.

Thanks

>
>  		spin_lock_irq(&group->port->lock);
>  		if (group->state == MCAST_BUSY &&
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYM++xAAoJEORje4g2clintCwQAKhMB1J0KXJ6kHIf/NJLlfZ3
jhqKRh6DoIj9pqyAZPbLs06HeMa53llOs+hGKpWb/Jzr9b40pNPHveW/+K1SiAAp
KwoUvAOFUDhXQNMnJ9MRYs7yMoWhi2zWOaJIXsuz9mQFNz+0QQ98yzRBDQ4Bg0kt
AcVq9qZdrR3isoQoRZshqgy7c/Oe1a0uwbnSiTdBr8NG/TSeLtAKfecJKhKmLo+0
tBZvBc12F64d0MCe2mVRBf4UTaUB6KQmeXrXO0e5P98vy8188GqxlNx95D+0ksCQ
sETOJRPP3RzfNnmhjcdMetOD+BDQXCXsoP7qmkvGTuwqm1Nkjw6YKcoN9rlgNzLh
+EPe944l7WY5Ut4ji/9WsuCKQ9ZleWAMzzjvhRM9KJByDcChmXSNzn3xON5W+eD5
FvjHXZJ+6mn9988nAFfngOZLdGp81fHLgoaKms7iNkaMc/6vvAUTXf8FulxaqhNe
M6fFE1Wc8W2UcTh7RNRHUZAsxC0W297ferC9WymYDs+88IfmPf2hvYFlMMBvWU5I
V9Yi0Hlp1vX0VYutPHxJMfb/X9Iz5AHXP2Yx9lUTYseSmdmmoq+J1ZsdDp0KQzjO
jLT0Qn/z53tlDIlcfU7kIjfg9wAbtRxAYad4hjqcgAcg1zndy0GVou8Qyh8wgLrm
QiiUu2INGLgR1B9Wgz+w
=cCr6
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
