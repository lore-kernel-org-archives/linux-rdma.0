From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] IB/usnic: Implement get_netdev hook
Date: Tue, 13 Jun 2017 10:25:26 +0300
Message-ID: <20170613072526.GM2576@mtr-leonro.local>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-2-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mZBmBd1ZkdwT1ny"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170611054450.7221-2-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5mZBmBd1ZkdwT1ny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 11, 2017 at 08:44:49AM +0300, Yuval Shaia wrote:
> usnic's get_netdev hook for struct ib_device is missing - add it.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Per Moni Shoua's suggestion - create seperate patch for this purpose.
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |  1 +
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 10 ++++++++++
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  1 +
>  3 files changed, 12 insertions(+)
>
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> index c0c1e8b..80577b9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -409,6 +409,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
>  	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
>  	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
>  	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
> +	us_ibdev->ib_dev.get_netdev = usnic_get_netdev;
>  	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
>  	us_ibdev->ib_dev.alloc_pd = usnic_ib_alloc_pd;
>  	us_ibdev->ib_dev.dealloc_pd = usnic_ib_dealloc_pd;
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index 4996984..f9dc1e80 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -424,6 +424,16 @@ int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
>  	return 0;
>  }
>
> +struct net_device *usnic_get_netdev(struct ib_device *device, u8 port_num)
> +{
> +	struct usnic_ib_dev *us_ibdev = to_usdev(device);
> +
> +	if (us_ibdev->netdev)
> +		dev_hold(us_ibdev->netdev);

Who will release this reference?

Thanks

> +
> +	return us_ibdev->netdev;
> +}
> +
>  int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
>  				u16 *pkey)
>  {
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> index 172e43b..1fda944 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> @@ -48,6 +48,7 @@ int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
>  				struct ib_qp_init_attr *qp_init_attr);
>  int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
>  				union ib_gid *gid);
> +struct net_device *usnic_get_netdev(struct ib_device *device, u8 port_num);
>  int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
>  				u16 *pkey);
>  struct ib_pd *usnic_ib_alloc_pd(struct ib_device *ibdev,
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--5mZBmBd1ZkdwT1ny
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/k2YACgkQ5GN7iDZy
WKeV4xAA0h7l6yY8Rp8B8UW87qFFSFp8pXQatxX+o7IkNLFkDF/vnTlj/deGsE7y
NqTH5VUH/e+9G3daVjpCoIsJdBKXbdZer4Uqsa/i0r7wJjvW1+/pl7A16/w35cL/
loFU2HKBIQN6MSHfv356nixiGIg02wzeuiK4HmtQvDBfgtMowu7Dyavsmty/kQO2
w0zmyPGIuQjV5ce4Xyotc/iofsPaaGVJWZ3I/i34lr6Wb0TaXAepw0UODMNa/4wB
YTl74dy3Q5osj61KEoJf4nuXbeyR0/cGfVbzjqRkjLBGlfY2aGTgaXG3Ua37/3yR
6ps/yGA/dcUEnc9QkbfFwQVJqoxD7WXpUHYB14XodKJRGXv6OXqoYQanzPMImmPG
2OlCSKxzd+l2d1WCnRyc8OnwOb247yCeF5B7qiw+HWZ2J3CtHFN8i2wzfx/4Snnk
+/nQpiaEer+jk1Ycg8glEMjvlJq6hEs9vT7FhUqMIaEbaRcRwe8GOdQBn59+MeSd
hZqEC6DQ86oP/L+BTfBN2rYD5idvu1mCnv9LR7xmkXjXHi0Uj59iqijxsf5L6O1C
5fmybXR14R9tQ7hkCxA7jp3Y7GlDxUPvVpsoUYD5Onxi+KEs1SgbhJsuhSVScjY4
jPModmFJj0kh3Viec/CHTNPD7YZamS4pdh7toFhKGxftenLeixU=
=xt69
-----END PGP SIGNATURE-----

--5mZBmBd1ZkdwT1ny--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
