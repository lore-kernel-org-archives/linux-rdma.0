From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mthca: remove mthca_user.h
Date: Sun, 28 Jan 2018 16:49:57 +0200
Message-ID: <20180128144957.GZ1393@mtr-leonro.local>
References: <1517143183-24393-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m02j6EnzJ5dgRysN"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517143183-24393-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Cc: dledford@redhat.com, hal.rosenstock@gmail.com, sean.hefty@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--m02j6EnzJ5dgRysN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 28, 2018 at 12:39:43PM +0000, Corentin Labbe wrote:
> mthca_user.h is unused since commit 486f60954c71 ("IB/mthca: Move user vendor structures")
> Remove it from tree.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/infiniband/hw/mthca/mthca_user.h | 112 -------------------------------
>  1 file changed, 112 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/mthca/mthca_user.h
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--m02j6EnzJ5dgRysN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpt4xUACgkQ5GN7iDZy
WKeE8RAAvLrEn4H5LrUl7koGyNHSGkqABOshpFjkW50YDuno7jHcO+4mXKArfc1G
zFm3fslAj74xPkbxLuolqMORhzjtnw7AgOX+xlsgCiaA6UE6LXWaAx/kyHY9Y3bj
tE7SyOyuBzNjr0zeQvU9K1GKHHUNza/w3weQH4n0gV4KirbbhNEdl/nMIybTzokn
NOX1W9SM0OPsJc/LIgC5+/W9eqBrkMkyBLFOsXMUEnVIGQ84GE5N048EhyshXTIx
XI0FjBI2mzvABZ011Y4dWGfNc5yEYk+j1zUy5UMbiL0Qv5Btww3jT4wej2TBkn0+
ZmZsd0eDawRD0dbOWhrYuZWQHUlC4Ah6bZziI2kDCRVeKXP0CwKLN9rm2JehnQQC
U/MYyEasYMVCFj6jBRHLl1URpwLqvO8cYf9aFGi/YyUt19Q5DzZh36E2ruZK/OHD
j7o0DJhq1SGHTlFqWEYgbWGnjsF8cxLeZAi2FvBa8XaPIxAsABvIadmzJIlJGnOg
FXZM1CtN7UDNwY6j9ApPKUaXE+s2yeth719xB/YgMX3EXWeaaeiFfZLUyG+TTXWC
Z8XfCPI9o0HMbsJCc2zoFe0OjZ08JLFHaZjHCaNhcUKgvhKUj87CyuItNVjSRwbV
GGg9Xz/JxsUYmn+/JOIhkpOnnwJW428chIfHQwQjB0jPSLRtGVs=
=9NrI
-----END PGP SIGNATURE-----

--m02j6EnzJ5dgRysN--
