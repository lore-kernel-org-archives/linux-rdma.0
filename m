From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 15/15] RDMA/bnxt_re: Disable FMR by default
Date: Thu, 18 May 2017 07:24:56 +0300
Message-ID: <20170518042456.GU3616@mtr-leonro.local>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
 <1495012791-5053-16-git-send-email-selvin.xavier@broadcom.com>
 <be1696c2-f93f-5f5e-cbe8-968bf41903e7@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiQKDdln2jY//0TJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <be1696c2-f93f-5f5e-cbe8-968bf41903e7-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YiQKDdln2jY//0TJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 17, 2017 at 08:29:09AM -0400, Dennis Dalessandro wrote:
> On 5/17/2017 5:19 AM, Selvin Xavier wrote:
> > Adding a config mechanism to enable/disable FMR support.
> > There are some issues seen with FMR implementation during
> > stress traffic. So disabling it by default for now.
>
> If it doesn't work maybe just remove it rather than adding another Kconfig?

+10000

>
> -Denny
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--YiQKDdln2jY//0TJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkdIhgACgkQ5GN7iDZy
WKes+g/+PETUNGQfGpowgs7xqp7XDOmk+askrTBpdi/b++gzNWu+uxEW2HLhx4vD
MYD8UF//UGkui93bBp3p7yWl93M9okkZfW+0R6RN5e/4xu6rd4TeeJ3r+7KddL4N
kB3wdo73UCxeE5LpzknmpVnYavRLdJFxH6t9p88rBueg+PUtmmJOlQJDJJPPTxbO
dOVUx+1TArIKy/n/8MEXQUdTjqE+67NTo64v8KDzG/x9GeeC2VLm+bQzyOA9TwF8
YSTQk40wY12rn5LMaOPg1NSNMrpQTJTPAOOr5wOVairW6dGmWRuBWhIBY+j2kmyk
ddCyH65y/dnpaSZzFHIKfbR9tCH6EcAekfyPC+AdDBV4NyolgKZLp4LU3IOpj/zc
TI81S2VuAdfl7bzrObNSUMSLq0t0AgS4hqxN3F12oE4BqsQCtDck+HBrTxv+F9em
5fFJNCu3M0llyyhjYi/KtmSQyQLU0NqmZ+ZJwggUh1A3mSGtyy+BOelzyg2IIWjO
CmQ9FS1aXHtCQvVu66fSU1QuyCQizLztTY7dOc+h18cWHH4b1BNB/Uzsx6x7uBTF
cBzBEa5O63QNbDo7DMBgad0oyVvxzSbhnuIGd7U5EepVx+c4YjBE84CiUymodAvu
jnkMHyCOzxEZBY9KmlNWbaYOf5z4VtXZ8RIP/ARpJllCUctq6yg=
=EsAI
-----END PGP SIGNATURE-----

--YiQKDdln2jY//0TJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
