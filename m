From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Make room for source GIDs to be added
Date: Tue, 13 Jun 2017 09:03:25 +0300
Message-ID: <20170613060325.GF2576@mtr-leonro.local>
References: <20170613025451.31416-1-somnath.kotur@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170613025451.31416-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 13, 2017 at 08:24:51AM +0530, Somnath Kotur wrote:
> Currently sgid_index is of type 'u8' so we can't really go beyond 128
> unique GID entries(one for each type so total of 256 GID entries).
> Change it to u16 so atleast 4k GID entries (as many VLANs that can be added)
> can be accomodated.
>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 2 +-
>  include/rdma/ib_verbs.h         | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

What type of testing did this change get?
According to spec, "The maximum number (N) of unicast GIDs supported per endport is
implementation specific".

mlx5 and mlx4 are limited to 128 GIDs and user will get errors if he try to set
more than that.

>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 4792f52..3161e2c 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -549,7 +549,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
>  		flow_class = be32_to_cpu(grh->version_tclass_flow);
>  		rdma_ah_set_grh(ah_attr, &sgid,
>  				flow_class & 0xFFFFF,
> -				(u8)gid_index, hoplimit,
> +				(u16)gid_index, hoplimit,
>  				(flow_class >> 20) & 0xFF);
>
>  	}
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index ba8314e..30ce942 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -639,7 +639,7 @@ struct ib_event_handler {
>  struct ib_global_route {
>  	union ib_gid	dgid;
>  	u32		flow_label;
> -	u8		sgid_index;
> +	u16		sgid_index;
>  	u8		hop_limit;
>  	u8		traffic_class;
>  };
> @@ -3612,7 +3612,7 @@ static inline void rdma_ah_set_interface_id(struct rdma_ah_attr *attr,
>
>  static inline void rdma_ah_set_grh(struct rdma_ah_attr *attr,
>  				   union ib_gid *dgid, u32 flow_label,
> -				   u8 sgid_index, u8 hop_limit,
> +				   u16 sgid_index, u8 hop_limit,
>  				   u8 traffic_class)
>  {
>  	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/gC0ACgkQ5GN7iDZy
WKf4KRAAvbZoJKg6pxbPjlEkAEnbqDcxiC8Xyh+LUAtsD6Kytc62BAlUkDSLFxsQ
rc2NyZ/HeKc90qOik3dpl+kkv8krC1y7wxVppQTP+J58gzVmHSRLk/hhCLgRKzVA
eOVMs8Z2eZTqFIb0yMDAH3JepJDoe4E6YA5i5WEYcOpnaHvwCgawQSK2o4Zykych
JxZ8NzTuCy3A/APpbrl3UgX4UMXGSFWHC5RtI5p8z/IpFfSJjiyGZFXvtP/+Cirs
ijUGK2SYs6SZ21ozft4VeKpF9eqNAXQVpqdxnYkoNgUcWq1jKY2mymMryRrDq9kX
i4MlmMFKSGF8ajzmr+6+0kCJ5OnAjBhjyWaSINl2Sl2iB2RUW4Au9K7vtd7IY2fd
tf/AhZ9X2fte7JaJXQRkmhSxPsi+CIq8msAH99FHhcc/qGFXZNFOIlpO2PHl8s/p
GK2wKae+R8sZyZOSiz4er6dLoVPWIRwAuBNITYvtp4TCb8yLjA+DNK4hRUba6MUn
LP6PgdgRCJ589nIb9j6gVbzDaWJm8kbixlvRub17Wnve4vPW0QBZ+NqGyZBINfpT
hvg4YDF9xD7qMhUOWLpq1BFyGijCiB8epmqTtQ7MPv/s7BxdDMGj6LmuE283dhhy
ZONH1qPriorMzIAxWYgKuX8xv98YT0dMuvt2pdE/MUWC/sb7dpI=
=Vy79
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
