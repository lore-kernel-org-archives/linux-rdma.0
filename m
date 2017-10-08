From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 26/47] IB/mlx5: Suppress gcc 7 fall-through complaints
Date: Sun, 8 Oct 2017 10:55:58 +0300
Message-ID: <20171008075558.GQ25829@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-27-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="U/5EjKfnYgGK6hcj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006213333.6721-27-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--U/5EjKfnYgGK6hcj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:33:12PM -0700, Bart Van Assche wrote:
> Avoid that gcc 7 reports the following warning when building with W=1:
>
> warning: this statement may fall through [-Wimplicit-fallthrough=]
>
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 2 ++
>  drivers/infiniband/hw/mlx5/qp.c | 1 +
>  2 files changed, 3 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--U/5EjKfnYgGK6hcj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnZ2g4ACgkQ5GN7iDZy
WKerfQ//QN5W5p0KpjChWNXKvDSCSS+ub/7cnuEZiRusspiKhqJ+AnQ0yW91Kn01
YxEQlP0fPS3jV2I3uOVDiHfOSq4vzc3QZKuKU6wcg21Yw5iP/qSH5ei7XL3yqeEi
ErGiN9AVkcYxZFcpvdHe6OOM+4rNAh5+dKlYqqXk+sct3isjCCPztCQ3E3S4h/pn
03S4dBlM7AGmT7BWybf6C3HPrFhu7agjwPw3s2ByPoFHh2tw3qybWvkIbe8z4kVq
7DMciXBLHIuJZ3krxmKzk9a2BqbiwIFGtrgUo7Wz7GENJ+dxiXRJUxVFA+z6DAj1
Je7lJXGXJtpZ+pQAIPny7m0PTYiNZGI1pojne2C+sFnizrCqjONaPHbWooCiQY45
1l8Tza+8Ih9XpLmS2Y+kZT2k57bwVYKCscF3oAFHf8iS50bxEn8TRL+P3be2p3bn
XXK1mkFRdja4CJqxFw3XXESFAjqaANntht7OVcmW5gX3SUpA0UqHL7Zmdmgh7OZP
6+D76tsZfFsH8gtVWr/ss8B27qp/j75/y4dquB1VtOn6IpjEcJ8IKWI47+y5DeHT
lBYDY6JKgh7jd2wYG+0izAmnCz6u5KCU3kEBk5jCuGB+5JKij7snYg3hXnm/VgLB
dUtFWiGBrVRi8XyJzpJiEqm8LIAz2FiqxpwtUSk30ccvj6NsXSo=
=6Op9
-----END PGP SIGNATURE-----

--U/5EjKfnYgGK6hcj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
