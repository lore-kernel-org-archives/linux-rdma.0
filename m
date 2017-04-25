From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Tue, 25 Apr 2017 21:06:30 +0300
Message-ID: <20170425180630.GU14088@mtr-leonro.local>
References: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
 <97bb90ec-4337-62f7-f08d-a673975a5637@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lh55S0yADJsuIVGW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <97bb90ec-4337-62f7-f08d-a673975a5637-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--lh55S0yADJsuIVGW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 20, 2017 at 07:21:29PM +0300, Sagi Grimberg wrote:
>
> > [1]
> > [ 5968.515237] DMAR: DRHD: handling fault status reg 2
> > [ 5968.519449] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
> > [ 5968.519450] 00000000 00000000 00000000 00000000
> > [ 5968.519451] 00000000 00000000 00000000 00000000
> > [ 5968.519451] 00000000 00000000 00000000 00000000
> > [ 5968.519452] 00000000 02005104 00000316 a71710e3
>
> Max, Can you decode this for us?

I'm not Max and maybe he will shed more light on it. I didn't find such
error in our documentation.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--lh55S0yADJsuIVGW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj/kCUACgkQ5GN7iDZy
WKfNQg//Z3nif5LDfcHmwgXSLv3qMriuGeZ3mV329vIf36kHdgsSdZGf/z2N5wXO
F1S6Rw06hgJ7G42M1wAH985XcKIY67kBlZpDw7MdObXyA5qHKRN99YH/C7Q42L96
PxqOltY8sZfouOmjBZ7P7prAnuBmYCsvDswjRqcx7Avcbb+yfxUpBAw+lylSqB+g
FP8o+LK+dUwFghNzJcZ2CWmfr/HilMucNO4e1kUwuXgY2CGjnjTUrFET/edHAfUa
oJfIdc7oR4Gcx5xXMgY466L8BJPQV5q0hCEzBKieuboRz9wvnaiprY1kXNZoiUO1
YNRXIFDvvYcvHjb0VFxE+CwJ65W0p53uJds41QO2N4XDpx5suVTRkKC2tEFBR4hY
mgf9UF9a2r3PW7D8qwulVE91cyFnw53xMKqT3ci8m4gEpRCER5fuOR9pR7Yej2B+
sMfJ155BH+bAHCJ2/N0qgeidOWS/soQ3IsbnVa9gpAx5rJHJ47qKRyTaj6sOap44
zflAGsnvsNBz/tygZWFdYHYT54NKL/Bh19rT2AkYvGY4BxgsiSkStsE/yfCbllIk
1YDxqpbyFKSWmPYTbQ+RSvZgJ8QZMw1vqmBLglxL6oWTAPvnfDJNRvQ/xk6WU3bC
rpGq5OPYMQJmVB/OXZu6x8dXaLD9M6XFW/RjpDX35+B5U5Y5B8U=
=TqcV
-----END PGP SIGNATURE-----

--lh55S0yADJsuIVGW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
