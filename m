From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Sun, 11 Dec 2016 11:23:26 +0200
Message-ID: <20161211092326.GA4479@mtr-leonro.local>
References: <20161209092044.GA4640@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161209092044.GA4640-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 09, 2016 at 12:20:44PM +0300, Dan Carpenter wrote:
> Hello Sagi Grimberg,
>
> The patch e6631814fb3a: "IB/mlx5: Support IB_WR_REG_SIG_MR" from Feb
> 23, 2014, leads to the following static checker warning:
>
> 	net/rds/ib_recv.c:672 rds_ib_send_ack()
> 	warn: 'ret' can be either negative or positive
>
> drivers/infiniband/hw/mlx5/qp.c
>   3614  static int set_psv_wr(struct ib_sig_domain *domain,
>   3615                        u32 psv_idx, void **seg, int *size)
>   3616  {
>   3617          struct mlx5_seg_set_psv *psv_seg = *seg;
>   3618
>   3619          memset(psv_seg, 0, sizeof(*psv_seg));
>   3620          psv_seg->psv_num = cpu_to_be32(psv_idx);
>   3621          switch (domain->sig_type) {
>   3622          case IB_SIG_TYPE_NONE:
>   3623                  break;
>   3624          case IB_SIG_TYPE_T10_DIF:
>   3625                  psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
>   3626                                                       domain->sig.dif.app_tag);
>   3627                  psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
>   3628                  break;
>   3629          default:
>   3630                  pr_err("Bad signature type given.\n");
>   3631                  return 1;
>
> Why do we return 1 here instead of a negative error code?

Yes, probably better to return something like EINVAL, instead of 1.
do you want us to handle it?

Thanks

>
>   3632          }
>   3633
>   3634          *seg += sizeof(*psv_seg);
>   3635          *size += sizeof(*psv_seg) / 16;
>   3636
>   3637          return 0;
>   3638  }
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhNGwMACgkQ5GN7iDZy
WKfuYw//ZEHR1w5sFnxKL6onEzzVyTFBQl/g4GX7ny7HcnQpW0FOd3T+yX+jZIvL
P8Xl+1H0KZS5GD5OjumwZUNU32XSt+8w88G3ULwp+am2ykrQ/enT8d+w3TY+UFP1
bqiZgA0GDi7Z/kdkHot4ZqvdjpOjfdlXowt0dE4HDpGJ8RaENd1wFQRNAGsGUM/6
t5KzlO2csbbyo/7FPhpcrEGTAhHdeSnpyh9IUZ8OVzpL7oTYiKMvJsO6U/sckTJ+
eDV2nZxQRxyMNfC+L0k3rDds/XlmPbP1zFlbwhbf8FUPNUPBZqFwSDjtPjbGZduf
stBeFzwzrXecbhY7CWdNrDIix5kqlH3sU60tsC98fkt8jjiJt864s0cJLzkNgVPY
qIzKJJrNopjBd4OW/+1r8ChYoobsZJDvngW9VlhXx9F4ipZGQQDhPdCuwWTYXwD7
1vEIB0/ymJ+8MSbpWBh+ODXZGXNSPYbUIEyN4GLvn5e1md1QxpOpeJp1bhY4zuj4
d89S7Q2c8EBJCE8g9VnCHDxPb62ZspQtkNYDqVDSPRHbp971MRtNb54FiQrMan4b
p8famUfKHE6A3bdTQoyNfd1jGRQUJJm9w0vRtj0IP/jdZNCfIh6UvyoZLZoAs/gd
Mq9RXNOsR1H5Vx2JAlJZAYMcOJaz2oFfCMu9PsH6+AJ0NMQfrUw=
=8GD5
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
