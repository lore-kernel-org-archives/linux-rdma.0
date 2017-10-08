From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Convert timers to use timer_setup()
Date: Sun, 8 Oct 2017 16:23:50 +0300
Message-ID: <20171008132350.GA25829@mtr-leonro.local>
References: <20171005004554.GA22669@beast>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2zf2tx9IpuxnXhG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171005004554.GA22669@beast>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "kernel-6AxghH7DbtA@public.gmane.org" <kernel-6AxghH7DbtA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--J2zf2tx9IpuxnXhG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 04, 2017 at 05:45:54PM -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> ---
> This requires commit 686fef928bba ("timer: Prepare to change timer
> callback argument type") in v4.14-rc3, but should be otherwise
> stand-alone.
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   | 6 ++++--
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +--
>  3 files changed, 6 insertions(+), 5 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--J2zf2tx9IpuxnXhG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaJuYACgkQ5GN7iDZy
WKc7+Q/+P1gGIWVf8edBa9oYLdT3mzJrxMz60GO//+Nr7a7QgEBMvJPQeT2xDv0t
BcOCsvogX5CkEyjiy5RKqktxEy5yC6za8ryAjXES0kC9b5QfITSrGOZiNGYNZrzV
vs0jRfPzDh7Dd92wQUcGD3M5kZlbK/DQS9+p+mpDHViOeeYjcssSBjdPVDsn3sXv
0YkcMfkaRKB2UH9iPwzm3Goy1+UYrIkiaLXJmUomVqoAM1yZSMtFfxockVVD69Xy
v2xl462X9wX6+CYL7/EGCSKJ2v2xbTo64DP6bKD8g15ymWO7hCGIYjaqw9GtD8Oi
7ggQ26cs5C/IH4U6s5fH8VshQbvd1ghs8dlmKwPDSZ0NqqWBz0F4tOgbemontNES
p9pzW+q0s13jtuGVYm/kCR4Gb/PsA2gz54RW9y4gHHhzppaEQKZtet/5fgOGB4Wv
lb+UzqENeQq8KdBJoNfGuWbmVoaqWJnt0U58NifAPEYOdk4fV46MWiTUnG1dyIQp
8HFVm7bnanpubQppXgNNraPZXkD08RJ9VkDOyN5OGqY0S6T/tSEtByt9HcqpxYyj
zJFdNUF7NU50CTu+75a5N4y6TldPxdLuF/8Dv6LSrDpKhflp1FEWZwsJi0q2n9hM
RbvIAd5HPhmCSwX6+wTMwA1SKvM9zrlL8A0wCW4ocBVm0dsmAFk=
=D9Wn
-----END PGP SIGNATURE-----

--J2zf2tx9IpuxnXhG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
