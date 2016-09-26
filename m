From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] utils: Create utils directory to put all
 common code and move min/max into it
Date: Mon, 26 Sep 2016 10:05:20 +0300
Message-ID: <20160926070520.GJ4088@leon.nu>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WI+ghjzd0JGVd6h/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474786207-2149-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WI+ghjzd0JGVd6h/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 25, 2016 at 09:50:04AM +0300, Leon Romanovsky wrote:
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  CMakeLists.txt                    |  6 ++++++
>  ibacm/linux/osd.h                 |  5 ++---
>  libibverbs/examples/rc_pingpong.c |  8 +------
>  libmlx5/src/mlx5.h                | 16 ++------------
>  librdmacm/src/cma.h               |  5 ++---
>  utils/math.h                      | 44 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 57 insertions(+), 27 deletions(-)
>  create mode 100644 utils/math.h
>
>
> +#include "../../utils/math.h"

Jason,
Can you give me a suggestion where and how should I use include_directories
command to be able to write "#include <utils/math.h>"?

Thanks

--WI+ghjzd0JGVd6h/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX6MiwAAoJEORje4g2clin5wgQAMU+x5ifyPV1kgGpvZ8lB6sE
7Krij/RJ6wX2uHhnv2jMRv7CM3CNGSk95OUNYnUwN46nk+hEhTIwkVi2yHNmB7yt
rW6lzqrYlnxVfzpv9LNJr+K2yTrMQyzZEKc5iiOVVav+79LGnHWjYg+V7StlenH7
a6z8BW8xPe/L/DESA/VSWA1d2s3AQYDhC6rzF3IKj0vZr9hmR4/SCDB2RaP91u42
/ivzf8qc1m8CcjiwnoDtpQxek8CFnmRjiE+k6e3wl3iqO7XVcwtbN1qRvWmQLBRV
y6jOYXnQqAzDaVnQ+ai4pw6at1RaHkShaIrBvuUqCW5SZWtmUBYjQL2xU0Y4uF48
bDsIExdTkLmYy39/rc/I642f+Oy2FpAD6Pryh3nkrVgg+AqOo14DKBGKzfpD2EY2
hPU2J9D3N949KLYgef+OC6cLcduTZfl8xtRPJ/JlJ6Fval3+6v0TLEaFWhJ41i2n
BKUyYtvtXYWczNjqH2kR9lG1OtIJAwc9u88geFo9rGJenamIVgQdDv6bQ6UFSwXm
wGYsVw9wyqe896g3TOFqSmeJj1zH2NGX9WH+MeXuTa92xOIIlgF5Qucfi3/3aODs
rP+Epc7jxT3UcR5Z5KJuMPWF8QwtrrKaDgJK/6rulnxsc5+MfTZEJXAw44QK6TdR
+uRVy8aYA5481q7ggtyO
=yD9u
-----END PGP SIGNATURE-----

--WI+ghjzd0JGVd6h/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
