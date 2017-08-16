From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx4: use kvmalloc_array to allocate wrid
Date: Wed, 16 Aug 2017 17:01:54 +0300
Message-ID: <20170816140154.GQ24282@mtr-leonro.local>
References: <20170816133123.20497-1-dongyang.li@anu.edu.au>
 <20170816133123.20497-2-dongyang.li@anu.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S/OOmhz5UkAXnkSU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170816133123.20497-2-dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--S/OOmhz5UkAXnkSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 11:31:23PM +1000, Li Dongyang wrote:
> We could use kvmalloc_array instead of the
> kmalloc and __vmalloc combination.
> After this we don't need to include linux/vmalloc.h
>
> Signed-off-by: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c  | 15 ++++-----------
>  drivers/infiniband/hw/mlx4/srq.c | 13 ++++---------
>  2 files changed, 8 insertions(+), 20 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--S/OOmhz5UkAXnkSU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUUFIACgkQ5GN7iDZy
WKfs5Q/9FvWq4ttCy3W9hDoVnlBzYBWvY8n5rkP5uQMQE6lboBPUtnMU9cUEk70t
qhXIh57MhPIPAzMCXjyQDvYqWsxvGabwnO9nELSPSmR6Y029Is4y7biITpfOgsTl
631971q6iIfTanDFsq18UxQ9Nw4edUvVEkcfTyfZRr8Ft0mfpwllpr203bnoxpkd
bxUJBNJCV0m1wXPUZqOoTzp+fcWcMIAKADJ9WZEeM+gQ+ucC9E9f380pmE1JOLWJ
0MgW7rP+quMD0S83OBrPHDaGHbIK54FnBwtlco3EGWVJuK0sUntb6lmHCMKTUKTq
dZcPLdJfEJaFqLaqF5G8H9vDm2g7m1xZDY+FVRqSwG+HCuLAHjCE/zf9YTLmuhjY
wSl5LzyMJ7lN6uABQpPltLHkSO7Hr9Nti4SsfUqSIWreixMKKZzm2vY9AOovxwr5
ei//Txedg1L/4f1jRcONrZAsOvIwlKxPEEvDn8JMz3swvFlY639G2Qzkk9w4TSZM
dkWVFGwx+V2f96vpFP+AvICHoCdoT53bVpwKxAfZd0Q3FFmm2YaYDVEgq5G8Qr64
WSQdk1pGsRbI1T1bRkc/B+5pAZR1DoFcP3OTkulz9t3xTeCeAe11XswOWDgEzv+f
FIs40at+QDz5V+Yj4FtrufvJlChpBMQdIqUdpoIqZUxsu4pLQOo=
=Tm1W
-----END PGP SIGNATURE-----

--S/OOmhz5UkAXnkSU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
