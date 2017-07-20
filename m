From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] usnic: do not ignore return value of
 __ethtool_get_link_ksettings
Date: Thu, 20 Jul 2017 11:48:04 +0300
Message-ID: <20170720084804.GY3259@mtr-leonro.local>
References: <20170713224625.6022-1-gvaradar@cisco.com>
 <20170713224625.6022-2-gvaradar@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qjSZefE6w0iW6XmQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713224625.6022-2-gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qjSZefE6w0iW6XmQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2017 at 03:46:25PM -0700, Govindarajulu Varadarajan wrote:
> Do not ignore the return value of the caller.
>
> Signed-off-by: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index 03002bac93e7..c0b82a990bc9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -327,13 +327,16 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  {
>  	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
>  	struct ethtool_link_ksettings cmd;
> +	int err = 0;

Please don't assign variable which will be overwritten immediately.
It has potential to hide the errors.

Thanks

>
>  	usnic_dbg("\n");
>
>  	mutex_lock(&us_ibdev->usdev_lock);
>  	rtnl_lock();
> -	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
> +	err = __ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
>  	rtnl_unlock();
> +	if (err)
> +		goto out;
>  	/* props being zeroed by the caller, avoid zeroing it here */
>
>  	props->lid = 0;
> @@ -364,9 +367,10 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  	/* Userspace will adjust for hdrs */
>  	props->max_msg_sz = us_ibdev->ufdev->mtu;
>  	props->max_vl_num = 1;
> +out:
>  	mutex_unlock(&us_ibdev->usdev_lock);
>
> -	return 0;
> +	return err;
>  }
>
>  int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
> --
> 2.13.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qjSZefE6w0iW6XmQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllwbkQACgkQ5GN7iDZy
WKfuFhAApZTXNFIgSChaeATh3plSJKq+5245KlIB2N33UDlJTk+EGkrSU4aVv4gv
jpK5r0dsTNghz53pCKY2XYvynQazOLrhBEPlhAXBz/lKi1CBV7uGsHI5p5fGhnD5
KM0hi4ScmZEm9JGz4miamanrsUWL3wrkvrZeH5FxNeHXne2obj9ZvfWylqibFigm
USpsEj/JMq/dumGMjShSWqn4cSt/TPlya7VwZyadwiqZ0W0mTfnXtlGMszJuGlfF
4kdf9QZFExpT6rr9LQe60p6WOS0VWKPmU88R2S3br9fsoMp2qS38b02pay6c/x+J
D5MvdFp0SVwgNwtn1jCF9bHxGmm7Z9UEIFSGMAXOr6hg5zK83CDyjoYU10WGE2V/
b5tveB6sK1oS0SoINkznXYgZ6lyxLenjVdbHn2JAcyPJHCNhxs8kjU8iA7NRGeZJ
YfFtMH+f3JctfEPT8D48pkajbBIYPeujD6QtFYQalA20/EyTAkP0+9js+/eVeJFN
mxznlKg+AtMV56Zz8tPZCpe/RBVxm9k6fN0q4F7OBZ9RLW4uhDXrXZJ5SRPx5k1H
/rkoYRRygtzvLLwDvV6vLE5GlvvRnLyQXHjmCjOY02lnqyteoeu/137mUwTNcpk4
1Mxa8NBPD0DpaZx3lOzPjc/hMx5pE8A60i4AZTjLHmCfAlagUgE=
=IKiI
-----END PGP SIGNATURE-----

--qjSZefE6w0iW6XmQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
