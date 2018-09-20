From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx4: Remove unnecessary parentheses
Date: Thu, 20 Sep 2018 08:03:50 +0300
Message-ID: <20180920050350.GE3519@mtr-leonro.mtl.com>
References: <20180920033229.15102-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920033229.15102-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 19, 2018 at 08:32:29PM -0700, Nathan Chancellor wrote:
> Clang warns when more than one set of parentheses are used in single
> conditional statements.
>
> drivers/infiniband/hw/mlx4/mcg.c:676:16: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>                         if ((method == IB_MGMT_METHOD_GET_RESP)) {
>                              ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/infiniband/hw/mlx4/mcg.c:676:16: note: remove extraneous
> parentheses around the comparison to silence this warning
>                         if ((method == IB_MGMT_METHOD_GET_RESP)) {
>                             ~       ^                         ~
> drivers/infiniband/hw/mlx4/mcg.c:676:16: note: use '=' to turn this
> equality comparison into an assignment
>                         if ((method == IB_MGMT_METHOD_GET_RESP)) {
>                                     ^~
>                                     =
>
> Remove the unnecessary parentheses to silence this warning.
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/infiniband/hw/mlx4/mcg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJboyo2AAoJEORje4g2clincQcQAMWuB2aiHb6PR7iy05Iz6o2F
mtp9JQVFHHuQSfgV1oLHLQWAklD8QjFBhOM+T1dAF5dMdeYMK0EMWocn6uSYSMJF
vUpzYe7qV7ImLrBhTI2zUGMbZRyDOpLnReT4fFZ32by74ABYJvUd3LjId+GclEdC
h2sQfi1DsqMM5U/IoQ/aDL9k+cB9DasJegsaEEXcPg8x1SaYwvHX5zN7CzqgGXxJ
Lx06c5A2/xJR3MWFs8Bts49f5zZV82+jw+JjU+4gsd93awvxw1KnY7LUG8ydf901
pCKfxGbf7cNxm9XTUk4KFjRYm7o1s4O7zQl+Ii3WtP/oJSAdISHk1CeihT0tDAnO
XXfaQ2IY9HmMWeKJq19mPz9KVXgI4htXzCDED86VoaNRlanXVZVYV2XVFEKX0UnB
xp9DsPHK93N+nnXUnh7a1gM6kfCk5GYi1rBFjJ415+1ppzCWIu2sabaV1Nc2WavS
nUFJSq2voi7i6Yj8BlqVnpUMS+HLIB3KaqiCBcecilNuOxn2oVpmeutZCRGhAGUn
DKmp6trJrmvhAKd1kWA1lAHJ5mpyv8UIS/QZaRuZRMoxZjY5zfT7t7XmsMiLJQ1U
FgBZIBTr49ntNanyhzhg+XesIajVTSzKdCyXmgKJpiawzkJbIgH7z1CPiyiB2tWh
KpSojCk+qHeyv61j7fLY
=8ZPj
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
