From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Block PKEY creation using ip link
Date: Thu, 26 Oct 2017 13:06:34 +0300
Message-ID: <20171026100634.GG16127@mtr-leonro.local>
References: <DB5PR05MB16704ACD20AE16C44B838486B4450@DB5PR05MB1670.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WTO+dqXoBrlfXqg9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB16704ACD20AE16C44B838486B4450-8IvNv+8VlcDlcZmNi56Wl9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WTO+dqXoBrlfXqg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2017 at 09:47:44AM +0000, Denis Drozdov wrote:
> Temporary commit that blocks pkey creation using
> ip link. Example:
>
> ip link add link ib2 name ib2.1 type ipoib
>         RTNETLINK answers: Operation not supported
>
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 3 +++
>  1 file changed, 3 insertions(+)

NAK,
It is completely wrong and this bug relevant for mlx5 enhanced IPoIB devices,
but you are disabling all IPoIB capable devices.

Thanks

>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
> index dd1f256..b507a6e 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
> @@ -101,6 +101,9 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
>         u16 child_pkey;
>         int err;
>
> +       /* TODO This change should be removed after adding netlink support */
> +       return -EOPNOTSUPP;
> +
>         if (!tb[IFLA_LINK])
>                 return -EINVAL;
>
> --
> 1.8.3.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WTO+dqXoBrlfXqg9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnxs6oACgkQ5GN7iDZy
WKdZFw//YQsGYzVhqXT9IJowhdgkE1oJFlswvhc0qUq92ri1kTqFG/kwCovwDJAP
TyqwkYEObOhKHfDCedMsGk7zSCfbGqwrZEoVvv8gw9TWDgvUI2DS5mULw1fc4pXj
jweOq7abM0itTDZXs0urMkky9RIxOsSXNx+wBWfZjmNg0KBuHzxbmDRmcuvrRgDt
ThtGvQseqXckLLje3AAinopfdq6+m3u+D5mZ4KTI0sluycX+kyKXF0O+Ic9cpIGF
vS6NeMlgAhPyOtTFIA2bcodGNoiu1JhsnyDSqtIoWfnvD9JbKY/dekB4F+Bidlou
SvrzrQiXFaT9qZFhYPb5OSl+/TUXB6GbsQCroVZynU6B/Og7cN9yfrgvC4iELUQK
mOgGg6wK6ug9YH239mFfaFVSxP9K509F7oazTnsZfkIqUQCjp6EwMOHn3maDS9eZ
wNEZFXHlcjJw/Ekcms5JljE0E47oGYTxrpn3wVsmsy772Jj3RcYd0SMlYkNtxUdP
kANdXZr6F+ggqV6oMHgY5k4zFDrR0/JMwcE9In5JiO5EzyK5AP9d3R5mRZbMS9xS
eIq89whqJpc+EeDtxk5AKwnH83Q2S8j94CnwHyxal6J+wh2xfqQ5P5as7nUpfiYb
euRFpsB1Up2cRd8m2BKnswNkqjgLrd1MnFaIwWuce+Gt2f923zQ=
=ktss
-----END PGP SIGNATURE-----

--WTO+dqXoBrlfXqg9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
