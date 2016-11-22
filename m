From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] IPoIB: Avoid reading an uninitialized member variable
Date: Tue, 22 Nov 2016 09:15:00 +0200
Message-ID: <20161122071500.GE23083@leon.nu>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
 <fd4a2913-545e-bf2f-e352-a47fd50a954f@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hcut4fGOf7Kh6EdG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fd4a2913-545e-bf2f-e352-a47fd50a954f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2016 at 10:21:41AM -0800, Bart Van Assche wrote:
> This patch avoids that Coverity reports the following:
>
>     Using uninitialized value port_attr.state when calling printk
>
> Fixes: commit 94232d9ce817 ("IPoIB: Start multicast join process only on active ports")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Except that it doesn't print the reason why ib_query_port failed,
it look good.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 1909dd2..fddff40 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -575,8 +575,11 @@ void ipoib_mcast_join_task(struct work_struct *work)
>  	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
>  		return;
>
> -	if (ib_query_port(priv->ca, priv->port, &port_attr) ||
> -	    port_attr.state != IB_PORT_ACTIVE) {
> +	if (ib_query_port(priv->ca, priv->port, &port_attr)) {
> +		ipoib_dbg(priv, "ib_query_port() failed\n");
> +		return;
> +	}
> +	if (port_attr.state != IB_PORT_ACTIVE) {
>  		ipoib_dbg(priv, "port state is not ACTIVE (state = %d) suspending join task\n",
>  			  port_attr.state);
>  		return;
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hcut4fGOf7Kh6EdG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYM/B0AAoJEORje4g2clinm34P/AmUlm0GQxmnDwNbo2vt5qem
F8tu2f6WWD5UAFEAM7dXNuLkD+HDmJ9nlPoY8/0DXESKzLBfGJ3Y0NOt1f6439ql
Cubg4iG7qB/lXI0VL0eSvt7jT4mySWwKih2sXrza0AUQ/SL+E6TGy54bSbA1Oyuq
GsVfsCSMlWixKvCFisARWI1K9GxLDI5mCSYT1fpYrJiOS8v19s5GTKjbKS+/XlOE
+LBGdsRc9L2iAYyEgRtQGRMr2AZuyW3zKknzGJhzZA/L4xP3PleJpoVlsoglOFvq
QlecKWngFipKP1dlDaWDC71FGIC2BxkFKBViqyUaKnerWr2/2aEZO/sZQtsGdBkk
1zxdwiSUqnTYXZmibFx//b95h5e+QWKmY5WNK78XZLQv3HDR7QgwcdNhb8qUqJbN
bRzOrXrZBGVUAW0oBViaTNYaf0iou/Orn5nh1C2ipiC7Qv+bB6uXVFc9AZ5j+hk5
qLIN3/BhJUXD3RiwxV4YNIdk2XQIaRQ20husOLoCv7w761OnYeOZOvAbsdJJPkp0
s6S2qLVvsRVoKDyP1katdXjsf4rt7l3jpuvVObhlYYZaRUQXV2kY/xfjn/TCXdX4
ImUIWfEq3uWFU9Up7daa5i2l37iGdxHg+pKbAJtCGYX3hf66hvQ+L0TuK8BytHvQ
gshBnhOePxefwTsnSU66
=P5qk
-----END PGP SIGNATURE-----

--hcut4fGOf7Kh6EdG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
