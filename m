From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Add L2 MAC resolution for UD QPs
Date: Thu, 10 Aug 2017 09:18:12 +0300
Message-ID: <20170810061812.GP1423@mtr-leonro.local>
References: <1502345099-6534-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+2GlJm56SCtLHYlr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502345099-6534-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+2GlJm56SCtLHYlr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 11:04:59PM -0700, Adit Ranadive wrote:
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>
> Use a libibverbs function to resolve the destination MAC address
> for a non-default GID in UD QPs.
>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/vmw_pvrdma/verbs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>

Thanks, applied.

--+2GlJm56SCtLHYlr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmL+qQACgkQ5GN7iDZy
WKc07Q//Rk4IwchTgNwfUxXc8AwP6MrhOxiBUcERnTLIwAYuEix6QUjX8SfA8wWu
L1jg9fU3hgRcz3L5OOdVY3AUlCgC63LZ8lbdu3C+7Rw3J+Rtjb2NmnjkT7Vj5xsy
mLrigfYikDYfJ/XT5yR3453VjipJJL5YhXkfdvox8RYZAa9aH7YC07BNq3u5knDF
1Ec749zWxx00eLC1GVN5+u/sdJWFzoaw6ap3eE9QGR09NZ6HAO0a1WHuZsKzt5E1
WS54NBD+yedUiSm1hCWV+amLw4aNOZcfOevsjehbJZcrSrKEn4ziXSrlpqSr5pqb
/8abpOD6EzDUSvGg2za9t2ToXBZ9mwCzwXFTYH78xy4iW7oBrV6tg1RBor2zfxcH
cyadcdeo7KalPEdZ+l/Pu6bKd95K/W1g//Y7Oyr15XNwp/76oG4NUGGpB79x1wlT
TTzjfPVYJQYMiJt3Fxuo3vFSeC4vE4txBqSgeG7AXrZ+VtgFsLeZlDeRGt1dORiA
YIVkt2KpTtb5jR7JM3xYrn0Q2sAIACNPokrAJCLO+g6zi9Gq0U20eWHmT0Wu3oKa
8tF8Ecd/2xBSj2zMRgVys+ZhSbaLNNTesirY/EmoOCX7YZct0T7CIu7UWEYOhdXT
yL/0b3O+EQsPc6s6Z/t9r5t/JRrZxKIsPe1MnbMjg995A2fLPSQ=
=YuRL
-----END PGP SIGNATURE-----

--+2GlJm56SCtLHYlr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
