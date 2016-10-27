From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 00/10] infiniband: Remove semaphores
Date: Thu, 27 Oct 2016 10:13:29 +0300
Message-ID: <20161027071329.GC3617@leon.nu>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477551554-30349-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2016 at 12:29:04PM +0530, Binoy Jayan wrote:
> Hi,
>
> These are a set of patches [v4] which removes semaphores from infiniband.
> These are part of a bigger effort to eliminate all semaphores from the
> linux kernel.
>
> v3 -> v4:
>
> IB/mlx5: Added patch - Replace semaphore umr_common:sem with wait_event
> IB/mlx5: Fixed a bug pointed out by Leon Romanovsky

Please keep full changelog for your next submissions/respins.

Thanks

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEakZAAoJEORje4g2clinDQEP/AyhsvbH/mAQVJQbKgjzBkXV
vMNcFeDjin2jpbLFLmdnqWiiotKcZ2+T5peclIndhV4m2H6Bu6Q9HDX9qQrZMbFW
S/36+EbQmNbg8grsL8YzgbertCmZ5u+v1MzPsbhayJxEjti5wos0fnD/3kClqPWX
BZ3dVQiVNVdskdfSJX1wi9YUuFUU48pRgQvS2M5jNI/uLWHI7/TJ7esM7W87mABE
QefT/P3mrPBktIizivRKerc7UNjjsJwCz7683Id+zBQHkkR5mwYxCZ+yg41ic5tK
6K8iHuVlau2PkFRdVD4eTWFGuiq3XggWQNL2lu+jQigMEJSKudSDGakhX0zLgail
4QRQzYUVWTqJRwJTADC0cBMUiw7jEQBydaaePj1ftM0ZnNwWiZhow2D0DYxXTWnb
ajnegcvGQZsaUiBE3P2cYiNMQKlauBneW0Qv9l4zuYjbpLfUZ6k0tA4EQwY8obvU
O9E/P+CrmQdQ5rniCsvA0Q9ApJe/w+DPd602ngJfHuLejohhYL+Un+R/PYCpw3a8
vZ2z1lRKCOFmQPYLMCcmUk1MEqeH5s8Y2OUI/Qt3naoU5TDMphCah2IXtrnxiACS
nfauqV5mrCacvmd/764HgOOLunvrteD4zMRpWEop7BLfX9+EwPtbhvTQcFlcZ4os
2e9fmKxq2k460+aQLuWT
=hCdA
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
